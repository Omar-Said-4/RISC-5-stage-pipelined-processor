LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY test IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        in_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
    );
END ENTITY test;

ARCHITECTURE Archtest OF test IS
    COMPONENT Fetch_Decode_Buffer IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            in_instruction : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_instruction : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL mid_instruction : STD_LOGIC_VECTOR (31 DOWNTO 0);
BEGIN
    u0 : Fetch_Decode_Buffer PORT MAP(
        clk => clk,
        rst => rst,
        in_instruction => in_instruction,
        out_instruction => mid_instruction
    );
    u1 : Fetch_Decode_Buffer PORT MAP(
        clk => clk,
        rst => rst,
        in_instruction => mid_instruction,
        out_instruction => out_instruction
    );
END Archtest;