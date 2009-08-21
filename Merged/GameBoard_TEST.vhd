----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:37:56 08/20/2009 
-- Design Name: 
-- Module Name:    GameBoard_TEST - Behavioral 
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

entity GameBoard_TEST is
    Port ( Clk : in  STD_LOGIC;
           SeqReset: in STD_LOGIC;
           ResetPUs : in std_logic;
           DisablePU : in std_Logic;
           ReadENColor: in std_logic;
           ColorDone: out std_logic;
           ColorOUT: out  STD_LOGIC_VECTOR (7 downto 0);
           Addr : in  STD_LOGIC_VECTOR (7 downto 0));
end GameBoard_TEST;

architecture Behavioral of GameBoard_TEST is

	COMPONENT GameBoard
	PORT(
		Clk : IN std_logic;
		SeqReset : IN std_logic;
		ResetPUs : IN std_logic;
		DisablePU : IN std_logic;
		ReadENColor : IN std_logic;
		RowA : IN std_logic_vector(2 downto 0);
		ColA : IN std_logic_vector(2 downto 0);
		RowB : IN std_logic_vector(2 downto 0);
		ColB : IN std_logic_vector(2 downto 0);          
		ColorOUT : OUT std_logic_vector(7 downto 0);
		ColorDONE : OUT std_logic;
		CollisionData : OUT std_logic_vector(1 downto 0)
		);
	END COMPONENT;

signal RowA : std_logic_vector(2 downto 0);
signal ColA : std_logic_vector(2 downto 0);
signal RowB : std_logic_vector(2 downto 0);
signal ColB : std_logic_vector(2 downto 0);          
signal CollisionData : std_logic_vector(1 downto 0);

--type state_type is (sInit, sOne, sTwo, sThree, sFour, sFive, sSix);	-- state machine
--signal curr_state: state_type := sIdle;
--signal next_state: state_type;

begin

gb: GameBoard PORT MAP(
		Clk => Clk,
		SeqReset => SeqReset,
		ResetPUs => ResetPUs,
		DisablePU => DisablePU,
		ReadENColor => ReadENColor,
		RowA => RowA,
		ColA => ColA,
		ColorOUT => ColorOUT,
		ColorDONE => ColorDONE,
		RowB => RowB,
		ColB => ColB,
		CollisionData => CollisionData 
	);


ColA <= Addr(2 downto 0);
RowA <= Addr(5 downto 3);


--statemachine: --state machine to do all the work
--process(curr_state, GoDisplay, waitTC, shiftCount, slowTC, slowCount)
--   begin
--   next_state <= curr_state;
--   
--   case curr_state is
--      when sInit =>
--         
--end process statemachine;
--
--statechanger:
--process (Clk)
--begin
--	if rising_edge(Clk) then --slow us down to at most 125khz
--		curr_state <= next_state;
--	end if;
--end process statechanger;

end Behavioral;

