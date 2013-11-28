`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:36:07 11/24/2012 
// Design Name: 
// Module Name:    ALU 
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
module ALU #(size = 16) (
		input[2:0] operation,
		input[(size-1):0] op1, op2,
		output reg[(size-1):0] out,
		output zero,
		output reg overflow
    );
	wire[(size-1):0] negop2;
	
	Negator #(size) negatorOp2  (op2,negop2);
	
	always @(operation, op1, op2)
	begin
		overflow = 1'b0;
		case(operation)
			3'b000: // +
				{overflow,out} = op1 + op2;
			3'b001: // -
				{overflow,out} = op1 + negop2;
			3'b010: // *
				{overflow,out} = 0;
			3'b011: // &
				out = op1 & op2;
			3'b100: // |
				out = op1 | op2;
			3'b101: // ~
				out = ~op1;
			default:
				out = 0;
		endcase
	end
	
	assign zero = ~|out;
endmodule
