library ieee;
use ieee.std_logic_1164.all;

entity  Write_address_calculation is
port(
	Regdst:in std_logic;
	address_rt:in std_logic_vector(4 downto 0);
	address_rd: in std_logic_vector(4 downto 0);
	address_reg_file:out std_logic_vector(4 downto 0)

);

end entity;

architecture arch of Write_address_calculation is
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

Begin
	u1:mux21
	generic map(Signal_length=>5)
	port map(sel=>Regdst,input0=>address_rt,input1=>address_rd,out_sig=>address_reg_file);

	
	
end arch;
