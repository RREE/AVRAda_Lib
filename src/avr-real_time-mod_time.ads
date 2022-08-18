--------------------------------------------------------------------------
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

--   some routines to modify time values

package AVR.Real_Time.Mod_Time is
   pragma Preelaborate;

   procedure Inc_Sec (T : access Time);
   procedure Dec_Sec (T : access Time);

   procedure Inc_Min (T : access Time);
   procedure Dec_Min (T : access Time);

   procedure Inc_Hour (T : access Time);
   procedure Dec_Hour (T : access Time);

   procedure Inc_Day (T : access Time);
   procedure Dec_Day (T : access Time);

   procedure Inc_Month (T : access Time);
   procedure Dec_Month (T : access Time);

   procedure Inc_Year (T : access Time);
   procedure Dec_Year (T : access Time);

end AVR.Real_Time.Mod_Time;
