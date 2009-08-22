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
PORT(
   Clk : IN std_logic;
   NoiseON : IN std_logic;
   FreqCount: IN std_logic_vector(16 downto 0);
   SIGOUT : OUT std_logic
   );
END COMPONENT;


signal freqout: std_logic_vector(16 downto 0);

begin

noisemaker: Noise PORT MAP(
		Clk => Clk,
		NoiseON => NoiseON,
		FreqCount => freqout,
		SIGOUT => NoiseOut
	);

process(NoiseType)
   begin
      case NoiseType is
         when "001" =>  --125000,  200hz 
            FreqOut <= "11110100001001000";
         when "010" => -- 25000,  1000hz
            FreqOUT <= "00110000110101000";
         when "011" => -- 12207,  2048hz
            FreqOUT <= "00010111110101111";
         when "100" => -- 6250,   4000hz
            FreqOUT <= "00001100001101010";
         when "101" => -- 4166,   6000hz
            FreqOUT <= "00001000001000110";
         when others =>
            FreqOUT <= "11110100001001000";
      end case;
end process;


end Behavioral;

