LIBRARY IEEE;
USE IEEE.std_logic_1164.ALL;
ENTITY FullAdder IS
    GENERIC (n : INTEGER := 8);
    PORT (
        X, Y : IN STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Cin, M : IN STD_LOGIC;
        Sum : OUT STD_LOGIC_VECTOR(n - 1 DOWNTO 0);
        Cout : OUT STD_LOGIC
    );
END ENTITY FullAdder;

ARCHITECTURE archFullAdder OF FullAdder IS
    COMPONENT Adder IS
        PORT (
            X, Y, Cin : IN STD_LOGIC;
            Sum, Cout : OUT STD_LOGIC
        );
    END COMPONENT;
    SIGNAL temp : STD_LOGIC_VECTOR(n DOWNTO 0);
    SIGNAL tempxor : STD_LOGIC_VECTOR (n - 1 DOWNTO 0);
BEGIN
    temp(0) <= Cin;
    generate_label : FOR i IN 0 TO n - 1 GENERATE
        tempxor(i) <= M XOR Y(i);
        f0 : Adder PORT MAP(X(i), tempxor(i), temp(i), Sum(i), temp(i + 1));
    END GENERATE;
    Cout <= temp(n);
END archFullAdder; -- archFullAdder