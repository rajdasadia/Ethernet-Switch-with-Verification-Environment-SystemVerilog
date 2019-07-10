//********************************************************************************************************
//Ethernet Packet Driver Class
//This class connects with the ports of the DUT and drives the packets generated from the generator class
//Caution: cannot use non blocking assignments in dynamic or automatic objects. Dynamic or automatic objects are the ones that are created with the beginning of the task or function and ends at the end of task or fn
//********************************************************************************************************
//`include "Ethernet_packet.sv"
import Ethernet_packet_package::*;

class Ethernet_packet_driver;


virtual Ethernet_interface Ethernet_driver_intf;
mailbox mailbox_driver;                                //pointer to accept the mailbox from the generator

function new(mailbox mailbox_driver, virtual Ethernet_interface Ethernet_driver_intf);
	this.mailbox_driver = mailbox_driver;
	this.Ethernet_driver_intf = Ethernet_driver_intf;
endfunction

task run;
Ethernet_packet pkt;
forever 
	begin
	
		mailbox_driver.get(pkt);
		$display("Ethernet_packet_driver:: Got packet = %s" ,pkt.packet_details());                //displays source, destination and crc of the packet
		if(pkt.source_address == 'hABCD)
			begin
				drive_pkt_portA(pkt);
			end
		else if(pkt.source_address == 'hBEEF)
			begin
				drive_pkt_portB(pkt);
			end
		else
			begin
				$display("Packet source address is not port A or B, Thus dropping the packet");
			end
	end
endtask

task drive_pkt_portA(Ethernet_packet pkt);
	int count;                                     //counts the number of words (32 bits)
	int total_packet_words = pkt.packet_size / 4;  // 1 word = 32 bits and packet size is in bytes
	bit [31:0] input_to_DUT;                       //32 bit input in the input port of DUT
	count = 0;
	$display("Ethernet_packet_driver :: drive_pkt_portA: number of words in the packet = %d", total_packet_words);
	forever@(posedge Ethernet_driver_intf.clk)
		begin
			if (Ethernet_driver_intf.portAstall == 0)
				begin
					Ethernet_driver_intf.Ethernet_driver_cb.inSop_A <= 0;
					Ethernet_driver_intf.Ethernet_driver_cb.inEop_A <= 0;
					input_to_DUT[7:0] = pkt.full_packet[4*count];
					input_to_DUT[15:8] = pkt.full_packet[4*count + 1];
					input_to_DUT[23:16] = pkt.full_packet[4*count + 2];
					input_to_DUT[31:24] = pkt.full_packet[4*count + 3];
					$display("time = %t  Ethernet_packet_driver :: drive_pkt_portA: input_to_DUT = %h  count = %d", $time, input_to_DUT, count);
					if(count == 0)
						begin
							Ethernet_driver_intf.Ethernet_driver_cb.inSop_A <= 1'b1;
							Ethernet_driver_intf.Ethernet_driver_cb.inData_A <= input_to_DUT;
							count ++;
						end
					else if(count == total_packet_words - 1)
						begin
							Ethernet_driver_intf.Ethernet_driver_cb.inEop_A <= 1'b1;
							Ethernet_driver_intf.Ethernet_driver_cb.inData_A <= input_to_DUT;
							count ++;
						end
					else if(count == total_packet_words)
						begin
							break;
						end
					else
						begin
							Ethernet_driver_intf.Ethernet_driver_cb.inData_A <= input_to_DUT;
							count ++;
						end
				end
		end
endtask

task drive_pkt_portB(Ethernet_packet pkt);
	int count;                                     //counts the number of words (32 bits)
	int total_packet_words = pkt.packet_size / 4;  // 1 word = 32 bits and packet size is in bytes
	bit [31:0] input_to_DUT;                       //32 bit input in the input port of DUT
	count = 0;
	$display("Ethernet_packet_driver :: drive_pkt_portB: number of words in the packet = %d", total_packet_words);
	forever@(posedge Ethernet_driver_intf.clk)
		begin
			if (Ethernet_driver_intf.portBstall == 0)
				begin
					Ethernet_driver_intf.Ethernet_driver_cb.inSop_B <= 0;
					Ethernet_driver_intf.Ethernet_driver_cb.inEop_B <= 0;
					input_to_DUT[7:0] = pkt.full_packet[4*count];
					input_to_DUT[15:8] = pkt.full_packet[4*count + 1];
					input_to_DUT[23:16] = pkt.full_packet[4*count + 2];
					input_to_DUT[31:24] = pkt.full_packet[4*count + 3];
					$display("time = %t  Ethernet_packet_driver :: drive_pkt_portA: input_to_DUT = %h  count = %d", $time, input_to_DUT, count);
					if(count == 0)
						begin
							Ethernet_driver_intf.Ethernet_driver_cb.inSop_B <= 1'b1;
							Ethernet_driver_intf.Ethernet_driver_cb.inData_B <= input_to_DUT;
							count ++;
						end
					else if(count == total_packet_words - 1)
						begin
							Ethernet_driver_intf.Ethernet_driver_cb.inEop_B <= 1'b1;
							Ethernet_driver_intf.Ethernet_driver_cb.inData_B <= input_to_DUT;
							count ++;
						end
					else if(count == total_packet_words)
						begin
							break;
						end
					else
						begin
							Ethernet_driver_intf.Ethernet_driver_cb.inData_B <= input_to_DUT;
							count ++;
						end
				end
		end
endtask
endclass
	
	


