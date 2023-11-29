LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY CU IS
    PORT (
        clk, reset : IN STD_LOGIC;
        op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        function_code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        MR, MW, IOR, IOW, WB1, WB2, STACK_OPERATION, PUSH_POP, JUMP, CALL, RSTCTRL, PROTECT, FREE, ALU, RTI, JZ : OUT STD_LOGIC);
END CU;
ARCHITECTURE CU_ARCH OF CU IS
BEGIN
    PROCESS (clk, reset)
    BEGIN
        IF reset = '1' THEN
            MR <= '0';
            MW <= '0';
            RTI <= '0';
            IOR <= '0';
            IOW <= '0';
            WB1 <= '0';
            WB2 <= '0';
            ALU <= '0';
            STACK_OPERATION <= '0';
            PUSH_POP <= '0';
            JUMP <= '0';
            CALL <= '0';
            RSTCTRL <= '1';
            PROTECT <= '0';
            FREE <= '0';
        ELSIF rising_edge(clk) THEN
            IF op_code = "00" THEN
                MR <= '0';
                JZ <= '0';
                MW <= '0';
                IOR <= '0';
                ALU <= '1';
                RTI <= '0';
                IOW <= '0';
                STACK_OPERATION <= '0';
                PUSH_POP <= '0';
                JUMP <= '0';
                CALL <= '0';
                RSTCTRL <= '0';
                PROTECT <= '0';
                FREE <= '0';
                IF (function_code = "1010") THEN
                    WB1 <= '0';
                    WB2 <= '0';
                ELSIF (function_code = "1110") THEN
                    WB1 <= '1';
                    WB2 <= '1';
                ELSE
                    WB1 <= '1';
                    WB2 <= '0';
                END IF;
            ELSIF op_code = "01" THEN
                IOR <= '0';
                RTI <= '0';
                IOW <= '0';
                WB1 <= function_code(0);
                WB2 <= '0';
                JUMP <= '0';
                JZ <= '0';
                CALL <= '0';
                RSTCTRL <= '0';
                ALU <= '0';
                IF (function_code(2 DOWNTO 0) = "110") THEN
                    STACK_OPERATION <= '1';
                    PUSH_POP <= '1';
                ELSIF (function_code(2 DOWNTO 0) = "111") THEN
                    STACK_OPERATION <= '1';
                    PUSH_POP <= '0';
                ELSE
                    STACK_OPERATION <= '0';
                    PUSH_POP <= '0';
                END IF;
                IF function_code(2 DOWNTO 0) = "100" THEN
                    PROTECT <= '1';
                    FREE <= '0';
                ELSIF function_code(2 DOWNTO 0) = "000" THEN
                    PROTECT <= '0';
                    FREE <= '1';
                ELSE
                    PROTECT <= '0';
                    FREE <= '0';
                END IF;
                IF function_code(2 DOWNTO 0) = "110" OR function_code(2 DOWNTO 0) = "010" THEN
                    MW <= '1';
                ELSE
                    MW <= '0';
                END IF;
                IF function_code(2 DOWNTO 0) = "111" OR function_code(2 DOWNTO 0) = "011" THEN
                    MR <= '1';
                ELSE
                    MR <= '0';
                END IF;
            ELSIF op_code = "10" THEN
                MR <= '0';
                MW <= '0';
                IOR <= NOT function_code(0);
                IOW <= function_code(0);
                WB1 <= '0';
                WB2 <= '0';
                ALU <= '0';
                RTI <= '0';
                JZ <= 0;
                STACK_OPERATION <= '0';
                PUSH_POP <= '0';
                JUMP <= '0';
                CALL <= '0';
                RSTCTRL <= '0';
                PROTECT <= '0';
                FREE <= '0';
            ELSIF op_code = "11" THEN
                IOR <= '0';
                IOW <= '0';
                WB1 <= '0';
                WB2 <= '0';
                ALU <= '0';
                PROTECT <= '0';
                FREE <= '0';
                RTI <= function_code(0) AND NOT function_code(1) AND NOT function_code(2);
                RSTCTRL <= '0';
                IF (function_code(2 DOWNTO 0) = "010") THEN
                    JZ <= '1';
                ELSE
                    JZ <= '0';
                END IF;
                IF (function_code(2 DOWNTO 0) = "111") THEN
                    MR <= '0';
                    MW <= '0';
                    STACK_OPERATION <= '0';
                    PUSH_POP <= '0';
                    JUMP <= '0';
                    CALL <= '0';
                ELSE
                    MR <= function_code(0);
                    MW <= NOT (function_code(1) OR function_code(2) OR function_code(0));
                    PUSH_POP <= NOT (function_code(1) OR function_code(2) OR function_code(0));
                    CALL <= NOT (function_code(1) OR function_code(2) OR function_code(0));
                    STACK_OPERATION <= NOT function_code(1);
                    JUMP <= function_code(1);
                END IF;
            END IF;
        END IF;
    END PROCESS;
END CU_ARCH;