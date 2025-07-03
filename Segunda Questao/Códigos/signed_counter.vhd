library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity signed_counter is
    port (
        clk : in std_logic;
        rst : in std_logic;
        output : out signed(7 downto 0) -- Output definido como inteiro com sinal
    );
end entity signed_counter;

architecture behavior of signed_counter is
    
    -- Sinal de contagem do contador que vai para a saida
    signal cnt : signed(7 downto 0);

begin
    
    -- Definicao do contador
    counter: process(clk, rst) -- Lista sensitiva com o clk e o rst
    begin
        if rst = '1' then -- Se reset entao cnt(saida) recebe o menor valor (10000000)
            cnt <= (7 => '1', others => '0');
        elsif rising_edge(clk) then -- Se borda de subida do clock incrementa a contagem
            cnt <= cnt + 1;
        end if;
    end process counter;
    
    -- Atribui a contagem a saida
    output <= cnt;

end architecture behavior;