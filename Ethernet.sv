module Ethernet(
input clk,
input reset,
input [31:0] inData_A,
input [31:0] inData_B,
input inSop_A,
input inEop_A,
input inSop_B,
input inEop_B,
output reg [31:0] outData_A,
output reg outSOP_A,
output reg outEOP_A,
output reg portAstall,                       //do not consider any package entry when port stall is high
output reg [31:0] outData_B,
output reg outSOP_B,
output reg outEOP_B,
output reg portBstall
);

parameter Port_A_addr = 'hABCD, Port_B_addr = 'hBEEF;

wire fifo_wrEnable[2];
reg fifo_rdEnable[2];
wire [33:0] fifo_DataIn [2];
wire fifo_full[2];
wire fifo_empty[2];
wire [33:0] fifo_DataOut [2];

eth_rcv_fsm eth_rcv_fsm_A(
.clk(clk),
.reset(reset),
.inData(inData_A),
.inSop(inSop_A),
.inEop(inEop_A),
.wrEnable(fifo_wrEnable[0]),    
.outData(fifo_DataIn[0])
);

eth_rcv_fsm eth_rcv_fsm_B(
.clk(clk),
.reset(reset),
.inData(inData_B),
.inSop(inSop_B),
.inEop(inEop_B),
.wrEnable(fifo_wrEnable[1]),    
.outData(fifo_DataIn[1])
);

fifo fifo_A(
.clk(clk),
.reset(reset),
.wrEnable(fifo_wrEnable[0]), 
.rdEnable(fifo_rdEnable[0]), 
.inData(fifo_DataIn[0]), 
.outData(fifo_DataOut[0]), 
.fifo_full(fifo_full[0]), 
.fifo_empty(fifo_empty[0])
);

fifo fifo_B(
.clk(clk),
.reset(reset),
.wrEnable(fifo_wrEnable[1]), 
.rdEnable(fifo_rdEnable[1]), 
.inData(fifo_DataIn[1]), 
.outData(fifo_DataOut[1]), 
.fifo_full(fifo_full[1]), 
.fifo_empty(fifo_empty[1])
);


reg [1:0] dest_port [2];
reg port_busy[2];
reg read_fifo_head [2];
reg read_fifo_data [2];

always @ (posedge clk)
begin
	if( reset == 0)
		begin
			for( int i = 0; i <2 ; i++)
				begin
				read_fifo_head [i] <= 1'b1;
				read_fifo_data [i] <= 1'b0;
				port_busy[i] <= 1'b0;
				dest_port [i] <= 2'b11;         //invalid
				fifo_rdEnable[i] <= 1'b0;
				end
					
			outData_A <= 'x;
			outData_B <= 'x;
			outSOP_A <= 0;
			outEOP_A <= 0; 
			outSOP_B <= 0;
			outEOP_B <= 0;
			portAstall <= 0; 
			portBstall <= 0;
		end
	else
		begin
			outSOP_A <= 0;
			outEOP_A <= 0; 
			outSOP_B <= 0;
			outEOP_B <= 0;
			for( int i = 0; i < 2; i++)
				begin
					if((read_fifo_head[i] == 1) && (fifo_empty[i] == 0))
						begin
							fifo_rdEnable[i] <= 1;
							read_fifo_head[i] <= 0;
							read_fifo_data[i] <= 1;
						end
					else if((read_fifo_data[i] == 1) && (fifo_full[i] == 0))
						begin
							if(fifo_DataOut[i][31:0] == Port_A_addr)
								begin
									dest_port[i] <= 2'b00;
								end
							else if(fifo_DataOut[i][31:0] == Port_B_addr)
								begin
									dest_port[i] <= 2'b01;
								end
							if(port_busy[dest_port[i]] == 1'b1)
								begin
									fifo_rdEnable[i] <= 1'b0;
								end
							else 
								begin
									fifo_rdEnable[i] <= 1'b1;
									port_busy[dest_port[i]] <= 1'b1;     //cannot accept packets from another port while accepting packets from one port
								end
						end
					else if(fifo_DataOut[i][33] == 1)      //EOP
						begin
							fifo_rdEnable[i] <= 1'b0;
							read_fifo_head[i] <= 1'b1;
							read_fifo_data[i] <= 1'b0;
							port_busy[dest_port[i]] <= 1'b0;
						end
					else
						begin
							fifo_rdEnable[i] <= 1'b1;
						end
					
					if(dest_port[i] == 1'b0)
						begin
							outData_A <= fifo_DataOut[i][31:0];
							outSOP_A <= fifo_DataOut[i][32];
							outEOP_A <= fifo_DataOut[i][33];
							portAstall <= fifo_full[0];
						end
					else if(dest_port[i] == 1'b1)
						begin
							outData_B <= fifo_DataOut[i][31:0];
							outSOP_B <= fifo_DataOut[i][32];
							outEOP_B <= fifo_DataOut[i][33];
							portBstall <= fifo_full[1];
						end
				end
		end
end
endmodule
					
						
					
			
			

 

