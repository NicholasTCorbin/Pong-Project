----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/05/2020 04:51:12 PM
-- Design Name: 
-- Module Name: renderer - Behavioral
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

entity renderer is
    Port ( 
       leftPaddleY : in integer range 0 to 480;
       rightPaddleY : in integer range 0 to 480;
       renderBall : in STD_LOGIC;
       ballX : in integer range 0 to 640;
       ballY : in integer range 0 to 480;
       leftScore : in integer range 0 to 99;
       rightScore : in integer range 0 to 99;
       smallClk : in STD_LOGIC;
       clk60 : in STD_LOGIC;
       sw : in STD_LOGIC;
       hSync : out STD_LOGIC;
       vSync : out STD_LOGIC;
       vgaRed : out STD_LOGIC_VECTOR (3 downto 0);
       vgaGreen : out STD_LOGIC_VECTOR (3 downto 0);
       vgaBlue : out STD_LOGIC_VECTOR (3 downto 0));
end renderer;

architecture Behavioral of renderer is

    type num_data is array (0 to 9, 0 to 9) of std_logic_vector(0 to 7);

    constant num_rom : num_data := (
    --   76543210
        ( -- 0
		"01111100", -- 0  *****
		"11000110", -- 1 **   **
		"11000110", -- 2 **   **
		"11001110", -- 3 **  ***
		"11011110", -- 4 ** ****
		"11110110", -- 5 **** **
		"11100110", -- 6 ***  **
		"11000110", -- 7 **   **
		"11000110", -- 8 **   **
		"01111100"  -- 9  *****
        ), ( -- 1
		"00011000", -- 0    **
		"00111000", -- 1   ***
		"01111000", -- 2  ****
		"00011000", -- 3    **
		"00011000", -- 4    **
		"00011000", -- 5    **
		"00011000", -- 6    **
		"00011000", -- 7    **
		"00011000", -- 8    **
		"01111110"  -- 9  ******
        ),( -- 2
		"01111100", -- 0  *****
		"11000110", -- 1 **   **
		"00000110", -- 2      **
		"00001100", -- 3     **
		"00011000", -- 4    **
		"00110000", -- 5   **
		"01100000", -- 6  **
		"11000000", -- 7 **
		"11000110", -- 8 **   **
		"11111110"  -- 9 *******
        ),( -- 3
		"01111100", -- 0  *****
		"11000110", -- 1 **   **
		"00000110", -- 2      **
		"00000110", -- 3      **
		"00111100", -- 4   ****
		"00000110", -- 5      **
		"00000110", -- 6      **
		"00000110", -- 7      **
		"11000110", -- 8 **   **
		"01111100"  -- 9  *****
        ),( -- 4
		"00001100", -- 0     **
		"00011100", -- 1    ***
		"00111100", -- 2   ****
		"01101100", -- 3  ** **
		"11001100", -- 4 **  **
		"11111110", -- 5 *******
		"00001100", -- 6     **
		"00001100", -- 7     **
		"00001100", -- 8     **
		"00011110"  -- 9    ****
        ),( -- 5
		"11111110", -- 0 *******
		"11000000", -- 1 **
		"11000000", -- 2 **
		"11000000", -- 3 **
		"11111100", -- 4 ******
		"00000110", -- 5      **
		"00000110", -- 6      **
		"00000110", -- 7      **
		"11000110", -- 8 **   **
		"01111100"  -- 9  *****
        ),( -- 6
		"00111000", -- 0   ***
		"01100000", -- 1  **
		"11000000", -- 2 **
		"11000000", -- 3 **
		"11111100", -- 4 ******
		"11000110", -- 5 **   **
		"11000110", -- 6 **   **
		"11000110", -- 7 **   **
		"11000110", -- 8 **   **
		"01111100"  -- 9  *****
        ),( -- 7
		"11111110", -- 0 *******
		"11000110", -- 1 **   **
		"00000110", -- 2      **
		"00000110", -- 3      **
		"00001100", -- 4     **
		"00011000", -- 5    **
		"00110000", -- 6   **
		"00110000", -- 7   **
		"00110000", -- 8   **
		"00110000"  -- 9   **
        ),( -- 8
		"01111100", -- 0  *****
		"11000110", -- 1 **   **
		"11000110", -- 2 **   **
		"11000110", -- 3 **   **
		"01111100", -- 4  *****
		"11000110", -- 5 **   **
		"11000110", -- 6 **   **
		"11000110", -- 7 **   **
		"11000110", -- 8 **   **
		"01111100"  -- 9  *****
        ),( -- 9
		"01111100", -- 0  *****
		"11000110", -- 1 **   **
		"11000110", -- 2 **   **
		"11000110", -- 3 **   **
		"01111110", -- 4  ******
		"00000110", -- 5      **
		"00000110", -- 6      **
		"00000110", -- 7      **
		"00001100", -- 8     **
		"01111000"  -- 9  ****
    ));

    component vga_controller_640_60 is
    port(
       rst         : in std_logic;
       pixel_clk   : in std_logic;
       HS          : out std_logic;
       VS          : out std_logic;
       hcount      : out std_logic_vector(10 downto 0);
       vcount      : out std_logic_vector(10 downto 0);
       blank       : out std_logic
    );
    end component;
    
    component reg is
    Port ( dataIn : in integer;
           we : in STD_LOGIC;
           clk : in STD_LOGIC;
           dataOut : out integer);
    end component;
    
    signal hcount : std_logic_vector(10 downto 0);
    signal vcount :  std_logic_vector(10 downto 0);
    signal blank : std_logic;
    
    constant WIDTH : integer range 0 to 640 := 640;
    constant HEIGHT : integer range 0 to 480 := 480;
    
    constant BALL_SIZE : integer range 0 to 32 := 16;
    constant PADDLE_WIDTH : integer range 0 to 32 := 16;
    constant PADDLE_HEIGHT : integer range 0 to 128 := 64;
    constant PADDLE_OFFSET : integer range 0 to 64 := 32;
    
    signal xl : integer := PADDLE_OFFSET;
    signal xr : integer := WIDTH - PADDLE_OFFSET - PADDLE_WIDTH;
    
    signal lx : integer;
    signal ly : integer;
    signal rx : integer;
    signal ry : integer;
    
    signal inBallX : integer;
    signal inBallY : integer;
begin
    lx <= xl;
    rx <= xr;
    
    vga : vga_controller_640_60 port map(rst => sw, pixel_clk => smallClk, HS => hSync, VS => vSync,
    hCount => hCount, vcount => vcount, blank => blank);
   
    --Putting this value into registers might make it bettter.
    regL : reg port map(dataIn => leftPaddleY, we => '1', clk => clk60, dataOut => ly);
    regR : reg port map(dataIn => rightPaddleY, we => '1', clk => clk60, dataOut => ry);
    
    regX : reg port map(dataIn => ballX, we => '1', clk => clk60, dataOut => inBallX);
    regY : reg port map(dataIn => ballY, we => '1', clk => clk60, dataOut => inBallY);

 process(smallClk)
    
    --variable lx : integer;
    --variable ly : integer;
    --variable rx : integer;
    --variable ry : integer;  
     
    variable vInt : integer := to_integer(unsigned(vCount));
    variable hInt : integer := to_integer(unsigned(hCount));
    variable drawWhite : std_logic;
    
    begin
        if(blank = '1') then
            vgaRed <= "0000";
            vgaGreen <= "0000";
            vgaBlue <= "0000";
            drawWhite := '0';
        else
          --lx := xl;
          --ly := leftPaddleY;
          --rx := xr;
          --ry := rightPaddleY;
          
          --Renders the ball
          --if(ballX < hInt and hInt < (ballX + BALL_SIZE) and ballY < vInt and vInt < (ballY + BALL_SIZE)) then
          if(inBallX < hInt
              and hInt < (inBallX + BALL_SIZE)
              and inBallY < vInt 
              and vInt < (inBallY + BALL_SIZE)) then
              
              if(renderBall = '1') then
                drawWhite := '1';
              else
                drawWhite := '0';
              end if;
          --Render both paddles
          elsif(lx < hInt 
              and hInt < (lx + PADDLE_WIDTH) 
              and ly < vInt 
              and vInt < (ly + PADDLE_HEIGHT)) then
            drawWhite := '1';
          elsif(rx < hInt 
              and hInt < (rx + PADDLE_WIDTH) 
              and ry < vInt 
              and vInt < (ry + PADDLE_HEIGHT)) then
            drawWhite := '1';
          -- index into the num data and draw it all acordingly
          -- currently the bottom bit will be truncated such that
          -- -- the result will be thicker than one pixel
          -- p1 score :: leftScore : in integer range 0 to 99
          -- tens
          elsif(hInt >= 110 and hInt < 126
              and vInt >= 5 and vInt < 25) then
            if(num_rom(leftScore / 10, (vInt - 5) / 2)((hint - 110) / 2) = '1') then
                drawWhite := '1';
            else
                drawWhite := '0';
            end if;
          -- p1 score :: leftScore : in integer range 0 to 99
          -- ones
          elsif(hInt >= 130 and hInt < 146
              and vInt >= 5 and vInt < 25) then
            if(num_rom(leftScore mod 10, (vInt - 5) / 2)((hint - 130) / 2) = '1') then
                drawWhite := '1';
            else
                drawWhite := '0';
            end if;
          -- p2 score :: rightScore : in integer range 0 to 99
          -- tens
          elsif(hInt >= 450 and hInt < 466
              and vInt >= 5 and vInt < 25) then
            if(num_rom(rightScore / 10, (vInt - 5) / 2)((hint - 450) / 2) = '1') then
                drawWhite := '1';
            else
                drawWhite := '0';
            end if;
          -- p2 score :: rightScore : in integer range 0 to 99
          -- ones
          elsif(hInt >= 470 and hInt < 486
              and vInt >= 5 and vInt < 25) then
            if(num_rom(rightScore mod 10, (vInt - 5) / 2)((hint - 470) / 2) = '1') then
                drawWhite := '1';
            else
                drawWhite := '0';
            end if;
          --I'm just going to draw an ugly line in the center right now, we'll make it better later
          elsif(hInt > 317
              and hInt < 323
              and (((vInt + 8) / 16) mod 2) = 1) then
            drawWhite := '1';
          else
            drawWhite := '0';
          end if;
        
          if(drawWhite = '1') then  
            vgaRed <= "1111";
            vgaGreen <= "1111";
            vgaBlue <= "1111"; 
          else
            vgaRed <= "0000";
            vgaGreen <= "0000";
            vgaBlue <= "0000";    
          end if;        
      end if;
    end process;

end Behavioral;
