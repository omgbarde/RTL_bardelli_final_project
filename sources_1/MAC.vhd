library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAC is
    port ( 
            x:      in std_logic;   -- first bit
            y:      in std_logic;   -- second bit
            pin:    in std_logic;   -- product in  
            cin:    in std_logic;   -- carry in  
            pout:   out std_logic;  -- product out
            cout:   out std_logic   -- carry out  
        );
end MAC;  

architecture structural of MAC is
begin
  
    pout <= (x and y) xor cin xor pin;
    cout <= (x and y and cin) or (x and y and pin) or (cin and pin);
    
end structural;
