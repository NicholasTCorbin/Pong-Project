----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/23/2020 12:02:40 AM
-- Design Name: 
-- Module Name: ballcollisioncontroller_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ballcollisioncontroller_tb is
--  Port ( );
end ballcollisioncontroller_tb;

architecture Behavioral of ballcollisioncontroller_tb is

   signal clk_s : STD_LOGIC := '0';

   -- signal lu : STD_LOGIC := '0'; 
   -- signal ld : STD_LOGIC := '0';
   -- signal ru : STD_LOGIC := '0';
   -- signal rd : STD_LOGIC := '0';

   signal resetInit_s : STD_LOGIC := '0';
   signal player1Scores_s : STD_LOGIC := '0';
   signal player2Scores_s : STD_LOGIC := '0';

   signal ballX_s : integer := 320;
   signal ballY_s : integer := 240;
   signal leftPaddleY_s : integer := 0;
   signal rightPaddleY_s : integer := 0;

component ballCollisionController is
    Generic ( simulation : std_logic := '0');
    Port ( clk60 : in STD_LOGIC;
           leftPaddleY : in integer;
           rightPaddleY : in integer;
           lu : in STD_LOGIC; -- not used
           ld : in STD_LOGIC; -- not used
           ru : in STD_LOGIC; -- not used
           rd : in STD_LOGIC; -- not used
           resetInit : in STD_LOGIC;
           ballX : out integer := 320;
           ballY : out integer := 240;
           player1Scores : out STD_LOGIC;
           player2Scores : out STD_LOGIC);
end component;


begin

dut : ballCollisionController 
   generic map (simulation => '1')
   port map (clk_s,
   leftPaddleY_s,
   rightPaddleY_s,
   '0', '0', '0', '0', -- not used
   resetInit_s,
   ballX_s, ballY_s,
   player1Scores_s,
   player2Scores_s);

clk_gen : process
begin
   clk_s <= not(clk_s);
   wait for 5 ns;
end process;

dut_test : process
begin

   resetInit_s <= '1';

   wait for 30 ns;

   resetInit_s <= '0';

   -- tests that the for paddle collision
   -- leave commented to test for scoring
   -- recongintion
   -- leftPaddleY_s <= 45;
   -- rightPaddleY_s <= 425;

   wait;

end process;

end Behavioral;
