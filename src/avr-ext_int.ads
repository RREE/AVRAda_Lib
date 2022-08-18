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


--  routines for manging external and pin change interrupts
--
--  names and values are taken from atmega168 data sheet
--

with Interfaces;                   use Interfaces;
with AVR.MCU;

package AVR.Ext_Int is
   pragma Preelaborate;

   --
   -- external interrupts
   --
   type Trigger_T is (Is_Low, Toggle, Falling_Edge, Rising_Edge);

   procedure Set_Int0_Sense_Control (Trigger : Trigger_T);
   procedure Set_Int1_Sense_Control (Trigger : Trigger_T);

   procedure Enable_External_Interrupt_0;
   procedure Enable_External_Interrupt_1;
   procedure Disable_External_Interrupt_0;
   procedure Disable_External_Interrupt_1;

   Signal_Ext_Int0 : constant String := MCU.Sig_INT0_String;
#if not (MCU = "attiny85") then
   Signal_Ext_Int1 : constant String := MCU.Sig_INT1_String;
#end if;

   --
   -- pin change interrupts (PCI)
   --

   --  provide a bit pattern for the pin change mask registers
   --  (PCMSK0, PCMSK1, PCMSK2).  If a bit is set, a pin change
   --  interrupt is enabled on the corresponding IO pin.  A cleared
   --  bit in the mask disables the PCI on the corresponding IO pin.
   procedure Select_Pins_For_PCI0 (Mask : Unsigned_8);
#if not (MCU = "attiny85") then
   procedure Select_Pins_For_PCI1 (Mask : Unsigned_8);
   procedure Select_Pins_For_PCI2 (Mask : Unsigned_8);
#end if;

   procedure Enable_Pin_Change_Interrupt_0;
   procedure Disable_Pin_Change_Interrupt_0;
#if not (MCU = "attiny85") then
   procedure Enable_Pin_Change_Interrupt_1;
   procedure Disable_Pin_Change_Interrupt_1;
   procedure Enable_Pin_Change_Interrupt_2;
   procedure Disable_Pin_Change_Interrupt_2;
#end if;

   Signal_Pin_Change_Int0 : constant String := MCU.Sig_PCINT0_String;
#if not (MCU = "attiny85") then
   Signal_Pin_Change_Int1 : constant String := MCU.Sig_PCINT1_String;
   Signal_Pin_Change_Int2 : constant String := MCU.Sig_PCINT2_String;
#end if;


private

   pragma Inline (Set_Int0_Sense_Control);
   pragma Inline (Enable_External_Interrupt_0);
   pragma Inline (Disable_External_Interrupt_0);
   pragma Inline (Select_Pins_For_PCI0);
   pragma Inline (Enable_Pin_Change_Interrupt_0);
   pragma Inline (Disable_Pin_Change_Interrupt_0);

#if not (MCU = "attiny85") then
   pragma Inline (Set_Int1_Sense_Control);
   pragma Inline (Enable_External_Interrupt_1);
   pragma Inline (Disable_External_Interrupt_1);
   pragma Inline (Select_Pins_For_PCI1);
   pragma Inline (Enable_Pin_Change_Interrupt_1);
   pragma Inline (Disable_Pin_Change_Interrupt_1);

   pragma Inline (Select_Pins_For_PCI2);
   pragma Inline (Enable_Pin_Change_Interrupt_2);
   pragma Inline (Disable_Pin_Change_Interrupt_2);
#end if;

end AVR.Ext_Int;
