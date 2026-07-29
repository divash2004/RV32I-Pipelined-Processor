3.1 Design Choice



The processor implements a subset of the RV32I Base Integer Instruction Set



The objective is to implement a processor capable of executing the fundamental classes of RISC-V instructions while avoiding additional complexity associated with advanced ISA features (e.g., multiplication/division, compressed instructions, CSR operations, interrupts, and exceptions).



The selected instruction subset exercises every major hardware component of the processor:



ALU operations

Immediate generation

Register file access

Memory interface

Branch and jump control

Program counter update

Write-back logic



3.2 Execution Units



R-Type

Instruction Execution Unit	Operation

ADD		ALU		ADD

SUB		ALU		SUB

AND		ALU		AND

OR		ALU		OR

XOR		ALU		XOR

SLL		ALU	Shift Left Logical

SRL		ALU	Shift Right Logical

SRA		ALU	Shift Right Arithmetic

SLT		ALU	Signed Less Than

SLTU		ALU	Unsigned Less Than



I-Type

Instruction  Execution Unit	Operation

ADDI		ALU	ADD

ANDI		ALU	AND

ORI		ALU	OR

XORI		ALU	XOR

SLLI		ALU	Shift Left Logical

SRLI		ALU	Shift Right Logical

SRAI		ALU	Shift Right Arithmetic

SLTI		ALU	Signed Less Than

LW		ALU	Address Calculation (Base + Offset)

JALR		ALU	Target Address Calculation (Base + Offset)



S-Type

Instruction	Execution Unit	Operation

SW		ALU	       Address Calculation (Base + Offset)





B-Type

Instruction	Execution Unit	Operation

BEQ		Comparator	Equality Comparison

BNE		Comparator	Inequality Comparison

BLT		Comparator	Signed Less Than

BGE		Comparator	Signed Greater Than or Equal



U-Type

Instruction	Execution Unit	Operation

LUI		ALU		Pass Immediate (PASS\_B)

AUIPC		ALU		PC + Immediate



J-Type

Instruction	Execution Unit	Operation

JAL		Branch Adder	PC + Immediate (Target), PC+4 for Link







3.3 Instructions Not Implemented



The following RV32I instructions are intentionally omitted:



Load Instructions LB LH LBU LHU Store Instructions SB SH Unsigned Branches BLTU BGEU System Instructions ECALL EBREAK



3.4 Motivation for ISA Selection

The objective of ISA selection was not to implement every instruction defined in the RV32I specification, but rather to implement a subset that exercises every major hardware block in the processor while avoiding additional hardware whose architectural concepts are already represented by other instructions.



Why implement arithmetic instructions?

Arithmetic instructions form the foundation of the ALU.



Why implement immediate instructions?

Immediate instructions verify that the processor correctly supports:

Immediate generation, Sign extension, ALU operand selection, Immediate arithmetic



Why implement only LW and SW?

Memory instructions are required to verify:

Address calculation

Data memory interface

Memory read/write control

Write-back from memory

A single load (LW) and a single store (SW) are sufficient to validate these architectural features.



Why not implement LB, LH, LBU and LHU?

These instructions do not introduce a new architectural concept.

Instead, they require additional implementation complexity such as:

Byte and half-word extraction

Byte-enable logic

Sign extension

Zero extension

Alignment handling

Since these mechanisms are independent of the processor pipeline itself, they were deferred.



Why not implement SB and SH?

SB and SH require partial-word writes into memory.

Supporting these instructions introduces:

Byte-enable generation

Write masking

Additional memory interface logic

These features do not change the processor microarchitecture and can be added later without modifying the pipeline.



Why implement branches?

Conditional branches are essential for verifying:

Comparator operation

Branch decision logic

Branch target calculation

Pipeline flushing

Control hazard handling

Without branch instructions, the processor would never exercise control-flow changes.



Why implement only BEQ, BNE, BLT and BGE?

These four instructions provide complete coverage of the comparator hardware implemented in this processor.

Unsigned branches (BLTU and BGEU) require unsigned comparison logic. Since signed comparison already validates the branch datapath and hazard handling mechanisms, unsigned variants were omitted from the initial implementation.



Why implement JAL and JALR?

These instructions verify:

Program counter redirection

Link register update

Write-back of PC+4

Function call support

Together they exercise both absolute and register-based control transfers.



Why implement LUI and AUIPC?

although these instructions are relatively simple, they verify two important datapath operations.

LUI validates immediate handling by routing the U-type immediate through the ALU using the PASS\_B operation before write-back. This avoids introducing a dedicated immediate write-back path and keeps the write-back stage uniform.

AUIPC validates PC-relative arithmetic by adding the U-type immediate to the current program counter.

Rather than introducing dedicated hardware for simple instructions, the design preferentially reuses existing datapath resources whenever doing so does not significantly increase control complexity. The implementation of LUI using the ALU PASS\_B operation is an example of this philosophy.



Together, these instructions complete the processor's immediate handling capability while reusing the existing ALU datapath.

Why exclude ECALL and EBREAK?

These instructions belong to the system-level functionality of the RISC-V architecture.

Supporting them requires:

Exception handling

Trap vectors

Privileged architecture

Machine control registers (CSRs)

These features are outside the scope of this project.



Why not implement the entire RV32I ISA?

The objective of this project is to design a correct and modular pipelined processor, not to maximize ISA coverage. Instruction selection was driven by hardware coverage rather than instruction count. Every implemented instruction exercises at least one unique datapath or control feature, while omitted instructions primarily represent refinements or extensions of already-implemented hardware rather than new architectural concepts.

