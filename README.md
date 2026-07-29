# RV32I-Pipelined-Processor
32-bit, single-issue, in-order, 5-stage pipelined RV32I processor implemented in Verilog HDL. Supports forwarding, hazard detection, pipeline stall/flush logic, synthesized and programmed on a Digilent Basys 3 (Xilinx Artix-7) FPGA using Vivado.

Target

Educational RTL implementation.
Interview portfolio project.
Synthesizable on FPGA.
Clean modular RTL.
Emphasis on readability over aggressive optimization.

Architectural Constraints

RV32I subset.
Classical 5-stage pipeline.
One instruction retired per cycle (ideal case).
No speculative execution.
No caches.
No out-of-order execution.

Design Principles

Modular RTL with one hardware block per module.
Synchronous design using a single global clock.
Separation of datapath and control logic.
Stage-local combinational logic separated by pipeline registers.
Module-level verification prior to system integration.

Approach
philosophy → scope → architecture → signals → registers → datapath details → verification

It will have 14 chapters:

Chapter 1. Project Overview

Chapter 2. Overall Architecture

Chapter 3. Supported Instruction Set

Chapter 5. Pipeline Registers

Chapter 6. Control Signals

Chapter 7. ALU Specification

Chapter 8. Immediate Generator

Chapter 9. Branch and Control-Flow Unit

Chapter 10. Hazard Handling

Chapter 11. Memory System

Chapter 12. Register File

Chapter 13. Module List

Chapter 14. Interfaces
