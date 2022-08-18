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

with System;                            use type System.Address;
with AVR.MCU;                           use AVR;

private package AVR.UART_Config is
   pragma Preelaborate;

#if UART = "usart0" then
   UCSRA      : Nat8 renames MCU.UCSR0A;
   UCSRA_Bits : Bits_In_Byte renames MCU.UCSR0A_Bits;
   UCSRB      : Nat8 renames MCU.UCSR0B;
   UCSRC      : Nat8 renames MCU.UCSR0C;

   UBRR       : Nat16 renames MCU.UBRR0;

   RXEN_Bit   : constant AVR.Bit_Number := MCU.RXEN0_Bit;
   TXEN_Bit   : constant AVR.Bit_Number := MCU.TXEN0_Bit;
   RXCIE_Bit  : constant AVR.Bit_Number := MCU.RXCIE0_Bit;
   UCSZ0_Bit  : constant AVR.Bit_Number := MCU.UCSZ00_Bit;
   UCSZ1_Bit  : constant AVR.Bit_Number := MCU.UCSZ01_Bit;
   U2X_Mask   : constant                := MCU.U2X0_Mask;

   UDRE_Bit   : constant AVR.Bit_Number := MCU.UDRE0_Bit;

   UDR        : Nat8 renames MCU.UDR0;
   RXC_Bit    : constant AVR.Bit_Number := MCU.RXC0_Bit;

#if MCU = "atmega162" then
   Rx_Name    : constant String := MCU.Sig_USART0_RXC_String;
#elsif MCU = "atmega168" or else MCU = "atmega328p" then
   Rx_Name    : constant String := MCU.Sig_USART_RX_String;
#else
   Rx_Name    : constant String := MCU.Sig_USART0_RX_String;
#end if;


#elsif UART = "usart1" then
   UCSRA      : Nat8 renames MCU.UCSR1A;
   UCSRA_Bits : Bits_In_Byte renames MCU.UCSR1A_Bits;
   UCSRB      : Nat8 renames MCU.UCSR1B;
   UCSRC      : Nat8 renames MCU.UCSR1C;

   UBRR       : Nat16 renames MCU.UBRR1;

   RXEN_Bit   : constant AVR.Bit_Number := MCU.RXEN1_Bit;
   TXEN_Bit   : constant AVR.Bit_Number := MCU.TXEN1_Bit;
   RXCIE_Bit  : constant AVR.Bit_Number := MCU.RXCIE1_Bit;
   UCSZ0_Bit  : constant AVR.Bit_Number := MCU.UCSZ10_Bit;
   UCSZ1_Bit  : constant AVR.Bit_Number := MCU.UCSZ11_Bit;
   U2X_Mask   : constant                := MCU.U2X1_Mask;

   UDRE_Bit   : constant AVR.Bit_Number := MCU.UDRE1_Bit;

   UDR        : Nat8 renames MCU.UDR1;
   RXC_Bit    : constant AVR.Bit_Number := MCU.RXC1_Bit;

   Rx_Name    : constant String := MCU.Sig_USART1_RX_String;

#elsif UART = "usart" then
   UCSRA      : Nat8 renames MCU.UCSRA;
   UCSRA_Bits : Bits_In_Byte renames MCU.UCSRA_Bits;
   UCSRB      : Nat8 renames MCU.UCSRB;
   UCSRC      : Nat8 renames MCU.UCSRC;

   UBRR       : Nat16 renames MCU.UBRR;

   RXEN_Bit   : constant AVR.Bit_Number := MCU.RXEN_Bit;
   TXEN_Bit   : constant AVR.Bit_Number := MCU.TXEN_Bit;
   RXCIE_Bit  : constant AVR.Bit_Number := MCU.RXCIE_Bit;
   UCSZ0_Bit  : constant AVR.Bit_Number := MCU.UCSZ0_Bit;
   UCSZ1_Bit  : constant AVR.Bit_Number := MCU.UCSZ1_Bit;
   U2X_Mask   : constant                := MCU.U2X_Mask;

   UDRE_Bit   : constant AVR.Bit_Number := MCU.UDRE_Bit;

   UDR        : Nat8 renames MCU.UDR;
   RXC_Bit    : constant AVR.Bit_Number := MCU.RXC_Bit;

#if MCU = "atmega32" or MCU = "atmega8" then
   Rx_Name    : constant String := MCU.Sig_USART_RXC_String;
#else
   Rx_Name    : constant String := MCU.Sig_USART_RX_String;
#end if;


#elsif UART = "uart" then
   UCSRA_Bits : Bits_In_Byte renames MCU.USR_Bits;

   UCSRB      : Unsigned_8 renames MCU.UCR;

   UBRRL      : Unsigned_8 renames MCU.UBRR;
   UBRR       : Unsigned_8 renames MCU.UBRR;

   UDR        : Unsigned_8 renames MCU.UDR;

   RXC_Bit    : constant AVR.Bit_Number := MCU.RXC_Bit;

   Rx_Name    : constant String := MCU.Sig_UART_RX_String;

#end if;

end AVR.UART_Config;
