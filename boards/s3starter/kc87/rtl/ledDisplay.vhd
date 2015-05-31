library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity ledDisplay is
    generic (
        sysclk : integer := 50000 -- 50MHz
    );
    Port ( 
        clk 		 : in  STD_LOGIC;
		  display    : in   STD_LOGIC_VECTOR (15 downto 0);
        hex_digits : out  STD_LOGIC_VECTOR (3 downto 0);
        hex 		 : out  STD_LOGIC_VECTOR (6 downto 0));
end ledDisplay;

architecture rtl of ledDisplay is
	 signal displayDelay : integer range 0 to sysclk := 0;
	 signal displayDigit : integer range 0 to 3 := 0;
	 signal digit        : std_logic_vector(3 downto 0);
begin
	 process
	 begin
		  wait until rising_edge(clk);
		 
 		  if (displayDelay < sysclk) then
		      displayDelay <= displayDelay + 1;
		  else
				displayDelay <= 0;
				
				if (displayDigit < 3) then
					displayDigit <= displayDigit + 1;
				else
					displayDigit <= 0;
				end if;
		  end if;
	 end process;
	 
	 hex_digits <= "1110" when displayDigit=0 else
				      "1101" when displayDigit=1 else
				      "1011" when displayDigit=2 else
				      "0111";
				  
 	 digit <= display(3 downto 0)  when displayDigit=0 else
				 display(7 downto 4)  when displayDigit=1 else
				 display(11 downto 8) when displayDigit=2 else
				 display(15 downto 12);
	 
    dec : entity work.seg7dec
    port map (
        number => digit,
        digits => hex
    );

end;

