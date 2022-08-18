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

with AVR.Interrupts;

package body AVR.SPI is

   ------------------------------------------------------------------
   -- INTERNAL - Configure the SPI Device
   ------------------------------------------------------------------
   procedure Config_Device is
   begin

      BV_MSTR := False;          -- For now

      --------------------------------------------------------------
      -- Disable I/O Pins until we go Master or Slave
      --------------------------------------------------------------

      BV_DD_SCK  := DD_Input;
      BV_DD_MISO := DD_Input;
      BV_DD_MOSI := DD_Input;
      BV_DD_SS   := DD_Input;

      --------------------------------------------------------------
      -- However, if Config_SS_Pin, then set up for slave select
      --------------------------------------------------------------
      if Config_SS_Pin then          -- Use the SS pin?
         BV_SS := True;              -- Yes, then set it high for now (inactive)
         BV_DD_SS  := DD_Output;     -- Make it an output pin
      end if;

      --------------------------------------------------------------
      -- Set the clock mode
      --------------------------------------------------------------
      case Config_Clock_Mode is
         when Sample_Rising_Setup_Falling =>
            BV_CPOL := False;
            BV_CPHA := False;
         when Setup_Rising_Sample_Falling =>
            BV_CPOL := False;
            BV_CPHA := True;
         when Sample_Falling_Setup_Rising =>
            BV_CPOL := True;
            BV_CPHA := False;
         when Setup_Falling_Sample_Rising =>
            BV_CPOL := True;
            BV_CPHA := True;
      end case;

      --------------------------------------------------------------
      -- Set the clock divisor
      --------------------------------------------------------------
      case Config_Clock_Divisor is
         when By_2 =>            -- Fosc / 2
            BV_SPI2X := True;
            BV_SPR1 := False;
            BV_SPR0 := False;
         when By_4 =>            -- Fosc / 4
            BV_SPI2X := False;
            BV_SPR1 := False;
            BV_SPR0 := False;
         when By_8 =>            -- Fosc / 8
            BV_SPI2X := True;
            BV_SPR1 := False;
            BV_SPR0 := True;
         when By_16 =>           -- Fosc / 16
            BV_SPI2X := False;
            BV_SPR1 := False;
            BV_SPR0 := True;
         when By_32 =>           -- Fosc / 32
            BV_SPI2X := True;
            BV_SPR1 := True;
            BV_SPR0 := False;
         when By_64 =>           -- Fosc / 64
            BV_SPI2X := False;
            BV_SPR1 := True;
            BV_SPR0 := False;
         when By_128 =>          -- Fosc / 128
            BV_SPI2X := False;
            BV_SPR1 := True;
            BV_SPR0 := True;
         when By_64_2X =>        -- Fosc / 64 in double mode
            BV_SPI2X := True;
            BV_SPR1 := True;
            BV_SPR0 := True;
      end case;

      --------------------------------------------------------------
      -- Set data order (endianness)
      --------------------------------------------------------------

      BV_DORD := Config_MSB_First xor True; -- 1=LSB first, 0=MSB first

   end Config_Device;

   ------------------------------------------------------------------
   -- INTERNAL - Enable / Disable SPI Device
   ------------------------------------------------------------------
   procedure Enable_Device (Enable : Boolean; Master_Mode : Boolean) is
   begin

      if Enable then
         BV_MSTR := Master_Mode;

         if Master_Mode then
            ------------------------------------------------------
            -- Configure the SS pin if we are using it
            ------------------------------------------------------
            if Config_SS_Pin then           -- Use the SS pin?
               BV_SS := True;              -- Yes, then set it high for now (inactive)
               BV_DD_SS  := DD_Output;     -- Make it an output pin
            end if;

            ------------------------------------------------------
            -- Configure the SPI Data Pin Directions
            ------------------------------------------------------
            BV_DD_SCK  := DD_Output;        -- We must configure this
            --  BV_DD_MISO := DD_Input;         -- SPI auto overrides this as shown
            BV_DD_MOSI := DD_Output;        -- We must configure this

            ------------------------------------------------------
            -- Set
            ------------------------------------------------------
            BV_SPIE := False;               -- Don't use interrupts in master mode
         else
            --  BV_DD_SCK  := DD_Input;         -- SPI auto overrides this as shown
            BV_DD_MISO := DD_Output;        -- We must set this to output mode
            --  BV_DD_MOSI := DD_Input;         -- SPI auto overrides this as shown
            --  BV_DD_SS   := DD_Input;         -- SPI auto overrides this as shown

            BV_SPIE := True;                -- Use receiver interrupts
         end if;
      else
         if Config_SS_Pin then              -- Use the SS pin?
            BV_SS := True;                  -- Yes, then set it high for now (inactive)
            BV_DD_SS  := DD_Output;         -- Make it an output pin
         end if;
         BV_SPIE := False;                   -- Turn off interrupts when disabled
      end if;

      BV_SPE := Enable;                       -- Enable/Disable SPI Device

   end Enable_Device;

   ------------------------------------------------------------------
   -- INTERNAL - Start Device in Configured Mode
   ------------------------------------------------------------------
   procedure Start_Device (Master_Mode : Boolean) is
   begin
      Interrupts.Disable_Interrupts;
      Enable_Device (True, Master_Mode);
      Interrupts.Enable_Interrupts;
   end Start_Device;

   ------------------------------------------------------------------
   -- INTERNAL - Stop Device
   ------------------------------------------------------------------
   procedure Stop_Device is
   begin
      Interrupts.Disable_Interrupts;
      Enable_Device (False, False);
      Interrupts.Enable_Interrupts;
   end Stop_Device;

   ------------------------------------------------------------------
   -- Initialize SPI Device and Perform Most of the Configuration
   ------------------------------------------------------------------
   procedure Startup
     (Clock_Divisor :     in      Clock_Divisor_Type;
      Clock_Mode :        in      Clock_Mode_Type;
      MSB_First :         in      Boolean := True;
      Use_SS_Pin :        in      Boolean := True)
   is
   begin

      Interrupts.Disable_Interrupts;

      BV_PRSPI := SPI_Operating;      -- Make sure it has not been shut down for power savings

      Config_Clock_Divisor := Clock_Divisor;
      Config_Clock_Mode    := Clock_Mode;
      Config_MSB_First     := MSB_First;
      Config_SS_Pin        := Use_SS_Pin;

      Enable_Device (False, False);   -- Disable the device for now
      Config_Device;                  -- but otherwise configure it

      Interrupts.Enable_Interrupts;

   end Startup;

   ------------------------------------------------------------------
   -- Shutdown SPI Device to save power (Inlined)
   ------------------------------------------------------------------
   procedure Shutdown is
   begin
      Interrupts.Disable_Interrupts;
      Enable_Device (False, False);   -- Disable the device for now
      BV_PRSPI := SPI_Shutdown;       -- Power SPI off to save power
      Interrupts.Enable_Interrupts;
   end Shutdown;

end AVR.SPI;
