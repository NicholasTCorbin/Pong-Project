----------------------------------------------------------------------------------
-- Module Name: clockdivider - Behavioral

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clockdivider is
  port ( clk_in    : in  STD_LOGIC;
         count_val : in  integer range 0 to 1000000000;      
         clk_out   : out STD_LOGIC );
end clockdivider;

architecture Behavioral of clockdivider is
  signal clk_outsignal : std_logic := '0';
begin
  process(clk_in)
    variable count: INTEGER RANGE 0 to 100000000 :=0;
  begin
    if rising_edge(clk_in) then
      count := count + 1;

      if (count = count_val) then
        clk_outsignal <= not clk_outsignal;
        count := 0;
      end if;
    end if;

    clk_out <= clk_outsignal;
  end process;
end Behavioral;
