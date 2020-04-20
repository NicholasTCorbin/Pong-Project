----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/18/2020 08:02:17 PM
-- Design Name: 
-- Module Name: ballCollisionController - Behavioral
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

entity ballCollisionController is
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
end ballCollisionController;

architecture Behavioral of ballCollisionController is
    constant PADDLE_OFFSET : integer range 0 to 64 := 32;
    constant PADDLE_WIDTH : integer range 0 to 32 := 16;
    constant PADDLE_SPEED : integer range 0 to 15 := 12;

    constant WIDTH : integer range 0 to 640 := 640;
    
    -- -> leftRight = '0'
    --Going down the screen = '0'
    signal upDown : STD_LOGIC;
    signal leftRight : STD_LOGIC;
    signal hitNumber : std_logic_vector (2 downto 0);
    
    --Make case statement later
    --7x1 5x5 6x4/3 are all speeds that are possible
    signal ballSpeedX : integer := 5;
    signal ballSpeedY : integer := 5;
    
begin

    process(clk60) 
        variable nextBallX : integer;
        variable nextBallY : integer;
        variable nextLeftPaddleY : integer;
        variable nextRightPaddleY : integer;
          
        begin
        
        if rising_edge(clk60) then
            
            --Use these and next ball to predict next frame collision
            if(lu = '1') then
                nextLeftPaddleY := leftPaddleY - PADDLE_SPEED;
            elsif (ld = '1') then 
                nextLeftPaddleY := leftPaddleY + PADDLE_SPEED;
            elsif (ru = '1') then 
                nextRightPaddleY := rightPaddleY - PADDLE_SPEED;
            elsif (rd = '1') then 
                nextRightPaddleY := rightPaddleY + PADDLE_SPEED;
            end if;
        
            if(leftRight = '0') then
                nextBallX := ballX + ballSpeedX;
            else
                nextBallX := ballX - ballSpeedX;
            end if;
            
            if(upDown = '0') then
                nextBallY := ballY + ballSpeedY;
            else
                nextBallY := ballY - ballSpeedY;
            end if;
                       
            player1Scores <= '0';
            player2Scores <= '0';
            
            hitNumber <= "000";
            
            if(ballX < PADDLE_OFFSET) then
                player2Scores <= '1';
            elsif (ballX > WIDTH - PADDLE_OFFSET) then
                player1Scores <= '1';
            else
                --topEdge <= '0'; CHANGE TO BALLX
                --If the ball is close to the paddle and the
                --if ((PADDLE_OFFSET + PADDLE_WIDTH > ballX - 5) and (ballX = 7)) then
                --    leftPaddle <= '1';
                --    internalRight <= '1';
                --end if;
                
            end if;
        end if;
    end process;
    
    --USE ME
    process(clk60)   
        begin
        if rising_edge(clk60) then
            if(upDown = '1') then
                if(ballY < 5) then
                    --Bounces off the wall
                    ballY <= 5 - ballY;
                    upDown <= '0';
                else
                    ballY <= ballY - 5;
                end if;
            elsif (upDown = '0') then
                if(ballY > 475) then
                    --Bounces off the wall
                    ballY <= 960 - 5 - ballY;
                    upDown <= '1';
                else
                    ballY <= ballY + 5;
                end if;
            end if;
-------------------------
        if(leftRight = '1') then
            if(ballX < 5) then
                --Bounces off the wall
                ballX <= 5 - ballX;
                leftRight <= '0';
            else
                ballX <= ballX - 5;
            end if;
        elsif (leftRight = '0') then
            if(ballX > 635) then
                --Bounces off the wall
                ballX <= 1280 - 5 - ballX;
                leftRight <= '1';
            else
                ballX <= ballX + 5;
            end if;
        end if;            
    end if;
        
    end process;

end Behavioral;
