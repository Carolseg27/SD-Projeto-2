library ieee;
use ieee. std_logic_1164.all;
 
entity Contador is
PORT( 
CLK, COUNT, LOAD: in std_logic; 
Z: out std_logic_vector(2 downto 0)
);
end Contador;

architecture behavioral of Contador is

component FF_JK is -- declarando o módulo somador 

port ( 
		J,K,CLOCK,SET,RESET: in std_logic;
		Q: out std_logic
		);
end component;

signal Qs: std_logic_vector(2 downto 0);
signal Num: std_logic_vector(2 downto 0);

begin
    Num <= "101";

    FF_JK_port0: FF_JK PORT MAP (
        J => COUNT,
        K => COUNT,
        CLOCK => CLK,
        SET=> LOAD and Num(0),
        RESET => LOAD and not Num(0),
        Q => Qs(0)  
    );
    
    FF_JK_port1: FF_JK PORT MAP (
        J => not Qs(0) and COUNT,
        K => not Qs(0) and COUNT,
        CLOCK => CLK,
        SET=> LOAD and Num(1),
        RESET => LOAD and not Num(1),
        Q => Qs(1)  
    );
    
    FF_JK_port2: FF_JK PORT MAP (
        J => not Qs(0) and not Qs(1) and COUNT,
        K => not Qs(0) and not Qs(1) and COUNT,
        CLOCK => CLK,
        SET=> LOAD and Num(2),
        RESET => LOAD and not Num(2),
        Q => Qs(2)  
    );
    
    Z <= Qs;
end behavioral;