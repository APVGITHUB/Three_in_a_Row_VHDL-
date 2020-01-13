library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity marcador is
    port (
        --entradas
        clk: in std_logic;
        reset: in std_logic;
        V1: in std_logic;
        V2: in std_logic;
        E: in std_logic;
        --ganador
        gana1: out std_logic;
        gana2: out std_logic;
        --quien empieza la siguiente partida
        inicio1: out std_logic;
        inicio2: out std_logic;
        random: out std_logic;
        --salidas para encender los leds
        partidas1: out std_logic_vector (3 downto 0);
        partidas2: out std_logic_vector (3 downto 0);
        n_partidas: out std_logic_vector (3 downto 0)
    );
end marcador;

architecture Behavioral of marcador is
    signal P1: unsigned (3 downto 0);
    signal P2: unsigned (3 downto 0);
    signal PT: unsigned (3 downto 0);
    signal dif: unsigned (3 downto 0);
   -- signal ovfP1: std_logic;
   -- signal ovfP2: std_logic;
    --signal ovfPT: std_logic;
    signal G1: std_logic;
    signal G2: std_logic;
    
    
begin

--contador de partidas jugadas
process(clk,reset)
begin
    if reset = '1' then
        PT <= (others => '0');
        --ovfPT <= '0';
    elsif clk'event and clk = '1' then
        if (V1='1' or V2='1' or E='1') then
            if PT = 8 then
                PT <= "1000";
                --ovfPT <= '1';
            else
                PT <= PT + 1;
            end if;
        end if;
    end if;
end process;

--contador partidas de 1 de 2 y la diferencia de ambos en valor absoluto
process (clk,reset)
begin
    if reset = '1' then
        P1 <= (others => '0');
        P2 <= (others => '0');
        dif <= (others => '0');
    elsif clk'event and clk = '1' then
        if V1 = '1' then
            P1 <= P1 + 1;
            if P2 > P1 then
                dif <= P2 -P1 - 1;
            else
                dif <= P1 - P2 +1;
            end if;
        elsif V2 = '1' then
            P2 <= P2 + 1;
            if P1 > P2 then
                dif <= P1 -P2 - 1;
            else
                dif <= P2 - P1 +1;
            end if;
            
        end if;
    end if;
end process;
--¿que pasa con la siguiente partida?
process(clk,reset)
begin
    if reset = '1' then
        G1 <= '0';
        G2 <= '0';
    elsif clk'event and clk = '1' then       
        --muerte subita
        if PT=8 and dif /= 0 then
            if V1 <= '1' then
                G1 <= '1';
            elsif V2 <= '1' then
                G2 <= '1';
            end if;
        else 
        --no se puede remontar
            if  (8 - PT) < (dif)  then     
                if P1 > P2 then
                    G1 <= '1';
                elsif P2 > P1 then
                    G2 <= '1';
                end if;
            end if;    
        end if;               
    end if;        
end process;


 --NUEVA PARTIDA: ¿quién tiene el primer turno?  
inicio1 <= '1' when V2 = '1' and G2 = '0' and G1 = '0' else '0'; --se podria poner cmo una sola
inicio2 <= '1' when V1 = '1' and G2 = '0' and G1 = '0' else '0';
random <= '1' when E = '1' and G2 = '0' and G1 = '0' else '0';

--salidas del marcador
gana1 <= std_logic(G1);
gana2 <= std_logic(G2);
partidas1 <= std_logic_vector(P1);
partidas2 <= std_logic_vector(P2);
n_partidas <= std_logic_vector(PT);

end Behavioral;

