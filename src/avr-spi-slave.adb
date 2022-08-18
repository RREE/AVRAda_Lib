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

package body AVR.SPI.Slave is

   ------------------------------------------------------------------
   -- Variables used by the Receiving ISR
   ------------------------------------------------------------------
   IO_Buffer :  Data_Buffer_Ptr;    -- Address of I/O Buffer
   Error_Flag : Boolean;            -- True if msg truncated
   X :          Positive;           -- Index into IO_Buffer
   Xmit_Last :  Natural;            -- Index of last byte to xmit

   pragma Volatile (Error_Flag);
   pragma Volatile (X);

   ------------------------------------------------------------------
   -- Ready Slave I/O with Master
   ------------------------------------------------------------------
   procedure Slave_IO
     (Data_Buffer : in     Data_Buffer_Ptr;   -- Input/Output buffer
      Count :       in out Natural;           -- Send & Received Count
      Error :          out Boolean;           -- Indicates message truncation or error
      Idle :        in     Idle_Proc := null  -- Invoke this when idle
     )
   is
   begin

      if Count > Data_Buffer'Last then        -- User error?
         Error := True;                       -- Tried to send more than buffer can hold
         return;
      end if;

      Interrupts.Disable_Interrupts;
      Enable_Device (False, False);           -- Reset and disable SPI peripheral
      Config_Device;                          -- Configure it (mostly)
      Interrupts.Enable_Interrupts;

      IO_Buffer  := Data_Buffer;              -- Receive data into this buffer
      Error_Flag := False;                    -- Reset truncation indicator
      X          := IO_Buffer.all'First;      -- Point to start of buffer
      Xmit_Last  := IO_Buffer.all'First + Count - 1; -- Stop xmit here

      if X <= Xmit_Last then                  -- Is slave sending data?
         SPDR := Data_Buffer(X);              -- Yes, queue first slave byte to be sent
      else
         SPDR := 0;                           -- No, so just send zero bytes
      end if;

      Enable_Device (True, Master_Mode => False); -- Start slave in interupt mode

      loop
         exit when X /= IO_Buffer.all'First;  -- Wait for a byte to be received
         if Idle /= null then
            Idle.all;                         -- This might issue AVR.Threads.Thread_Yield
         end if;
      end loop;

      loop
         exit when not BV_SS;                 -- Wait until SS deactivated (end transmission)
         if Idle /= null then
            Idle.all;                         -- This might issue AVR.Threads.Thread_Yield
         end if;
      end loop;

      Stop_Device;                            -- Stop Slave SPI device

      Count := X - IO_Buffer.all'First;       -- Return received byte count
      Error := Error_Flag;                    -- Truncation ?

      IO_Buffer := null;                      -- Remove buffer from ISR

   end Slave_IO;

   ------------------------------------------------------------------
   -- Reciever ISR
   ------------------------------------------------------------------

   procedure Receiver_ISR;
   pragma Machine_Attribute (Entity => Receiver_ISR, Attribute_Name => "signal");
   pragma Export (C, Receiver_ISR, MCU.Sig_SPI_STC_String);

   procedure Receiver_ISR is
   begin

      if IO_Buffer = null then                -- Do we have a buffer?
         ----------------------------------------------------------
         -- Handle the Interrupt, but do not store the data
         ----------------------------------------------------------
         declare
            Byte : Unsigned_8;
         begin
            loop
               Byte := SPDR;                  -- Clear SPIF status
               exit when not BV_SPIF;
            end loop;
            return;
         end;
      end if;

      --------------------------------------------------------------
      -- Read SPI Data into IO_Buffer
      --------------------------------------------------------------
      loop
         exit when not BV_SPIF;                 -- Loop until no more data

         if X <= IO_Buffer.all'Last then
            IO_Buffer(X) := SPDR;               -- Read input data
            X := X + 1;                         -- Point to next byte to send/recv
         else
            Error_Flag := True;                 -- Tell caller msg is truncated
         end if;

         if X <= Xmit_Last then                 -- Do we have more to send?
            SPDR := IO_Buffer(X);               -- Yes, queue Slave output data
         else
            SPDR := 0;                          -- Else just send zero bytes from slave
         end if;

      end loop;

   end Receiver_ISR;

end AVR.SPI.Slave;
