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
        speed: in std_logic;
        B4: in std_logic;
        B3: in std_logic;
        B2: in std_logic;
        B1: in std_logic;
        B1val: out std_logic; --HE AÑADIDO ESTA SALIDA PARA QUE SEA B1 TENIENDO EN CUENTA EL ANTIRREBOTE
        B1_prev1: out std_logic;
        fijar: in std_logic;
        election: out std_logic_vector (8 downto 0);     -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)              
        random: in std_logic;
        inicio1: in std_logic;
        inicio2: in std_logic;
        fin_tiempo: in std_logic;
        reset_election: in std_logic      
    );
end botones;

architecture Behavioral of botones is

 --DECLARACION COMPONENTE ANTIRREBOTES
   component antirebotes is
     port(
         clk : in std_logic;
         reset : in std_logic;
         speed: in std_logic;
         boton : in std_logic;
         filtrado: out std_logic
     );
    end component;
    
    signal valido : std_logic_vector(2 downto 0); --VALIDAR PULSACIONES B2,B3,B4
    signal afirm: std_logic_vector(2 downto 0);  
    signal B1_valido : std_logic; --VALIDAR PULSACION B1
    signal B1_afirm : std_logic;
    signal en: std_logic;
    signal en_prev: std_logic; 
    signal bot: std_logic_vector (1 downto 0);
    signal divider: integer range 1 to 1000;
    
     --temporizador 1
    constant T1: integer := (125*10**6)/2; -- para 0,5 segundos
    signal tmp1: integer range 0 to T1-1;
--    signal medio: std_logic;
    signal ovf1: std_logic;
    
    --temporizador 2
    constant T2: integer := (125*10**6)*3/2; --para 1,5 segundos
    signal tmp2: integer range 0 to T2-1;
--    signal arriba: std_logic;
    signal ovf2: std_logic;
   
    signal union: std_logic_vector(3 downto 0);
    signal B1_previo: std_logic;
    signal selector : std_logic_vector(1 downto 0);
    signal upper : std_logic;

begin


--CONEXIONES ANTIREBOTES Y BOTONES
ar1: antirebotes
    port map (
        clk  => clk,
        reset => reset,
        speed => speed,
        boton=>B1,
        filtrado => B1_valido
    );
ar2: antirebotes
    port map (
        clk  => clk,
        reset => reset,
        speed => speed,
        boton=>B2,
        filtrado => valido(0)
    );
ar3: antirebotes
        port map (
            clk  => clk,
            reset => reset,
            speed => speed,
            boton=>B3,
            filtrado => valido(1)
        );
ar4: antirebotes
            port map (
                clk  => clk,
                reset => reset,
                speed => speed,
                boton=>B4,
                filtrado => valido(2)
            );        
--ASIGNAR PULSACIÓN AFIRMATIVA A afirm
process(clk,reset)
       begin  
          if reset = '1' then
             afirm<= (others =>'0');
         elsif clk'event and clk='1' then
             if valido /= "000" then
                afirm <= valido;
             elsif en = '0' then
                 afirm <= "000";
             end if;
         end if;
end process;

--PULSACION VALIDA DE B1
process(clk,reset)
       begin  
          if reset = '1' then
             B1_afirm <= '0';
         elsif clk'event and clk='1' then
             if fin_tiempo = '1' then--or fin_maquina = '1' then
                B1_afirm <= '1';
             elsif B1_valido = '1' then
                B1_afirm <= B1_valido;
             elsif B1 = '0' then
                B1_afirm <= '0';
             end if;
         end if;
end process;
--divisor frecuencia para simulacion
divider <= 1000 when speed = '1' else 1;
--temporizador 1 (0,5s)
process(clk,reset)
begin  
    if reset = '1' then
        tmp1 <= 0;
    elsif clk'event and clk = '1' then
        if en = '1' then
            if tmp1 = T1/divider-1 then
                tmp1 <= 0;
            else 
                tmp1 <= tmp1 +1;
            end if;
        else 
            tmp1 <= 0;
        end if;
    end if;                         
end process;
ovf1 <= '1' when (tmp1 = T1/divider-1) and en='1' else '0';

--temporizador 2 (1,5s)
process(clk,reset)
begin  
    if reset = '1' then
        tmp2 <= 0;
    elsif clk'event and clk = '1' then
        if en='1' then
            if tmp2 = T2/divider-1 then
                tmp2 <= 0;
            else 
                tmp2 <= tmp2 +1;
            end if;
         else 
            tmp2 <= 0;
        end if;
    end if;                         
end process;
ovf2 <= '1' when (tmp2 = T2/divider-1) and en='1' else '0';


en <= '1' when (B4='1' or B3='1' or B2='1') else '0';       --enable activado mientras mantenga pulsado el boton

--guardar pulsos temporizadores
process(clk,reset)
begin
    if reset = '1' then
        en_prev <= '0';
        selector <=(others =>'0');
    elsif clk'event and clk = '1' then
            if ((en='1' and en_prev='0' and afirm /= "000")) then 
                en_prev <= '1';
                selector <= "01";
            elsif en = '1' and en_prev = '1' then       --mantener pulsado el boton
                if upper = '1' then
                    selector <= "11";
                elsif ovf1 = '1' and ovf2 ='0' then
                      selector <= "10";
                end if;
            elsif en = '0' and en_prev = '1' then       --soltar el boton
                 en_prev <= '0';
            elsif (reset_election = '1' or fijar = '1') then
                 selector <= "00";
            end if;
    end if;
end process;

-- quÃ© boton se ha pulsado
process(clk,reset)
begin
    if reset = '1' then
        bot <= (others => '0');
    elsif clk'event and clk = '1' then
        if (reset_election = '1' or fijar = '1') then
            bot <= (others => '0');
        elsif afirm /= "000" then
             if B4 = '1' then
                bot <= "01";
            elsif B3 = '1' then
                bot <= "10";
            elsif B2 = '1' then
                bot <= "11";
            end if;
        end if;
    end if;
end process;

--ASIGNAR PULSACION UP HASTA DEJAR LA PULSACION
process(clk,reset)
    begin  
        if reset = '1' then
        upper<='0';
        elsif clk'event and clk='1' then
               if ovf2 = '1' then
                    upper <= ovf2;
               elsif en = '0' then
                    upper <= '0';
                end if;
        end if;
end process;

--Eleccion realizada dependiendo del boton pulsado y del tiempo pulsado (decodificador)
union <= bot & selector;

election <= "000000000" when (inicio1 = '1' or inicio2 ='1' or random = '1') else
            "000000001" when union = "0101" else
            "000000010" when union = "0110" else
            "000000100" when union = "0111" else
            "000001000" when union = "1001" else
            "000010000" when union = "1010" else
            "000100000" when union = "1011" else
            "001000000" when union = "1101" else
            "010000000" when union = "1110" else
            "100000000" when union = "1111" else
            "000000000";

process (clk,reset)
begin
    if reset = '1' then
        B1_previo <= '0';
    elsif clk'event and clk='1' then
        if B1_afirm ='1' and B1_previo = '0' then           
            B1_previo <= '1';           
        elsif B1_afirm = '0' and B1_previo = '1' then           
            B1_previo <= '0';          
        end if;
        
    end if;
end process;
B1val <= B1_afirm;
B1_prev1 <= B1_previo;

end Behavioral;
