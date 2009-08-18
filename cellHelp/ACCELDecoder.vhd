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
           --Yin : in  STD_LOGIC;
           Clk : in  STD_LOGIC;
           --Xout : out STD_LOGIC_VECTOR (7 downto 0);
           --Yout : out STD_LOGIC_VECTOR (7 downto 0);
           T2Out : out STD_LOGIC_VECTOR (7 downto 0)
           --T1yOut : out STD_LOGIC_VECTOR (7 downto 0);
           --T1xOut : out STD_LOGIC_VECTOR (7 downto 0)
           );
end ACCELDecoder;

architecture Behavioral of ACCELDecoder is

--   component ACCELDivision
--      port (
--      clk: IN std_logic;
--      rfd: OUT std_logic;
--      dividend: IN std_logic_VECTOR(31 downto 0);
--      divisor: IN std_logic_VECTOR(7 downto 0);
--      quotient: OUT std_logic_VECTOR(31 downto 0);
--      fractional: OUT std_logic_VECTOR(7 downto 0));
--   end component;
--   -- Synplicity black box declaration
--   attribute syn_black_box : boolean;
--   attribute syn_black_box of ACCELDivision: component is true;

   
   COMPONENT AccelDetector
	PORT(
		Clk : IN std_logic;
		SigIn : IN std_logic;          
		T1out : OUT std_logic_vector(7 downto 0);
		T2out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
   
--   signal X, Y : unsigned(7 downto 0); --internal signals for output after some maths   
--   
--   signal rfd: std_logic; --do we need this?
--   signal dividend: std_logic_VECTOR(31 downto 0);
--   signal divisor: std_logic_VECTOR(7 downto 0);
--   signal quotient: std_logic_VECTOR(31 downto 0);
--   signal fractional: std_logic_VECTOR(7 downto 0); --throw this out?
   
   signal t1y,t1x,t2y,t2x: std_logic_vector(7 downto 0);
    
begin

xdetect: AccelDetector PORT MAP(
		Clk => Clk,
		SigIn => Xin,
		T1out => t1x,
		T2out => t2x
	);
   
--ydetect: AccelDetector PORT MAP(
--		Clk => Clk,
--		SigIn => Yin,
--		T1out => t1y,
--		T2out => t2y
--	);

--divs : ACCELDivision
--		port map (
--			clk => clk,
--			rfd => rfd,
--			dividend => dividend,
--			divisor => divisor,
--			quotient => quotient,
--			fractional => fractional);

T2Out <= std_logic_vector(t1x);
--T1xOut <= std_logic_vector(T1x);
--T1yOut <= std_logic_vector(T1y);

--dividend <= std_logic_vector((K * (T1x - Zactual)));
--divisor <= std_logic_vector(T2);


--Xout <= std_logic_vector(dividend);
--Yout <= std_logic_vector(divisor);



end Behavioral;

