`timescale 1ns/1ps

module writeback_mux (

    input  wire [31:0] alu_result,
    input  wire [31:0] dmem_data,
    input  wire [31:0] pc_4,

    input  wire [1:0]  wb_sel,

    output reg  [31:0] write_data

);

always @(*) begin

    case (wb_sel)

        2'b00: write_data = alu_result;
        2'b01: write_data = dmem_data;
        2'b10: write_data = pc_4;

        default: write_data = 32'b0;

    endcase

end

endmodule