
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
void kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

void
kern_init(void){
  100000:	f3 0f 1e fb          	endbr32 
  100004:	55                   	push   %ebp
  100005:	89 e5                	mov    %esp,%ebp
  100007:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10000a:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  10000f:	2d 16 0a 11 00       	sub    $0x110a16,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 0a 11 00 	movl   $0x110a16,(%esp)
  100027:	e8 0f 2f 00 00       	call   102f3b <memset>

    cons_init();                // init the console
  10002c:	e8 22 16 00 00       	call   101653 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 60 37 10 00 	movl   $0x103760,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 7c 37 10 00 	movl   $0x10377c,(%esp)
  100046:	e8 49 02 00 00       	call   100294 <cprintf>

    print_kerninfo();
  10004b:	e8 07 09 00 00       	call   100957 <print_kerninfo>

    grade_backtrace();
  100050:	e8 9a 00 00 00       	call   1000ef <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 90 2b 00 00       	call   102bea <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 49 17 00 00       	call   1017a8 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 c9 18 00 00       	call   10192d <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 6f 0d 00 00       	call   100dd8 <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 86 18 00 00       	call   1018f4 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 87 01 00 00       	call   1001fa <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	f3 0f 1e fb          	endbr32 
  100079:	55                   	push   %ebp
  10007a:	89 e5                	mov    %esp,%ebp
  10007c:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100086:	00 
  100087:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008e:	00 
  10008f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100096:	e8 27 0d 00 00       	call   100dc2 <mon_backtrace>
}
  10009b:	90                   	nop
  10009c:	c9                   	leave  
  10009d:	c3                   	ret    

0010009e <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009e:	f3 0f 1e fb          	endbr32 
  1000a2:	55                   	push   %ebp
  1000a3:	89 e5                	mov    %esp,%ebp
  1000a5:	53                   	push   %ebx
  1000a6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a9:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000af:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000b5:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000bd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000c1:	89 04 24             	mov    %eax,(%esp)
  1000c4:	e8 ac ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c9:	90                   	nop
  1000ca:	83 c4 14             	add    $0x14,%esp
  1000cd:	5b                   	pop    %ebx
  1000ce:	5d                   	pop    %ebp
  1000cf:	c3                   	ret    

001000d0 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000d0:	f3 0f 1e fb          	endbr32 
  1000d4:	55                   	push   %ebp
  1000d5:	89 e5                	mov    %esp,%ebp
  1000d7:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000da:	8b 45 10             	mov    0x10(%ebp),%eax
  1000dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000e1:	8b 45 08             	mov    0x8(%ebp),%eax
  1000e4:	89 04 24             	mov    %eax,(%esp)
  1000e7:	e8 b2 ff ff ff       	call   10009e <grade_backtrace1>
}
  1000ec:	90                   	nop
  1000ed:	c9                   	leave  
  1000ee:	c3                   	ret    

001000ef <grade_backtrace>:

void
grade_backtrace(void) {
  1000ef:	f3 0f 1e fb          	endbr32 
  1000f3:	55                   	push   %ebp
  1000f4:	89 e5                	mov    %esp,%ebp
  1000f6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000f9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000fe:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100105:	ff 
  100106:	89 44 24 04          	mov    %eax,0x4(%esp)
  10010a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100111:	e8 ba ff ff ff       	call   1000d0 <grade_backtrace0>
}
  100116:	90                   	nop
  100117:	c9                   	leave  
  100118:	c3                   	ret    

00100119 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100119:	f3 0f 1e fb          	endbr32 
  10011d:	55                   	push   %ebp
  10011e:	89 e5                	mov    %esp,%ebp
  100120:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100123:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100126:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100129:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10012c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10012f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100133:	83 e0 03             	and    $0x3,%eax
  100136:	89 c2                	mov    %eax,%edx
  100138:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10013d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100141:	89 44 24 04          	mov    %eax,0x4(%esp)
  100145:	c7 04 24 81 37 10 00 	movl   $0x103781,(%esp)
  10014c:	e8 43 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100151:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100155:	89 c2                	mov    %eax,%edx
  100157:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10015c:	89 54 24 08          	mov    %edx,0x8(%esp)
  100160:	89 44 24 04          	mov    %eax,0x4(%esp)
  100164:	c7 04 24 8f 37 10 00 	movl   $0x10378f,(%esp)
  10016b:	e8 24 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100170:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100174:	89 c2                	mov    %eax,%edx
  100176:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10017b:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100183:	c7 04 24 9d 37 10 00 	movl   $0x10379d,(%esp)
  10018a:	e8 05 01 00 00       	call   100294 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10018f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100193:	89 c2                	mov    %eax,%edx
  100195:	a1 20 0a 11 00       	mov    0x110a20,%eax
  10019a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a2:	c7 04 24 ab 37 10 00 	movl   $0x1037ab,(%esp)
  1001a9:	e8 e6 00 00 00       	call   100294 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001ae:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001b2:	89 c2                	mov    %eax,%edx
  1001b4:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001b9:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001c1:	c7 04 24 b9 37 10 00 	movl   $0x1037b9,(%esp)
  1001c8:	e8 c7 00 00 00       	call   100294 <cprintf>
    round ++;
  1001cd:	a1 20 0a 11 00       	mov    0x110a20,%eax
  1001d2:	40                   	inc    %eax
  1001d3:	a3 20 0a 11 00       	mov    %eax,0x110a20
}
  1001d8:	90                   	nop
  1001d9:	c9                   	leave  
  1001da:	c3                   	ret    

001001db <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001db:	f3 0f 1e fb          	endbr32 
  1001df:	55                   	push   %ebp
  1001e0:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
	asm volatile (
  1001e2:	83 ec 08             	sub    $0x8,%esp
  1001e5:	cd 78                	int    $0x78
  1001e7:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp"
	    : 
	    : "i"(T_SWITCH_TOU)
	);
}
  1001e9:	90                   	nop
  1001ea:	5d                   	pop    %ebp
  1001eb:	c3                   	ret    

001001ec <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001ec:	f3 0f 1e fb          	endbr32 
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
	asm volatile (
  1001f3:	cd 79                	int    $0x79
  1001f5:	89 ec                	mov    %ebp,%esp
	    "int %0 \n"
	    "movl %%ebp, %%esp \n"
	    : 
	    : "i"(T_SWITCH_TOK)
	);
}
  1001f7:	90                   	nop
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	f3 0f 1e fb          	endbr32 
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 10 ff ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 c8 37 10 00 	movl   $0x1037c8,(%esp)
  100210:	e8 7f 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_user();
  100215:	e8 c1 ff ff ff       	call   1001db <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 fa fe ff ff       	call   100119 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  100226:	e8 69 00 00 00       	call   100294 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 bc ff ff ff       	call   1001ec <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 e4 fe ff ff       	call   100119 <lab1_print_cur_status>
}
  100235:	90                   	nop
  100236:	c9                   	leave  
  100237:	c3                   	ret    

00100238 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100238:	f3 0f 1e fb          	endbr32 
  10023c:	55                   	push   %ebp
  10023d:	89 e5                	mov    %esp,%ebp
  10023f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100242:	8b 45 08             	mov    0x8(%ebp),%eax
  100245:	89 04 24             	mov    %eax,(%esp)
  100248:	e8 37 14 00 00       	call   101684 <cons_putc>
    (*cnt) ++;
  10024d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100250:	8b 00                	mov    (%eax),%eax
  100252:	8d 50 01             	lea    0x1(%eax),%edx
  100255:	8b 45 0c             	mov    0xc(%ebp),%eax
  100258:	89 10                	mov    %edx,(%eax)
}
  10025a:	90                   	nop
  10025b:	c9                   	leave  
  10025c:	c3                   	ret    

0010025d <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025d:	f3 0f 1e fb          	endbr32 
  100261:	55                   	push   %ebp
  100262:	89 e5                	mov    %esp,%ebp
  100264:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100271:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100275:	8b 45 08             	mov    0x8(%ebp),%eax
  100278:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100283:	c7 04 24 38 02 10 00 	movl   $0x100238,(%esp)
  10028a:	e8 18 30 00 00       	call   1032a7 <vprintfmt>
    return cnt;
  10028f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100292:	c9                   	leave  
  100293:	c3                   	ret    

00100294 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100294:	f3 0f 1e fb          	endbr32 
  100298:	55                   	push   %ebp
  100299:	89 e5                	mov    %esp,%ebp
  10029b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10029e:	8d 45 0c             	lea    0xc(%ebp),%eax
  1002a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  1002a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002ab:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 a7 ff ff ff       	call   10025d <vcprintf>
  1002b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002bc:	c9                   	leave  
  1002bd:	c3                   	ret    

001002be <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002be:	f3 0f 1e fb          	endbr32 
  1002c2:	55                   	push   %ebp
  1002c3:	89 e5                	mov    %esp,%ebp
  1002c5:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	89 04 24             	mov    %eax,(%esp)
  1002ce:	e8 b1 13 00 00       	call   101684 <cons_putc>
}
  1002d3:	90                   	nop
  1002d4:	c9                   	leave  
  1002d5:	c3                   	ret    

001002d6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002d6:	f3 0f 1e fb          	endbr32 
  1002da:	55                   	push   %ebp
  1002db:	89 e5                	mov    %esp,%ebp
  1002dd:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002e7:	eb 13                	jmp    1002fc <cputs+0x26>
        cputch(c, &cnt);
  1002e9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002ed:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002f0:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002f4:	89 04 24             	mov    %eax,(%esp)
  1002f7:	e8 3c ff ff ff       	call   100238 <cputch>
    while ((c = *str ++) != '\0') {
  1002fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	89 55 08             	mov    %edx,0x8(%ebp)
  100305:	0f b6 00             	movzbl (%eax),%eax
  100308:	88 45 f7             	mov    %al,-0x9(%ebp)
  10030b:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  10030f:	75 d8                	jne    1002e9 <cputs+0x13>
    }
    cputch('\n', &cnt);
  100311:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100314:	89 44 24 04          	mov    %eax,0x4(%esp)
  100318:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  10031f:	e8 14 ff ff ff       	call   100238 <cputch>
    return cnt;
  100324:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100327:	c9                   	leave  
  100328:	c3                   	ret    

00100329 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  100329:	f3 0f 1e fb          	endbr32 
  10032d:	55                   	push   %ebp
  10032e:	89 e5                	mov    %esp,%ebp
  100330:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100333:	90                   	nop
  100334:	e8 79 13 00 00       	call   1016b2 <cons_getc>
  100339:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10033c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100340:	74 f2                	je     100334 <getchar+0xb>
        /* do nothing */;
    return c;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100347:	f3 0f 1e fb          	endbr32 
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100351:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100355:	74 13                	je     10036a <readline+0x23>
        cprintf("%s", prompt);
  100357:	8b 45 08             	mov    0x8(%ebp),%eax
  10035a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035e:	c7 04 24 07 38 10 00 	movl   $0x103807,(%esp)
  100365:	e8 2a ff ff ff       	call   100294 <cprintf>
    }
    int i = 0, c;
  10036a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100371:	e8 b3 ff ff ff       	call   100329 <getchar>
  100376:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100379:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10037d:	79 07                	jns    100386 <readline+0x3f>
            return NULL;
  10037f:	b8 00 00 00 00       	mov    $0x0,%eax
  100384:	eb 78                	jmp    1003fe <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100386:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10038a:	7e 28                	jle    1003b4 <readline+0x6d>
  10038c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100393:	7f 1f                	jg     1003b4 <readline+0x6d>
            cputchar(c);
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100398:	89 04 24             	mov    %eax,(%esp)
  10039b:	e8 1e ff ff ff       	call   1002be <cputchar>
            buf[i ++] = c;
  1003a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003a3:	8d 50 01             	lea    0x1(%eax),%edx
  1003a6:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1003a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1003ac:	88 90 40 0a 11 00    	mov    %dl,0x110a40(%eax)
  1003b2:	eb 45                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1003b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003b8:	75 16                	jne    1003d0 <readline+0x89>
  1003ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003be:	7e 10                	jle    1003d0 <readline+0x89>
            cputchar(c);
  1003c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c3:	89 04 24             	mov    %eax,(%esp)
  1003c6:	e8 f3 fe ff ff       	call   1002be <cputchar>
            i --;
  1003cb:	ff 4d f4             	decl   -0xc(%ebp)
  1003ce:	eb 29                	jmp    1003f9 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1003d0:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003d4:	74 06                	je     1003dc <readline+0x95>
  1003d6:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003da:	75 95                	jne    100371 <readline+0x2a>
            cputchar(c);
  1003dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003df:	89 04 24             	mov    %eax,(%esp)
  1003e2:	e8 d7 fe ff ff       	call   1002be <cputchar>
            buf[i] = '\0';
  1003e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ea:	05 40 0a 11 00       	add    $0x110a40,%eax
  1003ef:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003f2:	b8 40 0a 11 00       	mov    $0x110a40,%eax
  1003f7:	eb 05                	jmp    1003fe <readline+0xb7>
        c = getchar();
  1003f9:	e9 73 ff ff ff       	jmp    100371 <readline+0x2a>
        }
    }
}
  1003fe:	c9                   	leave  
  1003ff:	c3                   	ret    

00100400 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100400:	f3 0f 1e fb          	endbr32 
  100404:	55                   	push   %ebp
  100405:	89 e5                	mov    %esp,%ebp
  100407:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  10040a:	a1 40 0e 11 00       	mov    0x110e40,%eax
  10040f:	85 c0                	test   %eax,%eax
  100411:	75 5b                	jne    10046e <__panic+0x6e>
        goto panic_dead;
    }
    is_panic = 1;
  100413:	c7 05 40 0e 11 00 01 	movl   $0x1,0x110e40
  10041a:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  10041d:	8d 45 14             	lea    0x14(%ebp),%eax
  100420:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100423:	8b 45 0c             	mov    0xc(%ebp),%eax
  100426:	89 44 24 08          	mov    %eax,0x8(%esp)
  10042a:	8b 45 08             	mov    0x8(%ebp),%eax
  10042d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100431:	c7 04 24 0a 38 10 00 	movl   $0x10380a,(%esp)
  100438:	e8 57 fe ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  10043d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100440:	89 44 24 04          	mov    %eax,0x4(%esp)
  100444:	8b 45 10             	mov    0x10(%ebp),%eax
  100447:	89 04 24             	mov    %eax,(%esp)
  10044a:	e8 0e fe ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  10044f:	c7 04 24 26 38 10 00 	movl   $0x103826,(%esp)
  100456:	e8 39 fe ff ff       	call   100294 <cprintf>
    
    cprintf("stack trackback:\n");
  10045b:	c7 04 24 28 38 10 00 	movl   $0x103828,(%esp)
  100462:	e8 2d fe ff ff       	call   100294 <cprintf>
    print_stackframe();
  100467:	e8 3d 06 00 00       	call   100aa9 <print_stackframe>
  10046c:	eb 01                	jmp    10046f <__panic+0x6f>
        goto panic_dead;
  10046e:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10046f:	e8 8c 14 00 00       	call   101900 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100474:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10047b:	e8 69 08 00 00       	call   100ce9 <kmonitor>
  100480:	eb f2                	jmp    100474 <__panic+0x74>

00100482 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100482:	f3 0f 1e fb          	endbr32 
  100486:	55                   	push   %ebp
  100487:	89 e5                	mov    %esp,%ebp
  100489:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10048c:	8d 45 14             	lea    0x14(%ebp),%eax
  10048f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100492:	8b 45 0c             	mov    0xc(%ebp),%eax
  100495:	89 44 24 08          	mov    %eax,0x8(%esp)
  100499:	8b 45 08             	mov    0x8(%ebp),%eax
  10049c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004a0:	c7 04 24 3a 38 10 00 	movl   $0x10383a,(%esp)
  1004a7:	e8 e8 fd ff ff       	call   100294 <cprintf>
    vcprintf(fmt, ap);
  1004ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1004af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1004b3:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b6:	89 04 24             	mov    %eax,(%esp)
  1004b9:	e8 9f fd ff ff       	call   10025d <vcprintf>
    cprintf("\n");
  1004be:	c7 04 24 26 38 10 00 	movl   $0x103826,(%esp)
  1004c5:	e8 ca fd ff ff       	call   100294 <cprintf>
    va_end(ap);
}
  1004ca:	90                   	nop
  1004cb:	c9                   	leave  
  1004cc:	c3                   	ret    

001004cd <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004cd:	f3 0f 1e fb          	endbr32 
  1004d1:	55                   	push   %ebp
  1004d2:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004d4:	a1 40 0e 11 00       	mov    0x110e40,%eax
}
  1004d9:	5d                   	pop    %ebp
  1004da:	c3                   	ret    

001004db <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004db:	f3 0f 1e fb          	endbr32 
  1004df:	55                   	push   %ebp
  1004e0:	89 e5                	mov    %esp,%ebp
  1004e2:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e8:	8b 00                	mov    (%eax),%eax
  1004ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004ed:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f0:	8b 00                	mov    (%eax),%eax
  1004f2:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004fc:	e9 ca 00 00 00       	jmp    1005cb <stab_binsearch+0xf0>
        int true_m = (l + r) / 2, m = true_m;
  100501:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100504:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100507:	01 d0                	add    %edx,%eax
  100509:	89 c2                	mov    %eax,%edx
  10050b:	c1 ea 1f             	shr    $0x1f,%edx
  10050e:	01 d0                	add    %edx,%eax
  100510:	d1 f8                	sar    %eax
  100512:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100515:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100518:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10051b:	eb 03                	jmp    100520 <stab_binsearch+0x45>
            m --;
  10051d:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7c 1f                	jl     100547 <stab_binsearch+0x6c>
  100528:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10052b:	89 d0                	mov    %edx,%eax
  10052d:	01 c0                	add    %eax,%eax
  10052f:	01 d0                	add    %edx,%eax
  100531:	c1 e0 02             	shl    $0x2,%eax
  100534:	89 c2                	mov    %eax,%edx
  100536:	8b 45 08             	mov    0x8(%ebp),%eax
  100539:	01 d0                	add    %edx,%eax
  10053b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10053f:	0f b6 c0             	movzbl %al,%eax
  100542:	39 45 14             	cmp    %eax,0x14(%ebp)
  100545:	75 d6                	jne    10051d <stab_binsearch+0x42>
        }
        if (m < l) {    // no match in [l, m]
  100547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10054a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10054d:	7d 09                	jge    100558 <stab_binsearch+0x7d>
            l = true_m + 1;
  10054f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100552:	40                   	inc    %eax
  100553:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100556:	eb 73                	jmp    1005cb <stab_binsearch+0xf0>
        }

        // actual binary search
        any_matches = 1;
  100558:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10055f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100562:	89 d0                	mov    %edx,%eax
  100564:	01 c0                	add    %eax,%eax
  100566:	01 d0                	add    %edx,%eax
  100568:	c1 e0 02             	shl    $0x2,%eax
  10056b:	89 c2                	mov    %eax,%edx
  10056d:	8b 45 08             	mov    0x8(%ebp),%eax
  100570:	01 d0                	add    %edx,%eax
  100572:	8b 40 08             	mov    0x8(%eax),%eax
  100575:	39 45 18             	cmp    %eax,0x18(%ebp)
  100578:	76 11                	jbe    10058b <stab_binsearch+0xb0>
            *region_left = m;
  10057a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10057d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100580:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100582:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100585:	40                   	inc    %eax
  100586:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100589:	eb 40                	jmp    1005cb <stab_binsearch+0xf0>
        } else if (stabs[m].n_value > addr) {
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	89 d0                	mov    %edx,%eax
  100590:	01 c0                	add    %eax,%eax
  100592:	01 d0                	add    %edx,%eax
  100594:	c1 e0 02             	shl    $0x2,%eax
  100597:	89 c2                	mov    %eax,%edx
  100599:	8b 45 08             	mov    0x8(%ebp),%eax
  10059c:	01 d0                	add    %edx,%eax
  10059e:	8b 40 08             	mov    0x8(%eax),%eax
  1005a1:	39 45 18             	cmp    %eax,0x18(%ebp)
  1005a4:	73 14                	jae    1005ba <stab_binsearch+0xdf>
            *region_right = m - 1;
  1005a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005a9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005ac:	8b 45 10             	mov    0x10(%ebp),%eax
  1005af:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1005b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005b4:	48                   	dec    %eax
  1005b5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1005b8:	eb 11                	jmp    1005cb <stab_binsearch+0xf0>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1005ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005bd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005c0:	89 10                	mov    %edx,(%eax)
            l = m;
  1005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1005c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005c8:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005ce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005d1:	0f 8e 2a ff ff ff    	jle    100501 <stab_binsearch+0x26>
        }
    }

    if (!any_matches) {
  1005d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005db:	75 0f                	jne    1005ec <stab_binsearch+0x111>
        *region_right = *region_left - 1;
  1005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e0:	8b 00                	mov    (%eax),%eax
  1005e2:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005e8:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005ea:	eb 3e                	jmp    10062a <stab_binsearch+0x14f>
        l = *region_right;
  1005ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1005ef:	8b 00                	mov    (%eax),%eax
  1005f1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005f4:	eb 03                	jmp    1005f9 <stab_binsearch+0x11e>
  1005f6:	ff 4d fc             	decl   -0x4(%ebp)
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	8b 00                	mov    (%eax),%eax
  1005fe:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  100601:	7e 1f                	jle    100622 <stab_binsearch+0x147>
  100603:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100606:	89 d0                	mov    %edx,%eax
  100608:	01 c0                	add    %eax,%eax
  10060a:	01 d0                	add    %edx,%eax
  10060c:	c1 e0 02             	shl    $0x2,%eax
  10060f:	89 c2                	mov    %eax,%edx
  100611:	8b 45 08             	mov    0x8(%ebp),%eax
  100614:	01 d0                	add    %edx,%eax
  100616:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10061a:	0f b6 c0             	movzbl %al,%eax
  10061d:	39 45 14             	cmp    %eax,0x14(%ebp)
  100620:	75 d4                	jne    1005f6 <stab_binsearch+0x11b>
        *region_left = l;
  100622:	8b 45 0c             	mov    0xc(%ebp),%eax
  100625:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100628:	89 10                	mov    %edx,(%eax)
}
  10062a:	90                   	nop
  10062b:	c9                   	leave  
  10062c:	c3                   	ret    

0010062d <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  10062d:	f3 0f 1e fb          	endbr32 
  100631:	55                   	push   %ebp
  100632:	89 e5                	mov    %esp,%ebp
  100634:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100637:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063a:	c7 00 58 38 10 00    	movl   $0x103858,(%eax)
    info->eip_line = 0;
  100640:	8b 45 0c             	mov    0xc(%ebp),%eax
  100643:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10064a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10064d:	c7 40 08 58 38 10 00 	movl   $0x103858,0x8(%eax)
    info->eip_fn_namelen = 9;
  100654:	8b 45 0c             	mov    0xc(%ebp),%eax
  100657:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10065e:	8b 45 0c             	mov    0xc(%ebp),%eax
  100661:	8b 55 08             	mov    0x8(%ebp),%edx
  100664:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100667:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100671:	c7 45 f4 8c 40 10 00 	movl   $0x10408c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100678:	c7 45 f0 18 cf 10 00 	movl   $0x10cf18,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10067f:	c7 45 ec 19 cf 10 00 	movl   $0x10cf19,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100686:	c7 45 e8 1d f0 10 00 	movl   $0x10f01d,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10068d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100690:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100693:	76 0b                	jbe    1006a0 <debuginfo_eip+0x73>
  100695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100698:	48                   	dec    %eax
  100699:	0f b6 00             	movzbl (%eax),%eax
  10069c:	84 c0                	test   %al,%al
  10069e:	74 0a                	je     1006aa <debuginfo_eip+0x7d>
        return -1;
  1006a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006a5:	e9 ab 02 00 00       	jmp    100955 <debuginfo_eip+0x328>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1006aa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1006b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1006b4:	2b 45 f4             	sub    -0xc(%ebp),%eax
  1006b7:	c1 f8 02             	sar    $0x2,%eax
  1006ba:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1006c0:	48                   	dec    %eax
  1006c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1006c7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006cb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006d2:	00 
  1006d3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006d6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006da:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006dd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 ef fd ff ff       	call   1004db <stab_binsearch>
    if (lfile == 0)
  1006ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006ef:	85 c0                	test   %eax,%eax
  1006f1:	75 0a                	jne    1006fd <debuginfo_eip+0xd0>
        return -1;
  1006f3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006f8:	e9 58 02 00 00       	jmp    100955 <debuginfo_eip+0x328>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100700:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100706:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100709:	8b 45 08             	mov    0x8(%ebp),%eax
  10070c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100710:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100717:	00 
  100718:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10071b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10071f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100722:	89 44 24 04          	mov    %eax,0x4(%esp)
  100726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100729:	89 04 24             	mov    %eax,(%esp)
  10072c:	e8 aa fd ff ff       	call   1004db <stab_binsearch>

    if (lfun <= rfun) {
  100731:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100734:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100737:	39 c2                	cmp    %eax,%edx
  100739:	7f 78                	jg     1007b3 <debuginfo_eip+0x186>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10073b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073e:	89 c2                	mov    %eax,%edx
  100740:	89 d0                	mov    %edx,%eax
  100742:	01 c0                	add    %eax,%eax
  100744:	01 d0                	add    %edx,%eax
  100746:	c1 e0 02             	shl    $0x2,%eax
  100749:	89 c2                	mov    %eax,%edx
  10074b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	8b 10                	mov    (%eax),%edx
  100752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100755:	2b 45 ec             	sub    -0x14(%ebp),%eax
  100758:	39 c2                	cmp    %eax,%edx
  10075a:	73 22                	jae    10077e <debuginfo_eip+0x151>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 c2                	mov    %eax,%edx
  100761:	89 d0                	mov    %edx,%eax
  100763:	01 c0                	add    %eax,%eax
  100765:	01 d0                	add    %edx,%eax
  100767:	c1 e0 02             	shl    $0x2,%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076f:	01 d0                	add    %edx,%eax
  100771:	8b 10                	mov    (%eax),%edx
  100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100776:	01 c2                	add    %eax,%edx
  100778:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10077e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100781:	89 c2                	mov    %eax,%edx
  100783:	89 d0                	mov    %edx,%eax
  100785:	01 c0                	add    %eax,%eax
  100787:	01 d0                	add    %edx,%eax
  100789:	c1 e0 02             	shl    $0x2,%eax
  10078c:	89 c2                	mov    %eax,%edx
  10078e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100791:	01 d0                	add    %edx,%eax
  100793:	8b 50 08             	mov    0x8(%eax),%edx
  100796:	8b 45 0c             	mov    0xc(%ebp),%eax
  100799:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  10079c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079f:	8b 40 10             	mov    0x10(%eax),%eax
  1007a2:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1007a5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007a8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1007ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007ae:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1007b1:	eb 15                	jmp    1007c8 <debuginfo_eip+0x19b>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007b6:	8b 55 08             	mov    0x8(%ebp),%edx
  1007b9:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1007bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1007c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007c5:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007cb:	8b 40 08             	mov    0x8(%eax),%eax
  1007ce:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007d5:	00 
  1007d6:	89 04 24             	mov    %eax,(%esp)
  1007d9:	e8 d1 25 00 00       	call   102daf <strfind>
  1007de:	8b 55 0c             	mov    0xc(%ebp),%edx
  1007e1:	8b 52 08             	mov    0x8(%edx),%edx
  1007e4:	29 d0                	sub    %edx,%eax
  1007e6:	89 c2                	mov    %eax,%edx
  1007e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007eb:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1007f1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007f5:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007fc:	00 
  1007fd:	8d 45 d0             	lea    -0x30(%ebp),%eax
  100800:	89 44 24 08          	mov    %eax,0x8(%esp)
  100804:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100807:	89 44 24 04          	mov    %eax,0x4(%esp)
  10080b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10080e:	89 04 24             	mov    %eax,(%esp)
  100811:	e8 c5 fc ff ff       	call   1004db <stab_binsearch>
    if (lline <= rline) {
  100816:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100819:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10081c:	39 c2                	cmp    %eax,%edx
  10081e:	7f 23                	jg     100843 <debuginfo_eip+0x216>
        info->eip_line = stabs[rline].n_desc;
  100820:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	89 d0                	mov    %edx,%eax
  100827:	01 c0                	add    %eax,%eax
  100829:	01 d0                	add    %edx,%eax
  10082b:	c1 e0 02             	shl    $0x2,%eax
  10082e:	89 c2                	mov    %eax,%edx
  100830:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100833:	01 d0                	add    %edx,%eax
  100835:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100839:	89 c2                	mov    %eax,%edx
  10083b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10083e:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100841:	eb 11                	jmp    100854 <debuginfo_eip+0x227>
        return -1;
  100843:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100848:	e9 08 01 00 00       	jmp    100955 <debuginfo_eip+0x328>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10084d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100850:	48                   	dec    %eax
  100851:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100854:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100857:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10085a:	39 c2                	cmp    %eax,%edx
  10085c:	7c 56                	jl     1008b4 <debuginfo_eip+0x287>
           && stabs[lline].n_type != N_SOL
  10085e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100861:	89 c2                	mov    %eax,%edx
  100863:	89 d0                	mov    %edx,%eax
  100865:	01 c0                	add    %eax,%eax
  100867:	01 d0                	add    %edx,%eax
  100869:	c1 e0 02             	shl    $0x2,%eax
  10086c:	89 c2                	mov    %eax,%edx
  10086e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100871:	01 d0                	add    %edx,%eax
  100873:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100877:	3c 84                	cmp    $0x84,%al
  100879:	74 39                	je     1008b4 <debuginfo_eip+0x287>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10087b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10087e:	89 c2                	mov    %eax,%edx
  100880:	89 d0                	mov    %edx,%eax
  100882:	01 c0                	add    %eax,%eax
  100884:	01 d0                	add    %edx,%eax
  100886:	c1 e0 02             	shl    $0x2,%eax
  100889:	89 c2                	mov    %eax,%edx
  10088b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10088e:	01 d0                	add    %edx,%eax
  100890:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100894:	3c 64                	cmp    $0x64,%al
  100896:	75 b5                	jne    10084d <debuginfo_eip+0x220>
  100898:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089b:	89 c2                	mov    %eax,%edx
  10089d:	89 d0                	mov    %edx,%eax
  10089f:	01 c0                	add    %eax,%eax
  1008a1:	01 d0                	add    %edx,%eax
  1008a3:	c1 e0 02             	shl    $0x2,%eax
  1008a6:	89 c2                	mov    %eax,%edx
  1008a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ab:	01 d0                	add    %edx,%eax
  1008ad:	8b 40 08             	mov    0x8(%eax),%eax
  1008b0:	85 c0                	test   %eax,%eax
  1008b2:	74 99                	je     10084d <debuginfo_eip+0x220>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1008b4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1008ba:	39 c2                	cmp    %eax,%edx
  1008bc:	7c 42                	jl     100900 <debuginfo_eip+0x2d3>
  1008be:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c1:	89 c2                	mov    %eax,%edx
  1008c3:	89 d0                	mov    %edx,%eax
  1008c5:	01 c0                	add    %eax,%eax
  1008c7:	01 d0                	add    %edx,%eax
  1008c9:	c1 e0 02             	shl    $0x2,%eax
  1008cc:	89 c2                	mov    %eax,%edx
  1008ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d1:	01 d0                	add    %edx,%eax
  1008d3:	8b 10                	mov    (%eax),%edx
  1008d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1008d8:	2b 45 ec             	sub    -0x14(%ebp),%eax
  1008db:	39 c2                	cmp    %eax,%edx
  1008dd:	73 21                	jae    100900 <debuginfo_eip+0x2d3>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e2:	89 c2                	mov    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	01 c0                	add    %eax,%eax
  1008e8:	01 d0                	add    %edx,%eax
  1008ea:	c1 e0 02             	shl    $0x2,%eax
  1008ed:	89 c2                	mov    %eax,%edx
  1008ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008f2:	01 d0                	add    %edx,%eax
  1008f4:	8b 10                	mov    (%eax),%edx
  1008f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008f9:	01 c2                	add    %eax,%edx
  1008fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008fe:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100900:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100903:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100906:	39 c2                	cmp    %eax,%edx
  100908:	7d 46                	jge    100950 <debuginfo_eip+0x323>
        for (lline = lfun + 1;
  10090a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10090d:	40                   	inc    %eax
  10090e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100911:	eb 16                	jmp    100929 <debuginfo_eip+0x2fc>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100913:	8b 45 0c             	mov    0xc(%ebp),%eax
  100916:	8b 40 14             	mov    0x14(%eax),%eax
  100919:	8d 50 01             	lea    0x1(%eax),%edx
  10091c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10091f:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100922:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100925:	40                   	inc    %eax
  100926:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100929:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10092c:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  10092f:	39 c2                	cmp    %eax,%edx
  100931:	7d 1d                	jge    100950 <debuginfo_eip+0x323>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100933:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100936:	89 c2                	mov    %eax,%edx
  100938:	89 d0                	mov    %edx,%eax
  10093a:	01 c0                	add    %eax,%eax
  10093c:	01 d0                	add    %edx,%eax
  10093e:	c1 e0 02             	shl    $0x2,%eax
  100941:	89 c2                	mov    %eax,%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10094c:	3c a0                	cmp    $0xa0,%al
  10094e:	74 c3                	je     100913 <debuginfo_eip+0x2e6>
        }
    }
    return 0;
  100950:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100955:	c9                   	leave  
  100956:	c3                   	ret    

00100957 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100957:	f3 0f 1e fb          	endbr32 
  10095b:	55                   	push   %ebp
  10095c:	89 e5                	mov    %esp,%ebp
  10095e:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100961:	c7 04 24 62 38 10 00 	movl   $0x103862,(%esp)
  100968:	e8 27 f9 ff ff       	call   100294 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10096d:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  100974:	00 
  100975:	c7 04 24 7b 38 10 00 	movl   $0x10387b,(%esp)
  10097c:	e8 13 f9 ff ff       	call   100294 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100981:	c7 44 24 04 5f 37 10 	movl   $0x10375f,0x4(%esp)
  100988:	00 
  100989:	c7 04 24 93 38 10 00 	movl   $0x103893,(%esp)
  100990:	e8 ff f8 ff ff       	call   100294 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100995:	c7 44 24 04 16 0a 11 	movl   $0x110a16,0x4(%esp)
  10099c:	00 
  10099d:	c7 04 24 ab 38 10 00 	movl   $0x1038ab,(%esp)
  1009a4:	e8 eb f8 ff ff       	call   100294 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1009a9:	c7 44 24 04 80 1d 11 	movl   $0x111d80,0x4(%esp)
  1009b0:	00 
  1009b1:	c7 04 24 c3 38 10 00 	movl   $0x1038c3,(%esp)
  1009b8:	e8 d7 f8 ff ff       	call   100294 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1009bd:	b8 80 1d 11 00       	mov    $0x111d80,%eax
  1009c2:	2d 00 00 10 00       	sub    $0x100000,%eax
  1009c7:	05 ff 03 00 00       	add    $0x3ff,%eax
  1009cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009d2:	85 c0                	test   %eax,%eax
  1009d4:	0f 48 c2             	cmovs  %edx,%eax
  1009d7:	c1 f8 0a             	sar    $0xa,%eax
  1009da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009de:	c7 04 24 dc 38 10 00 	movl   $0x1038dc,(%esp)
  1009e5:	e8 aa f8 ff ff       	call   100294 <cprintf>
}
  1009ea:	90                   	nop
  1009eb:	c9                   	leave  
  1009ec:	c3                   	ret    

001009ed <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009ed:	f3 0f 1e fb          	endbr32 
  1009f1:	55                   	push   %ebp
  1009f2:	89 e5                	mov    %esp,%ebp
  1009f4:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a01:	8b 45 08             	mov    0x8(%ebp),%eax
  100a04:	89 04 24             	mov    %eax,(%esp)
  100a07:	e8 21 fc ff ff       	call   10062d <debuginfo_eip>
  100a0c:	85 c0                	test   %eax,%eax
  100a0e:	74 15                	je     100a25 <print_debuginfo+0x38>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100a10:	8b 45 08             	mov    0x8(%ebp),%eax
  100a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a17:	c7 04 24 06 39 10 00 	movl   $0x103906,(%esp)
  100a1e:	e8 71 f8 ff ff       	call   100294 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a23:	eb 6c                	jmp    100a91 <print_debuginfo+0xa4>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a25:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a2c:	eb 1b                	jmp    100a49 <print_debuginfo+0x5c>
            fnname[j] = info.eip_fn_name[j];
  100a2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a34:	01 d0                	add    %edx,%eax
  100a36:	0f b6 10             	movzbl (%eax),%edx
  100a39:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	01 c8                	add    %ecx,%eax
  100a44:	88 10                	mov    %dl,(%eax)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a46:	ff 45 f4             	incl   -0xc(%ebp)
  100a49:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a4c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a4f:	7c dd                	jl     100a2e <print_debuginfo+0x41>
        fnname[j] = '\0';
  100a51:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	01 d0                	add    %edx,%eax
  100a5c:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a62:	8b 55 08             	mov    0x8(%ebp),%edx
  100a65:	89 d1                	mov    %edx,%ecx
  100a67:	29 c1                	sub    %eax,%ecx
  100a69:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a6c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a6f:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a73:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a79:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a7d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a81:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a85:	c7 04 24 22 39 10 00 	movl   $0x103922,(%esp)
  100a8c:	e8 03 f8 ff ff       	call   100294 <cprintf>
}
  100a91:	90                   	nop
  100a92:	c9                   	leave  
  100a93:	c3                   	ret    

00100a94 <read_eip>:

// 在调用该函数时会创建相应堆栈，
// 通过创建函数时压入的上一级函数返回地址来间接得到当前的eip
static __noinline uint32_t
read_eip(void) {
  100a94:	f3 0f 1e fb          	endbr32 
  100a98:	55                   	push   %ebp
  100a99:	89 e5                	mov    %esp,%ebp
  100a9b:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a9e:	8b 45 04             	mov    0x4(%ebp),%eax
  100aa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100aa4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100aa7:	c9                   	leave  
  100aa8:	c3                   	ret    

00100aa9 <print_stackframe>:
//          M[R[%esp]] = S
// 出栈指令：pop D，相当于
//          D = M[R[%esp]]; 
//          R[%esp] = R[%esp] + 4
void
print_stackframe(void) {
  100aa9:	f3 0f 1e fb          	endbr32 
  100aad:	55                   	push   %ebp
  100aae:	89 e5                	mov    %esp,%ebp
  100ab0:	53                   	push   %ebx
  100ab1:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100ab4:	89 e8                	mov    %ebp,%eax
  100ab6:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  100ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp=read_ebp();
  100abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip=read_eip();
  100abf:	e8 d0 ff ff ff       	call   100a94 <read_eip>
  100ac4:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (size_t i = 0; i < STACKFRAME_DEPTH; i++){
  100ac7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  100ace:	e9 8e 00 00 00       	jmp    100b61 <print_stackframe+0xb8>
        if (ebp==0){
  100ad3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ad7:	0f 84 90 00 00 00    	je     100b6d <print_stackframe+0xc4>
            break;      
        }
        cprintf("ebp:0x%08x eip:0x%08x ", ebp, eip);
  100add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ae0:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ae7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100aeb:	c7 04 24 34 39 10 00 	movl   $0x103934,(%esp)
  100af2:	e8 9d f7 ff ff       	call   100294 <cprintf>
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8), 
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  100af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100afa:	83 c0 14             	add    $0x14,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8), 
  100afd:	8b 18                	mov    (%eax),%ebx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  100aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b02:	83 c0 10             	add    $0x10,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8), 
  100b05:	8b 08                	mov    (%eax),%ecx
                *(uint32_t *)(ebp + 12), *(uint32_t *)(ebp + 16), *(uint32_t *)(ebp + 20));
  100b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b0a:	83 c0 0c             	add    $0xc,%eax
        cprintf("args:0x%08x 0x%08x 0x%08x 0x%08x", *(uint32_t *)(ebp + 8), 
  100b0d:	8b 10                	mov    (%eax),%edx
  100b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b12:	83 c0 08             	add    $0x8,%eax
  100b15:	8b 00                	mov    (%eax),%eax
  100b17:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  100b1b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100b1f:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b27:	c7 04 24 4c 39 10 00 	movl   $0x10394c,(%esp)
  100b2e:	e8 61 f7 ff ff       	call   100294 <cprintf>
        cprintf("\n");
  100b33:	c7 04 24 6d 39 10 00 	movl   $0x10396d,(%esp)
  100b3a:	e8 55 f7 ff ff       	call   100294 <cprintf>
        print_debuginfo(eip - 1);
  100b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b42:	48                   	dec    %eax
  100b43:	89 04 24             	mov    %eax,(%esp)
  100b46:	e8 a2 fe ff ff       	call   1009ed <print_debuginfo>
   
        eip = *(uint32_t *)(ebp + 4);
  100b4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b4e:	83 c0 04             	add    $0x4,%eax
  100b51:	8b 00                	mov    (%eax),%eax
  100b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = *(uint32_t *)(ebp);
  100b56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b59:	8b 00                	mov    (%eax),%eax
  100b5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (size_t i = 0; i < STACKFRAME_DEPTH; i++){
  100b5e:	ff 45 ec             	incl   -0x14(%ebp)
  100b61:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100b65:	0f 86 68 ff ff ff    	jbe    100ad3 <print_stackframe+0x2a>

        
    }
    
}
  100b6b:	eb 01                	jmp    100b6e <print_stackframe+0xc5>
            break;      
  100b6d:	90                   	nop
}
  100b6e:	90                   	nop
  100b6f:	83 c4 34             	add    $0x34,%esp
  100b72:	5b                   	pop    %ebx
  100b73:	5d                   	pop    %ebp
  100b74:	c3                   	ret    

00100b75 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b75:	f3 0f 1e fb          	endbr32 
  100b79:	55                   	push   %ebp
  100b7a:	89 e5                	mov    %esp,%ebp
  100b7c:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b86:	eb 0c                	jmp    100b94 <parse+0x1f>
            *buf ++ = '\0';
  100b88:	8b 45 08             	mov    0x8(%ebp),%eax
  100b8b:	8d 50 01             	lea    0x1(%eax),%edx
  100b8e:	89 55 08             	mov    %edx,0x8(%ebp)
  100b91:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b94:	8b 45 08             	mov    0x8(%ebp),%eax
  100b97:	0f b6 00             	movzbl (%eax),%eax
  100b9a:	84 c0                	test   %al,%al
  100b9c:	74 1d                	je     100bbb <parse+0x46>
  100b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba1:	0f b6 00             	movzbl (%eax),%eax
  100ba4:	0f be c0             	movsbl %al,%eax
  100ba7:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bab:	c7 04 24 f0 39 10 00 	movl   $0x1039f0,(%esp)
  100bb2:	e8 c2 21 00 00       	call   102d79 <strchr>
  100bb7:	85 c0                	test   %eax,%eax
  100bb9:	75 cd                	jne    100b88 <parse+0x13>
        }
        if (*buf == '\0') {
  100bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  100bbe:	0f b6 00             	movzbl (%eax),%eax
  100bc1:	84 c0                	test   %al,%al
  100bc3:	74 65                	je     100c2a <parse+0xb5>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100bc5:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100bc9:	75 14                	jne    100bdf <parse+0x6a>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100bcb:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100bd2:	00 
  100bd3:	c7 04 24 f5 39 10 00 	movl   $0x1039f5,(%esp)
  100bda:	e8 b5 f6 ff ff       	call   100294 <cprintf>
        }
        argv[argc ++] = buf;
  100bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100be2:	8d 50 01             	lea    0x1(%eax),%edx
  100be5:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100be8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100bef:	8b 45 0c             	mov    0xc(%ebp),%eax
  100bf2:	01 c2                	add    %eax,%edx
  100bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf7:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bf9:	eb 03                	jmp    100bfe <parse+0x89>
            buf ++;
  100bfb:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  100c01:	0f b6 00             	movzbl (%eax),%eax
  100c04:	84 c0                	test   %al,%al
  100c06:	74 8c                	je     100b94 <parse+0x1f>
  100c08:	8b 45 08             	mov    0x8(%ebp),%eax
  100c0b:	0f b6 00             	movzbl (%eax),%eax
  100c0e:	0f be c0             	movsbl %al,%eax
  100c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c15:	c7 04 24 f0 39 10 00 	movl   $0x1039f0,(%esp)
  100c1c:	e8 58 21 00 00       	call   102d79 <strchr>
  100c21:	85 c0                	test   %eax,%eax
  100c23:	74 d6                	je     100bfb <parse+0x86>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100c25:	e9 6a ff ff ff       	jmp    100b94 <parse+0x1f>
            break;
  100c2a:	90                   	nop
        }
    }
    return argc;
  100c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100c2e:	c9                   	leave  
  100c2f:	c3                   	ret    

00100c30 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100c30:	f3 0f 1e fb          	endbr32 
  100c34:	55                   	push   %ebp
  100c35:	89 e5                	mov    %esp,%ebp
  100c37:	53                   	push   %ebx
  100c38:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100c3b:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c42:	8b 45 08             	mov    0x8(%ebp),%eax
  100c45:	89 04 24             	mov    %eax,(%esp)
  100c48:	e8 28 ff ff ff       	call   100b75 <parse>
  100c4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100c50:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100c54:	75 0a                	jne    100c60 <runcmd+0x30>
        return 0;
  100c56:	b8 00 00 00 00       	mov    $0x0,%eax
  100c5b:	e9 83 00 00 00       	jmp    100ce3 <runcmd+0xb3>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c67:	eb 5a                	jmp    100cc3 <runcmd+0x93>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c69:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c6f:	89 d0                	mov    %edx,%eax
  100c71:	01 c0                	add    %eax,%eax
  100c73:	01 d0                	add    %edx,%eax
  100c75:	c1 e0 02             	shl    $0x2,%eax
  100c78:	05 00 00 11 00       	add    $0x110000,%eax
  100c7d:	8b 00                	mov    (%eax),%eax
  100c7f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c83:	89 04 24             	mov    %eax,(%esp)
  100c86:	e8 4a 20 00 00       	call   102cd5 <strcmp>
  100c8b:	85 c0                	test   %eax,%eax
  100c8d:	75 31                	jne    100cc0 <runcmd+0x90>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c92:	89 d0                	mov    %edx,%eax
  100c94:	01 c0                	add    %eax,%eax
  100c96:	01 d0                	add    %edx,%eax
  100c98:	c1 e0 02             	shl    $0x2,%eax
  100c9b:	05 08 00 11 00       	add    $0x110008,%eax
  100ca0:	8b 10                	mov    (%eax),%edx
  100ca2:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100ca5:	83 c0 04             	add    $0x4,%eax
  100ca8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100cab:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100cae:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100cb1:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cb5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cb9:	89 1c 24             	mov    %ebx,(%esp)
  100cbc:	ff d2                	call   *%edx
  100cbe:	eb 23                	jmp    100ce3 <runcmd+0xb3>
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc0:	ff 45 f4             	incl   -0xc(%ebp)
  100cc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cc6:	83 f8 02             	cmp    $0x2,%eax
  100cc9:	76 9e                	jbe    100c69 <runcmd+0x39>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ccb:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd2:	c7 04 24 13 3a 10 00 	movl   $0x103a13,(%esp)
  100cd9:	e8 b6 f5 ff ff       	call   100294 <cprintf>
    return 0;
  100cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ce3:	83 c4 64             	add    $0x64,%esp
  100ce6:	5b                   	pop    %ebx
  100ce7:	5d                   	pop    %ebp
  100ce8:	c3                   	ret    

00100ce9 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100ce9:	f3 0f 1e fb          	endbr32 
  100ced:	55                   	push   %ebp
  100cee:	89 e5                	mov    %esp,%ebp
  100cf0:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100cf3:	c7 04 24 2c 3a 10 00 	movl   $0x103a2c,(%esp)
  100cfa:	e8 95 f5 ff ff       	call   100294 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100cff:	c7 04 24 54 3a 10 00 	movl   $0x103a54,(%esp)
  100d06:	e8 89 f5 ff ff       	call   100294 <cprintf>

    if (tf != NULL) {
  100d0b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100d0f:	74 0b                	je     100d1c <kmonitor+0x33>
        print_trapframe(tf);
  100d11:	8b 45 08             	mov    0x8(%ebp),%eax
  100d14:	89 04 24             	mov    %eax,(%esp)
  100d17:	e8 d6 0d 00 00       	call   101af2 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100d1c:	c7 04 24 79 3a 10 00 	movl   $0x103a79,(%esp)
  100d23:	e8 1f f6 ff ff       	call   100347 <readline>
  100d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100d2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100d2f:	74 eb                	je     100d1c <kmonitor+0x33>
            if (runcmd(buf, tf) < 0) {
  100d31:	8b 45 08             	mov    0x8(%ebp),%eax
  100d34:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d3b:	89 04 24             	mov    %eax,(%esp)
  100d3e:	e8 ed fe ff ff       	call   100c30 <runcmd>
  100d43:	85 c0                	test   %eax,%eax
  100d45:	78 02                	js     100d49 <kmonitor+0x60>
        if ((buf = readline("K> ")) != NULL) {
  100d47:	eb d3                	jmp    100d1c <kmonitor+0x33>
                break;
  100d49:	90                   	nop
            }
        }
    }
}
  100d4a:	90                   	nop
  100d4b:	c9                   	leave  
  100d4c:	c3                   	ret    

00100d4d <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100d4d:	f3 0f 1e fb          	endbr32 
  100d51:	55                   	push   %ebp
  100d52:	89 e5                	mov    %esp,%ebp
  100d54:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100d57:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100d5e:	eb 3d                	jmp    100d9d <mon_help+0x50>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d63:	89 d0                	mov    %edx,%eax
  100d65:	01 c0                	add    %eax,%eax
  100d67:	01 d0                	add    %edx,%eax
  100d69:	c1 e0 02             	shl    $0x2,%eax
  100d6c:	05 04 00 11 00       	add    $0x110004,%eax
  100d71:	8b 08                	mov    (%eax),%ecx
  100d73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d76:	89 d0                	mov    %edx,%eax
  100d78:	01 c0                	add    %eax,%eax
  100d7a:	01 d0                	add    %edx,%eax
  100d7c:	c1 e0 02             	shl    $0x2,%eax
  100d7f:	05 00 00 11 00       	add    $0x110000,%eax
  100d84:	8b 00                	mov    (%eax),%eax
  100d86:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d8e:	c7 04 24 7d 3a 10 00 	movl   $0x103a7d,(%esp)
  100d95:	e8 fa f4 ff ff       	call   100294 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d9a:	ff 45 f4             	incl   -0xc(%ebp)
  100d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100da0:	83 f8 02             	cmp    $0x2,%eax
  100da3:	76 bb                	jbe    100d60 <mon_help+0x13>
    }
    return 0;
  100da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100daa:	c9                   	leave  
  100dab:	c3                   	ret    

00100dac <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100dac:	f3 0f 1e fb          	endbr32 
  100db0:	55                   	push   %ebp
  100db1:	89 e5                	mov    %esp,%ebp
  100db3:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100db6:	e8 9c fb ff ff       	call   100957 <print_kerninfo>
    return 0;
  100dbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dc0:	c9                   	leave  
  100dc1:	c3                   	ret    

00100dc2 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100dc2:	f3 0f 1e fb          	endbr32 
  100dc6:	55                   	push   %ebp
  100dc7:	89 e5                	mov    %esp,%ebp
  100dc9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100dcc:	e8 d8 fc ff ff       	call   100aa9 <print_stackframe>
    return 0;
  100dd1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dd6:	c9                   	leave  
  100dd7:	c3                   	ret    

00100dd8 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100dd8:	f3 0f 1e fb          	endbr32 
  100ddc:	55                   	push   %ebp
  100ddd:	89 e5                	mov    %esp,%ebp
  100ddf:	83 ec 28             	sub    $0x28,%esp
  100de2:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100de8:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100dec:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100df0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100df4:	ee                   	out    %al,(%dx)
}
  100df5:	90                   	nop
  100df6:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100dfc:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e00:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e04:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e08:	ee                   	out    %al,(%dx)
}
  100e09:	90                   	nop
  100e0a:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100e10:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e14:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100e18:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e1c:	ee                   	out    %al,(%dx)
}
  100e1d:	90                   	nop
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100e1e:	c7 05 08 19 11 00 00 	movl   $0x0,0x111908
  100e25:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100e28:	c7 04 24 86 3a 10 00 	movl   $0x103a86,(%esp)
  100e2f:	e8 60 f4 ff ff       	call   100294 <cprintf>
    pic_enable(IRQ_TIMER);
  100e34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100e3b:	e8 31 09 00 00       	call   101771 <pic_enable>
}
  100e40:	90                   	nop
  100e41:	c9                   	leave  
  100e42:	c3                   	ret    

00100e43 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e43:	f3 0f 1e fb          	endbr32 
  100e47:	55                   	push   %ebp
  100e48:	89 e5                	mov    %esp,%ebp
  100e4a:	83 ec 10             	sub    $0x10,%esp
  100e4d:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e53:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e57:	89 c2                	mov    %eax,%edx
  100e59:	ec                   	in     (%dx),%al
  100e5a:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e5d:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e63:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e67:	89 c2                	mov    %eax,%edx
  100e69:	ec                   	in     (%dx),%al
  100e6a:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e6d:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e73:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e77:	89 c2                	mov    %eax,%edx
  100e79:	ec                   	in     (%dx),%al
  100e7a:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e7d:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e83:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e87:	89 c2                	mov    %eax,%edx
  100e89:	ec                   	in     (%dx),%al
  100e8a:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e8d:	90                   	nop
  100e8e:	c9                   	leave  
  100e8f:	c3                   	ret    

00100e90 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100e90:	f3 0f 1e fb          	endbr32 
  100e94:	55                   	push   %ebp
  100e95:	89 e5                	mov    %esp,%ebp
  100e97:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100e9a:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100ea1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ea4:	0f b7 00             	movzwl (%eax),%eax
  100ea7:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100eab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eae:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100eb3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb6:	0f b7 00             	movzwl (%eax),%eax
  100eb9:	0f b7 c0             	movzwl %ax,%eax
  100ebc:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100ec1:	74 12                	je     100ed5 <cga_init+0x45>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100ec3:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100eca:	66 c7 05 66 0e 11 00 	movw   $0x3b4,0x110e66
  100ed1:	b4 03 
  100ed3:	eb 13                	jmp    100ee8 <cga_init+0x58>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ed8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100edc:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100edf:	66 c7 05 66 0e 11 00 	movw   $0x3d4,0x110e66
  100ee6:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100ee8:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100eef:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100ef3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ef7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100efb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100eff:	ee                   	out    %al,(%dx)
}
  100f00:	90                   	nop
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100f01:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f08:	40                   	inc    %eax
  100f09:	0f b7 c0             	movzwl %ax,%eax
  100f0c:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f10:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100f14:	89 c2                	mov    %eax,%edx
  100f16:	ec                   	in     (%dx),%al
  100f17:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100f1a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1e:	0f b6 c0             	movzbl %al,%eax
  100f21:	c1 e0 08             	shl    $0x8,%eax
  100f24:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f27:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f2e:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100f32:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f36:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f3a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3e:	ee                   	out    %al,(%dx)
}
  100f3f:	90                   	nop
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100f40:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  100f47:	40                   	inc    %eax
  100f48:	0f b7 c0             	movzwl %ax,%eax
  100f4b:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f4f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f53:	89 c2                	mov    %eax,%edx
  100f55:	ec                   	in     (%dx),%al
  100f56:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f59:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f5d:	0f b6 c0             	movzbl %al,%eax
  100f60:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f66:	a3 60 0e 11 00       	mov    %eax,0x110e60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f6e:	0f b7 c0             	movzwl %ax,%eax
  100f71:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
}
  100f77:	90                   	nop
  100f78:	c9                   	leave  
  100f79:	c3                   	ret    

00100f7a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f7a:	f3 0f 1e fb          	endbr32 
  100f7e:	55                   	push   %ebp
  100f7f:	89 e5                	mov    %esp,%ebp
  100f81:	83 ec 48             	sub    $0x48,%esp
  100f84:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f8a:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f8e:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f92:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f96:	ee                   	out    %al,(%dx)
}
  100f97:	90                   	nop
  100f98:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f9e:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fa2:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100fa6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100faa:	ee                   	out    %al,(%dx)
}
  100fab:	90                   	nop
  100fac:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100fb2:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fb6:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100fba:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100fbe:	ee                   	out    %al,(%dx)
}
  100fbf:	90                   	nop
  100fc0:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fc6:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fca:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fce:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fd2:	ee                   	out    %al,(%dx)
}
  100fd3:	90                   	nop
  100fd4:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100fda:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100fde:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fe2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fe6:	ee                   	out    %al,(%dx)
}
  100fe7:	90                   	nop
  100fe8:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100fee:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff2:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ff6:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ffa:	ee                   	out    %al,(%dx)
}
  100ffb:	90                   	nop
  100ffc:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  101002:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101006:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10100a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10100e:	ee                   	out    %al,(%dx)
}
  10100f:	90                   	nop
  101010:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101016:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  10101a:	89 c2                	mov    %eax,%edx
  10101c:	ec                   	in     (%dx),%al
  10101d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  101020:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101024:	3c ff                	cmp    $0xff,%al
  101026:	0f 95 c0             	setne  %al
  101029:	0f b6 c0             	movzbl %al,%eax
  10102c:	a3 68 0e 11 00       	mov    %eax,0x110e68
  101031:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101037:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10103b:	89 c2                	mov    %eax,%edx
  10103d:	ec                   	in     (%dx),%al
  10103e:	88 45 f1             	mov    %al,-0xf(%ebp)
  101041:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101047:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10104b:	89 c2                	mov    %eax,%edx
  10104d:	ec                   	in     (%dx),%al
  10104e:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101051:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101056:	85 c0                	test   %eax,%eax
  101058:	74 0c                	je     101066 <serial_init+0xec>
        pic_enable(IRQ_COM1);
  10105a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101061:	e8 0b 07 00 00       	call   101771 <pic_enable>
    }
}
  101066:	90                   	nop
  101067:	c9                   	leave  
  101068:	c3                   	ret    

00101069 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101069:	f3 0f 1e fb          	endbr32 
  10106d:	55                   	push   %ebp
  10106e:	89 e5                	mov    %esp,%ebp
  101070:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101073:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10107a:	eb 08                	jmp    101084 <lpt_putc_sub+0x1b>
        delay();
  10107c:	e8 c2 fd ff ff       	call   100e43 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101081:	ff 45 fc             	incl   -0x4(%ebp)
  101084:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  10108a:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10108e:	89 c2                	mov    %eax,%edx
  101090:	ec                   	in     (%dx),%al
  101091:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101094:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101098:	84 c0                	test   %al,%al
  10109a:	78 09                	js     1010a5 <lpt_putc_sub+0x3c>
  10109c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1010a3:	7e d7                	jle    10107c <lpt_putc_sub+0x13>
    }
    outb(LPTPORT + 0, c);
  1010a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a8:	0f b6 c0             	movzbl %al,%eax
  1010ab:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  1010b1:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010b4:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010b8:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010bc:	ee                   	out    %al,(%dx)
}
  1010bd:	90                   	nop
  1010be:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  1010c4:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010c8:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010cc:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010d0:	ee                   	out    %al,(%dx)
}
  1010d1:	90                   	nop
  1010d2:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  1010d8:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1010dc:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010e0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1010e4:	ee                   	out    %al,(%dx)
}
  1010e5:	90                   	nop
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010e6:	90                   	nop
  1010e7:	c9                   	leave  
  1010e8:	c3                   	ret    

001010e9 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010e9:	f3 0f 1e fb          	endbr32 
  1010ed:	55                   	push   %ebp
  1010ee:	89 e5                	mov    %esp,%ebp
  1010f0:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010f3:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010f7:	74 0d                	je     101106 <lpt_putc+0x1d>
        lpt_putc_sub(c);
  1010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fc:	89 04 24             	mov    %eax,(%esp)
  1010ff:	e8 65 ff ff ff       	call   101069 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  101104:	eb 24                	jmp    10112a <lpt_putc+0x41>
        lpt_putc_sub('\b');
  101106:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10110d:	e8 57 ff ff ff       	call   101069 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101112:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101119:	e8 4b ff ff ff       	call   101069 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10111e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101125:	e8 3f ff ff ff       	call   101069 <lpt_putc_sub>
}
  10112a:	90                   	nop
  10112b:	c9                   	leave  
  10112c:	c3                   	ret    

0010112d <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10112d:	f3 0f 1e fb          	endbr32 
  101131:	55                   	push   %ebp
  101132:	89 e5                	mov    %esp,%ebp
  101134:	53                   	push   %ebx
  101135:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101138:	8b 45 08             	mov    0x8(%ebp),%eax
  10113b:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101140:	85 c0                	test   %eax,%eax
  101142:	75 07                	jne    10114b <cga_putc+0x1e>
        c |= 0x0700;
  101144:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  10114b:	8b 45 08             	mov    0x8(%ebp),%eax
  10114e:	0f b6 c0             	movzbl %al,%eax
  101151:	83 f8 0d             	cmp    $0xd,%eax
  101154:	74 72                	je     1011c8 <cga_putc+0x9b>
  101156:	83 f8 0d             	cmp    $0xd,%eax
  101159:	0f 8f a3 00 00 00    	jg     101202 <cga_putc+0xd5>
  10115f:	83 f8 08             	cmp    $0x8,%eax
  101162:	74 0a                	je     10116e <cga_putc+0x41>
  101164:	83 f8 0a             	cmp    $0xa,%eax
  101167:	74 4c                	je     1011b5 <cga_putc+0x88>
  101169:	e9 94 00 00 00       	jmp    101202 <cga_putc+0xd5>
    case '\b':
        if (crt_pos > 0) {
  10116e:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101175:	85 c0                	test   %eax,%eax
  101177:	0f 84 af 00 00 00    	je     10122c <cga_putc+0xff>
            crt_pos --;
  10117d:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101184:	48                   	dec    %eax
  101185:	0f b7 c0             	movzwl %ax,%eax
  101188:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10118e:	8b 45 08             	mov    0x8(%ebp),%eax
  101191:	98                   	cwtl   
  101192:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101197:	98                   	cwtl   
  101198:	83 c8 20             	or     $0x20,%eax
  10119b:	98                   	cwtl   
  10119c:	8b 15 60 0e 11 00    	mov    0x110e60,%edx
  1011a2:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011a9:	01 c9                	add    %ecx,%ecx
  1011ab:	01 ca                	add    %ecx,%edx
  1011ad:	0f b7 c0             	movzwl %ax,%eax
  1011b0:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011b3:	eb 77                	jmp    10122c <cga_putc+0xff>
    case '\n':
        crt_pos += CRT_COLS;
  1011b5:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1011bc:	83 c0 50             	add    $0x50,%eax
  1011bf:	0f b7 c0             	movzwl %ax,%eax
  1011c2:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011c8:	0f b7 1d 64 0e 11 00 	movzwl 0x110e64,%ebx
  1011cf:	0f b7 0d 64 0e 11 00 	movzwl 0x110e64,%ecx
  1011d6:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  1011db:	89 c8                	mov    %ecx,%eax
  1011dd:	f7 e2                	mul    %edx
  1011df:	c1 ea 06             	shr    $0x6,%edx
  1011e2:	89 d0                	mov    %edx,%eax
  1011e4:	c1 e0 02             	shl    $0x2,%eax
  1011e7:	01 d0                	add    %edx,%eax
  1011e9:	c1 e0 04             	shl    $0x4,%eax
  1011ec:	29 c1                	sub    %eax,%ecx
  1011ee:	89 c8                	mov    %ecx,%eax
  1011f0:	0f b7 c0             	movzwl %ax,%eax
  1011f3:	29 c3                	sub    %eax,%ebx
  1011f5:	89 d8                	mov    %ebx,%eax
  1011f7:	0f b7 c0             	movzwl %ax,%eax
  1011fa:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
        break;
  101200:	eb 2b                	jmp    10122d <cga_putc+0x100>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101202:	8b 0d 60 0e 11 00    	mov    0x110e60,%ecx
  101208:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10120f:	8d 50 01             	lea    0x1(%eax),%edx
  101212:	0f b7 d2             	movzwl %dx,%edx
  101215:	66 89 15 64 0e 11 00 	mov    %dx,0x110e64
  10121c:	01 c0                	add    %eax,%eax
  10121e:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101221:	8b 45 08             	mov    0x8(%ebp),%eax
  101224:	0f b7 c0             	movzwl %ax,%eax
  101227:	66 89 02             	mov    %ax,(%edx)
        break;
  10122a:	eb 01                	jmp    10122d <cga_putc+0x100>
        break;
  10122c:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10122d:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  101234:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101239:	76 5d                	jbe    101298 <cga_putc+0x16b>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  10123b:	a1 60 0e 11 00       	mov    0x110e60,%eax
  101240:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101246:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10124b:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101252:	00 
  101253:	89 54 24 04          	mov    %edx,0x4(%esp)
  101257:	89 04 24             	mov    %eax,(%esp)
  10125a:	e8 1f 1d 00 00       	call   102f7e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10125f:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101266:	eb 14                	jmp    10127c <cga_putc+0x14f>
            crt_buf[i] = 0x0700 | ' ';
  101268:	a1 60 0e 11 00       	mov    0x110e60,%eax
  10126d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101270:	01 d2                	add    %edx,%edx
  101272:	01 d0                	add    %edx,%eax
  101274:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101279:	ff 45 f4             	incl   -0xc(%ebp)
  10127c:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101283:	7e e3                	jle    101268 <cga_putc+0x13b>
        }
        crt_pos -= CRT_COLS;
  101285:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  10128c:	83 e8 50             	sub    $0x50,%eax
  10128f:	0f b7 c0             	movzwl %ax,%eax
  101292:	66 a3 64 0e 11 00    	mov    %ax,0x110e64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101298:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  10129f:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1012a3:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012a7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012ab:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012af:	ee                   	out    %al,(%dx)
}
  1012b0:	90                   	nop
    outb(addr_6845 + 1, crt_pos >> 8);
  1012b1:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012b8:	c1 e8 08             	shr    $0x8,%eax
  1012bb:	0f b7 c0             	movzwl %ax,%eax
  1012be:	0f b6 c0             	movzbl %al,%eax
  1012c1:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  1012c8:	42                   	inc    %edx
  1012c9:	0f b7 d2             	movzwl %dx,%edx
  1012cc:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1012d0:	88 45 e9             	mov    %al,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012d3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012d7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012db:	ee                   	out    %al,(%dx)
}
  1012dc:	90                   	nop
    outb(addr_6845, 15);
  1012dd:	0f b7 05 66 0e 11 00 	movzwl 0x110e66,%eax
  1012e4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  1012e8:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ec:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012f0:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012f4:	ee                   	out    %al,(%dx)
}
  1012f5:	90                   	nop
    outb(addr_6845 + 1, crt_pos);
  1012f6:	0f b7 05 64 0e 11 00 	movzwl 0x110e64,%eax
  1012fd:	0f b6 c0             	movzbl %al,%eax
  101300:	0f b7 15 66 0e 11 00 	movzwl 0x110e66,%edx
  101307:	42                   	inc    %edx
  101308:	0f b7 d2             	movzwl %dx,%edx
  10130b:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  10130f:	88 45 f1             	mov    %al,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101312:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101316:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10131a:	ee                   	out    %al,(%dx)
}
  10131b:	90                   	nop
}
  10131c:	90                   	nop
  10131d:	83 c4 34             	add    $0x34,%esp
  101320:	5b                   	pop    %ebx
  101321:	5d                   	pop    %ebp
  101322:	c3                   	ret    

00101323 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101323:	f3 0f 1e fb          	endbr32 
  101327:	55                   	push   %ebp
  101328:	89 e5                	mov    %esp,%ebp
  10132a:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10132d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101334:	eb 08                	jmp    10133e <serial_putc_sub+0x1b>
        delay();
  101336:	e8 08 fb ff ff       	call   100e43 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10133b:	ff 45 fc             	incl   -0x4(%ebp)
  10133e:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101344:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101348:	89 c2                	mov    %eax,%edx
  10134a:	ec                   	in     (%dx),%al
  10134b:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10134e:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101352:	0f b6 c0             	movzbl %al,%eax
  101355:	83 e0 20             	and    $0x20,%eax
  101358:	85 c0                	test   %eax,%eax
  10135a:	75 09                	jne    101365 <serial_putc_sub+0x42>
  10135c:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101363:	7e d1                	jle    101336 <serial_putc_sub+0x13>
    }
    outb(COM1 + COM_TX, c);
  101365:	8b 45 08             	mov    0x8(%ebp),%eax
  101368:	0f b6 c0             	movzbl %al,%eax
  10136b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101371:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101374:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101378:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10137c:	ee                   	out    %al,(%dx)
}
  10137d:	90                   	nop
}
  10137e:	90                   	nop
  10137f:	c9                   	leave  
  101380:	c3                   	ret    

00101381 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101381:	f3 0f 1e fb          	endbr32 
  101385:	55                   	push   %ebp
  101386:	89 e5                	mov    %esp,%ebp
  101388:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10138b:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10138f:	74 0d                	je     10139e <serial_putc+0x1d>
        serial_putc_sub(c);
  101391:	8b 45 08             	mov    0x8(%ebp),%eax
  101394:	89 04 24             	mov    %eax,(%esp)
  101397:	e8 87 ff ff ff       	call   101323 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  10139c:	eb 24                	jmp    1013c2 <serial_putc+0x41>
        serial_putc_sub('\b');
  10139e:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013a5:	e8 79 ff ff ff       	call   101323 <serial_putc_sub>
        serial_putc_sub(' ');
  1013aa:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013b1:	e8 6d ff ff ff       	call   101323 <serial_putc_sub>
        serial_putc_sub('\b');
  1013b6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013bd:	e8 61 ff ff ff       	call   101323 <serial_putc_sub>
}
  1013c2:	90                   	nop
  1013c3:	c9                   	leave  
  1013c4:	c3                   	ret    

001013c5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013c5:	f3 0f 1e fb          	endbr32 
  1013c9:	55                   	push   %ebp
  1013ca:	89 e5                	mov    %esp,%ebp
  1013cc:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013cf:	eb 33                	jmp    101404 <cons_intr+0x3f>
        if (c != 0) {
  1013d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013d5:	74 2d                	je     101404 <cons_intr+0x3f>
            cons.buf[cons.wpos ++] = c;
  1013d7:	a1 84 10 11 00       	mov    0x111084,%eax
  1013dc:	8d 50 01             	lea    0x1(%eax),%edx
  1013df:	89 15 84 10 11 00    	mov    %edx,0x111084
  1013e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013e8:	88 90 80 0e 11 00    	mov    %dl,0x110e80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  1013ee:	a1 84 10 11 00       	mov    0x111084,%eax
  1013f3:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013f8:	75 0a                	jne    101404 <cons_intr+0x3f>
                cons.wpos = 0;
  1013fa:	c7 05 84 10 11 00 00 	movl   $0x0,0x111084
  101401:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101404:	8b 45 08             	mov    0x8(%ebp),%eax
  101407:	ff d0                	call   *%eax
  101409:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10140c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101410:	75 bf                	jne    1013d1 <cons_intr+0xc>
            }
        }
    }
}
  101412:	90                   	nop
  101413:	90                   	nop
  101414:	c9                   	leave  
  101415:	c3                   	ret    

00101416 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101416:	f3 0f 1e fb          	endbr32 
  10141a:	55                   	push   %ebp
  10141b:	89 e5                	mov    %esp,%ebp
  10141d:	83 ec 10             	sub    $0x10,%esp
  101420:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101426:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10142a:	89 c2                	mov    %eax,%edx
  10142c:	ec                   	in     (%dx),%al
  10142d:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101430:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  101434:	0f b6 c0             	movzbl %al,%eax
  101437:	83 e0 01             	and    $0x1,%eax
  10143a:	85 c0                	test   %eax,%eax
  10143c:	75 07                	jne    101445 <serial_proc_data+0x2f>
        return -1;
  10143e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101443:	eb 2a                	jmp    10146f <serial_proc_data+0x59>
  101445:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10144b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10144f:	89 c2                	mov    %eax,%edx
  101451:	ec                   	in     (%dx),%al
  101452:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  101455:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101459:	0f b6 c0             	movzbl %al,%eax
  10145c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  10145f:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  101463:	75 07                	jne    10146c <serial_proc_data+0x56>
        c = '\b';
  101465:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  10146c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10146f:	c9                   	leave  
  101470:	c3                   	ret    

00101471 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101471:	f3 0f 1e fb          	endbr32 
  101475:	55                   	push   %ebp
  101476:	89 e5                	mov    %esp,%ebp
  101478:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10147b:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101480:	85 c0                	test   %eax,%eax
  101482:	74 0c                	je     101490 <serial_intr+0x1f>
        cons_intr(serial_proc_data);
  101484:	c7 04 24 16 14 10 00 	movl   $0x101416,(%esp)
  10148b:	e8 35 ff ff ff       	call   1013c5 <cons_intr>
    }
}
  101490:	90                   	nop
  101491:	c9                   	leave  
  101492:	c3                   	ret    

00101493 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101493:	f3 0f 1e fb          	endbr32 
  101497:	55                   	push   %ebp
  101498:	89 e5                	mov    %esp,%ebp
  10149a:	83 ec 38             	sub    $0x38,%esp
  10149d:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1014a6:	89 c2                	mov    %eax,%edx
  1014a8:	ec                   	in     (%dx),%al
  1014a9:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1014ac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014b0:	0f b6 c0             	movzbl %al,%eax
  1014b3:	83 e0 01             	and    $0x1,%eax
  1014b6:	85 c0                	test   %eax,%eax
  1014b8:	75 0a                	jne    1014c4 <kbd_proc_data+0x31>
        return -1;
  1014ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014bf:	e9 56 01 00 00       	jmp    10161a <kbd_proc_data+0x187>
  1014c4:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1014ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1014cd:	89 c2                	mov    %eax,%edx
  1014cf:	ec                   	in     (%dx),%al
  1014d0:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1014d3:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014d7:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014da:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014de:	75 17                	jne    1014f7 <kbd_proc_data+0x64>
        // E0 escape character
        shift |= E0ESC;
  1014e0:	a1 88 10 11 00       	mov    0x111088,%eax
  1014e5:	83 c8 40             	or     $0x40,%eax
  1014e8:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  1014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  1014f2:	e9 23 01 00 00       	jmp    10161a <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  1014f7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014fb:	84 c0                	test   %al,%al
  1014fd:	79 45                	jns    101544 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  1014ff:	a1 88 10 11 00       	mov    0x111088,%eax
  101504:	83 e0 40             	and    $0x40,%eax
  101507:	85 c0                	test   %eax,%eax
  101509:	75 08                	jne    101513 <kbd_proc_data+0x80>
  10150b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10150f:	24 7f                	and    $0x7f,%al
  101511:	eb 04                	jmp    101517 <kbd_proc_data+0x84>
  101513:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101517:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10151a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151e:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  101525:	0c 40                	or     $0x40,%al
  101527:	0f b6 c0             	movzbl %al,%eax
  10152a:	f7 d0                	not    %eax
  10152c:	89 c2                	mov    %eax,%edx
  10152e:	a1 88 10 11 00       	mov    0x111088,%eax
  101533:	21 d0                	and    %edx,%eax
  101535:	a3 88 10 11 00       	mov    %eax,0x111088
        return 0;
  10153a:	b8 00 00 00 00       	mov    $0x0,%eax
  10153f:	e9 d6 00 00 00       	jmp    10161a <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101544:	a1 88 10 11 00       	mov    0x111088,%eax
  101549:	83 e0 40             	and    $0x40,%eax
  10154c:	85 c0                	test   %eax,%eax
  10154e:	74 11                	je     101561 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101550:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101554:	a1 88 10 11 00       	mov    0x111088,%eax
  101559:	83 e0 bf             	and    $0xffffffbf,%eax
  10155c:	a3 88 10 11 00       	mov    %eax,0x111088
    }

    shift |= shiftcode[data];
  101561:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101565:	0f b6 80 40 00 11 00 	movzbl 0x110040(%eax),%eax
  10156c:	0f b6 d0             	movzbl %al,%edx
  10156f:	a1 88 10 11 00       	mov    0x111088,%eax
  101574:	09 d0                	or     %edx,%eax
  101576:	a3 88 10 11 00       	mov    %eax,0x111088
    shift ^= togglecode[data];
  10157b:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10157f:	0f b6 80 40 01 11 00 	movzbl 0x110140(%eax),%eax
  101586:	0f b6 d0             	movzbl %al,%edx
  101589:	a1 88 10 11 00       	mov    0x111088,%eax
  10158e:	31 d0                	xor    %edx,%eax
  101590:	a3 88 10 11 00       	mov    %eax,0x111088

    c = charcode[shift & (CTL | SHIFT)][data];
  101595:	a1 88 10 11 00       	mov    0x111088,%eax
  10159a:	83 e0 03             	and    $0x3,%eax
  10159d:	8b 14 85 40 05 11 00 	mov    0x110540(,%eax,4),%edx
  1015a4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015a8:	01 d0                	add    %edx,%eax
  1015aa:	0f b6 00             	movzbl (%eax),%eax
  1015ad:	0f b6 c0             	movzbl %al,%eax
  1015b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015b3:	a1 88 10 11 00       	mov    0x111088,%eax
  1015b8:	83 e0 08             	and    $0x8,%eax
  1015bb:	85 c0                	test   %eax,%eax
  1015bd:	74 22                	je     1015e1 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1015bf:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015c3:	7e 0c                	jle    1015d1 <kbd_proc_data+0x13e>
  1015c5:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015c9:	7f 06                	jg     1015d1 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1015cb:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015cf:	eb 10                	jmp    1015e1 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1015d1:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015d5:	7e 0a                	jle    1015e1 <kbd_proc_data+0x14e>
  1015d7:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015db:	7f 04                	jg     1015e1 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  1015dd:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015e1:	a1 88 10 11 00       	mov    0x111088,%eax
  1015e6:	f7 d0                	not    %eax
  1015e8:	83 e0 06             	and    $0x6,%eax
  1015eb:	85 c0                	test   %eax,%eax
  1015ed:	75 28                	jne    101617 <kbd_proc_data+0x184>
  1015ef:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  1015f6:	75 1f                	jne    101617 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  1015f8:	c7 04 24 a1 3a 10 00 	movl   $0x103aa1,(%esp)
  1015ff:	e8 90 ec ff ff       	call   100294 <cprintf>
  101604:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10160a:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10160e:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101612:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101615:	ee                   	out    %al,(%dx)
}
  101616:	90                   	nop
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101617:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10161a:	c9                   	leave  
  10161b:	c3                   	ret    

0010161c <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10161c:	f3 0f 1e fb          	endbr32 
  101620:	55                   	push   %ebp
  101621:	89 e5                	mov    %esp,%ebp
  101623:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101626:	c7 04 24 93 14 10 00 	movl   $0x101493,(%esp)
  10162d:	e8 93 fd ff ff       	call   1013c5 <cons_intr>
}
  101632:	90                   	nop
  101633:	c9                   	leave  
  101634:	c3                   	ret    

00101635 <kbd_init>:

static void
kbd_init(void) {
  101635:	f3 0f 1e fb          	endbr32 
  101639:	55                   	push   %ebp
  10163a:	89 e5                	mov    %esp,%ebp
  10163c:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  10163f:	e8 d8 ff ff ff       	call   10161c <kbd_intr>
    pic_enable(IRQ_KBD);
  101644:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10164b:	e8 21 01 00 00       	call   101771 <pic_enable>
}
  101650:	90                   	nop
  101651:	c9                   	leave  
  101652:	c3                   	ret    

00101653 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101653:	f3 0f 1e fb          	endbr32 
  101657:	55                   	push   %ebp
  101658:	89 e5                	mov    %esp,%ebp
  10165a:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10165d:	e8 2e f8 ff ff       	call   100e90 <cga_init>
    serial_init();
  101662:	e8 13 f9 ff ff       	call   100f7a <serial_init>
    kbd_init();
  101667:	e8 c9 ff ff ff       	call   101635 <kbd_init>
    if (!serial_exists) {
  10166c:	a1 68 0e 11 00       	mov    0x110e68,%eax
  101671:	85 c0                	test   %eax,%eax
  101673:	75 0c                	jne    101681 <cons_init+0x2e>
        cprintf("serial port does not exist!!\n");
  101675:	c7 04 24 ad 3a 10 00 	movl   $0x103aad,(%esp)
  10167c:	e8 13 ec ff ff       	call   100294 <cprintf>
    }
}
  101681:	90                   	nop
  101682:	c9                   	leave  
  101683:	c3                   	ret    

00101684 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101684:	f3 0f 1e fb          	endbr32 
  101688:	55                   	push   %ebp
  101689:	89 e5                	mov    %esp,%ebp
  10168b:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10168e:	8b 45 08             	mov    0x8(%ebp),%eax
  101691:	89 04 24             	mov    %eax,(%esp)
  101694:	e8 50 fa ff ff       	call   1010e9 <lpt_putc>
    cga_putc(c);
  101699:	8b 45 08             	mov    0x8(%ebp),%eax
  10169c:	89 04 24             	mov    %eax,(%esp)
  10169f:	e8 89 fa ff ff       	call   10112d <cga_putc>
    serial_putc(c);
  1016a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a7:	89 04 24             	mov    %eax,(%esp)
  1016aa:	e8 d2 fc ff ff       	call   101381 <serial_putc>
}
  1016af:	90                   	nop
  1016b0:	c9                   	leave  
  1016b1:	c3                   	ret    

001016b2 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016b2:	f3 0f 1e fb          	endbr32 
  1016b6:	55                   	push   %ebp
  1016b7:	89 e5                	mov    %esp,%ebp
  1016b9:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1016bc:	e8 b0 fd ff ff       	call   101471 <serial_intr>
    kbd_intr();
  1016c1:	e8 56 ff ff ff       	call   10161c <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1016c6:	8b 15 80 10 11 00    	mov    0x111080,%edx
  1016cc:	a1 84 10 11 00       	mov    0x111084,%eax
  1016d1:	39 c2                	cmp    %eax,%edx
  1016d3:	74 36                	je     10170b <cons_getc+0x59>
        c = cons.buf[cons.rpos ++];
  1016d5:	a1 80 10 11 00       	mov    0x111080,%eax
  1016da:	8d 50 01             	lea    0x1(%eax),%edx
  1016dd:	89 15 80 10 11 00    	mov    %edx,0x111080
  1016e3:	0f b6 80 80 0e 11 00 	movzbl 0x110e80(%eax),%eax
  1016ea:	0f b6 c0             	movzbl %al,%eax
  1016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1016f0:	a1 80 10 11 00       	mov    0x111080,%eax
  1016f5:	3d 00 02 00 00       	cmp    $0x200,%eax
  1016fa:	75 0a                	jne    101706 <cons_getc+0x54>
            cons.rpos = 0;
  1016fc:	c7 05 80 10 11 00 00 	movl   $0x0,0x111080
  101703:	00 00 00 
        }
        return c;
  101706:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101709:	eb 05                	jmp    101710 <cons_getc+0x5e>
    }
    return 0;
  10170b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  101710:	c9                   	leave  
  101711:	c3                   	ret    

00101712 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101712:	f3 0f 1e fb          	endbr32 
  101716:	55                   	push   %ebp
  101717:	89 e5                	mov    %esp,%ebp
  101719:	83 ec 14             	sub    $0x14,%esp
  10171c:	8b 45 08             	mov    0x8(%ebp),%eax
  10171f:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101723:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101726:	66 a3 50 05 11 00    	mov    %ax,0x110550
    if (did_init) {
  10172c:	a1 8c 10 11 00       	mov    0x11108c,%eax
  101731:	85 c0                	test   %eax,%eax
  101733:	74 39                	je     10176e <pic_setmask+0x5c>
        outb(IO_PIC1 + 1, mask);
  101735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101738:	0f b6 c0             	movzbl %al,%eax
  10173b:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101741:	88 45 f9             	mov    %al,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101744:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101748:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10174c:	ee                   	out    %al,(%dx)
}
  10174d:	90                   	nop
        outb(IO_PIC2 + 1, mask >> 8);
  10174e:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101752:	c1 e8 08             	shr    $0x8,%eax
  101755:	0f b7 c0             	movzwl %ax,%eax
  101758:	0f b6 c0             	movzbl %al,%eax
  10175b:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101761:	88 45 fd             	mov    %al,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101764:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101768:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10176c:	ee                   	out    %al,(%dx)
}
  10176d:	90                   	nop
    }
}
  10176e:	90                   	nop
  10176f:	c9                   	leave  
  101770:	c3                   	ret    

00101771 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101771:	f3 0f 1e fb          	endbr32 
  101775:	55                   	push   %ebp
  101776:	89 e5                	mov    %esp,%ebp
  101778:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10177b:	8b 45 08             	mov    0x8(%ebp),%eax
  10177e:	ba 01 00 00 00       	mov    $0x1,%edx
  101783:	88 c1                	mov    %al,%cl
  101785:	d3 e2                	shl    %cl,%edx
  101787:	89 d0                	mov    %edx,%eax
  101789:	98                   	cwtl   
  10178a:	f7 d0                	not    %eax
  10178c:	0f bf d0             	movswl %ax,%edx
  10178f:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  101796:	98                   	cwtl   
  101797:	21 d0                	and    %edx,%eax
  101799:	98                   	cwtl   
  10179a:	0f b7 c0             	movzwl %ax,%eax
  10179d:	89 04 24             	mov    %eax,(%esp)
  1017a0:	e8 6d ff ff ff       	call   101712 <pic_setmask>
}
  1017a5:	90                   	nop
  1017a6:	c9                   	leave  
  1017a7:	c3                   	ret    

001017a8 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017a8:	f3 0f 1e fb          	endbr32 
  1017ac:	55                   	push   %ebp
  1017ad:	89 e5                	mov    %esp,%ebp
  1017af:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017b2:	c7 05 8c 10 11 00 01 	movl   $0x1,0x11108c
  1017b9:	00 00 00 
  1017bc:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1017c2:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017c6:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017ca:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017ce:	ee                   	out    %al,(%dx)
}
  1017cf:	90                   	nop
  1017d0:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1017d6:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017da:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017de:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017e2:	ee                   	out    %al,(%dx)
}
  1017e3:	90                   	nop
  1017e4:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017ea:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1017ee:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017f2:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017f6:	ee                   	out    %al,(%dx)
}
  1017f7:	90                   	nop
  1017f8:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1017fe:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101802:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101806:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10180a:	ee                   	out    %al,(%dx)
}
  10180b:	90                   	nop
  10180c:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101812:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101816:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10181a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10181e:	ee                   	out    %al,(%dx)
}
  10181f:	90                   	nop
  101820:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  101826:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10182a:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  10182e:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101832:	ee                   	out    %al,(%dx)
}
  101833:	90                   	nop
  101834:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  10183a:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10183e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101842:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101846:	ee                   	out    %al,(%dx)
}
  101847:	90                   	nop
  101848:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  10184e:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101852:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101856:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10185a:	ee                   	out    %al,(%dx)
}
  10185b:	90                   	nop
  10185c:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101862:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101866:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10186a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10186e:	ee                   	out    %al,(%dx)
}
  10186f:	90                   	nop
  101870:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101876:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10187a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10187e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101882:	ee                   	out    %al,(%dx)
}
  101883:	90                   	nop
  101884:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10188a:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10188e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101892:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101896:	ee                   	out    %al,(%dx)
}
  101897:	90                   	nop
  101898:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10189e:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018a2:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1018a6:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1018aa:	ee                   	out    %al,(%dx)
}
  1018ab:	90                   	nop
  1018ac:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  1018b2:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018b6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1018ba:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1018be:	ee                   	out    %al,(%dx)
}
  1018bf:	90                   	nop
  1018c0:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1018c6:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1018ca:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1018ce:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1018d2:	ee                   	out    %al,(%dx)
}
  1018d3:	90                   	nop
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018d4:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018db:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1018e0:	74 0f                	je     1018f1 <pic_init+0x149>
        pic_setmask(irq_mask);
  1018e2:	0f b7 05 50 05 11 00 	movzwl 0x110550,%eax
  1018e9:	89 04 24             	mov    %eax,(%esp)
  1018ec:	e8 21 fe ff ff       	call   101712 <pic_setmask>
    }
}
  1018f1:	90                   	nop
  1018f2:	c9                   	leave  
  1018f3:	c3                   	ret    

001018f4 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1018f4:	f3 0f 1e fb          	endbr32 
  1018f8:	55                   	push   %ebp
  1018f9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1018fb:	fb                   	sti    
}
  1018fc:	90                   	nop
    sti();
}
  1018fd:	90                   	nop
  1018fe:	5d                   	pop    %ebp
  1018ff:	c3                   	ret    

00101900 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101900:	f3 0f 1e fb          	endbr32 
  101904:	55                   	push   %ebp
  101905:	89 e5                	mov    %esp,%ebp

static inline void
cli(void) {
    asm volatile ("cli");
  101907:	fa                   	cli    
}
  101908:	90                   	nop
    cli();
}
  101909:	90                   	nop
  10190a:	5d                   	pop    %ebp
  10190b:	c3                   	ret    

0010190c <print_ticks>:
#include <console.h>
#include <kdebug.h>
#include <string.h>
#define TICK_NUM 100

static void print_ticks() {
  10190c:	f3 0f 1e fb          	endbr32 
  101910:	55                   	push   %ebp
  101911:	89 e5                	mov    %esp,%ebp
  101913:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101916:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  10191d:	00 
  10191e:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101925:	e8 6a e9 ff ff       	call   100294 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  10192a:	90                   	nop
  10192b:	c9                   	leave  
  10192c:	c3                   	ret    

0010192d <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  10192d:	f3 0f 1e fb          	endbr32 
  101931:	55                   	push   %ebp
  101932:	89 e5                	mov    %esp,%ebp
  101934:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101937:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10193e:	e9 c4 00 00 00       	jmp    101a07 <idt_init+0xda>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101943:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101946:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  10194d:	0f b7 d0             	movzwl %ax,%edx
  101950:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101953:	66 89 14 c5 a0 10 11 	mov    %dx,0x1110a0(,%eax,8)
  10195a:	00 
  10195b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195e:	66 c7 04 c5 a2 10 11 	movw   $0x8,0x1110a2(,%eax,8)
  101965:	00 08 00 
  101968:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10196b:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101972:	00 
  101973:	80 e2 e0             	and    $0xe0,%dl
  101976:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  10197d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101980:	0f b6 14 c5 a4 10 11 	movzbl 0x1110a4(,%eax,8),%edx
  101987:	00 
  101988:	80 e2 1f             	and    $0x1f,%dl
  10198b:	88 14 c5 a4 10 11 00 	mov    %dl,0x1110a4(,%eax,8)
  101992:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101995:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  10199c:	00 
  10199d:	80 e2 f0             	and    $0xf0,%dl
  1019a0:	80 ca 0e             	or     $0xe,%dl
  1019a3:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ad:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019b4:	00 
  1019b5:	80 e2 ef             	and    $0xef,%dl
  1019b8:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c2:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019c9:	00 
  1019ca:	80 e2 9f             	and    $0x9f,%dl
  1019cd:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019d7:	0f b6 14 c5 a5 10 11 	movzbl 0x1110a5(,%eax,8),%edx
  1019de:	00 
  1019df:	80 ca 80             	or     $0x80,%dl
  1019e2:	88 14 c5 a5 10 11 00 	mov    %dl,0x1110a5(,%eax,8)
  1019e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ec:	8b 04 85 e0 05 11 00 	mov    0x1105e0(,%eax,4),%eax
  1019f3:	c1 e8 10             	shr    $0x10,%eax
  1019f6:	0f b7 d0             	movzwl %ax,%edx
  1019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fc:	66 89 14 c5 a6 10 11 	mov    %dx,0x1110a6(,%eax,8)
  101a03:	00 
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  101a04:	ff 45 fc             	incl   -0x4(%ebp)
  101a07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101a0a:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a0f:	0f 86 2e ff ff ff    	jbe    101943 <idt_init+0x16>
    }
	// set for switch from user to kernel
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a15:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a1a:	0f b7 c0             	movzwl %ax,%eax
  101a1d:	66 a3 68 14 11 00    	mov    %ax,0x111468
  101a23:	66 c7 05 6a 14 11 00 	movw   $0x8,0x11146a
  101a2a:	08 00 
  101a2c:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a33:	24 e0                	and    $0xe0,%al
  101a35:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a3a:	0f b6 05 6c 14 11 00 	movzbl 0x11146c,%eax
  101a41:	24 1f                	and    $0x1f,%al
  101a43:	a2 6c 14 11 00       	mov    %al,0x11146c
  101a48:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a4f:	24 f0                	and    $0xf0,%al
  101a51:	0c 0e                	or     $0xe,%al
  101a53:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a58:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a5f:	24 ef                	and    $0xef,%al
  101a61:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a66:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a6d:	0c 60                	or     $0x60,%al
  101a6f:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a74:	0f b6 05 6d 14 11 00 	movzbl 0x11146d,%eax
  101a7b:	0c 80                	or     $0x80,%al
  101a7d:	a2 6d 14 11 00       	mov    %al,0x11146d
  101a82:	a1 c4 07 11 00       	mov    0x1107c4,%eax
  101a87:	c1 e8 10             	shr    $0x10,%eax
  101a8a:	0f b7 c0             	movzwl %ax,%eax
  101a8d:	66 a3 6e 14 11 00    	mov    %ax,0x11146e
  101a93:	c7 45 f8 60 05 11 00 	movl   $0x110560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a9d:	0f 01 18             	lidtl  (%eax)
}
  101aa0:	90                   	nop
	// load the IDT
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
  101ab6:	8b 04 85 40 3e 10 00 	mov    0x103e40(,%eax,4),%eax
  101abd:	eb 18                	jmp    101ad7 <trapname+0x33>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101abf:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ac3:	7e 0d                	jle    101ad2 <trapname+0x2e>
  101ac5:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ac9:	7f 07                	jg     101ad2 <trapname+0x2e>
        return "Hardware Interrupt";
  101acb:	b8 ea 3a 10 00       	mov    $0x103aea,%eax
  101ad0:	eb 05                	jmp    101ad7 <trapname+0x33>
    }
    return "(unknown trap)";
  101ad2:	b8 fd 3a 10 00       	mov    $0x103afd,%eax
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
  101b03:	c7 04 24 3e 3b 10 00 	movl   $0x103b3e,(%esp)
  101b0a:	e8 85 e7 ff ff       	call   100294 <cprintf>
    print_regs(&tf->tf_regs);
  101b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b12:	89 04 24             	mov    %eax,(%esp)
  101b15:	e8 8d 01 00 00       	call   101ca7 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1d:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b25:	c7 04 24 4f 3b 10 00 	movl   $0x103b4f,(%esp)
  101b2c:	e8 63 e7 ff ff       	call   100294 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b31:	8b 45 08             	mov    0x8(%ebp),%eax
  101b34:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 62 3b 10 00 	movl   $0x103b62,(%esp)
  101b43:	e8 4c e7 ff ff       	call   100294 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b53:	c7 04 24 75 3b 10 00 	movl   $0x103b75,(%esp)
  101b5a:	e8 35 e7 ff ff       	call   100294 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101b62:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b6a:	c7 04 24 88 3b 10 00 	movl   $0x103b88,(%esp)
  101b71:	e8 1e e7 ff ff       	call   100294 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b76:	8b 45 08             	mov    0x8(%ebp),%eax
  101b79:	8b 40 30             	mov    0x30(%eax),%eax
  101b7c:	89 04 24             	mov    %eax,(%esp)
  101b7f:	e8 20 ff ff ff       	call   101aa4 <trapname>
  101b84:	8b 55 08             	mov    0x8(%ebp),%edx
  101b87:	8b 52 30             	mov    0x30(%edx),%edx
  101b8a:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b92:	c7 04 24 9b 3b 10 00 	movl   $0x103b9b,(%esp)
  101b99:	e8 f6 e6 ff ff       	call   100294 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba1:	8b 40 34             	mov    0x34(%eax),%eax
  101ba4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ba8:	c7 04 24 ad 3b 10 00 	movl   $0x103bad,(%esp)
  101baf:	e8 e0 e6 ff ff       	call   100294 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 40 38             	mov    0x38(%eax),%eax
  101bba:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbe:	c7 04 24 bc 3b 10 00 	movl   $0x103bbc,(%esp)
  101bc5:	e8 ca e6 ff ff       	call   100294 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bca:	8b 45 08             	mov    0x8(%ebp),%eax
  101bcd:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bd1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bd5:	c7 04 24 cb 3b 10 00 	movl   $0x103bcb,(%esp)
  101bdc:	e8 b3 e6 ff ff       	call   100294 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 40             	mov    0x40(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 de 3b 10 00 	movl   $0x103bde,(%esp)
  101bf2:	e8 9d e6 ff ff       	call   100294 <cprintf>

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
  101c19:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c20:	85 c0                	test   %eax,%eax
  101c22:	74 1a                	je     101c3e <print_trapframe+0x14c>
            cprintf("%s,", IA32flags[i]);
  101c24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c27:	8b 04 85 80 05 11 00 	mov    0x110580(,%eax,4),%eax
  101c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c32:	c7 04 24 ed 3b 10 00 	movl   $0x103bed,(%esp)
  101c39:	e8 56 e6 ff ff       	call   100294 <cprintf>
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
  101c5c:	c7 04 24 f1 3b 10 00 	movl   $0x103bf1,(%esp)
  101c63:	e8 2c e6 ff ff       	call   100294 <cprintf>

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
  101c81:	c7 04 24 fa 3b 10 00 	movl   $0x103bfa,(%esp)
  101c88:	e8 07 e6 ff ff       	call   100294 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c8d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c90:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c98:	c7 04 24 09 3c 10 00 	movl   $0x103c09,(%esp)
  101c9f:	e8 f0 e5 ff ff       	call   100294 <cprintf>
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
  101cba:	c7 04 24 1c 3c 10 00 	movl   $0x103c1c,(%esp)
  101cc1:	e8 ce e5 ff ff       	call   100294 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cc9:	8b 40 04             	mov    0x4(%eax),%eax
  101ccc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd0:	c7 04 24 2b 3c 10 00 	movl   $0x103c2b,(%esp)
  101cd7:	e8 b8 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cdf:	8b 40 08             	mov    0x8(%eax),%eax
  101ce2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ce6:	c7 04 24 3a 3c 10 00 	movl   $0x103c3a,(%esp)
  101ced:	e8 a2 e5 ff ff       	call   100294 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  101cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfc:	c7 04 24 49 3c 10 00 	movl   $0x103c49,(%esp)
  101d03:	e8 8c e5 ff ff       	call   100294 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101d08:	8b 45 08             	mov    0x8(%ebp),%eax
  101d0b:	8b 40 10             	mov    0x10(%eax),%eax
  101d0e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d12:	c7 04 24 58 3c 10 00 	movl   $0x103c58,(%esp)
  101d19:	e8 76 e5 ff ff       	call   100294 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d21:	8b 40 14             	mov    0x14(%eax),%eax
  101d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d28:	c7 04 24 67 3c 10 00 	movl   $0x103c67,(%esp)
  101d2f:	e8 60 e5 ff ff       	call   100294 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d34:	8b 45 08             	mov    0x8(%ebp),%eax
  101d37:	8b 40 18             	mov    0x18(%eax),%eax
  101d3a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d3e:	c7 04 24 76 3c 10 00 	movl   $0x103c76,(%esp)
  101d45:	e8 4a e5 ff ff       	call   100294 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d4d:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d54:	c7 04 24 85 3c 10 00 	movl   $0x103c85,(%esp)
  101d5b:	e8 34 e5 ff ff       	call   100294 <cprintf>
}
  101d60:	90                   	nop
  101d61:	c9                   	leave  
  101d62:	c3                   	ret    

00101d63 <trap_dispatch>:
/* temporary trapframe or pointer to trapframe */
struct trapframe switchk2u, *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d63:	f3 0f 1e fb          	endbr32 
  101d67:	55                   	push   %ebp
  101d68:	89 e5                	mov    %esp,%ebp
  101d6a:	57                   	push   %edi
  101d6b:	56                   	push   %esi
  101d6c:	53                   	push   %ebx
  101d6d:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101d70:	8b 45 08             	mov    0x8(%ebp),%eax
  101d73:	8b 40 30             	mov    0x30(%eax),%eax
  101d76:	83 f8 79             	cmp    $0x79,%eax
  101d79:	0f 84 c6 01 00 00    	je     101f45 <trap_dispatch+0x1e2>
  101d7f:	83 f8 79             	cmp    $0x79,%eax
  101d82:	0f 87 3a 02 00 00    	ja     101fc2 <trap_dispatch+0x25f>
  101d88:	83 f8 78             	cmp    $0x78,%eax
  101d8b:	0f 84 d0 00 00 00    	je     101e61 <trap_dispatch+0xfe>
  101d91:	83 f8 78             	cmp    $0x78,%eax
  101d94:	0f 87 28 02 00 00    	ja     101fc2 <trap_dispatch+0x25f>
  101d9a:	83 f8 2f             	cmp    $0x2f,%eax
  101d9d:	0f 87 1f 02 00 00    	ja     101fc2 <trap_dispatch+0x25f>
  101da3:	83 f8 2e             	cmp    $0x2e,%eax
  101da6:	0f 83 4b 02 00 00    	jae    101ff7 <trap_dispatch+0x294>
  101dac:	83 f8 24             	cmp    $0x24,%eax
  101daf:	74 5e                	je     101e0f <trap_dispatch+0xac>
  101db1:	83 f8 24             	cmp    $0x24,%eax
  101db4:	0f 87 08 02 00 00    	ja     101fc2 <trap_dispatch+0x25f>
  101dba:	83 f8 20             	cmp    $0x20,%eax
  101dbd:	74 0a                	je     101dc9 <trap_dispatch+0x66>
  101dbf:	83 f8 21             	cmp    $0x21,%eax
  101dc2:	74 74                	je     101e38 <trap_dispatch+0xd5>
  101dc4:	e9 f9 01 00 00       	jmp    101fc2 <trap_dispatch+0x25f>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101dc9:	a1 08 19 11 00       	mov    0x111908,%eax
  101dce:	40                   	inc    %eax
  101dcf:	a3 08 19 11 00       	mov    %eax,0x111908
        if (ticks % TICK_NUM == 0) {
  101dd4:	8b 0d 08 19 11 00    	mov    0x111908,%ecx
  101dda:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101ddf:	89 c8                	mov    %ecx,%eax
  101de1:	f7 e2                	mul    %edx
  101de3:	c1 ea 05             	shr    $0x5,%edx
  101de6:	89 d0                	mov    %edx,%eax
  101de8:	c1 e0 02             	shl    $0x2,%eax
  101deb:	01 d0                	add    %edx,%eax
  101ded:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101df4:	01 d0                	add    %edx,%eax
  101df6:	c1 e0 02             	shl    $0x2,%eax
  101df9:	29 c1                	sub    %eax,%ecx
  101dfb:	89 ca                	mov    %ecx,%edx
  101dfd:	85 d2                	test   %edx,%edx
  101dff:	0f 85 f5 01 00 00    	jne    101ffa <trap_dispatch+0x297>
            print_ticks();
  101e05:	e8 02 fb ff ff       	call   10190c <print_ticks>
        }
        break;
  101e0a:	e9 eb 01 00 00       	jmp    101ffa <trap_dispatch+0x297>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101e0f:	e8 9e f8 ff ff       	call   1016b2 <cons_getc>
  101e14:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101e17:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e1b:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e1f:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e27:	c7 04 24 94 3c 10 00 	movl   $0x103c94,(%esp)
  101e2e:	e8 61 e4 ff ff       	call   100294 <cprintf>
        break;
  101e33:	e9 c9 01 00 00       	jmp    102001 <trap_dispatch+0x29e>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101e38:	e8 75 f8 ff ff       	call   1016b2 <cons_getc>
  101e3d:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e40:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101e44:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101e48:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e50:	c7 04 24 a6 3c 10 00 	movl   $0x103ca6,(%esp)
  101e57:	e8 38 e4 ff ff       	call   100294 <cprintf>
        break;
  101e5c:	e9 a0 01 00 00       	jmp    102001 <trap_dispatch+0x29e>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if (tf->tf_cs != USER_CS) {
  101e61:	8b 45 08             	mov    0x8(%ebp),%eax
  101e64:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e68:	83 f8 1b             	cmp    $0x1b,%eax
  101e6b:	0f 84 8c 01 00 00    	je     101ffd <trap_dispatch+0x29a>
            switchk2u = *tf;
  101e71:	8b 55 08             	mov    0x8(%ebp),%edx
  101e74:	b8 20 19 11 00       	mov    $0x111920,%eax
  101e79:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101e7e:	89 c1                	mov    %eax,%ecx
  101e80:	83 e1 01             	and    $0x1,%ecx
  101e83:	85 c9                	test   %ecx,%ecx
  101e85:	74 0c                	je     101e93 <trap_dispatch+0x130>
  101e87:	0f b6 0a             	movzbl (%edx),%ecx
  101e8a:	88 08                	mov    %cl,(%eax)
  101e8c:	8d 40 01             	lea    0x1(%eax),%eax
  101e8f:	8d 52 01             	lea    0x1(%edx),%edx
  101e92:	4b                   	dec    %ebx
  101e93:	89 c1                	mov    %eax,%ecx
  101e95:	83 e1 02             	and    $0x2,%ecx
  101e98:	85 c9                	test   %ecx,%ecx
  101e9a:	74 0f                	je     101eab <trap_dispatch+0x148>
  101e9c:	0f b7 0a             	movzwl (%edx),%ecx
  101e9f:	66 89 08             	mov    %cx,(%eax)
  101ea2:	8d 40 02             	lea    0x2(%eax),%eax
  101ea5:	8d 52 02             	lea    0x2(%edx),%edx
  101ea8:	83 eb 02             	sub    $0x2,%ebx
  101eab:	89 df                	mov    %ebx,%edi
  101ead:	83 e7 fc             	and    $0xfffffffc,%edi
  101eb0:	b9 00 00 00 00       	mov    $0x0,%ecx
  101eb5:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101eb8:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101ebb:	83 c1 04             	add    $0x4,%ecx
  101ebe:	39 f9                	cmp    %edi,%ecx
  101ec0:	72 f3                	jb     101eb5 <trap_dispatch+0x152>
  101ec2:	01 c8                	add    %ecx,%eax
  101ec4:	01 ca                	add    %ecx,%edx
  101ec6:	b9 00 00 00 00       	mov    $0x0,%ecx
  101ecb:	89 de                	mov    %ebx,%esi
  101ecd:	83 e6 02             	and    $0x2,%esi
  101ed0:	85 f6                	test   %esi,%esi
  101ed2:	74 0b                	je     101edf <trap_dispatch+0x17c>
  101ed4:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101ed8:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101edc:	83 c1 02             	add    $0x2,%ecx
  101edf:	83 e3 01             	and    $0x1,%ebx
  101ee2:	85 db                	test   %ebx,%ebx
  101ee4:	74 07                	je     101eed <trap_dispatch+0x18a>
  101ee6:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101eea:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            switchk2u.tf_cs = USER_CS;
  101eed:	66 c7 05 5c 19 11 00 	movw   $0x1b,0x11195c
  101ef4:	1b 00 
            switchk2u.tf_ds = switchk2u.tf_es = switchk2u.tf_ss = USER_DS;
  101ef6:	66 c7 05 68 19 11 00 	movw   $0x23,0x111968
  101efd:	23 00 
  101eff:	0f b7 05 68 19 11 00 	movzwl 0x111968,%eax
  101f06:	66 a3 48 19 11 00    	mov    %ax,0x111948
  101f0c:	0f b7 05 48 19 11 00 	movzwl 0x111948,%eax
  101f13:	66 a3 4c 19 11 00    	mov    %ax,0x11194c
            switchk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8;
  101f19:	8b 45 08             	mov    0x8(%ebp),%eax
  101f1c:	83 c0 44             	add    $0x44,%eax
  101f1f:	a3 64 19 11 00       	mov    %eax,0x111964
		
            // set eflags, make sure ucore can use io under user mode.
            // if CPL > IOPL, then cpu will generate a general protection.
            switchk2u.tf_eflags |= FL_IOPL_MASK;
  101f24:	a1 60 19 11 00       	mov    0x111960,%eax
  101f29:	0d 00 30 00 00       	or     $0x3000,%eax
  101f2e:	a3 60 19 11 00       	mov    %eax,0x111960
		
            // set temporary stack
            // then iret will jump to the right stack
            *((uint32_t *)tf - 1) = (uint32_t)&switchk2u;
  101f33:	8b 45 08             	mov    0x8(%ebp),%eax
  101f36:	83 e8 04             	sub    $0x4,%eax
  101f39:	ba 20 19 11 00       	mov    $0x111920,%edx
  101f3e:	89 10                	mov    %edx,(%eax)
        }
        break;
  101f40:	e9 b8 00 00 00       	jmp    101ffd <trap_dispatch+0x29a>
    case T_SWITCH_TOK:
        if (tf->tf_cs != KERNEL_CS) {
  101f45:	8b 45 08             	mov    0x8(%ebp),%eax
  101f48:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f4c:	83 f8 08             	cmp    $0x8,%eax
  101f4f:	0f 84 ab 00 00 00    	je     102000 <trap_dispatch+0x29d>
            tf->tf_cs = KERNEL_CS;
  101f55:	8b 45 08             	mov    0x8(%ebp),%eax
  101f58:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101f5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f61:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101f67:	8b 45 08             	mov    0x8(%ebp),%eax
  101f6a:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101f71:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101f75:	8b 45 08             	mov    0x8(%ebp),%eax
  101f78:	8b 40 40             	mov    0x40(%eax),%eax
  101f7b:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101f80:	89 c2                	mov    %eax,%edx
  101f82:	8b 45 08             	mov    0x8(%ebp),%eax
  101f85:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)(tf->tf_esp - (sizeof(struct trapframe) - 8));
  101f88:	8b 45 08             	mov    0x8(%ebp),%eax
  101f8b:	8b 40 44             	mov    0x44(%eax),%eax
  101f8e:	83 e8 44             	sub    $0x44,%eax
  101f91:	a3 6c 19 11 00       	mov    %eax,0x11196c
            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101f96:	a1 6c 19 11 00       	mov    0x11196c,%eax
  101f9b:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101fa2:	00 
  101fa3:	8b 55 08             	mov    0x8(%ebp),%edx
  101fa6:	89 54 24 04          	mov    %edx,0x4(%esp)
  101faa:	89 04 24             	mov    %eax,(%esp)
  101fad:	e8 cc 0f 00 00       	call   102f7e <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101fb2:	8b 15 6c 19 11 00    	mov    0x11196c,%edx
  101fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101fbb:	83 e8 04             	sub    $0x4,%eax
  101fbe:	89 10                	mov    %edx,(%eax)
        }
        break;
  101fc0:	eb 3e                	jmp    102000 <trap_dispatch+0x29d>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  101fc5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101fc9:	83 e0 03             	and    $0x3,%eax
  101fcc:	85 c0                	test   %eax,%eax
  101fce:	75 31                	jne    102001 <trap_dispatch+0x29e>
            print_trapframe(tf);
  101fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101fd3:	89 04 24             	mov    %eax,(%esp)
  101fd6:	e8 17 fb ff ff       	call   101af2 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101fdb:	c7 44 24 08 b5 3c 10 	movl   $0x103cb5,0x8(%esp)
  101fe2:	00 
  101fe3:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  101fea:	00 
  101feb:	c7 04 24 d1 3c 10 00 	movl   $0x103cd1,(%esp)
  101ff2:	e8 09 e4 ff ff       	call   100400 <__panic>
        break;
  101ff7:	90                   	nop
  101ff8:	eb 07                	jmp    102001 <trap_dispatch+0x29e>
        break;
  101ffa:	90                   	nop
  101ffb:	eb 04                	jmp    102001 <trap_dispatch+0x29e>
        break;
  101ffd:	90                   	nop
  101ffe:	eb 01                	jmp    102001 <trap_dispatch+0x29e>
        break;
  102000:	90                   	nop
        }
    }
}
  102001:	90                   	nop
  102002:	83 c4 2c             	add    $0x2c,%esp
  102005:	5b                   	pop    %ebx
  102006:	5e                   	pop    %esi
  102007:	5f                   	pop    %edi
  102008:	5d                   	pop    %ebp
  102009:	c3                   	ret    

0010200a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  10200a:	f3 0f 1e fb          	endbr32 
  10200e:	55                   	push   %ebp
  10200f:	89 e5                	mov    %esp,%ebp
  102011:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  102014:	8b 45 08             	mov    0x8(%ebp),%eax
  102017:	89 04 24             	mov    %eax,(%esp)
  10201a:	e8 44 fd ff ff       	call   101d63 <trap_dispatch>
}
  10201f:	90                   	nop
  102020:	c9                   	leave  
  102021:	c3                   	ret    

00102022 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $0
  102024:	6a 00                	push   $0x0
  jmp __alltraps
  102026:	e9 69 0a 00 00       	jmp    102a94 <__alltraps>

0010202b <vector1>:
.globl vector1
vector1:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $1
  10202d:	6a 01                	push   $0x1
  jmp __alltraps
  10202f:	e9 60 0a 00 00       	jmp    102a94 <__alltraps>

00102034 <vector2>:
.globl vector2
vector2:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $2
  102036:	6a 02                	push   $0x2
  jmp __alltraps
  102038:	e9 57 0a 00 00       	jmp    102a94 <__alltraps>

0010203d <vector3>:
.globl vector3
vector3:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $3
  10203f:	6a 03                	push   $0x3
  jmp __alltraps
  102041:	e9 4e 0a 00 00       	jmp    102a94 <__alltraps>

00102046 <vector4>:
.globl vector4
vector4:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $4
  102048:	6a 04                	push   $0x4
  jmp __alltraps
  10204a:	e9 45 0a 00 00       	jmp    102a94 <__alltraps>

0010204f <vector5>:
.globl vector5
vector5:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $5
  102051:	6a 05                	push   $0x5
  jmp __alltraps
  102053:	e9 3c 0a 00 00       	jmp    102a94 <__alltraps>

00102058 <vector6>:
.globl vector6
vector6:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $6
  10205a:	6a 06                	push   $0x6
  jmp __alltraps
  10205c:	e9 33 0a 00 00       	jmp    102a94 <__alltraps>

00102061 <vector7>:
.globl vector7
vector7:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $7
  102063:	6a 07                	push   $0x7
  jmp __alltraps
  102065:	e9 2a 0a 00 00       	jmp    102a94 <__alltraps>

0010206a <vector8>:
.globl vector8
vector8:
  pushl $8
  10206a:	6a 08                	push   $0x8
  jmp __alltraps
  10206c:	e9 23 0a 00 00       	jmp    102a94 <__alltraps>

00102071 <vector9>:
.globl vector9
vector9:
  pushl $0
  102071:	6a 00                	push   $0x0
  pushl $9
  102073:	6a 09                	push   $0x9
  jmp __alltraps
  102075:	e9 1a 0a 00 00       	jmp    102a94 <__alltraps>

0010207a <vector10>:
.globl vector10
vector10:
  pushl $10
  10207a:	6a 0a                	push   $0xa
  jmp __alltraps
  10207c:	e9 13 0a 00 00       	jmp    102a94 <__alltraps>

00102081 <vector11>:
.globl vector11
vector11:
  pushl $11
  102081:	6a 0b                	push   $0xb
  jmp __alltraps
  102083:	e9 0c 0a 00 00       	jmp    102a94 <__alltraps>

00102088 <vector12>:
.globl vector12
vector12:
  pushl $12
  102088:	6a 0c                	push   $0xc
  jmp __alltraps
  10208a:	e9 05 0a 00 00       	jmp    102a94 <__alltraps>

0010208f <vector13>:
.globl vector13
vector13:
  pushl $13
  10208f:	6a 0d                	push   $0xd
  jmp __alltraps
  102091:	e9 fe 09 00 00       	jmp    102a94 <__alltraps>

00102096 <vector14>:
.globl vector14
vector14:
  pushl $14
  102096:	6a 0e                	push   $0xe
  jmp __alltraps
  102098:	e9 f7 09 00 00       	jmp    102a94 <__alltraps>

0010209d <vector15>:
.globl vector15
vector15:
  pushl $0
  10209d:	6a 00                	push   $0x0
  pushl $15
  10209f:	6a 0f                	push   $0xf
  jmp __alltraps
  1020a1:	e9 ee 09 00 00       	jmp    102a94 <__alltraps>

001020a6 <vector16>:
.globl vector16
vector16:
  pushl $0
  1020a6:	6a 00                	push   $0x0
  pushl $16
  1020a8:	6a 10                	push   $0x10
  jmp __alltraps
  1020aa:	e9 e5 09 00 00       	jmp    102a94 <__alltraps>

001020af <vector17>:
.globl vector17
vector17:
  pushl $17
  1020af:	6a 11                	push   $0x11
  jmp __alltraps
  1020b1:	e9 de 09 00 00       	jmp    102a94 <__alltraps>

001020b6 <vector18>:
.globl vector18
vector18:
  pushl $0
  1020b6:	6a 00                	push   $0x0
  pushl $18
  1020b8:	6a 12                	push   $0x12
  jmp __alltraps
  1020ba:	e9 d5 09 00 00       	jmp    102a94 <__alltraps>

001020bf <vector19>:
.globl vector19
vector19:
  pushl $0
  1020bf:	6a 00                	push   $0x0
  pushl $19
  1020c1:	6a 13                	push   $0x13
  jmp __alltraps
  1020c3:	e9 cc 09 00 00       	jmp    102a94 <__alltraps>

001020c8 <vector20>:
.globl vector20
vector20:
  pushl $0
  1020c8:	6a 00                	push   $0x0
  pushl $20
  1020ca:	6a 14                	push   $0x14
  jmp __alltraps
  1020cc:	e9 c3 09 00 00       	jmp    102a94 <__alltraps>

001020d1 <vector21>:
.globl vector21
vector21:
  pushl $0
  1020d1:	6a 00                	push   $0x0
  pushl $21
  1020d3:	6a 15                	push   $0x15
  jmp __alltraps
  1020d5:	e9 ba 09 00 00       	jmp    102a94 <__alltraps>

001020da <vector22>:
.globl vector22
vector22:
  pushl $0
  1020da:	6a 00                	push   $0x0
  pushl $22
  1020dc:	6a 16                	push   $0x16
  jmp __alltraps
  1020de:	e9 b1 09 00 00       	jmp    102a94 <__alltraps>

001020e3 <vector23>:
.globl vector23
vector23:
  pushl $0
  1020e3:	6a 00                	push   $0x0
  pushl $23
  1020e5:	6a 17                	push   $0x17
  jmp __alltraps
  1020e7:	e9 a8 09 00 00       	jmp    102a94 <__alltraps>

001020ec <vector24>:
.globl vector24
vector24:
  pushl $0
  1020ec:	6a 00                	push   $0x0
  pushl $24
  1020ee:	6a 18                	push   $0x18
  jmp __alltraps
  1020f0:	e9 9f 09 00 00       	jmp    102a94 <__alltraps>

001020f5 <vector25>:
.globl vector25
vector25:
  pushl $0
  1020f5:	6a 00                	push   $0x0
  pushl $25
  1020f7:	6a 19                	push   $0x19
  jmp __alltraps
  1020f9:	e9 96 09 00 00       	jmp    102a94 <__alltraps>

001020fe <vector26>:
.globl vector26
vector26:
  pushl $0
  1020fe:	6a 00                	push   $0x0
  pushl $26
  102100:	6a 1a                	push   $0x1a
  jmp __alltraps
  102102:	e9 8d 09 00 00       	jmp    102a94 <__alltraps>

00102107 <vector27>:
.globl vector27
vector27:
  pushl $0
  102107:	6a 00                	push   $0x0
  pushl $27
  102109:	6a 1b                	push   $0x1b
  jmp __alltraps
  10210b:	e9 84 09 00 00       	jmp    102a94 <__alltraps>

00102110 <vector28>:
.globl vector28
vector28:
  pushl $0
  102110:	6a 00                	push   $0x0
  pushl $28
  102112:	6a 1c                	push   $0x1c
  jmp __alltraps
  102114:	e9 7b 09 00 00       	jmp    102a94 <__alltraps>

00102119 <vector29>:
.globl vector29
vector29:
  pushl $0
  102119:	6a 00                	push   $0x0
  pushl $29
  10211b:	6a 1d                	push   $0x1d
  jmp __alltraps
  10211d:	e9 72 09 00 00       	jmp    102a94 <__alltraps>

00102122 <vector30>:
.globl vector30
vector30:
  pushl $0
  102122:	6a 00                	push   $0x0
  pushl $30
  102124:	6a 1e                	push   $0x1e
  jmp __alltraps
  102126:	e9 69 09 00 00       	jmp    102a94 <__alltraps>

0010212b <vector31>:
.globl vector31
vector31:
  pushl $0
  10212b:	6a 00                	push   $0x0
  pushl $31
  10212d:	6a 1f                	push   $0x1f
  jmp __alltraps
  10212f:	e9 60 09 00 00       	jmp    102a94 <__alltraps>

00102134 <vector32>:
.globl vector32
vector32:
  pushl $0
  102134:	6a 00                	push   $0x0
  pushl $32
  102136:	6a 20                	push   $0x20
  jmp __alltraps
  102138:	e9 57 09 00 00       	jmp    102a94 <__alltraps>

0010213d <vector33>:
.globl vector33
vector33:
  pushl $0
  10213d:	6a 00                	push   $0x0
  pushl $33
  10213f:	6a 21                	push   $0x21
  jmp __alltraps
  102141:	e9 4e 09 00 00       	jmp    102a94 <__alltraps>

00102146 <vector34>:
.globl vector34
vector34:
  pushl $0
  102146:	6a 00                	push   $0x0
  pushl $34
  102148:	6a 22                	push   $0x22
  jmp __alltraps
  10214a:	e9 45 09 00 00       	jmp    102a94 <__alltraps>

0010214f <vector35>:
.globl vector35
vector35:
  pushl $0
  10214f:	6a 00                	push   $0x0
  pushl $35
  102151:	6a 23                	push   $0x23
  jmp __alltraps
  102153:	e9 3c 09 00 00       	jmp    102a94 <__alltraps>

00102158 <vector36>:
.globl vector36
vector36:
  pushl $0
  102158:	6a 00                	push   $0x0
  pushl $36
  10215a:	6a 24                	push   $0x24
  jmp __alltraps
  10215c:	e9 33 09 00 00       	jmp    102a94 <__alltraps>

00102161 <vector37>:
.globl vector37
vector37:
  pushl $0
  102161:	6a 00                	push   $0x0
  pushl $37
  102163:	6a 25                	push   $0x25
  jmp __alltraps
  102165:	e9 2a 09 00 00       	jmp    102a94 <__alltraps>

0010216a <vector38>:
.globl vector38
vector38:
  pushl $0
  10216a:	6a 00                	push   $0x0
  pushl $38
  10216c:	6a 26                	push   $0x26
  jmp __alltraps
  10216e:	e9 21 09 00 00       	jmp    102a94 <__alltraps>

00102173 <vector39>:
.globl vector39
vector39:
  pushl $0
  102173:	6a 00                	push   $0x0
  pushl $39
  102175:	6a 27                	push   $0x27
  jmp __alltraps
  102177:	e9 18 09 00 00       	jmp    102a94 <__alltraps>

0010217c <vector40>:
.globl vector40
vector40:
  pushl $0
  10217c:	6a 00                	push   $0x0
  pushl $40
  10217e:	6a 28                	push   $0x28
  jmp __alltraps
  102180:	e9 0f 09 00 00       	jmp    102a94 <__alltraps>

00102185 <vector41>:
.globl vector41
vector41:
  pushl $0
  102185:	6a 00                	push   $0x0
  pushl $41
  102187:	6a 29                	push   $0x29
  jmp __alltraps
  102189:	e9 06 09 00 00       	jmp    102a94 <__alltraps>

0010218e <vector42>:
.globl vector42
vector42:
  pushl $0
  10218e:	6a 00                	push   $0x0
  pushl $42
  102190:	6a 2a                	push   $0x2a
  jmp __alltraps
  102192:	e9 fd 08 00 00       	jmp    102a94 <__alltraps>

00102197 <vector43>:
.globl vector43
vector43:
  pushl $0
  102197:	6a 00                	push   $0x0
  pushl $43
  102199:	6a 2b                	push   $0x2b
  jmp __alltraps
  10219b:	e9 f4 08 00 00       	jmp    102a94 <__alltraps>

001021a0 <vector44>:
.globl vector44
vector44:
  pushl $0
  1021a0:	6a 00                	push   $0x0
  pushl $44
  1021a2:	6a 2c                	push   $0x2c
  jmp __alltraps
  1021a4:	e9 eb 08 00 00       	jmp    102a94 <__alltraps>

001021a9 <vector45>:
.globl vector45
vector45:
  pushl $0
  1021a9:	6a 00                	push   $0x0
  pushl $45
  1021ab:	6a 2d                	push   $0x2d
  jmp __alltraps
  1021ad:	e9 e2 08 00 00       	jmp    102a94 <__alltraps>

001021b2 <vector46>:
.globl vector46
vector46:
  pushl $0
  1021b2:	6a 00                	push   $0x0
  pushl $46
  1021b4:	6a 2e                	push   $0x2e
  jmp __alltraps
  1021b6:	e9 d9 08 00 00       	jmp    102a94 <__alltraps>

001021bb <vector47>:
.globl vector47
vector47:
  pushl $0
  1021bb:	6a 00                	push   $0x0
  pushl $47
  1021bd:	6a 2f                	push   $0x2f
  jmp __alltraps
  1021bf:	e9 d0 08 00 00       	jmp    102a94 <__alltraps>

001021c4 <vector48>:
.globl vector48
vector48:
  pushl $0
  1021c4:	6a 00                	push   $0x0
  pushl $48
  1021c6:	6a 30                	push   $0x30
  jmp __alltraps
  1021c8:	e9 c7 08 00 00       	jmp    102a94 <__alltraps>

001021cd <vector49>:
.globl vector49
vector49:
  pushl $0
  1021cd:	6a 00                	push   $0x0
  pushl $49
  1021cf:	6a 31                	push   $0x31
  jmp __alltraps
  1021d1:	e9 be 08 00 00       	jmp    102a94 <__alltraps>

001021d6 <vector50>:
.globl vector50
vector50:
  pushl $0
  1021d6:	6a 00                	push   $0x0
  pushl $50
  1021d8:	6a 32                	push   $0x32
  jmp __alltraps
  1021da:	e9 b5 08 00 00       	jmp    102a94 <__alltraps>

001021df <vector51>:
.globl vector51
vector51:
  pushl $0
  1021df:	6a 00                	push   $0x0
  pushl $51
  1021e1:	6a 33                	push   $0x33
  jmp __alltraps
  1021e3:	e9 ac 08 00 00       	jmp    102a94 <__alltraps>

001021e8 <vector52>:
.globl vector52
vector52:
  pushl $0
  1021e8:	6a 00                	push   $0x0
  pushl $52
  1021ea:	6a 34                	push   $0x34
  jmp __alltraps
  1021ec:	e9 a3 08 00 00       	jmp    102a94 <__alltraps>

001021f1 <vector53>:
.globl vector53
vector53:
  pushl $0
  1021f1:	6a 00                	push   $0x0
  pushl $53
  1021f3:	6a 35                	push   $0x35
  jmp __alltraps
  1021f5:	e9 9a 08 00 00       	jmp    102a94 <__alltraps>

001021fa <vector54>:
.globl vector54
vector54:
  pushl $0
  1021fa:	6a 00                	push   $0x0
  pushl $54
  1021fc:	6a 36                	push   $0x36
  jmp __alltraps
  1021fe:	e9 91 08 00 00       	jmp    102a94 <__alltraps>

00102203 <vector55>:
.globl vector55
vector55:
  pushl $0
  102203:	6a 00                	push   $0x0
  pushl $55
  102205:	6a 37                	push   $0x37
  jmp __alltraps
  102207:	e9 88 08 00 00       	jmp    102a94 <__alltraps>

0010220c <vector56>:
.globl vector56
vector56:
  pushl $0
  10220c:	6a 00                	push   $0x0
  pushl $56
  10220e:	6a 38                	push   $0x38
  jmp __alltraps
  102210:	e9 7f 08 00 00       	jmp    102a94 <__alltraps>

00102215 <vector57>:
.globl vector57
vector57:
  pushl $0
  102215:	6a 00                	push   $0x0
  pushl $57
  102217:	6a 39                	push   $0x39
  jmp __alltraps
  102219:	e9 76 08 00 00       	jmp    102a94 <__alltraps>

0010221e <vector58>:
.globl vector58
vector58:
  pushl $0
  10221e:	6a 00                	push   $0x0
  pushl $58
  102220:	6a 3a                	push   $0x3a
  jmp __alltraps
  102222:	e9 6d 08 00 00       	jmp    102a94 <__alltraps>

00102227 <vector59>:
.globl vector59
vector59:
  pushl $0
  102227:	6a 00                	push   $0x0
  pushl $59
  102229:	6a 3b                	push   $0x3b
  jmp __alltraps
  10222b:	e9 64 08 00 00       	jmp    102a94 <__alltraps>

00102230 <vector60>:
.globl vector60
vector60:
  pushl $0
  102230:	6a 00                	push   $0x0
  pushl $60
  102232:	6a 3c                	push   $0x3c
  jmp __alltraps
  102234:	e9 5b 08 00 00       	jmp    102a94 <__alltraps>

00102239 <vector61>:
.globl vector61
vector61:
  pushl $0
  102239:	6a 00                	push   $0x0
  pushl $61
  10223b:	6a 3d                	push   $0x3d
  jmp __alltraps
  10223d:	e9 52 08 00 00       	jmp    102a94 <__alltraps>

00102242 <vector62>:
.globl vector62
vector62:
  pushl $0
  102242:	6a 00                	push   $0x0
  pushl $62
  102244:	6a 3e                	push   $0x3e
  jmp __alltraps
  102246:	e9 49 08 00 00       	jmp    102a94 <__alltraps>

0010224b <vector63>:
.globl vector63
vector63:
  pushl $0
  10224b:	6a 00                	push   $0x0
  pushl $63
  10224d:	6a 3f                	push   $0x3f
  jmp __alltraps
  10224f:	e9 40 08 00 00       	jmp    102a94 <__alltraps>

00102254 <vector64>:
.globl vector64
vector64:
  pushl $0
  102254:	6a 00                	push   $0x0
  pushl $64
  102256:	6a 40                	push   $0x40
  jmp __alltraps
  102258:	e9 37 08 00 00       	jmp    102a94 <__alltraps>

0010225d <vector65>:
.globl vector65
vector65:
  pushl $0
  10225d:	6a 00                	push   $0x0
  pushl $65
  10225f:	6a 41                	push   $0x41
  jmp __alltraps
  102261:	e9 2e 08 00 00       	jmp    102a94 <__alltraps>

00102266 <vector66>:
.globl vector66
vector66:
  pushl $0
  102266:	6a 00                	push   $0x0
  pushl $66
  102268:	6a 42                	push   $0x42
  jmp __alltraps
  10226a:	e9 25 08 00 00       	jmp    102a94 <__alltraps>

0010226f <vector67>:
.globl vector67
vector67:
  pushl $0
  10226f:	6a 00                	push   $0x0
  pushl $67
  102271:	6a 43                	push   $0x43
  jmp __alltraps
  102273:	e9 1c 08 00 00       	jmp    102a94 <__alltraps>

00102278 <vector68>:
.globl vector68
vector68:
  pushl $0
  102278:	6a 00                	push   $0x0
  pushl $68
  10227a:	6a 44                	push   $0x44
  jmp __alltraps
  10227c:	e9 13 08 00 00       	jmp    102a94 <__alltraps>

00102281 <vector69>:
.globl vector69
vector69:
  pushl $0
  102281:	6a 00                	push   $0x0
  pushl $69
  102283:	6a 45                	push   $0x45
  jmp __alltraps
  102285:	e9 0a 08 00 00       	jmp    102a94 <__alltraps>

0010228a <vector70>:
.globl vector70
vector70:
  pushl $0
  10228a:	6a 00                	push   $0x0
  pushl $70
  10228c:	6a 46                	push   $0x46
  jmp __alltraps
  10228e:	e9 01 08 00 00       	jmp    102a94 <__alltraps>

00102293 <vector71>:
.globl vector71
vector71:
  pushl $0
  102293:	6a 00                	push   $0x0
  pushl $71
  102295:	6a 47                	push   $0x47
  jmp __alltraps
  102297:	e9 f8 07 00 00       	jmp    102a94 <__alltraps>

0010229c <vector72>:
.globl vector72
vector72:
  pushl $0
  10229c:	6a 00                	push   $0x0
  pushl $72
  10229e:	6a 48                	push   $0x48
  jmp __alltraps
  1022a0:	e9 ef 07 00 00       	jmp    102a94 <__alltraps>

001022a5 <vector73>:
.globl vector73
vector73:
  pushl $0
  1022a5:	6a 00                	push   $0x0
  pushl $73
  1022a7:	6a 49                	push   $0x49
  jmp __alltraps
  1022a9:	e9 e6 07 00 00       	jmp    102a94 <__alltraps>

001022ae <vector74>:
.globl vector74
vector74:
  pushl $0
  1022ae:	6a 00                	push   $0x0
  pushl $74
  1022b0:	6a 4a                	push   $0x4a
  jmp __alltraps
  1022b2:	e9 dd 07 00 00       	jmp    102a94 <__alltraps>

001022b7 <vector75>:
.globl vector75
vector75:
  pushl $0
  1022b7:	6a 00                	push   $0x0
  pushl $75
  1022b9:	6a 4b                	push   $0x4b
  jmp __alltraps
  1022bb:	e9 d4 07 00 00       	jmp    102a94 <__alltraps>

001022c0 <vector76>:
.globl vector76
vector76:
  pushl $0
  1022c0:	6a 00                	push   $0x0
  pushl $76
  1022c2:	6a 4c                	push   $0x4c
  jmp __alltraps
  1022c4:	e9 cb 07 00 00       	jmp    102a94 <__alltraps>

001022c9 <vector77>:
.globl vector77
vector77:
  pushl $0
  1022c9:	6a 00                	push   $0x0
  pushl $77
  1022cb:	6a 4d                	push   $0x4d
  jmp __alltraps
  1022cd:	e9 c2 07 00 00       	jmp    102a94 <__alltraps>

001022d2 <vector78>:
.globl vector78
vector78:
  pushl $0
  1022d2:	6a 00                	push   $0x0
  pushl $78
  1022d4:	6a 4e                	push   $0x4e
  jmp __alltraps
  1022d6:	e9 b9 07 00 00       	jmp    102a94 <__alltraps>

001022db <vector79>:
.globl vector79
vector79:
  pushl $0
  1022db:	6a 00                	push   $0x0
  pushl $79
  1022dd:	6a 4f                	push   $0x4f
  jmp __alltraps
  1022df:	e9 b0 07 00 00       	jmp    102a94 <__alltraps>

001022e4 <vector80>:
.globl vector80
vector80:
  pushl $0
  1022e4:	6a 00                	push   $0x0
  pushl $80
  1022e6:	6a 50                	push   $0x50
  jmp __alltraps
  1022e8:	e9 a7 07 00 00       	jmp    102a94 <__alltraps>

001022ed <vector81>:
.globl vector81
vector81:
  pushl $0
  1022ed:	6a 00                	push   $0x0
  pushl $81
  1022ef:	6a 51                	push   $0x51
  jmp __alltraps
  1022f1:	e9 9e 07 00 00       	jmp    102a94 <__alltraps>

001022f6 <vector82>:
.globl vector82
vector82:
  pushl $0
  1022f6:	6a 00                	push   $0x0
  pushl $82
  1022f8:	6a 52                	push   $0x52
  jmp __alltraps
  1022fa:	e9 95 07 00 00       	jmp    102a94 <__alltraps>

001022ff <vector83>:
.globl vector83
vector83:
  pushl $0
  1022ff:	6a 00                	push   $0x0
  pushl $83
  102301:	6a 53                	push   $0x53
  jmp __alltraps
  102303:	e9 8c 07 00 00       	jmp    102a94 <__alltraps>

00102308 <vector84>:
.globl vector84
vector84:
  pushl $0
  102308:	6a 00                	push   $0x0
  pushl $84
  10230a:	6a 54                	push   $0x54
  jmp __alltraps
  10230c:	e9 83 07 00 00       	jmp    102a94 <__alltraps>

00102311 <vector85>:
.globl vector85
vector85:
  pushl $0
  102311:	6a 00                	push   $0x0
  pushl $85
  102313:	6a 55                	push   $0x55
  jmp __alltraps
  102315:	e9 7a 07 00 00       	jmp    102a94 <__alltraps>

0010231a <vector86>:
.globl vector86
vector86:
  pushl $0
  10231a:	6a 00                	push   $0x0
  pushl $86
  10231c:	6a 56                	push   $0x56
  jmp __alltraps
  10231e:	e9 71 07 00 00       	jmp    102a94 <__alltraps>

00102323 <vector87>:
.globl vector87
vector87:
  pushl $0
  102323:	6a 00                	push   $0x0
  pushl $87
  102325:	6a 57                	push   $0x57
  jmp __alltraps
  102327:	e9 68 07 00 00       	jmp    102a94 <__alltraps>

0010232c <vector88>:
.globl vector88
vector88:
  pushl $0
  10232c:	6a 00                	push   $0x0
  pushl $88
  10232e:	6a 58                	push   $0x58
  jmp __alltraps
  102330:	e9 5f 07 00 00       	jmp    102a94 <__alltraps>

00102335 <vector89>:
.globl vector89
vector89:
  pushl $0
  102335:	6a 00                	push   $0x0
  pushl $89
  102337:	6a 59                	push   $0x59
  jmp __alltraps
  102339:	e9 56 07 00 00       	jmp    102a94 <__alltraps>

0010233e <vector90>:
.globl vector90
vector90:
  pushl $0
  10233e:	6a 00                	push   $0x0
  pushl $90
  102340:	6a 5a                	push   $0x5a
  jmp __alltraps
  102342:	e9 4d 07 00 00       	jmp    102a94 <__alltraps>

00102347 <vector91>:
.globl vector91
vector91:
  pushl $0
  102347:	6a 00                	push   $0x0
  pushl $91
  102349:	6a 5b                	push   $0x5b
  jmp __alltraps
  10234b:	e9 44 07 00 00       	jmp    102a94 <__alltraps>

00102350 <vector92>:
.globl vector92
vector92:
  pushl $0
  102350:	6a 00                	push   $0x0
  pushl $92
  102352:	6a 5c                	push   $0x5c
  jmp __alltraps
  102354:	e9 3b 07 00 00       	jmp    102a94 <__alltraps>

00102359 <vector93>:
.globl vector93
vector93:
  pushl $0
  102359:	6a 00                	push   $0x0
  pushl $93
  10235b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10235d:	e9 32 07 00 00       	jmp    102a94 <__alltraps>

00102362 <vector94>:
.globl vector94
vector94:
  pushl $0
  102362:	6a 00                	push   $0x0
  pushl $94
  102364:	6a 5e                	push   $0x5e
  jmp __alltraps
  102366:	e9 29 07 00 00       	jmp    102a94 <__alltraps>

0010236b <vector95>:
.globl vector95
vector95:
  pushl $0
  10236b:	6a 00                	push   $0x0
  pushl $95
  10236d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10236f:	e9 20 07 00 00       	jmp    102a94 <__alltraps>

00102374 <vector96>:
.globl vector96
vector96:
  pushl $0
  102374:	6a 00                	push   $0x0
  pushl $96
  102376:	6a 60                	push   $0x60
  jmp __alltraps
  102378:	e9 17 07 00 00       	jmp    102a94 <__alltraps>

0010237d <vector97>:
.globl vector97
vector97:
  pushl $0
  10237d:	6a 00                	push   $0x0
  pushl $97
  10237f:	6a 61                	push   $0x61
  jmp __alltraps
  102381:	e9 0e 07 00 00       	jmp    102a94 <__alltraps>

00102386 <vector98>:
.globl vector98
vector98:
  pushl $0
  102386:	6a 00                	push   $0x0
  pushl $98
  102388:	6a 62                	push   $0x62
  jmp __alltraps
  10238a:	e9 05 07 00 00       	jmp    102a94 <__alltraps>

0010238f <vector99>:
.globl vector99
vector99:
  pushl $0
  10238f:	6a 00                	push   $0x0
  pushl $99
  102391:	6a 63                	push   $0x63
  jmp __alltraps
  102393:	e9 fc 06 00 00       	jmp    102a94 <__alltraps>

00102398 <vector100>:
.globl vector100
vector100:
  pushl $0
  102398:	6a 00                	push   $0x0
  pushl $100
  10239a:	6a 64                	push   $0x64
  jmp __alltraps
  10239c:	e9 f3 06 00 00       	jmp    102a94 <__alltraps>

001023a1 <vector101>:
.globl vector101
vector101:
  pushl $0
  1023a1:	6a 00                	push   $0x0
  pushl $101
  1023a3:	6a 65                	push   $0x65
  jmp __alltraps
  1023a5:	e9 ea 06 00 00       	jmp    102a94 <__alltraps>

001023aa <vector102>:
.globl vector102
vector102:
  pushl $0
  1023aa:	6a 00                	push   $0x0
  pushl $102
  1023ac:	6a 66                	push   $0x66
  jmp __alltraps
  1023ae:	e9 e1 06 00 00       	jmp    102a94 <__alltraps>

001023b3 <vector103>:
.globl vector103
vector103:
  pushl $0
  1023b3:	6a 00                	push   $0x0
  pushl $103
  1023b5:	6a 67                	push   $0x67
  jmp __alltraps
  1023b7:	e9 d8 06 00 00       	jmp    102a94 <__alltraps>

001023bc <vector104>:
.globl vector104
vector104:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $104
  1023be:	6a 68                	push   $0x68
  jmp __alltraps
  1023c0:	e9 cf 06 00 00       	jmp    102a94 <__alltraps>

001023c5 <vector105>:
.globl vector105
vector105:
  pushl $0
  1023c5:	6a 00                	push   $0x0
  pushl $105
  1023c7:	6a 69                	push   $0x69
  jmp __alltraps
  1023c9:	e9 c6 06 00 00       	jmp    102a94 <__alltraps>

001023ce <vector106>:
.globl vector106
vector106:
  pushl $0
  1023ce:	6a 00                	push   $0x0
  pushl $106
  1023d0:	6a 6a                	push   $0x6a
  jmp __alltraps
  1023d2:	e9 bd 06 00 00       	jmp    102a94 <__alltraps>

001023d7 <vector107>:
.globl vector107
vector107:
  pushl $0
  1023d7:	6a 00                	push   $0x0
  pushl $107
  1023d9:	6a 6b                	push   $0x6b
  jmp __alltraps
  1023db:	e9 b4 06 00 00       	jmp    102a94 <__alltraps>

001023e0 <vector108>:
.globl vector108
vector108:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $108
  1023e2:	6a 6c                	push   $0x6c
  jmp __alltraps
  1023e4:	e9 ab 06 00 00       	jmp    102a94 <__alltraps>

001023e9 <vector109>:
.globl vector109
vector109:
  pushl $0
  1023e9:	6a 00                	push   $0x0
  pushl $109
  1023eb:	6a 6d                	push   $0x6d
  jmp __alltraps
  1023ed:	e9 a2 06 00 00       	jmp    102a94 <__alltraps>

001023f2 <vector110>:
.globl vector110
vector110:
  pushl $0
  1023f2:	6a 00                	push   $0x0
  pushl $110
  1023f4:	6a 6e                	push   $0x6e
  jmp __alltraps
  1023f6:	e9 99 06 00 00       	jmp    102a94 <__alltraps>

001023fb <vector111>:
.globl vector111
vector111:
  pushl $0
  1023fb:	6a 00                	push   $0x0
  pushl $111
  1023fd:	6a 6f                	push   $0x6f
  jmp __alltraps
  1023ff:	e9 90 06 00 00       	jmp    102a94 <__alltraps>

00102404 <vector112>:
.globl vector112
vector112:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $112
  102406:	6a 70                	push   $0x70
  jmp __alltraps
  102408:	e9 87 06 00 00       	jmp    102a94 <__alltraps>

0010240d <vector113>:
.globl vector113
vector113:
  pushl $0
  10240d:	6a 00                	push   $0x0
  pushl $113
  10240f:	6a 71                	push   $0x71
  jmp __alltraps
  102411:	e9 7e 06 00 00       	jmp    102a94 <__alltraps>

00102416 <vector114>:
.globl vector114
vector114:
  pushl $0
  102416:	6a 00                	push   $0x0
  pushl $114
  102418:	6a 72                	push   $0x72
  jmp __alltraps
  10241a:	e9 75 06 00 00       	jmp    102a94 <__alltraps>

0010241f <vector115>:
.globl vector115
vector115:
  pushl $0
  10241f:	6a 00                	push   $0x0
  pushl $115
  102421:	6a 73                	push   $0x73
  jmp __alltraps
  102423:	e9 6c 06 00 00       	jmp    102a94 <__alltraps>

00102428 <vector116>:
.globl vector116
vector116:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $116
  10242a:	6a 74                	push   $0x74
  jmp __alltraps
  10242c:	e9 63 06 00 00       	jmp    102a94 <__alltraps>

00102431 <vector117>:
.globl vector117
vector117:
  pushl $0
  102431:	6a 00                	push   $0x0
  pushl $117
  102433:	6a 75                	push   $0x75
  jmp __alltraps
  102435:	e9 5a 06 00 00       	jmp    102a94 <__alltraps>

0010243a <vector118>:
.globl vector118
vector118:
  pushl $0
  10243a:	6a 00                	push   $0x0
  pushl $118
  10243c:	6a 76                	push   $0x76
  jmp __alltraps
  10243e:	e9 51 06 00 00       	jmp    102a94 <__alltraps>

00102443 <vector119>:
.globl vector119
vector119:
  pushl $0
  102443:	6a 00                	push   $0x0
  pushl $119
  102445:	6a 77                	push   $0x77
  jmp __alltraps
  102447:	e9 48 06 00 00       	jmp    102a94 <__alltraps>

0010244c <vector120>:
.globl vector120
vector120:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $120
  10244e:	6a 78                	push   $0x78
  jmp __alltraps
  102450:	e9 3f 06 00 00       	jmp    102a94 <__alltraps>

00102455 <vector121>:
.globl vector121
vector121:
  pushl $0
  102455:	6a 00                	push   $0x0
  pushl $121
  102457:	6a 79                	push   $0x79
  jmp __alltraps
  102459:	e9 36 06 00 00       	jmp    102a94 <__alltraps>

0010245e <vector122>:
.globl vector122
vector122:
  pushl $0
  10245e:	6a 00                	push   $0x0
  pushl $122
  102460:	6a 7a                	push   $0x7a
  jmp __alltraps
  102462:	e9 2d 06 00 00       	jmp    102a94 <__alltraps>

00102467 <vector123>:
.globl vector123
vector123:
  pushl $0
  102467:	6a 00                	push   $0x0
  pushl $123
  102469:	6a 7b                	push   $0x7b
  jmp __alltraps
  10246b:	e9 24 06 00 00       	jmp    102a94 <__alltraps>

00102470 <vector124>:
.globl vector124
vector124:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $124
  102472:	6a 7c                	push   $0x7c
  jmp __alltraps
  102474:	e9 1b 06 00 00       	jmp    102a94 <__alltraps>

00102479 <vector125>:
.globl vector125
vector125:
  pushl $0
  102479:	6a 00                	push   $0x0
  pushl $125
  10247b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10247d:	e9 12 06 00 00       	jmp    102a94 <__alltraps>

00102482 <vector126>:
.globl vector126
vector126:
  pushl $0
  102482:	6a 00                	push   $0x0
  pushl $126
  102484:	6a 7e                	push   $0x7e
  jmp __alltraps
  102486:	e9 09 06 00 00       	jmp    102a94 <__alltraps>

0010248b <vector127>:
.globl vector127
vector127:
  pushl $0
  10248b:	6a 00                	push   $0x0
  pushl $127
  10248d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10248f:	e9 00 06 00 00       	jmp    102a94 <__alltraps>

00102494 <vector128>:
.globl vector128
vector128:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $128
  102496:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10249b:	e9 f4 05 00 00       	jmp    102a94 <__alltraps>

001024a0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $129
  1024a2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1024a7:	e9 e8 05 00 00       	jmp    102a94 <__alltraps>

001024ac <vector130>:
.globl vector130
vector130:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $130
  1024ae:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1024b3:	e9 dc 05 00 00       	jmp    102a94 <__alltraps>

001024b8 <vector131>:
.globl vector131
vector131:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $131
  1024ba:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1024bf:	e9 d0 05 00 00       	jmp    102a94 <__alltraps>

001024c4 <vector132>:
.globl vector132
vector132:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $132
  1024c6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1024cb:	e9 c4 05 00 00       	jmp    102a94 <__alltraps>

001024d0 <vector133>:
.globl vector133
vector133:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $133
  1024d2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1024d7:	e9 b8 05 00 00       	jmp    102a94 <__alltraps>

001024dc <vector134>:
.globl vector134
vector134:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $134
  1024de:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1024e3:	e9 ac 05 00 00       	jmp    102a94 <__alltraps>

001024e8 <vector135>:
.globl vector135
vector135:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $135
  1024ea:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1024ef:	e9 a0 05 00 00       	jmp    102a94 <__alltraps>

001024f4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $136
  1024f6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1024fb:	e9 94 05 00 00       	jmp    102a94 <__alltraps>

00102500 <vector137>:
.globl vector137
vector137:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $137
  102502:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102507:	e9 88 05 00 00       	jmp    102a94 <__alltraps>

0010250c <vector138>:
.globl vector138
vector138:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $138
  10250e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102513:	e9 7c 05 00 00       	jmp    102a94 <__alltraps>

00102518 <vector139>:
.globl vector139
vector139:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $139
  10251a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10251f:	e9 70 05 00 00       	jmp    102a94 <__alltraps>

00102524 <vector140>:
.globl vector140
vector140:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $140
  102526:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10252b:	e9 64 05 00 00       	jmp    102a94 <__alltraps>

00102530 <vector141>:
.globl vector141
vector141:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $141
  102532:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102537:	e9 58 05 00 00       	jmp    102a94 <__alltraps>

0010253c <vector142>:
.globl vector142
vector142:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $142
  10253e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102543:	e9 4c 05 00 00       	jmp    102a94 <__alltraps>

00102548 <vector143>:
.globl vector143
vector143:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $143
  10254a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10254f:	e9 40 05 00 00       	jmp    102a94 <__alltraps>

00102554 <vector144>:
.globl vector144
vector144:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $144
  102556:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10255b:	e9 34 05 00 00       	jmp    102a94 <__alltraps>

00102560 <vector145>:
.globl vector145
vector145:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $145
  102562:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102567:	e9 28 05 00 00       	jmp    102a94 <__alltraps>

0010256c <vector146>:
.globl vector146
vector146:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $146
  10256e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102573:	e9 1c 05 00 00       	jmp    102a94 <__alltraps>

00102578 <vector147>:
.globl vector147
vector147:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $147
  10257a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10257f:	e9 10 05 00 00       	jmp    102a94 <__alltraps>

00102584 <vector148>:
.globl vector148
vector148:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $148
  102586:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10258b:	e9 04 05 00 00       	jmp    102a94 <__alltraps>

00102590 <vector149>:
.globl vector149
vector149:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $149
  102592:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102597:	e9 f8 04 00 00       	jmp    102a94 <__alltraps>

0010259c <vector150>:
.globl vector150
vector150:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $150
  10259e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1025a3:	e9 ec 04 00 00       	jmp    102a94 <__alltraps>

001025a8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $151
  1025aa:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1025af:	e9 e0 04 00 00       	jmp    102a94 <__alltraps>

001025b4 <vector152>:
.globl vector152
vector152:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $152
  1025b6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1025bb:	e9 d4 04 00 00       	jmp    102a94 <__alltraps>

001025c0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $153
  1025c2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1025c7:	e9 c8 04 00 00       	jmp    102a94 <__alltraps>

001025cc <vector154>:
.globl vector154
vector154:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $154
  1025ce:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1025d3:	e9 bc 04 00 00       	jmp    102a94 <__alltraps>

001025d8 <vector155>:
.globl vector155
vector155:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $155
  1025da:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1025df:	e9 b0 04 00 00       	jmp    102a94 <__alltraps>

001025e4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $156
  1025e6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1025eb:	e9 a4 04 00 00       	jmp    102a94 <__alltraps>

001025f0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $157
  1025f2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1025f7:	e9 98 04 00 00       	jmp    102a94 <__alltraps>

001025fc <vector158>:
.globl vector158
vector158:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $158
  1025fe:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102603:	e9 8c 04 00 00       	jmp    102a94 <__alltraps>

00102608 <vector159>:
.globl vector159
vector159:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $159
  10260a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10260f:	e9 80 04 00 00       	jmp    102a94 <__alltraps>

00102614 <vector160>:
.globl vector160
vector160:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $160
  102616:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10261b:	e9 74 04 00 00       	jmp    102a94 <__alltraps>

00102620 <vector161>:
.globl vector161
vector161:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $161
  102622:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102627:	e9 68 04 00 00       	jmp    102a94 <__alltraps>

0010262c <vector162>:
.globl vector162
vector162:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $162
  10262e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102633:	e9 5c 04 00 00       	jmp    102a94 <__alltraps>

00102638 <vector163>:
.globl vector163
vector163:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $163
  10263a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10263f:	e9 50 04 00 00       	jmp    102a94 <__alltraps>

00102644 <vector164>:
.globl vector164
vector164:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $164
  102646:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10264b:	e9 44 04 00 00       	jmp    102a94 <__alltraps>

00102650 <vector165>:
.globl vector165
vector165:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $165
  102652:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102657:	e9 38 04 00 00       	jmp    102a94 <__alltraps>

0010265c <vector166>:
.globl vector166
vector166:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $166
  10265e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102663:	e9 2c 04 00 00       	jmp    102a94 <__alltraps>

00102668 <vector167>:
.globl vector167
vector167:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $167
  10266a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10266f:	e9 20 04 00 00       	jmp    102a94 <__alltraps>

00102674 <vector168>:
.globl vector168
vector168:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $168
  102676:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10267b:	e9 14 04 00 00       	jmp    102a94 <__alltraps>

00102680 <vector169>:
.globl vector169
vector169:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $169
  102682:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102687:	e9 08 04 00 00       	jmp    102a94 <__alltraps>

0010268c <vector170>:
.globl vector170
vector170:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $170
  10268e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102693:	e9 fc 03 00 00       	jmp    102a94 <__alltraps>

00102698 <vector171>:
.globl vector171
vector171:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $171
  10269a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10269f:	e9 f0 03 00 00       	jmp    102a94 <__alltraps>

001026a4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $172
  1026a6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1026ab:	e9 e4 03 00 00       	jmp    102a94 <__alltraps>

001026b0 <vector173>:
.globl vector173
vector173:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $173
  1026b2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1026b7:	e9 d8 03 00 00       	jmp    102a94 <__alltraps>

001026bc <vector174>:
.globl vector174
vector174:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $174
  1026be:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1026c3:	e9 cc 03 00 00       	jmp    102a94 <__alltraps>

001026c8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $175
  1026ca:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1026cf:	e9 c0 03 00 00       	jmp    102a94 <__alltraps>

001026d4 <vector176>:
.globl vector176
vector176:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $176
  1026d6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1026db:	e9 b4 03 00 00       	jmp    102a94 <__alltraps>

001026e0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $177
  1026e2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1026e7:	e9 a8 03 00 00       	jmp    102a94 <__alltraps>

001026ec <vector178>:
.globl vector178
vector178:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $178
  1026ee:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1026f3:	e9 9c 03 00 00       	jmp    102a94 <__alltraps>

001026f8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $179
  1026fa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1026ff:	e9 90 03 00 00       	jmp    102a94 <__alltraps>

00102704 <vector180>:
.globl vector180
vector180:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $180
  102706:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10270b:	e9 84 03 00 00       	jmp    102a94 <__alltraps>

00102710 <vector181>:
.globl vector181
vector181:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $181
  102712:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102717:	e9 78 03 00 00       	jmp    102a94 <__alltraps>

0010271c <vector182>:
.globl vector182
vector182:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $182
  10271e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102723:	e9 6c 03 00 00       	jmp    102a94 <__alltraps>

00102728 <vector183>:
.globl vector183
vector183:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $183
  10272a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10272f:	e9 60 03 00 00       	jmp    102a94 <__alltraps>

00102734 <vector184>:
.globl vector184
vector184:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $184
  102736:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10273b:	e9 54 03 00 00       	jmp    102a94 <__alltraps>

00102740 <vector185>:
.globl vector185
vector185:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $185
  102742:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102747:	e9 48 03 00 00       	jmp    102a94 <__alltraps>

0010274c <vector186>:
.globl vector186
vector186:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $186
  10274e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102753:	e9 3c 03 00 00       	jmp    102a94 <__alltraps>

00102758 <vector187>:
.globl vector187
vector187:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $187
  10275a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10275f:	e9 30 03 00 00       	jmp    102a94 <__alltraps>

00102764 <vector188>:
.globl vector188
vector188:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $188
  102766:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10276b:	e9 24 03 00 00       	jmp    102a94 <__alltraps>

00102770 <vector189>:
.globl vector189
vector189:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $189
  102772:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102777:	e9 18 03 00 00       	jmp    102a94 <__alltraps>

0010277c <vector190>:
.globl vector190
vector190:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $190
  10277e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102783:	e9 0c 03 00 00       	jmp    102a94 <__alltraps>

00102788 <vector191>:
.globl vector191
vector191:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $191
  10278a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10278f:	e9 00 03 00 00       	jmp    102a94 <__alltraps>

00102794 <vector192>:
.globl vector192
vector192:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $192
  102796:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10279b:	e9 f4 02 00 00       	jmp    102a94 <__alltraps>

001027a0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $193
  1027a2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1027a7:	e9 e8 02 00 00       	jmp    102a94 <__alltraps>

001027ac <vector194>:
.globl vector194
vector194:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $194
  1027ae:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1027b3:	e9 dc 02 00 00       	jmp    102a94 <__alltraps>

001027b8 <vector195>:
.globl vector195
vector195:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $195
  1027ba:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1027bf:	e9 d0 02 00 00       	jmp    102a94 <__alltraps>

001027c4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $196
  1027c6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1027cb:	e9 c4 02 00 00       	jmp    102a94 <__alltraps>

001027d0 <vector197>:
.globl vector197
vector197:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $197
  1027d2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1027d7:	e9 b8 02 00 00       	jmp    102a94 <__alltraps>

001027dc <vector198>:
.globl vector198
vector198:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $198
  1027de:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1027e3:	e9 ac 02 00 00       	jmp    102a94 <__alltraps>

001027e8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $199
  1027ea:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1027ef:	e9 a0 02 00 00       	jmp    102a94 <__alltraps>

001027f4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $200
  1027f6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1027fb:	e9 94 02 00 00       	jmp    102a94 <__alltraps>

00102800 <vector201>:
.globl vector201
vector201:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $201
  102802:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102807:	e9 88 02 00 00       	jmp    102a94 <__alltraps>

0010280c <vector202>:
.globl vector202
vector202:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $202
  10280e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102813:	e9 7c 02 00 00       	jmp    102a94 <__alltraps>

00102818 <vector203>:
.globl vector203
vector203:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $203
  10281a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10281f:	e9 70 02 00 00       	jmp    102a94 <__alltraps>

00102824 <vector204>:
.globl vector204
vector204:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $204
  102826:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10282b:	e9 64 02 00 00       	jmp    102a94 <__alltraps>

00102830 <vector205>:
.globl vector205
vector205:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $205
  102832:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102837:	e9 58 02 00 00       	jmp    102a94 <__alltraps>

0010283c <vector206>:
.globl vector206
vector206:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $206
  10283e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102843:	e9 4c 02 00 00       	jmp    102a94 <__alltraps>

00102848 <vector207>:
.globl vector207
vector207:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $207
  10284a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10284f:	e9 40 02 00 00       	jmp    102a94 <__alltraps>

00102854 <vector208>:
.globl vector208
vector208:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $208
  102856:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10285b:	e9 34 02 00 00       	jmp    102a94 <__alltraps>

00102860 <vector209>:
.globl vector209
vector209:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $209
  102862:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102867:	e9 28 02 00 00       	jmp    102a94 <__alltraps>

0010286c <vector210>:
.globl vector210
vector210:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $210
  10286e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102873:	e9 1c 02 00 00       	jmp    102a94 <__alltraps>

00102878 <vector211>:
.globl vector211
vector211:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $211
  10287a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10287f:	e9 10 02 00 00       	jmp    102a94 <__alltraps>

00102884 <vector212>:
.globl vector212
vector212:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $212
  102886:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10288b:	e9 04 02 00 00       	jmp    102a94 <__alltraps>

00102890 <vector213>:
.globl vector213
vector213:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $213
  102892:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102897:	e9 f8 01 00 00       	jmp    102a94 <__alltraps>

0010289c <vector214>:
.globl vector214
vector214:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $214
  10289e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1028a3:	e9 ec 01 00 00       	jmp    102a94 <__alltraps>

001028a8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $215
  1028aa:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1028af:	e9 e0 01 00 00       	jmp    102a94 <__alltraps>

001028b4 <vector216>:
.globl vector216
vector216:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $216
  1028b6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1028bb:	e9 d4 01 00 00       	jmp    102a94 <__alltraps>

001028c0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $217
  1028c2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1028c7:	e9 c8 01 00 00       	jmp    102a94 <__alltraps>

001028cc <vector218>:
.globl vector218
vector218:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $218
  1028ce:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1028d3:	e9 bc 01 00 00       	jmp    102a94 <__alltraps>

001028d8 <vector219>:
.globl vector219
vector219:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $219
  1028da:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1028df:	e9 b0 01 00 00       	jmp    102a94 <__alltraps>

001028e4 <vector220>:
.globl vector220
vector220:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $220
  1028e6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1028eb:	e9 a4 01 00 00       	jmp    102a94 <__alltraps>

001028f0 <vector221>:
.globl vector221
vector221:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $221
  1028f2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1028f7:	e9 98 01 00 00       	jmp    102a94 <__alltraps>

001028fc <vector222>:
.globl vector222
vector222:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $222
  1028fe:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102903:	e9 8c 01 00 00       	jmp    102a94 <__alltraps>

00102908 <vector223>:
.globl vector223
vector223:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $223
  10290a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10290f:	e9 80 01 00 00       	jmp    102a94 <__alltraps>

00102914 <vector224>:
.globl vector224
vector224:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $224
  102916:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10291b:	e9 74 01 00 00       	jmp    102a94 <__alltraps>

00102920 <vector225>:
.globl vector225
vector225:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $225
  102922:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102927:	e9 68 01 00 00       	jmp    102a94 <__alltraps>

0010292c <vector226>:
.globl vector226
vector226:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $226
  10292e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102933:	e9 5c 01 00 00       	jmp    102a94 <__alltraps>

00102938 <vector227>:
.globl vector227
vector227:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $227
  10293a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10293f:	e9 50 01 00 00       	jmp    102a94 <__alltraps>

00102944 <vector228>:
.globl vector228
vector228:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $228
  102946:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10294b:	e9 44 01 00 00       	jmp    102a94 <__alltraps>

00102950 <vector229>:
.globl vector229
vector229:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $229
  102952:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102957:	e9 38 01 00 00       	jmp    102a94 <__alltraps>

0010295c <vector230>:
.globl vector230
vector230:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $230
  10295e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102963:	e9 2c 01 00 00       	jmp    102a94 <__alltraps>

00102968 <vector231>:
.globl vector231
vector231:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $231
  10296a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10296f:	e9 20 01 00 00       	jmp    102a94 <__alltraps>

00102974 <vector232>:
.globl vector232
vector232:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $232
  102976:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10297b:	e9 14 01 00 00       	jmp    102a94 <__alltraps>

00102980 <vector233>:
.globl vector233
vector233:
  pushl $0
  102980:	6a 00                	push   $0x0
  pushl $233
  102982:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102987:	e9 08 01 00 00       	jmp    102a94 <__alltraps>

0010298c <vector234>:
.globl vector234
vector234:
  pushl $0
  10298c:	6a 00                	push   $0x0
  pushl $234
  10298e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102993:	e9 fc 00 00 00       	jmp    102a94 <__alltraps>

00102998 <vector235>:
.globl vector235
vector235:
  pushl $0
  102998:	6a 00                	push   $0x0
  pushl $235
  10299a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10299f:	e9 f0 00 00 00       	jmp    102a94 <__alltraps>

001029a4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1029a4:	6a 00                	push   $0x0
  pushl $236
  1029a6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1029ab:	e9 e4 00 00 00       	jmp    102a94 <__alltraps>

001029b0 <vector237>:
.globl vector237
vector237:
  pushl $0
  1029b0:	6a 00                	push   $0x0
  pushl $237
  1029b2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1029b7:	e9 d8 00 00 00       	jmp    102a94 <__alltraps>

001029bc <vector238>:
.globl vector238
vector238:
  pushl $0
  1029bc:	6a 00                	push   $0x0
  pushl $238
  1029be:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1029c3:	e9 cc 00 00 00       	jmp    102a94 <__alltraps>

001029c8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1029c8:	6a 00                	push   $0x0
  pushl $239
  1029ca:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1029cf:	e9 c0 00 00 00       	jmp    102a94 <__alltraps>

001029d4 <vector240>:
.globl vector240
vector240:
  pushl $0
  1029d4:	6a 00                	push   $0x0
  pushl $240
  1029d6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1029db:	e9 b4 00 00 00       	jmp    102a94 <__alltraps>

001029e0 <vector241>:
.globl vector241
vector241:
  pushl $0
  1029e0:	6a 00                	push   $0x0
  pushl $241
  1029e2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1029e7:	e9 a8 00 00 00       	jmp    102a94 <__alltraps>

001029ec <vector242>:
.globl vector242
vector242:
  pushl $0
  1029ec:	6a 00                	push   $0x0
  pushl $242
  1029ee:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1029f3:	e9 9c 00 00 00       	jmp    102a94 <__alltraps>

001029f8 <vector243>:
.globl vector243
vector243:
  pushl $0
  1029f8:	6a 00                	push   $0x0
  pushl $243
  1029fa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1029ff:	e9 90 00 00 00       	jmp    102a94 <__alltraps>

00102a04 <vector244>:
.globl vector244
vector244:
  pushl $0
  102a04:	6a 00                	push   $0x0
  pushl $244
  102a06:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102a0b:	e9 84 00 00 00       	jmp    102a94 <__alltraps>

00102a10 <vector245>:
.globl vector245
vector245:
  pushl $0
  102a10:	6a 00                	push   $0x0
  pushl $245
  102a12:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102a17:	e9 78 00 00 00       	jmp    102a94 <__alltraps>

00102a1c <vector246>:
.globl vector246
vector246:
  pushl $0
  102a1c:	6a 00                	push   $0x0
  pushl $246
  102a1e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102a23:	e9 6c 00 00 00       	jmp    102a94 <__alltraps>

00102a28 <vector247>:
.globl vector247
vector247:
  pushl $0
  102a28:	6a 00                	push   $0x0
  pushl $247
  102a2a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102a2f:	e9 60 00 00 00       	jmp    102a94 <__alltraps>

00102a34 <vector248>:
.globl vector248
vector248:
  pushl $0
  102a34:	6a 00                	push   $0x0
  pushl $248
  102a36:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102a3b:	e9 54 00 00 00       	jmp    102a94 <__alltraps>

00102a40 <vector249>:
.globl vector249
vector249:
  pushl $0
  102a40:	6a 00                	push   $0x0
  pushl $249
  102a42:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102a47:	e9 48 00 00 00       	jmp    102a94 <__alltraps>

00102a4c <vector250>:
.globl vector250
vector250:
  pushl $0
  102a4c:	6a 00                	push   $0x0
  pushl $250
  102a4e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102a53:	e9 3c 00 00 00       	jmp    102a94 <__alltraps>

00102a58 <vector251>:
.globl vector251
vector251:
  pushl $0
  102a58:	6a 00                	push   $0x0
  pushl $251
  102a5a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  102a5f:	e9 30 00 00 00       	jmp    102a94 <__alltraps>

00102a64 <vector252>:
.globl vector252
vector252:
  pushl $0
  102a64:	6a 00                	push   $0x0
  pushl $252
  102a66:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102a6b:	e9 24 00 00 00       	jmp    102a94 <__alltraps>

00102a70 <vector253>:
.globl vector253
vector253:
  pushl $0
  102a70:	6a 00                	push   $0x0
  pushl $253
  102a72:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102a77:	e9 18 00 00 00       	jmp    102a94 <__alltraps>

00102a7c <vector254>:
.globl vector254
vector254:
  pushl $0
  102a7c:	6a 00                	push   $0x0
  pushl $254
  102a7e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102a83:	e9 0c 00 00 00       	jmp    102a94 <__alltraps>

00102a88 <vector255>:
.globl vector255
vector255:
  pushl $0
  102a88:	6a 00                	push   $0x0
  pushl $255
  102a8a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102a8f:	e9 00 00 00 00       	jmp    102a94 <__alltraps>

00102a94 <__alltraps>:
# 最后压入trapframe结构体指针作为trap函数的参数，
# 再调用trap函数完成具体的中断处理
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  102a94:	1e                   	push   %ds
    pushl %es
  102a95:	06                   	push   %es
    pushl %fs
  102a96:	0f a0                	push   %fs
    pushl %gs
  102a98:	0f a8                	push   %gs
    pushal
  102a9a:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  102a9b:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102aa0:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102aa2:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102aa4:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102aa5:	e8 60 f5 ff ff       	call   10200a <trap>

    # pop the pushed stack pointer
    popl %esp
  102aaa:	5c                   	pop    %esp

00102aab <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  102aab:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  102aac:	0f a9                	pop    %gs
    popl %fs
  102aae:	0f a1                	pop    %fs
    popl %es
  102ab0:	07                   	pop    %es
    popl %ds
  102ab1:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102ab2:	83 c4 08             	add    $0x8,%esp
    iret
  102ab5:	cf                   	iret   

00102ab6 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102ab6:	55                   	push   %ebp
  102ab7:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  102ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  102abc:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102abf:	b8 23 00 00 00       	mov    $0x23,%eax
  102ac4:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102ac6:	b8 23 00 00 00       	mov    $0x23,%eax
  102acb:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  102acd:	b8 10 00 00 00       	mov    $0x10,%eax
  102ad2:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102ad4:	b8 10 00 00 00       	mov    $0x10,%eax
  102ad9:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102adb:	b8 10 00 00 00       	mov    $0x10,%eax
  102ae0:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102ae2:	ea e9 2a 10 00 08 00 	ljmp   $0x8,$0x102ae9
}
  102ae9:	90                   	nop
  102aea:	5d                   	pop    %ebp
  102aeb:	c3                   	ret    

00102aec <gdt_init>:

// stack0即为临时的内核栈，当在用户态执行时进行中断，将切换到stack0堆栈进行执行

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102aec:	f3 0f 1e fb          	endbr32 
  102af0:	55                   	push   %ebp
  102af1:	89 e5                	mov    %esp,%ebp
  102af3:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102af6:	b8 80 19 11 00       	mov    $0x111980,%eax
  102afb:	05 00 04 00 00       	add    $0x400,%eax
  102b00:	a3 a4 18 11 00       	mov    %eax,0x1118a4
    ts.ts_ss0 = KERNEL_DS;
  102b05:	66 c7 05 a8 18 11 00 	movw   $0x10,0x1118a8
  102b0c:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102b0e:	66 c7 05 08 0a 11 00 	movw   $0x68,0x110a08
  102b15:	68 00 
  102b17:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b1c:	0f b7 c0             	movzwl %ax,%eax
  102b1f:	66 a3 0a 0a 11 00    	mov    %ax,0x110a0a
  102b25:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102b2a:	c1 e8 10             	shr    $0x10,%eax
  102b2d:	a2 0c 0a 11 00       	mov    %al,0x110a0c
  102b32:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b39:	24 f0                	and    $0xf0,%al
  102b3b:	0c 09                	or     $0x9,%al
  102b3d:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b42:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b49:	0c 10                	or     $0x10,%al
  102b4b:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b50:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b57:	24 9f                	and    $0x9f,%al
  102b59:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b5e:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102b65:	0c 80                	or     $0x80,%al
  102b67:	a2 0d 0a 11 00       	mov    %al,0x110a0d
  102b6c:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b73:	24 f0                	and    $0xf0,%al
  102b75:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b7a:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b81:	24 ef                	and    $0xef,%al
  102b83:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b88:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b8f:	24 df                	and    $0xdf,%al
  102b91:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102b96:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102b9d:	0c 40                	or     $0x40,%al
  102b9f:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102ba4:	0f b6 05 0e 0a 11 00 	movzbl 0x110a0e,%eax
  102bab:	24 7f                	and    $0x7f,%al
  102bad:	a2 0e 0a 11 00       	mov    %al,0x110a0e
  102bb2:	b8 a0 18 11 00       	mov    $0x1118a0,%eax
  102bb7:	c1 e8 18             	shr    $0x18,%eax
  102bba:	a2 0f 0a 11 00       	mov    %al,0x110a0f
    gdt[SEG_TSS].sd_s = 0;
  102bbf:	0f b6 05 0d 0a 11 00 	movzbl 0x110a0d,%eax
  102bc6:	24 ef                	and    $0xef,%al
  102bc8:	a2 0d 0a 11 00       	mov    %al,0x110a0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102bcd:	c7 04 24 10 0a 11 00 	movl   $0x110a10,(%esp)
  102bd4:	e8 dd fe ff ff       	call   102ab6 <lgdt>
  102bd9:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102bdf:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102be3:	0f 00 d8             	ltr    %ax
}
  102be6:	90                   	nop

    // load the TSS
    ltr(GD_TSS);
}
  102be7:	90                   	nop
  102be8:	c9                   	leave  
  102be9:	c3                   	ret    

00102bea <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102bea:	f3 0f 1e fb          	endbr32 
  102bee:	55                   	push   %ebp
  102bef:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102bf1:	e8 f6 fe ff ff       	call   102aec <gdt_init>
}
  102bf6:	90                   	nop
  102bf7:	5d                   	pop    %ebp
  102bf8:	c3                   	ret    

00102bf9 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102bf9:	f3 0f 1e fb          	endbr32 
  102bfd:	55                   	push   %ebp
  102bfe:	89 e5                	mov    %esp,%ebp
  102c00:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102c0a:	eb 03                	jmp    102c0f <strlen+0x16>
        cnt ++;
  102c0c:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c12:	8d 50 01             	lea    0x1(%eax),%edx
  102c15:	89 55 08             	mov    %edx,0x8(%ebp)
  102c18:	0f b6 00             	movzbl (%eax),%eax
  102c1b:	84 c0                	test   %al,%al
  102c1d:	75 ed                	jne    102c0c <strlen+0x13>
    }
    return cnt;
  102c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c22:	c9                   	leave  
  102c23:	c3                   	ret    

00102c24 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102c24:	f3 0f 1e fb          	endbr32 
  102c28:	55                   	push   %ebp
  102c29:	89 e5                	mov    %esp,%ebp
  102c2b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102c2e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c35:	eb 03                	jmp    102c3a <strnlen+0x16>
        cnt ++;
  102c37:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102c3a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102c3d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102c40:	73 10                	jae    102c52 <strnlen+0x2e>
  102c42:	8b 45 08             	mov    0x8(%ebp),%eax
  102c45:	8d 50 01             	lea    0x1(%eax),%edx
  102c48:	89 55 08             	mov    %edx,0x8(%ebp)
  102c4b:	0f b6 00             	movzbl (%eax),%eax
  102c4e:	84 c0                	test   %al,%al
  102c50:	75 e5                	jne    102c37 <strnlen+0x13>
    }
    return cnt;
  102c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102c55:	c9                   	leave  
  102c56:	c3                   	ret    

00102c57 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102c57:	f3 0f 1e fb          	endbr32 
  102c5b:	55                   	push   %ebp
  102c5c:	89 e5                	mov    %esp,%ebp
  102c5e:	57                   	push   %edi
  102c5f:	56                   	push   %esi
  102c60:	83 ec 20             	sub    $0x20,%esp
  102c63:	8b 45 08             	mov    0x8(%ebp),%eax
  102c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102c69:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102c6f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c75:	89 d1                	mov    %edx,%ecx
  102c77:	89 c2                	mov    %eax,%edx
  102c79:	89 ce                	mov    %ecx,%esi
  102c7b:	89 d7                	mov    %edx,%edi
  102c7d:	ac                   	lods   %ds:(%esi),%al
  102c7e:	aa                   	stos   %al,%es:(%edi)
  102c7f:	84 c0                	test   %al,%al
  102c81:	75 fa                	jne    102c7d <strcpy+0x26>
  102c83:	89 fa                	mov    %edi,%edx
  102c85:	89 f1                	mov    %esi,%ecx
  102c87:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102c8a:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102c8d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102c93:	83 c4 20             	add    $0x20,%esp
  102c96:	5e                   	pop    %esi
  102c97:	5f                   	pop    %edi
  102c98:	5d                   	pop    %ebp
  102c99:	c3                   	ret    

00102c9a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102c9a:	f3 0f 1e fb          	endbr32 
  102c9e:	55                   	push   %ebp
  102c9f:	89 e5                	mov    %esp,%ebp
  102ca1:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102caa:	eb 1e                	jmp    102cca <strncpy+0x30>
        if ((*p = *src) != '\0') {
  102cac:	8b 45 0c             	mov    0xc(%ebp),%eax
  102caf:	0f b6 10             	movzbl (%eax),%edx
  102cb2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cb5:	88 10                	mov    %dl,(%eax)
  102cb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102cba:	0f b6 00             	movzbl (%eax),%eax
  102cbd:	84 c0                	test   %al,%al
  102cbf:	74 03                	je     102cc4 <strncpy+0x2a>
            src ++;
  102cc1:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102cc4:	ff 45 fc             	incl   -0x4(%ebp)
  102cc7:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102cca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102cce:	75 dc                	jne    102cac <strncpy+0x12>
    }
    return dst;
  102cd0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102cd3:	c9                   	leave  
  102cd4:	c3                   	ret    

00102cd5 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102cd5:	f3 0f 1e fb          	endbr32 
  102cd9:	55                   	push   %ebp
  102cda:	89 e5                	mov    %esp,%ebp
  102cdc:	57                   	push   %edi
  102cdd:	56                   	push   %esi
  102cde:	83 ec 20             	sub    $0x20,%esp
  102ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102cf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cf3:	89 d1                	mov    %edx,%ecx
  102cf5:	89 c2                	mov    %eax,%edx
  102cf7:	89 ce                	mov    %ecx,%esi
  102cf9:	89 d7                	mov    %edx,%edi
  102cfb:	ac                   	lods   %ds:(%esi),%al
  102cfc:	ae                   	scas   %es:(%edi),%al
  102cfd:	75 08                	jne    102d07 <strcmp+0x32>
  102cff:	84 c0                	test   %al,%al
  102d01:	75 f8                	jne    102cfb <strcmp+0x26>
  102d03:	31 c0                	xor    %eax,%eax
  102d05:	eb 04                	jmp    102d0b <strcmp+0x36>
  102d07:	19 c0                	sbb    %eax,%eax
  102d09:	0c 01                	or     $0x1,%al
  102d0b:	89 fa                	mov    %edi,%edx
  102d0d:	89 f1                	mov    %esi,%ecx
  102d0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102d12:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102d15:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102d18:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102d1b:	83 c4 20             	add    $0x20,%esp
  102d1e:	5e                   	pop    %esi
  102d1f:	5f                   	pop    %edi
  102d20:	5d                   	pop    %ebp
  102d21:	c3                   	ret    

00102d22 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102d22:	f3 0f 1e fb          	endbr32 
  102d26:	55                   	push   %ebp
  102d27:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d29:	eb 09                	jmp    102d34 <strncmp+0x12>
        n --, s1 ++, s2 ++;
  102d2b:	ff 4d 10             	decl   0x10(%ebp)
  102d2e:	ff 45 08             	incl   0x8(%ebp)
  102d31:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102d34:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d38:	74 1a                	je     102d54 <strncmp+0x32>
  102d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3d:	0f b6 00             	movzbl (%eax),%eax
  102d40:	84 c0                	test   %al,%al
  102d42:	74 10                	je     102d54 <strncmp+0x32>
  102d44:	8b 45 08             	mov    0x8(%ebp),%eax
  102d47:	0f b6 10             	movzbl (%eax),%edx
  102d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d4d:	0f b6 00             	movzbl (%eax),%eax
  102d50:	38 c2                	cmp    %al,%dl
  102d52:	74 d7                	je     102d2b <strncmp+0x9>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102d54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d58:	74 18                	je     102d72 <strncmp+0x50>
  102d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5d:	0f b6 00             	movzbl (%eax),%eax
  102d60:	0f b6 d0             	movzbl %al,%edx
  102d63:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d66:	0f b6 00             	movzbl (%eax),%eax
  102d69:	0f b6 c0             	movzbl %al,%eax
  102d6c:	29 c2                	sub    %eax,%edx
  102d6e:	89 d0                	mov    %edx,%eax
  102d70:	eb 05                	jmp    102d77 <strncmp+0x55>
  102d72:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102d77:	5d                   	pop    %ebp
  102d78:	c3                   	ret    

00102d79 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102d79:	f3 0f 1e fb          	endbr32 
  102d7d:	55                   	push   %ebp
  102d7e:	89 e5                	mov    %esp,%ebp
  102d80:	83 ec 04             	sub    $0x4,%esp
  102d83:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d86:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102d89:	eb 13                	jmp    102d9e <strchr+0x25>
        if (*s == c) {
  102d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8e:	0f b6 00             	movzbl (%eax),%eax
  102d91:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102d94:	75 05                	jne    102d9b <strchr+0x22>
            return (char *)s;
  102d96:	8b 45 08             	mov    0x8(%ebp),%eax
  102d99:	eb 12                	jmp    102dad <strchr+0x34>
        }
        s ++;
  102d9b:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  102da1:	0f b6 00             	movzbl (%eax),%eax
  102da4:	84 c0                	test   %al,%al
  102da6:	75 e3                	jne    102d8b <strchr+0x12>
    }
    return NULL;
  102da8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102dad:	c9                   	leave  
  102dae:	c3                   	ret    

00102daf <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102daf:	f3 0f 1e fb          	endbr32 
  102db3:	55                   	push   %ebp
  102db4:	89 e5                	mov    %esp,%ebp
  102db6:	83 ec 04             	sub    $0x4,%esp
  102db9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102dbc:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102dbf:	eb 0e                	jmp    102dcf <strfind+0x20>
        if (*s == c) {
  102dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc4:	0f b6 00             	movzbl (%eax),%eax
  102dc7:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102dca:	74 0f                	je     102ddb <strfind+0x2c>
            break;
        }
        s ++;
  102dcc:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd2:	0f b6 00             	movzbl (%eax),%eax
  102dd5:	84 c0                	test   %al,%al
  102dd7:	75 e8                	jne    102dc1 <strfind+0x12>
  102dd9:	eb 01                	jmp    102ddc <strfind+0x2d>
            break;
  102ddb:	90                   	nop
    }
    return (char *)s;
  102ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102ddf:	c9                   	leave  
  102de0:	c3                   	ret    

00102de1 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102de1:	f3 0f 1e fb          	endbr32 
  102de5:	55                   	push   %ebp
  102de6:	89 e5                	mov    %esp,%ebp
  102de8:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102deb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102df2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102df9:	eb 03                	jmp    102dfe <strtol+0x1d>
        s ++;
  102dfb:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  102e01:	0f b6 00             	movzbl (%eax),%eax
  102e04:	3c 20                	cmp    $0x20,%al
  102e06:	74 f3                	je     102dfb <strtol+0x1a>
  102e08:	8b 45 08             	mov    0x8(%ebp),%eax
  102e0b:	0f b6 00             	movzbl (%eax),%eax
  102e0e:	3c 09                	cmp    $0x9,%al
  102e10:	74 e9                	je     102dfb <strtol+0x1a>
    }

    // plus/minus sign
    if (*s == '+') {
  102e12:	8b 45 08             	mov    0x8(%ebp),%eax
  102e15:	0f b6 00             	movzbl (%eax),%eax
  102e18:	3c 2b                	cmp    $0x2b,%al
  102e1a:	75 05                	jne    102e21 <strtol+0x40>
        s ++;
  102e1c:	ff 45 08             	incl   0x8(%ebp)
  102e1f:	eb 14                	jmp    102e35 <strtol+0x54>
    }
    else if (*s == '-') {
  102e21:	8b 45 08             	mov    0x8(%ebp),%eax
  102e24:	0f b6 00             	movzbl (%eax),%eax
  102e27:	3c 2d                	cmp    $0x2d,%al
  102e29:	75 0a                	jne    102e35 <strtol+0x54>
        s ++, neg = 1;
  102e2b:	ff 45 08             	incl   0x8(%ebp)
  102e2e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e39:	74 06                	je     102e41 <strtol+0x60>
  102e3b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102e3f:	75 22                	jne    102e63 <strtol+0x82>
  102e41:	8b 45 08             	mov    0x8(%ebp),%eax
  102e44:	0f b6 00             	movzbl (%eax),%eax
  102e47:	3c 30                	cmp    $0x30,%al
  102e49:	75 18                	jne    102e63 <strtol+0x82>
  102e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102e4e:	40                   	inc    %eax
  102e4f:	0f b6 00             	movzbl (%eax),%eax
  102e52:	3c 78                	cmp    $0x78,%al
  102e54:	75 0d                	jne    102e63 <strtol+0x82>
        s += 2, base = 16;
  102e56:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102e5a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102e61:	eb 29                	jmp    102e8c <strtol+0xab>
    }
    else if (base == 0 && s[0] == '0') {
  102e63:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e67:	75 16                	jne    102e7f <strtol+0x9e>
  102e69:	8b 45 08             	mov    0x8(%ebp),%eax
  102e6c:	0f b6 00             	movzbl (%eax),%eax
  102e6f:	3c 30                	cmp    $0x30,%al
  102e71:	75 0c                	jne    102e7f <strtol+0x9e>
        s ++, base = 8;
  102e73:	ff 45 08             	incl   0x8(%ebp)
  102e76:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102e7d:	eb 0d                	jmp    102e8c <strtol+0xab>
    }
    else if (base == 0) {
  102e7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102e83:	75 07                	jne    102e8c <strtol+0xab>
        base = 10;
  102e85:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  102e8f:	0f b6 00             	movzbl (%eax),%eax
  102e92:	3c 2f                	cmp    $0x2f,%al
  102e94:	7e 1b                	jle    102eb1 <strtol+0xd0>
  102e96:	8b 45 08             	mov    0x8(%ebp),%eax
  102e99:	0f b6 00             	movzbl (%eax),%eax
  102e9c:	3c 39                	cmp    $0x39,%al
  102e9e:	7f 11                	jg     102eb1 <strtol+0xd0>
            dig = *s - '0';
  102ea0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea3:	0f b6 00             	movzbl (%eax),%eax
  102ea6:	0f be c0             	movsbl %al,%eax
  102ea9:	83 e8 30             	sub    $0x30,%eax
  102eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eaf:	eb 48                	jmp    102ef9 <strtol+0x118>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  102eb4:	0f b6 00             	movzbl (%eax),%eax
  102eb7:	3c 60                	cmp    $0x60,%al
  102eb9:	7e 1b                	jle    102ed6 <strtol+0xf5>
  102ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebe:	0f b6 00             	movzbl (%eax),%eax
  102ec1:	3c 7a                	cmp    $0x7a,%al
  102ec3:	7f 11                	jg     102ed6 <strtol+0xf5>
            dig = *s - 'a' + 10;
  102ec5:	8b 45 08             	mov    0x8(%ebp),%eax
  102ec8:	0f b6 00             	movzbl (%eax),%eax
  102ecb:	0f be c0             	movsbl %al,%eax
  102ece:	83 e8 57             	sub    $0x57,%eax
  102ed1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102ed4:	eb 23                	jmp    102ef9 <strtol+0x118>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed9:	0f b6 00             	movzbl (%eax),%eax
  102edc:	3c 40                	cmp    $0x40,%al
  102ede:	7e 3b                	jle    102f1b <strtol+0x13a>
  102ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee3:	0f b6 00             	movzbl (%eax),%eax
  102ee6:	3c 5a                	cmp    $0x5a,%al
  102ee8:	7f 31                	jg     102f1b <strtol+0x13a>
            dig = *s - 'A' + 10;
  102eea:	8b 45 08             	mov    0x8(%ebp),%eax
  102eed:	0f b6 00             	movzbl (%eax),%eax
  102ef0:	0f be c0             	movsbl %al,%eax
  102ef3:	83 e8 37             	sub    $0x37,%eax
  102ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102efc:	3b 45 10             	cmp    0x10(%ebp),%eax
  102eff:	7d 19                	jge    102f1a <strtol+0x139>
            break;
        }
        s ++, val = (val * base) + dig;
  102f01:	ff 45 08             	incl   0x8(%ebp)
  102f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f07:	0f af 45 10          	imul   0x10(%ebp),%eax
  102f0b:	89 c2                	mov    %eax,%edx
  102f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f10:	01 d0                	add    %edx,%eax
  102f12:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102f15:	e9 72 ff ff ff       	jmp    102e8c <strtol+0xab>
            break;
  102f1a:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102f1b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102f1f:	74 08                	je     102f29 <strtol+0x148>
        *endptr = (char *) s;
  102f21:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f24:	8b 55 08             	mov    0x8(%ebp),%edx
  102f27:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102f29:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102f2d:	74 07                	je     102f36 <strtol+0x155>
  102f2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f32:	f7 d8                	neg    %eax
  102f34:	eb 03                	jmp    102f39 <strtol+0x158>
  102f36:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102f39:	c9                   	leave  
  102f3a:	c3                   	ret    

00102f3b <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102f3b:	f3 0f 1e fb          	endbr32 
  102f3f:	55                   	push   %ebp
  102f40:	89 e5                	mov    %esp,%ebp
  102f42:	57                   	push   %edi
  102f43:	83 ec 24             	sub    $0x24,%esp
  102f46:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f49:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102f4c:	0f be 55 d8          	movsbl -0x28(%ebp),%edx
  102f50:	8b 45 08             	mov    0x8(%ebp),%eax
  102f53:	89 45 f8             	mov    %eax,-0x8(%ebp)
  102f56:	88 55 f7             	mov    %dl,-0x9(%ebp)
  102f59:	8b 45 10             	mov    0x10(%ebp),%eax
  102f5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102f5f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102f62:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102f66:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102f69:	89 d7                	mov    %edx,%edi
  102f6b:	f3 aa                	rep stos %al,%es:(%edi)
  102f6d:	89 fa                	mov    %edi,%edx
  102f6f:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102f72:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102f75:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102f78:	83 c4 24             	add    $0x24,%esp
  102f7b:	5f                   	pop    %edi
  102f7c:	5d                   	pop    %ebp
  102f7d:	c3                   	ret    

00102f7e <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102f7e:	f3 0f 1e fb          	endbr32 
  102f82:	55                   	push   %ebp
  102f83:	89 e5                	mov    %esp,%ebp
  102f85:	57                   	push   %edi
  102f86:	56                   	push   %esi
  102f87:	53                   	push   %ebx
  102f88:	83 ec 30             	sub    $0x30,%esp
  102f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f94:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f97:	8b 45 10             	mov    0x10(%ebp),%eax
  102f9a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102f9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102fa3:	73 42                	jae    102fe7 <memmove+0x69>
  102fa5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fae:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fb4:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102fb7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102fba:	c1 e8 02             	shr    $0x2,%eax
  102fbd:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102fbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102fc2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fc5:	89 d7                	mov    %edx,%edi
  102fc7:	89 c6                	mov    %eax,%esi
  102fc9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102fcb:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102fce:	83 e1 03             	and    $0x3,%ecx
  102fd1:	74 02                	je     102fd5 <memmove+0x57>
  102fd3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102fd5:	89 f0                	mov    %esi,%eax
  102fd7:	89 fa                	mov    %edi,%edx
  102fd9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102fdc:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102fdf:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
        return __memcpy(dst, src, n);
  102fe5:	eb 36                	jmp    10301d <memmove+0x9f>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102fe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ff0:	01 c2                	add    %eax,%edx
  102ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ff5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ffb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102ffe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103001:	89 c1                	mov    %eax,%ecx
  103003:	89 d8                	mov    %ebx,%eax
  103005:	89 d6                	mov    %edx,%esi
  103007:	89 c7                	mov    %eax,%edi
  103009:	fd                   	std    
  10300a:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10300c:	fc                   	cld    
  10300d:	89 f8                	mov    %edi,%eax
  10300f:	89 f2                	mov    %esi,%edx
  103011:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  103014:	89 55 c8             	mov    %edx,-0x38(%ebp)
  103017:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  10301a:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  10301d:	83 c4 30             	add    $0x30,%esp
  103020:	5b                   	pop    %ebx
  103021:	5e                   	pop    %esi
  103022:	5f                   	pop    %edi
  103023:	5d                   	pop    %ebp
  103024:	c3                   	ret    

00103025 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  103025:	f3 0f 1e fb          	endbr32 
  103029:	55                   	push   %ebp
  10302a:	89 e5                	mov    %esp,%ebp
  10302c:	57                   	push   %edi
  10302d:	56                   	push   %esi
  10302e:	83 ec 20             	sub    $0x20,%esp
  103031:	8b 45 08             	mov    0x8(%ebp),%eax
  103034:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103037:	8b 45 0c             	mov    0xc(%ebp),%eax
  10303a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10303d:	8b 45 10             	mov    0x10(%ebp),%eax
  103040:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103043:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103046:	c1 e8 02             	shr    $0x2,%eax
  103049:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10304b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10304e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103051:	89 d7                	mov    %edx,%edi
  103053:	89 c6                	mov    %eax,%esi
  103055:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103057:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  10305a:	83 e1 03             	and    $0x3,%ecx
  10305d:	74 02                	je     103061 <memcpy+0x3c>
  10305f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103061:	89 f0                	mov    %esi,%eax
  103063:	89 fa                	mov    %edi,%edx
  103065:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103068:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10306b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10306e:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103071:	83 c4 20             	add    $0x20,%esp
  103074:	5e                   	pop    %esi
  103075:	5f                   	pop    %edi
  103076:	5d                   	pop    %ebp
  103077:	c3                   	ret    

00103078 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103078:	f3 0f 1e fb          	endbr32 
  10307c:	55                   	push   %ebp
  10307d:	89 e5                	mov    %esp,%ebp
  10307f:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  103082:	8b 45 08             	mov    0x8(%ebp),%eax
  103085:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103088:	8b 45 0c             	mov    0xc(%ebp),%eax
  10308b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  10308e:	eb 2e                	jmp    1030be <memcmp+0x46>
        if (*s1 != *s2) {
  103090:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103093:	0f b6 10             	movzbl (%eax),%edx
  103096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103099:	0f b6 00             	movzbl (%eax),%eax
  10309c:	38 c2                	cmp    %al,%dl
  10309e:	74 18                	je     1030b8 <memcmp+0x40>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  1030a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1030a3:	0f b6 00             	movzbl (%eax),%eax
  1030a6:	0f b6 d0             	movzbl %al,%edx
  1030a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1030ac:	0f b6 00             	movzbl (%eax),%eax
  1030af:	0f b6 c0             	movzbl %al,%eax
  1030b2:	29 c2                	sub    %eax,%edx
  1030b4:	89 d0                	mov    %edx,%eax
  1030b6:	eb 18                	jmp    1030d0 <memcmp+0x58>
        }
        s1 ++, s2 ++;
  1030b8:	ff 45 fc             	incl   -0x4(%ebp)
  1030bb:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  1030be:	8b 45 10             	mov    0x10(%ebp),%eax
  1030c1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1030c4:	89 55 10             	mov    %edx,0x10(%ebp)
  1030c7:	85 c0                	test   %eax,%eax
  1030c9:	75 c5                	jne    103090 <memcmp+0x18>
    }
    return 0;
  1030cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1030d0:	c9                   	leave  
  1030d1:	c3                   	ret    

001030d2 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1030d2:	f3 0f 1e fb          	endbr32 
  1030d6:	55                   	push   %ebp
  1030d7:	89 e5                	mov    %esp,%ebp
  1030d9:	83 ec 58             	sub    $0x58,%esp
  1030dc:	8b 45 10             	mov    0x10(%ebp),%eax
  1030df:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1030e2:	8b 45 14             	mov    0x14(%ebp),%eax
  1030e5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1030e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1030eb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1030ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1030f1:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1030f4:	8b 45 18             	mov    0x18(%ebp),%eax
  1030f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1030fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1030fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103100:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103103:	89 55 f0             	mov    %edx,-0x10(%ebp)
  103106:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103109:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10310c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103110:	74 1c                	je     10312e <printnum+0x5c>
  103112:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103115:	ba 00 00 00 00       	mov    $0x0,%edx
  10311a:	f7 75 e4             	divl   -0x1c(%ebp)
  10311d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  103120:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103123:	ba 00 00 00 00       	mov    $0x0,%edx
  103128:	f7 75 e4             	divl   -0x1c(%ebp)
  10312b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10312e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103131:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103134:	f7 75 e4             	divl   -0x1c(%ebp)
  103137:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10313a:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10313d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103140:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103143:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103146:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103149:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10314c:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10314f:	8b 45 18             	mov    0x18(%ebp),%eax
  103152:	ba 00 00 00 00       	mov    $0x0,%edx
  103157:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10315a:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  10315d:	19 d1                	sbb    %edx,%ecx
  10315f:	72 4c                	jb     1031ad <printnum+0xdb>
        printnum(putch, putdat, result, base, width - 1, padc);
  103161:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103164:	8d 50 ff             	lea    -0x1(%eax),%edx
  103167:	8b 45 20             	mov    0x20(%ebp),%eax
  10316a:	89 44 24 18          	mov    %eax,0x18(%esp)
  10316e:	89 54 24 14          	mov    %edx,0x14(%esp)
  103172:	8b 45 18             	mov    0x18(%ebp),%eax
  103175:	89 44 24 10          	mov    %eax,0x10(%esp)
  103179:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10317c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10317f:	89 44 24 08          	mov    %eax,0x8(%esp)
  103183:	89 54 24 0c          	mov    %edx,0xc(%esp)
  103187:	8b 45 0c             	mov    0xc(%ebp),%eax
  10318a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10318e:	8b 45 08             	mov    0x8(%ebp),%eax
  103191:	89 04 24             	mov    %eax,(%esp)
  103194:	e8 39 ff ff ff       	call   1030d2 <printnum>
  103199:	eb 1b                	jmp    1031b6 <printnum+0xe4>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10319b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10319e:	89 44 24 04          	mov    %eax,0x4(%esp)
  1031a2:	8b 45 20             	mov    0x20(%ebp),%eax
  1031a5:	89 04 24             	mov    %eax,(%esp)
  1031a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031ab:	ff d0                	call   *%eax
        while (-- width > 0)
  1031ad:	ff 4d 1c             	decl   0x1c(%ebp)
  1031b0:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1031b4:	7f e5                	jg     10319b <printnum+0xc9>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1031b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1031b9:	05 10 3f 10 00       	add    $0x103f10,%eax
  1031be:	0f b6 00             	movzbl (%eax),%eax
  1031c1:	0f be c0             	movsbl %al,%eax
  1031c4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1031c7:	89 54 24 04          	mov    %edx,0x4(%esp)
  1031cb:	89 04 24             	mov    %eax,(%esp)
  1031ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d1:	ff d0                	call   *%eax
}
  1031d3:	90                   	nop
  1031d4:	c9                   	leave  
  1031d5:	c3                   	ret    

001031d6 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1031d6:	f3 0f 1e fb          	endbr32 
  1031da:	55                   	push   %ebp
  1031db:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1031dd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1031e1:	7e 14                	jle    1031f7 <getuint+0x21>
        return va_arg(*ap, unsigned long long);
  1031e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1031e6:	8b 00                	mov    (%eax),%eax
  1031e8:	8d 48 08             	lea    0x8(%eax),%ecx
  1031eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1031ee:	89 0a                	mov    %ecx,(%edx)
  1031f0:	8b 50 04             	mov    0x4(%eax),%edx
  1031f3:	8b 00                	mov    (%eax),%eax
  1031f5:	eb 30                	jmp    103227 <getuint+0x51>
    }
    else if (lflag) {
  1031f7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1031fb:	74 16                	je     103213 <getuint+0x3d>
        return va_arg(*ap, unsigned long);
  1031fd:	8b 45 08             	mov    0x8(%ebp),%eax
  103200:	8b 00                	mov    (%eax),%eax
  103202:	8d 48 04             	lea    0x4(%eax),%ecx
  103205:	8b 55 08             	mov    0x8(%ebp),%edx
  103208:	89 0a                	mov    %ecx,(%edx)
  10320a:	8b 00                	mov    (%eax),%eax
  10320c:	ba 00 00 00 00       	mov    $0x0,%edx
  103211:	eb 14                	jmp    103227 <getuint+0x51>
    }
    else {
        return va_arg(*ap, unsigned int);
  103213:	8b 45 08             	mov    0x8(%ebp),%eax
  103216:	8b 00                	mov    (%eax),%eax
  103218:	8d 48 04             	lea    0x4(%eax),%ecx
  10321b:	8b 55 08             	mov    0x8(%ebp),%edx
  10321e:	89 0a                	mov    %ecx,(%edx)
  103220:	8b 00                	mov    (%eax),%eax
  103222:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103227:	5d                   	pop    %ebp
  103228:	c3                   	ret    

00103229 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103229:	f3 0f 1e fb          	endbr32 
  10322d:	55                   	push   %ebp
  10322e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  103230:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103234:	7e 14                	jle    10324a <getint+0x21>
        return va_arg(*ap, long long);
  103236:	8b 45 08             	mov    0x8(%ebp),%eax
  103239:	8b 00                	mov    (%eax),%eax
  10323b:	8d 48 08             	lea    0x8(%eax),%ecx
  10323e:	8b 55 08             	mov    0x8(%ebp),%edx
  103241:	89 0a                	mov    %ecx,(%edx)
  103243:	8b 50 04             	mov    0x4(%eax),%edx
  103246:	8b 00                	mov    (%eax),%eax
  103248:	eb 28                	jmp    103272 <getint+0x49>
    }
    else if (lflag) {
  10324a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10324e:	74 12                	je     103262 <getint+0x39>
        return va_arg(*ap, long);
  103250:	8b 45 08             	mov    0x8(%ebp),%eax
  103253:	8b 00                	mov    (%eax),%eax
  103255:	8d 48 04             	lea    0x4(%eax),%ecx
  103258:	8b 55 08             	mov    0x8(%ebp),%edx
  10325b:	89 0a                	mov    %ecx,(%edx)
  10325d:	8b 00                	mov    (%eax),%eax
  10325f:	99                   	cltd   
  103260:	eb 10                	jmp    103272 <getint+0x49>
    }
    else {
        return va_arg(*ap, int);
  103262:	8b 45 08             	mov    0x8(%ebp),%eax
  103265:	8b 00                	mov    (%eax),%eax
  103267:	8d 48 04             	lea    0x4(%eax),%ecx
  10326a:	8b 55 08             	mov    0x8(%ebp),%edx
  10326d:	89 0a                	mov    %ecx,(%edx)
  10326f:	8b 00                	mov    (%eax),%eax
  103271:	99                   	cltd   
    }
}
  103272:	5d                   	pop    %ebp
  103273:	c3                   	ret    

00103274 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103274:	f3 0f 1e fb          	endbr32 
  103278:	55                   	push   %ebp
  103279:	89 e5                	mov    %esp,%ebp
  10327b:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  10327e:	8d 45 14             	lea    0x14(%ebp),%eax
  103281:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  103284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103287:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10328b:	8b 45 10             	mov    0x10(%ebp),%eax
  10328e:	89 44 24 08          	mov    %eax,0x8(%esp)
  103292:	8b 45 0c             	mov    0xc(%ebp),%eax
  103295:	89 44 24 04          	mov    %eax,0x4(%esp)
  103299:	8b 45 08             	mov    0x8(%ebp),%eax
  10329c:	89 04 24             	mov    %eax,(%esp)
  10329f:	e8 03 00 00 00       	call   1032a7 <vprintfmt>
    va_end(ap);
}
  1032a4:	90                   	nop
  1032a5:	c9                   	leave  
  1032a6:	c3                   	ret    

001032a7 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1032a7:	f3 0f 1e fb          	endbr32 
  1032ab:	55                   	push   %ebp
  1032ac:	89 e5                	mov    %esp,%ebp
  1032ae:	56                   	push   %esi
  1032af:	53                   	push   %ebx
  1032b0:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032b3:	eb 17                	jmp    1032cc <vprintfmt+0x25>
            if (ch == '\0') {
  1032b5:	85 db                	test   %ebx,%ebx
  1032b7:	0f 84 c0 03 00 00    	je     10367d <vprintfmt+0x3d6>
                return;
            }
            putch(ch, putdat);
  1032bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032c0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032c4:	89 1c 24             	mov    %ebx,(%esp)
  1032c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1032ca:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1032cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1032cf:	8d 50 01             	lea    0x1(%eax),%edx
  1032d2:	89 55 10             	mov    %edx,0x10(%ebp)
  1032d5:	0f b6 00             	movzbl (%eax),%eax
  1032d8:	0f b6 d8             	movzbl %al,%ebx
  1032db:	83 fb 25             	cmp    $0x25,%ebx
  1032de:	75 d5                	jne    1032b5 <vprintfmt+0xe>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1032e0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1032e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1032eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1032ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1032f1:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1032f8:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032fb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1032fe:	8b 45 10             	mov    0x10(%ebp),%eax
  103301:	8d 50 01             	lea    0x1(%eax),%edx
  103304:	89 55 10             	mov    %edx,0x10(%ebp)
  103307:	0f b6 00             	movzbl (%eax),%eax
  10330a:	0f b6 d8             	movzbl %al,%ebx
  10330d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  103310:	83 f8 55             	cmp    $0x55,%eax
  103313:	0f 87 38 03 00 00    	ja     103651 <vprintfmt+0x3aa>
  103319:	8b 04 85 34 3f 10 00 	mov    0x103f34(,%eax,4),%eax
  103320:	3e ff e0             	notrack jmp *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  103323:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  103327:	eb d5                	jmp    1032fe <vprintfmt+0x57>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  103329:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  10332d:	eb cf                	jmp    1032fe <vprintfmt+0x57>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  10332f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103336:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103339:	89 d0                	mov    %edx,%eax
  10333b:	c1 e0 02             	shl    $0x2,%eax
  10333e:	01 d0                	add    %edx,%eax
  103340:	01 c0                	add    %eax,%eax
  103342:	01 d8                	add    %ebx,%eax
  103344:	83 e8 30             	sub    $0x30,%eax
  103347:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10334a:	8b 45 10             	mov    0x10(%ebp),%eax
  10334d:	0f b6 00             	movzbl (%eax),%eax
  103350:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103353:	83 fb 2f             	cmp    $0x2f,%ebx
  103356:	7e 38                	jle    103390 <vprintfmt+0xe9>
  103358:	83 fb 39             	cmp    $0x39,%ebx
  10335b:	7f 33                	jg     103390 <vprintfmt+0xe9>
            for (precision = 0; ; ++ fmt) {
  10335d:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103360:	eb d4                	jmp    103336 <vprintfmt+0x8f>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103362:	8b 45 14             	mov    0x14(%ebp),%eax
  103365:	8d 50 04             	lea    0x4(%eax),%edx
  103368:	89 55 14             	mov    %edx,0x14(%ebp)
  10336b:	8b 00                	mov    (%eax),%eax
  10336d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103370:	eb 1f                	jmp    103391 <vprintfmt+0xea>

        case '.':
            if (width < 0)
  103372:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103376:	79 86                	jns    1032fe <vprintfmt+0x57>
                width = 0;
  103378:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  10337f:	e9 7a ff ff ff       	jmp    1032fe <vprintfmt+0x57>

        case '#':
            altflag = 1;
  103384:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10338b:	e9 6e ff ff ff       	jmp    1032fe <vprintfmt+0x57>
            goto process_precision;
  103390:	90                   	nop

        process_precision:
            if (width < 0)
  103391:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103395:	0f 89 63 ff ff ff    	jns    1032fe <vprintfmt+0x57>
                width = precision, precision = -1;
  10339b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10339e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1033a1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1033a8:	e9 51 ff ff ff       	jmp    1032fe <vprintfmt+0x57>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1033ad:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  1033b0:	e9 49 ff ff ff       	jmp    1032fe <vprintfmt+0x57>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1033b5:	8b 45 14             	mov    0x14(%ebp),%eax
  1033b8:	8d 50 04             	lea    0x4(%eax),%edx
  1033bb:	89 55 14             	mov    %edx,0x14(%ebp)
  1033be:	8b 00                	mov    (%eax),%eax
  1033c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  1033c3:	89 54 24 04          	mov    %edx,0x4(%esp)
  1033c7:	89 04 24             	mov    %eax,(%esp)
  1033ca:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cd:	ff d0                	call   *%eax
            break;
  1033cf:	e9 a4 02 00 00       	jmp    103678 <vprintfmt+0x3d1>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1033d4:	8b 45 14             	mov    0x14(%ebp),%eax
  1033d7:	8d 50 04             	lea    0x4(%eax),%edx
  1033da:	89 55 14             	mov    %edx,0x14(%ebp)
  1033dd:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1033df:	85 db                	test   %ebx,%ebx
  1033e1:	79 02                	jns    1033e5 <vprintfmt+0x13e>
                err = -err;
  1033e3:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1033e5:	83 fb 06             	cmp    $0x6,%ebx
  1033e8:	7f 0b                	jg     1033f5 <vprintfmt+0x14e>
  1033ea:	8b 34 9d f4 3e 10 00 	mov    0x103ef4(,%ebx,4),%esi
  1033f1:	85 f6                	test   %esi,%esi
  1033f3:	75 23                	jne    103418 <vprintfmt+0x171>
                printfmt(putch, putdat, "error %d", err);
  1033f5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1033f9:	c7 44 24 08 21 3f 10 	movl   $0x103f21,0x8(%esp)
  103400:	00 
  103401:	8b 45 0c             	mov    0xc(%ebp),%eax
  103404:	89 44 24 04          	mov    %eax,0x4(%esp)
  103408:	8b 45 08             	mov    0x8(%ebp),%eax
  10340b:	89 04 24             	mov    %eax,(%esp)
  10340e:	e8 61 fe ff ff       	call   103274 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  103413:	e9 60 02 00 00       	jmp    103678 <vprintfmt+0x3d1>
                printfmt(putch, putdat, "%s", p);
  103418:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10341c:	c7 44 24 08 2a 3f 10 	movl   $0x103f2a,0x8(%esp)
  103423:	00 
  103424:	8b 45 0c             	mov    0xc(%ebp),%eax
  103427:	89 44 24 04          	mov    %eax,0x4(%esp)
  10342b:	8b 45 08             	mov    0x8(%ebp),%eax
  10342e:	89 04 24             	mov    %eax,(%esp)
  103431:	e8 3e fe ff ff       	call   103274 <printfmt>
            break;
  103436:	e9 3d 02 00 00       	jmp    103678 <vprintfmt+0x3d1>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10343b:	8b 45 14             	mov    0x14(%ebp),%eax
  10343e:	8d 50 04             	lea    0x4(%eax),%edx
  103441:	89 55 14             	mov    %edx,0x14(%ebp)
  103444:	8b 30                	mov    (%eax),%esi
  103446:	85 f6                	test   %esi,%esi
  103448:	75 05                	jne    10344f <vprintfmt+0x1a8>
                p = "(null)";
  10344a:	be 2d 3f 10 00       	mov    $0x103f2d,%esi
            }
            if (width > 0 && padc != '-') {
  10344f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103453:	7e 76                	jle    1034cb <vprintfmt+0x224>
  103455:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  103459:	74 70                	je     1034cb <vprintfmt+0x224>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10345b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10345e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103462:	89 34 24             	mov    %esi,(%esp)
  103465:	e8 ba f7 ff ff       	call   102c24 <strnlen>
  10346a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10346d:	29 c2                	sub    %eax,%edx
  10346f:	89 d0                	mov    %edx,%eax
  103471:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103474:	eb 16                	jmp    10348c <vprintfmt+0x1e5>
                    putch(padc, putdat);
  103476:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10347a:	8b 55 0c             	mov    0xc(%ebp),%edx
  10347d:	89 54 24 04          	mov    %edx,0x4(%esp)
  103481:	89 04 24             	mov    %eax,(%esp)
  103484:	8b 45 08             	mov    0x8(%ebp),%eax
  103487:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  103489:	ff 4d e8             	decl   -0x18(%ebp)
  10348c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103490:	7f e4                	jg     103476 <vprintfmt+0x1cf>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103492:	eb 37                	jmp    1034cb <vprintfmt+0x224>
                if (altflag && (ch < ' ' || ch > '~')) {
  103494:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103498:	74 1f                	je     1034b9 <vprintfmt+0x212>
  10349a:	83 fb 1f             	cmp    $0x1f,%ebx
  10349d:	7e 05                	jle    1034a4 <vprintfmt+0x1fd>
  10349f:	83 fb 7e             	cmp    $0x7e,%ebx
  1034a2:	7e 15                	jle    1034b9 <vprintfmt+0x212>
                    putch('?', putdat);
  1034a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034ab:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  1034b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1034b5:	ff d0                	call   *%eax
  1034b7:	eb 0f                	jmp    1034c8 <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat);
  1034b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c0:	89 1c 24             	mov    %ebx,(%esp)
  1034c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1034c6:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1034c8:	ff 4d e8             	decl   -0x18(%ebp)
  1034cb:	89 f0                	mov    %esi,%eax
  1034cd:	8d 70 01             	lea    0x1(%eax),%esi
  1034d0:	0f b6 00             	movzbl (%eax),%eax
  1034d3:	0f be d8             	movsbl %al,%ebx
  1034d6:	85 db                	test   %ebx,%ebx
  1034d8:	74 27                	je     103501 <vprintfmt+0x25a>
  1034da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034de:	78 b4                	js     103494 <vprintfmt+0x1ed>
  1034e0:	ff 4d e4             	decl   -0x1c(%ebp)
  1034e3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1034e7:	79 ab                	jns    103494 <vprintfmt+0x1ed>
                }
            }
            for (; width > 0; width --) {
  1034e9:	eb 16                	jmp    103501 <vprintfmt+0x25a>
                putch(' ', putdat);
  1034eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034f2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1034f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1034fc:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1034fe:	ff 4d e8             	decl   -0x18(%ebp)
  103501:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103505:	7f e4                	jg     1034eb <vprintfmt+0x244>
            }
            break;
  103507:	e9 6c 01 00 00       	jmp    103678 <vprintfmt+0x3d1>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  10350c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10350f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103513:	8d 45 14             	lea    0x14(%ebp),%eax
  103516:	89 04 24             	mov    %eax,(%esp)
  103519:	e8 0b fd ff ff       	call   103229 <getint>
  10351e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103521:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  103524:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103527:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10352a:	85 d2                	test   %edx,%edx
  10352c:	79 26                	jns    103554 <vprintfmt+0x2ad>
                putch('-', putdat);
  10352e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103531:	89 44 24 04          	mov    %eax,0x4(%esp)
  103535:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10353c:	8b 45 08             	mov    0x8(%ebp),%eax
  10353f:	ff d0                	call   *%eax
                num = -(long long)num;
  103541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103547:	f7 d8                	neg    %eax
  103549:	83 d2 00             	adc    $0x0,%edx
  10354c:	f7 da                	neg    %edx
  10354e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103551:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103554:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10355b:	e9 a8 00 00 00       	jmp    103608 <vprintfmt+0x361>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103560:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103563:	89 44 24 04          	mov    %eax,0x4(%esp)
  103567:	8d 45 14             	lea    0x14(%ebp),%eax
  10356a:	89 04 24             	mov    %eax,(%esp)
  10356d:	e8 64 fc ff ff       	call   1031d6 <getuint>
  103572:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103575:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  103578:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10357f:	e9 84 00 00 00       	jmp    103608 <vprintfmt+0x361>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103584:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103587:	89 44 24 04          	mov    %eax,0x4(%esp)
  10358b:	8d 45 14             	lea    0x14(%ebp),%eax
  10358e:	89 04 24             	mov    %eax,(%esp)
  103591:	e8 40 fc ff ff       	call   1031d6 <getuint>
  103596:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103599:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10359c:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1035a3:	eb 63                	jmp    103608 <vprintfmt+0x361>

        // pointer
        case 'p':
            putch('0', putdat);
  1035a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035ac:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  1035b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b6:	ff d0                	call   *%eax
            putch('x', putdat);
  1035b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035bf:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  1035c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1035c9:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  1035cb:	8b 45 14             	mov    0x14(%ebp),%eax
  1035ce:	8d 50 04             	lea    0x4(%eax),%edx
  1035d1:	89 55 14             	mov    %edx,0x14(%ebp)
  1035d4:	8b 00                	mov    (%eax),%eax
  1035d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1035e0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1035e7:	eb 1f                	jmp    103608 <vprintfmt+0x361>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1035e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1035ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035f0:	8d 45 14             	lea    0x14(%ebp),%eax
  1035f3:	89 04 24             	mov    %eax,(%esp)
  1035f6:	e8 db fb ff ff       	call   1031d6 <getuint>
  1035fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103601:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103608:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10360c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10360f:	89 54 24 18          	mov    %edx,0x18(%esp)
  103613:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103616:	89 54 24 14          	mov    %edx,0x14(%esp)
  10361a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10361e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103621:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103624:	89 44 24 08          	mov    %eax,0x8(%esp)
  103628:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10362c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10362f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103633:	8b 45 08             	mov    0x8(%ebp),%eax
  103636:	89 04 24             	mov    %eax,(%esp)
  103639:	e8 94 fa ff ff       	call   1030d2 <printnum>
            break;
  10363e:	eb 38                	jmp    103678 <vprintfmt+0x3d1>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103640:	8b 45 0c             	mov    0xc(%ebp),%eax
  103643:	89 44 24 04          	mov    %eax,0x4(%esp)
  103647:	89 1c 24             	mov    %ebx,(%esp)
  10364a:	8b 45 08             	mov    0x8(%ebp),%eax
  10364d:	ff d0                	call   *%eax
            break;
  10364f:	eb 27                	jmp    103678 <vprintfmt+0x3d1>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103651:	8b 45 0c             	mov    0xc(%ebp),%eax
  103654:	89 44 24 04          	mov    %eax,0x4(%esp)
  103658:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  10365f:	8b 45 08             	mov    0x8(%ebp),%eax
  103662:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103664:	ff 4d 10             	decl   0x10(%ebp)
  103667:	eb 03                	jmp    10366c <vprintfmt+0x3c5>
  103669:	ff 4d 10             	decl   0x10(%ebp)
  10366c:	8b 45 10             	mov    0x10(%ebp),%eax
  10366f:	48                   	dec    %eax
  103670:	0f b6 00             	movzbl (%eax),%eax
  103673:	3c 25                	cmp    $0x25,%al
  103675:	75 f2                	jne    103669 <vprintfmt+0x3c2>
                /* do nothing */;
            break;
  103677:	90                   	nop
    while (1) {
  103678:	e9 36 fc ff ff       	jmp    1032b3 <vprintfmt+0xc>
                return;
  10367d:	90                   	nop
        }
    }
}
  10367e:	83 c4 40             	add    $0x40,%esp
  103681:	5b                   	pop    %ebx
  103682:	5e                   	pop    %esi
  103683:	5d                   	pop    %ebp
  103684:	c3                   	ret    

00103685 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103685:	f3 0f 1e fb          	endbr32 
  103689:	55                   	push   %ebp
  10368a:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10368c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10368f:	8b 40 08             	mov    0x8(%eax),%eax
  103692:	8d 50 01             	lea    0x1(%eax),%edx
  103695:	8b 45 0c             	mov    0xc(%ebp),%eax
  103698:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10369b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10369e:	8b 10                	mov    (%eax),%edx
  1036a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036a3:	8b 40 04             	mov    0x4(%eax),%eax
  1036a6:	39 c2                	cmp    %eax,%edx
  1036a8:	73 12                	jae    1036bc <sprintputch+0x37>
        *b->buf ++ = ch;
  1036aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036ad:	8b 00                	mov    (%eax),%eax
  1036af:	8d 48 01             	lea    0x1(%eax),%ecx
  1036b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  1036b5:	89 0a                	mov    %ecx,(%edx)
  1036b7:	8b 55 08             	mov    0x8(%ebp),%edx
  1036ba:	88 10                	mov    %dl,(%eax)
    }
}
  1036bc:	90                   	nop
  1036bd:	5d                   	pop    %ebp
  1036be:	c3                   	ret    

001036bf <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  1036bf:	f3 0f 1e fb          	endbr32 
  1036c3:	55                   	push   %ebp
  1036c4:	89 e5                	mov    %esp,%ebp
  1036c6:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  1036c9:	8d 45 14             	lea    0x14(%ebp),%eax
  1036cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  1036cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1036d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1036d6:	8b 45 10             	mov    0x10(%ebp),%eax
  1036d9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1036dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1036e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1036e4:	8b 45 08             	mov    0x8(%ebp),%eax
  1036e7:	89 04 24             	mov    %eax,(%esp)
  1036ea:	e8 08 00 00 00       	call   1036f7 <vsnprintf>
  1036ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1036f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1036f5:	c9                   	leave  
  1036f6:	c3                   	ret    

001036f7 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1036f7:	f3 0f 1e fb          	endbr32 
  1036fb:	55                   	push   %ebp
  1036fc:	89 e5                	mov    %esp,%ebp
  1036fe:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103701:	8b 45 08             	mov    0x8(%ebp),%eax
  103704:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103707:	8b 45 0c             	mov    0xc(%ebp),%eax
  10370a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10370d:	8b 45 08             	mov    0x8(%ebp),%eax
  103710:	01 d0                	add    %edx,%eax
  103712:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103715:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  10371c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103720:	74 0a                	je     10372c <vsnprintf+0x35>
  103722:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103725:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103728:	39 c2                	cmp    %eax,%edx
  10372a:	76 07                	jbe    103733 <vsnprintf+0x3c>
        return -E_INVAL;
  10372c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103731:	eb 2a                	jmp    10375d <vsnprintf+0x66>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103733:	8b 45 14             	mov    0x14(%ebp),%eax
  103736:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10373a:	8b 45 10             	mov    0x10(%ebp),%eax
  10373d:	89 44 24 08          	mov    %eax,0x8(%esp)
  103741:	8d 45 ec             	lea    -0x14(%ebp),%eax
  103744:	89 44 24 04          	mov    %eax,0x4(%esp)
  103748:	c7 04 24 85 36 10 00 	movl   $0x103685,(%esp)
  10374f:	e8 53 fb ff ff       	call   1032a7 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  103754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103757:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  10375a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10375d:	c9                   	leave  
  10375e:	c3                   	ret    
