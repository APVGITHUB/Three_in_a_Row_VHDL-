library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temporizador is
    port (
        clk: in std_logic;
        reset: in std_logic;
        speed: in std_logic;
        mode: in std_logic_vector (1 downto 0);
        cambia_turno: in std_logic;
        n_partidas: in std_logic_vector (2 downto 0);
        fin_tiempo: out std_logic           
    );
end temporizador;

architecture Behavioral of temporizador is

    signal limite: integer range 0 to 10;
    signal contador: integer range 0 to 10;
    
    signal divider: integer range 1 to 1000;
    constant MaxDF: integer := 125*10**6;  
    signal count_DF: integer range 0 to MaxDF-1;
    signal DF: std_logic;
    
    begin
    
    DivFreq: process(clk, reset)
        begin
            if reset = '1' then
                count_DF <= 0;
            elsif (clk' event and clk = '1') then
                if cambia_turno = '1' then
                    count_DF <= 0;
                elsif count_DF = MaxDF/divider-1 then
                    count_DF <= 0;
                else
                    count_DF <= count_DF + 1;
                end if;
            end if;
        end process;
    
    divider <= 1000 when speed = '1' else 1;
    DF <= '1' when count_DF = MaxDF/divider-1 else '0';
 
    with n_partidas select
        limite <= 10 when "000",
                  9 when "001",
                  8 when "010",
                  7 when "011",
                  6 when "100",
                  5 when "101",
                  4 when "110",
                  3 when "111",
                  10 when others;
                  
    process(clk, reset)
    begin
        if reset = '1' then
            contador <= 0;          
        elsif (clk'event and clk = '1') then
            if (cambia_turno = '1' or contador = limite) then
                contador <= 0;
            elsif DF = '1' then
                contador <= contador + 1;
            end if;           
        end if;
    end process;
    
    fin_tiempo <= '1' when contador=limite and mode = "01" else '0';
            
 
 end behavioral;