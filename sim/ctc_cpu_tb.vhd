library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ctc_cpu_tb is
end ctc_cpu_tb;

architecture sim of ctc_cpu_tb is
    signal clk      : std_logic := '0';
    signal reset_n  : std_logic := '0';
    signal int_n    : std_logic;
    signal m1_n     : std_logic;
    signal mreq_n   : std_logic;
    signal rfsh_n   : std_logic;
    signal iorq_n   : std_logic;
    signal rd_n     : std_logic;
    signal wr_n     : std_logic;
    signal cpu_addr : std_logic_vector(15 downto 0);
    signal cpu_di   : std_logic_vector(7 downto 0);
    signal cpu_do   : std_logic_vector(7 downto 0);
    
    signal ctcClkTrg : std_logic_vector(3 downto 0) := "0000";
    signal ctcTcTo  : std_logic_vector(3 downto 0);
    signal kcSysClk : std_logic;
    
    signal intAckV  : std_logic_vector(7 downto 0);
    signal intAck   : std_logic;
    signal int      : std_logic_vector(7 downto 0) := "00000000";

    signal osRom_d  : std_logic_vector(7 downto 0);
    signal ram_d    : std_logic_vector(7 downto 0);
    signal ctc_d    : std_logic_vector(7 downto 0);
    
    signal ram_cs_n : std_logic;
    signal osRom_cs_n : std_logic;
    signal ctc_cs_n : std_logic;
    
    signal memSel   : boolean;
    signal ioSel    : boolean;
    signal intAckCTC : std_logic;
    
    signal clkEn    : std_logic := '0';
begin
    clk <= not clk after 10 ns;
    clkEn <= not clkEn  after 20 ns;
    
    reset_n <= '1' after 50 ns;
    
    intAck <= '0' when intAckV="00000000" else '1';
    
    ioSel    <= iorq_n = '0';
    ctc_cs_n  <= '0' when cpu_addr(7 downto 3) = "10000"  and ioSel else '1';
    
    memSel   <= mreq_n = '0';
    ram_cs_n   <= '0' when (cpu_addr(15 downto 12) = "0100" and memSel) else '1';
    osRom_cs_n <= '0' when (cpu_addr(15 downto 12) = "0000" and memSel) else '1';
    
    intAckCTC  <= '0' when intAckV(3 downto 0)="0000" else '1';
    
    cpu_di <=
            ctc_d       when (ctc_cs_n = '0' or intAckCTC='1') else
            osRom_d     when osRom_cs_n = '0'else
            ram_d       when ram_cs_n='0' else
            "00000000";
        
      cpu : entity work.T80se
        generic map(Mode => 1, T2Write => 1, IOWait => 0)
        port map(
            RESET_n => reset_n,
            CLK_n   => clk,
            CLKEN   => clkEn,
            WAIT_n  => '1',
            INT_n   => int_n,
            NMI_n   => '1',
            BUSRQ_n => '1',
            M1_n    => m1_n,
            MREQ_n  => mreq_n,
            IORQ_n  => iorq_n,
            RD_n    => rd_n,
            WR_n    => wr_n,
            RFSH_n  => rfsh_n,
            HALT_n  => open,
            BUSAK_n => open,
            A       => cpu_addr,
            DI      => cpu_di,
            DO      => cpu_do
        );
  
     ram : entity work.sram
        generic map(
            AddrWidth => 12)
        port map(
            clk  => clk,
            addr => cpu_addr(11 downto 0),
            din  => cpu_do,
            dout => ram_d,
            ce_n => ram_cs_n,
            we_n => wr_n
        );
        
    os : entity work.os_ctc
    port map (
        clk  => clk,
        addr => cpu_addr(6 downto 0),
        data => osRom_d
    );
    
    intController : entity work.intController
    port map (
        clk       => clk,
        res       => reset_n,
        int       => int_n,
        intPeriph => int,
        intAck    => intAckV,
        cpuDIn    => cpu_di,
        m1        => m1_n,
        iorq      => iorq_n,
        rd        => rd_n
    );
    
    ctc : entity work.ctc
    generic map(
        sysclk => 10,
        ctcclk => 3
    )
    port map (
        clk     => clk,
        res_n   => reset_n,
        en      => ctc_cs_n,
           
        dIn     => cpu_do,
        dOut    => ctc_d,
            
        cs      => cpu_addr(1 downto 0),
        m1      => m1_n,
        iorq    => iorq_n,
        rd      => rd_n,
            
        int     => int(3 downto 0),
        intAck  => intAckV(3 downto 0),
        clk_trg => ctcClkTrg,
        zc_to   => ctcTcTo,
        kcSysClk => kcSysClk
     );   
end;
