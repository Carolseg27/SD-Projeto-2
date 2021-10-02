library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity dec_P_G is
    Port (
            DIG: in std_logic_vector(1 downto 0);
            SEG: out std_logic_vector(0 to 6)
		 );
end dec_P_G;

architecture Behavioral of dec_P_G is

signal sel: std_logic_vector(1 downto 0); 
signal segment_data : std_logic_vector(0 to 6);

begin
    
	sel   <= DIG;  
	    
	segment_data <= "1111101" when sel="01" else -- mostra G no display
		            "1110011" when sel="10" else -- mostra P
		            "0000000"                    -- os displays apagam
		          ;
    SEG <= not segment_data;

end Behavioral;