library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
 
entity debouncer is
Port (
    DATA: in std_logic;
    CLK : in std_logic;
    OP_DATA : out std_logic);
end debouncer ;
 
architecture Behavioral of debouncer is
 
Signal OP1, OP2, OP3: std_logic;
 
begin
Process(CLK) 
begin
    If rising_edge(CLK) then
        OP1 <= DATA;
        OP2 <= OP1;
        OP3 <= OP2;
    end if;
end process;
OP_DATA <= OP1 and OP2 and OP3; 
end Behavioral;
