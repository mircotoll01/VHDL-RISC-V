----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2024 11:26:25 AM
-- Design Name: 
-- Module Name: Logic_Unit_64bit - Behavioral
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Logic_Unit_64bit is
    Port ( 
        s0, s1  : in std_logic;
        x,y     : in std_logic_vector(63 downto 0);
        output  : out std_logic_vector(63 downto 0)
    );
end Logic_Unit_64bit;

architecture Behavioral of Logic_Unit_64bit is
    signal opSelection : std_logic_vector(1 downto 0);
begin
    process(x,y,s0,s1)
    begin
        opSelection <= (s1,s0);
        if opSelection = "00" then
            output <= x and y;
        elsif opSelection = "01" then
            output <= x or y;
        elsif opSelection = "10" then
            output <= x xor y;
        elsif opSelection = "11" then
            output <= not x;
        else output <= (others => '0');
        end if;
    end process;
end Behavioral;
