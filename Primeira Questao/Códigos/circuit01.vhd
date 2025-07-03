library IEEE;
use IEEE.std_logic_1164.all;

entity circuit01 is
    port (
        a : in std_logic;
        b : inout std_logic;
        c : inout std_logic;
        d : out std_logic
    );
end entity circuit01;

architecture arch of circuit01 is

    signal b_reg0 : std_logic; -- "Fio" do inverso de a
    signal d0 : std_logic;     -- "Fio" do inverso de c

begin
    
    -- Buffer tri-state que passa o valor de b para c quando a = 1 
    c <= b when a = '1' else 'Z';

    -- Buffer tri-state que passa o valor de c para b quando a = 0 
    b <= c when b_reg0 = '1' else 'Z';

    -- Inversor do valor de c
    d0 <= not c;

    -- REMOVER COMENTARIOS CASO QUEIRA O RTL IGUAL AO VISTO NA QUESTAO, MAS QUE NAO FUNCIONA CONFORME O ENUNCIADO
    -- Mux que define que quando a = 1 o valor de d eh c, quando a = 0 o valor de d eh o not c
    -- mux_01: process(a)
    -- begin
    --     case a is
    --         when '1' =>
    --             d <= c;
    --         when others =>
    --             d <= d0;
    --     end case;
    -- end process mux_01;

    -- Atribui a d o valor invertido de c (COMENTAR CASO QUEIRA O RTL IGUAL AO VISTO NA QUESTAO)
    d <= d0;

    -- Mux que inverte a saida de a para o controle do buffer tristate de b
    mux_02: process(a)
    begin
        case a is
            when '1' =>
                b_reg0 <= '0';
            when others =>
                b_reg0 <= '1';
        end case;
    end process mux_02;

end architecture arch;