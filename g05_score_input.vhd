-- Descp. Allow the user to input the score
--
-- entity name: g05_score_input
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: November 30, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_score_input is
    port (
        increment, sel : in std_logic;
        seg_code : out std_logic_vector(3 downto 0);
        segment : out std_logic_vector(1 downto 0)
    );
end g05_score_input;

architecture behavior of g05_pattern_input is

    type segment is (s1, s2);
    type score is (c1, c2, c3, c4, c5);
    signal s_present, s_next : segment;
    signal c_present, c_next : score;

begin
    selector: process(sel)
    begin
        case s_present is
            when s1 =>
                if sel = '0' then
                    s_next <= s2;
                else
                    s_next <= s1;
                end if;
                
            when s2 =>
                if sel = '0' then
                    s_next <= s1;
                else
                    s_next <= s2;
                end if;
            when others =>
                s_next <= s1;
         end case;
    end process; 

    process(CLK)
    begin
        if rising_edge(CLK) then
            s_present <= s_next;
        end if;
    end process; 

    incrementor: process(increment)
    begin
         case c_present is
            when c1 =>
                if increment = '0' then
                    c_next <= c2;
                else
                    c_next <= c1;
                end if;
                
            when c2 =>
                if increment = '0' then
                    c_next <= c3;
                else
                    c_next <= c2;
                end if;
                
            when c3 =>
                if increment = '0' then
                    c_next <= c4;
                else
                    c_next <= c3;
                end if;
                
            when c4 =>
                if increment = '0' then
                    c_next <= c5;
                else
                    c_next <= c4;
                end if;

            when c5 =>
                if increment = '0' then
                    c_next <= c1;
                else
                    c_next <= c5;
                end if;
            when others =>
                c_next <= c1;
         end case; 
    end process;
    
   process(CLK)
    begin
        if rising_edge(CLK) then
            c_present <= c_next;
        end if;
    end process; 

    seg_code <= "0000" when c_present = c1 else
                "0001" when c_present = c2 else
                "0010" when c_present = c3 else
                "0011" when c_present = c4 else
                "0100" when c_present = c5 else
                "0000";

    segement <= "00" when s_present = s1 else
                "01" when s_present = s2 else
                "00";


end behavior;