`timescale 1ns/1ps

module branch_target_adder (

    input  wire [31:0] pc,
    input  wire [31:0] imm,

    output wire [31:0] target_address

);

assign target_address = pc + imm;

endmodule