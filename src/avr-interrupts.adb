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


package body AVR.Interrupts is


   SREG : Unsigned_8;
   for SREG'Address use 16#5F#;
   pragma Volatile (SREG);


   function Save_And_Disable return Unsigned_8 is
      Status : constant Unsigned_8 := SREG;
   begin
      Disable_Interrupts;
      return Status;
   end Save_And_Disable;


   procedure Restore (Old_Status : Unsigned_8) is
   begin
      SREG := Old_Status;
   end Restore;


   Saved_SREG : Unsigned_8;

   procedure Save_And_Disable is
   begin
      Saved_SREG := Save_And_Disable;
   end Save_And_Disable;


   procedure Restore is
   begin
      Restore (Saved_SREG);
   end Restore;


end AVR.Interrupts;
