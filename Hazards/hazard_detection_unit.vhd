

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY hazard_detection_unit IS
    PORT (
        Rsrc1_decode, Rsrc2_decode : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        Rdst1_alu : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        code : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        m_read_signal : IN STD_LOGIC;
        stall_signal : OUT STD_LOGIC
    );

END ENTITY;

ARCHITECTURE hazard_detection_arch OF hazard_detection_unit IS
    SIGNAL hazard_condition : BOOLEAN;
    SIGNAL ALU : BOOLEAN;
    SIGNAL POP : BOOLEAN;
    SIGNAL LDD : BOOLEAN;
    SIGNAL INN : BOOLEAN;
    SIGNAL NOPE : BOOLEAN;
BEGIN

    ALU <= ((code(15 DOWNTO 14) = "00"));
    POP <= ((code(15 DOWNTO 14) = "01") AND (code(2 DOWNTO 0) = "111"));
    LDD <= ((code(15 DOWNTO 14) = "01") AND (code(2 DOWNTO 0) = "011"));
    INN <= ((code(15 DOWNTO 14) = "10") AND (code(0) = '0'));
    NOPE <= (code = "1111111111111111");

    hazard_condition <= ((Rsrc1_decode = Rdst1_alu AND m_read_signal = '1' AND POP = FALSE AND LDD = FALSE AND INN = FALSE AND NOPE = FALSE) OR
        (Rsrc2_decode = Rdst1_alu AND m_read_signal = '1' AND ALU = TRUE));

    WITH hazard_condition SELECT
        stall_signal <= '1' WHEN TRUE,
        '0' WHEN OTHERS;
END ARCHITECTURE;