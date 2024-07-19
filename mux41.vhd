library ieee;
use ieee.std_logic_1164.all;


entity mux41 is
	generic(
		Signals_length:integer:=32
	);
	port(
		sel:in std_logic_vector(1 downto 0);
		input0,input1,input2,input3:in std_logic_vector(Signals_length -1 downto 0);
		out_sig:out std_logic_vector(Signals_length -1 downto 0)
		);

end mux41;

architecture Behavioural of mux41 is 
Begin
	Process(sel,input0,input1,input2,input3)
	Begin
		case(sel) is
		
			when "00"=>out_sig<=input0;
			when "01"=>out_sig<=input1;
			when "10"=>out_sig<=input2;
			when "11"=>out_sig<=input3;
			when others=>out_sig<=(others=>'0');
		
		end case;
	end process;
end Behavioural;

