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
--  with Interfaces;                   use type Interfaces.Unsigned_8;
--                                     use type Interfaces.Integer_8;


package body AVR.Real_Time.Mod_Time is


   Max_Day : constant array (Month_Number) of Day_Number :=
     ( 1 => 31,
       2 => 28,
       3 => 31,
       4 => 30,
       5 => 31,
       6 => 30,
       7 => 31,
       8 => 31,
       9 => 30,
      10 => 31,
      11 => 30,
      12 => 31);


   procedure Inc_Sec (T : access Time) is
   begin
      if T.Sec /= 59 then
         T.Sec := T.Sec + 1;
      else
         T.Sec := 0;
         Inc_Min (T);
      end if;
   end Inc_Sec;


   procedure Dec_Sec (T : access Time) is
   begin
      if T.Sec = 0 then
         T.Sec := 59;
      else
         T.Sec := T.Sec - 1;
      end if;
   end Dec_Sec;


   procedure Inc_Min (T : access Time) is
   begin
      if T.Min /= 59 then
         T.Min := T.Min + 1;
      else
         T.Min := 0;
         Inc_Hour (T);
      end if;
   end Inc_Min;


   procedure Dec_Min (T : access Time) is
   begin
      if T.Min = 0 then
         T.Min := 59;
      else
         T.Min := T.Min - 1;
      end if;
   end Dec_Min;


   procedure Inc_Hour (T : access Time) is
   begin
      if T.Hour /= 23 then
         T.Hour := T.Hour + 1;
      else
         T.Hour := 0;
         Inc_Day (T);
      end if;
   end Inc_Hour;


   procedure Dec_Hour (T : access Time) is
   begin
      if T.Hour = 0 then
         T.Hour := 23;
      else
         T.Hour := T.Hour - 1;
      end if;
   end Dec_Hour;


   procedure Inc_Day (T : access Time) is
   begin
      --  first handle leap years
      if T.Year mod 4 = 0 and then T.Month = 2 then
         if T.Day = 29 then
            T.Day := 1;
            T.Month := 3;
         else
            T.Day := T.Day + 1;
         end if;
      elsif T.Day = Max_Day (T.Month) then
         T.Day := 1;
         Inc_Month (T);
      else
         T.Day := T.Day + 1;
      end if;
   end Inc_Day;


   procedure Dec_Day (T : access Time) is
   begin
      if T.Day = 1 then
         T.Day := 31;
      else
         T.Day := T.Day - 1;
      end if;
   end Dec_Day;


   procedure Inc_Month (T : access Time) is
   begin
      if T.Month /= 12 then
         T.Month := T.Month + 1;
      else
         T.Month := 1;
         Inc_Year (T);
      end if;
   end Inc_Month;


   procedure Dec_Month (T : access Time) is
   begin
      if T.Month = 1 then
         T.Month := 12;
      else
         T.Month := T.Month - 1;
      end if;
   end Dec_Month;


   procedure Inc_Year (T : access Time) is
   begin
      T.Year := T.Year + 1;
   end Inc_Year;


   procedure Dec_Year (T : access Time) is
   begin
      T.Year := T.Year - 1;
   end Dec_Year;

end AVR.Real_Time.Mod_Time;
