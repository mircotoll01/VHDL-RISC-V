library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IE_testbench is
end IE_testbench;

architecture Behavioral of IE_testbench is
constant clk_period     : time := 100 ns;
signal pc_in            : std_logic_vector(31 downto 0) := (others => '0');
signal next_pc          : std_logic_vector(31 downto 0) := (others => '0');
signal next_pc_reg      : std_logic_vector(31 downto 0) := (others => '0');
signal curr_pc          : std_logic_vector(31 downto 0) := (others => '0');
signal instr            : std_logic_vector(31 downto 0) := (others => '0');
signal clk              : std_logic := '0';
signal pc_load_en       : std_logic := '1';

signal rd_write_en      : std_logic := '0';
signal rd_value         : std_logic_vector(31 downto 0) := (others => '0');
signal rd_addr_in       : std_logic_vector(4 downto 0) := (others => '0');
signal rd_addr_out      : std_logic_vector(4 downto 0) := (others => '0');
signal op_class         : std_logic_vector(5 downto 0) := (others => '0');
signal funct3           : std_logic_vector(2 downto 0) := (others => '0');
signal funct7           : std_logic_vector(6 downto 0) := (others => '0');
signal a_sel            : std_logic := '0';
signal b_sel            : std_logic := '0';
signal cond_opcode      : std_logic_vector(2 downto 0) := (others => '0');
signal rs1_value        : std_logic_vector(31 downto 0) := (others => '0');
signal rs2_value        : std_logic_vector(31 downto 0) := (others => '0');
signal imm_se           : std_logic_vector(31 downto 0) := (others => '0');

signal branch_cond      : std_logic := '0';
signal alu_result       : std_logic_vector(31 downto 0) := (others => '0');

component instr_fetch
    port ( 
        clk             : in std_logic;
        pc_load_en      : in std_logic;
        pc_in           : in std_logic_vector(31 downto 0);
        next_pc         : out std_logic_vector(31 downto 0);
        curr_pc         : out std_logic_vector(31 downto 0);
        instr           : out std_logic_vector(31 downto 0));
end component;

component instr_decode
    port (
        clk             : in std_logic;
        instr           : in std_logic_vector(31 downto 0);
        rd_write_en     : in std_logic;
        rd_value        : in std_logic_vector(31 downto 0);
        rd_addr_in      : in std_logic_vector(4 downto 0);
        op_class        : out std_logic_vector(5 downto 0);
        funct3          : out std_logic_vector(2 downto 0);
        funct7          : out std_logic_vector(6 downto 0);
        a_sel           : out std_logic;
        b_sel           : out std_logic;
        cond_opcode     : out std_logic_vector(2 downto 0);
        rd_addr_out     : out std_logic_vector(4 downto 0);
        rs1_value       : out std_logic_vector(31 downto 0);
        rs2_value       : out std_logic_vector(31 downto 0);
        imm_se          : out std_logic_vector(31 downto 0));
end component;
    
component instr_exec
    port(
        a_sel           : in std_logic;
        b_sel           : in std_logic;    
        rs1_value       : in std_logic_vector(31 downto 0);
        rs2_value       : in std_logic_vector(31 downto 0);
        imm_se          : in std_logic_vector(31 downto 0);
        curr_pc         : in std_logic_vector(31 downto 0);
        cond_opcode     : in std_logic_vector(2 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        funct7          : in std_logic_vector(6 downto 0);
        op_class        : in std_logic_vector(5 downto 0);
        branch_cond     : out std_logic;
        alu_result      : out std_logic_vector(31 downto 0));
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
    id_inst : instr_decode
        port map (
            clk         => clk,
            instr       => instr,
            rd_write_en => rd_write_en,
            rd_value    => rd_value,
            rd_addr_in  => rd_addr_in,
            op_class    => op_class,
            funct3      => funct3,
            funct7      => funct7,
            a_sel       => a_sel,
            b_sel       => b_sel,
            cond_opcode => cond_opcode,
            rd_addr_out => rd_addr_out,
            rs1_value   => rs1_value,
            rs2_value   => rs2_value,
            imm_se      => imm_se);
    ie_inst : instr_exec
        port map(
            a_sel       => a_sel,
            b_sel       => b_sel,
            rs1_value   => rs1_value,
            rs2_value   => rs2_value,
            imm_se      => imm_se,
            curr_pc  => curr_pc,
            cond_opcode => cond_opcode,
            funct3      => funct3,
            funct7      => funct7,
            op_class    => op_class,
            branch_cond => branch_cond,
            alu_result  => alu_result);
        
    process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    pc_in       <= next_pc;
end Behavioral;
