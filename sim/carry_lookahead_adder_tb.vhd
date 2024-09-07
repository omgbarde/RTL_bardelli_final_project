-- OK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity carry_lookahead_add_sub_tb is
end carry_lookahead_add_sub_tb;
 
architecture behavioral of carry_lookahead_add_sub_tb is

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
    
  constant Nbit : integer := 8;
   
  signal Atest:     std_logic_vector(Nbit-1 downto 0);
  signal Btest:     std_logic_vector(Nbit-1 downto 0);
  signal sub:       std_logic;
  signal RESULT:    std_logic_vector(Nbit-1 downto 0);
  signal overflow:  std_logic;

   
begin
 
  DUT : carry_lookahead_add_sub_n
    generic map ( N => Nbit )
    port map (
      A   => Atest,
      B   => Btest,
      Add_sub => sub,
      Z => RESULT,
      Carry_out => overflow
      );
 
   
  process is
  begin
    sub <= '0';
    Atest <= "00000000";
    Btest <= "00000001";
    wait for 10 ns;
    Atest <= "00000100";
    Btest <= "00000010";
    wait for 10 ns;
    Atest <= "00000010";
    Btest <= "00000110";
    wait for 10 ns;
    Atest <= "00000111";
    Btest <= "00000111";
    wait for 10 ns;
    Atest <= "00000000";
    Btest <= "00000001";
    wait for 10 ns;
    Atest <= "00000100";
    Btest <= "00000010";
    wait for 10 ns;
    Atest <= "00000010";
    Btest <= "00000110";
    wait for 10 ns;
    Atest <= "00000111";
    Btest <= "00000111";
    wait for 10 ns;
    Atest <= "00000101";
    Btest <= "10101000";
    
    wait for 10 ns;
    sub <= '1';
    
    Atest <= "00000000";
    Btest <= "00000001";
    wait for 10 ns;
    Atest <= "00000100";
    Btest <= "00000010";
    wait for 10 ns;
    Atest <= "00000010";
    Btest <= "00000110";
    wait for 10 ns;
    Atest <= "00000111";
    Btest <= "00000111";
    wait for 10 ns;
    Atest <= "00000000";
    Btest <= "00000001";
    wait for 10 ns;
    Atest <= "00000100";
    Btest <= "00000010";
    wait for 10 ns;
    Atest <= "00000010";
    Btest <= "00000110";
    wait for 10 ns;
    Atest <= "00000111";
    Btest <= "00000111";
    wait for 10 ns;
    Atest <= "00000101";
    Btest <= "10101000";
    wait;
  end process;
   
end behavioral;