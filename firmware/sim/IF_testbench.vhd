----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/14/2025 06:19:25 PM
-- Design Name: 
-- Module Name: IF_testbench - Behavioral
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

entity IF_testbench is
--  Port ( );
end IF_testbench;

architecture Behavioral of IF_testbench is
    signal clock        : std_logic := '0';
    signal pcl          : std_logic := '0';
    signal pc           : std_logic_vector(11 downto 0) := (others => '0');
    signal pc_curr      : std_logic_vector(11 downto 0) := (others => '0');
    signal pc_next      : std_logic_vector(11 downto 0) := (others => '0');
    signal instr        : std_logic_vector(31 downto 0) := (others => '0');

    component instr_fetch
    port(
        clk         : in std_logic;
        pc_load     : in std_logic;
        pc_in       : in std_logic_vector(11 downto 0);
        next_pc     : out std_logic_vector(11 downto 0);
        curr_pc     : out std_logic_vector(11 downto 0);
        instruction : out std_logic_vector(31 downto 0)
    );
    end component;
begin
    I_F: instr_fetch
    port map(
        clk         => clock,
        pc_load     => pcl,
        pc_in       => pc,
        next_pc     => pc_next,
        curr_pc     => pc_curr,
        instruction => instr
    );
    
    process
    begin
        clock     <= not clock;
        wait for 10 ns;
    end process;

end Behavioral;
