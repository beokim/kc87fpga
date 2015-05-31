library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity intController_cpu_tb is
end intController_cpu_tb;

architecture sim of intController_cpu_tb is
    signal clk      : std_logic := '0';
    signal reset_n  : std_logic := '0';
    signal int_n    : std_logic;
    signal m1_n     : std_logic;
    signal mreq_n   : std_logic;
    signal iorq_n   : std_logic;
    signal rd_n     : std_logic;
    signal wr_n     : std_logic;
    signal cpu_addr : std_logic_vector(15 downto 0);
    signal cpu_di   : std_logic_vector(7 downto 0);
    signal cpu_do   : std_logic_vector(7 downto 0);
    
    signal intAckV  : std_logic_vector(7 downto 0);
    signal intAck   : std_logic;
    signal int      : std_logic_vector(7 downto 0);

    signal Mirror_OS : std_logic := '1';
    signal osRom_d  : std_logic_vector(7 downto 0);
    signal ram_d    : std_logic_vector(7 downto 0);
    signal ram_cs_n : std_logic;
    signal osRom_cs_n : std_logic;

    signal memSel   : boolean;

begin
    clk <= not clk after 10 ns;
    reset_n <= '1' after 50 ns;
    
    process
    begin
        wait until rising_edge(clk);
        if cpu_addr(15) = '1' then
            Mirror_OS <= '0';
        end if;
    end process;
    
    intAck <= '0' when intAckV="00000000" else '1';
    
    memSel   <= mreq_n = '0';
    ram_cs_n   <= '0' when (cpu_addr(15 downto 12) = "0000" and memSel) else '1';
    osRom_cs_n <= '0' when (cpu_addr(15 downto 12) = "1111" and memSel) else '1';
    
    cpu_di <=
            "00000000"  when intAck='1' else
            osRom_d     when osRom_cs_n = '0' or Mirror_OS = '1' else
            ram_d       when ram_cs_n='0' else
            "00000000";
        
      cpu : entity work.T80se
        generic map(Mode => 1, T2Write => 1, IOWait => 0)
        port map(
            RESET_n => reset_n,
            CLK_n   => clk,
            CLKEN   => '1',
            WAIT_n  => '1',
            INT_n   => int_n,
            NMI_n   => '1',
            BUSRQ_n => '1',
            M1_n    => m1_n,
            MREQ_n  => mreq_n,
            IORQ_n  => iorq_n,
            RD_n    => rd_n,
            WR_n    => wr_n,
            RFSH_n  => open,
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
        
    os : entity work.os
    port map (
        clk  => clk,
        addr => cpu_addr(5 downto 0),
        data => osRom_d
    );
    
    int <= "11111111",
      "00000000" after 100 ns,
      "00001111" after 11000 ns,
      "00000000" after 11020 ns,
      "00010001" after 18000 ns,
      "00000000" after 18020 ns,
      "00000111" after 21400 ns,
      "00000000" after 21420 ns,
      "11000000" after 40000 ns,
      "00110000" after 40020 ns,
      "00001100" after 40040 ns,
      "00000011" after 40060 ns,
      "00000000" after 40080 ns,
      "00000001" after 54400 ns;
    
      
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
end;
