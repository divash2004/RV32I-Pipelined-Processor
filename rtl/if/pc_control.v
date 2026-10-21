`timescale 1ns/1ps

module pc_control (

    input  wire [2:0] branch_jump,
    input  wire       branch_taken,

    output reg  [1:0] pc_sel

);

always @(*) begin

    case (branch_jump)

        3'b001,
        3'b010,
        3'b011,
        3'b100:
            pc_sel = branch_taken ? 2'b01 : 2'b00;

        3'b101:
            pc_sel = 2'b01;

        3'b110:
            pc_sel = 2'b10;

        default:
            pc_sel = 2'b00;

    endcase

end

endmodule