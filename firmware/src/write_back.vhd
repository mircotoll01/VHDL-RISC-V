library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity write_back is
    port ( 
        branch_cond     : in std_logic;
        op_class        : in std_logic_vector(4 downto 0);
        mem_out         : in std_logic_vector(31 downto 0);
        next_pc_ze      : in std_logic_vector(31 downto 0);
        curr_pc_ze      : in std_logic_vector(31 downto 0);
        alu_result      : in std_logic_vector(31 downto 0);
        rs2_value       : in std_logic_vector(31 downto 0);
        
        rd_write_en     : out std_logic;
        pc_load_en      : out std_logic;
        pc_out          : out std_logic_vector(31 downto 0);
        rd_value        : out std_logic_vector(31 downto 0)
    );
end write_back;

architecture Behavioral of write_back is
begin
    process(op_class,mem_out,branch_cond,alu_result,rs2_value,next_pc_ze)
    begin
        case op_class is
            when "00001" =>         -- OP - OP-IMM
                rd_value    <= alu_result;
                pc_out      <= next_pc_ze;
                rd_write_en <= '1';
                pc_load_en  <= '1';
            when "00011" =>         -- LUI
                rd_value    <= alu_result;
                pc_out      <= next_pc_ze;
                rd_write_en <= '1';
                pc_load_en  <= '1';
            when "00010" =>         -- LOAD
                rd_value    <= mem_out;
                pc_out      <= next_pc_ze;
                rd_write_en <= '1';
                pc_load_en  <= '1';
            when "01000" =>         -- JUMP
                rd_value    <= next_pc_ze;
                pc_out      <= std_logic_vector(signed(alu_result));
                rd_write_en <= '1';
                pc_load_en  <= '1';
            when "10000" =>         -- BRANCH
                rd_value    <= next_pc_ze when branch_cond = '1' else (others => 'Z');
                pc_out      <= alu_result when branch_cond = '1' else next_pc_ze;
                rd_write_en <= '1' when branch_cond = '1';
                pc_load_en  <= '1';
            when "01001" =>         -- AUIPC
                rd_value    <= std_logic_vector(signed(alu_result)+signed(next_pc_ze));
                pc_out      <= alu_result;
                rd_write_en <= '1';
                pc_load_en  <= '1';
            when others  => 
                rd_value    <= (others => 'Z');
                rd_write_en <= '0';
                pc_load_en  <= '1';
                pc_out      <= next_pc_ze;
        end case;
    end process;
end Behavioral;
