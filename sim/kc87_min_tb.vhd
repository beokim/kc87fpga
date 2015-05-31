library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity kc87_min_tb is
end kc87_min_tb;

architecture sim of kc87_min_tb is
    signal clk          : std_logic := '0';
    signal reset_n      : std_logic := '0';
    signal int_n        : std_logic;
    signal int          : std_logic_vector(2 downto 0) := (others => '1');
    signal m1_n         : std_logic;
    signal mreq_n       : std_logic;
    signal iorq_n       : std_logic;
    signal rd_n         : std_logic;
    signal wr_n         : std_logic;
    signal cpu_addr     : std_logic_vector(15 downto 0);
    signal cpu_do       : std_logic_vector(7 downto 0);
    signal cpu_di       : std_logic_vector(7 downto 0);
    
    signal osRom_d      : std_logic_vector(7 downto 0);
    signal ram_d        : std_logic_vector(7 downto 0);
    signal vram_d       : std_logic_vector(7 downto 0);
    signal cram_d       : std_logic_vector(7 downto 0);
    signal uart_d       : std_logic_vector(7 downto 0);

    signal ctc_d        : std_logic_vector(7 downto 0); 
    signal pio1_d       : std_logic_vector(7 downto 0);
    signal pio2_d       : std_logic_vector(7 downto 0);
    
    signal osRom_cs_n   : std_logic;
    signal ram_cs_n     : std_logic;
    signal vram_cs_n    : std_logic;
    signal cram_cs_n    : std_logic;
    signal ctc_cs_n     : std_logic;
    
    signal pio1_cs_n    : std_logic;
    signal pio2_cs_n    : std_logic;
    
    signal pio1_aIn     : std_logic_vector(7 downto 0);
    signal pio1_aOut    : std_logic_vector(7 downto 0);
    signal pio1_aRdy    : std_logic;
    signal pio1_aStb    : std_logic;
        
    signal pio1_bIn     : std_logic_vector(7 downto 0);
    signal pio1_bOut    : std_logic_vector(7 downto 0);
    signal pio1_bRdy    : std_logic;
    signal pio1_bStb    : std_logic;
    
    signal pio2_aIn     : std_logic_vector(7 downto 0);
    signal pio2_aOut    : std_logic_vector(7 downto 0);
    signal pio2_aRdy    : std_logic;
    signal pio2_aStb    : std_logic;
        
    signal pio2_bIn     : std_logic_vector(7 downto 0);
    signal pio2_bOut    : std_logic_vector(7 downto 0);
    signal pio2_bRdy    : std_logic;
    signal pio2_bStb    : std_logic;
    
    signal iei          : std_logic_vector(2 downto 0);
    signal ieo          : std_logic_vector(2 downto 0);
    
    signal intAckCTC    : std_logic;
    signal intAckPio1   : std_logic;
    signal intAckPio2   : std_logic;
    
    signal ctcTcTo      : std_logic_vector(3 downto 0);
    signal ctcClkTrg    : std_logic_vector(3 downto 0);
    
    signal kcSysClk     : std_logic;
    
    signal Mirror_OS    : std_logic := '1';
    
    signal kmatrixXout  : std_logic_vector(7 downto 0);
    signal kmatrixXin   : std_logic_vector(7 downto 0);
    signal kmatrixYout  : std_logic_vector(7 downto 0);
    signal kmatrixYin   : std_logic_vector(7 downto 0);
    
    signal ioSel        : boolean;
    signal memSel       : boolean;

    signal test1        : boolean;
    signal test2        : boolean;
    signal test3        : boolean;
        
begin
    clk <= not clk after 10 ns;

    reset_n <= '1' after 100 ns;
    
    int_n <= '1' when int="111" else '0';
    
    iei(0) <= '1';
    iei(1) <= ieo(0);
    iei(2) <= ieo(1);
    
    process
    begin
        wait until rising_edge(clk);
        if cpu_addr(15) = '1' then
            Mirror_OS <= '0';
        end if;
    end process;

    memSel   <= mreq_n = '0';
    
    test1 <= cpu_addr>=x"F085" and cpu_addr<=x"F09A" and memSel;
    test2 <= cpu_addr>=x"F09C" and cpu_addr<=x"F0CE" and memSel;
    
    osRom_cs_n <= '0' when (cpu_addr(15 downto 12) = "1111" and memSel) else '1';
    ram_cs_n   <= '0' when (cpu_addr(15 downto 14) = "00" and memSel) else '1';
    cram_cs_n  <= '0' when (cpu_addr(15 downto 10) = "111010") and memSel else '1';
    vram_cs_n  <= '0' when (cpu_addr(15 downto 10) = "111011") and memSel else '1';
    
    ioSel    <= iorq_n = '0';
    
    ctc_cs_n  <= '0' when cpu_addr(7 downto 3) = "10000"  and ioSel else '1';
    pio1_cs_n <= '0' when cpu_addr(7 downto 3) = "10001"  and ioSel else '1';
    pio2_cs_n <= '0' when cpu_addr(7 downto 3) = "10010"  and ioSel else '1';

    cpu_di <=
        osRom_d     when osRom_cs_n = '0' or Mirror_OS = '1' else
        ram_d       when (ram_cs_n = '0') else
        ctc_d       when (ctc_cs_n = '0' or intAckCTC='1') else
        pio1_d      when (pio1_cs_n = '0' or intAckPio1='1') else
        pio2_d      when (pio2_cs_n = '0' or intAckPio2='1') else
        cram_d      when cram_cs_n = '0' else
        vram_d      when vram_cs_n = '0' else
        "00000000";
        
    cpu : entity work.T80se
        generic map(Mode => 1, T2Write => 1, IOWait => 0)
        port map(
            RESET_n => reset_n,
            CLK_n   => clk,
--            CLKEN   => clkEn,
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
            AddrWidth => 14)
        port map(
            clk  => clk,
            addr => cpu_addr(13 downto 0),
            din  => cpu_do,
            dout => ram_D,
            ce_n => ram_cs_n,
            we_n => wr_n
        );

    vram : entity work.dualsram
        generic map (
            AddrWidth => 10
        )
        port map (
            clk1  => clk,
            addr1 => cpu_addr(9 downto 0),
            din1  => cpu_do,
            dout1 => vram_d,
            ce1_n => vram_cs_n, 
            we1_n => wr_n,
             
            clk2  => clk,
            addr2 => (others => '0'),
            din2  => "00000000",
            dout2 => open,
            ce2_n => '0',
            we2_n => '1'
        );
    
    cram : entity work.dualsram
        generic map (
            AddrWidth => 10
        )
        port map (
            clk1  => clk,
            addr1 => cpu_addr(9 downto 0),
            din1  => cpu_do,
            dout1 => cram_d,
            ce1_n => cram_cs_n, 
            we1_n => wr_n,
             
            clk2  => clk,
            addr2 => (others => '0'),
            din2  => "00000000",
            dout2 => open,
            ce2_n => '1',
            we2_n => '1'
        );

    os : entity work.os
    port map (
        clk  => clk,
        addr => cpu_addr(8 downto 0),
        data => osRom_d
    );
        
    ctc : entity work.ctc
        generic map(
            sysclk => 2,
            ctcclk => 1
        )
        port map (
            clk     => clk,
            res_n   => reset_n,
            en      => ctc_cs_n,
            
            dIn     => cpu_do,
            cpuDIn  => cpu_di,
            dOut    => ctc_d,
            
            cs      => cpu_addr(1 downto 0),
            m1      => m1_n,
            iorq    => iorq_n,
            rd      => rd_n,
            
            ieo     => ieo(0),
            iei     => iei(0),
            int     => int(0),
            intAck  => intAckCTC,
            clk_trg => ctcClkTrg,
            zc_to   => ctcTcTo,
            kcSysClk => kcSysClk
        );
    
    ctcClkTrg(2 downto 0) <= (others => '0');
    ctcClkTrg(3) <= ctcTcTo(2);
    
    -- System PIO
    pio1 : entity work.pio
        port map (
            clk   => clk,
            res_n => reset_n,
            en    => '1',
            dIn   => cpu_do,
            dOut  => pio1_d,
            cpuDIn => cpu_di,
            baSel => cpu_addr(0),
            cdSel => cpu_addr(1),
            ce    => pio1_cs_n,
            m1    => m1_n,
            iorq  => iorq_n,
            rd    => rd_n,
            ieo   => ieo(1),
            iei   => iei(1),
            intAck => intAckPio1,
            int   => int(1),
            aIn   => pio1_aIn,
            aOut  => pio1_aOut,
            aRdy  => pio1_aRdy,
            aStb  => pio1_aStb,
            bIn   => pio1_bIn,
            bOut  => pio1_bOut,
            bRdy  => pio1_bRdy,
            bStb  => '1'
        );
        
    -- Keyboard PIO
    pio2 : entity work.pio
        port map (
            clk   => clk,
            res_n => reset_n,
            en    => '1',
            dIn   => cpu_do,
            dOut  => pio2_d,
            cpuDIn => cpu_di,
            baSel => cpu_addr(0),
            cdSel => cpu_addr(1),
            ce    => pio2_cs_n,
            m1    => m1_n,
            iorq  => iorq_n,
            rd    => rd_n,
            ieo   => ieo(2),
            iei   => iei(2),
            intAck => intAckPio2,
            int   => int(2),
            aIn   => kmatrixXout,
            aOut  => kmatrixXin,
            aRdy  => pio2_aRdy,
            aStb  => '1',
            bIn   => kmatrixYout,
            bOut  => kmatrixYin,
            bRdy  => pio2_bRdy,
            bStb  => '1'
        );
        
    kmatrixYout <= "11111110" when kmatrixXin(0)='0' else "11111111";
    kmatrixXout(7 downto 4) <= "1111";
    kmatrixXout(3 downto 0) <= "0111";
    
end;

