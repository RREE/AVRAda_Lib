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

package AVR.ADC is
   pragma Preelaborate;

   type Clock_Scale is new Unsigned_8 range 1 .. 7;
   Scale_By_2    : constant Clock_Scale := 1;
   Scale_By_4    : constant Clock_Scale := 2;
   Scale_By_8    : constant Clock_Scale := 3;
   Scale_By_16   : constant Clock_Scale := 4;
   Scale_By_32   : constant Clock_Scale := 5;
   Scale_By_64   : constant Clock_Scale := 6;
   Scale_By_128  : constant Clock_Scale := 7;


   type Reference_Voltage is
     (Ext_Ref,   --  provide external reference voltage to AVCC pin
      Is_Vcc,    --  use Vcc (typ. 5V or 3.3V) as reference
      Int_Ref);  --  typ. 2.56V or 1.1V, see data sheet


   Max_ADC_Channels          : constant := 8;
   Max_Reserved_ADC_Channels : constant := 8;

   type ADC_Channel_T is new Nat8
     range 0 .. Max_ADC_Channels + Max_Reserved_ADC_Channels - 1;
   subtype ADC_User_Channel_T is ADC_Channel_T
     range 0 .. Max_ADC_Channels - 1;
   subtype ADC_Reserved_Channel_T is ADC_Channel_T
     range Max_ADC_Channels .. Max_ADC_Channels + Max_Reserved_ADC_Channels - 1;

   Internal_Temperatur_Channel : constant ADC_Reserved_Channel_T := 2#1000#;
   Internal_Voltage_Channel    : constant ADC_Reserved_Channel_T := 2#1110#;
   Internal_Ground_Channel     : constant ADC_Reserved_Channel_T := 2#1111#;

   --  result type of the AD conversion
   subtype Conversion_10bit is Unsigned_16 range 0 .. 2**10 - 1;
   subtype Conversion_8bit is Unsigned_8;

   procedure Set_Prescaler (Scale : Clock_Scale);
   procedure Set_Reference (Ref : Reference_Voltage);

   procedure Init (Scale : Clock_Scale;
                   Ref   : Reference_Voltage);

   procedure Start_Conversion (Ch : ADC_Channel_T) with Inline;
   function Conversion_Is_Active return Boolean with Inline;
   function Last_Result return Conversion_10bit with Inline;
--   function Last_Result return Conversion_8Bit;

   function Convert_10bit (Ch : ADC_Channel_T) return Conversion_10bit;
   function Convert_8bit (Ch : ADC_Channel_T) return Conversion_8bit;

private
   for Reference_Voltage use
     (Ext_Ref => 0,
      Is_Vcc  => 16#40#,
      Int_Ref => 16#C0#);
   for Reference_Voltage'Size use 8;
   Ref_Inv_Mask  : constant Unsigned_8  := 16#3F#;

end AVR.ADC;
