library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity instr_decode is
    Port (
        clk         : in std_logic;
        instr       : in std_logic_vector(31 downto 0);
        
        -- Inputs from mem writeback
        
        rd_write_en : in std_logic;
        rd_value    : in std_logic_vector(31 downto 0);
        rd_addr_in  : in std_logic_vector(4 downto 0);
        
        -- Decoded instruction informations
        
        op_class    : out std_logic_vector(5 downto 0);
        funct3      : out std_logic_vector(2 downto 0);
        funct7      : out std_logic_vector(6 downto 0);
        a_sel       : out std_logic;
        b_sel       : out std_logic;
        cond_opcode : out std_logic_vector(2 downto 0);
        rd_addr_out : out std_logic_vector(4 downto 0);
        
        -- Data to be elaborated
        
        rs1_value   : out std_logic_vector(31 downto 0);
        rs2_value   : out std_logic_vector(31 downto 0);
        imm_se      : out std_logic_vector(31 downto 0)
    );
end instr_decode;

architecture Structural of instr_decode is
    signal rd_rs1_mux       : std_logic_vector(4 downto 0) := (others => '0');
    signal we               : std_logic := '0';
        
    component register_file is
    port ( 
        clk         : in std_logic;
        da          : in std_logic_vector(4 downto 0);
        pda         : in std_logic_vector(4 downto 0);
        dina        : in std_logic_vector(4 downto 0);
        din         : in std_logic_vector(31 downto 0);
        we          : in std_logic;
        
        rso         : out std_logic_vector(31 downto 0);
        prso        : out std_logic_vector(31 downto 0));
    end component;
    
    component decoder is
    port(
        instr       : in std_logic_vector(31 downto 0);
        op_class    : out std_logic_vector(5 downto 0);
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
        da          => instr(19 downto 15),
        pda         => instr(24 downto 20),
        dina        => rd_addr_in,
        din         => rd_value,
        we          => rd_write_en,
        rso         => rs1_value,
        prso        => rs2_value);
    
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
     
    rd_addr_out <= instr(11 downto 7);
end Structural;
