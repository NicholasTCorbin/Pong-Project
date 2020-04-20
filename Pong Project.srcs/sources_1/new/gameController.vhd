----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2020 06:03:32 PM
-- Design Name: 
-- Module Name: gameController - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gameController is
    Port ( reset : in STD_LOGIC;
           init : in STD_LOGIC;
           lu : in STD_LOGIC;
           ld : in STD_LOGIC;
           ru : in STD_LOGIC;
           rd : in STD_LOGIC;
           clk60 : in STD_LOGIC;
           ballX : out integer range 0 to 640;
           ballY : out integer range 0 to 480;
           leftPaddleY : out integer range 0 to 480;
           rightPaddleY : out integer range 0 to 480;
           leftScore : out integer range 0 to 99;
           rightScore : out integer range 0 to 99;
           player1Scores : out STD_LOGIC;
           player2Scores : out STD_LOGIC);
end gameController;

architecture Behavioral of gameController is

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
    
    component ballController is
    Port ( toggleLR : in STD_LOGIC;
           toggleUD : in STD_LOGIC;
           collision : in STD_LOGIC;
           clk60 : in STD_LOGIC;
           ballX : out integer range 0 to 640;
           ballY : out integer range 0 to 480);
    end component;
    
    component ballCollisionController is
        Port ( clk60 : in STD_LOGIC;
               leftPaddleY : in integer;
               rightPaddleY : in integer;
               --Used to predict where paddles are next frame
               lu : in STD_LOGIC;
               ld : in STD_LOGIC;
               ru : in STD_LOGIC;
               rd : in STD_LOGIC;
               ballX : out integer;
               ballY : out integer;
               player1Scores : out STD_LOGIC;
               player2Scores : out STD_LOGIC);
    end component;
    
    signal bx : integer range 0 to 640 := 64;
    signal by : integer range 0 to 480 := 64;

    constant WIDTH : integer range 0 to 640 := 640;
    constant HEIGHT : integer range 0 to 480 := 480;
    
    constant BALL_SIZE : integer range 0 to 32 := 16;
    constant PADDLE_WIDTH : integer range 0 to 32 := 16;
    constant PADDLE_HEIGHT : integer range 0 to 128 := 64;
    constant PADDLE_OFFSET : integer range 0 to 64 := 32;
    constant PADDLE_SPEED : integer range 0 to 15 := 12;
    
    constant xl : integer := PADDLE_OFFSET;
    constant xr : integer := WIDTH - PADDLE_OFFSET - PADDLE_WIDTH;
begin
    --IMPORTANT: x,y is defined as 0,0 in the left corner
    --X and Y increase as we move away from there.
    --Everything is therefore defined by the upper left corner of the box
    leftScore <= 0;
    rightScore <= 0;
    --playerScores <= '0';
    --ballX <= 64;
    --ballY <= 64;
    
    paddle : paddleController port map(reset => reset, lu => lu, ld => ld, ru => ru, rd => rd,
    clk60 => clk60, leftPaddleY => leftPaddleY, rightPaddleY => rightPaddleY);

    --Add player 1 and player 2 scoring out later.
    ballCollision : ballCollisionController port map(clk60 => clk60, leftPaddleY => leftPaddleY, rightPaddleY => rightPaddleY,
    lu => lu, ld => ld, ru => ru, rd => rd, ballX => ballX, ballY => ballY, player1Scores => player1Scores, player2Scores => player2Scores); 
    
    --Updates paddle location depending on 
    /*
    process (clk60)   
        begin
        if rising_edge(clk60) then
            --bx <= bx + 4;
            --by <= by + 6;
            --ballX <= bx;
            --ballY <= by;
            ballX <= ballX + 4;
            ballY <= ballY + 6;
            -- Only update if the signal is high and was not previously high
        end if;
    end process;
    */

    
end Behavioral;
