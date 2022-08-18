with AVR.Real_Time;                use AVR.Real_Time;
-- with AVR.Real_Time.Set_Clock;      use AVR.Real_Time.Set_Clock;
with GNAT.Calendar;
with Ada.Calendar;
with Ada.Text_IO;                  use Ada.Text_IO;
with Ada.Real_Time.Timing_Events;  use Ada.Real_Time.Timing_Events;
with System.Tasking.Utilities;

package body AVR.Real_Time.Clock_Impl is
   --  difference in seconds between 1970-01-01 and 2000-01-01
   -- Delta_Epoch_AVR : constant := 946_684_800.0;

   A_Year  : Ada.Calendar.Year_Number;
   A_Month : Ada.Calendar.Month_Number;
   A_Day   : Ada.Calendar.Day_Number;
   A_Hour  : GNAT.Calendar.Hour_Number;
   A_Min   : GNAT.Calendar.Minute_Number;
   A_Sec   : GNAT.Calendar.Second_Number;
   A_Ss    : Ada.Calendar.Day_Duration;


   procedure Update;

--     protected Clock_Tick is
--        procedure Inc_Clock (Ev : in out Timing_Event);
--     end Clock_Tick;

--     Tick    : Timing_Event;
--     One_Sec : constant Ada.Real_Time.Time_Span := Ada.Real_Time.Seconds (1);

--     protected body Clock_Tick is
--        procedure Inc_Clock (Ev : in out Timing_Event)
--        is
--           use Ada.Real_Time;
--        begin
--           Inc_Sec;
--           Set_Handler (Tick,
--                        Ada.Real_Time.Time_Span'(One_Sec),
--                        Handler => Inc_Clock'Access);
--        end Inc_Clock;
--     end Clock_Tick;


   task Tick_1s is
      entry Start;
   end Tick_1s;


   task body Tick_1s is
   begin
      System.Tasking.Utilities.Make_Independent;
      accept Start;
      Put_Line ("Tick_1s started");
      loop
         delay 1.0;
         -- Inc_Sec;
         Update;
         -- Put_Line ("(Tick_1s) inc_sec");
      end loop;
   end Tick_1s;


   procedure Update is
   begin
      GNAT.Calendar.Split (Ada.Calendar.Clock,
                           A_Year,
                           A_Month,
                           A_Day,
                           A_Hour,
                           A_Min,
                           A_Sec,
                           A_SS);

      Now := AVR.Real_Time.Time'(Year  => Year_Number (A_Year - 2000),
                                 Month => Month_Number (A_Month),
                                 Day   => Day_Number (A_Day),
                                 Hour  => Hour_Number (A_Hour),
                                 Min   => Minute_Number (A_Min),
                                 Sec   => Second_Number (A_Sec));
   end Update;


   procedure Init is
   begin
      Tick_1s.Start;
      null;
   end Init;

begin
   Init;
end AVR.Real_Time.Clock_Impl;
