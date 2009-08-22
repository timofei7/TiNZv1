----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    16:16:00 08/22/2009 
-- Design Name: 
-- Module Name:    Noises - Behavioral 
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


entity Noises is
    Port ( Clk : IN  STD_LOGIC;
           NoiseType : IN  STD_LOGIC_VECTOR (2 downto 0);
           NoiseON: IN STD_LOGIC;
           NoiseOut : OUT  STD_LOGIC);
end Noises;

architecture Behavioral of Noises is

COMPONENT Noise
GENERIC (countfinal : integer:= 25000);
PORT(
   Clk : IN std_logic;
   NoiseON : IN std_logic;          
   SIGOUT : OUT std_logic
   );
END COMPONENT;

signal one, two, three, four, five: std_logic;

begin

one_r: Noise 
   GENERIC MAP( countfinal => 125000) --200hz
   PORT MAP(
		Clk => Clk,
		NoiseON => NoiseON,
		SIGOUT => one
	);
two_r: Noise
   GENERIC MAP( countfinal => 25000) --1000hz
   PORT MAP(
		Clk => Clk,
		NoiseON => NoiseON,
		SIGOUT => two
	);
three_r: Noise
   GENERIC MAP( countfinal => 12207) --2048hz LOUDEST
   PORT MAP(
		Clk => Clk,
		NoiseON => NoiseON,
		SIGOUT => three
	);
four_r: Noise
   GENERIC MAP( countfinal => 6250) --4000hz
   PORT MAP(
		Clk => Clk,
		NoiseON => NoiseON,
		SIGOUT => four
	);
five_r: Noise
   GENERIC MAP( countfinal => 4166) --6000hz
   PORT MAP(
		Clk => Clk,
		NoiseON => NoiseON,
		SIGOUT => five
	);   


process(NoiseType,one, two, three, four, five)
   begin
      case NoiseType is
         when "001" =>
            NoiseOUT <= one;
         when "010" =>
            NoiseOUT <= two;
         when "011" =>
            NoiseOUT <= three;         
         when "100" =>
            NoiseOUT <= four;
         when "101" =>
            NoiseOUT <= five;
         when others =>
            NoiseOUT <= one;
      end case;
end process;


end Behavioral;

