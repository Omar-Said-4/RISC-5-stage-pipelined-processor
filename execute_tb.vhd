LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Execute_tb IS
    GENERIC (n : INTEGER := 8);
END Execute_tb;

ARCHITECTURE Behavioral OF Execute_tb IS
    COMPONENT Execute IS
        PORT (
            clk : IN STD_LOGIC;
            src1, src2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            AluOp : IN STD_LOGIC;
            callOp : IN STD_LOGIC;
            calledAddress : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            currentpc : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            jmpOp : IN STD_LOGIC;
            jmpzOp : IN STD_LOGIC;
            func : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            dest1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            dest2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            calledpc : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            savedpc : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL tsrc1, tsrc2, tcurrentpc, tdest1, tdest2, tcalledpc, tsavedpc, tcalledAddress : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL tfunc : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL tclk, tAluOp, tcallOp, tjmpOp, tjmpzOp : STD_LOGIC;
BEGIN
    u0 : Execute GENERIC MAP(n) PORT MAP(tclk, tsrc1, tsrc2, tAluOp, tcallOp, tcalledAddress, tcurrentpc, tjmpOp, tjmpzOp, tfunc, tdest1, tdest2, tcalledpc, tsavedpc);
    PROCESS
    BEGIN
        tclk <= '1';
        WAIT FOR 100 ps;
        tclk <= '0';
        WAIT FOR 100 ps;
        tclk <= '1';
        WAIT FOR 100 ps;
        tclk <= '0';
        WAIT FOR 100 ps;
        WAIT;
    END PROCESS;
    PROCESS
    BEGIN
        -- testcase 1 
        tsrc1 <= x"F0";
        tsrc2 <= x"00";
        tAluOp <= '1';
        tfunc <= "1011";
        WAIT FOR 100 ps;
        -- testcase 2
        tsrc1 <= x"F0";
        tsrc2 <= x"01";
        tAluOp <= '1';
        tfunc <= "1011";
        WAIT FOR 100 ps;
        tsrc1 <= x"F0";
        tsrc2 <= x"02";
        tAluOp <= '1';
        tfunc <= "1011";
        WAIT FOR 100 ps;
        WAIT;
    END PROCESS;
END ARCHITECTURE;