library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity Displays is
  Port (
        clk: in std_logic;
        reset: in std_logic;
        speed: in std_logic;
        selector: out std_logic_vector (3 downto 0);
        segmentos: out std_logic_vector (7 downto 0);
        election: in std_logic_vector (8 downto 0);        -- eleccion => mantener parpadeo simepre (se pone a cero al comienzo de cada turno)
        Tablero1: in std_logic_vector (8 downto 0);            -- Tablero jugador 1 => mantenerlo encendido siempre (se va actualizando solo)
        Tablero2: in std_logic_vector (8 downto 0);            -- Tablero jugador 2 => mantenerlo encendido siempre (se va actualizando solo)
        turn: in std_logic;           -- 01 => turno jugador 1        -- 10 => turno jugador 2
        fail: in std_logic;
        
        V1: in std_logic;      --victoria jugador 1
        V2: in std_logic;      --victoria jugador 2
        E: in std_logic;
        gana1: in std_logic;
        gana2: in std_logic);
           
end Displays;

architecture Behavioral of Displays is
    signal finjuego: std_logic;
    signal count_temp5s: integer range 0 to 24;
    signal temp5s: std_logic;
    signal V15s: std_logic;
    signal V25s: std_logic;
    signal E5s: std_logic;
    
    signal divider: integer range 1 to 1000;
    constant MaxDFSel: integer := 125000/5; -- Div.Freq 5kHz  
    signal count_DFSel: integer range 0 to MaxDFSel-1;
    signal DFSel: std_logic;
    signal sel: integer range 0 to 3;
    ---------------------------------------------------------------------
    constant MaxDFTab: integer := 125000/500; --Div.Freq 500 kHz
    constant MaxTab: integer := 15;
    signal count_DFTab: integer range 0 to MaxDFTab-1;
    signal DFTab: std_logic;
    signal tab: integer range 0 to MaxTab;
    -------------------------------------------------------------------
    -- Divisor de Frecuencia que se usa para el selector de displays cuando hay que mostrar 1,2 o  = durante 5 segs
    constant MaxDF5: integer := 125000000/5; --Div.Freq 5 Hz
    signal count_DF5: integer range 0 to MaxDF5-1;
    signal DF5: std_logic;
    signal countsel5: integer range 0 to 3;
    --------------------------------------------------------
    signal tablero: std_logic_vector (8 downto 0);
    signal col_tablero: std_logic_vector (2 downto 0); --División de tablero en la parte correspondiente a cada display
   
    signal sel_election: integer range 0 to 3; -- Registra en que display se tiene que controlar el parpadeo/fail del segmento elegido para colocar la ficha
    
    signal selector_partida: std_logic_vector(3 downto 0);
    signal selector_5s: std_logic_vector(3 downto 0);
    
    signal segmentos_tablero: std_logic_vector(7 downto 0);
    signal segmentos_turn: std_logic_vector(7 downto 0);
    signal segmentos_partida: std_logic_vector(7 downto 0);
    signal segmentos_election: std_logic_vector(7 downto 0); --Registra como se debe representar en el display de 7seg el segmento elegido para colocar la ficha
    signal segmentos_electioncmp: std_logic_vector(7 downto 0);

        
begin
--divisor de frecuencia para la simulacion
divider <= 1000 when speed = '1' else 1;
-------------------------------------------------------------------------------
DivFreqSel: process(clk, reset) -- 5 kHz
    begin
        if reset = '1' then
            count_DFSel <= 0;
        elsif (clk' event and clk = '1') then
            if count_DFSel = MaxDFSel/divider-1 then
                count_DFSel <= 0;
            else
                count_DFSel <= count_DFSel + 1;
            end if;
        end if;
    end process;
    
 DFSel <= '1' when count_DFSel = MaxDFSel/divider-1 else '0';
 
PermSelector:process(clk, reset) -- Permuta a 0,1,2,3 el contador sel que controla (multiplexa) el selector de displays
     begin
         if reset = '1' then
             sel <= 0;
         elsif (clk' event and clk = '1') then
             if DFSel = '1' then
                 if sel = 3 then
                     sel <= 0;
                 else
                     sel <= sel + 1;
                 end if;
             end if;
         end if;
     end process;
----------------------------------------------------------------------------------------------------    
DivFreqTab: process(clk, reset)
    begin
      if reset = '1' then
        count_DFTab <= 1;
      elsif (clk' event and clk = '1') then
        if DFSel = '1' then
           count_DFTab <= 0;
        else
         if count_DFTab = MaxDFTab/divider-1 then
           count_DFTab <= 0;
         else
           count_DFTab <= count_DFTab + 1;
         end if;
        end if;
      end if;
     end process;
     
DFTab <= '1' when count_DFTab = 0  else '0';     
    
PermTab:process(clk, reset) -- permuta el tablero que se debe mostrar entre el tablero1 y el tablero2
   begin
     if reset = '1' then
        tab <= 0;
     elsif (clk' event and clk = '1') then
        if DFTab = '1' then
            if tab = MaxTab then
               tab <= 0;
            else
               tab <= tab + 1;
            end if;
        end if;
      end if;
    end process; 

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
DivFreq5Hz: process(reset, clk) -- 5Hz : Se utiliza para el parpadeo del segmento seleccionado en el modo tablero; y para el selector de displays en el modo Resultado (5s)
begin
    if reset='1' then
        count_DF5 <= 0;
    elsif (clk' event and clk='1') then
        if count_DF5 = MaxDF5/divider-1 then
            count_DF5 <= 0;
        else
            count_DF5 <= count_DF5 +1;
        end if;
    end if;
 end process;
 
 DF5 <= '1' when count_DF5 = MaxDF5/divider-1 else '0';
 
 PermSelector5Hz: process(reset, clk)
 begin
    if reset='1' then 
        countsel5 <= 0;
        segmentos_electioncmp <= "00000000";--ORIGINALMENTE TODO UNOS, PERO CREO QUE DEBE SER CON CEROS
    elsif (clk' event and clk='1') then
        if DF5='1' then
            if countsel5 = 3 then -- Permuta el valor del selector de displays para el modo resultado (1,2,= durante 5s)
                countsel5 <= 0;
            else 
                countsel5 <= countsel5 + 1;
            end if;
            
            if segmentos_electioncmp = "00000000" then -- Permuta el valor de una señal de comparacion para hacer parpadear solo el segmento de election en el modo tablero
                segmentos_electioncmp <= (segmentos_election);
            else
                segmentos_electioncmp <= "00000000";
            end if;
            
        end if;
    end if;
  end process;
--------------------------------------------- 
ContadorFinPartida5s: process(clk, reset)
begin
    if reset = '1' then
        count_temp5s <= 0;
        temp5s <= '0';
        finjuego <= '0';
        V15s <= '0';
        V25s <= '0';
        E5s <= '0';
    elsif (clk' event and clk = '1') then
        if (V1='1' or V2='1' or E='1' or temp5s='1') then
        
          if V1='1' then
            V15s <='1';
            temp5s <='1';
          elsif V2='1' then
            V25s <='1';
            temp5s <='1';
          elsif E='1' then
            E5s <='1';
            temp5s <='1';
          end if;
          
          if DF5='1' then
            if count_temp5s = 24 then
                count_temp5s <= 0;
                temp5s <= '0';
                V15s <= '0';
                V25s <= '0';
                E5s <= '0';
                if (gana1='1' or gana2='1') then
                    finjuego <= '1';
                end if;
            else
                count_temp5s <= count_temp5s +1;
                temp5s <='1';
            end if;
           end if;
        end if;
    end if;
end process;
---------------------------------------------------------------------------------------        
with sel select     
selector_partida <= "0001" when 0,  
                    "0010" when 1,
                    "0100" when 2,
                    "1000" when 3;

with countsel5 select     
selector_5s <= "0001" when 0,  
               "0010" when 1,
               "0100" when 2,
               "1000" when 3;
               
with tab select
tablero <=  (Tablero2 or tablero1) when 0,
            (Tablero2 or tablero1) when 1,
            (Tablero2 or tablero1) when 2,
            (Tablero2 or tablero1) when 3,
            Tablero1 when others;

with sel select         
col_tablero <=  tablero(8 downto 6) when 1, 
                tablero(5 downto 3) when 2, 
                tablero(2 downto 0) when 3, 
                "---" when others;
                
with col_tablero select 
    segmentos_tablero <= "10010010" when "111",
                         "10000000" when "100",
                         "10010000" when "110",
                         "00010000" when "010",
                         "00010010" when "011",
                         "00000010" when "001",
                         "10000010" when "101",
                         "00000000" when "000",
                         "00000000" when others;
                         
with turn select
    segmentos_turn <= "01100000" when '0',
                      "11011010" when '1',
                      "00000000" when others;
                      
with sel select
    segmentos_partida <= segmentos_tablero when 1,
                         segmentos_tablero when 2,
                         segmentos_tablero when 3,
                         segmentos_turn when 0;
                         

with election select
    sel_election <= 3 when "000000001",
                    3 when "000000010",
                    3 when "000000100",
                    2 when "000001000",
                    2 when "000010000",
                    2 when "000100000",
                    1 when "001000000",
                    1 when "010000000",
                    1 when "100000000",
                    0 when others;

with election select
    segmentos_election <= "01111111" when "000000100",
                          "01111111" when "000100000",
                          "01111111" when "100000000",
                          "11101111" when "000000010",
                          "11101111" when "000010000",
                          "11101111" when "010000000",
                          "11111101" when "000000001",
                          "11111101" when "000001000",
                          "11111101" when "001000000",
                          "11111111" when others;
                    
segmentos <= "10011111" when (finjuego='1' and gana1='1')else
             "00100101" when (finjuego='1' and gana2='1')else
             "10011111" when (temp5s='1' and V15s='1')else
             "00100101" when (temp5s='1' and V25s='1')else
             "01111101" when (temp5s='1' and E5s='1')else
             "00000001" when (fail='1' and sel_election=sel) else
             --ABAJO EL OR ERA UN AND, PERO NO FUNCIONABA
             (segmentos_partida or segmentos_electioncmp) when (election/="000000000" and sel_election=sel) else
             segmentos_partida;
             
selector <= selector_5s when temp5s='1' else
            selector_partida;

end Behavioral;
