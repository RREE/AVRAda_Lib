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


--  Subprograms to access the on-chip watchdog timer.
--  Tested with ATmega8 only

with Ada.Unchecked_Conversion;

with AVR;                          use AVR;
with AVR.MCU;                      use AVR.MCU;
with AVR.Interrupts;
--  with AVR.Watchdog.Disable_At_Startup;

package body AVR.Watchdog is

   function WDT_To_Byte is
      new Ada.Unchecked_Conversion (WDT_Oscillator_Cycles, Unsigned_8);


#if MCU = "attiny2313" or else MCU = "atmega169" or else MCU = "atmega8" then
   Watchdog_Control_R : Unsigned_8 renames WDTCR;
   Watchdog_Control_B : Bits_In_Byte renames WDTCR_Bits;
#elsif MCU = "atmega168" or else MCU = "atmega2560" or else MCU = "atmega328p" or else MCU = "atmega644p" then
   Watchdog_Control_R : Unsigned_8 renames WDTCSR;
   Watchdog_Control_B : Bits_In_Byte renames WDTCSR_Bits;
#end if;


   procedure Enable (Wdt : WDT_Oscillator_Cycles) is
      Tmp_SREG : Unsigned_8;
   begin
      Tmp_SREG := Interrupts.Save_And_Disable;
      Reset;
      Watchdog_Control_B := (WDCE_Bit => True,
                             WDE_Bit  => True,
                             others   => False);
      Watchdog_Control_R := (WDT_To_Byte (Wdt) or WDE_Mask);
      Interrupts.Restore (Tmp_SREG);
   end Enable;


   procedure Disable is
      Tmp_SREG : Unsigned_8;
   begin
      Tmp_SREG := Interrupts.Save_And_Disable;
      Reset;
      Watchdog_Control_B := (WDCE_Bit => True,
                             WDE_Bit  => True,
                             others   => False);
      Watchdog_Control_R := 0;
      Interrupts.Restore (Tmp_SREG);
   end Disable;

--  begin
--     Disable;
end AVR.Watchdog;
