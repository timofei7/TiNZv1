----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:27:09 08/17/2009 
-- Design Name: 
-- Module Name:    MainController - Behavioral 
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

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity MainController is
    Port ( Clk : in STD_LOGIC;
			  introDone : in  STD_LOGIC;
           death : in  STD_LOGIC;
           deathDone : in  STD_LOGIC;
           seqReset : out  STD_LOGIC;
           resetDisplay : out  STD_LOGIC;
           displaySelector : out  STD_LOGIC_VECTOR(1 downto 0);
           sevenSegEN : out  STD_LOGIC;
           resetGameT : out  STD_LOGIC;
           resetPlayer : out  STD_LOGIC;
           resetPU : out  STD_LOGIC;
           displayEN : out  STD_LOGIC;
           gameLogicEN : out  STD_LOGIC;
           sevenSegSelector : out  STD_LOGIC);
end MainController;

architecture Behavioral of MainController is
	constant NCLKDIV: integer := 2; --26;					--assuming clock freq of 50 MHz
   constant MAXCLKDIV: integer := 2**NCLKDIV-1; -- max count of clock divider, 1...11
	
	signal startResetTimer : std_logic := '0';
	signal gameReset : std_logic := '0';
	signal gameResetCount : unsigned(NCLKDIV-1 downto 0) := (others=>'0');

	type stateType is (Start, IntroDisplay, Reset, Play, StartDeath, DeathDisplay, Waiting);
   signal currState, nextState: stateType;

begin

--Timer for game reset
--Timer starts FSM enters Waiting state
gameResetTimer: process(Clk, startResetTimer)
   begin 
		if startResetTimer='1' then
			if rising_edge(Clk) then 
				gameResetCount <= gameResetCount+1;
			else
				gameResetCount <= gameResetCount;
			end if;
		else 
			gameResetCount <= (others=>'0');
		end if;
end process gameResetTimer; 
-- Clock enable pulse, once per 2^NCLKDIV
gameReset <= '1' when gameResetCount = MAXCLKDIV else '0';

--Synchronize state transitions with rising clock edge
stateUpdate: process(Clk)
begin
   if rising_edge(Clk) then
      currState <= nextState;
	else
		currState <= currState;
   end if;
end process stateUpdate;


--FSM for Controller
ControllerFSM: process(currState, introDone, death, deathDone, gameReset)
begin
	--Defaults
	seqReset <= '0';
	resetDisplay <= '0';
	displaySelector <= "00";
	sevenSegEN <= '0';
	resetGameT <= '0';
	resetPlayer <= '0';
	resetPU <= '0';
	displayEN <= '0';
	gameLogicEN <= '0';
	sevenSegSelector <= '0';
	startResetTimer <= '0';
	case currState is
		when Start =>
			seqReset <= '1';
			resetDisplay <= '1';
			nextState <= IntroDisplay;
		when IntroDisplay =>
			displaySelector <= "01";
			displayEN <= '1';
			if introDone='1' then
				nextState <= Reset;
			else
				nextState <= IntroDisplay;
			end if;
		when Reset =>
			resetDisplay <= '1';
			sevenSegEN <= '1';
			resetGameT <= '1';
			resetPlayer <= '1';
			resetPU <= '1';
			seqReset <= '1';
			nextState <= Play;
		when Play =>
			sevenSegEN <= '1';
			displayEN <= '1';
			gameLogicEN <= '1';
			if death='1' then
				nextState <= StartDeath;
			else
				nextState <= Play;
			end if;
		when StartDeath =>
			seqReset <= '1';
			resetDisplay <= '1';
			nextState <= DeathDisplay;
		when DeathDisplay =>
			displaySelector <= "10";
			displayEN <= '1';
			if deathDone='1' then
				nextState <= Waiting;
			else 
				nextState <= DeathDisplay;
			end if;
		when Waiting =>
			displayEN <= '1';
			displaySelector <= "10";
			sevenSegSelector <= '1';
			startResetTimer <= '1';
			if gameReset='1' then
				nextState <= Start;
			else
				nextState <= Waiting;
			end if;
		when others =>
			nextState <= currState;
		end case;
end process ControllerFSM;


end Behavioral;

