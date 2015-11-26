-- Descp: counts number of exact matches
--
-- entity name: g05_num_matches
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: October 1, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_num_matches is
    port (
        P1, P2, P3, P4 : in std_logic_vector(2 downto 0);
        G1, G2, G3, G4 : in std_logic_vector(2 downto 0);
        N : out std_logic_vector(2 downto 0)
    );
end g05_num_matches;

architecture behavior of g05_num_matches is

    component g05_comp6 is
        port (
            A : in std_logic_vector(5 downto 0);
            B : in std_logic_vector(5 downto 0);
            AeqB : out std_logic
        );
    end component;

    component g05_num1s is
        port (
            X : in std_logic_vector(3 downto 0);
            num1s : out std_logic_vector(2 downto 0)
        );
    end component;

    signal X : std_logic_vector(3 downto 0);

begin
    compX0 : g05_comp6
        port map (A(5 downto 3) => "000", A(2 downto 0) => P1,
                  B(5 downto 3) => "000", B(2 downto 0) => G1, AeqB => X(0));
    compX1 : g05_comp6
        port map (A(5 downto 3) => "000", A(2 downto 0) => P2,
                  B(5 downto 3) => "000", B(2 downto 0) => G2, AeqB => X(1));
    compX2 : g05_comp6
        port map (A(5 downto 3) => "000", A(2 downto 0) => P3,
                  B(5 downto 3) => "000", B(2 downto 0) => G3, AeqB => X(2));
    compX3 : g05_comp6
        port map (A(5 downto 3) => "000", A(2 downto 0) => P4,
                  B(5 downto 3) => "000", B(2 downto 0) => G4, AeqB => X(3));
    matches : g05_num1s
        port map (X => X, num1s => N);
        
end behavior;