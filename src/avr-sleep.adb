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

with AVR.MCU;                      use AVR.MCU;
with AVR.Interrupts;

package body AVR.Sleep is


   Sleep_Enable : Boolean renames
#if MCU = "atmega8" or else MCU = "atmega32" or else MCU = "atmega162" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" then
     MCUCR_Bits(SE_Bit);
#else
     SMCR_Bits(SE_Bit);
#end if;


   SM0 : Boolean renames
#if MCU = "atmega8" or else MCU = "atmega32" or else MCU = "atmega1280" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" then
      MCUCR_Bits (SM0_Bit);
#elsif MCU = "atmega162" then
      EMCUCR_Bits (SM0_Bit);
#else
      SMCR_Bits (SM0_Bit);
#end if;


   SM1 : Boolean renames
#if MCU = "atmega8" or else MCU = "atmega32" or else MCU = "atmega162" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" then
      MCUCR_Bits (SM1_Bit);
#else
      SMCR_Bits (SM1_Bit);
#end if;


#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and (not MCU = "attiny85") then
   SM2 : Boolean renames
#if MCU = "atmega8" or else MCU = "atmega32" then
      MCUCR_Bits (SM2_Bit);
#elsif MCU = "atmega162" then
      MCUCSR_Bits (SM2_Bit);
#else
      SMCR_Bits (SM2_Bit);
#end if;
#end if;


   --  Define internal sleep types for the various devices.  Also define
   --  some internal masks for use in Set_Mode.
#if MCU = "atmega8" or else MCU = "atmega32" or else MCU = "atmega162" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" then
   Sleep_Ctrl_Bits : AVR.Bits_In_Byte renames AVR.MCU.MCUCR_Bits;
#else
   Sleep_Ctrl_Bits : AVR.Bits_In_Byte renames AVR.MCU.SMCR_Bits;
#end if;

--     subtype Bit_Range is Bit_Number range AVR.MCU.SM0_Bit .. AVR.MCU.SM2_Bit;
--     type Bit_Range_A is array (Bit_Range) of Boolean;
--     type Sleep_Mask_T is array (Sleep_Mode_T range <>) of Bit_Range_A;


--     --  mask for ATmega169 and ATmega8
--     Sleep_Mask : constant Sleep_Mask_T :=
--       (Idle                => (AVR.MCU.SM0_Bit => False,
--                                AVR.MCU.SM1_Bit => False,
--                                AVR.MCU.SM2_Bit => False),

--        ADC_Noise_Reduction => (AVR.MCU.SM0_Bit => True,
--                                AVR.MCU.SM1_Bit => False,
--                                AVR.MCU.SM2_Bit => False),

--        Power_Down          => (AVR.MCU.SM0_Bit => False,
--                                AVR.MCU.SM1_Bit => True,
--                                AVR.MCU.SM2_Bit => False),

--        Power_Save          => (AVR.MCU.SM0_Bit => True,
--                                AVR.MCU.SM1_Bit => True,
--                                AVR.MCU.SM2_Bit => False),

--        Standby             => (AVR.MCU.SM0_Bit => False,
--                                AVR.MCU.SM1_Bit => True,
--                                AVR.MCU.SM2_Bit => True));

   ---------------------------------------------------------------------------


   procedure Sleep_Instr;
   pragma Inline_Always (Sleep_Instr);
   pragma Import (Intrinsic, Sleep_Instr, "__builtin_avr_sleep");


   procedure Set_Mode (Mode : Sleep_Mode_T)
   is
      use AVR.MCU;
   begin
      --        for Bit in Bit_Range'Range loop
      --           Set_Bit (AVR.MCU.SMCR, Bit, Sleep_Mask (Mode)(Bit));
      --        end loop;
      --
      --
      --  using the above loop gcc-4.2.1 -Os requires 438 bytes on a
      --  ATmega169, wheras the below case statement only requires 96
      --  bytes.
      --
      case Mode is
      when Idle =>
         --  Sleep_Ctrl_Bits (SM0_Bit) := False;
         --  Sleep_Ctrl_Bits (SM1_Bit) := False;
         SM0 := False;
         SM1 := False;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and (not MCU = "attiny85") then
         --  Sleep_Ctrl_Bits (SM2_Bit) := False;
         SM2 := False;
#end if;

      when ADC_Noise_Reduction =>
         --  Sleep_Ctrl_Bits (SM0_Bit) := True;
         --  Sleep_Ctrl_Bits (SM1_Bit) := False;
         SM0 := True;
         SM1 := False;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and (not MCU = "attiny85") then
         --  Sleep_Ctrl_Bits (SM2_Bit) := False;
         SM2 := False;
#end if;

      when Power_Down =>
         --  Sleep_Ctrl_Bits (SM0_Bit) := False;
         --  Sleep_Ctrl_Bits (SM1_Bit) := True;
         SM0 := False;
         SM1 := True;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and (not MCU = "attiny85") then
         --  Sleep_Ctrl_Bits (SM2_Bit) := False;
         SM2 := False;
#end if;

      when Power_Save =>
         --  Sleep_Ctrl_Bits (SM0_Bit) := True;
         --  Sleep_Ctrl_Bits (SM1_Bit) := True;
         SM0 := True;
         SM1 := True;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and (not MCU = "attiny85") then
         --  Sleep_Ctrl_Bits (SM2_Bit) := False;
         SM2 := False;
#end if;

      when Standby =>
         --  Sleep_Ctrl_Bits (SM0_Bit) := False;
         --  Sleep_Ctrl_Bits (SM1_Bit) := True;
         SM0 := False;
         SM1 := True;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and (not MCU = "attiny85") then
         --  Sleep_Ctrl_Bits (SM2_Bit) := True;
         SM2 := True;
#end if;

      when Extended_Standby =>
         --  Sleep_Ctrl_Bits (SM0_Bit) := True;
         --  Sleep_Ctrl_Bits (SM1_Bit) := True;
         SM0 := True;
         SM1 := True;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and (not MCU = "attiny85") then
         --  Sleep_Ctrl_Bits (SM2_Bit) := True;
         SM2 := True;
#end if;
      end case;

   end Set_Mode;


   --  Put the device in sleep mode. How the device is brought out of
   --  sleep mode depends on the specific mode selected with the
   --  set_mode function.  See the data sheet for your device for
   --  more details.


   --  Manipulates the SE (sleep enable) bit.
   procedure Enable is
   begin
      Sleep_Enable := True;
   end Enable;

   procedure Disable is
   begin
      Sleep_Enable := False;
   end Disable;


   --  Put the device in sleep mode.
   procedure Go_Sleeping is
   begin
      Enable;
      Sleep_Instr;
      Disable;
   end Go_Sleeping;


   --  Put the device in sleep mode if Condition is true.  Condition
   --  is checked and sleep mode entered as one indivisible action.
   procedure Go_Sleeping_If (Condition : Boolean) is
      S_Reg : Unsigned_8;
   begin
      S_Reg := AVR.Interrupts.Save_And_Disable;
      if Condition then Go_Sleeping; end if;
      AVR.Interrupts.Restore (S_Reg);
   end Go_Sleeping_If;

end AVR.Sleep;
