# FPGA Implementation

This directory contains the FPGA-specific constraints, implementation configuration, and resource-utilization results for the RV32I pipelined processor.

## Target Platform

| Parameter           | Specification                |
|---------------------|------------------------------|
| FPGA board          | Digilent Basys 3             |
| FPGA device         | AMD/Xilinx Artix-7 `XC7A35T` |
| HDL                 | Verilog                      |
| Design tool         | AMD Vivado                   |
| Top-level module    | `cpu`                        |

## Implementation Results

The processor was synthesized and implemented for the target FPGA using Vivado.

### Resource Utilization

| Resource   | Used  | Device capacity | Utilization |
|------------|-------|-----------------|-------------|
| LUTs       | 1,484 | 20,800          | 7.13%       |
| Flip-flops | 972   | 41,600          | 2.34%       |


### Timing Results

Recording the following values from the final implementation reports:

| Metric                      | Result      |
|-----------------------------|-------------|
| Target clock period         | To be added |
| Worst setup slack (WNS)     | To be added |
| Worst hold slack (WHS)      | To be added |
| Maximum operating frequency | To be added |



## Constraints

The board-specific Xilinx Design Constraints file (`.xdc`) specifies the physical and timing constraints used by Vivado.


