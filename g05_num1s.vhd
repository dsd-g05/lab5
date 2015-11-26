-- Descp: counts number of 1 bits in input number
--
-- entity name: g05_num_matches
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: September 29, 2015

library ieee;
use ieee.std_logic_1164.all; 

entity g05_num1s is 
    port (
        X : in std_logic_vector(3 downto 0);
        num1s : out std_logic_vector(2 downto 0)
    );
end g05_num1s;

architecture behavior of g05_num1s is 
begin 
    num1s(2) <= X(0) and X(1) and X(2) and X(3);
    num1s(1) <= (X(0) and X(1) and (not X(2)))
                or ((not X(0)) and X(1) and X(3))
                or (X(0) and (not X(1)) and X(3))
                or ((not X(0)) and X(2) and X(3))
                or (X(1) and X(2) and (not X(3)))
                or (X(0) and X(2) and (not X(3)));
    num1s(0) <= ((not X(0)) and X(1) and (not X(2)) and (not X(3)))
                or (X(0) and (not X(1)) and (not X(2)) and (not X(3)))
                or ((not X(0)) and (not X(1)) and (not X(2)) and X(3))
                or (X(0) and X(1) and (not X(2)) and X(3))
                or ((not X(0)) and X(1) and X(2) and X(3))
                or (X(0) and (not X(1)) and X(2) and X(3))
                or ((not X(0)) and (not X(1)) and X(2) and (not X(3)))
                or (X(0) and X(1) and X(2) and (not X(3)));
end behavior;