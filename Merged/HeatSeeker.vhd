----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    18:48:03 08/25/2009 
-- Design Name: 
-- Module Name:    HeatSeeker - Behavioral 
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
use IEEE.NUMERIC_STD.ALL;


entity HeatSeeker is
    Port ( Clk : in STD_LOGIC;
			  reset : in STD_LOGIC;
			  playerX : in  STD_LOGIC_VECTOR (2 downto 0);
           playerY : in  STD_LOGIC_VECTOR (2 downto 0);
           initHeatSeeker : in  STD_LOGIC;
           heatSeekerColor : out  STD_LOGIC_VECTOR(7 downto 0);
           activeSeeker : out  STD_LOGIC;
           heatSeekerXOut : out  STD_LOGIC_VECTOR (2 downto 0);
           heatSeekerYOut : out  STD_LOGIC_VECTOR (2 downto 0);
           seekerHit : out  STD_LOGIC);
end HeatSeeker;

architecture Behavioral of HeatSeeker is

COMPONENT positionCounter
	PORT(
		UP : IN std_logic;
		DOWN : IN std_logic;
		rst : IN std_logic;
		Clk : IN std_logic; 
		initValue: IN STD_LOGIC_VECTOR(2 downto 0);
		set : IN STD_LOGIC;		
		count : OUT std_logic_vector(2 downto 0);
		makeSoundMove : OUT std_logic_vector(2 downto 0)
		);
	END COMPONENT;


COMPONENT ClockDivider
GENERIC (DIV : integer);
	PORT(
		Clk : IN std_logic;          
		slowCE : OUT std_logic
		);
	END COMPONENT;


signal heatSeekerXSig : std_logic_vector(2 downto 0) := "000";
signal heatSeekerYSig : std_logic_vector(2 downto 0) := "000";

--signal playerStartX : std_logic_vector := "000";
--signal playerStartY : std_logic_vector := "000";

constant NCLKDIV_INIT : integer := 18;
constant MAX_INIT_CNT : integer := 2**NCLKDIV_INIT-1;

signal startInitTimer : std_logic := '0';
signal initTimer : unsigned(NCLKDIV_INIT-1 downto 0) := (others=>'0');
signal initDone : std_logic := '0';

signal seekerHitSig : std_logic := '0';
signal countVamp : unsigned(1 downto 0) := "00";

signal activeSeekerSig : std_logic := '0';

--Signals for heatseeker to move up/down
signal upX : std_logic := '0';
signal upY : std_logic := '0';
signal downX : std_logic := '0';
signal downY : std_logic := '0';

--When player location equals heatseeker location
signal equalX : std_logic := '0';
signal equalY : std_logic := '0';

signal moveEN : std_logic := '0';

type stateType is (Start, Init, Waiting, Seek);
   signal currState, nextState: stateType;


begin

activeSeeker <= activeSeekerSig;
heatSeekerColor <= "11100011";
seekerHitSig <= equalX and equalY;
heatSeekerXOut <= heatSeekerXSig;
heatSeekerYOut <= heatSeekerYSig;

heatSeekerLocX: positionCounter PORT MAP(
		UP => upX,
		DOWN => downX,
		rst => reset,
		set => initHeatSeeker,
		initValue => playerX,
		Clk => Clk,
		count => heatSeekerXSig,
		makeSoundMove => OPEN
	);
	
heatSeekerLocY: positionCounter PORT MAP(
		UP => upY,
		DOWN => downY,
		rst => reset,
		set => initHeatSeeker,
		initValue => playerY,
		Clk => Clk,
		count => heatSeekerYSig,
		makeSoundMove => OPEN
	);

moveEnabler: ClockDivider 
GENERIC MAP(Div => 28)
PORT MAP(
		Clk => Clk,
		slowCE => moveEN
	);


--this is a monopulser for this signal
process(Clk)
begin
   if rising_edge(Clk) then
      if seekerHitSig = '0' then
         countvamp <= "00";
      elsif countvamp /= "10" then
         countvamp <= countvamp +1;
      end if;
   end if;
end process;
seekerHit <= '1' when countvamp = "01" else '0';


--Synchronize state transitions with rising clock edge
stateTransition: process(Clk)
begin
   if rising_edge(Clk) then
		if reset='1' then
			currState <= Start;
		else
			currState <= nextState;
		end if;
	else
		currState <= currState;
	end if;
end process stateTransition;


SeekerActivation: process(initHeatSeeker, currState, playerX, playerY, initDone, heatSeekerXSig, heatSeekerYSig)
begin
	--Defaults
	activeSeekerSig <= '0';
	nextState <= currState;
	startInitTimer <= '0';
	case currState is
		when Start =>
			if initHeatSeeker = '1' then
				nextState <= Init;
			else
				nextState <= Start;
			end if;
		when Init =>
			startInitTimer <= '1';
			if initDone='1' then
				nextState <= Seek;
			else
				nextState <= Init;
			end if;
		when Seek =>
			activeSeekerSig <= '1';
			nextState <= Seek;
		when others =>
			nextState <= currState;
	end case;
end process SeekerActivation;


--Timer to delay activation of heatseekers
initTimerProcess: process(Clk, startInitTimer)
   begin 
		if startInitTimer='1' then
			if rising_edge(Clk) then 
				initTimer <= initTimer+1;
			else
				initTimer <= initTimer;
			end if;
		else 
			initTimer <= (others=>'0');
		end if;
end process initTimerProcess; 
-- Clock enable pulse, once per 2^NCLKDIV_INIT
initDone <= '1' when initTimer = MAX_INIT_CNT else '0';



SeekerMoveX : process(Clk, moveEN, playerX, heatSeekerXSig)
begin
	if rising_edge(Clk) then
		if moveEN='1' and activeSeekerSig='1' then
			if (playerX > heatSeekerXSig) then
				upX <= '1';
				downX <= '0';
			elsif (playerX < heatSeekerXSig) then
				downX <= '1';
				upX <= '0';
			else
				upX <= '0';
				downX <= '0';
			end if;
		else
			upX <= '0';
			downX <= '0';
		end if;
	end if;
end process SeekerMoveX;
equalX <= '1' when (playerX=heatSeekerXSig) else '0';


SeekerMoveY : process(Clk, moveEN, playerY, heatSeekerYSig)
begin
	if rising_edge(Clk) then
		if moveEN='1' and activeSeekerSig='1' then
			if (playerY > heatSeekerYSig) then
				upY <= '1';
				downY <= '0';
			elsif (playerY < heatSeekerYSig) then
				downY <= '1';
				upY <= '0';
			else
				upY <= '0';
				downY <= '0';
			end if;
		else
			upY <= '0';
			downY <= '0';
		end if;
	end if;
end process SeekerMoveY;
equalY <= '1' when (playerY=heatSeekerYSig) else '0';



end Behavioral;

