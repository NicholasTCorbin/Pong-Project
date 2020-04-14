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
          if(inBallX < hInt and hInt < (inBallX + BALL_SIZE) and inBallY < vInt and vInt < (inBallY + BALL_SIZE)) then
            drawWhite := '1';
          --Render both paddles
          elsif(lx < hInt and hInt < (lx + PADDLE_WIDTH) and ly < vInt and vInt < (ly + PADDLE_HEIGHT)) then
            drawWhite := '1';
          elsif(rx < hInt and hInt < (rx + PADDLE_WIDTH) and ry < vInt and vInt < (ry + PADDLE_HEIGHT)) then
            drawWhite := '1';
          --I'm just going to draw an ugly line in the center right now, we'll make it better later
          elsif(hInt > 315 and hInt < 325) then
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
