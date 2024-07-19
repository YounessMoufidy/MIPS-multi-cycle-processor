library ieee;
use ieee.std_logic_1164.all;


entity Alu_decoder is
	port(
		Alu_op:in std_logic_vector(1 downto 0);
		function_field:in std_logic_vector(5 downto 0);
		Alu_control:out std_logic_vector(2 downto 0)
		);
end Alu_decoder;


architecture Behavioral of Alu_decoder is
Begin
	Process(Alu_op,function_field)
	Begin
		case(Alu_op) is
			when "00"=>Alu_control<="010";--lw/sw
			when "01"=>Alu_control<="110";--sub
			when "10"=>if(function_field="100000") then --R type
								Alu_control<="010";--addition
							elsif(function_field="100010") then
								Alu_control<="110";--substraction
							elsif(function_field="100100") then
								Alu_control<="000";--AND
							elsif(function_field="100101") then
								Alu_control<="001";--or
							elsif(function_field="101010") then
								Alu_control<="111";--slt
							end if;
			when others=>Alu_control<="010";
		end case;
		
	end process;






end Behavioral;