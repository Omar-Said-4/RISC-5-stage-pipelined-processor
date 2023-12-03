LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY test_tb IS
    -- GENERIC (n : INTEGER := 32);
END test_tb;

ARCHITECTURE Archtest OF test_tb IS
    COMPONENT test IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            in_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL tclk, trst : STD_LOGIC;
    SIGNAL tin_instruction, tout_instruction : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
    uut : test PORT MAP(
        clk => tclk,
        rst => trst,
        in_instruction => tin_instruction,
        out_instruction => tout_instruction
    );

    clk_process : PROCESS
    BEGIN
        tclk <= '0';
        WAIT FOR 50 ps;
        tclk <= '1';
        WAIT FOR 50 ps;
        tclk <= '0';
        WAIT FOR 50 ps;
        tclk <= '1';
        WAIT FOR 50 ps;
        WAIT;
    END PROCESS;

    PROCESS
    BEGIN
        tin_instruction <= x"00000001";
        WAIT FOR 100 ps;
        tin_instruction <= x"00000002";
        WAIT FOR 100 ps;
        WAIT;
    END PROCESS;

END ARCHITECTURE;