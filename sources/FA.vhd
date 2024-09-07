library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA is
    port(
		  X:    in std_logic;     -- first bit
		  Y:    in std_logic;     -- second bit
		  Cin:  in std_logic;     -- carry in
		  S:    out std_logic;    -- arythmetic sum
		  Cout: out std_logic     -- carry out
		  );
end FA;


architecture structural of FA is
begin
    S <= X xor Y xor Cin;
    Cout <= (X and Y) or (X and Cin) or (Y and Cin);
end structural;