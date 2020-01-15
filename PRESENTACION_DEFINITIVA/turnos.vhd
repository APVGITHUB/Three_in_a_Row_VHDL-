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
    elsif clk'event and clk = '1' then                 
       if E = '1' then 
            turno <= lfsr(2);
        end if;
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
