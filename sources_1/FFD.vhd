library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity FFD is
    port ( 
            CLK:   in  std_logic; 
            RESET: in  std_logic; 
            D:     in  std_logic; 
            Q:     out std_logic
        );
end FFD;

architecture RTL of FFD is

begin
    process( CLK, RESET ) 
    begin 
        if( RESET = '1' ) then 
            Q <= '0'; 
        else 
            if( CLK'event and CLK = '1' ) then 
                Q <= D; 
            end if; 
        end if; 
    end process;
    
end RTL;
