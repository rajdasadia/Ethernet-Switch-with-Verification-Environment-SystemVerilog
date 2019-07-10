//******************************************************************************************************************************************************
//Ethernet Testbench Environment package
//This package consists of all the testbench components which are packet class, packet generator, packet driver, monitor and packet checker
//This package also has a class which creates instances of mailboxes and passes them into each class for their respective operations on their mailboxes
//This class again uses virtual interface which will point to the actual interface in the testbench module
//*******************************************************************************************************************************************************

package Ethernet_tb_env_package;

`include "Ethernet_packet.sv"
`include "Ethernet_packet_generator.sv"
`include "Ethernet_packet_driver.sv"
`include "Ethernet_monitor.sv"
`include "Ethernet_packet_checker.sv"

class Ethernet_tb_env;

Ethernet_packet_generator packet_generator;
Ethernet_packet_driver packet_driver;
Ethernet_monitor packet_monitor;
Ethernet_packet_checker packet_checker;
string env_name;
mailbox mbx_gen_driver;           //mailbox this is inputted at generator and outputted at the driver
mailbox mbx_mon_checker[4];          // 4 mailboxes that are inputted at the monitor and outputted at the checker

virtual Ethernet_interface rtl_intf;            //Virtual interface which will point to the actual static interface in the testbench module

function new(string env_name,virtual Ethernet_interface rtl_intf );

	this.env_name = env_name;
	this.rtl_intf = rtl_intf;
	mbx_gen_driver = new();
	packet_generator = new(mbx_gen_driver);
	packet_driver = new(mbx_gen_driver, rtl_intf);
	for(int i = 0; i < 4; i++)
		begin
			mbx_mon_checker[i] = new();
			$display("Creating mailbox for monitor to checker, mailbox number = %d", i);
		end
	packet_monitor = new(mbx_mon_checker, rtl_intf);
	packet_checker= new(mbx_mon_checker);
endfunction

task run();
$display("Ethernet_tb_env::run() called");
	fork
		packet_generator.run();
		packet_driver.run();
		packet_monitor.run();
		packet_checker.run();
	join
endtask

endclass: Ethernet_tb_env

endpackage: Ethernet_tb_env_package
	

