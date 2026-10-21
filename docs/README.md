# Design Documentation

This directory contains the architecture documentation and functional specifications for the RV32I pipelined processor.

The documentation describes the processor's organization, instruction support, pipeline operation, and principal RTL components.

Target

Educational RTL implementation.
Synthesizable on FPGA.
Clean modular RTL.

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

It will have 13 chapters:

Chapter 1. Project Overview

Chapter 2. Overall Architecture

Chapter 3. Supported Instruction Set

Chapter 4. Pipeline Registers

Chapter 5. Control Signals

Chapter 6. ALU Specification

Chapter 7. Immediate Generator

Chapter 8. Branch and Control-Flow Unit

Chapter 9. Hazard Handling

Chapter 10. Memory System

Chapter 11. Register File

Chapter 12. Module List

Chapter 13. Interfaces



