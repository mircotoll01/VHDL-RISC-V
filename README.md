# VHDL-RISC-V

A synthesizable, pipelined RV32I datapath implemented in VHDL, with full documentation and test infrastructure.

## Repository structure

```
VHDL-RISC-V/
├── docs/           ← Project documentation
│   ├── docs.pdf    ← Full report (introduction, appendices, code listings)
│   └── ...         ← (any other PDF/Diagrams)
├── firmware/       ← VHDL sources, testbenches & COE files
│   ├── ip/         ← ip xci files
│   │   ├── data_memory/
│   │   └── ...
│   ├── src/        ← Top‐level VHDL entities & pipeline stages and `.coe` init files for Block Memory Generator
│   │   ├── instr_fetch.vhd
│   │   ├── instr_decode.vhd
│   │   ├── instr_exec.vhd
│   │   ├── data_mem.vhd
│   │   ├── write_back.vhd
│   │   └── ...
│   ├── sim/         ← Testbenches for behavioral simulation and wave config files
│   │   ├── IF_testbench.vhd
|   |   ├── ...
├── .gitignore      ← Ignore build artifacts, temporary files
└── README.md       ← (this file)
```
