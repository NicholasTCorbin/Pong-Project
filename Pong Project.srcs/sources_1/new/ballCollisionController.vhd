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
           ballX : out integer;
           ballY : out integer;
           player1Scores : out STD_LOGIC;
           player2Scores : out STD_LOGIC);
end ballCollisionController;

architecture Behavioral of ballCollisionController is

    signal upDown : STD_LOGIC;
    signal leftRight : STD_LOGIC;
    
begin
    
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
