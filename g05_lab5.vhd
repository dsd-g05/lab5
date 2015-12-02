-- Descp. mastermind datapath
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
        START, READY : in std_logic;
		sel, increment : in std_logic;
        MODE : in std_logic;
        CLK : in std_logic;
        SEG_1, SEG_2, SEG_3, SEG_4, SEG_5, SEG_6 : out std_logic_vector(6 downto 0)
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
            SR_SEL, P_SEL, GR_SEL : out std_logic; 
            GR_LD, SR_LD : out std_logic;
            TM_IN, TM_EN, TC_EN, TC_RST : out std_logic; 
            SOLVED : out std_logic
		);
	end component;
	
    signal P_SEL, GR_SEL, SR_SEL : std_logic;
    signal GR_LD, SR_LD : std_logic;
    signal TM_IN, TM_OUT, TM_EN, TC_RST, TC_EN : std_logic;
    signal TC_LAST : std_logic;
    signal SC_CMP : std_logic;
    signal SOLVED : std_logic;
    signal START_MODE : std_logic;
    
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

    component g05_color_decoder is
        port (
            color : in std_logic_vector(2 downto 0);
            color_code : out std_logic_vector(3 downto 0)
        );
    end component;

    component g05_score_decoder is
        port (
            score_code : in std_logic_vector(3 downto 0);
            num_exact_matches, num_color_matches : out std_logic_vector(3 downto 0)
        );
    end component;
        
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
    
    signal score_input : std_logic_vector(2 downto 0);
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
    
    signal P1, P2, P3, P4 : std_logic_vector(2 downto 0);
    signal G1, G2, G3, G4 : std_logic_vector(2 downto 0);
    signal TM_ADDR : std_logic_vector(11 downto 0);
    signal score, score_reg, SR : std_logic_vector(3 downto 0);
    signal G1_code, G2_code, G3_code, G4_code, P1_code, P2_code, P3_code, P4_code : std_logic_vector(3 downto 0);
    
    signal score_reg_color, score_reg_exact : std_logic_vector(3 downto 0);
    signal DIS_P1, DIS_P2, DIS_P3, DIS_P4, DIS_P5, DIS_P6 : std_logic_vector(3 downto 0);
    
begin

    -- user input
    
	pattern_input : g05_pattern_input
        port map (increment => increment, sel => sel,
                  seg_code => seg_code, segment => segment);
    
    ext_p1 <= seg_code when segment = "00";
    ext_p2 <= seg_code when segment = "01";
    ext_p3 <= seg_code when segment = "10";
    ext_p4 <= seg_code when segment = "11";
    
    ext_pattern <= ext_p1 & ext_p2 & ext_p3 & ext_p4;
    
    user_score : g05_score_input
        port map (increment => increment, sel => sel,
                  score => score_input, score_part => score_part);
                  
    exact_matches <= score_input when score_part = '1';
    color_matches <= score_input when score_part = '0';
    
    --------------------------------------------------------
    -- datapath
    
    controller : g05_mastermind_controller
        port map (SC_CMP => SC_CMP, TC_LAST => TC_LAST, START => start, READY => READY,
                  MODE => MODE, CLK => CLK, SR_SEL => SR_SEL, P_SEL => P_SEL, GR_SEL => GR_SEL,
                  GR_LD => GR_LD, SR_LD => SR_LD, TM_IN => TM_IN, TM_EN => TM_EN, TC_EN => TC_EN,
                  TC_RST => TC_RST, SOLVED => SOLVED, TM_OUT => TM_OUT, START_MODE => START_MODE);
    
    P4 <= ext_pattern(2 downto 0) when P_SEL = '0' else TM_ADDR(2 downto 0);
    P3 <= ext_pattern(5 downto 3) when P_SEL = '0' else TM_ADDR(5 downto 3);
    P2 <= ext_pattern(8 downto 6) when P_SEL = '0' else TM_ADDR(8 downto 6);
    P1 <= ext_pattern(11 downto 9) when P_SEL = '0' else TM_ADDR(11 downto 9);
    
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
                  
    encoder : g05_score_encoder
        port map (num_exact_matches => exact_matches, num_color_matches => color_matches,
                  score_code => encoded_score);
                  
    process(CLK)
    begin
        if rising_edge(CLK) then
            if SR_LD = '1' then
                if MODE = '0' then
                    score_reg <= encoded_score;
                else
                    score_reg <= score;
                end if;
            end if;
        end if;
    end process;
    
    decode : g05_score_decoder
        port map (score_code => score_reg, num_exact_matches => score_reg_exact, num_color_matches => score_reg_color);
    
    SR <= score when SR_SEL = '0' else "0000";
    
    score_comp : g05_comp6
        port map (A(5 downto 4) => "00", A(3 downto 0) => score_reg,
                  B(5 downto 4) => "00", B(3 downto 0) => SR, AeqB => SC_CMP);
                  
    possibility_table : g05_possibility_table
        port map (TC_EN => TC_EN, TC_RST => TC_RST, TM_IN => TM_IN,
                  TM_EN => TM_EN, CLK => CLK, TC_LAST => TC_LAST, 
                  TM_ADDR => TM_ADDR, TM_OUT => TM_OUT);
                  
    -----------------------------------------------
    -- display
    
     G1_decode : g05_color_decoder
        port map (color => G1, color_code => G1_code);

    G2_decode : g05_color_decoder
        port map (color => G2, color_code => G2_code);
    
    G3_decode : g05_color_decoder
        port map (color => G3, color_code => G3_code);    
        
    G4_decode : g05_color_decoder
        port map (color => G4, color_code => G4_code);    
        
    P1_decode : g05_color_decoder
        port map (color => P1, color_code => P1_code);    
    
    P2_decode : g05_color_decoder
        port map (color => P2, color_code => P2_code);
        
    P3_decode : g05_color_decoder
        port map (color => P3, color_code => P3_code);
    
    P4_decode : g05_color_decoder
        port map (color => P4, color_code => P4_code);
    
    process(CLK)
    begin
        if (rising_edge(CLK)) then
            if START_MODE = '0' then
                if MODE = '0' then
                    DIS_P1 <= G1_code;
                    DIS_P2 <= G2_code;
                    DIS_P3 <= G3_code;
                    DIS_P4 <= G4_code;
                    DIS_P5 <= '0' & color_matches;
                    DIS_P6 <= '0' & exact_matches;
                else
                    DIS_P1 <= P1_code;
                    DIS_P2 <= P2_code;
                    DIS_P3 <= P3_code;
                    DIS_P4 <= P4_code;
                    DIS_P5 <= score_reg_color;
                    DIS_P6 <= score_reg_exact;
                end if;  
            else
                DIS_P1 <= "0000"; --
                DIS_P2 <= "0101"; -- S
                DIS_P3 <= "0111"; -- T
                DIS_P4 <= "1000"; -- A
                DIS_P5 <= "1011"; -- R
                DIS_P6 <= "0111"; -- T
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
        port map (code => DIS_P6, RippleBlank_In => START_MODE, segments => seg_6);

end behavior;