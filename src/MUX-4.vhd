----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2024 10:16:22 AM
-- Design Name: 
-- Module Name: MUX-4 - Behavioral
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

entity MUX_4_64bit is
    Port (
        s0,s1           : in std_logic;
        a0, a1, a2, a3  : in std_logic_vector(63 downto 0);       
        output          : out std_logic_vector(63 downto 0)
        );
end MUX_4_64bit;

architecture Behavioral of MUX_4_64bit is 
signal portSelection : std_logic_vector(1 downto 0);
begin
    process(a0,a1,a2,a3,s0,s1)
    begin
        portSelection <= (s1,s0);
        if portSelection = "00" then
            output <= a0;
        elsif portSelection = "01" then
            output <= a1;
        elsif portSelection = "10" then
            output <= a2;
        elsif portSelection = "11" then
            output <= a3;
        else output <= (others => '0');
        end if;
    end process;
end Behavioral;
