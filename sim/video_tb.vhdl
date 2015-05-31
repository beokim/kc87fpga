library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity video_tb is
end video_tb;

architecture sim of video_tb is
	signal   clk     : std_logic;
	signal   red     : std_logic_vector(3 downto 0);
	signal   green   : std_logic_vector(3 downto 0);
	signal   blue    : std_logic_vector(3 downto 0);
	signal   hsync   : std_logic;
	signal   vsync   : std_logic;
	signal   ramaddr : std_logic_vector(9 downto 0);
	signal   charData : std_logic_vector(7 downto 0);
	signal   colData : std_logic_vector(7 downto 0);
begin
	video: entity work.video
	   port map (
		  clk     => clk,
		  red     => red,
		  green   => green,
		  blue    => blue,
		  hsync   => hsync,
		  vsync   => vsync,
		  ramAddr => ramaddr,
		  charData => charData,
		  colData => colData
	);	  
	
	vram : entity work.sram
	generic map (
		AddrWidth => 10
	)
	port map (
		clk  => clk,
		addr	=> ramaddr,
		din	=>  ramaddr(7 downto 0),
		dout	=> charData,
		ce_n => '0', 
		we_n => '0'
	);
	
	cram : entity work.sram
	generic map (
		AddrWidth => 10
	)
	port map (
		clk  => clk,
		addr	=> ramaddr,
		din	=>  "11111111",
--		din	=>  ramaddr(9 downto 2),
		dout	=> colData,
		ce_n => '0', 
		we_n => '0'
	);
	
	process
	begin
		clk <= '0';
		wait for 12.5 ns;
		clk <= '1';
		wait for 12.5 ns;
	end process;

end;


