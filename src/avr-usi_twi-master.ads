--
-- USI I2C package for AVR-Ada
--
-- Copyright (C) 2013  Tero Koskinen <tero.koskinen@iki.fi>
--
-- This program is free software; you can redistribute it and/or
-- modify it under the terms of the GNU General Public License
-- as published by the Free Software Foundation; either version 2
-- of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU General Public License
-- along with this program; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301,
-- USA.
--
-- As a special exception, if other files instantiate generics from this
-- unit,  or  you  link  this  unit  with  other  files  to  produce  an
-- executable   this  unit  does  not  by  itself  cause  the  resulting
-- executable to  be  covered by the  GNU General  Public License.  This
-- exception does  not  however  invalidate  any  other reasons why  the
-- executable file might be covered by the GNU Public License.
--


with Interfaces;

package AVR.USI_TWI.Master is
   procedure Init;

   procedure Stop;

   procedure Write_Data (Address : Interfaces.Unsigned_8;
                         Data    : Data_Buffer);

   procedure Request_Data (Address : Interfaces.Unsigned_8;
                           Data    : in out Data_Buffer);

   function Get_Error return TWI_Error_State;

end AVR.USI_TWI.Master;
