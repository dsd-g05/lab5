-- Descp. decode the 4 bits encoded score  to two 4 bits score number, which is needed for the 7 segment display decoder
--4 bit number #### => (num_exact, num_color_matches)
--0000 (4,0)
--0001 (3,0)
--0010 (2,0)
--0011 (2,1)
--0100 (2,2)
--0101 (1,0)
--0110 (1,1)
--0111 (1,2)
--1000 (1,3)
--1001 (0,0)
--1010 (0,1)
--1011 (0,2)
--1100 (0,3)
--1101 (0,4)
--
-- entity name: g05_score_decoder
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: November 30, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_score_decoder is
	port (
		score_code : in std_logic_vector(3 downto 0);
		num_exact_matches, num_color_matches : out std_logic_vector(3 downto 0)
	);
end g05_score_decoder;

architecture behavior of g05_score_decoder is
begin
	process(score)
    begin
        case num_color_matches is
            when "0000" =>
                score_code <= "0000";
            when "0000" =>
                score_code <= "0001";
            when "0000" =>
                score_code <= "0010";
            when "0001" =>
                score_code <= "0011";
            when "0010" =>
                score_code <= "0100";
            when "0000" =>
                score_code <= "0101";
            when "0001" =>
                score_code <= "0110";
            when "0010" =>
                score_code <= "0111";
            when "0011" =>
                score_code <= "1000";
            when "0000" =>
                score_code <= "1001";
            when "0001" =>
                score_code <= "1010";
            when "0010" =>
                score_code <= "1011";
            when "0011" =>
                score_code <= "1100";
            when "0100" =>
                score_code <= "1101";
            when others =>
                score_code <= "0000";
        end case;

        case num_exact_matches is
            when "0100" =>
                score_code <= "0000";
            when "0011" =>
                score_code <= "0001";
            when "0010" =>
                score_code <= "0010";
            when "0010" =>
                score_code <= "0011";
            when "0010" =>
                score_code <= "0100";
            when "0001" =>
                score_code <= "0101";
            when "0001" =>
                score_code <= "0110";
            when "0001" =>
                score_code <= "0111";
            when "0001" =>
                score_code <= "1000";
            when "0000" =>
                score_code <= "1001";
            when "0000" =>
                score_code <= "1010";
            when "0000" =>
                score_code <= "1011";
            when "0000" =>
                score_code <= "1100";
            when "0000" =>
                score_code <= "1101";
            when others =>
                score_code <= "0000";
        end case;
    end process;
end behavior;