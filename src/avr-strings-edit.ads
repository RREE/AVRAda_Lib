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

package AVR.Strings.Edit is
   pragma Preelaborate;

   --  we use global variables for the input and output buffers
   Edit_Buffer_Length  : constant := 60;

   subtype All_Edit_Index_T is Unsigned_8 range 0 .. Edit_Buffer_Length+1;
   subtype Edit_Index_T is All_Edit_Index_T range 1 .. Edit_Buffer_Length;
   subtype Edit_Buffer_T is AVR_String (Edit_Index_T);

   type Edit_String is private;
   function Length (Text : Edit_String) return All_Edit_Index_T;
   function First (Text : Edit_String) return All_Edit_Index_T;
   function Last (Text : Edit_String) return All_Edit_Index_T;

   --------------------------------------------------------------------------

   Input_Line  : aliased Edit_Buffer_T;   --  buffer for all input
   Input_Ptr   : All_Edit_Index_T;        --  current location of parsing
   Input_Last  : All_Edit_Index_T;        --  end marker of input

   --  Skip all leading occurences of the specified character.  It
   --  advances the Input_Ptr to the first non-specified character or
   --  to the end of the Input_Line.
   procedure Skip (Blank : Character := ' ');

   --  Input_Ptr is advanced to the first Stop character or to
   --  Input_Buffer_Length + 1.
   procedure Get_Str (Stop : Character := ' ');
   function Get_Str (Stop : Character := ' ') return Edit_String;

   ---------------------------------------------------------------------

   Output_Line : aliased Edit_Buffer_T;
   Output_Last : All_Edit_Index_T;

   -- Put -- Put a character into a string
   --
   --    Value       - The character to be put
   --    Field       - The output field
   --    Justify     - Alignment within the field
   --    Fill        - The fill character
   --
   --  This procedure places the specified character or string Value
   --  into the Output_Line. Value is written starting from the
   --  Output_Last.  Put_Line appends a ASCII.LF character.
   procedure Put (Value   : Character;
                  Field   : All_Edit_Index_T := 0;
                  Justify : Alignment := Left;
                  Fill    : Character := ' ');
   procedure Put (Value   : AVR_String;
                  Field   : All_Edit_Index_T := 0;
                  Justify : Alignment := Left;
                  Fill    : Character := ' ');
   procedure Put (Value   : PM_String;
                  Field   : All_Edit_Index_T := 0;
                  Justify : Alignment := Left;
                  Fill    : Character := ' ');
   procedure Put (Value   : Edit_String;
                  Field   : All_Edit_Index_T := 0;
                  Justify : Alignment := Left;
                  Fill    : Character := ' ');
   procedure Put_Line (Value   : AVR_String;
                       Field   : All_Edit_Index_T := 0;
                       Justify : Alignment := Left;
                       Fill    : Character := ' ');
   procedure New_Line;  --  only line-feed (LF)
   procedure CRLF;      --  DOS like CR & LF
   procedure Reset_Output -- reset output line
     with Inline;

   generic
      with procedure Put_Raw (Value : Unsigned_8);
   procedure Flush_Output;

private

   type Edit_String is record
      First : Edit_Index_T;
      Last  : Edit_Index_T;
   end record;

end AVR.Strings.Edit;
