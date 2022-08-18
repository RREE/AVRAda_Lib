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
-- Written by Warren W, Gay VE3WWG
---------------------------------------------------------------------------
--
--  This is the top level SPI package. It will be needed by applications
--  wishing to operate in master mode and/or slave mode.
--
--  For Slave or Master applications, you must invoke the Startup
--  procedure to configure the main SPI resources. The final
--  configuration is performed when readying for master or slave
--  operation (see AVR.SPI.Master or AVI.SPI.Slave for that).
--
--  If you need to save power, you may call procedure Shutdown, to
--  turn the peripheral off.  If you need to re-activate it later,
--  you must again invoke procedure Startup. Procedure Shutdown is
--  is inlined, so it will not incure a code penalty unless it is used.
--
--  AVR.SPI.Master does not require the use of interrupts.
--
--  AVR.SPI.Slave does use a receive interrupt service routine so that
--  data is not lost if the calling thread gets pre-empted for too
--  long (see package AVR.Threads).  There is no requirement to
--  preallocate a receive buffer, since the data is received directly
--  into the calling user's data buffer.
--
---------------------------------------------------------------------------

with AVR;                          use AVR;
with AVR.MCU;


package AVR.SPI is

   ------------------------------------------------------------------
   -- SPI Data Buffer Type
   ------------------------------------------------------------------
   type SPI_Data_Type is array (Positive range <>) of Unsigned_8;
   for SPI_Data_Type'Component_Size use 8;

   ------------------------------------------------------------------
   -- Clock Polarity and Phase
   ------------------------------------------------------------------
   type Clock_Mode_Type is
     (
      Sample_Rising_Setup_Falling,  -- CPOL=0, CPHA=0 (Mode 0)  __^--|__^--|____
                                    -- MOSI/MISO                X***XXX***XXXXXX
      Sample_Falling_Setup_Rising,  -- CPOL=1, CPHA=0 (Mode 2)  --v__|--v__|----
      Setup_Rising_Sample_Falling,  -- CPOL=0, CPHA=1 (Mode 1)  __|--v__|--v____
                                    -- MOSI/MISO                XXXX***XXX***XXX
      Setup_Falling_Sample_Rising   -- CPOL=1, CPHA=1 (Mode 3)  --|__^--|__^----
                                    -- Chip Select              -|___________|--
     );

   ------------------------------------------------------------------
   -- Clock Divisors
   ------------------------------------------------------------------
   type Clock_Divisor_Type is
     (
      By_2,           -- clock divided by 2 (SPI2X)
      By_4,           -- clock divided by 4...
      By_8,           -- clock divided by 8 (SPI2X)
      By_16,          -- clock divided by 16
      By_32,          -- clock divided by 32 (SPI2X)
      By_64,          -- clock divided by 64
      By_64_2X,       -- clock divided by 64 (SPI2X)
      By_128          -- clock divided by 128
     );

   ------------------------------------------------------------------
   -- Start and Configure SPI Device
   ------------------------------------------------------------------
   procedure Startup
     (Clock_Divisor :     in      Clock_Divisor_Type;
      Clock_Mode :        in      Clock_Mode_Type;
      MSB_First :         in      Boolean := True;    -- LSB or MSB First
      Use_SS_Pin :        in      Boolean := True     -- Use SS to select slave
     );

   ------------------------------------------------------------------
   -- Shut down SPI device to Save Power
   ------------------------------------------------------------------
   procedure Shutdown;
   pragma Inline (Shutdown);

private

   ------------------------------------------------------------------
   -- Saved SPI Device Configuration
   ------------------------------------------------------------------
   Config_Clock_Divisor :  Clock_Divisor_Type := By_128;
   Config_Clock_Mode :     Clock_Mode_Type := Sample_Rising_Setup_Falling;
   Config_MSB_First :      Boolean := True;
   Config_SS_Pin :         Boolean := True;

   ------------------------------------------------------------------
   -- Internal Support Routines
   ------------------------------------------------------------------
   procedure Config_Device;
   procedure Enable_Device (Enable : Boolean; Master_Mode : Boolean);
   procedure Start_Device (Master_Mode : Boolean);
   procedure Stop_Device;

   ------------------------------------------------------------------
   -- I/O Pins Configuration
   ------------------------------------------------------------------
   #if MCU="at90usb1286" then
   DDR_SPI :       Nat8 renames MCU.DDRB;
   DDR_SPI_Bits :  Bits_In_Byte renames MCU.DDRB_Bits;

   BV_DD_SCK :        Boolean renames DDR_SPI_Bits(MCU.DDB1_Bit);
   BV_DD_MISO :       Boolean renames DDR_SPI_Bits(MCU.DDB3_Bit);
   BV_DD_MOSI :       Boolean renames DDR_SPI_Bits(MCU.DDB2_Bit);
   BV_DD_SS :         Boolean renames DDR_SPI_Bits(MCU.DDB0_Bit);

   BV_SS :            Boolean renames MCU.PORTB_Bits(MCU.PORTB0_Bit);
   --#elsif MCU="atmega168" or else MCU="atmega168p" or else MCU="atmega168pa" then
   #else
   DDR_SPI :       Nat8 renames MCU.DDRB;
   DDR_SPI_Bits :  Bits_In_Byte renames MCU.DDRB_Bits;

   BV_DD_SCK :        Boolean renames DDR_SPI_Bits(MCU.DDB5_Bit);
   BV_DD_MISO :       Boolean renames DDR_SPI_Bits(MCU.DDB4_Bit);
   BV_DD_MOSI :       Boolean renames DDR_SPI_Bits(MCU.DDB3_Bit);
   BV_DD_SS :         Boolean renames DDR_SPI_Bits(MCU.DDB2_Bit);

   BV_SS :            Boolean renames MCU.PORTB_Bits(MCU.PORTB2_Bit);

   #end if;

   ------------------------------------------------------------------
   -- SPCR - SPI Control Register
   ------------------------------------------------------------------
   SPCR :          Nat8 renames MCU.SPCR;
   SPCR_Bits :     Bits_In_Byte renames MCU.SPCR_Bits;

   BV_SPIE :       Boolean renames SPCR_Bits(MCU.SPIE_Bit);
   BV_SPE :        Boolean renames SPCR_Bits(MCU.SPE_Bit);
   BV_DORD :       Boolean renames SPCR_Bits(MCU.DORD_Bit);
   BV_MSTR :       Boolean renames SPCR_Bits(MCU.MSTR_Bit);
   BV_CPOL :       Boolean renames SPCR_Bits(MCU.CPOL_Bit);
   BV_CPHA :       Boolean renames SPCR_Bits(MCU.CPHA_Bit);
   BV_SPR1 :       Boolean renames SPCR_Bits(MCU.SPR1_Bit);
   BV_SPR0 :       Boolean renames SPCR_Bits(MCU.SPR0_Bit);

   ------------------------------------------------------------------
   -- SPSR - SPI Status Register
   ------------------------------------------------------------------
   SPSR :          Nat8 renames MCU.SPSR;
   SPSR_Bits :     Bits_In_Byte renames MCU.SPSR_Bits;

   BV_SPIF :       Boolean renames SPSR_Bits(MCU.SPIF_Bit);
   BV_WCOL :       Boolean renames SPSR_Bits(MCU.WCOL_Bit);
   BV_SPI2X :      Boolean renames SPSR_Bits(MCU.SPI2X_Bit);

   ------------------------------------------------------------------
   -- SPDR - SPI Data Register
   ------------------------------------------------------------------
   SPDR :          Nat8 renames MCU.SPDR;
   SPDR_Bits :     Bits_In_Byte renames MCU.SPDR_Bits;

   ------------------------------------------------------------------
   -- PRR - Power Reduction Register
   ------------------------------------------------------------------
#if MCU = "atmega644p" or MCU = "atmega2560" or MCU = "at90usb1286" then
   PRR :           Nat8 renames MCU.PRR0;
   BV_PRSPI :      Boolean renames MCU.PRR0_Bits(MCU.PRSPI_Bit);
#else
   PRR :           Nat8 renames MCU.PRR;
   BV_PRSPI :      Boolean renames MCU.PRR_Bits(MCU.PRSPI_Bit);
#end if;


   function SPI_Shutdown return Boolean renames True;
   function SPI_Operating return Boolean renames False;

end AVR.SPI;
