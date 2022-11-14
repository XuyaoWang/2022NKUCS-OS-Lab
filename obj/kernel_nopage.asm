
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 a0 11 40       	mov    $0x4011a000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 a0 11 00       	mov    %eax,0x11a000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 90 11 00       	mov    $0x119000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));

static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	f3 0f 1e fb          	endbr32 
  10003a:	55                   	push   %ebp
  10003b:	89 e5                	mov    %esp,%ebp
  10003d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100040:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  100045:	2d 36 9a 11 00       	sub    $0x119a36,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 9a 11 00 	movl   $0x119a36,(%esp)
  10005d:	e8 71 58 00 00       	call   1058d3 <memset>

    cons_init();                // init the console
  100062:	e8 44 16 00 00       	call   1016ab <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 00 61 10 00 	movl   $0x106100,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 1c 61 10 00 	movl   $0x10611c,(%esp)
  10007c:	e8 39 02 00 00       	call   1002ba <cprintf>

    print_kerninfo();
  100081:	e8 f7 08 00 00       	call   10097d <print_kerninfo>

    grade_backtrace();
  100086:	e8 95 00 00 00       	call   100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 b5 31 00 00       	call   103245 <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 91 17 00 00       	call   101826 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 11 19 00 00       	call   1019ab <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 53 0d 00 00       	call   100df2 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 ce 18 00 00       	call   101972 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	f3 0f 1e fb          	endbr32 
  1000aa:	55                   	push   %ebp
  1000ab:	89 e5                	mov    %esp,%ebp
  1000ad:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000b0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b7:	00 
  1000b8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bf:	00 
  1000c0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c7:	e8 10 0d 00 00       	call   100ddc <mon_backtrace>
}
  1000cc:	90                   	nop
  1000cd:	c9                   	leave  
  1000ce:	c3                   	ret    

001000cf <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cf:	f3 0f 1e fb          	endbr32 
  1000d3:	55                   	push   %ebp
  1000d4:	89 e5                	mov    %esp,%ebp
  1000d6:	53                   	push   %ebx
  1000d7:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000da:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000e0:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e6:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000ee:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000f2:	89 04 24             	mov    %eax,(%esp)
  1000f5:	e8 ac ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000fa:	90                   	nop
  1000fb:	83 c4 14             	add    $0x14,%esp
  1000fe:	5b                   	pop    %ebx
  1000ff:	5d                   	pop    %ebp
  100100:	c3                   	ret    

00100101 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  100101:	f3 0f 1e fb          	endbr32 
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  10010b:	8b 45 10             	mov    0x10(%ebp),%eax
  10010e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100112:	8b 45 08             	mov    0x8(%ebp),%eax
  100115:	89 04 24             	mov    %eax,(%esp)
  100118:	e8 b2 ff ff ff       	call   1000cf <grade_backtrace1>
}
  10011d:	90                   	nop
  10011e:	c9                   	leave  
  10011f:	c3                   	ret    

00100120 <grade_backtrace>:

void
grade_backtrace(void) {
  100120:	f3 0f 1e fb          	endbr32 
  100124:	55                   	push   %ebp
  100125:	89 e5                	mov    %esp,%ebp
  100127:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10012a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10012f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100136:	ff 
  100137:	89 44 24 04          	mov    %eax,0x4(%esp)
  10013b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100142:	e8 ba ff ff ff       	call   100101 <grade_backtrace0>
}
  100147:	90                   	nop
  100148:	c9                   	leave  
  100149:	c3                   	ret    

0010014a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10014a:	f3 0f 1e fb          	endbr32 
  10014e:	55                   	push   %ebp
  10014f:	89 e5                	mov    %esp,%ebp
  100151:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100154:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100157:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10015a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10015d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100160:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100164:	83 e0 03             	and    $0x3,%eax
  100167:	89 c2                	mov    %eax,%edx
  100169:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10016e:	89 54 24 08          	mov    %edx,0x8(%esp)
  100172:	89 44 24 04          	mov    %eax,0x4(%esp)
  100176:	c7 04 24 21 61 10 00 	movl   $0x106121,(%esp)
  10017d:	e8 38 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100182:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100186:	89 c2                	mov    %eax,%edx
  100188:	a1 00 c0 11 00       	mov    0x11c000,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 2f 61 10 00 	movl   $0x10612f,(%esp)
  10019c:	e8 19 01 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  1001a1:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  1001a5:	89 c2                	mov    %eax,%edx
  1001a7:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ac:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b4:	c7 04 24 3d 61 10 00 	movl   $0x10613d,(%esp)
  1001bb:	e8 fa 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001c0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001c4:	89 c2                	mov    %eax,%edx
  1001c6:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d3:	c7 04 24 4b 61 10 00 	movl   $0x10614b,(%esp)
  1001da:	e8 db 00 00 00       	call   1002ba <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001df:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001e3:	89 c2                	mov    %eax,%edx
  1001e5:	a1 00 c0 11 00       	mov    0x11c000,%eax
  1001ea:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001f2:	c7 04 24 59 61 10 00 	movl   $0x106159,(%esp)
  1001f9:	e8 bc 00 00 00       	call   1002ba <cprintf>
    round ++;
  1001fe:	a1 00 c0 11 00       	mov    0x11c000,%eax
  100203:	40                   	inc    %eax
  100204:	a3 00 c0 11 00       	mov    %eax,0x11c000
}
  100209:	90                   	nop
  10020a:	c9                   	leave  
  10020b:	c3                   	ret    

0010020c <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  10020c:	f3 0f 1e fb          	endbr32 
  100210:	55                   	push   %ebp
  100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  100213:	90                   	nop
  100214:	5d                   	pop    %ebp
  100215:	c3                   	ret    

00100216 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  100216:	f3 0f 1e fb          	endbr32 
  10021a:	55                   	push   %ebp
  10021b:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  10021d:	90                   	nop
  10021e:	5d                   	pop    %ebp
  10021f:	c3                   	ret    

00100220 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100220:	f3 0f 1e fb          	endbr32 
  100224:	55                   	push   %ebp
  100225:	89 e5                	mov    %esp,%ebp
  100227:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10022a:	e8 1b ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10022f:	c7 04 24 68 61 10 00 	movl   $0x106168,(%esp)
  100236:	e8 7f 00 00 00       	call   1002ba <cprintf>
    lab1_switch_to_user();
  10023b:	e8 cc ff ff ff       	call   10020c <lab1_switch_to_user>
    lab1_print_cur_status();
  100240:	e8 05 ff ff ff       	call   10014a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100245:	c7 04 24 88 61 10 00 	movl   $0x106188,(%esp)
  10024c:	e8 69 00 00 00       	call   1002ba <cprintf>
    lab1_switch_to_kernel();
  100251:	e8 c0 ff ff ff       	call   100216 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100256:	e8 ef fe ff ff       	call   10014a <lab1_print_cur_status>
}
  10025b:	90                   	nop
  10025c:	c9                   	leave  
  10025d:	c3                   	ret    

0010025e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10025e:	f3 0f 1e fb          	endbr32 
  100262:	55                   	push   %ebp
  100263:	89 e5                	mov    %esp,%ebp
  100265:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100268:	8b 45 08             	mov    0x8(%ebp),%eax
  10026b:	89 04 24             	mov    %eax,(%esp)
  10026e:	e8 69 14 00 00       	call   1016dc <cons_putc>
    (*cnt) ++;
  100273:	8b 45 0c             	mov    0xc(%ebp),%eax
  100276:	8b 00                	mov    (%eax),%eax
  100278:	8d 50 01             	lea    0x1(%eax),%edx
  10027b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10027e:	89 10                	mov    %edx,(%eax)
}
  100280:	90                   	nop
  100281:	c9                   	leave  
  100282:	c3                   	ret    

00100283 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100283:	f3 0f 1e fb          	endbr32 
  100287:	55                   	push   %ebp
  100288:	89 e5                	mov    %esp,%ebp
  10028a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10028d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100294:	8b 45 0c             	mov    0xc(%ebp),%eax
  100297:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10029b:	8b 45 08             	mov    0x8(%ebp),%eax
  10029e:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002a2:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002a5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a9:	c7 04 24 5e 02 10 00 	movl   $0x10025e,(%esp)
  1002b0:	e8 8a 59 00 00       	call   105c3f <vprintfmt>
    return cnt;
  1002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b8:	c9                   	leave  
  1002b9:	c3                   	ret    

001002ba <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  1002ba:	f3 0f 1e fb          	endbr32 
  1002be:	55                   	push   %ebp
  1002bf:	89 e5                	mov    %esp,%ebp
  1002c1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1002c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d4:	89 04 24             	mov    %eax,(%esp)
  1002d7:	e8 a7 ff ff ff       	call   100283 <vcprintf>
  1002dc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002e2:	c9                   	leave  
  1002e3:	c3                   	ret    

001002e4 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002e4:	f3 0f 1e fb          	endbr32 
  1002e8:	55                   	push   %ebp
  1002e9:	89 e5                	mov    %esp,%ebp
  1002eb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f1:	89 04 24             	mov    %eax,(%esp)
  1002f4:	e8 e3 13 00 00       	call   1016dc <cons_putc>
}
  1002f9:	90                   	nop
  1002fa:	c9                   	leave  
  1002fb:	c3                   	ret    

001002fc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002fc:	f3 0f 1e fb          	endbr32 
  100300:	55                   	push   %ebp
  100301:	89 e5                	mov    %esp,%ebp
  100303:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100306:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10030d:	eb 13                	jmp    100322 <cputs+0x26>
        cputch(c, &cnt);
  10030f:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100313:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100316:	89 54 24 04          	mov    %edx,0x4(%esp)
  10031a:	89 04 24             	mov    %eax,(%esp)
  10031d:	e8 3c ff ff ff       	call   10025e <cputch>
    while ((c = *str ++) != '\0') {
  100322:	8b 45 08             	mov    0x8(%ebp),%eax
  100325:	8d 50 01             	lea    0x1(%eax),%edx
  100328:	89 55 08             	mov    %edx,0x8(%ebp)
  10032b:	0f b6 00             	movzbl (%eax),%eax
  10032e:	88 45 f7             	mov    %al,-0x9(%ebp)
  100331:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100335:	75 d8                	jne    10030f <cputs+0x13>
    }
    cputch('\n', &cnt);
  100337:	8d 45 f0             	lea    -0x10(%ebp),%eax
  10033a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10033e:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100345:	e8 14 ff ff ff       	call   10025e <cputch>
    return cnt;
  10034a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  10034d:	c9                   	leave  
  10034e:	c3                   	ret    

0010034f <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10034f:	f3 0f 1e fb          	endbr32 
  100353:	55                   	push   %ebp
  100354:	89 e5                	mov    %esp,%ebp
  100356:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100359:	90                   	nop
  10035a:	e8 be 13 00 00       	call   10171d <cons_getc>
  10035f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100362:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100366:	74 f2                	je     10035a <getchar+0xb>
        /* do nothing */;
    return c;
  100368:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036b:	c9                   	leave  
  10036c:	c3                   	ret    

0010036d <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10036d:	f3 0f 1e fb          	endbr32 
  100371:	55                   	push   %ebp
  100372:	89 e5                	mov    %esp,%ebp
  100374:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100377:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10037b:	74 13                	je     100390 <readline+0x23>
        cprintf("%s", prompt);
  10037d:	8b 45 08             	mov    0x8(%ebp),%eax
  100380:	89 44 24 04          	mov    %eax,0x4(%esp)
  100384:	c7 04 24 a7 61 10 00 	movl   $0x1061a7,(%esp)
  10038b:	e8 2a ff ff ff       	call   1002ba <cprintf>
    }
    int i = 0, c;
  100390:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100397:	e8 b3 ff ff ff       	call   10034f <getchar>
  10039c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10039f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1003a3:	79 07                	jns    1003ac <readline+0x3f>
            return NULL;
  1003a5:	b8 00 00 00 00       	mov    $0x0,%eax
  1003aa:	eb 78                	jmp    100424 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  1003ac:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  1003b0:	7e 28                	jle    1003da <readline+0x6d>
  1003b2:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  1003b9:	7f 1f                	jg     1003da <readline+0x6d>
            cputchar(c);
  1003bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003be:	89 04 24             	mov    %eax,(%esp)
  1003c1:	e8 1e ff ff ff       	call   1002e4 <cputchar>
            buf[i ++] = c;
  1003c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003c9:	8d 50 01             	lea    0x1(%eax),%edx
  1003cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003cf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003d2:	88 90 20 c0 11 00    	mov    %dl,0x11c020(%eax)
  1003d8:	eb 45                	jmp    10041f <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003da:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003de:	75 16                	jne    1003f6 <readline+0x89>
  1003e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e4:	7e 10                	jle    1003f6 <readline+0x89>
            cputchar(c);
  1003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003e9:	89 04 24             	mov    %eax,(%esp)
  1003ec:	e8 f3 fe ff ff       	call   1002e4 <cputchar>
            i --;
  1003f1:	ff 4d f4             	decl   -0xc(%ebp)
  1003f4:	eb 29                	jmp    10041f <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003f6:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003fa:	74 06                	je     100402 <readline+0x95>
  1003fc:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100400:	75 95                	jne    100397 <readline+0x2a>
            cputchar(c);
  100402:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100405:	89 04 24             	mov    %eax,(%esp)
  100408:	e8 d7 fe ff ff       	call   1002e4 <cputchar>
            buf[i] = '\0';
  10040d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100410:	05 20 c0 11 00       	add    $0x11c020,%eax
  100415:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  100418:	b8 20 c0 11 00       	mov    $0x11c020,%eax
  10041d:	eb 05                	jmp    100424 <readline+0xb7>
        c = getchar();
  10041f:	e9 73 ff ff ff       	jmp    100397 <readline+0x2a>
        }
    }
}
  100424:	c9                   	leave  
  100425:	c3                   	ret    

00100426 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100426:	f3 0f 1e fb          	endbr32 
  10042a:	55                   	push   %ebp
  10042b:	89 e5                	mov    %esp,%ebp
  10042d:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100430:	a1 20 c4 11 00       	mov    0x11c420,%eax
  100435:	85 c0                	test   %eax,%eax
  100437:	75 5b                	jne    100494 <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100439:	c7 05 20 c4 11 00 01 	movl   $0x1,0x11c420
  100440:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100443:	8d 45 14             	lea    0x14(%ebp),%eax
  100446:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100449:	8b 45 0c             	mov    0xc(%ebp),%eax
  10044c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100450:	8b 45 08             	mov    0x8(%ebp),%eax
  100453:	89 44 24 04          	mov    %eax,0x4(%esp)
  100457:	c7 04 24 aa 61 10 00 	movl   $0x1061aa,(%esp)
  10045e:	e8 57 fe ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  100463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100466:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046a:	8b 45 10             	mov    0x10(%ebp),%eax
  10046d:	89 04 24             	mov    %eax,(%esp)
  100470:	e8 0e fe ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  100475:	c7 04 24 c6 61 10 00 	movl   $0x1061c6,(%esp)
  10047c:	e8 39 fe ff ff       	call   1002ba <cprintf>
    
    cprintf("stack trackback:\n");
  100481:	c7 04 24 c8 61 10 00 	movl   $0x1061c8,(%esp)
  100488:	e8 2d fe ff ff       	call   1002ba <cprintf>
    print_stackframe();
  10048d:	e8 3d 06 00 00       	call   100acf <print_stackframe>
  100492:	eb 01                	jmp    100495 <__panic+0x6f>
        goto panic_dead;
  100494:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100495:	e8 e4 14 00 00       	call   10197e <intr_disable>
    while (1) {
        kmonitor(NULL);
  10049a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1004a1:	e8 5d 08 00 00       	call   100d03 <kmonitor>
  1004a6:	eb f2                	jmp    10049a <__panic+0x74>

001004a8 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  1004a8:	f3 0f 1e fb          	endbr32 
  1004ac:	55                   	push   %ebp
  1004ad:	89 e5                	mov    %esp,%ebp
  1004af:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  1004b2:	8d 45 14             	lea    0x14(%ebp),%eax
  1004b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  1004b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1004bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1004c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004c6:	c7 04 24 da 61 10 00 	movl   $0x1061da,(%esp)
  1004cd:	e8 e8 fd ff ff       	call   1002ba <cprintf>
    vcprintf(fmt, ap);
  1004d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004d9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004dc:	89 04 24             	mov    %eax,(%esp)
  1004df:	e8 9f fd ff ff       	call   100283 <vcprintf>
    cprintf("\n");
  1004e4:	c7 04 24 c6 61 10 00 	movl   $0x1061c6,(%esp)
  1004eb:	e8 ca fd ff ff       	call   1002ba <cprintf>
    va_end(ap);
}
  1004f0:	90                   	nop
  1004f1:	c9                   	leave  
  1004f2:	c3                   	ret    

001004f3 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004f3:	f3 0f 1e fb          	endbr32 
  1004f7:	55                   	push   %ebp
  1004f8:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004fa:	a1 20 c4 11 00       	mov    0x11c420,%eax
}
  1004ff:	5d                   	pop    %ebp
  100500:	c3                   	ret    

00100501 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100501:	f3 0f 1e fb          	endbr32 
  100505:	55                   	push   %ebp
  100506:	89 e5                	mov    %esp,%ebp
  100508:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  10050b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050e:	8b 00                	mov    (%eax),%eax
  100510:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100513:	8b 45 10             	mov    0x10(%ebp),%eax
  100516:	8b 00                	mov    (%eax),%eax
  100518:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10051b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  100522:	e9 ca 00 00 00       	jmp    1005f1 <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100527:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10052d:	01 d0                	add    %edx,%eax
  10052f:	89 c2                	mov    %eax,%edx
  100531:	c1 ea 1f             	shr    $0x1f,%edx
  100534:	01 d0                	add    %edx,%eax
  100536:	d1 f8                	sar    %eax
  100538:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10053b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10053e:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100541:	eb 03                	jmp    100546 <stab_binsearch+0x45>
            m --;
  100543:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100546:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100549:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054c:	7c 1f                	jl     10056d <stab_binsearch+0x6c>
  10054e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100551:	89 d0                	mov    %edx,%eax
  100553:	01 c0                	add    %eax,%eax
  100555:	01 d0                	add    %edx,%eax
  100557:	c1 e0 02             	shl    $0x2,%eax
  10055a:	89 c2                	mov    %eax,%edx
  10055c:	8b 45 08             	mov    0x8(%ebp),%eax
  10055f:	01 d0                	add    %edx,%eax
  100561:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100565:	0f b6 c0             	movzbl %al,%eax
  100568:	39 45 14             	cmp    %eax,0x14(%ebp)
  10056b:	75 d6                	jne    100543 <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  10056d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100570:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100573:	7d 09                	jge    10057e <stab_binsearch+0x7d>
            l = true_m + 1;
  100575:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100578:	40                   	inc    %eax
  100579:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10057c:	eb 73                	jmp    1005f1 <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  10057e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100585:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100588:	89 d0                	mov    %edx,%eax
  10058a:	01 c0                	add    %eax,%eax
  10058c:	01 d0                	add    %edx,%eax
  10058e:	c1 e0 02             	shl    $0x2,%eax
  100591:	89 c2                	mov    %eax,%edx
  100593:	8b 45 08             	mov    0x8(%ebp),%eax
  100596:	01 d0                	add    %edx,%eax
  100598:	8b 40 08             	mov    0x8(%eax),%eax
  10059b:	39 45 18             	cmp    %eax,0x18(%ebp)
  10059e:	76 11                	jbe    1005b1 <stab_binsearch+0xb0>
            *region_left = m;
  1005a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005a3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005a6:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  1005a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1005ab:	40                   	inc    %eax
  1005ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1005af:	eb 40                	jmp    1005f1 <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  1005b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b4:	89 d0                	mov    %edx,%eax
  1005b6:	01 c0                	add    %eax,%eax
  1005b8:	01 d0                	add    %edx,%eax
  1005ba:	c1 e0 02             	shl    $0x2,%eax
  1005bd:	89 c2                	mov    %eax,%edx
  1005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c2:	01 d0                	add    %edx,%eax
  1005c4:	8b 40 08             	mov    0x8(%eax),%eax
  1005c7:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005ca:	73 14                	jae    1005e0 <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005cf:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1005d5:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005da:	48                   	dec    %eax
  1005db:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005de:	eb 11                	jmp    1005f1 <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005e6:	89 10                	mov    %edx,(%eax)
            l = m;
  1005e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005ee:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005f4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005f7:	0f 8e 2a ff ff ff    	jle    100527 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100601:	75 0f                	jne    100612 <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	8b 00                	mov    (%eax),%eax
  100608:	8d 50 ff             	lea    -0x1(%eax),%edx
  10060b:	8b 45 10             	mov    0x10(%ebp),%eax
  10060e:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  100610:	eb 3e                	jmp    100650 <stab_binsearch+0x14f>
        l = *region_right;
  100612:	8b 45 10             	mov    0x10(%ebp),%eax
  100615:	8b 00                	mov    (%eax),%eax
  100617:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  10061a:	eb 03                	jmp    10061f <stab_binsearch+0x11e>
  10061c:	ff 4d fc             	decl   -0x4(%ebp)
  10061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100622:	8b 00                	mov    (%eax),%eax
  100624:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100627:	7e 1f                	jle    100648 <stab_binsearch+0x147>
  100629:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10062c:	89 d0                	mov    %edx,%eax
  10062e:	01 c0                	add    %eax,%eax
  100630:	01 d0                	add    %edx,%eax
  100632:	c1 e0 02             	shl    $0x2,%eax
  100635:	89 c2                	mov    %eax,%edx
  100637:	8b 45 08             	mov    0x8(%ebp),%eax
  10063a:	01 d0                	add    %edx,%eax
  10063c:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100640:	0f b6 c0             	movzbl %al,%eax
  100643:	39 45 14             	cmp    %eax,0x14(%ebp)
  100646:	75 d4                	jne    10061c <stab_binsearch+0x11b>
        *region_left = l;
  100648:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10064e:	89 10                	mov    %edx,(%eax)
}
  100650:	90                   	nop
  100651:	c9                   	leave  
  100652:	c3                   	ret    

00100653 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100653:	f3 0f 1e fb          	endbr32 
  100657:	55                   	push   %ebp
  100658:	89 e5                	mov    %esp,%ebp
  10065a:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10065d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100660:	c7 00 f8 61 10 00    	movl   $0x1061f8,(%eax)
    info->eip_line = 0;
  100666:	8b 45 0c             	mov    0xc(%ebp),%eax
  100669:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100670:	8b 45 0c             	mov    0xc(%ebp),%eax
  100673:	c7 40 08 f8 61 10 00 	movl   $0x1061f8,0x8(%eax)
    info->eip_fn_namelen = 9;
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100684:	8b 45 0c             	mov    0xc(%ebp),%eax
  100687:	8b 55 08             	mov    0x8(%ebp),%edx
  10068a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10068d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100690:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100697:	c7 45 f4 20 74 10 00 	movl   $0x107420,-0xc(%ebp)
    stab_end = __STAB_END__;
  10069e:	c7 45 f0 2c 3d 11 00 	movl   $0x113d2c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  1006a5:	c7 45 ec 2d 3d 11 00 	movl   $0x113d2d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  1006ac:	c7 45 e8 46 68 11 00 	movl   $0x116846,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  1006b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006b6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  1006b9:	76 0b                	jbe    1006c6 <debuginfo_eip+0x73>
  1006bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1006be:	48                   	dec    %eax
  1006bf:	0f b6 00             	movzbl (%eax),%eax
  1006c2:	84 c0                	test   %al,%al
  1006c4:	74 0a                	je     1006d0 <debuginfo_eip+0x7d>
        return -1;
  1006c6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006cb:	e9 ab 02 00 00       	jmp    10097b <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006da:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006dd:	c1 f8 02             	sar    $0x2,%eax
  1006e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006e6:	48                   	dec    %eax
  1006e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006f1:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006f8:	00 
  1006f9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006fc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100700:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100703:	89 44 24 04          	mov    %eax,0x4(%esp)
  100707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10070a:	89 04 24             	mov    %eax,(%esp)
  10070d:	e8 ef fd ff ff       	call   100501 <stab_binsearch>
    if (lfile == 0)
  100712:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100715:	85 c0                	test   %eax,%eax
  100717:	75 0a                	jne    100723 <debuginfo_eip+0xd0>
        return -1;
  100719:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10071e:	e9 58 02 00 00       	jmp    10097b <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100726:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100729:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10072c:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  10072f:	8b 45 08             	mov    0x8(%ebp),%eax
  100732:	89 44 24 10          	mov    %eax,0x10(%esp)
  100736:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  10073d:	00 
  10073e:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100741:	89 44 24 08          	mov    %eax,0x8(%esp)
  100745:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100748:	89 44 24 04          	mov    %eax,0x4(%esp)
  10074c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074f:	89 04 24             	mov    %eax,(%esp)
  100752:	e8 aa fd ff ff       	call   100501 <stab_binsearch>

    if (lfun <= rfun) {
  100757:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10075a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10075d:	39 c2                	cmp    %eax,%edx
  10075f:	7f 78                	jg     1007d9 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100761:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100764:	89 c2                	mov    %eax,%edx
  100766:	89 d0                	mov    %edx,%eax
  100768:	01 c0                	add    %eax,%eax
  10076a:	01 d0                	add    %edx,%eax
  10076c:	c1 e0 02             	shl    $0x2,%eax
  10076f:	89 c2                	mov    %eax,%edx
  100771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100774:	01 d0                	add    %edx,%eax
  100776:	8b 10                	mov    (%eax),%edx
  100778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10077b:	2b 45 ec             	sub    -0x14(%ebp),%eax
  10077e:	39 c2                	cmp    %eax,%edx
  100780:	73 22                	jae    1007a4 <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100785:	89 c2                	mov    %eax,%edx
  100787:	89 d0                	mov    %edx,%eax
  100789:	01 c0                	add    %eax,%eax
  10078b:	01 d0                	add    %edx,%eax
  10078d:	c1 e0 02             	shl    $0x2,%eax
  100790:	89 c2                	mov    %eax,%edx
  100792:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	8b 10                	mov    (%eax),%edx
  100799:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10079c:	01 c2                	add    %eax,%edx
  10079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  1007a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a7:	89 c2                	mov    %eax,%edx
  1007a9:	89 d0                	mov    %edx,%eax
  1007ab:	01 c0                	add    %eax,%eax
  1007ad:	01 d0                	add    %edx,%eax
  1007af:	c1 e0 02             	shl    $0x2,%eax
  1007b2:	89 c2                	mov    %eax,%edx
  1007b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b7:	01 d0                	add    %edx,%eax
  1007b9:	8b 50 08             	mov    0x8(%eax),%edx
  1007bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007bf:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1007c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c5:	8b 40 10             	mov    0x10(%eax),%eax
  1007c8:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007ce:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007d4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007d7:	eb 15                	jmp    1007ee <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007dc:	8b 55 08             	mov    0x8(%ebp),%edx
  1007df:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007e8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007eb:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f1:	8b 40 08             	mov    0x8(%eax),%eax
  1007f4:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007fb:	00 
  1007fc:	89 04 24             	mov    %eax,(%esp)
  1007ff:	e8 43 4f 00 00       	call   105747 <strfind>
  100804:	8b 55 0c             	mov    0xc(%ebp),%edx
  100807:	8b 52 08             	mov    0x8(%edx),%edx
  10080a:	29 d0                	sub    %edx,%eax
  10080c:	89 c2                	mov    %eax,%edx
  10080e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100811:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  100814:	8b 45 08             	mov    0x8(%ebp),%eax
  100817:	89 44 24 10          	mov    %eax,0x10(%esp)
  10081b:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100822:	00 
  100823:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100826:	89 44 24 08          	mov    %eax,0x8(%esp)
  10082a:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  10082d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100834:	89 04 24             	mov    %eax,(%esp)
  100837:	e8 c5 fc ff ff       	call   100501 <stab_binsearch>
    if (lline <= rline) {
  10083c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10083f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100842:	39 c2                	cmp    %eax,%edx
  100844:	7f 23                	jg     100869 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100846:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100849:	89 c2                	mov    %eax,%edx
  10084b:	89 d0                	mov    %edx,%eax
  10084d:	01 c0                	add    %eax,%eax
  10084f:	01 d0                	add    %edx,%eax
  100851:	c1 e0 02             	shl    $0x2,%eax
  100854:	89 c2                	mov    %eax,%edx
  100856:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100859:	01 d0                	add    %edx,%eax
  10085b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10085f:	89 c2                	mov    %eax,%edx
  100861:	8b 45 0c             	mov    0xc(%ebp),%eax
  100864:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100867:	eb 11                	jmp    10087a <debuginfo_eip+0x227>
        return -1;
  100869:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10086e:	e9 08 01 00 00       	jmp    10097b <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100873:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100876:	48                   	dec    %eax
  100877:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10087a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10087d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100880:	39 c2                	cmp    %eax,%edx
  100882:	7c 56                	jl     1008da <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  100884:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100887:	89 c2                	mov    %eax,%edx
  100889:	89 d0                	mov    %edx,%eax
  10088b:	01 c0                	add    %eax,%eax
  10088d:	01 d0                	add    %edx,%eax
  10088f:	c1 e0 02             	shl    $0x2,%eax
  100892:	89 c2                	mov    %eax,%edx
  100894:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100897:	01 d0                	add    %edx,%eax
  100899:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10089d:	3c 84                	cmp    $0x84,%al
  10089f:	74 39                	je     1008da <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  1008a1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008a4:	89 c2                	mov    %eax,%edx
  1008a6:	89 d0                	mov    %edx,%eax
  1008a8:	01 c0                	add    %eax,%eax
  1008aa:	01 d0                	add    %edx,%eax
  1008ac:	c1 e0 02             	shl    $0x2,%eax
  1008af:	89 c2                	mov    %eax,%edx
  1008b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008b4:	01 d0                	add    %edx,%eax
  1008b6:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1008ba:	3c 64                	cmp    $0x64,%al
  1008bc:	75 b5                	jne    100873 <debuginfo_eip+0x220>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 40 08             	mov    0x8(%eax),%eax
  1008d6:	85 c0                	test   %eax,%eax
  1008d8:	74 99                	je     100873 <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008da:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008e0:	39 c2                	cmp    %eax,%edx
  1008e2:	7c 42                	jl     100926 <debuginfo_eip+0x2d3>
  1008e4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e7:	89 c2                	mov    %eax,%edx
  1008e9:	89 d0                	mov    %edx,%eax
  1008eb:	01 c0                	add    %eax,%eax
  1008ed:	01 d0                	add    %edx,%eax
  1008ef:	c1 e0 02             	shl    $0x2,%eax
  1008f2:	89 c2                	mov    %eax,%edx
  1008f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	8b 10                	mov    (%eax),%edx
  1008fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008fe:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100901:	39 c2                	cmp    %eax,%edx
  100903:	73 21                	jae    100926 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  100905:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100908:	89 c2                	mov    %eax,%edx
  10090a:	89 d0                	mov    %edx,%eax
  10090c:	01 c0                	add    %eax,%eax
  10090e:	01 d0                	add    %edx,%eax
  100910:	c1 e0 02             	shl    $0x2,%eax
  100913:	89 c2                	mov    %eax,%edx
  100915:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100918:	01 d0                	add    %edx,%eax
  10091a:	8b 10                	mov    (%eax),%edx
  10091c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10091f:	01 c2                	add    %eax,%edx
  100921:	8b 45 0c             	mov    0xc(%ebp),%eax
  100924:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100926:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100929:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10092c:	39 c2                	cmp    %eax,%edx
  10092e:	7d 46                	jge    100976 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  100930:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100933:	40                   	inc    %eax
  100934:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100937:	eb 16                	jmp    10094f <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100939:	8b 45 0c             	mov    0xc(%ebp),%eax
  10093c:	8b 40 14             	mov    0x14(%eax),%eax
  10093f:	8d 50 01             	lea    0x1(%eax),%edx
  100942:	8b 45 0c             	mov    0xc(%ebp),%eax
  100945:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100948:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10094b:	40                   	inc    %eax
  10094c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10094f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100952:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100955:	39 c2                	cmp    %eax,%edx
  100957:	7d 1d                	jge    100976 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100959:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10095c:	89 c2                	mov    %eax,%edx
  10095e:	89 d0                	mov    %edx,%eax
  100960:	01 c0                	add    %eax,%eax
  100962:	01 d0                	add    %edx,%eax
  100964:	c1 e0 02             	shl    $0x2,%eax
  100967:	89 c2                	mov    %eax,%edx
  100969:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10096c:	01 d0                	add    %edx,%eax
  10096e:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100972:	3c a0                	cmp    $0xa0,%al
  100974:	74 c3                	je     100939 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100976:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10097b:	c9                   	leave  
  10097c:	c3                   	ret    

0010097d <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  10097d:	f3 0f 1e fb          	endbr32 
  100981:	55                   	push   %ebp
  100982:	89 e5                	mov    %esp,%ebp
  100984:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100987:	c7 04 24 02 62 10 00 	movl   $0x106202,(%esp)
  10098e:	e8 27 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100993:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  10099a:	00 
  10099b:	c7 04 24 1b 62 10 00 	movl   $0x10621b,(%esp)
  1009a2:	e8 13 f9 ff ff       	call   1002ba <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  1009a7:	c7 44 24 04 f7 60 10 	movl   $0x1060f7,0x4(%esp)
  1009ae:	00 
  1009af:	c7 04 24 33 62 10 00 	movl   $0x106233,(%esp)
  1009b6:	e8 ff f8 ff ff       	call   1002ba <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1009bb:	c7 44 24 04 36 9a 11 	movl   $0x119a36,0x4(%esp)
  1009c2:	00 
  1009c3:	c7 04 24 4b 62 10 00 	movl   $0x10624b,(%esp)
  1009ca:	e8 eb f8 ff ff       	call   1002ba <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009cf:	c7 44 24 04 28 cf 11 	movl   $0x11cf28,0x4(%esp)
  1009d6:	00 
  1009d7:	c7 04 24 63 62 10 00 	movl   $0x106263,(%esp)
  1009de:	e8 d7 f8 ff ff       	call   1002ba <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009e3:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  1009e8:	2d 36 00 10 00       	sub    $0x100036,%eax
  1009ed:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009f2:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009f8:	85 c0                	test   %eax,%eax
  1009fa:	0f 48 c2             	cmovs  %edx,%eax
  1009fd:	c1 f8 0a             	sar    $0xa,%eax
  100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a04:	c7 04 24 7c 62 10 00 	movl   $0x10627c,(%esp)
  100a0b:	e8 aa f8 ff ff       	call   1002ba <cprintf>
}
  100a10:	90                   	nop
  100a11:	c9                   	leave  
  100a12:	c3                   	ret    

00100a13 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100a13:	f3 0f 1e fb          	endbr32 
  100a17:	55                   	push   %ebp
  100a18:	89 e5                	mov    %esp,%ebp
  100a1a:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  100a20:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a27:	8b 45 08             	mov    0x8(%ebp),%eax
  100a2a:	89 04 24             	mov    %eax,(%esp)
  100a2d:	e8 21 fc ff ff       	call   100653 <debuginfo_eip>
  100a32:	85 c0                	test   %eax,%eax
  100a34:	74 15                	je     100a4b <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a36:	8b 45 08             	mov    0x8(%ebp),%eax
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 a6 62 10 00 	movl   $0x1062a6,(%esp)
  100a44:	e8 71 f8 ff ff       	call   1002ba <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a49:	eb 6c                	jmp    100ab7 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a52:	eb 1b                	jmp    100a6f <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a54:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	0f b6 10             	movzbl (%eax),%edx
  100a5f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a68:	01 c8                	add    %ecx,%eax
  100a6a:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a6c:	ff 45 f4             	incl   -0xc(%ebp)
  100a6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a72:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a75:	7c dd                	jl     100a54 <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a77:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a80:	01 d0                	add    %edx,%eax
  100a82:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a88:	8b 55 08             	mov    0x8(%ebp),%edx
  100a8b:	89 d1                	mov    %edx,%ecx
  100a8d:	29 c1                	sub    %eax,%ecx
  100a8f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a92:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a95:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a99:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a9f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100aa3:	89 54 24 08          	mov    %edx,0x8(%esp)
  100aa7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aab:	c7 04 24 c2 62 10 00 	movl   $0x1062c2,(%esp)
  100ab2:	e8 03 f8 ff ff       	call   1002ba <cprintf>
}
  100ab7:	90                   	nop
  100ab8:	c9                   	leave  
  100ab9:	c3                   	ret    

00100aba <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100aba:	f3 0f 1e fb          	endbr32 
  100abe:	55                   	push   %ebp
  100abf:	89 e5                	mov    %esp,%ebp
  100ac1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100ac4:	8b 45 04             	mov    0x4(%ebp),%eax
  100ac7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aca:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100acd:	c9                   	leave  
  100ace:	c3                   	ret    

00100acf <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100acf:	f3 0f 1e fb          	endbr32 
  100ad3:	55                   	push   %ebp
  100ad4:	89 e5                	mov    %esp,%ebp
  100ad6:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ad9:	89 e8                	mov    %ebp,%eax
  100adb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  100ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  100ae1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ae4:	e8 d1 ff ff ff       	call   100aba <read_eip>
  100ae9:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100aec:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100af3:	e9 84 00 00 00       	jmp    100b7c <print_stackframe+0xad>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  100af8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100afb:	89 44 24 08          	mov    %eax,0x8(%esp)
  100aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b02:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b06:	c7 04 24 d4 62 10 00 	movl   $0x1062d4,(%esp)
  100b0d:	e8 a8 f7 ff ff       	call   1002ba <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  100b12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b15:	83 c0 08             	add    $0x8,%eax
  100b18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  100b1b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100b22:	eb 24                	jmp    100b48 <print_stackframe+0x79>
            cprintf("0x%08x ", args[j]);
  100b24:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100b27:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100b31:	01 d0                	add    %edx,%eax
  100b33:	8b 00                	mov    (%eax),%eax
  100b35:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b39:	c7 04 24 f0 62 10 00 	movl   $0x1062f0,(%esp)
  100b40:	e8 75 f7 ff ff       	call   1002ba <cprintf>
        for (j = 0; j < 4; j ++) {
  100b45:	ff 45 e8             	incl   -0x18(%ebp)
  100b48:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100b4c:	7e d6                	jle    100b24 <print_stackframe+0x55>
        }
        cprintf("\n");
  100b4e:	c7 04 24 f8 62 10 00 	movl   $0x1062f8,(%esp)
  100b55:	e8 60 f7 ff ff       	call   1002ba <cprintf>
        print_debuginfo(eip - 1);
  100b5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b5d:	48                   	dec    %eax
  100b5e:	89 04 24             	mov    %eax,(%esp)
  100b61:	e8 ad fe ff ff       	call   100a13 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b69:	83 c0 04             	add    $0x4,%eax
  100b6c:	8b 00                	mov    (%eax),%eax
  100b6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b74:	8b 00                	mov    (%eax),%eax
  100b76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100b79:	ff 45 ec             	incl   -0x14(%ebp)
  100b7c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100b80:	74 0a                	je     100b8c <print_stackframe+0xbd>
  100b82:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b86:	0f 8e 6c ff ff ff    	jle    100af8 <print_stackframe+0x29>
    }
}
  100b8c:	90                   	nop
  100b8d:	c9                   	leave  
  100b8e:	c3                   	ret    

00100b8f <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b8f:	f3 0f 1e fb          	endbr32 
  100b93:	55                   	push   %ebp
  100b94:	89 e5                	mov    %esp,%ebp
  100b96:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b99:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100ba0:	eb 0c                	jmp    100bae <parse+0x1f>
            *buf ++ = '\0';
  100ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba5:	8d 50 01             	lea    0x1(%eax),%edx
  100ba8:	89 55 08             	mov    %edx,0x8(%ebp)
  100bab:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bae:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb1:	0f b6 00             	movzbl (%eax),%eax
  100bb4:	84 c0                	test   %al,%al
  100bb6:	74 1d                	je     100bd5 <parse+0x46>
  100bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbb:	0f b6 00             	movzbl (%eax),%eax
  100bbe:	0f be c0             	movsbl %al,%eax
  100bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc5:	c7 04 24 7c 63 10 00 	movl   $0x10637c,(%esp)
  100bcc:	e8 40 4b 00 00       	call   105711 <strchr>
  100bd1:	85 c0                	test   %eax,%eax
  100bd3:	75 cd                	jne    100ba2 <parse+0x13>
        }
        if (*buf == '\0') {
  100bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  100bd8:	0f b6 00             	movzbl (%eax),%eax
  100bdb:	84 c0                	test   %al,%al
  100bdd:	74 65                	je     100c44 <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bdf:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100be3:	75 14                	jne    100bf9 <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100be5:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bec:	00 
  100bed:	c7 04 24 81 63 10 00 	movl   $0x106381,(%esp)
  100bf4:	e8 c1 f6 ff ff       	call   1002ba <cprintf>
        }
        argv[argc ++] = buf;
  100bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bfc:	8d 50 01             	lea    0x1(%eax),%edx
  100bff:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100c02:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  100c0c:	01 c2                	add    %eax,%edx
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c13:	eb 03                	jmp    100c18 <parse+0x89>
            buf ++;
  100c15:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100c18:	8b 45 08             	mov    0x8(%ebp),%eax
  100c1b:	0f b6 00             	movzbl (%eax),%eax
  100c1e:	84 c0                	test   %al,%al
  100c20:	74 8c                	je     100bae <parse+0x1f>
  100c22:	8b 45 08             	mov    0x8(%ebp),%eax
  100c25:	0f b6 00             	movzbl (%eax),%eax
  100c28:	0f be c0             	movsbl %al,%eax
  100c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2f:	c7 04 24 7c 63 10 00 	movl   $0x10637c,(%esp)
  100c36:	e8 d6 4a 00 00       	call   105711 <strchr>
  100c3b:	85 c0                	test   %eax,%eax
  100c3d:	74 d6                	je     100c15 <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c3f:	e9 6a ff ff ff       	jmp    100bae <parse+0x1f>
            break;
  100c44:	90                   	nop
        }
    }
    return argc;
  100c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c48:	c9                   	leave  
  100c49:	c3                   	ret    

00100c4a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c4a:	f3 0f 1e fb          	endbr32 
  100c4e:	55                   	push   %ebp
  100c4f:	89 e5                	mov    %esp,%ebp
  100c51:	53                   	push   %ebx
  100c52:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c55:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  100c5f:	89 04 24             	mov    %eax,(%esp)
  100c62:	e8 28 ff ff ff       	call   100b8f <parse>
  100c67:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c6a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c6e:	75 0a                	jne    100c7a <runcmd+0x30>
        return 0;
  100c70:	b8 00 00 00 00       	mov    $0x0,%eax
  100c75:	e9 83 00 00 00       	jmp    100cfd <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c81:	eb 5a                	jmp    100cdd <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c83:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c86:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c89:	89 d0                	mov    %edx,%eax
  100c8b:	01 c0                	add    %eax,%eax
  100c8d:	01 d0                	add    %edx,%eax
  100c8f:	c1 e0 02             	shl    $0x2,%eax
  100c92:	05 00 90 11 00       	add    $0x119000,%eax
  100c97:	8b 00                	mov    (%eax),%eax
  100c99:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c9d:	89 04 24             	mov    %eax,(%esp)
  100ca0:	e8 c8 49 00 00       	call   10566d <strcmp>
  100ca5:	85 c0                	test   %eax,%eax
  100ca7:	75 31                	jne    100cda <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100ca9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100cac:	89 d0                	mov    %edx,%eax
  100cae:	01 c0                	add    %eax,%eax
  100cb0:	01 d0                	add    %edx,%eax
  100cb2:	c1 e0 02             	shl    $0x2,%eax
  100cb5:	05 08 90 11 00       	add    $0x119008,%eax
  100cba:	8b 10                	mov    (%eax),%edx
  100cbc:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100cbf:	83 c0 04             	add    $0x4,%eax
  100cc2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cc5:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cc8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100ccb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100ccf:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd3:	89 1c 24             	mov    %ebx,(%esp)
  100cd6:	ff d2                	call   *%edx
  100cd8:	eb 23                	jmp    100cfd <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cda:	ff 45 f4             	incl   -0xc(%ebp)
  100cdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce0:	83 f8 02             	cmp    $0x2,%eax
  100ce3:	76 9e                	jbe    100c83 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ce5:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cec:	c7 04 24 9f 63 10 00 	movl   $0x10639f,(%esp)
  100cf3:	e8 c2 f5 ff ff       	call   1002ba <cprintf>
    return 0;
  100cf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cfd:	83 c4 64             	add    $0x64,%esp
  100d00:	5b                   	pop    %ebx
  100d01:	5d                   	pop    %ebp
  100d02:	c3                   	ret    

00100d03 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100d03:	f3 0f 1e fb          	endbr32 
  100d07:	55                   	push   %ebp
  100d08:	89 e5                	mov    %esp,%ebp
  100d0a:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100d0d:	c7 04 24 b8 63 10 00 	movl   $0x1063b8,(%esp)
  100d14:	e8 a1 f5 ff ff       	call   1002ba <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100d19:	c7 04 24 e0 63 10 00 	movl   $0x1063e0,(%esp)
  100d20:	e8 95 f5 ff ff       	call   1002ba <cprintf>

    if (tf != NULL) {
  100d25:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d29:	74 0b                	je     100d36 <kmonitor+0x33>
        print_trapframe(tf);
  100d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2e:	89 04 24             	mov    %eax,(%esp)
  100d31:	e8 bc 0d 00 00       	call   101af2 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d36:	c7 04 24 05 64 10 00 	movl   $0x106405,(%esp)
  100d3d:	e8 2b f6 ff ff       	call   10036d <readline>
  100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d49:	74 eb                	je     100d36 <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d55:	89 04 24             	mov    %eax,(%esp)
  100d58:	e8 ed fe ff ff       	call   100c4a <runcmd>
  100d5d:	85 c0                	test   %eax,%eax
  100d5f:	78 02                	js     100d63 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d61:	eb d3                	jmp    100d36 <kmonitor+0x33>
                break;
  100d63:	90                   	nop
            }
        }
    }
}
  100d64:	90                   	nop
  100d65:	c9                   	leave  
  100d66:	c3                   	ret    

00100d67 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d67:	f3 0f 1e fb          	endbr32 
  100d6b:	55                   	push   %ebp
  100d6c:	89 e5                	mov    %esp,%ebp
  100d6e:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d78:	eb 3d                	jmp    100db7 <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d7d:	89 d0                	mov    %edx,%eax
  100d7f:	01 c0                	add    %eax,%eax
  100d81:	01 d0                	add    %edx,%eax
  100d83:	c1 e0 02             	shl    $0x2,%eax
  100d86:	05 04 90 11 00       	add    $0x119004,%eax
  100d8b:	8b 08                	mov    (%eax),%ecx
  100d8d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d90:	89 d0                	mov    %edx,%eax
  100d92:	01 c0                	add    %eax,%eax
  100d94:	01 d0                	add    %edx,%eax
  100d96:	c1 e0 02             	shl    $0x2,%eax
  100d99:	05 00 90 11 00       	add    $0x119000,%eax
  100d9e:	8b 00                	mov    (%eax),%eax
  100da0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100da4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100da8:	c7 04 24 09 64 10 00 	movl   $0x106409,(%esp)
  100daf:	e8 06 f5 ff ff       	call   1002ba <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100db4:	ff 45 f4             	incl   -0xc(%ebp)
  100db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100dba:	83 f8 02             	cmp    $0x2,%eax
  100dbd:	76 bb                	jbe    100d7a <mon_help+0x13>
    }
    return 0;
  100dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dc4:	c9                   	leave  
  100dc5:	c3                   	ret    

00100dc6 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dc6:	f3 0f 1e fb          	endbr32 
  100dca:	55                   	push   %ebp
  100dcb:	89 e5                	mov    %esp,%ebp
  100dcd:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100dd0:	e8 a8 fb ff ff       	call   10097d <print_kerninfo>
    return 0;
  100dd5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dda:	c9                   	leave  
  100ddb:	c3                   	ret    

00100ddc <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ddc:	f3 0f 1e fb          	endbr32 
  100de0:	55                   	push   %ebp
  100de1:	89 e5                	mov    %esp,%ebp
  100de3:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100de6:	e8 e4 fc ff ff       	call   100acf <print_stackframe>
    return 0;
  100deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df0:	c9                   	leave  
  100df1:	c3                   	ret    

00100df2 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100df2:	f3 0f 1e fb          	endbr32 
  100df6:	55                   	push   %ebp
  100df7:	89 e5                	mov    %esp,%ebp
  100df9:	83 ec 28             	sub    $0x28,%esp
  100dfc:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100e02:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e06:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e0a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e0e:	ee                   	out    %al,(%dx)
}
  100e0f:	90                   	nop
  100e10:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100e16:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e1a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e1e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e22:	ee                   	out    %al,(%dx)
}
  100e23:	90                   	nop
  100e24:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e2a:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100e2e:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e32:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e36:	ee                   	out    %al,(%dx)
}
  100e37:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e38:	c7 05 0c cf 11 00 00 	movl   $0x0,0x11cf0c
  100e3f:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e42:	c7 04 24 12 64 10 00 	movl   $0x106412,(%esp)
  100e49:	e8 6c f4 ff ff       	call   1002ba <cprintf>
    pic_enable(IRQ_TIMER);
  100e4e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e55:	e8 95 09 00 00       	call   1017ef <pic_enable>
}
  100e5a:	90                   	nop
  100e5b:	c9                   	leave  
  100e5c:	c3                   	ret    

00100e5d <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100e5d:	55                   	push   %ebp
  100e5e:	89 e5                	mov    %esp,%ebp
  100e60:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100e63:	9c                   	pushf  
  100e64:	58                   	pop    %eax
  100e65:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100e68:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100e6b:	25 00 02 00 00       	and    $0x200,%eax
  100e70:	85 c0                	test   %eax,%eax
  100e72:	74 0c                	je     100e80 <__intr_save+0x23>
        intr_disable();
  100e74:	e8 05 0b 00 00       	call   10197e <intr_disable>
        return 1;
  100e79:	b8 01 00 00 00       	mov    $0x1,%eax
  100e7e:	eb 05                	jmp    100e85 <__intr_save+0x28>
    }
    return 0;
  100e80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e85:	c9                   	leave  
  100e86:	c3                   	ret    

00100e87 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e87:	55                   	push   %ebp
  100e88:	89 e5                	mov    %esp,%ebp
  100e8a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e91:	74 05                	je     100e98 <__intr_restore+0x11>
        intr_enable();
  100e93:	e8 da 0a 00 00       	call   101972 <intr_enable>
    }
}
  100e98:	90                   	nop
  100e99:	c9                   	leave  
  100e9a:	c3                   	ret    

00100e9b <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e9b:	f3 0f 1e fb          	endbr32 
  100e9f:	55                   	push   %ebp
  100ea0:	89 e5                	mov    %esp,%ebp
  100ea2:	83 ec 10             	sub    $0x10,%esp
  100ea5:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eab:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100eaf:	89 c2                	mov    %eax,%edx
  100eb1:	ec                   	in     (%dx),%al
  100eb2:	88 45 f1             	mov    %al,-0xf(%ebp)
  100eb5:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100ebb:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100ebf:	89 c2                	mov    %eax,%edx
  100ec1:	ec                   	in     (%dx),%al
  100ec2:	88 45 f5             	mov    %al,-0xb(%ebp)
  100ec5:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100ecb:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ecf:	89 c2                	mov    %eax,%edx
  100ed1:	ec                   	in     (%dx),%al
  100ed2:	88 45 f9             	mov    %al,-0x7(%ebp)
  100ed5:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100edb:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100edf:	89 c2                	mov    %eax,%edx
  100ee1:	ec                   	in     (%dx),%al
  100ee2:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100ee5:	90                   	nop
  100ee6:	c9                   	leave  
  100ee7:	c3                   	ret    

00100ee8 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100ee8:	f3 0f 1e fb          	endbr32 
  100eec:	55                   	push   %ebp
  100eed:	89 e5                	mov    %esp,%ebp
  100eef:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100ef2:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100ef9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100efc:	0f b7 00             	movzwl (%eax),%eax
  100eff:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100f03:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f06:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100f0b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f0e:	0f b7 00             	movzwl (%eax),%eax
  100f11:	0f b7 c0             	movzwl %ax,%eax
  100f14:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100f19:	74 12                	je     100f2d <cga_init+0x45>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100f1b:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100f22:	66 c7 05 46 c4 11 00 	movw   $0x3b4,0x11c446
  100f29:	b4 03 
  100f2b:	eb 13                	jmp    100f40 <cga_init+0x58>
    } else {
        *cp = was;
  100f2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f30:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100f34:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100f37:	66 c7 05 46 c4 11 00 	movw   $0x3d4,0x11c446
  100f3e:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100f40:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f47:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f4b:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4f:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f53:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f57:	ee                   	out    %al,(%dx)
}
  100f58:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;
  100f59:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f60:	40                   	inc    %eax
  100f61:	0f b7 c0             	movzwl %ax,%eax
  100f64:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f68:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f6c:	89 c2                	mov    %eax,%edx
  100f6e:	ec                   	in     (%dx),%al
  100f6f:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f72:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f76:	0f b6 c0             	movzbl %al,%eax
  100f79:	c1 e0 08             	shl    $0x8,%eax
  100f7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f7f:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f86:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f8a:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f8e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f92:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f96:	ee                   	out    %al,(%dx)
}
  100f97:	90                   	nop
    pos |= inb(addr_6845 + 1);
  100f98:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  100f9f:	40                   	inc    %eax
  100fa0:	0f b7 c0             	movzwl %ax,%eax
  100fa3:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fa7:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100fab:	89 c2                	mov    %eax,%edx
  100fad:	ec                   	in     (%dx),%al
  100fae:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100fb1:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fb5:	0f b6 c0             	movzbl %al,%eax
  100fb8:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100fbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100fbe:	a3 40 c4 11 00       	mov    %eax,0x11c440
    crt_pos = pos;
  100fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100fc6:	0f b7 c0             	movzwl %ax,%eax
  100fc9:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
}
  100fcf:	90                   	nop
  100fd0:	c9                   	leave  
  100fd1:	c3                   	ret    

00100fd2 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100fd2:	f3 0f 1e fb          	endbr32 
  100fd6:	55                   	push   %ebp
  100fd7:	89 e5                	mov    %esp,%ebp
  100fd9:	83 ec 48             	sub    $0x48,%esp
  100fdc:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100fe2:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100fe6:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100fea:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100fee:	ee                   	out    %al,(%dx)
}
  100fef:	90                   	nop
  100ff0:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100ff6:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ffa:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100ffe:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101002:	ee                   	out    %al,(%dx)
}
  101003:	90                   	nop
  101004:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  10100a:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10100e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101012:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101016:	ee                   	out    %al,(%dx)
}
  101017:	90                   	nop
  101018:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  10101e:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101022:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101026:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  10102a:	ee                   	out    %al,(%dx)
}
  10102b:	90                   	nop
  10102c:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  101032:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101036:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  10103a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10103e:	ee                   	out    %al,(%dx)
}
  10103f:	90                   	nop
  101040:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  101046:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10104a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10104e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101052:	ee                   	out    %al,(%dx)
}
  101053:	90                   	nop
  101054:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  10105a:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10105e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101062:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101066:	ee                   	out    %al,(%dx)
}
  101067:	90                   	nop
  101068:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10106e:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  101072:	89 c2                	mov    %eax,%edx
  101074:	ec                   	in     (%dx),%al
  101075:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101078:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  10107c:	3c ff                	cmp    $0xff,%al
  10107e:	0f 95 c0             	setne  %al
  101081:	0f b6 c0             	movzbl %al,%eax
  101084:	a3 48 c4 11 00       	mov    %eax,0x11c448
  101089:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10108f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  101093:	89 c2                	mov    %eax,%edx
  101095:	ec                   	in     (%dx),%al
  101096:	88 45 f1             	mov    %al,-0xf(%ebp)
  101099:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10109f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1010a3:	89 c2                	mov    %eax,%edx
  1010a5:	ec                   	in     (%dx),%al
  1010a6:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  1010a9:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1010ae:	85 c0                	test   %eax,%eax
  1010b0:	74 0c                	je     1010be <serial_init+0xec>
        pic_enable(IRQ_COM1);
  1010b2:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  1010b9:	e8 31 07 00 00       	call   1017ef <pic_enable>
    }
}
  1010be:	90                   	nop
  1010bf:	c9                   	leave  
  1010c0:	c3                   	ret    

001010c1 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  1010c1:	f3 0f 1e fb          	endbr32 
  1010c5:	55                   	push   %ebp
  1010c6:	89 e5                	mov    %esp,%ebp
  1010c8:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1010d2:	eb 08                	jmp    1010dc <lpt_putc_sub+0x1b>
        delay();
  1010d4:	e8 c2 fd ff ff       	call   100e9b <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  1010d9:	ff 45 fc             	incl   -0x4(%ebp)
  1010dc:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  1010e2:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1010e6:	89 c2                	mov    %eax,%edx
  1010e8:	ec                   	in     (%dx),%al
  1010e9:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1010ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1010f0:	84 c0                	test   %al,%al
  1010f2:	78 09                	js     1010fd <lpt_putc_sub+0x3c>
  1010f4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010fb:	7e d7                	jle    1010d4 <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  101100:	0f b6 c0             	movzbl %al,%eax
  101103:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101109:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10110c:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101110:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101114:	ee                   	out    %al,(%dx)
}
  101115:	90                   	nop
  101116:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10111c:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101120:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101124:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101128:	ee                   	out    %al,(%dx)
}
  101129:	90                   	nop
  10112a:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101130:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101134:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101138:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10113c:	ee                   	out    %al,(%dx)
}
  10113d:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10113e:	90                   	nop
  10113f:	c9                   	leave  
  101140:	c3                   	ret    

00101141 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101141:	f3 0f 1e fb          	endbr32 
  101145:	55                   	push   %ebp
  101146:	89 e5                	mov    %esp,%ebp
  101148:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10114b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10114f:	74 0d                	je     10115e <lpt_putc+0x1d>
        lpt_putc_sub(c);
  101151:	8b 45 08             	mov    0x8(%ebp),%eax
  101154:	89 04 24             	mov    %eax,(%esp)
  101157:	e8 65 ff ff ff       	call   1010c1 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10115c:	eb 24                	jmp    101182 <lpt_putc+0x41>
        lpt_putc_sub('\b');
  10115e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101165:	e8 57 ff ff ff       	call   1010c1 <lpt_putc_sub>
        lpt_putc_sub(' ');
  10116a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101171:	e8 4b ff ff ff       	call   1010c1 <lpt_putc_sub>
        lpt_putc_sub('\b');
  101176:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10117d:	e8 3f ff ff ff       	call   1010c1 <lpt_putc_sub>
}
  101182:	90                   	nop
  101183:	c9                   	leave  
  101184:	c3                   	ret    

00101185 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101185:	f3 0f 1e fb          	endbr32 
  101189:	55                   	push   %ebp
  10118a:	89 e5                	mov    %esp,%ebp
  10118c:	53                   	push   %ebx
  10118d:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101190:	8b 45 08             	mov    0x8(%ebp),%eax
  101193:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101198:	85 c0                	test   %eax,%eax
  10119a:	75 07                	jne    1011a3 <cga_putc+0x1e>
        c |= 0x0700;
  10119c:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a6:	0f b6 c0             	movzbl %al,%eax
  1011a9:	83 f8 0d             	cmp    $0xd,%eax
  1011ac:	74 72                	je     101220 <cga_putc+0x9b>
  1011ae:	83 f8 0d             	cmp    $0xd,%eax
  1011b1:	0f 8f a3 00 00 00    	jg     10125a <cga_putc+0xd5>
  1011b7:	83 f8 08             	cmp    $0x8,%eax
  1011ba:	74 0a                	je     1011c6 <cga_putc+0x41>
  1011bc:	83 f8 0a             	cmp    $0xa,%eax
  1011bf:	74 4c                	je     10120d <cga_putc+0x88>
  1011c1:	e9 94 00 00 00       	jmp    10125a <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  1011c6:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011cd:	85 c0                	test   %eax,%eax
  1011cf:	0f 84 af 00 00 00    	je     101284 <cga_putc+0xff>
            crt_pos --;
  1011d5:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1011dc:	48                   	dec    %eax
  1011dd:	0f b7 c0             	movzwl %ax,%eax
  1011e0:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1011e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1011e9:	98                   	cwtl   
  1011ea:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1011ef:	98                   	cwtl   
  1011f0:	83 c8 20             	or     $0x20,%eax
  1011f3:	98                   	cwtl   
  1011f4:	8b 15 40 c4 11 00    	mov    0x11c440,%edx
  1011fa:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  101201:	01 c9                	add    %ecx,%ecx
  101203:	01 ca                	add    %ecx,%edx
  101205:	0f b7 c0             	movzwl %ax,%eax
  101208:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10120b:	eb 77                	jmp    101284 <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  10120d:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101214:	83 c0 50             	add    $0x50,%eax
  101217:	0f b7 c0             	movzwl %ax,%eax
  10121a:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101220:	0f b7 1d 44 c4 11 00 	movzwl 0x11c444,%ebx
  101227:	0f b7 0d 44 c4 11 00 	movzwl 0x11c444,%ecx
  10122e:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101233:	89 c8                	mov    %ecx,%eax
  101235:	f7 e2                	mul    %edx
  101237:	c1 ea 06             	shr    $0x6,%edx
  10123a:	89 d0                	mov    %edx,%eax
  10123c:	c1 e0 02             	shl    $0x2,%eax
  10123f:	01 d0                	add    %edx,%eax
  101241:	c1 e0 04             	shl    $0x4,%eax
  101244:	29 c1                	sub    %eax,%ecx
  101246:	89 c8                	mov    %ecx,%eax
  101248:	0f b7 c0             	movzwl %ax,%eax
  10124b:	29 c3                	sub    %eax,%ebx
  10124d:	89 d8                	mov    %ebx,%eax
  10124f:	0f b7 c0             	movzwl %ax,%eax
  101252:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
        break;
  101258:	eb 2b                	jmp    101285 <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10125a:	8b 0d 40 c4 11 00    	mov    0x11c440,%ecx
  101260:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101267:	8d 50 01             	lea    0x1(%eax),%edx
  10126a:	0f b7 d2             	movzwl %dx,%edx
  10126d:	66 89 15 44 c4 11 00 	mov    %dx,0x11c444
  101274:	01 c0                	add    %eax,%eax
  101276:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101279:	8b 45 08             	mov    0x8(%ebp),%eax
  10127c:	0f b7 c0             	movzwl %ax,%eax
  10127f:	66 89 02             	mov    %ax,(%edx)
        break;
  101282:	eb 01                	jmp    101285 <cga_putc+0x100>
        break;
  101284:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101285:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  10128c:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101291:	76 5d                	jbe    1012f0 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101293:	a1 40 c4 11 00       	mov    0x11c440,%eax
  101298:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10129e:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012a3:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1012aa:	00 
  1012ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1012af:	89 04 24             	mov    %eax,(%esp)
  1012b2:	e8 5f 46 00 00       	call   105916 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012b7:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1012be:	eb 14                	jmp    1012d4 <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  1012c0:	a1 40 c4 11 00       	mov    0x11c440,%eax
  1012c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1012c8:	01 d2                	add    %edx,%edx
  1012ca:	01 d0                	add    %edx,%eax
  1012cc:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1012d1:	ff 45 f4             	incl   -0xc(%ebp)
  1012d4:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1012db:	7e e3                	jle    1012c0 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  1012dd:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  1012e4:	83 e8 50             	sub    $0x50,%eax
  1012e7:	0f b7 c0             	movzwl %ax,%eax
  1012ea:	66 a3 44 c4 11 00    	mov    %ax,0x11c444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1012f0:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  1012f7:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012fb:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1012ff:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101303:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101307:	ee                   	out    %al,(%dx)
}
  101308:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  101309:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101310:	c1 e8 08             	shr    $0x8,%eax
  101313:	0f b7 c0             	movzwl %ax,%eax
  101316:	0f b6 c0             	movzbl %al,%eax
  101319:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  101320:	42                   	inc    %edx
  101321:	0f b7 d2             	movzwl %dx,%edx
  101324:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101328:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10132b:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10132f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101333:	ee                   	out    %al,(%dx)
}
  101334:	90                   	nop
    outb(addr_6845, 15);
  101335:	0f b7 05 46 c4 11 00 	movzwl 0x11c446,%eax
  10133c:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101340:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101344:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101348:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10134c:	ee                   	out    %al,(%dx)
}
  10134d:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  10134e:	0f b7 05 44 c4 11 00 	movzwl 0x11c444,%eax
  101355:	0f b6 c0             	movzbl %al,%eax
  101358:	0f b7 15 46 c4 11 00 	movzwl 0x11c446,%edx
  10135f:	42                   	inc    %edx
  101360:	0f b7 d2             	movzwl %dx,%edx
  101363:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101367:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10136a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10136e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101372:	ee                   	out    %al,(%dx)
}
  101373:	90                   	nop
}
  101374:	90                   	nop
  101375:	83 c4 34             	add    $0x34,%esp
  101378:	5b                   	pop    %ebx
  101379:	5d                   	pop    %ebp
  10137a:	c3                   	ret    

0010137b <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10137b:	f3 0f 1e fb          	endbr32 
  10137f:	55                   	push   %ebp
  101380:	89 e5                	mov    %esp,%ebp
  101382:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101385:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10138c:	eb 08                	jmp    101396 <serial_putc_sub+0x1b>
        delay();
  10138e:	e8 08 fb ff ff       	call   100e9b <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101393:	ff 45 fc             	incl   -0x4(%ebp)
  101396:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10139c:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013a0:	89 c2                	mov    %eax,%edx
  1013a2:	ec                   	in     (%dx),%al
  1013a3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013a6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1013aa:	0f b6 c0             	movzbl %al,%eax
  1013ad:	83 e0 20             	and    $0x20,%eax
  1013b0:	85 c0                	test   %eax,%eax
  1013b2:	75 09                	jne    1013bd <serial_putc_sub+0x42>
  1013b4:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1013bb:	7e d1                	jle    10138e <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  1013bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1013c0:	0f b6 c0             	movzbl %al,%eax
  1013c3:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1013c9:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1013cc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1013d0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1013d4:	ee                   	out    %al,(%dx)
}
  1013d5:	90                   	nop
}
  1013d6:	90                   	nop
  1013d7:	c9                   	leave  
  1013d8:	c3                   	ret    

001013d9 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1013d9:	f3 0f 1e fb          	endbr32 
  1013dd:	55                   	push   %ebp
  1013de:	89 e5                	mov    %esp,%ebp
  1013e0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1013e3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1013e7:	74 0d                	je     1013f6 <serial_putc+0x1d>
        serial_putc_sub(c);
  1013e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1013ec:	89 04 24             	mov    %eax,(%esp)
  1013ef:	e8 87 ff ff ff       	call   10137b <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1013f4:	eb 24                	jmp    10141a <serial_putc+0x41>
        serial_putc_sub('\b');
  1013f6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013fd:	e8 79 ff ff ff       	call   10137b <serial_putc_sub>
        serial_putc_sub(' ');
  101402:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101409:	e8 6d ff ff ff       	call   10137b <serial_putc_sub>
        serial_putc_sub('\b');
  10140e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101415:	e8 61 ff ff ff       	call   10137b <serial_putc_sub>
}
  10141a:	90                   	nop
  10141b:	c9                   	leave  
  10141c:	c3                   	ret    

0010141d <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10141d:	f3 0f 1e fb          	endbr32 
  101421:	55                   	push   %ebp
  101422:	89 e5                	mov    %esp,%ebp
  101424:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101427:	eb 33                	jmp    10145c <cons_intr+0x3f>
        if (c != 0) {
  101429:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10142d:	74 2d                	je     10145c <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  10142f:	a1 64 c6 11 00       	mov    0x11c664,%eax
  101434:	8d 50 01             	lea    0x1(%eax),%edx
  101437:	89 15 64 c6 11 00    	mov    %edx,0x11c664
  10143d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101440:	88 90 60 c4 11 00    	mov    %dl,0x11c460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101446:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10144b:	3d 00 02 00 00       	cmp    $0x200,%eax
  101450:	75 0a                	jne    10145c <cons_intr+0x3f>
                cons.wpos = 0;
  101452:	c7 05 64 c6 11 00 00 	movl   $0x0,0x11c664
  101459:	00 00 00 
    while ((c = (*proc)()) != -1) {
  10145c:	8b 45 08             	mov    0x8(%ebp),%eax
  10145f:	ff d0                	call   *%eax
  101461:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101464:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101468:	75 bf                	jne    101429 <cons_intr+0xc>
            }
        }
    }
}
  10146a:	90                   	nop
  10146b:	90                   	nop
  10146c:	c9                   	leave  
  10146d:	c3                   	ret    

0010146e <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  10146e:	f3 0f 1e fb          	endbr32 
  101472:	55                   	push   %ebp
  101473:	89 e5                	mov    %esp,%ebp
  101475:	83 ec 10             	sub    $0x10,%esp
  101478:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10147e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101482:	89 c2                	mov    %eax,%edx
  101484:	ec                   	in     (%dx),%al
  101485:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101488:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10148c:	0f b6 c0             	movzbl %al,%eax
  10148f:	83 e0 01             	and    $0x1,%eax
  101492:	85 c0                	test   %eax,%eax
  101494:	75 07                	jne    10149d <serial_proc_data+0x2f>
        return -1;
  101496:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10149b:	eb 2a                	jmp    1014c7 <serial_proc_data+0x59>
  10149d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014a3:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1014a7:	89 c2                	mov    %eax,%edx
  1014a9:	ec                   	in     (%dx),%al
  1014aa:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1014ad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1014b1:	0f b6 c0             	movzbl %al,%eax
  1014b4:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1014b7:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1014bb:	75 07                	jne    1014c4 <serial_proc_data+0x56>
        c = '\b';
  1014bd:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1014c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1014c7:	c9                   	leave  
  1014c8:	c3                   	ret    

001014c9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1014c9:	f3 0f 1e fb          	endbr32 
  1014cd:	55                   	push   %ebp
  1014ce:	89 e5                	mov    %esp,%ebp
  1014d0:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1014d3:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1014d8:	85 c0                	test   %eax,%eax
  1014da:	74 0c                	je     1014e8 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  1014dc:	c7 04 24 6e 14 10 00 	movl   $0x10146e,(%esp)
  1014e3:	e8 35 ff ff ff       	call   10141d <cons_intr>
    }
}
  1014e8:	90                   	nop
  1014e9:	c9                   	leave  
  1014ea:	c3                   	ret    

001014eb <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1014eb:	f3 0f 1e fb          	endbr32 
  1014ef:	55                   	push   %ebp
  1014f0:	89 e5                	mov    %esp,%ebp
  1014f2:	83 ec 38             	sub    $0x38,%esp
  1014f5:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014fe:	89 c2                	mov    %eax,%edx
  101500:	ec                   	in     (%dx),%al
  101501:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101504:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101508:	0f b6 c0             	movzbl %al,%eax
  10150b:	83 e0 01             	and    $0x1,%eax
  10150e:	85 c0                	test   %eax,%eax
  101510:	75 0a                	jne    10151c <kbd_proc_data+0x31>
        return -1;
  101512:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101517:	e9 56 01 00 00       	jmp    101672 <kbd_proc_data+0x187>
  10151c:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101525:	89 c2                	mov    %eax,%edx
  101527:	ec                   	in     (%dx),%al
  101528:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10152b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10152f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101532:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101536:	75 17                	jne    10154f <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  101538:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10153d:	83 c8 40             	or     $0x40,%eax
  101540:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101545:	b8 00 00 00 00       	mov    $0x0,%eax
  10154a:	e9 23 01 00 00       	jmp    101672 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10154f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101553:	84 c0                	test   %al,%al
  101555:	79 45                	jns    10159c <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101557:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10155c:	83 e0 40             	and    $0x40,%eax
  10155f:	85 c0                	test   %eax,%eax
  101561:	75 08                	jne    10156b <kbd_proc_data+0x80>
  101563:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101567:	24 7f                	and    $0x7f,%al
  101569:	eb 04                	jmp    10156f <kbd_proc_data+0x84>
  10156b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10156f:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101572:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101576:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  10157d:	0c 40                	or     $0x40,%al
  10157f:	0f b6 c0             	movzbl %al,%eax
  101582:	f7 d0                	not    %eax
  101584:	89 c2                	mov    %eax,%edx
  101586:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10158b:	21 d0                	and    %edx,%eax
  10158d:	a3 68 c6 11 00       	mov    %eax,0x11c668
        return 0;
  101592:	b8 00 00 00 00       	mov    $0x0,%eax
  101597:	e9 d6 00 00 00       	jmp    101672 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  10159c:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015a1:	83 e0 40             	and    $0x40,%eax
  1015a4:	85 c0                	test   %eax,%eax
  1015a6:	74 11                	je     1015b9 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1015a8:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1015ac:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015b1:	83 e0 bf             	and    $0xffffffbf,%eax
  1015b4:	a3 68 c6 11 00       	mov    %eax,0x11c668
    }

    shift |= shiftcode[data];
  1015b9:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015bd:	0f b6 80 40 90 11 00 	movzbl 0x119040(%eax),%eax
  1015c4:	0f b6 d0             	movzbl %al,%edx
  1015c7:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015cc:	09 d0                	or     %edx,%eax
  1015ce:	a3 68 c6 11 00       	mov    %eax,0x11c668
    shift ^= togglecode[data];
  1015d3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015d7:	0f b6 80 40 91 11 00 	movzbl 0x119140(%eax),%eax
  1015de:	0f b6 d0             	movzbl %al,%edx
  1015e1:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015e6:	31 d0                	xor    %edx,%eax
  1015e8:	a3 68 c6 11 00       	mov    %eax,0x11c668

    c = charcode[shift & (CTL | SHIFT)][data];
  1015ed:	a1 68 c6 11 00       	mov    0x11c668,%eax
  1015f2:	83 e0 03             	and    $0x3,%eax
  1015f5:	8b 14 85 40 95 11 00 	mov    0x119540(,%eax,4),%edx
  1015fc:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101600:	01 d0                	add    %edx,%eax
  101602:	0f b6 00             	movzbl (%eax),%eax
  101605:	0f b6 c0             	movzbl %al,%eax
  101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10160b:	a1 68 c6 11 00       	mov    0x11c668,%eax
  101610:	83 e0 08             	and    $0x8,%eax
  101613:	85 c0                	test   %eax,%eax
  101615:	74 22                	je     101639 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101617:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10161b:	7e 0c                	jle    101629 <kbd_proc_data+0x13e>
  10161d:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101621:	7f 06                	jg     101629 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101623:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101627:	eb 10                	jmp    101639 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101629:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10162d:	7e 0a                	jle    101639 <kbd_proc_data+0x14e>
  10162f:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101633:	7f 04                	jg     101639 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101635:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101639:	a1 68 c6 11 00       	mov    0x11c668,%eax
  10163e:	f7 d0                	not    %eax
  101640:	83 e0 06             	and    $0x6,%eax
  101643:	85 c0                	test   %eax,%eax
  101645:	75 28                	jne    10166f <kbd_proc_data+0x184>
  101647:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  10164e:	75 1f                	jne    10166f <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101650:	c7 04 24 2d 64 10 00 	movl   $0x10642d,(%esp)
  101657:	e8 5e ec ff ff       	call   1002ba <cprintf>
  10165c:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101662:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101666:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10166a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10166d:	ee                   	out    %al,(%dx)
}
  10166e:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10166f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101672:	c9                   	leave  
  101673:	c3                   	ret    

00101674 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  101674:	f3 0f 1e fb          	endbr32 
  101678:	55                   	push   %ebp
  101679:	89 e5                	mov    %esp,%ebp
  10167b:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  10167e:	c7 04 24 eb 14 10 00 	movl   $0x1014eb,(%esp)
  101685:	e8 93 fd ff ff       	call   10141d <cons_intr>
}
  10168a:	90                   	nop
  10168b:	c9                   	leave  
  10168c:	c3                   	ret    

0010168d <kbd_init>:

static void
kbd_init(void) {
  10168d:	f3 0f 1e fb          	endbr32 
  101691:	55                   	push   %ebp
  101692:	89 e5                	mov    %esp,%ebp
  101694:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101697:	e8 d8 ff ff ff       	call   101674 <kbd_intr>
    pic_enable(IRQ_KBD);
  10169c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1016a3:	e8 47 01 00 00       	call   1017ef <pic_enable>
}
  1016a8:	90                   	nop
  1016a9:	c9                   	leave  
  1016aa:	c3                   	ret    

001016ab <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1016ab:	f3 0f 1e fb          	endbr32 
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1016b5:	e8 2e f8 ff ff       	call   100ee8 <cga_init>
    serial_init();
  1016ba:	e8 13 f9 ff ff       	call   100fd2 <serial_init>
    kbd_init();
  1016bf:	e8 c9 ff ff ff       	call   10168d <kbd_init>
    if (!serial_exists) {
  1016c4:	a1 48 c4 11 00       	mov    0x11c448,%eax
  1016c9:	85 c0                	test   %eax,%eax
  1016cb:	75 0c                	jne    1016d9 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  1016cd:	c7 04 24 39 64 10 00 	movl   $0x106439,(%esp)
  1016d4:	e8 e1 eb ff ff       	call   1002ba <cprintf>
    }
}
  1016d9:	90                   	nop
  1016da:	c9                   	leave  
  1016db:	c3                   	ret    

001016dc <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1016dc:	f3 0f 1e fb          	endbr32 
  1016e0:	55                   	push   %ebp
  1016e1:	89 e5                	mov    %esp,%ebp
  1016e3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  1016e6:	e8 72 f7 ff ff       	call   100e5d <__intr_save>
  1016eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  1016ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1016f1:	89 04 24             	mov    %eax,(%esp)
  1016f4:	e8 48 fa ff ff       	call   101141 <lpt_putc>
        cga_putc(c);
  1016f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1016fc:	89 04 24             	mov    %eax,(%esp)
  1016ff:	e8 81 fa ff ff       	call   101185 <cga_putc>
        serial_putc(c);
  101704:	8b 45 08             	mov    0x8(%ebp),%eax
  101707:	89 04 24             	mov    %eax,(%esp)
  10170a:	e8 ca fc ff ff       	call   1013d9 <serial_putc>
    }
    local_intr_restore(intr_flag);
  10170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101712:	89 04 24             	mov    %eax,(%esp)
  101715:	e8 6d f7 ff ff       	call   100e87 <__intr_restore>
}
  10171a:	90                   	nop
  10171b:	c9                   	leave  
  10171c:	c3                   	ret    

0010171d <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10171d:	f3 0f 1e fb          	endbr32 
  101721:	55                   	push   %ebp
  101722:	89 e5                	mov    %esp,%ebp
  101724:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101727:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  10172e:	e8 2a f7 ff ff       	call   100e5d <__intr_save>
  101733:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101736:	e8 8e fd ff ff       	call   1014c9 <serial_intr>
        kbd_intr();
  10173b:	e8 34 ff ff ff       	call   101674 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101740:	8b 15 60 c6 11 00    	mov    0x11c660,%edx
  101746:	a1 64 c6 11 00       	mov    0x11c664,%eax
  10174b:	39 c2                	cmp    %eax,%edx
  10174d:	74 31                	je     101780 <cons_getc+0x63>
            c = cons.buf[cons.rpos ++];
  10174f:	a1 60 c6 11 00       	mov    0x11c660,%eax
  101754:	8d 50 01             	lea    0x1(%eax),%edx
  101757:	89 15 60 c6 11 00    	mov    %edx,0x11c660
  10175d:	0f b6 80 60 c4 11 00 	movzbl 0x11c460(%eax),%eax
  101764:	0f b6 c0             	movzbl %al,%eax
  101767:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  10176a:	a1 60 c6 11 00       	mov    0x11c660,%eax
  10176f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101774:	75 0a                	jne    101780 <cons_getc+0x63>
                cons.rpos = 0;
  101776:	c7 05 60 c6 11 00 00 	movl   $0x0,0x11c660
  10177d:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101783:	89 04 24             	mov    %eax,(%esp)
  101786:	e8 fc f6 ff ff       	call   100e87 <__intr_restore>
    return c;
  10178b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10178e:	c9                   	leave  
  10178f:	c3                   	ret    

00101790 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101790:	f3 0f 1e fb          	endbr32 
  101794:	55                   	push   %ebp
  101795:	89 e5                	mov    %esp,%ebp
  101797:	83 ec 14             	sub    $0x14,%esp
  10179a:	8b 45 08             	mov    0x8(%ebp),%eax
  10179d:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1017a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017a4:	66 a3 50 95 11 00    	mov    %ax,0x119550
    if (did_init) {
  1017aa:	a1 6c c6 11 00       	mov    0x11c66c,%eax
  1017af:	85 c0                	test   %eax,%eax
  1017b1:	74 39                	je     1017ec <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  1017b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1017b6:	0f b6 c0             	movzbl %al,%eax
  1017b9:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1017bf:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017c2:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017c6:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1017ca:	ee                   	out    %al,(%dx)
}
  1017cb:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  1017cc:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1017d0:	c1 e8 08             	shr    $0x8,%eax
  1017d3:	0f b7 c0             	movzwl %ax,%eax
  1017d6:	0f b6 c0             	movzbl %al,%eax
  1017d9:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1017df:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1017e2:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017e6:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017ea:	ee                   	out    %al,(%dx)
}
  1017eb:	90                   	nop
    }
}
  1017ec:	90                   	nop
  1017ed:	c9                   	leave  
  1017ee:	c3                   	ret    

001017ef <pic_enable>:

void
pic_enable(unsigned int irq) {
  1017ef:	f3 0f 1e fb          	endbr32 
  1017f3:	55                   	push   %ebp
  1017f4:	89 e5                	mov    %esp,%ebp
  1017f6:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  1017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1017fc:	ba 01 00 00 00       	mov    $0x1,%edx
  101801:	88 c1                	mov    %al,%cl
  101803:	d3 e2                	shl    %cl,%edx
  101805:	89 d0                	mov    %edx,%eax
  101807:	98                   	cwtl   
  101808:	f7 d0                	not    %eax
  10180a:	0f bf d0             	movswl %ax,%edx
  10180d:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101814:	98                   	cwtl   
  101815:	21 d0                	and    %edx,%eax
  101817:	98                   	cwtl   
  101818:	0f b7 c0             	movzwl %ax,%eax
  10181b:	89 04 24             	mov    %eax,(%esp)
  10181e:	e8 6d ff ff ff       	call   101790 <pic_setmask>
}
  101823:	90                   	nop
  101824:	c9                   	leave  
  101825:	c3                   	ret    

00101826 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101826:	f3 0f 1e fb          	endbr32 
  10182a:	55                   	push   %ebp
  10182b:	89 e5                	mov    %esp,%ebp
  10182d:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101830:	c7 05 6c c6 11 00 01 	movl   $0x1,0x11c66c
  101837:	00 00 00 
  10183a:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101840:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101844:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101848:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  10184c:	ee                   	out    %al,(%dx)
}
  10184d:	90                   	nop
  10184e:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  101854:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101858:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10185c:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101860:	ee                   	out    %al,(%dx)
}
  101861:	90                   	nop
  101862:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101868:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10186c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101870:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101874:	ee                   	out    %al,(%dx)
}
  101875:	90                   	nop
  101876:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  10187c:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101880:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101884:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101888:	ee                   	out    %al,(%dx)
}
  101889:	90                   	nop
  10188a:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101890:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101894:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101898:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10189c:	ee                   	out    %al,(%dx)
}
  10189d:	90                   	nop
  10189e:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1018a4:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018a8:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1018ac:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1018b0:	ee                   	out    %al,(%dx)
}
  1018b1:	90                   	nop
  1018b2:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1018b8:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018bc:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1018c0:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1018c4:	ee                   	out    %al,(%dx)
}
  1018c5:	90                   	nop
  1018c6:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1018cc:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018d0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1018d4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1018d8:	ee                   	out    %al,(%dx)
}
  1018d9:	90                   	nop
  1018da:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1018e0:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018e4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1018e8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1018ec:	ee                   	out    %al,(%dx)
}
  1018ed:	90                   	nop
  1018ee:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1018f4:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1018f8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1018fc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101900:	ee                   	out    %al,(%dx)
}
  101901:	90                   	nop
  101902:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101908:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10190c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101910:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101914:	ee                   	out    %al,(%dx)
}
  101915:	90                   	nop
  101916:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10191c:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101920:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101924:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101928:	ee                   	out    %al,(%dx)
}
  101929:	90                   	nop
  10192a:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101930:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101934:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101938:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10193c:	ee                   	out    %al,(%dx)
}
  10193d:	90                   	nop
  10193e:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  101944:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101948:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10194c:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101950:	ee                   	out    %al,(%dx)
}
  101951:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101952:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101959:	3d ff ff 00 00       	cmp    $0xffff,%eax
  10195e:	74 0f                	je     10196f <pic_init+0x149>
        pic_setmask(irq_mask);
  101960:	0f b7 05 50 95 11 00 	movzwl 0x119550,%eax
  101967:	89 04 24             	mov    %eax,(%esp)
  10196a:	e8 21 fe ff ff       	call   101790 <pic_setmask>
    }
}
  10196f:	90                   	nop
  101970:	c9                   	leave  
  101971:	c3                   	ret    

00101972 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101972:	f3 0f 1e fb          	endbr32 
  101976:	55                   	push   %ebp
  101977:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  101979:	fb                   	sti    
}
  10197a:	90                   	nop
    sti();
}
  10197b:	90                   	nop
  10197c:	5d                   	pop    %ebp
  10197d:	c3                   	ret    

0010197e <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10197e:	f3 0f 1e fb          	endbr32 
  101982:	55                   	push   %ebp
  101983:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101985:	fa                   	cli    
}
  101986:	90                   	nop
    cli();
}
  101987:	90                   	nop
  101988:	5d                   	pop    %ebp
  101989:	c3                   	ret    

0010198a <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  10198a:	f3 0f 1e fb          	endbr32 
  10198e:	55                   	push   %ebp
  10198f:	89 e5                	mov    %esp,%ebp
  101991:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101994:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10199b:	00 
  10199c:	c7 04 24 60 64 10 00 	movl   $0x106460,(%esp)
  1019a3:	e8 12 e9 ff ff       	call   1002ba <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  1019a8:	90                   	nop
  1019a9:	c9                   	leave  
  1019aa:	c3                   	ret    

001019ab <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1019ab:	f3 0f 1e fb          	endbr32 
  1019af:	55                   	push   %ebp
  1019b0:	89 e5                	mov    %esp,%ebp
  1019b2:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019b5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1019bc:	e9 c4 00 00 00       	jmp    101a85 <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1019c1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c4:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  1019cb:	0f b7 d0             	movzwl %ax,%edx
  1019ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d1:	66 89 14 c5 80 c6 11 	mov    %dx,0x11c680(,%eax,8)
  1019d8:	00 
  1019d9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019dc:	66 c7 04 c5 82 c6 11 	movw   $0x8,0x11c682(,%eax,8)
  1019e3:	00 08 00 
  1019e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019e9:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  1019f0:	00 
  1019f1:	80 e2 e0             	and    $0xe0,%dl
  1019f4:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  1019fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fe:	0f b6 14 c5 84 c6 11 	movzbl 0x11c684(,%eax,8),%edx
  101a05:	00 
  101a06:	80 e2 1f             	and    $0x1f,%dl
  101a09:	88 14 c5 84 c6 11 00 	mov    %dl,0x11c684(,%eax,8)
  101a10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a13:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a1a:	00 
  101a1b:	80 e2 f0             	and    $0xf0,%dl
  101a1e:	80 ca 0e             	or     $0xe,%dl
  101a21:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a2b:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a32:	00 
  101a33:	80 e2 ef             	and    $0xef,%dl
  101a36:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a40:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a47:	00 
  101a48:	80 e2 9f             	and    $0x9f,%dl
  101a4b:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a52:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a55:	0f b6 14 c5 85 c6 11 	movzbl 0x11c685(,%eax,8),%edx
  101a5c:	00 
  101a5d:	80 ca 80             	or     $0x80,%dl
  101a60:	88 14 c5 85 c6 11 00 	mov    %dl,0x11c685(,%eax,8)
  101a67:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a6a:	8b 04 85 e0 95 11 00 	mov    0x1195e0(,%eax,4),%eax
  101a71:	c1 e8 10             	shr    $0x10,%eax
  101a74:	0f b7 d0             	movzwl %ax,%edx
  101a77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a7a:	66 89 14 c5 86 c6 11 	mov    %dx,0x11c686(,%eax,8)
  101a81:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a82:	ff 45 fc             	incl   -0x4(%ebp)
  101a85:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a88:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a8d:	0f 86 2e ff ff ff    	jbe    1019c1 <idt_init+0x16>
  101a93:	c7 45 f8 60 95 11 00 	movl   $0x119560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a9d:	0f 01 18             	lidtl  (%eax)
}
  101aa0:	90                   	nop
    }
    lidt(&idt_pd);
}
  101aa1:	90                   	nop
  101aa2:	c9                   	leave  
  101aa3:	c3                   	ret    

00101aa4 <trapname>:

static const char *
trapname(int trapno) {
  101aa4:	f3 0f 1e fb          	endbr32 
  101aa8:	55                   	push   %ebp
  101aa9:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101aab:	8b 45 08             	mov    0x8(%ebp),%eax
  101aae:	83 f8 13             	cmp    $0x13,%eax
  101ab1:	77 0c                	ja     101abf <trapname+0x1b>
        return excnames[trapno];
  101ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab6:	8b 04 85 c0 67 10 00 	mov    0x1067c0(,%eax,4),%eax
  101abd:	eb 18                	jmp    101ad7 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101abf:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ac3:	7e 0d                	jle    101ad2 <trapname+0x2e>
  101ac5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ac9:	7f 07                	jg     101ad2 <trapname+0x2e>
        return "Hardware Interrupt";
  101acb:	b8 6a 64 10 00       	mov    $0x10646a,%eax
  101ad0:	eb 05                	jmp    101ad7 <trapname+0x33>
    }
    return "(unknown trap)";
  101ad2:	b8 7d 64 10 00       	mov    $0x10647d,%eax
}
  101ad7:	5d                   	pop    %ebp
  101ad8:	c3                   	ret    

00101ad9 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ad9:	f3 0f 1e fb          	endbr32 
  101add:	55                   	push   %ebp
  101ade:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae3:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ae7:	83 f8 08             	cmp    $0x8,%eax
  101aea:	0f 94 c0             	sete   %al
  101aed:	0f b6 c0             	movzbl %al,%eax
}
  101af0:	5d                   	pop    %ebp
  101af1:	c3                   	ret    

00101af2 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101af2:	f3 0f 1e fb          	endbr32 
  101af6:	55                   	push   %ebp
  101af7:	89 e5                	mov    %esp,%ebp
  101af9:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101afc:	8b 45 08             	mov    0x8(%ebp),%eax
  101aff:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b03:	c7 04 24 be 64 10 00 	movl   $0x1064be,(%esp)
  101b0a:	e8 ab e7 ff ff       	call   1002ba <cprintf>
    print_regs(&tf->tf_regs);
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	89 04 24             	mov    %eax,(%esp)
  101b15:	e8 8d 01 00 00       	call   101ca7 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b25:	c7 04 24 cf 64 10 00 	movl   $0x1064cf,(%esp)
  101b2c:	e8 89 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b31:	8b 45 08             	mov    0x8(%ebp),%eax
  101b34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 e2 64 10 00 	movl   $0x1064e2,(%esp)
  101b43:	e8 72 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b53:	c7 04 24 f5 64 10 00 	movl   $0x1064f5,(%esp)
  101b5a:	e8 5b e7 ff ff       	call   1002ba <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6a:	c7 04 24 08 65 10 00 	movl   $0x106508,(%esp)
  101b71:	e8 44 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b76:	8b 45 08             	mov    0x8(%ebp),%eax
  101b79:	8b 40 30             	mov    0x30(%eax),%eax
  101b7c:	89 04 24             	mov    %eax,(%esp)
  101b7f:	e8 20 ff ff ff       	call   101aa4 <trapname>
  101b84:	8b 55 08             	mov    0x8(%ebp),%edx
  101b87:	8b 52 30             	mov    0x30(%edx),%edx
  101b8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b92:	c7 04 24 1b 65 10 00 	movl   $0x10651b,(%esp)
  101b99:	e8 1c e7 ff ff       	call   1002ba <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	8b 40 34             	mov    0x34(%eax),%eax
  101ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba8:	c7 04 24 2d 65 10 00 	movl   $0x10652d,(%esp)
  101baf:	e8 06 e7 ff ff       	call   1002ba <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 40 38             	mov    0x38(%eax),%eax
  101bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbe:	c7 04 24 3c 65 10 00 	movl   $0x10653c,(%esp)
  101bc5:	e8 f0 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bca:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 4b 65 10 00 	movl   $0x10654b,(%esp)
  101bdc:	e8 d9 e6 ff ff       	call   1002ba <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 40             	mov    0x40(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 5e 65 10 00 	movl   $0x10655e,(%esp)
  101bf2:	e8 c3 e6 ff ff       	call   1002ba <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bfe:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101c05:	eb 3d                	jmp    101c44 <print_trapframe+0x152>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101c07:	8b 45 08             	mov    0x8(%ebp),%eax
  101c0a:	8b 50 40             	mov    0x40(%eax),%edx
  101c0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c10:	21 d0                	and    %edx,%eax
  101c12:	85 c0                	test   %eax,%eax
  101c14:	74 28                	je     101c3e <print_trapframe+0x14c>
  101c16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c19:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c20:	85 c0                	test   %eax,%eax
  101c22:	74 1a                	je     101c3e <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c27:	8b 04 85 80 95 11 00 	mov    0x119580(,%eax,4),%eax
  101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c32:	c7 04 24 6d 65 10 00 	movl   $0x10656d,(%esp)
  101c39:	e8 7c e6 ff ff       	call   1002ba <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c3e:	ff 45 f4             	incl   -0xc(%ebp)
  101c41:	d1 65 f0             	shll   -0x10(%ebp)
  101c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c47:	83 f8 17             	cmp    $0x17,%eax
  101c4a:	76 bb                	jbe    101c07 <print_trapframe+0x115>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4f:	8b 40 40             	mov    0x40(%eax),%eax
  101c52:	c1 e8 0c             	shr    $0xc,%eax
  101c55:	83 e0 03             	and    $0x3,%eax
  101c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5c:	c7 04 24 71 65 10 00 	movl   $0x106571,(%esp)
  101c63:	e8 52 e6 ff ff       	call   1002ba <cprintf>

    if (!trap_in_kernel(tf)) {
  101c68:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6b:	89 04 24             	mov    %eax,(%esp)
  101c6e:	e8 66 fe ff ff       	call   101ad9 <trap_in_kernel>
  101c73:	85 c0                	test   %eax,%eax
  101c75:	75 2d                	jne    101ca4 <print_trapframe+0x1b2>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c77:	8b 45 08             	mov    0x8(%ebp),%eax
  101c7a:	8b 40 44             	mov    0x44(%eax),%eax
  101c7d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c81:	c7 04 24 7a 65 10 00 	movl   $0x10657a,(%esp)
  101c88:	e8 2d e6 ff ff       	call   1002ba <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c90:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c98:	c7 04 24 89 65 10 00 	movl   $0x106589,(%esp)
  101c9f:	e8 16 e6 ff ff       	call   1002ba <cprintf>
    }
}
  101ca4:	90                   	nop
  101ca5:	c9                   	leave  
  101ca6:	c3                   	ret    

00101ca7 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ca7:	f3 0f 1e fb          	endbr32 
  101cab:	55                   	push   %ebp
  101cac:	89 e5                	mov    %esp,%ebp
  101cae:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb4:	8b 00                	mov    (%eax),%eax
  101cb6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cba:	c7 04 24 9c 65 10 00 	movl   $0x10659c,(%esp)
  101cc1:	e8 f4 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	8b 40 04             	mov    0x4(%eax),%eax
  101ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd0:	c7 04 24 ab 65 10 00 	movl   $0x1065ab,(%esp)
  101cd7:	e8 de e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdf:	8b 40 08             	mov    0x8(%eax),%eax
  101ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce6:	c7 04 24 ba 65 10 00 	movl   $0x1065ba,(%esp)
  101ced:	e8 c8 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  101cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfc:	c7 04 24 c9 65 10 00 	movl   $0x1065c9,(%esp)
  101d03:	e8 b2 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d08:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0b:	8b 40 10             	mov    0x10(%eax),%eax
  101d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d12:	c7 04 24 d8 65 10 00 	movl   $0x1065d8,(%esp)
  101d19:	e8 9c e5 ff ff       	call   1002ba <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d21:	8b 40 14             	mov    0x14(%eax),%eax
  101d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d28:	c7 04 24 e7 65 10 00 	movl   $0x1065e7,(%esp)
  101d2f:	e8 86 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d34:	8b 45 08             	mov    0x8(%ebp),%eax
  101d37:	8b 40 18             	mov    0x18(%eax),%eax
  101d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3e:	c7 04 24 f6 65 10 00 	movl   $0x1065f6,(%esp)
  101d45:	e8 70 e5 ff ff       	call   1002ba <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4d:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d54:	c7 04 24 05 66 10 00 	movl   $0x106605,(%esp)
  101d5b:	e8 5a e5 ff ff       	call   1002ba <cprintf>
}
  101d60:	90                   	nop
  101d61:	c9                   	leave  
  101d62:	c3                   	ret    

00101d63 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d63:	f3 0f 1e fb          	endbr32 
  101d67:	55                   	push   %ebp
  101d68:	89 e5                	mov    %esp,%ebp
  101d6a:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  101d70:	8b 40 30             	mov    0x30(%eax),%eax
  101d73:	83 f8 79             	cmp    $0x79,%eax
  101d76:	0f 87 e6 00 00 00    	ja     101e62 <trap_dispatch+0xff>
  101d7c:	83 f8 78             	cmp    $0x78,%eax
  101d7f:	0f 83 c1 00 00 00    	jae    101e46 <trap_dispatch+0xe3>
  101d85:	83 f8 2f             	cmp    $0x2f,%eax
  101d88:	0f 87 d4 00 00 00    	ja     101e62 <trap_dispatch+0xff>
  101d8e:	83 f8 2e             	cmp    $0x2e,%eax
  101d91:	0f 83 00 01 00 00    	jae    101e97 <trap_dispatch+0x134>
  101d97:	83 f8 24             	cmp    $0x24,%eax
  101d9a:	74 5e                	je     101dfa <trap_dispatch+0x97>
  101d9c:	83 f8 24             	cmp    $0x24,%eax
  101d9f:	0f 87 bd 00 00 00    	ja     101e62 <trap_dispatch+0xff>
  101da5:	83 f8 20             	cmp    $0x20,%eax
  101da8:	74 0a                	je     101db4 <trap_dispatch+0x51>
  101daa:	83 f8 21             	cmp    $0x21,%eax
  101dad:	74 71                	je     101e20 <trap_dispatch+0xbd>
  101daf:	e9 ae 00 00 00       	jmp    101e62 <trap_dispatch+0xff>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101db4:	a1 0c cf 11 00       	mov    0x11cf0c,%eax
  101db9:	40                   	inc    %eax
  101dba:	a3 0c cf 11 00       	mov    %eax,0x11cf0c
        if (ticks % TICK_NUM == 0) {
  101dbf:	8b 0d 0c cf 11 00    	mov    0x11cf0c,%ecx
  101dc5:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101dca:	89 c8                	mov    %ecx,%eax
  101dcc:	f7 e2                	mul    %edx
  101dce:	c1 ea 05             	shr    $0x5,%edx
  101dd1:	89 d0                	mov    %edx,%eax
  101dd3:	c1 e0 02             	shl    $0x2,%eax
  101dd6:	01 d0                	add    %edx,%eax
  101dd8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101ddf:	01 d0                	add    %edx,%eax
  101de1:	c1 e0 02             	shl    $0x2,%eax
  101de4:	29 c1                	sub    %eax,%ecx
  101de6:	89 ca                	mov    %ecx,%edx
  101de8:	85 d2                	test   %edx,%edx
  101dea:	0f 85 aa 00 00 00    	jne    101e9a <trap_dispatch+0x137>
            print_ticks();
  101df0:	e8 95 fb ff ff       	call   10198a <print_ticks>
        }
        break;
  101df5:	e9 a0 00 00 00       	jmp    101e9a <trap_dispatch+0x137>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101dfa:	e8 1e f9 ff ff       	call   10171d <cons_getc>
  101dff:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e02:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e06:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e0a:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e12:	c7 04 24 14 66 10 00 	movl   $0x106614,(%esp)
  101e19:	e8 9c e4 ff ff       	call   1002ba <cprintf>
        break;
  101e1e:	eb 7b                	jmp    101e9b <trap_dispatch+0x138>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e20:	e8 f8 f8 ff ff       	call   10171d <cons_getc>
  101e25:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e28:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e2c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e30:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e38:	c7 04 24 26 66 10 00 	movl   $0x106626,(%esp)
  101e3f:	e8 76 e4 ff ff       	call   1002ba <cprintf>
        break;
  101e44:	eb 55                	jmp    101e9b <trap_dispatch+0x138>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e46:	c7 44 24 08 35 66 10 	movl   $0x106635,0x8(%esp)
  101e4d:	00 
  101e4e:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
  101e55:	00 
  101e56:	c7 04 24 45 66 10 00 	movl   $0x106645,(%esp)
  101e5d:	e8 c4 e5 ff ff       	call   100426 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e62:	8b 45 08             	mov    0x8(%ebp),%eax
  101e65:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e69:	83 e0 03             	and    $0x3,%eax
  101e6c:	85 c0                	test   %eax,%eax
  101e6e:	75 2b                	jne    101e9b <trap_dispatch+0x138>
            print_trapframe(tf);
  101e70:	8b 45 08             	mov    0x8(%ebp),%eax
  101e73:	89 04 24             	mov    %eax,(%esp)
  101e76:	e8 77 fc ff ff       	call   101af2 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e7b:	c7 44 24 08 56 66 10 	movl   $0x106656,0x8(%esp)
  101e82:	00 
  101e83:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
  101e8a:	00 
  101e8b:	c7 04 24 45 66 10 00 	movl   $0x106645,(%esp)
  101e92:	e8 8f e5 ff ff       	call   100426 <__panic>
        break;
  101e97:	90                   	nop
  101e98:	eb 01                	jmp    101e9b <trap_dispatch+0x138>
        break;
  101e9a:	90                   	nop
        }
    }
}
  101e9b:	90                   	nop
  101e9c:	c9                   	leave  
  101e9d:	c3                   	ret    

00101e9e <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e9e:	f3 0f 1e fb          	endbr32 
  101ea2:	55                   	push   %ebp
  101ea3:	89 e5                	mov    %esp,%ebp
  101ea5:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  101eab:	89 04 24             	mov    %eax,(%esp)
  101eae:	e8 b0 fe ff ff       	call   101d63 <trap_dispatch>
}
  101eb3:	90                   	nop
  101eb4:	c9                   	leave  
  101eb5:	c3                   	ret    

00101eb6 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $0
  101eb8:	6a 00                	push   $0x0
  jmp __alltraps
  101eba:	e9 67 0a 00 00       	jmp    102926 <__alltraps>

00101ebf <vector1>:
.globl vector1
vector1:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $1
  101ec1:	6a 01                	push   $0x1
  jmp __alltraps
  101ec3:	e9 5e 0a 00 00       	jmp    102926 <__alltraps>

00101ec8 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $2
  101eca:	6a 02                	push   $0x2
  jmp __alltraps
  101ecc:	e9 55 0a 00 00       	jmp    102926 <__alltraps>

00101ed1 <vector3>:
.globl vector3
vector3:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $3
  101ed3:	6a 03                	push   $0x3
  jmp __alltraps
  101ed5:	e9 4c 0a 00 00       	jmp    102926 <__alltraps>

00101eda <vector4>:
.globl vector4
vector4:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $4
  101edc:	6a 04                	push   $0x4
  jmp __alltraps
  101ede:	e9 43 0a 00 00       	jmp    102926 <__alltraps>

00101ee3 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $5
  101ee5:	6a 05                	push   $0x5
  jmp __alltraps
  101ee7:	e9 3a 0a 00 00       	jmp    102926 <__alltraps>

00101eec <vector6>:
.globl vector6
vector6:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $6
  101eee:	6a 06                	push   $0x6
  jmp __alltraps
  101ef0:	e9 31 0a 00 00       	jmp    102926 <__alltraps>

00101ef5 <vector7>:
.globl vector7
vector7:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $7
  101ef7:	6a 07                	push   $0x7
  jmp __alltraps
  101ef9:	e9 28 0a 00 00       	jmp    102926 <__alltraps>

00101efe <vector8>:
.globl vector8
vector8:
  pushl $8
  101efe:	6a 08                	push   $0x8
  jmp __alltraps
  101f00:	e9 21 0a 00 00       	jmp    102926 <__alltraps>

00101f05 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f05:	6a 09                	push   $0x9
  jmp __alltraps
  101f07:	e9 1a 0a 00 00       	jmp    102926 <__alltraps>

00101f0c <vector10>:
.globl vector10
vector10:
  pushl $10
  101f0c:	6a 0a                	push   $0xa
  jmp __alltraps
  101f0e:	e9 13 0a 00 00       	jmp    102926 <__alltraps>

00101f13 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f13:	6a 0b                	push   $0xb
  jmp __alltraps
  101f15:	e9 0c 0a 00 00       	jmp    102926 <__alltraps>

00101f1a <vector12>:
.globl vector12
vector12:
  pushl $12
  101f1a:	6a 0c                	push   $0xc
  jmp __alltraps
  101f1c:	e9 05 0a 00 00       	jmp    102926 <__alltraps>

00101f21 <vector13>:
.globl vector13
vector13:
  pushl $13
  101f21:	6a 0d                	push   $0xd
  jmp __alltraps
  101f23:	e9 fe 09 00 00       	jmp    102926 <__alltraps>

00101f28 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f28:	6a 0e                	push   $0xe
  jmp __alltraps
  101f2a:	e9 f7 09 00 00       	jmp    102926 <__alltraps>

00101f2f <vector15>:
.globl vector15
vector15:
  pushl $0
  101f2f:	6a 00                	push   $0x0
  pushl $15
  101f31:	6a 0f                	push   $0xf
  jmp __alltraps
  101f33:	e9 ee 09 00 00       	jmp    102926 <__alltraps>

00101f38 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f38:	6a 00                	push   $0x0
  pushl $16
  101f3a:	6a 10                	push   $0x10
  jmp __alltraps
  101f3c:	e9 e5 09 00 00       	jmp    102926 <__alltraps>

00101f41 <vector17>:
.globl vector17
vector17:
  pushl $17
  101f41:	6a 11                	push   $0x11
  jmp __alltraps
  101f43:	e9 de 09 00 00       	jmp    102926 <__alltraps>

00101f48 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f48:	6a 00                	push   $0x0
  pushl $18
  101f4a:	6a 12                	push   $0x12
  jmp __alltraps
  101f4c:	e9 d5 09 00 00       	jmp    102926 <__alltraps>

00101f51 <vector19>:
.globl vector19
vector19:
  pushl $0
  101f51:	6a 00                	push   $0x0
  pushl $19
  101f53:	6a 13                	push   $0x13
  jmp __alltraps
  101f55:	e9 cc 09 00 00       	jmp    102926 <__alltraps>

00101f5a <vector20>:
.globl vector20
vector20:
  pushl $0
  101f5a:	6a 00                	push   $0x0
  pushl $20
  101f5c:	6a 14                	push   $0x14
  jmp __alltraps
  101f5e:	e9 c3 09 00 00       	jmp    102926 <__alltraps>

00101f63 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f63:	6a 00                	push   $0x0
  pushl $21
  101f65:	6a 15                	push   $0x15
  jmp __alltraps
  101f67:	e9 ba 09 00 00       	jmp    102926 <__alltraps>

00101f6c <vector22>:
.globl vector22
vector22:
  pushl $0
  101f6c:	6a 00                	push   $0x0
  pushl $22
  101f6e:	6a 16                	push   $0x16
  jmp __alltraps
  101f70:	e9 b1 09 00 00       	jmp    102926 <__alltraps>

00101f75 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $23
  101f77:	6a 17                	push   $0x17
  jmp __alltraps
  101f79:	e9 a8 09 00 00       	jmp    102926 <__alltraps>

00101f7e <vector24>:
.globl vector24
vector24:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $24
  101f80:	6a 18                	push   $0x18
  jmp __alltraps
  101f82:	e9 9f 09 00 00       	jmp    102926 <__alltraps>

00101f87 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $25
  101f89:	6a 19                	push   $0x19
  jmp __alltraps
  101f8b:	e9 96 09 00 00       	jmp    102926 <__alltraps>

00101f90 <vector26>:
.globl vector26
vector26:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $26
  101f92:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f94:	e9 8d 09 00 00       	jmp    102926 <__alltraps>

00101f99 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $27
  101f9b:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f9d:	e9 84 09 00 00       	jmp    102926 <__alltraps>

00101fa2 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $28
  101fa4:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fa6:	e9 7b 09 00 00       	jmp    102926 <__alltraps>

00101fab <vector29>:
.globl vector29
vector29:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $29
  101fad:	6a 1d                	push   $0x1d
  jmp __alltraps
  101faf:	e9 72 09 00 00       	jmp    102926 <__alltraps>

00101fb4 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $30
  101fb6:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fb8:	e9 69 09 00 00       	jmp    102926 <__alltraps>

00101fbd <vector31>:
.globl vector31
vector31:
  pushl $0
  101fbd:	6a 00                	push   $0x0
  pushl $31
  101fbf:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fc1:	e9 60 09 00 00       	jmp    102926 <__alltraps>

00101fc6 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fc6:	6a 00                	push   $0x0
  pushl $32
  101fc8:	6a 20                	push   $0x20
  jmp __alltraps
  101fca:	e9 57 09 00 00       	jmp    102926 <__alltraps>

00101fcf <vector33>:
.globl vector33
vector33:
  pushl $0
  101fcf:	6a 00                	push   $0x0
  pushl $33
  101fd1:	6a 21                	push   $0x21
  jmp __alltraps
  101fd3:	e9 4e 09 00 00       	jmp    102926 <__alltraps>

00101fd8 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fd8:	6a 00                	push   $0x0
  pushl $34
  101fda:	6a 22                	push   $0x22
  jmp __alltraps
  101fdc:	e9 45 09 00 00       	jmp    102926 <__alltraps>

00101fe1 <vector35>:
.globl vector35
vector35:
  pushl $0
  101fe1:	6a 00                	push   $0x0
  pushl $35
  101fe3:	6a 23                	push   $0x23
  jmp __alltraps
  101fe5:	e9 3c 09 00 00       	jmp    102926 <__alltraps>

00101fea <vector36>:
.globl vector36
vector36:
  pushl $0
  101fea:	6a 00                	push   $0x0
  pushl $36
  101fec:	6a 24                	push   $0x24
  jmp __alltraps
  101fee:	e9 33 09 00 00       	jmp    102926 <__alltraps>

00101ff3 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ff3:	6a 00                	push   $0x0
  pushl $37
  101ff5:	6a 25                	push   $0x25
  jmp __alltraps
  101ff7:	e9 2a 09 00 00       	jmp    102926 <__alltraps>

00101ffc <vector38>:
.globl vector38
vector38:
  pushl $0
  101ffc:	6a 00                	push   $0x0
  pushl $38
  101ffe:	6a 26                	push   $0x26
  jmp __alltraps
  102000:	e9 21 09 00 00       	jmp    102926 <__alltraps>

00102005 <vector39>:
.globl vector39
vector39:
  pushl $0
  102005:	6a 00                	push   $0x0
  pushl $39
  102007:	6a 27                	push   $0x27
  jmp __alltraps
  102009:	e9 18 09 00 00       	jmp    102926 <__alltraps>

0010200e <vector40>:
.globl vector40
vector40:
  pushl $0
  10200e:	6a 00                	push   $0x0
  pushl $40
  102010:	6a 28                	push   $0x28
  jmp __alltraps
  102012:	e9 0f 09 00 00       	jmp    102926 <__alltraps>

00102017 <vector41>:
.globl vector41
vector41:
  pushl $0
  102017:	6a 00                	push   $0x0
  pushl $41
  102019:	6a 29                	push   $0x29
  jmp __alltraps
  10201b:	e9 06 09 00 00       	jmp    102926 <__alltraps>

00102020 <vector42>:
.globl vector42
vector42:
  pushl $0
  102020:	6a 00                	push   $0x0
  pushl $42
  102022:	6a 2a                	push   $0x2a
  jmp __alltraps
  102024:	e9 fd 08 00 00       	jmp    102926 <__alltraps>

00102029 <vector43>:
.globl vector43
vector43:
  pushl $0
  102029:	6a 00                	push   $0x0
  pushl $43
  10202b:	6a 2b                	push   $0x2b
  jmp __alltraps
  10202d:	e9 f4 08 00 00       	jmp    102926 <__alltraps>

00102032 <vector44>:
.globl vector44
vector44:
  pushl $0
  102032:	6a 00                	push   $0x0
  pushl $44
  102034:	6a 2c                	push   $0x2c
  jmp __alltraps
  102036:	e9 eb 08 00 00       	jmp    102926 <__alltraps>

0010203b <vector45>:
.globl vector45
vector45:
  pushl $0
  10203b:	6a 00                	push   $0x0
  pushl $45
  10203d:	6a 2d                	push   $0x2d
  jmp __alltraps
  10203f:	e9 e2 08 00 00       	jmp    102926 <__alltraps>

00102044 <vector46>:
.globl vector46
vector46:
  pushl $0
  102044:	6a 00                	push   $0x0
  pushl $46
  102046:	6a 2e                	push   $0x2e
  jmp __alltraps
  102048:	e9 d9 08 00 00       	jmp    102926 <__alltraps>

0010204d <vector47>:
.globl vector47
vector47:
  pushl $0
  10204d:	6a 00                	push   $0x0
  pushl $47
  10204f:	6a 2f                	push   $0x2f
  jmp __alltraps
  102051:	e9 d0 08 00 00       	jmp    102926 <__alltraps>

00102056 <vector48>:
.globl vector48
vector48:
  pushl $0
  102056:	6a 00                	push   $0x0
  pushl $48
  102058:	6a 30                	push   $0x30
  jmp __alltraps
  10205a:	e9 c7 08 00 00       	jmp    102926 <__alltraps>

0010205f <vector49>:
.globl vector49
vector49:
  pushl $0
  10205f:	6a 00                	push   $0x0
  pushl $49
  102061:	6a 31                	push   $0x31
  jmp __alltraps
  102063:	e9 be 08 00 00       	jmp    102926 <__alltraps>

00102068 <vector50>:
.globl vector50
vector50:
  pushl $0
  102068:	6a 00                	push   $0x0
  pushl $50
  10206a:	6a 32                	push   $0x32
  jmp __alltraps
  10206c:	e9 b5 08 00 00       	jmp    102926 <__alltraps>

00102071 <vector51>:
.globl vector51
vector51:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $51
  102073:	6a 33                	push   $0x33
  jmp __alltraps
  102075:	e9 ac 08 00 00       	jmp    102926 <__alltraps>

0010207a <vector52>:
.globl vector52
vector52:
  pushl $0
  10207a:	6a 00                	push   $0x0
  pushl $52
  10207c:	6a 34                	push   $0x34
  jmp __alltraps
  10207e:	e9 a3 08 00 00       	jmp    102926 <__alltraps>

00102083 <vector53>:
.globl vector53
vector53:
  pushl $0
  102083:	6a 00                	push   $0x0
  pushl $53
  102085:	6a 35                	push   $0x35
  jmp __alltraps
  102087:	e9 9a 08 00 00       	jmp    102926 <__alltraps>

0010208c <vector54>:
.globl vector54
vector54:
  pushl $0
  10208c:	6a 00                	push   $0x0
  pushl $54
  10208e:	6a 36                	push   $0x36
  jmp __alltraps
  102090:	e9 91 08 00 00       	jmp    102926 <__alltraps>

00102095 <vector55>:
.globl vector55
vector55:
  pushl $0
  102095:	6a 00                	push   $0x0
  pushl $55
  102097:	6a 37                	push   $0x37
  jmp __alltraps
  102099:	e9 88 08 00 00       	jmp    102926 <__alltraps>

0010209e <vector56>:
.globl vector56
vector56:
  pushl $0
  10209e:	6a 00                	push   $0x0
  pushl $56
  1020a0:	6a 38                	push   $0x38
  jmp __alltraps
  1020a2:	e9 7f 08 00 00       	jmp    102926 <__alltraps>

001020a7 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020a7:	6a 00                	push   $0x0
  pushl $57
  1020a9:	6a 39                	push   $0x39
  jmp __alltraps
  1020ab:	e9 76 08 00 00       	jmp    102926 <__alltraps>

001020b0 <vector58>:
.globl vector58
vector58:
  pushl $0
  1020b0:	6a 00                	push   $0x0
  pushl $58
  1020b2:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020b4:	e9 6d 08 00 00       	jmp    102926 <__alltraps>

001020b9 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020b9:	6a 00                	push   $0x0
  pushl $59
  1020bb:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020bd:	e9 64 08 00 00       	jmp    102926 <__alltraps>

001020c2 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020c2:	6a 00                	push   $0x0
  pushl $60
  1020c4:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020c6:	e9 5b 08 00 00       	jmp    102926 <__alltraps>

001020cb <vector61>:
.globl vector61
vector61:
  pushl $0
  1020cb:	6a 00                	push   $0x0
  pushl $61
  1020cd:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020cf:	e9 52 08 00 00       	jmp    102926 <__alltraps>

001020d4 <vector62>:
.globl vector62
vector62:
  pushl $0
  1020d4:	6a 00                	push   $0x0
  pushl $62
  1020d6:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020d8:	e9 49 08 00 00       	jmp    102926 <__alltraps>

001020dd <vector63>:
.globl vector63
vector63:
  pushl $0
  1020dd:	6a 00                	push   $0x0
  pushl $63
  1020df:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020e1:	e9 40 08 00 00       	jmp    102926 <__alltraps>

001020e6 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020e6:	6a 00                	push   $0x0
  pushl $64
  1020e8:	6a 40                	push   $0x40
  jmp __alltraps
  1020ea:	e9 37 08 00 00       	jmp    102926 <__alltraps>

001020ef <vector65>:
.globl vector65
vector65:
  pushl $0
  1020ef:	6a 00                	push   $0x0
  pushl $65
  1020f1:	6a 41                	push   $0x41
  jmp __alltraps
  1020f3:	e9 2e 08 00 00       	jmp    102926 <__alltraps>

001020f8 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020f8:	6a 00                	push   $0x0
  pushl $66
  1020fa:	6a 42                	push   $0x42
  jmp __alltraps
  1020fc:	e9 25 08 00 00       	jmp    102926 <__alltraps>

00102101 <vector67>:
.globl vector67
vector67:
  pushl $0
  102101:	6a 00                	push   $0x0
  pushl $67
  102103:	6a 43                	push   $0x43
  jmp __alltraps
  102105:	e9 1c 08 00 00       	jmp    102926 <__alltraps>

0010210a <vector68>:
.globl vector68
vector68:
  pushl $0
  10210a:	6a 00                	push   $0x0
  pushl $68
  10210c:	6a 44                	push   $0x44
  jmp __alltraps
  10210e:	e9 13 08 00 00       	jmp    102926 <__alltraps>

00102113 <vector69>:
.globl vector69
vector69:
  pushl $0
  102113:	6a 00                	push   $0x0
  pushl $69
  102115:	6a 45                	push   $0x45
  jmp __alltraps
  102117:	e9 0a 08 00 00       	jmp    102926 <__alltraps>

0010211c <vector70>:
.globl vector70
vector70:
  pushl $0
  10211c:	6a 00                	push   $0x0
  pushl $70
  10211e:	6a 46                	push   $0x46
  jmp __alltraps
  102120:	e9 01 08 00 00       	jmp    102926 <__alltraps>

00102125 <vector71>:
.globl vector71
vector71:
  pushl $0
  102125:	6a 00                	push   $0x0
  pushl $71
  102127:	6a 47                	push   $0x47
  jmp __alltraps
  102129:	e9 f8 07 00 00       	jmp    102926 <__alltraps>

0010212e <vector72>:
.globl vector72
vector72:
  pushl $0
  10212e:	6a 00                	push   $0x0
  pushl $72
  102130:	6a 48                	push   $0x48
  jmp __alltraps
  102132:	e9 ef 07 00 00       	jmp    102926 <__alltraps>

00102137 <vector73>:
.globl vector73
vector73:
  pushl $0
  102137:	6a 00                	push   $0x0
  pushl $73
  102139:	6a 49                	push   $0x49
  jmp __alltraps
  10213b:	e9 e6 07 00 00       	jmp    102926 <__alltraps>

00102140 <vector74>:
.globl vector74
vector74:
  pushl $0
  102140:	6a 00                	push   $0x0
  pushl $74
  102142:	6a 4a                	push   $0x4a
  jmp __alltraps
  102144:	e9 dd 07 00 00       	jmp    102926 <__alltraps>

00102149 <vector75>:
.globl vector75
vector75:
  pushl $0
  102149:	6a 00                	push   $0x0
  pushl $75
  10214b:	6a 4b                	push   $0x4b
  jmp __alltraps
  10214d:	e9 d4 07 00 00       	jmp    102926 <__alltraps>

00102152 <vector76>:
.globl vector76
vector76:
  pushl $0
  102152:	6a 00                	push   $0x0
  pushl $76
  102154:	6a 4c                	push   $0x4c
  jmp __alltraps
  102156:	e9 cb 07 00 00       	jmp    102926 <__alltraps>

0010215b <vector77>:
.globl vector77
vector77:
  pushl $0
  10215b:	6a 00                	push   $0x0
  pushl $77
  10215d:	6a 4d                	push   $0x4d
  jmp __alltraps
  10215f:	e9 c2 07 00 00       	jmp    102926 <__alltraps>

00102164 <vector78>:
.globl vector78
vector78:
  pushl $0
  102164:	6a 00                	push   $0x0
  pushl $78
  102166:	6a 4e                	push   $0x4e
  jmp __alltraps
  102168:	e9 b9 07 00 00       	jmp    102926 <__alltraps>

0010216d <vector79>:
.globl vector79
vector79:
  pushl $0
  10216d:	6a 00                	push   $0x0
  pushl $79
  10216f:	6a 4f                	push   $0x4f
  jmp __alltraps
  102171:	e9 b0 07 00 00       	jmp    102926 <__alltraps>

00102176 <vector80>:
.globl vector80
vector80:
  pushl $0
  102176:	6a 00                	push   $0x0
  pushl $80
  102178:	6a 50                	push   $0x50
  jmp __alltraps
  10217a:	e9 a7 07 00 00       	jmp    102926 <__alltraps>

0010217f <vector81>:
.globl vector81
vector81:
  pushl $0
  10217f:	6a 00                	push   $0x0
  pushl $81
  102181:	6a 51                	push   $0x51
  jmp __alltraps
  102183:	e9 9e 07 00 00       	jmp    102926 <__alltraps>

00102188 <vector82>:
.globl vector82
vector82:
  pushl $0
  102188:	6a 00                	push   $0x0
  pushl $82
  10218a:	6a 52                	push   $0x52
  jmp __alltraps
  10218c:	e9 95 07 00 00       	jmp    102926 <__alltraps>

00102191 <vector83>:
.globl vector83
vector83:
  pushl $0
  102191:	6a 00                	push   $0x0
  pushl $83
  102193:	6a 53                	push   $0x53
  jmp __alltraps
  102195:	e9 8c 07 00 00       	jmp    102926 <__alltraps>

0010219a <vector84>:
.globl vector84
vector84:
  pushl $0
  10219a:	6a 00                	push   $0x0
  pushl $84
  10219c:	6a 54                	push   $0x54
  jmp __alltraps
  10219e:	e9 83 07 00 00       	jmp    102926 <__alltraps>

001021a3 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021a3:	6a 00                	push   $0x0
  pushl $85
  1021a5:	6a 55                	push   $0x55
  jmp __alltraps
  1021a7:	e9 7a 07 00 00       	jmp    102926 <__alltraps>

001021ac <vector86>:
.globl vector86
vector86:
  pushl $0
  1021ac:	6a 00                	push   $0x0
  pushl $86
  1021ae:	6a 56                	push   $0x56
  jmp __alltraps
  1021b0:	e9 71 07 00 00       	jmp    102926 <__alltraps>

001021b5 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021b5:	6a 00                	push   $0x0
  pushl $87
  1021b7:	6a 57                	push   $0x57
  jmp __alltraps
  1021b9:	e9 68 07 00 00       	jmp    102926 <__alltraps>

001021be <vector88>:
.globl vector88
vector88:
  pushl $0
  1021be:	6a 00                	push   $0x0
  pushl $88
  1021c0:	6a 58                	push   $0x58
  jmp __alltraps
  1021c2:	e9 5f 07 00 00       	jmp    102926 <__alltraps>

001021c7 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021c7:	6a 00                	push   $0x0
  pushl $89
  1021c9:	6a 59                	push   $0x59
  jmp __alltraps
  1021cb:	e9 56 07 00 00       	jmp    102926 <__alltraps>

001021d0 <vector90>:
.globl vector90
vector90:
  pushl $0
  1021d0:	6a 00                	push   $0x0
  pushl $90
  1021d2:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021d4:	e9 4d 07 00 00       	jmp    102926 <__alltraps>

001021d9 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021d9:	6a 00                	push   $0x0
  pushl $91
  1021db:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021dd:	e9 44 07 00 00       	jmp    102926 <__alltraps>

001021e2 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021e2:	6a 00                	push   $0x0
  pushl $92
  1021e4:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021e6:	e9 3b 07 00 00       	jmp    102926 <__alltraps>

001021eb <vector93>:
.globl vector93
vector93:
  pushl $0
  1021eb:	6a 00                	push   $0x0
  pushl $93
  1021ed:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021ef:	e9 32 07 00 00       	jmp    102926 <__alltraps>

001021f4 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021f4:	6a 00                	push   $0x0
  pushl $94
  1021f6:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021f8:	e9 29 07 00 00       	jmp    102926 <__alltraps>

001021fd <vector95>:
.globl vector95
vector95:
  pushl $0
  1021fd:	6a 00                	push   $0x0
  pushl $95
  1021ff:	6a 5f                	push   $0x5f
  jmp __alltraps
  102201:	e9 20 07 00 00       	jmp    102926 <__alltraps>

00102206 <vector96>:
.globl vector96
vector96:
  pushl $0
  102206:	6a 00                	push   $0x0
  pushl $96
  102208:	6a 60                	push   $0x60
  jmp __alltraps
  10220a:	e9 17 07 00 00       	jmp    102926 <__alltraps>

0010220f <vector97>:
.globl vector97
vector97:
  pushl $0
  10220f:	6a 00                	push   $0x0
  pushl $97
  102211:	6a 61                	push   $0x61
  jmp __alltraps
  102213:	e9 0e 07 00 00       	jmp    102926 <__alltraps>

00102218 <vector98>:
.globl vector98
vector98:
  pushl $0
  102218:	6a 00                	push   $0x0
  pushl $98
  10221a:	6a 62                	push   $0x62
  jmp __alltraps
  10221c:	e9 05 07 00 00       	jmp    102926 <__alltraps>

00102221 <vector99>:
.globl vector99
vector99:
  pushl $0
  102221:	6a 00                	push   $0x0
  pushl $99
  102223:	6a 63                	push   $0x63
  jmp __alltraps
  102225:	e9 fc 06 00 00       	jmp    102926 <__alltraps>

0010222a <vector100>:
.globl vector100
vector100:
  pushl $0
  10222a:	6a 00                	push   $0x0
  pushl $100
  10222c:	6a 64                	push   $0x64
  jmp __alltraps
  10222e:	e9 f3 06 00 00       	jmp    102926 <__alltraps>

00102233 <vector101>:
.globl vector101
vector101:
  pushl $0
  102233:	6a 00                	push   $0x0
  pushl $101
  102235:	6a 65                	push   $0x65
  jmp __alltraps
  102237:	e9 ea 06 00 00       	jmp    102926 <__alltraps>

0010223c <vector102>:
.globl vector102
vector102:
  pushl $0
  10223c:	6a 00                	push   $0x0
  pushl $102
  10223e:	6a 66                	push   $0x66
  jmp __alltraps
  102240:	e9 e1 06 00 00       	jmp    102926 <__alltraps>

00102245 <vector103>:
.globl vector103
vector103:
  pushl $0
  102245:	6a 00                	push   $0x0
  pushl $103
  102247:	6a 67                	push   $0x67
  jmp __alltraps
  102249:	e9 d8 06 00 00       	jmp    102926 <__alltraps>

0010224e <vector104>:
.globl vector104
vector104:
  pushl $0
  10224e:	6a 00                	push   $0x0
  pushl $104
  102250:	6a 68                	push   $0x68
  jmp __alltraps
  102252:	e9 cf 06 00 00       	jmp    102926 <__alltraps>

00102257 <vector105>:
.globl vector105
vector105:
  pushl $0
  102257:	6a 00                	push   $0x0
  pushl $105
  102259:	6a 69                	push   $0x69
  jmp __alltraps
  10225b:	e9 c6 06 00 00       	jmp    102926 <__alltraps>

00102260 <vector106>:
.globl vector106
vector106:
  pushl $0
  102260:	6a 00                	push   $0x0
  pushl $106
  102262:	6a 6a                	push   $0x6a
  jmp __alltraps
  102264:	e9 bd 06 00 00       	jmp    102926 <__alltraps>

00102269 <vector107>:
.globl vector107
vector107:
  pushl $0
  102269:	6a 00                	push   $0x0
  pushl $107
  10226b:	6a 6b                	push   $0x6b
  jmp __alltraps
  10226d:	e9 b4 06 00 00       	jmp    102926 <__alltraps>

00102272 <vector108>:
.globl vector108
vector108:
  pushl $0
  102272:	6a 00                	push   $0x0
  pushl $108
  102274:	6a 6c                	push   $0x6c
  jmp __alltraps
  102276:	e9 ab 06 00 00       	jmp    102926 <__alltraps>

0010227b <vector109>:
.globl vector109
vector109:
  pushl $0
  10227b:	6a 00                	push   $0x0
  pushl $109
  10227d:	6a 6d                	push   $0x6d
  jmp __alltraps
  10227f:	e9 a2 06 00 00       	jmp    102926 <__alltraps>

00102284 <vector110>:
.globl vector110
vector110:
  pushl $0
  102284:	6a 00                	push   $0x0
  pushl $110
  102286:	6a 6e                	push   $0x6e
  jmp __alltraps
  102288:	e9 99 06 00 00       	jmp    102926 <__alltraps>

0010228d <vector111>:
.globl vector111
vector111:
  pushl $0
  10228d:	6a 00                	push   $0x0
  pushl $111
  10228f:	6a 6f                	push   $0x6f
  jmp __alltraps
  102291:	e9 90 06 00 00       	jmp    102926 <__alltraps>

00102296 <vector112>:
.globl vector112
vector112:
  pushl $0
  102296:	6a 00                	push   $0x0
  pushl $112
  102298:	6a 70                	push   $0x70
  jmp __alltraps
  10229a:	e9 87 06 00 00       	jmp    102926 <__alltraps>

0010229f <vector113>:
.globl vector113
vector113:
  pushl $0
  10229f:	6a 00                	push   $0x0
  pushl $113
  1022a1:	6a 71                	push   $0x71
  jmp __alltraps
  1022a3:	e9 7e 06 00 00       	jmp    102926 <__alltraps>

001022a8 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022a8:	6a 00                	push   $0x0
  pushl $114
  1022aa:	6a 72                	push   $0x72
  jmp __alltraps
  1022ac:	e9 75 06 00 00       	jmp    102926 <__alltraps>

001022b1 <vector115>:
.globl vector115
vector115:
  pushl $0
  1022b1:	6a 00                	push   $0x0
  pushl $115
  1022b3:	6a 73                	push   $0x73
  jmp __alltraps
  1022b5:	e9 6c 06 00 00       	jmp    102926 <__alltraps>

001022ba <vector116>:
.globl vector116
vector116:
  pushl $0
  1022ba:	6a 00                	push   $0x0
  pushl $116
  1022bc:	6a 74                	push   $0x74
  jmp __alltraps
  1022be:	e9 63 06 00 00       	jmp    102926 <__alltraps>

001022c3 <vector117>:
.globl vector117
vector117:
  pushl $0
  1022c3:	6a 00                	push   $0x0
  pushl $117
  1022c5:	6a 75                	push   $0x75
  jmp __alltraps
  1022c7:	e9 5a 06 00 00       	jmp    102926 <__alltraps>

001022cc <vector118>:
.globl vector118
vector118:
  pushl $0
  1022cc:	6a 00                	push   $0x0
  pushl $118
  1022ce:	6a 76                	push   $0x76
  jmp __alltraps
  1022d0:	e9 51 06 00 00       	jmp    102926 <__alltraps>

001022d5 <vector119>:
.globl vector119
vector119:
  pushl $0
  1022d5:	6a 00                	push   $0x0
  pushl $119
  1022d7:	6a 77                	push   $0x77
  jmp __alltraps
  1022d9:	e9 48 06 00 00       	jmp    102926 <__alltraps>

001022de <vector120>:
.globl vector120
vector120:
  pushl $0
  1022de:	6a 00                	push   $0x0
  pushl $120
  1022e0:	6a 78                	push   $0x78
  jmp __alltraps
  1022e2:	e9 3f 06 00 00       	jmp    102926 <__alltraps>

001022e7 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022e7:	6a 00                	push   $0x0
  pushl $121
  1022e9:	6a 79                	push   $0x79
  jmp __alltraps
  1022eb:	e9 36 06 00 00       	jmp    102926 <__alltraps>

001022f0 <vector122>:
.globl vector122
vector122:
  pushl $0
  1022f0:	6a 00                	push   $0x0
  pushl $122
  1022f2:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022f4:	e9 2d 06 00 00       	jmp    102926 <__alltraps>

001022f9 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022f9:	6a 00                	push   $0x0
  pushl $123
  1022fb:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022fd:	e9 24 06 00 00       	jmp    102926 <__alltraps>

00102302 <vector124>:
.globl vector124
vector124:
  pushl $0
  102302:	6a 00                	push   $0x0
  pushl $124
  102304:	6a 7c                	push   $0x7c
  jmp __alltraps
  102306:	e9 1b 06 00 00       	jmp    102926 <__alltraps>

0010230b <vector125>:
.globl vector125
vector125:
  pushl $0
  10230b:	6a 00                	push   $0x0
  pushl $125
  10230d:	6a 7d                	push   $0x7d
  jmp __alltraps
  10230f:	e9 12 06 00 00       	jmp    102926 <__alltraps>

00102314 <vector126>:
.globl vector126
vector126:
  pushl $0
  102314:	6a 00                	push   $0x0
  pushl $126
  102316:	6a 7e                	push   $0x7e
  jmp __alltraps
  102318:	e9 09 06 00 00       	jmp    102926 <__alltraps>

0010231d <vector127>:
.globl vector127
vector127:
  pushl $0
  10231d:	6a 00                	push   $0x0
  pushl $127
  10231f:	6a 7f                	push   $0x7f
  jmp __alltraps
  102321:	e9 00 06 00 00       	jmp    102926 <__alltraps>

00102326 <vector128>:
.globl vector128
vector128:
  pushl $0
  102326:	6a 00                	push   $0x0
  pushl $128
  102328:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10232d:	e9 f4 05 00 00       	jmp    102926 <__alltraps>

00102332 <vector129>:
.globl vector129
vector129:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $129
  102334:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102339:	e9 e8 05 00 00       	jmp    102926 <__alltraps>

0010233e <vector130>:
.globl vector130
vector130:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $130
  102340:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102345:	e9 dc 05 00 00       	jmp    102926 <__alltraps>

0010234a <vector131>:
.globl vector131
vector131:
  pushl $0
  10234a:	6a 00                	push   $0x0
  pushl $131
  10234c:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102351:	e9 d0 05 00 00       	jmp    102926 <__alltraps>

00102356 <vector132>:
.globl vector132
vector132:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $132
  102358:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10235d:	e9 c4 05 00 00       	jmp    102926 <__alltraps>

00102362 <vector133>:
.globl vector133
vector133:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $133
  102364:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102369:	e9 b8 05 00 00       	jmp    102926 <__alltraps>

0010236e <vector134>:
.globl vector134
vector134:
  pushl $0
  10236e:	6a 00                	push   $0x0
  pushl $134
  102370:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102375:	e9 ac 05 00 00       	jmp    102926 <__alltraps>

0010237a <vector135>:
.globl vector135
vector135:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $135
  10237c:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102381:	e9 a0 05 00 00       	jmp    102926 <__alltraps>

00102386 <vector136>:
.globl vector136
vector136:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $136
  102388:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10238d:	e9 94 05 00 00       	jmp    102926 <__alltraps>

00102392 <vector137>:
.globl vector137
vector137:
  pushl $0
  102392:	6a 00                	push   $0x0
  pushl $137
  102394:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102399:	e9 88 05 00 00       	jmp    102926 <__alltraps>

0010239e <vector138>:
.globl vector138
vector138:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $138
  1023a0:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023a5:	e9 7c 05 00 00       	jmp    102926 <__alltraps>

001023aa <vector139>:
.globl vector139
vector139:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $139
  1023ac:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023b1:	e9 70 05 00 00       	jmp    102926 <__alltraps>

001023b6 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023b6:	6a 00                	push   $0x0
  pushl $140
  1023b8:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023bd:	e9 64 05 00 00       	jmp    102926 <__alltraps>

001023c2 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023c2:	6a 00                	push   $0x0
  pushl $141
  1023c4:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023c9:	e9 58 05 00 00       	jmp    102926 <__alltraps>

001023ce <vector142>:
.globl vector142
vector142:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $142
  1023d0:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023d5:	e9 4c 05 00 00       	jmp    102926 <__alltraps>

001023da <vector143>:
.globl vector143
vector143:
  pushl $0
  1023da:	6a 00                	push   $0x0
  pushl $143
  1023dc:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023e1:	e9 40 05 00 00       	jmp    102926 <__alltraps>

001023e6 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023e6:	6a 00                	push   $0x0
  pushl $144
  1023e8:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023ed:	e9 34 05 00 00       	jmp    102926 <__alltraps>

001023f2 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $145
  1023f4:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023f9:	e9 28 05 00 00       	jmp    102926 <__alltraps>

001023fe <vector146>:
.globl vector146
vector146:
  pushl $0
  1023fe:	6a 00                	push   $0x0
  pushl $146
  102400:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102405:	e9 1c 05 00 00       	jmp    102926 <__alltraps>

0010240a <vector147>:
.globl vector147
vector147:
  pushl $0
  10240a:	6a 00                	push   $0x0
  pushl $147
  10240c:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  102411:	e9 10 05 00 00       	jmp    102926 <__alltraps>

00102416 <vector148>:
.globl vector148
vector148:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $148
  102418:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10241d:	e9 04 05 00 00       	jmp    102926 <__alltraps>

00102422 <vector149>:
.globl vector149
vector149:
  pushl $0
  102422:	6a 00                	push   $0x0
  pushl $149
  102424:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102429:	e9 f8 04 00 00       	jmp    102926 <__alltraps>

0010242e <vector150>:
.globl vector150
vector150:
  pushl $0
  10242e:	6a 00                	push   $0x0
  pushl $150
  102430:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102435:	e9 ec 04 00 00       	jmp    102926 <__alltraps>

0010243a <vector151>:
.globl vector151
vector151:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $151
  10243c:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102441:	e9 e0 04 00 00       	jmp    102926 <__alltraps>

00102446 <vector152>:
.globl vector152
vector152:
  pushl $0
  102446:	6a 00                	push   $0x0
  pushl $152
  102448:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10244d:	e9 d4 04 00 00       	jmp    102926 <__alltraps>

00102452 <vector153>:
.globl vector153
vector153:
  pushl $0
  102452:	6a 00                	push   $0x0
  pushl $153
  102454:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102459:	e9 c8 04 00 00       	jmp    102926 <__alltraps>

0010245e <vector154>:
.globl vector154
vector154:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $154
  102460:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102465:	e9 bc 04 00 00       	jmp    102926 <__alltraps>

0010246a <vector155>:
.globl vector155
vector155:
  pushl $0
  10246a:	6a 00                	push   $0x0
  pushl $155
  10246c:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102471:	e9 b0 04 00 00       	jmp    102926 <__alltraps>

00102476 <vector156>:
.globl vector156
vector156:
  pushl $0
  102476:	6a 00                	push   $0x0
  pushl $156
  102478:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10247d:	e9 a4 04 00 00       	jmp    102926 <__alltraps>

00102482 <vector157>:
.globl vector157
vector157:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $157
  102484:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102489:	e9 98 04 00 00       	jmp    102926 <__alltraps>

0010248e <vector158>:
.globl vector158
vector158:
  pushl $0
  10248e:	6a 00                	push   $0x0
  pushl $158
  102490:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102495:	e9 8c 04 00 00       	jmp    102926 <__alltraps>

0010249a <vector159>:
.globl vector159
vector159:
  pushl $0
  10249a:	6a 00                	push   $0x0
  pushl $159
  10249c:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  1024a1:	e9 80 04 00 00       	jmp    102926 <__alltraps>

001024a6 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024a6:	6a 00                	push   $0x0
  pushl $160
  1024a8:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024ad:	e9 74 04 00 00       	jmp    102926 <__alltraps>

001024b2 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024b2:	6a 00                	push   $0x0
  pushl $161
  1024b4:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024b9:	e9 68 04 00 00       	jmp    102926 <__alltraps>

001024be <vector162>:
.globl vector162
vector162:
  pushl $0
  1024be:	6a 00                	push   $0x0
  pushl $162
  1024c0:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024c5:	e9 5c 04 00 00       	jmp    102926 <__alltraps>

001024ca <vector163>:
.globl vector163
vector163:
  pushl $0
  1024ca:	6a 00                	push   $0x0
  pushl $163
  1024cc:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024d1:	e9 50 04 00 00       	jmp    102926 <__alltraps>

001024d6 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024d6:	6a 00                	push   $0x0
  pushl $164
  1024d8:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024dd:	e9 44 04 00 00       	jmp    102926 <__alltraps>

001024e2 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024e2:	6a 00                	push   $0x0
  pushl $165
  1024e4:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024e9:	e9 38 04 00 00       	jmp    102926 <__alltraps>

001024ee <vector166>:
.globl vector166
vector166:
  pushl $0
  1024ee:	6a 00                	push   $0x0
  pushl $166
  1024f0:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024f5:	e9 2c 04 00 00       	jmp    102926 <__alltraps>

001024fa <vector167>:
.globl vector167
vector167:
  pushl $0
  1024fa:	6a 00                	push   $0x0
  pushl $167
  1024fc:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  102501:	e9 20 04 00 00       	jmp    102926 <__alltraps>

00102506 <vector168>:
.globl vector168
vector168:
  pushl $0
  102506:	6a 00                	push   $0x0
  pushl $168
  102508:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10250d:	e9 14 04 00 00       	jmp    102926 <__alltraps>

00102512 <vector169>:
.globl vector169
vector169:
  pushl $0
  102512:	6a 00                	push   $0x0
  pushl $169
  102514:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102519:	e9 08 04 00 00       	jmp    102926 <__alltraps>

0010251e <vector170>:
.globl vector170
vector170:
  pushl $0
  10251e:	6a 00                	push   $0x0
  pushl $170
  102520:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102525:	e9 fc 03 00 00       	jmp    102926 <__alltraps>

0010252a <vector171>:
.globl vector171
vector171:
  pushl $0
  10252a:	6a 00                	push   $0x0
  pushl $171
  10252c:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102531:	e9 f0 03 00 00       	jmp    102926 <__alltraps>

00102536 <vector172>:
.globl vector172
vector172:
  pushl $0
  102536:	6a 00                	push   $0x0
  pushl $172
  102538:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10253d:	e9 e4 03 00 00       	jmp    102926 <__alltraps>

00102542 <vector173>:
.globl vector173
vector173:
  pushl $0
  102542:	6a 00                	push   $0x0
  pushl $173
  102544:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102549:	e9 d8 03 00 00       	jmp    102926 <__alltraps>

0010254e <vector174>:
.globl vector174
vector174:
  pushl $0
  10254e:	6a 00                	push   $0x0
  pushl $174
  102550:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102555:	e9 cc 03 00 00       	jmp    102926 <__alltraps>

0010255a <vector175>:
.globl vector175
vector175:
  pushl $0
  10255a:	6a 00                	push   $0x0
  pushl $175
  10255c:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102561:	e9 c0 03 00 00       	jmp    102926 <__alltraps>

00102566 <vector176>:
.globl vector176
vector176:
  pushl $0
  102566:	6a 00                	push   $0x0
  pushl $176
  102568:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10256d:	e9 b4 03 00 00       	jmp    102926 <__alltraps>

00102572 <vector177>:
.globl vector177
vector177:
  pushl $0
  102572:	6a 00                	push   $0x0
  pushl $177
  102574:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102579:	e9 a8 03 00 00       	jmp    102926 <__alltraps>

0010257e <vector178>:
.globl vector178
vector178:
  pushl $0
  10257e:	6a 00                	push   $0x0
  pushl $178
  102580:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102585:	e9 9c 03 00 00       	jmp    102926 <__alltraps>

0010258a <vector179>:
.globl vector179
vector179:
  pushl $0
  10258a:	6a 00                	push   $0x0
  pushl $179
  10258c:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102591:	e9 90 03 00 00       	jmp    102926 <__alltraps>

00102596 <vector180>:
.globl vector180
vector180:
  pushl $0
  102596:	6a 00                	push   $0x0
  pushl $180
  102598:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10259d:	e9 84 03 00 00       	jmp    102926 <__alltraps>

001025a2 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025a2:	6a 00                	push   $0x0
  pushl $181
  1025a4:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025a9:	e9 78 03 00 00       	jmp    102926 <__alltraps>

001025ae <vector182>:
.globl vector182
vector182:
  pushl $0
  1025ae:	6a 00                	push   $0x0
  pushl $182
  1025b0:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025b5:	e9 6c 03 00 00       	jmp    102926 <__alltraps>

001025ba <vector183>:
.globl vector183
vector183:
  pushl $0
  1025ba:	6a 00                	push   $0x0
  pushl $183
  1025bc:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025c1:	e9 60 03 00 00       	jmp    102926 <__alltraps>

001025c6 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025c6:	6a 00                	push   $0x0
  pushl $184
  1025c8:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025cd:	e9 54 03 00 00       	jmp    102926 <__alltraps>

001025d2 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025d2:	6a 00                	push   $0x0
  pushl $185
  1025d4:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025d9:	e9 48 03 00 00       	jmp    102926 <__alltraps>

001025de <vector186>:
.globl vector186
vector186:
  pushl $0
  1025de:	6a 00                	push   $0x0
  pushl $186
  1025e0:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025e5:	e9 3c 03 00 00       	jmp    102926 <__alltraps>

001025ea <vector187>:
.globl vector187
vector187:
  pushl $0
  1025ea:	6a 00                	push   $0x0
  pushl $187
  1025ec:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025f1:	e9 30 03 00 00       	jmp    102926 <__alltraps>

001025f6 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025f6:	6a 00                	push   $0x0
  pushl $188
  1025f8:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025fd:	e9 24 03 00 00       	jmp    102926 <__alltraps>

00102602 <vector189>:
.globl vector189
vector189:
  pushl $0
  102602:	6a 00                	push   $0x0
  pushl $189
  102604:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102609:	e9 18 03 00 00       	jmp    102926 <__alltraps>

0010260e <vector190>:
.globl vector190
vector190:
  pushl $0
  10260e:	6a 00                	push   $0x0
  pushl $190
  102610:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102615:	e9 0c 03 00 00       	jmp    102926 <__alltraps>

0010261a <vector191>:
.globl vector191
vector191:
  pushl $0
  10261a:	6a 00                	push   $0x0
  pushl $191
  10261c:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102621:	e9 00 03 00 00       	jmp    102926 <__alltraps>

00102626 <vector192>:
.globl vector192
vector192:
  pushl $0
  102626:	6a 00                	push   $0x0
  pushl $192
  102628:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10262d:	e9 f4 02 00 00       	jmp    102926 <__alltraps>

00102632 <vector193>:
.globl vector193
vector193:
  pushl $0
  102632:	6a 00                	push   $0x0
  pushl $193
  102634:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102639:	e9 e8 02 00 00       	jmp    102926 <__alltraps>

0010263e <vector194>:
.globl vector194
vector194:
  pushl $0
  10263e:	6a 00                	push   $0x0
  pushl $194
  102640:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102645:	e9 dc 02 00 00       	jmp    102926 <__alltraps>

0010264a <vector195>:
.globl vector195
vector195:
  pushl $0
  10264a:	6a 00                	push   $0x0
  pushl $195
  10264c:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102651:	e9 d0 02 00 00       	jmp    102926 <__alltraps>

00102656 <vector196>:
.globl vector196
vector196:
  pushl $0
  102656:	6a 00                	push   $0x0
  pushl $196
  102658:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10265d:	e9 c4 02 00 00       	jmp    102926 <__alltraps>

00102662 <vector197>:
.globl vector197
vector197:
  pushl $0
  102662:	6a 00                	push   $0x0
  pushl $197
  102664:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102669:	e9 b8 02 00 00       	jmp    102926 <__alltraps>

0010266e <vector198>:
.globl vector198
vector198:
  pushl $0
  10266e:	6a 00                	push   $0x0
  pushl $198
  102670:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102675:	e9 ac 02 00 00       	jmp    102926 <__alltraps>

0010267a <vector199>:
.globl vector199
vector199:
  pushl $0
  10267a:	6a 00                	push   $0x0
  pushl $199
  10267c:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102681:	e9 a0 02 00 00       	jmp    102926 <__alltraps>

00102686 <vector200>:
.globl vector200
vector200:
  pushl $0
  102686:	6a 00                	push   $0x0
  pushl $200
  102688:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10268d:	e9 94 02 00 00       	jmp    102926 <__alltraps>

00102692 <vector201>:
.globl vector201
vector201:
  pushl $0
  102692:	6a 00                	push   $0x0
  pushl $201
  102694:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102699:	e9 88 02 00 00       	jmp    102926 <__alltraps>

0010269e <vector202>:
.globl vector202
vector202:
  pushl $0
  10269e:	6a 00                	push   $0x0
  pushl $202
  1026a0:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026a5:	e9 7c 02 00 00       	jmp    102926 <__alltraps>

001026aa <vector203>:
.globl vector203
vector203:
  pushl $0
  1026aa:	6a 00                	push   $0x0
  pushl $203
  1026ac:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026b1:	e9 70 02 00 00       	jmp    102926 <__alltraps>

001026b6 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026b6:	6a 00                	push   $0x0
  pushl $204
  1026b8:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026bd:	e9 64 02 00 00       	jmp    102926 <__alltraps>

001026c2 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026c2:	6a 00                	push   $0x0
  pushl $205
  1026c4:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026c9:	e9 58 02 00 00       	jmp    102926 <__alltraps>

001026ce <vector206>:
.globl vector206
vector206:
  pushl $0
  1026ce:	6a 00                	push   $0x0
  pushl $206
  1026d0:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026d5:	e9 4c 02 00 00       	jmp    102926 <__alltraps>

001026da <vector207>:
.globl vector207
vector207:
  pushl $0
  1026da:	6a 00                	push   $0x0
  pushl $207
  1026dc:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026e1:	e9 40 02 00 00       	jmp    102926 <__alltraps>

001026e6 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026e6:	6a 00                	push   $0x0
  pushl $208
  1026e8:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026ed:	e9 34 02 00 00       	jmp    102926 <__alltraps>

001026f2 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026f2:	6a 00                	push   $0x0
  pushl $209
  1026f4:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026f9:	e9 28 02 00 00       	jmp    102926 <__alltraps>

001026fe <vector210>:
.globl vector210
vector210:
  pushl $0
  1026fe:	6a 00                	push   $0x0
  pushl $210
  102700:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102705:	e9 1c 02 00 00       	jmp    102926 <__alltraps>

0010270a <vector211>:
.globl vector211
vector211:
  pushl $0
  10270a:	6a 00                	push   $0x0
  pushl $211
  10270c:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  102711:	e9 10 02 00 00       	jmp    102926 <__alltraps>

00102716 <vector212>:
.globl vector212
vector212:
  pushl $0
  102716:	6a 00                	push   $0x0
  pushl $212
  102718:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10271d:	e9 04 02 00 00       	jmp    102926 <__alltraps>

00102722 <vector213>:
.globl vector213
vector213:
  pushl $0
  102722:	6a 00                	push   $0x0
  pushl $213
  102724:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102729:	e9 f8 01 00 00       	jmp    102926 <__alltraps>

0010272e <vector214>:
.globl vector214
vector214:
  pushl $0
  10272e:	6a 00                	push   $0x0
  pushl $214
  102730:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102735:	e9 ec 01 00 00       	jmp    102926 <__alltraps>

0010273a <vector215>:
.globl vector215
vector215:
  pushl $0
  10273a:	6a 00                	push   $0x0
  pushl $215
  10273c:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102741:	e9 e0 01 00 00       	jmp    102926 <__alltraps>

00102746 <vector216>:
.globl vector216
vector216:
  pushl $0
  102746:	6a 00                	push   $0x0
  pushl $216
  102748:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10274d:	e9 d4 01 00 00       	jmp    102926 <__alltraps>

00102752 <vector217>:
.globl vector217
vector217:
  pushl $0
  102752:	6a 00                	push   $0x0
  pushl $217
  102754:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102759:	e9 c8 01 00 00       	jmp    102926 <__alltraps>

0010275e <vector218>:
.globl vector218
vector218:
  pushl $0
  10275e:	6a 00                	push   $0x0
  pushl $218
  102760:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102765:	e9 bc 01 00 00       	jmp    102926 <__alltraps>

0010276a <vector219>:
.globl vector219
vector219:
  pushl $0
  10276a:	6a 00                	push   $0x0
  pushl $219
  10276c:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102771:	e9 b0 01 00 00       	jmp    102926 <__alltraps>

00102776 <vector220>:
.globl vector220
vector220:
  pushl $0
  102776:	6a 00                	push   $0x0
  pushl $220
  102778:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10277d:	e9 a4 01 00 00       	jmp    102926 <__alltraps>

00102782 <vector221>:
.globl vector221
vector221:
  pushl $0
  102782:	6a 00                	push   $0x0
  pushl $221
  102784:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102789:	e9 98 01 00 00       	jmp    102926 <__alltraps>

0010278e <vector222>:
.globl vector222
vector222:
  pushl $0
  10278e:	6a 00                	push   $0x0
  pushl $222
  102790:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102795:	e9 8c 01 00 00       	jmp    102926 <__alltraps>

0010279a <vector223>:
.globl vector223
vector223:
  pushl $0
  10279a:	6a 00                	push   $0x0
  pushl $223
  10279c:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  1027a1:	e9 80 01 00 00       	jmp    102926 <__alltraps>

001027a6 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027a6:	6a 00                	push   $0x0
  pushl $224
  1027a8:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027ad:	e9 74 01 00 00       	jmp    102926 <__alltraps>

001027b2 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027b2:	6a 00                	push   $0x0
  pushl $225
  1027b4:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027b9:	e9 68 01 00 00       	jmp    102926 <__alltraps>

001027be <vector226>:
.globl vector226
vector226:
  pushl $0
  1027be:	6a 00                	push   $0x0
  pushl $226
  1027c0:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027c5:	e9 5c 01 00 00       	jmp    102926 <__alltraps>

001027ca <vector227>:
.globl vector227
vector227:
  pushl $0
  1027ca:	6a 00                	push   $0x0
  pushl $227
  1027cc:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027d1:	e9 50 01 00 00       	jmp    102926 <__alltraps>

001027d6 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027d6:	6a 00                	push   $0x0
  pushl $228
  1027d8:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027dd:	e9 44 01 00 00       	jmp    102926 <__alltraps>

001027e2 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027e2:	6a 00                	push   $0x0
  pushl $229
  1027e4:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027e9:	e9 38 01 00 00       	jmp    102926 <__alltraps>

001027ee <vector230>:
.globl vector230
vector230:
  pushl $0
  1027ee:	6a 00                	push   $0x0
  pushl $230
  1027f0:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027f5:	e9 2c 01 00 00       	jmp    102926 <__alltraps>

001027fa <vector231>:
.globl vector231
vector231:
  pushl $0
  1027fa:	6a 00                	push   $0x0
  pushl $231
  1027fc:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  102801:	e9 20 01 00 00       	jmp    102926 <__alltraps>

00102806 <vector232>:
.globl vector232
vector232:
  pushl $0
  102806:	6a 00                	push   $0x0
  pushl $232
  102808:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10280d:	e9 14 01 00 00       	jmp    102926 <__alltraps>

00102812 <vector233>:
.globl vector233
vector233:
  pushl $0
  102812:	6a 00                	push   $0x0
  pushl $233
  102814:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102819:	e9 08 01 00 00       	jmp    102926 <__alltraps>

0010281e <vector234>:
.globl vector234
vector234:
  pushl $0
  10281e:	6a 00                	push   $0x0
  pushl $234
  102820:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102825:	e9 fc 00 00 00       	jmp    102926 <__alltraps>

0010282a <vector235>:
.globl vector235
vector235:
  pushl $0
  10282a:	6a 00                	push   $0x0
  pushl $235
  10282c:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102831:	e9 f0 00 00 00       	jmp    102926 <__alltraps>

00102836 <vector236>:
.globl vector236
vector236:
  pushl $0
  102836:	6a 00                	push   $0x0
  pushl $236
  102838:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10283d:	e9 e4 00 00 00       	jmp    102926 <__alltraps>

00102842 <vector237>:
.globl vector237
vector237:
  pushl $0
  102842:	6a 00                	push   $0x0
  pushl $237
  102844:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102849:	e9 d8 00 00 00       	jmp    102926 <__alltraps>

0010284e <vector238>:
.globl vector238
vector238:
  pushl $0
  10284e:	6a 00                	push   $0x0
  pushl $238
  102850:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102855:	e9 cc 00 00 00       	jmp    102926 <__alltraps>

0010285a <vector239>:
.globl vector239
vector239:
  pushl $0
  10285a:	6a 00                	push   $0x0
  pushl $239
  10285c:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102861:	e9 c0 00 00 00       	jmp    102926 <__alltraps>

00102866 <vector240>:
.globl vector240
vector240:
  pushl $0
  102866:	6a 00                	push   $0x0
  pushl $240
  102868:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10286d:	e9 b4 00 00 00       	jmp    102926 <__alltraps>

00102872 <vector241>:
.globl vector241
vector241:
  pushl $0
  102872:	6a 00                	push   $0x0
  pushl $241
  102874:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102879:	e9 a8 00 00 00       	jmp    102926 <__alltraps>

0010287e <vector242>:
.globl vector242
vector242:
  pushl $0
  10287e:	6a 00                	push   $0x0
  pushl $242
  102880:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102885:	e9 9c 00 00 00       	jmp    102926 <__alltraps>

0010288a <vector243>:
.globl vector243
vector243:
  pushl $0
  10288a:	6a 00                	push   $0x0
  pushl $243
  10288c:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102891:	e9 90 00 00 00       	jmp    102926 <__alltraps>

00102896 <vector244>:
.globl vector244
vector244:
  pushl $0
  102896:	6a 00                	push   $0x0
  pushl $244
  102898:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10289d:	e9 84 00 00 00       	jmp    102926 <__alltraps>

001028a2 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028a2:	6a 00                	push   $0x0
  pushl $245
  1028a4:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028a9:	e9 78 00 00 00       	jmp    102926 <__alltraps>

001028ae <vector246>:
.globl vector246
vector246:
  pushl $0
  1028ae:	6a 00                	push   $0x0
  pushl $246
  1028b0:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028b5:	e9 6c 00 00 00       	jmp    102926 <__alltraps>

001028ba <vector247>:
.globl vector247
vector247:
  pushl $0
  1028ba:	6a 00                	push   $0x0
  pushl $247
  1028bc:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028c1:	e9 60 00 00 00       	jmp    102926 <__alltraps>

001028c6 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028c6:	6a 00                	push   $0x0
  pushl $248
  1028c8:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028cd:	e9 54 00 00 00       	jmp    102926 <__alltraps>

001028d2 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028d2:	6a 00                	push   $0x0
  pushl $249
  1028d4:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028d9:	e9 48 00 00 00       	jmp    102926 <__alltraps>

001028de <vector250>:
.globl vector250
vector250:
  pushl $0
  1028de:	6a 00                	push   $0x0
  pushl $250
  1028e0:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028e5:	e9 3c 00 00 00       	jmp    102926 <__alltraps>

001028ea <vector251>:
.globl vector251
vector251:
  pushl $0
  1028ea:	6a 00                	push   $0x0
  pushl $251
  1028ec:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028f1:	e9 30 00 00 00       	jmp    102926 <__alltraps>

001028f6 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028f6:	6a 00                	push   $0x0
  pushl $252
  1028f8:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028fd:	e9 24 00 00 00       	jmp    102926 <__alltraps>

00102902 <vector253>:
.globl vector253
vector253:
  pushl $0
  102902:	6a 00                	push   $0x0
  pushl $253
  102904:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102909:	e9 18 00 00 00       	jmp    102926 <__alltraps>

0010290e <vector254>:
.globl vector254
vector254:
  pushl $0
  10290e:	6a 00                	push   $0x0
  pushl $254
  102910:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102915:	e9 0c 00 00 00       	jmp    102926 <__alltraps>

0010291a <vector255>:
.globl vector255
vector255:
  pushl $0
  10291a:	6a 00                	push   $0x0
  pushl $255
  10291c:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102921:	e9 00 00 00 00       	jmp    102926 <__alltraps>

00102926 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102926:	1e                   	push   %ds
    pushl %es
  102927:	06                   	push   %es
    pushl %fs
  102928:	0f a0                	push   %fs
    pushl %gs
  10292a:	0f a8                	push   %gs
    pushal
  10292c:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  10292d:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102932:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102934:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102936:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102937:	e8 62 f5 ff ff       	call   101e9e <trap>

    # pop the pushed stack pointer
    popl %esp
  10293c:	5c                   	pop    %esp

0010293d <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10293d:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10293e:	0f a9                	pop    %gs
    popl %fs
  102940:	0f a1                	pop    %fs
    popl %es
  102942:	07                   	pop    %es
    popl %ds
  102943:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102944:	83 c4 08             	add    $0x8,%esp
    iret
  102947:	cf                   	iret   

00102948 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102948:	55                   	push   %ebp
  102949:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10294b:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102950:	8b 55 08             	mov    0x8(%ebp),%edx
  102953:	29 c2                	sub    %eax,%edx
  102955:	89 d0                	mov    %edx,%eax
  102957:	c1 f8 02             	sar    $0x2,%eax
  10295a:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  102960:	5d                   	pop    %ebp
  102961:	c3                   	ret    

00102962 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102962:	55                   	push   %ebp
  102963:	89 e5                	mov    %esp,%ebp
  102965:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102968:	8b 45 08             	mov    0x8(%ebp),%eax
  10296b:	89 04 24             	mov    %eax,(%esp)
  10296e:	e8 d5 ff ff ff       	call   102948 <page2ppn>
  102973:	c1 e0 0c             	shl    $0xc,%eax
}
  102976:	c9                   	leave  
  102977:	c3                   	ret    

00102978 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102978:	55                   	push   %ebp
  102979:	89 e5                	mov    %esp,%ebp
  10297b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  10297e:	8b 45 08             	mov    0x8(%ebp),%eax
  102981:	c1 e8 0c             	shr    $0xc,%eax
  102984:	89 c2                	mov    %eax,%edx
  102986:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  10298b:	39 c2                	cmp    %eax,%edx
  10298d:	72 1c                	jb     1029ab <pa2page+0x33>
        panic("pa2page called with invalid pa");
  10298f:	c7 44 24 08 10 68 10 	movl   $0x106810,0x8(%esp)
  102996:	00 
  102997:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  10299e:	00 
  10299f:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  1029a6:	e8 7b da ff ff       	call   100426 <__panic>
    }
    return &pages[PPN(pa)];
  1029ab:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  1029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1029b4:	c1 e8 0c             	shr    $0xc,%eax
  1029b7:	89 c2                	mov    %eax,%edx
  1029b9:	89 d0                	mov    %edx,%eax
  1029bb:	c1 e0 02             	shl    $0x2,%eax
  1029be:	01 d0                	add    %edx,%eax
  1029c0:	c1 e0 02             	shl    $0x2,%eax
  1029c3:	01 c8                	add    %ecx,%eax
}
  1029c5:	c9                   	leave  
  1029c6:	c3                   	ret    

001029c7 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  1029c7:	55                   	push   %ebp
  1029c8:	89 e5                	mov    %esp,%ebp
  1029ca:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  1029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d0:	89 04 24             	mov    %eax,(%esp)
  1029d3:	e8 8a ff ff ff       	call   102962 <page2pa>
  1029d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1029db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029de:	c1 e8 0c             	shr    $0xc,%eax
  1029e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1029e4:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1029e9:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1029ec:	72 23                	jb     102a11 <page2kva+0x4a>
  1029ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1029f5:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  1029fc:	00 
  1029fd:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  102a04:	00 
  102a05:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  102a0c:	e8 15 da ff ff       	call   100426 <__panic>
  102a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a14:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  102a19:	c9                   	leave  
  102a1a:	c3                   	ret    

00102a1b <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  102a1b:	55                   	push   %ebp
  102a1c:	89 e5                	mov    %esp,%ebp
  102a1e:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  102a21:	8b 45 08             	mov    0x8(%ebp),%eax
  102a24:	83 e0 01             	and    $0x1,%eax
  102a27:	85 c0                	test   %eax,%eax
  102a29:	75 1c                	jne    102a47 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  102a2b:	c7 44 24 08 64 68 10 	movl   $0x106864,0x8(%esp)
  102a32:	00 
  102a33:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102a3a:	00 
  102a3b:	c7 04 24 2f 68 10 00 	movl   $0x10682f,(%esp)
  102a42:	e8 df d9 ff ff       	call   100426 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102a47:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a4f:	89 04 24             	mov    %eax,(%esp)
  102a52:	e8 21 ff ff ff       	call   102978 <pa2page>
}
  102a57:	c9                   	leave  
  102a58:	c3                   	ret    

00102a59 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102a59:	55                   	push   %ebp
  102a5a:	89 e5                	mov    %esp,%ebp
  102a5c:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  102a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  102a62:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102a67:	89 04 24             	mov    %eax,(%esp)
  102a6a:	e8 09 ff ff ff       	call   102978 <pa2page>
}
  102a6f:	c9                   	leave  
  102a70:	c3                   	ret    

00102a71 <page_ref>:

static inline int
page_ref(struct Page *page) {
  102a71:	55                   	push   %ebp
  102a72:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102a74:	8b 45 08             	mov    0x8(%ebp),%eax
  102a77:	8b 00                	mov    (%eax),%eax
}
  102a79:	5d                   	pop    %ebp
  102a7a:	c3                   	ret    

00102a7b <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102a7b:	55                   	push   %ebp
  102a7c:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a81:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a84:	89 10                	mov    %edx,(%eax)
}
  102a86:	90                   	nop
  102a87:	5d                   	pop    %ebp
  102a88:	c3                   	ret    

00102a89 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102a89:	55                   	push   %ebp
  102a8a:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  102a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102a8f:	8b 00                	mov    (%eax),%eax
  102a91:	8d 50 01             	lea    0x1(%eax),%edx
  102a94:	8b 45 08             	mov    0x8(%ebp),%eax
  102a97:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102a99:	8b 45 08             	mov    0x8(%ebp),%eax
  102a9c:	8b 00                	mov    (%eax),%eax
}
  102a9e:	5d                   	pop    %ebp
  102a9f:	c3                   	ret    

00102aa0 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  102aa0:	55                   	push   %ebp
  102aa1:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa6:	8b 00                	mov    (%eax),%eax
  102aa8:	8d 50 ff             	lea    -0x1(%eax),%edx
  102aab:	8b 45 08             	mov    0x8(%ebp),%eax
  102aae:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab3:	8b 00                	mov    (%eax),%eax
}
  102ab5:	5d                   	pop    %ebp
  102ab6:	c3                   	ret    

00102ab7 <__intr_save>:
__intr_save(void) {
  102ab7:	55                   	push   %ebp
  102ab8:	89 e5                	mov    %esp,%ebp
  102aba:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  102abd:	9c                   	pushf  
  102abe:	58                   	pop    %eax
  102abf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102ac5:	25 00 02 00 00       	and    $0x200,%eax
  102aca:	85 c0                	test   %eax,%eax
  102acc:	74 0c                	je     102ada <__intr_save+0x23>
        intr_disable();
  102ace:	e8 ab ee ff ff       	call   10197e <intr_disable>
        return 1;
  102ad3:	b8 01 00 00 00       	mov    $0x1,%eax
  102ad8:	eb 05                	jmp    102adf <__intr_save+0x28>
    return 0;
  102ada:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102adf:	c9                   	leave  
  102ae0:	c3                   	ret    

00102ae1 <__intr_restore>:
__intr_restore(bool flag) {
  102ae1:	55                   	push   %ebp
  102ae2:	89 e5                	mov    %esp,%ebp
  102ae4:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  102ae7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102aeb:	74 05                	je     102af2 <__intr_restore+0x11>
        intr_enable();
  102aed:	e8 80 ee ff ff       	call   101972 <intr_enable>
}
  102af2:	90                   	nop
  102af3:	c9                   	leave  
  102af4:	c3                   	ret    

00102af5 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102af5:	55                   	push   %ebp
  102af6:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102af8:	8b 45 08             	mov    0x8(%ebp),%eax
  102afb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102afe:	b8 23 00 00 00       	mov    $0x23,%eax
  102b03:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102b05:	b8 23 00 00 00       	mov    $0x23,%eax
  102b0a:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102b0c:	b8 10 00 00 00       	mov    $0x10,%eax
  102b11:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102b13:	b8 10 00 00 00       	mov    $0x10,%eax
  102b18:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102b1a:	b8 10 00 00 00       	mov    $0x10,%eax
  102b1f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102b21:	ea 28 2b 10 00 08 00 	ljmp   $0x8,$0x102b28
}
  102b28:	90                   	nop
  102b29:	5d                   	pop    %ebp
  102b2a:	c3                   	ret    

00102b2b <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  102b2b:	f3 0f 1e fb          	endbr32 
  102b2f:	55                   	push   %ebp
  102b30:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  102b32:	8b 45 08             	mov    0x8(%ebp),%eax
  102b35:	a3 a4 ce 11 00       	mov    %eax,0x11cea4
}
  102b3a:	90                   	nop
  102b3b:	5d                   	pop    %ebp
  102b3c:	c3                   	ret    

00102b3d <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102b3d:	f3 0f 1e fb          	endbr32 
  102b41:	55                   	push   %ebp
  102b42:	89 e5                	mov    %esp,%ebp
  102b44:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102b47:	b8 00 90 11 00       	mov    $0x119000,%eax
  102b4c:	89 04 24             	mov    %eax,(%esp)
  102b4f:	e8 d7 ff ff ff       	call   102b2b <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102b54:	66 c7 05 a8 ce 11 00 	movw   $0x10,0x11cea8
  102b5b:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102b5d:	66 c7 05 28 9a 11 00 	movw   $0x68,0x119a28
  102b64:	68 00 
  102b66:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102b6b:	0f b7 c0             	movzwl %ax,%eax
  102b6e:	66 a3 2a 9a 11 00    	mov    %ax,0x119a2a
  102b74:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102b79:	c1 e8 10             	shr    $0x10,%eax
  102b7c:	a2 2c 9a 11 00       	mov    %al,0x119a2c
  102b81:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102b88:	24 f0                	and    $0xf0,%al
  102b8a:	0c 09                	or     $0x9,%al
  102b8c:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102b91:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102b98:	24 ef                	and    $0xef,%al
  102b9a:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102b9f:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102ba6:	24 9f                	and    $0x9f,%al
  102ba8:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bad:	0f b6 05 2d 9a 11 00 	movzbl 0x119a2d,%eax
  102bb4:	0c 80                	or     $0x80,%al
  102bb6:	a2 2d 9a 11 00       	mov    %al,0x119a2d
  102bbb:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bc2:	24 f0                	and    $0xf0,%al
  102bc4:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bc9:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bd0:	24 ef                	and    $0xef,%al
  102bd2:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bd7:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bde:	24 df                	and    $0xdf,%al
  102be0:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102be5:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bec:	0c 40                	or     $0x40,%al
  102bee:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102bf3:	0f b6 05 2e 9a 11 00 	movzbl 0x119a2e,%eax
  102bfa:	24 7f                	and    $0x7f,%al
  102bfc:	a2 2e 9a 11 00       	mov    %al,0x119a2e
  102c01:	b8 a0 ce 11 00       	mov    $0x11cea0,%eax
  102c06:	c1 e8 18             	shr    $0x18,%eax
  102c09:	a2 2f 9a 11 00       	mov    %al,0x119a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102c0e:	c7 04 24 30 9a 11 00 	movl   $0x119a30,(%esp)
  102c15:	e8 db fe ff ff       	call   102af5 <lgdt>
  102c1a:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102c20:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102c24:	0f 00 d8             	ltr    %ax
}
  102c27:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102c28:	90                   	nop
  102c29:	c9                   	leave  
  102c2a:	c3                   	ret    

00102c2b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102c2b:	f3 0f 1e fb          	endbr32 
  102c2f:	55                   	push   %ebp
  102c30:	89 e5                	mov    %esp,%ebp
  102c32:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102c35:	c7 05 10 cf 11 00 08 	movl   $0x107208,0x11cf10
  102c3c:	72 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102c3f:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c44:	8b 00                	mov    (%eax),%eax
  102c46:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c4a:	c7 04 24 90 68 10 00 	movl   $0x106890,(%esp)
  102c51:	e8 64 d6 ff ff       	call   1002ba <cprintf>
    pmm_manager->init();
  102c56:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c5b:	8b 40 04             	mov    0x4(%eax),%eax
  102c5e:	ff d0                	call   *%eax
}
  102c60:	90                   	nop
  102c61:	c9                   	leave  
  102c62:	c3                   	ret    

00102c63 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102c63:	f3 0f 1e fb          	endbr32 
  102c67:	55                   	push   %ebp
  102c68:	89 e5                	mov    %esp,%ebp
  102c6a:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102c6d:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102c72:	8b 40 08             	mov    0x8(%eax),%eax
  102c75:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c78:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c7c:	8b 55 08             	mov    0x8(%ebp),%edx
  102c7f:	89 14 24             	mov    %edx,(%esp)
  102c82:	ff d0                	call   *%eax
}
  102c84:	90                   	nop
  102c85:	c9                   	leave  
  102c86:	c3                   	ret    

00102c87 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102c87:	f3 0f 1e fb          	endbr32 
  102c8b:	55                   	push   %ebp
  102c8c:	89 e5                	mov    %esp,%ebp
  102c8e:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102c91:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102c98:	e8 1a fe ff ff       	call   102ab7 <__intr_save>
  102c9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102ca0:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102ca5:	8b 40 0c             	mov    0xc(%eax),%eax
  102ca8:	8b 55 08             	mov    0x8(%ebp),%edx
  102cab:	89 14 24             	mov    %edx,(%esp)
  102cae:	ff d0                	call   *%eax
  102cb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb6:	89 04 24             	mov    %eax,(%esp)
  102cb9:	e8 23 fe ff ff       	call   102ae1 <__intr_restore>
    return page;
  102cbe:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102cc1:	c9                   	leave  
  102cc2:	c3                   	ret    

00102cc3 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102cc3:	f3 0f 1e fb          	endbr32 
  102cc7:	55                   	push   %ebp
  102cc8:	89 e5                	mov    %esp,%ebp
  102cca:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102ccd:	e8 e5 fd ff ff       	call   102ab7 <__intr_save>
  102cd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102cd5:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102cda:	8b 40 10             	mov    0x10(%eax),%eax
  102cdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ce0:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ce4:	8b 55 08             	mov    0x8(%ebp),%edx
  102ce7:	89 14 24             	mov    %edx,(%esp)
  102cea:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cef:	89 04 24             	mov    %eax,(%esp)
  102cf2:	e8 ea fd ff ff       	call   102ae1 <__intr_restore>
}
  102cf7:	90                   	nop
  102cf8:	c9                   	leave  
  102cf9:	c3                   	ret    

00102cfa <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102cfa:	f3 0f 1e fb          	endbr32 
  102cfe:	55                   	push   %ebp
  102cff:	89 e5                	mov    %esp,%ebp
  102d01:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102d04:	e8 ae fd ff ff       	call   102ab7 <__intr_save>
  102d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102d0c:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  102d11:	8b 40 14             	mov    0x14(%eax),%eax
  102d14:	ff d0                	call   *%eax
  102d16:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d1c:	89 04 24             	mov    %eax,(%esp)
  102d1f:	e8 bd fd ff ff       	call   102ae1 <__intr_restore>
    return ret;
  102d24:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102d27:	c9                   	leave  
  102d28:	c3                   	ret    

00102d29 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102d29:	f3 0f 1e fb          	endbr32 
  102d2d:	55                   	push   %ebp
  102d2e:	89 e5                	mov    %esp,%ebp
  102d30:	57                   	push   %edi
  102d31:	56                   	push   %esi
  102d32:	53                   	push   %ebx
  102d33:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102d39:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102d40:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102d47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102d4e:	c7 04 24 a7 68 10 00 	movl   $0x1068a7,(%esp)
  102d55:	e8 60 d5 ff ff       	call   1002ba <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102d5a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d61:	e9 1a 01 00 00       	jmp    102e80 <page_init+0x157>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102d66:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d69:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d6c:	89 d0                	mov    %edx,%eax
  102d6e:	c1 e0 02             	shl    $0x2,%eax
  102d71:	01 d0                	add    %edx,%eax
  102d73:	c1 e0 02             	shl    $0x2,%eax
  102d76:	01 c8                	add    %ecx,%eax
  102d78:	8b 50 08             	mov    0x8(%eax),%edx
  102d7b:	8b 40 04             	mov    0x4(%eax),%eax
  102d7e:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102d81:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102d84:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102d87:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102d8a:	89 d0                	mov    %edx,%eax
  102d8c:	c1 e0 02             	shl    $0x2,%eax
  102d8f:	01 d0                	add    %edx,%eax
  102d91:	c1 e0 02             	shl    $0x2,%eax
  102d94:	01 c8                	add    %ecx,%eax
  102d96:	8b 48 0c             	mov    0xc(%eax),%ecx
  102d99:	8b 58 10             	mov    0x10(%eax),%ebx
  102d9c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102d9f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102da2:	01 c8                	add    %ecx,%eax
  102da4:	11 da                	adc    %ebx,%edx
  102da6:	89 45 98             	mov    %eax,-0x68(%ebp)
  102da9:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102dac:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102daf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102db2:	89 d0                	mov    %edx,%eax
  102db4:	c1 e0 02             	shl    $0x2,%eax
  102db7:	01 d0                	add    %edx,%eax
  102db9:	c1 e0 02             	shl    $0x2,%eax
  102dbc:	01 c8                	add    %ecx,%eax
  102dbe:	83 c0 14             	add    $0x14,%eax
  102dc1:	8b 00                	mov    (%eax),%eax
  102dc3:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102dc6:	8b 45 98             	mov    -0x68(%ebp),%eax
  102dc9:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102dcc:	83 c0 ff             	add    $0xffffffff,%eax
  102dcf:	83 d2 ff             	adc    $0xffffffff,%edx
  102dd2:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102dd8:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102dde:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102de4:	89 d0                	mov    %edx,%eax
  102de6:	c1 e0 02             	shl    $0x2,%eax
  102de9:	01 d0                	add    %edx,%eax
  102deb:	c1 e0 02             	shl    $0x2,%eax
  102dee:	01 c8                	add    %ecx,%eax
  102df0:	8b 48 0c             	mov    0xc(%eax),%ecx
  102df3:	8b 58 10             	mov    0x10(%eax),%ebx
  102df6:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102df9:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102dfd:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102e03:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102e09:	89 44 24 14          	mov    %eax,0x14(%esp)
  102e0d:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e11:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102e14:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102e17:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e1b:	89 54 24 10          	mov    %edx,0x10(%esp)
  102e1f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102e23:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102e27:	c7 04 24 b4 68 10 00 	movl   $0x1068b4,(%esp)
  102e2e:	e8 87 d4 ff ff       	call   1002ba <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102e33:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e39:	89 d0                	mov    %edx,%eax
  102e3b:	c1 e0 02             	shl    $0x2,%eax
  102e3e:	01 d0                	add    %edx,%eax
  102e40:	c1 e0 02             	shl    $0x2,%eax
  102e43:	01 c8                	add    %ecx,%eax
  102e45:	83 c0 14             	add    $0x14,%eax
  102e48:	8b 00                	mov    (%eax),%eax
  102e4a:	83 f8 01             	cmp    $0x1,%eax
  102e4d:	75 2e                	jne    102e7d <page_init+0x154>
            if (maxpa < end && begin < KMEMSIZE) {
  102e4f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e52:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102e55:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102e58:	89 d0                	mov    %edx,%eax
  102e5a:	1b 45 9c             	sbb    -0x64(%ebp),%eax
  102e5d:	73 1e                	jae    102e7d <page_init+0x154>
  102e5f:	ba ff ff ff 37       	mov    $0x37ffffff,%edx
  102e64:	b8 00 00 00 00       	mov    $0x0,%eax
  102e69:	3b 55 a0             	cmp    -0x60(%ebp),%edx
  102e6c:	1b 45 a4             	sbb    -0x5c(%ebp),%eax
  102e6f:	72 0c                	jb     102e7d <page_init+0x154>
                maxpa = end;
  102e71:	8b 45 98             	mov    -0x68(%ebp),%eax
  102e74:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102e77:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e7a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102e7d:	ff 45 dc             	incl   -0x24(%ebp)
  102e80:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102e83:	8b 00                	mov    (%eax),%eax
  102e85:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102e88:	0f 8c d8 fe ff ff    	jl     102d66 <page_init+0x3d>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102e8e:	ba 00 00 00 38       	mov    $0x38000000,%edx
  102e93:	b8 00 00 00 00       	mov    $0x0,%eax
  102e98:	3b 55 e0             	cmp    -0x20(%ebp),%edx
  102e9b:	1b 45 e4             	sbb    -0x1c(%ebp),%eax
  102e9e:	73 0e                	jae    102eae <page_init+0x185>
        maxpa = KMEMSIZE;
  102ea0:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102ea7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102eae:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eb1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eb4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102eb8:	c1 ea 0c             	shr    $0xc,%edx
  102ebb:	a3 80 ce 11 00       	mov    %eax,0x11ce80
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102ec0:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102ec7:	b8 28 cf 11 00       	mov    $0x11cf28,%eax
  102ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ecf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102ed2:	01 d0                	add    %edx,%eax
  102ed4:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102ed7:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102eda:	ba 00 00 00 00       	mov    $0x0,%edx
  102edf:	f7 75 c0             	divl   -0x40(%ebp)
  102ee2:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ee5:	29 d0                	sub    %edx,%eax
  102ee7:	a3 18 cf 11 00       	mov    %eax,0x11cf18

    for (i = 0; i < npage; i ++) {
  102eec:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102ef3:	eb 2f                	jmp    102f24 <page_init+0x1fb>
        SetPageReserved(pages + i);
  102ef5:	8b 0d 18 cf 11 00    	mov    0x11cf18,%ecx
  102efb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102efe:	89 d0                	mov    %edx,%eax
  102f00:	c1 e0 02             	shl    $0x2,%eax
  102f03:	01 d0                	add    %edx,%eax
  102f05:	c1 e0 02             	shl    $0x2,%eax
  102f08:	01 c8                	add    %ecx,%eax
  102f0a:	83 c0 04             	add    $0x4,%eax
  102f0d:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102f14:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102f17:	8b 45 90             	mov    -0x70(%ebp),%eax
  102f1a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102f1d:	0f ab 10             	bts    %edx,(%eax)
}
  102f20:	90                   	nop
    for (i = 0; i < npage; i ++) {
  102f21:	ff 45 dc             	incl   -0x24(%ebp)
  102f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f27:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  102f2c:	39 c2                	cmp    %eax,%edx
  102f2e:	72 c5                	jb     102ef5 <page_init+0x1cc>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102f30:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  102f36:	89 d0                	mov    %edx,%eax
  102f38:	c1 e0 02             	shl    $0x2,%eax
  102f3b:	01 d0                	add    %edx,%eax
  102f3d:	c1 e0 02             	shl    $0x2,%eax
  102f40:	89 c2                	mov    %eax,%edx
  102f42:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  102f47:	01 d0                	add    %edx,%eax
  102f49:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102f4c:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  102f53:	77 23                	ja     102f78 <page_init+0x24f>
  102f55:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f58:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f5c:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  102f63:	00 
  102f64:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102f6b:	00 
  102f6c:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  102f73:	e8 ae d4 ff ff       	call   100426 <__panic>
  102f78:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102f7b:	05 00 00 00 40       	add    $0x40000000,%eax
  102f80:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102f83:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102f8a:	e9 4b 01 00 00       	jmp    1030da <page_init+0x3b1>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102f8f:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102f92:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102f95:	89 d0                	mov    %edx,%eax
  102f97:	c1 e0 02             	shl    $0x2,%eax
  102f9a:	01 d0                	add    %edx,%eax
  102f9c:	c1 e0 02             	shl    $0x2,%eax
  102f9f:	01 c8                	add    %ecx,%eax
  102fa1:	8b 50 08             	mov    0x8(%eax),%edx
  102fa4:	8b 40 04             	mov    0x4(%eax),%eax
  102fa7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102faa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fad:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fb0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fb3:	89 d0                	mov    %edx,%eax
  102fb5:	c1 e0 02             	shl    $0x2,%eax
  102fb8:	01 d0                	add    %edx,%eax
  102fba:	c1 e0 02             	shl    $0x2,%eax
  102fbd:	01 c8                	add    %ecx,%eax
  102fbf:	8b 48 0c             	mov    0xc(%eax),%ecx
  102fc2:	8b 58 10             	mov    0x10(%eax),%ebx
  102fc5:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fc8:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fcb:	01 c8                	add    %ecx,%eax
  102fcd:	11 da                	adc    %ebx,%edx
  102fcf:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102fd2:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102fd5:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102fd8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102fdb:	89 d0                	mov    %edx,%eax
  102fdd:	c1 e0 02             	shl    $0x2,%eax
  102fe0:	01 d0                	add    %edx,%eax
  102fe2:	c1 e0 02             	shl    $0x2,%eax
  102fe5:	01 c8                	add    %ecx,%eax
  102fe7:	83 c0 14             	add    $0x14,%eax
  102fea:	8b 00                	mov    (%eax),%eax
  102fec:	83 f8 01             	cmp    $0x1,%eax
  102fef:	0f 85 e2 00 00 00    	jne    1030d7 <page_init+0x3ae>
            if (begin < freemem) {
  102ff5:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ff8:	ba 00 00 00 00       	mov    $0x0,%edx
  102ffd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  103000:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103003:	19 d1                	sbb    %edx,%ecx
  103005:	73 0d                	jae    103014 <page_init+0x2eb>
                begin = freemem;
  103007:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10300a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10300d:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  103014:	ba 00 00 00 38       	mov    $0x38000000,%edx
  103019:	b8 00 00 00 00       	mov    $0x0,%eax
  10301e:	3b 55 c8             	cmp    -0x38(%ebp),%edx
  103021:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103024:	73 0e                	jae    103034 <page_init+0x30b>
                end = KMEMSIZE;
  103026:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10302d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  103034:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103037:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10303a:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10303d:	89 d0                	mov    %edx,%eax
  10303f:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  103042:	0f 83 8f 00 00 00    	jae    1030d7 <page_init+0x3ae>
                begin = ROUNDUP(begin, PGSIZE);
  103048:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  10304f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103052:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103055:	01 d0                	add    %edx,%eax
  103057:	48                   	dec    %eax
  103058:	89 45 ac             	mov    %eax,-0x54(%ebp)
  10305b:	8b 45 ac             	mov    -0x54(%ebp),%eax
  10305e:	ba 00 00 00 00       	mov    $0x0,%edx
  103063:	f7 75 b0             	divl   -0x50(%ebp)
  103066:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103069:	29 d0                	sub    %edx,%eax
  10306b:	ba 00 00 00 00       	mov    $0x0,%edx
  103070:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103073:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  103076:	8b 45 c8             	mov    -0x38(%ebp),%eax
  103079:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10307c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10307f:	ba 00 00 00 00       	mov    $0x0,%edx
  103084:	89 c3                	mov    %eax,%ebx
  103086:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  10308c:	89 de                	mov    %ebx,%esi
  10308e:	89 d0                	mov    %edx,%eax
  103090:	83 e0 00             	and    $0x0,%eax
  103093:	89 c7                	mov    %eax,%edi
  103095:	89 75 c8             	mov    %esi,-0x38(%ebp)
  103098:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  10309b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10309e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030a1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1030a4:	89 d0                	mov    %edx,%eax
  1030a6:	1b 45 cc             	sbb    -0x34(%ebp),%eax
  1030a9:	73 2c                	jae    1030d7 <page_init+0x3ae>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1030ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1030ae:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1030b1:	2b 45 d0             	sub    -0x30(%ebp),%eax
  1030b4:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  1030b7:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1030bb:	c1 ea 0c             	shr    $0xc,%edx
  1030be:	89 c3                	mov    %eax,%ebx
  1030c0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030c3:	89 04 24             	mov    %eax,(%esp)
  1030c6:	e8 ad f8 ff ff       	call   102978 <pa2page>
  1030cb:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1030cf:	89 04 24             	mov    %eax,(%esp)
  1030d2:	e8 8c fb ff ff       	call   102c63 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  1030d7:	ff 45 dc             	incl   -0x24(%ebp)
  1030da:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1030dd:	8b 00                	mov    (%eax),%eax
  1030df:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1030e2:	0f 8c a7 fe ff ff    	jl     102f8f <page_init+0x266>
                }
            }
        }
    }
}
  1030e8:	90                   	nop
  1030e9:	90                   	nop
  1030ea:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1030f0:	5b                   	pop    %ebx
  1030f1:	5e                   	pop    %esi
  1030f2:	5f                   	pop    %edi
  1030f3:	5d                   	pop    %ebp
  1030f4:	c3                   	ret    

001030f5 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  1030f5:	f3 0f 1e fb          	endbr32 
  1030f9:	55                   	push   %ebp
  1030fa:	89 e5                	mov    %esp,%ebp
  1030fc:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  1030ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103102:	33 45 14             	xor    0x14(%ebp),%eax
  103105:	25 ff 0f 00 00       	and    $0xfff,%eax
  10310a:	85 c0                	test   %eax,%eax
  10310c:	74 24                	je     103132 <boot_map_segment+0x3d>
  10310e:	c7 44 24 0c 16 69 10 	movl   $0x106916,0xc(%esp)
  103115:	00 
  103116:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10311d:	00 
  10311e:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  103125:	00 
  103126:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10312d:	e8 f4 d2 ff ff       	call   100426 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103132:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  103139:	8b 45 0c             	mov    0xc(%ebp),%eax
  10313c:	25 ff 0f 00 00       	and    $0xfff,%eax
  103141:	89 c2                	mov    %eax,%edx
  103143:	8b 45 10             	mov    0x10(%ebp),%eax
  103146:	01 c2                	add    %eax,%edx
  103148:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10314b:	01 d0                	add    %edx,%eax
  10314d:	48                   	dec    %eax
  10314e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103151:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103154:	ba 00 00 00 00       	mov    $0x0,%edx
  103159:	f7 75 f0             	divl   -0x10(%ebp)
  10315c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10315f:	29 d0                	sub    %edx,%eax
  103161:	c1 e8 0c             	shr    $0xc,%eax
  103164:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  103167:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10316d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103170:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103175:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  103178:	8b 45 14             	mov    0x14(%ebp),%eax
  10317b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10317e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103186:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  103189:	eb 68                	jmp    1031f3 <boot_map_segment+0xfe>
        pte_t *ptep = get_pte(pgdir, la, 1);
  10318b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103192:	00 
  103193:	8b 45 0c             	mov    0xc(%ebp),%eax
  103196:	89 44 24 04          	mov    %eax,0x4(%esp)
  10319a:	8b 45 08             	mov    0x8(%ebp),%eax
  10319d:	89 04 24             	mov    %eax,(%esp)
  1031a0:	e8 8a 01 00 00       	call   10332f <get_pte>
  1031a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1031a8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1031ac:	75 24                	jne    1031d2 <boot_map_segment+0xdd>
  1031ae:	c7 44 24 0c 42 69 10 	movl   $0x106942,0xc(%esp)
  1031b5:	00 
  1031b6:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1031bd:	00 
  1031be:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  1031c5:	00 
  1031c6:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1031cd:	e8 54 d2 ff ff       	call   100426 <__panic>
        *ptep = pa | PTE_P | perm;
  1031d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1031d5:	0b 45 18             	or     0x18(%ebp),%eax
  1031d8:	83 c8 01             	or     $0x1,%eax
  1031db:	89 c2                	mov    %eax,%edx
  1031dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1031e0:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1031e2:	ff 4d f4             	decl   -0xc(%ebp)
  1031e5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1031ec:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1031f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031f7:	75 92                	jne    10318b <boot_map_segment+0x96>
    }
}
  1031f9:	90                   	nop
  1031fa:	90                   	nop
  1031fb:	c9                   	leave  
  1031fc:	c3                   	ret    

001031fd <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1031fd:	f3 0f 1e fb          	endbr32 
  103201:	55                   	push   %ebp
  103202:	89 e5                	mov    %esp,%ebp
  103204:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  103207:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10320e:	e8 74 fa ff ff       	call   102c87 <alloc_pages>
  103213:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  103216:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10321a:	75 1c                	jne    103238 <boot_alloc_page+0x3b>
        panic("boot_alloc_page failed.\n");
  10321c:	c7 44 24 08 4f 69 10 	movl   $0x10694f,0x8(%esp)
  103223:	00 
  103224:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  10322b:	00 
  10322c:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103233:	e8 ee d1 ff ff       	call   100426 <__panic>
    }
    return page2kva(p);
  103238:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10323b:	89 04 24             	mov    %eax,(%esp)
  10323e:	e8 84 f7 ff ff       	call   1029c7 <page2kva>
}
  103243:	c9                   	leave  
  103244:	c3                   	ret    

00103245 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103245:	f3 0f 1e fb          	endbr32 
  103249:	55                   	push   %ebp
  10324a:	89 e5                	mov    %esp,%ebp
  10324c:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10324f:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103254:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103257:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10325e:	77 23                	ja     103283 <pmm_init+0x3e>
  103260:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103263:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103267:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  10326e:	00 
  10326f:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103276:	00 
  103277:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10327e:	e8 a3 d1 ff ff       	call   100426 <__panic>
  103283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103286:	05 00 00 00 40       	add    $0x40000000,%eax
  10328b:	a3 14 cf 11 00       	mov    %eax,0x11cf14
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  103290:	e8 96 f9 ff ff       	call   102c2b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103295:	e8 8f fa ff ff       	call   102d29 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10329a:	e8 f3 03 00 00       	call   103692 <check_alloc_page>

    check_pgdir();
  10329f:	e8 11 04 00 00       	call   1036b5 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1032a4:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1032ac:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  1032b3:	77 23                	ja     1032d8 <pmm_init+0x93>
  1032b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032b8:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1032bc:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  1032c3:	00 
  1032c4:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1032cb:	00 
  1032cc:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1032d3:	e8 4e d1 ff ff       	call   100426 <__panic>
  1032d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1032db:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1032e1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032e6:	05 ac 0f 00 00       	add    $0xfac,%eax
  1032eb:	83 ca 03             	or     $0x3,%edx
  1032ee:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1032f0:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1032f5:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1032fc:	00 
  1032fd:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103304:	00 
  103305:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  10330c:	38 
  10330d:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  103314:	c0 
  103315:	89 04 24             	mov    %eax,(%esp)
  103318:	e8 d8 fd ff ff       	call   1030f5 <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10331d:	e8 1b f8 ff ff       	call   102b3d <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  103322:	e8 2e 0a 00 00       	call   103d55 <check_boot_pgdir>

    print_pgdir();
  103327:	e8 b3 0e 00 00       	call   1041df <print_pgdir>

}
  10332c:	90                   	nop
  10332d:	c9                   	leave  
  10332e:	c3                   	ret    

0010332f <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  10332f:	f3 0f 1e fb          	endbr32 
  103333:	55                   	push   %ebp
  103334:	89 e5                	mov    %esp,%ebp
  103336:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  103339:	8b 45 0c             	mov    0xc(%ebp),%eax
  10333c:	c1 e8 16             	shr    $0x16,%eax
  10333f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103346:	8b 45 08             	mov    0x8(%ebp),%eax
  103349:	01 d0                	add    %edx,%eax
  10334b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!(*pdep & PTE_P)) {
  10334e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103351:	8b 00                	mov    (%eax),%eax
  103353:	83 e0 01             	and    $0x1,%eax
  103356:	85 c0                	test   %eax,%eax
  103358:	0f 85 af 00 00 00    	jne    10340d <get_pte+0xde>
        struct Page *page;
        if (!create || (page = alloc_page()) == NULL) {
  10335e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103362:	74 15                	je     103379 <get_pte+0x4a>
  103364:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10336b:	e8 17 f9 ff ff       	call   102c87 <alloc_pages>
  103370:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103373:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103377:	75 0a                	jne    103383 <get_pte+0x54>
            return NULL;
  103379:	b8 00 00 00 00       	mov    $0x0,%eax
  10337e:	e9 e7 00 00 00       	jmp    10346a <get_pte+0x13b>
        }
        set_page_ref(page, 1);
  103383:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10338a:	00 
  10338b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10338e:	89 04 24             	mov    %eax,(%esp)
  103391:	e8 e5 f6 ff ff       	call   102a7b <set_page_ref>
        uintptr_t pa = page2pa(page);
  103396:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103399:	89 04 24             	mov    %eax,(%esp)
  10339c:	e8 c1 f5 ff ff       	call   102962 <page2pa>
  1033a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(pa), 0, PGSIZE);
  1033a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033a7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033ad:	c1 e8 0c             	shr    $0xc,%eax
  1033b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1033b3:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1033b8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1033bb:	72 23                	jb     1033e0 <get_pte+0xb1>
  1033bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033c0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1033c4:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  1033cb:	00 
  1033cc:	c7 44 24 04 72 01 00 	movl   $0x172,0x4(%esp)
  1033d3:	00 
  1033d4:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1033db:	e8 46 d0 ff ff       	call   100426 <__panic>
  1033e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033e3:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1033e8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1033ef:	00 
  1033f0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1033f7:	00 
  1033f8:	89 04 24             	mov    %eax,(%esp)
  1033fb:	e8 d3 24 00 00       	call   1058d3 <memset>
        *pdep = pa | PTE_U | PTE_W | PTE_P;
  103400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103403:	83 c8 07             	or     $0x7,%eax
  103406:	89 c2                	mov    %eax,%edx
  103408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10340b:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
  10340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103410:	8b 00                	mov    (%eax),%eax
  103412:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103417:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10341a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10341d:	c1 e8 0c             	shr    $0xc,%eax
  103420:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103423:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103428:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  10342b:	72 23                	jb     103450 <get_pte+0x121>
  10342d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103430:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103434:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  10343b:	00 
  10343c:	c7 44 24 04 75 01 00 	movl   $0x175,0x4(%esp)
  103443:	00 
  103444:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10344b:	e8 d6 cf ff ff       	call   100426 <__panic>
  103450:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103453:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103458:	89 c2                	mov    %eax,%edx
  10345a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345d:	c1 e8 0c             	shr    $0xc,%eax
  103460:	25 ff 03 00 00       	and    $0x3ff,%eax
  103465:	c1 e0 02             	shl    $0x2,%eax
  103468:	01 d0                	add    %edx,%eax
}
  10346a:	c9                   	leave  
  10346b:	c3                   	ret    

0010346c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10346c:	f3 0f 1e fb          	endbr32 
  103470:	55                   	push   %ebp
  103471:	89 e5                	mov    %esp,%ebp
  103473:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103476:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10347d:	00 
  10347e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103481:	89 44 24 04          	mov    %eax,0x4(%esp)
  103485:	8b 45 08             	mov    0x8(%ebp),%eax
  103488:	89 04 24             	mov    %eax,(%esp)
  10348b:	e8 9f fe ff ff       	call   10332f <get_pte>
  103490:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103493:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103497:	74 08                	je     1034a1 <get_page+0x35>
        *ptep_store = ptep;
  103499:	8b 45 10             	mov    0x10(%ebp),%eax
  10349c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10349f:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  1034a1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1034a5:	74 1b                	je     1034c2 <get_page+0x56>
  1034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034aa:	8b 00                	mov    (%eax),%eax
  1034ac:	83 e0 01             	and    $0x1,%eax
  1034af:	85 c0                	test   %eax,%eax
  1034b1:	74 0f                	je     1034c2 <get_page+0x56>
        return pte2page(*ptep);
  1034b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034b6:	8b 00                	mov    (%eax),%eax
  1034b8:	89 04 24             	mov    %eax,(%esp)
  1034bb:	e8 5b f5 ff ff       	call   102a1b <pte2page>
  1034c0:	eb 05                	jmp    1034c7 <get_page+0x5b>
    }
    return NULL;
  1034c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1034c7:	c9                   	leave  
  1034c8:	c3                   	ret    

001034c9 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1034c9:	55                   	push   %ebp
  1034ca:	89 e5                	mov    %esp,%ebp
  1034cc:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  1034cf:	8b 45 10             	mov    0x10(%ebp),%eax
  1034d2:	8b 00                	mov    (%eax),%eax
  1034d4:	83 e0 01             	and    $0x1,%eax
  1034d7:	85 c0                	test   %eax,%eax
  1034d9:	74 4d                	je     103528 <page_remove_pte+0x5f>
        struct Page *page = pte2page(*ptep);
  1034db:	8b 45 10             	mov    0x10(%ebp),%eax
  1034de:	8b 00                	mov    (%eax),%eax
  1034e0:	89 04 24             	mov    %eax,(%esp)
  1034e3:	e8 33 f5 ff ff       	call   102a1b <pte2page>
  1034e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (page_ref_dec(page) == 0) {
  1034eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034ee:	89 04 24             	mov    %eax,(%esp)
  1034f1:	e8 aa f5 ff ff       	call   102aa0 <page_ref_dec>
  1034f6:	85 c0                	test   %eax,%eax
  1034f8:	75 13                	jne    10350d <page_remove_pte+0x44>
            free_page(page);
  1034fa:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103501:	00 
  103502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103505:	89 04 24             	mov    %eax,(%esp)
  103508:	e8 b6 f7 ff ff       	call   102cc3 <free_pages>
        }
        *ptep = 0;
  10350d:	8b 45 10             	mov    0x10(%ebp),%eax
  103510:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
  103516:	8b 45 0c             	mov    0xc(%ebp),%eax
  103519:	89 44 24 04          	mov    %eax,0x4(%esp)
  10351d:	8b 45 08             	mov    0x8(%ebp),%eax
  103520:	89 04 24             	mov    %eax,(%esp)
  103523:	e8 09 01 00 00       	call   103631 <tlb_invalidate>
    }
}
  103528:	90                   	nop
  103529:	c9                   	leave  
  10352a:	c3                   	ret    

0010352b <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10352b:	f3 0f 1e fb          	endbr32 
  10352f:	55                   	push   %ebp
  103530:	89 e5                	mov    %esp,%ebp
  103532:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103535:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10353c:	00 
  10353d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103540:	89 44 24 04          	mov    %eax,0x4(%esp)
  103544:	8b 45 08             	mov    0x8(%ebp),%eax
  103547:	89 04 24             	mov    %eax,(%esp)
  10354a:	e8 e0 fd ff ff       	call   10332f <get_pte>
  10354f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  103552:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103556:	74 19                	je     103571 <page_remove+0x46>
        page_remove_pte(pgdir, la, ptep);
  103558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10355b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10355f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103562:	89 44 24 04          	mov    %eax,0x4(%esp)
  103566:	8b 45 08             	mov    0x8(%ebp),%eax
  103569:	89 04 24             	mov    %eax,(%esp)
  10356c:	e8 58 ff ff ff       	call   1034c9 <page_remove_pte>
    }
}
  103571:	90                   	nop
  103572:	c9                   	leave  
  103573:	c3                   	ret    

00103574 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  103574:	f3 0f 1e fb          	endbr32 
  103578:	55                   	push   %ebp
  103579:	89 e5                	mov    %esp,%ebp
  10357b:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  10357e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103585:	00 
  103586:	8b 45 10             	mov    0x10(%ebp),%eax
  103589:	89 44 24 04          	mov    %eax,0x4(%esp)
  10358d:	8b 45 08             	mov    0x8(%ebp),%eax
  103590:	89 04 24             	mov    %eax,(%esp)
  103593:	e8 97 fd ff ff       	call   10332f <get_pte>
  103598:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10359b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10359f:	75 0a                	jne    1035ab <page_insert+0x37>
        return -E_NO_MEM;
  1035a1:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  1035a6:	e9 84 00 00 00       	jmp    10362f <page_insert+0xbb>
    }
    page_ref_inc(page);
  1035ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ae:	89 04 24             	mov    %eax,(%esp)
  1035b1:	e8 d3 f4 ff ff       	call   102a89 <page_ref_inc>
    if (*ptep & PTE_P) {
  1035b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035b9:	8b 00                	mov    (%eax),%eax
  1035bb:	83 e0 01             	and    $0x1,%eax
  1035be:	85 c0                	test   %eax,%eax
  1035c0:	74 3e                	je     103600 <page_insert+0x8c>
        struct Page *p = pte2page(*ptep);
  1035c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035c5:	8b 00                	mov    (%eax),%eax
  1035c7:	89 04 24             	mov    %eax,(%esp)
  1035ca:	e8 4c f4 ff ff       	call   102a1b <pte2page>
  1035cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1035d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1035d8:	75 0d                	jne    1035e7 <page_insert+0x73>
            page_ref_dec(page);
  1035da:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035dd:	89 04 24             	mov    %eax,(%esp)
  1035e0:	e8 bb f4 ff ff       	call   102aa0 <page_ref_dec>
  1035e5:	eb 19                	jmp    103600 <page_insert+0x8c>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1035e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035ea:	89 44 24 08          	mov    %eax,0x8(%esp)
  1035ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1035f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035f5:	8b 45 08             	mov    0x8(%ebp),%eax
  1035f8:	89 04 24             	mov    %eax,(%esp)
  1035fb:	e8 c9 fe ff ff       	call   1034c9 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  103600:	8b 45 0c             	mov    0xc(%ebp),%eax
  103603:	89 04 24             	mov    %eax,(%esp)
  103606:	e8 57 f3 ff ff       	call   102962 <page2pa>
  10360b:	0b 45 14             	or     0x14(%ebp),%eax
  10360e:	83 c8 01             	or     $0x1,%eax
  103611:	89 c2                	mov    %eax,%edx
  103613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103616:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  103618:	8b 45 10             	mov    0x10(%ebp),%eax
  10361b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10361f:	8b 45 08             	mov    0x8(%ebp),%eax
  103622:	89 04 24             	mov    %eax,(%esp)
  103625:	e8 07 00 00 00       	call   103631 <tlb_invalidate>
    return 0;
  10362a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10362f:	c9                   	leave  
  103630:	c3                   	ret    

00103631 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103631:	f3 0f 1e fb          	endbr32 
  103635:	55                   	push   %ebp
  103636:	89 e5                	mov    %esp,%ebp
  103638:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10363b:	0f 20 d8             	mov    %cr3,%eax
  10363e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103641:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103644:	8b 45 08             	mov    0x8(%ebp),%eax
  103647:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10364a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103651:	77 23                	ja     103676 <tlb_invalidate+0x45>
  103653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103656:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10365a:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  103661:	00 
  103662:	c7 44 24 04 d7 01 00 	movl   $0x1d7,0x4(%esp)
  103669:	00 
  10366a:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103671:	e8 b0 cd ff ff       	call   100426 <__panic>
  103676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103679:	05 00 00 00 40       	add    $0x40000000,%eax
  10367e:	39 d0                	cmp    %edx,%eax
  103680:	75 0d                	jne    10368f <tlb_invalidate+0x5e>
        invlpg((void *)la);
  103682:	8b 45 0c             	mov    0xc(%ebp),%eax
  103685:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  103688:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10368b:	0f 01 38             	invlpg (%eax)
}
  10368e:	90                   	nop
    }
}
  10368f:	90                   	nop
  103690:	c9                   	leave  
  103691:	c3                   	ret    

00103692 <check_alloc_page>:

static void
check_alloc_page(void) {
  103692:	f3 0f 1e fb          	endbr32 
  103696:	55                   	push   %ebp
  103697:	89 e5                	mov    %esp,%ebp
  103699:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10369c:	a1 10 cf 11 00       	mov    0x11cf10,%eax
  1036a1:	8b 40 18             	mov    0x18(%eax),%eax
  1036a4:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  1036a6:	c7 04 24 68 69 10 00 	movl   $0x106968,(%esp)
  1036ad:	e8 08 cc ff ff       	call   1002ba <cprintf>
}
  1036b2:	90                   	nop
  1036b3:	c9                   	leave  
  1036b4:	c3                   	ret    

001036b5 <check_pgdir>:

static void
check_pgdir(void) {
  1036b5:	f3 0f 1e fb          	endbr32 
  1036b9:	55                   	push   %ebp
  1036ba:	89 e5                	mov    %esp,%ebp
  1036bc:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1036bf:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  1036c4:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1036c9:	76 24                	jbe    1036ef <check_pgdir+0x3a>
  1036cb:	c7 44 24 0c 87 69 10 	movl   $0x106987,0xc(%esp)
  1036d2:	00 
  1036d3:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1036da:	00 
  1036db:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  1036e2:	00 
  1036e3:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1036ea:	e8 37 cd ff ff       	call   100426 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1036ef:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1036f4:	85 c0                	test   %eax,%eax
  1036f6:	74 0e                	je     103706 <check_pgdir+0x51>
  1036f8:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1036fd:	25 ff 0f 00 00       	and    $0xfff,%eax
  103702:	85 c0                	test   %eax,%eax
  103704:	74 24                	je     10372a <check_pgdir+0x75>
  103706:	c7 44 24 0c a4 69 10 	movl   $0x1069a4,0xc(%esp)
  10370d:	00 
  10370e:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103715:	00 
  103716:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  10371d:	00 
  10371e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103725:	e8 fc cc ff ff       	call   100426 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  10372a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10372f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103736:	00 
  103737:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10373e:	00 
  10373f:	89 04 24             	mov    %eax,(%esp)
  103742:	e8 25 fd ff ff       	call   10346c <get_page>
  103747:	85 c0                	test   %eax,%eax
  103749:	74 24                	je     10376f <check_pgdir+0xba>
  10374b:	c7 44 24 0c dc 69 10 	movl   $0x1069dc,0xc(%esp)
  103752:	00 
  103753:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10375a:	00 
  10375b:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  103762:	00 
  103763:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10376a:	e8 b7 cc ff ff       	call   100426 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  10376f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103776:	e8 0c f5 ff ff       	call   102c87 <alloc_pages>
  10377b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  10377e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103783:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10378a:	00 
  10378b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103792:	00 
  103793:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103796:	89 54 24 04          	mov    %edx,0x4(%esp)
  10379a:	89 04 24             	mov    %eax,(%esp)
  10379d:	e8 d2 fd ff ff       	call   103574 <page_insert>
  1037a2:	85 c0                	test   %eax,%eax
  1037a4:	74 24                	je     1037ca <check_pgdir+0x115>
  1037a6:	c7 44 24 0c 04 6a 10 	movl   $0x106a04,0xc(%esp)
  1037ad:	00 
  1037ae:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1037b5:	00 
  1037b6:	c7 44 24 04 ea 01 00 	movl   $0x1ea,0x4(%esp)
  1037bd:	00 
  1037be:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1037c5:	e8 5c cc ff ff       	call   100426 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1037ca:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1037cf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037d6:	00 
  1037d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1037de:	00 
  1037df:	89 04 24             	mov    %eax,(%esp)
  1037e2:	e8 48 fb ff ff       	call   10332f <get_pte>
  1037e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1037ea:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1037ee:	75 24                	jne    103814 <check_pgdir+0x15f>
  1037f0:	c7 44 24 0c 30 6a 10 	movl   $0x106a30,0xc(%esp)
  1037f7:	00 
  1037f8:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1037ff:	00 
  103800:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103807:	00 
  103808:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10380f:	e8 12 cc ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  103814:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103817:	8b 00                	mov    (%eax),%eax
  103819:	89 04 24             	mov    %eax,(%esp)
  10381c:	e8 fa f1 ff ff       	call   102a1b <pte2page>
  103821:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103824:	74 24                	je     10384a <check_pgdir+0x195>
  103826:	c7 44 24 0c 5d 6a 10 	movl   $0x106a5d,0xc(%esp)
  10382d:	00 
  10382e:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103835:	00 
  103836:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  10383d:	00 
  10383e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103845:	e8 dc cb ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 1);
  10384a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10384d:	89 04 24             	mov    %eax,(%esp)
  103850:	e8 1c f2 ff ff       	call   102a71 <page_ref>
  103855:	83 f8 01             	cmp    $0x1,%eax
  103858:	74 24                	je     10387e <check_pgdir+0x1c9>
  10385a:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  103861:	00 
  103862:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103869:	00 
  10386a:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  103871:	00 
  103872:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103879:	e8 a8 cb ff ff       	call   100426 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  10387e:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103883:	8b 00                	mov    (%eax),%eax
  103885:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10388a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10388d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103890:	c1 e8 0c             	shr    $0xc,%eax
  103893:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103896:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  10389b:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10389e:	72 23                	jb     1038c3 <check_pgdir+0x20e>
  1038a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038a3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1038a7:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  1038ae:	00 
  1038af:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  1038b6:	00 
  1038b7:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1038be:	e8 63 cb ff ff       	call   100426 <__panic>
  1038c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1038c6:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1038cb:	83 c0 04             	add    $0x4,%eax
  1038ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1038d1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1038d6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1038dd:	00 
  1038de:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1038e5:	00 
  1038e6:	89 04 24             	mov    %eax,(%esp)
  1038e9:	e8 41 fa ff ff       	call   10332f <get_pte>
  1038ee:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1038f1:	74 24                	je     103917 <check_pgdir+0x262>
  1038f3:	c7 44 24 0c 88 6a 10 	movl   $0x106a88,0xc(%esp)
  1038fa:	00 
  1038fb:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103902:	00 
  103903:	c7 44 24 04 f2 01 00 	movl   $0x1f2,0x4(%esp)
  10390a:	00 
  10390b:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103912:	e8 0f cb ff ff       	call   100426 <__panic>

    p2 = alloc_page();
  103917:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10391e:	e8 64 f3 ff ff       	call   102c87 <alloc_pages>
  103923:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103926:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  10392b:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  103932:	00 
  103933:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  10393a:	00 
  10393b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10393e:	89 54 24 04          	mov    %edx,0x4(%esp)
  103942:	89 04 24             	mov    %eax,(%esp)
  103945:	e8 2a fc ff ff       	call   103574 <page_insert>
  10394a:	85 c0                	test   %eax,%eax
  10394c:	74 24                	je     103972 <check_pgdir+0x2bd>
  10394e:	c7 44 24 0c b0 6a 10 	movl   $0x106ab0,0xc(%esp)
  103955:	00 
  103956:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10395d:	00 
  10395e:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103965:	00 
  103966:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10396d:	e8 b4 ca ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103972:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103977:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10397e:	00 
  10397f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103986:	00 
  103987:	89 04 24             	mov    %eax,(%esp)
  10398a:	e8 a0 f9 ff ff       	call   10332f <get_pte>
  10398f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103992:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103996:	75 24                	jne    1039bc <check_pgdir+0x307>
  103998:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  10399f:	00 
  1039a0:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1039a7:	00 
  1039a8:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  1039af:	00 
  1039b0:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1039b7:	e8 6a ca ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_U);
  1039bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039bf:	8b 00                	mov    (%eax),%eax
  1039c1:	83 e0 04             	and    $0x4,%eax
  1039c4:	85 c0                	test   %eax,%eax
  1039c6:	75 24                	jne    1039ec <check_pgdir+0x337>
  1039c8:	c7 44 24 0c 18 6b 10 	movl   $0x106b18,0xc(%esp)
  1039cf:	00 
  1039d0:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  1039d7:	00 
  1039d8:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  1039df:	00 
  1039e0:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  1039e7:	e8 3a ca ff ff       	call   100426 <__panic>
    assert(*ptep & PTE_W);
  1039ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1039ef:	8b 00                	mov    (%eax),%eax
  1039f1:	83 e0 02             	and    $0x2,%eax
  1039f4:	85 c0                	test   %eax,%eax
  1039f6:	75 24                	jne    103a1c <check_pgdir+0x367>
  1039f8:	c7 44 24 0c 26 6b 10 	movl   $0x106b26,0xc(%esp)
  1039ff:	00 
  103a00:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a07:	00 
  103a08:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103a0f:	00 
  103a10:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a17:	e8 0a ca ff ff       	call   100426 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103a1c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a21:	8b 00                	mov    (%eax),%eax
  103a23:	83 e0 04             	and    $0x4,%eax
  103a26:	85 c0                	test   %eax,%eax
  103a28:	75 24                	jne    103a4e <check_pgdir+0x399>
  103a2a:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  103a31:	00 
  103a32:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a39:	00 
  103a3a:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  103a41:	00 
  103a42:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a49:	e8 d8 c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 1);
  103a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a51:	89 04 24             	mov    %eax,(%esp)
  103a54:	e8 18 f0 ff ff       	call   102a71 <page_ref>
  103a59:	83 f8 01             	cmp    $0x1,%eax
  103a5c:	74 24                	je     103a82 <check_pgdir+0x3cd>
  103a5e:	c7 44 24 0c 4a 6b 10 	movl   $0x106b4a,0xc(%esp)
  103a65:	00 
  103a66:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103a6d:	00 
  103a6e:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  103a75:	00 
  103a76:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103a7d:	e8 a4 c9 ff ff       	call   100426 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  103a82:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103a87:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103a8e:	00 
  103a8f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103a96:	00 
  103a97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103a9a:	89 54 24 04          	mov    %edx,0x4(%esp)
  103a9e:	89 04 24             	mov    %eax,(%esp)
  103aa1:	e8 ce fa ff ff       	call   103574 <page_insert>
  103aa6:	85 c0                	test   %eax,%eax
  103aa8:	74 24                	je     103ace <check_pgdir+0x419>
  103aaa:	c7 44 24 0c 5c 6b 10 	movl   $0x106b5c,0xc(%esp)
  103ab1:	00 
  103ab2:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103ab9:	00 
  103aba:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103ac1:	00 
  103ac2:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ac9:	e8 58 c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p1) == 2);
  103ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ad1:	89 04 24             	mov    %eax,(%esp)
  103ad4:	e8 98 ef ff ff       	call   102a71 <page_ref>
  103ad9:	83 f8 02             	cmp    $0x2,%eax
  103adc:	74 24                	je     103b02 <check_pgdir+0x44d>
  103ade:	c7 44 24 0c 88 6b 10 	movl   $0x106b88,0xc(%esp)
  103ae5:	00 
  103ae6:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103aed:	00 
  103aee:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
  103af5:	00 
  103af6:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103afd:	e8 24 c9 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103b02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b05:	89 04 24             	mov    %eax,(%esp)
  103b08:	e8 64 ef ff ff       	call   102a71 <page_ref>
  103b0d:	85 c0                	test   %eax,%eax
  103b0f:	74 24                	je     103b35 <check_pgdir+0x480>
  103b11:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103b18:	00 
  103b19:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103b20:	00 
  103b21:	c7 44 24 04 fe 01 00 	movl   $0x1fe,0x4(%esp)
  103b28:	00 
  103b29:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b30:	e8 f1 c8 ff ff       	call   100426 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103b35:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103b3a:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103b41:	00 
  103b42:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b49:	00 
  103b4a:	89 04 24             	mov    %eax,(%esp)
  103b4d:	e8 dd f7 ff ff       	call   10332f <get_pte>
  103b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103b59:	75 24                	jne    103b7f <check_pgdir+0x4ca>
  103b5b:	c7 44 24 0c e8 6a 10 	movl   $0x106ae8,0xc(%esp)
  103b62:	00 
  103b63:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103b6a:	00 
  103b6b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103b72:	00 
  103b73:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103b7a:	e8 a7 c8 ff ff       	call   100426 <__panic>
    assert(pte2page(*ptep) == p1);
  103b7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103b82:	8b 00                	mov    (%eax),%eax
  103b84:	89 04 24             	mov    %eax,(%esp)
  103b87:	e8 8f ee ff ff       	call   102a1b <pte2page>
  103b8c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103b8f:	74 24                	je     103bb5 <check_pgdir+0x500>
  103b91:	c7 44 24 0c 5d 6a 10 	movl   $0x106a5d,0xc(%esp)
  103b98:	00 
  103b99:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103ba0:	00 
  103ba1:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103ba8:	00 
  103ba9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103bb0:	e8 71 c8 ff ff       	call   100426 <__panic>
    assert((*ptep & PTE_U) == 0);
  103bb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103bb8:	8b 00                	mov    (%eax),%eax
  103bba:	83 e0 04             	and    $0x4,%eax
  103bbd:	85 c0                	test   %eax,%eax
  103bbf:	74 24                	je     103be5 <check_pgdir+0x530>
  103bc1:	c7 44 24 0c ac 6b 10 	movl   $0x106bac,0xc(%esp)
  103bc8:	00 
  103bc9:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103bd0:	00 
  103bd1:	c7 44 24 04 01 02 00 	movl   $0x201,0x4(%esp)
  103bd8:	00 
  103bd9:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103be0:	e8 41 c8 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, 0x0);
  103be5:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103bea:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103bf1:	00 
  103bf2:	89 04 24             	mov    %eax,(%esp)
  103bf5:	e8 31 f9 ff ff       	call   10352b <page_remove>
    assert(page_ref(p1) == 1);
  103bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103bfd:	89 04 24             	mov    %eax,(%esp)
  103c00:	e8 6c ee ff ff       	call   102a71 <page_ref>
  103c05:	83 f8 01             	cmp    $0x1,%eax
  103c08:	74 24                	je     103c2e <check_pgdir+0x579>
  103c0a:	c7 44 24 0c 73 6a 10 	movl   $0x106a73,0xc(%esp)
  103c11:	00 
  103c12:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c19:	00 
  103c1a:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  103c21:	00 
  103c22:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c29:	e8 f8 c7 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103c2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c31:	89 04 24             	mov    %eax,(%esp)
  103c34:	e8 38 ee ff ff       	call   102a71 <page_ref>
  103c39:	85 c0                	test   %eax,%eax
  103c3b:	74 24                	je     103c61 <check_pgdir+0x5ac>
  103c3d:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103c44:	00 
  103c45:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c4c:	00 
  103c4d:	c7 44 24 04 05 02 00 	movl   $0x205,0x4(%esp)
  103c54:	00 
  103c55:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103c5c:	e8 c5 c7 ff ff       	call   100426 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103c61:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103c66:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103c6d:	00 
  103c6e:	89 04 24             	mov    %eax,(%esp)
  103c71:	e8 b5 f8 ff ff       	call   10352b <page_remove>
    assert(page_ref(p1) == 0);
  103c76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c79:	89 04 24             	mov    %eax,(%esp)
  103c7c:	e8 f0 ed ff ff       	call   102a71 <page_ref>
  103c81:	85 c0                	test   %eax,%eax
  103c83:	74 24                	je     103ca9 <check_pgdir+0x5f4>
  103c85:	c7 44 24 0c c1 6b 10 	movl   $0x106bc1,0xc(%esp)
  103c8c:	00 
  103c8d:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103c94:	00 
  103c95:	c7 44 24 04 08 02 00 	movl   $0x208,0x4(%esp)
  103c9c:	00 
  103c9d:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ca4:	e8 7d c7 ff ff       	call   100426 <__panic>
    assert(page_ref(p2) == 0);
  103ca9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103cac:	89 04 24             	mov    %eax,(%esp)
  103caf:	e8 bd ed ff ff       	call   102a71 <page_ref>
  103cb4:	85 c0                	test   %eax,%eax
  103cb6:	74 24                	je     103cdc <check_pgdir+0x627>
  103cb8:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103cbf:	00 
  103cc0:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103cc7:	00 
  103cc8:	c7 44 24 04 09 02 00 	movl   $0x209,0x4(%esp)
  103ccf:	00 
  103cd0:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103cd7:	e8 4a c7 ff ff       	call   100426 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103cdc:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ce1:	8b 00                	mov    (%eax),%eax
  103ce3:	89 04 24             	mov    %eax,(%esp)
  103ce6:	e8 6e ed ff ff       	call   102a59 <pde2page>
  103ceb:	89 04 24             	mov    %eax,(%esp)
  103cee:	e8 7e ed ff ff       	call   102a71 <page_ref>
  103cf3:	83 f8 01             	cmp    $0x1,%eax
  103cf6:	74 24                	je     103d1c <check_pgdir+0x667>
  103cf8:	c7 44 24 0c d4 6b 10 	movl   $0x106bd4,0xc(%esp)
  103cff:	00 
  103d00:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103d07:	00 
  103d08:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  103d0f:	00 
  103d10:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103d17:	e8 0a c7 ff ff       	call   100426 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103d1c:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d21:	8b 00                	mov    (%eax),%eax
  103d23:	89 04 24             	mov    %eax,(%esp)
  103d26:	e8 2e ed ff ff       	call   102a59 <pde2page>
  103d2b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103d32:	00 
  103d33:	89 04 24             	mov    %eax,(%esp)
  103d36:	e8 88 ef ff ff       	call   102cc3 <free_pages>
    boot_pgdir[0] = 0;
  103d3b:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103d40:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103d46:	c7 04 24 fb 6b 10 00 	movl   $0x106bfb,(%esp)
  103d4d:	e8 68 c5 ff ff       	call   1002ba <cprintf>
}
  103d52:	90                   	nop
  103d53:	c9                   	leave  
  103d54:	c3                   	ret    

00103d55 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103d55:	f3 0f 1e fb          	endbr32 
  103d59:	55                   	push   %ebp
  103d5a:	89 e5                	mov    %esp,%ebp
  103d5c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103d5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103d66:	e9 ca 00 00 00       	jmp    103e35 <check_boot_pgdir+0xe0>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103d71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d74:	c1 e8 0c             	shr    $0xc,%eax
  103d77:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103d7a:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103d7f:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103d82:	72 23                	jb     103da7 <check_boot_pgdir+0x52>
  103d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103d87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d8b:	c7 44 24 08 40 68 10 	movl   $0x106840,0x8(%esp)
  103d92:	00 
  103d93:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103d9a:	00 
  103d9b:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103da2:	e8 7f c6 ff ff       	call   100426 <__panic>
  103da7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103daa:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103daf:	89 c2                	mov    %eax,%edx
  103db1:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103db6:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103dbd:	00 
  103dbe:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dc2:	89 04 24             	mov    %eax,(%esp)
  103dc5:	e8 65 f5 ff ff       	call   10332f <get_pte>
  103dca:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103dcd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103dd1:	75 24                	jne    103df7 <check_boot_pgdir+0xa2>
  103dd3:	c7 44 24 0c 18 6c 10 	movl   $0x106c18,0xc(%esp)
  103dda:	00 
  103ddb:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103de2:	00 
  103de3:	c7 44 24 04 17 02 00 	movl   $0x217,0x4(%esp)
  103dea:	00 
  103deb:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103df2:	e8 2f c6 ff ff       	call   100426 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103df7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103dfa:	8b 00                	mov    (%eax),%eax
  103dfc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e01:	89 c2                	mov    %eax,%edx
  103e03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103e06:	39 c2                	cmp    %eax,%edx
  103e08:	74 24                	je     103e2e <check_boot_pgdir+0xd9>
  103e0a:	c7 44 24 0c 55 6c 10 	movl   $0x106c55,0xc(%esp)
  103e11:	00 
  103e12:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103e19:	00 
  103e1a:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103e21:	00 
  103e22:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103e29:	e8 f8 c5 ff ff       	call   100426 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103e2e:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103e35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103e38:	a1 80 ce 11 00       	mov    0x11ce80,%eax
  103e3d:	39 c2                	cmp    %eax,%edx
  103e3f:	0f 82 26 ff ff ff    	jb     103d6b <check_boot_pgdir+0x16>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103e45:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e4a:	05 ac 0f 00 00       	add    $0xfac,%eax
  103e4f:	8b 00                	mov    (%eax),%eax
  103e51:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103e56:	89 c2                	mov    %eax,%edx
  103e58:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103e5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103e60:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103e67:	77 23                	ja     103e8c <check_boot_pgdir+0x137>
  103e69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e6c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e70:	c7 44 24 08 e4 68 10 	movl   $0x1068e4,0x8(%esp)
  103e77:	00 
  103e78:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103e7f:	00 
  103e80:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103e87:	e8 9a c5 ff ff       	call   100426 <__panic>
  103e8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103e8f:	05 00 00 00 40       	add    $0x40000000,%eax
  103e94:	39 d0                	cmp    %edx,%eax
  103e96:	74 24                	je     103ebc <check_boot_pgdir+0x167>
  103e98:	c7 44 24 0c 6c 6c 10 	movl   $0x106c6c,0xc(%esp)
  103e9f:	00 
  103ea0:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103ea7:	00 
  103ea8:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103eaf:	00 
  103eb0:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103eb7:	e8 6a c5 ff ff       	call   100426 <__panic>

    assert(boot_pgdir[0] == 0);
  103ebc:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103ec1:	8b 00                	mov    (%eax),%eax
  103ec3:	85 c0                	test   %eax,%eax
  103ec5:	74 24                	je     103eeb <check_boot_pgdir+0x196>
  103ec7:	c7 44 24 0c a0 6c 10 	movl   $0x106ca0,0xc(%esp)
  103ece:	00 
  103ecf:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103ed6:	00 
  103ed7:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  103ede:	00 
  103edf:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ee6:	e8 3b c5 ff ff       	call   100426 <__panic>

    struct Page *p;
    p = alloc_page();
  103eeb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103ef2:	e8 90 ed ff ff       	call   102c87 <alloc_pages>
  103ef7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103efa:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103eff:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103f06:	00 
  103f07:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103f0e:	00 
  103f0f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103f12:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f16:	89 04 24             	mov    %eax,(%esp)
  103f19:	e8 56 f6 ff ff       	call   103574 <page_insert>
  103f1e:	85 c0                	test   %eax,%eax
  103f20:	74 24                	je     103f46 <check_boot_pgdir+0x1f1>
  103f22:	c7 44 24 0c b4 6c 10 	movl   $0x106cb4,0xc(%esp)
  103f29:	00 
  103f2a:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103f31:	00 
  103f32:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
  103f39:	00 
  103f3a:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103f41:	e8 e0 c4 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 1);
  103f46:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f49:	89 04 24             	mov    %eax,(%esp)
  103f4c:	e8 20 eb ff ff       	call   102a71 <page_ref>
  103f51:	83 f8 01             	cmp    $0x1,%eax
  103f54:	74 24                	je     103f7a <check_boot_pgdir+0x225>
  103f56:	c7 44 24 0c e2 6c 10 	movl   $0x106ce2,0xc(%esp)
  103f5d:	00 
  103f5e:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103f65:	00 
  103f66:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103f6d:	00 
  103f6e:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103f75:	e8 ac c4 ff ff       	call   100426 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103f7a:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  103f7f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103f86:	00 
  103f87:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103f8e:	00 
  103f8f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103f92:	89 54 24 04          	mov    %edx,0x4(%esp)
  103f96:	89 04 24             	mov    %eax,(%esp)
  103f99:	e8 d6 f5 ff ff       	call   103574 <page_insert>
  103f9e:	85 c0                	test   %eax,%eax
  103fa0:	74 24                	je     103fc6 <check_boot_pgdir+0x271>
  103fa2:	c7 44 24 0c f4 6c 10 	movl   $0x106cf4,0xc(%esp)
  103fa9:	00 
  103faa:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103fb1:	00 
  103fb2:	c7 44 24 04 23 02 00 	movl   $0x223,0x4(%esp)
  103fb9:	00 
  103fba:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103fc1:	e8 60 c4 ff ff       	call   100426 <__panic>
    assert(page_ref(p) == 2);
  103fc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103fc9:	89 04 24             	mov    %eax,(%esp)
  103fcc:	e8 a0 ea ff ff       	call   102a71 <page_ref>
  103fd1:	83 f8 02             	cmp    $0x2,%eax
  103fd4:	74 24                	je     103ffa <check_boot_pgdir+0x2a5>
  103fd6:	c7 44 24 0c 2b 6d 10 	movl   $0x106d2b,0xc(%esp)
  103fdd:	00 
  103fde:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  103fe5:	00 
  103fe6:	c7 44 24 04 24 02 00 	movl   $0x224,0x4(%esp)
  103fed:	00 
  103fee:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  103ff5:	e8 2c c4 ff ff       	call   100426 <__panic>

    const char *str = "ucore: Hello world!!";
  103ffa:	c7 45 e8 3c 6d 10 00 	movl   $0x106d3c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  104001:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104004:	89 44 24 04          	mov    %eax,0x4(%esp)
  104008:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10400f:	e8 db 15 00 00       	call   1055ef <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  104014:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10401b:	00 
  10401c:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  104023:	e8 45 16 00 00       	call   10566d <strcmp>
  104028:	85 c0                	test   %eax,%eax
  10402a:	74 24                	je     104050 <check_boot_pgdir+0x2fb>
  10402c:	c7 44 24 0c 54 6d 10 	movl   $0x106d54,0xc(%esp)
  104033:	00 
  104034:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  10403b:	00 
  10403c:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
  104043:	00 
  104044:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  10404b:	e8 d6 c3 ff ff       	call   100426 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  104050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104053:	89 04 24             	mov    %eax,(%esp)
  104056:	e8 6c e9 ff ff       	call   1029c7 <page2kva>
  10405b:	05 00 01 00 00       	add    $0x100,%eax
  104060:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  104063:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10406a:	e8 22 15 00 00       	call   105591 <strlen>
  10406f:	85 c0                	test   %eax,%eax
  104071:	74 24                	je     104097 <check_boot_pgdir+0x342>
  104073:	c7 44 24 0c 8c 6d 10 	movl   $0x106d8c,0xc(%esp)
  10407a:	00 
  10407b:	c7 44 24 08 2d 69 10 	movl   $0x10692d,0x8(%esp)
  104082:	00 
  104083:	c7 44 24 04 2b 02 00 	movl   $0x22b,0x4(%esp)
  10408a:	00 
  10408b:	c7 04 24 08 69 10 00 	movl   $0x106908,(%esp)
  104092:	e8 8f c3 ff ff       	call   100426 <__panic>

    free_page(p);
  104097:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10409e:	00 
  10409f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1040a2:	89 04 24             	mov    %eax,(%esp)
  1040a5:	e8 19 ec ff ff       	call   102cc3 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  1040aa:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1040af:	8b 00                	mov    (%eax),%eax
  1040b1:	89 04 24             	mov    %eax,(%esp)
  1040b4:	e8 a0 e9 ff ff       	call   102a59 <pde2page>
  1040b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1040c0:	00 
  1040c1:	89 04 24             	mov    %eax,(%esp)
  1040c4:	e8 fa eb ff ff       	call   102cc3 <free_pages>
    boot_pgdir[0] = 0;
  1040c9:	a1 e0 99 11 00       	mov    0x1199e0,%eax
  1040ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1040d4:	c7 04 24 b0 6d 10 00 	movl   $0x106db0,(%esp)
  1040db:	e8 da c1 ff ff       	call   1002ba <cprintf>
}
  1040e0:	90                   	nop
  1040e1:	c9                   	leave  
  1040e2:	c3                   	ret    

001040e3 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1040e3:	f3 0f 1e fb          	endbr32 
  1040e7:	55                   	push   %ebp
  1040e8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1040ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1040ed:	83 e0 04             	and    $0x4,%eax
  1040f0:	85 c0                	test   %eax,%eax
  1040f2:	74 04                	je     1040f8 <perm2str+0x15>
  1040f4:	b0 75                	mov    $0x75,%al
  1040f6:	eb 02                	jmp    1040fa <perm2str+0x17>
  1040f8:	b0 2d                	mov    $0x2d,%al
  1040fa:	a2 08 cf 11 00       	mov    %al,0x11cf08
    str[1] = 'r';
  1040ff:	c6 05 09 cf 11 00 72 	movb   $0x72,0x11cf09
    str[2] = (perm & PTE_W) ? 'w' : '-';
  104106:	8b 45 08             	mov    0x8(%ebp),%eax
  104109:	83 e0 02             	and    $0x2,%eax
  10410c:	85 c0                	test   %eax,%eax
  10410e:	74 04                	je     104114 <perm2str+0x31>
  104110:	b0 77                	mov    $0x77,%al
  104112:	eb 02                	jmp    104116 <perm2str+0x33>
  104114:	b0 2d                	mov    $0x2d,%al
  104116:	a2 0a cf 11 00       	mov    %al,0x11cf0a
    str[3] = '\0';
  10411b:	c6 05 0b cf 11 00 00 	movb   $0x0,0x11cf0b
    return str;
  104122:	b8 08 cf 11 00       	mov    $0x11cf08,%eax
}
  104127:	5d                   	pop    %ebp
  104128:	c3                   	ret    

00104129 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  104129:	f3 0f 1e fb          	endbr32 
  10412d:	55                   	push   %ebp
  10412e:	89 e5                	mov    %esp,%ebp
  104130:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104133:	8b 45 10             	mov    0x10(%ebp),%eax
  104136:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104139:	72 0d                	jb     104148 <get_pgtable_items+0x1f>
        return 0;
  10413b:	b8 00 00 00 00       	mov    $0x0,%eax
  104140:	e9 98 00 00 00       	jmp    1041dd <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104145:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104148:	8b 45 10             	mov    0x10(%ebp),%eax
  10414b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10414e:	73 18                	jae    104168 <get_pgtable_items+0x3f>
  104150:	8b 45 10             	mov    0x10(%ebp),%eax
  104153:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10415a:	8b 45 14             	mov    0x14(%ebp),%eax
  10415d:	01 d0                	add    %edx,%eax
  10415f:	8b 00                	mov    (%eax),%eax
  104161:	83 e0 01             	and    $0x1,%eax
  104164:	85 c0                	test   %eax,%eax
  104166:	74 dd                	je     104145 <get_pgtable_items+0x1c>
    }
    if (start < right) {
  104168:	8b 45 10             	mov    0x10(%ebp),%eax
  10416b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10416e:	73 68                	jae    1041d8 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  104170:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104174:	74 08                	je     10417e <get_pgtable_items+0x55>
            *left_store = start;
  104176:	8b 45 18             	mov    0x18(%ebp),%eax
  104179:	8b 55 10             	mov    0x10(%ebp),%edx
  10417c:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10417e:	8b 45 10             	mov    0x10(%ebp),%eax
  104181:	8d 50 01             	lea    0x1(%eax),%edx
  104184:	89 55 10             	mov    %edx,0x10(%ebp)
  104187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10418e:	8b 45 14             	mov    0x14(%ebp),%eax
  104191:	01 d0                	add    %edx,%eax
  104193:	8b 00                	mov    (%eax),%eax
  104195:	83 e0 07             	and    $0x7,%eax
  104198:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10419b:	eb 03                	jmp    1041a0 <get_pgtable_items+0x77>
            start ++;
  10419d:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  1041a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1041a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1041a6:	73 1d                	jae    1041c5 <get_pgtable_items+0x9c>
  1041a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1041ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1041b2:	8b 45 14             	mov    0x14(%ebp),%eax
  1041b5:	01 d0                	add    %edx,%eax
  1041b7:	8b 00                	mov    (%eax),%eax
  1041b9:	83 e0 07             	and    $0x7,%eax
  1041bc:	89 c2                	mov    %eax,%edx
  1041be:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041c1:	39 c2                	cmp    %eax,%edx
  1041c3:	74 d8                	je     10419d <get_pgtable_items+0x74>
        }
        if (right_store != NULL) {
  1041c5:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1041c9:	74 08                	je     1041d3 <get_pgtable_items+0xaa>
            *right_store = start;
  1041cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1041ce:	8b 55 10             	mov    0x10(%ebp),%edx
  1041d1:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1041d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1041d6:	eb 05                	jmp    1041dd <get_pgtable_items+0xb4>
    }
    return 0;
  1041d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1041dd:	c9                   	leave  
  1041de:	c3                   	ret    

001041df <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1041df:	f3 0f 1e fb          	endbr32 
  1041e3:	55                   	push   %ebp
  1041e4:	89 e5                	mov    %esp,%ebp
  1041e6:	57                   	push   %edi
  1041e7:	56                   	push   %esi
  1041e8:	53                   	push   %ebx
  1041e9:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1041ec:	c7 04 24 d0 6d 10 00 	movl   $0x106dd0,(%esp)
  1041f3:	e8 c2 c0 ff ff       	call   1002ba <cprintf>
    size_t left, right = 0, perm;
  1041f8:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1041ff:	e9 fa 00 00 00       	jmp    1042fe <print_pgdir+0x11f>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104204:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104207:	89 04 24             	mov    %eax,(%esp)
  10420a:	e8 d4 fe ff ff       	call   1040e3 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10420f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  104212:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104215:	29 d1                	sub    %edx,%ecx
  104217:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  104219:	89 d6                	mov    %edx,%esi
  10421b:	c1 e6 16             	shl    $0x16,%esi
  10421e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104221:	89 d3                	mov    %edx,%ebx
  104223:	c1 e3 16             	shl    $0x16,%ebx
  104226:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104229:	89 d1                	mov    %edx,%ecx
  10422b:	c1 e1 16             	shl    $0x16,%ecx
  10422e:	8b 7d dc             	mov    -0x24(%ebp),%edi
  104231:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104234:	29 d7                	sub    %edx,%edi
  104236:	89 fa                	mov    %edi,%edx
  104238:	89 44 24 14          	mov    %eax,0x14(%esp)
  10423c:	89 74 24 10          	mov    %esi,0x10(%esp)
  104240:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  104244:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104248:	89 54 24 04          	mov    %edx,0x4(%esp)
  10424c:	c7 04 24 01 6e 10 00 	movl   $0x106e01,(%esp)
  104253:	e8 62 c0 ff ff       	call   1002ba <cprintf>
        size_t l, r = left * NPTEENTRY;
  104258:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10425b:	c1 e0 0a             	shl    $0xa,%eax
  10425e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104261:	eb 54                	jmp    1042b7 <print_pgdir+0xd8>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104263:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104266:	89 04 24             	mov    %eax,(%esp)
  104269:	e8 75 fe ff ff       	call   1040e3 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  10426e:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  104271:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104274:	29 d1                	sub    %edx,%ecx
  104276:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104278:	89 d6                	mov    %edx,%esi
  10427a:	c1 e6 0c             	shl    $0xc,%esi
  10427d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104280:	89 d3                	mov    %edx,%ebx
  104282:	c1 e3 0c             	shl    $0xc,%ebx
  104285:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104288:	89 d1                	mov    %edx,%ecx
  10428a:	c1 e1 0c             	shl    $0xc,%ecx
  10428d:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  104290:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104293:	29 d7                	sub    %edx,%edi
  104295:	89 fa                	mov    %edi,%edx
  104297:	89 44 24 14          	mov    %eax,0x14(%esp)
  10429b:	89 74 24 10          	mov    %esi,0x10(%esp)
  10429f:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1042a3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1042a7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1042ab:	c7 04 24 20 6e 10 00 	movl   $0x106e20,(%esp)
  1042b2:	e8 03 c0 ff ff       	call   1002ba <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1042b7:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  1042bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1042bf:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042c2:	89 d3                	mov    %edx,%ebx
  1042c4:	c1 e3 0a             	shl    $0xa,%ebx
  1042c7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1042ca:	89 d1                	mov    %edx,%ecx
  1042cc:	c1 e1 0a             	shl    $0xa,%ecx
  1042cf:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1042d2:	89 54 24 14          	mov    %edx,0x14(%esp)
  1042d6:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1042d9:	89 54 24 10          	mov    %edx,0x10(%esp)
  1042dd:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1042e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1042e5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1042e9:	89 0c 24             	mov    %ecx,(%esp)
  1042ec:	e8 38 fe ff ff       	call   104129 <get_pgtable_items>
  1042f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1042f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1042f8:	0f 85 65 ff ff ff    	jne    104263 <print_pgdir+0x84>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1042fe:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  104303:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104306:	8d 55 dc             	lea    -0x24(%ebp),%edx
  104309:	89 54 24 14          	mov    %edx,0x14(%esp)
  10430d:	8d 55 e0             	lea    -0x20(%ebp),%edx
  104310:	89 54 24 10          	mov    %edx,0x10(%esp)
  104314:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  104318:	89 44 24 08          	mov    %eax,0x8(%esp)
  10431c:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  104323:	00 
  104324:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10432b:	e8 f9 fd ff ff       	call   104129 <get_pgtable_items>
  104330:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104333:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104337:	0f 85 c7 fe ff ff    	jne    104204 <print_pgdir+0x25>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  10433d:	c7 04 24 44 6e 10 00 	movl   $0x106e44,(%esp)
  104344:	e8 71 bf ff ff       	call   1002ba <cprintf>
}
  104349:	90                   	nop
  10434a:	83 c4 4c             	add    $0x4c,%esp
  10434d:	5b                   	pop    %ebx
  10434e:	5e                   	pop    %esi
  10434f:	5f                   	pop    %edi
  104350:	5d                   	pop    %ebp
  104351:	c3                   	ret    

00104352 <page2ppn>:
page2ppn(struct Page *page) {
  104352:	55                   	push   %ebp
  104353:	89 e5                	mov    %esp,%ebp
    return page - pages;
  104355:	a1 18 cf 11 00       	mov    0x11cf18,%eax
  10435a:	8b 55 08             	mov    0x8(%ebp),%edx
  10435d:	29 c2                	sub    %eax,%edx
  10435f:	89 d0                	mov    %edx,%eax
  104361:	c1 f8 02             	sar    $0x2,%eax
  104364:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10436a:	5d                   	pop    %ebp
  10436b:	c3                   	ret    

0010436c <page2pa>:
page2pa(struct Page *page) {
  10436c:	55                   	push   %ebp
  10436d:	89 e5                	mov    %esp,%ebp
  10436f:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  104372:	8b 45 08             	mov    0x8(%ebp),%eax
  104375:	89 04 24             	mov    %eax,(%esp)
  104378:	e8 d5 ff ff ff       	call   104352 <page2ppn>
  10437d:	c1 e0 0c             	shl    $0xc,%eax
}
  104380:	c9                   	leave  
  104381:	c3                   	ret    

00104382 <page_ref>:
page_ref(struct Page *page) {
  104382:	55                   	push   %ebp
  104383:	89 e5                	mov    %esp,%ebp
    return page->ref;
  104385:	8b 45 08             	mov    0x8(%ebp),%eax
  104388:	8b 00                	mov    (%eax),%eax
}
  10438a:	5d                   	pop    %ebp
  10438b:	c3                   	ret    

0010438c <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  10438c:	55                   	push   %ebp
  10438d:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10438f:	8b 45 08             	mov    0x8(%ebp),%eax
  104392:	8b 55 0c             	mov    0xc(%ebp),%edx
  104395:	89 10                	mov    %edx,(%eax)
}
  104397:	90                   	nop
  104398:	5d                   	pop    %ebp
  104399:	c3                   	ret    

0010439a <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10439a:	f3 0f 1e fb          	endbr32 
  10439e:	55                   	push   %ebp
  10439f:	89 e5                	mov    %esp,%ebp
  1043a1:	83 ec 10             	sub    $0x10,%esp
  1043a4:	c7 45 fc 1c cf 11 00 	movl   $0x11cf1c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1043ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043ae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1043b1:	89 50 04             	mov    %edx,0x4(%eax)
  1043b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043b7:	8b 50 04             	mov    0x4(%eax),%edx
  1043ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1043bd:	89 10                	mov    %edx,(%eax)
}
  1043bf:	90                   	nop
    list_init(&free_list);
    nr_free = 0;
  1043c0:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  1043c7:	00 00 00 
}
  1043ca:	90                   	nop
  1043cb:	c9                   	leave  
  1043cc:	c3                   	ret    

001043cd <default_init_memmap>:

// 初始化Page
static void
default_init_memmap(struct Page *base, size_t n) {
  1043cd:	f3 0f 1e fb          	endbr32 
  1043d1:	55                   	push   %ebp
  1043d2:	89 e5                	mov    %esp,%ebp
  1043d4:	83 ec 48             	sub    $0x48,%esp
    assert(n > 0);
  1043d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1043db:	75 24                	jne    104401 <default_init_memmap+0x34>
  1043dd:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  1043e4:	00 
  1043e5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1043ec:	00 
  1043ed:	c7 44 24 04 6e 00 00 	movl   $0x6e,0x4(%esp)
  1043f4:	00 
  1043f5:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1043fc:	e8 25 c0 ff ff       	call   100426 <__panic>
    struct Page *p = base;
  104401:	8b 45 08             	mov    0x8(%ebp),%eax
  104404:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  104407:	eb 7d                	jmp    104486 <default_init_memmap+0xb9>
        // 在查找可用内存并分配struct Page数组时就已经将将全部Page设置为Reserved
        // 将Page标记为可用的:清除Reserved,设置Property,并把property设置为0( 不是空闲块的第一个物理页 )
        assert(PageReserved(p));
  104409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10440c:	83 c0 04             	add    $0x4,%eax
  10440f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  104416:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10441c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10441f:	0f a3 10             	bt     %edx,(%eax)
  104422:	19 c0                	sbb    %eax,%eax
  104424:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  104427:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10442b:	0f 95 c0             	setne  %al
  10442e:	0f b6 c0             	movzbl %al,%eax
  104431:	85 c0                	test   %eax,%eax
  104433:	75 24                	jne    104459 <default_init_memmap+0x8c>
  104435:	c7 44 24 0c a9 6e 10 	movl   $0x106ea9,0xc(%esp)
  10443c:	00 
  10443d:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104444:	00 
  104445:	c7 44 24 04 73 00 00 	movl   $0x73,0x4(%esp)
  10444c:	00 
  10444d:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104454:	e8 cd bf ff ff       	call   100426 <__panic>
        p->flags = p->property = 0;
  104459:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10445c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104463:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104466:	8b 50 08             	mov    0x8(%eax),%edx
  104469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10446c:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10446f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104476:	00 
  104477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10447a:	89 04 24             	mov    %eax,(%esp)
  10447d:	e8 0a ff ff ff       	call   10438c <set_page_ref>
    for (; p != base + n; p ++) {
  104482:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104486:	8b 55 0c             	mov    0xc(%ebp),%edx
  104489:	89 d0                	mov    %edx,%eax
  10448b:	c1 e0 02             	shl    $0x2,%eax
  10448e:	01 d0                	add    %edx,%eax
  104490:	c1 e0 02             	shl    $0x2,%eax
  104493:	89 c2                	mov    %eax,%edx
  104495:	8b 45 08             	mov    0x8(%ebp),%eax
  104498:	01 d0                	add    %edx,%eax
  10449a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10449d:	0f 85 66 ff ff ff    	jne    104409 <default_init_memmap+0x3c>
    }
    base->property = n;
  1044a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1044a6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1044a9:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1044ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1044af:	83 c0 04             	add    $0x4,%eax
  1044b2:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1044b9:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1044bc:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1044bf:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1044c2:	0f ab 10             	bts    %edx,(%eax)
}
  1044c5:	90                   	nop
    nr_free += n;
  1044c6:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  1044cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044cf:	01 d0                	add    %edx,%eax
  1044d1:	a3 24 cf 11 00       	mov    %eax,0x11cf24
    list_add_before(&free_list, &(base->page_link));
  1044d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d9:	83 c0 0c             	add    $0xc,%eax
  1044dc:	c7 45 e4 1c cf 11 00 	movl   $0x11cf1c,-0x1c(%ebp)
  1044e3:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  1044e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044e9:	8b 00                	mov    (%eax),%eax
  1044eb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044ee:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1044f1:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1044f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044f7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1044fa:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1044fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104500:	89 10                	mov    %edx,(%eax)
  104502:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104505:	8b 10                	mov    (%eax),%edx
  104507:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10450a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  10450d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104510:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104513:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104516:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104519:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10451c:	89 10                	mov    %edx,(%eax)
}
  10451e:	90                   	nop
}
  10451f:	90                   	nop
}
  104520:	90                   	nop
  104521:	c9                   	leave  
  104522:	c3                   	ret    

00104523 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  104523:	f3 0f 1e fb          	endbr32 
  104527:	55                   	push   %ebp
  104528:	89 e5                	mov    %esp,%ebp
  10452a:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  10452d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104531:	75 24                	jne    104557 <default_alloc_pages+0x34>
  104533:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  10453a:	00 
  10453b:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104542:	00 
  104543:	c7 44 24 04 7f 00 00 	movl   $0x7f,0x4(%esp)
  10454a:	00 
  10454b:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104552:	e8 cf be ff ff       	call   100426 <__panic>
    if (n > nr_free) {
  104557:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  10455c:	39 45 08             	cmp    %eax,0x8(%ebp)
  10455f:	76 0a                	jbe    10456b <default_alloc_pages+0x48>
        return NULL;
  104561:	b8 00 00 00 00       	mov    $0x0,%eax
  104566:	e9 43 01 00 00       	jmp    1046ae <default_alloc_pages+0x18b>
    }
    struct Page *page = NULL;
  10456b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104572:	c7 45 f0 1c cf 11 00 	movl   $0x11cf1c,-0x10(%ebp)
    // TODO: optimize (next-fit)
    while ((le = list_next(le)) != &free_list) {
  104579:	eb 1c                	jmp    104597 <default_alloc_pages+0x74>
        // try to find empty space to allocate
        struct Page *p = le2page(le, page_link);
  10457b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10457e:	83 e8 0c             	sub    $0xc,%eax
  104581:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  104584:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104587:	8b 40 08             	mov    0x8(%eax),%eax
  10458a:	39 45 08             	cmp    %eax,0x8(%ebp)
  10458d:	77 08                	ja     104597 <default_alloc_pages+0x74>
            page = p;
  10458f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104592:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  104595:	eb 18                	jmp    1045af <default_alloc_pages+0x8c>
  104597:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10459a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  10459d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1045a0:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  1045a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1045a6:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1045ad:	75 cc                	jne    10457b <default_alloc_pages+0x58>
        }
    }
    if (page != NULL) {
  1045af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1045b3:	0f 84 f2 00 00 00    	je     1046ab <default_alloc_pages+0x188>
        if (page->property > n) {
  1045b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045bc:	8b 40 08             	mov    0x8(%eax),%eax
  1045bf:	39 45 08             	cmp    %eax,0x8(%ebp)
  1045c2:	0f 83 8f 00 00 00    	jae    104657 <default_alloc_pages+0x134>
            // 有多余出来的空间
            // p指向未被分配的页
            struct Page *p = page + n;
  1045c8:	8b 55 08             	mov    0x8(%ebp),%edx
  1045cb:	89 d0                	mov    %edx,%eax
  1045cd:	c1 e0 02             	shl    $0x2,%eax
  1045d0:	01 d0                	add    %edx,%eax
  1045d2:	c1 e0 02             	shl    $0x2,%eax
  1045d5:	89 c2                	mov    %eax,%edx
  1045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045da:	01 d0                	add    %edx,%eax
  1045dc:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  1045df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045e2:	8b 40 08             	mov    0x8(%eax),%eax
  1045e5:	2b 45 08             	sub    0x8(%ebp),%eax
  1045e8:	89 c2                	mov    %eax,%edx
  1045ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045ed:	89 50 08             	mov    %edx,0x8(%eax)
            SetPageProperty(p);
  1045f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045f3:	83 c0 04             	add    $0x4,%eax
  1045f6:	c7 45 cc 01 00 00 00 	movl   $0x1,-0x34(%ebp)
  1045fd:	89 45 c8             	mov    %eax,-0x38(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  104600:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104603:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104606:	0f ab 10             	bts    %edx,(%eax)
}
  104609:	90                   	nop
            list_add_after(&(page->page_link), &(p->page_link));
  10460a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10460d:	83 c0 0c             	add    $0xc,%eax
  104610:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104613:	83 c2 0c             	add    $0xc,%edx
  104616:	89 55 e0             	mov    %edx,-0x20(%ebp)
  104619:	89 45 dc             	mov    %eax,-0x24(%ebp)
    __list_add(elm, listelm, listelm->next);
  10461c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10461f:	8b 40 04             	mov    0x4(%eax),%eax
  104622:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104625:	89 55 d8             	mov    %edx,-0x28(%ebp)
  104628:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10462b:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10462e:	89 45 d0             	mov    %eax,-0x30(%ebp)
    prev->next = next->prev = elm;
  104631:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104634:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104637:	89 10                	mov    %edx,(%eax)
  104639:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10463c:	8b 10                	mov    (%eax),%edx
  10463e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104641:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104644:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104647:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10464a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10464d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104650:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104653:	89 10                	mov    %edx,(%eax)
}
  104655:	90                   	nop
}
  104656:	90                   	nop
        }
        list_del(&(page->page_link));
  104657:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10465a:	83 c0 0c             	add    $0xc,%eax
  10465d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    __list_del(listelm->prev, listelm->next);
  104660:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104663:	8b 40 04             	mov    0x4(%eax),%eax
  104666:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104669:	8b 12                	mov    (%edx),%edx
  10466b:	89 55 b8             	mov    %edx,-0x48(%ebp)
  10466e:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  104671:	8b 45 b8             	mov    -0x48(%ebp),%eax
  104674:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  104677:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10467a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10467d:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104680:	89 10                	mov    %edx,(%eax)
}
  104682:	90                   	nop
}
  104683:	90                   	nop
        nr_free -= n;
  104684:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104689:	2b 45 08             	sub    0x8(%ebp),%eax
  10468c:	a3 24 cf 11 00       	mov    %eax,0x11cf24
        ClearPageProperty(page);
  104691:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104694:	83 c0 04             	add    $0x4,%eax
  104697:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  10469e:	89 45 c0             	mov    %eax,-0x40(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
  1046a4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  1046a7:	0f b3 10             	btr    %edx,(%eax)
}
  1046aa:	90                   	nop
    }
    return page;
  1046ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1046ae:	c9                   	leave  
  1046af:	c3                   	ret    

001046b0 <default_free_pages>:
// 能够正确地处理参数：当1n超过已分配块的页数时，回收整个块;当n小于也分配块的页数时，回收n页，剩下的内存不回收;当base指向的内存块不是已分配块的起始地址时，从base开始回收
// 能够正确的合并空闲块（我的实现回收在base块高地址的所有相邻空闲块）
// 能够正确分割已分配块：default_free_pages要求回收已分配块中的任意页，剩下的未回收的部分作为新的已分配块
// 在回收后，空闲链表仍然是有序的
static void
default_free_pages(struct Page *base, size_t n) {
  1046b0:	f3 0f 1e fb          	endbr32 
  1046b4:	55                   	push   %ebp
  1046b5:	89 e5                	mov    %esp,%ebp
  1046b7:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  1046bd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1046c1:	75 24                	jne    1046e7 <default_free_pages+0x37>
  1046c3:	c7 44 24 0c 78 6e 10 	movl   $0x106e78,0xc(%esp)
  1046ca:	00 
  1046cb:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1046d2:	00 
  1046d3:	c7 44 24 04 a4 00 00 	movl   $0xa4,0x4(%esp)
  1046da:	00 
  1046db:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1046e2:	e8 3f bd ff ff       	call   100426 <__panic>
    struct Page *p = base;
  1046e7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1046ed:	e9 9d 00 00 00       	jmp    10478f <default_free_pages+0xdf>
        assert(!PageReserved(p) && !PageProperty(p));
  1046f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046f5:	83 c0 04             	add    $0x4,%eax
  1046f8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1046ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104705:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104708:	0f a3 10             	bt     %edx,(%eax)
  10470b:	19 c0                	sbb    %eax,%eax
  10470d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  104710:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104714:	0f 95 c0             	setne  %al
  104717:	0f b6 c0             	movzbl %al,%eax
  10471a:	85 c0                	test   %eax,%eax
  10471c:	75 2c                	jne    10474a <default_free_pages+0x9a>
  10471e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104721:	83 c0 04             	add    $0x4,%eax
  104724:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  10472b:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10472e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104731:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104734:	0f a3 10             	bt     %edx,(%eax)
  104737:	19 c0                	sbb    %eax,%eax
  104739:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  10473c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  104740:	0f 95 c0             	setne  %al
  104743:	0f b6 c0             	movzbl %al,%eax
  104746:	85 c0                	test   %eax,%eax
  104748:	74 24                	je     10476e <default_free_pages+0xbe>
  10474a:	c7 44 24 0c bc 6e 10 	movl   $0x106ebc,0xc(%esp)
  104751:	00 
  104752:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104759:	00 
  10475a:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
  104761:	00 
  104762:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104769:	e8 b8 bc ff ff       	call   100426 <__panic>
        p->flags = 0;
  10476e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104771:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104778:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10477f:	00 
  104780:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104783:	89 04 24             	mov    %eax,(%esp)
  104786:	e8 01 fc ff ff       	call   10438c <set_page_ref>
    for (; p != base + n; p ++) {
  10478b:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  10478f:	8b 55 0c             	mov    0xc(%ebp),%edx
  104792:	89 d0                	mov    %edx,%eax
  104794:	c1 e0 02             	shl    $0x2,%eax
  104797:	01 d0                	add    %edx,%eax
  104799:	c1 e0 02             	shl    $0x2,%eax
  10479c:	89 c2                	mov    %eax,%edx
  10479e:	8b 45 08             	mov    0x8(%ebp),%eax
  1047a1:	01 d0                	add    %edx,%eax
  1047a3:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1047a6:	0f 85 46 ff ff ff    	jne    1046f2 <default_free_pages+0x42>
    }
    base->property = n;
  1047ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1047af:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047b2:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  1047b5:	8b 45 08             	mov    0x8(%ebp),%eax
  1047b8:	83 c0 04             	add    $0x4,%eax
  1047bb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  1047c2:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1047c5:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1047c8:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1047cb:	0f ab 10             	bts    %edx,(%eax)
}
  1047ce:	90                   	nop
  1047cf:	c7 45 d4 1c cf 11 00 	movl   $0x11cf1c,-0x2c(%ebp)
    return listelm->next;
  1047d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1047d9:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  1047dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  1047df:	e9 0e 01 00 00       	jmp    1048f2 <default_free_pages+0x242>
        p = le2page(le, page_link);
  1047e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047e7:	83 e8 0c             	sub    $0xc,%eax
  1047ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1047ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1047f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1047f3:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1047f6:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1047f9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        // TODO: optimize
        if (base + base->property == p) {
  1047fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1047ff:	8b 50 08             	mov    0x8(%eax),%edx
  104802:	89 d0                	mov    %edx,%eax
  104804:	c1 e0 02             	shl    $0x2,%eax
  104807:	01 d0                	add    %edx,%eax
  104809:	c1 e0 02             	shl    $0x2,%eax
  10480c:	89 c2                	mov    %eax,%edx
  10480e:	8b 45 08             	mov    0x8(%ebp),%eax
  104811:	01 d0                	add    %edx,%eax
  104813:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104816:	75 5d                	jne    104875 <default_free_pages+0x1c5>
            base->property += p->property;
  104818:	8b 45 08             	mov    0x8(%ebp),%eax
  10481b:	8b 50 08             	mov    0x8(%eax),%edx
  10481e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104821:	8b 40 08             	mov    0x8(%eax),%eax
  104824:	01 c2                	add    %eax,%edx
  104826:	8b 45 08             	mov    0x8(%ebp),%eax
  104829:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  10482c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10482f:	83 c0 04             	add    $0x4,%eax
  104832:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  104839:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10483c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10483f:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104842:	0f b3 10             	btr    %edx,(%eax)
}
  104845:	90                   	nop
            list_del(&(p->page_link));
  104846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104849:	83 c0 0c             	add    $0xc,%eax
  10484c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  10484f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104852:	8b 40 04             	mov    0x4(%eax),%eax
  104855:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104858:	8b 12                	mov    (%edx),%edx
  10485a:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10485d:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104860:	8b 45 c0             	mov    -0x40(%ebp),%eax
  104863:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104866:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104869:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10486c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10486f:	89 10                	mov    %edx,(%eax)
}
  104871:	90                   	nop
}
  104872:	90                   	nop
  104873:	eb 7d                	jmp    1048f2 <default_free_pages+0x242>
        }
        else if (p + p->property == base) {
  104875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104878:	8b 50 08             	mov    0x8(%eax),%edx
  10487b:	89 d0                	mov    %edx,%eax
  10487d:	c1 e0 02             	shl    $0x2,%eax
  104880:	01 d0                	add    %edx,%eax
  104882:	c1 e0 02             	shl    $0x2,%eax
  104885:	89 c2                	mov    %eax,%edx
  104887:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10488a:	01 d0                	add    %edx,%eax
  10488c:	39 45 08             	cmp    %eax,0x8(%ebp)
  10488f:	75 61                	jne    1048f2 <default_free_pages+0x242>
            p->property += base->property;
  104891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104894:	8b 50 08             	mov    0x8(%eax),%edx
  104897:	8b 45 08             	mov    0x8(%ebp),%eax
  10489a:	8b 40 08             	mov    0x8(%eax),%eax
  10489d:	01 c2                	add    %eax,%edx
  10489f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048a2:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  1048a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a8:	83 c0 04             	add    $0x4,%eax
  1048ab:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  1048b2:	89 45 a0             	mov    %eax,-0x60(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1048b5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1048b8:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  1048bb:	0f b3 10             	btr    %edx,(%eax)
}
  1048be:	90                   	nop
            base = p;
  1048bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c2:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  1048c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048c8:	83 c0 0c             	add    $0xc,%eax
  1048cb:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  1048ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1048d1:	8b 40 04             	mov    0x4(%eax),%eax
  1048d4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1048d7:	8b 12                	mov    (%edx),%edx
  1048d9:	89 55 ac             	mov    %edx,-0x54(%ebp)
  1048dc:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  1048df:	8b 45 ac             	mov    -0x54(%ebp),%eax
  1048e2:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1048e5:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1048e8:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1048eb:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1048ee:	89 10                	mov    %edx,(%eax)
}
  1048f0:	90                   	nop
}
  1048f1:	90                   	nop
    while (le != &free_list) {
  1048f2:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  1048f9:	0f 85 e5 fe ff ff    	jne    1047e4 <default_free_pages+0x134>
        }
    }
    nr_free += n;
  1048ff:	8b 15 24 cf 11 00    	mov    0x11cf24,%edx
  104905:	8b 45 0c             	mov    0xc(%ebp),%eax
  104908:	01 d0                	add    %edx,%eax
  10490a:	a3 24 cf 11 00       	mov    %eax,0x11cf24
  10490f:	c7 45 9c 1c cf 11 00 	movl   $0x11cf1c,-0x64(%ebp)
    return listelm->next;
  104916:	8b 45 9c             	mov    -0x64(%ebp),%eax
  104919:	8b 40 04             	mov    0x4(%eax),%eax
    le = list_next(&free_list);
  10491c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  10491f:	eb 74                	jmp    104995 <default_free_pages+0x2e5>
        p = le2page(le, page_link);
  104921:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104924:	83 e8 0c             	sub    $0xc,%eax
  104927:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base + base->property <= p) {
  10492a:	8b 45 08             	mov    0x8(%ebp),%eax
  10492d:	8b 50 08             	mov    0x8(%eax),%edx
  104930:	89 d0                	mov    %edx,%eax
  104932:	c1 e0 02             	shl    $0x2,%eax
  104935:	01 d0                	add    %edx,%eax
  104937:	c1 e0 02             	shl    $0x2,%eax
  10493a:	89 c2                	mov    %eax,%edx
  10493c:	8b 45 08             	mov    0x8(%ebp),%eax
  10493f:	01 d0                	add    %edx,%eax
  104941:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104944:	72 40                	jb     104986 <default_free_pages+0x2d6>
            assert(base + base->property != p);
  104946:	8b 45 08             	mov    0x8(%ebp),%eax
  104949:	8b 50 08             	mov    0x8(%eax),%edx
  10494c:	89 d0                	mov    %edx,%eax
  10494e:	c1 e0 02             	shl    $0x2,%eax
  104951:	01 d0                	add    %edx,%eax
  104953:	c1 e0 02             	shl    $0x2,%eax
  104956:	89 c2                	mov    %eax,%edx
  104958:	8b 45 08             	mov    0x8(%ebp),%eax
  10495b:	01 d0                	add    %edx,%eax
  10495d:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  104960:	75 3e                	jne    1049a0 <default_free_pages+0x2f0>
  104962:	c7 44 24 0c e1 6e 10 	movl   $0x106ee1,0xc(%esp)
  104969:	00 
  10496a:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104971:	00 
  104972:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  104979:	00 
  10497a:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104981:	e8 a0 ba ff ff       	call   100426 <__panic>
  104986:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104989:	89 45 98             	mov    %eax,-0x68(%ebp)
  10498c:	8b 45 98             	mov    -0x68(%ebp),%eax
  10498f:	8b 40 04             	mov    0x4(%eax),%eax
            break;
        }
        le = list_next(le);
  104992:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104995:	81 7d f0 1c cf 11 00 	cmpl   $0x11cf1c,-0x10(%ebp)
  10499c:	75 83                	jne    104921 <default_free_pages+0x271>
  10499e:	eb 01                	jmp    1049a1 <default_free_pages+0x2f1>
            break;
  1049a0:	90                   	nop
    }
    list_add_before(le, &(base->page_link));
  1049a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1049a4:	8d 50 0c             	lea    0xc(%eax),%edx
  1049a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049aa:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1049ad:	89 55 90             	mov    %edx,-0x70(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1049b0:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049b3:	8b 00                	mov    (%eax),%eax
  1049b5:	8b 55 90             	mov    -0x70(%ebp),%edx
  1049b8:	89 55 8c             	mov    %edx,-0x74(%ebp)
  1049bb:	89 45 88             	mov    %eax,-0x78(%ebp)
  1049be:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1049c1:	89 45 84             	mov    %eax,-0x7c(%ebp)
    prev->next = next->prev = elm;
  1049c4:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1049c7:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1049ca:	89 10                	mov    %edx,(%eax)
  1049cc:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1049cf:	8b 10                	mov    (%eax),%edx
  1049d1:	8b 45 88             	mov    -0x78(%ebp),%eax
  1049d4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1049d7:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1049da:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1049dd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1049e0:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1049e3:	8b 55 88             	mov    -0x78(%ebp),%edx
  1049e6:	89 10                	mov    %edx,(%eax)
}
  1049e8:	90                   	nop
}
  1049e9:	90                   	nop
}
  1049ea:	90                   	nop
  1049eb:	c9                   	leave  
  1049ec:	c3                   	ret    

001049ed <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  1049ed:	f3 0f 1e fb          	endbr32 
  1049f1:	55                   	push   %ebp
  1049f2:	89 e5                	mov    %esp,%ebp
    return nr_free;
  1049f4:	a1 24 cf 11 00       	mov    0x11cf24,%eax
}
  1049f9:	5d                   	pop    %ebp
  1049fa:	c3                   	ret    

001049fb <basic_check>:

static void
basic_check(void) {
  1049fb:	f3 0f 1e fb          	endbr32 
  1049ff:	55                   	push   %ebp
  104a00:	89 e5                	mov    %esp,%ebp
  104a02:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  104a05:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104a0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104a0f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a15:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  104a18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a1f:	e8 63 e2 ff ff       	call   102c87 <alloc_pages>
  104a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104a27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104a2b:	75 24                	jne    104a51 <basic_check+0x56>
  104a2d:	c7 44 24 0c fc 6e 10 	movl   $0x106efc,0xc(%esp)
  104a34:	00 
  104a35:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104a3c:	00 
  104a3d:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  104a44:	00 
  104a45:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104a4c:	e8 d5 b9 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104a51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a58:	e8 2a e2 ff ff       	call   102c87 <alloc_pages>
  104a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a60:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a64:	75 24                	jne    104a8a <basic_check+0x8f>
  104a66:	c7 44 24 0c 18 6f 10 	movl   $0x106f18,0xc(%esp)
  104a6d:	00 
  104a6e:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104a75:	00 
  104a76:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104a7d:	00 
  104a7e:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104a85:	e8 9c b9 ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104a8a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a91:	e8 f1 e1 ff ff       	call   102c87 <alloc_pages>
  104a96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104a99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104a9d:	75 24                	jne    104ac3 <basic_check+0xc8>
  104a9f:	c7 44 24 0c 34 6f 10 	movl   $0x106f34,0xc(%esp)
  104aa6:	00 
  104aa7:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104aae:	00 
  104aaf:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  104ab6:	00 
  104ab7:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104abe:	e8 63 b9 ff ff       	call   100426 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  104ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ac6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104ac9:	74 10                	je     104adb <basic_check+0xe0>
  104acb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ace:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ad1:	74 08                	je     104adb <basic_check+0xe0>
  104ad3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ad6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104ad9:	75 24                	jne    104aff <basic_check+0x104>
  104adb:	c7 44 24 0c 50 6f 10 	movl   $0x106f50,0xc(%esp)
  104ae2:	00 
  104ae3:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104aea:	00 
  104aeb:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  104af2:	00 
  104af3:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104afa:	e8 27 b9 ff ff       	call   100426 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104aff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b02:	89 04 24             	mov    %eax,(%esp)
  104b05:	e8 78 f8 ff ff       	call   104382 <page_ref>
  104b0a:	85 c0                	test   %eax,%eax
  104b0c:	75 1e                	jne    104b2c <basic_check+0x131>
  104b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b11:	89 04 24             	mov    %eax,(%esp)
  104b14:	e8 69 f8 ff ff       	call   104382 <page_ref>
  104b19:	85 c0                	test   %eax,%eax
  104b1b:	75 0f                	jne    104b2c <basic_check+0x131>
  104b1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104b20:	89 04 24             	mov    %eax,(%esp)
  104b23:	e8 5a f8 ff ff       	call   104382 <page_ref>
  104b28:	85 c0                	test   %eax,%eax
  104b2a:	74 24                	je     104b50 <basic_check+0x155>
  104b2c:	c7 44 24 0c 74 6f 10 	movl   $0x106f74,0xc(%esp)
  104b33:	00 
  104b34:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104b3b:	00 
  104b3c:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  104b43:	00 
  104b44:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104b4b:	e8 d6 b8 ff ff       	call   100426 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104b50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104b53:	89 04 24             	mov    %eax,(%esp)
  104b56:	e8 11 f8 ff ff       	call   10436c <page2pa>
  104b5b:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104b61:	c1 e2 0c             	shl    $0xc,%edx
  104b64:	39 d0                	cmp    %edx,%eax
  104b66:	72 24                	jb     104b8c <basic_check+0x191>
  104b68:	c7 44 24 0c b0 6f 10 	movl   $0x106fb0,0xc(%esp)
  104b6f:	00 
  104b70:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104b77:	00 
  104b78:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104b7f:	00 
  104b80:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104b87:	e8 9a b8 ff ff       	call   100426 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  104b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b8f:	89 04 24             	mov    %eax,(%esp)
  104b92:	e8 d5 f7 ff ff       	call   10436c <page2pa>
  104b97:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104b9d:	c1 e2 0c             	shl    $0xc,%edx
  104ba0:	39 d0                	cmp    %edx,%eax
  104ba2:	72 24                	jb     104bc8 <basic_check+0x1cd>
  104ba4:	c7 44 24 0c cd 6f 10 	movl   $0x106fcd,0xc(%esp)
  104bab:	00 
  104bac:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104bb3:	00 
  104bb4:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  104bbb:	00 
  104bbc:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104bc3:	e8 5e b8 ff ff       	call   100426 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  104bc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bcb:	89 04 24             	mov    %eax,(%esp)
  104bce:	e8 99 f7 ff ff       	call   10436c <page2pa>
  104bd3:	8b 15 80 ce 11 00    	mov    0x11ce80,%edx
  104bd9:	c1 e2 0c             	shl    $0xc,%edx
  104bdc:	39 d0                	cmp    %edx,%eax
  104bde:	72 24                	jb     104c04 <basic_check+0x209>
  104be0:	c7 44 24 0c ea 6f 10 	movl   $0x106fea,0xc(%esp)
  104be7:	00 
  104be8:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104bef:	00 
  104bf0:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  104bf7:	00 
  104bf8:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104bff:	e8 22 b8 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  104c04:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  104c09:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  104c0f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104c12:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104c15:	c7 45 dc 1c cf 11 00 	movl   $0x11cf1c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c1f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104c22:	89 50 04             	mov    %edx,0x4(%eax)
  104c25:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c28:	8b 50 04             	mov    0x4(%eax),%edx
  104c2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104c2e:	89 10                	mov    %edx,(%eax)
}
  104c30:	90                   	nop
  104c31:	c7 45 e0 1c cf 11 00 	movl   $0x11cf1c,-0x20(%ebp)
    return list->next == list;
  104c38:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104c3b:	8b 40 04             	mov    0x4(%eax),%eax
  104c3e:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104c41:	0f 94 c0             	sete   %al
  104c44:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104c47:	85 c0                	test   %eax,%eax
  104c49:	75 24                	jne    104c6f <basic_check+0x274>
  104c4b:	c7 44 24 0c 07 70 10 	movl   $0x107007,0xc(%esp)
  104c52:	00 
  104c53:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104c5a:	00 
  104c5b:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104c62:	00 
  104c63:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104c6a:	e8 b7 b7 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  104c6f:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104c74:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104c77:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  104c7e:	00 00 00 

    assert(alloc_page() == NULL);
  104c81:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c88:	e8 fa df ff ff       	call   102c87 <alloc_pages>
  104c8d:	85 c0                	test   %eax,%eax
  104c8f:	74 24                	je     104cb5 <basic_check+0x2ba>
  104c91:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  104c98:	00 
  104c99:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ca0:	00 
  104ca1:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
  104ca8:	00 
  104ca9:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104cb0:	e8 71 b7 ff ff       	call   100426 <__panic>

    free_page(p0);
  104cb5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104cbc:	00 
  104cbd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104cc0:	89 04 24             	mov    %eax,(%esp)
  104cc3:	e8 fb df ff ff       	call   102cc3 <free_pages>
    free_page(p1);
  104cc8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ccf:	00 
  104cd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104cd3:	89 04 24             	mov    %eax,(%esp)
  104cd6:	e8 e8 df ff ff       	call   102cc3 <free_pages>
    free_page(p2);
  104cdb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ce2:	00 
  104ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ce6:	89 04 24             	mov    %eax,(%esp)
  104ce9:	e8 d5 df ff ff       	call   102cc3 <free_pages>
    assert(nr_free == 3);
  104cee:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104cf3:	83 f8 03             	cmp    $0x3,%eax
  104cf6:	74 24                	je     104d1c <basic_check+0x321>
  104cf8:	c7 44 24 0c 33 70 10 	movl   $0x107033,0xc(%esp)
  104cff:	00 
  104d00:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d07:	00 
  104d08:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
  104d0f:	00 
  104d10:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d17:	e8 0a b7 ff ff       	call   100426 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104d1c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d23:	e8 5f df ff ff       	call   102c87 <alloc_pages>
  104d28:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104d2b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104d2f:	75 24                	jne    104d55 <basic_check+0x35a>
  104d31:	c7 44 24 0c fc 6e 10 	movl   $0x106efc,0xc(%esp)
  104d38:	00 
  104d39:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d40:	00 
  104d41:	c7 44 24 04 ed 00 00 	movl   $0xed,0x4(%esp)
  104d48:	00 
  104d49:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d50:	e8 d1 b6 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104d55:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d5c:	e8 26 df ff ff       	call   102c87 <alloc_pages>
  104d61:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d64:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d68:	75 24                	jne    104d8e <basic_check+0x393>
  104d6a:	c7 44 24 0c 18 6f 10 	movl   $0x106f18,0xc(%esp)
  104d71:	00 
  104d72:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104d79:	00 
  104d7a:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  104d81:	00 
  104d82:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104d89:	e8 98 b6 ff ff       	call   100426 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104d8e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104d95:	e8 ed de ff ff       	call   102c87 <alloc_pages>
  104d9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104d9d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104da1:	75 24                	jne    104dc7 <basic_check+0x3cc>
  104da3:	c7 44 24 0c 34 6f 10 	movl   $0x106f34,0xc(%esp)
  104daa:	00 
  104dab:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104db2:	00 
  104db3:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  104dba:	00 
  104dbb:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104dc2:	e8 5f b6 ff ff       	call   100426 <__panic>

    assert(alloc_page() == NULL);
  104dc7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104dce:	e8 b4 de ff ff       	call   102c87 <alloc_pages>
  104dd3:	85 c0                	test   %eax,%eax
  104dd5:	74 24                	je     104dfb <basic_check+0x400>
  104dd7:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  104dde:	00 
  104ddf:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104de6:	00 
  104de7:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
  104dee:	00 
  104def:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104df6:	e8 2b b6 ff ff       	call   100426 <__panic>

    free_page(p0);
  104dfb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e02:	00 
  104e03:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104e06:	89 04 24             	mov    %eax,(%esp)
  104e09:	e8 b5 de ff ff       	call   102cc3 <free_pages>
  104e0e:	c7 45 d8 1c cf 11 00 	movl   $0x11cf1c,-0x28(%ebp)
  104e15:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104e18:	8b 40 04             	mov    0x4(%eax),%eax
  104e1b:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104e1e:	0f 94 c0             	sete   %al
  104e21:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104e24:	85 c0                	test   %eax,%eax
  104e26:	74 24                	je     104e4c <basic_check+0x451>
  104e28:	c7 44 24 0c 40 70 10 	movl   $0x107040,0xc(%esp)
  104e2f:	00 
  104e30:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104e37:	00 
  104e38:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
  104e3f:	00 
  104e40:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104e47:	e8 da b5 ff ff       	call   100426 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104e4c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e53:	e8 2f de ff ff       	call   102c87 <alloc_pages>
  104e58:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104e5b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e5e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104e61:	74 24                	je     104e87 <basic_check+0x48c>
  104e63:	c7 44 24 0c 58 70 10 	movl   $0x107058,0xc(%esp)
  104e6a:	00 
  104e6b:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104e72:	00 
  104e73:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
  104e7a:	00 
  104e7b:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104e82:	e8 9f b5 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  104e87:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104e8e:	e8 f4 dd ff ff       	call   102c87 <alloc_pages>
  104e93:	85 c0                	test   %eax,%eax
  104e95:	74 24                	je     104ebb <basic_check+0x4c0>
  104e97:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  104e9e:	00 
  104e9f:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ea6:	00 
  104ea7:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  104eae:	00 
  104eaf:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104eb6:	e8 6b b5 ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  104ebb:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  104ec0:	85 c0                	test   %eax,%eax
  104ec2:	74 24                	je     104ee8 <basic_check+0x4ed>
  104ec4:	c7 44 24 0c 71 70 10 	movl   $0x107071,0xc(%esp)
  104ecb:	00 
  104ecc:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104ed3:	00 
  104ed4:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  104edb:	00 
  104edc:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104ee3:	e8 3e b5 ff ff       	call   100426 <__panic>
    free_list = free_list_store;
  104ee8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104eeb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104eee:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  104ef3:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    nr_free = nr_free_store;
  104ef9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104efc:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_page(p);
  104f01:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f08:	00 
  104f09:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f0c:	89 04 24             	mov    %eax,(%esp)
  104f0f:	e8 af dd ff ff       	call   102cc3 <free_pages>
    free_page(p1);
  104f14:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f1b:	00 
  104f1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f1f:	89 04 24             	mov    %eax,(%esp)
  104f22:	e8 9c dd ff ff       	call   102cc3 <free_pages>
    free_page(p2);
  104f27:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104f2e:	00 
  104f2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f32:	89 04 24             	mov    %eax,(%esp)
  104f35:	e8 89 dd ff ff       	call   102cc3 <free_pages>
}
  104f3a:	90                   	nop
  104f3b:	c9                   	leave  
  104f3c:	c3                   	ret    

00104f3d <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104f3d:	f3 0f 1e fb          	endbr32 
  104f41:	55                   	push   %ebp
  104f42:	89 e5                	mov    %esp,%ebp
  104f44:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104f4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104f51:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104f58:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104f5f:	eb 6a                	jmp    104fcb <default_check+0x8e>
        struct Page *p = le2page(le, page_link);
  104f61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104f64:	83 e8 0c             	sub    $0xc,%eax
  104f67:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104f6a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104f6d:	83 c0 04             	add    $0x4,%eax
  104f70:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104f77:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104f7a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104f7d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104f80:	0f a3 10             	bt     %edx,(%eax)
  104f83:	19 c0                	sbb    %eax,%eax
  104f85:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104f88:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104f8c:	0f 95 c0             	setne  %al
  104f8f:	0f b6 c0             	movzbl %al,%eax
  104f92:	85 c0                	test   %eax,%eax
  104f94:	75 24                	jne    104fba <default_check+0x7d>
  104f96:	c7 44 24 0c 7e 70 10 	movl   $0x10707e,0xc(%esp)
  104f9d:	00 
  104f9e:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  104fa5:	00 
  104fa6:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  104fad:	00 
  104fae:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  104fb5:	e8 6c b4 ff ff       	call   100426 <__panic>
        count ++, total += p->property;
  104fba:	ff 45 f4             	incl   -0xc(%ebp)
  104fbd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104fc0:	8b 50 08             	mov    0x8(%eax),%edx
  104fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104fc6:	01 d0                	add    %edx,%eax
  104fc8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104fcb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104fce:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104fd1:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104fd4:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104fd7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104fda:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  104fe1:	0f 85 7a ff ff ff    	jne    104f61 <default_check+0x24>
    }
    assert(total == nr_free_pages());
  104fe7:	e8 0e dd ff ff       	call   102cfa <nr_free_pages>
  104fec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  104fef:	39 d0                	cmp    %edx,%eax
  104ff1:	74 24                	je     105017 <default_check+0xda>
  104ff3:	c7 44 24 0c 8e 70 10 	movl   $0x10708e,0xc(%esp)
  104ffa:	00 
  104ffb:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105002:	00 
  105003:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  10500a:	00 
  10500b:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105012:	e8 0f b4 ff ff       	call   100426 <__panic>

    basic_check();
  105017:	e8 df f9 ff ff       	call   1049fb <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10501c:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105023:	e8 5f dc ff ff       	call   102c87 <alloc_pages>
  105028:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  10502b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10502f:	75 24                	jne    105055 <default_check+0x118>
  105031:	c7 44 24 0c a7 70 10 	movl   $0x1070a7,0xc(%esp)
  105038:	00 
  105039:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105040:	00 
  105041:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  105048:	00 
  105049:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105050:	e8 d1 b3 ff ff       	call   100426 <__panic>
    assert(!PageProperty(p0));
  105055:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105058:	83 c0 04             	add    $0x4,%eax
  10505b:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  105062:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105065:	8b 45 bc             	mov    -0x44(%ebp),%eax
  105068:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10506b:	0f a3 10             	bt     %edx,(%eax)
  10506e:	19 c0                	sbb    %eax,%eax
  105070:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  105073:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  105077:	0f 95 c0             	setne  %al
  10507a:	0f b6 c0             	movzbl %al,%eax
  10507d:	85 c0                	test   %eax,%eax
  10507f:	74 24                	je     1050a5 <default_check+0x168>
  105081:	c7 44 24 0c b2 70 10 	movl   $0x1070b2,0xc(%esp)
  105088:	00 
  105089:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105090:	00 
  105091:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  105098:	00 
  105099:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1050a0:	e8 81 b3 ff ff       	call   100426 <__panic>

    list_entry_t free_list_store = free_list;
  1050a5:	a1 1c cf 11 00       	mov    0x11cf1c,%eax
  1050aa:	8b 15 20 cf 11 00    	mov    0x11cf20,%edx
  1050b0:	89 45 80             	mov    %eax,-0x80(%ebp)
  1050b3:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1050b6:	c7 45 b0 1c cf 11 00 	movl   $0x11cf1c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  1050bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050c0:	8b 55 b0             	mov    -0x50(%ebp),%edx
  1050c3:	89 50 04             	mov    %edx,0x4(%eax)
  1050c6:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050c9:	8b 50 04             	mov    0x4(%eax),%edx
  1050cc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1050cf:	89 10                	mov    %edx,(%eax)
}
  1050d1:	90                   	nop
  1050d2:	c7 45 b4 1c cf 11 00 	movl   $0x11cf1c,-0x4c(%ebp)
    return list->next == list;
  1050d9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1050dc:	8b 40 04             	mov    0x4(%eax),%eax
  1050df:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  1050e2:	0f 94 c0             	sete   %al
  1050e5:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1050e8:	85 c0                	test   %eax,%eax
  1050ea:	75 24                	jne    105110 <default_check+0x1d3>
  1050ec:	c7 44 24 0c 07 70 10 	movl   $0x107007,0xc(%esp)
  1050f3:	00 
  1050f4:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1050fb:	00 
  1050fc:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  105103:	00 
  105104:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10510b:	e8 16 b3 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  105110:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105117:	e8 6b db ff ff       	call   102c87 <alloc_pages>
  10511c:	85 c0                	test   %eax,%eax
  10511e:	74 24                	je     105144 <default_check+0x207>
  105120:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  105127:	00 
  105128:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10512f:	00 
  105130:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  105137:	00 
  105138:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10513f:	e8 e2 b2 ff ff       	call   100426 <__panic>

    unsigned int nr_free_store = nr_free;
  105144:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  105149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  10514c:	c7 05 24 cf 11 00 00 	movl   $0x0,0x11cf24
  105153:	00 00 00 

    free_pages(p0 + 2, 3);
  105156:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105159:	83 c0 28             	add    $0x28,%eax
  10515c:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  105163:	00 
  105164:	89 04 24             	mov    %eax,(%esp)
  105167:	e8 57 db ff ff       	call   102cc3 <free_pages>
    assert(alloc_pages(4) == NULL);
  10516c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  105173:	e8 0f db ff ff       	call   102c87 <alloc_pages>
  105178:	85 c0                	test   %eax,%eax
  10517a:	74 24                	je     1051a0 <default_check+0x263>
  10517c:	c7 44 24 0c c4 70 10 	movl   $0x1070c4,0xc(%esp)
  105183:	00 
  105184:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10518b:	00 
  10518c:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  105193:	00 
  105194:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10519b:	e8 86 b2 ff ff       	call   100426 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1051a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051a3:	83 c0 28             	add    $0x28,%eax
  1051a6:	83 c0 04             	add    $0x4,%eax
  1051a9:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1051b0:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1051b3:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1051b6:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1051b9:	0f a3 10             	bt     %edx,(%eax)
  1051bc:	19 c0                	sbb    %eax,%eax
  1051be:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1051c1:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1051c5:	0f 95 c0             	setne  %al
  1051c8:	0f b6 c0             	movzbl %al,%eax
  1051cb:	85 c0                	test   %eax,%eax
  1051cd:	74 0e                	je     1051dd <default_check+0x2a0>
  1051cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051d2:	83 c0 28             	add    $0x28,%eax
  1051d5:	8b 40 08             	mov    0x8(%eax),%eax
  1051d8:	83 f8 03             	cmp    $0x3,%eax
  1051db:	74 24                	je     105201 <default_check+0x2c4>
  1051dd:	c7 44 24 0c dc 70 10 	movl   $0x1070dc,0xc(%esp)
  1051e4:	00 
  1051e5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1051ec:	00 
  1051ed:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1051f4:	00 
  1051f5:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1051fc:	e8 25 b2 ff ff       	call   100426 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105201:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  105208:	e8 7a da ff ff       	call   102c87 <alloc_pages>
  10520d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105210:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105214:	75 24                	jne    10523a <default_check+0x2fd>
  105216:	c7 44 24 0c 08 71 10 	movl   $0x107108,0xc(%esp)
  10521d:	00 
  10521e:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105225:	00 
  105226:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  10522d:	00 
  10522e:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105235:	e8 ec b1 ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  10523a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105241:	e8 41 da ff ff       	call   102c87 <alloc_pages>
  105246:	85 c0                	test   %eax,%eax
  105248:	74 24                	je     10526e <default_check+0x331>
  10524a:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  105251:	00 
  105252:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105259:	00 
  10525a:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  105261:	00 
  105262:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105269:	e8 b8 b1 ff ff       	call   100426 <__panic>
    assert(p0 + 2 == p1);
  10526e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105271:	83 c0 28             	add    $0x28,%eax
  105274:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  105277:	74 24                	je     10529d <default_check+0x360>
  105279:	c7 44 24 0c 26 71 10 	movl   $0x107126,0xc(%esp)
  105280:	00 
  105281:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105288:	00 
  105289:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  105290:	00 
  105291:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105298:	e8 89 b1 ff ff       	call   100426 <__panic>

    p2 = p0 + 1;
  10529d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052a0:	83 c0 14             	add    $0x14,%eax
  1052a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1052a6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1052ad:	00 
  1052ae:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052b1:	89 04 24             	mov    %eax,(%esp)
  1052b4:	e8 0a da ff ff       	call   102cc3 <free_pages>
    free_pages(p1, 3);
  1052b9:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1052c0:	00 
  1052c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052c4:	89 04 24             	mov    %eax,(%esp)
  1052c7:	e8 f7 d9 ff ff       	call   102cc3 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1052cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052cf:	83 c0 04             	add    $0x4,%eax
  1052d2:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1052d9:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1052dc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1052df:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1052e2:	0f a3 10             	bt     %edx,(%eax)
  1052e5:	19 c0                	sbb    %eax,%eax
  1052e7:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1052ea:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1052ee:	0f 95 c0             	setne  %al
  1052f1:	0f b6 c0             	movzbl %al,%eax
  1052f4:	85 c0                	test   %eax,%eax
  1052f6:	74 0b                	je     105303 <default_check+0x3c6>
  1052f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1052fb:	8b 40 08             	mov    0x8(%eax),%eax
  1052fe:	83 f8 01             	cmp    $0x1,%eax
  105301:	74 24                	je     105327 <default_check+0x3ea>
  105303:	c7 44 24 0c 34 71 10 	movl   $0x107134,0xc(%esp)
  10530a:	00 
  10530b:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105312:	00 
  105313:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
  10531a:	00 
  10531b:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105322:	e8 ff b0 ff ff       	call   100426 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  105327:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10532a:	83 c0 04             	add    $0x4,%eax
  10532d:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105334:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  105337:	8b 45 90             	mov    -0x70(%ebp),%eax
  10533a:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10533d:	0f a3 10             	bt     %edx,(%eax)
  105340:	19 c0                	sbb    %eax,%eax
  105342:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105345:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  105349:	0f 95 c0             	setne  %al
  10534c:	0f b6 c0             	movzbl %al,%eax
  10534f:	85 c0                	test   %eax,%eax
  105351:	74 0b                	je     10535e <default_check+0x421>
  105353:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105356:	8b 40 08             	mov    0x8(%eax),%eax
  105359:	83 f8 03             	cmp    $0x3,%eax
  10535c:	74 24                	je     105382 <default_check+0x445>
  10535e:	c7 44 24 0c 5c 71 10 	movl   $0x10715c,0xc(%esp)
  105365:	00 
  105366:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10536d:	00 
  10536e:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  105375:	00 
  105376:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10537d:	e8 a4 b0 ff ff       	call   100426 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105382:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105389:	e8 f9 d8 ff ff       	call   102c87 <alloc_pages>
  10538e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105391:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105394:	83 e8 14             	sub    $0x14,%eax
  105397:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10539a:	74 24                	je     1053c0 <default_check+0x483>
  10539c:	c7 44 24 0c 82 71 10 	movl   $0x107182,0xc(%esp)
  1053a3:	00 
  1053a4:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1053ab:	00 
  1053ac:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1053b3:	00 
  1053b4:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1053bb:	e8 66 b0 ff ff       	call   100426 <__panic>
    free_page(p0);
  1053c0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1053c7:	00 
  1053c8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1053cb:	89 04 24             	mov    %eax,(%esp)
  1053ce:	e8 f0 d8 ff ff       	call   102cc3 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1053d3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1053da:	e8 a8 d8 ff ff       	call   102c87 <alloc_pages>
  1053df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1053e2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053e5:	83 c0 14             	add    $0x14,%eax
  1053e8:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1053eb:	74 24                	je     105411 <default_check+0x4d4>
  1053ed:	c7 44 24 0c a0 71 10 	movl   $0x1071a0,0xc(%esp)
  1053f4:	00 
  1053f5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1053fc:	00 
  1053fd:	c7 44 24 04 2d 01 00 	movl   $0x12d,0x4(%esp)
  105404:	00 
  105405:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10540c:	e8 15 b0 ff ff       	call   100426 <__panic>

    free_pages(p0, 2);
  105411:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  105418:	00 
  105419:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10541c:	89 04 24             	mov    %eax,(%esp)
  10541f:	e8 9f d8 ff ff       	call   102cc3 <free_pages>
    free_page(p2);
  105424:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10542b:	00 
  10542c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10542f:	89 04 24             	mov    %eax,(%esp)
  105432:	e8 8c d8 ff ff       	call   102cc3 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  105437:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10543e:	e8 44 d8 ff ff       	call   102c87 <alloc_pages>
  105443:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105446:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10544a:	75 24                	jne    105470 <default_check+0x533>
  10544c:	c7 44 24 0c c0 71 10 	movl   $0x1071c0,0xc(%esp)
  105453:	00 
  105454:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10545b:	00 
  10545c:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
  105463:	00 
  105464:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10546b:	e8 b6 af ff ff       	call   100426 <__panic>
    assert(alloc_page() == NULL);
  105470:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105477:	e8 0b d8 ff ff       	call   102c87 <alloc_pages>
  10547c:	85 c0                	test   %eax,%eax
  10547e:	74 24                	je     1054a4 <default_check+0x567>
  105480:	c7 44 24 0c 1e 70 10 	movl   $0x10701e,0xc(%esp)
  105487:	00 
  105488:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10548f:	00 
  105490:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  105497:	00 
  105498:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10549f:	e8 82 af ff ff       	call   100426 <__panic>

    assert(nr_free == 0);
  1054a4:	a1 24 cf 11 00       	mov    0x11cf24,%eax
  1054a9:	85 c0                	test   %eax,%eax
  1054ab:	74 24                	je     1054d1 <default_check+0x594>
  1054ad:	c7 44 24 0c 71 70 10 	movl   $0x107071,0xc(%esp)
  1054b4:	00 
  1054b5:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  1054bc:	00 
  1054bd:	c7 44 24 04 35 01 00 	movl   $0x135,0x4(%esp)
  1054c4:	00 
  1054c5:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  1054cc:	e8 55 af ff ff       	call   100426 <__panic>
    nr_free = nr_free_store;
  1054d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1054d4:	a3 24 cf 11 00       	mov    %eax,0x11cf24

    free_list = free_list_store;
  1054d9:	8b 45 80             	mov    -0x80(%ebp),%eax
  1054dc:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1054df:	a3 1c cf 11 00       	mov    %eax,0x11cf1c
  1054e4:	89 15 20 cf 11 00    	mov    %edx,0x11cf20
    free_pages(p0, 5);
  1054ea:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  1054f1:	00 
  1054f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054f5:	89 04 24             	mov    %eax,(%esp)
  1054f8:	e8 c6 d7 ff ff       	call   102cc3 <free_pages>

    le = &free_list;
  1054fd:	c7 45 ec 1c cf 11 00 	movl   $0x11cf1c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105504:	eb 1c                	jmp    105522 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
  105506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105509:	83 e8 0c             	sub    $0xc,%eax
  10550c:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  10550f:	ff 4d f4             	decl   -0xc(%ebp)
  105512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105515:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105518:	8b 40 08             	mov    0x8(%eax),%eax
  10551b:	29 c2                	sub    %eax,%edx
  10551d:	89 d0                	mov    %edx,%eax
  10551f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105522:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105525:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105528:	8b 45 88             	mov    -0x78(%ebp),%eax
  10552b:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10552e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105531:	81 7d ec 1c cf 11 00 	cmpl   $0x11cf1c,-0x14(%ebp)
  105538:	75 cc                	jne    105506 <default_check+0x5c9>
    }
    assert(count == 0);
  10553a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10553e:	74 24                	je     105564 <default_check+0x627>
  105540:	c7 44 24 0c de 71 10 	movl   $0x1071de,0xc(%esp)
  105547:	00 
  105548:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  10554f:	00 
  105550:	c7 44 24 04 40 01 00 	movl   $0x140,0x4(%esp)
  105557:	00 
  105558:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  10555f:	e8 c2 ae ff ff       	call   100426 <__panic>
    assert(total == 0);
  105564:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105568:	74 24                	je     10558e <default_check+0x651>
  10556a:	c7 44 24 0c e9 71 10 	movl   $0x1071e9,0xc(%esp)
  105571:	00 
  105572:	c7 44 24 08 7e 6e 10 	movl   $0x106e7e,0x8(%esp)
  105579:	00 
  10557a:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  105581:	00 
  105582:	c7 04 24 93 6e 10 00 	movl   $0x106e93,(%esp)
  105589:	e8 98 ae ff ff       	call   100426 <__panic>
}
  10558e:	90                   	nop
  10558f:	c9                   	leave  
  105590:	c3                   	ret    

00105591 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105591:	f3 0f 1e fb          	endbr32 
  105595:	55                   	push   %ebp
  105596:	89 e5                	mov    %esp,%ebp
  105598:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10559b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1055a2:	eb 03                	jmp    1055a7 <strlen+0x16>
        cnt ++;
  1055a4:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1055a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1055aa:	8d 50 01             	lea    0x1(%eax),%edx
  1055ad:	89 55 08             	mov    %edx,0x8(%ebp)
  1055b0:	0f b6 00             	movzbl (%eax),%eax
  1055b3:	84 c0                	test   %al,%al
  1055b5:	75 ed                	jne    1055a4 <strlen+0x13>
    }
    return cnt;
  1055b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055ba:	c9                   	leave  
  1055bb:	c3                   	ret    

001055bc <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1055bc:	f3 0f 1e fb          	endbr32 
  1055c0:	55                   	push   %ebp
  1055c1:	89 e5                	mov    %esp,%ebp
  1055c3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1055c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055cd:	eb 03                	jmp    1055d2 <strnlen+0x16>
        cnt ++;
  1055cf:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1055d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1055d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1055d8:	73 10                	jae    1055ea <strnlen+0x2e>
  1055da:	8b 45 08             	mov    0x8(%ebp),%eax
  1055dd:	8d 50 01             	lea    0x1(%eax),%edx
  1055e0:	89 55 08             	mov    %edx,0x8(%ebp)
  1055e3:	0f b6 00             	movzbl (%eax),%eax
  1055e6:	84 c0                	test   %al,%al
  1055e8:	75 e5                	jne    1055cf <strnlen+0x13>
    }
    return cnt;
  1055ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1055ed:	c9                   	leave  
  1055ee:	c3                   	ret    

001055ef <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1055ef:	f3 0f 1e fb          	endbr32 
  1055f3:	55                   	push   %ebp
  1055f4:	89 e5                	mov    %esp,%ebp
  1055f6:	57                   	push   %edi
  1055f7:	56                   	push   %esi
  1055f8:	83 ec 20             	sub    $0x20,%esp
  1055fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1055fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105601:	8b 45 0c             	mov    0xc(%ebp),%eax
  105604:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105607:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10560a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10560d:	89 d1                	mov    %edx,%ecx
  10560f:	89 c2                	mov    %eax,%edx
  105611:	89 ce                	mov    %ecx,%esi
  105613:	89 d7                	mov    %edx,%edi
  105615:	ac                   	lods   %ds:(%esi),%al
  105616:	aa                   	stos   %al,%es:(%edi)
  105617:	84 c0                	test   %al,%al
  105619:	75 fa                	jne    105615 <strcpy+0x26>
  10561b:	89 fa                	mov    %edi,%edx
  10561d:	89 f1                	mov    %esi,%ecx
  10561f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105622:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105625:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105628:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  10562b:	83 c4 20             	add    $0x20,%esp
  10562e:	5e                   	pop    %esi
  10562f:	5f                   	pop    %edi
  105630:	5d                   	pop    %ebp
  105631:	c3                   	ret    

00105632 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105632:	f3 0f 1e fb          	endbr32 
  105636:	55                   	push   %ebp
  105637:	89 e5                	mov    %esp,%ebp
  105639:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10563c:	8b 45 08             	mov    0x8(%ebp),%eax
  10563f:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105642:	eb 1e                	jmp    105662 <strncpy+0x30>
        if ((*p = *src) != '\0') {
  105644:	8b 45 0c             	mov    0xc(%ebp),%eax
  105647:	0f b6 10             	movzbl (%eax),%edx
  10564a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10564d:	88 10                	mov    %dl,(%eax)
  10564f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105652:	0f b6 00             	movzbl (%eax),%eax
  105655:	84 c0                	test   %al,%al
  105657:	74 03                	je     10565c <strncpy+0x2a>
            src ++;
  105659:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  10565c:	ff 45 fc             	incl   -0x4(%ebp)
  10565f:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  105662:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105666:	75 dc                	jne    105644 <strncpy+0x12>
    }
    return dst;
  105668:	8b 45 08             	mov    0x8(%ebp),%eax
}
  10566b:	c9                   	leave  
  10566c:	c3                   	ret    

0010566d <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  10566d:	f3 0f 1e fb          	endbr32 
  105671:	55                   	push   %ebp
  105672:	89 e5                	mov    %esp,%ebp
  105674:	57                   	push   %edi
  105675:	56                   	push   %esi
  105676:	83 ec 20             	sub    $0x20,%esp
  105679:	8b 45 08             	mov    0x8(%ebp),%eax
  10567c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10567f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105682:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  105685:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105688:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10568b:	89 d1                	mov    %edx,%ecx
  10568d:	89 c2                	mov    %eax,%edx
  10568f:	89 ce                	mov    %ecx,%esi
  105691:	89 d7                	mov    %edx,%edi
  105693:	ac                   	lods   %ds:(%esi),%al
  105694:	ae                   	scas   %es:(%edi),%al
  105695:	75 08                	jne    10569f <strcmp+0x32>
  105697:	84 c0                	test   %al,%al
  105699:	75 f8                	jne    105693 <strcmp+0x26>
  10569b:	31 c0                	xor    %eax,%eax
  10569d:	eb 04                	jmp    1056a3 <strcmp+0x36>
  10569f:	19 c0                	sbb    %eax,%eax
  1056a1:	0c 01                	or     $0x1,%al
  1056a3:	89 fa                	mov    %edi,%edx
  1056a5:	89 f1                	mov    %esi,%ecx
  1056a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1056aa:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1056ad:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1056b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1056b3:	83 c4 20             	add    $0x20,%esp
  1056b6:	5e                   	pop    %esi
  1056b7:	5f                   	pop    %edi
  1056b8:	5d                   	pop    %ebp
  1056b9:	c3                   	ret    

001056ba <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1056ba:	f3 0f 1e fb          	endbr32 
  1056be:	55                   	push   %ebp
  1056bf:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056c1:	eb 09                	jmp    1056cc <strncmp+0x12>
        n --, s1 ++, s2 ++;
  1056c3:	ff 4d 10             	decl   0x10(%ebp)
  1056c6:	ff 45 08             	incl   0x8(%ebp)
  1056c9:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1056cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056d0:	74 1a                	je     1056ec <strncmp+0x32>
  1056d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056d5:	0f b6 00             	movzbl (%eax),%eax
  1056d8:	84 c0                	test   %al,%al
  1056da:	74 10                	je     1056ec <strncmp+0x32>
  1056dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1056df:	0f b6 10             	movzbl (%eax),%edx
  1056e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056e5:	0f b6 00             	movzbl (%eax),%eax
  1056e8:	38 c2                	cmp    %al,%dl
  1056ea:	74 d7                	je     1056c3 <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1056ec:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1056f0:	74 18                	je     10570a <strncmp+0x50>
  1056f2:	8b 45 08             	mov    0x8(%ebp),%eax
  1056f5:	0f b6 00             	movzbl (%eax),%eax
  1056f8:	0f b6 d0             	movzbl %al,%edx
  1056fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056fe:	0f b6 00             	movzbl (%eax),%eax
  105701:	0f b6 c0             	movzbl %al,%eax
  105704:	29 c2                	sub    %eax,%edx
  105706:	89 d0                	mov    %edx,%eax
  105708:	eb 05                	jmp    10570f <strncmp+0x55>
  10570a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10570f:	5d                   	pop    %ebp
  105710:	c3                   	ret    

00105711 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105711:	f3 0f 1e fb          	endbr32 
  105715:	55                   	push   %ebp
  105716:	89 e5                	mov    %esp,%ebp
  105718:	83 ec 04             	sub    $0x4,%esp
  10571b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10571e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105721:	eb 13                	jmp    105736 <strchr+0x25>
        if (*s == c) {
  105723:	8b 45 08             	mov    0x8(%ebp),%eax
  105726:	0f b6 00             	movzbl (%eax),%eax
  105729:	38 45 fc             	cmp    %al,-0x4(%ebp)
  10572c:	75 05                	jne    105733 <strchr+0x22>
            return (char *)s;
  10572e:	8b 45 08             	mov    0x8(%ebp),%eax
  105731:	eb 12                	jmp    105745 <strchr+0x34>
        }
        s ++;
  105733:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105736:	8b 45 08             	mov    0x8(%ebp),%eax
  105739:	0f b6 00             	movzbl (%eax),%eax
  10573c:	84 c0                	test   %al,%al
  10573e:	75 e3                	jne    105723 <strchr+0x12>
    }
    return NULL;
  105740:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105745:	c9                   	leave  
  105746:	c3                   	ret    

00105747 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105747:	f3 0f 1e fb          	endbr32 
  10574b:	55                   	push   %ebp
  10574c:	89 e5                	mov    %esp,%ebp
  10574e:	83 ec 04             	sub    $0x4,%esp
  105751:	8b 45 0c             	mov    0xc(%ebp),%eax
  105754:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105757:	eb 0e                	jmp    105767 <strfind+0x20>
        if (*s == c) {
  105759:	8b 45 08             	mov    0x8(%ebp),%eax
  10575c:	0f b6 00             	movzbl (%eax),%eax
  10575f:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105762:	74 0f                	je     105773 <strfind+0x2c>
            break;
        }
        s ++;
  105764:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  105767:	8b 45 08             	mov    0x8(%ebp),%eax
  10576a:	0f b6 00             	movzbl (%eax),%eax
  10576d:	84 c0                	test   %al,%al
  10576f:	75 e8                	jne    105759 <strfind+0x12>
  105771:	eb 01                	jmp    105774 <strfind+0x2d>
            break;
  105773:	90                   	nop
    }
    return (char *)s;
  105774:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105777:	c9                   	leave  
  105778:	c3                   	ret    

00105779 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105779:	f3 0f 1e fb          	endbr32 
  10577d:	55                   	push   %ebp
  10577e:	89 e5                	mov    %esp,%ebp
  105780:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105783:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  10578a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105791:	eb 03                	jmp    105796 <strtol+0x1d>
        s ++;
  105793:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  105796:	8b 45 08             	mov    0x8(%ebp),%eax
  105799:	0f b6 00             	movzbl (%eax),%eax
  10579c:	3c 20                	cmp    $0x20,%al
  10579e:	74 f3                	je     105793 <strtol+0x1a>
  1057a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057a3:	0f b6 00             	movzbl (%eax),%eax
  1057a6:	3c 09                	cmp    $0x9,%al
  1057a8:	74 e9                	je     105793 <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  1057aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1057ad:	0f b6 00             	movzbl (%eax),%eax
  1057b0:	3c 2b                	cmp    $0x2b,%al
  1057b2:	75 05                	jne    1057b9 <strtol+0x40>
        s ++;
  1057b4:	ff 45 08             	incl   0x8(%ebp)
  1057b7:	eb 14                	jmp    1057cd <strtol+0x54>
    }
    else if (*s == '-') {
  1057b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057bc:	0f b6 00             	movzbl (%eax),%eax
  1057bf:	3c 2d                	cmp    $0x2d,%al
  1057c1:	75 0a                	jne    1057cd <strtol+0x54>
        s ++, neg = 1;
  1057c3:	ff 45 08             	incl   0x8(%ebp)
  1057c6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1057cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057d1:	74 06                	je     1057d9 <strtol+0x60>
  1057d3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1057d7:	75 22                	jne    1057fb <strtol+0x82>
  1057d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057dc:	0f b6 00             	movzbl (%eax),%eax
  1057df:	3c 30                	cmp    $0x30,%al
  1057e1:	75 18                	jne    1057fb <strtol+0x82>
  1057e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1057e6:	40                   	inc    %eax
  1057e7:	0f b6 00             	movzbl (%eax),%eax
  1057ea:	3c 78                	cmp    $0x78,%al
  1057ec:	75 0d                	jne    1057fb <strtol+0x82>
        s += 2, base = 16;
  1057ee:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1057f2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1057f9:	eb 29                	jmp    105824 <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  1057fb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1057ff:	75 16                	jne    105817 <strtol+0x9e>
  105801:	8b 45 08             	mov    0x8(%ebp),%eax
  105804:	0f b6 00             	movzbl (%eax),%eax
  105807:	3c 30                	cmp    $0x30,%al
  105809:	75 0c                	jne    105817 <strtol+0x9e>
        s ++, base = 8;
  10580b:	ff 45 08             	incl   0x8(%ebp)
  10580e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105815:	eb 0d                	jmp    105824 <strtol+0xab>
    }
    else if (base == 0) {
  105817:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10581b:	75 07                	jne    105824 <strtol+0xab>
        base = 10;
  10581d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105824:	8b 45 08             	mov    0x8(%ebp),%eax
  105827:	0f b6 00             	movzbl (%eax),%eax
  10582a:	3c 2f                	cmp    $0x2f,%al
  10582c:	7e 1b                	jle    105849 <strtol+0xd0>
  10582e:	8b 45 08             	mov    0x8(%ebp),%eax
  105831:	0f b6 00             	movzbl (%eax),%eax
  105834:	3c 39                	cmp    $0x39,%al
  105836:	7f 11                	jg     105849 <strtol+0xd0>
            dig = *s - '0';
  105838:	8b 45 08             	mov    0x8(%ebp),%eax
  10583b:	0f b6 00             	movzbl (%eax),%eax
  10583e:	0f be c0             	movsbl %al,%eax
  105841:	83 e8 30             	sub    $0x30,%eax
  105844:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105847:	eb 48                	jmp    105891 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105849:	8b 45 08             	mov    0x8(%ebp),%eax
  10584c:	0f b6 00             	movzbl (%eax),%eax
  10584f:	3c 60                	cmp    $0x60,%al
  105851:	7e 1b                	jle    10586e <strtol+0xf5>
  105853:	8b 45 08             	mov    0x8(%ebp),%eax
  105856:	0f b6 00             	movzbl (%eax),%eax
  105859:	3c 7a                	cmp    $0x7a,%al
  10585b:	7f 11                	jg     10586e <strtol+0xf5>
            dig = *s - 'a' + 10;
  10585d:	8b 45 08             	mov    0x8(%ebp),%eax
  105860:	0f b6 00             	movzbl (%eax),%eax
  105863:	0f be c0             	movsbl %al,%eax
  105866:	83 e8 57             	sub    $0x57,%eax
  105869:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10586c:	eb 23                	jmp    105891 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10586e:	8b 45 08             	mov    0x8(%ebp),%eax
  105871:	0f b6 00             	movzbl (%eax),%eax
  105874:	3c 40                	cmp    $0x40,%al
  105876:	7e 3b                	jle    1058b3 <strtol+0x13a>
  105878:	8b 45 08             	mov    0x8(%ebp),%eax
  10587b:	0f b6 00             	movzbl (%eax),%eax
  10587e:	3c 5a                	cmp    $0x5a,%al
  105880:	7f 31                	jg     1058b3 <strtol+0x13a>
            dig = *s - 'A' + 10;
  105882:	8b 45 08             	mov    0x8(%ebp),%eax
  105885:	0f b6 00             	movzbl (%eax),%eax
  105888:	0f be c0             	movsbl %al,%eax
  10588b:	83 e8 37             	sub    $0x37,%eax
  10588e:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105894:	3b 45 10             	cmp    0x10(%ebp),%eax
  105897:	7d 19                	jge    1058b2 <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  105899:	ff 45 08             	incl   0x8(%ebp)
  10589c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10589f:	0f af 45 10          	imul   0x10(%ebp),%eax
  1058a3:	89 c2                	mov    %eax,%edx
  1058a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058a8:	01 d0                	add    %edx,%eax
  1058aa:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1058ad:	e9 72 ff ff ff       	jmp    105824 <strtol+0xab>
            break;
  1058b2:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1058b3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1058b7:	74 08                	je     1058c1 <strtol+0x148>
        *endptr = (char *) s;
  1058b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058bc:	8b 55 08             	mov    0x8(%ebp),%edx
  1058bf:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1058c1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1058c5:	74 07                	je     1058ce <strtol+0x155>
  1058c7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1058ca:	f7 d8                	neg    %eax
  1058cc:	eb 03                	jmp    1058d1 <strtol+0x158>
  1058ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1058d1:	c9                   	leave  
  1058d2:	c3                   	ret    

001058d3 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1058d3:	f3 0f 1e fb          	endbr32 
  1058d7:	55                   	push   %ebp
  1058d8:	89 e5                	mov    %esp,%ebp
  1058da:	57                   	push   %edi
  1058db:	83 ec 24             	sub    $0x24,%esp
  1058de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058e1:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1058e4:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  1058e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1058eb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1058ee:	88 55 f7             	mov    %dl,-0x9(%ebp)
  1058f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1058f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1058f7:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1058fa:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1058fe:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105901:	89 d7                	mov    %edx,%edi
  105903:	f3 aa                	rep stos %al,%es:(%edi)
  105905:	89 fa                	mov    %edi,%edx
  105907:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10590a:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  10590d:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105910:	83 c4 24             	add    $0x24,%esp
  105913:	5f                   	pop    %edi
  105914:	5d                   	pop    %ebp
  105915:	c3                   	ret    

00105916 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105916:	f3 0f 1e fb          	endbr32 
  10591a:	55                   	push   %ebp
  10591b:	89 e5                	mov    %esp,%ebp
  10591d:	57                   	push   %edi
  10591e:	56                   	push   %esi
  10591f:	53                   	push   %ebx
  105920:	83 ec 30             	sub    $0x30,%esp
  105923:	8b 45 08             	mov    0x8(%ebp),%eax
  105926:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105929:	8b 45 0c             	mov    0xc(%ebp),%eax
  10592c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10592f:	8b 45 10             	mov    0x10(%ebp),%eax
  105932:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105935:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105938:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10593b:	73 42                	jae    10597f <memmove+0x69>
  10593d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105940:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105943:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105946:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105949:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10594c:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10594f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105952:	c1 e8 02             	shr    $0x2,%eax
  105955:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105957:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10595a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10595d:	89 d7                	mov    %edx,%edi
  10595f:	89 c6                	mov    %eax,%esi
  105961:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105963:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105966:	83 e1 03             	and    $0x3,%ecx
  105969:	74 02                	je     10596d <memmove+0x57>
  10596b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10596d:	89 f0                	mov    %esi,%eax
  10596f:	89 fa                	mov    %edi,%edx
  105971:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105974:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105977:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  10597a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  10597d:	eb 36                	jmp    1059b5 <memmove+0x9f>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10597f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105982:	8d 50 ff             	lea    -0x1(%eax),%edx
  105985:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105988:	01 c2                	add    %eax,%edx
  10598a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10598d:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105993:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  105996:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105999:	89 c1                	mov    %eax,%ecx
  10599b:	89 d8                	mov    %ebx,%eax
  10599d:	89 d6                	mov    %edx,%esi
  10599f:	89 c7                	mov    %eax,%edi
  1059a1:	fd                   	std    
  1059a2:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059a4:	fc                   	cld    
  1059a5:	89 f8                	mov    %edi,%eax
  1059a7:	89 f2                	mov    %esi,%edx
  1059a9:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1059ac:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1059af:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1059b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1059b5:	83 c4 30             	add    $0x30,%esp
  1059b8:	5b                   	pop    %ebx
  1059b9:	5e                   	pop    %esi
  1059ba:	5f                   	pop    %edi
  1059bb:	5d                   	pop    %ebp
  1059bc:	c3                   	ret    

001059bd <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1059bd:	f3 0f 1e fb          	endbr32 
  1059c1:	55                   	push   %ebp
  1059c2:	89 e5                	mov    %esp,%ebp
  1059c4:	57                   	push   %edi
  1059c5:	56                   	push   %esi
  1059c6:	83 ec 20             	sub    $0x20,%esp
  1059c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1059cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1059d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1059d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1059db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1059de:	c1 e8 02             	shr    $0x2,%eax
  1059e1:	89 c1                	mov    %eax,%ecx
    asm volatile (
  1059e3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1059e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1059e9:	89 d7                	mov    %edx,%edi
  1059eb:	89 c6                	mov    %eax,%esi
  1059ed:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1059ef:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1059f2:	83 e1 03             	and    $0x3,%ecx
  1059f5:	74 02                	je     1059f9 <memcpy+0x3c>
  1059f7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1059f9:	89 f0                	mov    %esi,%eax
  1059fb:	89 fa                	mov    %edi,%edx
  1059fd:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105a00:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105a03:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  105a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105a09:	83 c4 20             	add    $0x20,%esp
  105a0c:	5e                   	pop    %esi
  105a0d:	5f                   	pop    %edi
  105a0e:	5d                   	pop    %ebp
  105a0f:	c3                   	ret    

00105a10 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105a10:	f3 0f 1e fb          	endbr32 
  105a14:	55                   	push   %ebp
  105a15:	89 e5                	mov    %esp,%ebp
  105a17:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  105a1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105a20:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a23:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105a26:	eb 2e                	jmp    105a56 <memcmp+0x46>
        if (*s1 != *s2) {
  105a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a2b:	0f b6 10             	movzbl (%eax),%edx
  105a2e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a31:	0f b6 00             	movzbl (%eax),%eax
  105a34:	38 c2                	cmp    %al,%dl
  105a36:	74 18                	je     105a50 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105a38:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105a3b:	0f b6 00             	movzbl (%eax),%eax
  105a3e:	0f b6 d0             	movzbl %al,%edx
  105a41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105a44:	0f b6 00             	movzbl (%eax),%eax
  105a47:	0f b6 c0             	movzbl %al,%eax
  105a4a:	29 c2                	sub    %eax,%edx
  105a4c:	89 d0                	mov    %edx,%eax
  105a4e:	eb 18                	jmp    105a68 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  105a50:	ff 45 fc             	incl   -0x4(%ebp)
  105a53:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105a56:	8b 45 10             	mov    0x10(%ebp),%eax
  105a59:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a5c:	89 55 10             	mov    %edx,0x10(%ebp)
  105a5f:	85 c0                	test   %eax,%eax
  105a61:	75 c5                	jne    105a28 <memcmp+0x18>
    }
    return 0;
  105a63:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105a68:	c9                   	leave  
  105a69:	c3                   	ret    

00105a6a <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105a6a:	f3 0f 1e fb          	endbr32 
  105a6e:	55                   	push   %ebp
  105a6f:	89 e5                	mov    %esp,%ebp
  105a71:	83 ec 58             	sub    $0x58,%esp
  105a74:	8b 45 10             	mov    0x10(%ebp),%eax
  105a77:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105a7a:	8b 45 14             	mov    0x14(%ebp),%eax
  105a7d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  105a80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105a83:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105a86:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a89:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105a8c:	8b 45 18             	mov    0x18(%ebp),%eax
  105a8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105a92:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105a95:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a98:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105a9b:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105a9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aa1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105aa4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105aa8:	74 1c                	je     105ac6 <printnum+0x5c>
  105aaa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105aad:	ba 00 00 00 00       	mov    $0x0,%edx
  105ab2:	f7 75 e4             	divl   -0x1c(%ebp)
  105ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105ab8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105abb:	ba 00 00 00 00       	mov    $0x0,%edx
  105ac0:	f7 75 e4             	divl   -0x1c(%ebp)
  105ac3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ac6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105acc:	f7 75 e4             	divl   -0x1c(%ebp)
  105acf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105ad2:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105ad5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ad8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105adb:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105ade:	89 55 ec             	mov    %edx,-0x14(%ebp)
  105ae1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105ae4:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105ae7:	8b 45 18             	mov    0x18(%ebp),%eax
  105aea:	ba 00 00 00 00       	mov    $0x0,%edx
  105aef:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105af2:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105af5:	19 d1                	sbb    %edx,%ecx
  105af7:	72 4c                	jb     105b45 <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  105af9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105afc:	8d 50 ff             	lea    -0x1(%eax),%edx
  105aff:	8b 45 20             	mov    0x20(%ebp),%eax
  105b02:	89 44 24 18          	mov    %eax,0x18(%esp)
  105b06:	89 54 24 14          	mov    %edx,0x14(%esp)
  105b0a:	8b 45 18             	mov    0x18(%ebp),%eax
  105b0d:	89 44 24 10          	mov    %eax,0x10(%esp)
  105b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105b14:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105b17:	89 44 24 08          	mov    %eax,0x8(%esp)
  105b1b:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b26:	8b 45 08             	mov    0x8(%ebp),%eax
  105b29:	89 04 24             	mov    %eax,(%esp)
  105b2c:	e8 39 ff ff ff       	call   105a6a <printnum>
  105b31:	eb 1b                	jmp    105b4e <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b36:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b3a:	8b 45 20             	mov    0x20(%ebp),%eax
  105b3d:	89 04 24             	mov    %eax,(%esp)
  105b40:	8b 45 08             	mov    0x8(%ebp),%eax
  105b43:	ff d0                	call   *%eax
        while (-- width > 0)
  105b45:	ff 4d 1c             	decl   0x1c(%ebp)
  105b48:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  105b4c:	7f e5                	jg     105b33 <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105b4e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105b51:	05 a4 72 10 00       	add    $0x1072a4,%eax
  105b56:	0f b6 00             	movzbl (%eax),%eax
  105b59:	0f be c0             	movsbl %al,%eax
  105b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b5f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105b63:	89 04 24             	mov    %eax,(%esp)
  105b66:	8b 45 08             	mov    0x8(%ebp),%eax
  105b69:	ff d0                	call   *%eax
}
  105b6b:	90                   	nop
  105b6c:	c9                   	leave  
  105b6d:	c3                   	ret    

00105b6e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105b6e:	f3 0f 1e fb          	endbr32 
  105b72:	55                   	push   %ebp
  105b73:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105b75:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105b79:	7e 14                	jle    105b8f <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  105b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  105b7e:	8b 00                	mov    (%eax),%eax
  105b80:	8d 48 08             	lea    0x8(%eax),%ecx
  105b83:	8b 55 08             	mov    0x8(%ebp),%edx
  105b86:	89 0a                	mov    %ecx,(%edx)
  105b88:	8b 50 04             	mov    0x4(%eax),%edx
  105b8b:	8b 00                	mov    (%eax),%eax
  105b8d:	eb 30                	jmp    105bbf <getuint+0x51>
    }
    else if (lflag) {
  105b8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105b93:	74 16                	je     105bab <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  105b95:	8b 45 08             	mov    0x8(%ebp),%eax
  105b98:	8b 00                	mov    (%eax),%eax
  105b9a:	8d 48 04             	lea    0x4(%eax),%ecx
  105b9d:	8b 55 08             	mov    0x8(%ebp),%edx
  105ba0:	89 0a                	mov    %ecx,(%edx)
  105ba2:	8b 00                	mov    (%eax),%eax
  105ba4:	ba 00 00 00 00       	mov    $0x0,%edx
  105ba9:	eb 14                	jmp    105bbf <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  105bab:	8b 45 08             	mov    0x8(%ebp),%eax
  105bae:	8b 00                	mov    (%eax),%eax
  105bb0:	8d 48 04             	lea    0x4(%eax),%ecx
  105bb3:	8b 55 08             	mov    0x8(%ebp),%edx
  105bb6:	89 0a                	mov    %ecx,(%edx)
  105bb8:	8b 00                	mov    (%eax),%eax
  105bba:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105bbf:	5d                   	pop    %ebp
  105bc0:	c3                   	ret    

00105bc1 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  105bc1:	f3 0f 1e fb          	endbr32 
  105bc5:	55                   	push   %ebp
  105bc6:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105bc8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105bcc:	7e 14                	jle    105be2 <getint+0x21>
        return va_arg(*ap, long long);
  105bce:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd1:	8b 00                	mov    (%eax),%eax
  105bd3:	8d 48 08             	lea    0x8(%eax),%ecx
  105bd6:	8b 55 08             	mov    0x8(%ebp),%edx
  105bd9:	89 0a                	mov    %ecx,(%edx)
  105bdb:	8b 50 04             	mov    0x4(%eax),%edx
  105bde:	8b 00                	mov    (%eax),%eax
  105be0:	eb 28                	jmp    105c0a <getint+0x49>
    }
    else if (lflag) {
  105be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105be6:	74 12                	je     105bfa <getint+0x39>
        return va_arg(*ap, long);
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
  105beb:	8b 00                	mov    (%eax),%eax
  105bed:	8d 48 04             	lea    0x4(%eax),%ecx
  105bf0:	8b 55 08             	mov    0x8(%ebp),%edx
  105bf3:	89 0a                	mov    %ecx,(%edx)
  105bf5:	8b 00                	mov    (%eax),%eax
  105bf7:	99                   	cltd   
  105bf8:	eb 10                	jmp    105c0a <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  105bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfd:	8b 00                	mov    (%eax),%eax
  105bff:	8d 48 04             	lea    0x4(%eax),%ecx
  105c02:	8b 55 08             	mov    0x8(%ebp),%edx
  105c05:	89 0a                	mov    %ecx,(%edx)
  105c07:	8b 00                	mov    (%eax),%eax
  105c09:	99                   	cltd   
    }
}
  105c0a:	5d                   	pop    %ebp
  105c0b:	c3                   	ret    

00105c0c <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105c0c:	f3 0f 1e fb          	endbr32 
  105c10:	55                   	push   %ebp
  105c11:	89 e5                	mov    %esp,%ebp
  105c13:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105c16:	8d 45 14             	lea    0x14(%ebp),%eax
  105c19:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105c1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105c1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105c23:	8b 45 10             	mov    0x10(%ebp),%eax
  105c26:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c31:	8b 45 08             	mov    0x8(%ebp),%eax
  105c34:	89 04 24             	mov    %eax,(%esp)
  105c37:	e8 03 00 00 00       	call   105c3f <vprintfmt>
    va_end(ap);
}
  105c3c:	90                   	nop
  105c3d:	c9                   	leave  
  105c3e:	c3                   	ret    

00105c3f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105c3f:	f3 0f 1e fb          	endbr32 
  105c43:	55                   	push   %ebp
  105c44:	89 e5                	mov    %esp,%ebp
  105c46:	56                   	push   %esi
  105c47:	53                   	push   %ebx
  105c48:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c4b:	eb 17                	jmp    105c64 <vprintfmt+0x25>
            if (ch == '\0') {
  105c4d:	85 db                	test   %ebx,%ebx
  105c4f:	0f 84 c0 03 00 00    	je     106015 <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  105c55:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c58:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c5c:	89 1c 24             	mov    %ebx,(%esp)
  105c5f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c62:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105c64:	8b 45 10             	mov    0x10(%ebp),%eax
  105c67:	8d 50 01             	lea    0x1(%eax),%edx
  105c6a:	89 55 10             	mov    %edx,0x10(%ebp)
  105c6d:	0f b6 00             	movzbl (%eax),%eax
  105c70:	0f b6 d8             	movzbl %al,%ebx
  105c73:	83 fb 25             	cmp    $0x25,%ebx
  105c76:	75 d5                	jne    105c4d <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105c78:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105c7c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105c83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c86:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105c89:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105c93:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105c96:	8b 45 10             	mov    0x10(%ebp),%eax
  105c99:	8d 50 01             	lea    0x1(%eax),%edx
  105c9c:	89 55 10             	mov    %edx,0x10(%ebp)
  105c9f:	0f b6 00             	movzbl (%eax),%eax
  105ca2:	0f b6 d8             	movzbl %al,%ebx
  105ca5:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105ca8:	83 f8 55             	cmp    $0x55,%eax
  105cab:	0f 87 38 03 00 00    	ja     105fe9 <vprintfmt+0x3aa>
  105cb1:	8b 04 85 c8 72 10 00 	mov    0x1072c8(,%eax,4),%eax
  105cb8:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105cbb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105cbf:	eb d5                	jmp    105c96 <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105cc1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105cc5:	eb cf                	jmp    105c96 <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105cc7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105cce:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105cd1:	89 d0                	mov    %edx,%eax
  105cd3:	c1 e0 02             	shl    $0x2,%eax
  105cd6:	01 d0                	add    %edx,%eax
  105cd8:	01 c0                	add    %eax,%eax
  105cda:	01 d8                	add    %ebx,%eax
  105cdc:	83 e8 30             	sub    $0x30,%eax
  105cdf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105ce2:	8b 45 10             	mov    0x10(%ebp),%eax
  105ce5:	0f b6 00             	movzbl (%eax),%eax
  105ce8:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105ceb:	83 fb 2f             	cmp    $0x2f,%ebx
  105cee:	7e 38                	jle    105d28 <vprintfmt+0xe9>
  105cf0:	83 fb 39             	cmp    $0x39,%ebx
  105cf3:	7f 33                	jg     105d28 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  105cf5:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105cf8:	eb d4                	jmp    105cce <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105cfa:	8b 45 14             	mov    0x14(%ebp),%eax
  105cfd:	8d 50 04             	lea    0x4(%eax),%edx
  105d00:	89 55 14             	mov    %edx,0x14(%ebp)
  105d03:	8b 00                	mov    (%eax),%eax
  105d05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105d08:	eb 1f                	jmp    105d29 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  105d0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d0e:	79 86                	jns    105c96 <vprintfmt+0x57>
                width = 0;
  105d10:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105d17:	e9 7a ff ff ff       	jmp    105c96 <vprintfmt+0x57>

        case '#':
            altflag = 1;
  105d1c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105d23:	e9 6e ff ff ff       	jmp    105c96 <vprintfmt+0x57>
            goto process_precision;
  105d28:	90                   	nop

        process_precision:
            if (width < 0)
  105d29:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105d2d:	0f 89 63 ff ff ff    	jns    105c96 <vprintfmt+0x57>
                width = precision, precision = -1;
  105d33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105d36:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105d39:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105d40:	e9 51 ff ff ff       	jmp    105c96 <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105d45:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105d48:	e9 49 ff ff ff       	jmp    105c96 <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105d4d:	8b 45 14             	mov    0x14(%ebp),%eax
  105d50:	8d 50 04             	lea    0x4(%eax),%edx
  105d53:	89 55 14             	mov    %edx,0x14(%ebp)
  105d56:	8b 00                	mov    (%eax),%eax
  105d58:	8b 55 0c             	mov    0xc(%ebp),%edx
  105d5b:	89 54 24 04          	mov    %edx,0x4(%esp)
  105d5f:	89 04 24             	mov    %eax,(%esp)
  105d62:	8b 45 08             	mov    0x8(%ebp),%eax
  105d65:	ff d0                	call   *%eax
            break;
  105d67:	e9 a4 02 00 00       	jmp    106010 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105d6c:	8b 45 14             	mov    0x14(%ebp),%eax
  105d6f:	8d 50 04             	lea    0x4(%eax),%edx
  105d72:	89 55 14             	mov    %edx,0x14(%ebp)
  105d75:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105d77:	85 db                	test   %ebx,%ebx
  105d79:	79 02                	jns    105d7d <vprintfmt+0x13e>
                err = -err;
  105d7b:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105d7d:	83 fb 06             	cmp    $0x6,%ebx
  105d80:	7f 0b                	jg     105d8d <vprintfmt+0x14e>
  105d82:	8b 34 9d 88 72 10 00 	mov    0x107288(,%ebx,4),%esi
  105d89:	85 f6                	test   %esi,%esi
  105d8b:	75 23                	jne    105db0 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  105d8d:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105d91:	c7 44 24 08 b5 72 10 	movl   $0x1072b5,0x8(%esp)
  105d98:	00 
  105d99:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d9c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105da0:	8b 45 08             	mov    0x8(%ebp),%eax
  105da3:	89 04 24             	mov    %eax,(%esp)
  105da6:	e8 61 fe ff ff       	call   105c0c <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105dab:	e9 60 02 00 00       	jmp    106010 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  105db0:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105db4:	c7 44 24 08 be 72 10 	movl   $0x1072be,0x8(%esp)
  105dbb:	00 
  105dbc:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dbf:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  105dc6:	89 04 24             	mov    %eax,(%esp)
  105dc9:	e8 3e fe ff ff       	call   105c0c <printfmt>
            break;
  105dce:	e9 3d 02 00 00       	jmp    106010 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105dd3:	8b 45 14             	mov    0x14(%ebp),%eax
  105dd6:	8d 50 04             	lea    0x4(%eax),%edx
  105dd9:	89 55 14             	mov    %edx,0x14(%ebp)
  105ddc:	8b 30                	mov    (%eax),%esi
  105dde:	85 f6                	test   %esi,%esi
  105de0:	75 05                	jne    105de7 <vprintfmt+0x1a8>
                p = "(null)";
  105de2:	be c1 72 10 00       	mov    $0x1072c1,%esi
            }
            if (width > 0 && padc != '-') {
  105de7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105deb:	7e 76                	jle    105e63 <vprintfmt+0x224>
  105ded:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105df1:	74 70                	je     105e63 <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105df3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105df6:	89 44 24 04          	mov    %eax,0x4(%esp)
  105dfa:	89 34 24             	mov    %esi,(%esp)
  105dfd:	e8 ba f7 ff ff       	call   1055bc <strnlen>
  105e02:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105e05:	29 c2                	sub    %eax,%edx
  105e07:	89 d0                	mov    %edx,%eax
  105e09:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105e0c:	eb 16                	jmp    105e24 <vprintfmt+0x1e5>
                    putch(padc, putdat);
  105e0e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e15:	89 54 24 04          	mov    %edx,0x4(%esp)
  105e19:	89 04 24             	mov    %eax,(%esp)
  105e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  105e1f:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105e21:	ff 4d e8             	decl   -0x18(%ebp)
  105e24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e28:	7f e4                	jg     105e0e <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e2a:	eb 37                	jmp    105e63 <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  105e2c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105e30:	74 1f                	je     105e51 <vprintfmt+0x212>
  105e32:	83 fb 1f             	cmp    $0x1f,%ebx
  105e35:	7e 05                	jle    105e3c <vprintfmt+0x1fd>
  105e37:	83 fb 7e             	cmp    $0x7e,%ebx
  105e3a:	7e 15                	jle    105e51 <vprintfmt+0x212>
                    putch('?', putdat);
  105e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e43:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  105e4d:	ff d0                	call   *%eax
  105e4f:	eb 0f                	jmp    105e60 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  105e51:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e54:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e58:	89 1c 24             	mov    %ebx,(%esp)
  105e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105e5e:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105e60:	ff 4d e8             	decl   -0x18(%ebp)
  105e63:	89 f0                	mov    %esi,%eax
  105e65:	8d 70 01             	lea    0x1(%eax),%esi
  105e68:	0f b6 00             	movzbl (%eax),%eax
  105e6b:	0f be d8             	movsbl %al,%ebx
  105e6e:	85 db                	test   %ebx,%ebx
  105e70:	74 27                	je     105e99 <vprintfmt+0x25a>
  105e72:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105e76:	78 b4                	js     105e2c <vprintfmt+0x1ed>
  105e78:	ff 4d e4             	decl   -0x1c(%ebp)
  105e7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105e7f:	79 ab                	jns    105e2c <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  105e81:	eb 16                	jmp    105e99 <vprintfmt+0x25a>
                putch(' ', putdat);
  105e83:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e86:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e8a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105e91:	8b 45 08             	mov    0x8(%ebp),%eax
  105e94:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105e96:	ff 4d e8             	decl   -0x18(%ebp)
  105e99:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105e9d:	7f e4                	jg     105e83 <vprintfmt+0x244>
            }
            break;
  105e9f:	e9 6c 01 00 00       	jmp    106010 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105ea4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105ea7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eab:	8d 45 14             	lea    0x14(%ebp),%eax
  105eae:	89 04 24             	mov    %eax,(%esp)
  105eb1:	e8 0b fd ff ff       	call   105bc1 <getint>
  105eb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105eb9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105ebc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ebf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ec2:	85 d2                	test   %edx,%edx
  105ec4:	79 26                	jns    105eec <vprintfmt+0x2ad>
                putch('-', putdat);
  105ec6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ec9:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ecd:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed7:	ff d0                	call   *%eax
                num = -(long long)num;
  105ed9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105edc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105edf:	f7 d8                	neg    %eax
  105ee1:	83 d2 00             	adc    $0x0,%edx
  105ee4:	f7 da                	neg    %edx
  105ee6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ee9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105eec:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105ef3:	e9 a8 00 00 00       	jmp    105fa0 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105ef8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105efb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105eff:	8d 45 14             	lea    0x14(%ebp),%eax
  105f02:	89 04 24             	mov    %eax,(%esp)
  105f05:	e8 64 fc ff ff       	call   105b6e <getuint>
  105f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105f10:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105f17:	e9 84 00 00 00       	jmp    105fa0 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105f1c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f1f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f23:	8d 45 14             	lea    0x14(%ebp),%eax
  105f26:	89 04 24             	mov    %eax,(%esp)
  105f29:	e8 40 fc ff ff       	call   105b6e <getuint>
  105f2e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f31:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105f34:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105f3b:	eb 63                	jmp    105fa0 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  105f3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f40:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f44:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  105f4e:	ff d0                	call   *%eax
            putch('x', putdat);
  105f50:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f53:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f57:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f61:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105f63:	8b 45 14             	mov    0x14(%ebp),%eax
  105f66:	8d 50 04             	lea    0x4(%eax),%edx
  105f69:	89 55 14             	mov    %edx,0x14(%ebp)
  105f6c:	8b 00                	mov    (%eax),%eax
  105f6e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105f78:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105f7f:	eb 1f                	jmp    105fa0 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105f81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105f84:	89 44 24 04          	mov    %eax,0x4(%esp)
  105f88:	8d 45 14             	lea    0x14(%ebp),%eax
  105f8b:	89 04 24             	mov    %eax,(%esp)
  105f8e:	e8 db fb ff ff       	call   105b6e <getuint>
  105f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105f99:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105fa0:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105fa7:	89 54 24 18          	mov    %edx,0x18(%esp)
  105fab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105fae:	89 54 24 14          	mov    %edx,0x14(%esp)
  105fb2:	89 44 24 10          	mov    %eax,0x10(%esp)
  105fb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105fb9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105fbc:	89 44 24 08          	mov    %eax,0x8(%esp)
  105fc0:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105fc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fc7:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  105fce:	89 04 24             	mov    %eax,(%esp)
  105fd1:	e8 94 fa ff ff       	call   105a6a <printnum>
            break;
  105fd6:	eb 38                	jmp    106010 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fdb:	89 44 24 04          	mov    %eax,0x4(%esp)
  105fdf:	89 1c 24             	mov    %ebx,(%esp)
  105fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  105fe5:	ff d0                	call   *%eax
            break;
  105fe7:	eb 27                	jmp    106010 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105fec:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ff0:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  105ffa:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105ffc:	ff 4d 10             	decl   0x10(%ebp)
  105fff:	eb 03                	jmp    106004 <vprintfmt+0x3c5>
  106001:	ff 4d 10             	decl   0x10(%ebp)
  106004:	8b 45 10             	mov    0x10(%ebp),%eax
  106007:	48                   	dec    %eax
  106008:	0f b6 00             	movzbl (%eax),%eax
  10600b:	3c 25                	cmp    $0x25,%al
  10600d:	75 f2                	jne    106001 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  10600f:	90                   	nop
    while (1) {
  106010:	e9 36 fc ff ff       	jmp    105c4b <vprintfmt+0xc>
                return;
  106015:	90                   	nop
        }
    }
}
  106016:	83 c4 40             	add    $0x40,%esp
  106019:	5b                   	pop    %ebx
  10601a:	5e                   	pop    %esi
  10601b:	5d                   	pop    %ebp
  10601c:	c3                   	ret    

0010601d <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  10601d:	f3 0f 1e fb          	endbr32 
  106021:	55                   	push   %ebp
  106022:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  106024:	8b 45 0c             	mov    0xc(%ebp),%eax
  106027:	8b 40 08             	mov    0x8(%eax),%eax
  10602a:	8d 50 01             	lea    0x1(%eax),%edx
  10602d:	8b 45 0c             	mov    0xc(%ebp),%eax
  106030:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  106033:	8b 45 0c             	mov    0xc(%ebp),%eax
  106036:	8b 10                	mov    (%eax),%edx
  106038:	8b 45 0c             	mov    0xc(%ebp),%eax
  10603b:	8b 40 04             	mov    0x4(%eax),%eax
  10603e:	39 c2                	cmp    %eax,%edx
  106040:	73 12                	jae    106054 <sprintputch+0x37>
        *b->buf ++ = ch;
  106042:	8b 45 0c             	mov    0xc(%ebp),%eax
  106045:	8b 00                	mov    (%eax),%eax
  106047:	8d 48 01             	lea    0x1(%eax),%ecx
  10604a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10604d:	89 0a                	mov    %ecx,(%edx)
  10604f:	8b 55 08             	mov    0x8(%ebp),%edx
  106052:	88 10                	mov    %dl,(%eax)
    }
}
  106054:	90                   	nop
  106055:	5d                   	pop    %ebp
  106056:	c3                   	ret    

00106057 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  106057:	f3 0f 1e fb          	endbr32 
  10605b:	55                   	push   %ebp
  10605c:	89 e5                	mov    %esp,%ebp
  10605e:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  106061:	8d 45 14             	lea    0x14(%ebp),%eax
  106064:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  106067:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10606a:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10606e:	8b 45 10             	mov    0x10(%ebp),%eax
  106071:	89 44 24 08          	mov    %eax,0x8(%esp)
  106075:	8b 45 0c             	mov    0xc(%ebp),%eax
  106078:	89 44 24 04          	mov    %eax,0x4(%esp)
  10607c:	8b 45 08             	mov    0x8(%ebp),%eax
  10607f:	89 04 24             	mov    %eax,(%esp)
  106082:	e8 08 00 00 00       	call   10608f <vsnprintf>
  106087:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10608a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10608d:	c9                   	leave  
  10608e:	c3                   	ret    

0010608f <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  10608f:	f3 0f 1e fb          	endbr32 
  106093:	55                   	push   %ebp
  106094:	89 e5                	mov    %esp,%ebp
  106096:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  106099:	8b 45 08             	mov    0x8(%ebp),%eax
  10609c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10609f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060a2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1060a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1060a8:	01 d0                	add    %edx,%eax
  1060aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1060ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1060b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1060b8:	74 0a                	je     1060c4 <vsnprintf+0x35>
  1060ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1060bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1060c0:	39 c2                	cmp    %eax,%edx
  1060c2:	76 07                	jbe    1060cb <vsnprintf+0x3c>
        return -E_INVAL;
  1060c4:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1060c9:	eb 2a                	jmp    1060f5 <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1060cb:	8b 45 14             	mov    0x14(%ebp),%eax
  1060ce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1060d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1060d5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1060d9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  1060dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1060e0:	c7 04 24 1d 60 10 00 	movl   $0x10601d,(%esp)
  1060e7:	e8 53 fb ff ff       	call   105c3f <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  1060ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1060ef:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1060f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1060f5:	c9                   	leave  
  1060f6:	c3                   	ret    
