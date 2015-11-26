-- Descp. counts the number of color matches
--
-- entity name: g05_color_matches
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: October 15, 2015

library ieee;
use ieee.std_logic_1164.all;
library lpm;
use lpm.lpm_components.all;

entity g05_color_matches is
    port ( 
        P1, P2, P3, P4 : in std_logic_vector(2 downto 0);
        G1, G2, G3, G4 : in std_logic_vector(2 downto 0);
        num_exact_matches : out std_logic_vector(2 downto 0);
        num_color_matches : out std_logic_vector(2 downto 0)
    );
end g05_color_matches;

architecture behavior of g05_color_matches is

    component g05_minimum3 is
        port ( 
            N, M : in std_logic_vector(2 downto 0);
            min : out std_logic_vector(2 downto 0)
        );
    end component;

    component g05_num1s is 
        port ( 
            X : in std_logic_vector(3 downto 0);
            num1s : out std_logic_vector(2 downto 0)
        );
    end component;

    component g05_num_matches is
        port (
            P1, P2, P3, P4 : in std_logic_vector(2 downto 0);
            G1, G2, G3, G4 : in std_logic_vector(2 downto 0);
            N : out std_logic_vector(2 downto 0)
        );
    end component;

    signal EQ_P1, EQ_P2, EQ_P3, EQ_P4 : std_logic_vector(7 downto 0);
    signal EQ_G1, EQ_G2, EQ_G3, EQ_G4 : std_logic_vector(7 downto 0);
    signal P_C0, P_C1, P_C2, P_C3, P_C4, P_C5 : std_logic_vector(2 downto 0);
    signal G_C0, G_C1, G_C2, G_C3, G_C4, G_C5 : std_logic_vector(2 downto 0);   
    signal M_C0, M_C1, M_C2, M_C3, M_C4, M_C5 : std_logic_vector(2 downto 0);
    signal color_matches_all : std_logic_vector(2 downto 0);
    signal add1, add2, add3, add4 : std_logic_vector(2 downto 0);
    signal num_matches : std_logic_vector(2 downto 0);
    
begin
    --decode patern colors
    lpm_decode_P1 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => P1, eq => EQ_P1);
    lpm_decode_P2 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => P2, eq => EQ_P2);
    lpm_decode_P3 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => P3, eq => EQ_P3);
    lpm_decode_P4 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => P4, eq => EQ_P4);
                                        
    --count the number of each color in the pattern
    num1s_P_C0 : g05_num1s port map (X(0) => EQ_P1(0), X(1) => EQ_P2(0), X(2) => EQ_P3(0), X(3) => EQ_P4(0), num1s => P_C0);
    num1s_P_C1 : g05_num1s port map (X(0) => EQ_P1(1), X(1) => EQ_P2(1), X(2) => EQ_P3(1), X(3) => EQ_P4(1), num1s => P_C1);
    num1s_P_C2 : g05_num1s port map (X(0) => EQ_P1(2), X(1) => EQ_P2(2), X(2) => EQ_P3(2), X(3) => EQ_P4(2), num1s => P_C2);
    num1s_P_C3 : g05_num1s port map (X(0) => EQ_P1(3), X(1) => EQ_P2(3), X(2) => EQ_P3(3), X(3) => EQ_P4(3), num1s => P_C3);
    num1s_P_C4 : g05_num1s port map (X(0) => EQ_P1(4), X(1) => EQ_P2(4), X(2) => EQ_P3(4), X(3) => EQ_P4(4), num1s => P_C4);
    num1s_P_C5 : g05_num1s port map (X(0) => EQ_P1(5), X(1) => EQ_P2(5), X(2) => EQ_P3(5), X(3) => EQ_P4(5), num1s => P_C5);
    
    --decode guess colors
    lpm_decode_G1 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => G1, eq => EQ_G1);
    lpm_decode_G2 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => G2, eq => EQ_G2);
    lpm_decode_G3 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => G3, eq => EQ_G3);
    lpm_decode_G4 : lpm_decode
        generic map (lpm_width => 3, lpm_decodes => 8)
        port map (data => G4, eq => EQ_G4);
    
    --count the number of each color in the guess
    num1s_G_C0 : g05_num1s port map (X(0) => EQ_G1(0), X(1) => EQ_G2(0), X(2) => EQ_G3(0), X(3) => EQ_G4(0), num1s => G_C0);
    num1s_G_C1 : g05_num1s port map (X(0) => EQ_G1(1), X(1) => EQ_G2(1), X(2) => EQ_G3(1), X(3) => EQ_G4(1), num1s => G_C1);
    num1s_G_C2 : g05_num1s port map (X(0) => EQ_G1(2), X(1) => EQ_G2(2), X(2) => EQ_G3(2), X(3) => EQ_G4(2), num1s => G_C2);
    num1s_G_C3 : g05_num1s port map (X(0) => EQ_G1(3), X(1) => EQ_G2(3), X(2) => EQ_G3(3), X(3) => EQ_G4(3), num1s => G_C3);
    num1s_G_C4 : g05_num1s port map (X(0) => EQ_G1(4), X(1) => EQ_G2(4), X(2) => EQ_G3(4), X(3) => EQ_G4(4), num1s => G_C4);
    num1s_G_C5 : g05_num1s port map (X(0) => EQ_G1(5), X(1) => EQ_G2(5), X(2) => EQ_G3(5), X(3) => EQ_G4(5), num1s => G_C5);
    
    --count the number of times each color is in both the pattern and the guess
    min3_C0 : g05_minimum3 port map (M => P_C0, N => G_C0, min => M_C0);
    min3_C1 : g05_minimum3 port map (M => P_C1, N => G_C1, min => M_C1);
    min3_C2 : g05_minimum3 port map (M => P_C2, N => G_C2, min => M_C2);
    min3_C3 : g05_minimum3 port map (M => P_C3, N => G_C3, min => M_C3);
    min3_C4 : g05_minimum3 port map (M => P_C4, N => G_C4, min => M_C4);
    min3_C5 : g05_minimum3 port map (M => P_C5, N => G_C5, min => M_C5);
    
    --find the number of color matches which also include exact matches
    sum_1: lpm_add_sub
        generic map (lpm_width => 3)
        port map (dataa => M_C0, datab => M_C1, result => add1, add_sub => '1');
    sum_2: lpm_add_sub
        generic map (lpm_width => 3)
        port map (dataa => add1, datab => M_C2, result => add2, add_sub => '1');
    sum_3: lpm_add_sub
        generic map (lpm_width => 3)
        port map (dataa => add2, datab => M_C3, result => add3, add_sub => '1');
    sum_4: lpm_add_sub
        generic map (lpm_width => 3)
        port map (dataa => add3, datab => M_C4, result => add4, add_sub => '1');
    sum_5: lpm_add_sub
        generic map (lpm_width => 3)
        port map (dataa => add4, datab => M_C5, result => color_matches_all, add_sub => '1');
    
    --find the exact matches
    num_matches_exact : g05_num_matches 
        port map (P1 => P1, P2 => P2, P3 => P3, P4 => P4,
                  G1 => G1, G2 => G2, G3 => G3, G4 => G4,
                  N => num_matches);
    
    --find the number of color matches excluding the exact matches
    color_matches : lpm_add_sub
        generic map (lpm_width => 3)
        port map (dataa => color_matches_all, datab => num_matches, result => num_color_matches, add_sub => '0');
    
    num_exact_matches <= num_matches;
    
end behavior;