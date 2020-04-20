library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity topMod is
	port (
		clk : in std_logic;
		sw : in std_logic;
		leftUp : in std_logic;
		leftDown : in std_logic;
		rightUp : in std_logic;
		rightDown : in std_logic;
		btnC : in std_logic;

		vgaRed : out std_logic_vector (3 downto 0);
		vgaBlue : out std_logic_vector (3 downto 0);
		vgaGreen : out std_logic_vector (3 downto 0);
		hSync : out std_logic;
		vSync : out std_logic);
end topMod;


architecture Behavioral of topMod is
	-- Divides clock signal for use by renderer and game controller
	component clockdivider is
		port (
			clk_in : in std_logic;
			count_val : in integer range 0 to 1000000000;
			clk_out : out std_logic);
	end component;

	-- Debounces button signals
	component debouncer is
		port (
			DATA : in std_logic;
			CLK : in std_logic;
			OP_DATA : out std_logic);
	end component;

	-- Renders game state to VGA output
	component renderer is
		port (
			leftPaddleY : in integer range 0 to 480;
			rightPaddleY : in integer range 0 to 480;
			renderBall : in std_logic;
			ballX : in integer range 0 to 640;
			ballY : in integer range 0 to 480;
			leftScore : in integer range 0 to 9;
			rightScore : in integer range 0 to 9;
			smallClk : in std_logic;
			clk60 : in std_logic;
			sw : in std_logic;
			hSync : out std_logic;
			vSync : out std_logic;
			vgaRed : out std_logic_vector (3 downto 0);
			vgaGreen : out std_logic_vector (3 downto 0);
			vgaBlue : out std_logic_vector (3 downto 0));
	end component;

	-- Manages game controls
	component gameController is
		port (
			reset : in std_logic;
			init : in std_logic;
			lu : in std_logic;
			ld : in std_logic;
			ru : in std_logic;
			rd : in std_logic;
			clk60 : in std_logic;
			ballX : out integer range 0 to 640;
			ballY : out integer range 0 to 480;
			leftPaddleY : out integer range 0 to 480;
			rightPaddleY : out integer range 0 to 480;
			leftScore : out integer range 0 to 99;
			rightScore : out integer range 0 to 99;
			player1Scores : out std_logic;
			player2Scores : out std_logic);
	end component;

	-- Manages game state with finite state machine
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
			ballY : out integer range 0 to 480);
	end component;

	-- Git debug test
	component gitTest is
		port (
			a : in std_logic;
			b : out std_logic);
	end component;

	-- Clock signals
	signal smallClk : std_logic;
	signal clk60 : std_logic;

	-- Debounced paddle control signals
	signal lu : std_logic;
	signal ld : std_logic;
	signal ru : std_logic;
	signal rd : std_logic;
	signal center : std_logic;

	-- Ball coordinates
	signal bx : integer range 0 to 640;
	signal by : integer range 0 to 480;
	-- Paddle vertical position
	signal ly : integer range 0 to 480;
	signal ry : integer range 0 to 480;
	-- Player scores
	signal ls : integer;
    signal rs : integer;
    -- Score debug test
	signal ls_s : integer;
	signal rs_s : integer;
	signal counter : integer := 0;

	-- Signals flagging goals
	signal sco : std_logic;
	signal p1sco : std_logic;
	signal p2sco : std_logic;


begin
	--Useful for debugging
	-- clkDiv10 : clockdivider port map(clk_in => clk, count_val => 5000000, clk_out => clk10);
	--git : gitTest port map(a => lu, b => sco);

	-- Clock divider port maps
	clkDiv : clockdivider port map(clk_in => clk, count_val => 2, clk_out => smallClk);
	clkDiv60 : clockdivider port map(clk_in => clk, count_val => 833333, clk_out => clk60);

	-- Debouncer port maps
	debouncerLeftDown : debouncer port map(data => leftDown, clk => clk, op_data => ld);
	debouncerRightUp : debouncer port map(data => rightUp, clk => clk, op_data => ru);
	debouncerLeftUp : debouncer port map(data => leftUp, clk => clk, op_data => lu);
	debouncerRightDown : debouncer port map(data => rightDown, clk => clk, op_data => rd);
	debouncerCenter : debouncer port map(data => btnC, clk => clk, op_data => center);

	-- Game state port map
	gameState_pm : gameState port map(
		clk => clk, p1goal_i => p1sco, p2goal_i => p2sco, p1goal_o => p1sco, p2goal_o => p2sco,
		p1score_i => ls, p2score_i => rs, p1score_o => ls, p2score_o => rs,
		ballX => bx, ballY => by);
	-- Game controller port map
	control : gameController port map(
        reset => '0', init => center, lu => lu, ld => ld, ru => ru, rd => rd, clk60 => clk60,
        ballX => bx, ballY => by, leftPaddleY => ly, rightPaddleY => ry,
		leftScore => ls, rightScore => rs, player1Scores => p1sco, player2Scores => p2sco);
	-- Renderer port map
	render : renderer port map(
        leftPaddleY => ly, rightPaddleY => ry, renderBall => '1', ballX => bx, ballY => by,
        leftScore => ls_s, rightScore => rs_s, smallClk => smallClk, clk60 => clk60,
        sw => sw, hSync => hSync, vSync => vSync,
        vgaRed => vgaRed, vgaGreen => vgaGreen, vgaBlue => vgaBlue);

    -- Score debug test
	score_test : process (clk)
	begin
		if rising_edge(clk) then
			if (counter >= 100000000) then
                counter <= 0;
                
				if (ls_s < 9) then
					ls_s <= ls_s + 1;
				else
					ls_s <= 0;
                end if;
                
				if (rs_s > 0) then
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