library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.custom_types.all; -- Biblioteca para o tipo integer_array "type integer_array is array (natural range <>) of integer;"

entity circuit01 is
    port (
        clk : in std_logic;
        rst : in std_logic;
        inputs : in integer_array (7 downto 0);
        outputs : out integer_array (3 downto 0)
    );
end entity circuit01;

architecture version_A of circuit01 is -- Versao paralela

    signal result_reg : integer_array (3 downto 0); -- Array de inteiros para o "fio" que vai para o registrador

begin

    -- Realiza as multiplicacoes
    result_reg(0) <= inputs(0) * inputs(4);
    result_reg(1) <= inputs(1) * inputs(5);
    result_reg(2) <= inputs(2) * inputs(6);
    result_reg(3) <= inputs(3) * inputs(7);

    -- Registrador para atualizar a saida com base no clock
    sync_reg: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then -- Definicao do reset
                outputs(0) <= 0;
                outputs(1) <= 0;
                outputs(2) <= 0;
                outputs(3) <= 0;                
            else -- Joga os valores nas saidas
                outputs(0) <= result_reg(0);
                outputs(1) <= result_reg(1);
                outputs(2) <= result_reg(2);
                outputs(3) <= result_reg(3);
            end if;
        end if;
    end process sync_reg;
    
end architecture version_A;

architecture version_B of circuit01 is -- Versao sequencial (Fiz de forma a ter apenas um multiplicador fisico)
    
    type states is (first,second,third,fourth); -- Definicao dos estados
    signal current_state : states; -- estado atual da maquina de estados
    signal first_value, second_value, mult_result : integer; -- sinais intermediarios para fazer a multiplicacao em amenas um multiplicador fisico
    signal result_reg : integer_array (3 downto 0); -- Array de inteiros como registradores de saida

begin

    -- Processo combinacional para selecionar quais valores serao multiplicados de acordo com o estado atual
    sel_mult: process(current_state, inputs)
    begin
        case (current_state) is
            when first => -- Seleciona os valores da primeira multiplicacao (0 e 4)
                first_value <= inputs(0);
                second_value <= inputs(4);
            when second => -- Seleciona os valores da segunda multiplicacao (1 e 5)
                first_value <= inputs(1);
                second_value <= inputs(5);
            when third => -- Seleciona os valores da terceira multiplicacao (2 e 6)
                first_value <= inputs(2);
                second_value <= inputs(6);
            when others => -- Seleciona os valores da quarta multiplicacao (3 e 7)
                first_value <= inputs(3);
                second_value <= inputs(7);
        end case;
    end process sel_mult;

    -- Multiplica os valores escolhidos (Dessa forma, tera apenas um multiplicador fisico)
    mult_result <= first_value * second_value;

    -- Processo sincrono que registra os resultados das multiplicacoes e atualiza o estado atual
    sync_proc: process(clk)
    begin
        if rising_edge(clk) then
            if rst = '1' then -- Reset sincrono
                current_state <= first; -- Reseta o estado para o inicial
                result_reg <= (others => 0); -- Atribui 0 aos registradores de saida
            else
                case (current_state) is
                    when first => -- Registra o primeiro resultado e passa para o proximo estado
                        result_reg(0) <= mult_result;
                        current_state <= second;
                    when second => -- Registra o segundo resultado e passa para o proximo estado
                        result_reg(1) <= mult_result;
                        current_state <= third;
                    when third => -- Registra o terceiro resultado e passa para o proximo estado
                        result_reg(2) <= mult_result;
                        current_state <= fourth;
                    when others => -- Registra o quarto resultado e passa para o proximo estado
                        result_reg(3) <= mult_result;
                        current_state <= first;
                end case;
            end if;
        end if;
    end process sync_proc;

    -- Atribui o resultado das multiplicacoes na saida
    outputs(0) <= result_reg(0);
    outputs(1) <= result_reg(1);
    outputs(2) <= result_reg(2);
    outputs(3) <= result_reg(3);

end architecture version_B;