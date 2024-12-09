----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/02/2024 12:45:07 PM
-- Design Name: 
-- Module Name: Conditioning_Unit_64bit - Behavioral
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

entity Conditioning_Unit_64bit is
    Port ( 
        s0,s1       : in std_logic;
        inputReg    : in std_logic_vector(63 downto 0);
        output      : out std_logic_vector(63 downto 0)
    );
end Conditioning_Unit_64bit;

architecture Behavioral of Conditioning_Unit_64bit is
    signal opSelect : std_logic_vector(1 downto 0);
begin
    process(inputReg,s0,s1)
    begin     
        if opSelect = "00" then
            output <= (others => '0');
        elsif opSelect = "01" then
            output <= inputReg;
        elsif opSelect = "10" then
            output <= not inputReg;
        elsif opSelect = "11" then
            output <= (others => '1');
        else output <= (others => '0');
        end if;
    end process;
end Behavioral;
