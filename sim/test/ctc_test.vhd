library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity os_ctc is
    generic(
        AddrWidth   : integer := 7
    );
    port (
        clk  : in std_logic;
        addr : in std_logic_vector(AddrWidth-1 downto 0);
        data : out std_logic_vector(7 downto 0)
    );
end os_ctc;

architecture rtl of os_ctc is
    type rom128x8 is array (0 to 2**AddrWidth-1) of std_logic_vector(7 downto 0); 
    constant romData : rom128x8 := (
         x"c3",  x"10",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0000
         x"40",  x"00",  x"4b",  x"00",  x"56",  x"00",  x"61",  x"00", -- 0008
         x"31",  x"00",  x"42",  x"3e",  x"00",  x"ed",  x"47",  x"ed", -- 0010
         x"5e",  x"3e",  x"08",  x"d3",  x"80",  x"3e",  x"97",  x"d3", -- 0018
         x"80",  x"d3",  x"81",  x"d3",  x"82",  x"d3",  x"83",  x"3e", -- 0020
         x"02",  x"d3",  x"80",  x"3c",  x"d3",  x"81",  x"3c",  x"d3", -- 0028
         x"82",  x"3c",  x"d3",  x"83",  x"fb",  x"21",  x"08",  x"40", -- 0030
         x"ed",  x"73",  x"0a",  x"40",  x"34",  x"c3",  x"38",  x"00", -- 0038
         x"f5",  x"e5",  x"21",  x"00",  x"40",  x"34",  x"e1",  x"f1", -- 0040
         x"fb",  x"ed",  x"4d",  x"f5",  x"e5",  x"21",  x"02",  x"40", -- 0048
         x"34",  x"e1",  x"f1",  x"fb",  x"ed",  x"4d",  x"f5",  x"e5", -- 0050
         x"21",  x"04",  x"40",  x"34",  x"e1",  x"f1",  x"fb",  x"ed", -- 0058
         x"4d",  x"f5",  x"e5",  x"21",  x"06",  x"40",  x"34",  x"e1", -- 0060
         x"f1",  x"fb",  x"ed",  x"4d",  x"00",  x"00",  x"00",  x"00", -- 0068
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00", -- 0070
         x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00",  x"00"  -- 0078
        );
    
begin
    process begin
        wait until rising_edge(clk);
        data <= romData(to_integer(unsigned(addr)));
    end process;
end;
