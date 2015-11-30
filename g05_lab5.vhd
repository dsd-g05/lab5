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
        clk : in std_logic
	);
end g05_lab5;

architecture behavior of g05_lab5 is

	component g05_mastermind_controller is
		port (
            SC_CMP, TC_LAST : in std_logic;
            START, READY : in std_logic;
            MODE : in std_logic;
            CLK : in std_logic;
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
            CLK : in std_logic;
            TC_LAST : out std_logic;
            SC_CMP : out std_logic
		);
	end component;
	
    signal P_SEL, GR_SEL, SR_SEL : std_logic;
    signal GR_LD, SR_LD : std_logic;
    signal TM_IN, TM_EN, TC_RST, TC_EN : std_logic;
    signal TC_LAST : std_logic;
    signal SC_CMP : std_logic;
    signal SOLVED : std_logic;
    
	component g05_pattern_input is
		port (
            increment, sel : in std_logic;
            seg_code : out std_logic_vector(3 downto 0);
            segment : out std_logic_vector(1 downto 0)
		);
	end component;
    
    signal seg_code : std_logic_vector(3 downto 0);
    signal segment : std_logic_vector(1 downto 0);
    signal ext_p1, ext_p2, ext_p3, ext_p4;
    
begin

	pattern_input : g05_pattern_input
        port map (increment => increment, sel => sel,
                  seg_code => seg_code, segment => segment);
    
    ext_p1 <= seg_code when segment = "00";
    ext_p2 <= seg_code when segment = "01";
    ext_p3 <= seg_code when segment = "10";
    ext_p4 <= seg_code when segment = "11";
    
    ext_pattern = ext_p1 & ext_p2 & ext_p3 & ext_p4;
    
    process(clk)
    begin
        if (rising_edge(clk)) then
            if (mode = '0') then
            else
                
            end if;
        end if;
    end process;
    
    controller : g05_mastermind_controller
        port map (SC_CMP => SC_CMP, TC_LAST => TC_LAST, START => start, READY => ready,
                  MODE => mode, CLK => clk, SR_SEL => SR_SEL, P_SEL => P_SEL, GR_SEL => GR_SEL,
                  GR_LD => GR_LD, SR_LD => SR_LD, TM_IN => TM_IN, TM_EN => TM_EN, TC_EN => TC_EN,
                  TC_RST => TC_RST, SOLVED => SOLVED);
                  
    datapath : g05_mastermind_datapath
        port map (P_SEL => P_SEL, GR_SEL => GR_SEL, SR_SEL => SR_SEL, GR_LD => GR_LD, SR_LD => SR_LD,
                  TM_IN => TM_IN, TM_EN => TM_EN, TC_RST => TC_RST, TC_EN => TC_EN, EXT_PATTERN => ext_pattern,
                  CLK => clk, TC_LAST => TC_LAST, SC_CMP => SC_CMP);

end behavior;