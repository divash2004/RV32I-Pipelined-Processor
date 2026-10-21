# Instruction Fetch (IF)

This directory contains the Instruction Fetch stage and associated program-counter control logic for the five-stage RV32I pipelined processor.

## Modules

| Module | Responsibility                                                                                 |
|-----------------------|---------------------------------------------------------------------------------|
| `pc`                  | Maintains the program counter.                                                  |
| `pc_4_adder`          | Computes the sequential next PC, typically PC + 4.                              |
| `instruction_memory`  | Provides the instruction corresponding to the fetch address.                    |
| `if_id_pipeline`      | Registers instruction-fetch outputs for the Instruction Decode stage.           |
| `pc_control`          | Coordinates program-counter update control.                                     |
| `pc_mux`              | Selects the next program-counter value from the available control-flow targets. |



