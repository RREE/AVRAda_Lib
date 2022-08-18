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

package AVR.Timer0 is
   pragma Preelaborate;


   Counter : Unsigned_8 renames MCU.TCNT0;


   --
   --  Different scaling factors for timer clock input.
   --
   --  Verify in the data sheet that the scaling factor is available
   --  at all for your mcu.
   --
   subtype Scale_Type is Unsigned_8;
   function No_Clock_Source return Scale_Type;
   function No_Prescaling   return Scale_Type;
   function Scale_By_8      return Scale_Type;
   function Scale_By_32     return Scale_Type;
   function Scale_By_64     return Scale_Type;
   function Scale_By_128    return Scale_Type;
   function Scale_By_256    return Scale_Type;
   function Scale_By_1024   return Scale_Type;

   procedure Init_Normal (Prescaler : Scale_Type);
   procedure Init_CTC (Prescaler : Scale_Type; Overflow : Unsigned_8 := 0);
   procedure Set_Overflow_At (Overflow : Unsigned_8);

   procedure Set_Output_Compare_Mode_Normal;
   procedure Set_Output_Compare_Mode_Toggle;
   procedure Set_Output_Compare_Mode_Clear;
   procedure Set_Output_Compare_Mode_Set;

   procedure Stop;  --  set prescaler to No_Clock_Source, disable timer interrupts
   procedure Enable_Interrupt_Compare;
   procedure Enable_Interrupt_Overflow;
   procedure Disable_Interrupt_Compare;
   procedure Disable_Interrupt_Overflow;

#if MCU = "attiny13" or else MCU = "attiny13a" then
   Signal_Compare  : constant String := MCU.Sig_TIM0_COMPA_String;
   Signal_Overflow : constant String := MCU.Sig_TIM0_OVF_String;
#elsif MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" or else MCU = "atmega168" or else MCU = "atmega328p" or else MCU = "atmega644" or else MCU = "atmega644p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
   Signal_Compare  : constant String := MCU.Sig_TIMER0_COMPA_String;
   Signal_Overflow : constant String := MCU.Sig_TIMER0_OVF_String;
#elsif MCU = "atmega169" or else MCU = "atmega32" then
   Signal_Compare  : constant String := MCU.Sig_TIMER0_COMP_String;
   Signal_Overflow : constant String := MCU.Sig_TIMER0_OVF_String;
#elsif MCU = "atmega8" then
   Signal_Compare  : constant String := "not available";
   Signal_Overflow : constant String := MCU.Sig_TIMER0_OVF_String;
#end if;

private

   pragma Inline (No_Clock_Source);
   pragma Inline (No_Prescaling);
   pragma Inline (Scale_By_8);
   pragma Inline (Scale_By_32);
   pragma Inline (Scale_By_64);
   pragma Inline (Scale_By_128);
   pragma Inline (Scale_By_256);
   pragma Inline (Scale_By_1024);
   pragma Inline (Stop);
   pragma Inline (Set_Overflow_At);
   pragma Inline (Enable_Interrupt_Compare);
   pragma Inline (Enable_Interrupt_Overflow);

--     pragma Inline (Set_Output_Compare_Mode_Normal);
--     pragma Inline (Set_Output_Compare_Mode_Toggle);
--     pragma Inline (Set_Output_Compare_Mode_Clear);
--     pragma Inline (Set_Output_Compare_Mode_Set);
end AVR.Timer0;
