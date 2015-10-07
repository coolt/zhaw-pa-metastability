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
      PORT(    CLOCK_50: 			IN std_logic;
					KEY_0: 				IN std_logic;
					GPIO_0:		   OUT std_logic;  
					GPIO_1:		   OUT std_logic  
		);
END top_metastability_1;


----------------------------------------------------------------------------------
-- Architecture 
----------------------------------------------------------------------------------

ARCHITECTURE blocks OF top_metastability_1 IS


		COMPONENT metastability_1
				  PORT(	clk: 				IN std_logic;
							rst_n: 			IN std_logic;
							verification:	OUT std_logic; 
							zero_out:		OUT std_logic
					);
		END COMPONENT; 
		
				
    -- Signals: 
	 
	 
		
	 -- Instantiation of components: 
		BEGIN
   
		inst_counter: metastability_1
		PORT MAP(		clk 				=> CLOCK_50,
							rst_n 			=> KEY_0,
							verification	=> GPIO_0,
							zero_out 		=> GPIO_1
		);
	 
		
----------------------------------------------------------------------------------
-- Processes
----------------------------------------------------------------------------------



    -- Concurrent Assignments  
	 
    -- Assign outputs from intermediate signals


end blocks;

