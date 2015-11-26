-- Descp. Allow the user to choose a pattern
--
-- entity name: g05_pattern_input
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: November 26, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_pattern_input is
	port (
        increment, sel : in std_logic;
        seg1, seg2, seg3, seg4 : out std_logic_vector(6 downto 0);
        ext_pattern : out std_logic_vector(11 downto 0)
	);
end g05_pattern_input;

architecture behavior of g05_pattern_input is
    begin
        

end behavior;