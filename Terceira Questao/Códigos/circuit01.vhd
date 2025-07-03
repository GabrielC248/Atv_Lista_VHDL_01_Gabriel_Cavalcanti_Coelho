library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;
library work;
use work.custom_types.all; -- Biblioteca para o tipo bus_type "array (natural range <>) of std_logic_vector(3 downto 0)"

entity circuit01 is
    port (
        en : in std_logic;
        clk : in std_logic;
        rst : in std_logic;
        sel : in std_logic_vector(1 downto 0);
        bus_array : in bus_type(15 downto 0);
        sub_array : out bus_type(3 downto 0)
    );
end entity circuit01;

architecture arch of circuit01 is

    signal array_reg_wire : bus_type(3 downto 0); -- "Fio" para a saida dos muxes

    -- Declaracao do componente mux
    component custom_mux
        port (
            sel : in std_logic_vector(1 downto 0);
            input1 : in std_logic_vector(3 downto 0);
            input2 : in std_logic_vector(3 downto 0);
            input3 : in std_logic_vector(3 downto 0);
            input4 : in std_logic_vector(3 downto 0);
            output : out std_logic_vector(3 downto 0)
        );
    end component custom_mux;

begin
    
    mux_01 : entity work.custom_mux(arch_case) -- Instancia do primeiro mux com a versao case
        port map(
            sel => sel,
            input1 => bus_array(0),
            input2 => bus_array(4),
            input3 => bus_array(8),
            input4 => bus_array(12),
            output => array_reg_wire(0)
        );

    mux_02 : entity work.custom_mux(arch_if) -- Instancia do segundo mux com a versao if-elsif
        port map(
            sel => sel,
            input1 => bus_array(1),
            input2 => bus_array(5),
            input3 => bus_array(9),
            input4 => bus_array(13),
            output => array_reg_wire(1)
        );
        
    mux_03 : entity work.custom_mux(arch_when) -- Instancia do terceiro mux com a versao when-else
        port map(
            sel => sel,
            input1 => bus_array(2),
            input2 => bus_array(6),
            input3 => bus_array(10),
            input4 => bus_array(14),
            output => array_reg_wire(2)
        );

    mux_04 : entity work.custom_mux(arch_with) -- Instancia do quarto mux com a versao with-select
        port map(
            sel => sel,
            input1 => bus_array(3),
            input2 => bus_array(7),
            input3 => bus_array(11),
            input4 => bus_array(15),
            output => array_reg_wire(3)
        );

    array_reg: process(clk) -- Registrador sincrono para atualizar o array de saida com base no clock e em um sinal de habilitacao
    begin
        if rising_edge(clk) then
            if (rst = '1') then -- Definicao do reset (todas as saidas recebem 0)
                sub_array(0) <= (others => '0');
                sub_array(1) <= (others => '0');
                sub_array(2) <= (others => '0');
                sub_array(3) <= (others => '0');
            else -- Atualizacao da saida caso o enable esteja em sinal alto
                if (en = '1') then
                    sub_array(0) <= array_reg_wire(0);
                    sub_array(1) <= array_reg_wire(1);
                    sub_array(2) <= array_reg_wire(2);
                    sub_array(3) <= array_reg_wire(3);                
                end if;
            end if;
        end if;
    end process array_reg;

end architecture arch;