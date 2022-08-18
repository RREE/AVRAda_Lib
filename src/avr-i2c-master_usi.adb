---------------------------------------------------------------------------
-- Copyright (C) 2013  Tero Koskinen <tero.koskinen@iki.fi>              --
--                                                                       --
-- The AVR-Ada Library is free software;  you can redistribute it and/or --
-- modify it under terms of the  GNU General Public License as published --
-- by  the  Free Software  Foundation;  either  version 2, or  (at  your --
-- option) any later version.  The AVR-Ada Library is distributed in the --
-- hope that it will be useful, but  WITHOUT ANY WARRANTY;  without even --
-- the  implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR --
-- PURPOSE. See the GNU General Public License for more details.         --
--                                                                       --
-- As a special exception, if other files instantiate generics from this --
-- unit,  or  you  link  this  unit  with  other  files  to  produce  an --
-- executable   this  unit  does  not  by  itself  cause  the  resulting --
-- executable to  be  covered by the  GNU General  Public License.  This --
-- exception does  not  however  invalidate  any  other reasons why  the --
-- executable file might be covered by the GNU Public License.           --
---------------------------------------------------------------------------
--
-- I2C package implementation for masters using USI support in the AVR
-- chips.  This implementation is mainly based on Tero Koskinen's
-- AVR.USI_TWI package.
--

with Interfaces;                   use Interfaces;
with AVR;                          use AVR;
with AVR.Config;                   use AVR.Config;
with AVR.Wait;
with AVR.MCU;

package body AVR.I2C.Master is


   --  wiring info
   --  #if MCU = "attiny85" then
   PIN_USI_SDA   : constant Bit_Number := 0;
   PIN_USI_SCL   : constant Bit_Number := 2;

   -- attiny2313/attiny4313, other attiny mcus not supported/tested
   --  #else
   --     PIN_USI_SDA   : constant Bit_Number := 5;
   --     PIN_USI_SCL   : constant Bit_Number := 7;
   --  #end if;

   -- PORT_USI      : UNSIGNED_8   renames MCU.PORTB;
   -- PIN_USI       : Unsigned_8   renames MCU.PINB;
   DDR_USI_Bits  : Bits_In_Byte renames MCU.DDRB_Bits;
   PORT_USI_Bits : Bits_In_Byte renames MCU.PORTB_Bits;
   PIN_USI_Bits  : Bits_In_Byte renames MCU.PINB_Bits;
   PORT_USI_SDA  : Boolean      renames MCU.PORTB_Bits(PIN_USI_SDA);
   PORT_USI_SCL  : Boolean      renames MCU.PORTB_Bits(PIN_USI_SCL);


   type Write_Nr_Bits is (S8, S1);

   USISR_8Bit : constant Unsigned_8 :=
     MCU.USISIF_Mask or
     MCU.USIOIF_Mask or
     MCU.USIPF_Mask or
     MCU.USIDC_Mask;
   USISR_1Bit : constant Unsigned_8 :=
     MCU.USISIF_Mask or
     MCU.USIOIF_Mask or
     MCU.USIPF_Mask or
     MCU.USIDC_Mask or
     16#0E#;


   procedure T2_Wait is new AVR.Wait.Generic_Wait_USecs
     (Crystal_Hertz => Clock_Frequency,
      Micro_Seconds => 5);
   procedure T4_Wait is new AVR.Wait.Generic_Wait_USecs
     (Crystal_Hertz => AVR.Config.Clock_Frequency,
      Micro_Seconds => 4);


   TW_READ  : constant := 1;
   TW_WRITE : constant := 0;

   Error_State : Error_T;


   procedure Init is
      use AVR.MCU;
   begin
      DDR_USI_Bits (PIN_USI_SDA) := DD_Output; -- True;
      DDR_USI_Bits (PIN_USI_SCL) := DD_Output; -- True;

      PORT_USI_SDA := True;
      PORT_USI_SCL := True;

      USIDR := 16#FF#;
      USICR := -- USISIE := False, USIOIE := False -- disable Interrupts
        USIWM1_Mask or                      -- Two-wire mode for USI
        USICS1_Mask or
        USICLK_Mask;
      USISR :=
        USISIF_Mask or
        USIOIF_Mask or
        USIPF_Mask or
        USIDC_Mask;

      Error_State := OK;
   end Init;


   function Write_Byte (D : Unsigned_8) return Unsigned_8 is
      use AVR.MCU;

      Temp : Unsigned_8 := D;
   begin
      USISR := Temp;

      Temp := USIWM1_Mask or USICS1_Mask or USICLK_Mask or USITC_Mask;

      loop
         T2_Wait; -- T2_TWI
         USICR := Temp;
         loop
            exit when PIN_USI_Bits (PIN_USI_SCL);
         end loop;
         T4_Wait; -- T4_TWI
         USICR := Temp;

         exit when USISR_Bits (USIOIF_Bit);
      end loop;

      T2_Wait; -- T2_TWI
      Temp := USIDR;
      USIDR := 16#FF#;
      DDR_USI_Bits (PIN_USI_SDA) := True;

      return Temp;
   end Write_Byte;


   procedure Start_Condition is
      use AVR.MCU;
   begin
      -- Release SCL
      PORT_USI_SCL := True;
      loop
         exit when PORT_USI_SCL;
      end loop;

      T2_Wait; -- T2 in standard mode, T4 in fast mode

      -- Generate start condition
      PORT_USI_SDA := False;
      T4_Wait; -- T4_TWI
      PORT_USI_SCL := False;
      PORT_USI_SDA := True;  -- Release SDA

      if not USISR_Bits (USISIF_Bit) then
         Error_State := MISSING_START_CON;
      end if;

   end Start_Condition;


   procedure Send_Stop is
      use AVR.MCU;
   begin
      PORT_USI_SDA := False;
      PORT_USI_SCL := True;

      loop
         exit when PIN_USI_Bits (PIN_USI_SCL);
      end loop;

      T4_Wait; -- >4.7us
      PORT_USI_SDA := True;
      T2_Wait; -- >4.0us
   end Send_Stop;


   --  sending data to a slave consists of three steps
   --     1) provide the target address (Talk_To)
   --     2) queue the data to be sent (Put)
   --     3) actually send the data and terminate the session by a stop
   --        sequence (Send)

   --  The stop sequence is
   --     - either a real stop releasing the bus (Action=Stop).
   --       Potentially another master might take over the bus.
   --     - or the master continuous to control the bus
   --       (Action=Restart) allowing further send or receive messages.

   --  Design considerations: although the unconstrained array in Ada
   --  is quite elegant at the source code level, it generates a lot
   --  of assembler instructions for AVR.  We therefore also provide
   --  non overloaded functions with constrained arrays.  In a typical
   --  application with only one or very few clients on the bus you
   --  probably use only one of the constrained functions.  All other
   --  code is automatically removed during linking.


   procedure Talk_To (To: I2C_Address)
   is
      use AVR.MCU;

      R : Unsigned_8;

      Addr : constant Unsigned_8 := TW_WRITE or (Unsigned_8(To) * 2);
   begin
      Error_State := OK;

      Start_Condition;

      -- Send address first
      PORT_USI_SCL := False;
      USIDR := Addr;
      R := Write_Byte (USISR_8Bit);
      -- Ignore return value R

      -- Enable SDA as input
      DDR_USI_Bits (PIN_USI_SDA) := DD_Input; -- False;
      R := Write_Byte (USISR_1Bit);
      if (R and 1) = 1 then
         Error_State := NO_ACK_ON_ADDRESS;
         return;
      end if;
   end Talk_To;


   procedure Talk_To (To     : I2C_Address;
                      Data   : Data_Buffer;
                      Action : End_Of_Transmission := Stop)
   is
   begin
      Talk_To (To);      if Error_State /= OK then return; end if;
      Put (Data);        if Error_State /= OK then return; end if;
      Send (Action);
   end Talk_To;


   procedure Talk_To (To     : I2C_Address;
                      Data   : Unsigned_8;
                      Action : End_Of_Transmission := Stop)
   is
   begin
      Talk_To (To);      if Error_State /= OK then return; end if;
      Put (Data);        if Error_State /= OK then return; end if;
      Send (Action);
   end Talk_To;


   procedure Talk_To2 (To     : I2C_Address;
                       Data   : Nat8_Arr2;
                       Action : End_Of_Transmission := Stop)
   is
   begin
      Talk_To (To);      if Error_State /= OK then return; end if;
      Put (Data);        if Error_State /= OK then return; end if;
      Send (Action);
   end Talk_To2;


   procedure Put (Data : Data_Buffer)
   is
      R : Unsigned_8;
   begin
      -- send the actual data.
      for I in Data'Range loop
         PORT_USI_SCL := False;
         MCU.USIDR := Data (I);
         R := Write_Byte (USISR_8Bit);
         -- Ignore return value R

         -- Enable SDA as input
         DDR_USI_Bits (PIN_USI_SDA) := False;
         R := Write_Byte (USISR_1Bit);
         if (R and 1) = 1 then
            Error_State := NO_ACK_ON_DATA;
            return;
         end if;
      end loop;
   end Put;


   procedure Put (Data : Unsigned_8)
   is
      R : Unsigned_8;
   begin
      PORT_USI_SCL := False;
      MCU.USIDR := Data;
      R := Write_Byte (USISR_8Bit);
      -- Ignore return value R

      -- Enable SDA as input
      DDR_USI_Bits (PIN_USI_SDA) := False;
      R := Write_Byte (USISR_1Bit);
      if (R and 1) = 1 then
         Error_State := NO_ACK_ON_DATA;
         return;
      end if;
   end Put;


   procedure Put2 (Data : Nat8_Arr2)
   is
   begin
      Put (Data(Data'First));
      Put (Data(Data'First+1));
   end Put2;


   procedure Put3 (Data : Nat8_Arr3)
   is begin
      Put (Data(Data'First));
      Put (Data(Data'First+1));
      Put (Data(Data'First+2));
   end Put3;


   procedure Put4 (Data : Nat8_Arr4)
   is begin
      Put (Data(Data'First));
      Put (Data(Data'First+1));
      Put (Data(Data'First+2));
      Put (Data(Data'First+3));
   end Put4;


   procedure Send (Action : End_Of_Transmission := Stop)
   is
   begin
      if Action = Stop then
         Send_Stop;
      else
         null;
         --  restart is just another start
      end if;
   end Send;


   --  For receiving data from a slave you also have to provide the
   --  slave address.  Available data is indicated by
   --  Data_Is_Avalable.  The actual data can be retrieved with the
   --  Get functions.  At the end of the slave transmission the master
   --  emits a stop sequence following the same rules as for sending
   --  from master to the slave.

   procedure Request_From (From   : I2C_Address;
                           Count  : Buffer_Size;
                           Action : End_Of_Transmission := Stop)
   is
   begin
      Talk_To (From);
   end Request_From;


   function Data_Is_Available return Boolean
   is
   begin
      return Data_Is_Available;
   end Data_Is_Available;


   function Get return Unsigned_8
   is
   begin
      return Get;
   end Get;


   function Get return Integer_8
   is
   begin
      return Get;
   end Get;


   function Get return Unsigned_16
   is
   begin
      return Get;
   end Get;


   function Get return Integer_16
   is
   begin
      return Get;
   end Get;


   procedure Get (Data : out Data_Buffer)
   is
      use AVR.MCU;

      R : Unsigned_8;
   begin
      Error_State := OK;

      -- Enable SDA as input
      DDR_USI_Bits (PIN_USI_SDA) := DD_Input; -- False;
      R := Write_Byte (USISR_1Bit);
      if (R and 1) = 1 then
         Error_State := NO_ACK_ON_ADDRESS;
         return;
      end if;

      for I in Data'Range loop
         DDR_USI_Bits (PIN_USI_SDA) := DD_Input; -- False;
         Data (I) := Write_Byte (USISR_8Bit);

         if I = Data'Last then
            USIDR := 16#FF#; -- NACK
         else
            USIDR := 16#00#; -- ACK
         end if;
         R := Write_Byte (USISR_1Bit); -- ACK/NACK
      end loop;

      Send_Stop;
   end Get;


   function Get_Error return Error_T is
   begin
      return Error_State;
   end Get_Error;


begin
   Error_State := OK;
end AVR.I2C.Master;
