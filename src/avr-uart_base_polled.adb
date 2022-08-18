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
with AVR.MCU;                           use AVR.MCU;
with AVR.UART_Config;                   use AVR.UART_Config;

package body AVR.UART_Base_Polled is

   --
   --  Init
   --
   procedure Init (Baud_Divider : Serial_Speed;
                   Double_Speed : Boolean := False) is
   begin
      -- Set baud rate
#if not UART = "uart" then
      UBRR := Unsigned_16(Baud_Divider);
#else
      UBRR := Low_Byte(Unsigned_16(Baud_Divider));
#end if;

#if not UART = "uart" then
      -- Enable 2x speed
      if Double_Speed then
         UCSRA := U2X_Mask;
      else
         UCSRA := 0;
      end if;
#end if;


#if UART = "USART" then
      -- Async. mode, 8N1
      UCSRC := +(UCSZ0_Bit => True,
                 UCSZ1_Bit => True,
#if MCU = "atmega8" or else MCU = "atmega32" then
                 URSEL_Bit => True,
#end if;
                 others => False);

      --  at least on atmega8 UCSRC and UBRRH share the same address.
      --  When writing to the ACSRC register, the URSEL must be set,
      --  too.
#elsif UART = "USART0" then
      -- Async. mode, 8N1
      UCSRC := +(UCSZ0_Bit => True,
                 UCSZ1_Bit => True,
                 others => False);

#end if;

      -- Enable receiver and transmitter
      UCSRB := +(RXEN_Bit => True,
                 TXEN_Bit => True,
                 others => False);
   end Init;


   procedure Put_Raw (Data : Unsigned_8) is
   begin
      -- wait until Data Register Empty (DRE) is signaled
      while UCSRA_Bits (UDRE_Bit) = False loop null; end loop;
      UDR := Data;

      --  avr-gcc 3.4.4 -Os -mmcu=atmega169
      --     0:   98 2f           mov     r25, r24
      --     2:   80 91 c0 00     lds     r24, 0x00C0
      --     6:   85 ff           sbrs    r24, 5
      --     8:   fc cf           rjmp    .-8             ; 0x2
      --     a:   90 93 c6 00     sts     0x00C6, r25
      --     e:   08 95           ret

      --  avr-gcc 3.4.4 -Os -mmcu=at90s8515
      --     0:   5d 9b           sbis    0x0b, 5 ; 11
      --     2:   fe cf           rjmp    .-4
      --     4:   8c b9           out     0x0c, r24       ; 12
      --     6:   08 95           ret

      --  avr-gcc 4.3.2 -Os -mmcu=atmega8
      --     0:   98 2f           mov     r25, r24
      --     2:   80 91 c0 00     lds     r24, 0x00C0
      --     6:   85 ff           sbrs    r24, 5
      --     8:   00 c0           rjmp    .-8
      --     a:   90 93 c6 00     sts     0x00C6, r25

      --  avr-gcc 4.4.5 -Os -mmcu=atmega8
      --     0:   9b b1           in      r25, 0x0b
      --     2:   92 95           swap    r25
      --     4:   96 95           lsr     r25
      --     6:   91 70           andi    r25, 0x01
      --     8:   01 f0           breq    .+0
      --     a:   8c b9           out     0x0c, r24
   end Put_Raw;


   function Available return Boolean
   is
   begin
      return UCSRA_Bits (RXC_Bit);
   end Available;


   function Get_Raw return Unsigned_8 is
   begin
      while not Available loop null; end loop;
      return UDR;
      --     0:   80 91 c0 00     lds     r24, 0x00C0
      --     4:   87 ff           sbrs    r24, 7
      --     6:   fc cf           rjmp    .-8             ; 0x0
      --     8:   80 91 c6 00     lds     r24, 0x00C6
      --     c:   08 95           ret
   end Get_Raw;


   procedure Flush is
   begin null; end Flush;

end AVR.UART_Base_Polled;
