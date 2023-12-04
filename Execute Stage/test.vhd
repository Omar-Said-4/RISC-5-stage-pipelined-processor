LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY test IS
    PORT (
        clk : IN STD_LOGIC;
        in_src1, in_src2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_src1, out_src2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        in_RTI : IN STD_LOGIC;
        out_RTI : OUT STD_LOGIC
    );
END ENTITY test;

ARCHITECTURE Archtest OF test IS
BEGIN
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            out_src1 <= in_src1;
            out_src2 <= in_src2;
            out_RTI <= in_RTI;
        END IF;
    END PROCESS;
END Archtest;