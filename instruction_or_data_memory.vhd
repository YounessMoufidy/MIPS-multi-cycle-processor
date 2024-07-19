library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity instruction_or_data_memory is
	port(
		clk,aresetn:in std_logic;
		write_en:in std_logic;
		Adress_in:in std_logic_vector(31 downto 0);
		Write_data:in std_logic_vector(31 downto 0);
		Read_data:out std_logic_vector(31 downto 0)
		
		);
end instruction_or_data_memory;

architecture arch of instruction_or_data_memory is
Signal Physical_address:std_logic_vector(5 downto 0);
type mem_array_type is array(0 to 63) of std_logic_vector(7 downto 0);
Signal mem_array:mem_array_type:=(
	--the first 31 locations are for the instruction
--	--addi $t0,$t0,85
--	0 =>x"21",
--	1=>x"08",
--	2=>x"00",
--	3=>x"55",
----beq $0,$0,,label
--	0=>x"10",
--	1=>x"00",
--	2=>x"00",
--	3=>x"02",
--	--addi $t1,$t0,5
--	4=>x"20",
--	5=>x"09",
--	6=>x"00",
--	7=>x"05",
	--add $t2,$t1,$t0
	0=>x"01",
	1=>x"28",
	2=>x"50",
	3=>x"20",
	--beq 
--	0=>x"10",
--	1=>x"00",
--	2=>x"00",
--	3=>x"00",
--	--lw $t0,0($zero)
--	4=>x"8c",
--	5=>x"09",
--	6=>x"00",
--	7=>x"00",
	-- jump 0
--	4=>x"08",
--	5=>x"00",
--	6=>x"00",
--	7=>x"00",
	--beq $0,$0,,label
	4=>x"10",
	5=>x"00",
	6=>x"00",
	7=>x"02",
	--sw $t0,0($zero)
	8=>x"AD",
	9=>x"48",
	10=>x"00",
	11=>x"00",
	--lw $t1,0($zero)
	12=>x"8c",
	13=>x"09",
	14=>x"00",
	15=>x"00",
	
	others=>(others=>'0')
	
	--And the second 31 locations are for Data_memory
		);
Begin
	Physical_address<=Adress_in(5 downto 0);
	Process(clk,aresetn)
	Begin
		if(aresetn='0') then
			for k in 63 downto 32 loop
					mem_array(k)<=(others=>'0');
			end loop;
		elsif(rising_edge(clk)) then
			if(write_en='1') then
					mem_array(to_integer(unsigned(physical_address)))<=write_data(31 downto 24);--little endian memory
					mem_array(to_integer(unsigned(physical_address)+1))<=write_data(23 downto 16);
					mem_array(to_integer(unsigned(physical_address)+2))<=write_data(15 downto 8);
					mem_array(to_integer(unsigned(physical_address)+3))<=write_data(7 downto 0);	
			end if;
		end if;
	end process;
	--Read_data<=mem_array(to_integer(unsigned(Physical_address)));
	
	process(mem_array,physical_address)
	Begin
		--Mips does not support unaligned access
				if((to_integer(unsigned(physical_address))) rem 4 =0) then
					Read_data<=mem_array(to_integer(unsigned(physical_address))+0)&mem_array(to_integer(unsigned(physical_address)+1))&mem_array(to_integer(unsigned(physical_address)+2))&mem_array(to_integer(unsigned(physical_address)+3));
	
				elsif((to_integer(unsigned(physical_address))) rem 3=0) then
					Read_data<=mem_array((to_integer(unsigned(physical_address))-3))&mem_array(to_integer(unsigned(physical_address)-2))&mem_array(to_integer(unsigned(physical_address)-1))&mem_array(to_integer(unsigned(physical_address)));
	
				elsif((to_integer(unsigned(physical_address))) rem 2=0) then
					Read_data<=mem_array(to_integer(unsigned(physical_address)-2))&mem_array(to_integer(unsigned(physical_address)-1))&mem_array(to_integer(unsigned(physical_address)))&mem_array(to_integer(unsigned(physical_address)+1));
	
				else
					Read_data<=mem_array(to_integer(unsigned(physical_address)-1))&mem_array(to_integer(unsigned(physical_address)))&mem_array(to_integer(unsigned(physical_address)+1))& mem_array(to_integer(unsigned(physical_address)));
					
				end if;
		
		
	end process;
			
	
	
	
	
end arch;
	
	