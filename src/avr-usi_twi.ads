--
-- USI I2C package for AVR-Ada
--
-- Copyright (C) 2013  Tero Koskinen <tero.koskinen@iki.fi>
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


with AVR;
with AVR.MCU;
with Interfaces;

package AVR.USI_TWI is
   use Interfaces;

   type TWI_Error_State is
     (USI_TWI_OK,
      USI_TWI_NO_DATA,
      USI_TWI_DATA_OUT_OF_BOUND,
      USI_TWI_UNEXPECTED_START_CON,
      USI_TWI_UNEXPECTED_STOP_CON,
      USI_TWI_UNEXPECTED_DATA_COL,
      USI_TWI_NO_ACK_ON_DATA,
      USI_TWI_NO_ACK_ON_ADDRESS,
      USI_TWI_MISSING_START_CON,
      USI_TWI_MISSING_STOP_CON);

#if MCU = "attiny85" then
   PIN_USI_SDA   : constant Bit_Number := 0;
   PIN_USI_SCL   : constant Bit_Number := 2;

   -- attiny2313/attiny4313, other attiny mcus not supported/tested
#else
   PIN_USI_SDA   : constant Bit_Number := 5;
   PIN_USI_SCL   : constant Bit_Number := 7;
#end if;

   DDR_USI       : Unsigned_8 renames AVR.MCU.DDRB;
   PORT_USI      : Unsigned_8 renames AVR.MCU.PORTB;
   PIN_USI       : Unsigned_8 renames AVR.MCU.PINB;
   DDR_USI_Bits  : Bits_In_Byte renames AVR.MCU.DDRB_Bits;
   PORT_USI_Bits : Bits_In_Byte renames AVR.MCU.PORTB_Bits;
   PIN_USI_Bits  : Bits_In_Byte renames AVR.MCU.PINB_Bits;
   PORT_USI_SDA  : Boolean renames AVR.MCU.PORTB_Bits(PIN_USI_SDA);
   PORT_USI_SCL  : Boolean renames AVR.MCU.PORTB_Bits(PIN_USI_SCL);

   subtype Buffer_Size is Interfaces.Unsigned_8 range 0 .. 32;
   type Data_Buffer is array (Buffer_Size range <>) of Interfaces.Unsigned_8;

end AVR.USI_TWI;
