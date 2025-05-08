library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ALU is
    Port (
        first_operand   : in std_logic_vector(31 downto 0);
        second_operand  : in std_logic_vector(31 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        funct7          : in std_logic_vector(6 downto 0);
        op_class        : in std_logic_vector(4 downto 0);
        
        alu_result      : out std_logic_vector(31 downto 0)
    );
end ALU;

architecture Behavioral of ALU is
begin
process(op_class, funct3, funct7, first_operand, second_operand)
begin
    case op_class is
        when "00001" => -- OP and OP-IMM
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
            alu_result  <= std_logic_vector(signed(first_operand) + signed(second_operand));
        when "00100" => -- STORE
            alu_result  <= std_logic_vector(signed(first_operand) + signed(second_operand));
        when "00011" => -- LUI
            alu_result  <= second_operand;
        when "01001" => -- AUIPC
            alu_result  <= std_logic_vector(signed(first_operand) + signed(second_operand)); 
        when "01000" => -- JUMP
            alu_result  <= std_logic_vector(signed(first_operand) + signed(second_operand)); 
        when "10000" => -- BRANCH
            alu_result  <= std_logic_vector(signed(first_operand) + signed(second_operand));
        when others => 
            alu_result  <= (others => 'Z');
    end case;
end process;
end Behavioral;
