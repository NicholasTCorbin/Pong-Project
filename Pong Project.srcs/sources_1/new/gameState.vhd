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
    rst_o    : out std_logic;

    p1score_i : in integer range 0 to 99;
    p2score_i : in integer range 0 to 99;
    p1score_o : out integer range 0 to 99;
    p2score_o : out integer range 0 to 99;

    ballX : out integer range 0 to 640;
    ballY : out integer range 0 to 480
  );
end gameState;

architecture behavioral of gameState is

  type state_type is (init, reset, reset_w, game, p1goal, p2goal);

  signal curr_state  : state_type := init;
  signal rst_s       : std_logic := '0';
  signal ena_s       : std_logic := '0';

  signal count_so    : std_logic_vector(31 down to 0) := (others => '0');

  constant count_val : std_logic_vector(31 down to 0) := 
   "00000010111110101111000010000000";

  component gen_counter is
     generic (bit_width : integer);
        port ( clk, rst, ena : in std_logic;
      dout : out std_logic_vector (bit_width - 1 downto 0));
  end component;
    
begin

   gc : gen_counter
      generic map(bit_width => 32)
      port map(clk, rst_s, ena_s, count_so);

  game_fsm : process(clk)
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

          rst_o <= '1';

          ena_s <= '1';
          rst_s <= '0';

          curr_state <= reset_w;

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
        when reset_w =>
            if count_so = count_val then
                ena_s <= '0';
                rst_s <= '1';
                -- If either P1 or P2 reach 9 points...
                if p1score_i >= 9 or p2score_i >= 9 then
                  -- Next state: init.
                  curr_state <= init;
                -- Else...
                else
                  -- Next state: game.
                  rst_o <= '0';
                  curr_state <= game;
                end if;
             end if;

        when others =>
          curr_state <= init;

      end case;
    end if;
  end process;
end behavioral;
