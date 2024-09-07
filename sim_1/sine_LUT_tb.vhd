-- OK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity sine_LUT_tb is
end sine_LUT_tb;

architecture Behavioral of sine_LUT_tb is
    
    component sine_LUT is
        port(
            Angle:  in  std_logic_vector(6 downto 0);   -- input angle (0 - 90) in binary
            Sine:   out  std_logic_vector(9 downto 0)   -- sine value for that angle in fixed point notation [2 + 8]
            );
    end component;
    
    signal test_angle: std_logic_vector(6 downto 0):="0000000";
    signal output: std_logic_vector(9 downto 0);

begin
    
    DUT: sine_LUT
            port map (Angle => test_angle, Sine => output);

    STIMULATE_COMPONENT: process
    begin
        wait for 10 ns;
        for I in 0 to 10 loop
            test_angle <= test_angle + "0001000";
            wait for 10 ns;
        end loop;
        
        test_angle <= "1011001";
        wait for 10 ns;
        test_angle <= "1011010";
        wait for 50 ns;
        
        test_angle <= "1111111"; -- no sense
        wait;
    end process;

end Behavioral;
