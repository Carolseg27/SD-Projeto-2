library ieee;
use ieee. std_logic_1164.all;
 
entity Forca is
PORT( 
V_SW: in std_logic_vector(10 downto 0);
G_LEDG: out std_logic_vector(4 downto 0); -- leds para vida
CLOCK_50: in std_logic;
G_HEX4: out std_logic_vector(6 downto 0);
G_HEX3: out std_logic_vector(6 downto 0);
G_HEX2: out std_logic_vector(6 downto 0);
G_HEX1: out std_logic_vector(6 downto 0);
G_HEX0: out std_logic_vector(6 downto 0)
);
end Forca;

architecture behavioral of Forca is

component Contador is -- declarando o módulo contador 

port ( 
		CLK, COUNT, LOAD: in std_logic; 
        Z: out std_logic_vector(2 downto 0)
		);
end component;


component cod_bin_led is -- declarando o módulo codificador para leds 

port ( 
		num: in std_logic_vector(2 downto 0); 
        leds: out std_logic_vector(4 downto 0)
		);
end component;


component dec_7segm is -- declarando o módulo decodificador da senha

port ( 
		DIG: in std_logic_vector(4 downto 0); 
        SEG: out std_logic_vector(6 downto 0)
		);
end component;

component dec_P_G is -- declarando o módulo decodificador de P e G

port ( 
		DIG: in std_logic_vector(1 downto 0); 
        SEG: out std_logic_vector(6 downto 0)
		);
end component;


signal Erro: std_logic_vector(5 downto 0);              --Guarda chaves erradas
signal Acerto: std_logic_vector(3 downto 0);            --Guarda cheves corretas
signal CNT: std_logic;                                  --Sinal para habilitar contador
signal Chute_err: std_logic;                            --Parte do sinal CNT
signal P, G: std_logic;                                 --Onde P é perdeu, e G ganhou
signal Contagem: std_logic_vector(2 downto 0);          --Numero de vidas 
signal Acerto_estado: std_logic_vector(3 downto 0);     --Guarda o estado de cada digito da senha (descoberto ou nao)
signal RESET, INIT: std_logic;                          --RESET e Primeira Partida
signal Dig3,Dig2,Dig1,Dig0: std_logic_vector(3 downto 0);--Guardam os valores da senha em binário para cada digito

begin
    -- senha : 7246
    
    Dig3 <= "0111";
    Dig2 <= "0010";
    Dig1 <= "0100";
    Dig0 <= "0110";
    
    Erro <= V_SW(0)&V_SW(1)&V_SW(3)&V_SW(5)&V_SW(8)&V_SW(9);
    Acerto <= V_SW(7)&V_SW(2)&V_SW(4)&V_SW(6);
    RESET <= V_SW(10);
    
    P <=not(Contagem(2) or Contagem(1) or Contagem(0)); -- ou seja, P=1 quando contagem for "000"
    G <=(Acerto_estado(0) and Acerto_estado(1) and Acerto_estado(2) and Acerto_estado(3) and not P); 
    --G = 1 quando todos os digitos da senha forem descobertos


    --Processo lida com os chutes errados
    --Quando uma chave errada for pressionada, ela gera o sinal 'Chute_err'
    --A lógica do processo é análoga a chave estar conectada a um FF tipo D, Chute_err é 1
    --sempre que a chave for 1 e a saida do FF for 0, assim contando um erro apenas uma vez
    PROCESS(CLOCK_50)
        variable Erro_FF: std_logic_vector(5 downto 0);
        begin
            Chute_err <= (Erro(0) and not Erro_FF(0)) or (Erro(1) and not Erro_FF(1)) 
            or (Erro(2) and not Erro_FF(2)) or (Erro(3) and not Erro_FF(3)) or 
            (Erro(4) and not Erro_FF(4)) or (Erro(5) and not Erro_FF(5));
            
            if(CLOCK_50='1' and CLOCK_50'EVENT) then
                Erro_FF:= Erro;
            end if;
            
    end PROCESS;
    
    --Processo que lida com os acertos
    --Caso o programa ainda nao tenha 'iniciado' (O botao RESET nao tenha sido pressinado
    --pelo menos uma vez), o jogo nao registra um acerto. Isto é feito a fim de garantir que
    --o estado inicial dos digitos (descoberto ou nao) seja 0 (oculto)
    PROCESS(CLOCK_50)
        variable Acerto_FF: std_logic_vector(3 downto 0);
        begin
            for I in 0 to 3 loop
                if (Acerto(I) = '1') then
                    Acerto_FF(I):= '1';
                end if;
                if (RESET = '1') then
                    Acerto_FF(I):= '0';
                end if;
                if (INIT = '0') then
                    Acerto_FF(I):= '0';
                end if;
            end loop;
            
            Acerto_estado <= Acerto_FF;
            
    end PROCESS;
    
    --Processo lida com o sinal INIT
    --Este sinal foi implementado como solução para definir o estado inicial dos
    --dígitos da senha (atribuir um valor inicial à variável 'Acerto_FF' no processo
    --acima não resolveu este problema)
    PROCESS(RESET)
        variable iniciar: std_logic := '0';
        begin
        if (RESET = '1') then
        iniciar := '1';
        end if;
        INIT <= iniciar;
    end PROCESS;
    
    --Contador é habilitado quando há um erro, o jogo foi iniciado e ainda nao acabou
    CNT <= Chute_err and not P and not G and INIT;
    
    --Port dos decodificadores de cada digito da senha
    dec_7segm_port0: dec_7segm PORT MAP(
        DIG=> Acerto_estado(3)&Dig3,
        SEG => G_HEX3
    );
    
    dec_7segm_port1: dec_7segm PORT MAP(
        DIG=> Acerto_estado(2)&Dig2,
        SEG => G_HEX2
    );
    
    dec_7segm_port2: dec_7segm PORT MAP(
        DIG=> Acerto_estado(1)&Dig1,
        SEG => G_HEX1
    );
    
    dec_7segm_port3: dec_7segm PORT MAP(
        DIG=> Acerto_estado(0)&Dig0,
        SEG => G_HEX0
    );
    
    dec_P_G_port: dec_P_G PORT MAP(
        DIG=> P&G,
        SEG => G_HEX4
    );
    
    --Port do contador
    Contador_port: Contador PORT MAP (
        CLK => CLOCK_50,
        COUNT => CNT,
        LOAD=> RESET,
        Z => Contagem  
    );
    
    --Port do codificador para os leds de vida
    cod_bin_port: cod_bin_led PORT MAP(
        num => Contagem,
        leds => G_LEDG
    );
    
    
end behavioral;