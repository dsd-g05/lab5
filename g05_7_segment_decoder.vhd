-- Descp. Determines which LED should be lit up on the 7-segment display.
--
-- entity name: g05_7_segment_decoder
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: October 29, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_7_segment_decoder is

    port (  
        code : in std_logic_vector(3 downto 0);
        RippleBlank_In : in std_logic;
        RippleBlank_Out : out std_logic;
        segments : out std_logic_vector(6 downto 0)
    );

end g05_7_segment_decoder;

architecture behavior of g05_7_segment_decoder is
    -- input is the concatenation of RippleBlank_In and code
    signal input : std_logic_vector(4 downto 0);
    -- output is the concatenation of RippleBlank_Out and segments
    signal output : std_logic_vector(7 downto 0);
begin
    input <= RippleBlank_In & code;
    
    with input select output <=
        "01000000" when "00000", --display 0
        "01111001" when "00001", --display 1
        "00100100" when "00010", --display 2
        "00110000" when "00011", --display 3
        "00011001" when "00100", --display 4
        "00010010" when "00101", --display 5
        "00000010" when "00110", --display 6
        "01111000" when "00111", --display 7
        "00000000" when "01000", --display 8
        "00011000" when "01001", --display 9
        "00000011" when "01010", --display b (blue)
        "00101111" when "01011", --display r (red)
        "00101011" when "01100", --display n (black)
        "01110001" when "01101", --display j (yellow)
        "01100011" when "01110", --display v (green)
        "00100111" when "01111", --display c (white)
        "01111001" when "10001", --display 1
        "00100100" when "10010", --display 2
        "00110000" when "10011", --display 3
        "00011001" when "10100", --display 4
        "00010010" when "10101", --display 5
        "00000010" when "10110", --display 6
        "01111000" when "10111", --display 7
        "00000000" when "11000", --display 8
        "00011000" when "11001", --display 9
        "00000011" when "11010", --display b (blue)
        "00101111" when "11011", --display r (red)
        "00101011" when "11100", --display n (black)
        "01110001" when "11101", --display j (yellow)
        "01100011" when "11110", --display v (green)
        "00100111" when "11111", --display c (white)
        "11111111" when others;
        
    RippleBlank_Out <= output(7);
    segments <= output(6 downto 0);
end behavior;