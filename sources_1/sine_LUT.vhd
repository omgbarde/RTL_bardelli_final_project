library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sine_LUT is
    port(
        Angle:  in  std_logic_vector(6 downto 0);   -- input angle (0 - 90) in binary
        Sine:   out  std_logic_vector(9 downto 0)   -- sine value for that angle in fixed point notation [2 + 8]
        );
end sine_LUT;

architecture RTL of sine_LUT is

begin

    with Angle select
        Sine <= "0000000000" when "0000000", -- 0
                "0000100011" when "0001000", -- 8
                "0001000110" when "0010000", -- 16
                "0001101000" when "0011000", -- 24
                "0010000111" when "0100000", -- 32
                "0010100100" when "0101000", -- 40
                "0010111110" when "0110000", -- 48
                "0011010100" when "0111000", -- 56
                "0011100110" when "1000000", -- 64
                "0011110011" when "1001000", -- 72
                "0011111100" when "1010000", -- 80
                "0011111110" when "1011000", -- 88
                "0011111111" when "1011001", -- 89
                "0100000000" when "1011010", -- 90
                "----------" when others;

end RTL;
