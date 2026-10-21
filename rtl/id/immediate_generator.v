`timescale 1ns/1ps

module immediate_generator (

    input  wire [31:0] instruction,
    input  wire [2:0]  imm_sel,

    output reg  [31:0] imm

);

always @(*) begin

    case (imm_sel)

        // R-Type
        3'b000:
            imm = 32'b0;

        // I-Type
        3'b001:
            imm = {{20{instruction[31]}},
                   instruction[31:20]};

        // S-Type
        3'b010:
            imm = {{20{instruction[31]}},
                   instruction[31:25],
                   instruction[11:7]};

        // B-Type
        3'b011:
            imm = {{19{instruction[31]}},
                   instruction[31],
                   instruction[7],
                   instruction[30:25],
                   instruction[11:8],
                   1'b0};

        // U-Type
        3'b100:
            imm = {instruction[31:12],
                   12'b0};

        // J-Type
        3'b101:
            imm = {{11{instruction[31]}},
                   instruction[31],
                   instruction[19:12],
                   instruction[20],
                   instruction[30:21],
                   1'b0};

        default:
            imm = 32'b0;

    endcase

end

endmodule