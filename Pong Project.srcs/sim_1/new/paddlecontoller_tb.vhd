----------------------------------------------------------------------------------
-- Engineer: Austin Jones
-- Create Date: 04/23/2020 12:02:40 AM
-- Module Name: paddleController_tb - Behavioral
-- Additional Comments:
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

use IEEE.NUMERIC_STD.ALL;

entity paddlecontoller_tb is
--  Port ( );
   end paddlecontoller_tb;

architecture Behavioral of paddlecontoller_tb is

   -- holder signals used to stimulate the dut
   signal reset_s   : STD_LOGIC := '1';
   signal lu_s      : STD_LOGIC := '0';
   signal ld_s      : STD_LOGIC := '0';
   signal ru_s      : STD_LOGIC := '0';
   signal rd_s      : STD_LOGIC := '0';
   signal clk_s     : STD_LOGIC := '0';

   signal leftPaddleY_s   : integer range 0 to 480 := 0;
   signal rightPaddleY_s  : integer range 0 to 480 := 0;

   component paddleController is
      Port ( reset : in STD_LOGIC;
             lu : in STD_LOGIC;
             ld : in STD_LOGIC;
             ru : in STD_LOGIC;
             rd : in STD_LOGIC;
             clk60 : in STD_LOGIC;
             leftPaddleY : out integer range 0 to 480;
             rightPaddleY : out integer range 0 to 480);
   end component;

begin

   dut : paddleController 
   port map( reset_s,
   lu_s, ld_s,
   ru_s, rd_s,
   clk_s,
   leftPaddleY_s,
   rightPaddleY_s);

   clk_gen : process
   begin
      clk_s <= not(clk_s);
      wait for 5 ns;
   end process;

   -- test all movement conditions
   dut_test : process
   begin

      reset_s <= '1';

      wait for 30 ns;

      reset_s <= '0';

   -- left up
      lu_s <= '1';

      wait for 30 ns;

      lu_s <= '0';

   -- left down
      ld_s <= '1';

      wait for 30 ns;

      ld_s <= '0';

   -- right up
      ru_s <= '1';

      wait for 30 ns;

      ru_s <= '0';

   -- right down
      rd_s <= '1';

      wait for 30 ns;

      rd_s <= '0';

   -- reset
      reset_s <= '1';

      wait for 30 ns;

      reset_s <= '0';

   -- both up
      lu_s <= '1';
      ru_s <= '1';

      wait for 30 ns;

      lu_s <= '0';
      ru_s <= '0';

   -- both down
      ld_s <= '1';
      rd_s <= '1';

      wait for 30 ns;

      ld_s <= '0';
      rd_s <= '0';

   -- test multi input
      ld_s <= '1';
      lu_s <= '1';

      wait for 30 ns;

      ld_s <= '0';
      lu_s <= '0';

   -- test multi input
      ru_s <= '1';
      rd_s <= '1';

      wait for 30 ns;

      ru_s <= '0';
      rd_s <= '0';

   end process;

end Behavioral;
