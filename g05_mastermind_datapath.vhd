-- Descp. mastermind datapath
--
-- entity name: g05_mastermind_datapath
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: November 23, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_mastermind_datapath is
	port (
        P_SEL, GR_SEL, SR_SEL : in std_logic;
        GR_LD, SR_LD : in std_logic;
        TM_IN, TM_EN, TC_RST, TC_EN : in std_logic;
        EXT_PATTERN : in std_logic_vector(11 downto 0);
        CLK : in std_logic;
        TC_LAST : out std_logic;
        SC_CMP : out std_logic
	);
end g05_mastermind_datapath;

architecture behavior of g05_mastermind_datapath is
    
    component g05_mastermind_score is
        port ( 
            P1, P2, P3, P4 : in std_logic_vector(2 downto 0);
            G1, G2, G3, G4 : in std_logic_vector(2 downto 0); 
            exact_match_score : out std_logic_vector(2 downto 0); 
            color_match_score : out std_logic_vector(2 downto 0);
            score_code : out std_logic_vector(3 downto 0)
         );
    end component;
    
    component g05_possibility_table is
        port (
            TC_EN : in std_logic;
            TC_RST : in std_logic;
            TM_IN : in std_logic;
            TM_EN : in std_logic;
            CLK : in std_logic;
            TC_LAST : out std_logic;
            TM_ADDR : out std_logic_vector(11 downto 0);
            TM_OUT : out std_logic
        );
    end component;
    
    component g05_comp6 is
        port (
            A :  in  std_logic_vector(5 downto 0);
            B :  in  std_logic_vector(5 downto 0);
            AeqB :  out  std_logic
        );
    end component;

    signal P1, P2, P3, P4 : std_logic_vector(2 downto 0);
    signal G1, G2, G3, G4 : std_logic_vector(2 downto 0);
    signal TM_ADDR : std_logic_vector(11 downto 0);
    signal score, score_reg, SR : std_logic_vector(3 downto 0);
    
begin

    P1 <= EXT_PATTERN(2 downto 0) when P_SEL = '0' else TM_ADDR(2 downto 0);
    P2 <= EXT_PATTERN(5 downto 3) when P_SEL = '0' else TM_ADDR(5 downto 3);
    P3 <= EXT_PATTERN(8 downto 6) when P_SEL = '0' else TM_ADDR(8 downto 6);
    P4 <= EXT_PATTERN(11 downto 9) when P_SEL = '0' else TM_ADDR(11 downto 9);
    
    process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (GR_LD = '1') then
                if (GR_SEL = '0') then
                    G1 <= TM_ADDR(2 downto 0);
                    G2 <= TM_ADDR(5 downto 3);
                    G3 <= TM_ADDR(8 downto 6);
                    G4 <= TM_ADDR(11 downto 9);
                else
                    G1 <= "001";
                    G2 <= "001";
                    G3 <= "000";
                    G4 <= "000";
                end if;
            end if;
        end if;
    end process;

    mastermind_score : g05_mastermind_score
        port map (P1 => P1, P2 => P2, P3 => P3, P4 => P4,
                  G1 => G1, G2 => G2, G3 => G3, G4 => G4,
                  score_code => score);
                  
    process(CLK)
    begin
        if (rising_edge(CLK)) then
            if (SR_LD = '1') then
                score_reg <= score;
            end if;
        end if;
    end process;
    
    SR <= score when SR_SEL = '0' else "0000";
    
    score_comp : g05_comp6
        port map (A(5 downto 4) => "00", A(3 downto 0) => score_reg,
                  B(5 downto 4) => "00", B(3 downto 0) => SR, AeqB => SC_CMP);
                  
    possibility_table : g05_possibility_table
        port map (TC_EN => TC_EN, TC_RST => TC_RST, TM_IN => TM_IN,
                  TM_EN => TM_EN, CLK => CLK, TC_LAST => TC_LAST, 
                  TM_ADDR => TM_ADDR);
end behavior;