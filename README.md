# RV32I single-cycle core

A 32-bit single-cycle RISC-V processor in Verilog, implementing the RV32I base ISA (excluding `fence`, `ecall`, `ebreak`). Synthesized and running on a Zynq-7000 (XC7Z010) at 50 MHz.

## Demo

<!-- Replace the line below with the github.com/user-attachments/assets/... URL after uploading the mp4 through an issue comment. GitHub renders a bare attachment URL as an inline player. -->

https://github.com/user-attachments/assets/REPLACE-WITH-UPLOADED-VIDEO-URL

[Demo video on Google Drive](https://drive.google.com/file/d/19tp1hB963Ke_8VDH8YXSlvwh7crEMcuz/view?usp=sharing) — mirror link.

## What's implemented

| Block | Detail |
| --- | --- |
| ALU | Arithmetic, logic, and a barrel shifter for `sll` / `srl` / `sra` |
| Register file | 32 × 32-bit, dual read ports, `x0` hardwired to zero |
| Control unit | Single-cycle decode across all RV32I opcodes |
| Immediate generation | All six formats — I, S, B, U, J, and R (no immediate) |
| Branch unit | All six comparisons: `beq`, `bne`, `blt`, `bge`, `bltu`, `bgeu` |
| Memory access | Byte, halfword, and word, with sign- and zero-extension |

## Verification

Self-checking assembly testbenches cover every branch path and every load/store width. Each test writes a known signature to a register and the testbench flags a mismatch, so a failure points at the instruction rather than at a waveform to be read by hand.

One bug worth recording: a negative `addi` immediate aliased onto the `sub` control bit, so `addi x1, x0, -1` executed as a subtract. Found by diffing expected against actual register state, then root-caused in the waveform viewer by tracing the control signal back through immediate generation.

## FPGA results

Target: Zynq-7000 XC7Z010 (EDGE Zynq SoC board), Vivado.

| Metric | Value |
| --- | --- |
| Clock | 50 MHz, timing closed |
| Fmax | 63 MHz |
| LUTs | 874 |
| Flip-flops | 115 |

The repo includes the synthesis wrapper, the timing constraints file, and a 7-segment display driver that shows register contents on the board.

## In progress

A rare-trigger trojan in the control unit that corrupts register writeback under a specific instruction sequence. The clean core runs as a golden model alongside the modified one, and the two are diffed cycle by cycle to measure how long the trojan stays hidden and what it costs in area and timing.

## Repository layout

```
rtl/          Core RTL — ALU, regfile, control, imm-gen, datapath
tb/           Self-checking testbenches
asm/          Test programs and their expected signatures
constraints/  XDC timing and pin constraints
docs/         Waveforms and utilization reports
```

## Build and run

Simulation:

```bash
# Adjust to your simulator
iverilog -o sim tb/tb_top.v rtl/*.v
vvp sim
```

Hardware:

1. Open the project in Vivado and select the XC7Z010 part.
2. Add `rtl/`, the synthesis wrapper, and `constraints/`.
3. Load the test program into instruction memory via `$readmemh`.
4. Run synthesis and implementation, then generate and program the bitstream.

## Tools

Verilog HDL, RISC-V assembly, Xilinx Vivado, Zynq-7000.
