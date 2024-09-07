-- OK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity comparator_tb is
end comparator_tb;
 
architecture behavioral of comparator_tb is

    component comparator_n is
        generic (M : integer);
        port (
            X,Y:            in std_logic_vector(M-1 downto 0);  -- two inputs for comparison
            X_greater_Y:    out std_logic;                      -- '1' if X > Y else '0'
            X_less_Y:       out std_logic;                      -- '1' if X < Y else '0'
            X_equal_Y:      out std_logic                       -- '1' if X = Y else '0'
            );
    end component;
    
    constant Nbit : integer := 8;
    signal X_test:    std_logic_vector(Nbit-1 downto 0);
    signal Y_test:    std_logic_vector(Nbit-1 downto 0);
    signal IsGreater: std_logic;
    signal IsLess:    std_logic;
    signal IsEqual:   std_logic;
   
begin
 
  DUT : comparator_n
    generic map ( M => Nbit )
    port map (
      X   => X_test,
      Y   => Y_test,
      X_greater_Y => IsGreater,
      X_less_Y => IsLess,
      X_equal_Y => IsEqual
      );
 
   
  process is
  begin
    X_test <= "00000110";
    Y_test <= "00000111";
    wait for 20 ns;
    X_test <= "00000001";
    Y_test <= "00000001";
    wait for 20 ns;
    X_test <= "00000011";
    Y_test <= "00000001";
    wait for 20 ns;
    X_test <= "00000101";
    Y_test <= "01011000";
    wait;
  end process;
   
end behavioral;