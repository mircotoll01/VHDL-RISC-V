library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity write_back_pipeline is
    port ( 
        branch_cond     : in std_logic;
        op_class        : in std_logic_vector(5 downto 0);
        mem_out         : in std_logic_vector(31 downto 0);
        next_pc         : in std_logic_vector(31 downto 0);
        alu_result      : in std_logic_vector(31 downto 0);
        
        rd_write_en     : out std_logic;
        pc_load_en      : out std_logic;
        pc_out          : out std_logic_vector(31 downto 0);
        rd_value        : out std_logic_vector(31 downto 0)
    );
end write_back_pipeline;

architecture Behavioral of write_back_pipeline is
begin
    process(branch_cond, op_class, mem_out, next_pc, alu_result)
    begin
        case op_class is
            when "000010" | "000001" =>         -- OP - OP-IMM
                rd_value    <= alu_result;
                pc_out      <= next_pc;
                pc_load_en  <= '0';
                rd_write_en <= '1';
            when "000110" =>         -- LUI
                rd_value    <= alu_result;
                pc_out      <= next_pc;
                pc_load_en  <= '0';
                rd_write_en <= '1';
            when "000100" =>         -- LOAD
                rd_value    <= mem_out;
                pc_out      <= next_pc;
                pc_load_en  <= '0';
                rd_write_en <= '1';
            when "010000" =>         -- JUMP
                rd_value    <= next_pc;
                pc_out      <= std_logic_vector(signed(alu_result));
                pc_load_en  <= '1';
                rd_write_en <= '1';
            when "100000" =>         -- BRANCH
                rd_value    <= next_pc when branch_cond = '1' else (others => '0');
                pc_out      <= alu_result when branch_cond = '1' else next_pc;
                pc_load_en  <= '1' when branch_cond = '1' else '0';
                rd_write_en <= '1';
            when "010010" =>         -- AUIPC
                rd_value    <= std_logic_vector(signed(alu_result)+signed(next_pc));
                pc_out      <= alu_result;
                pc_load_en  <= '1';
                rd_write_en <= '1';
            when others  => 
                rd_value    <= (others => '0');
                rd_write_en <= '0';
                pc_load_en  <= '0';
                pc_out      <= next_pc;
        end case;
    end process;   
end Behavioral;
