`timescale 1ns/1ps

module branch_comparator (

    //============================================================
    // Data Inputs
    //============================================================

    input  wire [31:0] rs1_data,
    input  wire [31:0] rs2_data,

    //============================================================
    // Control Input
    //============================================================

    input  wire [2:0]  branch_jump,

    //============================================================
    // Control Output
    //============================================================

    output reg         branch_taken

);

always @(*) begin

    case (branch_jump)

        // BEQ
        3'b001:
            branch_taken = (rs1_data == rs2_data);

        // BNE
        3'b010:
            branch_taken = (rs1_data != rs2_data);

        // BLT
        3'b011:
            branch_taken = ($signed(rs1_data) < $signed(rs2_data));

        // BGE
        3'b100:
            branch_taken = ($signed(rs1_data) >= $signed(rs2_data));

        // Not a conditional branch
        default:
            branch_taken = 1'b0;

    endcase

end

endmodule