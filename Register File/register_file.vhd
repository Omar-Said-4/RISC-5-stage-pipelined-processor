LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.numeric_std.ALL;
ENTITY register_file IS PORT (
clk : IN STD_LOGIC;
rst : IN STD_LOGIC;
we : IN STD_LOGIC;

signal_read_one : IN STD_LOGIC;
signal_read_two : IN STD_LOGIC;

signal_write_one : IN STD_LOGIC;
signal_write_two : IN STD_LOGIC;

address_read_one : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
address_read_two : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

address_write_one : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
address_write_two : IN STD_LOGIC_VECTOR(2 DOWNTO 0);

datain1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
datain2 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);

dataout1 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
dataout2 : OUT STD_LOGIC_VECTOR(31 DOWNTO 0));

END ENTITY register_file;

ARCHITECTURE sync_register_file OF register_file IS
    TYPE register_file_type IS ARRAY(0 TO 7) OF STD_LOGIC_VECTOR(31 DOWNTO 0);
    SIGNAL register_file : register_file_type := (OTHERS => (OTHERS => '1')); -- Initial values;
BEGIN

    PROCESS (clk, rst) IS
    BEGIN
        IF rst = '1' THEN
            register_file <= (OTHERS => (OTHERS => '0'));
        ELSIF falling_edge(clk) THEN
            IF signal_write_one = '1' AND falling_edge(clk) THEN
                register_file(to_integer(unsigned((address_write_one)))) <= datain1;
            END IF;
            IF signal_write_one = '1' AND falling_edge(clk) THEN
                register_file(to_integer(unsigned((address_write_two)))) <= datain2;
            END IF;

        END IF;
    END PROCESS;

    WITH signal_read_one SELECT
        dataout1 <=
        register_file(to_integer(unsigned((address_read_one)))) WHEN '1',
        (OTHERS => '0') WHEN '0';

    WITH signal_read_two SELECT
        dataout2 <=
        register_file(to_integer(unsigned((address_read_two)))) WHEN '0',
        (OTHERS => '0') WHEN '0';

END sync_register_file;