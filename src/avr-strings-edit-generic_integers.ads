pragma Warnings (Off, "* is an internal GNAT unit");
with System.Int_Img;
pragma Warnings (On,  "* is an internal GNAT unit");

package AVR.Strings.Edit.Generic_Integers is
   pragma Preelaborate;


   --  the base of the integer to be read or written. The most common
   --  values are 10 (default), 16, or 2.
   subtype Number_Base is System.Int_Img.Radix_Range;


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
   generic
      type Number_T is range <>;
   procedure Get_I (Value : out Number_T;
                    Base  : in Number_Base := 10);

   generic
      type Number_T is mod <>;
   procedure Get_U (Value : out Number_T;
                    Base  : in Number_Base := 10);


   --  Put -- put an Unsigned number into the buffer Target.  Last is
   --  the index of the last valid character in Target.  A string of
   --  length 10 can hold all numbers up to 2^32 base 10. So don't use
   --  if for base 2!
   procedure Put_U32 (Value  : in Unsigned_32;
                      Base   : in Number_Base := 10;
                      Target : in out AStr11;
                      Last   : out Unsigned_8);

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
   --  Integer numbers are always printed on base 10.  All systems
   --  that I know don't print negative numbers for other bases than
   --  10.
   generic
      type Number_T is range <>;
   procedure Generic_Put_I (Value   : in Number_T;
                            Field   : in All_Edit_Index_T := 0;
                            Justify : in Alignment := Left;
                            Fill    : in Character := ' ');

   generic
      type Number_T is mod <>;
   procedure Generic_Put_U (Value   : in Number_T;
                            Base    : in Number_Base := 10;
                            Field   : in All_Edit_Index_T := 0;
                            Justify : in Alignment := Left;
                            Fill    : in Character := ' ');

private

   -- declared here for unit testing
   function Get_Digit (C : Character) return Unsigned_8;

end AVR.Strings.Edit.Generic_Integers;
