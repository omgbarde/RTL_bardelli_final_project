library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity multiplier_n_m is
    generic (N: integer; M: integer);
    port ( 
            A:      in std_logic_vector(N-1 downto 0);      -- first number (N bit)
            B:      in std_logic_vector(M-1 downto 0);      -- second number (M bit)
            Prod:   out std_logic_vector(M+N-1 downto 0)    -- A x B (N + M bit)
        );
end multiplier_n_m;

architecture RTL of multiplier_n_m is

    component MAC is
        port ( 
                x:      in std_logic;   -- first bit
                y:      in std_logic;   -- second bit
                pin:    in std_logic;   -- product in  
                cin:    in std_logic;   -- carry in  
                pout:   out std_logic;  -- product out
                cout:   out std_logic   -- carry out  
            );
    end component ;  
    
    -- matrix signals to connect the grid of MAC (N x M)
    type matrix is array (0 to M-1) of std_logic_vector(N-1 downto 0);
    signal CIN  : matrix;
    signal COUT : matrix;
    signal PIN  : matrix;
    signal POUT : matrix;
    
    begin
    
    -- nested loops to generate the matrix of MACs
    GENERATE_ROWS: for I in 0 to M-1 generate
        GENERATE_MAC: for J in 0 to N-1 generate
            CELL: MAC port map (
                                    x   => A(J),
                                    y   => B(I),
                                    pin => PIN(I)(J),
                                    cin => CIN(I)(J),
                                    pout => POUT(I)(J),
                                    cout => COUT(I)(J) 
                                );
        end generate;
    end generate;

    -- initialize the first row of carry in to '0'
    INIT_FIRST_ROW: for J in 0 to N-1 generate 
        PIN(0)(J) <= '0'; 
    end generate;

    CONNECT_COL_P: for I in 1 to M-1 generate
        CONNECT_ROW_P: for J in 0 to N-2 generate 
            PIN(I)(J) <= POUT(I-1)(J+1); 
        end generate;
        PIN(I)(N-1) <= COUT(I-1)(N-1);
    end generate;

    CONNECT_COL_C: for I in 0 to M-1 generate 
        CIN(I)(0) <= '0'; 
        CONNECT_ROW_P: for J in 1 to N-1 generate 
            CIN(I)(J) <= COUT(I)(J-1); 
        end generate;
    end generate;

    GENERATE_PROD: for j in 0 to M-1 generate
        Prod(J) <= POUT(J)(0);
    end generate;

    Prod(M+N-2 downto M) <= POUT(M-1)(N-1 downto 1);
    Prod(M+N-1) <= COUT(M-1)(N-1);

end RTL;