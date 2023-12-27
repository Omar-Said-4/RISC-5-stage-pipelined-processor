LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
ENTITY InstMemory IS PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    we : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY InstMemory;

ARCHITECTURE sync_InstMemory_a OF InstMemory IS
    TYPE rom_type IS ARRAY(0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    IMPURE FUNCTION init_inst_rom_hex RETURN rom_type IS
        FILE text_data_file : text OPEN read_mode IS "flash_rom_content.txt";
        VARIABLE text_line : line;
        VARIABLE rom_content : rom_type;
    BEGIN
        FOR i IN 0 TO 4095 LOOP
            readline(text_data_file, text_line);
            read(text_line, rom_content(i));
        END LOOP;
        RETURN rom_content;
    END FUNCTION;

    SIGNAL InstMemory : rom_type := init_inst_rom_hex;
BEGIN

    PROCESS (clk, rst) IS
    BEGIN
        IF rst = '1' THEN
            InstMemory <= (OTHERS => (OTHERS => '1'));
        END IF;
    END PROCESS;

    dataout <= InstMemory(to_integer(unsigned((address))));

END sync_InstMemory_a;