`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:53:11 11/24/2012 
// Design Name: 
// Module Name:    DataPath 
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


module DataPath(
		input clock,
		input reset,
		input ld_alu1,
		input ld_alu2,
		input ld_pc,
		input ld_acc,
		input ld_ir,
		input[1:0] pc_src,
		input[2:0] alu_operation,
		input[1:0] alu1_src_mux_control,
		input[1:0] alu2_src_mux_control,
		input[1:0] acc_src_mux_control,
		input[1:0] mem_data_select_control,
		input[1:0] mem_addr_select_control,
		output[(INST_SIZE-1):0] opcode,
		output alu_zero,
		output alu_overflow,
		output[(MEM_ADDR_SIZE-1):0] mem_address_bus,
		input [(WORD_SIZE-1):0] mem_data_in,
		output[(WORD_SIZE-1):0] mem_data_out,
		output[(REG_ADDR_SIZE-1):0] register
	);

	parameter INST_SIZE = 6;
	parameter REG_ADDR_SIZE = 4;
	parameter MEM_ADDR_SIZE = 6;
	parameter WORD_SIZE  = (INST_SIZE + REG_ADDR_SIZE + MEM_ADDR_SIZE);

	wire alu_zero, alu_overflow;
	wire [(MEM_ADDR_SIZE-1):0] ir_op1;
	wire [(REG_ADDR_SIZE-1):0] ir_op2;
	
	wire [(WORD_SIZE-1):0] alu1_data_in, alu2_data_in, alu1_data_out, alu2_data_out, alu_out, acc_data_out, acc_data_in, ir_data_in;
	wire [(MEM_ADDR_SIZE-1):0] pc_data_out, pc_data_in, pc_inc;
	
	//Muxer3To1 #(MEM_ADDR_SIZE) alu1_src_mux ( 
	wire [(WORD_SIZE-1):0] muxer_ir_input,ir_data_out;
	
	
	assign muxer_ir_input = {{(MEM_ADDR_SIZE + REG_ADDR_SIZE){1'b0}}, ir_op1};
	
	Muxer4To1 #(WORD_SIZE) mem_data_select( 'hz, acc_data_out, alu1_data_out, alu2_data_out, mem_data_select_control, mem_data_out );
	Muxer4To1 #(MEM_ADDR_SIZE) mem_addr_select ('hz,ir_op1,pc_data_out,acc_data_out, mem_addr_select_control, mem_address_bus);
	
	Muxer3To1 #(WORD_SIZE) acc_src_mux (alu_out,muxer_ir_input, mem_data_in, acc_src_mux_control, acc_data_in);
	Muxer3To1 #(WORD_SIZE) alu1_src_mux (acc_data_out, muxer_ir_input, mem_data_in, alu1_src_mux_control, alu1_data_in);
	Muxer3To1 #(WORD_SIZE) alu2_src_mux (acc_data_out, muxer_ir_input, mem_data_in, alu2_src_mux_control, alu2_data_in);
	
	Muxer3To1 #(MEM_ADDR_SIZE) pc_src_mux (pc_inc,ir_op1,acc_data_out,pc_src,pc_data_in);
	
	Incrementer #(MEM_ADDR_SIZE) pc_incrementer (pc_data_out,pc_inc);
	
	Register #(WORD_SIZE) alu1 ( clock, ld_alu1,  reset, alu1_data_in, alu1_data_out);
	Register #(WORD_SIZE) alu2 ( clock, ld_alu2,  reset, alu2_data_in, alu2_data_out);
	Register #(WORD_SIZE) acc (clock, ld_acc,  reset, acc_data_in, acc_data_out);
	Register #(WORD_SIZE) ir ( clock, ld_ir,  reset, ir_data_in, ir_data_out );
	
	Register #(MEM_ADDR_SIZE) pc (clock, ld_pc,   reset, pc_data_in, pc_data_out);
	
	ALU #(WORD_SIZE) alu(alu_operation, alu1_data_out, alu2_data_out, alu_out, alu_zero, alu_overflow);
	
	assign ir_data_in = mem_data_in;
	assign opcode = ir_data_out[(WORD_SIZE-1):(WORD_SIZE-INST_SIZE)];
	assign ir_op1 = ir_data_out[(WORD_SIZE-INST_SIZE-1):(WORD_SIZE-INST_SIZE-MEM_ADDR_SIZE)];
	assign ir_op2 = ir_data_out[(WORD_SIZE-INST_SIZE-MEM_ADDR_SIZE-1):0];
	assign register = ir_op2;
endmodule
