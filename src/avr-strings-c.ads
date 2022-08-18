package AVR.Strings.C is

   function "&" (L : String; R : AVR_String) return String;
   function "&" (L : AVR_String; R : String) return String;
   function "=" (L : String; R : AVR_String) return Boolean;
   function "=" (L : AVR_String; R : String) return Boolean;

end AVR.Strings.C;
