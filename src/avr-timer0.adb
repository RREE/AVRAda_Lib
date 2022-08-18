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

--
--  supported MCUs:
--
--  ATTINY
--  attiny13    attiny13a   attiny2313  attiny4313
--
--  ATMEGA
--  atmega168   atmega169   atmega2560  atmega32    atmega328p  atmega644
--  atmega644p  _atmega8_(partly)

with Interfaces;                   use Interfaces;
with AVR;                          use AVR;
with AVR.MCU;

package body AVR.Timer0 is


#if MCU = "attiny13" or else MCU = "attiny85" or else MCU = "attiny13a" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "atmega168" or else MCU = "atmega169" or else MCU = "atmega328p" or else MCU = "atmega644" or else MCU = "atmega644p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
   Output_Compare_Reg : Unsigned_8 renames MCU.OCR0A;
#elsif mcu = "atmega32" then
   Output_Compare_Reg : Unsigned_8 renames MCU.OCR0;
#end if;


#if MCU = "attiny13" or else MCU = "attiny85" or else MCU = "attiny13a" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "atmega168" or else MCU = "atmega169" or else MCU = "atmega328p" or else MCU = "atmega644" or else MCU = "atmega644p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
   Ctrl_Reg       : Bits_In_Byte renames MCU.TCCR0A_Bits;
#elsif MCU = "atmega8" or else MCU = "atmega32" then
   Ctrl_Reg       : Bits_In_Byte renames MCU.TCCR0_Bits;
#end if;

   Prescale_Reg   : Unsigned_8 renames
#if MCU = "attiny13" or else MCU = "attiny85" or else MCU = "attiny13a" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "atmega168" or else MCU = "atmega328p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
    MCU.TCCR0B;
#elsif MCU = "atmega169" or else MCU = "atmega644" or else MCU = "atmega644p" then
    MCU.TCCR0A;
#elsif MCU = "atmega8" or else MCU = "atmega32" then
    MCU.TCCR0;
#end if;


#if MCU = "atmega8" then
   Interrupt_Mask : Bits_In_Byte renames MCU.TIMSK_Bits;
   Overflow_Interrupt_Enable       : Boolean renames MCU.TIMSK_Bits (MCU.TOIE0_Bit);
#elsif MCU = "atmega32" then
   Interrupt_Mask : Bits_In_Byte renames MCU.TIMSK_Bits;
   Output_Compare_Interrupt_Enable : Boolean renames MCU.TIMSK_Bits (MCU.OCIE0_Bit);
   Overflow_Interrupt_Enable       : Boolean renames MCU.TIMSK_Bits (MCU.TOIE0_Bit);
#elsif  MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" then
   Interrupt_Mask : Bits_In_Byte renames MCU.TIMSK_Bits;
   Output_Compare_Interrupt_Enable : Boolean renames MCU.TIMSK_Bits (MCU.OCIE0A_Bit);
   Overflow_Interrupt_Enable       : Boolean renames MCU.TIMSK_Bits (MCU.TOIE0_Bit);
#elsif MCU = "attiny13" or else MCU = "attiny13a" or else MCU = "atmega168" or else MCU = "atmega169" or else MCU = "atmega328p" or else MCU = "atmega644" or else MCU = "atmega644p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
   Interrupt_Mask : Bits_In_Byte renames MCU.TIMSK0_Bits;
   Output_Compare_Interrupt_Enable : Boolean renames MCU.TIMSK0_Bits (MCU.OCIE0A_Bit);
   Overflow_Interrupt_Enable       : Boolean renames MCU.TIMSK0_Bits (MCU.TOIE0_Bit);
#end if;


   --  the setting of the CSx bits had been verified for the following MCUs:
   --  atmega168
   --  atmega328p
   --  atmega8u2

   --  If you use a different MCU please compare the settings here
   --  with the corresponding data sheet.  And please report your
   --  finding (errors or successful verification) to
   --  avr-devel@lists.sourceforge.net.

   function No_Clock_Source return Scale_Type is
   begin
      return 0;
   end No_Clock_Source;

   function No_Prescaling   return Scale_Type is
   begin
      return MCU.CS00_Mask;
   end No_Prescaling;

   function Scale_By_8      return Scale_Type is
   begin
      return MCU.CS01_Mask;
   end Scale_By_8;

   function Scale_By_32     return Scale_Type is
   begin
#if MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" or else MCU = "atmega168" or else MCU = "atmega328p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      raise Program_Error with "1/32 not available for this MCU";
#end if;
      return MCU.CS01_Mask or MCU.CS00_Mask;
   end Scale_By_32;

   function Scale_By_64     return Scale_Type is
   begin
#if MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" or else MCU = "atmega32" or else MCU = "atmega168" or else MCU = "atmega328p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      return MCU.CS01_Mask or MCU.CS00_Mask;
#else
      return MCU.CS02_Mask;
#end if;
   end Scale_By_64;

   function Scale_By_128    return Scale_Type is
   begin
#if MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" or else MCU = "atmega168" or else MCU = "atmega328p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      raise Program_Error with "1/128 not available for this MCU";
#end if;
      return MCU.CS02_Mask or MCU.CS00_Mask;
   end Scale_By_128;

   function Scale_By_256    return Scale_Type is
   begin
#if MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" or else MCU = "atmega8" or else MCU = "atmega32" or else MCU = "atmega168" or else MCU = "atmega328p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      return MCU.CS02_Mask;
#else
      return MCU.CS02_Mask or MCU.CS01_Mask;
#end if;
   end Scale_By_256;

   function Scale_By_1024   return Scale_Type is
   begin
#if MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "attiny85" or else MCU = "atmega32" or else MCU = "atmega168" or else MCU = "atmega328p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      return MCU.CS02_Mask or MCU.CS00_Mask;
#else
      return MCU.CS02_Mask or MCU.CS01_Mask or MCU.CS00_Mask;
#end if;
   end Scale_By_1024;


   procedure Init_Normal (Prescaler : Scale_Type)
   is
   begin
#if MCU = "attiny13" or else MCU = "attiny13a" or else MCU = "attiny85" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "atmega168" or else MCU = "atmega169" or else MCU = "atmega328p" or else MCU = "atmega644p" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      Ctrl_Reg := (MCU.COM0A0_Bit => False, --  \  normal operation,
                   MCU.COM0A1_Bit => False, --  /  OC0 disconnected

                   MCU.WGM00_Bit => False,  --  \  NORMAL MODE
                   MCU.WGM01_Bit => False,  --  /

                   others    => False);
#elsif MCU = "atmega2560" then
      Ctrl_Reg := (MCU.COM0A0_Bit => False, --  \  normal operation,
                   MCU.COM0A1_Bit => False, --  /  OC0 disconnected

                   MCU.WGM00_Bit => False,  --  \
                   MCU.WGM01_Bit => False,  --  |  NORMAL MODE
                   MCU.WGM02_Bit => False,  --  /

                   others    => False);

#elsif MCU = "atemga8" or else MCU = "atmega32" then
      Ctrl_Reg := (MCU.COM00_Bit => False,  --  \  normal operation,
                   MCU.COM01_Bit => False,  --  /  OC0 disconnected

                   MCU.WGM00_Bit => False,  --  \  NORMAL MODE
                   MCU.WGM01_Bit => False,  --  /

                   others    => False);
#end if;

      --  select the clock
      Prescale_Reg := Prescale_Reg or Prescaler;

      --  enable Timer0 Overflow
      Overflow_Interrupt_Enable := True;

      --  clear interrupt-flags of timer/counter0
      -- MCU.TIFR0 := 16#FF#;

      MCU.TCNT0 := 0;
   end Init_Normal;


   procedure Init_CTC (Prescaler : Scale_Type; Overflow : Unsigned_8 := 0)
   is
   begin
      --  set the control register with the prescaler and mode flags to
      --  timer output compare mode and clear timer on compare match
#if MCU = "attiny13" or else MCU = "attiny13a" or else MCU = "attiny85" or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "atmega168" or else MCU = "atmega169" or else MCU = "atmega328p" or else MCU = "atmega644" or else MCU = "atmega644p" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      Ctrl_Reg := (MCU.COM0A0_Bit => False, --  \  normal operation,
                   MCU.COM0A1_Bit => False, --  /  OC0 disconnected

                   MCU.WGM00_Bit => False,  --  \  Clear Timer on Compare
                   MCU.WGM01_Bit => True,   --  /  Match (CTC)

                   others    => False);
#elsif MCU = "atmega2560" then
      Ctrl_Reg := (MCU.COM0A0_Bit => False, --  \  normal operation,
                   MCU.COM0A1_Bit => False, --  /  OC0 disconnected

                   MCU.WGM00_Bit => False,  --  \  Clear Timer on Compare
                   MCU.WGM01_Bit => True ,  --  |  Match (CTC)
                   MCU.WGM02_Bit => False,  --  /

                   others    => False);

#elsif MCU = "atmega32" then
      Ctrl_Reg := (MCU.COM00_Bit => False,  --  \  normal operation,
                   MCU.COM01_Bit => False,  --  /  OC0 disconnected

                   MCU.WGM00_Bit => False,  --  \  Clear Timer on Compare
                   MCU.WGM01_Bit => True,   --  /  Match (CTC)

                   others    => False);
#end if;

      --  select the clock
      Prescale_Reg := Prescale_Reg or Prescaler;

#if not MCU = "atmega8" then
      --  enable Timer0 output compare interrupt
      Output_Compare_Interrupt_Enable := True;

      Output_Compare_Reg := Overflow;
#end if;

      --  reset all counters
      MCU.TCNT0 := 0;

   end Init_CTC;


#if MCU = "attiny13" or else MCU = "attiny13a" or else MCU = "attiny85"  or else MCU = "attiny2313" or else MCU = "attiny4313" or else MCU = "atmega168" or else MCU = "atmega169" or else MCU = "atmega2560" or else MCU = "atmega328p" or else MCU = "atmega644" or else MCU = "atmega644p" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
   Com0 : Boolean renames Ctrl_Reg (MCU.COM0A0_Bit);
   Com1 : Boolean renames Ctrl_Reg (MCU.COM0A1_Bit);
#elsif MCU = "atmega32" then
   Com0 : Boolean renames Ctrl_Reg (MCU.COM00_Bit);
   Com1 : Boolean renames Ctrl_Reg (MCU.COM01_Bit);
#end if;

   procedure Set_Output_Compare_Mode_Normal is
   begin
#if not MCU = "atmega8" then
      Com0 := False;
      Com1 := False;
#else
      pragma Not_Implemented; null;
#end if;
   end Set_Output_Compare_Mode_Normal;

   procedure Set_Output_Compare_Mode_Toggle is
   begin
#if not MCU = "atmega8" then
      Com0 := True;
      Com1 := False;
#else
      pragma Not_Implemented; null;
#end if;
   end Set_Output_Compare_Mode_Toggle;

   procedure Set_Output_Compare_Mode_Set is
   begin
#if not MCU = "atmega8" then
      Com0 := True;
      Com1 := True;
#else
      pragma Not_Implemented; null;
#end if;
   end Set_Output_Compare_Mode_Set;

   procedure Set_Output_Compare_Mode_Clear is
   begin
#if not MCU = "atmega8" then
      Com0 := False;
      Com1 := True;
#else
      pragma Not_Implemented; null;
#end if;
   end Set_Output_Compare_Mode_Clear;


   procedure Stop is
   begin
      -- Stop the timer and disable all timer interrupts
      Prescale_Reg := No_Clock_Source;
      Interrupt_Mask := (others => Low);
   end Stop;


   procedure Enable_Interrupt_Compare is
   begin
#if not MCU = "atmega8" then
      Output_Compare_Interrupt_Enable := True;
#else
      pragma Not_Implemented; null;
#end if;
   end Enable_Interrupt_Compare;


   procedure Enable_Interrupt_Overflow is
   begin
      Overflow_Interrupt_Enable := True;
   end Enable_Interrupt_Overflow;


   procedure Disable_Interrupt_Compare is
   begin
#if not MCU = "atmega8" then
      Output_Compare_Interrupt_Enable := False;
#else
      pragma Not_Implemented; null;
#end if;
   end Disable_Interrupt_Compare;


   procedure Disable_Interrupt_Overflow is
   begin
      Overflow_Interrupt_Enable := False;
   end Disable_Interrupt_Overflow;


   procedure Set_Overflow_At (Overflow : Unsigned_8) is
   begin
#if not MCU = "atmega8" then
      Output_Compare_Reg := Overflow;
#else
      pragma Not_Implemented; null;
#end if;
   end Set_Overflow_At;

end AVR.Timer0;
