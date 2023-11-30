LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY InstMemory IS PORT (
    clk : IN STD_LOGIC;
    rst : IN STD_LOGIC;
    we : IN STD_LOGIC;
    address : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    dataout : OUT STD_LOGIC_VECTOR(15 DOWNTO 0));
END ENTITY InstMemory;

ARCHITECTURE sync_InstMemory_a OF InstMemory IS
    TYPE InstMemory_type IS ARRAY(0 TO 4096) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL InstMemory : InstMemory_type := (OTHERS => (OTHERS => '1')); -- Initial values;
BEGIN

    PROCESS (clk, rst) IS
    BEGIN
        IF rst = '1' THEN
            InstMemory <= (OTHERS => (OTHERS => '0'));
        END IF;
    END PROCESS;

    dataout <= InstMemory(to_integer(unsigned((address))));

END sync_InstMemory_a;