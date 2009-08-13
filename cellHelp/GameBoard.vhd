----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    19:10:39 08/12/2009 
-- Design Name: 
-- Module Name:    GameBoard - Behavioral 
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

entity GameBoard is
   Port( 
        Clk : in STD_LOGIC;
        SeqReset : in  STD_LOGIC; --resets the gameboard frame back to start
        ResetPUs : in  STD_LOGIC;  --reset the powerups to initial state, on
        DisablePU : in  STD_LOGIC;  --disable the current type per the row and col address
        --the following is to wire to display
        RowA : in  STD_LOGIC_VECTOR (2 downto 0); --the row to check
        ColA : in  STD_LOGIC_VECTOR (2 downto 0); --the col to check
        Color : out  STD_LOGIC_VECTOR (7 downto 0); --color from attribute by type
        IsEnabled : out  STD_LOGIC; --is the type we are looking at enabled, yes?
        --the following is to wire to game logic
        RowB : in  STD_LOGIC_VECTOR (2 downto 0); --the row to check
        ColB : in  STD_LOGIC_VECTOR (2 downto 0); --the col to check
        CollisionData : out STD_LOGIC_VECTOR(1 downto 0) --msb=enabled? lsb=enemy or pup
    );
end GameBoard;

architecture Behavioral of GameBoard is

COMPONENT GameBoardROM --the gameboard ROM
	port (
	clka: IN std_logic;
	addra: IN std_logic_VECTOR(9 downto 0);
	douta: OUT std_logic_VECTOR(7 downto 0);
	clkb: IN std_logic;
	addrb: IN std_logic_VECTOR(9 downto 0);
	doutb: OUT std_logic_VECTOR(7 downto 0));
end component;
attribute syn_black_box : boolean;
attribute syn_black_box of GameBoardROM: component is true;

COMPONENT AttrLookup
PORT(
   Clk : IN std_logic;
   WriteAddr : IN std_logic_vector(5 downto 0);
   ReadAAddr : IN std_logic_vector(5 downto 0);
   ReadBAddr : IN std_logic_vector(5 downto 0);
   RstPU : IN std_logic;
   DisablePU : IN std_logic;          
   DataA : OUT std_logic_vector(8 downto 0);
   DataB : OUT std_logic_vector(8 downto 0)
   );
END COMPONENT;

COMPONENT ClockDivider
GENERIC (DIV : integer);
PORT(
   Clk : IN std_logic;          
   slowCE : OUT std_logic
   );
END COMPONENT;

signal addra: std_logic_VECTOR(9 downto 0); --gameboard rom read address a
signal addrb: std_logic_VECTOR(9 downto 0); --gameboard rom read address b
signal douta: std_logic_VECTOR(7 downto 0); --gameboard rom out a
signal doutb: std_logic_VECTOR(7 downto 0); --gameboard rom out b
signal writeaddr:  std_logic_vector(5 downto 0); --ident address to change type settings
signal readAaddr:  std_logic_vector(5 downto 0); --ident address to lookup Color attribute lookup to type 
signal readBaddr:  std_logic_vector(5 downto 0); --ident address to lookup Enable attribute lookup to type
signal dataa: std_logic_vector(8 downto 0); --for color/en data a
signal datab: std_logic_vector(8 downto 0); --for color/en data b
signal frameCount: unsigned(3 downto 0); --the count of the frame we are on
signal frameDirection: std_logic := '1'; -- 1 means up 0 means down, for counting direction that is
signal slowFrame: std_logic; --slow count enable for the frame counter

begin

clockdivs: ClockDivider
   GENERIC MAP(Div => 24) -- the clock divider value  DON"T FORGET TO SET THIS
   PORT MAP(Clk => Clk, slowCE => slowFrame);

board : GameBoardROM
   port map (
      clka => Clk,
      addra => addra,
      douta => douta,
      clkb => Clk,
      addrb => addrb,
      doutb => doutb
   );
   
attributes: AttrLookup PORT MAP(
   Clk => Clk,
   WriteAddr => writeaddr,
   ReadAAddr => readAaddr,
   ReadBAddr => readBaddr,
   RstPU => ResetPUs,
   DisablePU => DisablePU,
   DataA => dataa,
   DataB => datab
);

--  just hooking up various wires
addra <= std_logic_vector(frameCount) & RowA & ColA;
addrb <= std_logic_vector(frameCount) & RowB & ColB;
readAaddr <= douta(5 downto 0); --gets the type address from the main rom for color read
readBaddr <= doutb(5 downto 0); --same but for enable read
Color <= DataA(7 downto 0);
IsEnabled <= DataA(8);
CollisionData <= DataB(8) & doutb(7);  --grab the relevant collision bits the enable bit first and the enemy/pup bit second



FrameCounter: --animate the frames
process(Clk)
   begin
      if rising_edge(Clk) and slowFrame = '1' then
         if SeqReset = '1' then
            frameCount <= (others => '0');
         else
            if frameDirection = '0' then
               frameCount <= frameCount - 1;
            else
               frameCount <= frameCount + 1;
            end if;
         end if;
      end if;
end process FrameCounter;

direction:  --reverse counter direction or reset depending
process(Clk)
   begin
      if rising_edge(Clk) then
         if SeqReset = '1' then
            frameDirection <= '1';
         elsif frameCount = "1111" then
            frameDirection <= '0';
         elsif frameCount = "0000" then
            frameDirection <= '1';
         else
            frameDirection <= frameDirection;
         end if;
      end if;
end process direction;
      
      
end Behavioral;

