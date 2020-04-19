library ieee;
use ieee.std_logic_1164.all;


entity gameState is
  port (
    clk : in std_logic;
  );
end gameState;

architecture behavioral of gameState is
  type state_type is (init, reset, game, p1score, p2score);

  signal curr_state: state_type := st0;
    
begin
  process(clk)
  begin
    if rising_edge(clk) then
      case curr_state is
        when init =>
        when reset =>
        when game =>
        when p1score =>
        when p2score =>
        when others =>
      end case;
    end if;
  end process;
end behavioral;
