LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Execute_tb IS
    GENERIC (n : INTEGER := 32);
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
            savedpc : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            isjmp : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL tsrc1, tsrc2, tcurrentpc, tdest1, tdest2, tcalledpc, tsavedpc, tcalledAddress : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL tfunc : STD_LOGIC_VECTOR (3 DOWNTO 0);
    SIGNAL tclk, tAluOp, tcallOp, tjmpOp, tjmpzOp, tisjmp : STD_LOGIC;
BEGIN
    u0 : Execute GENERIC MAP(n) PORT MAP(tclk, tsrc1, tsrc2, tAluOp, tcallOp, tcalledAddress, tcurrentpc, tjmpOp, tjmpzOp, tfunc, tdest1, tdest2, tcalledpc, tsavedpc, tisjmp);
    PROCESS
    BEGIN
        -- testcase 1
        tclk <= '0';
        WAIT FOR 50 ps;
        tclk <= '1';
        WAIT FOR 50 ps;
        -- testcase 2
        tclk <= '0';
        WAIT FOR 50 ps;
        tclk <= '1';
        WAIT FOR 50 ps;
        tclk <= '0';
        WAIT FOR 50 ps;
        tclk <= '1';
        WAIT FOR 50 ps;
        WAIT;
    END PROCESS;
    PROCESS
    BEGIN
        -- testcase 1 
        tsrc1 <= x"00000001";
        tsrc2 <= x"00000000";
        tAluOp <= '1';
        tfunc <= "0011";
        WAIT FOR 100 ps;
        -- testcase 2
        tsrc1 <= x"FFFFFFF0";
        tsrc2 <= x"00000001";
        tAluOp <= '0';
        tjmpzOp <= '1';
        tfunc <= "1011";
        tcalledAddress <= x"10101010";
        WAIT FOR 100 ps;
        WAIT;
    END PROCESS;
END ARCHITECTURE;