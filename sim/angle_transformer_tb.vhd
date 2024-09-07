-- OK
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
-- takes 6 ns
entity angle_transformer_tb is
end angle_transformer_tb;
 
architecture behavioral of angle_transformer_tb is
    component angle_transformer is
        port(
            Theta:      in std_logic_vector(8 downto 0);    -- input angle
            ThetaPrime: out std_logic_vector(6 downto 0);   -- output translated angle
            SignFlag:   out std_logic;                      -- sign corrisponding to the quadrant
            ErrorFlag:  out std_logic                       -- raised if the input angle is invalid (>= 360)
         ); 
    end component;
    
    signal Theta_test  : std_logic_vector(8 downto 0);
    signal ThetaPrime_test  : std_logic_vector(6 downto 0);
    signal SignOut  : std_logic;
    signal ErrorOut : std_logic;
       
begin
 
  DUT : angle_transformer
        port map ( Theta => Theta_test, ThetaPrime => ThetaPrime_test, SignFlag => SignOut, ErrorFlag => ErrorOut );
  
  process is
  begin
    
    --      correct inputs       --
    -- 5 expected is 5, 0
    Theta_test <= "000000101";
    wait for 10 ns;
    -- 10 expected is 10, 0
    Theta_test <= "000001010";
    wait for 10 ns;
    -- 13 expected is 13, 0
    Theta_test <= "000001101";
    wait for 10 ns;
    -- 80 expected is 80, 0
    Theta_test <= "001010000";
    wait for 10 ns;
    -- 107 expected is 73, 0
    Theta_test <= "001101011";
    wait for 10 ns;
    -- 185 expected 5, 1
    Theta_test <= "010111001";
    wait for 10ns;
    -- 200 expected is 20, 1
    Theta_test <= "011001000";
    wait for 10 ns;
    -- 285 expected is 75, 1
    Theta_test <= "100011101";
    wait for 10 ns;

    
    --      edge cases      --
    
     -- 90 expected is 90, 0
    Theta_test <= "001011010";
    wait for 10 ns;
     -- 180 expected is 0, 0
    Theta_test <= "010110100";
    wait for 10 ns;
     -- 270 expected is 90, 1
    Theta_test <= "100001110";
    wait for 10 ns;
     -- 359 expected is 1, 1
    Theta_test <= "101100111";
    wait for 10 ns;
    
    --      wrong inputs        --
    
    -- 360 should raise error
    Theta_test <= "101101000";
    wait for 10 ns;
    
    -- 400 should raise error
    Theta_test <= "110010000";
    wait;
  end process;
   
end behavioral;