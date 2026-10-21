`timescale 1ns/1ps

module hazard_detection_unit (

    input  wire [4:0] id_rs1_addr,
    input  wire [4:0] id_rs2_addr,
    input  wire [4:0] id_ex_rd_addr,

    input  wire       id_ex_mem_read,

    output reg        pc_enable,
    output reg        if_id_enable,
    output reg        id_ex_flush

);

always @(*) begin

    if (id_ex_mem_read &&
        (id_ex_rd_addr != 5'd0) &&
        ((id_ex_rd_addr == id_rs1_addr) ||
         (id_ex_rd_addr == id_rs2_addr))) begin

        pc_enable    = 1'b0;
        if_id_enable = 1'b0;
        id_ex_flush  = 1'b1;

    end
    else begin

        pc_enable    = 1'b1;
        if_id_enable = 1'b1;
        id_ex_flush  = 1'b0;

    end

end

endmodule