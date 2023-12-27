LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY cpu_tb IS
    GENERIC (n : INTEGER := 32);
END cpu_tb;

ARCHITECTURE behavior OF cpu_tb IS
    COMPONENT cpu
        PORT (
            clk : IN STD_LOGIC;
            INT : IN STD_LOGIC;
            reset : IN STD_LOGIC
        );
    END COMPONENT;

    SIGNAL clk : STD_LOGIC := '1';
    SIGNAL reset, int : STD_LOGIC;
BEGIN
    uut : cpu GENERIC MAP(
        n) PORT MAP(
        clk => clk,
        INT => INT,
        reset => reset
    );

    clk_process : PROCESS
    BEGIN
        clk <= NOT clk;
        WAIT FOR 50 ps;
    END PROCESS;

    stim_proc : PROCESS
    BEGIN
        INT <= '0';
        reset <= '1';
        WAIT FOR 200 ps;
        reset <= '0';
        -- WAIT FOR 10 ns;
        -- RST <= '0';
        -- WAIT FOR 100 ns;
        -- INT <= '1';
        -- WAIT FOR 10 ns;
        -- INT <= '0';
        WAIT;
    END PROCESS;
END behavior;