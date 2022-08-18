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
-- This package is for sending SPI data in Master Mode
--
-- Notes:
--
--  (1) To select a slave using a pin other than built-in /SS, then
--      you must supply your own SS_Status_Proc.
--  (2) The SS_Status_Proc uses Active=True. The chip select is
--      active low, so be sure to invert the logic at the output pin.
--  (3) Supply SS_Proc'Access if you wish to use the built-in /SS
--      pin to drive slave select.
--  (4) It is assumed you have called AVR.SPI.Startup(...) at least
--      once, prior to calling AVR.SPI.Master.Master_IO(...).
--  (5) The buffer Data_Buffer is overwritten with received data
--      (if any).
--  (6) This functionality operates with SPI interrupts off.
--
---------------------------------------------------------------------

package AVR.SPI.Master is

   type SS_Status_Proc is access
     procedure (Activate_Select : Boolean);

   ------------------------------------------------------------------
   -- Drive the Built-in Slave Select Pin (Optional)
   ------------------------------------------------------------------
   procedure SS_Proc (Activate_Select : Boolean);   -- Drives the SS Pin

   ------------------------------------------------------------------
   -- Initiate SPI Communication as Master
   ------------------------------------------------------------------
   procedure Master_IO
     (Data_Buffer : in out SPI_Data_Type; -- Input/Output buffer
      SS_Status :   in     SS_Status_Proc -- Proc to set Slave Select status (or use SS_Proc)
     );

   --------------------------------------------------------------------
   -- Send out a single byte as master and return a received input byte
   --------------------------------------------------------------------
   function Read_Write (Output : Nat8) return Nat8;

   --------------------------------------------------------------------
   -- just send out a single byte as master
   --------------------------------------------------------------------
   procedure Write (Output : Nat8);
   pragma Inline (Write);

end AVR.SPI.Master;
