-------------------------------------------------------------------------------
-- Project     : Metastability detect
-- Description : An asynchrounous counter force flip flops to metastable state.
--               With the implementation of an synchronisation, metastability desapears.
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

ENTITY metastability_2 IS

port (CLOCK_27 : 	in std_logic;
		CLOCK_50 : 	in std_logic;
		KEY_1 : 		in std_logic; 		-- reset-button
      GPIO_0_0 :  out std_logic;		-- KO: state 
		GPIO_0_1 :  out std_logic;    -- KO: async. pulse 
		SW_17:      in std_logic;     -- synchronisation-switch
		LEDR_0:		out std_logic;
		LEDR_1:		out std_logic;
		LEDG_7:		out std_logic			
  );
end metastability_2; 


----------------------------------------------------------------------------------
-- Architecture 
----------------------------------------------------------------------------------
architecture behavioral of metastability_2 is

--------------------------------------------
-- Signals and Constants
--------------------------------------------
constant s0			: std_logic_vector(2 downto 0) := "001";
constant s1 		: std_logic_vector(2 downto 0) := "010";
constant unstable : std_logic_vector(2 downto 0) := "000";

signal state: 			std_logic_vector(2 downto 0);  
signal next_state: 	std_logic_vector(2 downto 0);

signal cnt: 			integer range 0 to 15 := 0;  
signal next_cnt: 		integer range 0 to 15 := 0; 
signal cnt_reset:		std_logic     := '0'; 

signal pulse_async: 	std_logic     := '0';
signal pulse_sync1: 	std_logic     := '0';
signal pulse_sync2: 	std_logic     := '0';
signal pulse: 			std_logic     := '0';


begin

--------------------------------------------
-- Clocked Process
--------------------------------------------
	fsm: process (all)
	begin
		if (KEY_1 = '0') then
			state <= s0;
		elsif (rising_edge(CLOCK_50)) then
		   state <= next_state;
			-- synchronistaion of async. pulse
		   pulse_sync1 <= pulse_async;
		   pulse_sync2 <= pulse_sync1;
		end if;
	end process;


	counter: process (all)
	begin
		if (KEY_1 = '0') then
			cnt <= 0;
		elsif(rising_edge(CLOCK_27)) then
		   cnt <= next_cnt;   			
		end if;
	end process;
	

	
--------------------------------------------
-- Asynynchronous Pulse Counter
-------------------------------------------- 
	counter_input: process (all)	
	begin			
			next_cnt <= cnt + 1; 
	end process;

	
--------------------------------------------
-- Test Metastable State Machine Logic
-------------------------------------------- 	
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
				 next_state <= s0;
			 else
				 next_state <= s1;
			 end if;
			 
		 when others => 
				next_state <= unstable;
				
	  end case;		
end process;	

--------------------------------------------
-- Synchronisation by Switch
--------------------------------------------
	multiplexer_synchro: process (all)
	begin
		if (SW_16 = '1') then
			pulse <= pulse_sync2;
		else 
			pulse <= pulse_async;
		end if;
	end process;
	

--------------------------------------------
-- Output Process
--------------------------------------------

	decode_cnt_max: process (all)
	begin
		if (cnt = 15) then
			pulse_async <= '1';
		else 
			pulse_async <= '0';
		end if;
	end process;	
		
	fsm_output: process (all)
	begin
	-- Default Values
	LEDR_0   <= '0';
	LEDR_1   <= '0';
	LEDG_7   <= '0';  
	GPIO_0_0 <= '0';
	
		case state is
			when s0 =>   
					LEDR_0  <= '1'; 
			when s1 =>   
					LEDR_1  <= '1'; 
					GPIO_0_0 <= '1';
			when unstable => 
			      LEDG_7  <= '1';
			when others =>   
					LEDG_7 <= '1';		 
		end case;			
	end process;	
	
   -- Set Output	
	GPIO_0_1 <= pulse_async;
	
end behavioral;
















