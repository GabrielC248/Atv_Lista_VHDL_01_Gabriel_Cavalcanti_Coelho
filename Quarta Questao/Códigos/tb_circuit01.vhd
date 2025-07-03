library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.custom_types.all; -- Biblioteca para o tipo integer_array "type integer_array is array (natural range <>) of integer;"

entity tb_circuit01 is
end entity tb_circuit01;

architecture testbench of tb_circuit01 is

    -- Definicao do periodo do clock
    constant T : time := 10 ps;

    -- Sinais do tb para o circuito feito
    signal tb_clk, tb_rst : std_logic;
    signal tb_inputs : integer_array (7 downto 0); -- inputs do testbench ligada as estradas de ambas as versoes
    signal tb_A_outputs : integer_array (3 downto 0); -- outputs da versao A (paralela)
    signal tb_B_outputs : integer_array (3 downto 0); -- outputs da versao B (sequencial)

    -- Declaracao do circuito feito
    component circuit01
        port (
            clk : in std_logic;
            rst : in std_logic;
            inputs : in integer_array (7 downto 0);
            outputs : out integer_array (3 downto 0)
        );
    end component circuit01;

begin
    
    -- Instanciacao da versao A do circuito feito
    uut_A : entity work.circuit01(version_A) 
        port map(
            clk => tb_clk,
            rst => tb_rst,
            inputs => tb_inputs,
            outputs => tb_A_outputs
        );

    -- Instanciacao da versao B do circuito feito
    uut_B : entity work.circuit01(version_B) 
        port map(
            clk => tb_clk,
            rst => tb_rst,
            inputs => tb_inputs,
            outputs => tb_B_outputs
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
        -- Aciona o reset em 200 ps
        wait for (T*19);
        tb_rst <= '1';
        wait for (T);
        tb_rst <= '0';
        wait;
    end process reset_gen;

    -- Estimulos fornecidos para realizar o testbench
    stimulus: process
    begin
        -- Inicia com tudo zerado
        tb_inputs(0) <= 0;
        tb_inputs(1) <= 0;
        tb_inputs(2) <= 0;
        tb_inputs(3) <= 0;
        tb_inputs(4) <= 0;
        tb_inputs(5) <= 0;
        tb_inputs(6) <= 0;
        tb_inputs(7) <= 0;

        -- Primeiro Teste
        wait for (T);
        tb_inputs(0) <= 1;
        tb_inputs(1) <= 2;
        tb_inputs(2) <= 3;
        tb_inputs(3) <= 4;
        tb_inputs(4) <= 5;
        tb_inputs(5) <= 6;
        tb_inputs(6) <= 7;
        tb_inputs(7) <= 8;

        -- Segundo Teste
        wait for (4*T);
        tb_inputs(0) <= 8;
        tb_inputs(1) <= 7;
        tb_inputs(2) <= 6;
        tb_inputs(3) <= 5;
        tb_inputs(4) <= 4;
        tb_inputs(5) <= 3;
        tb_inputs(6) <= 2;
        tb_inputs(7) <= 1;

        -- Terceiro Teste
        wait for (8*T);
        tb_inputs(0) <= 1;
        tb_inputs(1) <= 53;
        tb_inputs(2) <= 3;
        tb_inputs(3) <= 157;
        tb_inputs(4) <= 359;
        tb_inputs(5) <= 5;
        tb_inputs(6) <= 53;
        tb_inputs(7) <= 2;

        wait;
    end process stimulus;

end architecture testbench;