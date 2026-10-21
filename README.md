# RV32I Pipelined Processor

**A 32-bit, five-stage RISC-V processor implemented in Verilog HDL, synthesized with AMD Vivado, and deployed on a Digilent Basys 3 FPGA.**

A modular RTL implementation exploring processor datapath design, pipeline control, data forwarding, hazard handling, and control-flow execution.



## Overview

This project implements a single-issue, in-order processor based on a subset of the RISC-V RV32I base integer instruction set. The design follows a classical five-stage pipeline and separates the datapath, control logic, pipeline registers, and hazard-management logic into modular Verilog components.

The processor has been synthesized and programmed onto the **Digilent Basys 3 FPGA**, based on the AMD/Xilinx Artix-7 `XC7A35T` device.

### Key Features

- **Five-stage pipeline:** Instruction Fetch (IF), Instruction Decode (ID), Execute (EX), Memory Access (MEM), and Write Back (WB).
- **Modular RTL:** Separate modules for the ALU, register file, immediate generation, control logic, pipeline registers, and memory interfaces.
- **Data hazard handling:** Forwarding and hazard-detection logic, with pipeline stall and flush control.
- **Control-flow execution:** Conditional branches, jumps, and program-counter redirection.
- **Harvard memory organization:** Separate instruction and data memory interfaces.
- **FPGA implementation:** Synthesis, implementation, bitstream generation, and deployment using AMD Vivado.

## Architecture

The processor follows the conventional five-stage pipeline:

```
          ┌──────┐    ┌──────┐     ┌──────┐      ┌──────┐      ┌──────┐
          │  IF  │───▶│  ID  │───▶│  EX  │───▶  │ MEM  │───▶ │  WB  │
          └──────┘    └──────┘     └──────┘      └──────┘      └──────┘
             │           │            │             │              │
          Fetch       Decode       Execute       Memory      Writeback
                                  & Branch
```

Pipeline registers separate adjacent stages. Forwarding and hazard-control logic manage instruction dependencies and control-flow changes.

### Pipeline Stages

| Stage                         | Function |
|-------------------------------|-----------------------------------------------------------------------------------|
| IF — Instruction Fetch        | Fetches the instruction and determines the next program-counter value.            |
| ID — Instruction Decode       | Decodes the instruction, reads register operands, and generates control signals.  |
| EX — Execute                  | Performs ALU operations, evaluates branches, and calculates memory addresses.     |
| MEM — Memory Access           | Interfaces with data memory for load and store operations.                        |
| WB — Write Back               | Selects the result to write into the register file.                               |

### Hazard Handling

The design includes dedicated forwarding and hazard-detection modules.

- **Data hazards:** Forwarding paths reduce dependencies on values that have not yet reached register write-back.
- **Pipeline stalls:** Hazard-control logic can hold pipeline state when execution dependencies require it.
- **Control hazards:** Branch and jump handling redirects instruction fetch and uses flush control to prevent incorrect-path instructions from proceeding.

Branch resolution is performed in the execute stage. The processor does not implement branch prediction or speculative execution.

## Instruction Set Support

The implementation supports a documented **subset of RV32I**, rather than the complete base ISA.

| Instruction category                   | Implemented instructions |
|----------------------------------------|-----------------------------------------------------------------------------------------|
| Register-register arithmetic and logic | `ADD`, `SUB`, `AND`, `OR`, `XOR`, `SLL`, `SRL`, `SRA`, `SLT`, `SLTU`                    |
| Immediate arithmetic and logic         | `ADDI`, `ANDI`, `ORI`, `XORI`, `SLLI`, `SRLI`, `SRAI`, `SLTI`                           |
| Load and store                         | `LW`, `SW`                                                                              |
| Conditional branches                   | `BEQ`, `BNE`, `BLT`, `BGE`                                                              |
| Jumps                                  | `JAL`, `JALR`                                                                           |
| Upper-immediate operations             | `LUI`, `AUIPC`                                                                          |

The following instructions are unsupported: `LB`, `LH`, `LBU`, `LHU`, `SB`, `SH`, `BLTU`, `BGEU`, `ECALL`, and `EBREAK`.



## RTL Module Organization

The source code is organized around individual processor functions.

| Module | Responsibility |
|-----------------------------|----------------------------------------------------------------|
| `cpu.v`                     | Top-level processor integration                                |
| `alu.v`                     | Arithmetic, logical, shift, and comparison-related operations  |
| `main_control_unit.v`       | Instruction decoding and control-signal generation             |
| `register_file.v`           | Architectural register storage and access                      |
| `immediate_generator.v`     | Instruction immediate extraction and extension                 |
| `forwarding_unit.v`         | Operand forwarding control                                     |
| `hazard_detection_unit.v`   | Hazard detection and pipeline-control requests                 |
| `if_id_pipeline.v`          | IF/ID pipeline register                                        |
| `id_ex_pipeline.v`          | ID/EX pipeline register                                        |
| `ex_mem_pipeline.v`         | EX/MEM pipeline register                                       |
| `mem_wb_pipeline.v`         | MEM/WB pipeline register                                       |
| `instruction_memory.v`      | Instruction storage and access                                 |
| `data_memory.v`             | Data storage and access                                        |
| `branch_comparator.v`       | Conditional branch comparisons                                 |
| `branch_target_adder.v`     | Branch-target arithmetic                                       |
| `pc.v`                      | Program-counter state                                          |
| `pc_control.v`, `pc_mux.v`  | Program-counter update and selection logic                     |
| `operand_selection_muxes.v` | Datapath operand selection                                     |
| `writeback_mux.v`           | Write-back result selection                                    |
| `pc_4_adder.v`              | Sequential PC increment calculation                            |

The repository also contains architecture notes, instruction-format material, and a synthesized schematic.

## FPGA Implementation

**Target platform:** Digilent Basys 3  
**FPGA:** AMD/Xilinx Artix-7 `XC7A35T`  
**HDL:** Verilog  
**Synthesis and implementation:** AMD Vivado

The processor was synthesized, implemented, and programmed onto the FPGA. The reported implementation resource utilization was:

| Resource               | Utilization | Device utilization |
|------------------------|-------------|--------------------|
| Look-up tables (LUTs)  | 1,484       | 7.13%              |
| Flip-flops (FFs)       | 972         | 2.34%              |


## Engineering Scope

This project focuses on:

- Designing a modular, pipelined processor datapath in RTL.
- Integrating pipeline registers with instruction decoding and execution logic.
- Managing data dependencies through forwarding and hazard detection.
- Implementing conditional branches and jump instructions.
- Synthesizing and deploying a processor design on an FPGA.

---

**Author:** Divyansh Vashishtha  
**Repository:** [RV32I-Pipelined-Processor](https://github.com/divash2004/RV32I-Pipelined-Processor)
