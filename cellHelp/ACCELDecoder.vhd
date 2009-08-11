----------------------------------------------------------------------------------
-- Company:    DARTMOUTH - ENGS31
-- Engineer:   Divya Gunasekaran and Tim Tregubov
-- 
-- Create Date:    23:08:00 08/09/2009 
-- Design Name: 
-- Module Name:    ACCELDecoder - Behavioral 
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
-- SEE the documention at: http://www.analog.com/en/sensors/inertial-sensors/adxl213/products/product.html
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity ACCELDecoder is
    Port ( Xin : in  STD_LOGIC;
           Yin : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           RATE : out  STD_LOGIC_VECTOR (8 downto 0);
           T2Out : out STD_LOGIC_VECTOR (11 downto 0);
           T1yOut : out STD_LOGIC_VECTOR (11 downto 0);
           T1xOut : out STD_LOGIC_VECTOR (11 downto 0)
           );
end ACCELDecoder;

architecture Behavioral of ACCELDecoder is
   type state_type is ( sWaitXup,sResetTimer, sWaitXdown,sWaitFirstYdown, sWaitYup,sWaitYdown,
                        sSetTs);	-- state machine
	signal curr_state, next_state: state_type;
   
   signal tb,td,tc : unsigned(11 downto 0); --recorded times
   signal tbset,tdset,tcset, tset : std_logic; --set them
   signal T1x, T1y, T2 : unsigned(11 downto 0);  -- calculations
   signal timer : unsigned(11 downto 0); --timer
   signal timerReset : std_logic;
begin

TimerCounter:
process (Clk)
   begin
   if rising_edge(Clk) then
      if timerReset = '1' then
         timer <= (others => '0');
      else
         timer <= timer + 1;
      end if;
   end if;
end process TimerCounter;


process (clk)
   begin
      if rising_edge(Clk) then
         tb <= tb;
         tc <= tc;
         td <= td;
         T1x <= T1x;
         T1y <= T1y;
         T2 <= T2;
         
         if tbset = '1' then
            tb <= timer;
         elsif tcset = '1' then
            tc <= timer;
         elsif tdset = '1' then
            td <= timer;
         elsif tset = '1' then
            T1x <= tb;
            T1y <= td - tc;
            T2 <= (td - ((td - tc)/2)) - (tb/2);
         end if;
      end if;
end process;


Decode:
process (curr_state, Xin, Yin, timer)
   begin 
   timerReset <= '0';
   next_state <= curr_state;
   tbset <= '0';
   tcset <= '0';
   tdset <= '0';
   tset <= '0';
   
   case curr_state is
      when sWaitXup =>
         if Xin = '1' then
            timerReset <= '1'; --reset timer
            next_state <= sWaitXdown;
         end if;
--      when sResetTimer =>  --this takes an extra clock but isn't necessary
--         timerReset <= '1'; --reset timer
--         next_state <= sWaitXdown;
      when sWaitXdown =>
         if Xin = '0' then --record x time
            tbset <= '1';
            next_state <= sWaitFirstYdown;
         end if;
      when sWaitFirstYdown =>
         if Yin = '0' then -- move onto the waiting for the next up
            next_state <= sWaitYup;
         end if;
      when sWaitYup =>
         if Yin = '1' then --record x2y time
            tcset <= '1';
            next_state <= sWaitYdown;
         end if;
      when sWaitYDown =>
         if Yin = '0' then --record xthroughy time
            tdset <= '1';
            next_state <= sSetTs;
         end if;
      when sSetTs =>
         Tset <= '1';
         next_state <= sWaitXup;
      when others => 
         next_state <= sWaitXup;
   end case;
end process Decode;

T2Out <= std_logic_vector(T2);
T1xOut <= std_logic_vector(T1x);
T1yOut <= std_logic_vector(T1y);

StateSwitcher:
process (Clk)
begin
	if rising_edge(Clk) then
		curr_state <= next_state;
	end if;
end process StateSwitcher;


end Behavioral;

