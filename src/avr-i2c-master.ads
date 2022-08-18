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

--
-- I2C package for masters
--

with Interfaces;                   use Interfaces;

package AVR.I2C.Master is

   --  set the transmission speed (100kHz=standard, 400kHz=fast) at
   --  the top of the package body

   --  initialize as a master
   procedure Init;

   --  see if a device responds at the given address
   procedure Detect_Device (Device : I2C_Address; Is_Present : out Boolean);


   --  sending data to a slave (device) consists of three steps
   --     1) provide the target address (Send)
   --     2) queue the data to be sent (Put)
   --     3) actually send the data and terminate the session by a stop
   --        sequence (Finish_Send)

   --  The stop sequence is
   --     - either a real stop releasing the bus (Action=Stop).
   --       Potentially another master might take over the bus.
   --     - or the master continuous to control the bus
   --       (Action=Restart) allowing further send or receive messages.

   --  Design considerations: although the unconstrained array in Ada
   --  is quite elegant at the source code level, it generates a lot
   --  of assembler instructions for AVR.  We therefore also provide
   --  non overloaded functions with constrained arrays.  In a typical
   --  application with only one or very few clients on the bus you
   --  probably use only one of the constrained functions.  All other
   --  code is automatically removed during linking.

   type End_Of_Transmission is (Stop, Restart);

   --  procedure Send (Device : I2C_Address);
   procedure Send (Device : I2C_Address;
                   Data   : Data_Buffer);
   procedure Send (Device : I2C_Address;
                   Data   : Unsigned_8);
   procedure Send (Device : I2C_Address;
                   D1     : Unsigned_8;
                   D2     : Unsigned_8);
   procedure Send (Device : I2C_Address;
                   Data   : Unsigned_16);
   procedure Send (Device : I2C_Address;
                   D1     : Unsigned_16;
                   D2     : Unsigned_16);
   --  procedure Send (Device : I2C_Address;
   --                  Data   : Integer_8);
   --  procedure Send (Device : I2C_Address;
   --                  D1     : Integer_8;
   --                  D2     : Integer_8);
   --  procedure Send (To     : I2C_Address;
   --                  Data   : Nat8_Arr2;
   --                  Action : End_Of_Transmission := Stop);


   procedure Finish_Send (Action : End_Of_Transmission := Stop);


   --  For receiving data from a slave you also have to provide the
   --  slave (device) address.  Available data is indicated by
   --  Data_Is_Avalable.  The actual data can be retrieved with the
   --  Get functions.  At the end of the slave transmission the master
   --  emits a stop sequence following the same rules as for sending
   --  from master to the slave.

   procedure Request (Device : I2C_Address;
                      Count  : Buffer_Index);

   function Data_Is_Available return Boolean
     with Inline;
   function Get return Unsigned_8;
   --  function Get return Integer_8;
   function Get return Unsigned_16;
   function Get_U16_LE return Unsigned_16; -- low endian
   --  function Get return Integer_16;
   --  procedure Get (Data : out Data_Buffer);
   --  function Get_No_Ack return Unsigned_8;
   --  function Get_No_Ack return Integer_8;
   --  function Get_No_Ack return Unsigned_16;
   --  function Get_No_Ack return Integer_16;
   -- procedure Finish_Request (Action : End_Of_Transmission := Stop);


   procedure Send_And_Receive (Device :     I2C_Address;
                               Arg    :     Unsigned_8;
                               Data   : out Unsigned_8);
   procedure Send_And_Receive (Device :     I2C_Address;
                               Arg    :     Unsigned_8;
                               Data   : out Unsigned_16);
   procedure Send_And_Receive (Device :     I2C_Address;
                               Arg    :     Unsigned_16;
                               Data   : out Unsigned_16);


   function Get_Error return Error_T;

end AVR.I2C.Master;
