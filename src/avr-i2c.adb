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

package body AVR.I2C is

   function Image (E : Error_T) return Strings.AVR_String
   is
   begin
      case E is
      when OK => return "OK";
      when No_Data => return "No_Data";
      when Data_Out_Of_Bound    => return "Data_Out_Of_Bound";
      when Unexpected_Start_Con => return "Unexpected_Start_Con";
      when Unexpected_Stop_Con  => return "Unexpected_Stop_Con";
      when Unexpected_Data_Col  => return "Unexpected_Data_Col";
      when Lost_Arbitration     => return "Lost_Arbitration";
      when No_Ack_On_Data       => return "No_Ack_On_Data";
      when No_Ack_On_Address    => return "No_Ack_On_Address";
      when Missing_Start_Con    => return "Missing_Start_Con";
      when Missing_Stop_Con     => return "Missing_Stop_Con";
      end case;
   end Image;

end AVR.I2C;
