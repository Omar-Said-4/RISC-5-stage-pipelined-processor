LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY Fetch IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        fetch_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        currentPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_is32BitInst : OUT STD_LOGIC;
        out_immediate : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
        is_jmp_execute : IN STD_LOGIC;
        jmp_execute_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        is_jmp_mem : IN STD_LOGIC;
        jmp_mem_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        reset_PC_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
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

    PROCESS (clk, reset) IS
    BEGIN
        IF (reset = '1') THEN
            PC <= reset_PC_address;
            fetch_out <= (OTHERS => '1'); -- NOPE
            out_is32BitInst <= '0';
        ELSIF rising_edge(clk) THEN
            IF memOut(13) = '1' AND is32BitInst = '0' THEN -- is 32 bit Instruction
                fetch_out <= (OTHERS => '1'); -- NOPE
                tempFetchOut <= memOut;
                is32BitInst <= '1';
                out_is32BitInst <= '0';

            ELSIF is32BitInst = '1' THEN
                fetch_out <= tempFetchOut & memOut;
                out_immediate <= memOut;
                is32BitInst <= '0';
                out_is32BitInst <= '1';
            ELSIF is32BitInst = '0' THEN
                fetch_out <= memOut & "0000000000000000";
                out_immediate <= "0000000000000000";
                is32BitInst <= '0';
                out_is32BitInst <= '0';
            END IF;
            currentPC <= PC;
            IF is_jmp_mem = '1' THEN
                PC <= jmp_mem_address;
            ELSIF is_jmp_execute = '1' THEN
                PC <= jmp_execute_address;
            ELSE
                PC <= STD_LOGIC_VECTOR(unsigned(PC) + 1);
            END IF;
        END IF;
    END PROCESS;

END ARCHITECTURE;