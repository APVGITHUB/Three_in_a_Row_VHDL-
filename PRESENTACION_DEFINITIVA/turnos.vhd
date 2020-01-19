library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity turnos is
    port (
        clk: in std_logic;
        reset: in std_logic;
        mode: in std_logic_vector (1 downto 0);
        V1: in std_logic;
        E: in std_logic;
        reset_election: in std_logic;           
        turn: out std_logic;
        fail: in std_logic;                 
        fijar: out std_logic
           
);
end turnos;

architecture Behavioral of turnos is
    signal turno: std_logic;
    signal ya_cambiado: std_logic; 
    signal lfsr: std_logic_vector (3 downto 0):= "0000";
    signal feedback: std_logic;
    signal start: std_logic;
    
begin

--generación de un número aleatorio que no depende de reset
feedback <= not(lfsr(3) xor lfsr(2)); 
process(clk)
begin
    if clk'event and clk = '1' then
        lfsr <= lfsr(2 downto 0) & feedback;
    end if;
end process;


--seleccion del turno
process(clk,reset)
begin
    if reset = '1' then
        turno <= '0';
        ya_cambiado <= '0';
        fijar <= '0';
        start <= '0';
    elsif clk'event and clk = '1' then
        --inicialmente el turno es aleatorio
        if start = '0' then
            turno <= lfsr(2);
            start <= '1';
        end if;  
       -- si hy empate también es aleatorio          
       if E = '1' then 
            turno <= lfsr(2);
        end if;
        --turno cambia al final de cada movimiento una vez, si no ha habido error al colocar la ficha. Además, en el modo máquina cada vez que le toca al jugador 2.
        if (ya_cambiado = '0' and fail = '0' and reset_election ='1') or (mode = "10" and turno = '1' and V1 = '0') then 
            turno <= not(turno);
            fijar <= '1';
            ya_cambiado <= '1';
        else
            ya_cambiado <= '0';
            fijar <= '0';           
        end if;        
    end if;
end process;

turn <= turno;

end Behavioral;
