# Memory Access (MEM)

This directory contains the Memory Access stage of the five-stage RV32I pipelined processor.

## Modules

| Module               | Responsibility                                                                      |
|----------------------|-------------------------------------------------------------------------------------|
| `data_memory.v`      | Provides the processor's data-memory interface for load and store operations.       |
| `mem_wb_pipeline.v`  | Registers memory-stage results and associated information for the Write Back stage. |

