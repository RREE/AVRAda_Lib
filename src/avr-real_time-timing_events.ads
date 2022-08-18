------------------------------------------------------------------------------
--                                                                          --
--                                                                          --
--          A V R . R E A L _ T I M E . T I M I N G _ E V E N T S           --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --
-- This specification is derived from the Ada Reference Manual for use with --
-- AVR-Ada.                                                                 --
--                                                                          --
--                                                                          --
------------------------------------------------------------------------------


package AVR.Real_Time.Timing_Events is

   type Timing_Event is limited private;

   type Timing_Event_Handler
     is access procedure (Event : access Timing_Event);

   procedure Set_Handler
     (Event   : access Timing_Event;
      At_Time : Time;
      Handler : Timing_Event_Handler);

   --  procedure Set_Handler
   --    (Event   : access Timing_Event;
   --     At_Time : Time;
   --     Handler : access procedure (Event : access Timing_Event));

   procedure Set_Handler
     (Event   : access Timing_Event;
      In_Time : Time_Span;
      Handler : Timing_Event_Handler);

   function Current_Handler
     (Event : Timing_Event) return Timing_Event_Handler;

   procedure Cancel_Handler
     (Event     : access Timing_Event;
      Cancelled : out Boolean);

   function Time_Of_Event (Event : Timing_Event) return Time;

private

   type Timing_Event is record

      --  D.15 (22/2) requires atomicity with respect to the
      --  operations provided by the package and the timing events
      --  they manipulate. On real-time operating systems suitable for
      --  implementing this package, a different implementation
      --  strategy would be employed to meet that requirement.

      Timeout : Time := Time_First;
      --  The time at which the user's handler should be invoked when the
      --  event is "set" (i.e., when Handler is not null).

      Handler : Timing_Event_Handler;
      --  An access value designating the protected procedure to be invoked
      --  at the Timeout time in the future.  When this value is null the event
      --  is said to be "cleared" and no timeout is processed.

   end record;


   package Event_Queue is

      procedure Insert (This : access Timing_Event);
      --  Inserts This into the queue in ascending order by Timeout

      procedure Process_Events;
      --  Iterates over the list of events and calls the handlers for any of
      --  those that have timed out. Deletes those that have timed out.

      procedure Print_Events;

   end Event_Queue;


   pragma Inline (Cancel_Handler);
   pragma Inline (Current_Handler);
   pragma Inline (Time_Of_Event);

end AVR.Real_Time.Timing_Events;
