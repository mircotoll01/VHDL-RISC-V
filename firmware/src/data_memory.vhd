library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory is
    Port ( 
        clk             : in std_logic;
        op_class        : in std_logic_vector(4 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        rs2_value       : in std_logic_vector(31 downto 0);  
        alu_result      : in std_logic_vector(31 downto 0);
                   
        mem_out         : out std_logic_vector(31 downto 0));
end data_memory;

architecture Behavioral of data_memory is
    signal write_enable     : std_logic := '0';
    signal mem_out_raw      : std_logic_vector(31 downto 0) := (others => '0');
    signal rs2_value_scaled : std_logic_vector(31 downto 0):= (others => '0');
    
    component data_mem is
        port(
            clka        : in std_logic;
            wea         : in std_logic;
            dina        : in std_logic_vector(31 downto 0);
            addra       : in std_logic_vector(13 downto 0);
            douta       : out std_logic_vector(31 downto 0));
    end component;
begin
    dm : data_mem
    port map(
        clka    => clk,
        wea     => op_class(2), -- enable write only if it's a store instruction
        dina    => rs2_value_scaled,
        addra   => alu_result(13 downto 2) & (1 downto 0 => '0'), -- address selection needs only upper 12 bits
        douta   => mem_out_raw);
    
    process(funct3, op_class)
    begin
        case funct3 & op_class is
            when "000" & "00010" => -- LB
                mem_out <= std_logic_vector(resize(
                            signed(mem_out_raw(7 downto 0)), mem_out'length));
            when "000" & "00100" => --SB    
                rs2_value_scaled(7 downto 0) <= rs2_value(7 downto 0);
                mem_out <= (others => 'Z');
            when "001" & "00010" => -- LH
                mem_out <= std_logic_vector(resize(
                            signed(mem_out_raw(15 downto 0)), rs2_value_scaled'length));
            when "001" & "00100" => -- SH,
                rs2_value_scaled(15 downto 0) <= rs2_value(15 downto 0);
                mem_out <= (others => 'Z');
            when "010" & "00010" => -- LW
                mem_out <= mem_out_raw;
            when "010" & "00100" => -- SW
                rs2_value_scaled <= rs2_value;
                mem_out <= (others => 'Z');
            when "100" & "00010" => -- LBU
                mem_out <= std_logic_vector(resize(
                            unsigned(mem_out_raw(7 downto 0)), mem_out'length));
            when "101" & "00100" => -- LHU
                mem_out <= std_logic_vector(resize(
                            unsigned(mem_out_raw(15 downto 0)), mem_out'length));
            when others => 
                mem_out <= (others => 'Z');
        end case;
    end process;
end Behavioral;
