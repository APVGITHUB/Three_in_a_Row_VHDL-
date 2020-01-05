library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity antirebotes is
    port(
        clk : in std_logic;
        reset : in std_logic;
        speed: in std_logic;
        boton : in std_logic;
        filtrado: out std_logic
    );
end antirebotes;
        
architecture behavioral of antirebotes is
    
    --Sincronizador
    signal Q2 : std_logic;
    signal Q1 : std_logic;
    
    --Detector de flancos
    signal flanco : std_logic;
    signal Q3 : std_logic;
    
    --Declaracion de FSM explicita
    type state_t is (S_NADA, S_BOTON);
    signal state : state_t;
    
    --Temporizador
    signal E : std_logic;
    signal T : std_logic;
    
    signal divider: integer range 1 to 1000;
    constant CONT : integer:=125*10**5; --Supongo un pulso valido a partir de 0'1s
    signal cuenta : integer range 0 to CONT-1;
    
    
begin
    
    --Sincronizador
    process(clk,reset)
    begin
        if reset = '1' then
            Q1 <= '0';
            Q2 <= '0';
        elsif clk'event and clk = '1' then
            Q1 <= boton;
            Q2 <= Q1;
        end if;       
    end process;
        
    --Detector de flancos
    process(clk,reset)
    begin
        if reset = '1' then
            Q3 <= '0';
        elsif clk'event and clk = '1' then
            Q3 <= Q2;
        end if;
    end process;
    
    flanco <= '1' when Q2 = '1' and Q3 = '0' else '0';
    
    --divisor de frecuencias para la simulacion
    divider <= 1000 when speed = '1' else 1;
    --Implementacion del temporizador
    process(clk,reset)
    begin
       if reset = '1' then
            cuenta <= 0;
       elsif clk'event and clk = '1' then
            if E = '1' then
                 if cuenta = CONT/divider-1 then
                    cuenta <= 0;
                 else
                  cuenta <= cuenta+1;
                 end if;
            end if;
       end if;   
    end process;
    
    T <= '1' when cuenta=CONT/divider-1 and E = '1' else '0';  
    
    
    --Implementación de FSM explícita
    process(clk,reset)
    begin
        if reset = '1' then
            state <= S_NADA;
        elsif clk'event and clk = '1' then
        --ecc de estado como logica secuencial dentro del proceso
            case state is
                when S_NADA =>
                    if flanco = '1' then
                        state <= S_BOTON;
                    end if;
                    
                when S_BOTON =>
                    if T ='1' then
                        state <= S_NADA;
                    end if;
            end case;
        end if;
    end process;

    --ecc de salida como logica combinacional fuera del proceso
    filtrado <= '1' when state = S_BOTON and Q2 = '1' and T = '1' else '0'; --Mealy
    E <= '1' when state = S_BOTON else '0'; --Moore

end behavioral;
