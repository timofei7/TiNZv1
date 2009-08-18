----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    21:31:12 08/10/2009 
-- Design Name: 
-- Module Name:    Sequences - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description:    death and intro display sequences are managed here
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

entity Sequences is
    Port ( Clk : in STD_LOGIC;
           rowcol : in  STD_LOGIC_VECTOR (5 downto 0);
           seqReset : in  STD_LOGIC;
           seqDone : out STD_LOGIC;
           deathColor : out  STD_LOGIC_VECTOR (7 downto 0);
           introColor : out  STD_LOGIC_VECTOR (7 downto 0));
end Sequences;

architecture Behavioral of Sequences is

   component DeathROM
      port (
      clka: IN std_logic;
      addra: IN std_logic_VECTOR(9 downto 0);
      douta: OUT std_logic_VECTOR(7 downto 0));
   end component;
   component IntroROM
      port (
      clka: IN std_logic;
      addra: IN std_logic_VECTOR(9 downto 0);
      douta: OUT std_logic_VECTOR(7 downto 0));
   end component;
   attribute syn_black_box : boolean;
   attribute syn_black_box of DeathROM: component is true;
   attribute syn_black_box of IntroROM: component is true;

	COMPONENT ClockDivider
   GENERIC (DIV : integer);
	PORT(
		Clk : IN std_logic;          
		slowCE : OUT std_logic
		);
	END COMPONENT;

   signal addr : std_logic_vector(9 downto 0);
   signal dout : std_logic_vector(7 downto 0);
   signal iout : std_logic_vector(7 downto 0);
   
   signal CE:       std_logic := '0';                    -- slow clock enable
   signal frame : unsigned(3 downto 0) := (others => '0');

begin

clockdivs: ClockDivider
   GENERIC MAP(Div => 2) -- the clock divider value DON"T FORGET TO SET THIS!
   PORT MAP(Clk => Clk, slowCE => CE);
deathseq : DeathROM
		port map (
			clka => Clk,
			addra => addr,
			douta => dout);
introseq : IntroROM
		port map (
			clka => Clk,
			addra => addr,
			douta => iout);

addr <= std_logic_vector(frame) & rowcol; --create the address from the row col being asked for and the current frame;
deathColor <= dout;
introColor <= iout;

FrameCounter:
process(Clk)
   begin
      if rising_edge(Clk) then
         if seqReset = '1' then
            frame <= (others => '0');
         elsif CE = '1' and seqDone = '0' then --check this
            frame <= frame +1;
         else frame <= frame;
         end if;
      end if;
end process FrameCounter;
seqDone <= '1' when frame = "1111" else '0'; --say when we finish a sequence
              
end Behavioral;

