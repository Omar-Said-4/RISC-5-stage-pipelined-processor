LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Fetch_Decode_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        in_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY Fetch_Decode_Buffer;

ARCHITECTURE ArchFetch_Decode_Buffer OF Fetch_Decode_Buffer IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            out_instruction <= x"00000000";
        ELSIF rising_edge(clk) THEN
            out_instruction <= in_instruction;
        END IF;
    END PROCESS;
END ArchFetch_Decode_Buffer;