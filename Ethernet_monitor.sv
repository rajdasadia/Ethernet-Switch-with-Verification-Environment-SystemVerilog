//************************************************************************************************
//This is the Monitor class that constantly reads the data going in and coming out of the DUT
//This data in the mailbox is then provided to the checker class for verification of the packets
//************************************************************************************************

//`include "Ethernet_packet.sv"
import Ethernet_packet_package::*;

class Ethernet_monitor;

virtual Ethernet_interface Ethernet_monitor_intf;
mailbox mbx_out[4];

function new(mailbox mbx_out[4], virtual Ethernet_interface Ethernet_monitor_intf );
	this.mbx_out = mbx_out;
	this.Ethernet_monitor_intf = Ethernet_monitor_intf;
endfunction

task run;
	fork
		sample_portA_input_pkt();
		sample_portB_input_pkt();
		sample_portA_output_pkt();
		sample_portB_output_pkt();
	join
endtask

task sample_portA_input_pkt();
	Ethernet_packet pkt;
	int count;
	count = 0;
	forever @(posedge Ethernet_monitor_intf.clk)
		begin
			if(Ethernet_monitor_intf.Ethernet_monitor_cb.inSop_A)
				begin
					$display("Ethernet_monitor::sample_portA_input_pkt  time reading SOP at input port A is %t", $time);
					pkt = new();
					count ++;
					pkt.destination_address = Ethernet_monitor_intf.Ethernet_monitor_cb.inData_A;
				end
			else if(count == 1)
				begin
					count ++;
					pkt.source_address = Ethernet_monitor_intf.Ethernet_monitor_cb.inData_A;
				end
			else if(count > 1)
				begin
					pkt.packet_data.push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.inData_A);
					count ++;
				end
			else if(Ethernet_monitor_intf.Ethernet_monitor_cb.inEop_A)
				begin
					pkt.packet_CRC = Ethernet_monitor_intf.Ethernet_monitor_cb.inData_A;
					mbx_out[0].push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.inData_A);
					count = 0;
					$display("Ethernet_monitor::sample_portA_input_pkt at time %t saw entire packet at the input port which is pkt: %s" , $time, pkt.packet_details() );
				end
		end
endtask

		
task sample_portA_output_pkt();
	Ethernet_packet pkt;
	int count;
	count = 0;
	forever @(posedge Ethernet_monitor_intf.clk)
		begin
			if(Ethernet_monitor_intf.Ethernet_monitor_cb.outSop_A)
				begin
					$display("Ethernet_monitor::sample_portA_output_pkt  time reading SOP at output port A is %t", $time);
					pkt = new();
					count ++;
					pkt.destination_address = Ethernet_monitor_intf.Ethernet_monitor_cb.outData_A;
				end
			else if(count == 1)
				begin
					count ++;
					pkt.source_address = Ethernet_monitor_intf.Ethernet_monitor_cb.outData_A;
				end
			else if(count > 1)
				begin
					pkt.packet_data.push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.outData_A);
					count ++;
				end
			else if(Ethernet_monitor_intf.Ethernet_monitor_cb.outEop_A)
				begin
					pkt.packet_CRC = Ethernet_monitor_intf.Ethernet_monitor_cb.outData_A;
					mbx_out[2].push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.outData_A);
					count = 0;
					$display("Ethernet_monitor::sample_portA_output_pkt at time %t saw entire packet at the output port which is pkt: %s" , $time, pkt.packet_details() );
				end
		end
endtask
				
				
task sample_portB_input_pkt();
	Ethernet_packet pkt;
	int count;
	count = 0;
	forever @(posedge Ethernet_monitor_intf.clk)
		begin
			if(Ethernet_monitor_intf.Ethernet_monitor_cb.inSop_B)
				begin
					$display("Ethernet_monitor::sample_portB_input_pkt  time reading SOP at input port B is %t", $time);
					pkt = new();
					count ++;
					pkt.destination_address = Ethernet_monitor_intf.Ethernet_monitor_cb.inData_B;
				end
			else if(count == 1)
				begin
					count ++;
					pkt.source_address = Ethernet_monitor_intf.Ethernet_monitor_cb.inData_B;
				end
			else if(count > 1)
				begin
					pkt.packet_data.push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.inData_B);
					count ++;
				end
			else if(Ethernet_monitor_intf.Ethernet_monitor_cb.inEop_B)
				begin
					pkt.packet_CRC = Ethernet_monitor_intf.Ethernet_monitor_cb.inData_B;
					mbx_out[1].push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.inData_B);
					count = 0;
					$display("Ethernet_monitor::sample_portB_input_pkt at time %t saw entire packet at the input port which is pkt: %s" , $time, pkt.packet_details() );
				end
		end
endtask

		
task sample_portB_output_pkt();
	Ethernet_packet pkt;
	int count;
	count = 0;
	forever @(posedge Ethernet_monitor_intf.clk)
		begin
			if(Ethernet_monitor_intf.Ethernet_monitor_cb.outSop_B)
				begin
					$display("Ethernet_monitor::sample_portB_output_pkt  time reading SOP at output port B is %t", $time);
					pkt = new();
					count ++;
					pkt.destination_address = Ethernet_monitor_intf.Ethernet_monitor_cb.outData_B;
				end
			else if(count == 1)
				begin
					count ++;
					pkt.source_address = Ethernet_monitor_intf.Ethernet_monitor_cb.outData_B;
				end
			else if(count > 1)
				begin
					pkt.packet_data.push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.outData_B);
					count ++;
				end
			else if(Ethernet_monitor_intf.Ethernet_monitor_cb.outEop_B)
				begin
					pkt.packet_CRC = Ethernet_monitor_intf.Ethernet_monitor_cb.outData_B;
					mbx_out[3].push_back(Ethernet_monitor_intf.Ethernet_monitor_cb.outData_A);
					count = 0;
					$display("Ethernet_monitor::sample_portB_output_pkt at time %t saw entire packet at the output port which is pkt: %s" , $time, pkt.packet_details() );
				end
		end
endtask
				
endclass
				
				
				
				
				
				
				
				
				
				
				
				
				
					


