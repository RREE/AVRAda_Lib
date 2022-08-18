

--  extend serial communication for participating on a LIN bus

package AVR.UART.LIN is

   --
   --  LIN
   --
   procedure Sender_Mode;
   procedure Receiver_Mode;
   procedure Send_LIN_Break;

private

   pragma Inline (Sender_Mode);
   pragma Inline (Receiver_Mode);

end AVR.UART.LIN;
