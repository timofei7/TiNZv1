----------------------------------------------------------------------------------
-- Company:    DARTMOUTH COLLEGE - ENGS31
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
    Port ( 
           Clk : in  STD_LOGIC;    
           Xin : in  STD_LOGIC;
           Yin : in  STD_LOGIC;
			  XAnalogIn : in  STD_LOGIC;
           YAnalogIn : in  STD_LOGIC;
			  XAnalogOut : out std_logic;
			  YAnalogOut : out std_logic;
			  XMinus : out  STD_LOGIC;
			  XPlus : out  STD_LOGIC;
			  YMinus : out  STD_LOGIC;
			  YPlus : out  STD_LOGIC
           );
end ACCELDecoder;

architecture Behavioral of ACCELDecoder is

   component ACCELDivision
      port (
      clk: IN std_logic;
      rfd: OUT std_logic;
      dividend: IN std_logic_VECTOR(7 downto 0);
      divisor: IN std_logic_VECTOR(7 downto 0);
      quotient: OUT std_logic_VECTOR(7 downto 0);
      fractional: OUT std_logic_VECTOR(7 downto 0));
   end component;
   -- Synplicity black box declaration
   attribute syn_black_box : boolean;
   attribute syn_black_box of ACCELDivision: component is true;
	
	COMPONENT ThresHysteresis
	PORT(
		Clk : IN std_logic;
		SIN : IN std_logic_vector(7 downto 0);          
		UP : OUT std_logic;
		DOWN : OUT std_logic
		);
	END COMPONENT;

   
   COMPONENT AccelDetector
	PORT(
		Clk : IN std_logic;
		SigIn : IN std_logic;          
		T1out : OUT std_logic_vector(7 downto 0);
		T2out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
   
   signal X: std_logic_vector(7 downto 0):= (others => '0');
   signal Y: std_logic_vector(7 downto 0):= (others => '0'); --internal signals for output after some maths   
   
   --signal rfdX: std_logic; --we don't need this
   signal dividendX: std_logic_VECTOR(7 downto 0);
   signal divisorX: std_logic_VECTOR(7 downto 0);
   --signal quotientX: std_logic_VECTOR(7 downto 0); --trash
   signal fractionalX: std_logic_VECTOR(7 downto 0); 
   
   --signal rfdY: std_logic; --we don't need this
   signal dividendY: std_logic_VECTOR(7 downto 0);
   signal divisorY: std_logic_VECTOR(7 downto 0);
   --signal quotientY: std_logic_VECTOR(7 downto 0); --trash
   signal fractionalY: std_logic_VECTOR(7 downto 0); 

   signal t1y,t1x,t2y,t2x: std_logic_vector(7 downto 0);
	
	
   
    
begin


XAnalogOut <= XAnalogIn;
YAnalogOut <= YAnalogIn;

hysX: ThresHysteresis PORT MAP(
		Clk => Clk,
		SIN => X,
		UP => xminus,
		DOWN => xplus
	);
	
hysY: ThresHysteresis PORT MAP(
		Clk => Clk,
		SIN => Y,
		UP => yminus,
		DOWN => yplus
	);

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

divsX : ACCELDivision
		port map (
			clk => clk,
			rfd => OPEN,
			dividend => dividendX,
			divisor => divisorX,
			quotient => OPEN, --throw out
			fractional => fractionalX);

divsY : ACCELDivision
		port map (
			clk => clk,
			rfd => OPEN,
			dividend => dividendY,
			divisor => divisorY,
			quotient => OPEN, --throw out
			fractional => fractionalY);


dividendX <= t1x;
divisorX <= t2x;

dividendY <= t1y;
divisorY <=t2y;

X <= fractionalX;
Y <= fractionalY;



--Xout <= X; 
--Yout <= Y;



end Behavioral;

