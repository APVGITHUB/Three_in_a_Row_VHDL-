library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity tb_botones is
end tb_botones;

architecture testbench of tb_botones is
    
    component botones
        port (
            clk: in std_logic;
            reset: in std_logic;
            B4: in std_logic;
            B3: in std_logic;
            B2: in std_logic;
            election: out std_logic_vector (8 downto 0)       -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
                        
        );
    end component;
        
        signal clk: std_logic;
        signal reset: std_logic;
        signal B4: std_logic;
        signal B3: std_logic;
        signal B2: std_logic;
        signal election: std_logic_vector (8 downto 0);        -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
 
        
        --declaracion tiempo
        constant clk_period : time := 8 ns;

begin

    --instanciacion componente
    uut: botones
    port map (
        clk => clk,
        reset => reset,
        B4 => B4,
        B3 => B3,
        B2 => B2,
        election => election
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
         B4 <= '0';
         B3 <= '0';
         B2 <= '0';
         wait for clk_period*200;
         reset <= '0';
         wait for clk_period*10;
         B3 <= '1';
         wait for clk_period*10;
         B3 <= '0';
         wait for clk_period*10;
         B2 <= '1';
         wait for clk_period*10;
         B2 <= '0';         
         wait;
    end process;
           
end testbench;
