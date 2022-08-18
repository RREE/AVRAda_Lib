
with Ada.Unchecked_Conversion;
with Interfaces;                   use Interfaces;

package body AVR.Wait.Delays is


   procedure Wait_1ms is new Generic_Wait_USecs (Crystal_Hertz => 16_000_000,
                                                 Micro_Seconds => 1_000);

   function To_Milliseconds is new Ada.Unchecked_Conversion (Source => Duration,
                                                             Target => Integer_32);

   procedure Delay_For (D : Duration) is
      Milliseconds : constant Integer_32 := To_Milliseconds (D);
   begin
      if Milliseconds > 0 then
         for I in 1 .. Milliseconds loop
            Wait_1ms;
         end loop;
      end if;
   end Delay_For;

end AVR.Wait.Delays;
