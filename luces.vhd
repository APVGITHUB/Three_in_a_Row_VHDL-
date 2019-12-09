library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity luces is
    port (
        clk: in std_logic;
        reset: in std_logic;
        partidas1: in std_logic_vector (2 downto 0);
        partidas2: in std_logic_vector (2 downto 0);
        leds: out std_logic_vector (7 downto 0)
    );
end luces;

architecture Behavioral of luces is
    signal up: std_logic_vector (4 downto 0);
    signal down: std_logic_vector (4 downto 0);
    signal aux: std_logic_vector (2 downto 0) := "000";
  
begin

--decodificador P1
with partidas1 select
    up <= "00000" when "000",    --0
          "10000" when "001",    --1
          "11000" when "010",    --2
          "11100" when "011",    --3
          "11110" when "100",    --4
          "11111" when "101",    --5
          "-----" when others;

--decodificador P2
with partidas2 select
    down <= "00000" when "000",  --0
            "00001" when "001",  --1
            "00011" when "010",  --2
            "00111" when "011",  --3
            "01111" when "100",  --4
            "11111" when "101",  --5
            "-----" when others;
           
leds <= (up & aux) xor (aux & down) ;



end Behavioral;
