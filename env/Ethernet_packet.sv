//*************************************************************
//Ethernet Packet Class
//This class defines all the properties of an ethernet packet
//This class is part of Testbench for Ethernet DUT
//*************************************************************

class Ethernet_packet;

	rand bit [31:0] source_address;
	rand bit [31:0] destination_address;
	rand byte packet_data[$];                 //queue of packet data without Source add, dest add and crc
	bit [31:0] packet_CRC;
	int packet_size;                         //Total size of the packet
	byte full_packet[$];                     //Queue of full ethernet Packet with source and destination address and CRC

	function new();
	endfunction
		
	function void build_packet(); 	                   //function to create build entire packet
		int packet_size;
		packet_size = $urandom_range(4,24);           //minimum size of the packet should be 4 Bytes and max should be 24 Bytes
		packet_size = (packet_size>>2)<<2;
		for( int i = 0; i<= packet_size; i++)
			begin
				packet_data.push_back($urandom());
			end
	endfunction
	
	function void build_crc();
		packet_CRC = 32'hABCDDEAD;
	endfunction
	
	function void build_address();
		int random_num;
		random_num = $urandom_range(0,3);
		case(random_num)
		 0:
			begin
				source_address = 16'hABCD;
				destination_address = 16'hBEEF;
			end
		1:
			begin
				source_address = 16'hBEEF;
				destination_address = 16'hABCD;
			end
		2:
			begin
				source_address = 16'hABCD;
				destination_address = 16'hABCD;
			end
		3:
			begin
				source_address = 16'hBEEF;
				destination_address = 16'hBEEF;
			end
		endcase
	endfunction
	
	function void post_randomize();
		packet_size = packet_data.size() +4 +4 +4; //size of data + source add + dest add + CRC all in bytes
		build_address();
		build_packet();
		build_crc();
		for( int i = 0; i <4 ; i++)
			begin
				full_packet.push_back(destination_address >> i*8);     //adding destination address in the ethernet packet
			end
		for( int i = 0; i <4 ; i++)
			begin
				full_packet.push_back(source_address >> i*8);         //adding source address to the Ethernet packet queue
			end
		for( int i = 0; i <= packet_data.size(); i++)
			begin
				full_packet.push_back(packet_data[i]);                //adding source address to the Data packet queue
			end
		for( int i = 0; i <4 ; i++)
			begin
				full_packet.push_back(packet_CRC >> i*8);            //adding source CRC to the Ethernet packet queue
			end
	endfunction
	
			
	function bit packet_compare(Ethernet_packet pkt);
		if(this.full_packet == full_packet)
			begin
				return 1;
			end
		else
		
			begin
				return 0;
			end
	endfunction
	
	function string packet_details();
		string details;
		details = $psprintf("sa = %x da = %x crc = %x", source_address, destination_address, packet_CRC);
		return details;
	endfunction
	
	
endclass : Ethernet_packet
	
		


