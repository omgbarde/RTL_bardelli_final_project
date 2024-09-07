library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiple8 is
    port (
            x :         in  std_logic_vector(6 downto 0);   -- input number
            x_prev :    out std_logic_vector(6 downto 0);   -- previous multiple of 8
            x_next :    out std_logic_vector(6 downto 0)   -- next multiple of 8
        );
end multiple8;

architecture structural of multiple8 is

    component carry_lookahead_add_sub_n is
        generic (N : integer);
        port (
                A:          in std_logic_vector(N-1 downto 0);  -- first operator
                B:          in std_logic_vector(N-1 downto 0);  -- second operator
                Add_sub:    in std_logic;                       -- 0 -> add, 1 -> sub
                Z:          out std_logic_vector(N-1 downto 0); -- output
                Carry_out:  out std_logic                       -- carry out
            );
    end component;
    
    component comparator_n is
        generic (M : integer);
        port (
                X,Y:            in std_logic_vector(M-1 downto 0);  -- two inputs for comparison
                X_greater_Y:    out std_logic;                      -- '1' if X > Y else '0'
                X_less_Y:       out std_logic;                      -- '1' if X < Y else '0'
                X_equal_Y:      out std_logic                       -- '1' if X = Y else '0'
         );
    end component;
    
    signal x_ext : std_logic_vector(7 downto 0);
    signal temp1 : std_logic_vector(6 downto 0);
    signal temp2 : std_logic_vector(6 downto 0);
    signal ovr : std_logic;

begin
    
    x_ext <= '0' & x;
    
    -- equivalent of floor(x/8)
    temp1(6 downto 3) <= x(6 downto 3);
    -- equivalent of z*8
    temp1(2 downto 0) <= (others => '0');
    
    --compares if the input is > 87 therefore it has no next multiple of 8 in the 0-90 range
    COMPARATOR: comparator_n
                generic map (M =>8)
                port map (X => x_ext, Y => "01010111", X_greater_Y => ovr, X_less_Y => open, X_equal_Y => open);
                
    ADDER: carry_lookahead_add_sub_n 
                generic map(N => 7)
                port map (A => temp1, B => "0001000", Add_sub => '0', Z => temp2, Carry_out => open);
    
    -- outputs the same number in case the input was 88, 89 or 90
    -- the previous/next multiples otherwise
    x_prev <= temp1 when ovr = '0'
              else x;
              
    x_next <= temp2 when ovr = '0'
              else x;
                    
end structural;