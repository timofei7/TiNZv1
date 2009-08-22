----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    15:55:06 08/18/2009 
-- Design Name: 
-- Module Name:    ThresHysteresis - Behavioral 
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

entity ThresHysteresis is
    Port ( Clk : in  STD_LOGIC;
           SIN : in  STD_LOGIC_VECTOR (7 downto 0);
           UP : out  STD_LOGIC;
           DOWN : out  STD_LOGIC);
end ThresHysteresis;

architecture Behavioral of ThresHysteresis is

--constant upt: unsigned(7 downto 0)   := "10111111";
--constant uph: unsigned(7 downto 0)   := "10011111"; 
--constant downh: unsigned(7 downto 0) := "01111111"; 
--constant downt: unsigned(7 downto 0) := "01011111"; 

--constant upt: unsigned(7 downto 0)   := "11100110";  --THIS IS FUCKED UP!
--constant uph: unsigned(7 downto 0)   := "11011011"; 
--constant downh: unsigned(7 downto 0) := "11000111"; 
--constant downt: unsigned(7 downto 0) := "10110101"; 

constant upt: unsigned(7 downto 0)   := "10111011";  --this is in digilab with averaging
constant uph: unsigned(7 downto 0)   := "10011111";  --and pretty heavy tilt
constant downh: unsigned(7 downto 0) := "01101111"; 
constant downt: unsigned(7 downto 0) := "01001110"; 

signal sins: unsigned(7 downto 0);
signal waitReset: std_logic;
signal waitcount: unsigned(24 downto 0) := (others => '0');
constant waitcountfinal: unsigned(24 downto 0) := (others => '1');
signal waitTC : std_logic;

type state_type is (sStart, sSendUP, sSendDOWN, sWaitU, sWaitD);	-- state machine
signal curr_state, next_state: state_type;


begin

sins <= unsigned(SIN);


waitcounter:
process(Clk)
   begin
      if rising_edge(Clk) then
         if waitReset = '1' then
            waitcount <= (others => '0');
         else
            waitcount <= waitcount + 1;
         end if;
       end if;
end process;
waitTC <= '1' when waitcount = waitcountfinal else '0';


Detect:
process(curr_state, sins, waitTC)
   begin
      next_state <= curr_state;
      UP <= '0';
      DOWN <= '0';
      waitReset <= '0';
      
      case curr_state is
         when sStart =>
            if sins >= upt then
               next_state <= sSendUP;
				elsif sins <= downt then
					next_state <= sSendDOWN;
            end if;
         when sSendUP =>
            UP <= '1';
            waitReset <= '1';
            next_state <= sWaitU;
         when sSendDown =>
            DOWN <= '1';
            waitReset <= '1';
            next_state <= sWaitD;
         when sWaitD =>
				--DOWN <= '1'; --for testing
            if sins >= downh then
               next_state <= sStart;
            elsif waitTC = '1' then
               next_state <= sSendDown;
            end if;
         when sWaitU =>
				--UP <= '1';--for testing
            if sins <= uph then
               next_state <= sStart;
            elsif waitTC = '1' then
               next_state <= sSendUP;
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

