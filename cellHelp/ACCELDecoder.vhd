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
           Xout : out STD_LOGIC_VECTOR (7 downto 0);
           Yout : out STD_LOGIC_VECTOR (7 downto 0);
           T2Out : out STD_LOGIC_VECTOR (7 downto 0);
           T1yOut : out STD_LOGIC_VECTOR (7 downto 0);
           T1xOut : out STD_LOGIC_VECTOR (7 downto 0)
           );
end ACCELDecoder;

architecture Behavioral of ACCELDecoder is

   component ACCELDivision
      port (
      clk: IN std_logic;
      rfd: OUT std_logic;
      dividend: IN std_logic_VECTOR(31 downto 0);
      divisor: IN std_logic_VECTOR(7 downto 0);
      quotient: OUT std_logic_VECTOR(7 downto 0);
      fractional: OUT std_logic_VECTOR(7 downto 0));
   end component;
   -- Synplicity black box declaration
   attribute syn_black_box : boolean;
   attribute syn_black_box of ACCELDivision: component is true;

   
   COMPONENT AccelDetector
	PORT(
		Clk : IN std_logic;
		SigIn : IN std_logic;          
		T1out : OUT std_logic_vector(7 downto 0);
		T2out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
   
   signal X: unsigned(7 downto 0):= (others => '0');
   signal Y: unsigned(7 downto 0):= (others => '0'); --internal signals for output after some maths   
   
   signal rfd: std_logic; --we don't need this
   signal dividend: std_logic_VECTOR(31 downto 0);
   signal divisor: std_logic_VECTOR(7 downto 0);
   signal quotient: std_logic_VECTOR(7 downto 0);
   signal fractional: std_logic_VECTOR(7 downto 0); 
   

   signal t1y,t1x,t2y,t2x: std_logic_vector(7 downto 0);
   
   --a little state machine for dividing
   type state_type is (sDivX,sSetX,sDivY,sSetY);	-- state machine
	signal curr_state, next_state: state_type;
   
   signal divsetxy: std_logic:='0'; --chooses which to div x/y x=0 y=1
    
begin

xdetect: AccelDetector PORT MAP(
		Clk => Clk,
		SigIn => Xin,
		T1out => t1x,
		T2out => t2x
	);
   
ydetect: AccelDetector PORT MAP(
		Clk => Clk,
		SigIn => Yin,
		T1out => t1y,
		T2out => t2y
	);

divs : ACCELDivision
		port map (
			clk => clk,
			rfd => rfd,
			dividend => dividend,
			divisor => divisor,
			quotient => quotient, --throw ou
			fractional => fractional);



T2Out <= std_logic_vector(t1x);
T1xOut <= std_logic_vector(T1x);
T1yOut <= std_logic_vector(T1y);



dividend <= t1y when divsetxy = '1' else t1x; --default to x
divisor <= t2y when divsetxy = '1' else t2x;  --do y when divsetxy


Registers:
process(Clk)
   begin
      if rising_edge(Clk) then
         if xset = '1' then
            X <= fractional;
         elsif yset = '1' then
            Y <= fractional;
         end if;
      end if;
end process Registers;


LetsDivide:
process(curr_state, rfd)
   begin
      next_state <= curr_state;
      xset <= '0';
      yset <= '0';
      divsetxy <= '0'; --x when 0 y when 1
      
      case curr_state is
         when sDivX =>
            divsetxy <= '0';
            next_state <= sSetX;
         when sSetX =>
            xset <= '1';
            next_state <= sDivY;
         when sDivY =>
            divsetxy <= '1';
            next_state <= sSetY;
         when sSetY =>
            yset <= '1';
            next_state <= sDivX;
         when others => next_state <= sDivX;
      end case;
end process LetsDivide;




StateSwitcher:
process (Clk)
begin
	if rising_edge(Clk) then
		curr_state <= next_state;
	end if;
end process StateSwitcher;

end Behavioral;

