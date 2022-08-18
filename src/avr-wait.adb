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

-- Make the program wait for the specified amount of time.  This can only
-- work, if the routines are properly inlined avoiding the call overhead.
-- As these routines do a busy wait, any interupt will add to the delay.
-- For delays of more than a few milliseconds (and even there) a timer
-- triggerd delay is preferable.

with System.Machine_Code;          use System.Machine_Code;
with Interfaces;                   use Interfaces;

package body AVR.Wait is


   procedure Wait_3_Cycles (Count : Unsigned_8) is
      Dummy : Unsigned_8;
   begin
      if Count > 0 then
         Asm ("1: dec %0" & ASCII.LF &
              "brne 1b",
              Outputs  => Unsigned_8'Asm_Output ("=r", Dummy),
              Inputs   => Unsigned_8'Asm_Input ("0", Count),
              Volatile => True);
      end if;
   end Wait_3_Cycles;


   procedure Wait_4_Cycles (Count : Unsigned_16) is
      Dummy : Unsigned_16;
   begin
      if Count > 0 then
         Asm ("1: sbiw %0,1" & ASCII.LF &
              "brne 1b",
              Outputs  => Unsigned_16'Asm_Output ("=w", Dummy),
              Inputs   => Unsigned_16'Asm_Input ("0", Count),
              Volatile => True);
      end if;
   end Wait_4_Cycles;


   procedure Generic_Wait_USecs is
      -- time for four cycles measured in pico seconds
      Cycle_Length : constant Long_Long_Integer :=
        1_000_000_000_000 / Crystal_Hertz;

      Cycles_To_Wait : constant Unsigned_32
        := Unsigned_32 ((Micro_Seconds * 1_000_000) / Cycle_Length);
   begin
      Wait_Cycles (Cycles_To_Wait);
   end Generic_Wait_USecs;


   procedure Generic_Wait_NSecs is
      -- time for one cycle measured in pico seconds
      Cycle_Length : constant Long_Long_Integer :=
        1_000_000_000_000 / Crystal_Hertz;

      Cycles_To_Wait : constant Unsigned_32
        := Unsigned_32 ((Nano_Seconds * 1_000) / Cycle_Length);
   begin
      Wait_Cycles (Cycles_To_Wait);
   end Generic_Wait_NSecs;


   procedure Generic_Busy_Wait_Milliseconds (Wait : Unsigned_16)
   is
      procedure Wait_1ms is new Generic_Wait_USecs
        (Crystal_Hertz => Crystal_Hertz,
         Micro_Seconds => 1000);
   begin
      for I in 1 .. Wait loop
         Wait_1ms;
      end loop;
   end Generic_Busy_Wait_Milliseconds;


   procedure Generic_Busy_Wait_Seconds (Wait : Unsigned_16)
   is
      procedure Wait_1sec is new Generic_Busy_Wait_Milliseconds
        (Crystal_Hertz => Crystal_Hertz);
   begin
      for I in 1 .. Wait loop
         Wait_1sec (1000);
      end loop;
   end Generic_Busy_Wait_Seconds;


end AVR.Wait;
