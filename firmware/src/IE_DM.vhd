library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
entity IE_DM is
    Port ( 
        clk             : in std_logic;
        flush           : in std_logic;
        curr_pc_ie      : in std_logic_vector(31 downto 0); 
        next_pc_ie      : in std_logic_vector(31 downto 0); 
        op_class_ie     : in std_logic_vector(5 downto 0); 
        funct3_ie       : in std_logic_vector(2 downto 0); 
        alu_result_ie   : in std_logic_vector(31 downto 0); 
        rs2_value_ie    : in std_logic_vector(31 downto 0); 
        rd_addr_ie      : in std_logic_vector(4 downto 0); 
        branch_cond_ie  : in std_logic;
        
        curr_pc_dm      : out std_logic_vector(31 downto 0); 
        next_pc_dm      : out std_logic_vector(31 downto 0); 
        op_class_dm     : out std_logic_vector(5 downto 0); 
        funct3_dm       : out std_logic_vector(2 downto 0); 
        alu_result_dm   : out std_logic_vector(31 downto 0); 
        rs2_value_dm    : out std_logic_vector(31 downto 0); 
        rd_addr_dm      : out std_logic_vector(4 downto 0); 
        branch_cond_dm  : out std_logic
    );
end IE_DM;

architecture Behavioral of IE_DM is
    signal curr_pc_reg      : std_logic_vector(31 downto 0) := (others => '0'); 
    signal next_pc_reg      : std_logic_vector(31 downto 0) := (others => '0'); 
    signal op_class_reg     : std_logic_vector(5 downto 0)  := (others => '0'); 
    signal funct3_reg       : std_logic_vector(2 downto 0)  := (others => '0'); 
    signal alu_result_reg   : std_logic_vector(31 downto 0) := (others => '0'); 
    signal rs2_value_reg    : std_logic_vector(31 downto 0) := (others => '0'); 
    signal rd_addr_reg      : std_logic_vector(4 downto 0)  := (others => '0'); 
    signal branch_cond_reg  : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if flush = '1' then
                curr_pc_reg         <= (others => '0');
                next_pc_reg         <= (others => '0');
                op_class_reg        <= (others => '0');
                funct3_reg          <= (others => '0');
                alu_result_reg      <= (others => '0');
                rs2_value_reg       <= (others => '0');
                rd_addr_reg         <= (others => '0');
                branch_cond_reg     <= '0';
            else
                curr_pc_reg         <= curr_pc_ie;
                next_pc_reg         <= next_pc_ie;
                op_class_reg        <= op_class_ie;
                funct3_reg          <= funct3_ie;
                alu_result_reg      <= alu_result_ie;
                rs2_value_reg       <= rs2_value_ie;
                rd_addr_reg         <= rd_addr_ie;
                branch_cond_reg     <= branch_cond_ie;
            end if;
            
        end if;
    end process;
    curr_pc_dm          <= curr_pc_reg;
    next_pc_dm          <= next_pc_reg;
    op_class_dm         <= op_class_reg;
    funct3_dm           <= funct3_reg;
    alu_result_dm       <= alu_result_reg;
    rs2_value_dm        <= rs2_value_reg;
    rd_addr_dm          <= rd_addr_reg;
    branch_cond_dm      <= branch_cond_reg;
end Behavioral;
