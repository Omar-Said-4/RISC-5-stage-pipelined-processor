LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY Adder IS
    PORT (
        X, Y, Cin : IN STD_LOGIC;
        Sum, Cout : OUT STD_LOGIC
    );
END ENTITY Adder;

ARCHITECTURE archAdder OF Adder IS
BEGIN
    Sum <= X XOR Y XOR Cin;
    Cout <= (X AND Y) OR (cin AND (X XOR Y));
END archAdder; -- archAdder