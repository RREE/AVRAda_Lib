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

--  The implementation relies on a resolution for System.Duration
--  being at 1 second as a simple solution.  Duration also spans at
--  least 2 days so that day_duration'last + day_duration'last does
--  not hit the upper limit of the base type duration.
--
--

with Ada.Unchecked_Conversion;
with AVR;
with AVR.Int_Img;
with AVR.Real_Time.Mod_Time;

package body AVR.Real_Time is


   Minute_Length : constant := 60;
   Hour_Length   : constant := 60 * Minute_Length;
   -- Day_Length    : constant := 24 * Hour_Length;

   -- Days_In_Month : constant array (Month_Number) of Day_Number :=
   --   (31, 28, 31, 30,  31,  30,  31,  31,  30,  31,  30,  31);
   Sum_Days_In_Month : constant array (Month_Number) of Integer_16 :=
     ( 0, 31, 59, 90, 120, 151, 181, 212, 243, 273, 304, 334);


   Days_In_4_Years    : constant := 365 * 3 + 366;
   -- Seconds_In_4_Years : constant := 86_400 * Days_In_4_Years;
   -- Days_In_56_Years   : constant := Days_In_4_Years * 14;


   function Day_Of_Week (Date : Time) return Day_Name
   is
   begin
      pragma Not_Implemented;
      return Sunday;
   end Day_Of_Week;


   function Year (Date : Time) return Year_Number is
   begin
      return Date.Year;
   end Year;


   function Month (Date : Time) return Month_Number is
   begin
      return Date.Month;
   end Month;


   function Day (Date : Time) return Day_Number is
   begin
      return Date.Day;
   end Day;


   function Hour (Date : Time) return Hour_Number is
   begin
      return Date.Hour;
   end Hour;


   function Minute (Date : Time) return Minute_Number is
   begin
      return Date.Min;
   end Minute;


   function Second (Date : Time) return Second_Number is
   begin
      return Date.Sec;
   end Second;


   function Seconds (Date : Time) return Day_Duration is
   begin
      return Day_Duration (Integer_32(Date.Sec) +
                           Integer_32(Date.Min) * 60 +
                           Integer_32(Date.Hour) * 3600);
   end Seconds;


   function Seconds_Of
     (Hour       : Hour_Number;
      Minute     : Minute_Number;
      Second     : Second_Number := 0)
     return Day_Duration
   is
      S : Day_Duration;
   begin
      S := Day_Duration ((((Integer_32(Hour) * 60) + Integer_32(Minute)) * 60)
                         + Integer_32(Second));
      return S;
   end Seconds_Of;


   procedure Split
     (Seconds    : in Day_Duration;
      Hour       : out Hour_Number;
      Minute     : out Minute_Number;
      Second     : out Second_Number)
   is
      -- subtype Nat32 is Integer_32 range 0 .. Integer_32'Last;
      Secs : Nat32;
   begin
      if Seconds = 0.0 then
         Hour       := 0;
         Minute     := 0;
         Second     := 0;
      else
         Secs := Nat32 (Seconds);

         Hour       := Hour_Number   (Secs / Hour_Length);
         Secs       := Secs mod Hour_Length;
         Minute     := Minute_Number (Secs / Minute_Length);
         Second     := Second_Number (Secs mod Minute_Length);
      end if;
   end Split;


   procedure Split
     (Date       : in Time;
      Year       : out Year_Number;
      Month      : out Month_Number;
      Day        : out Day_Number;
      Hour       : out Hour_Number;
      Minute     : out Minute_Number;
      Second     : out Second_Number)
   is
   begin
      Year       := Date.Year;
      Month      := Date.Month;
      Day        := Date.Day;
      Hour       := Date.Hour;
      Minute     := Date.Min;
      Second     := Date.Sec;
   end Split;


   procedure Split
     (Date       : Time;
      Year       : out Year_Number;
      Month      : out Month_Number;
      Day        : out Day_Number)
   is
   begin
      Year  := Date.Year;
      Month := Date.Month;
      Day   := Date.Day;
   end Split;


   function Time_Of
     (Year       : Year_Number;
      Month      : Month_Number;
      Day        : Day_Number;
      Hour       : Hour_Number     := 0;
      Minute     : Minute_Number   := 0;
      Second     : Second_Number   := 0)
     return Time
   is
   begin
      return Time'(Sec   => Second,
                   Min   => Minute,
                   Hour  => Hour,
                   Day   => Day,
                   Month => Month,
                   Year  => Year);
   end Time_Of;


   function "+" (Left : Time; Right : Duration) return Time is
      use AVR.Real_Time.Mod_Time;
      Result : aliased Time := Left;
      Remain : Duration := Right;
   begin
      while Remain >= 24.0 * 3600.0 loop
         Inc_Day (Result'Access);
         Remain := Remain - 24.0 * 3600.0;
      end loop;
      while Remain >= 3600.0 loop
         Inc_Hour (Result'Access);
         Remain := Remain - 3600.0;
      end loop;
      while Remain >= 60.0 loop
         Inc_Min (Result'Access);
         Remain := Remain - 60.0;
      end loop;
      while Remain >= 1.0 loop
         Inc_Sec (Result'Access);
         Remain := Remain - 1.0;
      end loop;
      return Result;
   end "+";


   function "+" (Left : Duration; Right : Time) return Time is
   begin
      return Right + Left;
   end "+";


   function "-" (Left : Time; Right : Duration) return Time is
   begin
      return Left + (-Right);
   end "-";


   function "-" (Left : Time; Right : Time) return Duration is
      Result : constant Duration := 0.0;
   begin
      pragma Not_Implemented;
      return Result;
   end "-";


   function "<" (Left, Right : Time) return Boolean is
   begin
      return not (Left >= Right);
   end "<";


   function "<=" (Left, Right : Time) return Boolean is
   begin
      return not (Left > Right);
   end "<=";


   function ">" (Left, Right : Time) return Boolean is
   begin
      if Left.Year > Right.Year then
         return True;
      elsif Left.Year = Right.Year then
         if Left.Month > Right.Month then
            return True;
         elsif Left.Month = Right.Month then
            if Left.Day > Right.Day then
               return True;
            elsif Left.Day = Right.Day then
               if Left.Hour > Right.Hour then
                  return True;
               elsif Left.Hour = Right.Hour then
                  if Left.Min > Right.Min then
                     return True;
                  elsif Left.Min = Right.Min then
                     if Left.Sec > Right.Sec then
                        return True;
                     else
                        return False;
                     end if;
                  else
                     return False;
                  end if;
               else
                  return False;
               end if;
            else
               return False;
            end if;
         else
            return False;
         end if;
      else
         return False;
      end if;
   end ">";


   function ">=" (Left, Right : Time) return Boolean is
   begin
      if Left = Right or else Left > Right then
         return True;
      else
         return False;
      end if;
   end ">=";


   function Microseconds (US : Integer) return Duration is
   begin
      return Milliseconds (US / 1000);
   end Microseconds;


   function Milliseconds (MS : Integer) return Duration is
   begin
      return Duration (MS) / 1000.0;
   end Milliseconds;


   function Seconds (S  : Integer) return Duration is
   begin
      return Duration (S);
   end Seconds;


   function Minutes (M  : Integer) return Duration is
   begin
      return Duration (60 * M);
   end Minutes;


   function Hours (H  : Integer) return Duration is
   begin
      return Duration (3600 * H);
   end Hours;


   -- complete image "YYYY-MM-DD HH:MM:SS"
   function Image (Date : Time) return AStr19 is
      Img : AStr19;
   begin
      Img (1 .. 10) := Date_Image (Date);
      Img (11) := ' ';
      Img (12 .. 19) := Time_Image (Date);
      return Img;
   end Image;


   -- "HH:MM:SS"
   function Time_Image (T : Time) return AStr8 is
      use AVR.Int_Img;
      Img : AStr8;
   begin
      U8_Img_99_Right (T.Hour, Img (1 .. 2));
      U8_Img_99_Right (T.Min,  Img (4 .. 5));
      U8_Img_99_Right (T.Sec,  Img (7 .. 8));
      Img (3) := ':';
      Img (6) := ':';
      return Img;
   end Time_Image;


   -- "HHMMSS"
   function Time_Image_Short (T : Time) return AStr6 is
      use AVR.Int_Img;
      Img : AStr6;
   begin
      U8_Img_99_Right (T.Hour, Img (1 .. 2));
      U8_Img_99_Right (T.Min,  Img (3 .. 4));
      U8_Img_99_Right (T.Sec,  Img (5 .. 6));
      return Img;
   end Time_Image_Short;


   -- "YYYY-MM-DD"
   function Date_Image (D : Time) return AStr10 is
      use AVR.Int_Img;
      Img : AStr10 := "2000-00-00";
   begin
      U8_Img_99_Right (Nat8 (D.Year), Img (3 .. 4));
      U8_Img_99_Right (D.Month, Img (6 .. 7));
      U8_Img_99_Right (D.Day,   Img (9 .. 10));
      return Img;
   end Date_Image;


   function Date_Image_Short (D : Time) return AStr6 is
      use AVR.Int_Img;
      Img : AStr6;
   begin
      U8_Img_99_Right (Nat8 (D.Year), Img (1 .. 2));
      U8_Img_99_Right (D.Month, Img (3 .. 4));
      U8_Img_99_Right (D.Day,   Img (5 .. 6));
      return Img;
   end Date_Image_Short;


   -- "HH:MM:SS"
   function Image (Elapsed_Time : Duration) return AStr8 is
      use AVR.Int_Img;
      Img : AStr8 := "00:00:00";
      D   : Duration := Elapsed_Time;
      Cnt : Nat8;
   begin
      Cnt := 0;
      while D > 3600.0 loop
         Cnt := Cnt + 1;
         D   := D - 3600.0;
      end loop;
      U8_Img_99_Right (Cnt, Img (1..2));

      Cnt := 0;
      while D > 60.0 loop
         Cnt := Cnt + 1;
         D   := D - 60.0;
      end loop;
      U8_Img_99_Right (Cnt, Img (4..5));

      Cnt := Nat8 (D);
      U8_Img_99_Right (Cnt, Img (7..8));

      return Img;
   end Image;


   --  this will give a warning on typical host machines about not
   --  matching sizes of types.  We don't care as we are only
   --  interested in the low 16 bits anyway.  GNAT defines the
   --  behaviour here by stripping the high bits.
   function To_U16 is new Ada.Unchecked_Conversion
     (Source => Day_Duration, Target => Nat16);

   function Millisec_Image (D : Day_Duration) return AStr10 is
      Img   : AStr10;
      Int   : constant Nat16 := To_U16 (D);
   begin
      AVR.Int_Img.U16_Img_Right (Int, Img (2 .. 6));
      if D >= 1000.0 then
         Img (1) := Img (2);
         Img (2) := Img (3);
         Img (3) := ',';
      end if;
      return Img;
   end Millisec_Image;


   function Millisec_Image (T : Time) return AStr10 is
   begin
      pragma Not_Implemented;
      return "     0,000";
   end Millisec_Image;


   -- "HH:MM:SS.000"
   function Fract_Image (Elapsed_Time : Duration) return AStr12
   is
      Img : AStr12;
   begin
      Img (1 .. 8) := Image (Elapsed_Time);
      Img (9) := '.';
      return Img;
   end Fract_Image;


   function Value (Date : AVR_String) return Time is
      pragma Unreferenced (Date);
      T : Time;
   begin
      pragma Not_Implemented;
      return Time_First;
   end Value;


   function Value (Elapsed_Time : AVR_String) return Duration is
      pragma Unreferenced (Elapsed_Time);
   begin
      pragma Not_Implemented;
      return Duration'(0.0);
   end Value;

end AVR.Real_Time;
