library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity linear_interpolator is 
    port (
            sign_flag:  in  std_logic;                      -- denotes if the calculated sine has to be complemented
            x_int:      in  std_logic_vector (6 downto 0);  -- value of x to interpolate the function at
            x_0:        in  std_logic_vector (6 downto 0);  -- nearest previous value of x
            y_0:        in  std_logic_vector (9 downto 0);  -- value of the funcction at previous point
            y_1:        in  std_logic_vector (9 downto 0);  -- value of the funcction at next point
            y_out:      out std_logic_vector (9 downto 0)   -- linearly interpolated value
        );
end linear_interpolator;

architecture structural of linear_interpolator is

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
    
    component complement_2 is
        generic(N : integer);
        port (
                X:      in std_logic_vector(N-1 downto 0);      -- input number
                X_comp: out std_logic_vector(N-1 downto 0)      -- two's complement
            );
    end component;
    
    component multiplier_n_m is
        generic (N: integer; M: integer);
        port ( 
                A:      in std_logic_vector(N-1 downto 0);      -- first number (N bit)
                B:      in std_logic_vector(M-1 downto 0);      -- second number (M bit)
                Prod:   out std_logic_vector(M+N-1 downto 0)    -- A x B (N + M bit)
            );
    end component;
    
    signal Dx: std_logic_vector(6 downto 0);
    signal Dx_min: std_logic_vector(2 downto 0);
    signal Dy: std_logic_vector(9 downto 0);
    signal Product_int: std_logic_vector(12 downto 0);
    signal temp1: std_logic_vector (12 downto 0);
    signal temp2: std_logic_vector (9 downto 0);
    signal temp3: std_logic_vector (9 downto 0);
    signal sine:  std_logic_vector (9 downto 0);
    signal sine_comp: std_logic_vector (9 downto 0);

begin
                        
        -- Dx = x - x_0
        X_SUB: carry_lookahead_add_sub_n
                generic map(N => 7)
                port map (
                            A           =>  x_int, 
                            B           =>  x_0,
                            Add_sub     => '1', 
                            Z           =>  Dx, 
                            Carry_out   =>  open
                        );
                
        -- Dx is always <= 7 so it fits in 3 bits
        Dx_min <= dx (2 downto 0);
                        
        -- Dy = y_1 - y_0
        Y_SUB: carry_lookahead_add_sub_n
                generic map ( N => 10)
                port map (
                            A           =>  y_1, 
                            B           =>  y_0, 
                            Add_sub     =>  '1',
                            Z           =>  Dy, 
                            Carry_out   =>  open
                        );
                
        -- multiply Dx * Dy 
        MULT: multiplier_n_m
                generic map(N => 3, M => 10)
                port map (
                            a       =>  Dx_min, 
                            b       =>  Dy, 
                            prod    =>  Product_int
                        );
       
        -- divide by 8 (shift right logical by 3)
        temp1 <= "000" & Product_int(12 downto 3);
       
        --truncate
        temp2 <= temp1(9 downto 0);
       
        -- perform y0 + (Dx*dy)/8         
        ADDER: carry_lookahead_add_sub_n
                generic map ( N => 10)
                port map (
                            A           =>  y_0, 
                            B           =>  temp2,
                            Add_sub     =>  '0',
                            Z           =>  sine,
                            Carry_out   =>  open
                        );
                
        -- calculate twos complement
        COMPLEMENT_SINE: complement_2
                        generic map (N => 10)
                        port map (
                                    X       =>  sine, 
                                    X_comp  =>  sine_comp
                                );
                
       y_out <= sine when sign_flag = '0'
           else sine_comp;
       
end structural;
