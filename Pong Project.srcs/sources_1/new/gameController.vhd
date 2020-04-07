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
           playerScores : out STD_LOGIC);
end gameController;

architecture Behavioral of gameController is
    signal yl : integer range 0 to 480 := 3;
    signal yr : integer range 0 to 480 := 3;
    
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
    playerScores <= '0';
    ballX <= 64;
    ballY <= 64;
    
    --Updates paddle location depending on 
    process (clk60)   
        begin
        if rising_edge(clk60) then
            -- Only update if the signal is high and was not previously high
            if (lu = '1') then
                if(yl > (PADDLE_SPEED - 1)) then --11
                    yl <= yl - PADDLE_SPEED;  
                else
                    yl <= 0;
                end if;     
            elsif (ld = '1') then
                --480 - 64 - 12 = 404
                if(yl < (HEIGHT - PADDLE_HEIGHT - PADDLE_SPEED)) then
                    yl <= yl + PADDLE_SPEED;
                else
                    yl <= (HEIGHT - PADDLE_HEIGHT); --416
                end if;
            end if;
            
            if (ru = '1') then
                if(yr > (PADDLE_SPEED - 1)) then
                    yr <= yr - PADDLE_SPEED;     
                else
                    yr <= 0;
                end if; 
            elsif (rd = '1') then
                if(yr < (HEIGHT - PADDLE_HEIGHT - PADDLE_SPEED)) then
                    yr <= yr + PADDLE_SPEED;     
                else
                    yr <= (HEIGHT - PADDLE_HEIGHT);
                end if; 
            end if;
        end if;
    end process;
    
    leftPaddleY <= yl;
    rightPaddleY <= yr;
    
end Behavioral;
