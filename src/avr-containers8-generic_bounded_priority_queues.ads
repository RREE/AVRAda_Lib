

generic
   Max_Length : AVR.Containers8.Count_Type;

   type Element_Type is private;

   with function "<" (Left, Right : Element_Type) return Boolean is <>;
   with function "=" (Left, Right : Element_Type) return Boolean is <>;

package AVR.Containers8.Generic_Bounded_Priority_Queues is
   pragma Preelaborate;

   function Length return Count_Type;
   function Is_Empty return Boolean;

   function First_Element return Element_Type;

   procedure Insert (New_Item  : Element_Type;
                     Inserted  : out Boolean);

   procedure Delete_First;

private

   pragma Inline (Length);
   pragma Inline (Is_Empty);
   pragma Inline (First_Element);

   subtype Element_Count is Count_Type range 0 .. Max_Length;
   subtype Element_Index is Count_Type range 1 .. Max_Length;

   type Element_Array is array (Element_Index) of Element_Type;

   A : Element_Array;

   Len : Element_Count := 0;

end AVR.Containers8.Generic_Bounded_Priority_Queues;
