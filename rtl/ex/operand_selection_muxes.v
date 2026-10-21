`timescale 1ns/1ps

module operand_selection_muxes (

    //============================================================
    // Data Inputs
    //============================================================

    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,
    input  wire [31:0] imm,
    input  wire [31:0] pc,

    input  wire [31:0] ex_mem_alu_result,
    input  wire [31:0] mem_wb_write_data,

    //============================================================
    // Control Inputs
    //============================================================

    input  wire        op1_sel,
    input  wire        op2_sel,
    input  wire [1:0]  forwardA,
    input  wire [1:0]  forwardB,

    //============================================================
    // Data Outputs
    //============================================================

    output reg [31:0] operand_a,
    output reg [31:0] operand_b

);

    //------------------------------------------------------------
    // Internal Signals
    //------------------------------------------------------------

    reg [31:0] rs1_forwarded;
    reg [31:0] rs2_forwarded;

    //------------------------------------------------------------
    // Forwarding MUX for RS1
    //------------------------------------------------------------

    always @(*) begin

        case (forwardA)

            2'b00: rs1_forwarded = rs1_data;
            2'b01: rs1_forwarded = mem_wb_write_data;
            2'b10: rs1_forwarded = ex_mem_alu_result;

            default: rs1_forwarded = rs1_data;

        endcase

    end

    //------------------------------------------------------------
    // Forwarding MUX for RS2
    //------------------------------------------------------------

    always @(*) begin

        case (forwardB)

            2'b00: rs2_forwarded = rs2_data;
            2'b01: rs2_forwarded = mem_wb_write_data;
            2'b10: rs2_forwarded = ex_mem_alu_result;

            default: rs2_forwarded = rs2_data;

        endcase

    end

    //------------------------------------------------------------
    // Operand A Selection
    //------------------------------------------------------------

    always @(*) begin

        case (op1_sel)

            1'b0: operand_a = rs1_forwarded;
            1'b1: operand_a = pc;

        endcase

    end

    //------------------------------------------------------------
    // Operand B Selection
    //------------------------------------------------------------

    always @(*) begin

        case (op2_sel)

            1'b0: operand_b = rs2_forwarded;
            1'b1: operand_b = imm;

        endcase

    end

endmodule