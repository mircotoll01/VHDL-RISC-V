library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity comparator is
    port ( 
        first_operand   : in std_logic_vector(31 downto 0);
        second_operand  : in std_logic_vector(31 downto 0);
        cond_opcode     : in std_logic_vector(2 downto 0);
        
        branch_cond     : out std_logic
    );
end comparator;

architecture Behavioral of comparator is
begin
    process(cond_opcode, first_operand, second_operand)
    begin
        branch_cond     <= '0';
        case cond_opcode is
            when "000"  =>          -- EQ
                if first_operand = second_operand then 
                    branch_cond <= '1';
                end if;
            when "001"  =>          -- NEQ
                if not(first_operand = second_operand) then 
                    branch_cond <= '1';
                end if;
            when "100"  =>          -- LT lower than
                if signed(first_operand) < signed(second_operand) then 
                    branch_cond <= '1';
                end if;
            when "101"  =>          -- GE greater or equal
                if signed(first_operand) >= signed(second_operand) then 
                    branch_cond <= '1';
                end if;
            when "110"  =>          -- LT unsigned
                if unsigned(first_operand) < unsigned(second_operand) then 
                    branch_cond <= '1';
                end if;
            when "111"  =>          -- GE unsigned
                if unsigned(first_operand) >= unsigned(second_operand) then 
                    branch_cond <= '1';
                end if;
            when others =>
                branch_cond <= '0';
        end case;
    end process;
end Behavioral;
