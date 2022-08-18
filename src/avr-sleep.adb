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

with AVR.MCU;
with AVR.Interrupts;

package body AVR.Sleep is


   --  Define internal sleep types for the various devices.  Also define
   --  some internal masks for use in Set_Mode.
#if MCU = "atmega8" or else MCU = "atmega32" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" then
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


--     -- Define the sleep modes according to the internal sleep types.
--  #if _SLEEP_TYPE == 1
--     #define SLEEP_MODE_IDLE         0
--       #define SLEEP_MODE_PWR_DOWN     _BV(SM)
--  #endif


--  #if _SLEEP_TYPE == 2

--  --
--  --   * Type 2 devices are not completely identical, so we need a few
--  --   * #ifdefs here.
--  --   *
--  --   * Note that it appears the datasheet of the tiny2313 has the bottom
--  --   * two lines of table 13 with the wrong SM0/SM1 values.

--  #define SLEEP_MODE_IDLE         0

--  #if !defined(__AVR_ATtiny2313__) && !defined(__AVR_AT94K__)
--  -- no ADC in ATtiny2313, SM0 is alternative powerdown mode
--  -- no ADC in AT94K, setting SM0 only is reserved
--  # define SLEEP_MODE_ADC          _BV(SM0)
--  #endif -- !defined(__AVR_ATtiny2313__) && !defined(__AVR_AT94K__)

--  #define SLEEP_MODE_PWR_DOWN     _BV(SM1)

--  #if defined(__AVR_ATtiny2313__) || defined(__AVR_ATtiny26__)
--  -- tiny2313 and tiny26 have standby rather than powersave */
--  # define SLEEP_MODE_STANDBY      (_BV(SM0) | _BV(SM1))
--  #elif !defined(__AVR_ATtiny13__)
--  -- SM0|SM1 is reserved on the tiny13 */
--  # define SLEEP_MODE_PWR_SAVE     (_BV(SM0) | _BV(SM1))
--  #endif

--  #endif


--  #if _SLEEP_TYPE == 3 || defined(__DOXYGEN__)
--  -- \ingroup avr_sleep
--  --      \def SLEEP_MODE_IDLE
--  --      Idle mode.
--  #define SLEEP_MODE_IDLE         0
--  --* \ingroup avr_sleep
--  --      \def SLEEP_MODE_ADC
--  --      ADC Noise Reduction Mode. */
--  #define SLEEP_MODE_ADC          _BV(SM0)
--  --* \ingroup avr_sleep
--  --      \def SLEEP_MODE_PWR_DOWN
--  --      Power Down Mode. */
--  #define SLEEP_MODE_PWR_DOWN     _BV(SM1)
--  --* \ingroup avr_sleep
--  --      \def SLEEP_MODE_PWR_SAVE
--  --      Power Save Mode. */
--  #define SLEEP_MODE_PWR_SAVE     (_BV(SM0) | _BV(SM1))
--  --* \ingroup avr_sleep
--  --      \def SLEEP_MODE_STANDBY
--  --      Standby Mode. */
--  #define SLEEP_MODE_STANDBY      (_BV(SM1) | _BV(SM2))
--  --* \ingroup avr_sleep
--  --      \def SLEEP_MODE_EXT_STANDBY
--  --      Extended Standby Mode. */
--  #define SLEEP_MODE_EXT_STANDBY  (_BV(SM0) | _BV(SM1) | _BV(SM2))
--  #endif


--  #if _SLEEP_TYPE == 4
--  #define SLEEP_MODE_IDLE         0
--  #define SLEEP_MODE_PWR_DOWN     1
--  #define SLEEP_MODE_PWR_SAVE     2
--  #define SLEEP_MODE_ADC          3
--  #define SLEEP_MODE_STANDBY      4
--  #define SLEEP_MODE_EXT_STANDBY  5
--  #endif


--  #if _SLEEP_TYPE == 5
--  #define SLEEP_MODE_IDLE         0
--  #define SLEEP_MODE_PWR_DOWN     1
--  #define SLEEP_MODE_PWR_SAVE     2
--  #endif


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
         Sleep_Ctrl_Bits (SM0_Bit) := False;
         Sleep_Ctrl_Bits (SM1_Bit) := False;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and ( not MCU = "attiny85" ) then
         Sleep_Ctrl_Bits (SM2_Bit) := False;
#end if;

      when ADC_Noise_Reduction =>
         Sleep_Ctrl_Bits (SM0_Bit) := True;
         Sleep_Ctrl_Bits (SM1_Bit) := False;
#if ( not MCU = "attiny2313" ) and ( not MCU = "attiny4313" ) and ( not MCU = "attiny85" ) then
         Sleep_Ctrl_Bits (SM2_Bit) := False;
#end if;

      when Power_Down =>
         Sleep_Ctrl_Bits (SM0_Bit) := False;
         Sleep_Ctrl_Bits (SM1_Bit) := True;
#if (not MCU = "attiny2313") and (not MCU = "attiny4313") and ( not MCU = "attiny85" ) then
         Sleep_Ctrl_Bits (SM2_Bit) := False;
#end if;

      when Power_Save =>
         Sleep_Ctrl_Bits (SM0_Bit) := True;
         Sleep_Ctrl_Bits (SM1_Bit) := True;
#if (not MCU = "attiny2313" ) and (not MCU = "attiny4313" ) and ( not MCU = "attiny85" ) then
         Sleep_Ctrl_Bits (SM2_Bit) := False;
#else
         raise Program_Error with "Power_Save not supported on this MCU";
#end if;

      when Standby =>
         Sleep_Ctrl_Bits (SM0_Bit) := False;
         Sleep_Ctrl_Bits (SM1_Bit) := True;
#if ( not MCU = "attiny2313" ) and ( not MCU = "attiny4313" ) and ( not MCU = "attiny85" ) then
         Sleep_Ctrl_Bits (SM2_Bit) := True;
#else
         raise Program_Error with "Standby not supported on this MCU";
#end if;

      when Extended_Standby =>
         Sleep_Ctrl_Bits (SM0_Bit) := True;
         Sleep_Ctrl_Bits (SM1_Bit) := True;
#if ( not MCU = "attiny2313" ) and ( not MCU = "attiny4313" ) and ( not MCU = "attiny85" ) then
         Sleep_Ctrl_Bits (SM2_Bit) := True;
#else
         raise Program_Error with "Extended_Standby not supported on this MCU";
#end if;
      end case;

   end Set_Mode;


--  #elif _SLEEP_TYPE == 5

--  #define set_sleep_mode(mode) \
--  do { \
--      MCUCR = ((MCUCR & ~_BV(SM1)) | ((mode) == SLEEP_MODE_PWR_DOWN || (mode) == SLEEP_MODE_PWR_SAVE ? _BV(SM1) : 0));
--      EMCUCR = ((EMCUCR & ~_BV(SM0)) | ((mode) == SLEEP_MODE_PWR_SAVE ? _BV(SM0) : 0));
--  } while(0)

--  #elif _SLEEP_TYPE == 4

--  #define set_sleep_mode(mode) \
--  do { \
--      MCUCR = ((MCUCR & ~_BV(SM1)) | ((mode) == SLEEP_MODE_IDLE ? 0 : _BV(SM1))); \
--      MCUCSR = ((MCUCSR & ~_BV(SM2)) | ((mode) == SLEEP_MODE_STANDBY  || (mode) == SLEEP_MODE_EXT_STANDBY ? _BV(SM2) : 0)); \
--      EMCUCR = ((EMCUCR & ~_BV(SM0)) | ((mode) == SLEEP_MODE_PWR_SAVE || (mode) == SLEEP_MODE_EXT_STANDBY ? _BV(SM0) : 0)); \
--  } while(0)

--  #elif _SLEEP_TYPE == 3 || _SLEEP_TYPE == 2 || _SLEEP_TYPE == 1

--  #define set_sleep_mode(mode) \
--  do { \
--      _SLEEP_CONTROL_REG = ((_SLEEP_CONTROL_REG & ~_SLEEP_MODE_MASK) | (mode)); \
--  } while(0)

--  #endif

   --  Put the device in sleep mode. How the device is brought out of
   --  sleep mode depends on the specific mode selected with the
   --  set_mode function.  See the data sheet for your device for
   --  more details.


   --  Manipulates the SE (sleep enable) bit.
   procedure Enable is
   begin
      Sleep_Ctrl_Bits (AVR.MCU.SE_Bit) := True;
   end Enable;

   procedure Disable is
   begin
      Sleep_Ctrl_Bits (AVR.MCU.SE_Bit) := False;
   end Disable;


   --  Put the device in sleep mode. SE-bit must be set beforehand.
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
