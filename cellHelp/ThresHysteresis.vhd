----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    15:55:06 08/18/2009 
-- Design Name: 
-- Module Name:    ThresHysteresis - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
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

entity ThresHysteresis is
    Port ( Clk : in  STD_LOGIC;
           SIN : in  STD_LOGIC_VECTOR (7 downto 0);
           UP : out  STD_LOGIC;
           DOWN : out  STD_LOGIC);
end ThresHysteresis;

architecture Behavioral of ThresHysteresis is

constant: upt: unsigned(7 downto 0):= "

begin


end Behavioral;

