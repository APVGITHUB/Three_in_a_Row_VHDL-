-- elegir la posicion mediante los botones B4,B3,B2
---------------------------------------------------------------------------------------------------------- 
--TABLERO
--                  3-       6-       9-        ARRIBA (tmp2)            Tab = 9 8 7 6 5 4 3 2 1      
--                  2-       5-       8-        MEDIO (tmp1)                   
--                  1-       4-       7-        ABAJO                    vector 9 bits que pueden ser '0' o '1'
--                                                                          '0' --> posicion libre    
--                  B4       B3       B2                                    '1' --> posicion ocupada       

 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity botones is
    port (
        clk: in std_logic;
        reset: in std_logic;
        B4: in std_logic;
        B3: in std_logic;
        B2: in std_logic;
        election: out std_logic_vector (8 downto 0)     -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)              
    );
end botones;

architecture Behavioral of botones is
   
    signal en: std_logic;
    signal en_prev: std_logic; 
    signal bot: std_logic_vector (1 downto 0);
    
     --temporizador 1
    constant T1: integer := (125*10**6)/2;     --0,5 segundos
    signal tmp1: integer range 0 to T1;
    signal medio: std_logic;
    signal ovf1: std_logic;
    
    --temporizador 2
    constant T2: integer := (125*10**6)*3/2;  --1,5 segundos
    signal tmp2: integer range 0 to T2;
    signal arriba: std_logic;
    signal ovf2: std_logic;
   
    signal union: std_logic_vector(3 downto 0);


begin

--temporizador 1 (0,5s)
process(clk,reset)
begin  
    if reset = '1' then
        tmp1 <= 0;
    elsif clk'event and clk = '1' then
        if en = '1' then
            if tmp1 = T1-1 then
                tmp1 <= 0;
            else 
                tmp1 <= tmp1 +1;
            end if;
        else 
            tmp1 <= 0;
        end if;
    end if;                         
end process;
ovf1 <= '1' when (tmp1 = T1-1) and en='1' else '0';

--temporizador 2 (1,5s)
process(clk,reset)
begin  
    if reset = '1' then
        tmp2 <= 0;
    elsif clk'event and clk = '1' then
        if en='1' then
            if tmp2 = T2-1 then
                tmp2 <= 0;
            else 
                tmp2 <= tmp2 +1;
            end if;
         else 
            tmp2 <= 0;
        end if;
    end if;                         
end process;
ovf2 <= '1' when (tmp2 = T2-1) and en='1' else '0';


en <= '1' when (B4='1' or B3='1' or B2='1') else '0';       --enable activado mientras mantenga pulsado el boton

--guardar pulsos temporizadores
process(clk,reset)
begin
    if reset = '1' then
        arriba <= '0';
        medio <= '0';
        en_prev <= '0';
    elsif clk'event and clk = '1' then
        if en='1' and en_prev='0' then              --acabo de pulsar el boton (reset)
            medio <='0';
            arriba <= '0';
            en_prev <= '1';
        elsif en = '1' and en_prev = '1' then       --mantener pulsado el boton
            if ovf2 = '1' then
                arriba <= '1';
            elsif ovf1 = '1' then
                medio <= '1';
            end if;
        elsif en = '0' and en_prev = '1' then       --soltar el boton
            en_prev <= '0';
        end if;
    end if;
end process;

-- qué boton se ha pulsado
process(clk,reset)
begin
    if reset = '1' then
        bot <= (others => '0');
    elsif clk'event and clk = '1' then
        if B4 = '1' then
            bot <= "01";
        elsif B3 = '1' then
            bot <= "10";
        elsif B2 = '1' then
            bot <= "11";
        end if;
    end if;
end process;

--Eleccion realizada dependiendo del boton pulsado y del tiempo pulsado (decodificador)
union <= bot & arriba & medio;

election <= "000000001" when union = "0100" else
            "000000010" when union = "0101" else
            "000000100" when union = "0110" else
            "000001000" when union = "1000" else
            "000010000" when union = "1001" else
            "000100000" when union = "1010" else
            "001000000" when union = "1100" else
            "010000000" when union = "1101" else
            "100000000" when union = "1110" else
--            "000000000" when inicio = '1' else        --falta poner a 0 eleccion al comienzo de cada turno (poner un enable al decodificador)
            "---------" ;
            


end Behavioral;
