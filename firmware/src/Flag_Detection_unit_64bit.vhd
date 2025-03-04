----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2024 01:01:34 PM
-- Design Name: 
-- Module Name: Flag_Detection_unit_64bit - Behavioral
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

entity Flag_Detection_unit_64bit is
    Port ( 
        input       : in std_logic_vector(63 downto 0);
        Z, N, P     : out std_logic
    );
end Flag_Detection_unit_64bit;

architecture Behavioral of Flag_Detection_unit_64bit is
begin
    process(input)
        variable even : std_logic;
    begin
        if unsigned(input) = 0 then Z <= '1';
        else Z <= '0';
        
        N <= input(63);
        
        even := '0';
        for i in input'range loop
            if input(i) = '1' then even := not even;
            end if;
        end loop;
        P <= even;
        end if;
    end process;
end Behavioral;
