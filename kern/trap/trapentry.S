#include <memlayout.h>

# vectors.S sends all traps here.
.text
.globl __alltraps

# __alltraps为各中断处理程序的前置代码，
# 用于继续在栈中完成trapframe结构，
# 依次压入ds、es、fs、gs、通用寄存器，
# 并将数据段切换为内核数据段
#（代码段在IDT初始化过程中设置为内核代码段），
# 最后压入trapframe结构体指针作为trap函数的参数，
# 再调用trap函数完成具体的中断处理
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
    pushl %es
    pushl %fs
    pushl %gs
    pushal

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
    movw %ax, %ds
    movw %ax, %es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp

    # call trap(tf), where tf=%esp
    call trap

    # pop the pushed stack pointer
    popl %esp

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal

    # restore %ds, %es, %fs and %gs
    popl %gs
    popl %fs
    popl %es
    popl %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
    iret

