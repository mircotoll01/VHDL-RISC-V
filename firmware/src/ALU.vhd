----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2025 10:57:58 AM
-- Design Name: 
-- Module Name: ALU - Structural
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

entity ALU is
    Port (
        first_operand   : in std_logic_vector(31 downto 0);
        second_operand  : in std_logic_vector(31 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        funct7          : in std_logic_vector(6 downto 0);
        op_class        : in std_logic_vector(4 downto 0);
        
        alu_result      : out std_logic_vector(31 downto 0);
        ls_class        : out std_logic_vector(2 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
process(op_class, funct3, funct7, first_operand, second_operand)
begin
    case op_class is
        when "00001" => --OP and OP-IMM
            case funct3 is
                when "001" => -- SLL,SLLI
                    alu_result <= std_logic_vector(shift_left(unsigned(first_operand),
                                        to_integer(unsigned(second_operand))));
                when "010" => -- SLT,SLTI
                    alu_result <= 
                        (0 => '1', others => '1')
                    when (unsigned(first_operand) < unsigned(second_operand)) else
                        (others => '0');
                when "011" => -- SLTU,SLTIU
                    alu_result <= 
                        (0 => '1', others => '1')
                    when (unsigned(first_operand) < unsigned(second_operand)) else
                        (others => '0');
                when "100" => -- XOR, XORI
                    alu_result <= first_operand xor second_operand;
                when "101" => -- right shifts
                    alu_result     <= 
                    std_logic_vector(shift_right(unsigned(first_operand), 
                                        to_integer(unsigned(second_operand(4 downto 0)))))
                    when funct7(5) = '1' else
                    std_logic_vector(shift_right(signed(first_operand), 
                                        to_integer(unsigned(second_operand(4 downto 0)))));
                when "110" => -- OR,ORI
                    alu_result      <= first_operand or second_operand;
                when "111" => -- AND, ANDI
                    alu_result      <= first_operand and second_operand;
                when others =>
                    alu_result <= 
                        std_logic_vector(signed(first_operand) - signed(second_operand))
                    when funct7(5) = '1' else
                        std_logic_vector(signed(first_operand) + signed(second_operand));
            end case;
        when "00010" => -- LOAD
            case funct3 is
                when "000" => -- LB
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "001";
                when "001" => -- LH
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "010";
                when "010" => -- LW
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "100";
                when "100" => -- LBU
                    alu_result <= std_logic_vector(unsigned(first_operand) + unsigned(second_operand));
                    ls_class <=  "001";
                when "101" => -- LHU
                    alu_result <= std_logic_vector(unsigned(first_operand) + unsigned(second_operand));
                    ls_class <=  "010";
                when others =>
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "001";
            end case;
        when "00100" => -- STORE
            case funct3 is
                when "000" => -- SB
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "001";
                when "001" => -- SH
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "010";
                when "010" => -- SW
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "100";
                when others =>
                    alu_result <= std_logic_vector(signed(first_operand) + signed(second_operand));
                    ls_class <=  "001";
            end case;
        when others => -- BRANCH, JUMP or undefined sequences may just lead to an addition 
                        --  which may or may not be considered
            alu_result <= std_logic_vector(unsigned(first_operand) + unsigned(second_operand));
    end case;
end process;
end Behavioral;
