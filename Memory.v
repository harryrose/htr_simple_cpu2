`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:16:00 11/24/2012 
// Design Name: 
// Module Name:    Memory 
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
module Memory(
	input read,
	input write,
	input [(MEM_ADDR_SIZE-1):0] address_in,
	input [(WORD_SIZE-1):0] data_in,
	output [(WORD_SIZE-1):0] out
   );
	parameter INST_SIZE = 6;
	parameter REG_ADDR_SIZE = 4;
	parameter MEM_ADDR_SIZE = 6;
	parameter WORD_SIZE  = (INST_SIZE + REG_ADDR_SIZE + MEM_ADDR_SIZE);

	reg [(WORD_SIZE-1):0] storage [0:63];
	reg [(WORD_SIZE-1):0] data_out;
	
	assign out = data_out;
	
	always @(read or write or address_in)
		if(read) data_out = storage[address_in];
		else if(write) storage[address_in] = data_in;
		else data_out = 'hZ;

	integer i;
	initial begin
	
		for( i = 0; i < 64; i = i +1)
			storage[i] = i;
			
		// 000001 000101 0000
		// 0000 0100 0101 0000
		// 0450
		
		// 000001 000110 0001
		// 0000 0100 0110 0001
		// 0461
		
		// 001001 000000 0000
		// 0010 0100 0000 0000
		// 2400
		
		// 000010 000101 0010
		// 0000 1000 0101 0010
		// 0852
		
		// 000011 000000 0000
		// 0000 1100 0000 0000
		// 0C00
		storage[0] = 16'h0450; // load address 5 into alu1
		storage[1] = 16'h0461; // load address 6 into alu2
		storage[2] = 16'h2400; // add the two together
		storage[3] = 16'h0852; // store the accumulator into address 5
		storage[4] = 16'h0C00; // jump back to 0.
		storage[5] = 16'h00000;
		storage[6] = 16'h00001;
	end
endmodule
