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

--  implementation of the heart beat for AVR processors

--  the current implementation is only tested on the ATmega169

with AVR.Config;
with AVR.Interrupts;
with AVR.Timer1_8bit;

package body AVR.Real_Time.Clock_Impl is

   --  configuration part

   --  one millisecond
   Tick_Delta : constant := 0.001;

   -------------------------------------------------------------------------

   package Timer renames AVR.Timer1_8bit;

   procedure Tick;
   pragma Machine_Attribute (Entity         => Tick,
                             Attribute_Name => "signal");
   pragma Export (C, Tick, Timer.Signal_Compare);

   procedure Tick is
      Local_Secs : Day_Duration := Now.Secs;
   begin
      Local_Secs := Local_Secs + Tick_Delta;
      if Local_Secs = Day_Duration'Last then
         Now.Days := Now.Days + 1;
         Local_Secs := 0.0;
      end if;
      Now.Secs := Local_Secs;
   end Tick;
   --  inside the interrupt routine we don't need to always read and
   --  write from/to RAM. Having the seconds in a local variable in
   --  registers saves 24 bytes on a mega328p (120 vs. 144 bytes).


   procedure Init is
   begin
      --  the following configuration is needed on timer0 for the
      --  different quartz frequencies to generate an interrupt every
      --  1ms, i.e. at 1000Hz.
      --
      --  |  quartz MHz          | prescale         | overflow at     |
      --  +----------------------+------------------+-----------------+
      --  |  1 | 0.000_001       |    8 | 0.000_008 | 125 | 0.001_000 |
      --  |  2 | 0.000_000_5     |    8 | 0.000_004 | 250 | 0.001_000 |
      --  |  4 | 0.000_000_25    |   64 | 0.000_016 |  63 | 0.001_008 |
      --  |  8 | 0.000_000_125   |   64 | 0.000_008 | 125 | 0.001_000 |
      --  | 12 | 0.000_000_083_3 |   64 | 0.000_005 | 188 | 0.001_003 |
      --  | 16 | 0.000_000_062_5 |   64 | 0.000_004 | 250 | 0.001_000 |
      --  +----------------------+------------------+-----------------+

      if AVR.Config.Clock_Frequency = 1_000_000 then
         Timer.Init_CTC (Timer.Scale_By_8, Overflow => 124);
         pragma Compile_Time_Warning
           (True, "t0 scale: 8, overflow 124");

      elsif AVR.Config.Clock_Frequency = 2_000_000 then
         Timer.Init_CTC (Timer.Scale_By_8, Overflow => 249);
         pragma Compile_Time_Warning
           (True, "t0 scale: 8, overflow 249");

      elsif AVR.Config.Clock_Frequency = 4_000_000 then
         Timer.Init_CTC (Timer.Scale_By_64, Overflow => 62);
         pragma Compile_Time_Warning
           (True, "t0 scale: 64, overflow 62");

      elsif AVR.Config.Clock_Frequency = 8_000_000 then
         Timer.Init_CTC (Timer.Scale_By_64, Overflow => 124);
         pragma Compile_Time_Warning
           (True, "t0 scale: 64, overflow 124");

      elsif AVR.Config.Clock_Frequency = 12_000_000 then
         Timer.Init_CTC (Timer.Scale_By_64, Overflow => 187);
         pragma Compile_Time_Warning
           (True, "t0 scale: 64, overflow 187");

      elsif AVR.Config.Clock_Frequency = 16_000_000 then
         Timer.Init_CTC (Timer.Scale_By_64, Overflow => 249);
         pragma Compile_Time_Warning
           (True, "t0 scale: 64, overflow 249");

      else
         pragma Compile_Time_Warning
           (True, "no matching timer configuration available");
         null;
      end if;

      AVR.Interrupts.Enable;
   end Init;

begin
   Init;
end AVR.Real_Time.Clock_Impl;
