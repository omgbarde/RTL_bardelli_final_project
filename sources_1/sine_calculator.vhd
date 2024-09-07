library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity sine_calculator is
    port (
            ANGLE:  in std_logic_vector (8 downto 0);   -- input angle as a 9 bit unsigned integer
            CLK:    in std_logic;                       -- clock signal
            RST:    in std_logic;                       -- reset signal
            SINE:   out std_logic_vector(9 downto 0);   -- output calculated sine as a 10 bit fixed point float
            ERR:    out std_logic                       -- error flag (if raised any putput is to be considered invalid)
        );
end sine_calculator;

architecture RTL of sine_calculator is

    component FFD is
        port ( 
                CLK:   in  std_logic; 
                RESET: in  std_logic; 
                D:     in  std_logic; 
                Q:     out std_logic
            );
    end component;

    component PP_register_n is
        generic( N: integer ); 
        port ( 
                CLK:   in  std_logic; 
                RESET: in  std_logic; 
                X:     in  std_logic_vector(N-1 downto 0); 
                Y:     out std_logic_vector(N-1 downto 0) 
            );
    end component;

    component angle_transformer is
        port (
                Theta:      in std_logic_vector(8 downto 0);    -- input angle
                ThetaPrime: out std_logic_vector(6 downto 0);   -- output translated angle
                SignFlag:   out std_logic;                      -- sign corrisponding to the quadrant
                ErrorFlag:  out std_logic                       -- raised if the input angle is invalid (> 360)
            );
        
    end component;
    
    component multiple8 is
        port (
                x :         in  std_logic_vector(6 downto 0);   -- input number
                x_prev :    out std_logic_vector(6 downto 0);   -- previous multiple of 8
                x_next :    out std_logic_vector(6 downto 0)    -- next multiple of 8
            );
    end component;
    
    component sine_LUT is
        port (
                Angle:  in  std_logic_vector(6 downto 0);       -- input angle (0 - 90) in binary
                Sine:   out  std_logic_vector(9 downto 0)       -- sine value for that angle in fixed point notation [2 + 8]
            );
    end component;
    
    component linear_interpolator is 
        port (
                sign_flag:  in  std_logic;                      -- denotes if the calculated sine has to be complemented
                x_int:      in  std_logic_vector (6 downto 0);  -- value of x to interpolate the function at
                x_0:        in  std_logic_vector (6 downto 0);  -- nearest previous value of x
                y_0:        in  std_logic_vector (9 downto 0);  -- value of the funcction at previous point
                y_1:        in  std_logic_vector (9 downto 0);  -- value of the funcction at next point
                y_out:      out std_logic_vector (9 downto 0)   -- linearly interpolated value
            );
    end component;

    signal angle_to_transform: std_logic_vector(8 downto 0);
    signal transformed_angle: std_logic_vector(6 downto 0);
    signal previous_multiple_8: std_logic_vector(6 downto 0);
    signal next_multiple_8: std_logic_vector(6 downto 0);
    signal previous_sine: std_logic_vector(9 downto 0);
    signal next_sine: std_logic_vector(9 downto 0);
    signal calculated_sine: std_logic_vector(9 downto 0);
    signal sign_flag_internal: std_logic;
    signal error_flag_internal: std_logic;
    
begin

    ANGLE_REG: PP_register_n
                generic map (N => 9)
                port map (
                            CLK     =>  CLK, 
                            RESET   =>  RST, 
                            X       =>  ANGLE, 
                            Y       =>  angle_to_transform
                        );
                
    TRANSFORM: angle_transformer
                port map (
                            Theta       =>  angle_to_transform, 
                            ThetaPrime  =>  transformed_angle, 
                            SignFlag    =>  sign_flag_internal, 
                            ErrorFlag   =>  error_flag_internal
                         );
                
    NEIGHBORS: multiple8
                port map (
                            x       =>  transformed_angle,
                            x_prev  =>  previous_multiple_8, 
                            x_next  =>  next_multiple_8
                        );
                
    SINE_LUT_1: sine_LUT
                port map (
                            Angle   =>  previous_multiple_8, 
                            Sine    =>  previous_sine
                        );
    
    SINE_LUT_2: sine_LUT
                port map (
                            Angle => next_multiple_8,
                            Sine => next_sine
                        );
    
    APPROX: linear_interpolator
                port map (
                            sign_flag   =>  sign_flag_internal,
                            x_int       =>  transformed_angle, 
                            x_0         =>  previous_multiple_8, 
                            y_0         =>  previous_sine, 
                            y_1         =>  next_sine, 
                            y_out       =>  calculated_sine
                         );
                         
    SINE_REG: PP_register_n
                generic map (N => 10)
                port map (
                            CLK     =>  CLK, 
                            RESET   =>  RST, 
                            X       =>  calculated_sine, 
                            Y       =>  SINE
                        );
                
    ERR_FF: FFD
                port map (
                            CLK => CLK, 
                            RESET => RST, 
                            D => error_flag_internal, 
                            Q => ERR
                         );
                
end RTL;