LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Decode_Execute_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        in_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY Decode_Execute_Buffer;

ARCHITECTURE Decode_Execute_Buffer OF Decode_Execute_Buffer IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            out_instruction <= x"00000000";
        END IF;
        IF rising_edge(clk) THEN
            -- out_instruction <= in_instruction;
        END IF;
    END PROCESS;
END ArchFetch_Decode_Buffer;