module fifo( clk, reset, wrEnable, rdEnable, inData, outData, fifo_full, fifo_empty);

parameter fifo_width = 34, fifo_depth = 16;
input clk, reset;
input wrEnable, rdEnable;
input [fifo_width-1:0] inData;
output reg [fifo_width-1:0] outData;
output reg fifo_full;
output reg fifo_empty;

reg [fifo_width - 1:0] RAM [fifo_width - 1:0];

integer wrPtr, rdPtr; 

always @ (posedge clk)
begin
	if(reset == 0)
		begin
			outData <= 0;
			fifo_full <= 0;
			fifo_empty <= 1;
			wrPtr <= 0;
			rdPtr <= 0;
		end
	else
		begin
			if (wrEnable == 1'b1 && fifo_full == 1'b0)
				begin
					RAM[wrPtr] <= inData;
					fifo_empty <= 0;
					wrPtr <= (wrPtr + 1)% fifo_depth;
					if(wrPtr == rdPtr)
						begin
							fifo_full <= 1'b1;
						end
				end
			else if (rdEnable == 1'b1 && fifo_empty == 1'b0)
				begin
					outData <= RAM[rdPtr];
					fifo_full <= 0;
					rdPtr <= (rdPtr + 1) % fifo_depth;
					if(rdPtr == wrPtr)
						begin
							fifo_empty <= 1'b1;
						end
				end
			else
				begin
				end
		end
end
endmodule