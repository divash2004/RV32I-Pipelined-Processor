`timescale 1ns/1ps

module main_control_unit (

    input  wire [6:0] opcode,
    input  wire [2:0] funct3,
    input  wire [6:0] funct7,

    output reg  [2:0] imm_sel,
    output reg        op1_sel,
    output reg        op2_sel,
    output reg  [4:0] alu_op,
    output reg  [2:0] branch_jump,
    output reg        mem_read,
    output reg        mem_write,
    output reg  [1:0] wb_sel,
    output reg        reg_write_en

);

    //============================================================
    // Opcode Encoding
    //============================================================

    localparam R_TYPE = 7'b0110011;
    localparam I_TYPE = 7'b0010011;
    localparam LOAD   = 7'b0000011;
    localparam STORE  = 7'b0100011;
    localparam BRANCH = 7'b1100011;
    localparam LUI    = 7'b0110111;
    localparam AUIPC  = 7'b0010111;
    localparam JAL    = 7'b1101111;
    localparam JALR   = 7'b1100111;

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
    // Main Decoder
    //============================================================

    always @(*) begin

        //--------------------------------------------------------
        // Default Control Signals
        //--------------------------------------------------------

        imm_sel      = 3'b000;
        op1_sel      = 1'b0;      // RS1
        op2_sel      = 1'b0;      // RS2
        alu_op       = ADD;
        branch_jump  = 3'b000;
        mem_read     = 1'b0;
        mem_write    = 1'b0;
        wb_sel       = 2'b00;     // ALU Result
        reg_write_en = 1'b0;

        case (opcode)

        //--------------------------------------------------------
        // R-Type
        //--------------------------------------------------------

        R_TYPE: begin

            reg_write_en = 1'b1;

            case (funct3)

                3'b000: alu_op = (funct7 == 7'b0100000) ? SUB : ADD;
                3'b001: alu_op = SLL;
                3'b010: alu_op = SLT;
                3'b011: alu_op = SLTU;
                3'b100: alu_op = XOR_OP;
                3'b101: alu_op = (funct7 == 7'b0100000) ? SRA : SRL;
                3'b110: alu_op = OR_OP;
                3'b111: alu_op = AND_OP;

                default: alu_op = ADD;

            endcase

        end

        //--------------------------------------------------------
        // I-Type Arithmetic
        //--------------------------------------------------------

        I_TYPE: begin

            imm_sel      = 3'b001;
            op2_sel      = 1'b1;
            reg_write_en = 1'b1;

            case (funct3)

                3'b000: alu_op = ADD;                         // ADDI
                3'b001: alu_op = SLL;                         // SLLI
                3'b010: alu_op = SLT;                         // SLTI
                3'b011: alu_op = SLTU;                        // SLTIU
                3'b100: alu_op = XOR_OP;                      // XORI
                3'b101: alu_op = (funct7 == 7'b0100000) ? SRA : SRL;
                3'b110: alu_op = OR_OP;                       // ORI
                3'b111: alu_op = AND_OP;                      // ANDI

                default: alu_op = ADD;

            endcase

        end

        //--------------------------------------------------------
        // Load Word (LW)
        //--------------------------------------------------------

        LOAD: begin

            imm_sel      = 3'b001;
            op2_sel      = 1'b1;
            alu_op       = ADD;

            mem_read     = 1'b1;

            wb_sel       = 2'b01;
            reg_write_en = 1'b1;

        end

        //--------------------------------------------------------
        // Store Word (SW)
        //--------------------------------------------------------

        STORE: begin

            imm_sel   = 3'b010;
            op2_sel   = 1'b1;
            alu_op    = ADD;

            mem_write = 1'b1;

        end

        //--------------------------------------------------------
        // Branch Instructions
        //--------------------------------------------------------

        BRANCH: begin

            imm_sel = 3'b011;

            case (funct3)

                3'b000: branch_jump = 3'b001;     // BEQ
                3'b001: branch_jump = 3'b010;     // BNE
                3'b100: branch_jump = 3'b011;     // BLT
                3'b101: branch_jump = 3'b100;     // BGE

                default: branch_jump = 3'b000;

            endcase

        end

        //--------------------------------------------------------
        // LUI
        //--------------------------------------------------------

        LUI: begin

            imm_sel      = 3'b100;
            op2_sel      = 1'b1;
            alu_op       = PASS_B;

            reg_write_en = 1'b1;

        end

        //--------------------------------------------------------
        // AUIPC
        //--------------------------------------------------------

        AUIPC: begin

            imm_sel      = 3'b100;
            op1_sel      = 1'b1;
            op2_sel      = 1'b1;
            alu_op       = ADD;

            reg_write_en = 1'b1;

        end

        //--------------------------------------------------------
        // JAL
        //--------------------------------------------------------

        JAL: begin

            imm_sel      = 3'b101;

            branch_jump  = 3'b101;

            wb_sel       = 2'b10;

            reg_write_en = 1'b1;

        end

        //--------------------------------------------------------
        // JALR
        //--------------------------------------------------------

        JALR: begin

            imm_sel      = 3'b001;
            op2_sel      = 1'b1;
            alu_op       = ADD;

            branch_jump  = 3'b110;

            wb_sel       = 2'b10;

            reg_write_en = 1'b1;

        end

    

        default: begin
            // Keep default control signals
        end

        endcase

    end

endmodule