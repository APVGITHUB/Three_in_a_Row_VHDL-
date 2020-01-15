library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_turno is
end tb_turno;

architecture Behavioral of tb_turno is
    
    component validar is
        port(
            clk: in std_logic;
            reset: in std_logic;
            mode: in std_logic_vector (1 downto 0);
            B1: in std_logic;
            B1_prev: in std_logic;
            V1: in std_logic;
            V2: in std_logic;
            E: in std_logic;
            reset_election: in std_logic;  
            turn: out std_logic_vector( 1 downto 0);
            fail: in std_logic;
            fijar: out std_logic        
        );
    end component;
    
     signal clk: std_logic;
     signal reset: std_logic;
     signal mode:  std_logic_vector (1 downto 0);
     signal B1: std_logic;
     signal B1_prev: std_logic;
     signal V1: std_logic;
     signal V2: std_logic;
     signal E: std_logic;
     signal reset_election: std_logic;  
     signal turn: std_logic_vector( 1 downto 0);
     signal fail: std_logic;
     signal fijar: std_logic;
     
     --declaracion tiempo
     constant clk_period : time := 8 ns;
            
begin

    --instanciacion componente
    uut: validar
    port map (
        clk => clk,
        reset => reset,
        mode => mode,
        B1 => B1,
        B1_prev => B1_prev,
        V1 => V1,
        V2 => V2,
        E => E,
        reset_election => reset_election,
        turn => turn,
        fail => fail,
        fijar => fijar
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
           B1_prev <= '0';
           V1 <= '0';
           V2 <= '0';
           E <= '0';
           reset_election <= '0';
           fail <= '0';
           wait for clk_period*200;
           reset <= '0';
           wait for clk_period*10;
           reset_election <= '1';
           wait for clk_period*10;
           B1 <= '1';
           reset_election <= '0';
           wait for clk_period;
           B1_prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           wait for clk_period;
           B1_prev <= '0';
           wait for clk_period*10;
           reset_election <= '1';
           wait for clk_period*10;
           B1 <= '1';
           reset_election <= '0';
           wait for clk_period;
           B1_prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           wait for clk_period;
           B1_prev <= '0';
           wait for clk_period*10;
           reset_election <= '1';
           wait for clk_period*10;
           B1 <= '1';
           reset_election <= '0';
           wait for clk_period;
           B1_prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           wait for clk_period;
           V1 <= '1';
           B1_prev <= '0';
           wait;
        end process;           

end Behavioral;
