`timescale 1ns/1ps

module alu (

    //============================================================
    // Data Inputs
    //============================================================

    input  wire [31:0] operand_a,
    input  wire [31:0] operand_b,

    //============================================================
    // Control Input
    //============================================================

    input  wire [4:0]  alu_op,

    //============================================================
    // Data Output
    //============================================================

    output reg [31:0] alu_result

);

    //============================================================
    // ALU Operation Encoding
    //============================================================

    localparam ADD    = 5'b00000;
    localparam SUB    = 5'b00001;
    localparam AND_OP = 5'b00010;
    localparam OR_OP  = 5'b00011;
    localparam XOR_OP = 5'b00100;
    localparam SLL    = 5'b00101;
    localparam SRL    = 5'b00110;
    localparam SRA    = 5'b00111;
    localparam SLT    = 5'b01000;
    localparam SLTU   = 5'b01001;
    localparam PASS_B = 5'b01010;

    //============================================================
    // ALU
    //============================================================

    always @(*) begin

        case (alu_op)

            //----------------------------------------------------
            // Arithmetic
            //----------------------------------------------------

            ADD:
                alu_result = operand_a + operand_b;

            SUB:
                alu_result = operand_a - operand_b;

            //----------------------------------------------------
            // Logical
            //----------------------------------------------------

            AND_OP:
                alu_result = operand_a & operand_b;

            OR_OP:
                alu_result = operand_a | operand_b;

            XOR_OP:
                alu_result = operand_a ^ operand_b;

            //----------------------------------------------------
            // Shift
            //----------------------------------------------------

            SLL:
                alu_result = operand_a << operand_b[4:0];

            SRL:
                alu_result = operand_a >> operand_b[4:0];

            SRA:
                alu_result = $signed(operand_a) >>> operand_b[4:0];

            //----------------------------------------------------
            // Comparison
            //----------------------------------------------------

            SLT:
                alu_result = ($signed(operand_a) < $signed(operand_b))
                             ? 32'd1 : 32'd0;

            SLTU:
                alu_result = (operand_a < operand_b)
                             ? 32'd1 : 32'd0;

            //----------------------------------------------------
            // Pass Through
            //----------------------------------------------------

            PASS_B:
                alu_result = operand_b;

            //----------------------------------------------------
            // Reserved
            //----------------------------------------------------

            default:
                alu_result = 32'b0;

        endcase

    end

endmodule