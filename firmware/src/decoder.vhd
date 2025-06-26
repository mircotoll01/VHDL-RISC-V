library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity decoder is
    Port (
        instr       : in std_logic_vector(31 downto 0);
        op_class    : out std_logic_vector(5 downto 0);
        funct3      : out std_logic_vector(2 downto 0);
        funct7      : out std_logic_vector(6 downto 0);
        a_sel       : out std_logic;
        b_sel       : out std_logic;
        cond_opcode : out std_logic_vector(2 downto 0);
        imm_se      : out std_logic_vector(31 downto 0)
     );
end decoder;  -- make so that the decoder gives out the addresses of the first and second operand fot the LUI instruction doesn't use instr(19 - 15) as address for first operand

architecture Behavioral of decoder is      
begin
process(instr)
begin
case instr(6 downto 5) is
    when "00" =>
        case instr(4 downto 0) is  
            when "000" & "11"  => -- LOAD [I-type]
                op_class    <=  "000100";
                imm_se      <=  std_logic_vector(resize(signed(instr(31 downto 20)), imm_se'length));-- Sign extension
                a_sel       <=  '1'; -- Select register as first operand 
                b_sel       <=  '0'; -- Select immediate as second operand
                funct3      <=  instr(14 downto 12);
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0');   
            when "100" & "11"  => -- OP-IMM [I-type]
                op_class    <=  "000010";
                imm_se      <=  std_logic_vector(resize(signed(instr(31 downto 20)), imm_se'length));
                a_sel       <=  '1';
                b_sel       <=  '0';
                funct3      <=  instr(14 downto 12);
                funct7      <=  instr(31 downto 25); -- shifts have funct7
                cond_opcode <=  (others => '0');    
            when "101" & "11"  => -- AUIPC [U-type] can be encoded as a combination jump/operation
                op_class    <=  "010010";
                imm_se      <=  instr(31) & instr(30 downto 20) 
                                & instr(19 downto 12) & (11 downto 0 => '0');
                a_sel       <=  '0'; -- Select Program counter as first operand 
                b_sel       <=  '0'; -- Select immediate as second operand
                funct3      <=  (others => '0'); 
                funct7      <=  (others => '0');  
                cond_opcode <=  (others => '0');                         
            when others =>
                op_class    <=  (others => '0'); 
                imm_se      <=  (others => '0'); 
                a_sel       <=  '0';
                b_sel       <=  '0';
                funct3      <=  (others => '0'); 
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0');  
        end case;
    when "01" =>
        case instr(4 downto 0) is 
            when "000" & "11"  => -- STORE [S-type]
                op_class    <=  "001000";
                imm_se      <=  std_logic_vector(resize(signed(instr(31 downto 25) 
                                & instr(11 downto 7)), imm_se'length));
                a_sel       <=  '1';
                b_sel       <=  '0';
                funct3      <=  instr(14 downto 12);
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0'); 
            when "100" & "11"  => -- OP [R-type]
                op_class    <=  "000001";
                imm_se      <=  (others => '0');
                a_sel       <=  '1';
                b_sel       <=  '1';
                funct3      <=  instr(14 downto 12);
                funct7      <=  instr(31 downto 25);
                cond_opcode <=  (others => '0'); 
            when "101" & "11"  => -- LUI [U-type] encoded as a combination load/operation
                op_class    <=  "000110";
                imm_se      <=  instr(31) & instr(30 downto 20) 
                                & instr(19 downto 12) & (11 downto 0 => '0');
                a_sel       <=  '1'; 
                b_sel       <=  '0'; 
                funct3      <=  (others => '0'); 
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0');                       
            when others =>
                op_class    <=  (others => '0'); 
                imm_se      <=  (others => '0'); 
                a_sel       <=  '0';
                b_sel       <=  '0';
                funct3      <=  (others => '0'); 
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0');  
        end case;    
    when "11" =>
        case instr(4 downto 0) is 
            when "000" & "11"  => -- BRANCH [B-type]
                op_class    <=  "100000";
                imm_se      <=  std_logic_vector(resize(signed(instr(31) & instr(7) & 
                                instr(30 downto 25) & instr(11 downto 8) & '0'), imm_se'length));
                a_sel       <=  '0';
                b_sel       <=  '0';
                funct3      <=  (others => '0'); 
                funct7      <=  (others => '0'); 
                cond_opcode <=  instr(14 downto 12); 
            when "001" & "11"  => -- JALR [I-type]
                op_class    <=  "010000";
                imm_se      <=  std_logic_vector(resize(signed(instr(31 downto 20)), imm_se'length));
                a_sel       <=  '0';
                b_sel       <=  '0';
                funct3      <=  instr(14 downto 12);
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0'); 
            when "011" & "11"  => -- JAL [J-type]
                op_class    <=  "010000";
                imm_se      <=  std_logic_vector(resize(signed(instr(31) & instr(19 downto 12) 
                                & instr(20) & instr(30 downto 21) & "0"), imm_se'length));
                a_sel       <=  '0';
                b_sel       <=  '0'; 
                funct3      <=  (others => '0'); 
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0');                      
            when others =>
                op_class    <=  (others => '0'); 
                imm_se      <=  (others => '0'); 
                a_sel       <=  '0';
                b_sel       <=  '0';
                funct3      <=  (others => '0'); 
                funct7      <=  (others => '0'); 
                cond_opcode <=  (others => '0');  
        end case;   
    when others =>
        op_class    <=  (others => '0'); 
        imm_se      <=  (others => '0'); 
        a_sel       <=  '0';
        b_sel       <=  '0';
        funct3      <=  (others => '0'); 
        funct7      <=  (others => '0'); 
        cond_opcode <=  (others => '0');  
end case;
end process;
end Behavioral;
