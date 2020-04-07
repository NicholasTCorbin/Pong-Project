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
    
    signal hcount : std_logic_vector(10 downto 0);
    signal vcount :  std_logic_vector(10 downto 0);
    signal blank : std_logic;
    
    signal xl : integer range 0 to 640 := 3;
    
    signal xr : integer range 0 to 640 := 596;
begin

    vga : vga_controller_640_60 port map(rst => sw, pixel_clk => smallClk, HS => hSync, VS => vSync,
    hCount => hCount, vcount => vcount, blank => blank);
    
 process(smallClk)
    
    variable lx : integer;
    variable ly : integer;
    variable rx : integer;
    variable ry : integer;  
     
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
          lx := xl;
          ly := leftPaddleY;
          rx := xr;
          ry := rightPaddleY;
          
          --Render both boxes
          if(ballX < hInt and hInt < (ballX + 16) and ballY < vInt and vInt < (ballY + 16)) then
            drawWhite := '1';
          elsif(lx < hInt and hInt < (lx + 16) and ly < vInt and vInt < (ly + 64)) then
            drawWhite := '1';
          elsif(rx < hInt and hInt < (rx + 16) and ry < vInt and vInt < (ry + 64)) then
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
