# RV32 counter demo. Load at byte address 0; reset PC must be 0.
# Observe upper bits of x1 on LEDs. No data memory or UART required.
.option norvc
.section .text
.globl _start
_start:
    addi x1, x0, 0       # 0x00000093 at PC 0
loop:
    addi x1, x1, 1       # 0x00108093 at PC 4
    jal  x0, loop        # 0xffdff06f at PC 8: jump back 4 bytes
