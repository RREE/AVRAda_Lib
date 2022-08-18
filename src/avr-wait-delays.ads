--  This package implements AVR.Wait delays

--  Note: the compiler generates direct calls to this interface, in
--  the processing of relative delay statements.

package AVR.Wait.Delays is


   type Duration is delta 0.001 range -32.0 .. 32.0;
   for Duration'Size use 32;


   --  Delay until an interval of length (at least) D seconds has
   --  passed.
   procedure Delay_For (D : Duration);


private
   pragma Export (Ada, Delay_For, "ada__calendar__delays__delay_for");

end AVR.Wait.Delays;
