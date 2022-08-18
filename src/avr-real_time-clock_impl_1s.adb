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

--  implementation of the heart beat for AVR processors at 1 sec resolution
--
--  the current implementation had been tested only on the ATmega169

with AVR;                          use AVR;
with AVR.MCU;
with AVR.Interrupts;
with AVR.Real_Time.Mod_Time;

package body AVR.Real_Time.Clock_Impl is

   --  configuration part

   Timer_Overflow : constant String := AVR.MCU.Sig_TIMER2_OVF_String;

   --  Tick_Delta : constant := 1.0;

   -------------------------------------------------------------------------

   procedure Tick;
   pragma Machine_Attribute (Entity         => Tick,
                             Attribute_Name => "signal");
   pragma Export (C, Tick, Timer_Overflow);

   procedure Tick is
      N : aliased Time := Now;
   begin
      AVR.Real_Time.Mod_Time.Inc_Sec (N'Access);
      Now := N;
   end Tick;


   procedure Init is
   begin
      --  disabel global interrupt
      AVR.Interrupts.Disable_Interrupts;

      --  disable OCIE2A and TOIE2
      MCU.TIMSK2_Bits (MCU.TOIE2_Bit) := False;

      --  select asynchronous operation of Timer2
      MCU.ASSR := MCU.AS2_Mask;

      --  clear TCNT2A
      MCU.TCNT2 := 0;

      --  select precaler: 32.768 kHz / 128 = 1 sec between each overflow
      --  Set (TCCR2A, Get (TCCR2A) or CS22 or CS20);
      declare
         use MCU;
         No_Clock_Source : constant Nat8 := 0;
         No_Prescaling   : constant Nat8 := CS20_Mask;
         Scale_By_8      : constant Nat8 := CS21_Mask;
         Scale_By_32     : constant Nat8 := CS21_Mask or CS20_Mask;
         Scale_By_64     : constant Nat8 := CS22_Mask;
         Scale_By_128    : constant Nat8 := CS22_Mask or CS20_Mask;
         Scale_By_256    : constant Nat8 := CS22_Mask or CS21_Mask;
         Scale_By_1024   : constant Nat8 := CS22_Mask or CS21_Mask or CS20_Mask;
      begin
         MCU.TCCR2A := MCU.TCCR2A or Scale_By_128;
      end;

      --  alternatively prescale by 32 and generate compare interrupt
      --  at 125.  That triggers an interrupt at 32 * 125 = 4000 =
      --  every 0.25ms. ???


      --  wait for 'Timer/Counter Control Register2 Update Busy' and
      --  'Timer/Counter2 Update Busy' to be cleared
      while (MCU.ASSR and (MCU.TCN2UB_Mask or MCU.TCR2UB_Mask)) /= 0 loop null; end loop;

      --  clear interrupt-flags of timer/counter2
      MCU.TIFR2 := 16#FF#;

      --  enable Timer2 overflow interrupt
      MCU.TIMSK2_Bits (MCU.TOIE2_Bit) := True;

      --  enable global interrupt
      AVR.Interrupts.Enable_Interrupts;

      -- provide a default value for the current time
      Now := Time_First;
   end Init;

begin
   Init;
end AVR.Real_Time.Clock_Impl; -- 1sec
