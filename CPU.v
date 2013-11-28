`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    14:22:55 11/24/2012 
// Design Name: 
// Module Name:    CPU 
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
module CPU(
	input clock,
	input reset,
	output mem_read, mem_write, 
   output[(MEM_ADDR_SIZE-1):0] mem_address_bus,
	output[(WORD_SIZE-1):0] mem_data_in, mem_data_out
	 );
	 
	parameter INST_SIZE = 6;
	parameter REG_ADDR_SIZE = 4;
	parameter MEM_ADDR_SIZE = 6;
	parameter WORD_SIZE  = (INST_SIZE + REG_ADDR_SIZE + MEM_ADDR_SIZE);	 
	 
	wire [(INST_SIZE-1):0] opcode;
	wire [(REG_ADDR_SIZE-1):0] register;

	wire 		alu_zero, alu_overflow, ld_alu1, ld_alu2, ld_acc, ld_pc, ld_ir;
	wire[1:0] 	pc_src, alu1_src_mux_control, alu2_src_mux_control, 
				acc_src_mux_control, mem_data_select_control, mem_addr_select_control;
	wire[2:0] 	alu_operation;
	 
	Controller controllerUnit ( clock, reset, opcode,register, alu_zero, alu_overflow, ld_alu1, ld_alu2, ld_acc, ld_pc, ld_ir, pc_src,
					mem_read, mem_write, alu_operation, alu1_src_mux_control, alu2_src_mux_control,
					acc_src_mux_control, mem_data_select_control, mem_addr_select_control );

	 DataPath dataPathUnit ( 	clock, reset, ld_alu1, ld_alu2, ld_pc, ld_acc, ld_ir, pc_src, alu_operation, alu1_src_mux_control,
										alu2_src_mux_control, acc_src_mux_control, mem_data_select_control, mem_addr_select_control,
										opcode, alu_zero, alu_overflow, mem_address_bus, mem_data_in, mem_data_out, register);
endmodule
