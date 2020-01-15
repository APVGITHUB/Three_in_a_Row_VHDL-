library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_temporizador is

end tb_temporizador;

architecture testbench of tb_temporizador is
    component temporizador
        Port ( 
            clk: in std_logic;
            reset: in std_logic;
            speed: in std_logic;
            mode: in std_logic_vector (1 downto 0);
            cambia_turno: in std_logic;
            n_partidas: in std_logic_vector (3 downto 0);
            fin_tiempo: out std_logic;
            parar_temporizador: in std_logic     
            );
    end component;
    
    signal clk: std_logic;
    signal reset: std_logic;
    signal speed: std_logic;
    signal mode: std_logic_vector (1 downto 0);
    signal cambia_turno: std_logic;
    signal n_partidas: std_logic_vector (2 downto 0);
    signal fin_tiempo: std_logic;
    signal parar_temporizador: std_logic;
    
    constant clk_period: time := 8 ns;
    
    begin
    
    uut: temporizador
    port map (
        clk => clk,
        reset => reset,
        speed => speed,
        mode => mode,
        cambia_turno => cambia_turno,
        n_partidas => n_partidas,
        fin_tiempo => fin_tiempo,
        parar_temporizador => parar_temporizador
    );
    
    
    process
    begin
       clk <= '1';
       wait for clk_period/2;
       clk <= '0';
       wait for clk_period/2;        
    end process;
    
    process
    begin
        reset<='1';
        speed<='1';
        mode <= "01";
        parar_temporizador <= '0';
        cambia_turno<='0';
        n_partidas<="000";
        
        wait for clk_period*150000;
        reset <= '0';
        wait for clk_period*150000;
        cambia_turno<='1';
        wait for clk_period;
        cambia_turno<='0';
        wait for clk_period*150000*10;
        cambia_turno<='1';
        wait for clk_period;
        cambia_turno<='0';
        wait for clk_period*150000*2;
        cambia_turno<='1';
        wait for clk_period;
        cambia_turno<='0';
        wait for clk_period*150000*8;  
        n_partidas<="110";
        cambia_turno<='1';
        wait for clk_period;
        cambia_turno<='0';
        wait for clk_period*150000*3;
        wait;  
     end process;
end testbench;    