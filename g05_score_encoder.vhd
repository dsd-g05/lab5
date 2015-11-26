-- Descp. Encode the score of the Mastermind game in a 4 bit number #### => (num_exact, num_color_matches)
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
--
-- entity name: g05_score_encoder
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: October 18, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_score_encoder is
	port (
		score_code : out std_logic_vector(3 downto 0);
		num_exact_matches : in std_logic_vector(2 downto 0);
		num_color_matches : in std_logic_vector(2 downto 0)
	);
end g05_score_encoder;

architecture behavior of g05_score_encoder is
	signal score : std_logic_vector(5 downto 0);
begin
	score <= num_exact_matches&num_color_matches; 
	process(score)
    begin
		case score is
			when "100000" =>
				score_code <= "0000";
			when "011000" =>
				score_code <= "0001";
			when "010000" =>
				score_code <= "0010";	
			when "010001" =>
				score_code <= "0011";
			when "010010" =>
				score_code <= "0100";
			when "001000" =>
				score_code <= "0101";
			when "001001" =>
				score_code <= "0110";	
			when "001010" =>
				score_code <= "0111";
			when "001011" =>
				score_code <= "1000";
			when "000000" =>
				score_code <= "1001";
			when "000001" =>
				score_code <= "1010";	
			when "000010" =>
				score_code <= "1011";
			when "000011" =>
				score_code <= "1100";
			when others =>
				score_code <= "1101";
		end case;
	end process;
end behavior;