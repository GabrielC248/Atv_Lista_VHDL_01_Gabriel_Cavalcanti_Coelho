library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.custom_types.all; -- Biblioteca para o tipo bus_type "array (natural range <>) of std_logic_vector(3 downto 0)"

entity tb_circuit01 is
end entity tb_circuit01;

architecture testbench of tb_circuit01 is

    -- Definicao do periodo do clock
    constant T : time := 10 ps;

    -- Sinais do tb para o circuito feito
    signal tb_en, tb_clk, tb_rst : std_logic;
    signal tb_sel : std_logic_vector(1 downto 0);
    signal tb_bus_array : bus_type(15 downto 0);
    signal tb_sub_array : bus_type(3 downto 0);

    -- Declaracao do circuito feito
    component circuit01
        port (
            en : in std_logic;
            clk : in std_logic;
            rst : in std_logic;
            sel : in std_logic_vector(1 downto 0);
            bus_array : in bus_type(15 downto 0);
            sub_array : out bus_type(3 downto 0)
        );
    end component circuit01;

begin
    
    -- Instanciacao do circuito feito
    uut :  circuit01
        port map (
            en => tb_en,
            clk => tb_clk,
            rst => tb_rst,
            sel => tb_sel,
            bus_array => tb_bus_array,
            sub_array => tb_sub_array
        );
    
    -- Gera o clock do testbench
    clock_gen: process
    begin
        tb_clk <= '0';
        wait for (T/2);
        tb_clk <= '1';
        wait for (T/2);
    end process clock_gen;

    -- Acionamento do reset
    reset_gen: process
    begin
        -- Aciona o reset logo no comeco
        tb_rst <= '1';
        wait for (T);        
        tb_rst <= '0';

        -- Aciona o reset um pouco depois do primeiro teste
        wait for (10*T);
        tb_rst <= '1';
        wait for (T);
        tb_rst <= '0';

        wait;
    end process reset_gen;

    -- Estimulos fornecidos para realizar o testbench
    stimulus: process
    begin
        -- Inicia com tudo zerado
        tb_sel <= "00";
        tb_bus_array <= (others => (others => '0'));

        -- Habilita a saida
        tb_en <= '1';

        -- Atribui a cada posicao do vetor um valor de 4 bits "correspondente" a posicao para facilitar a visualizacao na forma de onda
        wait for (2*T);
        tb_bus_array <= (
                0  => "0000",
                1  => "0001",
                2  => "0010",
                3  => "0011",
                4  => "0100",
                5  => "0101",
                6  => "0110",
                7  => "0111",
                8  => "1000",
                9  => "1001",
                10 => "1010",
                11 => "1011",
                12 => "1100",
                13 => "1101",
                14 => "1110",
                15 => "1111"
            );
        wait for (2*T);
        tb_sel <= "01"; -- Testa o sel quando em 01
        wait for (2*T);
        tb_sel <= "10"; -- Testa o sel quando em 10
        wait for (2*T);
        tb_sel <= "11"; -- Testa o sel quando em 11

        -- Segundo teste
        wait for (5*T);
        tb_sel <= "00"; -- Testa o sel quando em 00     
        tb_bus_array <= ( -- Atribui os mesmos valores anteriores mas agora invertido
            0  => "1111",
            1  => "1110",
            2  => "1101",
            3  => "1100",
            4  => "1011",
            5  => "1010",
            6  => "1001",
            7  => "1000",
            8  => "0111",
            9  => "0110",
            10 => "0101",
            11 => "0100",
            12 => "0011",
            13 => "0010",
            14 => "0001",
            15 => "0000"
        );
        wait for (2*T);
        tb_sel <= "01"; -- Testa o sel quando em 01
        wait for (2*T);
        tb_sel <= "10"; -- Testa o sel quando em 10
        wait for (2*T);
        tb_sel <= "11"; -- Testa o sel quando em 11
        wait for (2*T);

        -- Repete o primeiro teste novamente, mas com o enable desabilitado (todas as saidas devem ficar congeladas)
        tb_en <= '0';

        -- Zera tudo depois de 2 periodos de clock
        wait for (2*T);
        tb_sel <= "00";
        tb_bus_array <= (others => (others => '0'));

        -- Atribui a cada posicao do vetor um valor de 4 bits "correspondente" a posicao para facilitar a visualizacao na forma de onda
        wait for (2*T);
        tb_bus_array <= (
                0  => "0000",
                1  => "0001",
                2  => "0010",
                3  => "0011",
                4  => "0100",
                5  => "0101",
                6  => "0110",
                7  => "0111",
                8  => "1000",
                9  => "1001",
                10 => "1010",
                11 => "1011",
                12 => "1100",
                13 => "1101",
                14 => "1110",
                15 => "1111"
            );
        wait for (2*T);
        tb_sel <= "01"; -- Testa o sel quando em 01
        wait for (2*T);
        tb_sel <= "10"; -- Testa o sel quando em 10
        wait for (2*T);
        tb_sel <= "11"; -- Testa o sel quando em 11

        wait;
    end process stimulus;

end architecture testbench;