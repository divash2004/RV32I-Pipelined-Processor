

2.1 Microarchitectural Design Decisions



| Feature           | Choice                     |



| ----------------- | -------------------------- |



| ISA               | RV32I subset               |



| Datapath          | 32-bit                     |



| Pipeline          | 5-stage                    |



| Execution         | In-order                   |



| Issue             | Single                     |



| Memory            | Harvard                    |



| Hazards           | Forwarding + Stall + Flush |



| Branch Resolution | EX                         |



| Cache             | No                         |



| Branch Prediction | No                         |



| FPGA              | Basys 3                    |





Each instruction progresses sequentially through the five pipeline stages. Multiple instructions may reside simultaneously in different stages, allowing instruction-level parallelism while maintaining in-order execution.



2.2 Pipeline Organization



Instruction execution is divided into five stages.



Instruction Fetch (IF)

Fetch instruction from instruction memory -> Compute the sequential PC (PC + 4) -> Select the next program counter Store fetched information in the IF/ID pipeline register



Instruction Decode (ID)

Decode instruction fields-> Read operands from the register file -> Generate immediate values Generate processor control signals-> Detect hazards before execution



Execute (EX)

Select operands through forwarding and operand multiplexers-> Perform arithmetic and logical operations -> Evaluate branch conditions -> Compute memory addresses -> Compute branch target addresses



Memory Access (MEM)

Perform data memory read/write operations-> Forward execution results toward write-back



Write Back (WB)

Select the correct write-back source -> Update the destination register



Each stage is separated by a dedicated pipeline register



2.3 Architectural Decisions



What architecture should this processor have?



Possible options:



\* Single-cycle

\* Multi-cycle

\* Pipelined



I chose a \*\*5-stage pipelined architecture\*\*.



A single-cycle processor has a very long critical path because every instruction must complete in one clock cycle.



A multi-cycle processor improves clock frequency but introduces a finite-state controller and variable instruction latency.



A pipelined processor overlaps instruction execution, allowing multiple instructions to be in flight simultaneously. It represents the architecture used by classical RISC processors and is the natural next step after studying the single-cycle datapath.



Why exactly five stages?



Because the work naturally divides into five distinct tasks.



&#x20;                                            IF → ID → EX → MEM → WB



Each stage performs one major operation.



This separation keeps each stage relatively simple and allows a higher clock frequency than a single-cycle implementation.



It is also the pipeline organization described in Hennessy \& Patterson, making it easier to verify my implementation against a standard reference.



Why in-order execution?



Alternatives:



\* In-order

\* Out-of-order



I selected \*\*in-order execution\*\* because:



\* simpler hardware

\* easier verification

\* no register renaming

\* no reorder buffer

\* no reservation stations



Since the purpose of this project is to understand RTL implementation rather than maximize IPC, in-order execution provides the best balance between complexity and learning value.



Why single issue?



One instruction is issued every cycle (under ideal conditions).



Alternatives:



\* superscalar

\* VLIW

\* multiple issue



Multiple issue would require dependency checking between simultaneously issued instructions, multiple execution units, and a much more complex control structure.



That complexity is beyond the scope of this project.



Why Harvard architecture?



Alternatives:



\* Von Neumann

\* Harvard



I selected Harvard architecture because instruction fetch and data memory access occur simultaneously in a pipelined processor.



If both shared one memory, a structural hazard would occur whenever IF and MEM required memory in the same cycle.



Using separate instruction and data memories removes this hazard completely.



It also maps naturally onto FPGA block RAM resources.



Why no cache?



Because cache design is an independent topic.



The purpose of this project is processor microarchitecture.



Adding caches would introduce



\* cache controller

\* replacement policy

\* cache misses

\* stall logic



without changing the core pipeline itself.



Why no branch prediction?



Branches are resolved in the Execute stage.



If a branch is taken, younger instructions are flushed.



Alternatives:



\* static prediction

\* dynamic prediction

\* BTB

\* BHT



These techniques improve performance but greatly increase control complexity.



Since correctness is the primary objective, I chose explicit flushing.



Why forwarding?



Without forwarding, almost every data dependency introduces pipeline stalls.



Forwarding allows results to be used before they are written back, significantly reducing CPI with relatively little hardware.



The only remaining unavoidable hazard is the load-use hazard.



Why stall after a load?



Example:



lw x5,0(x1)

add x6,x5,x7





The loaded data is not available until the MEM stage.



Forwarding cannot provide data that has not yet been produced.



Therefore a one-cycle stall is unavoidable.



Why modular RTL?



Instead of writing one large processor module, every hardware block will be implemented independently.



Benefits:



\* easier debugging

\* easier verification

\* reusable modules

\* clearer interfaces



Each module will have its own RTL, testbench, and waveform verification before integration.



