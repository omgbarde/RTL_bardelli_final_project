library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity angle_transformer is
    port(
        Theta:      in std_logic_vector(8 downto 0);    -- input angle
        ThetaPrime: out std_logic_vector(6 downto 0);   -- output translated angle
        SignFlag:   out std_logic;                      -- sign corrisponding to the quadrant
        ErrorFlag:  out std_logic                       -- raised if the input angle is invalid (> 360)
     );
    
end angle_transformer;

architecture RTL of angle_transformer is 

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
    
    signal Theta_ext: std_logic_vector (9 downto 0);
    signal IS_FIRST_QUADRANT: std_logic;            -- signal to assert first quadrant
    signal IS_SECOND_QUADRANT: std_logic;           -- signal to assert second quadrant
    signal IS_THIRD_QUADRANT: std_logic;            -- signal to assert THIRD quadrant
    signal R1: std_logic_vector(8 downto 0);       -- will contain theta -180
    signal R2: std_logic_vector(8 downto 0);       -- will contain 180 - theta
    signal R3: std_logic_vector(8 downto 0);       -- will contain 360 - theta
    signal OK: std_logic;                           -- agnle check internal
    
begin
    
    Theta_ext <= '0' & Theta;
                
    --adder to perform 180 - Theta
    CLA10_2QUADRANT: carry_lookahead_add_sub_n 
                generic map(N => 9)
                port map (A => "010110100", B => Theta, Add_sub => '1', Z => R1, Carry_out => open);
                                                
    --adder to perform theta - 180
    CLA11_3QUADRANT: carry_lookahead_add_sub_n 
                generic map(N => 9)
                port map (A => Theta, B => "010110100", Add_sub => '1', Z => R2, Carry_out => open);
                
    --adder to perform 360 - theta
    CLA11_4QUADRANT: carry_lookahead_add_sub_n 
                generic map(N => 9)
                port map (A => "101101000", B => Theta, Add_sub => '1', Z => R3, Carry_out => open);
                
     -- checks if the angle is less than 90
     COMPARATOR_1QUADRANT: comparator_n
                generic map (M =>9)
                port map (X => Theta, Y => "001011010", X_greater_Y => open, X_less_Y => IS_FIRST_QUADRANT,  X_equal_Y => open);
     
     -- checks if the angle is less than 180
     COMPARATOR_2QUADRANT: comparator_n
                generic map (M =>9)
                port map (X => Theta, Y => "010110100", X_greater_Y => open, X_less_Y => IS_SECOND_QUADRANT , X_equal_Y => open);
                
     -- checks if the angle is less than 270
     COMPARATOR_3QUADRANT: comparator_n
                generic map (M =>10)
                port map (X => Theta_ext, Y => "0100001110", X_greater_Y => open, X_less_Y => IS_THIRD_QUADRANT, X_equal_Y => open);
                
     -- checks if the angle is less than 360
     COMPARATOR_ERROR: comparator_n
                generic map (M =>10)
                port map (X => Theta_ext, Y => "0101101000", X_greater_Y => ErrorFlag, X_less_Y => open, X_equal_Y => open);
                
     -- Theta prime is always less than 90, it takes the last 7 bits
     ThetaPrime <=       R3(6 downto 0) when IS_THIRD_QUADRANT  = '0' 
                    else R2(6 downto 0) when IS_SECOND_QUADRANT = '0' 
                    else R1(6 downto 0) when IS_FIRST_QUADRANT  = '0' 
                    else Theta (6 downto 0);
                    
     -- the sine is negative in 3rd & 4th quadrant
     SignFlag <=     '1' when (IS_THIRD_QUADRANT = '0' or IS_SECOND_QUADRANT = '0') 
                else '0';
     
                
end RTL;