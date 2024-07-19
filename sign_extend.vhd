library ieee;
use ieee.std_logic_1164.all;


entity sign_extend is
	generic(
		in_sig_length:integer:=16;
		out_sig_length:integer:=32
	);
	port(
		in_sig:in std_logic_vector(in_sig_length -1 downto 0);
		out_sig:out std_logic_vector(out_sig_length -1 downto 0)
	
	);
end sign_extend;

architecture arch of sign_extend is
Signal sign_sig:std_logic_vector(out_sig_length-in_sig_length-1 downto 0);
Begin
	sign_sig<=(others=>in_sig(in_sig'left));
	out_sig<=sign_sig&in_sig;
end arch;
	
