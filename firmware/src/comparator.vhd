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
        clk             : in std_logic;
        first_operand   : in std_logic_vector(31 downto 0);
        second_operand  : in std_logic_vector(31 downto 0);
        cond_opcode     : in std_logic_vector(2 downto 0);
        
        output      : out std_logic
    );
end comparator;

architecture Behavioral of comparator is
    signal output_raw  : std_logic := '0';
    signal output_reg  : std_logic := '0';
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case cond_opcode is
                when "000"  =>          -- EQ
                    output_raw <= '0';
                    if first_operand = second_operand then 
                        output_raw <= '1';
                    end if;
                when "001"  =>          -- NEQ
                    output_raw <= '0';
                    if not(first_operand = second_operand) then 
                        output_raw <= '1';
                    end if;
                when "100"  =>          -- LT lower than
                    output_raw <= '0';
                    if first_operand < second_operand then 
                        output_raw <= '1';
                    end if;
                when "101"  =>          -- GE greater or equal
                    output_raw <= '0';
                    if first_operand <= second_operand then 
                        output_raw <= '1';
                    end if;
                when others =>
                    output_raw <= '0';
            end case;
            output  <= output_raw;
        end if;
    end process;
    output_reg  <= output_raw;
end Behavioral;
