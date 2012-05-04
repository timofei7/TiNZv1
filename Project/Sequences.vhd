----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009
-- 
-- Create Date:    21:31:12 08/10/2009 
-- Module Name:    Sequences - Behavioral 
-- Project Name: 	 TINZ (This Is Not Zelda)
--
-- Description:    death and intro display sequences are managed here
--
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;

entity Sequences is
    Port ( Clk : in STD_LOGIC;
           row : in  STD_LOGIC_VECTOR (2 downto 0);  --row to read
           col : in  STD_LOGIC_VECTOR (2 downto 0);  --col to read
           seqReset : in  STD_LOGIC;  --reset counter
           seqDone : out STD_LOGIC;  --this sequence is done
           deathColor : out  STD_LOGIC_VECTOR (7 downto 0); 
           introColor : out  STD_LOGIC_VECTOR (7 downto 0);
           winColor   : out  STD_LOGIC_VECTOR (7 downto 0));
end Sequences;

architecture Behavioral of Sequences is

   component WinROM
      port (
      clka: IN std_logic;
      addra: IN std_logic_VECTOR(9 downto 0);
      douta: OUT std_logic_VECTOR(7 downto 0));
   end component;
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
   attribute syn_black_box of WinROM: component is true;
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
   signal wout : std_logic_vector(7 downto 0);
   
   signal CE:       std_logic := '0';                    -- slow clock enable
   signal frame : unsigned(4 downto 0) := (others => '0');
   signal framesm: unsigned(3 downto 0);
   signal seqDoneSig: std_logic:= '0';
   signal rowcol: std_logic_vector(5 downto 0):= "000000";

begin

rowcol <= row & col;
framesm <= frame(3 downto 0);

clockdivs: ClockDivider
   GENERIC MAP(Div => 24) -- the clock divider value 24 is good
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
winseq : WinROM
		port map (
			clka => Clk,
			addra => addr,
			douta => wout);

addr <= std_logic_vector(framesm) & rowcol; --create the address from the row col being asked for and the current frame;
deathColor <= dout;
introColor <= iout;
wincolor <= wout;

FrameCounter:
process(Clk)
   begin
      if rising_edge(Clk) then
         if seqReset = '1' then
            frame <= (others => '0');
         elsif CE = '1' and frame /= "10000" then --check this
            frame <= frame +1;
         else frame <= frame;
         end if;
      end if;
end process FrameCounter;
seqDoneSig <= '1' when frame = "10000" else '0'; --say when we finish a sequence
seqDone <= seqDoneSig;          
          
end Behavioral;

