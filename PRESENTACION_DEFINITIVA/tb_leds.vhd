library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_leds is
end tb_leds;

architecture testbench of tb_leds is
    --declaracion de leds
    component luces is
        port (
            clk: in std_logic;
            reset: in std_logic;
            partidas1: in std_logic_vector (3 downto 0);
            partidas2: in std_logic_vector (3 downto 0);
            leds: out std_logic_vector (7 downto 0)
        );
    end component;
    
    --declaracion señales internas
       signal clk: std_logic;
       signal reset: std_logic;
       signal partidas1: std_logic_vector (3 downto 0);
       signal partidas2: std_logic_vector (3 downto 0);
       signal leds: std_logic_vector (7 downto 0);
       
       --declaracion de tiempo
       constant clk_period : time := 8 ns;

begin

    --instanciacion del componente
    uut: luces
    port map (
        clk => clk,
        reset => reset,
        partidas1 => partidas1,
        partidas2 => partidas2,
        leds => leds
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
           partidas1 <= "0000";
           partidas2 <= "0000";
           wait for clk_period*200;
           reset <= '0';
           wait for clk_period*10;
           partidas1 <= "0001";
           wait for clk_period*10;
           partidas2 <= "0001";
           wait for clk_period*10;
           partidas1 <= "0010";
           wait for clk_period*10;
           partidas2 <= "0010";
           wait for clk_period*10;
           partidas1 <= "0011";
           wait for clk_period*10;
           partidas1 <= "0101";
           wait;
        end process;

end testbench;
