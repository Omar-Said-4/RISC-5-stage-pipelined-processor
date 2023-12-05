LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
ENTITY data_ram IS
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

END data_ram;

ARCHITECTURE sync_ram OF data_ram IS
  TYPE ram_type IS ARRAY (0 TO 4095) OF STD_LOGIC_VECTOR(15 DOWNTO 0);
  IMPURE FUNCTION init_data_ram_hex RETURN ram_type IS
    FILE text_data_file : text OPEN read_mode IS "data_ram_content_hex.txt";
    VARIABLE text_line : line;
    VARIABLE ram_content : ram_type;
  BEGIN
    FOR i IN 0 TO 4095 LOOP
      readline(text_data_file, text_line);
      hread(text_line, ram_content(i));
    END LOOP;
    RETURN ram_content;
  END FUNCTION;
  SIGNAL ram : ram_type := init_data_ram_hex;
BEGIN
  data_out <= ram(conv_integer(addr)) & ram(conv_integer(addr) + 1) WHEN (re = '1' AND weh = '0' AND wel = '0' AND rstloc = '0') ELSE
    (OTHERS => '0');
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF rstloc = '1' THEN
        ram(conv_integer(addr)) <= x"0000";
      END IF;
      IF weh = '1' AND rstloc = '0' THEN
        ram(conv_integer(addr)) <= data_in (31 DOWNTO 16);
      END IF;
      IF wel = '1' AND rstloc = '0' THEN
        ram(conv_integer(addr) + 1) <= data_in (15 DOWNTO 0);
      END IF;
      -- IF re = '1' AND weh = '0' AND wel = '0' AND rstloc = '0' THEN
      --   data_out <= ram(conv_integer(addr)) & ram(conv_integer(addr) + 1);
      -- END IF;
    END IF;
  END PROCESS;
END sync_ram;