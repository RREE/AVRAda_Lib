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
with Ada.Unchecked_Conversion;
with AVR.MCU;

package body AVR.ADC is


   ADC_Left_Adjust_Result  : Boolean renames MCU.ADMUX_Bits (MCU.ADLAR_Bit);
   ADC_Enable              : Boolean renames MCU.ADCSRA_Bits (MCU.ADEN_Bit);
   ADC_Auto_Trigger_Enable : Boolean renames MCU.ADCSRA_Bits (MCU.ADATE_Bit);
   ADC_Interrupt_Enable    : Boolean renames MCU.ADCSRA_Bits (MCU.ADIE_Bit);
   ADC_Start_Conversion    : Boolean renames MCU.ADCSRA_Bits (MCU.ADSC_Bit);


   procedure Set_Prescaler (Scale : Clock_Scale)
   is
      Prescale_Mask : constant Unsigned_8 := 2#1111_1000#;
   begin
      MCU.ADCSRA := (MCU.ADCSRA and Prescale_Mask) or Unsigned_8 (Scale);
   end Set_Prescaler;


   function To_U8 is new Ada.Unchecked_Conversion
     (Source => Reference_Voltage,
      Target => Unsigned_8);

   procedure Set_Reference (Ref : Reference_Voltage)
   is
   begin
      MCU.ADMUX := (MCU.ADMUX and Ref_Inv_Mask) or To_U8 (Ref);
      --  avr-gcc V4.3.3 -Os -mmcu=atmega32
      --
      --  0:   97 b1           in      r25, 0x07       ; 7
      --  2:   9f 73           andi    r25, 0x3F       ; 63
      --  4:   98 2b           or      r25, r24
      --  6:   97 b9           out     0x07, r25       ; 7
      --  8:   08 95           ret
   end Set_Reference;


   procedure Init (Scale : Clock_Scale;
                   Ref   : Reference_Voltage)
   is
   begin
      ADC_Enable := True;
      ADC_Auto_Trigger_Enable := False;
      ADC_Left_Adjust_Result := False;
      ADC_Interrupt_Enable := False;

      Set_Prescaler (Scale);
      Set_Reference (Ref);
   end Init;


   procedure Start_Conversion (Ch : ADC_Channel_T)
   is
   begin
      MCU.ADMUX := (MCU.ADMUX and 16#F0#) or Unsigned_8 (Ch);
      ADC_Start_Conversion := True;
   end Start_Conversion;


   function Conversion_Is_Active return Boolean
   is
   begin
      return ADC_Start_Conversion;
   end Conversion_Is_Active;


   function Last_Result return Conversion_10bit
   is
   begin
      return MCU.ADC;
   end Last_Result;


   function Convert_10bit (Ch : ADC_Channel_T) return Conversion_10bit
   is
   begin
      ADC_Left_Adjust_Result := False;
      Start_Conversion (Ch);
      while Conversion_Is_Active loop null; end loop;
      return Last_Result;
   end Convert_10bit;


   function Convert_8bit (Ch : ADC_Channel_T) return Conversion_8bit
   is
   begin
      ADC_Left_Adjust_Result := True;
      Start_Conversion (Ch);
      while Conversion_Is_Active loop null; end loop;
      return MCU.ADCH;
   end Convert_8bit;

end AVR.ADC;
