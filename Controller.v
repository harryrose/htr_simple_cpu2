`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    13:09:23 11/24/2012 
// Design Name: 
// Module Name:    Controller 
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
module Controller(
		input clock,
		input reset,
		input [(INST_SIZE-1):0] opcode,
		input [(REG_ADDR_SIZE-1):0] register,
		input alu_zero,
		input alu_overflow,
		output reg ld_alu1,
		output reg ld_alu2,
		output reg ld_acc,
		output reg ld_pc,
		output reg ld_ir,
		output reg [1:0] pc_src,
		output reg mem_read,
		output reg mem_write,
		output reg [2:0] alu_operation,
		output reg [1:0] alu1_src_mux_control,
		output reg [1:0] alu2_src_mux_control,
		output reg [1:0] acc_src_mux_control,
		output reg [1:0] mem_data_select_control,
		output reg [1:0] mem_addr_select_control
	   );

	parameter INST_SIZE = 6;
	parameter REG_ADDR_SIZE = 4;
	parameter MEM_ADDR_SIZE = 6;
	parameter WORD_SIZE  = (INST_SIZE + REG_ADDR_SIZE + MEM_ADDR_SIZE);

`define fetch   2'b00
`define decode  2'b01
`define execute 2'b10
`define reset	 2'b11

`define _reg_alu1 4'b0000
`define _reg_alu2 4'b0001
`define _reg_acc  4'b0010

	wire [1:0] nextState;
	reg [1:0] currentState;
	assign  nextState = currentState +1;
	
	always @(posedge clock) begin
		ld_ir = 1'b0;
		ld_alu1 = 1'b0;
		ld_alu2 = 1'b0;
		ld_pc = 1'b0;
		pc_src = 1'b0;
		mem_read = 1'b0;
		mem_write = 1'b0;
		alu_operation = 3'b0;
		alu1_src_mux_control = 2'b0;
		alu2_src_mux_control = 2'b0;
		acc_src_mux_control = 2'b0;
		mem_data_select_control = 2'b0;
		mem_addr_select_control = 2'b0;
		
		case (currentState)
			`fetch:
				begin
				// Put instruction address from PC on address bus and issue a read into the instruction register
					mem_addr_select_control = 2'b10;
					ld_ir = 1'b1;
					mem_read = 1'b1;
				end
				
			`decode:
				begin
				
				end
				
			`execute:
				begin
					case (opcode)
						6'b000000:
							begin
								//noop
							end
						6'b000001:
							begin
								//load from memory
								// load <memory address> register
								mem_addr_select_control = 2'b01;
								mem_read = 1'b1;
								
								case ( register )
									`_reg_alu1: // alu1
										begin
											ld_alu1 = 1;
											alu1_src_mux_control = 2'b10;
										end
									
									`_reg_alu2:	// alu2
										begin
											ld_alu2 = 1;
											alu2_src_mux_control = 2'b10;
										end
										
									`_reg_acc:	// alu2
										begin
											ld_acc = 1;
											acc_src_mux_control = 2'b10;
										end
								endcase
							end
						6'b000010:
							begin
								// Store to memory
								// sto <memory address> register
								mem_addr_select_control = 2'b01;
								mem_write = 1'b1;
								
								case ( register )
									`_reg_alu1:
										begin
											mem_data_select_control = 2'b10;
										end
										
									`_reg_alu2:
										begin
											mem_data_select_control = 2'b11;
										end
										
									`_reg_acc:
										begin
											mem_data_select_control = 2'b01;
										end
								endcase
							end
						6'b000011:
							// Jump to a specific memory address
							// jmpi <addr>
							begin
								pc_src = 2'b01;
								ld_pc = 1;
							end
						6'b000100:
							// Jump to an address held in the accumulator
							// jmp
							begin
								pc_src = 2'b10;
								ld_pc =1;
							end
						6'b000101:
							// Jump to an address if acc is zero
							// jzi <addr>
							begin
								pc_src = alu_zero ? 2'b01: 2'b00;
								ld_pc = 1;
							end
							
						6'b000110:
							//Jump to an address in a register if acc is zero
							// jz  000000 <register>
							begin
								
							end
							
						6'b000111:
							//Jump to an address if acc is not zero
							// jnzi <addr>
							begin
								pc_src = alu_zero ?  2'b00 : 2'b01;
								ld_pc = 1;
							end
							
						6'b001000:
							//Jump to an address held by a register if acc is not zero
							// jnz 000000 <register>
							begin
							end
							
						6'b001001:
							// Add alu1 and alu2 and store the result in acc
							begin
								alu_operation = 3'b000;
								acc_src_mux_control = 3'b00;
								ld_acc = 1;
							end
							
						6'b001010:
							// Subtract alu2 from alu1 and store the resutl in acc
							begin
								alu_operation = 3'b001;
								acc_src_mux_control = 3'b00;
								ld_acc = 1;
							end
						/*6'b000100:
						6'b000101:
						6'b000110:
						6'b000111:
						6'b001000:
						6'b001001:
						6'b001010:
						6'b001011:
						6'b001100:
						6'b001101:
						6'b001110:
						6'b001111:
						6'b010000:
						6'b010001:
						6'b010010:
						6'b010011:
						6'b010100:
						6'b010101:
						6'b010110:
						6'b010111:
						6'b011000:
						6'b011001:
						6'b011010:
						6'b011011:
						6'b011100:
						6'b011101:
						6'b011110:*/
						default:
							begin
								//noop
							end
					endcase
					
					ld_pc = 1; // increment the program counter (or load it from memory, whatever).
				end
				
			`reset:
				begin
				
				end
				
		endcase
		
		currentState = reset? `fetch : nextState;
	end
		
endmodule
