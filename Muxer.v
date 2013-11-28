`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:32:02 11/24/2012 
// Design Name: 
// Module Name:    Muxer 
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
module Muxer2To1 #(size = 16)
	(
		input[(size-1):0] a, b,
		input control,
		output[(size-1):0] out
    );

	assign out = control ? b : a;
	
endmodule

module Muxer3To1 #(size = 16)
	(
		input[(size-1):0] a,b,c,
		input[1:0] control,
		output reg[(size-1):0] out
	);
	
	always @(a,b,c,control)
		case(control)
			2'b00:
				out = a;
			2'b01:
				out = b;
			2'b10:
				out = c;
			2'b11:
				out = 0;
		endcase
endmodule

module Muxer4To1 #(size = 16)
	(
		input[(size-1):0] a,b,c,d,
		input[1:0] control,
		output reg[(size-1):0] out
	);
	
	always @(a,b,c,control)
		case(control)
			2'b00:
				out = a;
			2'b01:
				out = b;
			2'b10:
				out = c;
			2'b11:
				out = d;
		endcase
endmodule