

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hazard_detection_unit IS
    PORT (
        Rsrc1_decode, Rsrc2_decode : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rdst1_alu, Rdst2_alu : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        m_read_signal : IN STD_LOGIC;
        stall_signal : OUT STD_LOGIC
    );

END ENTITY;

ARCHITECTURE hazard_detection_arch OF hazard_detection_unit IS
    SIGNAL hazard_condition : BOOLEAN;
BEGIN
    -- Other signal assignments or declarations go here...

    hazard_condition <= (Rsrc1_decode = Rdst1_alu AND m_read_signal = '1') OR
                        (Rsrc2_decode = Rdst1_alu AND m_read_signal = '1');

    WITH hazard_condition SELECT
        stall_signal <= '1' WHEN TRUE,
                        '0' WHEN OTHERS;

END ARCHITECTURE;