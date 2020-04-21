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
           resetInit : in STD_LOGIC;
           ballX : out integer := 320;
           ballY : out integer := 240;
           player1Scores : out STD_LOGIC;
           player2Scores : out STD_LOGIC);
end ballCollisionController;

architecture Behavioral of ballCollisionController is
    constant PADDLE_OFFSET : integer range 0 to 64 := 32;
    constant PADDLE_WIDTH : integer range 0 to 32 := 16;
    constant PADDLE_HEIGHT : integer range 0 to 128 := 64;
    constant PADDLE_SPEED : integer range 0 to 15 := 12;
    constant BALL_SIZE : integer range 0 to 32 := 16;
    
    constant WIDTH : integer range 0 to 640 := 640;
    constant HEIGHT : integer range 0 to 480 := 480;
    
    constant RIGHT_PADDLE_X : integer := WIDTH - PADDLE_OFFSET - PADDLE_WIDTH;
    constant LEFT_PADDLE_X : integer := PADDLE_OFFSET + PADDLE_WIDTH;

    -- -> leftRight = '0'
    --Going down the screen = '0'
    signal upDown : STD_LOGIC;
    signal leftRight : STD_LOGIC;
    signal hitNumber : std_logic_vector (2 downto 0);
    
    --Make case statement later
    --7x1 5x5 6x4/3 are all speeds that are possible
    signal ballSpeedX : integer := 5;
    signal ballSpeedY : integer := 5;
    
    
    signal count_so    : std_logic_vector(31 downto 0) := (others => '0');
    signal randomValue1 : std_logic_vector(2 downto 0);
    signal randomValue2 : std_logic_vector(2 downto 0);
    signal randomValue3 : std_logic_vector(1 downto 0);
    
     component gen_counter is
        generic (bit_width : integer);
            port ( clk, rst, ena : in std_logic;
        dout : out std_logic_vector (bit_width - 1 downto 0));
     end component;
     
begin
    
    --ballX <= 320;
    --ballY <= 240;
    /*
    process(resetInit)
    begin
        if(rising_edge(resetInit)) then
            ballX <= 320;
            ballY <= 240;
        end if;
    end process;
    */
    gc : gen_counter
        generic map(bit_width => 32)
        port map(clk60, '0', '1', count_so);
        
    process(clk60)        
        begin
        if rising_edge(clk60) then
            
            player1Scores <= '0';
            player2Scores <= '0';
            
            if(ballX < PADDLE_OFFSET) then
                player2Scores <= '1';
            elsif (ballX > WIDTH - PADDLE_OFFSET) then
                player1Scores <= '1';
            else             
            end if;
        end if;
    end process;
    
    
    
    process(clk60, resetInit)   
        variable x : integer;

        begin
        if rising_edge(clk60) then
            if(resetInit = '0') then
            --Controls code that bounces ball off of top and bottom screen
            if(upDown = '1') then
                if(ballY < ballSpeedY) then
                    --Bounces off the wall
                    ballY <= ballSpeedY - ballY;
                    upDown <= '0';
                else
                    ballY <= ballY - ballSpeedY;
                end if;
            elsif (upDown = '0') then
                if(ballY > (HEIGHT - ballSpeedY)) then
                    --Bounces off the wall
                    ballY <= 960 - ballSpeedY - ballY;
                    upDown <= '1';
                else
                    ballY <= ballY + ballSpeedY;
                end if;
            end if;
            else
                --ballY <= 390;
                randomValue1 <= count_so(2 downto 0);
                randomValue2 <= count_so(5 downto 3);
                randomValue3 <= count_so(7 downto 6);
                
                case randomValue1 is 
                when "000" => ballSpeedX <=  3; ballSpeedY <=  6;
                when "001" => ballSpeedX <=  5; ballSpeedY <=  5;
                when "010" => ballSpeedX <=  6; ballSpeedY <=  3;
                when "011" => ballSpeedX <=  7; ballSpeedY <=  2;
                when "100" => ballSpeedX <=  7; ballSpeedY <=  2;
                when "101" => ballSpeedX <=  6; ballSpeedY <=  3;
                when "110" => ballSpeedX <=  5; ballSpeedY <=  5;
                when "111" => ballSpeedX <=  3; ballSpeedY <=  6;
                when others => ballSpeedX <=  5; ballSpeedY <=  5;
                end case;

                case randomValue2 is 
                when "000" =>  ballY <=  130;
                when "001" =>  ballY <=  150;
                when "010" =>  ballY <=  180;
                when "011" =>  ballY <=  210;
                when "100" =>  ballY <=  240;
                when "101" =>  ballY <=  270;
                when "110" =>  ballY <=  300;
                when "111" =>  ballY <=  330;
                when others => ballY <=  360;
                end case;
                
                case randomValue3 is 
                when "00" =>  upDown <=  '0'; leftRight <=  '0';
                when "01" =>  upDown <=  '0'; leftRight <=  '1';
                when "10" =>  upDown <=  '1'; leftRight <=  '0';
                when "11" =>  upDown <=  '1'; leftRight <=  '1';
                when others => upDown <=  '0'; leftRight <=  '0';
                end case;
                    
            end if;
-------------------------
        if(resetInit = '0') then
        if(leftRight = '1') then
            if(ballX < ballSpeedX) then
                --Bounces off the wall
                ballX <= ballSpeedX - ballX;
                leftRight <= '0';
            --Paddle Collision Detection. The worst if statement of all time
            --If we are close on the x axis to the paddle
            elsif(((ballX - LEFT_PADDLE_X) < ballSpeedX) and (ballY > (leftPaddleY - BALL_SIZE)) and (ballY < (leftPaddleY + PADDLE_HEIGHT))) then
                ballX <= ballX - ballSpeedX;
                leftRight <= '0';
                
                x := ballY + BALL_SIZE - leftPaddleY;

               if( x < 8) then
                 ballSpeedX <= 2;
                 ballSpeedY <= 7;
                 upDown <= '1';
               elsif(( x >= 8) and (x < 16)) then
                 ballSpeedX <= 3;
                 ballSpeedY <= 6;
                 upDown <= '1';
               elsif(( x >= 16) and (x < 24)) then
                 ballSpeedX <= 5;
                 ballSpeedY <= 5;
                 upDown <= '1';
               elsif(( x >= 24) and (x < 32)) then
                 ballSpeedX <= 6;
                 ballSpeedY <= 3;
                 upDown <= '1';
               elsif(( x >= 32) and (x < 40)) then
                 ballSpeedX <= 7;
                 ballSpeedY <= 2;
                 upDown <= '1';
               elsif(( x >= 48) and (x < 56)) then
                 ballSpeedX <= 7;
                 ballSpeedY <= 2;
                 upDown <= '0';
               elsif(( x >= 56) and (x < 64)) then
                 ballSpeedX <= 6;
                 ballSpeedY <= 3;
                 upDown <= '0';
               elsif(( x >= 64) and (x < 72)) then
                 ballSpeedX <= 5;
                 ballSpeedY <= 5;
                 upDown <= '0';
               elsif(( x >= 72) and (x < 80)) then
                 ballSpeedX <= 3;
                 ballSpeedY <= 6;
                 upDown <= '0';
               else
                 ballSpeedX <= 2;
                 ballSpeedY <= 7;
                 upDown <= '0';
               end if;
                
            else
                ballX <= ballX - ballSpeedX;
            end if;
        elsif (leftRight = '0') then
            if(ballX > (WIDTH - ballSpeedX)) then
                --Bounces off the wall
                ballX <= 1280 - ballSpeedX - ballX;
                leftRight <= '1';
            elsif(((RIGHT_PADDLE_X - BALL_SIZE - ballX) < ballSpeedX) and (ballY > (rightPaddleY - BALL_SIZE)) and (ballY < (rightPaddleY + PADDLE_HEIGHT))) then
                ballX <= ballX + ballSpeedX;
                leftRight <= '1';
                
               x := ballY + BALL_SIZE - rightPaddleY;

               if( x < 8) then
                 ballSpeedX <= 3;
                 ballSpeedY <= 7;
                 upDown <= '1';
               elsif(( x >= 8) and (x < 16)) then
                 ballSpeedX <= 4;
                 ballSpeedY <= 6;
                 upDown <= '1';
               elsif(( x >= 16) and (x < 24)) then
                 ballSpeedX <= 5;
                 ballSpeedY <= 5;
                 upDown <= '1';
               elsif(( x >= 24) and (x < 32)) then
                 ballSpeedX <= 6;
                 ballSpeedY <= 4;
                 upDown <= '1';
               elsif(( x >= 32) and (x < 40)) then
                 ballSpeedX <= 7;
                 ballSpeedY <= 3;
                 upDown <= '1';
               elsif(( x >= 48) and (x < 56)) then
                 ballSpeedX <= 7;
                 ballSpeedY <= 3;
                 upDown <= '0';
               elsif(( x >= 56) and (x < 64)) then
                 ballSpeedX <= 6;
                 ballSpeedY <= 4;
                 upDown <= '0';
               elsif(( x >= 64) and (x < 72)) then
                 ballSpeedX <= 5;
                 ballSpeedY <= 5;
                 upDown <= '0';
               elsif(( x >= 72) and (x < 80)) then
                 ballSpeedX <= 4;
                 ballSpeedY <= 6;
                 upDown <= '0';
               else
                 ballSpeedX <= 3;
                 ballSpeedY <= 7;
                 upDown <= '0';
               end if;
               
            else
                ballX <= ballX + ballSpeedX;
            end if;
        end if;
        else
            ballX <= 330;
        end if;            
    end if;
    
    end process;
    
end Behavioral;
