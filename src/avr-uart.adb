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

with Ada.Unchecked_Conversion;
with System;                            use type System.Address;
with AVR.Int_Img;
with AVR.Interrupts;
with AVR.MCU;                           use AVR;
with AVR.UART_Config;                   use AVR.UART_Config;

package body AVR.UART is


   ------------------------------------------------------------------------
   --
   type Receive_Mode_T is (Polled, Interrupt);
   Receive_Mode : constant Receive_Mode_T := Polled;


   --
   --  Init
   --

   --  procedure Init (Baud : Baud_Rate := 19200)
   --  is
   --     subtype B is Baud_Rate'Base;
   --     Ubrr : constant Unsigned_16 := Unsigned_16
   --       ((Config.Clock_Frequency + 8 * B (Baud)) /
   --          ((16 * B (Baud)) - 1));
   --  begin
   --     Init (Ubrr, False);
   --  end Init;

   procedure Init_Common (Baud_Divider : Serial_Speed;
                          Double_Speed : Boolean := False)
   is
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


      -- Async. mode, 8N1
      UCSRC := +(UCSZ0_Bit => True,
                 UCSZ1_Bit => True,
#if MCU = "atmega8" or else MCU = "atmega32" then
                 MCU.URSEL_Bit => True,
#end if;
                 others => False);
      --  at least on atmega8 UCSRC and UBRRH share the same address.
      --  When writing to the ACSRC register, the URSEL must be set,
      --  too.
   end Init_Common;


   procedure Init (Baud_Divider : Serial_Speed;
                   Double_Speed : Boolean := False)
   is
   begin
      Init_Common (Baud_Divider, Double_Speed);

      -- Enable receiver and transmitter
      UCSRB := +(RXEN_Bit => True,
                 TXEN_Bit => True,
                 others => False);

      -- Receive_Mode := Polled;
      pragma Assert (Receive_Mode = Polled);

   end Init;


   Rx_Buf : Buffer_Ptr;
   Rx_Inx, Rx_Outx : Unsigned_8;
   pragma Volatile(Rx_Inx);

   procedure Init_Interrupt_Read (Baud_Divider   : Serial_Speed;
                                  Double_Speed   : Boolean := False;
                                  Receive_Buffer : Buffer_Ptr)
   is
      Data : Unsigned_8;
   begin
      Init_Common (Baud_Divider, Double_Speed);

      -- Enable receiver and transmitter
      UCSRB := +(RXEN_Bit => True,
                 TXEN_Bit => True,
                 RXCIE_Bit => True,     -- Enable Receiver interrupts
                 others => False);

      -- Clear UART input queue
      while UCSRA_Bits(RXC_Bit) = True loop
         Data := UDR;     -- Empty data buffer
      end loop;
      Rx_Buf := Receive_Buffer;
      Rx_Inx := Rx_Buf.all'First;
      Rx_Outx := Rx_Buf.all'First;

      Interrupts.Enable_Interrupts;

      -- Receive_Mode := Interrupt;
      pragma Assert (Receive_Mode = Interrupt);
   end Init_Interrupt_Read;


   function To_U8 is
      new Ada.Unchecked_Conversion (Source => Character,
                                    Target => Unsigned_8);

   procedure Put (Ch : Character) is
   begin
      Put_Raw (To_U8 (Ch));
   end Put;


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

      --  avr-gcc 9.2.0 -Os -mmcu=atmega8
      --  0000008e <avr__uart__put_raw>:
      --  8e:   5d 9b           sbis    0x0b, 5 ; 11
      --  90:   fe cf           rjmp    .-4             ; 0x8e <avr__uart__put_raw>
      --  92:   8c b9           out     0x0c, r24       ; 12
      --  94:   08 95           ret
   end Put_Raw;


   procedure Put (S : AVR_String) is
   begin
      for I in S'Range loop
         Put (S (I));
      end loop;
   end Put;


--     procedure Put (S : Pstr20.Pstring) is
--     begin
--        for I in Unsigned_8'(1) .. Length(S) loop
--           Put (Element (S, I));
--        end loop;
--     end Put;


   procedure Put (Str : Program_Address; Len : Unsigned_8)
   is
      C : Unsigned_8;
      Text_Ptr : Program_Address := Str;
      use AVR.Programspace;
   begin
      for J in Unsigned_8'(1) .. Len loop
         C := Get (Text_Ptr);
         Put_Raw (C);
         Text_Ptr := Text_Ptr + 1;
      end loop;
   end Put;


   --  pointer calculation for putting C like zero ended strings
   function "+" (L : Chars_Ptr; R : Unsigned_16) return Chars_Ptr;
   pragma Inline ("+");

   function "+" (L : Chars_Ptr; R : Unsigned_16) return Chars_Ptr is
      function Addr is new Ada.Unchecked_Conversion (Source => Chars_Ptr,
                                                     Target => Unsigned_16);
      function Ptr is new Ada.Unchecked_Conversion (Source => Unsigned_16,
                                                    Target => Chars_Ptr);
   begin
      return Ptr (Addr (L) + R);
   end "+";

   procedure Put_C (S : Chars_Ptr) is
      P : Chars_Ptr := S;
   begin
      if P = null then return; end if;
      while P.all /= ASCII.NUL loop
         Put (P.all);
         P := P + 1;
      end loop;
   end Put_C;


   procedure Put_Line (S : AVR_String) is
   begin
      Put (S);
      New_Line;
   end Put_Line;


   procedure Put_Line (S : Chars_Ptr) is
   begin
      Put_C (S);
      New_Line;
   end Put_Line;


   procedure New_Line is
      EOL : constant := 16#0A#;
   begin
      Put_Raw (EOL);
   end New_Line;


   procedure CRLF is
      LF : constant := 16#0A#;
      CR : constant := 16#0D#;
   begin
      Put_Raw (CR);
      Put_Raw (LF);
   end CRLF;


   procedure Put (Data : Unsigned_8;
                  Base : Unsigned_8 := 10)
   is
   begin
      if Base /= 16 then
         declare
            Img : AStr3;
            L   : Unsigned_8;
         begin
            AVR.Int_Img.U8_Img (Data, Img, L);
            for I in 1 .. L loop
               Put (Img (I));
            end loop;
         end;
      else
         declare
            Img : AStr2;
         begin
            AVR.Int_Img.U8_Hex_Img (Data, Img);
            Put (Img (1));
            Put (Img (2));
         end;
      end if;
   end Put;


   procedure Put (Data : Integer_16;
                  Base : Unsigned_8 := 10)
   is
      Img : AStr5;
      L   : Unsigned_8;
   begin
      if Base /= 16 then
         if Data < 0 then
            Put ('-');
            AVR.Int_Img.U16_Img (Unsigned_16 (-Data), Img, L);
         else
            AVR.Int_Img.U16_Img (Unsigned_16 (Data), Img, L);
         end if;
         for J in Unsigned_8'(1) .. L loop
            Put (Img (J));
         end loop;
      else
         Put_Line ("Put(int16, base=16) not yet implemented");
      end if;
   end Put;


   procedure Put (Data : Unsigned_16;
                  Base : Unsigned_8 := 10)
   is
      Img : AStr5;
      L   : Unsigned_8;
   begin
      if Base = 16 then
         Put (High_Byte (Data), 16);
         Put (Low_Byte (Data), 16);
      elsif Base = 10 then
         AVR.Int_Img.U16_Img (Data, Img, L);
         for J in Unsigned_8'(1) .. L loop
            Put (Img (J));
         end loop;
      else
         Put_Line ("Put(u16) not yet implemented");
      end if;
   end Put;


   procedure Put (Data : Unsigned_32;
                  Base : Unsigned_8 := 10)
   is
      -- Img : AStr5;
      -- L   : Unsigned_8;
      pragma Unreferenced (Base);
      type Four_Bytes is array (0..3) of Unsigned_8;
      Bytes : Four_Bytes;
      for Bytes'Address use Data'Address;
   begin
      --      if Base = 16 then
      Put (Unsigned_8 (Data / 256 / 256 / 256), 16);
      Put (Unsigned_8 ((Data and 16#00FF0000#) / 256 / 256), 16);
      Put (Unsigned_8 ((Data and 16#0000FF00#) / 256), 16);
      Put (Unsigned_8 (Data and 16#000000FF#), 16);
      --      end if;
   end Put;


   -- Receive ISR Routine
   procedure Receiver_ISR;
   pragma Machine_Attribute (Entity => Receiver_ISR, Attribute_Name => "signal");
   pragma Export (C, Receiver_ISR, Rx_Name);

   procedure Receiver_ISR is
   begin
      pragma Assert (Receive_Mode = Interrupt);

      while UCSRA_Bits (RXC_Bit) = True loop
         Rx_Buf (Rx_Inx) := UDR;
         if Rx_Inx = Rx_Buf.all'Last then
            Rx_Inx := Rx_Buf.all'First;
         else
            Rx_Inx := Rx_Inx + 1;
         end if;
      end loop;
   end Receiver_ISR;


   function Get return Character is
      function To_Char is new Ada.Unchecked_Conversion (Target => Character,
                                                        Source => Unsigned_8);
   begin
      return To_Char (Get_Raw);
   end Get;


   function Get_Raw return Unsigned_8 is
   begin
      if Receive_Mode = Polled then
         while UCSRA_Bits (RXC_Bit) = False loop null; end loop;
         return UDR;
         --     0:   80 91 c0 00     lds     r24, 0x00C0
         --     4:   87 ff           sbrs    r24, 7
         --     6:   fc cf           rjmp    .-8             ; 0x0
         --     8:   80 91 c6 00     lds     r24, 0x00C6
         --     c:   08 95           ret
      else -- interrupt
         declare
            Byte : Unsigned_8;
         begin

            while Rx_Outx = Rx_Inx loop null; end loop;

            Byte := Rx_Buf (Rx_Outx);

            if Rx_Outx = Rx_Buf.all'Last then
               Rx_Outx := Rx_Buf.all'First;
            else
               Rx_Outx := Rx_Outx + 1;
            end if;

            return Byte;
         end;
      end if;
   end Get_Raw;


   procedure Get_Raw (Byte : out Unsigned_8) is
   begin
      Byte := Get_Raw;
   end Get_Raw;


   function Have_Input return Boolean is
   begin
      return Rx_Outx /= Rx_Inx;
   end Have_Input;


   procedure Get_Line (S    : out AVR_String;
                       Last : out Unsigned_8)
   is
      C : Character;
   begin
      for I in S'First .. S'Last loop
         C := Get;
         if C = ASCII.CR or C = ASCII.LF then
            Last :=  I - 1;
            return;
         else
            S (I) := C;
         end if;
      end loop;
      Last := S'Last;

      return;
   end Get_Line;

end AVR.UART;
