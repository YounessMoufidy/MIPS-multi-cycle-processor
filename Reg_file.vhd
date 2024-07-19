library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Reg_file is
	generic(
		address_length:integer :=5;
		Register_length:integer:=32
			);
	port(
	clk,aresetn:in std_logic;
	Write_en:in std_logic;
	Adress_1,adress_2,write_adress:in std_logic_vector(address_length -1 downto 0);
	Write_data:in std_logic_vector(Register_length -1 downto 0);
	Read_data_1,Read_data_2:out std_logic_vector(Register_length -1 downto 0)
		);
	
end Reg_file;

architecture Behavioral of Reg_file is
	type reg_array is array(0 to 2**address_length -1) of std_logic_vector(Register_length -1 downto 0);
	Signal Reg_file_array:reg_array:=(others=>(others=>'0'));
	
	Begin
		Process(clk,aresetn)
		Begin
			if(aresetn='0') then
				for k in 31 downto 0 loop
					Reg_file_array(k)<=(others=>'0');
				end loop;
			elsif(rising_edge(clk)) then
				if(Write_en='1') then
					if(write_adress="00000") then
						Reg_file_array(to_integer(unsigned(write_adress)))<=x"00000000";
					else
						Reg_file_array(to_integer(unsigned(write_adress)))<=Write_data;
					end if;
				end if;
			end if;
		end process;
		Read_data_1<=Reg_file_array(to_integer(unsigned(Adress_1)));
		Read_data_2<=Reg_file_array(to_integer(unsigned(Adress_2)));
end Behavioral;