-- OK
library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity multiplier_n_m_tb is
end multiplier_n_m_tb;

architecture behavioral of multiplier_n_m_tb is

component multiplier_n_m
generic (M: integer := 4; N: integer := 4);
    port (
        a    :  in  std_logic_vector(M-1 downto 0);
        b    :  in  std_logic_vector(N-1 downto 0);
        prod :  out std_logic_vector(M+N-1 downto 0) );
end component;

-- signals
signal a       : std_logic_vector(3 downto 0) :="0101";
signal b       : std_logic_vector(3 downto 0) :="1010";
signal answer  : std_logic_vector(7 downto 0);
signal correct : std_logic;

begin
    -- Instantiating the Design Under Test (DUT)
    DUT: multiplier_n_m
    generic map (
        M => 4,
        N => 4 )
    port map (
        a    => a,
        b    => b,
        prod => answer );

    -- Stimulus process
    stim_proc: process
    begin
        wait for 1 ns;
        a <= a + 1;
        if a = "0" then
            b <= b + 1;
        end if;
    end process;

    -- Check results
    correct <= '1' when to_integer(unsigned(a))*to_integer(unsigned(b)) = 
    to_integer(unsigned(answer)) else '0';

end behavioral;