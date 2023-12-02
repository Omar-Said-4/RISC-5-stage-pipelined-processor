LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY bitset_module IS
    GENERIC (n : INTEGER := 32);
    PORT (
        bitset_pos : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        bitset_out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
    );
END ENTITY bitset_module;

ARCHITECTURE Archbitset OF bitset_module IS
    SIGNAL zeros : STD_LOGIC_VECTOR (n - 1 DOWNTO 0) := x"00000000";
    SIGNAL one : STD_LOGIC_VECTOR (n - 1 DOWNTO 0) := x"00000001";
BEGIN
    bitset_out <= one WHEN (bitset_pos = "000")
        ELSE
        one((n - 1 - to_integer(unsigned(bitset_pos))) DOWNTO 0) & zeros((to_integer(unsigned(bitset_pos)) - 1) DOWNTO 0);
END Archbitset;