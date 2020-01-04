
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;


entity top is
  Port ( 
        clk: in std_logic;
        reset: in std_logic;
        speed: in std_logic;
        B4: in std_logic;
        B3: in std_logic;
        B2: in std_logic;
        B1: in std_logic;
        selector: out std_logic_vector (3 downto 0);
        segmentos: out std_logic_vector (7 downto 0);
        leds: out std_logic_vector (7 downto 0)
        );
end top;

architecture Structural of top is

    component botones is
    port (
        clk: in std_logic;
        reset: in std_logic;
        speed: in std_logic;
        B4: in std_logic;
        B3: in std_logic;
        B2: in std_logic;
        B1: in std_logic;
        B1val: out std_logic;
        B1_prev1: out std_logic;
        fijar: in std_logic;
        election: out std_logic_vector (8 downto 0);
        random: in std_logic;
        inicio1: in std_logic;
        inicio2: in std_logic               
    );
    end component;
    
    
    component validar is
    port (
        clk: in std_logic;
        reset: in std_logic;
        speed: in std_logic;
        B1val: in std_logic;
        B1_prev1: in std_logic;
        turn: in std_logic;
        election: in std_logic_vector (8 downto 0);           
        Tablero1: out std_logic_vector (8 downto 0);        
        Tablero2: out std_logic_vector (8 downto 0);        
        fail: out std_logic;                               
        V1: out std_logic;     
        V2: out std_logic;      
        E: out std_logic;
        random: in std_logic;
        inicio1: in std_logic;
        inicio2: in std_logic                                    
        );
    end component;
      
    component marcador is
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
          partidas1: out std_logic_vector (2 downto 0);
          partidas2: out std_logic_vector (2 downto 0)
      ); 
    end component;
    
    component displays is
    Port (
          reset: in std_logic;
          clk: in std_logic;
          speed: in std_logic;
          selector: out std_logic_vector (3 downto 0);
          segmentos: out std_logic_vector (7 downto 0);
          election: in std_logic_vector (8 downto 0);        
          Tablero1: in std_logic_vector (8 downto 0);           
          Tablero2: in std_logic_vector (8 downto 0);          
          turn: in std_logic;          
          fail: in std_logic;
          
          V1: in std_logic;     
          V2: in std_logic;      
          E: in std_logic;
          gana1: in std_logic;
          gana2: in std_logic
          );
    end component;
          
    component luces is
    port (
          clk: in std_logic;
          reset: in std_logic;
          partidas1: in std_logic_vector (2 downto 0);
          partidas2: in std_logic_vector (2 downto 0);
          leds: out std_logic_vector (7 downto 0)
      );      
    end component;
    
    component turnos is
    port (
        clk: in std_logic;
        reset: in std_logic;
        B1: in std_logic;
        B1_prev: in std_logic;
        V1: in std_logic;
        V2: in std_logic;
        E: in std_logic;
        election: in std_logic_vector (8 downto 0);          
        turn: out std_logic;
        fail: in std_logic;
        fijar: out std_logic                                     
        );
    end component;
    
    -- señales
    signal Tablero1: std_logic_vector (8 downto 0);
    signal Tablero2: std_logic_vector (8 downto 0); 
    signal turno: std_logic;
    signal B1val: std_logic; 
    signal B1_prev1: std_logic;
    signal election: std_logic_vector (8 downto 0);
    signal V1: std_logic;
    signal V2: std_logic;
    signal E: std_logic;  
    signal fail: std_logic;
    signal gana1: std_logic;
    signal gana2: std_logic;
    signal partidas1: std_logic_vector (2 downto 0);
    signal partidas2: std_logic_vector (2 downto 0);
    signal inicio1: std_logic;
    signal inicio2: std_logic;
    signal random: std_logic;
    signal fijar: std_logic;
    ------
begin

    pulsar_botones: botones
    port map (
    clk => clk,
    reset => reset,
    speed => speed,
    B4 => B4,
    B3 => B3,
    B2 => B2,
    B1 => B1,
    B1val => B1val,
    B1_prev1 => B1_prev1,
    fijar => fijar,
    election => election,
    random => random,
    inicio1 => inicio1,
    inicio2 => inicio2    
    );
    
    
    validacion: validar
    port map (
    clk => clk,
    reset=> reset,
    speed => speed,
    B1val => B1val,
    B1_prev1 => B1_prev1,
    turn => turno,
    election => election,          
    Tablero1 => Tablero1,        
    Tablero2 => Tablero2,     
    fail => fail,                            
    V1 => V1,  
    V2 => V2,    
    E => E,
    random => random,
    inicio1 => inicio1,
    inicio2 => inicio2
    );
    
    actualizar_marcador: marcador  
    port map (        
    clk => clk,
    reset => reset,
    V1 => V1,
    V2 => V2,
    E => E,
   
    gana1 => gana1,
    gana2 => gana2,
    
    inicio1 => inicio1,
    inicio2 => inicio2,
    random => random,

    partidas1 => partidas1,
    partidas2 => partidas2
    );         
    
    mostrar_marcador: displays
    port map(
     reset => reset,    
     clk => clk,
     speed => speed,
     selector => selector,
     segmentos => segmentos,
     election => election,       
     Tablero1 => Tablero1,            
     Tablero2 => Tablero2,         
     turn => turno,          
     fail => fail,
     
     V1 => V1,    
     V2 => V2,    
     E => E,
     gana1 => gana1,
     gana2 => gana2
     );  
     
     mostrar_leds: luces
     port map(
     clk => clk,
     reset => reset,
     partidas1 => partidas1,
     partidas2 => partidas2,
     leds => leds
     );              
 
     actualizar_turno: turnos
     port map(
     clk => clk,
     reset => reset,
     B1 => B1,
     B1_prev => B1_prev1,
     V1 => V1,
     V2 => V2,
     E => E,
     election => election,   
     turn => turno,
     fail => fail,
     fijar => fijar                                        
     );
end Structural;
