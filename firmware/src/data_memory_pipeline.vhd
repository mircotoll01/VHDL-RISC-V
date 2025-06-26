library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_memory_pipeline is
    Port ( 
        clk             : in std_logic;
        op_class        : in std_logic_vector(5 downto 0);
        funct3          : in std_logic_vector(2 downto 0);
        rs2_value       : in std_logic_vector(31 downto 0);  
        alu_result      : in std_logic_vector(31 downto 0);
        
        read_addr       : in std_logic_vector(13 downto 0);
                   
        read_data_out   : out std_logic_vector(31 downto 0);
        mem_out         : out std_logic_vector(31 downto 0));
end data_memory_pipeline;

architecture Behavioral of data_memory_pipeline is
    signal mem_out_raw  : std_logic_vector(31 downto 0) := (others => '0');
    signal write_enable : std_logic_vector(3 downto 0)  := (others => '0');
    
    component data_mem is
        port(
            clka        : in std_logic;
            wea         : in std_logic_vector(3 downto 0);
            dina        : in std_logic_vector(31 downto 0);
            addra       : in std_logic_vector(11 downto 0);
            douta       : out std_logic_vector(31 downto 0);
            
            clkb        : in std_logic;
            web         : in std_logic_vector(3 downto 0);
            dinb        : in std_logic_vector(31 downto 0);
            addrb       : in std_logic_vector(11 downto 0);
            doutb       : out std_logic_vector(31 downto 0));
    end component;
begin
    dm : data_mem
    port map(
        clka    => clk,
        wea     => write_enable, -- enable write only if it's a store instruction
        dina    => rs2_value,
        addra   => alu_result(13 downto 2), 
        douta   => mem_out_raw,
        
        clkb    => clk,
        web     => (others => '0'), 
        dinb    => (others => '0'),
        addrb   => read_addr(13 downto 2), 
        doutb   => read_data_out
        );
    
    process(all)
    begin
        case funct3 & op_class is
            when "000" & "000100" => -- LB
                write_enable<= "0000";
                mem_out     <= std_logic_vector(resize(
                                signed(mem_out_raw(7 downto 0)), mem_out'length));
            when "000" & "001000" => -- SB    
                write_enable<= "0001";
                mem_out     <= (others => '0');
            when "001" & "000100" => -- LH
                write_enable<= "0000";
                mem_out     <= std_logic_vector(resize(
                                signed(mem_out_raw(15 downto 0)), mem_out'length));
            when "001" & "001000" => -- SH,
                write_enable<= "0011";
                mem_out     <= (others => '0');
            when "010" & "000100" => -- LW
                write_enable<= "0000";
                mem_out     <= mem_out_raw;
            when "010" & "001000" => -- SW
                write_enable<= "1111";
                mem_out     <= (others => '0');
            when "100" & "000100" => -- LBU
                write_enable<= "0000";
                mem_out     <= std_logic_vector(resize(
                                unsigned(mem_out_raw(7 downto 0)), mem_out'length));
            when "101" & "000100" => -- LHU
                write_enable<= "0000";
                mem_out     <= std_logic_vector(resize(
                                unsigned(mem_out_raw(15 downto 0)), mem_out'length));
            when others => 
                write_enable<= "0000";
                mem_out     <= (others => '0');
        end case;
    end process;
end Behavioral;



