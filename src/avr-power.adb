--   Copyright (c) 2006  Eric B. Weddington
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


with AVR.MCU;                      use AVR.MCU;

package body AVR.Power is

#if MCU = "ATmega640" or MCU = "ATmega1280" or MCU = "ATmega1281" or MCU = "ATmega2560" or MCU = "ATmega2561" then

   procedure Adc_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      PRR0 := PRR0 or PRADC_Mask;
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      PRR0 := PRR0 or PRSPI_Mask;
   end Spi_Disable;

   procedure Twi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTWI);
   end Twi_Enable;

   procedure Twi_Disable is
   begin
      PRR0 := PPR0 or PRTWI_Mask;
   end Twi_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      PRR0 := PRR0 or PRTIM0_Mask;
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      PRR0 := PRR0 or PRTIM1_Mask;
   end Timer1_Disable;

   procedure Timer2_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM2);
   end Timer2_Enable;

   procedure Timer2_Disable is
   begin
      PRR0 := PRR0 or PRTIM2_Mask;
   end Timer2_Disable;

   procedure Timer3_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRTIM3);
   end Timer3_Enable;

   procedure Timer3_Disable is
   begin
      PRR1 := PRR1 or PRTIM3_Mask;
   end Timer3_Disable;

   procedure Timer4_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRTIM4);
   end Timer4_Enable;

   procedure Timer4_Disable is
   begin
      PRR1 := PRR1 or PRTIM4_Mask;
   end Timer4_Disable;

   procedure Timer5_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRTIM5);
   end Timer5_Enable;

   procedure Timer5_Disable is
   begin
      PRR1 := PRR1 or PRTIM5_Mask;
   end Timer5_Disable;

   procedure Usart0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRUSART0);
   end Usart0_Enable;

   procedure Usart0_Disable is
   begin
      PRR0 := PRR0 or PRUSART0_Mask;
   end Usart0_Disable;

   procedure Usart1_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRUSART1);
   end Usart1_Enable;

   procedure Usart1_Disable is
   begin
      PRR1 := PRR1 or PRUSART1_Mask;
   end Usart1_Disable;

   procedure Usart2_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRUSART2);
   end Usart2_Enable;

   procedure Usart2_Disable is
   begin
      PRR1 := PRR1 or PRUSART2_Mask;
   end Usart2_Disable;

   procedure Usart3_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRUSART3);
   end Usart3_Enable;

   procedure Usart3_Disable is
   begin
      PRR1 := PRR1 or PRUSART3_Mask;
   end Usart3_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#elsif MCU = "AT90USB646" or MCU = "AT90USB647" or MCU = "AT90USB1286" or MCU = "AT90USB1287" then

   procedure Adc_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      PRR0 := PRR0 or PRADC_Mask;
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      PRR0 := PRR0 or PRSPI_Mask;
   end Spi_Disable;

   procedure Twi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTWI);
   end Twi_Enable;

   procedure Twi_Disable is
   begin
      PRR0 := PRR0 or PRTWI_Mask;
   end Twi_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      PRR0 := PRR0 or PRTIM0_Mask;
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      PRR0 := PRR0 or PRTIM1_Mask;
   end Timer1_Disable;

   procedure Timer2_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM2);
   end Timer2_Enable;

   procedure Timer2_Disable is
   begin
      PRR0 := PRR0 or PRTIM2_Mask;
   end Timer2_Disable;

   procedure Timer3_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRTIM3);
   end Timer3_Enable;

   procedure Timer3_Disable is
   begin
      Set (PRR1, Get (PRR1) or PRTIM3);
   end Timer3_Disable;

   procedure Usart1_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRUSART1);
   end Usart1_Enable;

   procedure Usart1_Disable is
   begin
      Set (PRR1, Get (PRR1) or PRUSART1);
   end Usart1_Disable;

   procedure Usb_Enable is
   begin
      Set (PRR1, Get (PRR1) and not PRUSB);
   end Usb_Enable;

   procedure Usb_Disable is
   begin
      Set (PRR1, Get (PRR1) or PRUSB);
   end Usb_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart0_Enable is begin null; end Usart0_Enable;
   procedure Usart0_Disable is begin null; end Usart0_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#elsif MCU = "AT90PWM1" then

   procedure Adc_Enable is
   begin
      Set (PRR, Get (PRR) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      PRR := PRR or PRADC_Mask;
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR, Get (PRR) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      PRR := PRR or PRSPI_Mask;
   end Spi_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      PRR := PRR or PRTIM0_Mask;
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      PRR := PRR or PRTIM1_Mask;
   end Timer1_Disable;

   -- Power Stage Controller 0
   procedure Psc0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRPSC0);
   end Psc0_Enable;

   procedure Psc0_Disable is
   begin
      PRR := PRR or PRPSC0_Mask;
   end Psc0_Disable;

   -- Power Stage Controller 1
   procedure Psc1_Enable is
   begin
      Set (PRR, Get (PRR) and not PRPSC1);
   end Psc1_Enable;

   procedure Psc1_Disable is
   begin
      PRR := PRR or PRPSC1_Mask;
   end Psc1_Disable;

   -- Power Stage Controller 2
   procedure Psc2_Enable is
   begin
      Set (PRR, Get (PRR) and not PRPSC2);
   end Psc2_Enable;

   procedure Psc2_Disable is
   begin
      PRR := PRR or PRPSC2_Mask;
   end Psc2_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Timer2_Enable is begin null; end Timer2_Enable;
   procedure Timer2_Disable is begin null; end Timer2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Twi_Enable is begin null; end Twi_Enable;
   procedure Twi_Disable is begin null; end Twi_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart0_Enable is begin null; end Usart0_Enable;
   procedure Usart0_Disable is begin null; end Usart0_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#elsif MCU = "AT90PWM2" or MCU = "AT90PWM3" then

   procedure Adc_Enable is
   begin
      Set (PRR, Get (PRR) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      PRR := PRR or PRADC_Mask;
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR, Get (PRR) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      PRR := PRR or PRSPI_Mask;
   end Spi_Disable;

   procedure Usart_Enable is
   begin
      Set (PRR, Get (PRR) and not PRUSART);
   end Usart_Enable;

   procedure Usart_Disable is
   begin
      PRR := PRR or PRUSART_Mask;
   end Usart_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      PRR := PRR or PRTIM0_Mask;
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      PRR := PRR or PRTIM1_Mask;
   end Timer1_Disable;

   -- Power Stage Controller 0
   procedure Psc0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRPSC0);
   end Psc0_Enable;

   procedure Psc0_Disable is
   begin
      PRR := PRR or PRPSC0_Mask;
   end Psc0_Disable;

   -- Power Stage Controller 1
   procedure Psc1_Enable is
   begin
      Set (PRR, Get (PRR) and not PRPSC1);
   end Psc1_Enable;

   procedure Psc1_Disable is
   begin
      PRR := PRR or PRPSC1_Mask;
   end Psc1_Disable;

   -- Power Stage Controller 2
   procedure Psc2_Enable is
   begin
      Set (PRR, Get (PRR) and not PRPSC2);
   end Psc2_Enable;

   procedure Psc2_Disable is
   begin
      PRR := PRR or PRPSC2_Mask;
   end Psc2_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Timer2_Enable is begin null; end Timer2_Enable;
   procedure Timer2_Disable is begin null; end Timer2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Twi_Enable is begin null; end Twi_Enable;
   procedure Twi_Disable is begin null; end Twi_Disable;
   procedure Usart0_Enable is begin null; end Usart0_Enable;
   procedure Usart0_Disable is begin null; end Usart0_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#elsif MCU = "ATmega165" or MCU = "ATmega165P" or MCU = "ATmega325" or MCU = "ATmega3250" or MCU = "ATmega645" or MCU = "ATmega6450" then

   procedure Adc_Enable is
   begin
      Set (PRR, Get (PRR) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      Set (PRR, Get (PRR) or PRADC);
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR, Get (PRR) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      Set (PRR, Get (PRR) or PRSPI);
   end Spi_Disable;

   procedure Usart0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRUSART0);
   end Usart0_Enable;

   procedure Usart0_Disable is
   begin
      Set (PRR, Get (PRR) or PRUSART0);
   end Usart0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      Set (PRR, Get (PRR) or PRTIM1);
   end Timer1_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Timer0_Enable is begin null; end Timer0_Enable;
   procedure Timer0_Disable is begin null; end Timer0_Disable;
   procedure Timer2_Enable is begin null; end Timer2_Enable;
   procedure Timer2_Disable is begin null; end Timer2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Twi_Enable is begin null; end Twi_Enable;
   procedure Twi_Disable is begin null; end Twi_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#elsif MCU = "ATmega169" or MCU = "ATmega169P" or MCU = "ATmega329" or MCU = "ATmega3290" or MCU = "ATmega649" or MCU = "ATmega6490" then

   procedure Adc_Enable is
   begin
      PRR := PRR and not PRADC_Mask;
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      PRR := PRR or PRADC_Mask;
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      PRR := PRR and not PRSPI_Mask;
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      PRR := PRR or PRSPI_Mask;
   end Spi_Disable;

   procedure Usart0_Enable is
   begin
      PRR := PRR and not PRUSART0_Mask;
   end Usart0_Enable;

   procedure Usart0_Disable is
   begin
      PRR := PRR or PRUSART0_Mask;
   end Usart0_Disable;

   procedure Timer1_Enable is
   begin
      PRR := PRR and not PRTIM1_Mask;
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      PRR := PRR or PRTIM1_Mask;
   end Timer1_Disable;

   procedure Lcd_Enable is
   begin
      PRR := PRR and not PRLCD_Mask;
   end Lcd_Enable;

   procedure Lcd_Disable is
   begin
      PRR := PRR or PRLCD_Mask;
   end Lcd_Disable;

   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Timer0_Enable is begin null; end Timer0_Enable;
   procedure Timer0_Disable is begin null; end Timer0_Disable;
   procedure Timer2_Enable is begin null; end Timer2_Enable;
   procedure Timer2_Disable is begin null; end Timer2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Twi_Enable is begin null; end Twi_Enable;
   procedure Twi_Disable is begin null; end Twi_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#elsif MCU = "ATmega164P" or MCU = "ATmega324P" then

   procedure Adc_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRADC);
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRSPI);
   end Spi_Disable;

   procedure Usart0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRUSART0);
   end Usart0_Enable;

   procedure Usart0_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRUSART0);
   end Usart0_Disable;

   procedure Usart1_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRUSART1);
   end Usart1_Enable;

   procedure Usart1_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRUSART1);
   end Usart1_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM0);
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM1);
   end Timer1_Disable;

   procedure Timer2_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM2);
   end Timer2_Enable;

   procedure Timer2_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM2);
   end Timer2_Disable;

   procedure Twi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTWI);
   end Twi_Enable;

   procedure Twi_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTWI);
   end Twi_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Timer1_Enable is begin null; end Timer1_Enable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;


#elsif MCU = "ATmega644" then

   procedure Adc_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRADC);
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRSPI);
   end Spi_Disable;

   procedure Usart0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRUSART0);
   end Usart0_Enable;

   procedure Usart0_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRUSART0);
   end Usart0_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM0);
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM1);
   end Timer1_Disable;

   procedure Timer2_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM2);
   end Timer2_Enable;

   procedure Timer2_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM2);
   end Timer2_Disable;

   procedure Twi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTWI);
   end Twi_Enable;

   procedure Twi_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTWI);
   end Twi_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#elsif MCU = "ATmega406" then

   procedure Twi_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTWI);
   end Twi_Enable;

   procedure Twi_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTWI);
   end Twi_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM0);
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRTIM1);
   end Timer1_Disable;

   -- Voltage ADC
   procedure Vadc_Enable is
   begin
      Set (PRR0, Get (PRR0) and not PRVADC);
   end Vadc_Enable;

   procedure Vadc_Disable is
   begin
      Set (PRR0, Get (PRR0) or PRVADC);
   end Vadc_Disable;

   procedure Adc_Enable is begin null; end Adc_Enable;
   procedure Adc_Disable is begin null; end Adc_Disable;
   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Spi_Enable is begin null; end Spi_Enable;
   procedure Spi_Disable is begin null; end Spi_Disable;
   procedure Timer2_Enable is begin null; end Timer2_Enable;
   procedure Timer2_Disable is begin null; end Timer2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart0_Enable is begin null; end Usart0_Enable;
   procedure Usart0_Disable is begin null; end Usart0_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;

#elsif MCU = "ATmega48" or MCU = "ATmega88" or MCU = "ATmega168" then

   procedure Adc_Enable is
   begin
      Set (PRR, Get (PRR) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      Set (PRR, Get (PRR) or PRADC);
   end Adc_Disable;

   procedure Spi_Enable is
   begin
      Set (PRR, Get (PRR) and not PRSPI);
   end Spi_Enable;

   procedure Spi_Disable is
   begin
      Set (PRR, Get (PRR) or PRSPI);
   end Spi_Disable;

   procedure Usart0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRUSART0);
   end Usart0_Enable;

   procedure Usart0_Disable is
   begin
      Set (PRR, Get (PRR) or PRUSART0);
   end Usart0_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      Set (PRR, Get (PRR) or PRTIM0);
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      Set (PRR, Get (PRR) or PRTIM1);
   end Timer1_Disable;

   procedure Timer2_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM2);
   end Timer2_Enable;

   procedure Timer2_Disable is
   begin
      Set (PRR, Get (PRR) or PRTIM2);
   end Timer2_Disable;

   procedure Twi_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTWI);
   end Twi_Enable;

   procedure Twi_Disable is
   begin
      Set (PRR, Get (PRR) or PRTWI);
   end Twi_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;


#elsif MCU = "ATtiny24" or MCU = "ATtiny44" or MCU = "ATtiny84" or MCU = "ATtiny25" or MCU = "ATtiny45" or MCU = "ATtiny85" or MCU = "ATtiny261" or MCU = "ATtiny461" or MCU = "ATtiny8" then

   procedure Adc_Enable is
   begin
      Set (PRR, Get (PRR) and not PRADC);
   end Adc_Enable;

   procedure Adc_Disable is
   begin
      Set (PRR, Get (PRR) or PRADC);
   end Adc_Disable;

   procedure Timer0_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM0);
   end Timer0_Enable;

   procedure Timer0_Disable is
   begin
      Set (PRR, Get (PRR) or PRTIM0);
   end Timer0_Disable;

   procedure Timer1_Enable is
   begin
      Set (PRR, Get (PRR) and not PRTIM1);
   end Timer1_Enable;

   procedure Timer1_Disable is
   begin
      Set (PRR, Get (PRR) or PRTIM1);
   end Timer1_Disable;

   -- Universal Serial Interface
   procedure Usi_Enable is
   begin
      Set (PRR, Get (PRR) and not PRUSI);
   end Usi_Enable;

   procedure Usi_Disable is
   begin
      Set (PRR, Get (PRR) or PRUSI);
   end Usi_Disable;

   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Spi_Enable is begin null; end Spi_Enable;
   procedure Spi_Disable is begin null; end Spi_Disable;
   procedure Timer2_Enable is begin null; end Timer2_Enable;
   procedure Timer2_Disable is begin null; end Timer2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Twi_Enable is begin null; end Twi_Enable;
   procedure Twi_Disable is begin null; end Twi_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart0_Enable is begin null; end Usart0_Enable;
   procedure Usart0_Disable is begin null; end Usart0_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#else

   procedure Adc_Enable is begin null; end Adc_Enable;
   procedure Adc_Disable is begin null; end Adc_Disable;
   procedure Lcd_Enable is begin null; end Lcd_Enable;
   procedure Lcd_Disable is begin null; end Lcd_Disable;
   procedure Psc0_Enable is begin null; end Psc0_Enable;
   procedure Psc0_Disable is begin null; end Psc0_Disable;
   procedure Psc1_Enable is begin null; end Psc1_Enable;
   procedure Psc1_Disable is begin null; end Psc1_Disable;
   procedure Psc2_Enable is begin null; end Psc2_Enable;
   procedure Psc2_Disable is begin null; end Psc2_Disable;
   procedure Spi_Enable is begin null; end Spi_Enable;
   procedure Spi_Disable is begin null; end Spi_Disable;
   procedure Timer0_Enable is begin null; end Timer0_Enable;
   procedure Timer0_Disable is begin null; end Timer0_Disable;
   procedure Timer1_Enable is begin null; end Timer1_Enable;
   procedure Timer1_Disable is begin null; end Timer1_Disable;
   procedure Timer2_Enable is begin null; end Timer2_Enable;
   procedure Timer2_Disable is begin null; end Timer2_Disable;
   procedure Timer3_Enable is begin null; end Timer3_Enable;
   procedure Timer3_Disable is begin null; end Timer3_Disable;
   procedure Timer4_Enable is begin null; end Timer4_Enable;
   procedure Timer4_Disable is begin null; end Timer4_Disable;
   procedure Timer5_Enable is begin null; end Timer5_Enable;
   procedure Timer5_Disable is begin null; end Timer5_Disable;
   procedure Twi_Enable is begin null; end Twi_Enable;
   procedure Twi_Disable is begin null; end Twi_Disable;
   procedure Usart_Enable is begin null; end Usart_Enable;
   procedure Usart_Disable is begin null; end Usart_Disable;
   procedure Usart0_Enable is begin null; end Usart0_Enable;
   procedure Usart0_Disable is begin null; end Usart0_Disable;
   procedure Usart1_Enable is begin null; end Usart1_Enable;
   procedure Usart1_Disable is begin null; end Usart1_Disable;
   procedure Usart2_Enable is begin null; end Usart2_Enable;
   procedure Usart2_Disable is begin null; end Usart2_Disable;
   procedure Usart3_Enable is begin null; end Usart3_Enable;
   procedure Usart3_Disable is begin null; end Usart3_Disable;
   procedure Usb_Enable is begin null; end Usb_Enable;
   procedure Usb_Disable is begin null; end Usb_Disable;
   procedure Usi_Enable is begin null; end Usi_Enable;
   procedure Usi_Disable is begin null; end Usi_Disable;
   procedure Vadc_Enable is begin null; end Vadc_Enable;
   procedure Vadc_Disable is begin null; end Vadc_Disable;

#end if;

end AVR.Power;

