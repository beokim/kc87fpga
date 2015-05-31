--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:55:51 05/25/2015
-- Design Name:   
-- Module Name:   E:/source/altera/kc87/boards/s3/KC87/sim/kc87_tb.vhd
-- Project Name:  KC87
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: kc87
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY kc87_tb IS
END kc87_tb;
 
ARCHITECTURE behavior OF kc87_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT kc87
    PORT(
         CLOCK_50 : IN  std_logic;
         VGA_R : OUT  std_logic;
         VGA_G : OUT  std_logic;
         VGA_B : OUT  std_logic;
         VGA_HS : OUT  std_logic;
         VGA_VS : OUT  std_logic;
         SRAM_ADDR : OUT  std_logic_vector(17 downto 0);
         SRAM_DQ : INOUT  std_logic_vector(15 downto 0);
         SRAM_OE_N : OUT  std_logic;
         SRAM_CE_N : OUT  std_logic;
         SRAM_WE_N : OUT  std_logic;
         SRAM_LB_N : OUT  std_logic;
         SRAM_UB_N : OUT  std_logic;
         PS2_CLK : INOUT  std_logic;
         PS2_DAT : INOUT  std_logic;
         UART_TXD : OUT  std_logic;
         UART_RXD : IN  std_logic;
         KEY : IN  std_logic_vector(3 downto 0);
         SW : IN  std_logic_vector(7 downto 0);
         LEDR : OUT  std_logic_vector(7 downto 0);
         HEX : OUT  std_logic_vector(6 downto 0);
         HEX_AN : OUT  std_logic_vector(3 downto 0);
         SD_DAT : IN  std_logic;
         SD_DAT3 : OUT  std_logic;
         SD_CMD : OUT  std_logic;
         SD_CLK : OUT  std_logic;
         GPIO_1 : OUT  std_logic_vector(9 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal CLOCK_50 : std_logic := '0';
   signal UART_RXD : std_logic := '0';
   signal KEY : std_logic_vector(3 downto 0) := (others => '1');
   signal SW : std_logic_vector(7 downto 0) := (others => '1');
   signal SD_DAT : std_logic := '0';

	--BiDirs
   signal SRAM_DQ : std_logic_vector(15 downto 0);
   signal PS2_CLK : std_logic;
   signal PS2_DAT : std_logic;

 	--Outputs
   signal VGA_R : std_logic;
   signal VGA_G : std_logic;
   signal VGA_B : std_logic;
   signal VGA_HS : std_logic;
   signal VGA_VS : std_logic;
   signal SRAM_ADDR : std_logic_vector(17 downto 0);
   signal SRAM_OE_N : std_logic;
   signal SRAM_CE_N : std_logic;
   signal SRAM_WE_N : std_logic;
   signal SRAM_LB_N : std_logic;
   signal SRAM_UB_N : std_logic;
   signal UART_TXD : std_logic;
   signal LEDR : std_logic_vector(7 downto 0);
   signal HEX : std_logic_vector(6 downto 0);
   signal HEX_AN : std_logic_vector(3 downto 0);
   signal SD_DAT3 : std_logic;
   signal SD_CMD : std_logic;
   signal SD_CLK : std_logic;
   signal GPIO_1 : std_logic_vector(9 downto 0);

   -- Clock period definitions
   constant CLOCK_50_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: kc87 PORT MAP (
          CLOCK_50 => CLOCK_50,
          VGA_R => VGA_R,
          VGA_G => VGA_G,
          VGA_B => VGA_B,
          VGA_HS => VGA_HS,
          VGA_VS => VGA_VS,
          SRAM_ADDR => SRAM_ADDR,
          SRAM_DQ => SRAM_DQ,
          SRAM_OE_N => SRAM_OE_N,
          SRAM_CE_N => SRAM_CE_N,
          SRAM_WE_N => SRAM_WE_N,
          SRAM_LB_N => SRAM_LB_N,
          SRAM_UB_N => SRAM_UB_N,
          PS2_CLK => PS2_CLK,
          PS2_DAT => PS2_DAT,
          UART_TXD => UART_TXD,
          UART_RXD => UART_RXD,
          KEY => KEY,
          SW => SW,
          LEDR => LEDR,
          HEX => HEX,
          HEX_AN => HEX_AN,
          SD_DAT => SD_DAT,
          SD_DAT3 => SD_DAT3,
          SD_CMD => SD_CMD,
          SD_CLK => SD_CLK,
          GPIO_1 => GPIO_1
        );

   -- Clock process definitions
   CLOCK_50_process :process
   begin
		CLOCK_50 <= '0';
		wait for CLOCK_50_period/2;
		CLOCK_50 <= '1';
		wait for CLOCK_50_period/2;
   end process;
 
   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      wait for 100 ns;	

      wait for CLOCK_50_period*10;

      -- insert stimulus here 

      wait;
   end process;

END;
