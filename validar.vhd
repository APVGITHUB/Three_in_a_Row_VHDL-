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
        B1: in std_logic;
        B1_prev: in std_logic;
        V1: in std_logic;
        V2: in std_logic;
        E: in std_logic;
        election: in std_logic_vector (8 downto 0);         -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
--        Tablero1: out std_logic_vector (8 downto 0);        -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
--        Tablero2: out std_logic_vector (8 downto 0);        -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
--         fail: out std_logic;                               -- si la posicion elegida no es valida => fail=1 durante 1 segundo
        turn: out std_logic_vector( 1 downto 0)              -- 01 => turno jugador 1        -- 10 => turno jugador 2
       
               
    );
end validar;

architecture Behavioral of validar is
    
--    --determinar eleccion 
--    signal comparar: std_logic_vector(8 downto 0);
--    constant MAX: integer := 125*10**6;
--    signal seg: integer range 0 to MAX-1;
--    signal fijar: std_logic;
--    signal error: std_logic;
--    signal Tab1: std_logic_vector (8 downto 0) := "000000000";
--    signal Tab2: std_logic_vector (8 downto 0) := "000000000";
--    signal ocho: std_logic;
    
    signal turno: unsigned (1 downto 0) := "00";
    --signal inicio: std_logic;
    
    signal lfsr: std_logic_vector (3 downto 0);
    signal feedback: std_logic;
    signal r: unsigned (1 downto 0);

begin

----comparacion del tablero actual con la posicion nueva elegida
--process(clk,reset)
--begin
--    if reset = '1' then
--        comparar <= "000000000";
--    elsif clk'event and clk = '1' then
--        comparar <= eleccion and(Tab1 xor Tab2);
--    end if;
--end process;

--fijar <= '1' when comparar="000000000" and B1='1' and B1prev='0' else '0';      --dura un pulso de reloj
--error <= '1' when comparar/="000000000" and B1='1' and B1prev='0' else '0';     --dura un pulso de reloj

----activar error(ocho) 1 segundo 
--process(clk,reset)
--begin
--    if reset = '1' then
--        ocho <= '0';
--    elsif clk'event and clk = '1' then
--        if error = '1' then
--            ocho <= '1';
--        end if;
--    end if;
--end process;

----contador de un segundo        
--process(clk,reset)
--begin
--    if reset = '0' then
--        seg <= 0;
--    elsif clk'event and clk = '1' then
--        if ocho = '1' then
--            if seg = MAX-1 then
--                seg <= 0;
--                ocho <= '0';
--            else 
--                seg <= seg + 1;
--            end if;
--        end if;
--    end if;
--end process;

----actualizar tablero
--Tab1 <= (Tab1 xor eleccion) when (turno = '0' and fijar = '1');
--Tab2 <= (Tab2 xor eleccion) when (turno = '1' and fijar = '1');

----pulsar boton B1 y eleccion es válida => fijar = '1'
--process(clk,reset)
--begin
--    if reset = '1' then
--        B1prev <= '0';
--    elsif clk'event and clk = '1' then
--        if B1 = '1' then
--            B1prev <= '1';
--        end if;
--    end if;
--end process;

----soltar boton B1 y cambia turno
--process(clk,reset)
--begin
--    if reset = '1' then
--        --turno <= alterna;       --primer turno de la partida
--    elsif clk'event and clk = '1' then
--        if B1='0' and B1prev='1' then
--            if turno = '0' then turno <= '1';     -- turno 1 --> turno 2
--            elsif turno = '1' then turno <= '0';  -- turno 2 --> turno 1
--            end if;
--            B1prev <= '0';
--        end if;
--    end if;
--end process;


--bit aleatorio 
feedback <= not(lfsr(3) xor lfsr(2)); 
process(clk,reset)
begin
    if reset = '1' then
        lfsr <= (others => '0');
    elsif clk'event and clk = '1' then
        lfsr <= lfsr(2 downto 0) & feedback;
    end if;
end process;

with lfsr(3) select
r <= "01" when '0',
     "10" when '1',
     "--" when others;

----turno inicial
--process(clk,reset)
--begin
--    if reset = '1' then
--        turno <= (others => '0');
--        --inicio <= '0';
--    elsif clk'event and clk = '1' then          
--        if V1 = '1' then
--            turno <= "10";
--        elsif V2 = '1' then
--            turno <= "01";
--        elsif E <= '1' then
--            turno <= r;
--        else
--            if B1 = '0' and B1_prev = '1' then
--                turno <= not(turno);
--            end if;
--        end if;
--    end if;
--end process;
turno <= "01" when V1 = '1' else
         "10" when V2 = '1' else
         r when E = '1' else
         not(turno) when B1 = '0' and B1_prev = '1' else
         "--";

--salidas
--Tablero1 <= std_logic_vector(Tab1);
--Tablero2 <= std_logic_vector(Tab2);
turn <= std_logic_vector(turno);
--fail <= ocho;
end Behavioral;