library ieee;
use ieee. std_logic_1164.all;
 
entity FF_JK is
PORT( J,K,CLOCK,SET,RESET: in std_logic;
Q: out std_logic);
end FF_JK;
 
 

Architecture behavioral of FF_JK is
begin
    PROCESS(CLOCK)
        variable TMP: std_logic;
        begin
            if(CLOCK='1' and CLOCK'EVENT) then
                if(J='0' and K='0')then
                    TMP:=TMP;
                elsif(J='1' and K='1')then
                    TMP:= not TMP;
                elsif(J='0' and K='1')then
                    TMP:='0';
                else
                    TMP:='1';
                end if;
            end if;
            if(RESET='1')then
                TMP:='0';
            end if;
            if(SET='1')then
                TMP:='1';
            end if;
            Q<=TMP;
        end PROCESS;
end behavioral;
