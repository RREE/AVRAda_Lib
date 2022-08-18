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

--  Use of the SLEEP instruction can allow your application to reduce
--  it's power comsumption considerably. AVR devices can be put into
--  different sleep modes. Refer to the datasheet for the details
--  relating to the device you are using.
--
--  Some devices permit to switch off single areas in the processor.
--  See the package AVR.Power and your datasheet for details.

package AVR.Sleep is
   pragma Preelaborate (AVR.Sleep);

   --  not all of these modes are available for all devices.  See the
   --  data sheet of the used part to verify.
   type Sleep_Mode_T is (Idle,
                         ADC_Noise_Reduction,
                         Power_Down,
                         Power_Save,
                         Standby,
                         Extended_Standby);
   for Sleep_Mode_T'Size use 8;


   --  set the sleep mode
   procedure Set_Mode (Mode : Sleep_Mode_T);


   --  Put the device in sleep mode.  How the device is brought out of
   --  sleep mode depends on the specific mode selected with the
   --  Set_Mode function.  See the data sheet for your device for more
   --  details.
   procedure Go_Sleeping;


   --  Put the device in sleep mode if Condition is true.  Condition
   --  is checked and sleep mode entered as one indivisible action.
   procedure Go_Sleeping_If (Condition : Boolean);


private
   --  Manipulates the SE (sleep enable) bit.
   procedure Enable;
   procedure Disable;

   pragma Inline_Always (Enable);
   pragma Inline_Always (Disable);
   pragma Inline_Always (Go_Sleeping);
   pragma Inline_Always (Go_Sleeping_If);
end AVR.Sleep;
