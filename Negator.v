`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:43:26 11/24/2012 
// Design Name: 
// Module Name:    Negator 
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
module Negator #(size = 16) (
		input [(size-1):0] in,
		output[(size-1):0] out
    );
	
	assign out = (~in) + 1;
endmodule
