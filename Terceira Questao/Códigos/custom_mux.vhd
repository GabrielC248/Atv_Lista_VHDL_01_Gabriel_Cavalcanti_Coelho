library IEEE;
use IEEE.std_logic_1164.all;

entity custom_mux is
    port (
        sel : in std_logic_vector(1 downto 0);
        input1 : in std_logic_vector(3 downto 0);
        input2 : in std_logic_vector(3 downto 0);
        input3 : in std_logic_vector(3 downto 0);
        input4 : in std_logic_vector(3 downto 0);
        output : out std_logic_vector(3 downto 0)
    );
end entity custom_mux;

architecture arch_case of custom_mux is -- Arquitetura do mux com o case

begin

    mux: process(sel, input1, input2, input3, input4)
    begin
        case sel is
            when "00" =>
                output <= input1;
            when "01" =>
                output <= input2;
            when "10" =>
                output <= input3;
            when others =>
                output <= input4;
        end case;
    end process mux;

end architecture arch_case;

architecture arch_if of custom_mux is -- Arquitetura do mux com o if-elsif

begin

    mux: process(sel, input1, input2, input3, input4)
    begin
        if (sel = "00") then
            output <= input1;
        elsif (sel = "01") then
            output <= input2;
        elsif (sel = "10") then
            output <= input3;
        else
            output <= input4;
        end if ;
    end process mux;

end architecture arch_if;

architecture arch_when of custom_mux is -- Arquitetura do mux com o when-else

begin

    output <= input1 when sel = "00" else
              input2 when sel = "01" else
              input3 when sel = "10" else
              input4;

end architecture arch_when;

architecture arch_with of custom_mux is -- Arquitetura do mux com o with-select

begin

    with sel select output <=
        input1 when "00",
        input2 when "01",
        input3 when "10",
        input4 when others;

end architecture arch_with;