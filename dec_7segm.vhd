library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity dec_7segm is
    Port (
            DIG: in std_logic_vector(4 downto 0);
            SEG: out std_logic_vector(0 to 6)
		 );
end dec_7segm;

architecture Behavioral of dec_7segm is

signal sel: std_logic_vector(4 downto 0); -- 1 bit de enable + 4 bits do número em si
signal segment_data : std_logic_vector(0 to 6);

begin
    
	sel   <= DIG;  
	    
	segment_data <= "1000000" when sel="00000" else --essa parte mostra '-' no display já que o 1° bit=0 -> como se fosse um enable
		            "1000000" when sel="00001" else 
		            "1000000" when sel="00010" else 
		            "1000000" when sel="00011" else 
		            "1000000" when sel="00100" else 
		            "1000000" when sel="00101" else
		            "1000000" when sel="00110" else 
		            "1000000" when sel="00111" else 
		            "1000000" when sel="01000" else 
		            "1000000" when sel="01001" else 
	                                               -- essa parte mostra o valor dos outros 4 bits, já que o 1° bit=1
	                "0111111" when sel="10000" else --'mostra 0 no display'
		            "0000110" when sel="10001" else --'mostra 1 no display'
		            "1011011" when sel="10010" else --'mostra 2 no display'
		            "1001111" when sel="10011" else --'mostra 3 no display'
		            "1100110" when sel="10100" else --'mostra 4 no display'
		            "1101101" when sel="10101" else --'mostra 5 no display'
		            "1111101" when sel="10110" else --'mostra 6 no display'
		            "0000111" when sel="10111" else --'mostra 7 no display'
		            "1111111" when sel="11000" else --'mostra 8 no display'
		            "1101111" when sel="11001" else --'mostra 9 no display'
		            "0000000"
		          ;
    SEG <= not segment_data;

end Behavioral;