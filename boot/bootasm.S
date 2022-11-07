#include <asm.h>

# Start the CPU: switch to 32-bit protected mode, jump into C.
# The BIOS loads this code from the first sector of the hard disk into
# memory at physical address 0x7c00 and starts executing in real mode
# with %cs=0 %ip=7c00.

# 代码段选择子  0000 1 000
.set PROT_MODE_CSEG,        0x8                     # kernel code segment selector

# 数据段选择子  0001 0 000 
.set PROT_MODE_DSEG,        0x10                    # kernel data segment selector

# 保护模式打开标志
.set CR0_PE_ON,             0x1                     # protected mode enable flag

# start address should be 0:7c00, in real mode, the beginning address of the running bootloader
.globl start
start:
.code16                 # 16位实模式                                             # Assemble for 16-bit mode
    cli                 # 关闭中断                             # Disable interrupts
    cld                 # 字符串操作时方向递增                            # String operations increment

    # Set up the important data segment registers (DS, ES, SS).
    # 通过异或操作,设置ax寄存器值为0
    xorw %ax, %ax                                   # Segment number zero
    # 设置ds, es, ss寄存器为0
    movw %ax, %ds                                   # -> Data Segment
    movw %ax, %es                                   # -> Extra Segment
    movw %ax, %ss                                   # -> Stack Segment

    # Enable A20:
    #  For backwards compatibility with the earliest PCs, physical
    #  address line 20 is tied low, so that addresses higher than
    #  1MB wrap around to zero by default. This code undoes this.
    #  汇编中使用in/out来访问系统的io空间
seta20.1:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.1

    movb $0xd1, %al                                 # 0xd1 -> port 0x64
    outb %al, $0x64                                 # 0xd1 means: write data to 8042's P2 port

seta20.2:
    inb $0x64, %al                                  # Wait for not busy(8042 input buffer empty).
    testb $0x2, %al
    jnz seta20.2

    movb $0xdf, %al                                 # 0xdf -> port 0x60
    outb %al, $0x60                                 # 0xdf = 11011111, means set P2's A20 bit(the 1 bit) to 1

    # Switch from real to protected mode, using a bootstrap GDT
    # and segment translation that makes virtual addresses
    # identical to physical addresses, so that the
    # effective memory map does not change during the switch.
    lgdt gdtdesc

    # 将%cr0的最低位置1实现实模式到保护模式的转换
    movl %cr0, %eax
    orl $CR0_PE_ON, %eax
    movl %eax, %cr0

    # Jump to next instruction, but in 32-bit code segment.
    # Switches processor into 32-bit mode.
    # 通过ljmp指令跳转到32位代码开始执行，
    # 同时更新了代码段的选择子为0x8，
    # 以及清空了流水线过时的16位代码。
    ljmp $PROT_MODE_CSEG, $protcseg

.code32                                             # Assemble for 32-bit mode
protcseg:
    # Set up the protected-mode data segment registers
    # 设置段寄存器选择子为GDT表中的数据段
    movw $PROT_MODE_DSEG, %ax                       # Our data segment selector
    movw %ax, %ds                                   # -> DS: Data Segment
    movw %ax, %es                                   # -> ES: Extra Segment
    movw %ax, %fs                                   # -> FS
    movw %ax, %gs                                   # -> GS
    movw %ax, %ss                                   # -> SS: Stack Segment

    # Set up the stack pointer and call into C. The stack region is from 0--start(0x7c00)
    # 设置堆栈，从0开始到0x7c00（bootloader起始地址）
    movl $0x0, %ebp
    movl $start, %esp
    call bootmain

    # If bootmain returns (it shouldn't), loop.
spin:
    jmp spin

# Bootstrap GDT
.p2align 2                                          # force 4 byte alignment
gdt:
    # 全局描述符表GDT（Global Descriptor Table）在整个系统中，
    # 全局描述符表GDT只有一张(一个处理器对应一个GDT)，
    # GDT可以被放在内存的任何位置，但CPU必须知道GDT的入口，也就是基地址放在哪里，
    # Intel的设计者门提供了一个寄存器GDTR用来存放GDT的入口地址，
    # 程序员将GDT设定在内存中某个位置之后，可以通过LGDT指令将GDT的入口地址装入此积存器，
    # 从此以后，CPU就根据此寄存器中的内容作为GDT的入口来访问GDT了。
    # GDTR中存放的是GDT在内存中的基地址和其表长界限
    SEG_NULLASM                                     # null seg
    SEG_ASM(STA_X|STA_R, 0x0, 0xffffffff)           # code seg for bootloader and kernel
    SEG_ASM(STA_W, 0x0, 0xffffffff)                 # data seg for bootloader and kernel

gdtdesc:
    .word 0x17                                      # sizeof(gdt) - 1
    .long gdt                                       # address gdt
