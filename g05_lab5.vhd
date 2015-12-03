-- Descp.
--
-- entity name: g05_lab5
--
-- Version 1.0
-- Author: Felix Dube; felix.dube@mail.mcgill.ca & Auguste Lalande; auguste.lalande@mail.mcgill.ca
-- Date: November 26, 2015

library ieee;
use ieee.std_logic_1164.all;

entity g05_lab5 is
	port (
        start, ready : in std_logic;
		sel, increment : in std_logic;
        mode : in std_logic;
        clk : in std_logic;
        seg_1, seg_2, seg_3, seg_4, seg_5, seg_6 : out std_logic_vector(6 downto 0)
	);
end g05_lab5;

architecture behavior of g05_lab5 is

	component g05_mastermind_controller is
		port (
            TM_OUT : in std_logic;
            SC_CMP, TC_LAST : in std_logic;
            START, READY : in std_logic;
            MODE : in std_logic;
            CLK : in std_logic;
            START_MODE : out std_logic;
            DEFAULT_SCORE : out std_logic;
            SR_SEL, P_SEL, GR_SEL : out std_logic; 
            GR_LD, SR_LD : out std_logic;
            TM_IN, TM_EN, TC_EN, TC_RST : out std_logic; 
            SOLVED : out std_logic
		);
	end component;
	
	component g05_mastermind_datapath is
		port (
            P_SEL, GR_SEL, SR_SEL : in std_logic;
            GR_LD, SR_LD : in std_logic;
            TM_IN, TM_EN, TC_RST, TC_EN : in std_logic;
            EXT_PATTERN : in std_logic_vector(11 downto 0);
            EXT_SCORE : in std_logic_vector(3 downto 0);
            MODE : in std_logic;
            START_MODE : in std_logic;
            CLK : in std_logic;
            TM_OUT : out std_logic;
            TC_LAST : out std_logic;
            SC_CMP : out std_logic;
            DIS_P1, DIS_P2, DIS_P3, DIS_P4, DIS_P5, DIS_P6 : out std_logic_vector(3 downto 0)
		);
	end component;
	
    signal P_SEL, GR_SEL, SR_SEL : std_logic;
    signal GR_LD, SR_LD : std_logic;
    signal TM_IN, TM_OUT, TM_EN, TC_RST, TC_EN : std_logic;
    signal TC_LAST : std_logic;
    signal SC_CMP : std_logic;
    signal SOLVED : std_logic;
    signal tmp_P5, tmp_P6 : std_logic_vector(3 downto 0);
    signal DIS_P1, DIS_P2, DIS_P3, DIS_P4, DIS_P5, DIS_P6 : std_logic_vector(3 downto 0);
    signal START_MODE, DEFAULT_SCORE : std_logic;
        
	component g05_pattern_input is
		port (
            increment, sel : in std_logic;
            seg_code : out std_logic_vector(2 downto 0);
            segment : out std_logic_vector(1 downto 0)
		);
	end component;
    
    signal seg_code : std_logic_vector(2 downto 0);
    signal segment : std_logic_vector(1 downto 0);
    signal ext_p1, ext_p2, ext_p3, ext_p4 : std_logic_vector(2 downto 0);
    signal ext_pattern : std_logic_vector(11 downto 0);
    
    component g05_score_input is
        port (
            increment, sel : in std_logic;
            score : out std_logic_vector(2 downto 0);
            score_part : out std_logic
        );
    end component;
    
    signal score : std_logic_vector(2 downto 0);
    signal exact_matches, color_matches : std_logic_vector(2 downto 0);
    signal score_part : std_logic;
    
    component g05_score_encoder is
        port (
            score_code : out std_logic_vector(3 downto 0);
            num_exact_matches : in std_logic_vector(2 downto 0);
            num_color_matches : in std_logic_vector(2 downto 0)
        );
    end component;
    
    signal encoded_score : std_logic_vector(3 downto 0);
    
    component g05_7_segment_decoder is
        port (  
            code : in std_logic_vector(3 downto 0);
            RippleBlank_In : in std_logic;
            RippleBlank_Out : out std_logic;
            segments : out std_logic_vector(6 downto 0)
        );
    end component;
    
begin

	pattern_input : g05_pattern_input
        port map (increment => increment, sel => sel,
                  seg_code => seg_code, segment => segment);
    
    ext_p1 <= seg_code when segment = "00";
    ext_p2 <= seg_code when segment = "01";
    ext_p3 <= seg_code when segment = "10";
    ext_p4 <= seg_code when segment = "11";
    
    ext_pattern <= ext_p1 & ext_p2 & ext_p3 & ext_p4;
    
    score_input : g05_score_input
        port map (increment => increment, sel => sel,
                  score => score, score_part => score_part);
                  
    exact_matches <= score when score_part = '1';
    color_matches <= score when score_part = '0';
    
    encoder : g05_score_encoder
        port map (num_exact_matches => exact_matches, num_color_matches => color_matches,
                  score_code => encoded_score);
    
    controller : g05_mastermind_controller
        port map (SC_CMP => SC_CMP, TC_LAST => TC_LAST, START => start, READY => ready,
                  MODE => mode, CLK => clk, SR_SEL => SR_SEL, P_SEL => P_SEL, GR_SEL => GR_SEL,
                  GR_LD => GR_LD, SR_LD => SR_LD, TM_IN => TM_IN, TM_EN => TM_EN, TC_EN => TC_EN,
                  TC_RST => TC_RST, SOLVED => SOLVED, TM_OUT => TM_OUT, START_MODE => START_MODE, DEFAULT_SCORE => DEFAULT_SCORE);
                  
    datapath : g05_mastermind_datapath
        port map (P_SEL => P_SEL, GR_SEL => GR_SEL, SR_SEL => SR_SEL, GR_LD => GR_LD, SR_LD => SR_LD,
                  TM_IN => TM_IN, TM_OUT => TM_OUT, TM_EN => TM_EN, TC_RST => TC_RST, TC_EN => TC_EN, EXT_PATTERN => ext_pattern,
                  EXT_SCORE => encoded_score, MODE => mode, CLK => clk, TC_LAST => TC_LAST, SC_CMP => SC_CMP, 
                  DIS_P1 => DIS_P1, DIS_P2 => DIS_P2, DIS_P3 => DIS_P3, DIS_P4 => DIS_P4, DIS_P5 => tmp_P5, DIS_P6 => tmp_P6, START_MODE => START_MODE);
    
    process(clk, START_MODE)
    begin
        if START_MODE = '0' then
            if rising_edge(clk) then
                if DEFAULT_SCORE = '0' then
                    if MODE = '1' then
                        DIS_P5 <= tmp_P5;
                        DIS_P6 <= tmp_P6;
                    else
                        DIS_P5 <= '0' & color_matches;
                        DIS_P6 <= '0' & exact_matches;
                    end if;
                else
                    DIS_P5 <= "0000";
                    DIS_P6 <= "0000";
                end if;
            end if;
        end if;
    end process;
    
    segment1 : g05_7_segment_decoder
        port map (code => DIS_P1, RippleBlank_In => '0', segments => seg_1);
        
    segment2 : g05_7_segment_decoder
        port map (code => DIS_P2, RippleBlank_In => '0', segments => seg_2);
        
    segment3 : g05_7_segment_decoder
        port map (code => DIS_P3, RippleBlank_In => '0', segments => seg_3);
           
    segment4 : g05_7_segment_decoder
        port map (code => DIS_P4, RippleBlank_In => '0', segments => seg_4);
        
    segment5 : g05_7_segment_decoder
        port map (code => DIS_P5, RippleBlank_In => '0', segments => seg_5);
           
    segment6 : g05_7_segment_decoder
        port map (code => DIS_P6, RippleBlank_In => '0', segments => seg_6);

end behavior;