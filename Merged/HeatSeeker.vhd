----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009

-- Create Date:    18:48:03 08/25/2009 
-- Module Name:    HeatSeeker - Behavioral 
-- Project Name: 	 TINZ (This Is Not Zelda)

-- Description: This module converts disabled power-ups into "heatseeking ghosts"
-- that follow the player on the board and can kill the player. There can only be
-- one active heatseeker on the board at any given time. This module includes 
-- instantiations of positionCounter and clockDivider to keep track of the 
-- heatseeker's location and regular the speed of the heatseeker's movement,
-- respectively. 

----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity HeatSeeker is
    Port ( Clk : in STD_LOGIC;
			  reset : in STD_LOGIC;	--from MainController
			  playerX : in  STD_LOGIC_VECTOR (2 downto 0);	--from Player
           playerY : in  STD_LOGIC_VECTOR (2 downto 0);	--from Player
           initHeatSeeker : in  STD_LOGIC;					--from GameLogicFSM
           heatSeekerColor : out  STD_LOGIC_VECTOR(7 downto 0);	--to Display
           activeSeeker : out  STD_LOGIC;									--to GameLogicFSM
           heatSeekerXOut : out  STD_LOGIC_VECTOR (2 downto 0);	--to Display
           heatSeekerYOut : out  STD_LOGIC_VECTOR (2 downto 0);	--to Display
           seekerHit : out  STD_LOGIC);									--to GameLogic FSM
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

--Heatseeker location
signal heatSeekerXSig : std_logic_vector(2 downto 0) := "000";
signal heatSeekerYSig : std_logic_vector(2 downto 0) := "000";

--Constants and signals to regulate speed of heatseeker's activation and movement
constant NCLKDIV_INIT : integer := 18;
constant MAX_INIT_CNT : integer := 2**NCLKDIV_INIT-1;

signal startInitTimer : std_logic := '0';
signal initTimer : unsigned(NCLKDIV_INIT-1 downto 0) := (others=>'0');
signal initDone : std_logic := '0';

--Heatseeker hit
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

--Signals for finite state machine
type stateType is (Start, Init, Waiting, Seek);
   signal currState, nextState: stateType;

begin

activeSeeker <= activeSeekerSig;
heatSeekerColor <= "11100011";	--hardcoded color
seekerHitSig <= equalX and equalY;	--heatseeker hit player when locations are equivalent
heatSeekerXOut <= heatSeekerXSig;
heatSeekerYOut <= heatSeekerYSig;

--Heatseekers location on x-axis
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
	
--Heatseeker's location on y-axis
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

--Regulate speed of heatseeker
moveEnabler: ClockDivider 
GENERIC MAP(Div => 28)
PORT MAP(
		Clk => Clk,
		slowCE => moveEN
	);


--this is a monopulser for the seekerHit signal
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
		--Initialize heatseeker
		when Init =>
			startInitTimer <= '1';	--delay activation of heatseeker for player's sake
			if initDone='1' then
				nextState <= Seek;
			else
				nextState <= Init;
			end if;
		--Let heatseeker follow player on board
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


--Directs movement of heatseeker on x-axis
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

--Directs movement of heatseeker on y-axis
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

