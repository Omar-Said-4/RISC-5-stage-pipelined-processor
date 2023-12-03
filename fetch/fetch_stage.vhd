LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch IS

    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        fetch_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );

END ENTITY;

ARCHITECTURE ArchFetch OF Fetch IS
    COMPONENT InstMemory IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            we : IN STD_LOGIC;
            address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
            dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );

    END COMPONENT;

    SIGNAL is32BitInst : STD_LOGIC := '0';
    SIGNAL memOut : STD_LOGIC_VECTOR (15 DOWNTO 0);
    SIGNAL PC : STD_LOGIC_VECTOR (31 DOWNTO 0) := (OTHERS => '0');
    SIGNAL tempFetchOut : STD_LOGIC_VECTOR (15 DOWNTO 0);
BEGIN

    InstMem : InstMemory PORT MAP(clk, rst, '0', PC(15 DOWNTO 0), memOut);

    PROCESS (clk, rst) IS
    BEGIN
        IF rst = '1' THEN
            PC <= (OTHERS => '0');
        ELSIF rising_edge(clk) THEN
            IF memOut(14) = '1' AND is32BitInst = '0' THEN -- is 32 bit Instruction
                fetch_out <= (OTHERS => '0'); -- NOPE
                tempFetchOut <= memOut;
                is32BitInst <= '1';

            ELSIF is32BitInst = '1' THEN
                fetch_out <= tempFetchOut & memOut;
                is32BitInst <= '0';

            ELSIF is32BitInst = '0' THEN
                fetch_out <= memOut & "0000000000000000";
                is32BitInst <= '0';
            END IF;
            PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
        END IF;
    END PROCESS;

END ARCHITECTURE;