# Instruction Decode (ID)

This directory contains the Instruction Decode stage and associated control logic of the five-stage RV32I pipelined processor.

## Modules

| Module                        | Responsibility                                                                                  |
|-------------------------------|-------------------------------------------------------------------------------------------------|
| `main_control_unit.v`         | Decodes instructions and generates processor control signals.                                   |
| `register_file.v`             | Provides access to the processor's architectural registers.                                     |
| `immediate_generator.v`       | Extracts and extends immediate values from instruction fields.                                  |
| `hazard_detection_unit.v`     | Detects instruction dependencies that require pipeline stalls or other hazard-control actions.  |
| `id_ex_pipeline.v`            | Registers decoded operands, control signals, and associated information for the Execute stage.  |

