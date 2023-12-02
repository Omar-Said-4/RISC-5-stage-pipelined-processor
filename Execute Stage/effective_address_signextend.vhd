LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY effective_address_signextend IS
    PORT (
        effective_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
        extended_val : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END effective_address_signextend;
ARCHITECTURE Archeffective_address_signextend OF effective_address_signextend IS
BEGIN
    extended_val(19 DOWNTO 0) <= effective_address;
    -- Set the remaining bits to '0'
    extended_val(31 DOWNTO 20) <= (OTHERS => '0');
END Archeffective_address_signextend;