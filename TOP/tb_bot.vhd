--HE USADO LAS FRECUENCIAS QUE HE PUESTO EN botones.vhd y antirebotes.vhd (low<5us<medio<15us<high // pulsacion validada por antireb >200ns)
--PARA VERLO BIEN EN SIMULACION PONER 150 us en tiempo de simulacion




library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity tb_bot is
end tb_bot;

architecture Behavioral of tb_bot is

component botones is 
           Port (
                   clk: in std_logic;
                   reset: in std_logic;
                   B4: in std_logic;
                   B3: in std_logic;
                   B2: in std_logic;
                   B1: in std_logic;
                   B1_prev: out std_logic;
                   fijar: in std_logic;
                   election: out std_logic_vector (8 downto 0) 
                  );
end component;

  --Inputs
   signal clk : std_logic;
   signal B : std_logic;
   signal B1 : std_logic;
   signal B1_prev : std_logic;
   signal B2 : std_logic;
   signal B3 : std_logic;
   signal B4 : std_logic;
   signal fijar : std_logic;
   signal election: std_logic_vector(8 downto 0);
   signal reset : std_logic;
 	--Outputs
  -- signal result: std_logic_vector(2 downto 0);
   -- Clock period definitions
   constant clk_period : time := 8 ns;

begin
	-- Instantiate the Unit Under Test (UUT)
    uut: botones
            port map(
                    clk=>clk,
                    reset=>reset,
                    B1=>B1,
                    B2 => B2,
                    B3 => B3,
                    B4 => B4,
                    B1_prev => B1_prev,
                    fijar => fijar,
                    election=>election
                     );
   -- Clock process definitions
    clk_process :process
                   begin
                       clk <= '1';
                       wait for clk_period/2;
                       clk <= '0';
                       wait for clk_period/2;
                 end process;
-----------------------------------------------------------------------------------------------------------------------
                    -- Stimulus process
                    stim_proc: process
                    begin        
                       -- hold reset state for 100 ns.
                         reset <= '1';
                         B <= '0';
                         B1 <= '0';
                         B2 <= '0';
                         B3<= '0';
                         B4 <= '0';
                         fijar <= '0';
                         wait for 10 us;
                         reset <= '0';
                         wait for 20 us ;
                      
                         -- Rebotes por ruido(puse 200ns para el antirebotes)
                         B2 <= '1';
                         wait for 100 ns;
                         B2 <= '0';
                         wait for 5 us;
                         B3 <= '1';
                         wait for 100 ns;
                         B3 <= '0';
                         wait for 5 us;
                         B4 <= '1';
                         wait for 100 ns;
                         B4 <= '0';                                                  
                         wait for 10 us;
                       -- Boton valido y low
                         B3 <= '1';
                         wait for 3 us;
                         B3 <= '0';
                         wait for 10 us;
                         --fijar resultado
                         fijar <='1';
                         wait for 5 us;
                         fijar <= '0';
                         wait for 5 us;
                         -- boton valido y medio
                         B2 <= '1';
                         wait for 10 us;
                         B2 <= '0';
                         wait for 10 us;
                         -- boton valido y high
                         B4 <= '1';
                         wait for 20 us;
                         B4 <= '0';
                         wait for 5 us;
                         --fijar resultado
                         fijar<='1';
                         wait for 5 us;
                         fijar <= '0';
                         wait for 10 us;
                       wait;
                         
                    end process;                          
                   

end Behavioral;

