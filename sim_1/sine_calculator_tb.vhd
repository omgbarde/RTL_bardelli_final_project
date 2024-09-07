-- max frequency achieved: 20.833 MHz

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity sine_calculator_tb is
end sine_calculator_tb;

architecture Behavioral of sine_calculator_tb is

    component sine_calculator is
        port (
            ANGLE:  in std_logic_vector (8 downto 0);   -- input angle as a 9 bit unsigned integer
            CLK:    in std_logic;                       -- clock signal
            RST:    in std_logic;                       -- reset signal
            SINE:   out std_logic_vector(9 downto 0);   -- output calculated sine as a 10 bit fixed point float
            ERR:    out std_logic                       -- error flag (if raised any putput is to be considered invalid)
            );
    end component;

    signal test_angle: std_logic_vector(8 downto 0) := "000000000";
    signal tb_clock: std_logic := '1';
    signal tb_reset: std_logic := '0';
    signal output_sine: std_logic_vector(9 downto 0);
    signal error: std_logic;
    
begin

    DUT: sine_calculator
            port map (ANGLE => test_angle, CLK => tb_clock, RST => tb_reset, SINE => output_sine, ERR => error);
    
            
    GENERATE_CLOCK: process
    begin
        wait for 24 ns;             -- half period
        tb_clock <= not tb_clock;
    end process;
    
    STIMULATE_COMPONENT: process
    begin
        wait for 2 ns;
        tb_reset <= '1';
        wait for 2 ns;
        tb_reset <= '0';
        wait for 46 ns;
        
        for I in 0 to 511 loop
            wait for 48 ns;
            test_angle <= test_angle + 1;
        end loop;
    end process;

end Behavioral;
