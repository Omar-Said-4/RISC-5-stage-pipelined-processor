LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-- USE IEEE.STD_LOGIC_ARITH.ALL;
-- USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.NUMERIC_STD.ALL;
ENTITY execute IS
    PORT (
        clk : IN STD_LOGIC;
        mr : IN STD_LOGIC;
        mw : IN STD_LOGIC;
        protect : IN STD_LOGIC;
        free : IN STD_LOGIC;
        stack_operation : IN STD_LOGIC;
        push_pop : IN STD_LOGIC;
        data_out : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        effective_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        data_in : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        ior : IN STD_LOGIC;
        iow : IN STD_LOGIC
    );
END execute;

ARCHITECTURE exec_stage OF execute IS
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
            lower_location_state : OUT STD_LOGIC);
    END COMPONENT;

    ------------------------------------------------------------------------------------------------
    SIGNAL sp : STD_LOGIC_VECTOR(31 DOWNTO 0) := X"00000FFE";
    SIGNAL IN_PORT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL OUT_PORT : STD_LOGIC_VECTOR(31 DOWNTO 0);
    ------------------------------------------------------------------------------------------------
    SIGNAL ram_addr_in : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL higher_location_state : STD_LOGIC;
    SIGNAL lower_location_state : STD_LOGIC;
    SIGNAL weh : STD_LOGIC;
    SIGNAL wel : STD_LOGIC;
    SIGNAL mem_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL io_out : STD_LOGIC_VECTOR(31 DOWNTO 0);
BEGIN
    comp_data_mem : data_ram PORT MAP(
        clk => clk,
        weh => weh,
        wel => wel,
        re => mr,
        addr => ram_addr_in(11 DOWNTO 0),
        data_out => mem_out,
        data_in => data_in,
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
        (STD_LOGIC_VECTOR(unsigned(sp) + to_unsigned(2, sp'length))) AND X"00000FFE"WHEN (push_pop = '0');
    weh <= mw AND (NOT higher_location_state);
    wel <= mw AND (NOT lower_location_state);
    data_out <= mem_out WHEN (mr = '1') ELSE
        io_out WHEN (ior = '1');
    PROCESS (clk)
    BEGIN
        IF (rising_edge(clk)) THEN
            IF (stack_operation = '1') THEN
                IF (push_pop = '1') THEN
                    sp <= (STD_LOGIC_VECTOR(unsigned(sp) - to_unsigned(2, sp'length)) AND X"00000FFE");
                ELSE
                    sp <= (STD_LOGIC_VECTOR(unsigned(sp) + to_unsigned(2, sp'length)) AND X"00000FFE");
                END IF;
            END IF;
            IF (iow = '1') THEN
                OUT_PORT <= data_in;
            ELSIF (ior = '1') THEN
                io_out <= IN_PORT;
            END IF;
        END IF;
    END PROCESS;
END exec_stage;