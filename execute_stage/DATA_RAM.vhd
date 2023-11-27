library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
USE IEEE.STD_LOGIC_TEXTIO.ALL;
USE STD.TEXTIO.ALL;
entity data_ram is
    Port ( clk : in  STD_LOGIC;
           we : in  STD_LOGIC;
           re : in  STD_LOGIC;
           addr : in  STD_LOGIC_VECTOR (11 downto 0);
           data_in : in  STD_LOGIC_VECTOR (15 downto 0);
           data_out : out  STD_LOGIC_VECTOR (15 downto 0));
end data_ram;

architecture sync_ram of data_ram is
type ram_type is array (0 to 4095) of std_logic_vector(15 downto 0);
impure function init_data_ram_hex return ram_type is
    file text_data_file : text open read_mode is "data_ram_content_hex.txt";
    variable text_line : line;
    variable ram_content : ram_type;
  begin
    for i in 0 to 4095 loop
      readline(text_data_file, text_line);
      hread(text_line, ram_content(i));
    end loop;
    return ram_content;
end function;
signal ram : ram_type:= init_data_ram_hex;
begin
process(clk)
begin
if rising_edge(clk) then
if we = '1' then
    ram(conv_integer(addr)) <= data_in;
end if;
else if re = '1' then
    data_out <= ram(conv_integer(addr));
end if;
end if;
end process;
end sync_ram;

