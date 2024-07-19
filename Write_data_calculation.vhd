library ieee;
use ieee.std_logic_1164.all;


entity Write_data_calculation is
port(
	clk,aresetn:in std_logic;
	Mem_to_reg:in std_logic;
	Alu_out:in std_logic_vector(31 downto 0);
	--Data out from data memory
	Data_out:in std_logic_vector(31 downto 0);
	write_data_to_reg_file:out std_logic_vector(31 downto 0)
	);
end Write_data_calculation;


architecture arch of Write_data_calculation is



	component D_FlipFlop is
		generic(
			signal_length:integer:=32
		);
		port(
			clk,aresetn:in std_logic;
			EN:in std_logic;
			D:in std_logic_vector(signal_length-1 downto 0);
			Q:out std_logic_vector(signal_length-1 downto 0)
		);
	end component;

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
Signal D_flip_flop_out:std_logic_vector(31 downto 0);
Begin
	u1:D_FlipFlop
	generic map(signal_length=>32)
	port map(clk,aresetn,'1',Data_out,D_flip_flop_out);
	
	u2:mux21
	generic map(signal_length=>32)
	port map(Mem_to_reg,Alu_out,D_flip_flop_out,write_data_to_reg_file);
end arch;
	
	
	
	
	
	
	
	
