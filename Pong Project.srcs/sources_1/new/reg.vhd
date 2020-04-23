-- general purpose register component
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity reg is
    Port ( dataIn : in integer;
           we : in STD_LOGIC;
           clk : in STD_LOGIC;
           dataOut : out integer);
end reg;

architecture Behavioral of reg is
begin
process(we, dataIn, clk)
    begin
    if(we = '1') then
        if(rising_edge(clk)) then
            dataOut <= dataIn;
        else
            dataOut <= dataOut;
        end if;
    end if;
end process;

end Behavioral;
