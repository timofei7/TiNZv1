----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    09:38:23 08/10/2009 
-- Design Name: 
-- Module Name:    MoveDecoder - Behavioral 
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

entity MoveDecoder is
    Port ( Xin : in  STD_LOGIC_VECTOR (11 downto 0);
           Yin : in  STD_LOGIC_VECTOR (11 downto 0);
           Xout : out  STD_LOGIC;
           Yout : out  STD_LOGIC;
           Clk : in  STD_LOGIC);
end MoveDecoder;

architecture Behavioral of MoveDecoder is

begin


end Behavioral;

