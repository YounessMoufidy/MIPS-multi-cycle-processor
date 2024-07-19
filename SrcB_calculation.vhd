library ieee;
use ieee.std_logic_1164.all;


entity SrcB_calculation is
port(
	clk,aresetn:in std_logic;
	AluSrcB:in std_logic_vector(1 downto 0);
	Read_data_2_after_clock_edge:in std_logic_vector(31 downto 0);
	Branch_immediat:in std_logic_vector(15 downto 0);
	SrcB:out std_logic_vector(31 downto 0)
	);
end SrcB_calculation;

architecture arch of SrcB_calculation is
--shift left
component shift_left_circuit is
	generic(
		signal_length:integer:=32;
		shift_ammount:integer:=2
		);
	port(
		in_sig:in std_logic_vector(31 downto 0);
		out_sig:out std_logic_vector(31 downto 0)
		);
end component;
--mux41
component mux41 is
	generic(
		Signals_length:integer:=32
	);
	port(
		sel:in std_logic_vector(1 downto 0);
		input0,input1,input2,input3:in std_logic_vector(Signals_length -1 downto 0);
		out_sig:out std_logic_vector(Signals_length -1 downto 0)
		);

end component;
--Sign extend
component sign_extend is
	generic(
		in_sig_length:integer:=16;
		out_sig_length:integer:=32
	);
	port(
		in_sig:in std_logic_vector(in_sig_length -1 downto 0);
		out_sig:out std_logic_vector(out_sig_length -1 downto 0)
	
	);
end component;

Signal Read_data_2_after_clock:std_logic_vector(31 downto 0):=(others=>'0');
Signal sign_extend_Branch_immediat:std_logic_vector(31 downto 0):=(others=>'0');
Signal sign_extend_Branch_immediat_after_shif_left:std_logic_vector(31 downto 0):=(others=>'0');

Begin
	
	u2:sign_extend
	generic map(in_sig_length=>16,out_sig_length=>32)
	port map(Branch_immediat,sign_extend_Branch_immediat);
	
	
	u3:shift_left_circuit
	generic map(signal_length=>32,shift_ammount=>2)
	port map(sign_extend_Branch_immediat,sign_extend_Branch_immediat_after_shif_left);
	
	
	u:mux41
	generic map(signals_length=>32)
	port map(AlusrcB,Read_data_2_after_clock,x"00000004",sign_extend_Branch_immediat,sign_extend_Branch_immediat_after_shif_left,SrcB);




end arch;