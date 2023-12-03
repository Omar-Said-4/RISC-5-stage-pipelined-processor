LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    GENERIC (n : INTEGER := 32);
    PORT (
        clk : IN STD_LOGIC;
        INT : IN STD_LOGIC;
        RST : IN STD_LOGIC
    );
END ENTITY CPU;

ARCHITECTURE CPU_ARCH OF CPU IS
    COMPONENT Fetch IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            fetch_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT decode IS
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
    END COMPONENT;
    SIGNAL instr : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_reg1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_reg2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_mr : STD_LOGIC;
    SIGNAL in_mw : STD_LOGIC;
    SIGNAL in_ior : STD_LOGIC;
    SIGNAL in_iow : STD_LOGIC;
    SIGNAL in_wb1 : STD_LOGIC;
    SIGNAL in_wb2 : STD_LOGIC;
    SIGNAL in_stack_operation : STD_LOGIC;
    SIGNAL in_push_pop : STD_LOGIC;
    SIGNAL in_jump : STD_LOGIC;
    SIGNAL in_call : STD_LOGIC;
    SIGNAL in_rstctrl : STD_LOGIC;
    SIGNAL in_protect : STD_LOGIC;
    SIGNAL in_free : STD_LOGIC;
    SIGNAL in_aluop : STD_LOGIC;
    SIGNAL in_rti : STD_LOGIC;
BEGIN
    u0 : Fetch PORT MAP(
        clk => clk,
        rst => rst,
        fetch_out => instr
    );
    u2 : decode PORT MAP(
        clk => clk,
        reset => rst,
        we1 => '0',
        we2 => '0',
        wb_addr1 => "000",
        wb_addr2 => "000",
        data_in1 => x"00000000",
        data_in2 => x"00000000",
        re_addr1 => instr(9 DOWNTO 7),
        re_addr2 => instr(6 DOWNTO 4),
        reg1 => in_reg1,
        reg2 => in_reg2,
        op_code => instr(15 DOWNTO 14),
        function_code => instr(3 DOWNTO 0),
        MR => in_mr,
        MW => in_mw,
        IOR => in_ior,
        IOW => in_iow,
        WB1 => in_wb1,
        WB2 => in_wb2,
        STACK_OPERATION => in_stack_operation,
        PUSH_POP => in_push_pop,
        JUMP => in_jump,
        CALL => in_call,
        RSTCTRL => in_rstctrl,
        PROTECT => in_protect,
        FREE => in_free,
        ALU => in_aluop,
        RTI => in_rti
    );
END CPU_ARCH;