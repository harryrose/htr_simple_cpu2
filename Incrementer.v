`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:29:21 11/24/2012 
// Design Name: 
// Module Name:    Incrementer 
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
module Incrementer #(size = 16, amount = 1)
	(
		input  [(size - 1): 0] data_in,
		output [(size - 1): 0] data_out
    );

	assign data_out = data_in + amount;
endmodule
