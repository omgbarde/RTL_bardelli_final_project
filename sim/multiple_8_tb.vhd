-- OK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiple8_tb is
end multiple8_tb;

architecture Behavioral of multiple8_tb is

    component multiple8 is
        Port (
            x :         in  std_logic_vector(6 downto 0);   -- input number
            x_prev :    out std_logic_vector(6 downto 0);   -- previous multiple of 8
            x_next :    out std_logic_vector(6 downto 0);   -- next multiple of 8
            overflow:   out std_logic                       -- raised if input > 87  
        );
    end component;
    
    signal x_test:  std_logic_vector(6 downto 0);
    signal prev:    std_logic_vector(6 downto 0);
    signal succ:    std_logic_vector(6 downto 0);
    signal ovr:     std_logic;

begin

    DUT: multiple8
            port map(
                x => x_test,
                x_prev => prev,
                x_next => succ,
                overflow => ovr
            );
            
    process is
    begin
        x_test <= "0000000";    -- 0
        wait for 10 ns;
        x_test <= "0000011";    -- 3
        wait for 10 ns;
        x_test <= "0000101";    -- 5
        wait for 10 ns;
        x_test <= "0010001";    -- 17
        wait for 10 ns;
        x_test <= "0011001";    -- 25
        wait for 10 ns;
        x_test <= "0011110";    -- 30
        wait for 10 ns;
        x_test <= "0101100";    -- 44
        wait for 10 ns;
        x_test <= "0111001";    -- 57
        wait for 10 ns;
        x_test <= "0111101";    -- 61
        wait for 10 ns;
        x_test <= "1001110";    -- 78
        wait for 10 ns;
        x_test <= "1011000";    -- 88
        wait for 10 ns;
        x_test <= "1011001";    -- 89
        wait for 10 ns;
        x_test <= "1011010";    -- 90
        wait for 10 ns;
        x_test <= "1011110";    -- random high number
        wait;
    end process;

end Behavioral;
