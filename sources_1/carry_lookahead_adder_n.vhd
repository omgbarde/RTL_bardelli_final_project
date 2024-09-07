library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity carry_lookahead_add_sub_n is
    generic (N : integer);
    port (
            A:          in std_logic_vector(N-1 downto 0);  -- first operator
            B:          in std_logic_vector(N-1 downto 0);  -- second operator
            Add_sub:    in std_logic;                       -- 0 -> add, 1 -> sub
            Z:          out std_logic_vector(N-1 downto 0); -- output
            Carry_out:  out std_logic                       -- carry out
        );
end carry_lookahead_add_sub_n;
 
architecture RTL of carry_lookahead_add_sub_n is
 
    component FA is
        port (
                  X:    in std_logic;     -- first bit
                  Y:    in std_logic;     -- second bit
                  Cin:  in std_logic;     -- carry in
                  S:    out std_logic;    -- arythmetic sum
                  Cout: out std_logic     -- carry out
            );
    end component;
             
    signal xor_B:   std_logic_vector(N-1 downto 0);     -- signal to contain B xor Add_sub
    signal G:       std_logic_vector(N-1 downto 0);     -- Generate
    signal P:       std_logic_vector(N-1 downto 0);     -- Propagate
    signal C:       std_logic_vector(N downto 0);       -- Carry 
    signal RES:     std_logic_vector(N-1 downto 0);     -- Result
 
begin
    C(0) <= Add_sub;
    
    GENERATE_XOR :  for I in 0 to N-1 generate
        xor_B(I) <= B(I) xor Add_sub;
    end generate GENERATE_XOR;
    
    -- Create the Full Adders
    GENERATE_ADDER : for I in 0 to N-1 generate
        U: FA port map (
                        X       =>  A(I),
                        Y       =>  xor_B(I),
                        Cin     =>  C(I),        
                        S       =>  RES(I),
                        Cout    =>  open 
                    );
     end generate GENERATE_ADDER;
     
     -- Generate Terms:  Gi=Ai*Bi
     -- Propagate Terms: Pi=Ai+Bi
     -- Carry Terms: Ci+1=Gi+(Pi*Ci)
     GENERATE_CLA : for J in 0 to N-1 generate
        G(J)   <= A(J) and xor_B(J);
        P(J)   <= A(J) or xor_B(J);
        C(J+1) <= G(J) or (P(J) and C(J));
     end generate GENERATE_CLA;
         
     Z <= RES;
     Carry_out <= C(N);
     
end RTL;