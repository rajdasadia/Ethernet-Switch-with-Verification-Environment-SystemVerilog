//****************************************************************************************************
//interface to connect testbench architecture with the DUT
//This interface is not used in the DUT but can be modified and used in the DUT
//****************************************************************************************************

interface Ethernet_interface (
input clk,
input reset,
input [31:0] inData_A,      
input [31:0] inData_B,
input inSop_A,
input inEop_A,
input inSop_B,
input inEop_B,
input [31:0] outData_A,
input outSOP_A,
input outEOP_A,
input portAstall,                  //do not consider any package engry when port stall is high
input [31:0] outData_B,
input outSOP_B,
input outEOP_B,
input portBstall
);

default clocking Ethernet_monitor_cb @(posedge clk);
default input  #2ns output #2ns;
input clk;
input reset;
input inData_A;      
input inData_B;
input inSop_A;
input inEop_A;
input inSop_B;
input inEop_B;
input outData_A;
input outSOP_A;
input outEOP_A;
input portAstall;                 
input outData_B;
input outSOP_B;
input outEOP_B;
input portBstall;
endclocking: Ethernet_monitor_cb

modport Ethernet_monitor_mp ( clocking Ethernet_monitor_cb);

clocking Ethernet_driver_cb @(posedge clk);
default input  #2ns output #2ns;
output inData_A;
output inSop_A;
output inEop_A;
output inData_B;
output inSop_B;
output inEop_B;
endclocking: Ethernet_driver_cb

modport Ethernet_driver_mp ( clocking Ethernet_driver_cb);

endinterface
