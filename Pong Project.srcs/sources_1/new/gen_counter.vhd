----------------------------------------------------------------------------------
-- Engineer: Austin Jones
-- Create Date: 04/20/2020 04:23:15 AM
-- Module Name: gen_counter - Behavioral
-- Description: Generic Counter
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity gen_counter is
    generic (bit_WIDTH : integer := 8);
    Port ( clk, rst, ena : in STD_LOGIC;
           dout : out STD_LOGIC_VECTOR (bit_WIDTH - 1 downto 0));
end gen_counter;

architecture Behavioral of gen_counter is

signal data : unsigned(bit_WIDTH - 1 downto 0) := (others => '0');

begin

dout <= std_logic_vector(data);

count_up : process (clk)
begin
   if(rising_edge(clk)) then
      if(rst = '1') then
         data <= (others => '0');
      elsif(ena = '1') then
         data <= data + 1;
      end if;
   end if;
end process;

end Behavioral;
