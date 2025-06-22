library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IF_ID is
    Port ( 
        clk         : in std_logic;
        curr_pc_if  : in std_logic_vector(31 downto 0); 
        next_pc_if  : in std_logic_vector(31 downto 0); 
        instr_if    : in std_logic_vector(31 downto 0); 
        
        curr_pc_id  : out std_logic_vector(31 downto 0); 
        next_pc_id  : out std_logic_vector(31 downto 0); 
        instr_id    : out std_logic_vector(31 downto 0)
    );
end IF_ID;

architecture Behavioral of IF_ID is
    signal curr_pc_reg  : std_logic_vector(31 downto 0) := (others => '0'); 
    signal next_pc_reg  : std_logic_vector(31 downto 0) := (others => '0'); 
    signal instr_reg    : std_logic_vector(31 downto 0) := (others => '0');
begin 
    process(clk)
    begin
        if rising_edge(clk) then
            curr_pc_reg <= curr_pc_if;
            next_pc_reg <= next_pc_if;
            instr_reg   <= instr_if;
        end if;
    end process;
    
    curr_pc_id  <= curr_pc_reg;
    next_pc_id  <= next_pc_reg;
    instr_id    <= instr_reg;
end Behavioral;
