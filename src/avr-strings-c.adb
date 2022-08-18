-- with Ada.Unchecked_Conversion;
with Interfaces;                   use Interfaces;

package body AVR.Strings.C is

   function "&" (L : String; R : AVR_String) return String
   is
      LL : constant Natural := L'Length;
      LR : constant Natural := R'Length;
      S  : String (1 .. LL + LR);
   begin
      S (1 .. LL) := L;
      for I in R'Range loop
         S (LL + Natural(I - R'First + 1)) := R(I);
      end loop;

      return S;
   end "&";


   function "&" (L : AVR_String; R : String) return String
   is
      LL : constant Natural := L'Length;
      LR : constant Natural := R'Length;
      S  : String (1 .. LL + LR);
   begin
      S (LL+1 .. S'Last) := R;
      for I in L'Range loop
         S (1 + Natural (I - L'First)) := L(I);
      end loop;
      return S;
   end "&";


   function "=" (L : String; R : AVR_String) return Boolean
   is
   begin
      if L'Length /= R'Length then
         return False;
      end if;

      for I in R'Range loop
         if L (L'First + I - R'First) /= R (I) then
            return False;
         end if;
      end loop;
      return True;
   end "=";


   function "=" (L : AVR_String; R : String) return Boolean
   is
   begin
      return R = L;
   end "=";


end AVR.Strings.C;
