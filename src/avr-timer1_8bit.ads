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


with Interfaces;                   use Interfaces;
with AVR.MCU;

package AVR.Timer1_8bit is
   pragma Preelaborate;


   -- The main counter of the timer
   Counter : Unsigned_8 renames MCU.TCNT1;


   --
   --  Different scaling factors for timer clock input.
   --
   --  Verify in the data sheet that the scaling factor is available
   --  at all for your mcu.
   --
   subtype Scale_Type is Unsigned_8;
   function No_Clock_Source return Scale_Type;
   function No_Prescaling   return Scale_Type;
   function Scale_By_2      return Scale_Type;
   function Scale_By_4      return Scale_Type;
   function Scale_By_8      return Scale_Type;
   function Scale_By_16     return Scale_Type;
   function Scale_By_32     return Scale_Type;
   function Scale_By_64     return Scale_Type;
   function Scale_By_128    return Scale_Type;
   function Scale_By_256    return Scale_Type;
   function Scale_By_512    return Scale_Type;
   function Scale_By_1024   return Scale_Type;
   function Scale_By_2048   return Scale_Type;
   function Scale_By_4096   return Scale_Type;
   function Scale_By_8192   return Scale_Type;
   function Scale_By_16384  return Scale_Type;

   --  type PWM_Type is private;
   --  Fast_PWM            : constant PWM_Type; --  TOP = FF
   --  Phase_Correct_PWM   : constant PWM_Type;

   --  normal mode
   procedure Init_Normal (Prescaler : Scale_Type);
   --  clear timer on compare match
   procedure Init_CTC (Prescaler : Scale_Type; Overflow : Unsigned_8 := 0);
   procedure Set_Overflow_At (Overflow : Unsigned_8);
   --  PWM modes
   --  procedure Init_PWM (Prescaler      : Scale_Type;
   --                      PWM_Resolution : PWM_Type;
   --                      Inverted       : Boolean := False);


   procedure Set_Output_Compare_Mode_Normal;
   procedure Set_Output_Compare_Mode_Toggle;
   procedure Set_Output_Compare_Mode_Clear;
   procedure Set_Output_Compare_Mode_Set;

   procedure Stop;  --  set prescaler to No_Clock_Source, disable timer interrupts
   procedure Enable_Interrupt_Compare;
   procedure Enable_Interrupt_Overflow;

-- #if MCU = "attiny85" then
   Signal_Compare  : constant String := MCU.Sig_TIMER1_COMPA_String;
-- #end if
   Signal_Overflow : constant String := MCU.Sig_TIMER1_OVF_String;

private

   --  type PWM_Bits is (WGM0, WGM1, WGM2);

   --  type PWM_Type is array (PWM_Bits) of Boolean;

   --  Fast_PWM          : constant PWM_Type :=
   --    (WGM0 => True,  WGM1 => True,  WGM2 => True);  --  TOP = FF
   --  Phase_Correct_PWM : constant PWM_Type :=
   --    (WGM0 => True,  WGM1 => False, WGM2 => False); --  TOP = FF


   pragma Inline (No_Clock_Source);
   pragma Inline (No_Prescaling);
   pragma Inline (Scale_By_2);
   pragma Inline (Scale_By_4);
   pragma Inline (Scale_By_8);
   pragma Inline (Scale_By_16);
   pragma Inline (Scale_By_32);
   pragma Inline (Stop);
   pragma Inline (Set_Overflow_At);
   pragma Inline (Enable_Interrupt_Compare);
   pragma Inline (Enable_Interrupt_Overflow);

end AVR.Timer1_8bit;
