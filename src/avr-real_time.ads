------------------------------------------------------------------------------
--                                                                          --
--                         AVR-Ada RUN-TIME COMPONENTS                      --
--                                                                          --
--                         A V R . R E A L _ T I M E                        --
--                                                                          --
--                                  S p e c                                 --
--                                                                          --
--  This specification is derived from the Ada Reference Manual for use     --
--  with AVR-Ada.  It contains declarations from Ada.Calendar,              --
--  Ada.Calendar.Formatting, and Ada.Real_Time.  It is part of the AVR-Ada  --
--  library.
--  --------------------------------------------------------------------------
--  The AVR-Ada Library is free software;  you can redistribute it and/or   --
--  modify it under terms of the  GNU General Public License as published   --
--  by  the  Free Software  Foundation;  either  version 2, or  (at  your   --
--  option) any later version.  The AVR-Ada Library is distributed in the   --
--  hope that it will be useful, but  WITHOUT ANY WARRANTY;  without even   --
--  the  implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR   --
--  PURPOSE. See the GNU General Public License for more details.           --
--                                                                          --
--  As a special exception, if other files instantiate generics from this   --
--  unit,  or  you  link  this  unit  with  other  files  to  produce  an   --
--  executable   this  unit  does  not  by  itself  cause  the  resulting   --
--  executable to  be  covered by the  GNU General  Public License.  This   --
--  exception does  not  however  invalidate  any  other reasons why  the   --
--  executable file might be covered by the GNU Public License.             --
--  --------------------------------------------------------------------------



--  The specification relies on a resolution for System.Duration being
--  at least one millisecond = 0.001.  The AVR GNAT compiler is
--  patched to provide a 32-bit wide type for duration that has a tick
--  of at least one millisecond. Duration also spans at least 2 days
--  so that day_duration'last + day_duration'last does not hit the
--  upper limit of the base type duration.
--
--  The package is Pure since Clock is not part of  the specification.      --
--

with Interfaces;
with AVR.Strings;                  use AVR.Strings;

package AVR.Real_Time is
   pragma Pure;

   type Time is private;
   Time_First : constant Time;
   Time_Last  : constant Time;
   Time_Unit  : constant := 10#1.0#E-3;

   type Duration is delta 0.001 digits 9 range -24.0 * 3600.0 .. 48.0 * 3600.0;
   -- for Duration'Small use 0.001;
   for Duration'Size use 32;


   subtype Time_Span is Duration;
   --  we declare Time_Span for AVR as a subtype of Duration rather
   --  then a completely independant type.  This way we provide the
   --  visiblity of the type and its functions and don't have to
   --  duplicate all kind of comfort routines.
   --     Time_Span_First : constant Time_Span;
   --     Time_Span_Last  : constant Time_Span;
   --     Time_Span_Zero  : constant Time_Span;
   --     Time_Span_Unit  : constant Time_Span;

   Tick : constant Duration := Duration'Small; -- = 0.001;

   -- Day of the week:
   type Day_Name is (Monday, Tuesday, Wednesday, Thursday,
                     Friday, Saturday, Sunday);
   for Day_Name'Size use 8;

   function Day_Of_Week (Date : Time) return Day_Name;


   --  Declarations representing limits of allowed local time values.
   subtype Year_Number     is Interfaces.Integer_8; -- offset to the year 2000
   subtype Month_Number    is Interfaces.Unsigned_8 range 1 .. 12;
   subtype Day_Number      is Interfaces.Unsigned_8 range 1 .. 31;
   subtype Hour_Number     is Interfaces.Unsigned_8 range 0 .. 23;
   subtype Minute_Number   is Interfaces.Unsigned_8 range 0 .. 59;
   subtype Second_Number   is Interfaces.Unsigned_8 range 0 .. 59;
   subtype Day_Duration    is Duration              range 0.0 .. 86_400.0;
   subtype Second_Duration is Day_Duration          range 0.0 .. 1.0;


   --  split functions
   function Year       (Date : Time) return Year_Number;
   function Month      (Date : Time) return Month_Number;
   function Day        (Date : Time) return Day_Number;
   function Hour       (Date : Time) return Hour_Number;
   function Minute     (Date : Time) return Minute_Number;
   function Second     (Date : Time) return Second_Number;
   function Sub_Second (Date : Time) return Second_Duration;
   function Seconds    (Date : Time) return Day_Duration;


   function Seconds_Of (Hour       : Hour_Number;
                        Minute     : Minute_Number;
                        Second     : Second_Number := 0;
                        Sub_Second : Second_Duration := 0.0)
                       return Day_Duration;

   procedure Split (Seconds    : in Day_Duration;
                    Hour       : out Hour_Number;
                    Minute     : out Minute_Number;
                    Second     : out Second_Number;
                    Sub_Second : out Second_Duration);

   procedure Split (Date       : in Time;
                    Year       : out Year_Number;
                    Month      : out Month_Number;
                    Day        : out Day_Number;
                    Hour       : out Hour_Number;
                    Minute     : out Minute_Number;
                    Second     : out Second_Number;
                    Sub_Second : out Second_Duration);

   procedure Split (Date       : Time;
                    Year       : out Year_Number;
                    Month      : out Month_Number;
                    Day        : out Day_Number);
                    -- Seconds    : out Day_Duration);

   --  constructor function
   function Time_Of (Year       : Year_Number;
                     Month      : Month_Number;
                     Day        : Day_Number;
                     Hour       : Hour_Number     := 0;
                     Minute     : Minute_Number   := 0;
                     Second     : Second_Number   := 0;
                     Sub_Second : Second_Duration := 0.0)
                    return Time;

   function "+" (Left : Time;      Right : Duration)  return Time;
   function "+" (Left : Duration;  Right : Time)      return Time;
   function "-" (Left : Time;      Right : Duration)  return Time;
   function "-" (Left : Time;      Right : Time)      return Duration;

   function "<"  (Left, Right : Time) return Boolean;
   function "<=" (Left, Right : Time) return Boolean;
   function ">"  (Left, Right : Time) return Boolean;
   function ">=" (Left, Right : Time) return Boolean;

   -- function Nanoseconds  (NS : Integer) return Duration;
   function Microseconds (US : Integer) return Duration;
   function Milliseconds (MS : Integer) return Duration;
   function Seconds      (S  : Integer) return Duration;
   function Minutes      (M  : Integer) return Duration;
   function Hours        (H  : Integer) return Duration;
   -- function Days         (D  : Integer) return Duration;

   --
   --  Image
   --

   function Image (Date : Time) return AStr19;         -- "YYYY-MM-DD HH:MM:SS"
   function Time_Image (T : Time) return AStr8;        -- "HH:MM:SS"
   function Time_Image_Short (T : Time) return AStr6;  -- "HHMMSS"
   function Date_Image (D : Time) return AStr10;       -- "YYYY-MM-DD"
   function Date_Image_Short (D : Time) return AStr6;  -- "YYMMDD"
   function Millisec_Image (D : Day_Duration) return AStr10; -- "00,000.000"
   function Millisec_Image (T : Time) return AStr10;   -- "00,000.000"

   function Image (Elapsed_Time : Duration) return AStr8;    -- "HH:MM:SS"
   function Fract_Image (Elapsed_Time : Duration)
                        return AStr12;                       -- "HH:MM:SS.000"

   function Value (Date : AVR_String) return Time;
   -- function Time_Value (Date : AStr6) return Time;  -- "HHMMSS"
   -- function Date_Value (Date : AStr6) return Time;  -- "YYMMDD"
   function Value (Elapsed_Time : AVR_String) return Duration;


private

   pragma Inline (Milliseconds);
   pragma Inline (Seconds);
   pragma Inline (Minutes);
   pragma Inline (Hours);

   pragma Inline ("+");
   function Time_Minus_Duration (Left : Time; Right : Duration) return Time
     renames "-";
   pragma Inline (Time_Minus_Duration);

   pragma Inline ("<");
   pragma Inline ("<=");
   -- pragma Inline (">");
   -- pragma Inline (">=");

   subtype Day_Count is Interfaces.Integer_16;

   --
   --  Time structure
   --
   type Time is record
      Days : Day_Count;
      Secs : Day_Duration;
   end record;

   Time_First : constant Time := Time'(-2**14, 0.0);

   Time_Last  : constant Time := Time'(Day_Count'Last, Day_Duration'Last);


   --  declared here for testing purposes
   function Julian_Day
     (Year  : Year_Number;
      Month : Month_Number;
      Day   : Day_Number) return Interfaces.Integer_32;

end AVR.Real_Time;
