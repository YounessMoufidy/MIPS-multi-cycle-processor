library ieee;
use ieee.std_logic_1164.all;


entity tb_mips_multi_cycle is
end tb_mips_multi_cycle;


architecture Behavioral of tb_mips_multi_cycle is

component mips_multi_cycle is
	
	port(
		aresetn:in std_logic;
		clk:in std_logic);



end component;
Signal clk,aresetn: std_logic;
Signal clk_time:time:=50 ns;
Begin
	
	DUT:mips_multi_cycle
	port map(aresetn,clk);
	reset_process:process
	begin
		aresetn<='0';
		wait for 5 ns;
		aresetn<='1';
		wait for 600 ns;
	
	end process reset_process;
	
	clk_process:process
	begin
		clk<='0';
		wait for clk_time/2;
		clk<='1';
		wait for clk_time/2;	
	end process clk_process;

	
	



end Behavioral;