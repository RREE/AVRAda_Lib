procedure AVR.Disable_Watchdog_At_Startup;
pragma Linker_Section (AVR.Disable_Watchdog_At_Startup, ".init3");
pragma Machine_Attribute (AVR.Disable_Watchdog_At_Startup, "naked");
