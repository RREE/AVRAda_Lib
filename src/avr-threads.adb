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
-- Written by Warren W. Gay VE3WWG
---------------------------------------------------------------------------

with Interfaces;                   use Interfaces;
with System;
with Ada.Unchecked_Conversion;
with AVR;                          use AVR;
with AVR.Timer2;
with AVR.Interrupts;


package body AVR.Threads is


   Ticks : Ticks_T;
   pragma Volatile (Ticks);


   ------------------------------------------------------------------
   -- Initialize the Threading Library and Timer
   ------------------------------------------------------------------
   procedure Init is
      procedure avr_thread_init;
      pragma Import (C, avr_thread_init, "avr_thread_init");
   begin
      Interrupts.Disable_Interrupts;
      Timer2.Init_CTC(AVR.Timer2.Scale_By_1024,255);
      Ticks := 0;
      avr_thread_init;
      Interrupts.Enable_Interrupts;
   end Init;
   pragma Inline (Init);

   ------------------------------------------------------------------
   -- Change Timer Resolution
   ------------------------------------------------------------------
   procedure Set_Timer(Prescale : AVR.Timer2.Scale_Type; Compare : Unsigned_8) is
   begin

      AVR.Interrupts.Disable_Interrupts;
      AVR.Timer2.Stop;
      AVR.Timer2.Init_CTC(Prescale,Compare);
      AVR.Interrupts.Enable_Interrupts;

   end Set_Timer;

   ------------------------------------------------------------------
   -- Timer2 ISR
   ------------------------------------------------------------------

   procedure Timer2_ISR;
   pragma Machine_Attribute (Entity => Timer2_ISR, Attribute_Name => "naked");
   pragma Export (C, Timer2_ISR, Timer2.Signal_Compare);

   procedure Timer2_ISR is
      procedure avr_thread_isr_start;
      procedure avr_thread_isr_end;

      pragma Import(C,avr_thread_isr_start,"avr_thread_isr_start");
      pragma Import(C,avr_thread_isr_end,"avr_thread_isr_end");
   begin

      avr_thread_isr_start;
      Ticks := Ticks + 1;
      avr_thread_isr_end;

   end Timer2_ISR;

   ------------------------------------------------------------------
   -- Return the # Ticks from the Timer
   ------------------------------------------------------------------
   function Get_Timer_Ticks return Ticks_T is
      R : Ticks_T;
   begin
      AVR.Interrupts.Disable_Interrupts;
      R := Ticks;
      AVR.Interrupts.Enable_Interrupts;
      return R;
   end Get_Timer_Ticks;

   ------------------------------------------------------------------
   -- INTERNAL - Return Access to the Current Thread's Context Object
   ------------------------------------------------------------------
   function Get_Context return Context_Ptr is
      type C_Context_Ptr is access all Context;
      pragma Convention(Convention => C, Entity => C_Context_Ptr);

      type Ada_Context_Ptr is access all Context;
      pragma Convention(Convention => Ada, Entity => Ada_Context_Ptr);

      function To_Thread_Context_Ptr is
         new Ada.Unchecked_Conversion (Ada_Context_Ptr, Context_Ptr);

      C_Context : C_Context_Ptr;
      pragma Volatile (C_Context);
      pragma Import (C, C_Context, "avr_thread_active");

      A_Context : Ada_Context_Ptr;
   begin

      A_Context := Ada_Context_Ptr(C_Context);
      return To_Thread_Context_Ptr(A_Context);

   end Get_Context;

   ------------------------------------------------------------------
   -- Stop the Current Thread
   ------------------------------------------------------------------
   procedure Stop is
      procedure avr_thread_stop;
      pragma Import(C,avr_thread_stop,"avr_thread_stop");
   begin

      avr_thread_stop;

   end Stop;

   ------------------------------------------------------------------
   -- INTERNAL - Trampoline from C code into Ada procedure
   ------------------------------------------------------------------
   procedure Thread_Thunk;
   pragma Export (C, Thread_Thunk, "thread_thunk");

   procedure Thread_Thunk is
      C : Context_Ptr := Get_Context;
   begin

      C.Ada_Proc.all;   -- Start Ada proc
      Stop;             -- Stop it if it returns

   end Thread_Thunk;

   ------------------------------------------------------------------
   -- Start a new Thread
   ------------------------------------------------------------------
   procedure Start (C : in out Context; Proc : Thread_Proc) is
      type Func_Ptr is access procedure;
      pragma Convention (C, Func_Ptr);

      procedure avr_thread_start
        (Context : System.Address;
         Func : Func_Ptr;
         Stack : System.Address;
         Size : Interfaces.Unsigned_16);
      pragma Import(C,avr_thread_start,"avr_thread_start");
   begin

      for X in C.Stack'Range loop
         C.Stack(X) := 16#BE#;     -- Write signature bytes into stack
      end loop;

      C.Ada_Proc := Proc;   -- Tell Thread_Thunk what to start

      avr_thread_start
        (
         Context     => C.C_Context'Address,
         Func        => Thread_Thunk'Access,
         Stack       => C.Stack'Address,
         Size        => C.Stack_Size
        );

   end Start;

   ------------------------------------------------------------------
   -- Return the # of Stack Bytes Used or Zero if Corrupted
   ------------------------------------------------------------------
   function Stack_Used (C : Context) return Unsigned_16 is
   begin

      if C.Stack (C.Stack'First) /= 16#BE# then
         return 0;               -- Full stack used, & likely overrun
      end if;

      for X in C.Stack'Range loop
         if C.Stack(X) /= 16#BE# then
            return C.Stack'Last - X + 1;
         end if;
      end loop;

      return 0;                   -- This exit should never happen

   end Stack_Used;

   ------------------------------------------------------------------
   -- Yield for Some Milliseconds
   ------------------------------------------------------------------
   procedure Sleep (Ticks : Ticks_T) is
      procedure avr_thread_sleep(ticks : Unsigned_16);
      pragma Import(C,avr_thread_sleep,"avr_thread_sleep");
   begin

      avr_thread_sleep(Unsigned_16(Ticks));

   end Sleep;

   ------------------------------------------------------------------
   -- Just Yield
   ------------------------------------------------------------------
   procedure Yield is
   begin
      Sleep(0);
   end Yield;


   ------------------------------------------------------------------
   --                         M U T E X
   ------------------------------------------------------------------


   ------------------------------------------------------------------
   -- Acquire a Mutex
   ------------------------------------------------------------------
   procedure Acquire (M : in out Mutex) is
      procedure avr_thread_mutex_basic_gain(Mutex : System.Address);
      pragma Import(C,avr_thread_mutex_basic_gain,"avr_thread_mutex_basic_gain");
   begin
      avr_thread_mutex_basic_gain(M.C_Mutex'Address);
   end Acquire;

   ------------------------------------------------------------------
   -- Test and Acquire a Mutex
   ------------------------------------------------------------------
   procedure Acquire (M : in out Mutex; Success : out Boolean) is
      use Interfaces;

      function avr_thread_mutex_basic_test_and_gain(M : System.Address) return Unsigned_8;
      pragma Import(C,avr_thread_mutex_basic_test_and_gain,"avr_thread_mutex_basic_test_and_gain");
   begin
      Success := avr_thread_mutex_basic_test_and_gain(M.C_Mutex'Address) /= 0;
   end Acquire;

   ------------------------------------------------------------------
   -- Release a Mutex
   ------------------------------------------------------------------
   procedure Release (M : in out Mutex) is
      procedure avr_thread_mutex_basic_release(Mutex : System.Address);
      pragma Import(C,avr_thread_mutex_basic_release,"avr_thread_mutex_basic_release");
   begin
      avr_thread_mutex_basic_release(M.C_Mutex'Address);
   end Release;

   ------------------------------------------------------------------
   -- Nested Mutex Acquire
   --
   -- When Timeout_Ticks = 0, will block indefinitely
   -- When task already owns mutex, ownership is incremented (nested lock)
   --
   ------------------------------------------------------------------
   procedure Acquire (M : in out Nested_Mutex; Success : out Boolean; Timeout_Ticks : Ticks_T := 0) is
      use Interfaces;

      function avr_thread_mutex_gain(Mutex : System.Address; Ticks : Unsigned_16) return Unsigned_8;
      pragma Import(C,avr_thread_mutex_gain,"avr_thread_mutex_gain");
   begin
      Success := avr_thread_mutex_gain(M'Address, Unsigned_16(Timeout_Ticks)) /= 0;
   end Acquire;

   ------------------------------------------------------------------
   -- Nested Mutex Release
   --
   -- Must be released as many times as Acquired to free Mutex
   ------------------------------------------------------------------
   procedure Release(M : in out Nested_Mutex; Success : out Boolean) is
      use Interfaces;

      function avr_thread_mutex_release(Mutex : System.Address) return Unsigned_8;
      pragma Import(C,avr_thread_mutex_release,"avr_thread_mutex_release");
   begin
      Success := avr_thread_mutex_release(M'Address) /= 0;
   end Release;


   ------------------------------------------------------------------
   --                        E V E N T S
   ------------------------------------------------------------------


   ------------------------------------------------------------------
   -- Clear the Event
   --
   -- This does not release any waiting threads.
   ------------------------------------------------------------------
   procedure Clear (Ev : in out Event) is
      procedure avr_thread_event_clear (Ev : System.Address);
      pragma Import (C, avr_thread_event_clear, "avr_thread_event_clear");
   begin
      avr_thread_event_clear(Ev.C_State'Address);
   end Clear;

   ------------------------------------------------------------------
   -- Wake only one waiting thread
   ------------------------------------------------------------------
   procedure Wake_One (Ev : in out Event) is
      procedure avr_thread_event_set_wake_one(Event : System.Address);
      pragma Import(C,avr_thread_event_set_wake_one,"avr_thread_event_set_wake_one");
   begin
      avr_thread_event_set_wake_one (Ev.C_State'Address);
   end Wake_One;

   ------------------------------------------------------------------
   -- Wake all waiting threads
   ------------------------------------------------------------------
   procedure Wake_All (Ev : in out Event) is
      procedure avr_thread_event_set_wake_all(Ev : System.Address);
      pragma Import(C,avr_thread_event_set_wake_all,"avr_thread_event_set_wake_all");
   begin
      avr_thread_event_set_wake_all(Ev.C_State'Address);
   end Wake_All;

   ------------------------------------------------------------------
   -- Wait for the event to be signaled
   ------------------------------------------------------------------
   procedure Wait (Ev : in out Event; Success : out Boolean; Timeout_Ticks : Ticks_T := 0) is
      function avr_thread_event_wait(Event : System.Address; Ticks : Unsigned_16) return Unsigned_8;
      pragma Import(C,avr_thread_event_wait,"avr_thread_event_wait");
   begin
      Success := avr_thread_event_wait(Ev.C_State'Address,Unsigned_16(Timeout_Ticks)) /= 0;
   end Wait;

   ------------------------------------------------------------------
   -- Wait and Clear event when it is signaled
   ------------------------------------------------------------------
   procedure Wait_And_Clear (Ev : in out Event; Success : out Boolean; Timeout_Ticks : Ticks_T := 0) is
      function avr_thread_event_wait_and_clear(Event : System.Address; Ticks : Unsigned_16) return Unsigned_8;
      pragma Import (C, avr_thread_event_wait_and_clear, "avr_thread_event_wait_and_clear");
   begin
      Success := avr_thread_event_wait_and_clear(Ev.C_State'Address,Unsigned_16(Timeout_Ticks)) /= 0;
   end Wait_And_Clear;

begin
   Init;
end AVR.Threads;
