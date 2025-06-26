library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DTPH_testbench is
end DTPH_testbench;

architecture Behavioral of DTPH_testbench is
constant clk_period     : time := 100 ns;
signal clk              : std_logic := '0';
signal disp_seg_o       : std_logic_vector(6 downto 0);
signal disp_an_o        : std_logic_vector(7 downto 0);

component datapath
    port(
        clk         : in std_logic;
        sw_i        : in std_logic_vector(15 downto 0);
        disp_seg_o  : out std_logic_vector(6 downto 0);
        disp_an_o   : out std_logic_vector(7 downto 0)
    );
end component;

begin

    datapath_inst : datapath
    port map(
        clk         => clk,
        sw_i        => "0000000000000100",
        disp_seg_o  => disp_seg_o,
        disp_an_o   => disp_an_o);
    
    process
    begin
        clk         <= '0';
        wait for clk_period/2;
        clk         <= '1';
        wait for clk_period/2;
    end process;
end Behavioral;
