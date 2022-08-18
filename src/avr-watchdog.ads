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

package AVR.Watchdog is
   pragma Preelaborate;

   type WDT_Oscillator_Cycles is
     (
      WDT_16K,
      WDT_32K,
      WDT_64K,
      WDT_128K,
      WDT_256K,
      WDT_512K,
      WDT_1024K,
      WDT_2048K
     );
   for WDT_Oscillator_Cycles'Size use 8;

   --  init watchdog reset/interrupt
   procedure Enable (Wdt : WDT_Oscillator_Cycles);

   --  reset watchdog timer
   procedure Wdr;
   procedure Reset renames Wdr;

   --  disable watchdog reset/interrupt
   procedure Disable;

private
   pragma Inline_Always (Reset);
   pragma Inline_Always (Enable);
   pragma Inline_Always (Disable);
   pragma Import (Intrinsic, Wdr, "__builtin_avr_wdr");
end AVR.Watchdog;
