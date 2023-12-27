

LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY forwarding_unit IS
    PORT (
        R1_alu_in, R2_alu_in : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        R1_alu_out, R2_alu_out : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        R1_mem_out, R2_mem_out : IN STD_LOGIC_VECTOR (2 DOWNTO 0);

        R1_alu_in_value, R2_alu_in_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        R1_alu_out_value, R2_alu_out_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        R1_mem_out_value, R2_mem_out_value : IN STD_LOGIC_VECTOR (31 DOWNTO 0);

        wb1_alu_out, wb2_alu_out : IN STD_LOGIC;
        wb1_mem_out, wb2_mem_out : IN STD_LOGIC;

        forwarding_unit_out1, forwarding_unit_out2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
);

END ENTITY;

ARCHITECTURE forwarding_arch OF forwarding_unit IS
    SIGNAL R1_alu_out_signal : BOOLEAN;
    SIGNAL R2_alu_out_signal : BOOLEAN;
    SIGNAL R1_mem_out_signal : BOOLEAN;
    SIGNAL R2_mem_out_signal : BOOLEAN;

BEGIN
    -- Other signal assi gnments or declarations go here...

    R1_alu_out_signal <= (R1_alu_in = R1_alu_out AND wb1_alu_out = '1') OR
        (R1_alu_in = R2_alu_out AND wb2_alu_out = '1');

    R2_alu_out_signal <= (R2_alu_in = R1_alu_out AND wb1_alu_out = '1') OR
        (R2_alu_in = R2_alu_out AND wb2_alu_out = '1');

    R1_mem_out_signal <= (R1_alu_in = R1_mem_out AND wb1_mem_out = '1') OR
        (R1_alu_in = R2_mem_out AND wb2_mem_out = '1');

    R2_mem_out_signal <= (R2_alu_in = R1_mem_out AND wb1_mem_out = '1') OR
        (R2_alu_in = R2_mem_out AND wb2_mem_out = '1');

    forwarding_unit_out1 <= R1_alu_out_value WHEN R1_alu_out_signal = TRUE 
    ELSE R1_mem_out_value WHEN R1_mem_out_signal = TRUE
    ELSE R1_alu_in_value;

    forwarding_unit_out2 <= R2_alu_out_value WHEN R2_alu_out_signal = TRUE 
    ELSE R2_mem_out_value WHEN R2_mem_out_signal = TRUE
    ELSE R2_alu_in_value;

END ARCHITECTURE;
