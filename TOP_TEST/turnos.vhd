library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity turnos is
    port (
        clk: in std_logic;
        reset: in std_logic;
        B1: in std_logic;
        B1_prev: in std_logic;
        V1: in std_logic;
        V2: in std_logic;
        E: in std_logic;
        election: in std_logic_vector (8 downto 0);           -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
        turn: out std_logic;
        fail: in std_logic;  -- fail necesario para no actualizar turno con error                                   -- 0 => turno jugador 1        -- 1 => turno jugador 2
        fijar: out std_logic
           
);
end turnos;

architecture Behavioral of turnos is
    signal turno: std_logic;
    signal ya_cambiado: std_logic; --PARA NO CAMBIAR EL TURNO REPETIDAMENTE
    signal lfsr: std_logic_vector (3 downto 0);
    signal feedback: std_logic;
    
begin

feedback <= not(lfsr(3) xor lfsr(2)); 
process(clk,reset)
begin
    if reset = '1' then
        lfsr <= (others => '0');
    elsif clk'event and clk = '1' then
        lfsr <= lfsr(2 downto 0) & feedback;
    end if;
end process;


--turno inicial
process(clk,reset)
begin
    if reset = '1' then
        turno <= '0';
        ya_cambiado <= '0';
        fijar <= '0';
        --inicio <= '0';
    elsif clk'event and clk = '1' then          
        --if V1 = '1' then --CREO QUE ESTO NO HACE FALTA: EL TURNO YA SE CAMBIA CUANDO SE SUELTA EL BOTON Y CON ESTO LO CAMBIAS DOS VECES
            --turno <= '1';
        --elsif V2 = '1' then
            --turno <= '0';
       if E = '1' then    --ESTO SI FUNCIONA SI QUE ES NECESARIO
            turno <= lfsr(2);
        end if;
        if B1 = '0' and B1_prev = '1' and ya_cambiado = '0' and fail = '0' and election /="000000000" then --TURNO SE CAMBIA AL SOLTAR EL BOTON (QUIZAS CONVIENE USAR B1val POR LOS REBOTES)
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
