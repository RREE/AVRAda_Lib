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
--  ATTINY:
--
--  ATMEGA:
--  atmega168   atmega169   atmega2560  atmega32    atmega328p  atmega644
--  atmega644p  _atmega8_(partly) atmega8u2

with Interfaces;                   use Interfaces;
with AVR;                          use AVR;
with AVR.MCU;

package body AVR.Timer1 is


   Output_Compare_Reg : Unsigned_16 renames MCU.OCR1A;

   Ctrl_Reg           : Bits_In_Byte renames MCU.TCCR1A_Bits;

   Prescale_Reg       : Unsigned_8 renames MCU.TCCR1B;


#if MCU = "atmega168" or else MCU = "atmega169" or else MCU = "atmega2560" or else MCU = "atmega328p" or else MCU = "atmega644" or else MCU = "atmega644p" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
   Interrupt_Mask : Bits_In_Byte renames MCU.TIMSK1_Bits;
#elsif MCU = "atmega8" or else MCU = "atmega32" or else MCU = "atmega162" or else MCU = "attiny4313" or else MCU = "attiny2313" then
   Interrupt_Mask : Bits_In_Byte renames MCU.TIMSK_Bits;
#end if;
   Output_Compare_Interrupt_Enable : Boolean renames Interrupt_Mask (MCU.OCIE1A_Bit);
   Overflow_Interrupt_Enable       : Boolean renames Interrupt_Mask (MCU.TOIE1_Bit);


   WGM0 : Boolean renames MCU.TCCR1A_Bits (MCU.WGM10_Bit);
   WGM1 : Boolean renames MCU.TCCR1A_Bits (MCU.WGM11_Bit);
   WGM2 : Boolean renames MCU.TCCR1B_Bits (MCU.WGM12_Bit);
   WGM3 : Boolean renames MCU.TCCR1B_Bits (MCU.WGM13_Bit);

   Com0  : Boolean renames Ctrl_Reg (MCU.COM1A0_Bit);
   Com1  : Boolean renames Ctrl_Reg (MCU.COM1A1_Bit);
   ComB0 : Boolean renames Ctrl_Reg (MCU.COM1B0_Bit);
   ComB1 : Boolean renames Ctrl_Reg (MCU.COM1B1_Bit);


   function No_Clock_Source return Scale_Type is
   begin
      return 0;
   end No_Clock_Source;

   function No_Prescaling   return Scale_Type is
   begin
      return MCU.CS10_Mask;
   end No_Prescaling;

   function Scale_By_8      return Scale_Type is
   begin
      return MCU.CS11_Mask;
   end Scale_By_8;

   function Scale_By_64     return Scale_Type is
   begin
      return MCU.CS11_Mask or MCU.CS10_Mask;
   end Scale_By_64;

   function Scale_By_256    return Scale_Type is
   begin
      return MCU.CS12_Mask;
   end Scale_By_256;

   function Scale_By_1024   return Scale_Type is
   begin
      return MCU.CS12_Mask or MCU.CS10_Mask;
   end Scale_By_1024;


   procedure Init_Common (Prescaler : Scale_Type)
   is
   begin
      --  reset power reduction for Timer1
#if MCU = "atmega328p" then
      MCU.PRR_Bits (MCU.PRTIM1_Bit) := Low;
#elsif MCU = "atmega644p" or else MCU = "atmega2560" or else MCU = "atmega8u2" or else MCU = "at90usb1286" or else MCU = "atmega32u4" then
      MCU.PRR0_Bits (MCU.PRTIM1_Bit) := Low;
#end if;

      --  select the clock
      Prescale_Reg := Prescale_Reg or Prescaler;

      MCU.TCNT1 := 0;
   end Init_Common;


   procedure Init_Normal (Prescaler : Scale_Type)
   is
   begin
      Ctrl_Reg := (MCU.COM1A0_Bit => False, --  \  normal operation,
                   MCU.COM1A1_Bit => False, --  /  OC0 disconnected

                   MCU.WGM10_Bit => False,  --  \  NORMAL MODE
                   MCU.WGM11_Bit => False,  --  /

                   others    => False);

      Init_Common (Prescaler);

      --  enable Timer1 Overflow
      Overflow_Interrupt_Enable := True;
   end Init_Normal;


   procedure Init_CTC (Prescaler : Scale_Type; Overflow : Unsigned_16 := 0)
   is
   begin
      --  set the control register with the prescaler and mode flags to
      --  timer output compare mode and clear timer on compare match
      Ctrl_Reg := (MCU.COM1A0_Bit => False, --  \  normal operation,
                   MCU.COM1A1_Bit => False, --  /  OC0 disconnected

                   MCU.WGM10_Bit => False,  --  \  Clear Timer on Compare
                   MCU.WGM11_Bit => True,   --  /  Match (CTC)

                   others    => False);

      Init_Common (Prescaler);

      --  enable Timer1 output compare interrupt
      Output_Compare_Interrupt_Enable := True;

      Output_Compare_Reg := Overflow;
   end Init_CTC;


   procedure Init_PWM (Prescaler      : Scale_Type;
                       PWM_Resolution : PWM_Type;
                       Inverted       : Boolean := False)
   is
   begin
      Init_Common (Prescaler);

      WGM0 := PWM_Resolution(0);
      WGM1 := PWM_Resolution(1);
      WGM2 := PWM_Resolution(2);
      WGM3 := PWM_Resolution(3);

      Com0 := Inverted;
      Com1 := High;
   end Init_PWM;


   procedure Set_Output_Compare_Mode_Normal is
   begin
      Com0 := False;
      Com1 := False;
   end Set_Output_Compare_Mode_Normal;

   procedure Set_Output_Compare_Mode_Toggle is
   begin
      Com0 := True;
      Com1 := False;
   end Set_Output_Compare_Mode_Toggle;

   procedure Set_Output_Compare_Mode_Set is
   begin
      Com0 := True;
      Com1 := True;
   end Set_Output_Compare_Mode_Set;

   procedure Set_Output_Compare_Mode_Clear is
   begin
      Com0 := False;
      Com1 := True;
   end Set_Output_Compare_Mode_Clear;

   procedure Set_Output_Compare_Mode_B_Normal is
   begin
      ComB0 := False;
      ComB1 := False;
   end Set_Output_Compare_Mode_B_Normal;

   procedure Set_Output_Compare_Mode_B_Toggle is
   begin
      ComB0 := True;
      ComB1 := False;
   end Set_Output_Compare_Mode_B_Toggle;

   procedure Set_Output_Compare_Mode_B_Clear is
   begin
      ComB0 := False;
      ComB1 := True;
   end Set_Output_Compare_Mode_B_Clear;

   procedure Set_Output_Compare_Mode_B_Set is
   begin
      ComB0 := True;
      ComB1 := True;
   end Set_Output_Compare_Mode_B_Set;


   procedure Stop is
   begin
      -- Stop the timer and disable all timer interrupts
      Prescale_Reg := No_Clock_Source;
      Interrupt_Mask := (others => Low);
   end Stop;


   procedure Enable_Interrupt_Compare is
   begin
      Output_Compare_Interrupt_Enable := True;
   end Enable_Interrupt_Compare;

   procedure Enable_Interrupt_Overflow is
   begin
      Overflow_Interrupt_Enable := True;
   end Enable_Interrupt_Overflow;

   procedure Set_Overflow_At (Overflow : Unsigned_16) is
   begin
      Output_Compare_Reg := Overflow;
   end Set_Overflow_At;

end AVR.Timer1;
