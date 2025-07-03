library IEEE;
use IEEE.std_logic_1164.all;

package custom_types is
    
    type bus_type is array (natural range <>) of std_logic_vector(3 downto 0);
    
end package custom_types;