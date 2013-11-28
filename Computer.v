`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:34:14 11/24/2012 
// Design Name: 
// Module Name:    Computer 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module Computer(
    );
	 
	parameter INST_SIZE = 6;
	parameter REG_ADDR_SIZE = 4;
	parameter MEM_ADDR_SIZE = 6;
	parameter WORD_SIZE  = (INST_SIZE + REG_ADDR_SIZE + MEM_ADDR_SIZE);
	
	wire mem_read, mem_write;
	wire [(MEM_ADDR_SIZE-1):0] mem_address_bus;
	wire [(WORD_SIZE-1):0] data_to_mem, data_from_mem;
	
	reg clock, reset;
	
	Memory memory( mem_read, mem_write, mem_address_bus, data_to_mem, data_from_mem);

	CPU cpu( clock, reset, mem_read, mem_write, mem_address_bus,data_from_mem, data_to_mem);
	
	/*initial begin
		clock = 1'b0;
		reset = 1'b1;
		#10 reset <= 1'b0;
		#1000 $finish;
	end
	
	always #5 clock <= ~clock;
	*/
endmodule
