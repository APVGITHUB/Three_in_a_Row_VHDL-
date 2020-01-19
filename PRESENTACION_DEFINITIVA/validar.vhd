--comparar la eleccion con las fichas colocadas en el tablero los turno anteriores
--si la nueva posicion ya estaba seleccionada de turnos anteriores mostrar un error con un 8 un segundo
--si la nueva posicion es valida actualizar el tablero y cambiar el turno al otro jugador

 

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity validar is
    port (
        clk: in std_logic;
        reset: in std_logic;
        speed: in std_logic;
        mode: in std_logic_vector (1 downto 0);
        B1val: in std_logic; 
        B1_prev1: in std_logic;
        turn: in std_logic;
        election: in std_logic_vector (8 downto 0);           -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
        Tablero1: out std_logic_vector (8 downto 0);        -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
        Tablero2: out std_logic_vector (8 downto 0);        -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
        fail: out std_logic;                               -- si la posicion elegida no es valida => fail=1 durante 1 segundo
        V1: out std_logic;      --victoria jugador 1
        V2: out std_logic;      --victoria jugador 2
        E: out std_logic;   --empate
        random: in std_logic;     
        inicio1: in std_logic;
        inicio2: in std_logic;
        fin_tiempo: in std_logic;
        reset_election: out std_logic
       
                        
    );
end validar;

architecture Behavioral of validar is
    
    --determinar eleccion 
    signal comparar: std_logic_vector(8 downto 0) := "000000000";
    signal divider: integer range 1 to 1000;    
    constant MAX: integer := 125*10**6;
    signal seg: integer range 0 to MAX-1;
    
    
    signal Tab1: std_logic_vector (8 downto 0);
    signal Tab2: std_logic_vector (8 downto 0);

    signal S: std_logic_vector (8 downto 0);
    signal V: std_logic;    --victoria
    signal Tab: std_logic_vector (8 downto 0);      --fichas de 1 + fichas de 2
    signal empate: std_logic;
    signal error: std_logic;
    signal ocho: std_logic;
    signal V_previo: std_logic;
    signal empate_previo: std_logic;
    
    signal resetear_election: std_logic;
    signal n: integer range 0 to 8;
   
    
    

begin

-- se comprueba si la casilla elegida está libre
Tab <= Tab1 xor Tab2;
comparar <= election and Tab;

--Generador de posiciones aleatorias para los modos 2 y 3
process (clk,reset)
begin
    if reset = '1' then
        n <= 0;
    elsif clk'event and clk = '1' then
        if n = 8 then
            n <= 0;
        else
            n <= n+1;
        end if;
    end if;
end process;

--actualizar tablero
process(clk,reset)
begin
    if reset='1' then
        Tab1<="000000000";
        Tab2<="000000000";
        resetear_election <= '0';
        
    elsif clk'event and clk='1' then
        if resetear_election = '1' then
            resetear_election <= '0';
        end if;
        --Si hay una casilla elegida en una posición libre se añade al tablero correspondiente (y se indica que se debe poner la elección a 0)
        --En caso de que se haya acabado el tiempo, o de que juegue la máquina, se escoge una casilla libre aleatoria.
        if turn='0' then 
            if (B1_prev1='1' and comparar = "000000000" and election /= "000000000") then
                Tab1 <= (Tab1 xor election);
                resetear_election <= '1';             
            elsif (fin_tiempo = '1' and (comparar /= "000000000" or election = "000000000")) then
                if Tab(n REM 9)='0' then
                    Tab1(n REM 9)<='1';
                elsif Tab(n+1 REM 9)='0' then
                    Tab1(n+1 REM 9)<='1';
                elsif Tab(n+2 REM 9)='0' then
                    Tab1(n+2 REM 9)<='1';
                elsif Tab(n+3 REM 9)='0' then
                    Tab1(n+3 REM 9)<='1'; 
                elsif Tab(n+4 REM 9)='0' then
                    Tab1(n+4 REM 9)<='1';
                elsif Tab(n+5 REM 9)='0' then
                    Tab1(n+5 REM 9)<='1';
                elsif Tab(n+6 REM 9)='0' then
                    Tab1(n+6 REM 9)<='1';
                elsif Tab(n+7 REM 9)='0' then
                    Tab1(n+7 REM 9)<='1'; 
                elsif Tab(n+8 REM 9)='0' then
                    Tab1(n+8 REM 9)<='1';  
                end if; 
                resetear_election <= '1';          
            end if;                                                     
        elsif turn = '1' then
            if (B1_prev1 = '1' and comparar = "000000000" and election /= "000000000" and mode /="10") then
                Tab2 <= (Tab2 xor election);
                resetear_election <= '1'; 
            elsif ((fin_tiempo = '1' and (comparar /= "000000000" or election = "000000000")) or mode = "10") then
                if Tab(n REM 9)='0' then
                    Tab2(n REM 9)<='1';
                elsif Tab(n+1 REM 9)='0' then
                    Tab2(n+1 REM 9)<='1';
                elsif Tab(n+2 REM 9)='0' then
                    Tab2(n+2 REM 9)<='1';
                elsif Tab(n+3 REM 9)='0' then
                    Tab2(n+3 REM 9)<='1'; 
                elsif Tab(n+4 REM 9)='0' then
                    Tab2(n+4 REM 9)<='1';
                elsif Tab(n+5 REM 9)='0' then
                    Tab2(n+5 REM 9)<='1';
                elsif Tab(n+6 REM 9)='0' then
                    Tab2(n+6 REM 9)<='1';
                elsif Tab(n+7 REM 9)='0' then
                    Tab2(n+7 REM 9)<='1'; 
                elsif Tab(n+8 REM 9)='0' then
                    Tab2(n+8 REM 9)<='1';  
                end if; 
                resetear_election <= '1';                                    
            end if;        
        end if;       
        --Con cada nueva partida se ponen los tableros a cero.
        if (inicio1='1' or inicio2='1' or random = '1') then
            Tab1<="000000000";
            Tab2<="000000000";   
        end if; 
    end if;
end process;

reset_election <= resetear_election;

--Error dura un pulso e indica que la casilla no está libre
error <= '1' when (B1val = '1' and B1_prev1 = '0' and comparar /= "000000000") else '0';


--MUX
with turn select
    S <= Tab1 when '0',
         Tab2 when '1',
         "---------" when others;
         
--empate
empate <= '1' when ((Tab = "111111111") and (V_previo = '0' and V = '0') and B1val = '1') else '0';     --debe durar un ciclo de reloj


--3 en raya
V <= '1' when (S(0)='1' and S(1)='1' and S(2)='1') or 
              (S(3)='1' and S(4)='1' and S(5)='1') or 
              (S(6)='1' and S(7)='1' and S(8)='1') or 
              (S(0)='1' and S(3)='1' and S(6)='1') or 
              (S(1)='1' and S(4)='1' and S(7)='1') or 
              (S(2)='1' and S(5)='1' and S(8)='1') or 
              (S(2)='1' and S(4)='1' and S(6)='1') or 
              (S(0)='1' and S(4)='1' and S(8)='1')
              else '0'; 


process (clk,reset)
begin
   if reset = '1' then
      V_previo <= '0';
      empate_previo <= '0';
   elsif clk'event and clk='1' then
      if V ='1' and V_previo = '0' then           
          V_previo <= '1';           
      elsif V = '0' and V_previo = '1' then           
          V_previo <= '0';          
      end if;  
      if empate ='1' and empate_previo = '0' then           
          empate_previo <= '1';           
      elsif empate = '0' and empate_previo = '1' then           
          empate_previo <= '0';          
      end if;                    
   end if;
end process;

--enable contador de un segundo
process(clk,reset)
begin
    if reset = '1' then
        ocho <= '0';
    elsif clk'event and clk = '1' then
        if error = '1' then
            ocho <= '1';
        end if;
        if seg = MAX/divider-1 then
            ocho <= '0';
        end if;
    end if;
end process;

fail <= ocho;
--divisor de frecuencia para la simulacion
divider <= 1000 when speed = '1' else 1;
--contador de un segundo        
process(clk,reset)
begin
    if reset = '1' then
        seg <= 0;
    elsif clk'event and clk = '1' then
        if ocho = '1' then
            if seg = MAX/divider-1 then
                seg <= 0;
            else 
                seg <= seg + 1;
            end if;
        end if;
    end if;
end process;

--salidas
Tablero1 <= std_logic_vector(Tab1);
Tablero2 <= std_logic_vector(Tab2);

--V1 y V2 tienen que ser un pulso de reloj
V1 <= '1' when (V_previo = '1' and V = '0' and turn = '1') else '0'; 
V2 <= '1' when (V_previo = '1' and V = '0' and turn = '0') else '0'; 
E <= '1' when (empate_previo = '1' and empate='0') else '0';

end Behavioral;
