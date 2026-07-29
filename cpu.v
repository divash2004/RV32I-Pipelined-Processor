`timescale 1ns/1ps



module cpu(
    input  wire clk,
    input  wire reset,

    output wire [15:0] led
);

//============================================================
// if Stage
//============================================================
wire [31:0] pc;
wire [31:0] next_pc;
wire [31:0] pc_4;
wire [31:0] instruction;
wire [1:0]  pc_sel;

wire        pc_enable;      // from hazard detection unit (stall)
wire        if_id_enable;   // from hazard detection unit (stall)
wire        if_id_flush;    // branch/jump squash

wire [31:0] if_id_pc;
wire [31:0] if_id_pc_4;
wire [31:0] if_id_instruction;

//============================================================
// id Stage
//============================================================
wire [4:0] rs1_addr;
wire [4:0] rs2_addr;
wire [4:0] rd_addr;

wire [6:0] opcode;
wire [2:0] funct3;
wire [6:0] funct7;

wire [31:0] rs1_data;
wire [31:0] rs2_data;
wire [31:0] imm;

wire       op1_sel;
wire       op2_sel;
wire [4:0] alu_op;
wire [2:0] branch_jump;
wire       mem_read;
wire       mem_write;
wire [1:0] wb_sel;
wire       reg_write_en;
wire [2:0] imm_sel;

wire       id_ex_flush;     // hazard bubble or branch squash

wire [31:0] id_ex_pc;
wire [31:0] id_ex_pc_4;
wire [31:0] id_ex_rs1_data;
wire [31:0] id_ex_rs2_data;
wire [31:0] id_ex_imm;

wire [4:0] id_ex_rs1_addr;
wire [4:0] id_ex_rs2_addr;
wire [4:0] id_ex_rd_addr;

wire       id_ex_op1_sel;
wire       id_ex_op2_sel;
wire [4:0] id_ex_alu_op;
wire [2:0] id_ex_branch_jump;
wire       id_ex_mem_read;
wire       id_ex_mem_write;
wire [1:0] id_ex_wb_sel;
wire       id_ex_reg_write_en;

//============================================================
// ex Stage
//============================================================
wire [1:0] forwardA;
wire [1:0] forwardB;

wire [31:0] operand_a;
wire [31:0] operand_b;

wire [31:0] alu_result;

wire        branch_taken;
wire        branch_flush;      // derived: branch_taken & real branch/jump
wire [31:0] target_address;

wire [31:0] ex_mem_pc_4;
wire [31:0] ex_mem_alu_result;
wire [31:0] ex_mem_rs2_data;

wire [4:0] ex_mem_rd_addr;

wire       ex_mem_mem_read;
wire       ex_mem_mem_write;
wire [1:0] ex_mem_wb_sel;
wire       ex_mem_reg_write_en;

//============================================================
// mem Stage
//============================================================
wire [31:0] dmem_data;

wire [31:0] mem_wb_pc_4;
wire [31:0] mem_wb_alu_result;
wire [31:0] mem_wb_dmem_data;

wire [4:0] mem_wb_rd_addr;

wire [1:0] mem_wb_wb_sel;
wire       mem_wb_reg_write_en;

//============================================================
// wb Stage
//============================================================
wire [31:0] write_data;   // also used as mem_wb_write_data forwarding source

// derived branch-squash: only flush if the ex-stage instruction is
// actually a branch/jump and it's taken. branch_jump == 3'b000 assumed
// "not a branch/jump" per your defines.vh -- adjust if your encoding differs.
assign branch_flush = branch_taken && (id_ex_branch_jump != 3'b000);
assign if_id_flush  = branch_flush; 

// instruction field extraction (standard rv32i)
assign opcode   = if_id_instruction[6:0];
assign funct3   = if_id_instruction[14:12];
assign funct7   = if_id_instruction[31:25];
assign rs1_addr = if_id_instruction[19:15];
assign rs2_addr = if_id_instruction[24:20];
assign rd_addr  = if_id_instruction[11:7];

//------------------------------------------------------------
// Debug Output
//------------------------------------------------------------

assign led = alu_result[15:0];

//============================================================
// if Stage instances
//============================================================
pc pc_reg (
    .next_pc (next_pc),
    .clk     (cpu_clk),
    .reset   (reset),
    .enable  (pc_enable),
    .pc      (pc)
);

pc_4_adder pc_4_adder_inst (
    .pc   (pc),
    .pc_4 (pc_4)
);

pc_control pc_control_inst (
    .branch_jump  (id_ex_branch_jump),
    .branch_taken (branch_taken),
    .pc_sel       (pc_sel)
);

pc_mux pc_mux_inst (
    .pc_4           (pc_4),
    .target_address (target_address),
    .alu_result     (alu_result),
    .pc_sel         (pc_sel),
    .next_pc        (next_pc)
);

instruction_memory imem_inst (
    .pc          (pc),
    .instruction (instruction)
);

if_id_pipeline if_id_reg (
    .pc_in          (pc),
    .pc_4_in        (pc_4),
    .instruction_in (instruction),
    .clk            (cpu_clk),
    .reset          (reset),
    .enable         (if_id_enable),
    .flush          (if_id_flush),
    .pc_out         (if_id_pc),
    .pc_4_out       (if_id_pc_4),
    .instruction_out(if_id_instruction)
);

//============================================================
// id Stage instances
//============================================================
register_file rf_inst (
    .rs1_addr     (rs1_addr),
    .rs2_addr     (rs2_addr),
    .rd_addr      (mem_wb_rd_addr),
    .write_data   (write_data),
    .reg_write_en (mem_wb_reg_write_en),
    .clk          (cpu_clk),
    .reset        (reset),
    .rs1_data     (rs1_data),
    .rs2_data     (rs2_data)
);

immediate_generator imm_gen_inst (
    .instruction (if_id_instruction),
    .imm_sel     (imm_sel),
    .imm         (imm)
);

main_control_unit ctrl_inst (
    .opcode       (opcode),
    .funct3       (funct3),
    .funct7       (funct7),
    .imm_sel      (imm_sel),
    .op1_sel      (op1_sel),
    .op2_sel      (op2_sel),
    .alu_op       (alu_op),
    .branch_jump  (branch_jump),
    .mem_read     (mem_read),
    .mem_write    (mem_write),
    .wb_sel       (wb_sel),
    .reg_write_en (reg_write_en)
);

wire id_ex_flush_hazard;

hazard_detection_unit hdu_inst (
    .id_rs1_addr    (rs1_addr),
    .id_rs2_addr    (rs2_addr),
    .id_ex_rd_addr  (id_ex_rd_addr),
    .id_ex_mem_read (id_ex_mem_read),
    .pc_enable      (pc_enable),
    .if_id_enable   (if_id_enable),
    .id_ex_flush    (id_ex_flush_hazard)
);

// combine hazard-driven bubble with branch-squash
assign id_ex_flush = id_ex_flush_hazard || branch_flush;

id_ex_pipeline id_ex_reg (
    .pc_in            (if_id_pc),
    .pc_4_in          (if_id_pc_4),
    .rs1_data_in      (rs1_data),
    .rs2_data_in      (rs2_data),
    .imm_in           (imm),
    .rs1_addr_in      (rs1_addr),
    .rs2_addr_in      (rs2_addr),
    .rd_addr_in       (rd_addr),
    .op1_sel_in       (op1_sel),
    .op2_sel_in       (op2_sel),
    .alu_op_in        (alu_op),
    .branch_jump_in   (branch_jump),
    .mem_read_in      (mem_read),
    .mem_write_in     (mem_write),
    .wb_sel_in        (wb_sel),
    .reg_write_en_in  (reg_write_en),
    .clk              (cpu_clk),
    .reset            (reset),
    .enable           (1'b1),
    .flush            (id_ex_flush),
    .pc_out           (id_ex_pc),
    .pc_4_out         (id_ex_pc_4),
    .rs1_data_out     (id_ex_rs1_data),
    .rs2_data_out     (id_ex_rs2_data),
    .imm_out          (id_ex_imm),
    .rs1_addr_out     (id_ex_rs1_addr),
    .rs2_addr_out     (id_ex_rs2_addr),
    .rd_addr_out      (id_ex_rd_addr),
    .op1_sel_out      (id_ex_op1_sel),
    .op2_sel_out      (id_ex_op2_sel),
    .alu_op_out       (id_ex_alu_op),
    .branch_jump_out  (id_ex_branch_jump),
    .mem_read_out     (id_ex_mem_read),
    .mem_write_out    (id_ex_mem_write),
    .wb_sel_out       (id_ex_wb_sel),
    .reg_write_en_out (id_ex_reg_write_en)
);

//============================================================
// ex Stage instances
//============================================================
forwarding_unit fwd_inst (
    .id_ex_rs1_addr      (id_ex_rs1_addr),
    .id_ex_rs2_addr      (id_ex_rs2_addr),
    .ex_mem_rd_addr      (ex_mem_rd_addr),
    .mem_wb_rd_addr      (mem_wb_rd_addr),
    .ex_mem_reg_write_en (ex_mem_reg_write_en),
    .mem_wb_reg_write_en (mem_wb_reg_write_en),
    .forwardA            (forwardA),
    .forwardB            (forwardB)
);

operand_selection_muxes op_mux_inst (
    .rs1_data          (id_ex_rs1_data),
    .rs2_data          (id_ex_rs2_data),
    .imm               (id_ex_imm),
    .pc                (id_ex_pc),
    .ex_mem_alu_result (ex_mem_alu_result),
    .mem_wb_write_data (write_data),
    .op1_sel           (id_ex_op1_sel),
    .op2_sel           (id_ex_op2_sel),
    .forwardA          (forwardA),
    .forwardB          (forwardB),
    .operand_a         (operand_a),
    .operand_b         (operand_b)
);

alu alu_inst (
    .operand_a  (operand_a),
    .operand_b  (operand_b),
    .alu_op     (id_ex_alu_op),
    .alu_result (alu_result)
);

// Branch Unit = comparator + target adder
branch_comparator branch_cmp_inst (
    .rs1_data(operand_a),
    .rs2_data(operand_b),
    .branch_jump(id_ex_branch_jump),
    .branch_taken(branch_taken)
);

branch_target_adder branch_adder_inst (
    .pc             (id_ex_pc),
    .imm            (id_ex_imm),
    .target_address (target_address)
);

ex_mem_pipeline ex_mem_reg (
    .pc_4_in          (id_ex_pc_4),
    .alu_result_in    (alu_result),
    .rs2_data_in      (id_ex_rs2_data),
    .rd_addr_in       (id_ex_rd_addr),
    .mem_read_in      (id_ex_mem_read),
    .mem_write_in     (id_ex_mem_write),
    .wb_sel_in        (id_ex_wb_sel),
    .reg_write_en_in  (id_ex_reg_write_en),
    .clk              (cpu_clk),
    .reset            (reset),
    .enable           (1'b1),
    .pc_4_out         (ex_mem_pc_4),
    .alu_result_out   (ex_mem_alu_result),
    .rs2_data_out     (ex_mem_rs2_data),
    .rd_addr_out      (ex_mem_rd_addr),
    .mem_read_out     (ex_mem_mem_read),
    .mem_write_out    (ex_mem_mem_write),
    .wb_sel_out       (ex_mem_wb_sel),
    .reg_write_en_out (ex_mem_reg_write_en)
);

//============================================================
// mem Stage instances
//============================================================
data_memory dmem_inst (
    .alu_result (ex_mem_alu_result),
    .write_data (ex_mem_rs2_data),   // store data, not the wb write_data
    .mem_read   (ex_mem_mem_read),
    .mem_write  (ex_mem_mem_write),
    .clk        (cpu_clk),
    .dmem_data  (dmem_data)
);

mem_wb_pipeline mem_wb_reg (
    .pc_4_in          (ex_mem_pc_4),
    .alu_result_in    (ex_mem_alu_result),
    .dmem_data_in     (dmem_data),
    .rd_addr_in       (ex_mem_rd_addr),
    .wb_sel_in        (ex_mem_wb_sel),
    .reg_write_en_in  (ex_mem_reg_write_en),
    .clk              (cpu_clk),
    .reset            (reset),
    .enable           (1'b1),
    .pc_4_out         (mem_wb_pc_4),
    .alu_result_out   (mem_wb_alu_result),
    .dmem_data_out    (mem_wb_dmem_data),
    .rd_addr_out      (mem_wb_rd_addr),
    .wb_sel_out       (mem_wb_wb_sel),
    .reg_write_en_out (mem_wb_reg_write_en)
);

//============================================================
// wb Stage instances
//============================================================
writeback_mux wb_mux_inst (
    .alu_result (mem_wb_alu_result),
    .dmem_data  (mem_wb_dmem_data),
    .pc_4       (mem_wb_pc_4),
    .wb_sel     (mem_wb_wb_sel),
    .write_data (write_data)
);

reg [26:0] counter;

always @(posedge clk or posedge reset) begin
    if (reset)
        counter <= 0;
    else
        counter <= counter + 1;
end

wire cpu_clk = counter[26];

endmodule