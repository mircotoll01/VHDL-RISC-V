library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DM_WB is
    Port (
        clk             : in std_logic;
        next_pc_dm      : in std_logic_vector(31 downto 0); 
        mem_out_dm      : in std_logic_vector(31 downto 0); 
        alu_result_dm   : in std_logic_vector(31 downto 0); 
        rd_addr_dm      : in std_logic_vector(4 downto 0); 
        branch_cond_dm  : in std_logic;
        op_class_dm     : in std_logic_vector(5 downto 0);
        
        next_pc_wb      : out std_logic_vector(31 downto 0); 
        mem_out_wb      : out std_logic_vector(31 downto 0); 
        alu_result_wb   : out std_logic_vector(31 downto 0); 
        rd_addr_wb      : out std_logic_vector(4 downto 0); 
        branch_cond_wb  : out std_logic;
        op_class_wb     : out std_logic_vector(5 downto 0)
    );
end DM_WB;

architecture Behavioral of DM_WB is
signal next_pc_reg      : std_logic_vector(31 downto 0) := (others => '0');
signal mem_out_reg      : std_logic_vector(31 downto 0) := (others => '0');
signal alu_result_reg   : std_logic_vector(31 downto 0) := (others => '0');
signal rd_addr_reg      : std_logic_vector(4 downto 0) := (others => '0');
signal branch_cond_reg  : std_logic := '0';
signal op_class_reg     : std_logic_vector(5 downto 0):= (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            next_pc_reg     <= next_pc_dm;
            mem_out_reg     <= mem_out_dm;
            alu_result_reg  <= alu_result_dm;
            rd_addr_reg     <= rd_addr_dm;
            branch_cond_reg <= branch_cond_dm;
            op_class_reg    <= op_class_dm;
        end if;
    end process;
    next_pc_wb   <= next_pc_reg;
    mem_out_wb      <= mem_out_reg;
    alu_result_wb   <= alu_result_reg;
    rd_addr_wb      <= rd_addr_reg;
    branch_cond_wb  <= branch_cond_reg;
    op_class_wb     <= op_class_reg;
end Behavioral;
