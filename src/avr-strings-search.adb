package body AVR.Strings.Search is


   function Index
     (Source   : in AVR_String;
      Pattern  : in AVR_String;
      Going    : in Direction := Forward)
     return     Unsigned_8
   is
      Cur_Index     : Unsigned_8;

   begin
      if Pattern'Length = 0 then
         return 0;
      end if;

      --  Forwards case
      if Going = Forward then
         for J in Unsigned_8'(1) .. Source'Length - Pattern'Length + 1 loop
            Cur_Index := Source'First + J - 1;

            if Pattern = Source
                           (Cur_Index .. Cur_Index + Pattern'Length - 1)
            then
               return Cur_Index;
            end if;
         end loop;

      --  Backwards case

      else
         for J in reverse Unsigned_8'(1) .. Source'Length - Pattern'Length + 1
         loop
            Cur_Index := Source'First + J - 1;

            if Pattern = Source (Cur_Index .. Cur_Index + Pattern'Length - 1)
            then
               return Cur_Index;
            end if;
         end loop;
      end if;

      --  Fall through if no match found. Note that the loops are skipped
      --  completely in the case of the pattern being longer than the source.

      return 0;
   end Index;


   function Index (Source   : in AVR_String;
                   Pattern  : in Character;
                   Going    : in Direction := Forward) return Unsigned_8
   is
   begin
      --  Forwards case
      if Going = Forward then
         for J in Source'Range loop
            if Pattern = Source(J) then
               return J;
            end if;
         end loop;

      --  Backwards case

      else
         for J in reverse Source'Range loop
            if Pattern = Source (J) then
               return J;
            end if;
         end loop;
      end if;

      --  Fall through if no match found. Note that the loops are skipped
      --  completely in the case of the pattern being longer than the source.

      return 0;
   end Index;


   function Index_Non_Blank
     (Source : in AVR_String;
      Going  : in Direction := Forward)
     return   Unsigned_8
   is
   begin
      if Going = Forward then
         for J in Source'Range loop
            if Source (J) /= ' ' then
               return J;
            end if;
         end loop;

      else -- Going = Backward
         for J in reverse Source'Range loop
            if Source (J) /= ' ' then
               return J;
            end if;
         end loop;
      end if;

      --  Fall through if no match
      return 0;

   end Index_Non_Blank;


   function Count
     (Source   : in AVR_String;
      Pattern  : in AVR_String)
     return     Unsigned_8
   is
      N : Unsigned_8 := 0;
      J : Unsigned_8 := Source'First;

   begin
      if Pattern'Length = 0 then
         return 0;
      end if;

      while J <= Source'Last - (Pattern'Length - 1) loop
         if Source (J .. J + (Pattern'Length - 1)) = Pattern then
            N := N + 1;
            J := J + Pattern'Length;
         else
            J := J + 1;
         end if;
      end loop;

      return N;
   end Count;


   function Count
     (Source   : in AVR_String;
      Pattern  : in Character)
     return     Unsigned_8
   is
      N : Unsigned_8 := 0;
   begin
      for J in Source'Range loop
         if Source (J) = Pattern then
            N := N + 1;
         end if;
      end loop;

      return N;
   end Count;

end AVR.Strings.Search;
