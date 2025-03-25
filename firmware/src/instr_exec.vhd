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
        clk             : in std_logic;
        a_sel           : in std_logic;
        b_sel           : in std_logic;    
        rs1             : in std_logic_vector(31 downto 0);
        rs2             : in std_logic_vector(31 downto 0);
        imm_se          : in std_logic_vector(31 downto 0);
        curr_pc         : in std_logic_vector(31 downto 0);
        cond_opcode     : in std_logic_vector(2 downto 0);
        alu_opcode      : in std_logic_vector(2 downto 0);
        
        branch_cond     : out std_logic;
        alu_pre_result  : out std_logic_vector(31 downto 0);
        alu_result      : out std_logic_vector(31 downto 0)
     );
end instr_exec;

architecture Structural of instr_exec is
    signal alu_mux_a    : std_logic_vector(31 downto 0);
    signal alu_mux_b    : std_logic_vector(31 downto 0);

    component ALU is
        port (
            clk         : in std_logic;
            a           : in std_logic_vector(31 downto 0);
            b           : in std_logic_vector(31 downto 0);
            opcode      : in std_logic_vector(2 downto 0);
            
            result      : out std_logic_vector(31 downto 0);
            pre_result  : out std_logic_vector(31 downto 0)
        );
    end component;
    
    component comparator is
        port ( 
            clk         : in std_logic;
            a           : in std_logic_vector(31 downto 0);
            b           : in std_logic_vector(31 downto 0);
            opcode      : in std_logic_vector(2 downto 0);
            
            output      : out std_logic
        );
    end component;
begin
    comp : comparator 
    port map(
        clk         => clk,
        a           => rs1,
        b           => rs2,
        opcode      => cond_opcode,
        output      => branch_cond
    ); 
    
    alu_1 : ALU
    port map(
        clk         => clk,
        a           => alu_mux_a,
        b           => alu_mux_b,
        opcode      => alu_opcode,
        result      => alu_result,
        pre_result  => alu_pre_result
    );
    
    process(clk)
    begin
        if rising_edge(clk) then
            if a_sel = '1' then
                alu_mux_a <= rs1;
            else
                alu_mux_a <= curr_pc;
            end if;
            
            if b_sel = '1' then
                alu_mux_b <= rs2;
            else
                alu_mux_b <= imm_se;
            end if;
        end if;
    end process;
end Structural;
