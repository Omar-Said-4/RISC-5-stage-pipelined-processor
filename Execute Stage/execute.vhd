LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;

ENTITY Execute IS
    GENERIC (n : INTEGER := 32);
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        src1, src2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        AluOp : IN STD_LOGIC;
        callOp : IN STD_LOGIC;
        ior : IN STD_LOGIC;
        iow : IN STD_LOGIC;
        calledAddress : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        currentpc : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        jmpOp : IN STD_LOGIC;
        jmpzOp : IN STD_LOGIC;
        func : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        in_EA : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        in_wb_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        in_wb_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        in_MR, in_MW, in_WB1, in_WB2, in_STACK_OPERATION, in_PUSH_POP, in_RSTCTRL, in_PROTECT, in_FREE, in_RTI, in_RET : IN STD_LOGIC;
        dest1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        dest2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        calledpc : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        fetched_jmp_address : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        fetched_is_jmp : OUT STD_LOGIC;
        -- remember to add isjmp out signal
        out_callOp : OUT STD_LOGIC;
        out_wb_addr1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        out_wb_addr2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        -- change to 31 bit instaed of 19
        out_EA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_MR, out_MW, out_WB1, out_WB2, out_STACK_OPERATION, out_PUSH_POP, out_RSTCTRL, out_PROTECT, out_FREE, out_RTI, out_RET : OUT STD_LOGIC
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
    COMPONENT effective_address_signextend IS
        PORT (
            effective_address : IN STD_LOGIC_VECTOR (19 DOWNTO 0);
            extended_val : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL out1, out2 : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL zf, nf, cf : STD_LOGIC;
    -- Z ZERO Flag
    -- N Negative Flag
    -- C Carry Flag
    SIGNAL CCR : STD_LOGIC_VECTOR (2 DOWNTO 0) := "000";
    SIGNAL mid_EA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL IN_PORT : STD_LOGIC_VECTOR(31 DOWNTO 0) := x"00000000";
    SIGNAL OUT_PORT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL savedpc : STD_LOGIC_VECTOR (31 DOWNTO 0);

BEGIN
    u0 : ALU GENERIC MAP(n) PORT MAP(src1, src2, func, out1, out2, zf, nf, cf);
    u1 : FullAdder GENERIC MAP(n) PORT MAP(currentpc, x"00000001", '0', '0', savedpc, OPEN);
    u2 : effective_address_signextend PORT MAP(in_EA, mid_EA);
    PROCESS (clk)
    BEGIN
        IF (reset = '1') THEN
            CCR <= "000";
            OUT_PORT <= x"00000000";
            IN_PORT <= x"00000000";
            out_MR <= '1';
            out_MW <= '0';
            out_WB1 <= '0';
            out_WB2 <= '0';
            out_STACK_OPERATION <= '0';
            out_PUSH_POP <= '0';
            out_RSTCTRL <= '0';
            out_PROTECT <= '0';
            out_FREE <= '0';
            out_RTI <= '0';
            out_RET <= '0';
            out_wb_addr1 <= "000";
            out_wb_addr2 <= "000";
            out_callOp <= '0';
            out_EA <= x"00000000";
            fetched_jmp_address <= x"00000000";
            fetched_is_jmp <= '0';
            dest1 <= x"00000000";
            dest2 <= x"00000000";
            calledpc <= x"00000000";
        ELSIF rising_edge(clk) THEN
            IF (iow = '1') THEN
                OUT_PORT <= src1;
            END IF;
            out_MR <= in_MR;
            out_MW <= in_MW;
            out_WB1 <= in_WB1;
            out_WB2 <= in_WB2;
            out_STACK_OPERATION <= in_STACK_OPERATION;
            out_PUSH_POP <= in_PUSH_POP;
            out_RSTCTRL <= in_RSTCTRL;
            out_PROTECT <= in_PROTECT;
            out_FREE <= in_FREE;
            out_RTI <= in_RTI;
            out_RET <= in_RET;
            out_wb_addr1 <= in_wb_addr1;
            out_wb_addr2 <= in_wb_addr2;
            IF (AluOp = '1') THEN
                CCR(0) <= zf;
                CCR(1) <= nf;
                CCR(2) <= cf;
                dest1 <= out1;
                dest2 <= out2;
            ELSIF (ior = '1') THEN
                dest1 <= IN_PORT;
                dest2 <= src2;
            ELSIF (callOp = '1') THEN
                dest1 <= savedpc;
                dest2 <= src2;
            ELSE
                dest1 <= src1;
                dest2 <= src2;
            END IF;
            IF ((jmpOp = '1') OR (jmpzOp = '1' AND CCR(0) = '1')) THEN
                fetched_jmp_address <= src1;
                fetched_is_jmp <= '1';
            ELSE
                fetched_is_jmp <= '0';
            END IF;
            IF (callOp = '1') THEN
                calledpc <= calledAddress;
                out_callOp <= '1';
            ELSE
                out_callOp <= '0';
            END IF;
            out_EA <= mid_EA;
        END IF;
    END PROCESS;
END ArchExecute;