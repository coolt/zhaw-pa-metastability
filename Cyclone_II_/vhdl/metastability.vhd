-------------------------------------------------------------------------------
-- Project     : Metastability detect
-- Description : metastability.vhd
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


entity metastability is
port (CLOCK_50 : 	in std_logic;
      KEY_0 : 		in std_logic;  -- low activ 
      GPIO_0_0 :  out std_logic
  );
end metastability;


----------------------------------------------------------------------------------
-- Architecture 
----------------------------------------------------------------------------------
architecture behavioral of metastability is

--------------------------------------------
-- signals
--------------------------------------------
type actual_state is (s0, s1, s2, s3, s4, s5, s6, s7); 
		
signal state: 			actual_state;  
signal next_state: 	actual_state;


begin

--------------------------------------------
-- clocked process
--------------------------------------------
	process (CLOCK_50)
	begin
		if (rising_edge(CLOCK_50)) then
		  state <= next_state;   			
		end if;
	end process;

	
--------------------------------------------
-- input process
--------------------------------------------
	process (state, KEY_0)
	
	begin	
	  case state is
		  when s0 =>  
			  -- key pressed
			  if(KEY_0 ='0') then
				--GPIO_0_0 <= '1';
				next_state <= s1;
			 else
				next_state <= s0;
			  end if;  
			
		  when s1 =>    
			 -- key pressed
			 if(KEY_0 ='0') then
				next_state <= s0;
				--GPIO_0_0 <= '0';
			 else
				next_state <= s1;
			 end if;

		 -- no official states
		 when s2 =>       
			 if(KEY_0 ='0') then
				next_state <= s3;
			 else
				next_state <= s2;
			 end if;
	
		 when s3 =>       
			 if(KEY_0 ='0') then
				next_state <= s4;
			 else
				next_state <= s3;
			 end if;

		 when s4 =>       
			 if(KEY_0 ='0') then
				next_state <= s5;
			 else
				next_state <= s4;
			 end if;

		 when s5 =>       
			 if(KEY_0 ='0') then
				next_state <= s6;
			 else
				next_state <= s5;
			 end if;

		 when s6 =>       
			 if(KEY_0 ='0') then
				next_state <= s7;
			 else
				next_state <= s6;
			 end if;
		
		when s7 =>       		 
				next_state <= s7;
		end case;
	end process;	

	
--------------------------------------------
-- output process
--------------------------------------------
	process (state)
	begin
		-- not allowed state
		if (state = s2) or (state = s3) or (state = s4) or (state = s5) or (state = s6) or (state = s7) then
			GPIO_0_0 <= '1';
		else
			GPIO_0_0 <= '0';
		end if;	
	end process;	
	
	
end behavioral;

