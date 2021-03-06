----------------------------------------------------------------------------------
-- DARTMOUTH COLLEGE - ENGS31
-- Divya Gunasekaran and Tim Tregubov
-- Final Project
-- September 1, 2009
-- 
-- Create Date:    23:08:00 08/09/2009 
-- Design Name: 
-- Module Name:    ACCELDecoder - Behavioral
-- Project Name: 	 TINZ (This Is Not Zelda)
-- 
-- Description:    all acclerometer action happens here + switching of axis based on level
-- Additional Comments: 
-- SEE the documention at: http://www.analog.com/en/sensors/inertial-sensors/adxl213/products/product.html
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;


entity ACCELDecoder is
    Port ( 
           Clk : in  STD_LOGIC; 
           SpeedRate: in std_logic_vector(1 downto 0);   --the repeat rate desired
           LevelDifficulty: in std_logic_vector(1 downto 0); --the level difficulty for axis flipping
           Xin : in  STD_LOGIC; --from accelerometr
           Yin : in  STD_LOGIC; --''
			  XAnalogIn : in  STD_LOGIC;  --bogus from/to accelerometr
           YAnalogIn : in  STD_LOGIC; --''
			  XAnalogOut : out std_logic; --''
			  YAnalogOut : out std_logic; --''
			  XMinus : out  STD_LOGIC; --we have a move in X -
			  XPlus : out  STD_LOGIC;  --we have a move in x +
			  YMinus : out  STD_LOGIC;  -- in y -
			  YPlus : out  STD_LOGIC -- in y +
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
      SpeedRate: IN std_logic_vector(1 downto 0);
		UP : OUT std_logic;
		DOWN : OUT std_logic
		);
	END COMPONENT;

   
   COMPONENT AccelDetector
	PORT(
		Clk : IN std_logic;
		SigIn : IN std_logic; 
      Done: OUT std_logic;
		T1out : OUT std_logic_vector(7 downto 0);
		T2out : OUT std_logic_vector(7 downto 0)
		);
	END COMPONENT;
   
   COMPONENT AccelFilter
	PORT(
		Clk : IN std_logic;
		CE : IN std_logic;
		SIGIN : IN std_logic_vector(7 downto 0);          
		SIGOUT : OUT std_logic_vector(7 downto 0)
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
	
	signal doneX: std_logic:= '0';
   signal doneY: std_logic:= '0';
   
   signal xMinusSwap: std_logic;
   signal yMinusSwap: std_logic;
   signal xPlusSwap: std_logic;
   signal yPlusSwap: std_logic;
    
begin

--randomize haha the directions of the accelerometer
process(xminusswap, yminusswap, xplusswap, yplusswap, LevelDifficulty)
   begin
      case LevelDifficulty is
         when "00" =>  --normal
            xminus <= xminusswap;
            yminus <= yminusswap;
            xplus <= xplusswap;
            yplus <= yplusswap;
         when "01" =>  --flips directions
            xminus <= xplusswap;
            yminus <= yplusswap;
            xplus <= xminusswap;
            yplus <= yminusswap;
        when "10" =>  --swaps x and y
            xminus <= yminusswap; 
            yminus <= xminusswap;
            xplus <= yplusswap;
            yplus <= xplusswap;
         when "11" => --flips and swaps
            xminus <= yplusswap;
            yminus <= xplusswap;
            xplus <= yminusswap;
            yplus <= xminusswap;
         when others => 
            xminus <= xminusswap;
            yminus <= yminusswap;
            xplus <= xplusswap;
            yplus <= yplusswap;
      end case;
end process;
                                    

xFilt: AccelFilter PORT MAP(
		Clk => Clk,
		CE => doneX,
		SIGIN => fractionalX,
		SIGOUT => X
	);
yFilt: AccelFilter PORT MAP(
		Clk => Clk,
		CE => doneY,
		SIGIN => fractionalY,
		SIGOUT => Y
	);



XAnalogOut <= XAnalogIn;
YAnalogOut <= YAnalogIn;

hysX: ThresHysteresis PORT MAP(
		Clk => Clk,
		SIN => Y, --swap with X, Y gives correct direction
      SpeedRate => SpeedRate,
		UP => xminusswap,
		DOWN => xplusswap
	);
	
hysY: ThresHysteresis PORT MAP(
		Clk => Clk,
		SIN => X, --swap with Y, X gives correct direction
      SpeedRate => SpeedRate,
		UP => yminusswap,
		DOWN => yplusswap
	);

xdetect: AccelDetector PORT MAP(
		Clk => Clk,
		SigIn => Xin,
      Done => doneX,
		T1out => t1x,
		T2out => t2x
	);
   
ydetect: AccelDetector PORT MAP(
		Clk => Clk,
		SigIn => Yin,
      Done => doneY,
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



end Behavioral;

