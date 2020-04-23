----------------------------------------------------------------------------------
-- Engineer: Nick Corbin
-- Create Date: 04/08/2020 09:11:15 PM
-- Module Name: ballController - Behavioral
-- Additional Comments:
--
--   --DON'T USE
--   --DON'T USE
--   --DON'T USE
--   --DON'T USE
--   --DON'T USE
--   --USE BALLCOLLISIONCONTROLLER
--   --USE BALLCOLLISIONCONTROLLER
--   --USE BALLCOLLISIONCONTROLLER
--   --USE BALLCOLLISIONCONTROLLER
--
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

entity ballController is
    Port ( toggleLR : in STD_LOGIC;
           toggleUD : in STD_LOGIC;
           collision : in STD_LOGIC;
           clk60 : in STD_LOGIC;
           ballX : out integer range 0 to 640;
           ballY : out integer range 0 to 480);
end ballController;

architecture Behavioral of ballController is
    signal upDown : STD_LOGIC;
    signal leftRight : STD_LOGIC;

begin
    --ballX <= 128;
    --Eventually, we will send signals from the collision controller to prompt changes in ball direction
    --Make speed a constant
    
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
