library ieee;
use ieee.std_logic_1164.all;


entity mux21 is
	generic(
		Signal_length:integer:=32
		);
	port(
		sel:in std_logic;
		input0,input1:in std_logic_vector(Signal_length-1 downto 0);
		out_sig:out std_logic_vector(Signal_length -1 downto 0)
		
		);
end mux21;


architecture arch of mux21 is

Begin
	Process(sel,input0,input1)
	Begin
		case(sel) is
		when '0'=>out_sig<=input0;
		when '1'=>out_sig<=input1;
		when others=>out_sig<=(others=>'0');
		end case;
	end process;
end arch;