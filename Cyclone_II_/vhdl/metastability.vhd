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
port (CLOCK_27 : 	in std_logic;
		CLOCK_50 : 	in std_logic;
      SW_17 : 		in std_logic;  
      GPIO_0_0 :  out std_logic;		-- state 
		GPIO_0_1 :  out std_logic;    -- pulse 
		LEDR_17:		out std_logic
		
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
		
signal state: 			actual_state  := s0;  
signal next_state: 	actual_state;

signal cnt: 			integer range 0 to 15 := 0;  
signal next_cnt: 		integer range 0 to 15 := 0;  
signal pulse: 			std_logic     := '0';
signal cnt_reset:		std_logic     := '0';



begin

--------------------------------------------
-- clocked process
--------------------------------------------
	fsm: process (all)
	begin
		if (SW_17 = '1') then
			state <= s2;
		elsif (rising_edge(CLOCK_50)) then
		  state <= next_state;
		end if;
	end process;


	counter: process (all)
	begin
		if (cnt_reset = '1') then
			cnt <= 0;
		elsif(rising_edge(CLOCK_27)) then
		  cnt <= next_cnt;   			
		end if;
	end process;
	
	

	
--------------------------------------------
-- input process
-------------------------------------------- 
	counter_input: process (all)	
	begin			
			next_cnt <= cnt + 1; 
	end process;

	fsm_input: process (all)		
	begin 	  
	  case state is
	  		  when s0 => 
			  if(pulse ='1') then
				next_state <= s1;
			 else
				next_state <= s0;
			  end if;  
			
		  when s1 =>    
			 if(pulse ='1') then
				next_state <= s2;  ----------------
			 else
				next_state <= s1;
			 end if;

		 -- no official states
		 when s2 =>       
			 if(pulse ='1') then
				next_state <= s3;
			 else
				next_state <= s2;
			 end if;
	
		 when s3 =>       
			 if(pulse ='1') then
				next_state <= s4;
			 else
				next_state <= s3;
			 end if;

		 when s4 =>       
			 if(pulse ='1') then
				next_state <= s5;
			 else
				next_state <= s4;
			 end if;

		 when s5 =>       
			 if(pulse ='1') then
				next_state <= s6;
			 else
				next_state <= s5;
			 end if;

		 when s6 =>       
			 if(pulse ='1') then
				next_state <= s7;
			 else
				next_state <= s6;
			 end if;
		
		when s7 =>       		 
				next_state <= s0;    -----
		end case;
		
	end process;	

	
--------------------------------------------
-- output process
--------------------------------------------

	decode_cnt_max: process (all)
	begin
		if (cnt = 15) then
			cnt_reset <= '1';
			pulse <= '1';
		else 
			cnt_reset <= '0';
			pulse <= '0';
		end if;
	end process;	
	
	
	
	fsm_output: process (all)
	begin
		-- not allowed state
		if (state = s2) then -- or (state = s3) or (state = s4) or (state = s5) or (state = s6) or (state = s7) then
			GPIO_0_0 <= '1';
			LEDR_17   <= '1';
		else
			GPIO_0_0 <= '0';
			LEDR_17   <= '0';
		end if;	
	end process;	
	
	GPIO_0_1 <= pulse;
	
end behavioral;

