LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Mem_WB_Buffer IS
    PORT (
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        in_we1 : IN STD_LOGIC;
        in_we2 : IN STD_LOGIC;
        in_wb_addr1 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        in_wb_addr2 : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
        in_data1 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        in_data2 : IN STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_we1 : OUT STD_LOGIC;
        out_we2 : OUT STD_LOGIC;
        out_wb_addr1 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        out_wb_addr2 : OUT STD_LOGIC_VECTOR (2 DOWNTO 0);
        out_data1 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0);
        out_data2 : OUT STD_LOGIC_VECTOR (31 DOWNTO 0)
    );
END ENTITY Mem_WB_Buffer;
ARCHITECTURE ArchMem_WB_Buffer OF Mem_WB_Buffer IS
BEGIN
    PROCESS (clk, rst)
    BEGIN
        IF rst = '1' THEN
            out_we1 <= '0';
            out_we2 <= '0';
            out_wb_addr1 <= "000";
            out_wb_addr2 <= "000";
            out_data1 <= x"00000000";
            out_data2 <= x"00000000";
        ELSIF rising_edge(clk) THEN
            out_we1 <= in_we1;
            out_we2 <= in_we2;
            out_wb_addr1 <= in_wb_addr1;
            out_wb_addr2 <= in_wb_addr2;
            out_data1 <= in_data1;
            out_data2 <= in_data2;
        END IF;
    END PROCESS;
END ArchMem_WB_Buffer;