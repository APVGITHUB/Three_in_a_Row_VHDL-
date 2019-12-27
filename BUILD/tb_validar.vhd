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
           B1: in std_logic;
           B2: in std_logic;
           B3: in std_logic;
           B4: in std_logic;
          -- B1_prev1: in std_logic;
           --B1_prev2: in std_logic;
           turno: in std_logic;
           --election: in std_logic_vector (8 downto 0);           -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
           Tablero1: out std_logic_vector (8 downto 0);        -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
           Tablero2: out std_logic_vector (8 downto 0);        -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
           fail: out std_logic;                               -- si la posicion elegida no es valida => fail=1 durante 1 segundo
           
           V1: out std_logic;      --victoria jugador 1
           V2: out std_logic;      --victoria jugador 2
           E: out std_logic        --empate
                  
       );
    end component;
    

       signal clk: std_logic;
       signal reset: std_logic;
       signal B1: std_logic;
       signal B2: std_logic;
       signal B3: std_logic;
       signal B4: std_logic;
       --signal B1_prev1: std_logic;
       --signal B1_prev2: std_logic;
       signal turno: std_logic;
       --signal election: std_logic_vector (8 downto 0);           -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
       signal Tablero1: std_logic_vector (8 downto 0);        -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
       signal Tablero2: std_logic_vector (8 downto 0);        -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
       signal fail: std_logic;                               -- si la posicion elegida no es valida => fail=1 durante 1 segundo
       
       signal V1: std_logic;      --victoria jugador 1
       signal V2: std_logic;      --victoria jugador 2
       signal E: std_logic;        --empate
      
       --declaracion tiempo
       constant clk_period : time := 8 ns;            

begin

    --instanciacion del componente
        uut: validar
            port map (
                clk => clk,
                reset => reset,
                B1 => B1,
                B2=>B2,
                B3=>B3,
                B4=>B4,
                --B1_prev1 => B1_prev1,
                --B1_prev2 => B1_prev2,
                turno => turno,
               -- election => election,
                Tablero1 => Tablero1,
                Tablero2 => Tablero2,
                fail => fail,
                V1 => V1,
                V2 => V2,
                E => E
                
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
        B1 <= '0';
        B2 <='0';
        B3 <= '0';
        B4 <= '0';
        turno <= '0';
        --B1_prev1 <= '0';
        --B1_prev2 <= '0';
        --election <= (others => '0');
        wait for 10 us;
        reset <= '0';
        wait for 20 us;
        --rebotes por ruido
        B4 <= '1';
        wait for 100 ns;
        B4 <= '0';
        wait for 10 us;
        B4 <= '1';
        wait for 4 us;
        B4 <= '0';
        wait for 10 us;
        --pulsar B1
        B1 <= '1';
        wait for 1 us;
        B1 <='0';
        wait for 10 us;
         B4 <= '1';
         wait for 4 us;
         B4 <= '0';
         wait for 10 us;
         --pulsar B1
         B1 <= '1';
         wait for 1 us;
         B1 <='0';
         wait for 10 us;
         wait;
    end process;
    
            
end testbench;
