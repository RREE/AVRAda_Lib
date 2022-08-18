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

with Interfaces;                   use Interfaces;
with AVR.Strings;                  use AVR.Strings;
with AVR.Strings.Progmem;          use AVR.Strings.Progmem;


generic
   with procedure Put_Raw (Value : Unsigned_8);
   with function Get_Raw return Unsigned_8;
   with procedure Flush;
package AVR.Generic_Text_IO is
   pragma Preelaborate;

   --  used for interfacing with C
   --  can put out a C like zero ended string
   type Chars_Ptr is access all Character;
   pragma No_Strict_Aliasing (Chars_Ptr);

   --  Output routines
   procedure Put (Ch : Character);
   procedure Put_Char (Ch : Character) renames Put;

   procedure Put (S : AVR_String);
   procedure Put (S : PM_String);
   procedure Put_C (S : Chars_Ptr);
   procedure Put (S : Chars_Ptr) renames Put_C;
   procedure Put_Edited;
   procedure Put renames Put_Edited;

   procedure Put_Line (S : AVR_String);
   procedure Put_Line (S : Chars_Ptr);

   procedure New_Line;  --  only line-feed (LF)
   procedure CRLF;      --  DOS like CR & LF

   --  Input routines
   function Get return Character;
   procedure Get_Raw (Byte : out Unsigned_8);
   procedure Get_Line (S    : out AVR_String;
                       Last : out Unsigned_8);
   procedure Get_Input_Line;

private

   pragma Inline_Always (Get);
   pragma Inline_Always (Get_Raw);
   pragma Inline_Always (Put_Char);

   pragma Inline (New_Line);
   pragma Inline (CRLF);

end AVR.Generic_Text_IO;
