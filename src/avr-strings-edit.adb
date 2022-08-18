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

with AVR.Strings.Progmem;          use AVR.Strings.Progmem;

package body AVR.Strings.Edit is


   function Length (Text : Edit_String) return All_Edit_Index_T is
   begin
      return Text.Last - Text.First + 1;
   end Length;


   function First (Text : Edit_String) return All_Edit_Index_T is
   begin
      return Text.First;
   end First;


   function Last (Text : Edit_String) return All_Edit_Index_T is
   begin
      return Text.Last;
   end Last;


   --  This procedure skips the blank characters starting from
   --  Input_Line(Input_Ptr).  Input_Ptr is advanced to the first
   --  non-blank character or to Input_Buffer_Length + 1.
   procedure Skip (Blank : Character := ' ') is
   begin
      while Input_Line (Input_Ptr) = Blank loop
         Input_Ptr := Input_Ptr + 1;
         exit when Input_Ptr > Input_Last;
      end loop;
   end Skip;


   procedure Get_Str (Stop : Character := ' ') is
   begin
      while Input_Line(Input_Ptr) /= Stop loop
         Input_Ptr := Input_Ptr + 1;
         exit when Input_Ptr > Input_Last;
      end loop;
   end Get_Str;


   function Get_Str (Stop : Character := ' ') return Edit_String is
      Word : Edit_String;
   begin
      Skip;
      Word.First := Input_Ptr;
      Get_Str (Stop);
      Word.Last := Input_Ptr - 1;
      return Word;
   end Get_Str;


   --  Append -- put a character to the output string
   --            it is like Put (Value, field = 1, Justify = Left)
   procedure Append (Value : Character)
   is
   begin
      Output_Line (Output_Last) := Value;
      Output_Last := Output_Last + 1;
   end Append;


   -- Put -- Put a character into a string
   --
   --    Value       - The character to be put
   --    Field       - The output field
   --    Justify     - Alignment within the field
   --    Fill        - The fill character
   --
   --  This procedure places the specified character Value into the
   --  Output_Line. The character is written at Output_Last.
   procedure Put (Value       : Character;
                  Field       : All_Edit_Index_T := 0;
                  Justify     : Alignment := Left;
                  Fill        : Character := ' ')
   is
   begin
      if Field > 1 then
         if Output_Last + Field > All_Edit_Index_T'Last then
            -- error;
            raise Constraint_Error;
            -- return;
         else
            if Justify = Right then
               for I in 1 .. Field - 1 loop
                  Output_Line (Output_Last) := Fill;
                  Output_Last := Output_Last + 1;
               end loop;
            end if;
         end if;
      end if;

      -- in all cases we append the Value
      Output_Line (Output_Last) := Value;
      Output_Last := Output_Last + 1;

      if Justify = Left and then Field > 1 then
         for Pos in 1 .. Field-1 loop
            Output_Line (Output_Last) := Fill;
            Output_Last := Output_Last + 1;
         end loop;
      end if;
   end Put;


   procedure Put (Value       : AVR_String;
                  Field       : All_Edit_Index_T := 0;
                  Justify     : Alignment := Left;
                  Fill        : Character := ' ')
   is
      Value_Length : constant All_Edit_Index_T := Value'Length;
   begin
      if Field > Value_Length then
         if Output_Last + Field > All_Edit_Index_T'Last then
            -- error;
            return;
         else
            if Justify = Right then
               for I in Value_Length .. Field - 1 loop
                  Output_Line (Output_Last) := Fill;
                  Output_Last := Output_Last + 1;
               end loop;
            end if;
         end if;
      end if;
      -- in all cases we append the Value
      Output_Line(Output_Last..Output_Last+Value_Length-1) := Value;
      Output_Last := Output_Last + Value_Length;

      if Justify = Left and then Field > Value_Length then
         for I in Value_Length .. Field - 1 loop
            Output_Line (Output_Last) := Fill;
            Output_Last := Output_Last + 1;
         end loop;
      end if;
   end Put;


   procedure Put (Value   : PM_String;
                  Field   : All_Edit_Index_T := 0;
                  Justify : Alignment := Left;
                  Fill    : Character := ' ')
   is
      Value_Length : constant Nat8 := Length (Value);
      Str : AVR_String (1 .. Value_Length);
   begin
      To_String (Value, Str);
      Put (Str, Field, Justify, Fill);
   end Put;


   procedure Put (Value       : Edit_String;
                  Field       : All_Edit_Index_T := 0;
                  Justify     : Alignment := Left;
                  Fill        : Character := ' ')
   is
   begin
      Put (Input_Line (Value.First .. Value.Last), Field, Justify, Fill);
   end Put;


   procedure Put_Line (Value       : AVR_String;
                       Field       : All_Edit_Index_T := 0;
                       Justify     : Alignment := Left;
                       Fill        : Character := ' ')
   is
   begin
      Put (Value, Field, Justify, Fill);
      New_Line;
   end Put_Line;


   procedure New_Line  --  only line-feed (LF)
   is
      EOL : constant Character := Character'Val(16#0A#);
   begin
      Append (EOL);
   end New_Line;


   procedure CRLF is   --  DOS like CR & LF
      LF : constant Character := Character'Val(16#0A#);
      CR : constant Character := Character'Val(16#0D#);
   begin
      Append (CR);
      Append (LF);
   end CRLF;


   -- reset output line
   procedure Reset_Output is
   begin
      Output_Last := 1;
   end Reset_Output;


   procedure Flush_Output is
   begin
      for I in 1 .. Output_Last - 1 loop
         Put_Raw (Unsigned_8(Character'Pos(Output_Line(I))));
      end loop;
      Output_Last := 1;
   end Flush_Output;

end AVR.Strings.Edit;
