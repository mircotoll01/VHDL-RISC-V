library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_exec_pipeline is
    Port (
        a_sel           : in std_logic;
        b_sel           : in std_logic;    
        rs1_value_in    : in std_logic_vector(31 downto 0);
        rs2_value_in    : in std_logic_vector(31 downto 0);
        imm_se          : in std_logic_vector(31 downto 0);
        curr_pc         : in std_logic_vector(31 downto 0);
        cond_opcode     : in std_logic_vector(2 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        funct7          : in std_logic_vector(6 downto 0);
        op_class        : in std_logic_vector(5 downto 0);
        
        -- operand forwarding inputs
        rs1_addr_in     : in std_logic_vector(4 downto 0);
        rs2_addr_in     : in std_logic_vector(4 downto 0);
        rd_addr_dm      : in std_logic_vector(4 downto 0);      
        alu_result_dm   : in std_logic_vector(31 downto 0);
        rd_addr_wb      : in std_logic_vector(4 downto 0);      
        alu_result_wb   : in std_logic_vector(31 downto 0);
        op_class_dm     : in std_logic_vector(5 downto 0);
        op_class_wb     : in std_logic_vector(5 downto 0);
        
        branch_cond     : out std_logic;
        rs2_value_out   : out std_logic_vector(31 downto 0);
        alu_result      : out std_logic_vector(31 downto 0)
     );
end instr_exec_pipeline;

architecture Structural of instr_exec_pipeline is
    signal first_operand    : std_logic_vector(31 downto 0) := (others => '0');
    signal second_operand   : std_logic_vector(31 downto 0) := (others => '0');
    signal rs1_fw   : std_logic_vector(31 downto 0) := (others => '0');
    signal rs2_fw   : std_logic_vector(31 downto 0) := (others => '0');

    component ALU is
        port (
            first_operand   : in std_logic_vector(31 downto 0);
            second_operand  : in std_logic_vector(31 downto 0);
            funct3          : in std_logic_vector(2 downto 0);
            funct7          : in std_logic_vector(6 downto 0);
            op_class        : in std_logic_vector(5 downto 0);
            
            alu_result      : out std_logic_vector(31 downto 0));
    end component;
    
    component comparator is
        port ( 
            first_operand   : in std_logic_vector(31 downto 0);
            second_operand  : in std_logic_vector(31 downto 0);
            cond_opcode     : in std_logic_vector(2 downto 0);
            
            branch_cond     : out std_logic);
    end component;
    
    component forwarding_unit is
        port ( 
            rs1             : in std_logic_vector(31 downto 0);
            rs2             : in std_logic_vector(31 downto 0);
            alu_res_dm      : in std_logic_vector(31 downto 0);
            alu_res_wb      : in std_logic_vector(31 downto 0);
            rs1_addr        : in std_logic_vector(4 downto 0);
            rs2_addr        : in std_logic_vector(4 downto 0);
            rd_addr_dm      : in std_logic_vector(4 downto 0);
            rd_addr_wb      : in std_logic_vector(4 downto 0);
            op_class_ie     : in std_logic_vector(5 downto 0);
            op_class_dm     : in std_logic_vector(5 downto 0);    
            op_class_wb     : in std_logic_vector(5 downto 0);
            a_sel           : in std_logic;
            b_sel           : in std_logic;
            imm_se          : in std_logic_vector(31 downto 0);
            curr_pc         : in std_logic_vector(31 downto 0);
            
            rs2_fw          : out std_logic_vector(31 downto 0);
            first_operand   : out std_logic_vector(31 downto 0);  
            second_operand  : out std_logic_vector(31 downto 0));
    end component;
begin
    comp : comparator 
    port map(
        first_operand   => rs1_value_in,
        second_operand  => rs2_value_in,
        cond_opcode     => cond_opcode,
        branch_cond     => branch_cond); 
    
    alu_1 : ALU
    port map(
        first_operand   => first_operand,
        second_operand  => second_operand,
        funct3          => funct3,
        funct7          => funct7,
        op_class        => op_class,
         
        alu_result      => alu_result);
     
    rs1_fw          <= alu_result_wb when (rd_addr_wb = rs1_addr_in) 
                        else alu_result_dm when (rd_addr_dm = rs1_addr_in)
                        else rs1_value_in;
    rs2_fw          <= alu_result_wb when (rd_addr_wb = rs2_addr_in)
                        else alu_result_dm when (rd_addr_dm = rs2_addr_in) 
                        else rs2_value_in;
    first_operand   <= rs1_fw when a_sel = '1' else curr_pc;
    second_operand  <= rs2_fw when b_sel = '1' else imm_se;
    rs2_value_out   <= rs2_fw;
end Structural;
