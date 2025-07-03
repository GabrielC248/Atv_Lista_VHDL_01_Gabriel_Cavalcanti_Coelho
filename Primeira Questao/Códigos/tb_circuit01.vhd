library IEEE;
use IEEE.std_logic_1164.all;

entity tb_circuit01 is
end entity tb_circuit01;

architecture testbench of tb_circuit01 is

    -- Sinais do testbench
    signal a_tb, b_tb, c_tb, d_tb : std_logic;

    -- Declara o circuito da questao
    component circuit01 is
        port (
            a : in std_logic;
            b : inout std_logic;
            c : inout std_logic;
            d : out std_logic
        );
    end component circuit01;

begin
    
    -- Instancia o circuito da questao
    uut : circuit01
        port map (
            a => a_tb,
            b => b_tb,
            c => c_tb,
            d => d_tb
        );

    -- Sequencia de estimulos para testar o circuito da questao
    stimulus: process
    begin
        -- Inicializa o teste com todos os sinais como 0
        a_tb <= '0';
        b_tb <= '0';
        c_tb <= '0';
        wait for 10 ps;

        -- Teste para verificar se o valor de b esta sendo passado para c quando a = 1
        a_tb <= '1'; -- Sinal de controle
        b_tb <= '1'; -- Sinal "ativo"
        c_tb <= 'Z'; -- Alta impedancia em c para receber o valor de b
        wait for 10 ps;
        b_tb <= '0';
        wait for 10 ps;
        b_tb <= '1';
        wait for 10 ps;
        b_tb <= '0';
        wait for 10 ps;

        -- Pausa para facilitar a visualizacao no waveform
        wait for 20 ps;

        -- Teste para verificar se o valor de c esta sendo passado para b quando a = 0
        a_tb <= '0'; -- Sinal de controle
        b_tb <= 'Z'; -- Alta impedancia em b para receber o valor de c
        c_tb <= '1'; -- Sinal "ativo"
        wait for 10 ps;
        c_tb <= '0';
        wait for 10 ps;
        c_tb <= '1';
        wait for 10 ps;
        c_tb <= '0';
        wait for 10 ps;

        -- Fim do teste
        a_tb <= '0';
        b_tb <= '0';
        c_tb <= '0';
        wait;
    end process stimulus;

end architecture testbench;