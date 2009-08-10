----------------------------------------------------------------------------------
-- Company:    Dartmouth College - ENGS31
-- Engineer:   Tim Tregubov
-- 
-- Create Date:    22:47:14 08/09/2009 
-- Design Name: 
-- Module Name:    PWMDecoder - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:   This Decodes the PWM signal from the accelerometer
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity PWMDecoder is
    Port ( PWM : in  STD_LOGIC;
           RATE : out  STD_LOGIC_VECTOR (8 downto 0);
           CLK : in  STD_LOGIC);
end PWMDecoder;

architecture Behavioral of PWMDecoder is

begin


end Behavioral;

