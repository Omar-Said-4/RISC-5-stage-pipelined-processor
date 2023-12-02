LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Execute IS
    GENERIC (n : INTEGER := 32);
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
        -- remember to add isjmp out signal
    );
END ENTITY Execute;

ARCHITECTURE ArchExecute OF Execute IS
    COMPONENT ALU IS
        PORT (
            src1, src2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            AluOp : IN STD_LOGIC;
            func : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
            dest1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            dest2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            zf : OUT STD_LOGIC;
            nf : OUT STD_LOGIC;
            cf : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT FullAdder IS
        PORT (
            X, Y : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Cin, M : IN STD_LOGIC;
            Sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Cout : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL out1, out2 : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL zf, nf, cf : STD_LOGIC;
    -- Z ZERO Flag
    -- N Negative Flag
    -- C Carry Flag
    SIGNAL CCR : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
BEGIN
    u0 : ALU GENERIC MAP(n) PORT MAP(src1, src2, AluOp, func, out1, out2, zf, nf, cf);
    u1 : FullAdder GENERIC MAP(n) PORT MAP(currentpc, x"00000001", '0', '0', savedpc, OPEN);
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            IF (AluOp = '1') THEN
                CCR(0) <= zf;
                CCR(1) <= nf;
                CCR(2) <= cf;
                dest1 <= out1;
                dest2 <= out2;
            END IF;
            IF ((callOp = '1') OR (jmpOp = '1') OR (jmpzOp = '1' AND CCR(2) = '1')) THEN
                calledpc <= calledAddress;
            END IF;
        END IF;
    END PROCESS;
END ArchExecute;