library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity tb_counters is
end entity tb_counters;

architecture testbench of tb_counters is

    signal clk_tb, rst_tb : std_logic; -- Sinais comuns dos contadores

    signal output_integer : integer; -- Output do contador de inteiro de -128 ate 127
    signal output_signed : signed(7 downto 0); -- Output do contador de inteiro com sinal
    signal output_unsigned : unsigned(7 downto 0); -- Output do contador de inteiro sem sinal

    -- Declaracao do contador de inteiro de -128 ate 127
    component integer_counter
        port (
            clk : in std_logic;
            rst : in std_logic;
            output : out integer range -128 to 127
        );
    end component integer_counter;

    -- Declaracao do contador de inteiro com sinal
    component signed_counter
        port (
            clk : in std_logic;
            rst : in std_logic;
            output : out signed(7 downto 0)
        );
    end component signed_counter;

    -- Declaracao do contador de inteiro sem sinal
    component unsigned_counter
        port (
            clk : in std_logic;
            rst : in std_logic;
            output : out unsigned(7 downto 0)
        );
    end component unsigned_counter;

begin

    -- Instanciacao do contador de inteiro de -128 ate 127
    uut_integer : integer_counter
        port map (
            clk => clk_tb,
            rst => rst_tb,
            output => output_integer
        );
    
    -- Instanciacao do contador de inteiro com sinal
    uut_signed : signed_counter
        port map (
            clk => clk_tb,
            rst => rst_tb,
            output => output_signed
        );

    -- Instanciacao do contador de inteiro sem sinal
    uut_unsigned : unsigned_counter
        port map (
            clk => clk_tb,
            rst => rst_tb,
            output => output_unsigned
        );

    -- Gera o clock do testbench
    clock_gen: process
    begin
        clk_tb <= '0';
        wait for 5 ps;
        clk_tb <= '1';
        wait for 5 ps;
    end process clock_gen;

    -- Aciona o reset em tempos definidos para teste
    reset_gen: process
    begin
        rst_tb <= '0';

        -- Ativa o reset no inicio e na borda de subida do clock
        wait for 25 ps;        
        rst_tb <= '1';
        wait for 5 ps;
        rst_tb <= '0';

        -- Ativa o reset um pouco depois da primeira contagem completa na borda de descida do clock
        wait for 2670 ps;
        rst_tb <= '1';
        wait for 5 ps;
        rst_tb <= '0';
        
        wait;
    end process reset_gen;

end architecture testbench;