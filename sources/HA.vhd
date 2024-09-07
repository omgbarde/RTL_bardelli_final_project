library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity HA is
    port(
		  X:    in std_logic;     -- input bit
		  Cin:  in std_logic;     -- carry in
		  Y:    out std_logic;    -- arythmetic sum
		  Cout: out std_logic     -- carry out
		  );
end HA;


architecture structural of HA is
begin
    Y <= X xor Cin;
    Cout <= (X and Cin);
end structural;