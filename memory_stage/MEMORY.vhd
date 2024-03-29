LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_ARITH.ALL;
-- USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY memory IS
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
        wb1 : IN STD_LOGIC;
        wb2 : IN STD_LOGIC;
        out_jmp_fetch_mem : OUT STD_LOGIC;
        out_jmp_fetch_mem_addr : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        in_call_signal : IN STD_LOGIC;
        in_RET_signal : IN STD_LOGIC;
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
END memory;

ARCHITECTURE mem_stage OF memory IS
    COMPONENT data_ram IS
        PORT (
            clk : IN STD_LOGIC;
            weh : IN STD_LOGIC;
            wel : IN STD_LOGIC;
            re : IN STD_LOGIC;
            addr : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
            data_in : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
            data_out : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
            rstloc : IN STD_LOGIC
        );
    END COMPONENT;
    COMPONENT mem_lock_cache IS
        PORT (
            addr : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
            lock : IN STD_LOGIC;
            clk : IN STD_LOGIC;
            unlock : IN STD_LOGIC;
            higher_location_state : OUT STD_LOGIC;
            lower_location_state : OUT STD_LOGIC
        );
    END COMPONENT;

    ------------------------------------------------------------------------------------------------
    SIGNAL sp : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FFE";
    ------------------------------------------------------------------------------------------------
    SIGNAL ram_addr_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL higher_location_state : STD_LOGIC;
    SIGNAL lower_location_state : STD_LOGIC;
    SIGNAL weh : STD_LOGIC;
    SIGNAL wel : STD_LOGIC;
    SIGNAL mem_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    -- SIGNAL io_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL wb_data_out1 : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    comp_data_mem : data_ram PORT MAP(
        clk => clk,
        weh => weh,
        wel => wel,
        re => mr,
        addr => ram_addr_in(11 DOWNTO 0),
        data_out => mem_out,
        data_in => data_in1,
        rstloc => free
    );
    comp_mem_lock_cache : mem_lock_cache PORT MAP(
        clk => clk,
        addr => ram_addr_in(11 DOWNTO 0),
        lock => protect,
        unlock => free,
        higher_location_state => higher_location_state,
        lower_location_state => lower_location_state
    );
    ram_addr_in <= effective_address WHEN (stack_operation = '0') ELSE
        sp WHEN (push_pop = '1') ELSE
        (STD_LOGIC_VECTOR(unsigned(sp) + to_unsigned(2, 12))) AND X"00000FFE"WHEN (push_pop = '0');
    weh <= mw AND (NOT higher_location_state);
    wel <= mw AND (NOT lower_location_state);

    wb_data_out1 <= data_in1;

    data_out2 <= data_in2;
    jmp_m <= stack_operation AND (NOT push_pop);
    PROCESS (clk, reset)
    BEGIN
        IF (reset = '1') THEN
            out_jmp_fetch_mem <= '0';
            out_jmp_fetch_mem_addr <= (OTHERS => '0');
            out_RTI <= '0';
            out_jmp_fetch_mem <= '0';
            wb_address_out1 <= (OTHERS => '0');
            wb_address_out2 <= (OTHERS => '0');
            wb1_out <= '0';
            wb2_out <= '0';
            out_RTI <= '0';
            data_out1 <= mem_out;
        ELSIF (rising_edge(clk)) THEN
            IF (mr = '1') THEN
                data_out1 <= mem_out;
            ELSIF (in_call_signal = '1') THEN
                data_out1 <= in_calledpc;
            ELSE
                data_out1 <= wb_data_out1;
            END IF;
            wb_address_out1 <= wb_address_in1;
            wb_address_out2 <= wb_address_in2;
            wb1_out <= wb1;
            wb2_out <= wb2;
            IF (stack_operation = '1') THEN
                IF (push_pop = '1') THEN
                    sp <= (STD_LOGIC_VECTOR(unsigned(sp) - to_unsigned(2, sp'length)) AND X"00000FFE");
                ELSE
                    sp <= (STD_LOGIC_VECTOR(unsigned(sp) + to_unsigned(2, sp'length)) AND X"00000FFE");
                END IF;
            END IF;
            IF (in_call_signal = '1' OR in_RET_signal = '1' OR in_RTI_signal = '1') THEN
                out_jmp_fetch_mem <= '1';
            END IF;
        END IF;
    END PROCESS;
END mem_stage;