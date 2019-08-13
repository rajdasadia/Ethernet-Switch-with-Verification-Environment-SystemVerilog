//************************************************************************************
//Ethernet packet checker class
//This class uses 4 mailboxes, 2 at two input ports and 2 at two output ports
//This class checks if the packet that arrived from each outport is correct 
//************************************************************************************
//`include "Ethernet_packet.sv"
import Ethernet_packet_package::*;
class Ethernet_packet_checker;

mailbox mbx_in[4];
Ethernet_packet exp_ethernet_pkt_A[$];           //Queue of expected ethernet packet at output port A
Ethernet_packet exp_ethernet_pkt_B[$];           //Queue of expected ethernet packet at output port B

function new(mailbox mbx_in[4]);                 //4 mailboxes , 2 for input, 2 for output provided by the monitor class
	for(int i = 0; i < 4; i++)
		begin
			this.mbx_in[i] = mbx_in[i];
		end
endfunction

task run;
	$display("Ethernet_packet_checker::task run() called");
	fork
		get_and_process_pkt(0);
		get_and_process_pkt(1);
		get_and_process_pkt(2);
		get_and_process_pkt(3);
	join_none
endtask

task get_and_process_pkt(int port);
	Ethernet_packet pkt;
	$display("Ethernet_packet_checker::get_and_process_pkt on port %d called",port);
	forever 
		begin
			mbx_in[port].get(pkt);
			$display("time = %t got packet at the port %d packet = %s", $time, port, pkt.packet_details());
			if(port < 2)
				begin
					push_in_exp_pkt_queue(pkt);
				end
			else
				begin
					check_in_exp_pkt_queue(port, pkt);
				end
		end
endtask

function void push_in_exp_pkt_queue(Ethernet_packet pkt);
	if(pkt.destination_address == 'hABCD)
		begin
			exp_ethernet_pkt_A.push_back(pkt);
		end
	else if(pkt.destination_address == 'hBEEF)
		begin
			exp_ethernet_pkt_B.push_back(pkt);
		end
	else
		begin
			$error("Unknown destination of the packet hence dropping");
		end
endfunction

function void check_in_exp_pkt_queue(int port, Ethernet_packet pkt);
Ethernet_packet exp;
	if(port == 2)
		begin
			exp = exp_ethernet_pkt_A.pop_front();
		end
	else if(port == 3)
		begin
			exp = exp_ethernet_pkt_B.pop_front();
		end
	if(pkt.packet_compare(exp))
		begin
			$display("Packet arrived at the correct destination");
		end
	else
		begin
			$display("Packet arrived at the incorrect destination");
		end
endfunction

endclass
