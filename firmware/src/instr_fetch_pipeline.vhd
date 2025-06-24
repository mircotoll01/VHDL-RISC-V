library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_fetch_pipeline is
    port ( 
        clk         : in std_logic;
        pc_load_en  : in std_logic;
        pc_in       : in std_logic_vector(31 downto 0);
        pc_stall    : in std_logic;
        
        next_pc     : out std_logic_vector(31 downto 0);
        curr_pc     : out std_logic_vector(31 downto 0);
        instr       : out std_logic_vector(31 downto 0));
end instr_fetch_pipeline;

architecture Structural of instr_fetch_pipeline is
    signal pc_reg  : unsigned(31 downto 0) := (others => '0');

    component instruction_memory
    port(
        clka        : in std_logic;
        wea         : in std_logic;
        addra       : in std_logic_vector(11 downto 0);
        dina        : in std_logic_vector(31 downto 0);
        douta       : out std_logic_vector(31 downto 0));
    end component;
begin
    instr_mem: instruction_memory 
    port map(
        clka        => clk,
        wea         => '0',
        dina        => (others => '0'),
        addra       => std_logic_vector(pc_reg(13 downto 2)),
        douta       => instr);
    
    process (clk)
    begin
        if rising_edge(clk) then
            if pc_stall = '1' then
                pc_reg  <= pc_reg;
            elsif pc_load_en = '1' then
                pc_reg  <= unsigned(pc_in);
            else
                pc_reg <= pc_reg + 4;
            end if;
        end if;
    end process;
    next_pc     <= std_logic_vector(pc_reg + 4);
    curr_pc     <= std_logic_vector(pc_reg);
end Structural;
