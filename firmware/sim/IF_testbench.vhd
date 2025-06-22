library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IF_testbench is
end IF_testbench;

architecture Behavioral of IF_testbench is
    constant clk_period     : time := 20 ns;
    signal pc_in            : std_logic_vector(31 downto 0) := (others => '0');
    signal pc_load_en       : std_logic := '1';
    signal next_pc          : std_logic_vector(31 downto 0) := (others => '0');
    signal curr_pc          : std_logic_vector(31 downto 0) := (others => '0');
    signal instr            : std_logic_vector(31 downto 0) := (others => '0');
    signal clk              : std_logic := '0';
    
    component instr_fetch
        port ( 
            clk         : in std_logic;
            pc_load_en  : in std_logic;
            pc_in       : in std_logic_vector(31 downto 0);
            next_pc     : out std_logic_vector(31 downto 0);
            curr_pc     : out std_logic_vector(31 downto 0);
            instr       : out std_logic_vector(31 downto 0));
    end component;
begin
    if_inst : instr_fetch
        port map (
            clk         => clk,
            pc_load_en  => pc_load_en,
            pc_in       => pc_in,
            next_pc     => next_pc,
            curr_pc     => curr_pc,
            instr       => instr);
    
    process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process; 
    
    pc_in       <= next_pc;
end Behavioral;
