library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity shift_left_circuit is
	generic(
		signal_length:integer:=32;
		shift_ammount:integer:=2
		);
	port(
		in_sig:in std_logic_vector(signal_length -1 downto 0);
		out_sig:out std_logic_vector(signal_length -1 downto 0)
		);
end shift_left_circuit;

architecture arch of shift_left_circuit is
Begin
	out_sig<=std_logic_vector((shift_left(unsigned(in_sig),shift_ammount)));
	
end arch;