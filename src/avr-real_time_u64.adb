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

--  The specification and implementation is based on standard
--  Ada.Real_Time as of gcc-4.7 (Feb 2012).

with Interfaces;                   use Interfaces;
with AVR.Int_Img;

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


   --  Compute Julian day number
   --
   --  The code of this function is a modified version of algorithm
   --  199 from the Collected Algorithms of the ACM. The author of
   --  algorithm 199 is Robert G. Tantzen.
   --
   --  Julian_Day is used by Day_Of_Week and Day_In_Year. Note that
   --  this implementation is not expensive.
   --
   --  The function Julian_Day was copied from the gcc sources off the
   --  main trunk in March 2006.  It has therefore the copyright 2006
   --  by the FSF.
   function Julian_Day
     (Year  : Year_Number;
      Month : Month_Number;
      Day   : Day_Number) return Integer_32
   is
      Internal_Year  : Integer_32;
      Internal_Month : Integer_32;
      Internal_Day   : Integer_32;
      Julian_Date    : Integer_32;
      C              : Integer_32;
      Ya             : Integer_32;

   begin
      Internal_Year  := Integer_32 (Year) + 2000;
      Internal_Month := Integer_32 (Month);
      Internal_Day   := Integer_32 (Day);

      if Internal_Month > 2 then
         Internal_Month := Internal_Month - 3;
      else
         Internal_Month := Internal_Month + 9;
         Internal_Year  := Internal_Year - 1;
      end if;

      C  := Internal_Year / 100;
      Ya := Internal_Year - (100 * C);

      Julian_Date := (146_097 * C) / 4 +
        (1_461 * Ya) / 4 +
        (153 * Internal_Month + 2) / 5 +
        Internal_Day + 1_721_119;

      return Julian_Date;
   end Julian_Day;


   procedure Julian_Date (JD    :     Integer_32;
                          Year  : out Year_Number;
                          Month : out Month_Number;
                          Day   : out Day_Number)
   is
      J, D, M, Y : Integer_32;
   begin
      j := JD - 1_721_119;
      Y := (4 * J - 1) / 146_097;  J := 4 * J - 1 - 146_097 * Y;  D := J / 4;
      J := (4 * D + 3) / 1_461;  D := 4 * D + 3 - 1_461 * J;  D := (D + 4) / 4 ;
      M := (5 * d - 3) / 153;  D := 5 * D - 3 - 153 * M;  D := (D + 5) / 5 ;
      Y := 100 * Y + J;
      if M < 10 then
         Month := Month_Number (M + 3);
         Year  := Year_Number (Y - 2000);
      else
         Month := Month_Number (M - 9);
         Year  := Year_Number (Y + 1 - 2000);
      end if;
      Day := Day_Number (D);
   end Julian_Date;


   function Day_Of_Week (Date : Time) return Day_Name is
      Year  : Year_Number;
      Month : Month_Number;
      Day   : Day_Number;
   begin
      Split (Date, Year, Month, Day);
      return Day_Name'Val ((Julian_Day (Year, Month, Day)) mod 7);
   end Day_Of_Week;


   function Year (Date : Time) return Year_Number is
      Y : Year_Number;
      M : Month_Number;
      D : Day_Number;
   begin
      Split (Date, Y, M, D);
      return Y;
   end Year;


   function Month (Date : Time) return Month_Number is
      Y : Year_Number;
      M : Month_Number;
      D : Day_Number;
   begin
      Split (Date, Y, M, D);
      return M;
   end Month;


   function Day (Date : Time) return Day_Number is
      Y : Year_Number;
      M : Month_Number;
      D : Day_Number;
   begin
      Split (Date, Y, M, D);
      return D;
   end Day;


   function Hour (Date : Time) return Hour_Number is
   begin
      return Hour_Number (Integer_32 (Date.Secs) / Hour_Length);
   end Hour;


   function Minute (Date : Time) return Minute_Number is
   begin
      return Minute_Number
        ((Integer_32 (Date.Secs) mod Hour_Length) / Minute_Length);
   end Minute;


   function Second (Date : Time) return Second_Number is
   begin
      return Second_Number (Integer_32 (Date.Secs - Sub_Second (Date)) rem 60);
   end Second;


   function Sub_Second (Date : Time) return Second_Duration is
      --  converting to integer rounds
      Int_Seconds : constant Integer_32 := Integer_32 (Date.Secs-0.5);
      SS : constant Duration := Date.Secs - Duration (Int_Seconds);
   begin
      if Date.Secs = 0.0 then
         return 0.0;
      end if;

--        declare
--           use Ada.Text_IO;
--        begin
--           Put_Line ("date.secs:"&Date.Secs'Img);
--           Put_Line ("int_secs:"&Int_Seconds'Img);
--           Put_Line ("ss:"&SS'Img);
--        end;

      if SS < 0.0 then
         return Second_Duration (1.0 + SS);
      else
         return Second_Duration (SS);
      end if;
   end Sub_Second;


   function Seconds (Date : Time) return Day_Duration is
   begin
      return Date.Secs;
   end Seconds;


   function Seconds_Of
     (Hour       : Hour_Number;
      Minute     : Minute_Number;
      Second     : Second_Number := 0;
      Sub_Second : Second_Duration := 0.0)
     return Day_Duration
   is
      SS : Day_Duration := 0.0;
      H : constant Integer_32 := Integer_32(Hour);
      M : constant Integer_32 := Integer_32(Minute);
      S : constant Integer_32 := Integer_32(Minute);
      T : Integer_32;
   Begin
      T := H * 60 + M;
      T := T * 60 + S;
      -- Ss := Day_Duration (T); <<-- generate compiler error

      --  SS := Day_Duration ((((Integer_32(Hour) * 60) + Integer_32(Minute)) * 60)
      --  + Integer_32(Second))
      --  + Sub_Second;
      return SS;
   end Seconds_Of;


   procedure Split
     (Seconds    : in Day_Duration;
      Hour       : out Hour_Number;
      Minute     : out Minute_Number;
      Second     : out Second_Number;
      Sub_Second : out Second_Duration)
   is
      subtype Nat32 is Integer_32 range 0 .. Integer_32'Last;
      Secs : Nat32;
   begin
      if Seconds = 0.0 then
         Hour       := 0;
         Minute     := 0;
         Second     := 0;
         Sub_Second := 0.0;
      else
         Secs := Nat32 (Seconds - 0.5);
         Sub_Second := Seconds - Day_Duration (Secs);

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
      Second     : out Second_Number;
      Sub_Second : out Second_Duration)
   is
   begin
      Split (Date, Year, Month, Day);
      Split (Date.Secs, Hour, Minute, Second, Sub_Second);
   end Split;


   procedure Split
     (Date       : Time;
      Year       : out Year_Number;
      Month      : out Month_Number;
      Day        : out Day_Number)
   is
      Julian_Day_Of_2000_01_01 : constant := 2451545;
   begin
      Julian_Date (Integer_32 (Date.Days) + Julian_Day_Of_2000_01_01,
                   Year,
                   Month,
                   Day);
   end Split;


   function Time_Of
     (Year       : Year_Number;
      Month      : Month_Number;
      Day        : Day_Number;
      Hour       : Hour_Number     := 0;
      Minute     : Minute_Number   := 0;
      Second     : Second_Number   := 0;
      Sub_Second : Second_Duration := 0.0)
     return Time
   is
      T : Time;
      Y : Year_Number;
      -- Days : Day_Count;
      -- J : Integer_32 := Julian_Day (Year, Month, Day);
   begin
      T.Secs := Seconds_Of (Hour, Minute, Second, Sub_Second);
      --  the years that we support range from 2000 - 99 = 1901 to
      --  2000 + 99 = 2099.  All years divisable by 4 are leap years
      --  including the year 2000.
      Y := Year / 4;
      T.Days := Day_Count (Y) * Days_In_4_Years;
      Y := Year rem 4;
      T.Days := T.Days + Day_Count (Y) * 365;
      if Y > 0 then
         T.Days := T.Days + 1;
      end if;

      T.Days := T.Days + Day_Count (Sum_Days_In_Month (Month));

      T.Days := T.Days + Day_Count (Day - 1);

      return T;
   end Time_Of;


   function "+" (Left : Time; Right : Duration) return Time is
      pragma Unsuppress (Overflow_Check);
   begin
      return Time (Duration (Left) + Duration (Right));
   end "+";


   function "+" (Left : Duration; Right : Time) return Time is
      pragma Unsuppress (Overflow_Check);
   begin
      return Time (Duration (Left) + Duration (Right));
   end "+";


   function "-" (Left : Time; Right : Duration) return Time is
      pragma Unsuppress (Overflow_Check);
   begin
      return Time (Duration (Left) - Duration (Right));
   end "-";


   function "-" (Left : Time; Right : Time) return Duration is
      pragma Unsuppress (Overflow_Check);
   begin
      return Duration (Left) - Duration (Right);
   end "-";


   function "<" (Left, Right : Time) return Boolean is
      pragma Unsuppress (Overflow_Check);
   begin
      return Duration (Left) < Duration (Right);
   end "<";


   function "<=" (Left, Right : Time) return Boolean is
      pragma Unsuppress (Overflow_Check);
   begin
      return Duration (Left) <= Duration (Right);
   end "<=";


   function ">" (Left, Right : Time) return Boolean is
      pragma Unsuppress (Overflow_Check);
   begin
      return Duration (Left) > Duration (Right);
   end ">";


   function ">=" (Left, Right : Time) return Boolean is
      pragma Unsuppress (Overflow_Check);
   begin
      return Duration (Left) >= Duration (Right);
   end ">=";


   function Microseconds (US : Integer) return Duration is
   begin
      return Duration (US) * 1_000_000.0;
   end Microseconds;

   --  avoid front end inlining by placing milliseconds after
   --  microsends. With front end inlining enabled (-gnatN) we get a
   --  gnat bug box.
   function Milliseconds (MS : Integer) return Duration is
   begin
      return Duration (MS) * 1000;
   end Milliseconds;


   function Seconds (S  : Integer) return Duration is
   begin
      return Duration (S) * 1_000_000_000.0;
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
      pragma Unreferenced (T);
      Img : AStr8 := "00:00:00";
   begin
      return Img;
   end Time_Image;


   function Time_Image_Short (T : Time) return AStr6 is
      pragma Unreferenced (T);
      Img : AStr6 := "000000";
   begin
      return Img;
   end Time_Image_Short;


   -- "YYYY-MM-DD"
   function Date_Image (D : Time) return AStr10 is
      pragma Unreferenced (D);
      Img : AStr10 := "0000-00-00";
   begin
      pragma Not_Implemented;
      return Img;
   end Date_Image;


   function Date_Image_Short (D : Time) return AStr6 is
      Img_L : constant Astr10 := Date_Image (D);
      Img : AStr6;
   begin
      Img (1) := Img_L (3);
      Img (2) := Img_L (4);
      Img (3) := Img_L (6);
      Img (4) := Img_L (7);
      Img (5) := Img_L (9);
      Img (6) := Img_L (10);
      return Img;
   end Date_Image_Short;


   --  this will give a warning on typical host machines about not
   --  matching sizes of types.  We don't care as we are only
   --  interested in the low 32 bits anyway.
   function To_Int32 is new Ada.Unchecked_Conversion
     (Source => Day_Duration, Target => Integer_32);

   -- "00,000.000"
   function Millisec_Image (D : Day_Duration) return AStr10 is
      Img     : AStr10      := "**********";
      I32_Img : AStr10      := "++++++++++";
      D32_Img : AStr8       := "    0000";
      Int     : constant Integer_32 := To_Int32 (D);
      --  Is_Neg : constant Boolean := (D < 0.0);
      L     : Nat8 := 0;
   begin
      pragma Compile_Time_Warning (Day_Duration'Small /= 0.001,
                      "Image of milliseconds only works for " &
                      "Duration'Small = 0.001");

      AVR.Int_Img.U32_Img (Nat32 (Int), I32_Img, L);
      -- fill the intermediate unformatted string
      for I in reverse D32_Img'Range loop
         D32_Img (I) := I32_Img (L); L := L - 1;
         exit when L = 0;
      end loop;
      -- build the formated string
      Img (10) := D32_Img (8);
      Img (9)  := D32_Img (7);
      Img (8)  := D32_Img (6);
      Img (7)  := '.';
      Img (6)  := D32_Img (5);
      Img (5)  := D32_Img (4);
      Img (4)  := D32_Img (3);

      if D >= 1000.0 then
         Img (3) := ',';
         Img (2) := D32_Img (2);
         Img (1) := D32_Img (1);
      else
         Img (3) := ' ';
         Img (2) := ' ';
         Img (1) := ' ';
      end if;

      -----------------------------------------
      --
      --
      --
      -----------------------------------------

      --        pragma Not_Implemented;

      --        Put_Line ("int: " & Int'Img);
      --        Ref := 10_000.0;
      --        for I in Img'Range loop
      --         if I = 3 and then D >= 1_000.0 then
      --            Img (3) := ',';
      --         elsif I = 7 then
      --            Img (7) := '.';
      --         else
      --            if DD > Ref then
      --               Digit := '0';
      --               while DD > Ref loop
      --                  Put_Line ("Ref:" & Ref'Img & " DD:" & DD'Img & " Digit: " & Digit);
      --                  DD := DD - Ref;
      --                  Digit := Character'Succ (Digit);
      --               end loop;
      --            else
      --               if Ref >= 1.0 then
      --                  Digit := ' ';
      --               else
      --                  Digit := '0';
      --               end if;
      --            end if;
      --            Ref := Ref / 10.0;
      --            Img (I) := Digit;
      --         end if;
      --         Put ("Img (#" & I'Img); Put (") ");
      --         for J in Img'Range loop
      --            Put (Img(J));
      --         end loop;
      --         New_Line;
      --        end loop;
      --     end if;

      --        begin
      --           Put ("D: " & D'Img & "Img: ");
      --           for J in Img'Range loop
      --              Put (Img(J));
      --           end loop;
      --           New_Line;
      --        end;

      return Img;
   end Millisec_Image;


   function Millisec_Image (T : Time) return AStr10 is
   begin
      return Millisec_Image (T.Secs);
   end Millisec_Image;


   -- "HH:MM:SS"
   function Image (Elapsed_Time : Duration) return AStr8 is
      pragma Unreferenced (Elapsed_Time);
      Img : AStr8 := "00:00:00";
   begin
      pragma Not_Implemented;
      return Img;
   end Image;


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
