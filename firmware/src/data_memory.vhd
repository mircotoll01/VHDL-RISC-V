library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    Port ( 
        clk             : in std_logic;
        op_class        : in std_logic_vector(4 downto 0);
        ls_class        : in std_logic_vector(2 downto 0);
        rs2_value       : in std_logic_vector(31 downto 0);  
        alu_result      : in std_logic_vector(31 downto 0);
                   
        mem_out         : out std_logic_vector(31 downto 0));
end data_memory;

architecture Behavioral of data_memory is
    signal write_enable : std_logic := '0';
    signal mem_out_raw  : std_logic_vector(31 downto 0) := (others => '0');
    component data_mem is
        port(
            clk     : in std_logic;
            we      : in std_logic;
            d       : in std_logic_vector(31 downto 0);
            a       : in std_logic_vector(5 downto 0);
            spo     : out std_logic_vector(31 downto 0));
    end component;
begin
    dm : data_mem
    port map(
        clk     => clk,
        we      => op_class(2), -- enable write only if it's a store instruction
        d       => rs2_value,
        a       => alu_result(13 downto 2) & (1 downto 0 => '0'), -- address selection needs only 14 bits
        spo     => mem_out_raw);
    
    process(mem_out_raw)
    begin
        case(ls_class) is
            when "000" => 
                mem_out <= std_logic_vector(resize(
                            signed(mem_out_raw(7 downto 0)), mem_out'length));
            when "001" => 
                mem_out <= std_logic_vector(resize(
                            signed(mem_out_raw(15 downto 0)), mem_out'length));
            when "010" => 
                mem_out <= mem_out_raw;
            when "100" => 
                mem_out <= std_logic_vector(resize(
                            unsigned(mem_out_raw(7 downto 0)), mem_out'length));
            when "101" => 
                mem_out <= std_logic_vector(resize(
                            unsigned(mem_out_raw(15 downto 0)), mem_out'length));
            when others => 
        end case;
    end process;
end Behavioral;
