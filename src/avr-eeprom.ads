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

--  read and write the on-chip EEprom.

with System;
with AVR.MCU;

package AVR.EEprom is
   pragma Preelaborate;


   subtype EEprom_Address is System.Address
     range 0 .. AVR.MCU.E2end;


   --  read a value from the specified address
   function Get (Address : EEprom_Address) return Unsigned_8;
   function Get (Address : EEprom_Address) return Character;
   function Get (Address : EEprom_Address) return Unsigned_16;
   function Get (Address : EEprom_Address) return Unsigned_32;
   function Get (Address : EEprom_Address) return Integer_8;
   function Get (Address : EEprom_Address) return Integer_16;
   function Get (Address : EEprom_Address) return Integer_32;
   procedure Get (Address : EEprom_Address; Data : out Nat8_Array);
   --  generic
   --     type T is limited private;
   --  procedure Generic_Get (Address : EEprom_Address; Data : out T);

   --  store a value at the address
   procedure Put (Address : EEprom_Address; Data : Unsigned_8);
   procedure Put (Address : EEprom_Address; Data : Character);
   procedure Put (Address : EEprom_Address; Data : Unsigned_16);
   procedure Put (Address : EEprom_Address; Data : Unsigned_32);
   procedure Put (Address : EEprom_Address; Data : Integer_8);
   procedure Put (Address : EEprom_Address; Data : Integer_16);
   procedure Put (Address : EEprom_Address; Data : Integer_32);
   procedure Put (Address : EEprom_Address; Data : Nat8_Array);

end AVR.EEprom;
