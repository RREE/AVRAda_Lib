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
with AVR;                          use AVR;
with AVR.MCU;
with AVR.Interrupts;

package body AVR.Timer1_8bit is


   Output_Compare_Reg : Unsigned_8 renames MCU.OCR1A;
   Ctrl_Reg       : Bits_In_Byte renames MCU.TCCR1_Bits;

   Prescale_Reg   : Unsigned_8 renames MCU.TCCR1;

   Interrupt_Mask : Bits_In_Byte renames MCU.TIMSK_Bits;
   Output_Compare_Interrupt_Enable : Boolean renames Interrupt_Mask (MCU.OCIE1A_Bit);
   Overflow_Interrupt_Enable       : Boolean renames Interrupt_Mask (MCU.TOIE1_Bit);


   function No_Clock_Source return Scale_Type is
   begin
      return 0;
   end No_Clock_Source;

   function No_Prescaling   return Scale_Type is
   begin
      return MCU.CS10_Mask;
   end No_Prescaling;

   function Scale_By_2      return Scale_Type is
   begin
      return MCU.CS11_Mask;
   end Scale_By_2;

   function Scale_By_4      return Scale_Type is
   begin
      return MCU.CS11_Mask or MCU.CS10_Mask;
   end Scale_By_4;

   function Scale_By_8      return Scale_Type is
   begin
      return MCU.CS12_Mask;
   end Scale_By_8;

   function Scale_By_16    return Scale_Type is
   begin
      return MCU.CS12_Mask or MCU.CS10_Mask;
   end Scale_By_16;

   function Scale_By_32     return Scale_Type is
   begin
      return MCU.CS12_Mask or MCU.CS11_Mask;
   end Scale_By_32;

   function Scale_By_64     return Scale_Type is
   begin
      return MCU.CS12_Mask or MCU.CS11_Mask or MCU.CS10_Mask;
   end Scale_By_64;

   function Scale_By_128    return Scale_Type is
   begin
      return MCU.CS13_Mask;
   end Scale_By_128;

   function Scale_By_256    return Scale_Type is
   begin
      return MCU.CS13_Mask or MCU.CS10_Mask;
   end Scale_By_256;

   function Scale_By_512    return Scale_Type is
   begin
      return MCU.CS13_Mask or MCU.CS11_Mask;
   end Scale_By_512;

   function Scale_By_1024   return Scale_Type is
   begin
      return MCU.CS13_Mask or MCU.CS11_Mask or MCU.CS10_Mask;
   end Scale_By_1024;

   function Scale_By_2048   return Scale_Type is
   begin
      return MCU.CS13_Mask or MCU.CS12_Mask;
   end Scale_By_2048;

   function Scale_By_4096   return Scale_Type is
   begin
      return MCU.CS13_Mask or MCU.CS12_Mask or MCU.CS10_Mask;
   end Scale_By_4096;

   function Scale_By_8192   return Scale_Type is
   begin
      return MCU.CS13_Mask or MCU.CS12_Mask or MCU.CS11_Mask;
   end Scale_By_8192;

   function Scale_By_16384  return Scale_Type is
   begin
      return MCU.CS13_Mask or MCU.CS12_Mask or MCU.CS11_Mask or MCU.CS10_Mask;
   end Scale_By_16384;


   procedure Init_CTC (Prescaler : Scale_Type; Overflow : Unsigned_8 := 0)
   is
      Interrupt_Status : Unsigned_8;
   begin

      Interrupt_Status := Interrupts.Save_And_Disable;

      --  set the control register with the prescaler and mode flags to
      --  timer output compare mode and clear timer on compare match
      Ctrl_Reg := (MCU.COM1A0_Bit => False, --  \  normal operation,
                   MCU.COM1A1_Bit => False, --  /  OC0 disconnected
                   MCU.CTC1_Bit => True,   --  Clear Timer on Compare Match (CTC)
                   others    => False);

      --  select the clock
      Prescale_Reg := Prescale_Reg or Prescaler;

      --  enable Timer2 output compare interrupt
      Output_Compare_Interrupt_Enable := True;

      Output_Compare_Reg := Overflow;

      -- Clear_Overflow_Count;
      MCU.TCNT1 := 0;

      Interrupts.Restore (Interrupt_Status);

   end Init_CTC;


   procedure Init_Normal (Prescaler : Scale_Type)
   is
      Interrupt_Status : Unsigned_8;
   begin

      Interrupt_Status := Interrupts.Save_And_Disable;

      --  set the control register with the prescaler and mode flags to
      --  timer output compare mode and clear timer on compare match
      Ctrl_Reg := (MCU.COM1A0_Bit => False, --  \  normal operation,
                   MCU.COM1A1_Bit => False, --  /  OC0 disconnected
                   others    => False);

      --  select the clock
      Prescale_Reg := Prescale_Reg or Prescaler;

      --  enable Timer1 overflow interrupt
      Overflow_Interrupt_Enable := True;

      -- Clear_Overflow_Count;
      MCU.TCNT1 := 0;

      Interrupts.Restore (Interrupt_Status);

   end Init_Normal;


   --  PWM modes
   --  procedure Init_PWM (Prescaler      : Scale_Type;
   --                      PWM_Resolution : PWM_Type;
   --                      Inverted       : Boolean := False)
   --  is
   --  begin
   --     --  select the clock
   --     Prescale_Reg := Prescale_Reg or Prescaler;

   --     MCU.TCNT1 := 0;

   --     MCU.TCCR1_Bits(MCU.WGM10_Bit) := PWM_Resolution(WGM0);
   --     MCU.TCCR1_Bits(MCU.WGM11_Bit) := PWM_Resolution(WGM1);
   --     MCU.TCCR1_Bits(MCU.WGM12_Bit) := PWM_Resolution(WGM2);
   --  end Init_PWM;


   Com0 : Boolean renames Ctrl_Reg (MCU.COM1A0_Bit);
   Com1 : Boolean renames Ctrl_Reg (MCU.COM1A1_Bit);

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


   procedure Set_Overflow_At (Overflow : Unsigned_8) is
   begin
      Output_Compare_Reg := Overflow;
   end Set_Overflow_At;

end AVR.Timer1_8bit;
