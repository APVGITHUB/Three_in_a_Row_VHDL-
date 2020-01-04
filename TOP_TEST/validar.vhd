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
        B1val: in std_logic; -- EN LUGAR DE B1 USAMOS LA SEÑAL TENIENDO EN CUENTA EL ANTIRREBOTE
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
        inicio2: in std_logic               
    );
end validar;

architecture Behavioral of validar is
    
    --determinar eleccion 
    signal comparar: std_logic_vector(8 downto 0) := "000000000";
    signal divider: integer range 1 to 1000;    
    constant MAX: integer := 1500; --PARA SIMULACION, HAY QUE CAMBIAR, ES UN SEGUNDO 125*10**6;
    signal seg: integer range 0 to MAX-1;
    
    
    signal Tab1: std_logic_vector (8 downto 0); --:= "000000000";
    signal Tab2: std_logic_vector (8 downto 0);--:= "000000000";

    signal S: std_logic_vector (8 downto 0);
    signal V: std_logic;    --victoria
    signal Tab: std_logic_vector (8 downto 0);      --fichas de 1 + fichas de 2
    signal empate: std_logic;
    signal error: std_logic;
    signal ocho: std_logic;
    signal V_previo: std_logic;
    signal empate_previo: std_logic;
    
    

begin

Tab <= Tab1 xor Tab2;
comparar <= election and Tab;

--actualizar tablero
process(clk,reset)
begin
    if reset='1' then
        Tab1<="000000000";
        Tab2<="000000000";
    elsif clk'event and clk='1' then
        if (turn='0' and B1_prev1='1' and comparar = "000000000") then --TIENE QUE SER EL PREVIO PARA QUE EL ERROR SEA CORRECTO Y EL TABLERO SE CAMBIE DESPUES
            Tab1 <= (Tab1 xor election);
        elsif (turn = '1' and B1_prev1 = '1' and comparar = "000000000") then
            Tab2 <= (Tab2 xor election);
        end if;
        if (inicio1='1' or inicio2='1' or random = '1') then
            Tab1<="000000000";
            Tab2<="000000000";   
        end if; 
    end if;
end process;

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

--NECESARIO PARA QUE empate, V1 Y V2 SEAN DE UN PULSO
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
V1 <= '1' when (V_previo = '1' and V = '0' and turn = '1') else '0'; --and B1val='1' and B1_prev1 ='0') else '0';
V2 <= '1' when (V_previo = '1' and V = '0' and turn = '0') else '0'; --and B1val='1' and B1_prev1 ='0') else '0';
E <= '1' when (empate_previo = '1' and empate='0') else '0';

end Behavioral;
