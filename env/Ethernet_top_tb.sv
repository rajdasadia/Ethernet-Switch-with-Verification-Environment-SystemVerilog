//************************************************************************************
//Ethernet testbench topmodule that creates an object of testbench environment class 
//Passes interface handle for the virtual interface
//This module connects directly with the DUT
//************************************************************************************

import Ethernet_tb_env_package::*;
`include"Ethernet_interface.sv"

module Ethernet_tb_top;

	reg clk;
	reg reset;
	wire [31:0] inData_A;
	wire [31:0] inData_B;
	wire inSop_A;
	wire inEop_A;
	wire inSop_B;
	wire inEop_B;
	wire [31:0] outData_A;
	wire outSOP_A;
	wire outEOP_A;
	wire portAstall;                     
	wire [31:0] outData_B;
	wire outSOP_B;
	wire outEOP_B;
	wire portBstall;
	
	
	//Instantiating the DUT
	
	Ethernet Ethernet_DUT(
	.clk(clk),
	.reset(reset),
	.inData_A(inData_A),
	.inData_B(inData_B),
	.inSop_A(inSop_A),
	.inEop_A(inEop_A),
	.inSop_B(inSop_B),
	.inEop_B(inEop_B),
	.outData_A(outData_A),
	.outSOP_A(outSOP_A),
	.outEOP_A(outEOP_A),
	.portAstall(portAstall),                     
	.outData_B(outData_B),
	.outSOP_B(outSOP_B),
	.outEOP_B(outEOP_B),
	.portBstall(portBstall)
	);
	
	//instantiating the interface
	
	Ethernet_interface Ethernet_interface_DUT(
	.clk(clk),
	.reset(reset),
	.inData_A(inData_A),
	.inData_B(inData_B),
	.inSop_A(inSop_A),
	.inEop_A(inEop_A),
	.inSop_B(inSop_B),
	.inEop_B(inEop_B),
	.outData_A(outData_A),
	.outSOP_A(outSOP_A),
	.outEOP_A(outEOP_A),
	.portAstall(portAstall),                     
	.outData_B(outData_B),
	.outSOP_B(outSOP_B),
	.outEOP_B(outEOP_B),
	.portBstall(portBstall)
	);
	
	//Instantiating top module of TB
	
	Ethernet_tb_env Ethernet_tb_env1;
	
	always 
		begin
			#5 clk = 0;
			#5 clk = 1;
		end
		
	initial 
		begin
			reset = 0;
			#5 reset = 1;
			Ethernet_tb_env1 = new("sample_environment", Ethernet_interface_DUT);
			$display("Created Ethernet Testbench Environment");
			fork
				begin
					Ethernet_tb_env1.run();
				end
			join
		end
endmodule
	
	
	
	
	
