library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity integer_counter is
    port (
        clk : in std_logic;
        rst : in std_logic;
        output : out integer range -128 to 127 -- Output definido como inteiro de -128 ate 127
    );
end entity integer_counter;

architecture behavior of integer_counter is
    
    -- Sinal de contagem do contador que vai para a saida
    signal cnt : integer range -128 to 127;

begin
    
    -- Definicao do contador
    counter: process(clk, rst) -- Lista sensitiva com o clk e o rst
    begin
        if rst = '1' then -- Se reset entao cnt(saida) recebe o menor valor (-128)
            cnt <= -128;
        elsif rising_edge(clk) then -- Se borda de subida do clock incrementa a contagem ou volta para o menor valor caso chegue no maior valor
            if cnt >= 127 then
                cnt <= -128;
            else
                cnt <= cnt + 1;
            end if;
        end if;
    end process counter;
    
    -- Atribui a contagem a saida
    output <= cnt;

end architecture behavior;