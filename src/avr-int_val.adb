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

--  internal package for converting strings to numbers.

with Interfaces;                use Interfaces;
with AVR.Strings;               use AVR.Strings;

package body AVR.Int_Val is

   function U8_Value_Str2 (Img : AStr2) return Unsigned_8
   is
      V : Unsigned_8;
      C1 : Character renames Img (Img'First);
      C2 : Character renames Img (Img'First+1);
   begin
      if C1 in '0' .. '9' then
         V := Character'Pos (C1) - Character'Pos ('0');
      else
         V := 0;
      end if;

      if C2 in '0' .. '9' then
         V := 10*V + Character'Pos (C2) - Character'Pos ('0');
      else
         V := 0;
      end if;
      return V;
   end U8_Value_Str2;


   function U8_Value_Str3 (Img : AStr3) return Unsigned_8
   is
      V : Unsigned_8;
      C3 : Character renames Img (Img'First+2);
   begin
      V := U8_Value_Str2 (Img (Img'First .. Img'First+1));
      if C3 in '0' .. '9' then
         V := 10*V + Character'Pos (C3) - Character'Pos ('0');
      end if;

      return V;
   end U8_Value_Str3;

end AVR.Int_Val;
