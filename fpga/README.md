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


Family	Artix-7
Device	XC7A35T
Package	CPG236
Speed grade	-1



## Constraints

The board-specific Xilinx Design Constraints file (`.xdc`) specifies the physical and timing constraints used by Vivado.


