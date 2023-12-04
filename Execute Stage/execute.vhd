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
        in_EA : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        in_MR, in_MW, in_IOR, in_IOW, in_WB1, in_WB2, in_STACK_OPERATION, in_PUSH_POP, in_RSTCTRL, in_PROTECT, in_FREE, in_RTI : IN STD_LOGIC;
        dest1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        dest2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        calledpc : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        savedpc : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        -- remember to add isjmp out signal
        isjmp : OUT STD_LOGIC;
        out_EA : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
        out_MR, out_MW, out_IOR, out_IOW, out_WB1, out_WB2, out_STACK_OPERATION, out_PUSH_POP, out_RSTCTRL, out_PROTECT, out_FREE, out_RTI : OUT STD_LOGIC
    );
END ENTITY Execute;

ARCHITECTURE ArchExecute OF Execute IS
    COMPONENT ALU IS
        PORT (
            src1, src2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
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
    u0 : ALU GENERIC MAP(n) PORT MAP(src1, src2, func, out1, out2, zf, nf, cf);
    u1 : FullAdder GENERIC MAP(n) PORT MAP(currentpc, x"00000001", '0', '0', savedpc, OPEN);
    PROCESS (clk)
    BEGIN
        IF rising_edge(clk) THEN
            out_EA <= in_EA;
            out_MR <= in_MR;
            out_MW <= in_MW;
            out_IOR <= in_IOR;
            out_IOW <= in_IOW;
            out_WB1 <= in_WB1;
            out_WB2 <= in_WB2;
            out_STACK_OPERATION <= in_STACK_OPERATION;
            out_PUSH_POP <= in_PUSH_POP;
            out_RSTCTRL <= in_RSTCTRL;
            out_PROTECT <= in_PROTECT;
            out_FREE <= in_FREE;
            out_RTI <= in_RTI;
            IF (AluOp = '1') THEN
                CCR(0) <= zf;
                CCR(1) <= nf;
                CCR(2) <= cf;
                dest1 <= out1;
                dest2 <= out2;
            END IF;
            IF ((callOp = '1') OR (jmpOp = '1') OR (jmpzOp = '1' AND CCR(2) = '1')) THEN
                calledpc <= calledAddress;
                isjmp <= '1';
            ELSE
                isjmp <= '0';
            END IF;
        END IF;
    END PROCESS;
END ArchExecute;