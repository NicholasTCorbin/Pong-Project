library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gameState is
  port (
    clk : in std_logic;

    p1goal_i : in std_logic;
    p2goal_i : in std_logic;
    p1goal_o : out std_logic;
    p2goal_o : out std_logic;

    p1score_i : in integer range 0 to 99;
    p2score_i : in integer range 0 to 99;
    p1score_o : out integer range 0 to 99;
    p2score_o : out integer range 0 to 99;

    ballX : out integer range 0 to 640;
    ballY : out integer range 0 to 480
  );
end gameState;

architecture behavioral of gameState is
  type state_type is (init, reset, game, p1goal, p2goal);

  signal curr_state : state_type := init;
    
begin
  process(clk)
  begin
    if rising_edge(clk) then
      case curr_state is
        when init =>
          -- Reset score to 0 0.
          p1score_o <= 0;
          p2score_o <= 0;

          -- Next state: reset.
          curr_state <= reset;

        when reset =>
          -- Reset ball position.
          ballX <= 320;
          ballY <= 240;

          -- If either P1 or P2 reach 11 points...
          if p1score_i >= 11 or p2score_i >= 11 then
            -- Next state: init.
            curr_state <= init;
          -- Else...
          else
            -- Next state: game.
            curr_state <= game;
          end if;

        when game =>
          -- If right side of screen is touched by ball...
          if p1goal_i = '1' then
            -- Next state: p1goal.
            curr_state <= p1goal;
          -- Else if left side of screen is touched by ball...
          elsif p2goal_i = '1' then
            -- Next state: p2goal.
            curr_state <= p2goal;
          -- Else...
          else
            -- Next state: game.
            curr_state <= game;
          end if;

        when p1goal =>
          -- Increment P1's score.
          p1score_o <= p1score_i + 1;
          -- Reset score signal.
          p1goal_o <= '0';
          -- Next state: reset.
          curr_state <= reset;

        when p2goal =>
          -- Increment P2's score.
          p2score_o <= p2score_i + 1;
          -- Reset score signal.
          p1goal_o <= '0';
          -- Next state: reset.
          curr_state <= reset;

        when others =>
          curr_state <= init;

      end case;
    end if;
  end process;
end behavioral;
