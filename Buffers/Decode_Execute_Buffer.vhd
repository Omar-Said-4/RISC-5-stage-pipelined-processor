LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Decode_Execute_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        in_src1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        in_src2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_src1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_src2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        in_MR, in_MW, in_IOR, in_IOW, in_WB1, in_WB2, in_STACK_OPERATION, in_PUSH_POP, in_JUMP, in_CALL, in_RSTCTRL, in_PROTECT, in_FREE, in_ALUop, in_RTI : IN STD_LOGIC;
        out_MR, out_MW, out_IOR, out_IOW, out_WB1, out_WB2, out_STACK_OPERATION, out_PUSH_POP, out_JUMP, out_CALL, out_RSTCTRL, out_PROTECT, out_FREE, out_ALUop, out_RTI : OUT STD_LOGIC
    );
END ENTITY Decode_Execute_Buffer;

ARCHITECTURE ArchDecode_Execute_Buffer OF Decode_Execute_Buffer IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            out_src1 <= x"00000000";
            out_src2 <= x"00000000";
            out_MR <= '0';
            out_MW <= '0';
            out_IOR <= '0';
            out_IOW <= '0';
            out_WB1 <= '0';
            out_WB2 <= '0';
            out_STACK_OPERATION <= '0';
            out_PUSH_POP <= '0';
            out_JUMP <= '0';
            out_RSTCTRL <= '0';
            out_PROTECT <= '0';
            out_FREE <= '0';
            out_ALUop <= '0';
            out_RTI <= '0';
        ELSIF rising_edge(clk) THEN
            out_src1 <= in_src1;
            out_src2 <= in_src2;
            out_MR <= in_MR;
            out_MW <= in_MW;
            out_IOR <= in_IOR;
            out_IOW <= in_IOW;
            out_WB1 <= in_WB1;
            out_WB2 <= in_WB2;
            out_STACK_OPERATION <= in_STACK_OPERATION;
            out_PUSH_POP <= in_PUSH_POP;
            out_JUMP <= in_JUMP;
            out_RSTCTRL <= in_RSTCTRL;
            out_PROTECT <= in_PROTECT;
            out_FREE <= in_FREE;
            out_ALUop <= in_ALUop;
            out_RTI <= in_RTI;
        END IF;
    END PROCESS;
END ArchDecode_Execute_Buffer;