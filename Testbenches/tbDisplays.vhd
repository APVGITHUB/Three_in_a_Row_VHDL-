library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tbDisplays is
end tbDisplays;

architecture testbench of tbDisplays is
component Displays is
  Port (
        clk: in std_logic;
        reset: in std_logic;
        speed: in std_logic; 
        selector: out std_logic_vector (3 downto 0);
        segmentos: out std_logic_vector (7 downto 0);
        election: in std_logic_vector (8 downto 0);        -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
        Tablero1: in std_logic_vector (8 downto 0);            -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
        Tablero2: in std_logic_vector (8 downto 0);            -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
        turn: in std_logic_vector (1 downto 0);           -- 01 => turno jugador 1        -- 10 => turno jugador 2
        fail: in std_logic;
        
        V1: in std_logic;      --victoria jugador 1
        V2: in std_logic;      --victoria jugador 2
        E: in std_logic;
        gana1: in std_logic;
        gana2: in std_logic;
        parar_temporizador: out std_logic
        );
 end component;
               
        --HE QUITADO LOS :='0' PERO NO CREO QUE ESO CAMBIARA NADA
        --TAMBIEN PONIA in Y out, PERO AQUI SON SEÑALES NO ENTRADAS EN TEORIA, LO HE QUITADO
        signal clk:  std_logic; 
        signal reset:  std_logic;
        signal speed:  std_logic;
        signal election:  std_logic_vector (8 downto 0);        -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
        signal Tablero1:  std_logic_vector (8 downto 0);            -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
        signal Tablero2:  std_logic_vector (8 downto 0);            -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
        signal turn:  std_logic_vector (1 downto 0);           -- 01 => turno jugador 1        -- 10 => turno jugador 2
        signal fail:  std_logic;
                
        signal V1:  std_logic;      --victoria jugador 1
        signal V2:  std_logic;      --victoria jugador 2
        signal E:  std_logic;
        signal gana1:  std_logic;
        signal gana2:  std_logic;
                
        signal selector:  std_logic_vector (3 downto 0);
        signal segmentos:  std_logic_vector (7 downto 0);
        
        signal parar_temporizador: std_logic;
        
        constant clk_period : time := 8 ns;

begin
uut: Displays 
        port map (
            clk => clk,
            reset=> reset,
            speed => speed,
            selector => selector,
            segmentos => segmentos,
            election => election,       
            Tablero1 => Tablero1,            
            Tablero2 => Tablero2,            
            turn => turn,         
            fail => fail, 
            V1 => V1,
            V2 => V2,
            E => E,
            gana1 => gana1,
            gana2 => gana2,
            parar_temporizador => parar_temporizador
            );
    
clk_process: process
begin
		clk <= 01';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;
   
stim_sim: process
begin
    reset <= '1';
    speed <= '1';
    wait for 100 ns;
    reset <='0';
    election <= "000000000";
    Tablero1 <= "110000000";
    Tablero2 <= "001010000";
    turn <= "01";
    fail <= '0';
    V1 <= '0';
    V2 <= '0';
    E <= '0';
    gana1 <= '0';
    gana2 <= '0';
    
    wait for 10 ms; -- s NO EXISTE, HAY QUE PONERO EN ns ms O ALGO DE ESO. HE REDUCIDO EL TIEMP PARA SIMULAR
     election <= "100000000";
     fail <= '1';
    wait for 10 ms;
     election <= "000000000";
     fail <= '0';
    wait for 10 ms;
     election <= "000000001";
    wait for 5 ms;
     turn <= "10";
     election <= "000000000";
     Tablero1<="110000001";
    wait for 10 ms;
     election <= "000000100";
    wait for 10 ms;
     V2 <= '1';
     gana2 <= '1';
    wait for clk_period;
     V2 <= '0';
end process;
     
end testbench;
