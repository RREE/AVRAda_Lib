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

with System;

package body AVR.Int_Img is


   procedure U16_Div_10 (Dividend  : in  Unsigned_16;
                         Result    : out Unsigned_16;
                         Remainder : out Unsigned_8)
   is
   begin
      Result := Dividend / 10;
      Remainder := Unsigned_8 (Dividend rem 10);
   end U16_Div_10;


   procedure U8_Div_10 (Dividend  : in  Unsigned_8;
                        Result    : out Unsigned_8;
                        Remainder : out Unsigned_8)
   is
   begin
      Result := Dividend / 10;
      Remainder := Dividend rem 10;
   end U8_Div_10;
   pragma Unreferenced (U8_Div_10);


   procedure Nibble_Hex_Img (Data : Unsigned_8; Target : out Character)
   is
   begin
      if Data < 10 then
         Target := Character'Val (Data + 48);
      else
         Target := Character'Val (Data + 55);
      end if;
   end Nibble_Hex_Img;


   Dig_8  : constant AVR.Nat8_Array  := (100, 10); pragma Unreferenced (Dig_8);
   Dig_16 : constant AVR.Nat16_Array  := (10_000, 1_000, 100, 10);
   Dig_32 : constant AVR.Nat32_Array :=
     (1_000_000_000, 100_000_000, 10_000_000,
      1_000_000, 100_000, 10_000, 1_000, 100, 10);


   procedure U8_Img (Data : Unsigned_8;
                     Target : out AStr3; Last : out Unsigned_8)
   is
      U16_Str : AStr5;
   begin
      U16_Img (Unsigned_16 (Data), U16_Str, Last);
      -- Target (Target'First .. Target'First+Last-1) := U16_Str (1..Last);
      for I in Unsigned_8'(0) .. Last - 1 loop
         Target (Target'First + I) := U16_Str (1 + I);
      end loop;
   end U8_Img;


   procedure C_Itoa (Val : Integer_16; S : System.Address; Radix : Integer);
   pragma Import (C, C_Itoa, "itoa");

   procedure U8_Img_C (Data : Unsigned_8;
                       Target : out AStr3; Last : out Unsigned_8)
   is
   begin
      C_Itoa (Integer_16 (Data), Target'Address, 10);
      if Data < 10 then
         Last := Target'First;
      elsif Data < 100 then
         Last := Target'First + 1;
      else
         Last := Target'First + 2;
      end if;
   end U8_Img_C;


   procedure U8_Img_Right (Data : Unsigned_8; Target : out AStr3)
   is
      D : Unsigned_8 := Data;
   begin
      if D >= 100 then
         Target (Target'First) := Character'Val (48 + (D / 100));
         D := D rem 100;
      else
         Target (Target'First) := ' ';
      end if;

      if D >= 10 or else Data >= 100 then
         Target (Target'First + 1) := Character'Val (48 + (D / 10));
      else
         Target (Target'First + 1) := ' ';
      end if;

      Target (Target'First + 2)  := Character'Val (48 + (D rem 10));
   end U8_Img_Right;


   --  put text representation of decimal number < 100 into target
   --  string with a leading 0 for numbers < 10.
   procedure U8_Img_99_Right (Data : Unsigned_8; Target : out AStr2)
   is begin
      if Data >= 100 then return; end if;
      Target (Target'First) := Character'Val (48 + (Data / 10));
      Target (Target'First + 1) := Character'Val (48 + (Data rem 10));
   end U8_Img_99_Right;


   --  put text representation of hexadecimal number into target
   --  string with a leading 0 for numbers < 16.
   procedure U8_Hex_Img (Data : Unsigned_8; Target : out AStr2)
   is
   begin
      Nibble_Hex_Img (Data and 16#0F#, Target (Target'Last));
      Nibble_Hex_Img (Data / 16, Target (Target'First));
   end U8_Hex_Img;


   --  put text representation of decimal number Data into Target
   --  string beginning at the left most character.
   procedure U16_Img_Orig (Data : Unsigned_16;
                           Target : out AStr5; Last : out Unsigned_8) is
      Val     : Unsigned_16 := Data;
      D       : Unsigned_8;
      Is_Zero : Boolean := True;
   begin
      Last := Target'First;
      for J in Dig_16'Range loop
         D := 0;
         while Val >= Dig_16 (J) loop
            D := D + 1;
            Val := Val - Dig_16 (J);
            Is_Zero := False;
         end loop;
         if not Is_Zero then
            Target (Last) := Character'Val (48 + D);
            Last := Last + 1;
         end if;
      end loop;
      Target (Last) := Character'Val (48 + Val);
   end U16_Img_Orig;
   pragma Unreferenced (U16_Img_Orig);

   procedure U16_Img (Data : Unsigned_16;
                      Target : out AStr5; Last : out Unsigned_8) is
      Img : AStr10;
   begin
      U32_Img (Unsigned_32 (Data), Img, Last);
      Target := Img (1..5);
      Last := Last + Target'First - 1;
   end U16_Img;


   procedure U16_Img_New (Data : Unsigned_16;
                      Target : out AStr5; Last : out Unsigned_8) is
      Tmp_Img : AStr5;
      L       : Unsigned_8 := 1;
   begin
      U16_Img_Right (Data, Tmp_Img);
      while Tmp_Img (L) = ' ' loop
         L := L + 1;
      end loop;
      Last := Target'Last - L + 1;
      Target (Target'First .. Last) := Tmp_Img (L .. 5);
   end U16_Img_New;
   pragma Unreferenced (U16_Img_New);

   --  put text representation of decimal number Data into Target
   --  string right aligned.  Leading characters are filled with
   --  blanks.
   procedure U16_Img_Right_Old (Data : Unsigned_16; Target : out AStr5)
   is
      L : constant Unsigned_8 := Target'Last;
      subtype Target_Index is Unsigned_8 range 0 .. AStr5'Last;
      LI  : Target_Index;
   begin
      U16_Img (Data, Target, LI);
      if LI < Target'Last then
         for I in reverse Target'Range loop
            if I <= L - LI then
               Target (I) := ' ';
            else
               Target (I) := Target (I - (L-LI));
            end if;
         end loop;
      end if;
   end U16_Img_Right_Old;
   pragma Unreferenced (U16_Img_Right_Old);

   procedure U16_Img_Right (Data : Unsigned_16; Target : out AStr5)
   is
      D : Unsigned_16;
      R : Unsigned_8;
      Nil : Boolean := False;
   begin
      D := Data;
      for L in reverse Target'Range loop
         U16_Div_10 (D, D, R);
         if not Nil then
            Target (L) := Character'Val (48 + R);
         else
            Target (L) := ' ';
         end if;
         if D = 0 then Nil := True; end if;
      end loop;
   end U16_Img_Right;


   --  put text representation of decimal number Data into Target
   --  string beginning at the left most character.
   procedure U32_Img (Data   : Unsigned_32;
                      Target : out AStr10; Last : out Unsigned_8)
   is
      Val     : Unsigned_32 := Data;
      D       : Unsigned_8;
      Is_Zero : Boolean := True;
   begin
      Last := Target'First;
      for J in Dig_32'Range loop
         D := 0;
         while Val >= Dig_32 (J) loop
            D := D + 1;
            Val := Val - Dig_32 (J);
            Is_Zero := False;
         end loop;
         if not Is_Zero then
            Target (Last) := Character'Val (48 + D);
            Last := Last + 1;
         end if;
      end loop;
      Target (Last) := Character'Val (48 + Val);
   end U32_Img;


end AVR.Int_Img;
