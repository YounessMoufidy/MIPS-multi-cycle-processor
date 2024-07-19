library ieee;
use ieee.std_logic_1164.all;

entity programcounter is

	port(
		clk,aresetn:in std_logic;
		PcSrc:in std_logic_vector(1 downto 0);
		PCEN:in std_logic;
		AluOut:in std_logic_vector(31 downto 0);
		AluResult:in std_logic_vector(31 downto 0);
		Jump_immediat:in std_logic_vector(25 downto 0);
		--old_pc:Buffer  std_logic_vector(31 downto 0);
		current_pc:Buffer std_logic_vector(31 downto 0)
		);
		
end programcounter;

architecture behavioral of programcounter is
--Mux41
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
--D flip flop
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
--shift_left_circuit
component shift_left_circuit is
	generic(
		signal_length:integer:=32;
		shift_ammount:integer:=2
		);
	port(
		in_sig:in std_logic_vector(signal_length -1 downto 0);
		out_sig:out std_logic_vector(signal_length -1 downto 0)
		);
end component;
--sign_extend
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

--Signal Aluout:std_logic_vector(31 downto 0);
Signal Jump_immediat_after_sign_extend:std_logic_vector(27 downto 0):=(others=>'0');
Signal Jump_immediat_after_shift_left:std_logic_vector(27 downto 0):=(others=>'0');
Signal Jump_immediat_after_concatenation:std_logic_vector(31 downto 0):=(others=>'0');
Signal new_pc:std_logic_vector(31 downto 0):=(others=>'0');
Signal calculated_pc:std_logic_vector(31 downto 0):=(others=>'0');

Begin
	
	Jump_immediat_after_concatenation<=calculated_pc(31 downto 28)&Jump_immediat_after_shift_left;
	
	
	
	u1:sign_extend
	generic map(in_sig_length=>26,out_sig_length=>28)
	port map(Jump_immediat,Jump_immediat_after_sign_extend);
	
	
	
	u2:shift_left_circuit
	generic map(signal_length=>28,shift_ammount=>2)
	port map(Jump_immediat_after_sign_extend,Jump_immediat_after_shift_left);
	
	u3:mux41
	generic map(Signals_length=>32)
	port map(PcSrc,AluResult,Aluout,Jump_immediat_after_concatenation,x"00000000",new_pc);
	
	u4:D_FlipFlop
	generic map(signal_length=>32)
	port map(clk,aresetn,PCEN,new_pc,calculated_pc);
	--old_pc<=calculated_pc;
	current_pc<=calculated_pc;
end behavioral;