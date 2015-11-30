-- Descp. decodes the 3 bit color to the 4 bit needed for the segment_decoder
--
-- entity name: g05_color_decoder
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: October 29, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_color_decoder is
	port (
        color : in std_logic_vector(2 downto 0);
        color_code : out std_logic_vector(3 downto 0)
	);
end g05_color_decoder;

architecture behavior of g05_color_decoder is
begin  
    with color select color_code <=
        "1010" when "000",
        "1011" when "001",
        "1100" when "010",
        "1101" when "011",
        "1110" when "100",
        "1111" when "101",
        "1010" when others;
end behavior;