LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY decode IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
        we1 : IN STD_LOGIC;
        we2 : IN STD_LOGIC;
        in_is32BitInst : IN STD_LOGIC;
        in_currentPC : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_currentPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        wb_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        wb_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        wb_addr_fetch1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        wb_addr_fetch2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        data_in1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        data_in2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        re_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        immediate : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
        re_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        reg1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        reg2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        function_code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        EA_IN : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
        EA : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
        out_func : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        out_wb_addr1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        out_wb_addr2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        MR, MW, IOR, IOW, WB1, WB2, STACK_OPERATION, PUSH_POP, JUMP, CALL, RSTCTRL, PROTECT, FREE, ALU, RTI, JZ, RET : OUT STD_LOGIC
    );
END decode;
ARCHITECTURE DEC_ARCH OF decode IS
    COMPONENT CU IS
        PORT (
            clk, reset : IN STD_LOGIC;
            op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            function_code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            MR, MW, IOR, IOW, WB1, WB2, STACK_OPERATION, PUSH_POP, JUMP, CALL, RSTCTRL, PROTECT, FREE, ALU, RTI, JZ, RET : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT REG_BANK IS
        PORT (
            clk : IN STD_LOGIC;
            we1 : IN STD_LOGIC;
            we2 : IN STD_LOGIC;
            wb_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            wb_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            data_in1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            re_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            re_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            reg1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            reg2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            rst : IN STD_LOGIC
        );
    END COMPONENT;
    COMPONENT immediate_val_signextend IS
        PORT (
            immediate_val : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            extended_val : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL src_out2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL src_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL extended_val : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    u0 : immediate_val_signextend PORT MAP(
        immediate_val => immediate,
        extended_val => extended_val
    );
    comp_reg_bank : REG_BANK PORT MAP(
        clk => clk,
        we1 => we1,
        we2 => we2,
        wb_addr1 => wb_addr1,
        wb_addr2 => wb_addr2,
        data_in1 => data_in1,
        data_in2 => data_in2,
        re_addr1 => re_addr1,
        re_addr2 => re_addr2,
        reg1 => src_out1,
        reg2 => src_out2,
        rst => reset
    );
    comp_cu : CU PORT MAP(
        clk => clk,
        reset => reset,
        op_code => op_code,
        function_code => function_code,
        MR => MR,
        MW => MW,
        IOR => IOR,
        IOW => IOW,
        WB1 => WB1,
        WB2 => WB2,
        STACK_OPERATION => STACK_OPERATION,
        PUSH_POP => PUSH_POP,
        JUMP => JUMP,
        CALL => CALL,
        RSTCTRL => RSTCTRL,
        PROTECT => PROTECT,
        FREE => FREE,
        ALU => ALU,
        RTI => RTI,
        JZ => JZ,
        RET => RET
    );
    -- reg2 <= src_out2 WHEN in_is32BitInst = '0' ELSE
    --     x"0000" & immediate;
    PROCESS (clk)
    BEGIN
        IF (clk'EVENT AND clk = '1') THEN
            reg1 <= src_out1;
            -- in case of
            --protect
            --free
            IF (op_code = "01" AND (function_code(2 DOWNTO 0) = "100" OR function_code(2 DOWNTO 0) = "000")) THEN
                EA <= src_out1(19 DOWNTO 0);
            ELSE
                EA <= EA_IN;
            END IF;
            out_currentPC <= in_currentPC;
            out_func <= function_code;
            out_wb_addr1 <= wb_addr_fetch1;
            out_wb_addr2 <= wb_addr_fetch1;
            IF (in_is32BitInst = '0') THEN
                -- i did this beacuse OR R2,R5 will give me error in reg2 value always    
                reg2 <= src_out2;
                -- why i did this    
                -- reg2 <= data_in1;
            ELSE
                reg2 <= extended_val;
            END IF;
        END IF;
    END PROCESS;
END DEC_ARCH;