----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/25/2025 11:47:58 AM
-- Design Name: 
-- Module Name: comparator - Behavioral
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
