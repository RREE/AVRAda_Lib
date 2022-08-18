package body AVR.UART.LIN is

      procedure Sender_Mode
   is
   begin
      -- Enable transmitter
      UCSRB := +(TXEN_Bit => True,
                 others => False);
   end Sender_Mode;


   procedure Receiver_Mode
   is
   begin
      -- Enable receiver
      UCSRB := +(RXEN_Bit => True,
                 others => False);
   end Receiver_Mode;


   procedure Send_LIN_Break is
#if not UART = "uart" then
      Orig_Baud_Divider : constant Unsigned_16 := UBRR;
#else
      Orig_Baud_Divider : constant Unsigned_8 := UBRRL;
#end if;
   begin
      --  We send a 16#00#. That will pull the line low for 9 bit
      --  lengths.  In order to achieve a low of 13 bit times we have
      --  to increase the bit time by about 50%, i.e. reduce the baud
      --  rate by 2/3.
      --
      --  the Baud rate calculates as follows:
      --               Freq
      --  Baud = ---------------
      --          16 (UBBR + 1)
      --
      --  after transformation we get
      --
      --  UBBR (2/3Baud) = 1.5(UBBR + 1) - 1
      --
      --  I consider that formula too complicated for what we need.
      --  The pragmatic solution is to simply double the existing UBBR
      --  value.
      --
      --  The current setting is in UBBR
      --
      --  Freq [MHz] | Baud rate | UBBR |
      --      8.0    |      9600 |   51 |
      --
      UBRR := UBRR * 2;


#if UART = "usart" then
      -- Async. mode, 8N1
      UCSRC := +(UCSZ0_Bit => True,
                 UCSZ1_Bit => True,
                 URSEL_Bit => True,
                 others => False);

      --  at least on atmega8 UCSRC and UBRRH share the same address.
      --  When writing to the ACSRC register, the URSEL must be set,
      --  too.
#elsif UART = "usart0" then
      -- Async. mode, 8N1
      UCSRC := +(UCSZ0_Bit => True,
                 UCSZ1_Bit => True,
                 others => False);

#end if;

      --
      Put_Raw (16#00#);

      --  reset the baud divider
      UBRR := Orig_Baud_Divider;

   end Send_LIN_Break;

end AVR.UART.LIN;
