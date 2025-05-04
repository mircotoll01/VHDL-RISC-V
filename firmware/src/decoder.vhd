----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/18/2025 08:40:41 AM
-- Design Name: 
-- Module Name: decoder - Behavioral
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

entity decoder is
    Port (
        clk         : in std_logic;
        instr       : in std_logic_vector(31 downto 0);
        op_class    : out std_logic_vector(4 downto 0);
        funct3      : out std_logic_vector(2 downto 0);
        funct7      : out std_logic_vector(6 downto 0);
        a_sel       : out std_logic;
        b_sel       : out std_logic;
        cond_opcode : out std_logic_vector(2 downto 0);
        imm_se      : out std_logic_vector(31 downto 0)
     );
end decoder;

architecture Behavioral of decoder is
    signal op_class_reg     : std_logic_vector(4 downto 0) := (others => '0'); 
    signal funct3_reg       : std_logic_vector(2 downto 0) := (others => '0');
    signal funct7_reg       : std_logic_vector(6 downto 0) := (others => '0');
    signal a_sel_reg        : std_logic := '0';
    signal b_sel_reg        : std_logic := '0';
    signal cond_opcode_reg  : std_logic_vector(2 downto 0) := (others => '0');
    signal imm_se_reg       : std_logic_vector(31 downto 0) := (others => '0');
    
begin
    process(clk)
    begin
        if rising_edge(clk) then
            case instr(6 downto 5) is
                when "00" =>
                    case instr(4 downto 2) is 
                        when "000"  =>              -- LOAD [I-type]
                            op_class_reg    <=  "00010";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31 downto 20)), imm_se_reg'length)); -- Sign extension of the 12 bit immediate part 
                            a_sel_reg       <=  '1'; -- Select register as first operand 
                            b_sel_reg       <=  '0'; -- Select immediate as second operand
                            funct3_reg      <=  "000"; -- Select add
                            funct7_reg      <=  (others => '0'); -- Select add
                            cond_opcode_reg <=  (others => '0');
                        when "100"  =>              -- OP-IMM [I-type]
                            op_class_reg    <=  "00001";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31 downto 20)), imm_se_reg'length));
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '0';
                            funct3_reg      <=  instr(14 downto 12);
                            funct7_reg      <=  (others => '0');
                            cond_opcode_reg <=  instr(14 downto 12);    
                        when "101"  =>              -- AUIPC (Add upper-immediate to Program Counter) [U-type] can be encoded as a jump
                            op_class_reg    <=  "01000";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31 downto 12)), imm_se_reg'length));
                            a_sel_reg       <=  '0'; -- Select Program counter as first operand 
                            b_sel_reg       <=  '0'; -- Select immediate as second operand
                            funct3_reg      <=  "000"; -- Select add
                            funct7_reg      <=  (others => '0');
                            cond_opcode_reg <=  (others => '0');                            
                        when others =>
                    end case;
                when "01" =>
                    case instr(4 downto 2) is 
                        when "000"  =>              -- STORE [S-type]
                            op_class_reg    <=  "00100";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31 downto 25) & instr(11 downto 7)), imm_se_reg'length));
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '1';
                            funct3_reg      <=  "000";
                            funct7_reg      <=  (others => '0');
                            cond_opcode_reg <=  (others => '0');
                        when "100"  =>              -- OP [R-type]
                            op_class_reg    <=  "00001";
                            imm_se_reg      <=  (others => '0');
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '1';
                            funct3_reg      <=  instr(14 downto 12);
                            funct7_reg      <=  instr(31 downto 25);
                            cond_opcode_reg <=  (others => '0');    
                        when "101"  =>              -- LUI [I-type]
                            op_class_reg    <=  "00010";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31 downto 20)), imm_se_reg'length)); -- Sign extension of the 12 bit immediate part 
                            a_sel_reg       <=  '1'; -- Select register as first operand 
                            b_sel_reg       <=  '0'; -- Select immediate as second operand
                            funct3_reg      <=  "000"; -- Select add
                            funct7_reg      <=  (others => '0');
                            cond_opcode_reg <=  (others => '0');                         
                        when others =>
                    end case;    
                when "11" =>
                    case instr(4 downto 2) is 
                        when "000"  =>              -- BRANCH [B-type]
                            op_class_reg    <=  "10000";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31) & instr(7) & instr(30 downto 25) & instr(11 downto 8)), imm_se_reg'length));
                            a_sel_reg       <=  '1';
                            b_sel_reg       <=  '1';
                            funct3_reg      <=  (others => '0');
                            funct7_reg      <=  (others => '0');
                            cond_opcode_reg <=  instr(14 downto 12); 
                        when "001"  =>              -- JALR [J-type]
                            op_class_reg    <=  "01000";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21)), imm_se_reg'length));
                            a_sel_reg       <=  '0';
                            b_sel_reg       <=  '0';
                            funct3_reg      <=  instr(14 downto 12);
                            funct7_reg      <=  (others => '0');
                            cond_opcode_reg <=  (others => '0');   
                        when "011"  =>              -- JAL
                            op_class_reg    <=  "01000";
                            imm_se_reg      <=  std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) & instr(20) & instr(30 downto 21)), imm_se_reg'length));
                            a_sel_reg       <=  '0';
                            b_sel_reg       <=  '0'; 
                            funct3_reg      <=  (others => '0');
                            funct7_reg      <=  (others => '0');
                            cond_opcode_reg <=  (others => '0');                         
                        when others =>
                    end case;   
                when others =>
            end case;  
        end if;
    end process;
    
    imm_se          <= imm_se_reg;
    cond_opcode     <= cond_opcode_reg;
    a_sel           <= a_sel_reg;
    b_sel           <= b_sel_reg;
    funct3          <= funct3_reg;
    cond_opcode     <= cond_opcode_reg; 
    op_class        <= op_class_reg;
end Behavioral;
