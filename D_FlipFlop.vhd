library ieee;
use ieee.std_logic_1164.all;


entity D_FlipFlop is
	generic(
		signal_length:integer:=32
	);
	port(
		clk,aresetn:in std_logic;
		EN:in std_logic;
		D:in std_logic_vector(signal_length-1 downto 0);
		Q:out std_logic_vector(signal_length-1 downto 0)
	);
end D_FlipFlop;


architecture Behavioural of D_FlipFlop is
Begin
		Process(clk,aresetn)
		Begin
			if(aresetn='0') then
				Q<=(others=>'0');
			elsif(rising_edge(clk)) then
				if(EN='1') then
					Q<=D;
				end if;
			end if;
		end process;
	

end Behavioural;