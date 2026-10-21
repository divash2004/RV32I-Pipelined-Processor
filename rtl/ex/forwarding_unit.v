`timescale 1ns/1ps

module forwarding_unit (

    //============================================================
    // Data Inputs
    //============================================================

    input  wire [4:0] id_ex_rs1_addr,
    input  wire [4:0] id_ex_rs2_addr,
    input  wire [4:0] ex_mem_rd_addr,
    input  wire [4:0] mem_wb_rd_addr,

    //============================================================
    // Control Inputs
    //============================================================

    input  wire       ex_mem_reg_write_en,
    input  wire       mem_wb_reg_write_en,

    //============================================================
    // Control Outputs
    //============================================================

    output reg [1:0] forwardA,
    output reg [1:0] forwardB

);

always @(*) begin

    //------------------------------------------------------------
    // Default: No Forwarding
    //------------------------------------------------------------

    forwardA = 2'b00;
    forwardB = 2'b00;

    //------------------------------------------------------------
    // ForwardA (RS1)
    //------------------------------------------------------------

    if (ex_mem_reg_write_en &&
        (ex_mem_rd_addr != 5'd0) &&
        (ex_mem_rd_addr == id_ex_rs1_addr)) begin

        forwardA = 2'b10;

    end
    else if (mem_wb_reg_write_en &&
             (mem_wb_rd_addr != 5'd0) &&
             (mem_wb_rd_addr == id_ex_rs1_addr)) begin

        forwardA = 2'b01;

    end

    //------------------------------------------------------------
    // ForwardB (RS2)
    //------------------------------------------------------------

    if (ex_mem_reg_write_en &&
        (ex_mem_rd_addr != 5'd0) &&
        (ex_mem_rd_addr == id_ex_rs2_addr)) begin

        forwardB = 2'b10;

    end
    else if (mem_wb_reg_write_en &&
             (mem_wb_rd_addr != 5'd0) &&
             (mem_wb_rd_addr == id_ex_rs2_addr)) begin

        forwardB = 2'b01;

    end

end

endmodule