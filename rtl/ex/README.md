# Execute (EX)

This directory contains the Execute stage and associated datapath logic of the five-stage RV32I pipelined processor.

## Modules

| Module                          | Responsibility                                                               |
|---------------------------------|------------------------------------------------------------------------------|
| `alu.v`                         | Performs arithmetic, logical, shift, and comparison-related operations.      |
| `branch_comparator.v`           | Evaluates conditional branch comparisons.                                    |
| `branch_target_adder.v`         | Calculates branch target addresses.                                          |
| `forwarding_unit.v`             | Controls operand forwarding to resolve data dependencies.                    |
| `operand_selection_muxes.v`     | Selects operands for execution.                                              |  
| `ex_mem_pipeline.v`             | Registers execution results and associated information for the Memory stage. |

