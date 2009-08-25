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
        WIN: out STD_LOGIC;
        SeqReset : in  STD_LOGIC; --resets the gameboard frame back to start
        ResetPUs : in  STD_LOGIC;  --reset the powerups to initial state, on
        DisablePU : in  STD_LOGIC;  --disable the current type per the row and col address
        --the following is to wire to display
        ReadENColor: in STD_LOGIC; --a 1 clock cycle pulse to enable the read
        RowA : in  STD_LOGIC_VECTOR (2 downto 0); --the row to check FOR DISPLAY
        ColA : in  STD_LOGIC_VECTOR (2 downto 0); --the col to check FOR DISPLAY
        ColorOUT : out  STD_LOGIC_VECTOR (7 downto 0); --color from attribute by type
        ColorDONE: out STD_LOGIC; --signal to send when the color is done
        --the following is to wire to game logic
        RowB : in  STD_LOGIC_VECTOR (2 downto 0); --the row to check FOR GAMELOGIC
        ColB : in  STD_LOGIC_VECTOR (2 downto 0); --the col to check FOR GAMELOGIC
        Level: in  STD_LOGIC_VECTOR (1 downto 0); --pick a level!
        CollisionData : out STD_LOGIC_VECTOR(1 downto 0) := (others => '0') --msb=enabled? lsb=enemy or pup
    );
end GameBoard;

architecture Behavioral of GameBoard is

COMPONENT GameBoardROM --the gameboard ROM
	port (
	clka: IN std_logic;
	addra: IN std_logic_VECTOR(11 downto 0);
	douta: OUT std_logic_VECTOR(7 downto 0);
	clkb: IN std_logic;
	addrb: IN std_logic_VECTOR(11 downto 0);
	doutb: OUT std_logic_VECTOR(7 downto 0));
end component;
attribute syn_black_box : boolean;
attribute syn_black_box of GameBoardROM: component is true;

COMPONENT AttrLookup
PORT(
   Clk : IN std_logic;
   WriteAddr : IN std_logic_vector(3 downto 0);
   ReadColor : IN std_logic_vector(3 downto 0);
   ReadEnabled : IN std_logic_vector(3 downto 0);
   RstPU : IN std_logic;
   DisablePU : IN std_logic;          
   Color : OUT std_logic_vector(7 downto 0);
   WIN: out std_logic;
   Enabled : OUT std_logic
   );
END COMPONENT;

COMPONENT ClockDivider
GENERIC (DIV : integer);
PORT(
   Clk : IN std_logic;          
   slowCE : OUT std_logic
   );
END COMPONENT;

signal addra: std_logic_VECTOR(11 downto 0) := (others => '0'); --gameboard rom read address a
signal addrb: std_logic_VECTOR(11 downto 0) := (others => '0'); --gameboard rom read address b
signal douta: std_logic_VECTOR(7 downto 0) := (others => '0'); --gameboard rom out a
signal doutb: std_logic_VECTOR(7 downto 0) := (others => '0'); --gameboard rom out b
signal writeaddr:  std_logic_vector(3 downto 0) := (others => '0'); --ident address to change type settings --we throw out a couple bits
signal readcolor:  std_logic_vector(3 downto 0) := (others => '0'); --ident address to lookup Color attribute lookup to type 
signal readenabled:  std_logic_vector(3 downto 0) := (others => '0'); --ident address to lookup Enable attribute lookup to type
signal color: std_logic_vector(7 downto 0) := (others => '0'); --for color
signal enabled: std_logic := '0'; --for en data
signal frameCount: unsigned(3 downto 0) := (others => '0'); --the count of the frame we are on
signal frameDirection: std_logic := '1'; -- 1 means up 0 means down, for counting direction that is
signal slowFrame: std_logic := '0'; --slow count enable for the frame counter
-- do we really need all this counter stuff?
-- this is so we can send after some preset number of cycles to make sure the memory ops are all done
signal rcoloren: std_logic := '0'; --internal enable for the color done counter
signal rcolorcount: unsigned(3 downto 0) := (others => '0'); --counter for color done
signal rcolortc: std_logic := '0'; --terminal count signal for counter
constant donecount: unsigned(3 downto 0) := x"2"; --this is how many clock cycles to wait for (minus 1) so 2 really means 1 cycle

begin
      

clockdivs: ClockDivider
   GENERIC MAP(Div => 24) -- the clock divider value  DON"T FORGET TO SET THIS to something like 24!
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
   ReadColor => readcolor,
   ReadEnabled => readenabled,
   RstPU => ResetPUs,
   DisablePU => DisablePU,
   Color => color,
   WIN => WIN,
   Enabled => enabled
);

--  just hooking up various wires
addra <= Level & std_logic_vector(frameCount) & RowA & ColA; -- this is for DISPLAY
addrb <= Level & std_logic_vector(frameCount) & RowB & ColB; -- this is for GAMELOGIC
readcolor <= douta(3 downto 0); --gets the type address from the main rom for color read --we throw out a couple bits
readenabled <= doutb(3 downto 0); --same but for enable read --we throw out a couple bits
writeaddr <= readenabled; -- idiot tim poor taxonomy
colorOUT <= color;
CollisionData <= enabled & doutb(6);  --grab the relevant collision bits the enable bit first and the enemy/pup bit second


FrameCounter: --animate the frames
process(Clk)
   begin
      if rising_edge(Clk) then
         if SeqReset = '1' then
            frameCount <= (others => '0');
         elsif  slowFrame = '1' then
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
      

colorDoneProcess: --this counter sets color done after some number of clock cycles
process(Clk)
   begin
      if rising_edge(Clk) then
         if ReadENColor = '1' or rcoloren = '1' then
            if rcolortc = '1' then
               rcoloren <= '0';
               rcolorcount <= x"0";
            else 
               rcoloren <= '1';
               rcolorcount <= rcolorcount+1;
            end if;
         end if;
      end if;
end process colorDoneProcess;
rcolortc <= '1' when rcolorcount = donecount else '0'; -- terminal count for counter
ColorDone <= rcolortc;
    
      
end Behavioral;

