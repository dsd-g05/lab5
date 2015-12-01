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
	process(score_code)
    begin
        case score_code is
            when "0000" => 
                num_color_matches <= "0000";
            when "0001" => 
                num_color_matches <= "0000";
            when "0010" => 
                num_color_matches <= "0000";
            when "0011" => 
                num_color_matches <= "0001";
            when "0100" => 
                num_color_matches <= "0010";
            when "0101" => 
                num_color_matches <= "0000";
            when "0110" => 
                num_color_matches <= "0001";
            when "0111" => 
                num_color_matches <= "0010";
            when "1000" => 
                num_color_matches <= "0011";
            when "1001" => 
                num_color_matches <= "0000";
            when "1010" => 
                num_color_matches <= "0001";
            when "1011" => 
                num_color_matches <= "0010";
            when "1100" => 
                num_color_matches <= "0011";
            when "1101" => 
                num_color_matches  <= "0100";
            when others =>  
                num_color_matches <= "0000";
        end case;

        case score_code is
            when "0000" =>
                num_exact_matches <= "0100";
            when "0001" =>
                num_exact_matches <= "0011";
            when "0010" =>
                num_exact_matches <= "0010";
            when "0011" =>
                num_exact_matches <= "0010";
            when "0100" =>
                num_exact_matches <= "0010";
            when "0101" =>
                num_exact_matches <= "0001";
            when "0110" =>
                num_exact_matches <= "0001";
            when "0111" =>
                num_exact_matches <= "0001";
            when "1000" =>
                num_exact_matches <= "0001";
            when "1001" =>
                num_exact_matches <= "0000";
            when "1010" =>
                num_exact_matches <= "0000";
            when "1011" =>
                num_exact_matches <= "0000";
            when "1100" =>
                num_exact_matches <= "0000";
            when "1101" =>
                num_exact_matches <= "0000";
            when others =>
                num_exact_matches <= "0000";
        end case;
    end process;
end behavior;