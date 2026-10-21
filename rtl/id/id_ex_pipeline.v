`timescale 1ns/1ps

module id_ex_pipeline(

    //============================================================
    // Data Inputs
    //============================================================

    input  wire [31:0] pc_in,
    input  wire [31:0] pc_4_in,
    input  wire [31:0] rs1_data_in,
    input  wire [31:0] rs2_data_in,
    input  wire [31:0] imm_in,

    input  wire [4:0]  rs1_addr_in,
    input  wire [4:0]  rs2_addr_in,
    input  wire [4:0]  rd_addr_in,

    //============================================================
    // Control Inputs
    //============================================================

    input  wire        op1_sel_in,
    input  wire        op2_sel_in,
    input  wire [4:0]  alu_op_in,
    input  wire [2:0]  branch_jump_in,
    input  wire        mem_read_in,
    input  wire        mem_write_in,
    input  wire [1:0]  wb_sel_in,
    input  wire        reg_write_en_in,

    input  wire        clk,
    input  wire        reset,
    input  wire        enable,
    input  wire        flush,

    //============================================================
    // Data Outputs
    //============================================================

    output reg [31:0] pc_out,
    output reg [31:0] pc_4_out,
    output reg [31:0] rs1_data_out,
    output reg [31:0] rs2_data_out,
    output reg [31:0] imm_out,

    output reg [4:0]  rs1_addr_out,
    output reg [4:0]  rs2_addr_out,
    output reg [4:0]  rd_addr_out,

    //============================================================
    // Control Outputs
    //============================================================

    output reg        op1_sel_out,
    output reg        op2_sel_out,
    output reg [4:0]  alu_op_out,
    output reg [2:0]  branch_jump_out,
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

        pc_out           <= 32'b0;
        pc_4_out         <= 32'b0;
        rs1_data_out     <= 32'b0;
        rs2_data_out     <= 32'b0;
        imm_out          <= 32'b0;

        rs1_addr_out     <= 5'b0;
        rs2_addr_out     <= 5'b0;
        rd_addr_out      <= 5'b0;

        op1_sel_out      <= 1'b0;
        op2_sel_out      <= 1'b0;
        alu_op_out       <= 5'b0;
        branch_jump_out  <= 3'b0;
        mem_read_out     <= 1'b0;
        mem_write_out    <= 1'b0;
        wb_sel_out       <= 2'b0;
        reg_write_en_out <= 1'b0;

    end

    //------------------------------------------------------------
    // Flush (Insert Bubble)
    //------------------------------------------------------------

    else if (flush) begin

        pc_out           <= 32'b0;
        pc_4_out         <= 32'b0;
        rs1_data_out     <= 32'b0;
        rs2_data_out     <= 32'b0;
        imm_out          <= 32'b0;

        rs1_addr_out     <= 5'b0;
        rs2_addr_out     <= 5'b0;
        rd_addr_out      <= 5'b0;

        op1_sel_out      <= 1'b0;
        op2_sel_out      <= 1'b0;
        alu_op_out       <= 5'b0;
        branch_jump_out  <= 3'b0;
        mem_read_out     <= 1'b0;
        mem_write_out    <= 1'b0;
        wb_sel_out       <= 2'b0;
        reg_write_en_out <= 1'b0;

    end

    //------------------------------------------------------------
    // Normal Operation
    //------------------------------------------------------------

    else if (enable) begin

        pc_out           <= pc_in;
        pc_4_out         <= pc_4_in;
        rs1_data_out     <= rs1_data_in;
        rs2_data_out     <= rs2_data_in;
        imm_out          <= imm_in;

        rs1_addr_out     <= rs1_addr_in;
        rs2_addr_out     <= rs2_addr_in;
        rd_addr_out      <= rd_addr_in;

        op1_sel_out      <= op1_sel_in;
        op2_sel_out      <= op2_sel_in;
        alu_op_out       <= alu_op_in;
        branch_jump_out  <= branch_jump_in;
        mem_read_out     <= mem_read_in;
        mem_write_out    <= mem_write_in;
        wb_sel_out       <= wb_sel_in;
        reg_write_en_out <= reg_write_en_in;

    end

end

endmodule