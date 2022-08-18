

package AVR.Strings.Search is
   pragma Pure;

   function Index
     (Source   : in AVR_String;
      Pattern  : in AVR_String;
      Going    : in Direction := Forward)
      return     Unsigned_8;

   function Index
     (Source   : in AVR_String;
      Pattern  : in Character;
      Going    : in Direction := Forward)
      return     Unsigned_8;

   function Index_Non_Blank
     (Source : in AVR_String;
      Going  : in Direction := Forward)
     return   Unsigned_8;

   function Count
     (Source   : in AVR_String;
      Pattern  : in AVR_String)
      return     Unsigned_8;

   function Count
     (Source   : in AVR_String;
      Pattern  : in Character)
     return     Unsigned_8;

end AVR.Strings.Search;
