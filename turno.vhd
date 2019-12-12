library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_turno is
end tb_turno;

architecture Behavioral of tb_turno is
    
    component turno is
        port(
            clk: in std_logic;
            reset: in std_logic;
            B1: in std_logic;
            B1_prev: in std_logic;
            comparar: in std_logic_vector (8 downto 0);
            V1: in std_logic;
            V2: in std_logic;
            E: in std_logic;
        --    election: in std_logic_vector (8 downto 0);  
            turn: out std_logic       
        );
    end component;
    
     signal clk: std_logic;
     signal reset: std_logic;
     signal B1: std_logic;
     signal B1_prev: std_logic;
     signal comparar: std_logic_vector (8 downto 0);
     signal V1: std_logic;
     signal V2: std_logic;
     signal E: std_logic;
   --  signal election: std_logic_vector (8 downto 0);  
     signal turn: std_logic;
     
     --declaracion tiempo
     constant clk_period : time := 8 ns;
            
begin

    --instanciacion componente
    uut: turno
    port map (
        clk => clk,
        reset => reset,
        B1 => B1,
        B1_prev => B1_prev,
        comparar => comparar,
        V1 => V1,
        V2 => V2,
        E => E,
  --      election => election,
        turn => turn
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
           comparar <= (others => '0');
           V1 <= '0';
           V2 <= '0';
           E <= '0';
        --   election <= (others => '0');
           wait for clk_period*200;
           reset <= '0';
           wait for clk_period*10;
      --     election <= "000000001";
           wait for clk_period*10;
           B1 <= '1';
           wait for clk_period;
           B1_prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           wait for clk_period;
           B1_prev <= '0';
           wait for clk_period*10;
    --       election <= "000000010";
           wait for clk_period*10;
           B1 <= '1';
           wait for clk_period;
           B1_prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           wait for clk_period;
           B1_prev <= '0';
           wait for clk_period*10;
     --      election <= "000000100";
           wait for clk_period*10;
           B1 <= '1';
           wait for clk_period;
           B1_prev <= '1';
           wait for clk_period*10;
           B1 <= '0';
           V1 <= '1';
           wait for clk_period;
           B1_prev <= '0';
           wait;
        end process;           

end Behavioral;
