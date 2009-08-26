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
			  soundEN : IN STD_LOGIC;		 --enables sound, sent from Controller
			  soundSelect : IN STD_LOGIC;  --chooses between sound cmd from GameLogic or Player
			  makeSoundLogic : IN STD_LOGIC_VECTOR(2 downto 0);
			  makeSoundMove : IN STD_LOGIC_VECTOR(2 downto 0);
           winSound: in std_logic;
			  TESTOUT : OUT STD_LOGIC_VECTOR(7 downto 0);
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
signal NoiseType : std_logic_vector(3 downto 0) := "0000";


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


--FOR MUSIC: 
constant d6: std_logic_vector(16 downto 0):=      "00101001100100010"; --21282 = 1174.66hz
constant g6: std_logic_vector(16 downto 0):=      "00011111001001000"; --15944 = 1567.98hz
constant d7: std_logic_vector(16 downto 0):=      "00010100110010001";-- 10641 = 2349.32hz
constant c7: std_logic_vector(16 downto 0):=      "00010111010101000";-- 11944 = 2093.00hz
constant b7: std_logic_vector(16 downto 0):=      "00011000101101110";-- 12654 = 1975.53hz
constant a7: std_logic_vector(16 downto 0):=      "00011011101111100";-- 14204 = 1760.00hz
constant fsharp7: std_logic_vector(16 downto 0):= "00010000011111110";-- 8446 = 2959.96hz
constant g7: std_logic_vector(16 downto 0):=      "00001111100100100";--7972 3135hz

--Timer signals beep times
constant NCLKDIV_EIGHTH: integer := 22; 					--assuming clock freq of 50 MHz
constant MAX_EIGHTH_CNT: integer := 2**NCLKDIV_EIGHTH-1; -- max count of clock divider, 1...11
signal enableEIGHTHNote : std_logic := '0';
signal eighthnotecounter : unsigned(NCLKDIV_EIGHTH-1 downto 0) := (others=>'0');
signal eighthnote : std_logic := '0';
signal enableQUARTERNote : std_logic := '0';
signal quarternotecounter : unsigned(3 downto 0) := (others=>'0');
signal quarternote : std_logic := '0';
signal enableHALFNote : std_logic := '0';
signal halfnotecounter : unsigned(3 downto 0) := (others=>'0');
signal halfnote : std_logic := '0';



--State machine states, signals
type stateType is (Quiet, GotPU, StuckandLostPU, DeathSiren1, DeathSiren2, Move, sw1,sw2,sw3,sw4,sw5,sw6,sw7,sw8,sw9,sw10,sw11,sw12,sw13,sw14,sw15,sw16,sw17,sw18,sw19);
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

--for testing only
process(Clk)
   begin
      if rising_edge(Clk) then
         if makeSoundMove = soundsig and makeSOundMove /= "000" then
            soundsig <= soundsig;
         else
            soundsig <= makeSound;
         end if;
      end if;
end process;


process(NoiseType)
   begin
      case NoiseType is
         when "0001" =>  --125000,  200hz 
            FreqOut <= "11110100001001000";
         when "0010" => -- 25000,  1000hz
            FreqOUT <= "00110000110101000";
         when "0011" => -- 12207,  2048hz
            FreqOUT <= "00010111110101111";
         when "0100" => -- 6250,   4000hz
            FreqOUT <= "00001100001101010";
         when "0101" => -- 4166,   6000hz
            FreqOUT <= "00001000001000110";
         when "0110" =>  --d6
            FreqOUT <= d6;
         when "0111" =>  --g6
            FreqOUT <= g6;
         when "1000" =>  --d7
            FreqOUT <= d7;
         when "1001" =>  --c7
            FreqOUT <= c7;
         when "1010" =>  --b7
            FreqOUT <= b7;
         when "1011" =>  --a7
            FreqOUT <= a7;
         when "1100" =>  --fsharp7
            FreqOUT <= fsharp7;
         when "1101" =>  --g7
            FreqOUT <= g7;
         --when "1110" =>  --
         --when "1111" =>  --
         when others =>
            FreqOUT <= "11110100001001000";
      end case;
end process;


--Chooses between sound type determined by GameLogic or by Display module
chooseSound: process(soundSelect, makeSoundMove, makeSoundLogic, winSound)
begin
	if soundSelect='1' and winSound = '0' then
		makeSound <= makeSoundLogic;
   elsif winSound = '1' then
      makeSound <= "110"; --hardcode the win sound --hack revisit
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


soundFSM: process(currState, makeSound, sirenOscillate, sirenDone, beepDone, shbeepDone, eighthnote,halfnote,quarternote)
begin
	--Defaults
	NoiseON <= '1';
	NoiseType <= "0000";
	startSirenTimer <= '0';
	startOscillateTimer <= '0';
   startBeepTimer <= '0';
   startSHBeepTimer <= '0';
	nextState <= Quiet;
   enableHALFNote <= '0';
   enableQuarterNote <='0';
   enableEIGHTHNote <= '0';
	case currState is
		when Quiet =>
         NoiseON <= '0';
			if makeSound="001" then
				nextState <= StuckandLostPU;
			elsif makeSound="010" then
				nextState <= GotPU;
			elsif makeSound="011" then
				nextState <= DeathSiren1;
			elsif makeSound="101" then
				nextState <= Move;
         elsif makeSound="110" then
            nextState <= sw1;
			else
				nextState <= Quiet;
			end if;
		when StuckandLostPU =>
			NoiseType <= "0001";
         startBeepTimer <= '1';
         if beepDone = '1' then 
            nextState <= Quiet;
         else
            nextState <= StuckandLostPU;
         end if;		
      when Move =>
			NoiseType <= "0101";
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
			NoiseType <= "0010";
         startBeepTimer <= '1';
         if beepDone = '1' then 
            nextState <= Quiet;
         else
            nextState <= GotPU;
         end if;
		when DeathSiren1 =>
			NoiseType <= "0011";
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
			NoiseType <= "0010";
			startSirenTimer <= '1';
			startOscillateTimer <= '1';
			if sirenOscillate='1' and sirenDone='0' then
				nextState <= DeathSiren1;
			elsif sirenOscillate='0' and sirenDone='0' then
				nextState <= DeathSiren2;
			end if;
      when sw1 =>
         enableEighthNote <= '1';
         NoiseType <= "0110";
         if eighthnote = '1' then
            nextState <= sw2;
         end if;
      when sw2 => 
         enableEighthNote <= '1';
         NoiseType <= "0110";
         if eighthnote = '1' then
            nextState <= sw3;
         end if;
      when sw3 => 
         enableEighthNote <= '1';
         NoiseType <= "0110";
         if eighthnote = '1' then
            nextState <= sw4;
         end if;
      when sw4 =>
         enableEighthNote <= '1';
         enableQuarterNote <= '1';
         enableHalfNote <= '1';
         NoiseType <= "0111";
         if halfnote = '1' then
            nextState <= sw5;
         end if;
      when sw5 =>
         enableEighthNote <= '1';
         enableQuarterNote <= '1';
         enableHalfNote <= '1';
         NoiseType <= "1000";
         if halfnote = '1' then
            nextState <= sw6;
         end if;
      when sw6 =>
         enableEighthNote <='1';
         NoiseType <= "1001";
         if eighthnote = '1' then
            nextState <= sw7;
         end if;
      when sw7 =>
         enableEighthNote <='1';
         NoiseType <= "1010";
         if eighthnote = '1' then
            nextState <= sw8;
         end if;
      when sw8 =>
         enableEighthNote <='1';
         NoiseType <= "1011";
         if eighthnote = '1' then
            nextState <= sw9;
         end if;
      when sw9 =>
         enableEighthNote <= '1';
         enableQuarterNote <= '1';
         enableHalfNote <= '1';
         NoiseType <= "1101";
         if halfnote = '1' then
            nextState <= sw10;
         end if;
      when sw10 =>
         enableEighthNote <= '1';
         enableQuarterNote <= '1';
         NoiseType <= "1000";
         if quarternote = '1' then
            nextState <= sw11;
         end if;
      when sw11 =>
         enableEighthNote <= '1';
         NoiseType <= "1001";
         if eighthnote = '1' then
            nextState <= sw12;
         end if;
      when sw12 =>
         enableEighthNote <= '1';
         NoiseType <= "1010";
         if eighthnote = '1' then
            nextState <= sw13;
         end if;
      when sw13 =>
         enableEighthNote <= '1';
         NoiseType <= "1011";
         if eighthnote = '1' then
            nextState <= sw14;
         end if;
      when sw14  =>
         enableEighthNote <= '1';
         enableQuarterNote <= '1';
         enableHalfNote <= '1';
         NoiseType <= "1101";
         if halfnote = '1' then
            nextState <= sw15;
         end if;
      when sw15 =>
         enableEighthNote <= '1';
         enableQuarterNote <= '1';
         NoiseType <= "1000";
         if quarternote = '1' then
            nextState <= sw16;
         end if;
      when sw16 =>
         enableEighthNote <= '1';
         NoiseType <= "1001";
         if eighthnote = '1' then
            nextState <= sw17;
         end if;
      when sw17 =>
         enableEighthNote <= '1';
         NoiseType <= "1010";
         if eighthnote = '1' then
            nextState <= sw18;
         end if;
      when sw18 =>
         enableEighthNote <= '1';
         NoiseType <= "1001";
         if eighthnote = '1' then
            nextState <= sw19;
         end if;
      when sw19 =>
         enableEighthNote <= '1';
         enableQuarterNote <= '1';
         enableHalfNote <= '1';
         NoiseType <= "1011";
         if halfnote = '1' then
            nextState <= Quiet;
         end if;
		when others =>
			nextState <= Quiet;
	end case;
end process soundFSM;


--Timer for eighth note
eighthnotetimer: process(Clk, enableEighthNote)
   begin 
		if enableEighthNote='1' then
			if rising_edge(Clk) then 
				eighthnotecounter <= eighthnotecounter+1;
			else
				eighthnotecounter <= eighthnotecounter;
			end if;
		else 
			eighthnotecounter <= (others=>'0');
		end if;
end process eighthnotetimer; 
eighthnote <= '1' when eighthnotecounter = MAX_EIGHTH_CNT else '0';

quarternotetimer: process(Clk, enableQuarterNote)
   begin
      if rising_edge(clk) then
         if enableQuarterNote = '1' then
            quarternotecounter <= quarternotecounter + 1;
         end if;
      end if;
end process;
quarternote <= '1' when quarternotecounter = "100" else '0';

halfnotetimer: process(Clk, enableHalfNote)
   begin
      if rising_edge(clk) then
         if enableHalfNote = '1' then
            halfnotecounter <= halfnotecounter + 1;
         end if;
      end if;
end process;
halfnote <= '1' when halfnotecounter = "100" else '0';




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

