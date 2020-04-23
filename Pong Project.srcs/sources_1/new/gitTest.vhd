----------------------------------------------------------------------------------
-- Additional Comments: Used to make sure that git workded on the pro
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity gitTest is
    Port ( a : in STD_LOGIC;
           b : out STD_LOGIC);
end gitTest;

architecture Behavioral of gitTest is

begin
    b <= not a;

end Behavioral;
