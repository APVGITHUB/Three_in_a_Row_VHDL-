
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity evaluar is
    port (
        clk: in std_logic;
        reset: in std_logic;
        Tab1: in std_logic_vector (8 downto 0);
        Tab2: in std_logic_vector (8 downto 0);
        turno: in std_logic_vector (1 downto 0);
        B1: in std_logic;
        B1prev: in std_logic;
        V1: out std_logic;      --victoria jugador 1
        V2: out std_logic;      --victoria jugador 2
        E: out std_logic        --empate
    );
end evaluar;

architecture Behavioral of evaluar is
    signal S: std_logic_vector (8 downto 0);
    signal V: std_logic;    --victoria
    signal Tab: std_logic_vector (8 downto 0);
begin

--MUX
with turno select
    S <= Tab1 when "01",
         Tab2 when "10",
         "---------" when others;
         
--empate
Tab <= Tab1 xor Tab2;
E <= '1' when (Tab = "111111111") and V/= '0' else '0';     --todo el tablero completo y nadie gana

--3 en raya
V <= '1' when (S(0)='1' and S(1)='1' and S(2)='1') or 
              (S(3)='1' and S(4)='1' and S(5)='1') or 
              (S(6)='1' and S(7)='1' and S(8)='1') or 
              (S(0)='1' and S(3)='1' and S(6)='1') or 
              (S(1)='1' and S(4)='1' and S(7)='1') or 
              (S(2)='1' and S(5)='1' and S(8)='1') or 
              (S(2)='1' and S(4)='1' and S(6)='1') or 
              (S(0)='1' and S(4)='1' and S(8)='1')
              else '0'; 

--S = "000000111" or   
--              S = "000111000" or
--              S = "111000000" or
--              S = "001001001" or
--              S = "010010010" or
--              S = "100100100" or
--              S = "100010001" or
--              S = "001010100"
--              else '0';

--V1 y V2 tienen que ser un pulso de reloj
V1 <= '1' when (V = '1' and turno = "01" and B1='0' and B1prev ='1' ) else '0';
V2 <= '1' when (V = '1' and turno = "10" and B1='0' and B1prev ='1') else '0';
  
end Behavioral;
