library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_IE is
    Port ( 
        clk             : in std_logic;
        curr_pc_id      : in std_logic_vector(31 downto 0); 
        next_pc_id      : in std_logic_vector(31 downto 0); 
        op_class_id     : in std_logic_vector(5 downto 0); 
        funct3_id       : in std_logic_vector(2 downto 0); 
        funct7_id       : in std_logic_vector(6 downto 0); 
        a_sel_id        : in std_logic; 
        b_sel_id        : in std_logic; 
        imm_se_id       : in std_logic_vector(31 downto 0); 
        rs1_value_id    : in std_logic_vector(31 downto 0); 
        rs2_value_id    : in std_logic_vector(31 downto 0); 
        rd_addr_id      : in std_logic_vector(4 downto 0); 
        rs1_addr_id     : in std_logic_vector(4 downto 0); 
        rs2_addr_id     : in std_logic_vector(4 downto 0);
        cond_opcode_id  : in std_logic_vector(2 downto 0);
        
        curr_pc_ie      : out std_logic_vector(31 downto 0); 
        next_pc_ie      : out std_logic_vector(31 downto 0); 
        op_class_ie     : out std_logic_vector(5 downto 0); 
        funct3_ie       : out std_logic_vector(2 downto 0); 
        funct7_ie       : out std_logic_vector(6 downto 0); 
        a_sel_ie        : out std_logic; 
        b_sel_ie        : out std_logic; 
        imm_se_ie       : out std_logic_vector(31 downto 0); 
        rs1_value_ie    : out std_logic_vector(31 downto 0); 
        rs2_value_ie    : out std_logic_vector(31 downto 0); 
        rd_addr_ie      : out std_logic_vector(4 downto 0); 
        rs1_addr_ie     : out std_logic_vector(4 downto 0); 
        rs2_addr_ie     : out std_logic_vector(4 downto 0); 
        cond_opcode_ie  : out std_logic_vector(2 downto 0)
    );
end ID_IE;

architecture Behavioral of ID_IE is
signal curr_pc_reg      : std_logic_vector(31 downto 0) := (others => '0'); 
signal next_pc_reg      : std_logic_vector(31 downto 0) := (others => '0'); 
signal op_class_reg     : std_logic_vector(5 downto 0) := (others => '0'); 
signal funct3_reg       : std_logic_vector(2 downto 0) := (others => '0'); 
signal funct7_reg       : std_logic_vector(6 downto 0) := (others => '0'); 
signal a_sel_reg        : std_logic := '0'; 
signal b_sel_reg        : std_logic := '0'; 
signal imm_se_reg       : std_logic_vector(31 downto 0) := (others => '0'); 
signal rs1_value_reg    : std_logic_vector(31 downto 0) := (others => '0'); 
signal rs2_value_reg    : std_logic_vector(31 downto 0) := (others => '0'); 
signal rd_addr_reg      : std_logic_vector(4 downto 0) := (others => '0'); 
signal rs1_addr_reg     : std_logic_vector(4 downto 0) := (others => '0'); 
signal rs2_addr_reg     : std_logic_vector(4 downto 0) := (others => '0'); 
signal cond_opcode_reg  : std_logic_vector(2 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            curr_pc_reg         <= curr_pc_id;
            next_pc_reg         <= next_pc_id;
            op_class_reg        <= op_class_id;
            funct3_reg          <= funct3_id;
            funct7_reg          <= funct7_id;
            a_sel_reg           <= a_sel_id;
            b_sel_reg           <= b_sel_id;
            imm_se_reg          <= imm_se_id;
            rs1_value_reg       <= rs1_value_id;
            rs2_value_reg       <= rs2_value_id;
            rd_addr_reg         <= rd_addr_id;
            rs1_addr_reg        <= rs1_addr_id;
            rs2_addr_reg        <= rs2_addr_id;
            cond_opcode_reg     <= cond_opcode_id;
        end if;
    end process;
    
    curr_pc_ie          <= curr_pc_reg;
    next_pc_ie          <= next_pc_reg;
    op_class_ie         <= op_class_reg;
    funct3_ie           <= funct3_reg;
    funct7_ie           <= funct7_reg;
    a_sel_ie            <= a_sel_reg;
    b_sel_ie            <= b_sel_reg;
    imm_se_ie           <= imm_se_reg;
    rs1_value_ie        <= rs1_value_reg;
    rs2_value_ie        <= rs2_value_reg;
    rd_addr_ie          <= rd_addr_reg;
    rs1_addr_ie         <= rs1_addr_reg;
    rs2_addr_ie         <= rs2_addr_reg;
    cond_opcode_ie      <= cond_opcode_reg;
end Behavioral;
