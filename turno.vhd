library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity turno is
    port (
        clk: in std_logic;
        reset: in std_logic;
        B1: in std_logic;
        B1_prev: in std_logic;
        V1: in std_logic;
        V2: in std_logic;
        E: in std_logic;
        comparar: in std_logic_vector (8 downto 0);
 --       election: in std_logic_vector (8 downto 0);           -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
        turn: out std_logic                                   -- 0 => turno jugador 1        -- 1 => turno jugador 2
   
           
);
end turno;

architecture Behavioral of turno is
    signal turno: std_logic;
    signal lfsr: std_logic_vector (3 downto 0) := "0000";
    signal feedback: std_logic;
    signal fin: std_logic;
    
begin

feedback <= not(lfsr(3) xor lfsr(2)); 
--process(clk,reset)
--begin
--    if reset = '1' then
--        lfsr <= (others => '0');
--    elsif clk'event and clk = '1' then
--        lfsr <= lfsr(2 downto 0) & feedback;
--    end if;
--end process;

lfsr <= lfsr(2 downto 0) & feedback;

--turno inicial
fin <= V1 or V2 or E;
process(clk,reset)
begin
    if reset = '1' then
        turno <= '0';
        --inicio <= '0';
    elsif clk'event and clk = '1' then 
        if fin = '1' then         
            if V1 = '1' then
                turno <= '1';
            elsif V2 = '1' then
                turno <= '0';
            elsif E <= '1' then
                turno <= lfsr(2);
            end if;
        elsif B1 = '0' and B1_prev = '1' and comparar = "000000000" then
            turno <= not(turno);
        end if;
    end if;
end process;

turn <= std_logic(turno);

end Behavioral;
