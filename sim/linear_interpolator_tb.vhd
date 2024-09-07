-- OK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;


entity linear_interpolator_tb is
end linear_interpolator_tb;

architecture Behavioral of linear_interpolator_tb is

    component linear_interpolator is 
        port (
            sign_flag:  in  std_logic;                      -- denotes if the calculated sine has to be complemented
            overflow:   in  std_logic;                      -- denotes if the angle has no next multiple of 8
            x_int:      in  std_logic_vector (6 downto 0);  -- value of x to interpolate the function at
            x_0:        in  std_logic_vector (6 downto 0);  -- nearest previous value of x
            y_0:        in  std_logic_vector (9 downto 0);  -- value of the funcction at previous point
            y_1:        in  std_logic_vector (9 downto 0);  -- value of the funcction at next point
            y_out:      out std_logic_vector (9 downto 0)   -- linearly interpolated value
            );
    end component;
    
    signal sign:    std_logic;
    signal ovr:    std_logic;
    signal x:       std_logic_vector (6 downto 0);
    signal x0:       std_logic_vector (6 downto 0);
    signal y0:      std_logic_vector (9 downto 0);
    signal y1:      std_logic_vector (9 downto 0);
    signal RES:     std_logic_vector (9 downto 0);
    
begin
    
    DUT: linear_interpolator
            port map(sign_flag => sign, overflow => ovr, x_int => x, x_0 => x0, y_0 => y0, y_1=> y1, y_out => RES);

    STIMULATE_COMPONENT: process is
    begin
    
        sign <= '0';
        ovr <= '0';
        
        -- 0 - 8
        x0 <= "0000000";
        y0 <= "0000000000";
        y1 <= "0000100011";
        x <= "0000000";

        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 8 - 16
        x0 <= "0001000";
        y0 <= "0000100011";
        y1 <= "0001000110";
        x <= "0001000";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;
        
        -- 16 - 24
        x0 <= "0010000";
        y0 <= "0001000110";
        y1 <= "0001101000";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;
        
        -- 24 - 32
        x0 <= "0011000";
        y0 <= "0001101000";
        y1 <= "0010000111";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 32 - 40
        x0 <= "0100000";
        y0 <= "0010000111";
        y1 <= "0010100100";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 40 - 48
        x0 <= "0101000";
        y0 <= "0010100100";
        y1 <= "0010111110";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 48 - 56
        x0 <= "0110000";
        y0 <= "0010111110";
        y1 <= "0011010100";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 56 - 64
        x0 <= "0111000";
        y0 <= "0011010100";
        y1 <= "0011100110";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 64 - 72
        x0 <= "1000000";
        y0 <= "0011100110";
        y1 <= "0011110011";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 72 - 80
        x0 <= "1001000";
        y0 <= "0011110011";
        y1 <= "0011111100";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;
        
        -- 80 - 88
        x0 <= "1010000";
        y0 <= "0011111100";
        y1 <= "0011111110";
        for I in 0 to 7 loop
            wait for 10 ns;
            x <= x + '1';
        end loop;
        wait for 5 ns;

        -- 88, 89, 90
        ovr <= '1';
        
        x0 <= "1011000";
        y0 <= "0011111110";
        y1 <= "----------";
        wait for 10 ns;
        
        x0 <= "1011001";
        y0 <= "0011111111";
        y1 <= "----------";
        x <= x + '1';
        wait for 10 ns;
        
        x0 <= "1011010";
        y0 <= "0100000000";
        y1 <= "----------";
        x <= x + '1';
        wait;

    end process;

end Behavioral;
