package body AVR.Containers8.Generic_Bounded_Priority_Queues is

   -- Array Implementation of Binary Heaps
      -- (http://www.sbhatnagar.com/SourceCode/pqueue.html)

      --  One does not need pointers and dynamic memory allocation to
      --  implement a binary heap. A plain flat one-dimensional array
      --  will do fine. Assume that you are dealing with a binary heap
      --  holding n elements. The elements may be stored in an array
      --  with n slots in which

      --  * the children of the node in slot x occupy slots 2x and
      --    2x+1, and
      --  * accordingly, the parent of the node in slot x lives in
      --    slot x/2.

      --  Clearly, the root node sits in slot 1, its children sit in
      --  slots 2 and 3, respectively, their children in turn are
      --  occupying slot 4, 5, 6, and 7, respectively, and so
      --  on. There is a straightforward one-to-one correspondence
      --  between binary heaps and flattened-out array representations
      --  of binary heaps. It is important to note that, since the
      --  link relationship (or lack thereof) between any two nodes is
      --  obvious directly from their respective slot indices, we do
      --  not need to explicitly store any links, thus saving
      --  substantial amounts of time and space.

      -- How Do I Enqueue an Item?

      --  Let A be the priority queue's underlying item array, and let
      --  n be the number of items this array currently contains. At
      --  any time, the queue's n items will be in A[1], A[2], ...,
      --  A[n]. Thus, the index of the first available slot will be
      --  n+1, and there will not be an available slot between any two
      --  items. Now, let a be a portion of data to be enqueued. To
      --  insert a, proceed as follows:

      --  1. Let m = n+1.
      --  2. Put a into A[m]; that is, put a into the first available
      --     slot.
      --  3. Check whether m=1. If yes, you are done; the algorithm
      --     terminates.
      --  4. Compare the key of A[m] to that of A[m/2].
      --     * If A[m] > A[m/2], swap A[m] and A[m/2]. Let m =
      --       m/2. Then go back to step (3).
      --     * Otherwise (if the key of A[m] is less than or equal to
      --       than of A[m/2]), the newly inserted item a has
      --       travelled as close to the root node as it needs to
      --       get. The algorithm terminates.

      -- How Do I Remove an Item?

      --  Let A be the prioriy queue's underlying item array, and let
      --  n be the number of the portions of data the priority queue
      --  currently contains. To remove an item from the queue,
      --  proceed as outlined below:

      --  1. Remove the item in slot A[1]. Let n = n-1 to reflect the
      --     fact that the number of items in the queue has decreased
      --     by one.
      --  2. Check whether n=0. If yes, the queue is now empty, and
      --     the algorithm terminates.
      --  3. Move the item in A[n+1] to slot A[1]; i. e., let the last
      --     item in the queue take the removed item's place. From now
      --     on, we shall refer to this item as item a.
      --  4. Let u = 1 and v = 1.
      --  5. Check whether 2u <= n, that is, whether the queue
      --     currently contains at least 2u items.
      --     * If yes, compare the respective keys of item A[u] and
      --       item A[2u]. If the key associated with item A[2u] is
      --       higher than that of A[u], let v = 2u. As you will see,
      --       the algorithm so to speak makes a mental note stating
      --       that (for the time being) it looks as though A[u] and
      --       A[2u] should swap positions.
      --     * If no, item a already is a far away from the root node
      --       as it possibly can get, and the algorithm terminates.
      --  6. Check whether 2u+1 <= n; that is, whether the queue
      --     contains at least 2u+1 elements.
      --     * If yes, compare the respective keys of item A[v] and
      --       item A[2u+1]. (That's right, A[v] and A[2u+1], not A[u]
      --       and A[2u+1].) If the latter key is higher than the
      --       former key, let v = 2u+1. The algorithm, so to speak,
      --       memorizes that A[u] and A[2u+1] should be swapped.
      --     * If no, go straight to step (7).
      --  7. Unless u = v, swap A[u] and A[v].
      --  8. Let u = v to adjust u to the new slot index of item
      --     a. Then go back to step (5).

   function Length return Count_Type is
   begin
      return Len;
   end Length;


   function Is_Empty return Boolean is
   begin
      return (Len = 0);
   end Is_Empty;


   function First_Element return Element_Type is
   begin
      --  we cannot do much in case of error, so always return the
      --  first element, even if empty list
      --
      -- if not Is_Empty then
      return A (1);
      -- end if;
   end First_Element;


   procedure Insert (New_Item  : Element_Type;
                     Inserted  : out Boolean)
   is
      --  the queue's n items will be in A[1], A[2], ..., A[n].  Thus,
      --  the index of the first available slot will be n+1, and there
      --  will not be an available slot between any two items. Now,
      --  let a be a portion of data to be enqueued. To insert a,
      --  proceed as follows:

      M : Element_Count;

   begin
      if Len = Max_Length then
         Inserted := False;
         return;
      else
         Inserted := True;
      end if;

      --  1. Let m = n+1.
      Len := Len + 1;
      M   := Len;

      --  2. Put a into A[m]; that is, put a into the first available
      --     slot.

      --  3. Check whether m=1. If yes, you are done; the algorithm
      --     terminates.
      --  4. Compare the key of A[m] to that of A[m/2].
      while M > 1 and then A (M/2) < New_Item loop
         A (M) := A (M/2);
         M     := M/2;
         --     * If A[m] > A[m/2], swap A[m] and A[m/2]. Let m =
         --       m/2. Then go back to step (3).
      end loop;
      A (M) := New_Item;

      --     * Otherwise (if the key of A[m] is less than or equal to
      --       than of A[m/2]), the newly inserted item a has
      --       travelled as close to the root node as it needs to
      --       get. The algorithm terminates.
   end Insert;


   procedure Delete_First is
      M : Element_Count := 1;
      J : Element_Count;
      Tmp : Element_Type;
   begin
      Len := Len - 1;
      Tmp := A (Len);
      while M <= Len / 2 loop
         J := 2 * M;
         if J < Len and then A(J) < A (J+1) then
            J := J + 1;
         end if;
         exit when A (J) < Tmp or else A (J) = Tmp;
         A (M) := A (J);
         M := J;
      end loop;
      A (M) := Tmp;
   end Delete_First;

end AVR.Containers8.Generic_Bounded_Priority_Queues;
