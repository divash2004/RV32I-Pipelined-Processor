`timescale 1ns/1ps

module instruction_memory(

    input  wire [31:0] pc,
    output wire [31:0] instruction

);

reg [31:0] memory [0:1023];

initial begin
    memory[0]  = 32'h00A00093; // addi x1,x0,10
    memory[1]  = 32'h01400113; // addi x2,x0,20
    memory[2]  = 32'h002081B3; // add  x3,x1,x2
    memory[3]  = 32'h00302023; // sw   x3,0(x0)
    memory[4]  = 32'h00002203; // lw   x4,0(x0)
    memory[5]  = 32'h01E00293; // addi x5,x0,30
    memory[6]  = 32'h00521463; // bne  x4,x5,fail
    memory[7]  = 32'h0080006F; // jal  done
    memory[8]  = 32'h06300313; // fail: addi x6,x0,99
    memory[9]  = 32'h00100393; // done: addi x7,x0,1
    memory[10] = 32'h00000063; // loop: beq x0,x0,loop
end

assign instruction = memory[pc[11:2]];

endmodule