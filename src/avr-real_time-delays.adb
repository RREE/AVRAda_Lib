
with AVR.Sleep;
with AVR.Real_Time.Clock;

package body AVR.Real_Time.Delays is


   --  Max_Sensible_Delay : constant Duration := 24.0 * 60.0 * 60.0;

   --  Values for Mode call below. Note that the compiler (exp_ch9.adb)
   --  relies on these values. So any change here must be reflected in
   --  corresponding changes in the compiler.
   --  Relative          : constant := 0;
   --  Absolute_Calendar : constant := 1;
   --  Absolute_RT       : constant := 2;
   --  AVR_RT            : constant := 3;


   procedure Delay_For (D : Duration) is
      End_Of_Delay : constant Time := Clock + D;
   begin
      Delay_Until (End_Of_Delay);
   end Delay_For;


   procedure Delay_Until (T : Time) is
   begin
      --  the following comparison might become expensive when
      --  delaying across midnight.  An alternative implementation
      --  could start an additional delay counter in the timer tick.
      while T > Clock loop
         Sleep.Set_Mode (Sleep.Idle);
         --  ??? if we used timer2 on atmega169, we could apply the
         --  power-save mode instead.

         Sleep.Go_Sleeping;
         --  the MCU wakes up from the timer interrupt once per millisecond.

      end loop;
   end Delay_Until;

end AVR.Real_Time.Delays;
