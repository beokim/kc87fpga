library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity intController_tb is
end intController_tb;

architecture sim of intController_tb is
    signal clk      : std_logic := '0';
    signal reset_n  : std_logic := '0';
    signal int_n    : std_logic;
    signal intAck   : std_logic_vector(7 downto 0);
    
    type testVectType is record
        intPeriph   : std_logic_vector(7 downto 0);
        cpuDIn      : std_logic_vector(7 downto 0);
        m1_n        : std_logic;
        iorq_n      : std_logic;
        rd_n        : std_logic;
    end record;
  
    signal testVect : testVectType;
begin
    clk <= not clk after 10 ns;

    reset_n <= '1' after 100 ns;
    
    testVect <= ("00000000", "00000000", '1', '1', '1' ),
                ("00000001", "00000000", '1', '1', '1' ) after 200 ns, -- int 0
                ("00000010", "00000000", '1', '1', '1' ) after 400 ns, -- int 1
                ("00000000", "00000000", '1', '1', '1' ) after 600 ns,
                ("00000000", "00000000", '0', '0', '1' ) after 800 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 1000 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 1200 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 1400 ns,
                ("00000000", "11101101", '0', '1', '0' ) after 1600 ns, -- reti ED
                ("00000000", "00000000", '1', '1', '1' ) after 1800 ns,
                ("00000000", "01001101", '0', '1', '0' ) after 2000 ns, -- reti 4D
                ("00000000", "00000000", '1', '1', '1' ) after 2200 ns,
                ("00000000", "11101101", '0', '1', '0' ) after 2400 ns, -- reti ED
                ("00000000", "00000000", '1', '1', '1' ) after 2600 ns,
                ("00000000", "01001101", '0', '1', '0' ) after 2800 ns, -- reti 4D
                ("00000000", "00000000", '1', '1', '1' ) after 3000 ns,
                ("00001111", "00000000", '1', '1', '1' ) after 3200 ns, -- int 0-3
                ("11110000", "00000000", '1', '1', '1' ) after 3400 ns, -- int 4-7
                ("00000000", "00000000", '1', '1', '1' ) after 3600 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 3800 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 4000 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 4200 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 4400 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 4600 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 4800 ns, 
                ("00000000", "11101101", '0', '1', '0' ) after 5000 ns, -- reti ED      
                ("00000000", "00000000", '1', '1', '1' ) after 5200 ns,
                ("00000000", "01001101", '0', '1', '0' ) after 5400 ns, -- reti 4D
                ("00000000", "00000000", '1', '1', '1' ) after 5600 ns,
                ("00000000", "00000000", '0', '0', '1' ) after 5800 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 6000 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 6200 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 6400 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 6600 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 6800 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 7000 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 7200 ns, 
                ("00000000", "00000000", '0', '0', '1' ) after 7400 ns, -- int ack
                ("00000000", "00000000", '1', '1', '1' ) after 7600 ns; 
    
    intController : entity work.intController
    port map (
        clk       => clk,
        res       => reset_n,
        int       => int_n,
        intPeriph => testVect.intPeriph,
        intAck    => intAck,
        cpuDIn    => testVect.cpuDIn,
        m1        => testVect.m1_n,
        iorq      => testVect.iorq_n,
        rd        => testVect.rd_n
  );
    
end;
