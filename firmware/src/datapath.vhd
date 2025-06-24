library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    port(
        clk     : in std_logic
    );
end datapath;

architecture Structural of datapath is

signal next_pc_if       : std_logic_vector(31 downto 0) := (others => '0');
signal curr_pc_if       : std_logic_vector(31 downto 0) := (others => '0');
signal instr_if         : std_logic_vector(31 downto 0) := (others => '0');
signal instr_id         : std_logic_vector(31 downto 0) := (others => '0');

signal rd_write_en_wb   : std_logic := '0';
signal rd_value_wb      : std_logic_vector(31 downto 0) := (others => '0');
signal rd_addr_in_wb    : std_logic_vector(4 downto 0) := (others => '0');

signal flush_if_id      : std_logic := '0';
signal pc_stall         : std_logic := '0';

signal rd_addr_id       : std_logic_vector(4 downto 0) := (others => '0');
signal rs1_addr_id      : std_logic_vector(4 downto 0) := (others => '0');
signal rs2_addr_id      : std_logic_vector(4 downto 0) := (others => '0');
signal next_pc_id       : std_logic_vector(31 downto 0) := (others => '0');
signal curr_pc_id       : std_logic_vector(31 downto 0) := (others => '0');
signal op_class_id      : std_logic_vector(5 downto 0) := (others => '0');
signal funct3_id        : std_logic_vector(2 downto 0) := (others => '0');
signal funct7_id        : std_logic_vector(6 downto 0) := (others => '0');
signal a_sel_id         : std_logic := '0';
signal b_sel_id         : std_logic := '0';
signal cond_opcode_id   : std_logic_vector(2 downto 0) := (others => '0');
signal rs1_value_id     : std_logic_vector(31 downto 0) := (others => '0');
signal rs2_value_id     : std_logic_vector(31 downto 0) := (others => '0');
signal imm_se_id        : std_logic_vector(31 downto 0) := (others => '0');
signal rd_addr_ie       : std_logic_vector(4 downto 0) := (others => '0');
signal rs1_addr_ie      : std_logic_vector(4 downto 0) := (others => '0');
signal rs2_addr_ie      : std_logic_vector(4 downto 0) := (others => '0');
signal next_pc_ie       : std_logic_vector(31 downto 0) := (others => '0');
signal curr_pc_ie       : std_logic_vector(31 downto 0) := (others => '0');
signal op_class_ie      : std_logic_vector(5 downto 0) := (others => '0');
signal funct3_ie        : std_logic_vector(2 downto 0) := (others => '0');
signal funct7_ie        : std_logic_vector(6 downto 0) := (others => '0');
signal a_sel_ie         : std_logic := '0';
signal b_sel_ie         : std_logic := '0';
signal cond_opcode_ie   : std_logic_vector(2 downto 0) := (others => '0');
signal rs1_value_ie     : std_logic_vector(31 downto 0) := (others => '0');
signal rs2_value_ie     : std_logic_vector(31 downto 0) := (others => '0');
signal imm_se_ie        : std_logic_vector(31 downto 0) := (others => '0');

signal branch_cond_ie   : std_logic := '0';
signal alu_result_ie    : std_logic_vector(31 downto 0) := (others => '0');
signal rs2_value_out    : std_logic_vector(31 downto 0) := (others => '0');
signal branch_cond_dm   : std_logic := '0';
signal alu_result_dm    : std_logic_vector(31 downto 0) := (others => '0');
signal next_pc_dm       : std_logic_vector(31 downto 0) := (others => '0');
signal curr_pc_dm       : std_logic_vector(31 downto 0) := (others => '0');
signal op_class_dm      : std_logic_vector(5 downto 0) := (others => '0');
signal rs2_value_dm     : std_logic_vector(31 downto 0) := (others => '0');
signal funct3_dm        : std_logic_vector(2 downto 0) := (others => '0');
signal rd_addr_dm       : std_logic_vector(4 downto 0) := (others => '0');

signal mem_out_dm       : std_logic_vector(31 downto 0) := (others => '0');
signal next_pc_wb       : std_logic_vector(31 downto 0) := (others => '0');
signal mem_out_wb       : std_logic_vector(31 downto 0) := (others => '0');
signal alu_result_wb    : std_logic_vector(31 downto 0) := (others => '0');
signal rd_addr_wb       : std_logic_vector(4 downto 0) := (others => '0');
signal branch_cond_wb   : std_logic := '0';
signal op_class_wb      : std_logic_vector(5 downto 0) := (others => '0');

signal pc_out_wb        : std_logic_vector(31 downto 0) := (others => '0');
signal pc_load_en_wb    : std_logic := '0';


component instr_fetch_pipeline
    port ( 
        clk             : in std_logic;
        pc_load_en      : in std_logic;
        pc_in           : in std_logic_vector(31 downto 0);
        pc_stall        : in std_logic;
        next_pc         : out std_logic_vector(31 downto 0);
        curr_pc         : out std_logic_vector(31 downto 0);
        instr           : out std_logic_vector(31 downto 0));
end component;

component IF_ID
    port ( 
        clk             : in std_logic;
        flush           : in std_logic;
        curr_pc_if      : in std_logic_vector(31 downto 0); 
        next_pc_if      : in std_logic_vector(31 downto 0); 
        instr_if        : in std_logic_vector(31 downto 0);
        curr_pc_id      : out std_logic_vector(31 downto 0); 
        next_pc_id      : out std_logic_vector(31 downto 0); 
        instr_id        : out std_logic_vector(31 downto 0)
    );
end component;

component instr_decode_pipeline
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
        rs1_addr_out    : out std_logic_vector(4 downto 0);
        rs2_addr_out    : out std_logic_vector(4 downto 0);
        rs1_value       : out std_logic_vector(31 downto 0);
        rs2_value       : out std_logic_vector(31 downto 0);
        imm_se          : out std_logic_vector(31 downto 0));
end component;
    
component ID_IE
    Port ( 
        clk             : in std_logic;
        flush           : in std_logic;
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
        cond_opcode_ie  : out std_logic_vector(2 downto 0));
end component;

component instr_exec_pipeline
    port(
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
        rs1_addr_in     : in std_logic_vector(4 downto 0);
        rs2_addr_in     : in std_logic_vector(4 downto 0);
        rd_addr_dm      : in std_logic_vector(4 downto 0);      
        alu_result_dm   : in std_logic_vector(31 downto 0);
        rd_addr_wb      : in std_logic_vector(4 downto 0);      
        alu_result_wb   : in std_logic_vector(31 downto 0);
        branch_cond     : out std_logic;
        rs2_value_out   : out std_logic_vector(31 downto 0);
        alu_result      : out std_logic_vector(31 downto 0));
end component;

component IE_DM
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
        branch_cond_dm  : out std_logic);
end component;

component data_memory_pipeline is
    Port ( 
        clk             : in std_logic;
        op_class        : in std_logic_vector(5 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        rs2_value       : in std_logic_vector(31 downto 0);  
        alu_result      : in std_logic_vector(31 downto 0);
                   
        mem_out         : out std_logic_vector(31 downto 0));
end component;

component DM_WB is
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
        op_class_wb     : out std_logic_vector(5 downto 0));
end component;

component write_back_pipeline is
    port ( 
        branch_cond     : in std_logic;
        op_class        : in std_logic_vector(5 downto 0);
        mem_out         : in std_logic_vector(31 downto 0);
        next_pc         : in std_logic_vector(31 downto 0);
        alu_result      : in std_logic_vector(31 downto 0);
        rd_write_en     : out std_logic;
        pc_load_en      : out std_logic;
        pc_out          : out std_logic_vector(31 downto 0);
        rd_value        : out std_logic_vector(31 downto 0));
end component;

begin
    if_inst : instr_fetch_pipeline
        port map (
            clk             => clk,
            pc_load_en      => pc_load_en_wb,
            pc_in           => pc_out_wb,
            pc_stall        => (branch_cond_ie or branch_cond_dm or branch_cond_wb)
                                or (op_class_ie(4) or op_class_dm(4) or op_class_wb(4)),
            next_pc         => next_pc_if,
            curr_pc         => curr_pc_if,
            instr           => instr_if);
    reg_if_id : IF_ID
        port map(
            clk             => clk,
            flush           => (branch_cond_ie or branch_cond_dm or branch_cond_wb)
                                or (op_class_ie(4) or op_class_dm(4) or op_class_wb(4)),
            curr_pc_if      => curr_pc_if,
            next_pc_if      => next_pc_if,
            instr_if        => instr_if,
            curr_pc_id      => curr_pc_id,
            next_pc_id      => next_pc_id,
            instr_id        => instr_id);
    id_inst : instr_decode_pipeline
        port map (
            clk             => clk,
            instr           => instr_id,
            rd_write_en     => rd_write_en_wb,
            rd_value        => rd_value_wb,
            rd_addr_in      => rd_addr_wb,
            op_class        => op_class_id,
            funct3          => funct3_id,
            funct7          => funct7_id,
            a_sel           => a_sel_id,
            b_sel           => b_sel_id,
            cond_opcode     => cond_opcode_id,
            rd_addr_out     => rd_addr_id,
            rs1_addr_out    => rs1_addr_id,
            rs2_addr_out    => rs2_addr_id,
            rs1_value       => rs1_value_id,
            rs2_value       => rs2_value_id,
            imm_se          => imm_se_id);
    reg_id_ie: ID_IE 
        port map(
            clk             => clk,
            flush           => (branch_cond_dm or branch_cond_wb)
                                or (op_class_dm(4) or op_class_wb(4)),
            curr_pc_id      => curr_pc_id,
            next_pc_id      => next_pc_id,
            op_class_id     => op_class_id,
            funct3_id       => funct3_id,
            funct7_id       => funct7_id,
            a_sel_id        => a_sel_id,
            b_sel_id        => b_sel_id,
            imm_se_id       => imm_se_id,
            rs1_value_id    => rs1_value_id,
            rs2_value_id    => rs2_value_id,
            rd_addr_id      => rd_addr_id,
            rs1_addr_id     => rs1_addr_id,
            rs2_addr_id     => rs2_addr_id,
            cond_opcode_id  => cond_opcode_id,
            curr_pc_ie      => curr_pc_ie,
            next_pc_ie      => next_pc_ie,
            op_class_ie     => op_class_ie,
            funct3_ie       => funct3_ie,
            funct7_ie       => funct7_ie,
            a_sel_ie        => a_sel_ie,
            b_sel_ie        => b_sel_ie,
            imm_se_ie       => imm_se_ie,
            rs1_value_ie    => rs1_value_ie,
            rs2_value_ie    => rs2_value_ie,
            rd_addr_ie      => rd_addr_ie,
            rs1_addr_ie     => rs1_addr_ie,
            rs2_addr_ie     => rs2_addr_ie,
            cond_opcode_ie  => cond_opcode_ie);
    ie_inst : instr_exec_pipeline
        port map(
            a_sel           => a_sel_ie,
            b_sel           => b_sel_ie,
            rs1_value_in    => rs1_value_ie,
            rs2_value_in    => rs2_value_ie,
            imm_se          => imm_se_ie,
            curr_pc         => curr_pc_ie,
            cond_opcode     => cond_opcode_ie,
            funct3          => funct3_ie,
            funct7          => funct7_ie,
            op_class        => op_class_ie,
            rs1_addr_in     => rs1_addr_ie,
            rs2_addr_in     => rs2_addr_ie,
            rd_addr_dm      => rd_addr_dm,
            alu_result_dm   => alu_result_dm,
            rd_addr_wb      => rd_addr_wb,
            alu_result_wb   => alu_result_wb,
            branch_cond     => branch_cond_ie,
            rs2_value_out   => rs2_value_out,
            alu_result      => alu_result_ie);
    reg_ie_dm: IE_DM
        port map(
            clk             => clk,
            flush           => branch_cond_dm
                                or op_class_wb(4),
            curr_pc_ie      => curr_pc_ie,
            next_pc_ie      => next_pc_ie,
            op_class_ie     => op_class_ie,
            funct3_ie       => funct3_ie,
            alu_result_ie   => alu_result_ie,
            rs2_value_ie    => rs2_value_out,
            rd_addr_ie      => rd_addr_ie,
            branch_cond_ie  => branch_cond_ie,
            curr_pc_dm      => curr_pc_dm,
            next_pc_dm      => next_pc_dm,
            op_class_dm     => op_class_dm,
            funct3_dm       => funct3_dm,
            alu_result_dm   => alu_result_dm,
            rs2_value_dm    => rs2_value_dm,
            rd_addr_dm      => rd_addr_dm,
            branch_cond_dm  => branch_cond_dm);
    mem : data_memory_pipeline
        port map(
            clk             => clk,
            op_class        => op_class_dm,
            funct3          => funct3_dm,
            rs2_value       => rs2_value_dm,
            alu_result      => alu_result_dm,
            mem_out         => mem_out_dm); 
    reg_dm_wb: DM_WB
        port map(
            clk             => clk,
            next_pc_dm      => next_pc_dm,
            mem_out_dm      => mem_out_dm,
            alu_result_dm   => alu_result_dm,
            rd_addr_dm      => rd_addr_dm,
            branch_cond_dm  => branch_cond_dm,
            op_class_dm     => op_class_dm,
            next_pc_wb      => next_pc_wb,
            mem_out_wb      => mem_out_wb,
            alu_result_wb   => alu_result_wb,
            rd_addr_wb      => rd_addr_wb,
            branch_cond_wb  => branch_cond_wb,
            op_class_wb     => op_class_wb);
    wb : write_back_pipeline
        port map(
            branch_cond     => branch_cond_wb,
            op_class        => op_class_wb,
            mem_out         => mem_out_wb,
            next_pc         => next_pc_wb,
            alu_result      => alu_result_wb,
            rd_write_en     => rd_write_en_wb,
            pc_load_en      => pc_load_en_wb,
            pc_out          => pc_out_wb,
            rd_value        => rd_value_wb);
end Structural;
