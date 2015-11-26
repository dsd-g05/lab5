-- Descp. Compares two 3bit numbers and outputs the smallest one
--
-- entity name: g05_minimum3
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: October 5, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_minimum3 is
    port ( 
        N, M : in std_logic_vector(2 downto 0);
        min : out std_logic_vector(2 downto 0)
    );
end g05_minimum3;

architecture behavior of g05_minimum3 is
    signal AltB, AeqB, AgtB : std_logic;
    signal i : std_logic_vector(2 downto 0);
begin
    i <= N xnor M;
    AeqB <= i(0) and i(1) and i(2);
    AgtB <= (N(2) and not M(2)) or 
            (N(1) and not M(1) and i(2)) or 
            (N(0) and not M(0) and i(2) and i(1));
    AltB <= AeqB nor AgtB;
    min <= M when AltB = '0' else N;   
end behavior;