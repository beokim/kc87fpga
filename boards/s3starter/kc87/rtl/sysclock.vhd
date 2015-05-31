library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity sysclock is
    Port ( inclk0 : in  STD_LOGIC;
           c0 : out  STD_LOGIC;
           c1 : out  STD_LOGIC;
           locked : out  STD_LOGIC);
end sysclock;

architecture Behavioral of sysclock is

begin
    clock : entity work.xclock
    port map (
        CLKIN_IN        => inclk0,
        CLKFX_OUT       => c0,
		  CLK0_OUT			=> c1,
--        CLKDV_OUT			=> c1,
        LOCKED_OUT      => locked
    );

end Behavioral;

