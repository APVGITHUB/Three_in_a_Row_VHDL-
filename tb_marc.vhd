library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_marc is
end tb_marc;

architecture testbench of tb_marc is
    --declaracion de marcador
    component marcador is 
        port(
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
    
    --declaracion señales internas
        --entradas
        signal clk: std_logic;
        signal reset: std_logic;
        signal V1: std_logic;
        signal V2: std_logic;
        signal E: std_logic;
        --ganador
        signal gana1: std_logic;
        signal gana2: std_logic;
        --quien empieza la siguiente partida
        signal inicio1: std_logic;
        signal inicio2: std_logic;
        signal random: std_logic;
        --salidas para encender los leds
        signal partidas1: std_logic_vector (2 downto 0);
        signal partidas2: std_logic_vector (2 downto 0);
        
        --declaracion de tiempo
        constant clk_period : time := 8 ns;
begin

    --instanciacion del componente
    uut: marcador
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
        V1 <= '0';
        V2 <= '0';
        E <= '0';
        wait for clk_period*200;
        reset <= '0';
        wait for clk_period*200;
        -- 1-0 -- 1
        V1 <= '1';
        V2 <= '0';
        E <= '0';
        wait for clk_period;
        V1 <= '0';
        V2 <= '0';
        E <= '0';
        wait for clk_period*10;
        -- 2-0 -- 2
        V1 <= '1';
        V2 <= '0';
        E <= '0';
        wait for clk_period;
        V1 <= '0';
        V2 <= '0';
        E <= '0';
        wait for clk_period*10;
        -- 3-0 -- 3
        V1 <= '1';
        V2 <= '0';
        E <= '0';
        wait for clk_period;
        V1 <= '0';
        V2 <= '0';
        E <= '0';
        wait for clk_period*10;
        -- 3-0 +1E-- 4
        V1 <= '0';
        V2 <= '0';
        E <= '1';
        wait for clk_period;
        V1 <= '0';
        V2 <= '0';
        E <= '0';
        wait for clk_period*10;
        -- 3-0 + 2E -- 5
        V1 <= '0';
        V2 <= '0';
        E <= '1';
        wait for clk_period;
        V1 <= '0';
        V2 <= '0';
        E <= '0';
        wait for clk_period*10;
        -- 3-0 + 3E -- 6
        V1 <= '0';
        V2 <= '0';
        E <= '1';
        wait for clk_period;
        V1 <= '0';
        V2 <= '0';
        E <= '0';
               
        wait;
    end process;

end testbench;
