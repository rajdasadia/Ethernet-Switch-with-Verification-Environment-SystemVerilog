module eth_rcv_fsm(
input clk,
input reset,
input [31:0] inData,
input inSop,
input inEop,
output reg wrEnable,
output reg [33:0] outData //32 bits data bus and bit 33 and 34 for start and end bit
);

parameter IDLE = 2'b00, destination_rcvd = 2'b01, source_rcvd = 2'b10;  
reg [1:0] STATE;   
always @ (posedge clk)

	begin
		if(reset == 0)
			begin
				wrEnable <= 0;
				outData <= 0;
				STATE <= IDLE;
			end
			
		else
			begin
				case(STATE)
				
					IDLE:
						begin
							if(inSop == 1)
								begin
									wrEnable <= 1;
									outData[33] <= 0;
									outData[32] <= 1;        // Set SOP
									outData[31:0] <= inData; // Destination Address
									STATE <= destination_rcvd;
								end
							else
								begin
									wrEnable <= 0;
									outData <= 0;
									STATE <= IDLE;
								end
						end
						
					destination_rcvd:
						begin
							wrEnable <= 1;
							outData[31:0] <= inData; // Source Address
							outData[32] <= 0;
							outData[33] <= 0;
							STATE <= source_rcvd;
						end
						
					source_rcvd:
						begin
							if(inEop == 1)
								begin
									wrEnable <= 1;
									outData[31:0] <= inData;
									outData[32] <= 0;
									outData[33] <= 1;       //Set EOP
									STATE <= IDLE;
								end
							else
								begin
									wrEnable <= 1;             
									outData[31:0] <= inData;   //receive data until EOP is detected
									outData[32] <= 0;
									outData[33] <= 0;
								end
						end
						
					default:
						begin
							wrEnable <= 0;
							outData <= 0;
							STATE <= IDLE;
						end
				endcase
			end //else
		end //always block
endmodule