`timescale 1ns/1ps

module ex_mem_pipeline (

    //============================================================
    // Data Inputs
    //============================================================

    input  wire [31:0] pc_4_in,
    input  wire [31:0] alu_result_in,
    input  wire [31:0] rs2_data_in,
    input  wire [4:0]  rd_addr_in,

    //============================================================
    // Control Inputs
    //============================================================

    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire [1:0]  wb_sel_in,
    input  wire        reg_write_en_in,

    input  wire        clk,
    input  wire        reset,
    input  wire        enable,

    //============================================================
    // Data Outputs
    //============================================================

    output reg [31:0] pc_4_out,
    output reg [31:0] alu_result_out,
    output reg [31:0] rs2_data_out,
    output reg [4:0]  rd_addr_out,

    //============================================================
    // Control Outputs
    //============================================================

    output reg        mem_read_out,
    output reg        mem_write_out,
    output reg [1:0]  wb_sel_out,
    output reg        reg_write_en_out

);

always @(posedge clk or posedge reset) begin

    //------------------------------------------------------------
    // Reset
    //------------------------------------------------------------

    if (reset) begin

        pc_4_out         <= 32'b0;
        alu_result_out   <= 32'b0;
        rs2_data_out     <= 32'b0;
        rd_addr_out      <= 5'b0;

        mem_read_out     <= 1'b0;
        mem_write_out    <= 1'b0;
        wb_sel_out       <= 2'b0;
        reg_write_en_out <= 1'b0;

    end

    //------------------------------------------------------------
    // Normal Operation
    //------------------------------------------------------------

    else if (enable) begin

        pc_4_out         <= pc_4_in;
        alu_result_out   <= alu_result_in;
        rs2_data_out     <= rs2_data_in;
        rd_addr_out      <= rd_addr_in;

        mem_read_out     <= mem_read_in;
        mem_write_out    <= mem_write_in;
        wb_sel_out       <= wb_sel_in;
        reg_write_en_out <= reg_write_en_in;

    end

end

endmodule