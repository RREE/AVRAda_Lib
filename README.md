# AVRAda_Lib
Library of drivers for AVR microcontrollers

The library strives to abstract away many of AVR's irregularities
among the different MCUs. There is on one side drives for the on-chip
capabilities, like GPIO, timers, A/D converters, UART, etc.  On the
other side the library provides some functionility that is typically
in the Ada run time system or standard library, like real-time
functions or string handling functions.

The main incentive to write special packages in the AVR hierarchy
instead of the Ada hierarchy are the size constraints of the 8bit
microcontrollers. Some of them only have a few bytes of RAM.  You then
think twice if you want your string variables indexed by a 8bit wide
or 16bit wide index.

The library make heavy use of the GNAT preprocessor. All compilations
have the symbol of the respective MCU name and the UART/Serial
interface distinguishes between UART, USART, USART0, and USART1 for
example. See the file mcu_capabilities.gpr.