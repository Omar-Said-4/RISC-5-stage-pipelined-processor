LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY immediate_val_signextend IS
    PORT (
        immediate_val : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        extended_val : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END immediate_val_signextend;
ARCHITECTURE Archimmediate_val_signextend OF immediate_val_signextend IS
BEGIN
    extended_val(15 DOWNTO 0) <= immediate_val;
    -- Set the remaining bits to the last bit of the input
    extended_val(31 DOWNTO 16) <= (OTHERS => immediate_val(15));
END Archimmediate_val_signextend;