---------------------------------------------------------------------------
-- The AVR-Ada Library is free software;  you can redistribute it and/or --
-- modify it under terms of the  GNU General Public License as published --
-- by  the  Free Software  Foundation;  either  version 2, or  (at  your --
-- option) any later version.  The AVR-Ada Library is distributed in the --
-- hope that it will be useful, but  WITHOUT ANY WARRANTY;  without even --
-- the  implied warranty of MERCHANTABILITY or FITNESS FOR A  PARTICULAR --
-- PURPOSE. See the GNU General Public License for more details.         --
--                                                                       --
-- As a special exception, if other files instantiate generics from this --
-- unit,  or  you  link  this  unit  with  other  files  to  produce  an --
-- executable   this  unit  does  not  by  itself  cause  the  resulting --
-- executable to  be  covered by the  GNU General  Public License.  This --
-- exception does  not  however  invalidate  any  other reasons why  the --
-- executable file might be covered by the GNU Public License.           --
---------------------------------------------------------------------------


with Interfaces;                   use type Interfaces.Unsigned_8;

package body AVR.Timer1.Timing_Events is


   function Sooner (Left, Right : access Timing_Event) return Boolean;
   --  Used by the Event_Queue insertion routine to keep the events in
   --  ascending order by timeout value.
   pragma Inline (Sooner);


   package body Event_Queue is

      Max_Events : constant := 8;
      subtype Event_Count is Interfaces.Unsigned_8 range 0 .. Max_Events;
      subtype Event_Index is Event_Count range 1 .. Max_Events;

      All_Events : array (Event_Index) of access Timing_Event;

      Last_Event : Event_Count := 0;


      procedure Insert (This : access Timing_Event) is
         I : Event_Count := 1;
      begin
         -- dont insert empty handlers
         if This.Handler = null then return; end if;

         if Last_Event = Max_Events then
            -- ???
            -- error case, report it somehow !!!
            -- ???
            return;
         end if;

         --  find the correct location in the queue for the new event
         while I <= Last_Event and then Sooner (All_Events (I), This) loop
            I := I + 1;
         end loop;
         --  move all later events one up in the line
         for J in reverse I .. Last_Event loop
            All_Events (J+1) := All_Events (J);
         end loop;
         Last_Event := Last_Event + 1;
         All_Events (I) := This.all'Unchecked_Access;

      end Insert;


      procedure Process_Events is
         Next_Event : access Timing_Event;
      begin
         while not (Last_Event = 0) loop
            Next_Event := All_Events (1);

            if Next_Event.Timeout > Clock then

               --  We found one that has not yet timed-out. The queue
               --  is in ascending order by Timeout so there is no
               --  need to continue processing (and indeed we must
               --  not continue since we always delete the first
               --  element).

               return;
            end if;

            --  we can delete the event from the queue.
            for J in Event_Count'(2) .. Last_Event loop
               All_Events (J-1) := All_Events (J);
            end loop;
            Last_Event := Last_Event - 1;

            --  and now call the handler
            if Next_Event.Handler /= null then
               Next_Event.Handler (Next_Event);
            end if;

         end loop;

      end Process_Events;


      procedure Print_Events is
--           Idx : Event_Count;
--           Elm : access Timing_Event;

--           use AVR.Strings;
--           procedure Put (T : AVR_String) is
--           begin
--              for I in T'Range loop
--                 Ada.Text_IO.Put (T (I));
--              end loop;
--           end Put;

      begin
         null;
--       for I in 1 .. Last_Event loop
--              Elm := All_Events (I);

--              Ada.Text_IO.Put (I'Img); Ada.Text_IO.Put ("  : ");
--              Put (Image (Elm.Timeout));
--              Ada.Text_IO.New_Line;
--           end loop;
--           Ada.Text_IO.Put_Line ("--- end all events ---");
      end Print_Events;

   end Event_Queue;


   procedure Set_Handler
     (Event   : in out Timing_Event;
      At_Time : Ticks;
      Handler : Timing_Event_Handler)
   is
   begin
      -- remove existing handler for this event
      Event.Handler := null;

      -- handle expired events immediately
      if Clock >= At_Time then
         if Handler /= null then
            Handler (Event);
         end if;
         return;
      end if;

      if Handler /= null then
         Event.Timeout := At_Time;
         Event.Handler := Handler;
         Event_Queue.Insert (Event);
      end if;
   end Set_Handler;


   procedure Set_Handler
     (Event   : access Timing_Event;
      In_Time : Time_Span;
      Handler : Timing_Event_Handler)
   is
   begin
      Set_Handler (Event, Clock + In_Time, Handler);
   end Set_Handler;


   function Current_Handler
     (Event : Timing_Event) return Timing_Event_Handler
   is
   begin
      return Event.Handler;
   end Current_Handler;


   procedure Cancel_Handler
     (Event     : access Timing_Event;
      Cancelled : out Boolean)
   is
   begin
      Cancelled := Event.Handler /= null;
      Event.Handler := null;
   end Cancel_Handler;


   function Time_Of_Event (Event : Timing_Event) return Time is
   begin
      return Event.Timeout;
   end Time_Of_Event;


   function Sooner (Left, Right : access Timing_Event) return Boolean is
   begin
      return Right.Timeout > Left.Timeout;
   end Sooner;

end AVR.Real_Time.Timing_Events;
