with Interfaces;                   use Interfaces;
with AVR.Strings.Edit.Generic_Integers;

package AVR.Strings.Edit.Integers is
   pragma Preelaborate;


   --  the base of the integer to be read or read. The most common
   --  values are 10 (default), 16, or 2.
   subtype Number_Base is Generic_Integers.Number_Base;


   -- Get -- Get an integer number from the string
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
   --  procedure Get is new Generic_Integers.Get_I (Integer_64);
   procedure Get is new Generic_Integers.Get_I (Integer_32);
   procedure Get is new Generic_Integers.Get_I (Integer_16);
   procedure Get is new Generic_Integers.Get_I (Integer_8);
   --  procedure Get is new Generic_Integers.Get_U (Unsigned_64);
   procedure Get is new Generic_Integers.Get_U (Unsigned_32);
   procedure Get is new Generic_Integers.Get_U (Unsigned_16);
   procedure Get is new Generic_Integers.Get_U (Unsigned_8);

   --
   -- Put -- Put an integer into a string
   -- Put_I (Value   : in Number_T;
   --        Field   : in All_Edit_Index_T := 0;
   --        Justify : in Alignment := Left;
   --        Fill    : in Character := ' ');
   -- Put_U (Value   : in Number_T;
   --        Base    : in Number_Base := 10;
   --        Field   : in All_Edit_Index_T := 0;
   --        Justify : in Alignment := Left;
   --        Fill    : in Character := ' ');
   --
   --      Value       - The value to be put
   --      Base        - The base used for the output (only for Unsigned_XX)
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
   procedure Put is new Generic_Integers.Generic_Put_I (Integer_32);
   procedure Put is new Generic_Integers.Generic_Put_I (Integer_16);
   procedure Put is new Generic_Integers.Generic_Put_I (Integer_8);
   procedure Put is new Generic_Integers.Generic_Put_U (Unsigned_32);
   procedure Put is new Generic_Integers.Generic_Put_U (Unsigned_16);
   procedure Put is new Generic_Integers.Generic_Put_U (Unsigned_8);

end AVR.Strings.Edit.Integers;
