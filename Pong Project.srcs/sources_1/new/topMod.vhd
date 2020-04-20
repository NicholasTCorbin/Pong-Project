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
           leftScore : in integer range 0 to 9;
           rightScore : in integer range 0 to 9;
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

    component gameState is
        port (
            clk : in std_logic;
    
            p1goal_i : in std_logic;
            p2goal_i : in std_logic;
            p1goal_o : out std_logic;
            p2goal_o : out std_logic;
    
            p1score_i : in integer range 0 to 99;
            p2score_i : in integer range 0 to 99;
            p1score_o : out integer range 0 to 99;
            p2score_o : out integer range 0 to 99;
    
            ballX : out integer range 0 to 640;
            ballY : out integer range 0 to 480
        );
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
    
    signal counter : integer := 0;
    signal bx : integer range 0 to 640;
    signal by : integer range 0 to 480;
    signal ly : integer range 0 to 480;
    signal ry : integer range 0 to 480;
    signal ls : integer;
    signal rs : integer;
    signal ls_s : integer;
    signal rs_s : integer;
    signal sco : STD_LOGIC;
    
    signal player1Scores : std_logic;
    signal player2Scores : std_logic;

begin

    debouncerLeftDown : debouncer port map(data => leftDown, clk => clk, op_data => ld);
    debouncerRightUp : debouncer port map(data => rightUp, clk => clk, op_data => ru);
    debouncerLeftUp : debouncer port map(data => leftUp, clk => clk, op_data => lu);
    debouncerRightDown : debouncer port map(data => rightDown, clk => clk, op_data => rd);

    -- TODO: sco needs to be split into p1 and p2.
    gameState_pm : gameState port map(clk => clk, p1goal_i => sco, p2goal_i => sco, p1goal_o => sco, p2goal_o => sco,
                                   p1score_i => ls, p2score_i => rs, p1score_o => ls, p2score_o => rs, ballX => bx, ballY => by);

    clkDiv : clockdivider port map(clk_in => clk, count_val => 2, clk_out => smallClk);
        
    clkDiv60 : clockdivider port map(clk_in => clk, count_val => 833333, clk_out => clk60);
    
    --Useful for debugging
    -- clkDiv10 : clockdivider port map(clk_in => clk, count_val => 5000000, clk_out => clk10);
    
    --git : gitTest port map(a => lu, b => sco);
    
    control : gameController port map(reset => '0', init => '0', lu => lu, ld => ld, ru => ru, 
    rd => rd, clk60 => clk60, ballX => bx, ballY => by, leftPaddleY => ly, rightPaddleY => ry, 
    leftScore => ls, rightScore => rs, player1Scores => player1Scores, player2Scores => player2Scores);
    
    render : renderer port map(leftPaddleY => ly, rightPaddleY => ry, renderBall => '1', ballX => bx,
    ballY => by, leftScore => ls_s, rightScore => rs_s, smallClk => smallClk, clk60 => clk60, sw => sw, hSync => hSync,
    vSync => vSync, vgaRed => vgaRed, vgaGreen => vgaGreen, vgaBlue => vgaBlue);

   score_test : process (clk)
   begin
      if rising_edge(clk) then
         if(counter >= 100000000) then
            counter <= 0;
            if(ls_s < 9) then
               ls_s <= ls_s + 1;
            else
               ls_s <= 0;
            end if;
            if(rs_s > 0) then
               rs_s <= rs_s - 1;
            else
               rs_s <= 9;
            end if;
         else
            counter <= counter + 1;
         end if;
      end if;
   end process;
    
end Behavioral;
