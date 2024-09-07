library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity complement_2 is
    generic(N : integer);
    port (
            X:      in std_logic_vector(N-1 downto 0);  -- input number
            X_comp: out std_logic_vector(N-1 downto 0)  -- two's complement
        );
end complement_2;

architecture RTL of complement_2 is
 
    component HA is
        port(
              X:    in std_logic;     -- input bit
              Cin:  in std_logic;     -- carry in
              Y:    out std_logic;    -- arythmetic sum
              Cout: out std_logic     -- carry out
              );
    end component;

    signal X_not:       std_logic_vector(N-1 downto 0);
    signal C:           std_logic_vector(N downto 0);
    signal RES:         std_logic_vector(N-1 downto 0);


begin
    
    -- negate the input
    X_not <= not X;
    
    C(0) <= '1';
    
    -- Create the Half Adders
    GENERATE_ADDER : for I in 0 to N-1 generate
        U: HA port map (
                X  => X_not(I),
                Cin => C(I),        
                Y   => RES(I),
                Cout => C(I+1)
                );
     end generate GENERATE_ADDER;
     
     X_comp <= RES;
     
end RTL;