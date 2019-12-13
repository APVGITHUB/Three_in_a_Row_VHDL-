
--COMPONENTE UN SOLO BOTÓN
-- Para simularlo, fijarse en las frecuencias de los temporizadores

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;



entity button is
         Port (
                clk: in std_logic;
                reset: in std_logic;
                B: in std_logic; --Boton 
                result: out std_logic_vector(2 downto 0) --vector que almacena el resultado de la columna correspondiente al botón
                );
end button;

architecture Behavioral of button is
 --DECLARACION COMPONENTE ANTIRREBOTES
   component antirebotes is
     port(
         clk : in std_logic;
         reset : in std_logic;
         boton : in std_logic;
         filtrado: out std_logic
     );
    end component;
 --DECLARACION SEÑALES INTERNAS
  
   signal en: std_logic; --SE PONE A UNO CUANDO SE PULSA EL BOTON
   signal valido: std_logic; --SE PONE A UNO CUANDO EL ANTIRREBOTES DA POR VALIDA LA PULSACION
   signal afirm: std_logic;  
   signal en_prev: std_logic;
   signal selector: std_logic_vector(1 downto 0);
   
    --temporizador 1
   constant T1: integer := 625;     --lo he puesto a 5us, en realidad es (125*10**6)/2;  para 0,5 segundos
   signal tmp1: integer range 0 to T1;
   signal ovf1: std_logic;
   
   --temporizador 2
   constant T2: integer := 1875;    --lo he puesto a 15us, en realidad es(125*10**6)*3/2; para 1,5 segundos
   signal tmp2: integer range 0 to T2;
   signal ovf2: std_logic;
  
   

begin
--CONEXIONES ANTIREBOTES Y BOTON
ar: antirebotes
    port map (
        clk  => clk,
        reset => reset,
        boton=>B,
        filtrado => valido
    );

--temporizador 1 (0,5s)
process(clk,reset)
begin  
   if reset = '1' then
       tmp1 <= 0;
   elsif clk'event and clk = '1' then
       if en = '1' then
           if tmp1 = T1-1 then
               tmp1 <= 0;
           else 
               tmp1 <= tmp1 +1;
           end if;
       else 
           tmp1 <= 0;
       end if;
   end if;                         
end process;
ovf1 <= '1' when (tmp1 = T1-1) and en='1' else '0';

--temporizador 2 (1,5s)
process(clk,reset)
begin  
   if reset = '1' then
       tmp2 <= 0;
   elsif clk'event and clk = '1' then
       if en='1' then
           if tmp2 = T2-1 then
               tmp2 <= 0;
           else 
               tmp2 <= tmp2 +1;
           end if;
        else 
           tmp2 <= 0;
       end if;
   end if;                         
end process;
ovf2 <= '1' when (tmp2 = T2-1) and en='1' else '0';


en <= '1' when B='1' else '0';     --enable activado mientras mantenga pulsado el boton

--
process(clk, reset)
    begin
        if reset = '1' then
        en_prev<='0';
        selector<=(others=>'0');
        elsif clk'event and clk = '1' then
          if afirm ='1' then
            if (en = '1' and en_prev='0') then --inicio pulsación y señal validada por antirrebotes
                   en_prev<='1';
                   selector <="01";
                   elsif en ='1' and en_prev='1' then
                    if ovf2 = '1' then --pulsacion mantenida hasta 1.5 sec
                        selector <="11";
                    elsif ovf1 = '1' then --pulsación mantenida hasta 0.5 sec
                        selector <="10";                   
                    end if;
            elsif en = '0' and en_prev = '1' then       --soltar el boton
                   en_prev <= '0';   
          --  else  --no se ha pulsado o ha sido denegada por antirebotes
            --result <="000";
            end if;
        end if; 
      end if;
end process;
--ASIGNAR PULSACIÓN AFIRMATIVA A afirm
process(clk,reset)
    begin 
        if reset = '1' then
        afirm<='0';
        --en_prev<='0';
        elsif clk'event and clk='1' then
               if valido = '1' then
                    afirm <= valido;
               elsif en = '0' then
                    afirm <= '0';
                end if;
        end if;
end process;

with selector select
         result<= "001" when "01",
                  "010" when "10",
                  "100" when "11",
                  "000" when others;

end Behavioral;
