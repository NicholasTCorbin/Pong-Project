----------------------------------------------------------------------------------
-- Engineer: Jonathan Ting Austin Jones
-- Create Date: 04/05/2020 04:51:12 PM
-- Module Name: gameState - Behavioral
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity gameState is
   generic(simulation : std_logic := '0');
   port (
           clk : in std_logic;
           center : in std_logic;

           p1goal : in std_logic;
           p2goal : in std_logic;

           rst : out std_logic;

           p1score : out integer range 0 to 99;
           p2score : out integer range 0 to 99
        );
end gameState;


architecture behavioral of gameState is

   component gen_counter is
      generic (bit_width : integer);
      port ( clk, rst, ena : in std_logic;
             dout : out std_logic_vector (bit_width - 1 downto 0));
   end component;

   -- possible states of fsm
   type state_type is (init, reset, reset_w, game, p1goal_inc, p2goal_inc);

   -- constant value set at compile
   signal count_val : std_logic_vector(31 downto 0) := (others => '0'); 

   signal curr_state  : state_type := init;

   signal rst_s       : std_logic := '0';
   signal ena_s       : std_logic := '0';

   signal count_so    : std_logic_vector(31 downto 0) := (others => '0');

   signal p1score_s : integer range 0 to 99 := 0;
   signal p2score_s : integer range 0 to 99 := 0;


begin

   -- wrap in a signal
   p1score <= p1score_s;
   p2score <= p2score_s;

   -- adds delay in the reset for humans
   count_val <= 
      -- adjust wait time in simulation
      "00000000000000000000000000000011"
      when simulation = '1' else
    --"00000010111110101111000010000000"; Increase the count
      "00001011111010111100001000000000";

   gc : gen_counter
      generic map(bit_width => 32)
      port map(clk, rst_s, ena_s, count_so);

   game_fsm : process(clk)
   begin
      if rising_edge(clk) then
         case curr_state is
            when init =>
               -- Reset score to 0 0.
               p1score_s <= 0;
               p2score_s <= 0;

               -- Next state: reset.
               curr_state <= reset;

            -- initialize for the pause in reset
            when reset =>
               rst <= '1';

               ena_s <= '1';
               rst_s <= '0';

               curr_state <= reset_w;

            when game =>
               -- If reset button is pressed, changes state to init.
               if center = '1' then
                  curr_state <= init;
               -- If right side of screen is touched by ball...
               elsif p1goal = '1' then
                  -- Next state: p1goal.
                  curr_state <= p1goal_inc;
               -- Else if left side of screen is touched by ball...
               elsif p2goal = '1' then
                  -- Next state: p2goal.
                  curr_state <= p2goal_inc;
               -- Else...
               else
                  -- Next state: game.
                  curr_state <= game;
               end if;

            when p1goal_inc =>
               -- Increment P1's score.
               p1score_s <= p1score_s + 1;
               -- Next state: reset.
               curr_state <= reset;

            when p2goal_inc =>
               -- Increment P2's score.
               p2score_s <= p2score_s + 1;
               -- Next state: reset.
               curr_state <= reset;
            -- wait in reset so humans can rest
            when reset_w =>
               if count_so = count_val then
                  ena_s <= '0';
                  rst_s <= '1';
                  -- If either P1 or P2 reach 12 points...
                  if p1score_s >= 12 or p2score_s >= 12 then
                     -- Next state: init.
                     curr_state <= init;
                  -- Else...
                  else
                     -- Next state: game.
                     rst <= '0';
                     curr_state <= game;
                  end if;
               end if;

            -- reset to init
            when others =>
               curr_state <= init;

         end case;
      end if;
   end process;
end behavioral;
