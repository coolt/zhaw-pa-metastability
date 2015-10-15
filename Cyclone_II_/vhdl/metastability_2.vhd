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

ENTITY metastability_2 IS

port (CLOCK_27 : 	in std_logic;
		CLOCK_50 : 	in std_logic;
		KEY_1 : 		in std_logic; 		-- Reset
      GPIO_0_0 :  out std_logic;		-- state 
		GPIO_0_1 :  out std_logic;    -- pulse 
		SW_17:      in std_logic;
		LEDR_0:		out std_logic;
		LEDR_1:		out std_logic;
		LEDR_2:		out std_logic;
		LEDR_3:		out std_logic;
		LEDR_4:		out std_logic;
		LEDR_5:		out std_logic;
		LEDR_6:		out std_logic;
		LEDR_7:		out std_logic;
		LEDG_7:		out std_logic			
  );
end metastability_2; 


----------------------------------------------------------------------------------
-- Architecture 
----------------------------------------------------------------------------------
architecture behavioral of metastability_2 is

--------------------------------------------
-- signals
--------------------------------------------
--constant unstable : std_logic_vector(7 downto 0) := "00000000";
constant s0			: std_logic_vector(7 downto 0) := "00000001";
constant s1 		: std_logic_vector(7 downto 0) := "00000010";
constant s2 		: std_logic_vector(7 downto 0) := "00000100";
constant s3 		: std_logic_vector(7 downto 0) := "00001000";
constant s4 		: std_logic_vector(7 downto 0) := "00010000";
constant s5 		: std_logic_vector(7 downto 0) := "00100000";
constant s6 		: std_logic_vector(7 downto 0) := "01000000";
constant s7 		: std_logic_vector(7 downto 0) := "10000000";

signal state: 			std_logic_vector(7 downto 0);  
signal next_state: 	std_logic_vector(7 downto 0);

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
		if (KEY_1 = '0') then
			state <= s0;
		elsif (rising_edge(CLOCK_27)) then
		  state <= next_state;
		end if;
	end process;


	counter: process (all)
	begin
		if (KEY_1 = '0') then
			cnt <= 0;
		elsif(rising_edge(CLOCK_50)) then
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
			 
				if SW_17 = '1' then
						next_state <= s2;  
				else 
						next_state <= s0;
				end if;
			 else
				next_state <= s1;
			 end if;

		 -- no official states
		 when s2 =>   next_state <= s3;
		 when s3 =>   next_state <= s4;
		 when s4 =>   next_state <= s5;
		 when s5 =>	  next_state <= s6;
		 when s6 =>   next_state <= s7;
		 when s7 =>   next_state <= s7;  
		 when others => next_state <= s0; --unstable;  -- s0: immer astabil
	  end case;
		
	end process;	

	
--------------------------------------------
-- output process
--------------------------------------------

	decode_cnt_max: process (all)
	begin
		if (cnt = 15) then
			pulse <= '1';
		else 
			pulse <= '0';
		end if;
	end process;	
		
	fsm_output: process (all)
	begin
	LEDR_0  <= '0';
	LEDR_1  <= '0';
	LEDR_2  <= '0';
	LEDR_3  <= '0';
	LEDR_4  <= '0';
	LEDR_5  <= '0';
	LEDR_6  <= '0';
	LEDR_7  <= '0';
	LEDG_7  <= '0';
	GPIO_0_0 <= '0';
	
	case state is
			when s0 =>   LEDR_0  <= '1'; 
			when s1 =>   LEDR_1  <= '1'; GPIO_0_0 <= '1';
			when s2 =>   LEDR_2  <= '1';
			when s3 =>   LEDR_3  <= '1';
			when s4 =>   LEDR_4  <= '1';
			when s5 =>   LEDR_5  <= '1';
			when s6 =>   LEDR_6  <= '1';
			when s7 =>   LEDR_7  <= '1';
			--when unstable => LEDG_7 <= '1';
			when OTHERS =>   LEDG_7 <= '1';		 
	end case;
			
end process;	
		
	GPIO_0_1 <= pulse;
	
end behavioral;
















