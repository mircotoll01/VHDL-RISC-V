----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 08:40:41 AM
-- Design Name: 
-- Module Name: decoder - Behavioral
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

entity decoder is
    Port (
        clk         : in std_logic;
        instr       : in std_logic_vector(31 downto 0);
        op_class    : out std_logic_vector(4 downto 0);
        alu_opcode  : out std_logic_vector(2 downto 0);
        a_sel       : out std_logic;
        b_sel       : out std_logic;
        cond_opcode : out std_logic_vector(2 downto 0);
        imm_se      : out signed(31 downto 0)
     );
end decoder;

architecture Behavioral of decoder is
    signal op_class_reg     : std_logic_vector(4 downto 0) := (others => '0');
    signal alu_opcode_reg   : std_logic_vector(2 downto 0) := (others => '0');
    signal a_sel_reg        : std_logic := '0';
    signal b_sel_reg        : std_logic := '0';
    signal cond_opcode_reg  : std_logic_vector(2 downto 0) := (others => '0');
    signal imm_se_reg       : signed(31 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case instr(6 downto 5) is
                when "00" =>
                    case instr(4 downto 2) is 
                        when "000"  =>              -- LOAD
                            op_class_reg    <=  "00100";
                            imm_se_reg      <=  resize(signed(instr(31 downto 20)), imm_se_reg'length);
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '0';
                            alu_opcode_reg  <= "000";
                            cond_opcode_reg <= "000";
                        when "100"  =>              -- OP-IMM
                            op_class_reg    <=  "00001";
                            imm_se_reg      <=  resize(signed(instr(31 downto 20)), imm_se_reg'length);
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '0';
                            alu_opcode_reg  <= instr(14 downto 12);
                            cond_opcode_reg <= instr(14 downto 12);                            
                        when others =>
                    end case;
                when "01" =>
                    case instr(4 downto 2) is 
                        when "000"  =>              -- STORE
                            op_class_reg    <=  "00010";
                            imm_se_reg      <=  resize(signed(instr(31 downto 25) & instr(11 downto 7)), imm_se_reg'length);
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '1';
                            alu_opcode_reg  <= "000";
                            cond_opcode_reg <= "000";
                        when "100"  =>              -- OP
                            op_class_reg    <=  "00001";
                            imm_se_reg      <=  (others => '0');
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '1';
                            alu_opcode_reg  <= instr(14 downto 12);
                            cond_opcode_reg <= instr(14 downto 12);                            
                        when others =>
                    end case;    
                when "11" =>
                    case instr(4 downto 2) is 
                        when "000"  =>              -- BRANCH
                            op_class_reg    <=  "01000";
                            imm_se_reg      <=  resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8)), imm_se_reg'length);
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '1';
                            alu_opcode_reg  <= "000";
                            cond_opcode_reg <= "000";
                        when "011"  =>              -- JAL
                            op_class_reg    <=  "10000";
                            imm_se_reg      <=  resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21)), imm_se_reg'length);
                            a_sel_reg       <=  '0';
                            b_sel_reg       <=  '0';
                            alu_opcode_reg  <= instr(14 downto 12);
                            cond_opcode_reg <= instr(14 downto 12);                            
                        when others =>
                    end case;   
                when others =>
            end case;
        end if;
    end process;
    
    imm_se          <= imm_se_reg;
    cond_opcode     <= cond_opcode_reg;
    a_sel           <=  a_sel_reg;
    b_sel           <=  b_sel_reg;
    alu_opcode      <= alu_opcode_reg;
    cond_opcode     <= cond_opcode_reg; 
end Behavioral;
