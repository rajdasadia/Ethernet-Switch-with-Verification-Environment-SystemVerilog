//*****************************************************************************
//Ethernet packet generator class
//Testbench for Ethernet DUT
//packets are generated and put in a mailbox and can be achieved from the mailbox itself
//*****************************************************************************

//`include "Ethernet_packet.sv"
import Ethernet_packet_package::*;

class Ethernet_packet_generator;
	int num_packet;                                     //number of packets that needs to be generated and pushed in the mailbox
	mailbox mbx_pakcket_out;                                //mailbox containing packets
	
	function new(mailbox mbx);
		mbx_pakcket_out = mbx;
	endfunction

	task run;
		Ethernet_packet pkt;
		num_packet = $urandom_range(2,3);
		for (int i = 0; i < num_packet; i++)
			begin
				pkt = new();
				pkt.post_randomize();
				mbx_pakcket_out.put(pkt);
			end
	endtask
endclass
