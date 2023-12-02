LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY ALU IS
    GENERIC (n : INTEGER := 32);
    PORT (
        src1, src2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        AluOp : IN STD_LOGIC;
        func : IN STD_LOGIC_VECTOR (3 DOWNTO 0);
        dest1 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        dest2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
        -- Z ZERO Flag
        zf : OUT STD_LOGIC;
        -- N Negative Flag
        nf : OUT STD_LOGIC;
        -- C Carry Flag
        cf : OUT STD_LOGIC
    );
END ENTITY ALU;
ARCHITECTURE ArchALU OF ALU IS
    COMPONENT FullAdder IS
        PORT (
            X, Y : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Cin, M : IN STD_LOGIC;
            Sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
            Cout : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT bitset_module IS
        PORT (
            bitset_pos : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            bitset_out : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL out1, out2, decFullAdderOut, FullAdderOut, incAdderOut, decAdderOut, bitset_out : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL decFullAdderCout, FullAdderCout, incAdderCout, decAdderCout : STD_LOGIC;
BEGIN
    u0 : FullAdder GENERIC MAP(n) PORT MAP(src1, src2, '0', '0', FullAdderOut, FullAdderCout);
    u1 : FullAdder GENERIC MAP(n) PORT MAP(src1, x"00000001", '0', '0', incAdderOut, incAdderCout);
    u2 : FullAdder GENERIC MAP(n) PORT MAP(src1, x"00000001", '1', '1', decAdderOut, decAdderCout);
    u3 : FullAdder GENERIC MAP(n) PORT MAP(src1, src2, '1', '1', decFullAdderOut, decFullAdderCout);
    u4 : bitset_module GENERIC MAP(n) PORT MAP(src2(2 DOWNTO 0), bitset_out);
    out1 <= (NOT src1) WHEN (AluOp = '1') AND (func = "0000")
        ELSE
        STD_LOGIC_VECTOR(to_signed(to_integer(0 - signed(src1)), n)) WHEN (AluOp = '1') AND (func = "0001")
        ELSE
        incAdderOut WHEN (AluOp = '1') AND (func = "0010")
        ELSE
        decAdderOut WHEN (AluOp = '1') AND (func = "0011")
        ELSE
        FullAdderOut WHEN (AluOp = '1') AND (func = "0100" OR func = "0101")
        ELSE
        decFullAdderOut WHEN (AluOp = '1') AND (func = "0110")
        ELSE
        (src1 AND src2)WHEN (AluOp = '1') AND (func = "0111")
        ELSE
        (src1 XOR src2)WHEN (AluOp = '1') AND (func = "1000")
        ELSE
        (src1 OR src2)WHEN (AluOp = '1') AND (func = "1001")
        ELSE
        (x"00000001")WHEN (AluOp = '1') AND (func = "1010") AND (src1 > src2)
        ELSE
        (x"FFFFFFFF")WHEN (AluOp = '1') AND (func = "1010") AND (src1 < src2)
        ELSE
        (x"00000000")WHEN (AluOp = '1') AND (func = "1010") AND (src1 = src2)
        ELSE
        (src1 OR bitset_out) WHEN (AluOp = '1') AND (func = "1011")
        ELSE
        src1(to_integer(unsigned(src2) - 1) DOWNTO 0) & src1((n - 1) DOWNTO to_integer(unsigned(src2)))WHEN (AluOp = '1') AND (func = "1100")
        ELSE
        src1(to_integer((n - 1) - unsigned(src2)) DOWNTO 0) & src1((n - 1) DOWNTO to_integer(n - unsigned(src2))) WHEN (AluOp = '1') AND (func = "1101")
        ELSE
        src2 WHEN (AluOp = '1') AND (func = "1110")
        ELSE
        src2;
    -- swap case
    out2 <= src1 WHEN (AluOp = '1') AND (func = "1110")
        ELSE
        src1;
    -- flags case
    zf <= '1'WHEN (AluOp = '1') AND (out1 = x"00")
        ELSE
        '0';
    cf <= FullAdderCout WHEN (AluOp = '1') AND (func = "0100" OR func = "0101")
        ELSE
        incAdderCout WHEN (AluOp = '1') AND (func = "0010")
        ELSE
        decAdderCout WHEN (AluOp = '1') AND (func = "0011")
        ELSE
        decFullAdderCout WHEN (AluOp = '1') AND (func = "0110")
        ELSE
        '0';
    nf <= '1' WHEN (AluOp = '1') AND (out1(n - 1) = '1')
        ELSE
        '0';
    dest1 <= out1;
    dest2 <= out2;
END ArchALU;