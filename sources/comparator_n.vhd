library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity comparator_n is
    generic (M : integer);
    port (
            X,Y:            in std_logic_vector(M-1 downto 0);  -- two inputs for comparison
            X_greater_Y:    out std_logic;                      -- '1' if X > Y else '0'
            X_less_Y:       out std_logic;                      -- '1' if X < Y else '0'
            X_equal_Y:      out std_logic                       -- '1' if X = Y else '0'
        );
end comparator_n;

architecture RTL of comparator_n is    

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
    
    signal Y_comp:  std_logic_vector (M-1 downto 0);
    signal Cout:    std_logic;
    signal Z_int:   std_logic_vector (M-1 downto 0);
    signal gt_or:   std_logic_vector (M-2 downto 0);
    signal eq_and:  std_logic_vector (M-1 downto 0);

    begin
    
    SUBTRACTOR: carry_lookahead_add_sub_n 
                generic map(N => M)
                port map (
                            A           =>  X, 
                            B           =>  Y,
                            Add_sub     => '1', 
                            Z           =>  Z_int, 
                            Carry_out   =>  Cout
                        );
     
    gt_or(0) <= Z_int(0);
    eq_and(0) <= not Z_int(0);

    GENERATE_OR: for I in 0 to M-3 generate
        gt_or(I+1) <= gt_or(I) or Z_int(I+1);
    end generate GENERATE_OR;
     
    GENERATE_AND: for I in 0 to M-2 generate
       eq_and(I+1) <= eq_and(I) and (not Z_int(I+1));
    end generate GENERATE_AND;
     
     -- X - Y > 0 <=> Zn-1'*(Z0+Z1+...+Zn-2)
     -- X - Y < 0 <=> Zn-1
     -- X - Y = 0 <=> (Z0'*Z1'*...*Zn-1')
     X_greater_Y <= (not Z_int(M-1)) and gt_or(M-2);
     X_less_Y <= Z_int(M-1);
     X_equal_Y <= eq_and(M-1);
 
end RTL;