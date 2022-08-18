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
-- I2C package for AVR-Ada
--


with AVR;
with AVR.Strings;

package AVR.I2C is
   pragma Pure;

   type Error_T is
     (OK,
      No_Data,
      Data_Out_Of_Bound,
      Unexpected_Start_Con,
      Unexpected_Stop_Con,
      Unexpected_Data_Col,
      Lost_Arbitration,
      No_Ack_On_Data,
      No_Ack_On_Address,
      Missing_Start_Con,
      Missing_Stop_Con);

   function Image (E : Error_T) return Strings.AVR_String;


   type Speed_Mode is (Standard, --  100kHz
                       Fast,     --  400kHz
                       Fast_Plus);

   type I2C_Address is new Nat8 range 0 .. 127;

   subtype Buffer_Index is Nat8 range 0 .. 32;
   subtype Buffer_Range is Nat8 range 1 .. 32;
   type Data_Buffer is array (Buffer_Range range <>) of Nat8;

end AVR.I2C;
