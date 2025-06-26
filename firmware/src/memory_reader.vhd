library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity memory_reader is
    Port ( 
        clk         : in std_logic;
        data_in_dm  : in std_logic_vector(31 downto 0);
        data_in_reg : in std_logic_vector(31 downto 0);
        sw_i        : in std_logic_vector(15 downto 0);
        sw_reg_mem  : in std_logic;
        
        disp_seg    : out std_logic_vector(7 downto 0);
        an          : out std_logic_vector(7 downto 0);
        led_green   : out std_logic;
        led_red     : out std_logic;
        addr_sel    : out std_logic_vector(13 downto 0)    
    );
end memory_reader;

architecture Behavioral of memory_reader is
signal clk_div          : std_logic := '0';
signal mode_reg_mem     : std_logic := '0';
signal data_in_dm_buf   : std_logic_vector(31 downto 0) := (others => '0');
signal data_in_reg_buf  : std_logic_vector(31 downto 0) := (others => '0');
signal active_digit     : integer range 0 to 7 := 0;
signal led_green_buf    : std_logic := '0';
signal led_red_buf      : std_logic := '0';

function convert_bcd( data_in: std_logic_vector(3 downto 0)) return std_logic_vector is
variable disp_seg : std_logic_vector(7 downto 0);
begin
    case data_in is
        when "0000" => disp_seg := "11000000"; -- "0"     
        when "0001" => disp_seg := "11111001"; -- "1" 
        when "0010" => disp_seg := "10100100"; -- "2" 
        when "0011" => disp_seg := "10110000"; -- "3" 
        when "0100" => disp_seg := "10011001"; -- "4" 
        when "0101" => disp_seg := "10010010"; -- "5" 
        when "0110" => disp_seg := "10000010"; -- "6" 
        when "0111" => disp_seg := "11111000"; -- "7" 
        when "1000" => disp_seg := "10000000"; -- "8"     
        when "1001" => disp_seg := "10010000"; -- "9" 
        when "1010" => disp_seg := "10001000"; -- a
        when "1011" => disp_seg := "10000011"; -- b
        when "1100" => disp_seg := "11000110"; -- C
        when "1101" => disp_seg := "10100001"; -- d
        when "1110" => disp_seg := "10000110"; -- E
        when "1111" => disp_seg := "10001110"; -- F
    end case;
    return disp_seg;
end function;

begin
    process(clk)
        variable counter    : integer range 0 to 4999 := 0;
    begin
        if rising_edge(clk) then
            counter := counter + 1;
            if counter = 4999 then  
                counter             := 0;
                if active_digit < 7 then
                    active_digit    <= active_digit + 1;
                else
                    active_digit    <= 0;
                end if;
            end if;
        end if;
    end process;
    
    process(clk)
    variable counter : integer range 0 to 4999 := 0;
    begin
        if rising_edge(clk) then
            if counter = 4999 then  
                data_in_dm_buf      <= data_in_dm;
                data_in_reg_buf     <= data_in_reg;
                counter := 0;
            end if;
            counter := counter + 1;
        end if;
    end process;
    
    process(active_digit)
    begin
        if mode_reg_mem = '1' then
            led_green_buf   <= '1';
            led_red_buf     <= '0';
        else
            led_green_buf   <= '0';
            led_red_buf     <= '1';
       end if;
                
        case active_digit is
            when 0 =>
                disp_seg <= convert_bcd(data_in_dm_buf(3 downto 0) when mode_reg_mem = '0' 
                            else data_in_reg_buf(3 downto 0));
                an       <= "11111110";
            when 1 =>
                disp_seg <= convert_bcd(data_in_dm_buf(7 downto 4) when mode_reg_mem = '0' 
                            else data_in_reg_buf(7 downto 4));
                an       <= "11111101";
            when 2 =>
                disp_seg <= convert_bcd(data_in_dm_buf(11 downto 8) when mode_reg_mem = '0' 
                            else data_in_reg_buf(11 downto 8));
                an       <= "11111011";
            when 3 =>
                disp_seg <= convert_bcd(data_in_dm_buf(15 downto 12) when mode_reg_mem = '0' 
                            else data_in_reg_buf(15 downto 12));
                an       <= "11110111";
            when 4 =>
                disp_seg <= convert_bcd(data_in_dm_buf(19 downto 16) when mode_reg_mem = '0' 
                            else data_in_reg_buf(19 downto 16));
                an       <= "11101111";
            when 5 =>
                disp_seg <= convert_bcd(data_in_dm_buf(23 downto 20) when mode_reg_mem = '0' 
                            else data_in_reg_buf(23 downto 20));
                an       <= "11011111";
            when 6 =>
                disp_seg <= convert_bcd(data_in_dm_buf(27 downto 24) when mode_reg_mem = '0' 
                            else data_in_reg_buf(27 downto 24));
                an       <= "10111111";
            when 7 =>
                disp_seg <= convert_bcd(data_in_dm_buf(31 downto 28) when mode_reg_mem = '0' 
                            else data_in_reg_buf(31 downto 28));
                an       <= "01111111";
            when others =>
        end case;
    end process; 
    
    addr_sel    <=  sw_i(13) & sw_i(12) & sw_i(11) & sw_i(10) &
                    sw_i(9) & sw_i(8) & sw_i(7) & sw_i(6) & sw_i(5) &
                    sw_i(4) & sw_i(3) & sw_i(2) & sw_i(1) & sw_i(0);
    
    mode_reg_mem <= sw_i(15);
                 
    led_green   <= led_green_buf;
    led_red     <= led_red_buf;
 
end Behavioral;
