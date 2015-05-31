library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctc_tb is
end ctc_tb;

architecture sim of ctc_tb is
    signal clk      : std_logic := '0';
    signal ctc_d    : std_logic_vector(7 downto 0);
    signal ctcClkTrg : std_logic_vector(3 downto 0) := "0000";
    signal ctcTcTo  : std_logic_vector(3 downto 0);
    signal int      : std_logic_vector(3 downto 0);
    signal kcSysClk : std_logic;
    signal res_n    : std_logic;
    
    type testVectType is record
        ctc_cs_n    : std_logic;
        cpu_do      : std_logic_vector(7 downto 0);
        cpu_addr    : std_logic_vector(1 downto 0);
        m1_n        : std_logic;
        iorq_n      : std_logic;
        rd_n        : std_logic;
        intAck      : std_logic_vector(3 downto 0);
    end record;
    
    signal testVect : testVectType;
begin
    clk <= not clk after 100 ns; 
    res_n <= '0', '1' after 200 ns;
    testVect <= ('1', "00000000", "00", '1', '1', '1', "0000"),
                ('0', "00010000", "00", '1', '0', '1', "0000") after 400 ns, -- irq vector
                ('1', "00000000", "00", '1', '1', '1', "0000") after 600 ns,
                ('0', "10010101", "00", '1', '0', '1', "0000") after 800 ns, -- CH0: int + timer + timeconstant follows + cw
                ('1', "00000000", "00", '1', '1', '1', "0000") after 1000 ns,
                ('0', "00000001", "00", '1', '0', '1', "0000") after 1200 ns, -- timeconstant
                ('1', "00000000", "00", '1', '1', '1', "0000") after 1400 ns,
                ('0', "10010101", "10", '1', '0', '1', "0000") after 1800 ns, -- CH2: int + timer + timeconstant follows + cw
                ('1', "00000000", "10", '1', '1', '1', "0000") after 2000 ns,
                ('0', "00000010", "10", '1', '0', '1', "0000") after 2200 ns, -- timeconstant
                ('1', "00000000", "10", '1', '1', '1', "0000") after 2400 ns,
                ('0', "00000000", "00", '0', '0', '1', "0000") after 29400 ns, -- int ack
                ('1', "00000000", "00", '1', '1', '1', "0000") after 29600 ns, 
                ('1', "11101101", "10", '0', '1', '0', "0000") after 31000 ns, -- reti ED
                ('1', "00000000", "11", '1', '1', '1', "0000") after 31200 ns, 
                ('1', "01001101", "10", '0', '1', '0', "0000") after 31400 ns, -- reti 4D
                ('1', "00000000", "11", '1', '1', '1', "0000") after 32600 ns,
                ('0', "00000000", "00", '0', '0', '1', "0001") after 42000 ns, -- int ack
                ('1', "00000000", "00", '1', '1', '1', "0000") after 42200 ns,
                ('0', "00000000", "00", '0', '0', '1', "0010") after 42400 ns, -- int ack
                ('1', "00000000", "00", '1', '1', '1', "0000") after 42600 ns,
                ('0', "00000000", "00", '0', '0', '1', "0100") after 42800 ns, -- int ack
                ('1', "00000000", "00", '1', '1', '1', "0000") after 43000 ns,
                ('0', "00000000", "00", '0', '0', '1', "1000") after 43200 ns, -- int ack
                ('1', "00000000", "00", '1', '1', '1', "0000") after 43400 ns; 
                
    ctc : entity work.ctc
        generic map(
           sysclk => 10,
           ctcclk => 3
        )
        port map (
            clk     => clk,
            res_n   => res_n,
            en      => testVect.ctc_cs_n,
            
            dIn     => testVect.cpu_do,
            dOut    => ctc_d,
            
            cs      => testVect.cpu_addr(1 downto 0),
            m1      => testVect.m1_n,
            iorq    => testVect.iorq_n,
            rd      => testVect.rd_n,
            
            int     => int,
            intAck  => testVect.intAck,
            clk_trg => ctcClkTrg,
            zc_to   => ctcTcTo,
            kcSysClk => kcSysClk
        );    
end;