library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_evaluar is
end tb_evaluar;

architecture testbench of tb_evaluar is
    component evaluar is
        port (
            clk: in std_logic;
            reset: in std_logic;
            Tab1: in std_logic_vector (8 downto 0);
            Tab2: in std_logic_vector (8 downto 0);
            turno: in std_logic_vector (1 downto 0);
            B1: in std_logic;
            B1prev: in std_logic;
            V1: out std_logic;      --victoria jugador 1
            V2: out std_logic;      --victoria jugador 2
            E: out std_logic        --empate
        );
    end component;
    
     signal clk: std_logic;
     signal reset: std_logic;
     signal Tab1: std_logic_vector (8 downto 0);
     signal Tab2: std_logic_vector (8 downto 0);
     signal turno: std_logic_vector (1 downto 0);
     signal B1: std_logic;
     signal B1prev: std_logic;
     signal V1: std_logic;      --victoria jugador 1
     signal V2: std_logic;      --victoria jugador 2
     signal E: std_logic;        --empate
    
    --declaracion tiempo
    constant clk_period : time := 8 ns;
    
begin

    --instanciacion componente
    uut: evaluar
    port map (
        clk => clk,
        reset => reset,
        Tab1 => Tab1,
        Tab2 => Tab2,
        turno => turno,
        B1 => B1,
        B1prev => B1prev,
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
           Tab1 <= (others => '0');
           Tab2 <= (others => '0');
           turno <= (others => '0');
           B1 <= '0';
           B1prev <= '0';
           wait for clk_period*200;
           reset <= '0';
           turno <= "10";
           wait for clk_period*10;
           B1 <= '1';
           wait for clk_period;
           Tab1 <= "110000010";
           Tab2 <= "000100000";
           B1prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           wait for clk_period;
           B1prev <= '0';
           turno <= "01";
           wait for clk_period*10;
           --segundo turno
           B1 <= '1';
           wait for clk_period;
           Tab1 <= "111000010";
           Tab2 <= "000100000";
           B1prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           wait for clk_period;
           B1prev <= '0';
           turno <= "10";
           wait;
       end process;

end testbench;
