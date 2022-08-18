package body AVR.Containers8.Generic_Circular_Buffer is


   Write_Loc : Element_Index;
   Read_Loc  : Element_Index;


   procedure Inc_And_Wrap_Around (Loc : in out Element_Index)
   is
   begin
      if Loc = Max_Length then
         Loc := 1;
      else
         Loc := Loc + 1;
      end if;
   end Inc_And_Wrap_Around;


   function Length return Count_Type is
      L : Element_Count;
   begin
      if Read_Loc = Write_Loc then
         return 0;
      elsif Read_Loc > Write_Loc then
         return Write_Loc - Read_Loc + Max_Length;
      else
         return Write_Loc - Read_Loc;
      end if;
   end Length;


   function Is_Empty return Boolean is
   begin
      return Read_Loc = Write_Loc;
   end Is_Empty;


   procedure Append (Item : Element_Type) is
      Is_Full : constant Boolean := Length = Max_Length;
   begin
      if not Is_Full then
         Buffer (Write_Loc) := Item;
         Inc_And_Wrap_Around (Write_Loc);
      else
         -- ignore any new value
         null;
      end if;
   end Append;


   function Dequeue return Element_Type is
      Empty : constant Boolean := Is_Empty;
      E : Element_Type;
   begin
      if not Is_Empty then
         E := Buffer (Read_Loc);
         Inc_And_Wrap_Around (Read_Loc);
         return E;
      else
         -- do nothing
         null;
      end if;
   end Dequeue;


   procedure Init is
   begin
      Write_Loc := 1;
      Read_Loc  := 1;
   end Init;

begin
   Init;
end AVR.Containers8.Generic_Circular_Buffer;
