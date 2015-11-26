-- Descp. Generate the table of all the possible pattern
--
-- entity name: g05_possibility_table
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: November 2, 2015

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity g05_possibility_table is
	port (
		TC_EN : in std_logic; -- table counter enable
		TC_RST : in std_logic; -- table counter reset
		TM_IN : in std_logic; -- table memory input data
		TM_EN : in std_logic; -- table memory write enable
		CLK : in std_logic;
		TC_LAST : out std_logic; -- last count flag
		TM_ADDR : out std_logic_vector(11 downto 0);
		TM_OUT : out std_logic -- table memory output
	);
end g05_possibility_table;

architecture behavior of g05_possibility_table is
	signal TC : std_logic_vector(11 downto 0);
	signal MT : std_logic_vector(4195 downto 0);
begin

	-- Table memory counter
	process(CLK, TC_RST)
	begin
		if(TC_RST = '1') then
			TC <= "000000000000";
			TC_LAST <= '0';
		elsif(rising_edge(CLK)) then
			if(TC_EN = '1') then
				if(TC(2 downto 0) = "101") then
					if(TC(5 downto 3) = "101") then
						if(TC(8 downto 6) = "101") then
							if(TC(11 downto 9) = "101") then
								TC_LAST <= '1';
								TC <= "000000000000";
							else
								TC <= TC + 147;
							end if;
						else
							TC <= TC + 19;
						end if;
					else
						TC <= TC + 3;
					end if;
				else
					TC <= TC + 1;
				end if;
			end if;
			
		end if;
	end process;
	TM_ADDR <= TC;
	-- Write in the memory table at a specific memory address
	process(CLK)
	begin
		if(rising_edge(CLK)) then
			if(TM_EN = '1') then
				MT(to_integer(unsigned(TC))) <= TM_IN;
			end if;
			
		end if;
	end process;
	TM_OUT <= MT(to_integer(unsigned(TC)));
end behavior;
