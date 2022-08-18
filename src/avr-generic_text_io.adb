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

with System;                       use type System.Address;
with Interfaces;                   use Interfaces;
with Ada.Unchecked_Conversion;
with AVR.Strings;                  use AVR.Strings;
with AVR.Strings.Edit;


package body AVR.Generic_Text_IO is


   function To_U8 is new Ada.Unchecked_Conversion (Source => Character,
                                                   Target => Unsigned_8);

   --  Output routines
   procedure Put (Ch : Character) is
   begin
      Put_Raw (To_U8 (Ch));
   end Put;


   procedure Put (S : AVR_String) is
   begin
      for I in S'Range loop
         Put (S (I));
      end loop;
   end Put;


   procedure Put_Edited_Inst is new Edit.Flush_Output (Put_Raw);
   procedure Put_Edited renames Put_Edited_Inst;


   procedure Put_Inst is new Strings.Progmem.Generic_Put (Put);
   procedure Put (S : PM_String) renames Put_Inst;


   --  pointer calculation for putting C like zero ended strings
   function "+" (L : Chars_Ptr; R : Unsigned_16) return Chars_Ptr;
   pragma Inline ("+");

   function "+" (L : Chars_Ptr; R : Unsigned_16) return Chars_Ptr is
      function Addr is new Ada.Unchecked_Conversion (Source => Chars_Ptr,
                                                     Target => Unsigned_16);
      function Ptr is new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                                    Target => Chars_Ptr);
   begin
      return Ptr (Addr (L) + R);
   end "+";

   procedure Put_C (S : Chars_Ptr) is
      P : Chars_Ptr := S;
   begin
      if P = null then return; end if;
      while P.all /= ASCII.NUL loop
         Put (P.all);
         P := P + 1;
      end loop;
   end Put_C;


   procedure Put_Line (S : AVR_String) is
   begin
      Put (S);
      New_Line;
   end Put_Line;


   procedure Put_Line (S : Chars_Ptr) is
   begin
      Put_C (S);
      New_Line;
   end Put_Line;


   procedure New_Line is
      EOL : constant := 16#0A#;
   begin
      Put_Raw (EOL);
   end New_Line;


   procedure CRLF is
      LF : constant := 16#0A#;
      CR : constant := 16#0D#;
   begin
      Put_Raw (CR);
      Put_Raw (LF);
   end CRLF;


   --  Input routines
   function Get return Character is
      function To_Char is new Ada.Unchecked_Conversion (Target => Character,
                                                        Source => Unsigned_8);
   begin
      return To_Char (Get_Raw);
   end Get;


   procedure Get_Raw (Byte : out Unsigned_8) is
   begin
      Byte := Get_Raw;
   end Get_Raw;


   procedure Get_Line (S    : out AVR_String;
                       Last : out Unsigned_8)
   is
      C : Character;
   begin
      for I in S'First .. S'Last loop
         C := Get;
         if C = ASCII.CR or C = ASCII.LF then
            Last :=  I - 1;
            return;
         else
            S (I) := C;
         end if;
      end loop;
      Last := S'Last;

      return;
   end Get_Line;


   procedure Get_Input_Line
   is
      C : Character;
   begin
      Edit.Input_Ptr  := 0;
      Edit.Input_Last := 0;
      loop
         Edit.Input_Ptr := Edit.Input_Ptr + 1;
         C := Get;
         if C = ASCII.LF or else C = ASCII.CR then
            exit;
         else
            Edit.Input_Line(Edit.Input_Ptr) := C;
         end if;
      end loop;
   end Get_Input_Line;


end AVR.Generic_Text_IO;
