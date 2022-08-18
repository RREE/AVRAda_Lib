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
with Interfaces;                   use type Interfaces.Unsigned_8;
                                   use type Interfaces.Integer_8;
with AVR.Real_Time.Clock_Impl;
with AVR.Real_Time.Mod_Time;       use AVR.Real_Time.Mod_Time;

package body AVR.Real_Time.Set_Clock is


   Now : Time renames AVR.Real_Time.Clock_Impl.Now;
   N   : aliased Time;


   procedure Inc_Sec is
   begin
      N := Now;
      Inc_Sec (N'Access);
      Now := N;
   end Inc_Sec;


   procedure Dec_Sec is
   begin
      N := Now;
      Dec_Sec (N'Access);
      Now := N;
   end Dec_Sec;


   procedure Inc_Min is
   begin
      N := Now;
      Inc_Min (N'Access);
      Now := N;
   end Inc_Min;


   procedure Dec_Min is
   begin
      N := Now;
      Dec_Min (N'Access);
      Now := N;
   end Dec_Min;


   procedure Inc_Hour is
   begin
      N := Now;
      Inc_Hour (N'Access);
      Now := N;
   end Inc_Hour;


   procedure Dec_Hour is
   begin
      N := Now;
      Dec_Hour (N'Access);
      Now := N;
   end Dec_Hour;


   procedure Inc_Day is
   begin
      N := Now;
      Inc_Day (N'Access);
      Now := N;
   end Inc_Day;


   procedure Dec_Day is
   begin
      N := Now;
      Dec_Day (N'Access);
      Now := N;
   end Dec_Day;


   procedure Inc_Month is
   begin
      N := Now;
      Inc_Month (N'Access);
      Now := N;
   end Inc_Month;


   procedure Dec_Month is
   begin
      N := Now;
      Dec_Month (N'Access);
      Now := N;
   end Dec_Month;


   procedure Inc_Year is
   begin
      N := Now;
      Inc_Year (N'Access);
      Now := N;
   end Inc_Year;


   procedure Dec_Year is
   begin
      N := Now;
      Dec_Year (N'Access);
      Now := N;
   end Dec_Year;


   --  set the date and time parts separately in the internal clock to
   --  Target.
   procedure Set_Date_Part (Target : Time)
   is
   begin
      Now.Day   := Target.Day;
      Now.Month := Target.Month;
      Now.Year  := Target.Year;
   end Set_Date_Part;


   procedure Set_Time_Part (Target : Time)
   is
   begin
      Now.Sec  := Target.Sec;
      Now.Min  := Target.Min;
      Now.Hour := Target.Hour;
   end Set_Time_Part;


   --  set all fields of the internal clock
   procedure Set (Target : Time)
   is
   begin
      Set_Date_Part (Target);
      Set_Time_Part (Target);
   end Set;

end AVR.Real_Time.Set_Clock;
