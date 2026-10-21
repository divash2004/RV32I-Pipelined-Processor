`timescale 1ns/1ps

module pc_4_adder (
    input  wire [31:0] pc,
    output wire [31:0] pc_4
);

assign pc_4 = pc + 32'd4;

endmodule