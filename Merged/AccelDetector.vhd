----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    00:39:52 08/18/2009 
-- Design Name: 
-- Module Name:    AccelDetector - Behavioral 
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

entity AccelDetector is
    Port ( Clk : in  STD_LOGIC;
           SigIn : in  STD_LOGIC;
           T1out : out  STD_LOGIC_VECTOR (7 downto 0);
           T2out : out  STD_LOGIC_VECTOR (7 downto 0));
end AccelDetector;

architecture Behavioral of AccelDetector is

   type state_type is (sStart,sReset, sUP,sDOWN);	-- state machine
	signal curr_state, next_state: state_type;
   
   signal count: unsigned(7 downto 0) := (others => '0');
   signal countReset: std_logic:='0';
   signal slowCE: std_logic;
   
   signal t1, t2: std_logic_vector(7 downto 0) := (others => '0');
   signal t1set, t2set: std_logic := '0';
   
   COMPONENT ClockDivider
   GENERIC (DIV : integer);
   PORT(
      Clk : IN std_logic;          
      slowCE : OUT std_logic
      );
   END COMPONENT;
   
   
begin

clockdivs: ClockDivider
   GENERIC MAP(Div => 12) -- the clock divider value CHECK THIS VALUE FIRST
   PORT MAP(Clk => Clk, slowCE => slowCE);
   

TimerCounter:  --count slowly we need to accomodate 5-15ms T2 times
process (Clk)
   begin
   if rising_edge(Clk) then
      if countReset = '1' then
         count <= (others => '0');
      elsif slowCE = '1' then
         count <= count + 1;
      end if;
   end if;
end process TimerCounter;


t1out <= t1;
t2out <= t2;

Registers:
process(Clk)
   begin
      if rising_edge(Clk) then
         if t1set = '1' then
            t1 <= std_logic_vector(count);
         elsif t2set = '1' then
            t2 <= std_logic_vector(count);
         end if;
      end if;
end process Registers;


Detect:
process(curr_state, SigIn, count)
   begin
      next_state <= curr_state;
      t1set <= '0';
      t2set <= '0';
      countReset <= '0';
      
      case curr_state is
         when sStart => --pick up first count, could be replaced by last state
            if SigIn = '1' then
               next_state <= sReset;
             end if;
         when sReset =>  --reset counter
            countReset <= '1';
            next_state <= sUP;
         when sUP =>  --measure while sigin is up
            if SigIn = '0' then
               t1set <= '1';
               next_state <= sDown;
            end if;
         when sDown =>  --measure sigin while down
            if SigIn = '1' then
               t2set <= '1';
               next_state <= sReset;
            end if;
         when others => next_state <= sStart;
      end case;
end process Detect;
            
            


StateSwitcher:
process (Clk)
begin
	if rising_edge(Clk) then
		curr_state <= next_state;
	end if;
end process StateSwitcher;


end Behavioral;

