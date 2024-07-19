library ieee;
use ieee.std_logic_1164.all;


entity SrcA_calculation is

port(
	clk,aresetn:in std_logic;
	AluSrcA:in std_logic;
	current_pc:in std_logic_vector(31 downto 0);
	read_data1_after_clock_edge:in std_logic_vector(31 downto 0);
	SrcA:out std_logic_vector(31 downto 0)

	);
end SrcA_calculation;


architecture arch of SrcA_calculation is
	component mux21 is
	generic(
		Signal_length:integer:=32
		);
	port(
		sel:in std_logic;
		input0,input1:in std_logic_vector(Signal_length-1 downto 0);
		out_sig:out std_logic_vector(Signal_length -1 downto 0)
		
		);
	end component;

--	component D_FlipFlop is
--		generic(
--			signal_length:integer:=32
--		);
--		port(
--			clk,aresetn:in std_logic;
--			EN:in std_logic;
--			D:in std_logic_vector(signal_length-1 downto 0);
--			Q:out std_logic_vector(signal_length-1 downto 0)
--		);
--	end component;
	--Signal read_data1_after_clock_edge:std_logic_vector(31 downto 0);
	Begin
--		u1:D_FlipFlop
--		generic map(signal_length=>32)
--		port map(clk,aresetn,'1',read_data1,read_data1_after_clock_edge);
		
		u2:mux21
		generic map(Signal_length=>32)
		port map(AluSrcA,current_pc,read_data1_after_clock_edge,SrcA);
		





end arch;