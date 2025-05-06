----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/30/2025 09:39:06 AM
-- Design Name: 
-- Module Name: IE_testbench - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity IE_testbench is
end IE_testbench;

architecture Behavioral of IE_testbench is
constant clk_period     : time := 100 ns;
signal pc_in            : std_logic_vector(11 downto 0) := (others => '0');
signal next_pc          : std_logic_vector(11 downto 0) := (others => '0');
signal next_pc_reg      : std_logic_vector(11 downto 0) := (others => '0');
signal curr_pc          : std_logic_vector(11 downto 0) := (others => '0');
signal instr            : std_logic_vector(31 downto 0) := (others => '0');
signal clk              : std_logic := '0';
signal pc_load_en       : std_logic := '1';

-- signals for the ID

signal rd_write_en      : std_logic := '0';
signal rd_value         : std_logic_vector(31 downto 0) := (others => '0');
signal next_pc_ze       : std_logic_vector(31 downto 0) := (others => '0');
signal curr_pc_ze       : std_logic_vector(31 downto 0) := (others => '0');
signal op_class         : std_logic_vector(4 downto 0) := (others => '0');
signal funct3           : std_logic_vector(2 downto 0) := (others => '0');
signal a_sel            : std_logic := '0';
signal b_sel            : std_logic := '0';
signal cond_opcode      : std_logic_vector(2 downto 0) := (others => '0');
signal rs1              : std_logic_vector(31 downto 0) := (others => '0');
signal rs2              : std_logic_vector(31 downto 0) := (others => '0');
signal imm_se           : std_logic_vector(31 downto 0) := (others => '0');

--signals for the IE
signal funct7           : std_logic_vector(6 downto 0) := (others => '0');
signal branch_cond      : std_logic := '0';
signal ls_class         : std_logic_vector(2 downto 0) := (others => '0');
signal alu_result       : std_logic_vector(31 downto 0) := (others => '0');

component instr_fetch
    port ( 
        clk         : in std_logic;
        pc_load_en  : in std_logic;
        pc_in       : in std_logic_vector(11 downto 0);
        
        next_pc     : out std_logic_vector(11 downto 0);
        curr_pc     : out std_logic_vector(11 downto 0);
        instr       : out std_logic_vector(31 downto 0));
end component;

component instr_decode
    port (
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
        
        rs1         : out std_logic_vector(31 downto 0);
        rs2         : out std_logic_vector(31 downto 0);
        imm_se      : out std_logic_vector(31 downto 0));
end component;
    
component instr_exec
    port(
        a_sel           : in std_logic;
        b_sel           : in std_logic;    
        rs1             : in std_logic_vector(31 downto 0);
        rs2             : in std_logic_vector(31 downto 0);
        imm_se          : in std_logic_vector(31 downto 0);
        curr_pc         : in std_logic_vector(31 downto 0);
        cond_opcode     : in std_logic_vector(2 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        funct7          : in std_logic_vector(6 downto 0);
        op_class        : in std_logic_vector(4 downto 0);
        
        branch_cond     : out std_logic;
        alu_result      : out std_logic_vector(31 downto 0);
        ls_class        : out std_logic_vector(2 downto 0));
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
            next_pc     => next_pc,
            curr_pc     => curr_pc,
            rd_write_en => rd_write_en,
            rd_value    => rd_value, 
            next_pc_ze  => next_pc_ze,
            curr_pc_ze  => curr_pc_ze,
            op_class    => op_class,
            funct3      => funct3,
            funct7      => funct7,
            a_sel       => a_sel,
            b_sel       => b_sel,
            cond_opcode => cond_opcode,
            rs1         => rs1,
            rs2         => rs2,
            imm_se      => imm_se);
    ie_inst : instr_exec
        port map(
            a_sel       => a_sel,
            b_sel       => b_sel,
            rs1         => rs1,
            rs2         => rs2,
            imm_se      => imm_se,
            curr_pc     => curr_pc_ze,
            cond_opcode => cond_opcode,
            funct3      => funct3,
            funct7      => funct7,
            op_class    => op_class,
            branch_cond => branch_cond,
            ls_class    => ls_class);
        
    process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    pc_in       <= next_pc;
end Behavioral;
