--  PM_Strings are text strings stored in program memory.  As such
--  they are essentially constants.  They can only be sent to an
--  output stream.

with AVR;                          use AVR;
with AVR.Programspace;             use AVR.Programspace;

package AVR.Strings.Progmem is
   pragma Preelaborate;


   type Progmem_String is new AVR_String
     with Linker_Section => ".progmem";
   --  gcc-4.5.1: "pragma "LINKER_SECTION" applies only to objects"
   --  AdaCore implemented Linker_Section for types in gcc-4.9 on
   --  request of AVR-Ada [J121-006 public].


   type Text_In_Progmem (Len : Nat8) is record
      Text : AVR_String(1..Len);
   end record
     with Linker_Section => ".progmem";


   --  a handle to the string in program memory (=flash)
   type PM_String is new Program_Address; -- access Text_In_Progmem;
   Nil : constant PM_String;


   --  function To_String (Text : PM_String) return AVR_String;
   function Length (Text : PM_String) return Nat8;
   procedure To_String (Text : PM_String; Text_Out : out AVR_String);
   --  In order to avoid using the secondary stack we provide the two
   --  routines above.  You first have to determine the length, than
   --  you can create an appropriate variable on the client side and
   --  convert the PM_String to a string in RAM.


   --  iterate over all characters in the string and apply the Put.
   --  Mostly used for output.
   generic
      with procedure Put (C : Character);
   procedure Generic_Put (T : PM_String);


private

   Nil : constant PM_String := 0;

end AVR.Strings.Progmem;
