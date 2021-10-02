library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity cod_bin_led is
    Port (
            num: in std_logic_vector(2 downto 0); -- A entrada varia de 0 a 5
            leds: out std_logic_vector(4 downto 0) -- São 5 leds, um para cada vida
		 );
end cod_bin_led;

architecture Behavioral of cod_bin_led is

signal sel: std_logic_vector(2 downto 0); 
signal led_data : std_logic_vector(4 downto 0);

begin
    
	sel   <= num(2 downto 0);  
	    
	led_data <= "00001" when sel="001" else -- se a entrada for 1 então 1 led acende
		        "00011" when sel="010" else -- se 2 então 2 leds acendem
		        "00111" when sel="011" else -- se 3 então 3 leds acendem
		        "01111" when sel="100" else -- se 4 então 4 leds acendem
		        "11111" when sel="101" else -- se 5 então 5 leds acendem
		        "00000"     -- se for 0 ou qualquer outro número fora do intervalo de 1 a 5, então nenhum led acende
		          ;
    leds <= led_data;

end Behavioral;