---------------------------------------------------------------------------
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
-- I2C package implementation for masters using TWI support in the AVR
-- (mega) chips.  This implementation is mainly based on Tero
-- Koskine's TWI EEPROM package and the Atmel implementation note
-- (AVR315: Using the TWI module as I2C Master).
--
-- A very detailed and easy to understand description is (in German
-- language) at http://www.mikrocontroller.net/articles/AVR_TWI


with Interfaces;                   use Interfaces;
with AVR;                          use AVR;
with AVRAda_RTS_Config;
with AVR.Strings;                  use AVR.Strings;
with AVR.Interrupts;
with AVR.MCU;
with AVR.Serial;
-- with AVR.Strings.Edit;
-- with AVR.Strings.Edit.Integers;

package body AVR.I2C.Master is


   Debug_Print_Error_Messages : constant Boolean := False;

   Speed : constant Speed_Mode := Standard;

   ---------------------------------------------------------------------------


   TW_READ  : constant := 1;
   TW_WRITE : constant := 0;

   Error_State : Error_T;

   -- Start condition
   TW_START        : constant := 16#08#;
   TW_REP_START    : constant := 16#10#;

   -- Master transmitter
   TW_MT_SLA_ACK   : constant := 16#18#; -- SLA+W transmitted, ACK got
   TW_MT_SLA_NACK  : constant := 16#20#; -- SLA+W transmitted, NACK got

   TW_MT_DATA_ACK  : constant := 16#28#; -- data transmitted, ACK got
   TW_MT_DATA_NACK : constant := 16#30#; -- data transmitted, NACK got

   -- Master receiver
   TW_MR_SLA_ACK   : constant := 16#40#; -- SLA+R transmitted, ACK got
   TW_MR_SLA_NACK  : constant := 16#48#; -- SLA+R transmitted, NACK got

   TW_MR_DATA_ACK  : constant := 16#50#; -- data transmitted, ACK got
   TW_MR_DATA_NACK : constant := 16#58#; -- data transmitted, NACK got

   -- Generic errors
   --  TW_BUS_ERROR    : constant := 0;
   --  TW_NO_INFO      : constant := 16#F8#; -- no information available
   TW_ARB_LOST     : constant := 16#38#; -- arbitr. lost in SLA+W/R or data



   Buffer        : Data_Buffer (Buffer_Range);

   Data_Index    : Buffer_Range;
   Data_Max      : Buffer_Index;
   Data_Received : Buffer_Index;
   Data_Sent     : Boolean; -- All data sent?

   type TWI_State_Enum is (Ready, Master_Receive, Master_Transmit);
   TWI_State : TWI_State_Enum;
   pragma Volatile (TWI_State);
   Slave_Addr_RW : Interfaces.Unsigned_8;
   pragma Volatile (Slave_Addr_RW);


   procedure Send_Stop;
   procedure Reply (Ack : Boolean)
     with Inline;
   procedure Release
     with Inline;
   procedure Check_Err (Msg : AVR_String);


   procedure Init is
      use AVR.MCU;
   begin
      Data_Index := Buffer_Range'First;
      Data_Max := Buffer_Range'First;
      Data_Sent := False;
      TWI_State := Ready;

      -- Init twi ports (portc 4&5)
      PORTC_Bits (4) := True;
      PORTC_Bits (5) := True;

      -- Init twi prescaler and bitrate
      TWSR_Bits (TWPS0_Bit) := False;
      TWSR_Bits (TWPS1_Bit) := False;
      -- Interfaces.Unsigned_8 (((CPU_Speed / TWI_FREQ) - 16) / 2);
      -- (((16_000_000 / 100_000 = 160) - 16 = 144) / 2 = 72)
      -- (((16_000_000 / 400_000 = 40) - 16 = 24) / 2 = 12)
      pragma Assert (AVRAda_RTS_Config.Clock_Frequency = 16_000_000);
      if Speed = Fast then
         TWBR := 12;
      else
         TWBR := 72;
      end if;

      -- Enable twi, acks, and interrupt
      TWCR_Bits := (TWEN_Bit => True,
                    TWIE_Bit => True,
                    TWEA_Bit => True,
                    others   => False);

      AVR.Interrupts.Enable;

      Error_State := OK;
   end Init;


   procedure Check_Err (Msg : AVR_String)
   is
      use Serial;
   begin
      if Error_State /= OK then
         Put_Line ("error: "&Image(Error_State)& " at "&Msg);
      end if;
   end Check_Err;


   procedure Request (Device : I2C_Address;
                      Count  : Buffer_Index)
   is
      use type Interfaces.Unsigned_8;
      use AVR.MCU;
   begin
      Data_Index    := Buffer_Range'First;
      Data_Max      := Count;
      Data_Received := 0;
      Error_State   := OK;
      TWI_State     := Master_Receive;

      Slave_Addr_RW := TW_READ or (Unsigned_8(Device) * 2);

      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTA_Bit => True,
                    others    => False);

      loop
         exit when TWI_State /= Master_Receive;
      end loop;

      --  declare
      --     use AVR.Strings.Edit;
      --     use AVR.Strings.Edit.Integers;
      --  begin
      --     if Count = 8 then
      --        Reset_Output;
      --        Put ("# i2c request ");
      --        Put (Count);
      --        Put (" : ");
      --        for I in Unsigned_8'(1) .. 3 loop
      --           Put (Buffer(I), Base => 16, Field => 2, Fill => '0');
      --           Put (' ');
      --        end loop;
      --        Put (' ');
      --        Put (' ');
      --        for I in Unsigned_8'(4) .. 6 loop
      --           Put (Buffer(I), Base => 16, Field => 2, Fill => '0');
      --           Put (' ');
      --        end loop;
      --        New_Line;
      --        Serial.Put_Edited;
      --     end if;
      --  end;
   end Request;


   function Data_Is_Available return Boolean
   is
   begin
      return Data_Index <= Data_Received;
   end Data_Is_Available;


   --  Actually send the data to the device.  This is part of all send
   --  actions after setting up of the send buffer
   procedure Start_Sending (Device : I2C_Address)
   is
      use AVR.MCU;
   begin
      TWI_State   := Master_Transmit;
      Error_State := OK;

      Slave_Addr_RW := TW_WRITE or (Unsigned_8(Device) * 2);

      -- Send start condition
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTA_Bit => True,
                    others    => False);

      loop
         exit when TWI_State /= Master_Transmit;
      end loop;
   end Start_Sending;


   procedure Send (Device : I2C_Address;
                   Data   : Data_Buffer)
   is
      use AVR.MCU;
   begin
      Data_Sent := False;
      Buffer (1 .. Data'Length) := Data;
      Data_Index := Buffer_Range'First; -- = 1
      Data_Max   := Data'Length;

      TWI_State   := Master_Transmit;
      Error_State := OK;

      Slave_Addr_RW := TW_WRITE or (Unsigned_8(Device) * 2);

      -- Send start condition
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTA_Bit => True,
                    others    => False);

      loop
         exit when TWI_State /= Master_Transmit;
      end loop;

      if Debug_Print_Error_Messages then Check_Err ("sendbuffer"); end if;
   end Send;


   procedure Send (Device : I2C_Address;
                   Data   : Unsigned_8)
   is
      use AVR.MCU;
   begin
      Data_Sent  := False;
      Buffer (1) := Data;
      Data_Index := 1;
      Data_Max   := 1;

      TWI_State   := Master_Transmit;
      Error_State := OK;

      Slave_Addr_RW := TW_WRITE or (Unsigned_8(Device) * 2);

      -- Send start condition
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTA_Bit => True,
                    others    => False);

      loop
         exit when TWI_State /= Master_Transmit;
      end loop;
      if Debug_Print_Error_Messages then Check_Err ("send1x8u"); end if;
   end Send;


   procedure Send (Device : I2C_Address;
                   Data   : Unsigned_16)
   is
      use AVR.MCU;
   begin
      Data_Sent  := False;
      Buffer (1) := High_Byte(Data);
      Buffer (2) := Low_Byte(Data);
      Data_Index := 1;
      Data_Max   := 2;

      TWI_State   := Master_Transmit;
      Error_State := OK;

      Slave_Addr_RW := TW_WRITE or (Unsigned_8(Device) * 2);

      -- Send start condition
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTA_Bit => True,
                    others    => False);

      loop
         exit when TWI_State /= Master_Transmit;
      end loop;
      if Debug_Print_Error_Messages then Check_Err ("send1x16u"); end if;
   end Send;


   procedure Send (Device : I2C_Address;
                   D1     : Unsigned_8;
                   D2     : Unsigned_8)
   is
      use AVR.MCU;
   begin
      Data_Sent  := False;
      Buffer (1) := D1;
      Buffer (2) := D2;
      Data_Index := 1;
      Data_Max   := 2;

      TWI_State   := Master_Transmit;
      Error_State := OK;

      Slave_Addr_RW := TW_WRITE or (Unsigned_8(Device) * 2);

      -- Send start condition
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTA_Bit => True,
                    others    => False);

      loop
         exit when TWI_State /= Master_Transmit;
      end loop;
      if Debug_Print_Error_Messages then Check_Err ("send2x8u"); end if;
   end Send;


   procedure Send (Device : I2C_Address;
                   D1     : Unsigned_16;
                   D2     : Unsigned_16)
   is
      use AVR.MCU;
   begin
      Data_Sent  := False;
      Buffer (1) := High_Byte(D1);
      Buffer (2) := Low_Byte(D1);
      Buffer (3) := High_Byte(D2);
      Buffer (4) := Low_Byte(D2);

      Data_Index := 1;
      Data_Max   := 4;

      TWI_State   := Master_Transmit;
      Error_State := OK;

      Slave_Addr_RW := TW_WRITE or (Unsigned_8(Device) * 2);

      -- Send start condition
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTA_Bit => True,
                    others    => False);

      loop
         exit when TWI_State /= Master_Transmit;
      end loop;
      if Debug_Print_Error_Messages then Check_Err ("send2x16u"); end if;
   end Send;


   procedure Send_Stop is
      use AVR.MCU;
   begin
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    TWSTO_Bit => True,
                    others    => False);
      loop
         exit when not TWCR_Bits (TWSTO_Bit);
      end loop;
      TWI_State := Ready;
      if Debug_Print_Error_Messages then Check_Err ("stop"); end if;
   end Send_Stop;


   procedure Reply (Ack : Boolean) is
      use AVR.MCU;
   begin
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => Ack,   --  <--
                    TWINT_Bit => True,
                    others    => False);
      if Debug_Print_Error_Messages then Check_Err ("reply"); end if;
   end Reply;


   procedure Release is
      use AVR.MCU;
   begin
      TWCR_Bits := (TWEN_Bit  => True,
                    TWIE_Bit  => True,
                    TWEA_Bit  => True,
                    TWINT_Bit => True,
                    others    => False);
      TWI_State := Ready;
      if Debug_Print_Error_Messages then Check_Err ("release"); end if;
   end Release;


   procedure TWI_Interrupt;
   pragma Machine_Attribute (Entity         => TWI_Interrupt,
                             Attribute_Name => "signal");
   pragma Export (C, TWI_Interrupt, MCU.Sig_TWI_String);

   procedure TWI_Interrupt is
      use AVR.MCU;

      TW_Status_Mask : constant Unsigned_8 :=
        TWS7_Mask or TWS6_Mask or TWS5_Mask or TWS4_Mask or TWS3_Mask;
      TW_Status      : constant Unsigned_8 :=
        TWSR and TW_Status_Mask;

   begin
      case TW_Status is

      when TW_START | TW_REP_START =>
         TWDR := Slave_Addr_RW;
         Reply (Ack => True);

      when TW_ARB_LOST =>
         Error_State := Lost_Arbitration;
         Release;

      -- Master data receive

      -- Address sent, got ack from slave
      when TW_MR_SLA_ACK =>
         if Data_Received  < Data_Max - 1 then
            Reply (Ack => True);
         else
            Reply (Ack => False);
         end if;


      -- no ACK after sending the address --> stop
      when TW_MR_SLA_NACK =>
         Send_Stop;


      -- Data available from slave
      when TW_MR_DATA_ACK =>
         Data_Received := Data_Received + 1;
         Buffer (Data_Received) := TWDR;
         if Data_Received < Data_Max then
            Reply (Ack => True);
         else
            Reply (Ack => False);
         end if;


      -- Final data byte got
      when TW_MR_DATA_NACK =>
         Data_Received := Data_Received + 1;
         Buffer (Data_Received) := TWDR;
         Send_Stop;


      -- Master data transmit
      --

      when TW_MT_SLA_ACK | TW_MT_DATA_ACK =>
         if Data_Index <= Data_Max and then not Data_Sent then
            TWDR := Buffer (Data_Index);
            if Data_Index < Data_Max then
               Data_Index := Data_Index + 1;
            else
               Data_Sent := True;
            end if;
            Reply (Ack => True);
         else
            Send_Stop;
         end if;


      when TW_MT_SLA_NACK =>
         Error_State := No_Ack_On_Address;
         Send_Stop;

      when TW_MT_DATA_NACK =>
         Error_State := No_Ack_On_Data;
         Send_Stop;

      when others =>
         null;
      end case;
   end TWI_Interrupt;

   -------------------------------------------------------------------------


   --  sending data to a slave consists of three steps
   --     1) provide the target address
   --     2) queue the data to be sent
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
   --  non overloaded functions with a few standard variables.  In a
   --  typical application with only one or very few clients on the
   --  bus you probably use only one of the constrained functions.
   --  All other code is automatically removed during linking.


   procedure Finish_Send (Action : End_Of_Transmission := Stop)
   is
   begin
      if Action = Stop then
         Send_Stop;
      else
         null;
         --  restart is just another start
      end if;
      if Debug_Print_Error_Messages then Check_Err ("finish send"); end if;
   end Finish_Send;


   --  For receiving data from a slave you also have to provide the
   --  slave address.  Available data is indicated by
   --  Data_Is_Avalable.  The actual data can be retrieved with the
   --  Get functions.  At the end of the slave transmission the master
   --  emits a stop sequence following the same rules as for sending
   --  from master to the slave.


   function Get_U8 return Unsigned_8 is
      Ret_Val : Unsigned_8 := 0;
   begin
      if Data_Index <= Data_Received then
         Ret_Val := Buffer (Data_Index);
         Data_Index := Data_Index + 1;
      end if;
      if Debug_Print_Error_Messages then Check_Err ("get u8"); end if;
      return Ret_Val;
   end Get_U8;
   function Get return Unsigned_8 renames Get_U8;


   function Get return Unsigned_16
   is
      T : constant Unsigned_8 := Get_U8;
   begin
      return Unsigned_16(T) * 2**8 + Unsigned_16(Get_U8);
   end Get;


   function Get_U16_LE return Unsigned_16
   is
      T : constant Unsigned_8 := Get_U8;
   begin
      return Unsigned_16(Get_U8) * 2**8 + Unsigned_16(T);
   end Get_U16_LE;


   procedure Send_And_Receive (Device :     I2C_Address;
                               Arg    :     Unsigned_8;
                               Data   : out Unsigned_8)
   is
   begin
      Send (Device, Arg);
      Request (Device, 1);
      Data := Get;
      if Debug_Print_Error_Messages then Check_Err ("send and receive1"); end if;
   end Send_And_Receive;


   procedure Send_And_Receive (Device :     I2C_Address;
                               Arg    :     Unsigned_8;
                               Data   : out Unsigned_16)
   is
   begin
      Send (Device, Arg);
      Request (Device, 2);
      Data := Get;
      if Debug_Print_Error_Messages then Check_Err ("send and receive2"); end if;
   end Send_And_Receive;


   procedure Send_And_Receive (Device :     I2C_Address;
                               Arg    :     Unsigned_16;
                               Data   : out Unsigned_16)
   is
   begin
      Send (Device, Arg);
      Request (Device, 2);
      Data := Get;
      if Debug_Print_Error_Messages then Check_Err ("send2 and receive2"); end if;
   end Send_And_Receive;


   function Get_Error return Error_T is
   begin
      return Error_State;
   end Get_Error;


   procedure Detect_Device (Device : I2C_Address; Is_Present : out Boolean)
   is
   begin
      Data_Sent := False;
      Data_Index := 1;
      Data_Max := 0;

      Start_Sending (Device);
      Is_Present := (Error_State = OK);
   end Detect_Device;

begin
   Error_State := OK;
end AVR.I2C.Master;
