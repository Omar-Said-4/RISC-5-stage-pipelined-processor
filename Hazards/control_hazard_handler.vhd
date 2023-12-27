
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY control_handler_unit IS
    PORT (
        JMP_ALU : IN STD_LOGIC;
        JMP_MEMORY : IN STD_LOGIC;

        fetch_flush, decode_flush, alu_flush, memory_flush : OUT STD_LOGIC
    );

END ENTITY;

ARCHITECTURE control_handler_arch OF control_handler_unit IS
BEGIN

    WITH ALU SELECT
        memory_flush <= '1' WHEN '1',
        '0' WHEN OTHERS;

    WITH JMP_MEMORY SELECT
        memory_flush <= '1' WHEN '1',
        '0' WHEN OTHERS;

    WITH JMP_MEMORY SELECT
        memory_flush <= '1' WHEN '1',
        '0' WHEN OTHERS;

    WITH JMP_MEMORY SELECT
        memory_flush <= '1' WHEN '1',
        '0' WHEN OTHERS;

END ARCHITECTURE;