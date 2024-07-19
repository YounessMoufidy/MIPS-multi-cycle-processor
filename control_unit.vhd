library ieee;
use ieee.std_logic_1164.all;

entity control_unit is
port(
		clk,aresetn:in std_logic;
		op_code:in std_logic_vector(5 downto 0);
		zero:in std_logic;
		--function_field: in std_logic_vector(5 downto 0);(look at alu decoder)
		Instruction_or_data:out std_logic;
		MemWrite:out  std_logic;
		IRWrite:out  std_logic;
		Regdst:out std_logic;
		MemtoReg:out std_logic;
		RegWrite:out std_logic;
		AluSrcA:out std_logic;
		AluSrcB:out std_logic_vector(1 downto 0);
		Aluop:out std_logic_vector(1 downto 0);
		PcSrc:out std_logic_vector(1 downto 0);
		Branch:Buffer std_logic;
		PcWrite:Buffer std_logic;
		PCEN:out std_logic
		);

end control_unit;

architecture Behavioral of control_unit is
type state is (S0,S1,S2,S3,S4,S5,S6,S7,S8,S9,S10,S11);
Signal PS:state;
Begin
	
	Process(aresetn,clk)
	Begin
		if(aresetn='0') then
			PS<=S0;
		elsif(rising_edge(clk)) then
			case(Ps) is
				when S0=>PS<=S1;
				when S1=>if(op_code="100011" or op_code="101011") then -- lw/sw
								PS<=S2;
							elsif(op_code="000000") then--R type 
								PS<=S6;
							elsif(op_code="000100") then--beq
								PS<=S8;
							elsif(op_code="000010") then--jump
								PS<=S11;
							elsif(op_code="001000") then--addi
								PS<=S9;
							end if;
				when S2=>if(op_code="100011") then --lw
									PS<=S3;
							elsif(op_code="101011") then--sw
									PS<=S5;
							end if;
				when S3=>PS<=S4;
				when S4=>PS<=S0;
				When S5=>PS<=S0;--end of lw
				when S6=>PS<=S7;
				When S7=>PS<=S0;--end of Rtype
				when S8=>PS<=S0;--end of BEQ
				--when S12=>PS<=S0;
				when S9=>PS<=S10;
				when S10=>PS<=S0;--end of addi
				when S11=>PS<=S0;--end of jump
				when others=>PS<=S0;
			end case;
		end if;
	end process;
	PCEN<=(Branch and zero) or PcWrite;
	Process(PS)
	Begin
		Instruction_or_data<='0';AluSrcA<='0';AluSrcB<="00";Aluop<="00";PcSrc<="00";IRWrite<='0';PcWrite<='0';Branch<='0';MemWrite<='0';MemtoReg<='0';RegWrite<='0';Regdst<='0';
		--
		case(PS) is
			
			when S0=>Instruction_or_data<='0';AluSrcA<='0';AluSrcB<="01";Aluop<="00";PcSrc<="00";IRWrite<='1';PcWrite<='1';
			When S1=>AluSrcA<='0';AluSrcB<="11";Aluop<="00";
			when S2=>AluSrcA<='1';AluSrcB<="10";Aluop<="00";
			when S3=>Instruction_or_data<='1';MemWrite<='0';
			when S4=>MemtoReg<='1';RegWrite<='1';Regdst<='0';
			when S5=>Instruction_or_data<='1';MemWrite<='1';
			when S6=>AluSrcA<='1';AluSrcB<="00";Aluop<="10";--to perform Rtype
			when S7=>MemtoReg<='0';RegWrite<='1';Regdst<='1';--Write Back Rtype
			when S8=>AluSrcA<='1';AluSrcB<="00";Aluop<="01";Branch<='1';PcSrc<="01";
			--when S12=>PcWrite<='1';
			When S9=>AluSrcA<='1';AluSrcB<="10";Aluop<="00";
			when S10=>Regdst<='0';MemtoReg<='0';RegWrite<='1';
			when S11=>PcSrc<="10";PcWrite<='1';
		end case;
	end process;
		
end Behavioral;