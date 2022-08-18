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

package body AVR.SPI.Master is

   ------------------------------------------------------------------
   -- Drive the Built-in SS Pin for Slave Select (Use is optional)
   ------------------------------------------------------------------
   procedure SS_Proc (Activate_Select : Boolean) is
   begin
      BV_SS := Activate_Select xor True;   -- SS is Active Low
   end SS_Proc;

   --------------------------------------------------------------------
   -- Send out a single byte as master and return a received input byte
   --------------------------------------------------------------------
   function Read_Write (Output : Nat8) return Nat8
   is
   begin
      SPDR := Output;        --  Send byte on it's way
      loop
         exit when BV_SPIF;  --  Transmission complete?
      end loop;
      return SPDR;           --  Read slave data, if any
   end Read_Write;

   --------------------------------------------------------------------
   -- just send out a single byte as master
   --------------------------------------------------------------------
   procedure Write (Output : Nat8)
   is
      Dummy : Nat8;
   begin
      Dummy := Read_Write (Output);
   end Write;

   ------------------------------------------------------------------
   -- Master I/O with Slave
   ------------------------------------------------------------------
   procedure Master_IO
     (Data_Buffer : in out SPI_Data_Type;  -- Input/Output buffer
      SS_Status :   in     SS_Status_Proc  -- Proc to set Slave Select status
     )
   is
   begin

      Interrupts.Disable_Interrupts;
      Enable_Device (False, False);
      Config_Device;
      Enable_Device (True, Master_Mode => True);
      AVR.Interrupts.Enable_Interrupts;

      loop
         SS_Status (True);                 -- Select slave device

         for X in Data_Buffer'Range loop
            exit when BV_WCOL;             -- Quit if Write Collision

            Data_Buffer(X) := Read_Write (Data_Buffer(X));
         end loop;

         if not BV_WCOL then
            SS_Status (False);             -- Unselect slave device
            Stop_Device;
            return;
         end if;

         ----------------------------------------------------------
         -- Recover after Write Collision Error
         ----------------------------------------------------------
         Stop_Device;
         SS_Status (False);                -- Unselect slave
         Start_Device (Master_Mode => True);
      end loop;

   end Master_IO;

end AVR.SPI.Master;
