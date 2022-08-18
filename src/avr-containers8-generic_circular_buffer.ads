--  generic package of a FIFO store (first in, first out). The generic
--  parameters are the Element_Type of the stored elements and the
--  maximum storage space Max_Length.


generic
   Max_Length : AVR.Containers8.Count_Type;

   type Element_Type is private;

package AVR.Containers8.Generic_Circular_Buffer is
   pragma Preelaborate;

   function Length return Count_Type;
   function Is_Empty return Boolean;

   procedure Append (Item : Element_Type);
   procedure Push renames Append;
   function Dequeue return Element_Type;
   function Pull renames Dequeue;

private

   pragma Inline (Length);
   pragma Inline (Is_Empty);

   subtype Element_Count is Count_Type range 0 .. Max_Length;
   subtype Element_Index is Count_Type range 1 .. Max_Length;

   type Element_Array is array (Element_Index) of Element_Type;

   Buffer : Element_Array;

end AVR.Containers8.Generic_Circular_Buffer;
