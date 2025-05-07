library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_decode is
    Port (
        clk         : in std_logic;
        instr       : in std_logic_vector(31 downto 0);
        next_pc     : in std_logic_vector(11 downto 0);
        curr_pc     : in std_logic_vector(11 downto 0);
        
        -- Inputs from mem writeback
        
        rd_write_en : in std_logic;
        rd_value    : in std_logic_vector(31 downto 0);
        
        -- sign-extended pc info
        
        next_pc_ze  : out std_logic_vector(31 downto 0);
        curr_pc_ze  : out std_logic_vector(31 downto 0);
        
        -- Decoded instruction informations
        
        op_class    : out std_logic_vector(4 downto 0);
        funct3      : out std_logic_vector(2 downto 0);
        funct7      : out std_logic_vector(6 downto 0);
        a_sel       : out std_logic;
        b_sel       : out std_logic;
        cond_opcode : out std_logic_vector(2 downto 0);
        
        -- Data to be elaborated
        
        rs1_value   : out std_logic_vector(31 downto 0);
        rs2_value   : out std_logic_vector(31 downto 0);
        imm_se      : out std_logic_vector(31 downto 0)
    );
end instr_decode;

architecture Structural of instr_decode is
    signal rd_rs1_mux       : std_logic_vector(4 downto 0) := (others => '0');
    signal next_pc_ze_reg   : std_logic_vector(31 downto 0) := (others => '0');
    signal curr_pc_ze_reg   : std_logic_vector(31 downto 0) := (others => '0');
        
    component register_file is
    port(
        clk         : in std_logic;
        we          : in std_logic;
        a           : in std_logic_vector(4 downto 0);
        d           : in std_logic_vector(31 downto 0);
        dpra        : in std_logic_vector(4 downto 0);
        qspo        : out std_logic_vector(31 downto 0);
        qdpo        : out std_logic_vector(31 downto 0));
    end component;
    
    component decoder is
    port(
        instr       : in std_logic_vector(31 downto 0);
        op_class    : out std_logic_vector(4 downto 0);
        funct3      : out std_logic_vector(2 downto 0);
        funct7      : out std_logic_vector(6 downto 0);
        a_sel       : out std_logic;
        b_sel       : out std_logic;
        cond_opcode : out std_logic_vector(2 downto 0);
        imm_se      : out std_logic_vector(31 downto 0));
    end component;
begin
    reg : register_file
    port map(
        clk         => clk,
        we          => rd_write_en,
        d           => rd_value,
        a           => rd_rs1_mux,
        dpra        => instr(24 downto 20),
        qspo        => rs1_value,
        qdpo        => rs2_value);
    
    dec : decoder
    port map(
        instr       => instr,
        op_class    => op_class,
        funct3      => funct3,
        funct7      => funct7,
        a_sel       => a_sel,
        b_sel       => b_sel,
        cond_opcode => cond_opcode,
        imm_se      => imm_se);
     
    rd_rs1_mux  <= instr(11 downto 7) when rd_write_en = '1' else instr(19 downto 15);
    next_pc_ze  <= std_logic_vector(resize(unsigned(next_pc), next_pc_ze_reg'length));
    curr_pc_ze  <= std_logic_vector(resize(unsigned(curr_pc), next_pc_ze_reg'length));
end Structural;
