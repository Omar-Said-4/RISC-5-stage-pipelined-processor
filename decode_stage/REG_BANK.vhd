LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
ENTITY REG_BANK IS
    PORT (
        clk : IN STD_LOGIC;
        we1 : IN STD_LOGIC;
        we2 : IN STD_LOGIC;
        wb_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        wb_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        data_in1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        data_in2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        re_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        re_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        reg1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        reg2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        rst : IN STD_LOGIC
    );

END REG_BANK;

ARCHITECTURE sync_bank OF REG_BANK IS
    TYPE reg_bank_type IS ARRAY (0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    IMPURE FUNCTION init_reg_bank_hex RETURN reg_bank_type IS
        FILE text_data_file : text OPEN read_mode IS "reg_bank_content_hex.txt";
        VARIABLE text_line : line;
        VARIABLE reg_bank_content : reg_bank_type;
    BEGIN
        FOR i IN 0 TO 7 LOOP
            readline(text_data_file, text_line);
            hread(text_line, reg_bank_content(i));
        END LOOP;
        RETURN reg_bank_content;
    END FUNCTION;
    SIGNAL reg_bank : reg_bank_type := init_reg_bank_hex;
BEGIN
    reg1 <= reg_bank(conv_integer(re_addr1));
    reg2 <= reg_bank(conv_integer(re_addr2));
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            loop_rst : FOR i IN 0 TO 7 LOOP
                reg_bank(i) <= (OTHERS => '0');
            END LOOP loop_rst;
        ELSIF rising_edge(clk) THEN
            IF we1 = '1'THEN
                reg_bank(conv_integer(wb_addr1)) <= data_in1;
            END IF;
            IF we2 = '1' THEN
                reg_bank(conv_integer(wb_addr2)) <= data_in2;
            END IF;
        END IF;
    END PROCESS;
END sync_bank;