----------------------------------------------------------------------------------
-- Engineer: Austin Jones
-- Create Date: 04/23/2020 12:02:40 AM
-- Module Name: gamestate_tb - Behavioral
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity gamestate_tb is
   --  Port ( );
   end gamestate_tb;

architecture Behavioral of gamestate_tb is

   -- holder sigs for testing
   signal clk_s       : std_logic := '0';
   signal center_s    : std_logic := '0';

   signal p1goal_s    : std_logic := '0';
   signal p2goal_s    : std_logic := '0';

   signal rst_s       : std_logic := '0';

   signal p1score_s   : integer range 0 to 99 := 0;
   signal p2score_s   : integer range 0 to 99 := 0;

   component gameState is
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
   end component;

begin

   -- covering all the bases
   p2goal_s <= not(p1goal_s);

   dut : gameState
   generic map (simulation => '1')
   port map ( clk_s, center_s, p1goal_s, p2goal_s,
   rst_s, p1score_s, p2score_s);

   clk_gen : process
   begin
      clk_s <= not(clk_s);
      wait for 5 ns;
   end process;

   dut_test : process
   begin

      -- let anything init that has to
      wait for 103 ns;

      -- p1 goal
      p1goal_s <= '1';

      -- a score should take 5 clk cycles in
      -- test mode
      wait for 40 ns;

      -- p2 goal
      p1goal_s <= '0';

      -- should be 1-1
      wait for 25 ns;

      -- p1 goal
      p1goal_s <= '1';

      -- let p1 win and then some
      wait for 200 ns;

      -- clear
      center_s <= '1';

      wait for 50 ns;

      center_s <= '0';

      wait; 

   end process;


end Behavioral;
