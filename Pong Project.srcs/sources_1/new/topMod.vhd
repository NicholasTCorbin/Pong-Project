library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

entity topMod is
    Port( clk : in std_logic;
          sw : in std_logic;
          leftUp : in std_logic;
          leftDown : in std_logic;
          rightUp : in std_logic;
          rightDown : in std_logic;
          vgaRed : out std_logic_vector (3 downto 0);
          vgaBlue : out std_logic_vector (3 downto 0);
          vgaGreen : out std_logic_vector (3 downto 0);
          hSync : out std_logic;
          vSync : out std_logic);
end topMod;

architecture Behavioral of topMod is   
    component clockdivider is
    port ( clk_in    : in  STD_LOGIC;
        count_val : in  integer range 0 to 1000000000;      
        clk_out   : out STD_LOGIC );
    end component;
    
    component debouncer is
    Port (
        DATA: in std_logic;
        CLK : in std_logic;
        OP_DATA : out std_logic);
    end component;
    
    component renderer is
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
    end component;    
    
    component gameController is
        Port ( 
           reset : in STD_LOGIC;
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
    end component;
    
    component gitTest is
    Port ( a : in STD_LOGIC;
           b : out STD_LOGIC);
    end component;
    
    signal smallClk : std_logic;
    signal clk60 : std_logic;
    
    signal lu : std_logic;
    signal ld : std_logic;
    signal ru : std_logic;
    signal rd : std_logic;
    
    signal bx : integer range 0 to 640;
    signal by : integer range 0 to 480;
    signal ly : integer range 0 to 480;
    signal ry : integer range 0 to 480;
    signal ls : integer range 0 to 99;
    signal rs : integer range 0 to 99;
    signal sco : STD_LOGIC;
    
    signal player1Scores : std_logic;
    signal player2Scores : std_logic;

begin
    debouncerLeftDown : debouncer port map(data => leftDown, clk => clk, op_data => ld);
    debouncerRightUp : debouncer port map(data => rightUp, clk => clk, op_data => ru);
    debouncerLeftUp : debouncer port map(data => leftUp, clk => clk, op_data => lu);
    debouncerRightDown : debouncer port map(data => rightDown, clk => clk, op_data => rd);

    clkDiv : clockdivider port map(clk_in => clk, count_val => 2, clk_out => smallClk);
        
    clkDiv60 : clockdivider port map(clk_in => clk, count_val => 833333, clk_out => clk60);
    
    --Useful for debugging
    --clkDiv10 : clockdivider port map(clk_in => clk, count_val => 5000000, clk_out => clk60);
    
    --git : gitTest port map(a => lu, b => sco);
    
    control : gameController port map(reset => '0', init => '0', lu => lu, ld => ld, ru => ru, 
    rd => rd, clk60 => clk60, ballX => bx, ballY => by, leftPaddleY => ly, rightPaddleY => ry, 
    leftScore => ls, rightScore => rs, player1Scores => player1Scores, player2Scores => player2Scores);
    
    render : renderer port map(leftPaddleY => ly, rightPaddleY => ry, renderBall => '1', ballX => bx,
    ballY => by, leftScore => ls, rightScore => rs, smallClk => smallClk, clk60 => clk60, sw => sw, hSync => hSync,
    vSync => vSync, vgaRed => vgaRed, vgaGreen => vgaGreen, vgaBlue => vgaBlue);
    
end Behavioral;
