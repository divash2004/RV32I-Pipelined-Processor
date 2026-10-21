`timescale 1ns/1ps

module pc_mux (

    input  wire [31:0] pc_4,
    input  wire [31:0] target_address,
    input  wire [31:0] alu_result,

    input  wire [1:0] pc_sel,

    output reg  [31:0] next_pc

);

always @(*) begin

    case (pc_sel)

        2'b00: next_pc = pc_4;

        2'b01: next_pc = target_address;

        2'b10: next_pc = alu_result;

        default: next_pc = pc_4;

    endcase

end

endmodule