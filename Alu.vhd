
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Alu is 
port(

	SrcA,SrcB:in std_logic_vector(31 downto 0);
	AluControl:in std_logic_vector(2 downto 0);
	Zero:out std_logic;
	AluResult:out std_logic_vector(31 downto 0)
	);
end Alu;

architecture arch of Alu is
Signal Intermidiate_result:std_logic_vector(31 downto 0):=(others=>'0');
Begin 

	process(AluControl,SrcA,SrcB)
	Begin
		case(AluControl) is
		
		when "000"=>Intermidiate_result<=SrcA And SrcB;
		when "001"=>Intermidiate_result<=SrcA Or SrcB;
		when "010"=>Intermidiate_result<=std_logic_vector(signed(SrcA) + signed(SrcB));
		--011
		--100
		--101
		when "110"=>Intermidiate_result<=std_logic_vector(signed(SrcA) - signed(SrcB));
		when "111"=>if(signed(SrcA)<signed(SrcB)) then
							Intermidiate_result<=x"00000001";
						else
							Intermidiate_result<=(others=>'0');
						end if;
		when others=>Intermidiate_result<=(others=>'0');
		end case;
	end process;
	AluResult<=Intermidiate_result;
	
	zero<='1' when (Intermidiate_result=x"00000000") else '0';
	

end arch;