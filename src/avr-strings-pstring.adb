------------------------------------------------------------------------------
--                                                                          --
--                         AVR-Ada RUNTIME COMPONENTS                       --
--                                                                          --
--               A V R . A D A . S T R I N G S . PSTRING
--                                                                          --
--                                 B o d y                                  --
--                                                                          --
--          Copyright (C) 2005 R. Ebert
--                                                                          --
------------------------------------------------------------------------------

-- with Avr.Strings.Search;

package body AVR.Strings.PString is


   package body Generic_PString is

      ------------
      -- Append --
      ------------

      --  Case of Pstring and Pstring

--        function Append
--          (Left, Right : Pstring)
--          return        Pstring
--        is
--           Result : Pstring;
--           Llen   : constant Unsigned_8 := Left.Current_Length;
--           Rlen   : constant Unsigned_8 := Right.Current_Length;
--           Nlen   : constant Unsigned_8 := Llen + Rlen;

--        begin
--           if Nlen <= Max_Length then
--              Result.Current_Length := Nlen;
--              Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--              Result.Data (Llen + 1 .. Nlen) := Right.Data (1 .. Rlen);

--           else
--              Result.Current_Length := Max_Length;

--              if Llen >= Max_Length then -- only case is Llen = Max_Length
--                 Result.Data := Left.Data;

--              else
--                 Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--                 Result.Data (Llen + 1 .. Max_Length) :=
--                   Right.Data (1 .. Max_Length - Llen);
--              end if;

--           end if;

--           return Result;
--        end  Append;


--        procedure Append
--          (Source   : in out Pstring;
--           New_Item : Pstring)
--        is
--           Llen       : constant Unsigned_8 := Source.Current_Length;
--           Rlen       : constant Unsigned_8 := New_Item.Current_Length;
--           Nlen       : constant Unsigned_8 := Llen + Rlen;

--        begin
--           if Nlen <= Max_Length then
--              Source.Current_Length := Nlen;
--              Source.Data (Llen + 1 .. Nlen) := New_Item.Data (1 .. Rlen);

--           else
--              Source.Current_Length := Max_Length;

--              if Llen < Max_Length then
--                 Source.Data (Llen + 1 .. Max_Length) :=
--                   New_Item.Data (1 .. Max_Length - Llen);
--              end if;

--           end if;

--        end Append;

--        --  Case of Pstring and AVR_String

--        function Append
--          (Left  : Pstring;
--           Right : AVR_String)
--          return  Pstring
--        is
--           Result : Pstring;
--           Llen   : constant Unsigned_8 := Left.Current_Length;
--           Rlen   : constant Unsigned_8 := Right'Length;
--           Nlen   : constant Unsigned_8 := Llen + Rlen;

--        begin
--           if Nlen <= Max_Length then
--              Result.Current_Length := Nlen;
--              Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--              Result.Data (Llen + 1 .. Nlen) := Right;

--           else
--              Result.Current_Length := Max_Length;

--              if Llen >= Max_Length then -- only case is Llen = Max_Length
--                 Result.Data := Left.Data;

--              else
--                 Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--                 Result.Data (Llen + 1 .. Max_Length) :=
--                   Right (Right'First .. Right'First - 1 +
--                          Max_Length - Llen);

--              end if;

--           end if;

--           return Result;
--        end Append;

--        procedure Append
--          (Source   : in out Pstring;
--           New_Item : AVR_String)
--        is
--           Llen   : constant Unsigned_8 := Source.Current_Length;
--           Rlen   : constant Unsigned_8 := New_Item'Length;
--           Nlen   : constant Unsigned_8 := Llen + Rlen;

--        begin
--           if Nlen <= Max_Length then
--              Source.Current_Length := Nlen;
--              Source.Data (Llen + 1 .. Nlen) := New_Item;

--           else
--              Source.Current_Length := Max_Length;

--              if Llen < Max_Length then
--                 Source.Data (Llen + 1 .. Max_Length) :=
--                   New_Item (New_Item'First ..
--                             New_Item'First - 1 + Max_Length - Llen);
--              end if;

--           end if;

--        end Append;

--        --  Case of String and Pstring

--        function Append
--          (Left  : AVR_String;
--           Right : Pstring)
--          return  Pstring
--        is
--           Result     : Pstring;
--           Llen       : constant Unsigned_8 := Left'Length;
--           Rlen       : constant Unsigned_8 := Right.Current_Length;
--           Nlen       : constant Unsigned_8 := Llen + Rlen;

--        begin
--           if Nlen <= Max_Length then
--              Result.Current_Length := Nlen;
--              Result.Data (1 .. Llen) := Left;
--              Result.Data (Llen + 1 .. Llen + Rlen) := Right.Data (1 .. Rlen);

--           else
--              Result.Current_Length := Max_Length;

--              if Llen >= Max_Length then
--                 Result.Data (1 .. Max_Length) :=
--                   Left (Left'First .. Left'First + (Max_Length - 1));

--              else
--                 Result.Data (1 .. Llen) := Left;
--                 Result.Data (Llen + 1 .. Max_Length) :=
--                   Right.Data (1 .. Max_Length - Llen);
--              end if;

--           end if;

--           return Result;
--        end Append;

--        --  Case of Pstring and Character

--        function Append
--          (Left  : Pstring;
--           Right : Character)
--          return  Pstring
--        is
--           Result     : Pstring;
--           Llen       : constant Unsigned_8 := Left.Current_Length;

--        begin
--           if Llen  < Max_Length then
--              Result.Current_Length := Llen + 1;
--              Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--              Result.Data (Llen + 1) := Right;
--              return Result;

--           else
--              return Left;

--           end if;
--        end Append;

--        procedure Append
--          (Source   : in out Pstring;
--           New_Item : Character)
--        is
--           Llen       : constant Unsigned_8  := Source.Current_Length;
--        begin
--           if Llen  < Max_Length then
--              Source.Current_Length := Llen + 1;
--              Source.Data (Llen + 1) := New_Item;

--           else
--              Source.Current_Length := Max_Length;

--           end if;

--        end Append;

--        --  Case of Character and Pstring

--        function Append
--          (Left  : Character;
--           Right : Pstring)
--          return  Pstring
--        is
--           Result : Pstring;
--           Rlen   : constant Unsigned_8 := Right.Current_Length;

--        begin
--           if Rlen < Max_Length then
--              Result.Current_Length := Rlen + 1;
--              Result.Data (1) := Left;
--              Result.Data (2 .. Rlen + 1) := Right.Data (1 .. Rlen);
--              return Result;

--           else
--                    Result.Current_Length := Max_Length;
--                    Result.Data (1) := Left;
--                    Result.Data (2 .. Max_Length) :=
--                      Right.Data (1 .. Max_Length - 1);
--                    return Result;

--           end if;
--        end Append;


      -------------------
      -- Element --
      -------------------

      function Element
        (Source : PString;
         Index  : Pos8)
        return   Character
      is
      begin
         if Index in 1 .. Source.Current_Length then
            return Source.Data (Index);
         else
            --  raise Strings.Index_Error;
            return ASCII.NUL;
         end if;
      end Element;

      ------------
      -- Concat --
      ------------

--        function "&"
--          (Left  : Pstring;
--           Right : Pstring)
--          return  Pstring
--        is
--           Result : Pstring ;
--           Llen   : constant Length_Range := Left.Current_Length;
--           Rlen   : constant Length_Range := Right.Current_Length;
--           Nlen   : Byte := Llen + Rlen;

--        begin
--           if Nlen > Max_Length then
--              --  raise Ada.Strings.Length_Error;
--              Nlen := Max_Length;
--           end if;

--           Result.Current_Length := Nlen;
--           Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--           Result.Data (Llen + 1 .. Nlen) := Right.Data (1 .. Rlen);

--           return Result;
--        end "&";

--        function "&"
--          (Left  : Pstring;
--           Right : AVR_String)
--          return  Pstring
--        is
--           Result : Pstring;
--           Llen   : constant Length_Range := Left.Current_Length;

--           Nlen   : Byte := Llen + Right'Length;

--        begin
--           if Nlen > Max_Length then
--              --  raise Ada.Strings.Length_Error;
--              Nlen := Max_Length;
--           end if;

--           Result.Current_Length := Nlen;
--           Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--           Result.Data (Llen + 1 .. Nlen) := Right;

--           return Result;
--        end "&";

--        function "&"
--          (Left  : AVR_String;
--           Right : Pstring)
--          return  Pstring
--        is
--           Result : Pstring;
--           Llen   : constant Byte := Left'Length;
--           Rlen   : constant Byte := Right.Current_Length;
--           Nlen   : Byte := Llen + Rlen;

--        begin
--           if Nlen > Max_Length then
--              --  raise Ada.Strings.Length_Error;
--              Nlen := Max_Length;
--           end if;
--           Result.Current_Length := Nlen;
--           Result.Data (1 .. Llen) := Left;
--           Result.Data (Llen + 1 .. Nlen) := Right.Data (1 .. Rlen);

--           return Result;
--        end "&";

--        function "&"
--          (Left  : Pstring;
--           Right : Character)
--          return  Pstring
--        is
--           Result : Pstring;
--           Llen   : constant Byte := Left.Current_Length;

--        begin
--           if Llen = Max_Length then
--              --  raise Ada.Strings.Length_Error;
--              return Left;
--           else
--              Result.Current_Length := Llen + 1;
--              Result.Data (1 .. Llen) := Left.Data (1 .. Llen);
--              Result.Data (Result.Current_Length) := Right;
--           end if;

--           return Result;
--        end "&";

--        function "&"
--          (Left  : Character;
--           Right : Pstring)
--          return  Pstring
--        is
--           Result : Pstring;
--           Rlen   : constant Byte := Right.Current_Length;

--        begin
--           if Rlen = Max_Length then
--              --  raise Ada.Strings.Length_Error;
--              null; --  ???
--           else
--              Result.Current_Length := Rlen + 1;
--              Result.Data (1) := Left;
--              Result.Data (2 .. Result.Current_Length) := Right.Data (1 .. Rlen);
--           end if;

--           return Result;
--        end "&";

--        -----------
--        -- Equal --
--        -----------

--        function "=" (Left, Right : Pstring) return Boolean is
--        begin
--           return Left.Current_Length = Right.Current_Length
--             and then Left.Data (1 .. Left.Current_Length) =
--             Right.Data (1 .. Right.Current_Length);
--        end "=";

--        function "=" (Left : Pstring; Right : AVR_String)
--                       return Boolean is
--        begin
--           return Left.Current_Length = Right'Length
--             and then Left.Data (1 .. Left.Current_Length) = Right;
--        end "=";

--        function "=" (Left : AVR_String; Right : Pstring)
--                       return Boolean is
--        begin
--           return Left'Length = Right.Current_Length
--             and then Left = Right.Data (1 .. Right.Current_Length);
--        end "=";

--        -------------
--        -- Greater --
--        -------------

--        function ">" (Left, Right : Pstring) return Boolean is
--           Min_Len : constant Length_Range :=
--             Length_Range'Min (Left.Current_Length, Right.Current_Length);
--        begin
--           for J in 1 .. Min_Len loop
--              if Left.Data (J) > Right.Data (J) then
--                 return True;
--              end if;
--           end loop;
--           return Left.Current_Length > Right.Current_Length;
--        end ">";


--        function ">"
--          (Left  : Pstring;
--           Right : AVR_String)
--          return  Boolean
--        is
--        begin
--           return Left > (+Right);
--        end ">";

--        function ">"
--          (Left  : AVR_String;
--           Right : Pstring)
--          return  Boolean
--        is
--        begin
--           return +Left > Right;
--        end ">";

--        ----------------------
--        -- Greater_Or_Equal --
--        ----------------------

--        function ">=" (Left, Right : Pstring) return Boolean is
--           Min_Len : constant Length_Range :=
--             Length_Range'Min (Left.Current_Length, Right.Current_Length);
--        begin
--           for J in 1 .. Min_Len loop
--              if Left.Data (J) < Right.Data (J) then
--                 return False;
--              end if;
--           end loop;
--           return Left.Current_Length >= Right.Current_Length;
--        end ">=";

--        function ">="
--          (Left  : Pstring;
--           Right : AVR_String)
--          return  Boolean
--        is
--        begin
--           return Left >= +Right;
--        end ">=";

--        function ">="
--          (Left  : AVR_String;
--           Right : Pstring)
--          return  Boolean
--        is
--        begin
--           return +Left >= Right;
--        end ">=";

--        ----------
--        -- Less --
--        ----------

--        function "<" (Left, Right : Pstring) return Boolean is
--        begin
--           return not (Left >= Right);
--        end "<";

--        function "<"
--          (Left  : Pstring;
--           Right : AVR_String)
--          return  Boolean
--        is
--        begin
--           return not (Left >= + Right);
--        end "<";

--        function "<"
--          (Left  : AVR_String;
--           Right : Pstring)
--          return  Boolean
--        is
--        begin
--           return not (Pstring'(+Left) >= Right);
--        end "<";

--        -------------------
--        -- Less_Or_Equal --
--        -------------------

--        function "<=" (Left, Right : Pstring) return Boolean is
--        begin
--           return not (Left > Right);
--        end "<=";

--        function "<="
--          (Left  : Pstring;
--           Right : AVR_String)
--          return  Boolean
--        is
--        begin
--           return not (Left > +Right);
--        end "<=";

--        function "<="
--          (Left  : AVR_String;
--           Right : Pstring)
--          return  Boolean
--        is
--        begin
--           return not (+Left > Right);
--        end "<=";

--        -----------------
--        -- Count --
--        -----------------

--        function Count
--          (Source   : Pstring;
--           Pattern  : AVR_String)
--          return Length_Range
--        is
--        begin
--           return
--             Search.Count
--             (Source.Data (1 .. Source.Current_Length), Pattern);
--        end Count;

--        function Count
--          (Source   : Pstring;
--           Pattern  : Character)
--          return Length_Range
--        is
--           N : Length_Range := 0;
--        begin
--           for J in 1 .. Source.Current_Length loop
--              if Source.Data (J) = Pattern then
--                 N := N + 1;
--              end if;
--           end loop;

--           return N;
--        end Count;

      ------------------
      -- Delete --
      ------------------

--        function Delete
--          (Source  : Pstring;
--           From    : Pos8;
--           Through : Byte)
--          return    Pstring
--        is
--           Result     : Pstring;
--           Slen       : constant Byte := Source.Current_Length;
--           Num_Delete : constant Byte := Through - From + 1;

--        begin
--           if Num_Delete <= 0 then
--              return Source;

--           elsif From > Slen + 1 then
--              --  raise Ada.Strings.Index_Error;  ???
--              return Null_Pstring;

--           elsif Through >= Slen then
--              Result.Current_Length := From - 1;
--              Result.Data (1 .. From - 1) := Source.Data (1 .. From - 1);
--              return Result;

--           else
--              Result.Current_Length := Slen - Num_Delete;
--              Result.Data (1 .. From - 1) := Source.Data (1 .. From - 1);
--              Result.Data (From .. Result.Current_Length) :=
--                Source.Data (Through + 1 .. Slen);
--              return Result;
--           end if;
--        end Delete;

--        procedure Delete
--          (Source  : in out Pstring;
--           From    : Pos8;
--           Through : Byte)
--        is
--           Slen       : constant Byte := Source.Current_Length;
--           Num_Delete : constant Byte := Through - From + 1;

--        begin
--           if Num_Delete <= 0 then
--              return;

--           elsif From > Slen + 1 then
--              --  raise Ada.Strings.Index_Error;
--              null; --  ???

--           elsif Through >= Slen then
--              Source.Current_Length := From - 1;

--           else
--              Source.Current_Length := Slen - Num_Delete;
--              Source.Data (From .. Source.Current_Length) :=
--                Source.Data (Through + 1 .. Slen);
--           end if;
--        end Delete;


      ----------------
      -- Bounded_Head --
      ----------------

--        function Head
--          (Source : Pstring;
--           Count  : Byte;
--           Pad    : Character := Space)
--          return   Pstring
--        is
--           Result     : Pstring;
--           Slen       : constant Byte := Source.Current_Length;
--           Npad       : constant Byte := Count - Slen;

--        begin
--           if Npad <= 0 then
--              Result.Current_Length := Count;
--              Result.Data (1 .. Count) := Source.Data (1 .. Count);

--           elsif Count <= Max_Length then
--              Result.Current_Length := Count;
--              Result.Data (1 .. Slen) := Source.Data (1 .. Slen);
--              Result.Data (Slen + 1 .. Count) := (others => Pad);

--           else
--              Result.Current_Length := Max_Length;
--              Result.Data (1 .. Slen) := Source.Data (1 .. Slen);
--              Result.Data (Slen + 1 .. Max_Length) := (others => Pad);

--           end if;

--           return Result;
--        end Head;

--        procedure Head
--          (Source : in out Pstring;
--           Count  : Byte;
--           Pad    : Character  := Space)
--        is
--           Slen       : constant Byte  := Source.Current_Length;
--           Npad       : constant Byte  := Count - Slen; --  ??? Integer

--        begin
--           if Npad <= 0 then
--              Source.Current_Length := Count;

--           elsif Count <= Max_Length then
--              Source.Current_Length := Count;
--              Source.Data (Slen + 1 .. Count) := (others => Pad);

--           else
--              Source.Current_Length := Max_Length;
--              Source.Data (Slen + 1 .. Max_Length) := (others => Pad);

--           end if;
--        end Head;

--        -----------------
--        -- Index --
--        -----------------

--        function Index
--          (Source   : Pstring;
--           Pattern  : AVR_String)
--          return     Byte
--        is
--        begin
--           return Search.Index
--             (Source.Data (1 .. Source.Current_Length), Pattern, Strings.Forward);
--        end Index;

--        function RIndex
--          (Source   : Pstring;
--           Pattern  : AVR_String)
--          return     Byte
--        is
--        begin
--           return Search.Index
--             (Source.Data (1 .. Source.Current_Length), Pattern, Strings.Backward);
--        end RIndex;

      ---------------------------
      -- Index_Non_Blank --
      ---------------------------

--        function Index_Non_Blank
--          (Source : Pstring;
--           Going  : Strings.Direction := Strings.Forward)
--          return Length_Range
--        is
--        begin
--           return
--             Search.Index_Non_Blank
--             (Source.Data (1 .. Source.Current_Length), Going);
--        end Index_Non_Blank;

      ------------------
      -- Bounded_Insert --
      ------------------

--        function Insert
--          (Source   : Pstring;
--           Before   : Pos8;
--           New_Item : AVR_String)
--          return     Pstring
--        is
--           Result     : Pstring;
--           Slen       : constant Byte := Source.Current_Length;
--           Nlen       : constant Byte := New_Item'Length;
--           Tlen       : constant Byte := Slen + Nlen;
--           Blen       : constant Byte := Before - 1;
--           Alen       : constant Byte := Slen - Blen; --  ??? Integer
--           Droplen    : constant Byte := Tlen - Max_Length; --  ??? Integer

--           --  Tlen is the length of the total string before possible truncation.
--           --  Blen, Alen are the lengths of the before and after pieces of the
--           --  source string.

--        begin
--           if Alen < 0 then
--              --  raise Ada.Strings.Index_Error;
--              null; --  ???

--           elsif Droplen <= 0 then
--              Result.Current_Length := Tlen;
--              Result.Data (1 .. Blen) := Source.Data (1 .. Blen);
--              Result.Data (Before .. Before + Nlen - 1) := New_Item;
--              Result.Data (Before + Nlen .. Tlen) :=
--                Source.Data (Before .. Slen);

--           else
--              Result.Current_Length := Max_Length;

--                    Result.Data (1 .. Blen) := Source.Data (1 .. Blen);

--                    if Droplen > Alen then
--                       Result.Data (Before .. Max_Length) :=
--                         New_Item (New_Item'First
--                                   .. New_Item'First + Max_Length - Before);
--                    else
--                       Result.Data (Before .. Before + Nlen - 1) := New_Item;
--                       Result.Data (Before + Nlen .. Max_Length) :=
--                         Source.Data (Before .. Slen - Droplen);
--                    end if;

--           end if;

--           return Result;
--        end Insert;

--        procedure Insert
--          (Source   : in out Pstring;
--           Before   : Pos8;
--           New_Item : AVR_String)
--        is
--        begin
--           --  We do a double copy here because this is one of the situations
--           --  in which we move data to the right, and at least at the moment,
--           --  GNAT is not handling such cases correctly ???

--           Source := Insert (Source, Before, New_Item);
--        end Insert;

      ------------------
      -- Length --
      ------------------

      function Length (Source : PString) return Length_Range is
      begin
         return Source.Current_Length;
      end Length;

--        ---------------------
--        -- Bounded_Overwrite --
--        ---------------------

--        function Overwrite
--          (Source    : Pstring;
--           Position  : Pos8;
--           New_Item  : AVR_String)
--          return      Pstring
--        is
--           Result     : Pstring ;
--           Endpos     : constant Byte  := Position + New_Item'Length - 1;
--           Slen       : constant Byte  := Source.Current_Length;
--           Droplen    : Byte;

--        begin
--           if Position > Slen + 1 then
--              --  raise Ada.Strings.Index_Error;
--              null; --  ???
--              return Source;

--           elsif New_Item'Length = 0 then
--              return Source;

--           elsif Endpos <= Slen then
--              Result.Current_Length := Source.Current_Length;
--              Result.Data (1 .. Slen) := Source.Data (1 .. Slen);
--              Result.Data (Position .. Endpos) := New_Item;
--              return Result;

--           elsif Endpos <= Max_Length then
--              Result.Current_Length := Endpos;
--              Result.Data (1 .. Position - 1) := Source.Data (1 .. Position - 1);
--              Result.Data (Position .. Endpos) := New_Item;
--              return Result;

--           else
--              Result.Current_Length := Max_Length;
--              Droplen := Endpos - Max_Length;

--              Result.Data (1 .. Position - 1) :=
--                Source.Data (1 .. Position - 1);

--              Result.Data (Position .. Max_Length) :=
--                New_Item (New_Item'First .. New_Item'Last - Droplen);
--              return Result;

--           end if;
--        end Overwrite;


--        procedure Overwrite
--          (Source    : in out Pstring;
--           Position  : Pos8;
--           New_Item  : AVR_String)
--        is
--           Endpos     : constant Pos8 := Position + New_Item'Length - 1;
--           Slen       : constant Byte  := Source.Current_Length;
--           Droplen    : Byte;

--        begin
--           if Position > Slen + 1 then
--              --  raise Ada.Strings.Index_Error;
--              null; --   ???

--           elsif Endpos <= Slen then
--              Source.Data (Position .. Endpos) := New_Item;

--           elsif Endpos <= Max_Length then
--              Source.Data (Position .. Endpos) := New_Item;
--              Source.Current_Length := Endpos;

--           else
--              Source.Current_Length := Max_Length;
--              Droplen := Endpos - Max_Length;

--              Source.Data (Position .. Max_Length) :=
--                New_Item (New_Item'First .. New_Item'Last - Droplen);

--           end if;
--        end Overwrite;

--        ---------------------------
--        -- Replace_Element --
--        ---------------------------

--        procedure Replace_Element
--          (Source : in out Pstring;
--           Index  : Pos8;
--           By     : Character)
--        is
--        begin
--           if Index <= Source.Current_Length then
--              Source.Data (Index) := By;
--           else
--              --  raise Ada.Strings.Index_Error;
--              null; --  ???
--           end if;
--        end Replace_Element;

--        -------------------------
--        -- Replace_Slice --
--        -------------------------

--        function Replace_Slice
--          (Source   : Pstring;
--           Low      : Pos8;
--           High     : Byte;
--           By       : AVR_String)
--          return     Pstring
--        is
--           Slen       : constant Byte  := Source.Current_Length;

--        begin
--           if Low > Slen + 1 then
--              --  raise Strings.Index_Error;
--              null; --  ???
--              return Source;

--           elsif High < Low then
--              return Insert (Source, Low, By);

--           else
--              declare
--                 Blen    : constant Byte := Byte'Max (0, Low - 1);
--                 Alen    : constant Byte := Byte'Max (0, Slen - High);
--                 Tlen    : constant Byte := Blen + By'Length + Alen;
--                 Droplen : constant Byte := Tlen - Max_Length; --  ??? Integer
--                 Result  : Pstring;

--                 --  Tlen is the total length of the result string before any
--                 --  truncation. Blen and Alen are the lengths of the pieces
--                 --  of the original string that end up in the result string
--                 --  before and after the replaced slice.

--              begin
--                 if Droplen <= 0 then
--                    Result.Current_Length := Tlen;
--                    Result.Data (1 .. Blen) := Source.Data (1 .. Blen);
--                    Result.Data (Low .. Low + By'Length - 1) := By;
--                    Result.Data (Low + By'Length .. Tlen) :=
--                      Source.Data (High + 1 .. Slen);

--                 else
--                    Result.Current_Length := Max_Length;

--                    Result.Data (1 .. Blen) := Source.Data (1 .. Blen);

--                    if Droplen > Alen then
--                       Result.Data (Low .. Max_Length) :=
--                         By (By'First .. By'First + Max_Length - Low);
--                    else
--                       Result.Data (Low .. Low + By'Length - 1) := By;
--                       Result.Data (Low + By'Length .. Max_Length) :=
--                         Source.Data (High + 1 .. Slen - Droplen);
--                    end if;

--                 end if;

--                 return Result;
--              end;
--           end if;
--        end Replace_Slice;

--        procedure Replace_Slice
--          (Source   : in out Pstring;
--           Low      : Pos8;
--           High     : Byte;
--           By       : AVR_String)
--        is
--        begin
--           --  We do a double copy here because this is one of the situations
--           --  in which we move data to the right, and at least at the moment,
--           --  GNAT is not handling such cases correctly ???

--           Source := Replace_Slice (Source, Low, High, By);
--        end Replace_Slice;

--        ---------------------
--        -- Replicate --
--        ---------------------

--        function Replicate
--          (Count      : Byte;
--           Item       : Character)
--          return       Pstring
--        is
--           Result : Pstring;

--        begin
--           if Count <= Max_Length then
--              Result.Current_Length := Count;

--              --        elsif Drop = Strings.Error then
--              --           raise Ada.Strings.Length_Error;

--           else
--              Result.Current_Length := Max_Length;
--           end if;

--           Result.Data (1 .. Result.Current_Length) := (others => Item);
--           return Result;
--        end Replicate;

--        function Replicate
--            (Count      : Byte;
--             Item       : AVR_String)
--            return       Pstring
--        is
--           Length : constant Byte := Count * Item'Length; --  ??? Integer
--           Result : Pstring;
--           Indx   : Pos8;

--        begin
--           if Length <= Max_Length then
--              Result.Current_Length := Length;

--              if Length > 0 then
--                 Indx := 1;

--                 for J in 1 .. Count loop
--                    Result.Data (Indx .. Indx + Item'Length - 1) := Item;
--                    Indx := Indx + Item'Length;
--                 end loop;
--              end if;

--           else
--              Result.Current_Length := Max_Length;

--                    Indx := 1;

--                    while Indx + Item'Length <= Max_Length + 1 loop
--                       Result.Data (Indx .. Indx + Item'Length - 1) := Item;
--                       Indx := Indx + Item'Length;
--                    end loop;

--                    Result.Data (Indx .. Max_Length) :=
--                      Item (Item'First .. Item'First + Max_Length - Indx);

--           end if;

--           return Result;
--        end Replicate;

--        function Replicate
--          (Count : Byte;
--           Item  : Pstring)
--          return  Pstring
--        is
--        begin
--           return
--             Replicate (Count, Item.Data (1 .. Item.Current_Length));
--        end Replicate;

--        -----------------
--        -- Slice --
--        -----------------

--        function Slice
--          (Source : Pstring;
--           Low    : Pos8;
--           High   : Byte)
--          return   PString
--        is
--           Result : Pstring;
--        begin
--           --  Note: test of High > Length is in accordance with AI95-00128

--           if Low > Source.Current_Length + 1
--             or else High > Source.Current_Length
--           then
--              --  raise Index_Error;
--              null; --  ???
--              return Null_PString;

--           else
--              Result.Current_Length := High - Low;
--              Result.Data (1 .. Result.Current_Length) :=
--                Source.Data (Low .. High);
--           end if;
--        end Slice;


--        ----------
--        -- Tail --
--        ----------

--        function Tail
--          (Source : Pstring;
--           Count  : Byte;
--           Pad    : Character := Space)
--          return   Pstring
--        is
--           Result     : Pstring;
--           Slen       : constant Byte := Source.Current_Length;
--           Npad       : constant Byte := Count - Slen; --  ??? Integer

--        begin
--           if Npad <= 0 then
--              Result.Current_Length := Count;
--              Result.Data (1 .. Count) :=
--                Source.Data (Slen - (Count - 1) .. Slen);

--           elsif Count <= Max_Length then
--              Result.Current_Length := Count;
--              Result.Data (1 .. Npad) := (others => Pad);
--              Result.Data (Npad + 1 .. Count) := Source.Data (1 .. Slen);

--           else
--              Result.Current_Length := Max_Length;

--                    if Npad >= Max_Length then
--                       Result.Data := (others => Pad);

--                    else
--                       Result.Data (1 .. Npad) := (others => Pad);
--                       Result.Data (Npad + 1 .. Max_Length) :=
--                         Source.Data (1 .. Max_Length - Npad);
--                    end if;

--           end if;

--           return Result;
--        end Tail;

--        procedure Tail
--          (Source : in out Pstring;
--           Count  : Byte;
--           Pad    : Character  := Space)
--        is
--           Slen       : constant Byte  := Source.Current_Length;
--           Npad       : constant Byte  := Count - Slen; --  ??? Integer

--           Temp : constant AVR_String (1 .. Max_Length) := Source.Data;

--        begin
--           if Npad <= 0 then
--              Source.Current_Length := Count;
--              Source.Data (1 .. Count) :=
--                Temp (Slen - (Count - 1) .. Slen);

--           elsif Count <= Max_Length then
--              Source.Current_Length := Count;
--              Source.Data (1 .. Npad) := (others => Pad);
--              Source.Data (Npad + 1 .. Count) := Temp (1 .. Slen);

--           else
--              Source.Current_Length := Max_Length;

--              if Npad >= Max_Length then
--                 Source.Data := (others => Pad);

--              else
--                 Source.Data (1 .. Npad) := (others => Pad);
--                 Source.Data (Npad + 1 .. Max_Length) :=
--                   Temp (1 .. Max_Length - Npad);
--              end if;

--           end if;
--        end Tail;

      ---------------------
      -- To_String --
      ---------------------

--        function To_String (Source : in Pstring) return AVR_String is
--        begin
--           return Source.Data (1 .. Source.Current_Length);
--        end To_String;

--        pstr20.ads:2:01: instantiation error at avr-strings-pstring.adb:1225
--        pstr20.ads:2:01: construct not allowed in configurable run-time mode

      ----------------
      -- Trim --
      ----------------

--        function Trim (Source : Pstring; Side : Trim_End)
--                              return   Pstring
--        is
--           Result : Pstring;
--           Last   : Byte := Source.Current_Length;
--           First  : Pos8 := 1;

--        begin
--           if Side = Left or else Side = Both then
--              while First <= Last and then Source.Data (First) = ' ' loop
--                 First := First + 1;
--              end loop;
--           end if;

--           if Side = Right or else Side = Both then
--              while Last >= First and then Source.Data (Last) = ' ' loop
--                 Last := Last - 1;
--              end loop;
--           end if;

--           Result.Current_Length := Last - First + 1;
--           Result.Data (1 .. Result.Current_Length) := Source.Data (First .. Last);
--           return Result;
--        end Trim;

--        procedure Trim
--          (Source : in out Pstring;
--           Side   : Trim_End)
--        is
--           Last       : Byte    := Source.Current_Length;
--           First      : Pos8          := 1;
--           Temp       : AVR_String (1 .. Max_Length);

--        begin
--           Temp (1 .. Last) := Source.Data (1 .. Last);

--           if Side = Left or else Side = Both then
--              while First <= Last and then Temp (First) = ' ' loop
--                 First := First + 1;
--              end loop;
--           end if;

--           if Side = Right or else Side = Both then
--              while Last >= First and then Temp (Last) = ' ' loop
--                 Last := Last - 1;
--              end loop;
--           end if;

--           Source.Data := (others => ASCII.NUL);
--           Source.Current_Length := Last - First + 1;
--           Source.Data (1 .. Source.Current_Length) := Temp (First .. Last);
--        end Trim;


      -----------
      -- Times --
      -----------

--        function "*"
--          (Left       : Byte;
--           Right      : AVR_String)
--          return  Pstring
--        is
--           Result : Pstring ;
--           Pos    : Pos8         := 1;
--           Rlen   : constant Byte := Right'Length;
--           Nlen   : constant Byte := Left * Rlen;

--        begin
--           if Nlen > Max_Length then
--              --  raise Ada.Strings.Index_Error;
--              null; --  ???

--           else
--              Result.Current_Length := Nlen;

--              if Nlen > 0 then
--                 for J in 1 .. Left loop
--                    Result.Data (Pos .. Pos + Rlen - 1) := Right;
--                    Pos := Pos + Rlen;
--                 end loop;
--              end if;
--           end if;

--           return Result;
--        end "*";

--        function "*"
--          (Left  : Byte;
--           Right : Pstring)
--          return  Pstring
--        is
--           Result : Pstring;
--           Pos    : Pos8 := 1;
--           Rlen   : constant Byte := Right.Current_Length;
--           Nlen   : constant Byte := Left * Rlen;

--        begin
--           if Nlen > Max_Length then
--              --  raise Ada.Strings.Length_Error;
--              null; --  ???

--           else
--              Result.Current_Length := Nlen;

--              if Nlen > 0 then
--                 for J in 1 .. Left loop
--                    Result.Data (Pos .. Pos + Rlen - 1) :=
--                      Right.Data (1 .. Rlen);
--                    Pos := Pos + Rlen;
--                 end loop;
--              end if;
--           end if;

--           return Result;
--        end "*";

      ---------------------
      -- To_Pstring --
      ---------------------

      function To_PString
        (Source     : AVR_String)
        return       PString
      is
         Result : PString;
         Slen   : constant Unsigned_8 := Source'Length;

      begin
         if Slen <= Max_Length then
            Result.Current_Length := Slen;
            Result.Data (1 .. Slen) := Source;

         else
            Result.Current_Length := Max_Length;
            Result.Data (1 .. Max_Length) :=
              Source (Source'First .. Source'First - 1 + Max_Length);

         end if;

         return Result;
      end To_PString;

      ---------
      -- "*" --
      ---------

--        function "*"
--          (Left  : in Byte;
--           Right : in Character)
--          return  Pstring
--        is
--           Nlen : Length_Range := Left;
--        begin
--           if Left > Max_Length then
--              Nlen := Max_Length;
--           end if;
--           return Pstring'(Current_Length => Nlen,
--                                  Data => (1 .. Left => Right));
--        end "*";


   end Generic_PString;

end AVR.Strings.PString;
