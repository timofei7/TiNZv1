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

--ADJUST CLKDIVIDERS!
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Noises is
    Port ( Clk : IN  STD_LOGIC;
           --NoiseType : IN  STD_LOGIC_VECTOR (2 downto 0); --now a signal rather than port
			  soundEN : IN STD_LOGIC;		 --enables sound, sent from Controller
			  soundSelect : IN STD_LOGIC;  --chooses between sound cmd from GameLogic or Player
			  makeSoundLogic : IN STD_LOGIC_VECTOR(2 downto 0);
			  makeSoundMove : IN STD_LOGIC_VECTOR(2 downto 0);
			  TESTOUT : OUT STD_LOGIC_VECTOR(7 downto 0);
           --NoiseON: IN STD_LOGIC; --now a signal rather than port
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
signal NoiseON : std_logic := '0';
signal makeSound : std_logic_vector(2 downto 0) := "000";
signal NoiseType : std_logic_vector(2 downto 0) := "000";


--Timer signals for death siren
constant NCLKDIV_SIREN: integer := 28; 					--assuming clock freq of 50 MHz
constant MAX_SIREN_CNT: integer := 2**NCLKDIV_SIREN-1; -- max count of clock divider, 1...11

signal startSirenTimer : std_logic := '0';
signal sirenDoneTimer : unsigned(NCLKDIV_SIREN-1 downto 0) := (others=>'0');
signal sirenDone : std_logic := '0';

--Timer signals for oscillating between freq of death siren
constant NCLKDIV_OSC: integer := 24; 					--assuming clock freq of 50 MHz
constant MAX_OSC_CNT: integer := 2**NCLKDIV_OSC-1; -- max count of clock divider, 1...11
	
signal startOscillateTimer : std_logic := '0';
signal sirenOscillateTimer : unsigned(NCLKDIV_OSC-1 downto 0) := (others=>'0');
signal sirenOscillate : std_logic := '0';

--Timer signals beep times
constant NCLKDIV_BEEP: integer := 24; 					--assuming clock freq of 50 MHz
constant MAX_BEEP_CNT: integer := 2**NCLKDIV_BEEP-1; -- max count of clock divider, 1...11
	
signal startBeepTimer : std_logic := '0';
signal beepTimer : unsigned(NCLKDIV_BEEP-1 downto 0) := (others=>'0');
signal beepDone : std_logic := '0';

--Timer signals beep times
constant NCLKDIV_SHBEEP: integer := 10; 					--assuming clock freq of 50 MHz
constant MAX_SHBEEP_CNT: integer := 2**NCLKDIV_SHBEEP-1; -- max count of clock divider, 1...11
	
signal startSHBeepTimer : std_logic := '0';
signal shbeepTimer : unsigned(NCLKDIV_SHBEEP-1 downto 0) := (others=>'0');
signal shbeepDone : std_logic := '0';

--State machine states, signals
type stateType is (Quiet, GotPU, StuckandLostPU, DeathSiren1, DeathSiren2, Move);
signal currState, nextState: stateType;

signal soundsig: std_logic_vector(2 downto 0):="000";

begin

TESTOUT <= soundSelect & NoiseON & makeSoundLogic & soundsig;

noisemaker: Noise PORT MAP(
		Clk => Clk,
		NoiseON => NoiseON,
		FreqCount => freqout,
		SIGOUT => NoiseOut
	);


process(Clk)
   begin
      if rising_edge(Clk) then
         if makeSoundMove = soundsig and makeSOundMove /= "000" then
            soundsig <= soundsig;
         else
            soundsig <= makeSOundMove;
         end if;
      end if;
end process;


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


--Chooses between sound type determined by GameLogic or by Display module
chooseSound: process(soundSelect, makeSoundMove, makeSoundLogic)
begin
	if soundSelect='1' then
		makeSound <= makeSoundLogic;
	else
		makeSound <= makeSoundMove;
	end if;
end process chooseSound;


--Synchronize state transitions with rising clock edge
--Slow down state changes in FSM so we have a longer level for the noise signal
stateTransition:process(Clk)
begin
   if rising_edge(Clk) then
      if soundEN = '1' then
         currState <= nextState;
      else
         currState <= Quiet;
      end if;
   else
      currState <= currState;
   end if;
end process stateTransition;


soundFSM: process(currState, makeSound, sirenOscillate, sirenDone, beepDone, shbeepDone)
begin
	--Defaults
	NoiseON <= '0';
	NoiseType <= "000";
	startSirenTimer <= '0';
	startOscillateTimer <= '0';
   startBeepTimer <= '0';
   startSHBeepTimer <= '0';
	nextState <= Quiet;
	case currState is
		when Quiet =>
			if makeSound="001" then
				nextState <= StuckandLostPU;
			elsif makeSound="010" then
				nextState <= GotPU;
			elsif makeSound="011" then
				nextState <= DeathSiren1;
			elsif makeSound="101" then
				nextState <= Move;
			else
				nextState <= Quiet;
			end if;
		when StuckandLostPU =>
			NoiseON <= '1';
			NoiseType <= "001";
         startBeepTimer <= '1';
         if beepDone = '1' then 
            nextState <= Quiet;
         else
            nextState <= StuckandLostPU;
         end if;		
      when Move =>
			NoiseON <= '1';
			NoiseType <= "101";
         startSHBeepTimer <= '1';
         if shbeepDone = '1' then 
            nextState <= Quiet;
         elsif makeSound="001" then  --move should be interruptable by other sounds
				nextState <= StuckandLostPU;
			elsif makeSound="010" then
				nextState <= GotPU;
			elsif makeSound="011" then
				nextState <= DeathSiren1;
			else
            nextState <= Move;
         end if;
		when GotPU =>
			NoiseON <= '1';
			NoiseType <= "010";
         startBeepTimer <= '1';
         if beepDone = '1' then 
            nextState <= Quiet;
         else
            nextState <= GotPU;
         end if;
		when DeathSiren1 =>
			NoiseON <= '1';
			NoiseType <= "011";
			startSirenTimer <= '1';
			startOscillateTimer <= '1';
			if sirenOscillate='1' and sirenDone='0' then
				nextState <= DeathSiren2;
			elsif sirenOscillate='1' and sirenDone='1' then
				nextState <= Quiet;
			else
				nextState <= DeathSiren1;
			end if;
		when DeathSiren2 =>
			NoiseON <= '1';
			NoiseType <= "010";
			startSirenTimer <= '1';
			startOscillateTimer <= '1';
			if sirenOscillate='1' and sirenDone='0' then
				nextState <= DeathSiren1;
			elsif sirenOscillate='0' and sirenDone='0' then
				nextState <= DeathSiren2;
         else
            nextState <= Quiet;
			end if;
		when others =>
			nextState <= Quiet;
	end case;
end process soundFSM;


--Timer to end death siren sound
--Timer starts when state DeathSiren1 is entered
deathSirenTimer: process(Clk, startSirenTimer)
   begin 
		if startSirenTimer='1' then
			if rising_edge(Clk) then 
				sirenDoneTimer <= sirenDoneTimer+1;
			else
				sirenDoneTimer <= sirenDoneTimer;
			end if;
		else 
			sirenDoneTimer <= (others=>'0');
		end if;
end process deathSirenTimer; 
-- Clock enable pulse, once per 2^NCLKDIV_SIREN
sirenDone <= '1' when sirenDoneTimer = MAX_SIREN_CNT else '0';
				
--Timer to oscillate between frequencies used for death siren
--Timer resets when state DeathSiren1 or DeathSiren2 is entered
oscillatingSirenTimer: process(Clk, startOscillateTimer)
   begin 
		if startOscillateTimer='1' then
			if rising_edge(Clk) then 
				sirenOscillateTimer <= sirenOscillateTimer+1;
			else
				sirenOscillateTimer <= sirenOscillateTimer;
			end if;
		else 
			sirenOscillateTimer <= (others=>'0');
		end if;
end process oscillatingSirenTimer; 
-- Clock enable pulse, once per 2^NCLKDIV_OSC
sirenOscillate <= '1' when sirenOscillateTimer = MAX_OSC_CNT else '0';


--Timer to time beeps
beepTimerProcess: process(Clk, startBeepTimer)
   begin 
		if startBeepTimer='1' then
			if rising_edge(Clk) then 
				BeepTimer <= BeepTimer+1;
			else
				BeepTimer <= BeepTimer;
			end if;
		else 
			BeepTimer <= (others=>'0');
		end if;
end process beepTimerProcess; 
-- Clock enable pulse, once per 2^NCLKDIV_OSC
beepDone <= '1' when BeepTimer = MAX_BEEP_CNT else '0';

--Timer to time beeps
shbeepTimerProcess: process(Clk, startSHBeepTimer)
   begin 
		if startSHBeepTimer='1' then
			if rising_edge(Clk) then 
				shBeepTimer <= shBeepTimer+1;
			else
				shBeepTimer <= shBeepTimer;
			end if;
		else 
			shBeepTimer <= (others=>'0');
		end if;
end process shbeepTimerProcess; 
-- Clock enable pulse, once per 2^NCLKDIV_OSC
shbeepDone <= '1' when shBeepTimer = MAX_SHBEEP_CNT else '0';


end Behavioral;

