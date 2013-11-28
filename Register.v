`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:24:13 11/24/2012 
// Design Name: 
// Module Name:    Register 
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
module Register # ( Size = 16, ResetValue = 0)
	(
		input	 clock, clock_en, reset,
		input [(Size - 1):0] data_in,
		output [(Size -1):0] out
    );
	reg [(Size - 1):0] data_out;
	
	assign out = data_out;
	
	always @(posedge clock, posedge reset)
		begin
			if(reset) data_out <= ResetValue;
			else if(clock_en) data_out <= data_in;
		end
		
	initial
		data_out = 0;
endmodule
