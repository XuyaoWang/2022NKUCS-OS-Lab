// 初始化GDT表
#ifndef __BOOT_ASM_H__
#define __BOOT_ASM_H__

/* Assembler macros to create x86 segments */

/* Normal segment */
// .word定义了段界限
// .byte分别定义了如下四部分：
// 段基址23~16
// P=1、DPL=00、S=1、TYPE=type
// G=1、D/B=1、L=0、AVL=0、段界限19~16
// 段基址31~24
// .byte 
//      Base 23:16
//      Type,S,DPL,P
//      SEGLIM 19:16
//      AVL,0,D/B,G
//      Base 31:24

#define SEG_NULLASM                                             \
    .word 0, 0;                                                 \
    .byte 0, 0, 0, 0

// 定义初始化段描述符的宏函数
// 段描述符的G=1，段界限已4K为单位，但参数lim以字节为单位，
// 因此在段界限分片时均右移12位（除以4K）
#define SEG_ASM(type,base,lim)                                  \
    .word (((lim) >> 12) & 0xffff), ((base) & 0xffff);          \
    .byte (((base) >> 16) & 0xff), (0x90 | (type)),             \
        (0xC0 | (((lim) >> 28) & 0xf)), (((base) >> 24) & 0xff)


/* Application segment type bits */
#define STA_X       0x8     // Executable segment
#define STA_E       0x4     // Expand down (non-executable segments)
#define STA_C       0x4     // Conforming code segment (executable only)
#define STA_W       0x2     // Writeable (non-executable segments)
#define STA_R       0x2     // Readable (executable segments)
#define STA_A       0x1     // Accessed

#endif /* !__BOOT_ASM_H__ */

