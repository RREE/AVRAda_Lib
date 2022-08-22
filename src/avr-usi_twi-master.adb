--
-- USI I2C package for AVR-Ada
--
-- Copyright (C) 2013, 2022  Tero Koskinen <tero.koskinen@iki.fi>
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-- USA.
--
-- As a special exception, if other files instantiate generics from this
-- unit,  or  you  link  this  unit  with  other  files  to  produce  an
-- executable   this  unit  does  not  by  itself  cause  the  resulting
-- executable to  be  covered by the  GNU General  Public License.  This
-- exception does  not  however  invalidate  any  other reasons why  the
-- executable file might be covered by the GNU Public License.
--



with AVR.MCU;
with AVR.Wait;
with AVRAda_RTS_Config;

package body AVR.USI_TWI.Master is
   procedure T2_Wait is
       new AVR.Wait.Generic_Wait_USecs (Crystal_Hertz => AVRAda_RTS_Config.Clock_Frequency,
                                        Micro_Seconds => 5);
   procedure T4_Wait is
       new AVR.Wait.Generic_Wait_USecs (Crystal_Hertz => AVRAda_RTS_Config.Clock_Frequency,
                                        Micro_Seconds => 4);
   Error_State : TWI_Error_State;
   TW_READ : constant := 1;
   TW_WRITE : constant := 0;

   procedure Init is
      use AVR.MCU;
   begin
      PORT_USI_Bits (PIN_USI_SDA) := True;
      PORT_USI_Bits (PIN_USI_SCL) := True;

      DDR_USI_Bits (PIN_USI_SCL) := True;
      DDR_USI_Bits (PIN_USI_SDA) := True;

      USIDR := 16#FF#;
      USICR := -- USISIE := False, USIOIE := False -- disable Interrupts
               USIWM1_Mask                         -- Two-wire mode for USI
               or USICS1_Mask or USICLK_Mask;
      USISR := USISIF_Mask or USIOIF_Mask or USIPF_Mask or USIDC_Mask;

      Error_State := USI_TWI_OK;
   end Init;

   procedure Stop is
   begin
      PORT_USI_Bits (PIN_USI_SDA) := False;
      PORT_USI_Bits (PIN_USI_SCL) := True;

      loop
         exit when PIN_USI_Bits (PIN_USI_SCL);
      end loop;

      T4_Wait; -- >4.7us
      PORT_USI_Bits (PIN_USI_SDA) := True;
      T2_Wait; -- >4.0us
   end Stop;

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
      PORT_USI_Bits (PIN_USI_SCL) := True;
      loop
         exit when PORT_USI_Bits (PIN_USI_SCL);
      end loop;

      T2_Wait; -- T2_TWI in standard mode, T4_TWI in fast mode

      -- Generate start condition
      PORT_USI_Bits (PIN_USI_SDA) := False;
      T4_Wait; -- T4_TWI
      PORT_USI_Bits (PIN_USI_SCL) := False;
      PORT_USI_Bits (PIN_USI_SDA) := True;  -- Release SDA

      if not USISR_Bits (USISIF_Bit) then
         Error_State := USI_TWI_MISSING_START_CON;
      end if;

   end Start_Condition;

   procedure Write_Data (Address : Interfaces.Unsigned_8;
                         Data    : Data_Buffer) is
      use AVR.MCU;

      Temp_USISR_8Bit : constant Unsigned_8 :=
         USISIF_Mask or USIOIF_Mask or USIPF_Mask or USIDC_Mask;
      Temp_USISR_1Bit : constant Unsigned_8 :=
         USISIF_Mask or USIOIF_Mask or USIPF_Mask or USIDC_Mask or 16#0E#;

      R : Unsigned_8;

      Addr : constant Unsigned_8 := TW_WRITE or (Address * 2);
   begin
      Error_State := USI_TWI_OK;

      Start_Condition;

      -- Send address first
      PORT_USI_Bits (PIN_USI_SCL) := False;
      USIDR := Addr;
      R := Write_Byte (Temp_USISR_8Bit);
      -- Ignore return value R

      -- Enable SDA as input
      DDR_USI_Bits (PIN_USI_SDA) := False;
      R := Write_Byte (Temp_USISR_1Bit);
      if (R and 1) = 1 then
         Error_State := USI_TWI_NO_ACK_ON_ADDRESS;
         return;
      end if;

      -- Then send the actual data.
      for I in Data'Range loop
         PORT_USI_Bits (PIN_USI_SCL) := False;
         USIDR := Data (I);
         R := Write_Byte (Temp_USISR_8Bit);
         -- Ignore return value R

         -- Enable SDA as input
         DDR_USI_Bits (PIN_USI_SDA) := False;
         R := Write_Byte (Temp_USISR_1Bit);
         if (R and 1) = 1 then
            Error_State := USI_TWI_NO_ACK_ON_DATA;
            return;
         end if;
      end loop;

      Stop;

   end Write_Data;

   procedure Request_Data (Address : Interfaces.Unsigned_8;
                           Data    : in out Data_Buffer) is
      use AVR.MCU;

      Temp_USISR_8Bit : constant Unsigned_8 :=
         USISIF_Mask or USIOIF_Mask or USIPF_Mask or USIDC_Mask;
      Temp_USISR_1Bit : constant Unsigned_8 :=
         USISIF_Mask or USIOIF_Mask or USIPF_Mask or USIDC_Mask or 16#0E#;

      R : Unsigned_8;
      Addr : constant Unsigned_8 := TW_READ or (Address * 2);
   begin
      Error_State := USI_TWI_OK;

      Start_Condition;

      -- Send address first
      PORT_USI_Bits (PIN_USI_SCL) := False;
      USIDR := Addr;
      R := Write_Byte (Temp_USISR_8Bit);
      -- Ignore return value R

      -- Enable SDA as input
      DDR_USI_Bits (PIN_USI_SDA) := False;
      R := Write_Byte (Temp_USISR_1Bit);
      if (R and 1) = 1 then
         Error_State := USI_TWI_NO_ACK_ON_ADDRESS;
         return;
      end if;

      for I in Data'Range loop
         DDR_USI_Bits (PIN_USI_SDA) := False;
         Data (I) := Write_Byte (Temp_USISR_8Bit);
         if I = Data'Last then
            USIDR := 16#FF#; -- NACK
         else
            USIDR := 16#00#; -- ACK
         end if;

         R := Write_Byte (Temp_USISR_1Bit); -- ACK/NACK
      end loop;

      Stop;
   end Request_Data;

   function Get_Error return TWI_Error_State is
   begin
      return Error_State;
   end Get_Error;

begin
   Error_State := USI_TWI_OK;
end AVR.USI_TWI.Master;
