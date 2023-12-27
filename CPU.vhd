LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;

ENTITY CPU IS
    GENERIC (n : INTEGER := 32);
    PORT (
        clk : IN STD_LOGIC;
        INT : IN STD_LOGIC;
        reset : IN STD_LOGIC
    );
END ENTITY CPU;

ARCHITECTURE CPU_ARCH OF CPU IS
    COMPONENT Fetch IS
        PORT (
            clk : IN STD_LOGIC;
            reset : IN STD_LOGIC;
            rst : IN STD_LOGIC;
            fetch_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            currentPC : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_is32BitInst : OUT STD_LOGIC;
            out_immediate : OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
            is_jmp_execute : IN STD_LOGIC;
            jmp_execute_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            is_jmp_mem : IN STD_LOGIC;
            jmp_mem_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            reset_PC_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
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
    END COMPONENT;
    COMPONENT Execute IS
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
            -- savedpc : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            -- remember to add isjmp out signal
            fetched_jmp_address : OUT STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
            fetched_is_jmp : OUT STD_LOGIC;

            out_callOp : OUT STD_LOGIC;
            out_wb_addr1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            out_wb_addr2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
            -- change to 31 bit instaed of 19
            out_EA : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            out_MR, out_MW, out_WB1, out_WB2, out_STACK_OPERATION, out_PUSH_POP, out_RSTCTRL, out_PROTECT, out_FREE, out_RTI, out_RET : OUT STD_LOGIC
        );
    END COMPONENT;
    COMPONENT memory IS
        PORT (
            clk, reset : IN STD_LOGIC;
            mr : IN STD_LOGIC;
            mw : IN STD_LOGIC;
            protect : IN STD_LOGIC;
            free : IN STD_LOGIC;
            stack_operation : IN STD_LOGIC;
            push_pop : IN STD_LOGIC;
            effective_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_in2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
            in_RTI_signal : IN STD_LOGIC;
            in_RET_signal : IN STD_LOGIC;
            wb1 : IN STD_LOGIC;
            wb2 : IN STD_LOGIC;
            out_jmp_fetch_mem : OUT STD_LOGIC;
            in_call_signal : IN STD_LOGIC;
            wb1_out : OUT STD_LOGIC;
            wb2_out : OUT STD_LOGIC;
            wb_address_in1 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_address_in2 : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_address_out1 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            wb_address_out2 : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            data_out1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            data_out2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
            jmp_m : OUT STD_LOGIC;
            out_RTI : OUT STD_LOGIC;
            in_calledpc : IN STD_LOGIC_VECTOR(31 DOWNTO 0)
        );
    END COMPONENT;
    SIGNAL mid_rst : STD_LOGIC;
    --start of decode signals--
    SIGNAL D_E_wb_addr1 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL D_E_wb_addr2 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL D_E_JZ : STD_LOGIC;
    SIGNAL D_E_RET : STD_LOGIC;
    --end of decode signals--

    --start of execute signals--
    SIGNAL E_M_dest1 : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL E_M_dest2 : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL E_M_calledpc : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    -- SIGNAL E_M_savedpc : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
    SIGNAL E_M_out_callOp : STD_LOGIC;
    SIGNAL E_M_EA : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL E_M_wb_addr1 : STD_LOGIC_VECTOR (2 DOWNTO 0);
    SIGNAL E_M_wb_addr2 : STD_LOGIC_VECTOR (2 DOWNTO 0);

    SIGNAL E_M_RET : STD_LOGIC;
    -- SIGNAL E_M_RTE : STD_LOGIC (2 DOWNTO 0);
    SIGNAL D_E_IOR, D_E_IOW : STD_LOGIC;
    SIGNAL E_M_MR, E_M_MW, E_M_WB1, E_M_WB2, E_M_STACK_OPERATION, E_M_PUSH_POP, E_M_RSTCTRL, E_M_PROTECT, E_M_FREE, E_M_RTI : STD_LOGIC;
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
    SIGNAL in_wb1 : STD_LOGIC;
    SIGNAL in_wb2 : STD_LOGIC;
    SIGNAL in_stack_operation : STD_LOGIC;
    SIGNAL in_push_pop : STD_LOGIC;
    SIGNAL D_E_jmp : STD_LOGIC;
    SIGNAL in_call : STD_LOGIC;
    SIGNAL in_rstctrl : STD_LOGIC;
    SIGNAL in_protect : STD_LOGIC;
    SIGNAL in_free : STD_LOGIC;
    SIGNAL in_aluop : STD_LOGIC;
    SIGNAL in_rti : STD_LOGIC;
    SIGNAL EA_IN_EXE : STD_LOGIC_VECTOR(19 DOWNTO 0);
    -- SIGNAL test_rti : STD_LOGIC;
    SIGNAL EA_CONCAT : STD_LOGIC_VECTOR(19 DOWNTO 0); -- 3SHAN MOD7EK
    ---------------------------------------- MEM_STAGE-------------------------------------------
    SIGNAL WB1_INTERMEDIATE : STD_LOGIC;
    SIGNAL WB2_INTERMEDIATE : STD_LOGIC;
    SIGNAL DATA_OUT1_M_W : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL DATA_OUT2_M_W : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL JMP_M_R : STD_LOGIC;
    SIGNAL mem_wb_address1 : STD_LOGIC_VECTOR(2 DOWNTO 0);
    SIGNAL mem_wb_address2 : STD_LOGIC_VECTOR(2 DOWNTO 0);

    -------------------Mem/Execute to Fetch----------------------
    SIGNAL E_F_fetched_jmp_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL E_F_fetched_is_jmp : STD_LOGIC;
    SIGNAL M_F_fetched_jmp_address : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL M_F_fetched_is_jmp : STD_LOGIC;

BEGIN
    EA_CONCAT <= instr(15 DOWNTO 0) & instr(22 DOWNTO 19);
    u0 : Fetch PORT MAP(
        clk => clk,
        reset => reset,
        rst => mid_rst,
        fetch_out => instr,
        currentPC => F_D_currentPC,
        out_is32BitInst => F_D_out_is32BitInst,
        out_immediate => F_D_immediate,
        is_jmp_execute => E_F_fetched_is_jmp,
        jmp_execute_address => E_F_fetched_jmp_address,
        is_jmp_mem => M_F_fetched_is_jmp,
        jmp_mem_address => DATA_OUT1_M_W, -- 3SHAN MOD7EK
        reset_PC_address => Data_out1_M_W
    );
    u1 : decode PORT MAP(
        clk => clk,
        reset => reset,
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
        wb_addr_fetch1 => instr(28 DOWNTO 26),
        wb_addr_fetch2 => instr(25 DOWNTO 23),
        reg1 => in_reg1,
        reg2 => in_reg2,
        op_code => instr(31 DOWNTO 30),
        function_code => instr(19 DOWNTO 16),
        MR => in_mr,
        MW => in_mw,
        EA_IN => EA_CONCAT,
        EA => EA_IN_EXE,
        IOR => D_E_IOR,
        IOW => D_E_IOW,
        WB1 => in_wb1,
        WB2 => in_wb2,
        STACK_OPERATION => in_stack_operation,
        PUSH_POP => in_push_pop,
        JUMP => D_E_jmp,
        CALL => in_call,
        RSTCTRL => in_rstctrl,
        PROTECT => in_protect,
        FREE => in_free,
        ALU => in_aluop,
        RTI => in_rti,
        out_func => D_E_func,
        out_wb_addr1 => D_E_wb_addr1,
        out_wb_addr2 => D_E_wb_addr2,
        RET => D_E_RET,
        JZ => D_E_JZ
    );
    u2 : Execute GENERIC MAP(
        n) PORT MAP(
        clk => clk,
        reset => reset,
        src1 => in_reg1,
        src2 => in_reg2,
        AluOp => in_aluop,
        callOp => in_call,
        calledAddress => in_reg1,
        in_wb_addr1 => D_E_wb_addr1,
        in_wb_addr2 => D_E_wb_addr2,
        currentpc => D_E_currentPC,
        jmpOp => D_E_jmp,
        jmpzOp => D_E_JZ,
        func => D_E_func,
        in_EA => EA_IN_EXE,
        in_MR => in_mr,
        in_MW => in_mw,
        IOR => D_E_IOR,
        IOW => D_E_IOW,
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
        -- savedpc => E_M_savedpc,
        out_callOp => E_M_out_callOp,
        out_EA => E_M_EA,
        out_MR => E_M_MR,
        out_MW => E_M_MW,
        out_WB1 => E_M_WB1,
        out_WB2 => E_M_WB2,
        out_STACK_OPERATION => E_M_STACK_OPERATION,
        out_PUSH_POP => E_M_PUSH_POP,
        out_RSTCTRL => E_M_RSTCTRL,
        out_PROTECT => E_M_PROTECT,
        out_FREE => E_M_FREE,
        out_RTI => E_M_RTI,
        out_RET => E_M_RET,
        out_wb_addr1 => E_M_wb_addr1,
        out_wb_addr2 => E_M_wb_addr2,
        fetched_jmp_address => E_F_fetched_jmp_address,
        fetched_is_jmp => E_F_fetched_is_jmp,
        in_RET => D_E_RET
    );
    u3 : memory PORT MAP(
        clk => clk,
        reset => reset,
        mr => E_M_MR,
        mw => E_M_MW,
        protect => E_M_PROTECT,
        free => E_M_FREE,
        stack_operation => E_M_STACK_OPERATION,
        push_pop => E_M_PUSH_POP,
        effective_address => E_M_EA,
        data_in1 => E_M_dest1,
        data_in2 => E_M_dest2,
        in_RTI_signal => E_M_RTI,
        in_RET_signal => E_M_RET,
        out_jmp_fetch_mem => M_F_fetched_is_jmp,
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
        jmp_m => JMP_M_R,
        in_call_signal => E_M_out_callOp,
        in_calledpc => E_M_calledpc
    );
END CPU_ARCH;