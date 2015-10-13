-------------------------------------------------------------------------------
-- Project     : Metastability detect
-- Description : fsm_x.vhd
--                         
--               
-- Author      : Katrin Bächli
-------------------------------------------------------------------------------
-- Change History
-- Date     |Name      |Modification
------------|----------|-------------------------------------------------------
-- 6.10.15	| baek     | init: Code from http://vhdlguru.blogspot.ch/2010/04/how-to-implement-state-machines-in-vhdl.html
-------------------------------------------------------------------------------
library ieee;
use IEEE.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm_1 is
port (clk : 	in std_logic;
      key : 	in std_logic;
      alarm :  out std_logic
  );
end fsm_1;

----------------------------------------------------------------------------------
-- Architecture 
----------------------------------------------------------------------------------
architecture behavioral of fsm_1 is


--------------------------------------------
-- signals
--------------------------------------------
type actual_state is (s0, s1, s2, s3, s4, s5, s6, s7); 

--constant s0:				actual_state := "000";
--constant s1:				actual_state := "001";
--signal s2:				std_logic_vector(2 downto 0) := "010";
--signal s3:				std_logic_vector(2 downto 0) := "011";
--signal s4:				std_logic_vector(2 downto 0) := "100";
--signal s5:				std_logic_vector(2 downto 0) := "101";
--signal s6:				std_logic_vector(2 downto 0) := "110";
--signal s7:				std_logic_vector(2 downto 0) := "111";


--attribute sync_encoding:	string;
--attribute sync_encoding of actual_state:  type is "000 001 010 011 100 101 110 111";

signal state: 			actual_state;  
signal next_state: 	actual_state;
--signal fsm_in:			std_logic_vector(2 downto 0) := "000";
--signal fsm_out: 		std_logic_vector(2 downto 0) := "000";

begin

--------------------------------------------
-- clocked process
--------------------------------------------
	process (clk)
	begin
		if (rising_edge(clk)) then
		  state <= next_state;   			
		end if;
	end process;

	
--------------------------------------------
-- input process
--------------------------------------------
	process (state, key)
	
	begin	
	  case state is
		  when s0 =>       
			  if(key ='1') then
				next_state <= s1;
			 else
				next_state <= s0;
			  end if;  
			
		  when s1 =>        
			 if(key ='1') then
				next_state <= s0;
			 else
				next_state <= s1;
			 end if;

		 -- no official states
		 when s2 =>       
			 if(key ='1') then
				next_state <= s3;
			 else
				next_state <= s2;
			 end if;
	
		 when s3 =>       
			 if(key ='1') then
				next_state <= s4;
			 else
				next_state <= s3;
			 end if;

		 when s4 =>       
			 if(key ='1') then
				next_state <= s5;
			 else
				next_state <= s4;
			 end if;

		 when s5 =>       
			 if(key ='1') then
				next_state <= s6;
			 else
				next_state <= s5;
			 end if;

		 when s6 =>       
			 if(key ='1') then
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
		if state = s7 or state = s2 then
			alarm <= '1';
		else
			alarm <= '0';
		end if;
--		case state is
--			when s0 => 
--				fsm_out <= "000";
--			when s1 => 
--				fsm_out <= "001";
--			when s2 => 
--				fsm_out <= "010";
--			when s3 => 
--				fsm_out <= "011";
--			when s4 => 
--				fsm_out <= "100";
--			when s5 => 
--				fsm_out <= "101";
--			when s6 => 
--				fsm_out <= "110";
--			when s7 => 
--				fsm_out <= "111";
--		end case;
	end process;

-- signal auf port output setzen

end behavioral;