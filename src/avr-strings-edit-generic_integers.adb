with Interfaces;                   use Interfaces;

package body AVR.Strings.Edit.Generic_Integers is


   function Get_Digit (C : Character) return Unsigned_8
   is
   begin
      if C in '0' .. '9' then
         return Character'Pos (C) - 48;
      elsif C in 'a' .. 'f' then
         return Character'Pos (C) - 87;
      elsif C in 'A' .. 'F' then
         return Character'Pos (C) - 55;
      else
         return 16;
      end if;
   end Get_Digit;


   procedure Get_U32 (Value : out Unsigned_32;
                      Base  : in Number_Base := 10)
   is
      Radix : constant Unsigned_32 := Unsigned_32(Base);
      Digit : Nat8;
   begin
      if Input_Line(Input_Ptr) = '+' then
         Input_Ptr := Input_Ptr + 1;
      end if;

      Value := 0;
      while Input_Ptr <= Input_Last loop
         Digit := Get_Digit (Input_Line(Input_Ptr));
         exit when Digit >= Nat8(Base);
         Value := Value * Radix;
         Value := Value + Unsigned_32(Digit);
         Input_Ptr := Input_Ptr + 1;
      end loop;
   end Get_U32;


   -- Get -- Get an integer number from the Input_Line
   --
   --      Value   - The result
   --      Base    - The base of the expected number
   --      ToFirst - Force value to First instead of exception
   --      ToLast  - Force value to Last instead of exception
   --
   -- This procedure gets an integer number from the Input_Line. The
   -- process starts at Input_Line (Input_Ptr). The parameter Base
   -- indicates the base of the expected number.
   --
   procedure Get_I (Value   : out Number_T;
                    Base    : in Number_Base := 10)
   is
      Is_Negative : Boolean := False;
      --  Digit       : Nat8;
   begin
      --  if Input_Line(Input_Ptr) = '+' then
      --     Input_Ptr := Input_Ptr + 1;
      --  elsif Input_Line(Input_Ptr) = '-' then
      if Input_Line(Input_Ptr) = '-' then
         Is_Negative := True;
         Input_Ptr := Input_Ptr + 1;
      end if;

      Get_U32 (Unsigned_32(Value), Base);

      if Is_Negative then
         Value := - Value;
      end if;
   end Get_I;


   procedure Get_U (Value   : out Number_T;
                    Base    : in Number_Base := 10)
   is
   begin
      Get_U32 (Unsigned_32(Value), Base);
   end Get_U;


   procedure Put_U32 (Value   : in Unsigned_32;
                      Base    : in Number_Base := 10;
                      Target  : in out AStr11;
                      Last    : out Unsigned_8)
   is
      use System.Int_Img;
      Len : All_Edit_Index_T;
   begin
      Len := U32_Img (Value,
                      Target(Target'First+1)'Unchecked_Access,
                      Base);
      Last := Target'First + Len;
   end Put_U32;


   -- Put -- Put an integer into the Output_Line
   --
   --      Value       - The value to be put
   --      Base        - The base used for the output
   --      Field       - The output field
   --      Justify     - Alignment within the field
   --      Fill        - The fill character
   --
   -- This procedure places the number specified  by  the  parameter  Value
   -- into  the  Output_Line. The string is written starting
   -- from  Output_Line (Output_Ptr). The parameter Base indicates the number
   -- base used for the output. The base itself  does  not  appear  in  the
   -- output.
   --
   -- Example :
   --
   --      Put (5, 2, 10, Center, '@');
   --
   --      Now the Output_Line is "@@@+101@@@##########", Output_Ptr = 11
   --
   procedure Generic_Put_I (Value   : in Number_T;
                            Field   : in All_Edit_Index_T := 0;
                            Justify : in Alignment := Left;
                            Fill    : in Character := ' ')
   is
      Is_Negative : constant Boolean := (Value < 0);
      Pos_Value   : constant Number_T := abs(Value);
      Value_Img   : AStr11;
      Last        : Edit_Index_T;
   begin
      Put_U32 (Unsigned_32(Pos_Value), 10, Value_Img, Last);
      if Is_Negative then
         Value_Img(1) := '-';
         Put (Value_Img (1..Last), Field, Justify, Fill);
      else
         Put (Value_Img (2..Last), Field, Justify, Fill);
      end if;
   end Generic_Put_I;


   procedure Generic_Put_U (Value   : in Number_T;
                            Base    : in Number_Base := 10;
                            Field   : in All_Edit_Index_T := 0;
                            Justify : in Alignment := Left;
                            Fill    : in Character := ' ')
   is
      Value_Img : AStr11;
      Last      : Edit_Index_T;
   begin
      Put_U32 (Unsigned_32(Value), Base, Value_Img, Last);
      Put (Value_Img (2..Last), Field, Justify, Fill);
   end Generic_Put_U;

end AVR.Strings.Edit.Generic_Integers;
