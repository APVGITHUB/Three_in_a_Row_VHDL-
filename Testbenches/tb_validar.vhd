library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity tb_validar is
end tb_validar;

architecture testbench of tb_validar is
    
    component validar is
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
           E: out std_logic        --empate
           
           random: in std_logic;     
           inicio1: in std_logic;
           inicio2: in std_logic;
           fin_tiempo: in std_logic;
           reset_election: out std_logic       
       );
    end component;
    

       signal clk: std_logic;
       signal reset: std_logic;
       signal speed: std_logic;
       signal mode: std_logic_vector (1 downto 0);
       signal B1val: std_logic;
       signal B1_prev1: std_logic;
       signal turn: std_logic;
       signal election: std_logic_vector (8 downto 0);           -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
       signal Tablero1: std_logic_vector (8 downto 0);        -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
       signal Tablero2: std_logic_vector (8 downto 0);        -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
       signal fail: std_logic;                               -- si la posicion elegida no es valida => fail=1 durante 1 segundo
       
       signal V1: std_logic;      --victoria jugador 1
       signal V2: std_logic;      --victoria jugador 2
       signal E: std_logic;        --empate
      
       signal random: std_logic;     
       signal inicio1: std_logic;
       signal inicio2: std_logic;
       signal fin_tiempo: std_logic;
       signal reset_election: std_logic; 
       --declaracion tiempo
       constant clk_period : time := 8 ns;            

begin

    --instanciacion del componente
        uut: validar
            port map (
                clk => clk,
                reset => reset,
                speed => speed,
                mode => mode,
                B1val => B1val,
                B1_prev1 => B1_prev1,
                B1_prev2 => B1_prev2,
                turn => turn,
                election => election,
                Tablero1 => Tablero1,
                Tablero2 => Tablero2,
                fail => fail,
                V1 => V1,
                V2 => V2,
                E => E,
                random => random,
                inicio1 => inicio1,
                inicio2 => inicio2,
                fin_tiempo => fin_tiempo,
                reset_election => reset_election
                
                
            );
            
     --generacion de reloj
     process
     begin
        clk <= '1';
        wait for clk_period/2;
        clk <= '0';
        wait for clk_period/2;        
    end process;
        
    --generacion resto de entradas
    process
    begin
        reset <= '1';
        speed <= '1';
        mode <= "00";
        B1val <= '0';
        B1_prev1 <= '0';
        turn <= '0';
        election <= (others => '0');
        random <= '0';
        inicio1 <= '0';
        inicio2 <= '0';
        fin_tiempo <= '0';
        wait for clk_period*100;
        reset <= '0';
        wait for clk_period*10;
        election <= "000000001";
        wait for clk_period*10;
        --pulsar B1
        B1val <= '1';
        wait for clk_period;
        B1_prev1 <= '1';
        wait for clk_period;
        B1_prev2 <= '1';
        wait for clk_period*10;
        B1val <= '0';
        wait for clk_period;
        B1_prev1 <= '0';
        turn <= '1';
        wait for clk_period;
        B1_prev2 <= '0';
        wait for clk_period*10;
        election <= "100000000";
        wait for clk_period*10;
        --pulsar B1
        B1val <= '1';
        wait for clk_period;
        B1_prev1 <= '1';
        wait for clk_period;
        B1_prev2 <= '1';
        wait for clk_period*10;
        B1val <= '0';
        wait for clk_period;
        B1_prev1 <= '0';
        turn <= '0';
        wait for clk_period;
        B1_prev2 <= '0';
        wait for clk_period*10;
        election <= "000000010";
        wait for clk_period*10;
        --pulsar B1
        B1val <= '1';
        wait for clk_period;
        B1_prev1 <= '1';
        wait for clk_period;
        B1_prev2 <= '1';
        wait for clk_period*10;
        B1val <= '0';
        wait for clk_period;
        B1_prev1 <= '0';
        turn <= '1';
        wait for clk_period;
        B1_prev2 <= '0';
        wait for clk_period*10;
        election <= "110000000";
        wait for clk_period*10;
        --pulsar B1
        B1val <= '1';
        wait for clk_period;
        B1_prev1 <= '1';
        wait for clk_period;
        B1_prev2 <= '1';
        wait for clk_period*10;
        B1val <= '0';
        wait for clk_period;
        B1_prev1 <= '0';
        turn <= '0';
        wait for clk_period;
        B1_prev2 <= '0';
        wait for clk_period*10;
        election <= "000000111";
        wait for clk_period*10;
        --pulsar B1
        B1val <= '1';
        wait for clk_period;
        B1_prev1 <= '1';
        wait for clk_period;
        B1_prev2 <= '1';
        wait for clk_period*10;
        B1val <= '0';
        wait for clk_period;
        B1_prev1 <= '0';
        turn <= '1';
        wait for clk_period;
        B1_prev2 <= '0';
        wait;
    end process;
    
            
end testbench;
