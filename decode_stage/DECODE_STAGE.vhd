LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY decode IS
    PORT (
        clk : IN STD_LOGIC;
        reset : IN STD_LOGIC;
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
        op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
        function_code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        MR, MW, IOR, IOW, WB1, WB2, STACK_OPERATION, PUSH_POP, JUMP, CALL, RSTCTRL, PROTECT, FREE, ALU, RTI : OUT STD_LOGIC
    );
END decode;
ARCHITECTURE DEC_ARCH OF decode IS
    COMPONENT CU IS
        PORT (
            clk, reset : IN STD_LOGIC;
            op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            function_code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            MR, MW, IOR, IOW, WB1, WB2, STACK_OPERATION, PUSH_POP, JUMP, CALL, RSTCTRL, PROTECT, FREE, ALU, RTI : OUT STD_LOGIC
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
BEGIN
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
        reg1 => reg1,
        reg2 => reg2,
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
        RTI => RTI
    );
END DEC_ARCH;