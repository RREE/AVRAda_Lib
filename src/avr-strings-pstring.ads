------------------------------------------------------------------------------
--                                                                          --
--                          AVR RUN-TIME COMPONENTS                         --
--                                                                          --
--                  A V R . S T R I N G S . B O U N D E D                   --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
--          Copyright (C) 2005 R. Ebert                                     --
--                                                                          --
------------------------------------------------------------------------------


package AVR.Strings.PString is
   pragma Pure;


   generic
      Max : Pos8;

      --  Maximum length of a PString.  This implementation in the AVR
      --  hierarchy is limited to an absolute maximum of 255
      --  characters.
   package Generic_PString is
      --  pragma Preelaborate (Generic_Pstring);
      --  GNAT: "incorrect placement of pragma PREELABORATE"

      Max_Length : constant Pos8 := Max;

      subtype Length_Range is Unsigned_8 range 0 .. Max_Length;


      type PString is record
         Current_Length : Length_Range;
         Data           : AVR_String (1 .. Max_Length);
      end record;
      --  type PString is private;

      --  Null_PString : constant PString;

      function Length (Source : in PString) return Length_Range;

      --------------------------------------------------------
      -- Conversion, Concatenation, and Selection Functions --
      --------------------------------------------------------

      function To_PString (Source : in AVR_String) return PString;
      function "+" (Source : in AVR_String) return PString
        renames To_PString;
      pragma Pure_Function (To_PString);

      --  function To_String (Source : in Pstring) return AVR_String;

--        function Append (Left, Right : in Pstring)
--                        return        Pstring;

--        function Append
--          (Left  : in Pstring;
--           Right : in AVR_String)
--          return  Pstring;

--        function Append
--          (Left  : in AVR_String;
--           Right : in Pstring)
--          return  Pstring;

--        function Append
--          (Left  : in Pstring;
--           Right : in Character)
--          return  Pstring;

--        function Append
--          (Left  : in Character;
--           Right : in Pstring)
--          return  Pstring;

--        procedure Append
--          (Source   : in out Pstring;
--           New_Item : in Pstring);

--        procedure Append
--          (Source   : in out Pstring;
--           New_Item : in AVR_String);

--        procedure Append
--          (Source   : in out Pstring;
--           New_Item : in Character);

--        function "&"
--          (Left, Right : in Pstring)
--          return        Pstring;

--        function "&"
--          (Left  : in Pstring;
--           Right : in AVR_String)
--          return  Pstring;

--        function "&"
--          (Left  : in AVR_String;
--           Right : in Pstring)
--          return  Pstring;

--        function "&"
--          (Left  : in Pstring;
--           Right : in Character)
--          return  Pstring;

--        function "&"
--          (Left  : in Character;
--           Right : in Pstring)
--           return  Pstring;

      function Element
        (Source : in PString;
         Index  : in Pos8)
        return   Character;

--        procedure Replace_Element
--          (Source : in out Pstring;
--           Index  : in Pos8;
--           By     : in Character);

--        function Slice
--          (Source : in Pstring;
--           Low    : in Pos8;
--           High   : in Byte) -- permit a null array
--           return   Pstring;

--        function "="  (Left, Right : in Pstring) return Boolean;

--        function "="
--          (Left  : in Pstring;
--           Right : in AVR_String)
--           return  Boolean;

--        function "="
--          (Left  : in AVR_String;
--           Right : in Pstring)
--           return  Boolean;

--        function "<"  (Left, Right : in Pstring) return Boolean;

--        function "<"
--          (Left  : in Pstring;
--           Right : in AVR_String)
--           return  Boolean;

--        function "<"
--          (Left  : in AVR_String;
--           Right : in Pstring)
--           return  Boolean;

--        function "<=" (Left, Right : in Pstring) return Boolean;

--        function "<="
--          (Left  : in Pstring;
--           Right : in AVR_String)
--           return  Boolean;

--        function "<="
--          (Left  : in AVR_String;
--           Right : in Pstring)
--           return  Boolean;

--        function ">"  (Left, Right : in Pstring) return Boolean;

--        function ">"
--          (Left  : in Pstring;
--           Right : in AVR_String)
--           return  Boolean;

--        function ">"
--          (Left  : in AVR_String;
--           Right : in Pstring)
--           return  Boolean;

--        function ">=" (Left, Right : in Pstring) return Boolean;

--        function ">="
--          (Left  : in Pstring;
--           Right : in AVR_String)
--           return  Boolean;

--        function ">="
--          (Left  : in AVR_String;
--           Right : in Pstring)
--           return  Boolean;

      ----------------------
      -- Search Functions --
      ----------------------

--        function Index
--          (Source  : in Pstring;
--           Pattern : in AVR_String)
--           return    Byte;

--        function RIndex
--          (Source  : in Pstring;
--           Pattern : in AVR_String)
--          return    Byte;
--        --  same as index but searching from the end, correspondonds to
--        --  Going => Backward.


--        function Index_Non_Blank
--          (Source : in Pstring;
--           Going  : in Direction := Forward)
--           return   Length_Range;

--        function Count
--          (Source  : in Pstring;
--           Pattern : in AVR_String)
--           return   Length_Range;

--        function Count
--          (Source  : in Pstring;
--           Pattern : in Character)
--          return   Length_Range;

--        function Count
--          (Source  : in Pstring;
--           Pattern : in AVR_String;
--           Mapping : in Maps.Character_Mapping_Function)
--           return    Byte;

--        function Count
--          (Source : in Pstring;
--           Set    : in Maps.Character_Set)
--           return   Byte;

--        procedure Find_Token
--          (Source : in Pstring;
--           Set    : in Maps.Character_Set;
--           Test   : in Membership;
--           First  : out pos8;
--           Last   : out Byte);

      ------------------------------------
      -- String Translation Subprograms --
      ------------------------------------

--        function Translate
--          (Source   : in Pstring;
--           Mapping  : in Maps.Character_Mapping)
--           return     Pstring;

--        procedure Translate
--          (Source   : in out Pstring;
--           Mapping  : in Maps.Character_Mapping);

--        function Translate
--          (Source  : in Pstring;
--           Mapping : in Maps.Character_Mapping_Function)
--           return    Pstring;

--        procedure Translate
--          (Source  : in out Pstring;
--           Mapping : in Maps.Character_Mapping_Function);

      ---------------------------------------
      -- String Transformation Subprograms --
      ---------------------------------------

--        function Replace_Slice
--          (Source   : in Pstring;
--           Low      : in Pos8;
--           High     : in Byte;
--           By       : in AVR_String)
--           return     Pstring;

--        procedure Replace_Slice
--          (Source   : in out Pstring;
--           Low      : in Pos8;
--           High     : in Byte;
--           By       : in AVR_String);

--        function Insert
--          (Source   : in Pstring;
--           Before   : in Pos8;
--           New_Item : in AVR_String)
--           return     Pstring;

--        procedure Insert
--          (Source   : in out Pstring;
--           Before   : in Pos8;
--           New_Item : in AVR_String);

--        function Overwrite
--          (Source    : in Pstring;
--           Position  : in Pos8;
--           New_Item  : in AVR_String)
--           return      Pstring;

--        procedure Overwrite
--          (Source    : in out Pstring;
--           Position  : in pos8;
--           New_Item  : in AVR_String);

--        function Delete
--          (Source  : in Pstring;
--           From    : in Pos8;
--           Through : in Byte)
--           return    Pstring;

--        procedure Delete
--          (Source  : in out Pstring;
--           From    : in Pos8;
--           Through : in Byte);

--        ---------------------------------
--        -- String Selector Subprograms --
--        ---------------------------------

--        function Trim
--          (Source : in Pstring;
--           Side   : in Trim_End)
--           return   Pstring;

--        procedure Trim
--          (Source : in out Pstring;
--           Side   : in Trim_End);

--        function Trim
--          (Source  : in Pstring;
--            Left   : in Maps.Character_Set;
--            Right  : in Maps.Character_Set)
--            return   Pstring;

--        procedure Trim
--          (Source : in out Pstring;
--           Left   : in Maps.Character_Set;
--           Right  : in Maps.Character_Set);

--        function Head
--          (Source : in Pstring;
--           Count  : in Byte;
--           Pad    : in Character := Space)
--           return   Pstring;

--        procedure Head
--          (Source : in out Pstring;
--           Count  : in Byte;
--           Pad    : in Character  := Space);

--        function Tail
--          (Source : in Pstring;
--           Count  : in Byte;
--           Pad    : in Character  := Space)
--           return Pstring;

--        procedure Tail
--          (Source : in out Pstring;
--           Count  : in Byte;
--           Pad    : in Character  := Space);

      ------------------------------------
      -- String Constructor Subprograms --
      ------------------------------------

--        function "*"
--          (Left  : in Byte;
--           Right : in Character)
--           return  Pstring;

--        function "*"
--          (Left  : in Byte;
--           Right : in AVR_String)
--           return  Pstring;

--        function "*"
--          (Left  : in Byte;
--           Right : in Pstring)
--           return  Pstring;

--        function Replicate
--          (Count : in Byte;
--           Item  : in Character)
--           return  Pstring;

--        function Replicate
--          (Count : in Byte;
--           Item  : in AVR_String)
--           return  Pstring;

--        function Replicate
--          (Count : in Byte;
--           Item  : in Pstring)
--           return  Pstring;

   private

--        type Pstring is record
--           Current_Length : Length_Range;
--           Data           : AVR_String (1 .. Max_Length);
--        end record;

--        Null_Pstring : constant Pstring :=
--          (Current_Length => 0,
--           Data           => (1 .. Max_Length => ASCII.NUL));

      pragma Inline_Always (To_PString);
      pragma Pure_Function (To_PString);
      pragma Inline_Always (Element);
      pragma Pure_Function (Element);
      pragma Inline_Always (Length);
      pragma Pure_Function (Length);
   end Generic_PString;

end AVR.Strings.PString;
