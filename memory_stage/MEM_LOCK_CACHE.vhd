LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
ENTITY mem_lock_cache IS
  PORT (
    addr : IN STD_LOGIC_VECTOR (11 DOWNTO 0);
    lock : IN STD_LOGIC;
    clk : IN STD_LOGIC;
    unlock : IN STD_LOGIC;
    higher_location_state : OUT STD_LOGIC;
    lower_location_state : OUT STD_LOGIC
  );
END mem_lock_cache;

ARCHITECTURE lock_cache_arch OF mem_lock_cache IS
  TYPE lock_cache_type IS ARRAY (0 TO 4095) OF STD_LOGIC;
  IMPURE FUNCTION init_mem_lock_cache RETURN lock_cache_type IS
    FILE text_data_file : text OPEN read_mode IS "data_ram_content_hex.txt";
    VARIABLE text_line : line;
    VARIABLE lock_cache_content : lock_cache_type;
  BEGIN
    FOR i IN 0 TO 4095 LOOP
      readline(text_data_file, text_line);
      read(text_line, lock_cache_content(i));
    END LOOP;
    RETURN lock_cache_content;
  END FUNCTION;
  SIGNAL lock_cache : lock_cache_type := init_mem_lock_cache;
BEGIN
  higher_location_state <= lock_cache(conv_integer(addr));
  lower_location_state <= lock_cache(conv_integer(addr) + 1) WHEN conv_integer(addr) < 4095 ELSE
    '0';
  PROCESS (clk)
  BEGIN
    IF rising_edge(clk) THEN
      IF lock = '1' THEN
        lock_cache(conv_integer(addr)) <= '1';
      ELSIF unlock = '1' THEN
        lock_cache(conv_integer(addr)) <= '0';
      END IF;
    END IF;
  END PROCESS;
END lock_cache_arch;