-- Descp. Complete scoring circuit
--
-- entity name: g05_mastermind_score
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: October 18, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_mastermind_score is
    port ( 
        P1, P2, P3, P4 : in std_logic_vector(2 downto 0);
        G1, G2, G3, G4 : in std_logic_vector(2 downto 0); 
        exact_match_score : out std_logic_vector(2 downto 0); 
        color_match_score : out std_logic_vector(2 downto 0);
        score_code : out std_logic_vector(3 downto 0)
    );
end g05_mastermind_score;

architecture behavior of g05_mastermind_score is

    signal color_matches, exact_matches : std_logic_vector(2 downto 0);

    component g05_color_matches is
         port ( 
              P1, P2, P3, P4 : in std_logic_vector(2 downto 0);
              G1, G2, G3, G4 : in std_logic_vector(2 downto 0);
              num_exact_matches : out std_logic_vector(2 downto 0);
              num_color_matches : out std_logic_vector(2 downto 0)
         );
    end component;
    
    component g05_score_encoder is
        port (
            score_code : out std_logic_vector(3 downto 0);
            num_exact_matches : in std_logic_vector(2 downto 0);
            num_color_matches : in std_logic_vector(2 downto 0)
        );
    end component;
    
begin
    num_matches : g05_color_matches
        port map (P1 => P1, P2 => P2, P3 => P3, P4 => P4, G1 => G1, G2 => G2, G3 => G3, G4 => G4, 
                  num_exact_matches => exact_matches, num_color_matches => color_matches);
        
    score : g05_score_encoder
        port map (num_exact_matches => exact_matches, num_color_matches => color_matches, score_code => score_code);
        
    color_match_score <= color_matches;
    exact_match_score <= exact_matches;
    
end behavior;