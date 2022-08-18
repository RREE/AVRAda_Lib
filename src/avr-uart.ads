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


--  Subprograms to access the on-chip uart/usart in polled and in
--  interrupt driven mode.  There is a compile time boolean constant
--  in the body of this package to choose between the two modes.
--
--  Call Init as the first routine of this package for the polled mode
--  or Init_Interrupt_Read for the interrupt driven read mode.


with AVR.Strings;                  use AVR.Strings;
with AVR.Programspace;             use AVR.Programspace;

package AVR.UART is
   pragma Preelaborate;


   type Serial_Speed is new Unsigned_16;
   Baud_1200_1MHz    : constant Serial_Speed := 51;
   Baud_4800_1MHz    : constant Serial_Speed := 12;

   Baud_2400_4MHz    : constant Serial_Speed := 103;
   Baud_4800_4MHz    : constant Serial_Speed := 51;
   Baud_19200_4MHz   : constant Serial_Speed := 12;

   Baud_4800_8MHz    : constant Serial_Speed := 103;
   Baud_9600_8MHz    : constant Serial_Speed := 51;
   Baud_19200_8MHz   : constant Serial_Speed := 25;
   Baud_38400_8MHz   : constant Serial_Speed := 12;

   Baud_4800_12MHz   : constant Serial_Speed := 155;
   Baud_9600_12MHz   : constant Serial_Speed := 77;
   Baud_19200_12MHz  : constant Serial_Speed := 38;
   Baud_57600_12MHz  : constant Serial_Speed := 12;

   -- 14.7456MHz crystal gives 0.0% error rate for 115200bps
   Baud_115200_14_7MHz : constant Serial_Speed := 7;  -- error = 0.0%

   Baud_9600_16MHz   : constant Serial_Speed := 103;
   Baud_19200_16MHz  : constant Serial_Speed := 51;
   Baud_38400_16MHz  : constant Serial_Speed := 25;
   Baud_57600_16MHz  : constant Serial_Speed := 16; -- error = 2.1%
   Baud_76800_16MHz  : constant Serial_Speed := 12;
   Baud_115200_16MHz : constant Serial_Speed := 8;  -- error = 3.7%

   Baud_9600_20MHz   : constant Serial_Speed := 129;
   Baud_19200_20MHz  : constant Serial_Speed := 64;
   Baud_38400_20MHz  : constant Serial_Speed := 32; -- error = 1.4%
   Baud_76800_20MHz  : constant Serial_Speed := 15; -- error = 1.7%
   Baud_115200_20MHz : constant Serial_Speed := 10; -- error = 1.4%

   --  initialize the registers, internal clock and baud rate generator
   procedure Init (Baud_Divider : Serial_Speed;
                   Double_Speed : Boolean := False);

   type Buffer_Ptr is access all Nat8_Array;
   procedure Init_Interrupt_Read (Baud_Divider   : Serial_Speed;
                                  Double_Speed   : Boolean := False;
                                  Receive_Buffer : Buffer_Ptr);

   --  used for interfacing with C
   --  can put out a C like zero ended string
   type Chars_Ptr is access all Character;
   pragma No_Strict_Aliasing (Chars_Ptr);

   --  Output routines
   procedure Put (Ch : Character);
   procedure Put_Char (Ch : Character) renames Put;
   procedure Put_Raw (Data : Unsigned_8);

   procedure Put (S : AVR_String);
   --  procedure Put (S : Pstr20.Pstring);
   procedure Put (Str : Program_Address; Len : Unsigned_8);
   procedure Put_C (S : Chars_Ptr);
   procedure Put (S : Chars_Ptr) renames Put_C;

   procedure Put_Line (S : AVR_String);
   procedure Put_Line (S : Chars_Ptr);

   procedure New_Line;  --  only line-feed (LF)
   procedure CRLF;      --  DOS like CR & LF

   procedure Put (Data : Unsigned_8;
                  Base : Unsigned_8 := 10);

   procedure Put (Data : Integer_16;
                  Base : Unsigned_8 := 10);

   procedure Put (Data : Unsigned_16;
                  Base : Unsigned_8 := 10);

   procedure Put (Data : Unsigned_32;
                  Base : Unsigned_8 := 10);

   --  Input routines
   function Get return Character;
   function Get_Raw return Unsigned_8;
   procedure Get_Raw (Byte : out Unsigned_8);
   function Have_Input return Boolean;

   procedure Get_Line (S    : out AVR_String;
                       Last : out Unsigned_8);

private

   pragma Inline (Get);
   pragma Inline (Put_Raw);
   pragma Inline (Have_Input);

   pragma Inline (Put_Char);

   pragma Inline (New_Line);
   pragma Inline (CRLF);

end AVR.UART;
