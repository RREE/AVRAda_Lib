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
-- The Slave_IO(..) procedure readies the SPI device to transceive
-- with the master SPI device.
--
-- NOTES:
--
--  (1) This facility is interrupt driven, so it should not lose data
--      if you are using AVR.Threads and get preempted for too long.
--  (2) It is assumed that you have called AVR.SPI.Startup(..) first.
--  (3) Data_Buffer is updated in place with data received from the
--      master.
--  (4) Count initially indicates how many slave bytes to send. The
--      number of bytes received is also returned in Count.
--  (5) Sending slave data is optional. You may specify a Count of zero.
--  (6) Control will not be returned until at least one byte is received.
--  (7) The Error return status indicates that either the incoming
--      message was too large for Data_Buffer, or the number of slave
--      bytes being sent was not completely sent.
--  (8) The Data_Buffer must be large enough to receive the longest
--      possible message from master.
--  (9) Supply an Idle_Proc if you have other tasks to perform, or
--      wish to invoke AVR.Threads.Thread_Yield when the slave
--      device is waiting for data to be received.
--
---------------------------------------------------------------------------

package AVR.SPI.Slave is

   type Idle_Proc is access
     procedure;

   type Data_Buffer_Ptr is access all SPI_Data_Type;

   ------------------------------------------------------------------
   -- Ready Slave SPI for Communication with Master Device
   ------------------------------------------------------------------
   procedure Slave_IO
     (Data_Buffer : in     Data_Buffer_Ptr;   -- Input/Output buffer
      Count :       in out Natural;           -- How many bytes to send
      Error :          out Boolean;           -- Indicates message truncation or error
      Idle :        in     Idle_Proc := null  -- Idle procedure (for thread yield etc.)
     );

end AVR.SPI.Slave;
