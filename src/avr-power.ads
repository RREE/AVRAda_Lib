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

--  This package permits to control the power consumption in fine
--  detail.  It copies the idea by Eric B. Weddington of the
--  corresponding file in the avr-libc-dev mailing list as of
--  2006-07-18.

--   Copyright (c) 2006  Eric B. Weddington for the original C version.
--   All rights reserved.

--   Redistribution and use in source and binary forms, with or
--   without modification, are permitted provided that the following
--   conditions are met:

--   * Redistributions of source code must retain the above copyright
--     notice, this list of conditions and the following disclaimer.
--   * Redistributions in binary form must reproduce the above copyright
--     notice, this list of conditions and the following disclaimer in
--     the documentation and/or other materials provided with the
--     distribution.
--   * Neither the name of the copyright holders nor the names of
--     contributors may be used to endorse or promote products derived
--     from this software without specific prior written permission.

--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
--  INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
--  CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
--  ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
--  POSSIBILITY OF SUCH DAMAGE.


package AVR.Power is
   pragma Preelaborate (AVR.Power);

   procedure Adc_Enable;
   procedure Adc_Disable;

   procedure Lcd_Enable;
   procedure Lcd_Disable;

   procedure Psc0_Enable;
   procedure Psc0_Disable;

   procedure Psc1_Enable;
   procedure Psc1_Disable;

   procedure Psc2_Enable;
   procedure Psc2_Disable;

   procedure Spi_Enable;
   procedure Spi_Disable;

   procedure Timer0_Enable;
   procedure Timer0_Disable;

   procedure Timer1_Enable;
   procedure Timer1_Disable;

   procedure Timer2_Enable;
   procedure Timer2_Disable;

   procedure Timer3_Enable;
   procedure Timer3_Disable;

   procedure Timer4_Enable;
   procedure Timer4_Disable;

   procedure Timer5_Enable;
   procedure Timer5_Disable;

   procedure Twi_Enable;
   procedure Twi_Disable;

   procedure Usart_Enable;
   procedure Usart_Disable;

   procedure Usart0_Enable;
   procedure Usart0_Disable;

   procedure Usart1_Enable;
   procedure Usart1_Disable;

   procedure Usart2_Enable;
   procedure Usart2_Disable;

   procedure Usart3_Enable;
   procedure Usart3_Disable;

   procedure Usb_Enable;
   procedure Usb_Disable;

   procedure Usi_Enable;
   procedure Usi_Disable;

   procedure Vadc_Enable;
   procedure Vadc_Disable;

private

   pragma Inline (Adc_Enable);
   pragma Inline (Adc_Disable);
   pragma Inline (Lcd_Enable);
   pragma Inline (Lcd_Disable);
   pragma Inline (Psc0_Enable);
   pragma Inline (Psc0_Disable);
   pragma Inline (Psc1_Enable);
   pragma Inline (Psc1_Disable);
   pragma Inline (Psc2_Enable);
   pragma Inline (Psc2_Disable);
   pragma Inline (Spi_Enable);
   pragma Inline (Spi_Disable);
   pragma Inline (Timer0_Enable);
   pragma Inline (Timer0_Disable);
   pragma Inline (Timer1_Enable);
   pragma Inline (Timer1_Disable);
   pragma Inline (Timer2_Enable);
   pragma Inline (Timer2_Disable);
   pragma Inline (Timer3_Enable);
   pragma Inline (Timer3_Disable);
   pragma Inline (Timer4_Enable);
   pragma Inline (Timer4_Disable);
   pragma Inline (Timer5_Enable);
   pragma Inline (Timer5_Disable);
   pragma Inline (Twi_Enable);
   pragma Inline (Twi_Disable);
   pragma Inline (Usart_Enable);
   pragma Inline (Usart_Disable);
   pragma Inline (Usart0_Enable);
   pragma Inline (Usart0_Disable);
   pragma Inline (Usart1_Enable);
   pragma Inline (Usart1_Disable);
   pragma Inline (Usart2_Enable);
   pragma Inline (Usart2_Disable);
   pragma Inline (Usart3_Enable);
   pragma Inline (Usart3_Disable);
   pragma Inline (Usb_Enable);
   pragma Inline (Usb_Disable);
   pragma Inline (Usi_Enable);
   pragma Inline (Usi_Disable);
   pragma Inline (Vadc_Enable);
   pragma Inline (Vadc_Disable);

end AVR.Power;

