-- OK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FA_tb is
end FA_tb;

architecture Behavioral of FA_tb is

    component FA is
        port(
              X:    in std_logic;     -- first bit
              Y:    in std_logic;     -- second bit
              Cin:  in std_logic;     -- carry in
              S:    out std_logic;    -- arythmetic sum
              Cout: out std_logic     -- carry out
              );
    end component;
    
    signal X_test:      std_logic;
    signal Y_test:      std_logic;
    signal S_test:      std_logic;
    signal Cout_test:   std_logic;

begin

    DUT: FA 
        port map (
            X => X_test,
            Y => Y_test,
            Cin => '1',
            S => S_test,
            Cout => Cout_test
        );
        
    process is
    begin
        X_test <= '0';
        Y_test <= '0';
        wait for 10 ns;
        X_test <= '0';
        Y_test <= '1';
        wait for 10 ns;
        X_test <= '1';
        Y_test <= '0';
        wait for 10 ns;
        X_test <= '1';
        Y_test <= '1';
        wait;
    end process;

end Behavioral;
