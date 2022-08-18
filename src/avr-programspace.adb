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

with System.Machine_Code;             use System.Machine_Code;
with System.Storage_Elements;
with AVR.MCU;

package body AVR.Programspace is


   --  set to true, if the the MCU supports the enhanced LPM
   --  instruction with direct addressing in the Z pointer.
   Have_lpm_rd_Zplus : constant Boolean := AVR.MCU.Have_lpm_rd_Zplus;


   --  read bytes (8bit), words (16bit) or double words (32bit) from
   --  an address in programm memory (flash).
   function Get_Byte (Addr : Program_Address) return Unsigned_8 is
      Result : Unsigned_8;
   begin
      if not Have_lpm_rd_Zplus then
         Asm ("lpm"          & ASCII.LF &
              "mov %0, r0",
              Outputs => Unsigned_8'Asm_Output ("=r", Result),
              Inputs  => Program_Address'Asm_Input ("z", Addr),
              Clobber => "r0");
      else
         Asm ("lpm %0, Z",
              Outputs => Unsigned_8'Asm_Output ("=r", Result),
              Inputs  => Program_Address'Asm_Input ("z", Addr));
      end if;
      return Result;
   end Get_Byte;


   function Get_Char (Addr : Program_Address) return Character is
      U : Unsigned_8;
   begin
      U := Get_Byte (Addr);
      return Character'Val (U);
   end Get_Char;


   function Get_Word (Addr : Program_Address) return Unsigned_16 is
      Result     : Unsigned_16;
      Dummy_Addr : Program_Address := Addr;
   begin
      if not Have_lpm_rd_Zplus then
         Asm ("lpm"         & ASCII.LF &
              "mov %A0, r0" & ASCII.LF &
              "adiw r30, 1" & ASCII.LF &
              "lpm"         & ASCII.LF &
              "mov %B0, r0",
              Outputs => (Unsigned_16'Asm_Output ("=r", Result),
                          Program_Address'Asm_Output ("=z", Dummy_Addr)),
              Inputs  => Program_Address'Asm_Input ("1", Addr),
              Clobber => "r0");
      else
         Asm ("lpm %A0, Z+" & ASCII.LF &
              "lpm %B0, Z",
              Outputs => (Unsigned_16'Asm_Output ("=r", Result),
                          Program_Address'Asm_Output ("=z", Dummy_Addr)),
              Inputs  => Program_Address'Asm_Input ("1", Addr));
      end if;
      return Result;
   end Get_Word;


   function Get_DWord (Addr : Program_Address) return Unsigned_32 is
      Result     : Unsigned_32;
      Dummy_Addr : Program_Address := Addr;
   begin
      if not Have_lpm_rd_Zplus then
         Asm ("lpm"         & ASCII.LF &
              "mov %A0, r0" & ASCII.LF &
              "adiw r30, 1" & ASCII.LF &
              "lpm"         & ASCII.LF &
              "mov %B0, r0" & ASCII.LF &
              "adiw r30, 1" & ASCII.LF &
              "lpm"         & ASCII.LF &
              "mov %C0, r0" & ASCII.LF &
              "adiw r30, 1" & ASCII.LF &
              "lpm"         & ASCII.LF &
              "mov %D0, r0" & ASCII.LF,
              Outputs => (Unsigned_32'Asm_Output ("=r", Result),
                          Program_Address'Asm_Output ("=z", Dummy_Addr)),
              Inputs  => Program_Address'Asm_Input ("1", Dummy_Addr),
              Clobber => "r0");
      else
         Asm ("lpm %A0, Z+" & ASCII.LF &
              "lpm %B0, Z+" & ASCII.LF &
              "lpm %C0, Z+" & ASCII.LF &
              "lpm %D0, Z",
              Outputs => (Unsigned_32'Asm_Output ("=r", Result),
                          Program_Address'Asm_Output ("=z", Dummy_Addr)),
              Inputs  => Program_Address'Asm_Input ("1", Addr));
      end if;
      return Result;
   end Get_DWord;


   function Get (Addr : Far_Program_Address) return Unsigned_8 is
      pragma Unreferenced (Addr);
   begin
      return 0;
   end Get;


   function Get (Addr : Far_Program_Address) return Unsigned_16 is
      pragma Unreferenced (Addr);
   begin
      return 0;
   end Get;


   function Get (Addr : Far_Program_Address) return Unsigned_32 is
      pragma Unreferenced (Addr);
   begin
      return 0;
   end Get;


   procedure Inc (Addr : in out Program_Address) -- increment address by 1
   is
      use System.Storage_Elements;
   begin
      Addr := Addr + 1;
   end Inc;

   procedure Dec (Addr : in out Program_Address) -- decrement address by 1
   is
      use System.Storage_Elements;
   begin
      Addr := Addr - 1;
   end Dec;
end AVR.Programspace;
