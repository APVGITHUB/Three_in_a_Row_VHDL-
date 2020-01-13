library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity luces is
    port (
        clk: in std_logic;
        reset: in std_logic;
        partidas1: in std_logic_vector (3 downto 0);
        partidas2: in std_logic_vector (3 downto 0);
        leds: out std_logic_vector (7 downto 0)
    );
end luces;

architecture Behavioral of luces is
    signal up: std_logic_vector (7 downto 0);
    signal down: std_logic_vector (7 downto 0);
  
begin

--decodificador P1
with partidas1 select
    up <= "00000000" when "0000",    --0
          "10000000" when "0001",    --1
          "11000000" when "0010",    --2
          "11100000" when "0011",    --3
          "11110000" when "0100",    --4
          "11111000" when "0101",    --5
          "--------" when others;

--decodificador P2
with partidas2 select
    down <= "00000000" when "0000",  --0
            "00000001" when "0001",  --1
            "00000011" when "0010",  --2
            "00000111" when "0011",  --3
            "00001111" when "0100",  --4
            "00011111" when "0101",  --5
            "--------" when others;
           
leds <= up or down ;



end Behavioral;
