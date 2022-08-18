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


--  Subprograms to access the on-chip uart/usart in polled mode.

with AVR.Strings;                  use AVR.Strings;
with AVR.Strings.Progmem;          use AVR.Strings.Progmem;
with AVR.Generic_Text_IO;
with AVR.UART_Base_Polled;

package AVR.Serial_Polled is
   pragma Preelaborate;

   package Base renames AVR.UART_Base_Polled;

   subtype Serial_Speed is Base.Serial_Speed;
   Baud_1200_1MHz    : Serial_Speed renames Base.Baud_1200_1MHz;
   Baud_4800_1MHz    : Serial_Speed renames Base.Baud_4800_1MHz;

   Baud_2400_4MHz    : Serial_Speed renames Base.Baud_2400_4MHz;
   Baud_4800_4MHz    : Serial_Speed renames Base.Baud_4800_4MHz;
   Baud_19200_4MHz   : Serial_Speed renames Base.Baud_19200_4MHz;

   Baud_4800_8MHz    : Serial_Speed renames Base.Baud_4800_8MHz;
   Baud_9600_8MHz    : Serial_Speed renames Base.Baud_9600_8MHz;
   Baud_19200_8MHz   : Serial_Speed renames Base.Baud_19200_8MHz;
   Baud_38400_8MHz   : Serial_Speed renames Base.Baud_38400_8MHz;

   Baud_4800_12MHz   : Serial_Speed renames Base.Baud_4800_12MHz;
   Baud_9600_12MHz   : Serial_Speed renames Base.Baud_9600_12MHz;
   Baud_19200_12MHz  : Serial_Speed renames Base.Baud_19200_12MHz;
   Baud_57600_12MHz  : Serial_Speed renames Base.Baud_57600_12MHz;

   -- 14.7456MHz crystal gives 0.0% error rate for 115200bps
   Baud_115200_14_7MHz : Serial_Speed renames Base.Baud_115200_14_7MHz;

   Baud_9600_16MHz   : Serial_Speed renames Base.Baud_9600_16MHz;
   Baud_19200_16MHz  : Serial_Speed renames Base.Baud_19200_16MHz;
   Baud_28800_16MHz  : Serial_Speed renames Base.Baud_28800_16MHz;
   Baud_38400_16MHz  : Serial_Speed renames Base.Baud_38400_16MHz;
   Baud_57600_16MHz  : Serial_Speed renames Base.Baud_57600_16MHz;
   Baud_76800_16MHz  : Serial_Speed renames Base.Baud_76800_16MHz;
   Baud_115200_16MHz : Serial_Speed renames Base.Baud_115200_16MHz;

   Baud_9600_20MHz   : Serial_Speed renames Base.Baud_9600_20MHz;
   Baud_19200_20MHz  : Serial_Speed renames Base.Baud_19200_20MHz;
   Baud_38400_20MHz  : Serial_Speed renames Base.Baud_38400_20MHz;
   Baud_76800_20MHz  : Serial_Speed renames Base.Baud_76800_20MHz;
   Baud_115200_20MHz : Serial_Speed renames Base.Baud_115200_20MHz;

   --  initialize the registers, internal clock and baud rate generator
   procedure Init (Baud_Divider : Serial_Speed;
                   Double_Speed : Boolean := False) renames Base.Init;

   package Impl is new AVR.Generic_Text_IO
     (Put_Raw => Base.Put_Raw,
      Get_Raw => Base.Get_Raw,
      Flush   => Base.Flush);

   --  used for interfacing with C
   --  can put out a C like zero ended string
   subtype Chars_Ptr is Impl.Chars_Ptr;

   --  Output routines
   procedure Put (Ch : Character) renames Impl.Put_Char;
   procedure Put_Char (Ch : Character) renames Put;
   procedure Put_Raw (Data : Unsigned_8) renames Base.Put_Raw;

   procedure Put (S : AVR_String) renames Impl.Put;
   procedure Put (S : PM_String) renames Impl.Put;
   procedure Put_C (S : Chars_Ptr) renames Impl.Put;
   procedure Put (S : Chars_Ptr) renames Put_C;
   procedure Put_Edited renames Impl.Put_Edited;
   procedure Put renames Put_Edited;

   procedure Put_Line (S : AVR_String) renames Impl.Put_Line;
   procedure Put_Line (S : Chars_Ptr) renames Impl.Put_Line;

   procedure New_Line renames Impl.New_Line;  --  only line-feed (LF)
   procedure CRLF renames Impl.CRLF;      --  DOS like CR & LF

   --  Input routines
   function Available return Boolean renames Base.Available;
   function Get return Character renames Impl.Get;
   function Get_Raw return Unsigned_8 renames Base.Get_Raw;
   procedure Get_Raw (Byte : out Unsigned_8) renames Impl.Get_Raw;

   procedure Get_Line (S    : out AVR_String;
                       Last : out Unsigned_8) renames Impl.Get_Line;

private

   pragma Inline (Get);
   pragma Inline_Always (Get_Raw);
   pragma Inline (Put);
   pragma Inline_Always (Put_Char);
   pragma Inline (New_Line);
   pragma Inline (CRLF);

end AVR.Serial_Polled;
