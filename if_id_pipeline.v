`timescale 1ns/1ps

module if_id_pipeline (

    input  wire        clk,
    input  wire        reset,
    input  wire        enable,
    input  wire        flush,

    input  wire [31:0] pc_in,
    input  wire [31:0] pc_4_in,
    input  wire [31:0] instruction_in,

    output reg  [31:0] pc_out,
    output reg  [31:0] pc_4_out,
    output reg  [31:0] instruction_out

);

always @(posedge clk or posedge reset) begin

    if (reset) begin
        pc_out          <= 32'b0;
        pc_4_out        <= 32'b0;
        instruction_out <= 32'b0;
    end

    else if (flush) begin
        pc_out          <= 32'b0;
        pc_4_out        <= 32'b0;
        instruction_out <= 32'b0;
    end

    else if (enable) begin
        pc_out          <= pc_in;
        pc_4_out        <= pc_4_in;
        instruction_out <= instruction_in;
    end

end

endmodule