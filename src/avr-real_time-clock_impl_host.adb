with AVR.Real_Time;                use AVR.Real_Time;
with Ada.Real_Time.Delays;

function AVR.Real_Time.Clock return Time is
   --  difference in seconds between 1970-01-01 and 2000-01-01
   Delta_Epoch_AVR : constant := 946_684_800.0;
   Now : constant Standard.Duration :=
     Ada.Real_Time.Delays.To_Duration (Ada.Real_Time.Clock) - Delta_Epoch_AVR;
   T : Time;
begin
   T.Days := Day_Count (Long_Long_Integer (Now) / 86_400);
   T.Secs := Duration (Now - Standard.Duration (T.Days) * 86_400.0);
   return T;
end AVR.Real_Time.Clock;
