----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2025 04:21:50 PM
-- Design Name: 
-- Module Name: instr_exec - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity instr_exec is
    Port (
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
        ls_class        : out std_logic_vector(2 downto 0)
     );
end instr_exec;

architecture Structural of instr_exec is
    signal alu_mux_a    : std_logic_vector(31 downto 0);
    signal alu_mux_b    : std_logic_vector(31 downto 0);

    component ALU is
        port (
            first_operand   : in std_logic_vector(31 downto 0);
            second_operand  : in std_logic_vector(31 downto 0);
            funct3          : in std_logic_vector(2 downto 0);
            funct7          : in std_logic_vector(6 downto 0);
            op_class        : in std_logic_vector(4 downto 0);
            
            alu_result      : out std_logic_vector(31 downto 0);
            ls_class        : out std_logic_vector(2 downto 0));
    end component;
    
    component comparator is
        port ( 
            first_operand   : in std_logic_vector(31 downto 0);
            second_operand  : in std_logic_vector(31 downto 0);
            cond_opcode     : in std_logic_vector(2 downto 0);
            
            branch_cond     : out std_logic);
    end component;
begin
    comp : comparator 
    port map(
        first_operand   => rs1,
        second_operand  => rs2,
        cond_opcode     => cond_opcode,
        branch_cond     => branch_cond); 
    
    alu_1 : ALU
    port map(
        first_operand   => alu_mux_a,
        second_operand  => alu_mux_b,
        funct3          => funct3,
        funct7          => funct7,
        op_class        => op_class,
         
        alu_result      => alu_result,
        ls_class        => ls_class);
    
    alu_mux_a   <= rs1 when a_sel = '1' else curr_pc;
    alu_mux_b   <= rs2 when b_sel = '1' else imm_se;
end Structural;
