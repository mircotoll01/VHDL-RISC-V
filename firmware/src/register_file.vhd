library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity register_file is
    Port ( 
        clk         : in std_logic;
        da          : in std_logic_vector(4 downto 0);
        pda         : in std_logic_vector(4 downto 0);
        dina        : in std_logic_vector(4 downto 0);
        din         : in std_logic_vector(31 downto 0);
        we          : in std_logic;
        
        rso         : out std_logic_vector(31 downto 0);
        prso        : out std_logic_vector(31 downto 0);
        
        -- checking out registers from outside
        
        addr_sel    : in std_logic_vector(13 downto 0);
        reg_out     : out std_logic_vector(31 downto 0)
    );
end register_file;

architecture Behavioral of register_file is
    type reg_file is array(31 downto 0) of std_logic_vector(31 downto 0);
    signal registers: reg_file  := (others => (others => '0')); 
    signal rso_buf  : std_logic_vector(31 downto 0) := (others => '0');
    signal prso_buf : std_logic_vector(31 downto 0) := (others => '0');
begin
    process(clk)
        variable registers_buf  : reg_file  := (others => (others => '0'));
    begin
        if rising_edge(clk) then
            if we = '1' and dina /= "00000" then
                registers_buf(to_integer(unsigned(dina))) := din;
            end if;
            registers   <= registers_buf;
        end if;
    end process;
    
    rso     <= registers(to_integer(unsigned(da)));
    prso    <= registers(to_integer(unsigned(pda)));
    
    -- checking registers from data reader
    reg_out <= registers(to_integer(unsigned(addr_sel(4 downto 0))));
end Behavioral;
