------------------------------------------------------------------------------
--                                                                          --
--                       AVR-Ada LIBRARY COMPONENTS                         --
--                                                                          --
--                      A V R . C O N T A I N E R S 8                       --
--                                                                          --
--                                 S p e c                                  --
--                                                                          --

--      This specification is adapted from the Ada Reference Manual for     --
--      use  with AVR-Ada.  In  accordance with  the copyright  of that     --
--      document, you  can freely  copy and modify  this specification,     --
--      provided  that  if you  redistribute  a  modified version,  any     --
--      changes   that   you   have   made   are   clearly   indicated.     --
--  ----------------------------------------------------------------------- --

package AVR.Containers8 is
   pragma Pure;

   --  reduced ranges to fit into 8 bits
   type Hash_Type is mod 2**8;
   type Count_Type is range 0 .. 2**8 - 1;

private
   for Hash_Type'Size use 8;
   for Count_Type'Size use 8;
end AVR.Containers8;
