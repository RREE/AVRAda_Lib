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

--  this package provides access to constants stored in program memory

with System;

package AVR.Programspace is
   pragma Preelaborate;


   subtype Program_Address is System.Address;

   type Far_Program_Address is mod 2 ** 32;

   --  read bytes (8bit), Unsigned_16s (16bit) or double words (32bit) from
   --  an address in programm memory (flash).

   function Get_Byte (Addr : Program_Address) return Unsigned_8;
   function Get (Addr : Program_Address) return Unsigned_8 renames Get_Byte;
   function Get_Char (Addr : Program_Address) return Character;
   function Get (Addr : Program_Address) return Character renames Get_Char;
   function Get_Word (Addr : Program_Address) return Unsigned_16;
   function Get (Addr : Program_Address) return Unsigned_16 renames Get_Word;
   function Get_DWord (Addr : Program_Address) return Unsigned_32;
   function Get (Addr : Program_Address) return Unsigned_32 renames Get_DWord;

   function Get (Addr : Far_Program_Address) return Unsigned_8;
   function Get (Addr : Far_Program_Address) return Unsigned_16;
   function Get (Addr : Far_Program_Address) return Unsigned_32;

   procedure Inc (Addr : in out Program_Address); -- increment address by 1
   procedure Dec (Addr : in out Program_Address); -- decrement address by 1

private

   pragma Inline (Get);
   pragma Inline (Inc);
   pragma Inline (Dec);

end AVR.Programspace;
