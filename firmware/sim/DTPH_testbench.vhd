library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity DTPH_testbench is
end DTPH_testbench;

architecture Behavioral of DTPH_testbench is
constant clk_period     : time := 100 ns;
signal clk              : std_logic := '0';

component datapath
    port(
        clk     : std_logic
    );
end component;

begin

    datapath_inst : datapath
    port map(
        clk         => clk
    );
    
    process
    begin
        clk         <= '0';
        wait for clk_period/2;
        clk         <= '1';
        wait for clk_period/2;
    end process;
end Behavioral;
