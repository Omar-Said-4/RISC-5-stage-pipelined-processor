LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Execute_Mem_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        in_effective_address : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        in_data : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_effective_address : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        out_data : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
        in_MR, in_MW, in_IOR, in_IOW, in_STACK_OPERATION, in_PUSH_POP, in_PROTECT, in_FREE : IN STD_LOGIC;
        out_MR, out_MW, out_IOR, out_IOW, out_STACK_OPERATION, out_PUSH_POP, out_PROTECT, out_FREE : OUT STD_LOGIC
    );
END ENTITY Execute_Mem_Buffer;
ARCHITECTURE ArchExecute_Mem_Buffer OF Execute_Mem_Buffer IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            out_effective_address <= x"00000000";
            out_data <= x"00000000";
            out_MR <= '0';
            out_MW <= '0';
            out_IOR <= '0';
            out_IOW <= '0';
            out_STACK_OPERATION <= '0';
            out_PUSH_POP <= '0';
            out_PROTECT <= '0';
            out_FREE <= '0';
        ELSIF rising_edge(clk) THEN
            out_effective_address <= in_effective_address;
            out_data <= in_data;
            out_MR <= in_MR;
            out_MW <= in_MW;
            out_IOR <= in_IOR;
            out_IOW <= in_IOW;
            out_STACK_OPERATION <= in_STACK_OPERATION;
            out_PUSH_POP <= in_PUSH_POP;
            out_PROTECT <= in_PROTECT;
            out_FREE <= in_FREE;
        END IF;
    END PROCESS;
END ArchExecute_Mem_Buffer;