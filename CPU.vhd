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
    COMPONENT test IS
        PORT (
            clk : IN STD_LOGIC;
            in_src1, in_src2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            out_src1, out_src2 : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            in_RTI : IN STD_LOGIC;
            out_RTI : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT Fetch IS
        PORT (
            clk : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            fetch_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            currentPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_is32BitInst : OUT STD_LOGIC;
            out_immediate : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
        );
    END COMPONENT;
    COMPONENT decode IS
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
            data_in1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            re_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            immediate : IN STD_LOGIC_VECTOR (15 DOWNTO 0);
            re_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            reg1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            reg2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            op_code : IN STD_LOGIC_VECTOR(1 DOWNTO 0);
            function_code : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            EA : OUT STD_LOGIC_VECTOR(19 DOWNTO 0);
            EA_IN : IN STD_LOGIC_VECTOR(19 DOWNTO 0);
            out_func : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
            out_wb_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            out_wb_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            MR, MW, IOR, IOW, WB1, WB2, STACK_OPERATION, PUSH_POP, JUMP, CALL, RSTCTRL, PROTECT, FREE, ALU, RTI : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT Execute IS
        PORT (
            clk : IN STD_LOGIC;
            src1, src2 : IN STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            AluOp : IN STD_LOGIC;
            callOp : IN STD_LOGIC;
            in_wb_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
            in_wb_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
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
            out_wb_addr1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            out_wb_addr2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- remember to add isjmp out signal
            isjmp : OUT STD_LOGIC;
            out_EA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_MR, out_MW, out_IOR, out_IOW, out_WB1, out_WB2, out_STACK_OPERATION, out_PUSH_POP, out_RSTCTRL, out_PROTECT, out_FREE, out_RTI : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT memory IS
        PORT (
            clk : IN STD_LOGIC;
            mr : IN STD_LOGIC;
            mw : IN STD_LOGIC;
            protect : IN STD_LOGIC;
            free : IN STD_LOGIC;
            stack_operation : IN STD_LOGIC;
            push_pop : IN STD_LOGIC;
            effective_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            ior : IN STD_LOGIC;
            iow : IN STD_LOGIC;
            wb1 : IN STD_LOGIC;
            wb2 : IN STD_LOGIC;
            wb1_out : OUT STD_LOGIC;
            wb2_out : OUT STD_LOGIC;
            wb_address_in1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_address_in2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_address_out1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_address_out2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            jmp_m : OUT STD_LOGIC
        );
    END COMPONENT;

    --start of decode signals--
    SIGNAL D_E_wb_addr1 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL D_E_wb_addr2 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    --end of decode signals--

    --start of execute signals--
    SIGNAL E_M_dest1 : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL E_M_dest2 : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL E_M_calledpc : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL E_M_savedpc : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL E_M_isjmp : STD_LOGIC;
    SIGNAL E_M_EA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL E_M_wb_addr1 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL E_M_wb_addr2 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL E_M_MR, E_M_MW, E_M_IOR, E_M_IOW, E_M_WB1, E_M_WB2, E_M_STACK_OPERATION, E_M_PUSH_POP, E_M_RSTCTRL, E_M_PROTECT, E_M_FREE, E_M_RTI : STD_LOGIC;
    --end of execute signals--
    SIGNAL F_D_out_is32BitInst : STD_LOGIC;
    SIGNAL F_D_immediate : STD_LOGIC_VECTOR(15 DOWNTO 0);
    SIGNAL F_D_currentPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL D_E_currentPC : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL instr : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_reg1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL in_reg2 : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL D_E_func : STD_LOGIC_VECTOR(3 DOWNTO 0);
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
    SIGNAL EA_IN_EXE : STD_LOGIC_VECTOR(19 DOWNTO 0);
    -- SIGNAL test_rti : STD_LOGIC;
    SIGNAL EA_CONCAT : STD_LOGIC_VECTOR(19 DOWNTO 0); -- 3SHAN MOD7EK
    ---------------------------------------- MEM_STAGE
    SIGNAL WB1_INTERMEDIATE : STD_LOGIC;
    SIGNAL WB2_INTERMEDIATE : STD_LOGIC;
    SIGNAL DATA_OUT1_M_W : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DATA_OUT2_M_W : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL JMP_M_R : STD_LOGIC;
    SIGNAL mem_wb_address1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL mem_wb_address2 : STD_LOGIC_VECTOR(2 DOWNTO 0);
BEGIN
    EA_CONCAT <= instr(22 DOWNTO 19) & instr(15 DOWNTO 0);
    u0 : Fetch PORT MAP(
        clk => clk,
        rst => rst,
        fetch_out => instr,
        currentPC => F_D_currentPC,
        out_is32BitInst => F_D_out_is32BitInst,
        out_immediate => F_D_immediate
    );
    u1 : decode PORT MAP(
        clk => clk,
        reset => rst,
        in_is32BitInst => F_D_out_is32BitInst,
        immediate => F_D_immediate,
        in_currentPC => F_D_currentPC,
        out_currentPC => D_E_currentPC,
        we1 => WB1_INTERMEDIATE,
        we2 => WB2_INTERMEDIATE,
        wb_addr1 => mem_wb_address1,
        wb_addr2 => mem_wb_address2,
        data_in1 => DATA_OUT1_M_W,
        data_in2 => DATA_OUT2_M_W,
        re_addr1 => instr(25 DOWNTO 23),
        re_addr2 => instr(22 DOWNTO 20),
        reg1 => in_reg1,
        reg2 => in_reg2,
        op_code => instr(31 DOWNTO 30),
        function_code => instr(19 DOWNTO 16),
        MR => in_mr,
        MW => in_mw,
        EA_IN => EA_CONCAT,
        EA => EA_IN_EXE,
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
        RTI => in_rti,
        out_func => D_E_func,
        out_wb_addr1 => D_E_wb_addr1,
        out_wb_addr2 => D_E_wb_addr2
    );
    u2 : Execute GENERIC MAP(
        n) PORT MAP(
        clk => clk,
        src1 => in_reg1,
        src2 => in_reg2,
        AluOp => in_aluop,
        callOp => in_call,
        calledAddress => in_reg2,
        in_wb_addr1 => D_E_wb_addr1,
        in_wb_addr2 => D_E_wb_addr2,
        currentpc => D_E_currentPC,
        jmpOp => in_jump,
        jmpzOp => in_jump,
        func => D_E_func,
        in_EA => EA_IN_EXE,
        in_MR => in_mr,
        in_MW => in_mw,
        in_IOR => in_ior,
        in_IOW => in_iow,
        in_WB1 => in_wb1,
        in_WB2 => in_wb2,
        in_STACK_OPERATION => in_stack_operation,
        in_PUSH_POP => in_push_pop,
        in_RSTCTRL => in_rstctrl,
        in_PROTECT => in_protect,
        in_FREE => in_free,
        in_RTI => in_rti,
        dest1 => E_M_dest1,
        dest2 => E_M_dest2,
        calledpc => E_M_calledpc,
        savedpc => E_M_savedpc,
        isjmp => E_M_isjmp,
        out_EA => E_M_EA,
        out_MR => E_M_MR,
        out_MW => E_M_MW,
        out_IOR => E_M_IOR,
        out_IOW => E_M_IOW,
        out_WB1 => E_M_WB1,
        out_WB2 => E_M_WB2,
        out_STACK_OPERATION => E_M_STACK_OPERATION,
        out_PUSH_POP => E_M_PUSH_POP,
        out_RSTCTRL => E_M_RSTCTRL,
        out_PROTECT => E_M_PROTECT,
        out_FREE => E_M_FREE,
        out_RTI => E_M_RTI,
        out_wb_addr1 => E_M_wb_addr1,
        out_wb_addr2 => E_M_wb_addr2
    );
    u3 : memory PORT MAP(
        clk => clk,
        mr => E_M_MR,
        mw => E_M_MW,
        protect => E_M_PROTECT,
        free => E_M_FREE,
        stack_operation => E_M_STACK_OPERATION,
        push_pop => E_M_PUSH_POP,
        effective_address => E_M_EA,
        data_in1 => E_M_dest1,
        data_in2 => E_M_dest2,
        ior => E_M_IOR,
        iow => E_M_IOW,
        wb1 => E_M_WB1,
        wb2 => E_M_WB2,
        wb1_out => WB1_INTERMEDIATE,
        wb2_out => WB2_INTERMEDIATE,
        wb_address_in1 => E_M_wb_addr1,
        wb_address_in2 => E_M_wb_addr2,
        wb_address_out1 => mem_wb_address1,
        wb_address_out2 => mem_wb_address2,
        data_out1 => DATA_OUT1_M_W,
        data_out2 => DATA_OUT2_M_W,
        jmp_m => JMP_M_R
    );
END CPU_ARCH;