-------------------------------------------------------------------------------
-- Project     : Metastability detect
-- Description : top_metastability_x.vhd
-- Author      : Katrin Bächli
-------------------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|-------------------------------------------------------
-- 6.10.15	| baek     | init

-------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

 
ENTITY top_metastability_1 IS
      PORT(    CLOCK_50: 			in std_logic;
					KEY_0: 				in std_logic;
					GPIO_0:		   	out std_logic 
		);
END top_metastability_1;


----------------------------------------------------------------------------------
-- Architecture 
----------------------------------------------------------------------------------

ARCHITECTURE blocks OF top_metastability_1 IS


		COMPONENT fsm_1
				  PORT(	clk: 			in std_logic;
							key:			in std_logic; 
							alarm:		out std_logic
					);
		END COMPONENT; 
		
	 
	 
		
	 -- Instantiation of components: 
		BEGIN
   
		inst_counter: fsm_1
		PORT MAP(		clk 				=> CLOCK_50,
							key				=> KEY_0,
							alarm 			=> GPIO_0
		);

end blocks;

