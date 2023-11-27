library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
entity mem_lock_cache is
    Port ( clk : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (11 downto 0);
           lock : in  STD_LOGIC ;
           unlock : in  STD_LOGIC ;
           location_state : out  STD_LOGIC
           );
end mem_lock_cache;

architecture lock_cache_arch of mem_lock_cache is
type lock_cache_type is array (0 to 4095) of std_logic;
impure function init_mem_lock_cache return lock_cache_type is
    file text_data_file : text open read_mode is "data_ram_content_hex.txt";
    variable text_line : line;
    variable lock_cache_content : lock_cache_type;
  begin
    for i in 0 to 4095 loop
      readline(text_data_file, text_line);
      read(text_line, lock_cache_content(i));
    end loop;
    return lock_cache_content;
end function;
signal lock_cache : lock_cache_type:= init_mem_lock_cache;
begin
process(clk)
begin
if rising_edge(clk) then
if lock = '1' then
  lock_cache(conv_integer(addr)) <= '1';
elsif unlock = '1' then
  lock_cache(conv_integer(addr)) <= '0';
end if;
location_state <= lock_cache(conv_integer(addr));
end if;
end process;
end lock_cache_arch;

