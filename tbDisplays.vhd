library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tbDisplays is
end tbDisplays;

architecture Behavioral of tbDisplays is
component Displays is
  Port (reset: in std_logic;
        clk: in std_logic;
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
        gana2: in std_logic);
 end component;
        
        signal clk: in std_logic :='0';
        signal reset: in std_logic :='0';
        signal election: in std_logic_vector (8 downto 0);        -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
        signal Tablero1: in std_logic_vector (8 downto 0);            -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
        signal Tablero2: in std_logic_vector (8 downto 0);            -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
        signal turn: in std_logic_vector (1 downto 0);           -- 01 => turno jugador 1        -- 10 => turno jugador 2
        signal fail: in std_logic := '0';
                
        signal V1: in std_logic :='0';      --victoria jugador 1
        signal V2: in std_logic :='0';      --victoria jugador 2
        signal E: in std_logic :='0';
        signal gana1: in std_logic :='0';
        signal gana2: in std_logic :='0';
                
        signal selector: out std_logic_vector (3 downto 0);
        signal segmentos: out std_logic_vector (7 downto 0);
        
        constant clk_period : time := 8 ns;

begin
uut: Displays PORT MAP(
        clk => clk,
        selector => selector,
        segmentos => segmentos,
        election => election,       
        Tablero1 => Tablero1,            
        Tablero2 = > Tablero2,            
        turn => turn,         
        fail => fail, 
        V1 => V1,
        V2 => V2,
        E => E,
        gana1 => gana1,
        gana2 => gana2);
    
clk_process: process
begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
end process;
   
stim_sim: process
begin
    reset <= '1';
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
    
    wait for 1 s;
     election <= "100000000";
     fail <= '1';
    wait for 1 s;
     election <= "000000000";
     fail <= '0';
    wait for 1 s;
     election <= "000000001";
    wait for 0.5 s;
     turn <= "10";
     election <= "000000000";
     Tablero1<="110000001";
    wait for 1 s;
     election <= "000000100";
    wait for 1 s;
     V2 <= '1';
     gana2 <= '1';
    wait for clk_period;
     V2 <= '0';
end process;
     
end Behavioral;
