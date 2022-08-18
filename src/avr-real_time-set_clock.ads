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

--   some routines to set the internal clock

package AVR.Real_Time.Set_Clock is

   procedure Inc_Sec;
   procedure Dec_Sec;

   procedure Inc_Min;
   procedure Dec_Min;

   procedure Inc_Hour;
   procedure Dec_Hour;

   procedure Inc_Day;
   procedure Dec_Day;

   procedure Inc_Month;
   procedure Dec_Month;

   procedure Inc_Year;
   procedure Dec_Year;

   --  set the date and time parts separately in the internal clock to
   --  Target.
   procedure Set_Date_Part (Target : Time);
   procedure Set_Time_Part (Target : Time);
   --  set all fields of the internal clock
   procedure Set (Target : Time);

private
--     pragma Inline (Inc_Sec);
--     pragma Inline (Dec_Sec);
--     pragma Inline (Inc_Min);
--     pragma Inline (Dec_Min);
--     pragma Inline (Inc_Hour);
--     pragma Inline (Dec_Hour);
--     pragma Inline (Inc_Day);
--     pragma Inline (Dec_Day);
--     pragma Inline (Inc_Month);
--     pragma Inline (Dec_Month);
--     pragma Inline (Inc_Year);
--     pragma Inline (Dec_Year);

end AVR.Real_Time.Set_Clock;
