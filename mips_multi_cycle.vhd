library ieee;
use ieee.std_logic_1164.all;


entity mips_multi_cycle is
	
	port(
		aresetn:in std_logic;
		clk:in std_logic);



end mips_multi_cycle;

architecture Behavioral of mips_multi_cycle is
		component programcounter is

			port(
				clk,aresetn:in std_logic;
				PcSrc:in std_logic_vector(1 downto 0);
				PCEN:in std_logic;
				AluResult:in std_logic_vector(31 downto 0);
				AluOut:in std_logic_vector(31 downto 0);
				Jump_immediat:in std_logic_vector(25 downto 0);
				--old_pc:buffer  std_logic_vector(31 downto 0);
				current_pc:buffer std_logic_vector(31 downto 0)
				);
				
		end component;
		component D_FlipFlop is
			generic(
				signal_length:integer:=32
			);
			port(
				clk,aresetn:in std_logic;
				EN:in std_logic;
				D:in std_logic_vector(signal_length-1 downto 0);
				Q:out std_logic_vector(signal_length-1 downto 0)
			);
		end component;


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
		component instruction_or_data_memory is
			port(
				clk,aresetn:in std_logic;
				write_en:in std_logic;
				Adress_in:in std_logic_vector(31 downto 0);
				Write_data:in std_logic_vector(31 downto 0);
				Read_data:out std_logic_vector(31 downto 0)
				
				);
		end component;
		component instruction_decoder is
			port(
				
				clk,aresetn:in std_logic;
				IRwrite:in std_logic;
				Read_instruction:in std_logic_vector(31 downto 0);
				address_rs:out std_logic_vector(4 downto 0);
				address_rt:out std_logic_vector(4 downto 0);
				address_rd:out std_logic_vector(4 downto 0);
				op_code:out std_logic_vector(5 downto 0);
				function_field:out std_logic_vector(5 downto 0);
				Branch_immediate:out std_logic_vector(15 downto 0);
				jump_immediate:out std_logic_vector(25 downto 0)
				
			
			);
			
		end component;

		component Write_data_calculation is
		port(
			clk,aresetn:in std_logic;
			Mem_to_reg:in std_logic;
			Alu_out:in std_logic_vector(31 downto 0);
			--Data out from data memory
			Data_out:in std_logic_vector(31 downto 0);
			write_data_to_reg_file:out std_logic_vector(31 downto 0)
			);
		end component;

		component  Write_address_calculation is
		port(
			Regdst:in std_logic;
			address_rt:in std_logic_vector(4 downto 0);
			address_rd: in std_logic_vector(4 downto 0);
			address_reg_file:out std_logic_vector(4 downto 0)

		);

		end component;
		component Reg_file is
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
			
		end component;

		component SrcA_calculation is

		port(
			clk,aresetn:in std_logic;
			AluSrcA:in std_logic;
			current_pc:in std_logic_vector(31 downto 0);
			read_data1_after_clock_edge:in std_logic_vector(31 downto 0);
			SrcA:out std_logic_vector(31 downto 0)

			);
		end component;
		component SrcB_calculation is
		port(
			clk,aresetn:in std_logic;
			AluSrcB:in std_logic_vector(1 downto 0);
			Read_data_2_after_clock_edge:in std_logic_vector(31 downto 0);
			Branch_immediat:in std_logic_vector(15 downto 0);
			SrcB:out std_logic_vector(31 downto 0)
			);
		end component;

		component control_unit is
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

		end component;
		component Alu_decoder is
		port(
			Alu_op:in std_logic_vector(1 downto 0);
			function_field:in std_logic_vector(5 downto 0);
			Alu_control:out std_logic_vector(2 downto 0)
			);
	  end component;

		component Alu is 
		port(

			SrcA,SrcB:in std_logic_vector(31 downto 0);
			AluControl:in std_logic_vector(2 downto 0);
			Zero:out std_logic;
			AluResult:out std_logic_vector(31 downto 0)
			);
		end component;


		Signal PcSrc			:std_logic_vector(1 downto 0):=(others=>'0');
		Signal PCEN				:std_logic:='0';
		Signal AluResult		:std_logic_vector(31 downto 0):=(others=>'0');
		--Signal old_pc			:std_logic_vector(31 downto 0):=(others=>'0');
		Signal	current_pc:	std_logic_vector(31 downto 0):="11111111111111111111111111111100";
		Signal Adress_in: std_logic_vector(31 downto 0):=(others=>'0');
		Signal Read_data:  std_logic_vector(31 downto 0):=(others=>'0');
		Signal address_rs:		 std_logic_vector(4 downto 0):=(others=>'0');
		Signal address_rt:		 std_logic_vector(4 downto 0):=(others=>'0');
		Signal address_rd:		 std_logic_vector(4 downto 0):=(others=>'0');
		Signal op_code:			 std_logic_vector(5 downto 0):=(others=>'0');
		Signal function_field:	 std_logic_vector(5 downto 0):=(others=>'0');
		Signal Branch_immediate: std_logic_vector(15 downto 0):=(others=>'0');
		Signal jump_immediat:	 std_logic_vector(25 downto 0):=(others=>'0');
		Signal IRwrite:			 std_logic:='0';
		Signal Regdst:				std_logic:='0';
	   Signal address_reg_file: std_logic_vector(4 downto 0):=(others=>'0');
		Signal Mem_to_reg: std_logic:='0';
		Signal write_data_to_reg_file: std_logic_vector(31 downto 0):=(others=>'0');
		Signal Write_en: std_logic:='0';
		Signal Read_data_1,Read_data_2: std_logic_vector(31 downto 0):=(others=>'0');
		Signal read_data1_after_clock_edge:std_logic_vector(31 downto 0):=(others=>'0');
		Signal AluSrcA: std_logic:='0';
		Signal SrcA: std_logic_vector(31 downto 0):=(others=>'0');
		Signal read_data2_after_clock_edge:std_logic_vector(31 downto 0):=(others=>'0');
		Signal AluSrcB: std_logic_vector(1 downto 0):=(others=>'0');
		Signal SrcB:     std_logic_vector(31 downto 0):=(others=>'0');
		Signal zero:std_logic:='0';
		Signal Instruction_or_data: std_logic;
		Signal MemWrite:  std_logic:='0';
		Signal RegWrite: std_logic:='0';
		Signal Aluop: std_logic_vector(1 downto 0):=(others=>'0');
		Signal Branch: std_logic:='0';
		Signal PcWrite: std_logic:='0';
		Signal Alu_control: std_logic_vector(2 downto 0):=(others=>'0');
		Signal AluOut:std_logic_vector(31 downto 0):=(others=>'0');
Begin
--program counter
component_programcounter:programcounter
port map(clk,aresetn,PcSrc,PCEN,AluResult,AluOut,Jump_immediat,current_pc);
--mux21
component_mux21:mux21
generic map(Signal_length=>32)
port map(Instruction_or_data,current_pc,AluOut,Adress_in);

--instruction_or_data_memory
component_instruction_or_data_memory:instruction_or_data_memory
port map(clk,aresetn,MemWrite,Adress_in,Read_data_2,Read_data);

--instruction_decoder
component_instruction_decoder:instruction_decoder
port map(clk,aresetn,IRwrite,Read_data,address_rs,address_rt,address_rd,op_code,function_field,Branch_immediate,jump_immediat);

--write adress
component_Write_address_calculation:Write_address_calculation
port map(Regdst,address_rt,address_rd,address_reg_file);
--write data
component_Write_data_calculation:Write_data_calculation
port map(clk,aresetn,Mem_to_reg,AluOut,Read_data,write_data_to_reg_file);
--Regfile
component_Reg_file:Reg_file 
generic map(address_length=>5,Register_length=>32)
port map(clk,aresetn,RegWrite,address_rs,address_rt,address_reg_file,write_data_to_reg_file,Read_data_1,Read_data_2);
--Dflipflop
component_D_FlipFlop1:D_FlipFlop
generic map(signal_length=>32)
port map(clk,aresetn,'1',Read_data_1,read_data1_after_clock_edge);
--SrcA_calculation
component_SrcA_calculation:SrcA_calculation
port map(clk,aresetn,AluSrcA,current_pc,read_data1_after_clock_edge,SrcA);
--
component_D_FlipFlop2:D_FlipFlop
generic map(signal_length=>32)
port map(clk,aresetn,'1',Read_data_2,read_data2_after_clock_edge);

--SrcB_calculation
component_SrcB_calculation:SrcB_calculation
port map(clk,aresetn,AluSrcB,read_data2_after_clock_edge,Branch_immediate,SrcB);

--control unit
component_control_unit:control_unit
port map(clk,aresetn,op_code,zero,Instruction_or_data,MemWrite,IRWrite,Regdst,Mem_to_reg,RegWrite,AluSrcA,AluSrcB,Aluop,PcSrc,Branch,PcWrite,PCEN);
--AluDecoder
component_AluDecoder:Alu_Decoder
port map(Aluop,function_field,Alu_control);

--Alu
component_Alu:Alu
port map(SrcA,SrcB,Alu_control,Zero,AluResult);

--D flip flop
component_D_FlipFlop3:D_FlipFlop
generic map(signal_length=>32)
port map(clk,aresetn,'1',AluResult,AluOut);






end Behavioral;