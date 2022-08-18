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

--  internal package for converting numbers to strings.
--  The package is used in all IO packages


with AVR.Strings;               use AVR.Strings;

package AVR.Int_Img is
   pragma Pure;

   --  convert low nibble of Data into a hexadecimal character
   --  representation.
   procedure Nibble_Hex_Img (Data : Unsigned_8; Target : out Character);
   pragma Inline (Nibble_Hex_Img);

   --  put text representation of decimal number Data into Target
   --  string beginning at the left most character.
   procedure U8_Img (Data : Unsigned_8;
                     Target : out AStr3; Last : out Unsigned_8);
   procedure U8_Img_C (Data : Unsigned_8;
                       Target : out AStr3; Last : out Unsigned_8);
   --  U8_Img uses our own implementation in pure Ada, U8_Img_C relies
   --  upon the itoa function of avr-libc.

   --  put text representation of decimal number Data into Target
   --  string right aligned.
   procedure U8_Img_Right (Data : Unsigned_8; Target : out AStr3);

   --  put text representation of decimal number Data into Target
   --  string beginning at the left most character.
   procedure U16_Img (Data : Unsigned_16; Target : out AStr5; Last : out Unsigned_8);

   --  put text representation of decimal number Data into Target
   --  string right aligned.  Leading characters are filled with
   --  blanks.
   procedure U16_Img_Right (Data : Unsigned_16; Target : out AStr5);

   --  put text representation of decimal number Data into Target
   --  string beginning at the left most character.
   procedure U32_Img (Data   : Unsigned_32;
                      Target : out AStr10; Last : out Unsigned_8);

   --  put text representation of decimal number Data < 100 into
   --  Target string with a leading 0 for numbers < 10.
   procedure U8_Img_99_Right (Data : Unsigned_8; Target : out AStr2);

   --  put text representation of hexadecimal number Data into Target
   --  string with a leading 0 for numbers < 16.
   procedure U8_Hex_Img (Data : Unsigned_8; Target : out AStr2);

end AVR.Int_Img;
