---------------------------------------------------------------------------
--                                                                       --
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

with Interfaces;                   use Interfaces;

package AVR.Wait is
   pragma Preelaborate;


   procedure Wait_3_Cycles (Count : Unsigned_8);
   -- can wait up to 2**8 x 3 cycles

   procedure Wait_4_Cycles (Count : Unsigned_16);
   -- can wait up to 2**16 x 4 cycles

   procedure Wait_Cycles (Count : Unsigned_32);


   generic
      Crystal_Hertz : Long_Long_Integer;
      Micro_Seconds : Long_Long_Integer;
   procedure Generic_Wait_USecs;

   generic
      Crystal_Hertz : Long_Long_Integer;
      Nano_Seconds  : Long_Long_Integer;
   procedure Generic_Wait_NSecs;
   --  provide a pragma Inline for the instances of these procedures,
   --  at least for short delays where the call overhead is relatively
   --  important.

   --  If you care for code size, instatiate this routine at a top
   --  level of a package. Dead code elimination wil remove it
   --  then. If you instantiate it at a nested level, the compiler
   --  will always generate code for it, even if the routine is
   --  inlined.

   generic
      Crystal_Hertz : Long_Long_Integer;
   procedure Generic_Busy_Wait_Milliseconds (Wait : Unsigned_16);

   generic
      Crystal_Hertz : Long_Long_Integer;
   procedure Generic_Busy_Wait_Seconds (Wait : Unsigned_16);
   --  Simple minded busy delay loops that use the above
   --  Generic_Wait_USecs.  Beware that any interrupt activity adds to
   --  the specified delay.

private

   pragma Inline_Always (Wait_3_Cycles);
   pragma Inline_Always (Wait_4_Cycles);
   pragma Inline_Always (Generic_Wait_USecs);
   pragma Import (Intrinsic, Wait_Cycles, "__builtin_avr_delay_cycles");

end AVR.Wait;
