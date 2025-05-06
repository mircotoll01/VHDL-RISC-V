----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2025 10:59:56 AM
-- Design Name: 
-- Module Name: Instr_Fetch - Structural
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

entity instr_fetch is
    port ( 
        clk         : in std_logic;
        pc_load_en  : in std_logic;
        pc_in       : in std_logic_vector(11 downto 0);
        
        next_pc     : out std_logic_vector(11 downto 0);
        curr_pc     : out std_logic_vector(11 downto 0);
        instr       : out std_logic_vector(31 downto 0));
end instr_fetch;

architecture Structural of instr_fetch is
    signal pc_reg  : unsigned(11 downto 0) := (others => '0');

    component instruction_memory
    port(
        clka        : in std_logic;
        wea         : in std_logic;
        addra       : in std_logic_vector(9 downto 0);
        dina        : in std_logic_vector(31 downto 0);
        douta       : out std_logic_vector(31 downto 0));
    end component;
begin
    instr_mem: instruction_memory 
    port map(
        clka        => clk,
        wea         => '0',
        dina        => (others => '0'),
        addra       => std_logic_vector(pc_reg(11 downto 2)),
        douta       => instr);
    
    process (clk)
    begin
        if rising_edge(clk) then
            if pc_load_en = '1' then
                pc_reg  <= unsigned(pc_in);
            end if;
        end if;
    end process;
    next_pc     <= std_logic_vector(pc_reg + 4);
    curr_pc     <= std_logic_vector(pc_reg);
end Structural;
