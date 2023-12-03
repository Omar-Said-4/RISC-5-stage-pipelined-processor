LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    (
    clk : IN STD_LOGIC;
    INT : IN STD_LOGIC;
    RST : IN STD_LOGIC
    );
END memory;

ARCHITECTURE CPU_ARCH OF CPU IS
    COMPONENT Fetch(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        fetch_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END CPU_ARCH;