-------------------------------------------------------------------------------
-- Project     : Metastability detect
-- Description : metastability_x.vhd
--               
--               
-- Author      : Katrin Bächli
-------------------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|-------------------------------------------------------
-- 6.10.15	| baek     | init
-------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity metastability_1 is
	port(	clk: 				in std_logic;
			rst_n: 			in std_logic;
			verification:	out std_logic; 
			zero_out:		out std_logic
	);
end entity;


----------------------------------------------------------------------------------
-- Architecture 
----------------------------------------------------------------------------------
architecture rtl of metastability_1 is 

signal   cnt: 			integer range 0 to 255 		:= 0;
signal   next_cnt: 	integer range 0 to 255 		:= 0;
signal 	glitch: 		std_logic 						:= '0';
signal 	next_zero: 	std_logic 						:= '0';
signal 	zero: 		std_logic 						:= '0';

begin

	-- clocked prozess -------------------------------
	-- stores actual system state
	ff: process(clk, glitch)	
	begin	
		if (glitch = '1') then				
				cnt <= 0;	
		elsif (rising_edge(clk)) then	
				cnt <= next_cnt;	
				zero <= next_zero;	
		end if;
	end process;
	
	-- input logic process ----------------------------
	count_up: process(cnt)	
	begin	
		next_cnt <= cnt + 1;
	end process;
	
	-- output logic process ----------------------------
	output: process(cnt)	
	begin	
			if (cnt = 158) then				
				glitch <= '1';
			else 				
				glitch <= '0';
			end if;		
	end process;
	
	-- output logic
	output2:	process(cnt)	
	begin	
			if (cnt = 0) then				
				next_zero <= '1';
			else 				
				next_zero <= '0';
			end if;		
	end process;
	
			verification <= glitch;
end rtl;
