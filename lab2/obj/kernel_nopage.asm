
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 70 11 40 	lgdtl  0x40117018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 02 00 00 00       	call   10002a <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>

0010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002a:	55                   	push   %ebp
  10002b:	89 e5                	mov    %esp,%ebp
  10002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100030:	ba 68 89 11 00       	mov    $0x118968,%edx
  100035:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  10003a:	29 c2                	sub    %eax,%edx
  10003c:	89 d0                	mov    %edx,%eax
  10003e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100049:	00 
  10004a:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  100051:	e8 83 5d 00 00       	call   105dd9 <memset>

    cons_init();                // init the console
  100056:	e8 78 15 00 00       	call   1015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005b:	c7 45 f4 80 5f 10 00 	movl   $0x105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100065:	89 44 24 04          	mov    %eax,0x4(%esp)
  100069:	c7 04 24 9c 5f 10 00 	movl   $0x105f9c,(%esp)
  100070:	e8 c7 02 00 00       	call   10033c <cprintf>

    print_kerninfo();
  100075:	e8 f6 07 00 00       	call   100870 <print_kerninfo>

    grade_backtrace();
  10007a:	e8 86 00 00 00       	call   100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10007f:	e8 4b 42 00 00       	call   1042cf <pmm_init>

    pic_init();                 // init interrupt controller
  100084:	e8 b3 16 00 00       	call   10173c <pic_init>
    idt_init();                 // init interrupt descriptor table
  100089:	e8 05 18 00 00       	call   101893 <idt_init>

    clock_init();               // init clock interrupt
  10008e:	e8 f6 0c 00 00       	call   100d89 <clock_init>
    intr_enable();              // enable irq interrupt
  100093:	e8 12 16 00 00       	call   1016aa <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  100098:	eb fe                	jmp    100098 <kern_init+0x6e>

0010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000a7:	00 
  1000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000af:	00 
  1000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000b7:	e8 ff 0b 00 00       	call   100cbb <mon_backtrace>
}
  1000bc:	c9                   	leave  
  1000bd:	c3                   	ret    

001000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000be:	55                   	push   %ebp
  1000bf:	89 e5                	mov    %esp,%ebp
  1000c1:	53                   	push   %ebx
  1000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cb:	8d 55 08             	lea    0x8(%ebp),%edx
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000dd:	89 04 24             	mov    %eax,(%esp)
  1000e0:	e8 b5 ff ff ff       	call   10009a <grade_backtrace2>
}
  1000e5:	83 c4 14             	add    $0x14,%esp
  1000e8:	5b                   	pop    %ebx
  1000e9:	5d                   	pop    %ebp
  1000ea:	c3                   	ret    

001000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000eb:	55                   	push   %ebp
  1000ec:	89 e5                	mov    %esp,%ebp
  1000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f1:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1000fb:	89 04 24             	mov    %eax,(%esp)
  1000fe:	e8 bb ff ff ff       	call   1000be <grade_backtrace1>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <grade_backtrace>:

void
grade_backtrace(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010b:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100117:	ff 
  100118:	89 44 24 04          	mov    %eax,0x4(%esp)
  10011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100123:	e8 c3 ff ff ff       	call   1000eb <grade_backtrace0>
}
  100128:	c9                   	leave  
  100129:	c3                   	ret    

0010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012a:	55                   	push   %ebp
  10012b:	89 e5                	mov    %esp,%ebp
  10012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 c0             	movzwl %ax,%eax
  100143:	83 e0 03             	and    $0x3,%eax
  100146:	89 c2                	mov    %eax,%edx
  100148:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10014d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100151:	89 44 24 04          	mov    %eax,0x4(%esp)
  100155:	c7 04 24 a1 5f 10 00 	movl   $0x105fa1,(%esp)
  10015c:	e8 db 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100165:	0f b7 d0             	movzwl %ax,%edx
  100168:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10016d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100171:	89 44 24 04          	mov    %eax,0x4(%esp)
  100175:	c7 04 24 af 5f 10 00 	movl   $0x105faf,(%esp)
  10017c:	e8 bb 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100185:	0f b7 d0             	movzwl %ax,%edx
  100188:	a1 40 7a 11 00       	mov    0x117a40,%eax
  10018d:	89 54 24 08          	mov    %edx,0x8(%esp)
  100191:	89 44 24 04          	mov    %eax,0x4(%esp)
  100195:	c7 04 24 bd 5f 10 00 	movl   $0x105fbd,(%esp)
  10019c:	e8 9b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a5:	0f b7 d0             	movzwl %ax,%edx
  1001a8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b5:	c7 04 24 cb 5f 10 00 	movl   $0x105fcb,(%esp)
  1001bc:	e8 7b 01 00 00       	call   10033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c5:	0f b7 d0             	movzwl %ax,%edx
  1001c8:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d5:	c7 04 24 d9 5f 10 00 	movl   $0x105fd9,(%esp)
  1001dc:	e8 5b 01 00 00       	call   10033c <cprintf>
    round ++;
  1001e1:	a1 40 7a 11 00       	mov    0x117a40,%eax
  1001e6:	83 c0 01             	add    $0x1,%eax
  1001e9:	a3 40 7a 11 00       	mov    %eax,0x117a40
}
  1001ee:	c9                   	leave  
  1001ef:	c3                   	ret    

001001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f0:	55                   	push   %ebp
  1001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f3:	5d                   	pop    %ebp
  1001f4:	c3                   	ret    

001001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f5:	55                   	push   %ebp
  1001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001f8:	5d                   	pop    %ebp
  1001f9:	c3                   	ret    

001001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fa:	55                   	push   %ebp
  1001fb:	89 e5                	mov    %esp,%ebp
  1001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100200:	e8 25 ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100205:	c7 04 24 e8 5f 10 00 	movl   $0x105fe8,(%esp)
  10020c:	e8 2b 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_user();
  100211:	e8 da ff ff ff       	call   1001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
  100216:	e8 0f ff ff ff       	call   10012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021b:	c7 04 24 08 60 10 00 	movl   $0x106008,(%esp)
  100222:	e8 15 01 00 00       	call   10033c <cprintf>
    lab1_switch_to_kernel();
  100227:	e8 c9 ff ff ff       	call   1001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  10022c:	e8 f9 fe ff ff       	call   10012a <lab1_print_cur_status>
}
  100231:	c9                   	leave  
  100232:	c3                   	ret    

00100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100233:	55                   	push   %ebp
  100234:	89 e5                	mov    %esp,%ebp
  100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10023d:	74 13                	je     100252 <readline+0x1f>
        cprintf("%s", prompt);
  10023f:	8b 45 08             	mov    0x8(%ebp),%eax
  100242:	89 44 24 04          	mov    %eax,0x4(%esp)
  100246:	c7 04 24 27 60 10 00 	movl   $0x106027,(%esp)
  10024d:	e8 ea 00 00 00       	call   10033c <cprintf>
    }
    int i = 0, c;
  100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100259:	e8 66 01 00 00       	call   1003c4 <getchar>
  10025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100265:	79 07                	jns    10026e <readline+0x3b>
            return NULL;
  100267:	b8 00 00 00 00       	mov    $0x0,%eax
  10026c:	eb 79                	jmp    1002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100272:	7e 28                	jle    10029c <readline+0x69>
  100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10027b:	7f 1f                	jg     10029c <readline+0x69>
            cputchar(c);
  10027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100280:	89 04 24             	mov    %eax,(%esp)
  100283:	e8 da 00 00 00       	call   100362 <cputchar>
            buf[i ++] = c;
  100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10028b:	8d 50 01             	lea    0x1(%eax),%edx
  10028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100294:	88 90 60 7a 11 00    	mov    %dl,0x117a60(%eax)
  10029a:	eb 46                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  10029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a0:	75 17                	jne    1002b9 <readline+0x86>
  1002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002a6:	7e 11                	jle    1002b9 <readline+0x86>
            cputchar(c);
  1002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ab:	89 04 24             	mov    %eax,(%esp)
  1002ae:	e8 af 00 00 00       	call   100362 <cputchar>
            i --;
  1002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002b7:	eb 29                	jmp    1002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  1002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002bd:	74 06                	je     1002c5 <readline+0x92>
  1002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002c3:	75 1d                	jne    1002e2 <readline+0xaf>
            cputchar(c);
  1002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 92 00 00 00       	call   100362 <cputchar>
            buf[i] = '\0';
  1002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002d3:	05 60 7a 11 00       	add    $0x117a60,%eax
  1002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002db:	b8 60 7a 11 00       	mov    $0x117a60,%eax
  1002e0:	eb 05                	jmp    1002e7 <readline+0xb4>
        }
    }
  1002e2:	e9 72 ff ff ff       	jmp    100259 <readline+0x26>
}
  1002e7:	c9                   	leave  
  1002e8:	c3                   	ret    

001002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002e9:	55                   	push   %ebp
  1002ea:	89 e5                	mov    %esp,%ebp
  1002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f2:	89 04 24             	mov    %eax,(%esp)
  1002f5:	e8 05 13 00 00       	call   1015ff <cons_putc>
    (*cnt) ++;
  1002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002fd:	8b 00                	mov    (%eax),%eax
  1002ff:	8d 50 01             	lea    0x1(%eax),%edx
  100302:	8b 45 0c             	mov    0xc(%ebp),%eax
  100305:	89 10                	mov    %edx,(%eax)
}
  100307:	c9                   	leave  
  100308:	c3                   	ret    

00100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100309:	55                   	push   %ebp
  10030a:	89 e5                	mov    %esp,%ebp
  10030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100316:	8b 45 0c             	mov    0xc(%ebp),%eax
  100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10031d:	8b 45 08             	mov    0x8(%ebp),%eax
  100320:	89 44 24 08          	mov    %eax,0x8(%esp)
  100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100327:	89 44 24 04          	mov    %eax,0x4(%esp)
  10032b:	c7 04 24 e9 02 10 00 	movl   $0x1002e9,(%esp)
  100332:	e8 bb 52 00 00       	call   1055f2 <vprintfmt>
    return cnt;
  100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10033a:	c9                   	leave  
  10033b:	c3                   	ret    

0010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10033c:	55                   	push   %ebp
  10033d:	89 e5                	mov    %esp,%ebp
  10033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100342:	8d 45 0c             	lea    0xc(%ebp),%eax
  100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10034b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10034f:	8b 45 08             	mov    0x8(%ebp),%eax
  100352:	89 04 24             	mov    %eax,(%esp)
  100355:	e8 af ff ff ff       	call   100309 <vcprintf>
  10035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100360:	c9                   	leave  
  100361:	c3                   	ret    

00100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100362:	55                   	push   %ebp
  100363:	89 e5                	mov    %esp,%ebp
  100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100368:	8b 45 08             	mov    0x8(%ebp),%eax
  10036b:	89 04 24             	mov    %eax,(%esp)
  10036e:	e8 8c 12 00 00       	call   1015ff <cons_putc>
}
  100373:	c9                   	leave  
  100374:	c3                   	ret    

00100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100375:	55                   	push   %ebp
  100376:	89 e5                	mov    %esp,%ebp
  100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100382:	eb 13                	jmp    100397 <cputs+0x22>
        cputch(c, &cnt);
  100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
  10038b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10038f:	89 04 24             	mov    %eax,(%esp)
  100392:	e8 52 ff ff ff       	call   1002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  100397:	8b 45 08             	mov    0x8(%ebp),%eax
  10039a:	8d 50 01             	lea    0x1(%eax),%edx
  10039d:	89 55 08             	mov    %edx,0x8(%ebp)
  1003a0:	0f b6 00             	movzbl (%eax),%eax
  1003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003aa:	75 d8                	jne    100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003af:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ba:	e8 2a ff ff ff       	call   1002e9 <cputch>
    return cnt;
  1003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003c2:	c9                   	leave  
  1003c3:	c3                   	ret    

001003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003c4:	55                   	push   %ebp
  1003c5:	89 e5                	mov    %esp,%ebp
  1003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003ca:	e8 6c 12 00 00       	call   10163b <cons_getc>
  1003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003d6:	74 f2                	je     1003ca <getchar+0x6>
        /* do nothing */;
    return c;
  1003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003db:	c9                   	leave  
  1003dc:	c3                   	ret    

001003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003dd:	55                   	push   %ebp
  1003de:	89 e5                	mov    %esp,%ebp
  1003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e6:	8b 00                	mov    (%eax),%eax
  1003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1003ee:	8b 00                	mov    (%eax),%eax
  1003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003fa:	e9 d2 00 00 00       	jmp    1004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100405:	01 d0                	add    %edx,%eax
  100407:	89 c2                	mov    %eax,%edx
  100409:	c1 ea 1f             	shr    $0x1f,%edx
  10040c:	01 d0                	add    %edx,%eax
  10040e:	d1 f8                	sar    %eax
  100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100419:	eb 04                	jmp    10041f <stab_binsearch+0x42>
            m --;
  10041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100425:	7c 1f                	jl     100446 <stab_binsearch+0x69>
  100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10042a:	89 d0                	mov    %edx,%eax
  10042c:	01 c0                	add    %eax,%eax
  10042e:	01 d0                	add    %edx,%eax
  100430:	c1 e0 02             	shl    $0x2,%eax
  100433:	89 c2                	mov    %eax,%edx
  100435:	8b 45 08             	mov    0x8(%ebp),%eax
  100438:	01 d0                	add    %edx,%eax
  10043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10043e:	0f b6 c0             	movzbl %al,%eax
  100441:	3b 45 14             	cmp    0x14(%ebp),%eax
  100444:	75 d5                	jne    10041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10044c:	7d 0b                	jge    100459 <stab_binsearch+0x7c>
            l = true_m + 1;
  10044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100451:	83 c0 01             	add    $0x1,%eax
  100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100457:	eb 78                	jmp    1004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100463:	89 d0                	mov    %edx,%eax
  100465:	01 c0                	add    %eax,%eax
  100467:	01 d0                	add    %edx,%eax
  100469:	c1 e0 02             	shl    $0x2,%eax
  10046c:	89 c2                	mov    %eax,%edx
  10046e:	8b 45 08             	mov    0x8(%ebp),%eax
  100471:	01 d0                	add    %edx,%eax
  100473:	8b 40 08             	mov    0x8(%eax),%eax
  100476:	3b 45 18             	cmp    0x18(%ebp),%eax
  100479:	73 13                	jae    10048e <stab_binsearch+0xb1>
            *region_left = m;
  10047b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100486:	83 c0 01             	add    $0x1,%eax
  100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10048c:	eb 43                	jmp    1004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  10048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100491:	89 d0                	mov    %edx,%eax
  100493:	01 c0                	add    %eax,%eax
  100495:	01 d0                	add    %edx,%eax
  100497:	c1 e0 02             	shl    $0x2,%eax
  10049a:	89 c2                	mov    %eax,%edx
  10049c:	8b 45 08             	mov    0x8(%ebp),%eax
  10049f:	01 d0                	add    %edx,%eax
  1004a1:	8b 40 08             	mov    0x8(%eax),%eax
  1004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004a7:	76 16                	jbe    1004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
  1004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004af:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b7:	83 e8 01             	sub    $0x1,%eax
  1004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004bd:	eb 12                	jmp    1004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004c5:	89 10                	mov    %edx,(%eax)
            l = m;
  1004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004d7:	0f 8e 22 ff ff ff    	jle    1003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e1:	75 0f                	jne    1004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e6:	8b 00                	mov    (%eax),%eax
  1004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1004ee:	89 10                	mov    %edx,(%eax)
  1004f0:	eb 3f                	jmp    100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	8b 00                	mov    (%eax),%eax
  1004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004fa:	eb 04                	jmp    100500 <stab_binsearch+0x123>
  1004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100500:	8b 45 0c             	mov    0xc(%ebp),%eax
  100503:	8b 00                	mov    (%eax),%eax
  100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100508:	7d 1f                	jge    100529 <stab_binsearch+0x14c>
  10050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10050d:	89 d0                	mov    %edx,%eax
  10050f:	01 c0                	add    %eax,%eax
  100511:	01 d0                	add    %edx,%eax
  100513:	c1 e0 02             	shl    $0x2,%eax
  100516:	89 c2                	mov    %eax,%edx
  100518:	8b 45 08             	mov    0x8(%ebp),%eax
  10051b:	01 d0                	add    %edx,%eax
  10051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100521:	0f b6 c0             	movzbl %al,%eax
  100524:	3b 45 14             	cmp    0x14(%ebp),%eax
  100527:	75 d3                	jne    1004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  100529:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  10052f:	89 10                	mov    %edx,(%eax)
    }
}
  100531:	c9                   	leave  
  100532:	c3                   	ret    

00100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100533:	55                   	push   %ebp
  100534:	89 e5                	mov    %esp,%ebp
  100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  100539:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053c:	c7 00 2c 60 10 00    	movl   $0x10602c,(%eax)
    info->eip_line = 0;
  100542:	8b 45 0c             	mov    0xc(%ebp),%eax
  100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10054f:	c7 40 08 2c 60 10 00 	movl   $0x10602c,0x8(%eax)
    info->eip_fn_namelen = 9;
  100556:	8b 45 0c             	mov    0xc(%ebp),%eax
  100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100560:	8b 45 0c             	mov    0xc(%ebp),%eax
  100563:	8b 55 08             	mov    0x8(%ebp),%edx
  100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100569:	8b 45 0c             	mov    0xc(%ebp),%eax
  10056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100573:	c7 45 f4 58 72 10 00 	movl   $0x107258,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057a:	c7 45 f0 48 1e 11 00 	movl   $0x111e48,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100581:	c7 45 ec 49 1e 11 00 	movl   $0x111e49,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100588:	c7 45 e8 a2 48 11 00 	movl   $0x1148a2,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100595:	76 0d                	jbe    1005a4 <debuginfo_eip+0x71>
  100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059a:	83 e8 01             	sub    $0x1,%eax
  10059d:	0f b6 00             	movzbl (%eax),%eax
  1005a0:	84 c0                	test   %al,%al
  1005a2:	74 0a                	je     1005ae <debuginfo_eip+0x7b>
        return -1;
  1005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005a9:	e9 c0 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bb:	29 c2                	sub    %eax,%edx
  1005bd:	89 d0                	mov    %edx,%eax
  1005bf:	c1 f8 02             	sar    $0x2,%eax
  1005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005c8:	83 e8 01             	sub    $0x1,%eax
  1005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005dc:	00 
  1005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005ee:	89 04 24             	mov    %eax,(%esp)
  1005f1:	e8 e7 fd ff ff       	call   1003dd <stab_binsearch>
    if (lfile == 0)
  1005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f9:	85 c0                	test   %eax,%eax
  1005fb:	75 0a                	jne    100607 <debuginfo_eip+0xd4>
        return -1;
  1005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100602:	e9 67 02 00 00       	jmp    10086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  10060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100613:	8b 45 08             	mov    0x8(%ebp),%eax
  100616:	89 44 24 10          	mov    %eax,0x10(%esp)
  10061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100621:	00 
  100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
  100625:	89 44 24 08          	mov    %eax,0x8(%esp)
  100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
  10062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100633:	89 04 24             	mov    %eax,(%esp)
  100636:	e8 a2 fd ff ff       	call   1003dd <stab_binsearch>

    if (lfun <= rfun) {
  10063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100641:	39 c2                	cmp    %eax,%edx
  100643:	7f 7c                	jg     1006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100648:	89 c2                	mov    %eax,%edx
  10064a:	89 d0                	mov    %edx,%eax
  10064c:	01 c0                	add    %eax,%eax
  10064e:	01 d0                	add    %edx,%eax
  100650:	c1 e0 02             	shl    $0x2,%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100658:	01 d0                	add    %edx,%eax
  10065a:	8b 10                	mov    (%eax),%edx
  10065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100662:	29 c1                	sub    %eax,%ecx
  100664:	89 c8                	mov    %ecx,%eax
  100666:	39 c2                	cmp    %eax,%edx
  100668:	73 22                	jae    10068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10066d:	89 c2                	mov    %eax,%edx
  10066f:	89 d0                	mov    %edx,%eax
  100671:	01 c0                	add    %eax,%eax
  100673:	01 d0                	add    %edx,%eax
  100675:	c1 e0 02             	shl    $0x2,%eax
  100678:	89 c2                	mov    %eax,%edx
  10067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10067d:	01 d0                	add    %edx,%eax
  10067f:	8b 10                	mov    (%eax),%edx
  100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100684:	01 c2                	add    %eax,%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	89 c2                	mov    %eax,%edx
  10069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10069f:	01 d0                	add    %edx,%eax
  1006a1:	8b 50 08             	mov    0x8(%eax),%edx
  1006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ad:	8b 40 10             	mov    0x10(%eax),%eax
  1006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bf:	eb 15                	jmp    1006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c4:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d9:	8b 40 08             	mov    0x8(%eax),%eax
  1006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006e3:	00 
  1006e4:	89 04 24             	mov    %eax,(%esp)
  1006e7:	e8 61 55 00 00       	call   105c4d <strfind>
  1006ec:	89 c2                	mov    %eax,%edx
  1006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f1:	8b 40 08             	mov    0x8(%eax),%eax
  1006f4:	29 c2                	sub    %eax,%edx
  1006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
  100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  10070a:	00 
  10070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100715:	89 44 24 04          	mov    %eax,0x4(%esp)
  100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10071c:	89 04 24             	mov    %eax,(%esp)
  10071f:	e8 b9 fc ff ff       	call   1003dd <stab_binsearch>
    if (lline <= rline) {
  100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072a:	39 c2                	cmp    %eax,%edx
  10072c:	7f 24                	jg     100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  10072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100731:	89 c2                	mov    %eax,%edx
  100733:	89 d0                	mov    %edx,%eax
  100735:	01 c0                	add    %eax,%eax
  100737:	01 d0                	add    %edx,%eax
  100739:	c1 e0 02             	shl    $0x2,%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100741:	01 d0                	add    %edx,%eax
  100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100747:	0f b7 d0             	movzwl %ax,%edx
  10074a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100750:	eb 13                	jmp    100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100757:	e9 12 01 00 00       	jmp    10086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10075f:	83 e8 01             	sub    $0x1,%eax
  100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10076b:	39 c2                	cmp    %eax,%edx
  10076d:	7c 56                	jl     1007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  10076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100772:	89 c2                	mov    %eax,%edx
  100774:	89 d0                	mov    %edx,%eax
  100776:	01 c0                	add    %eax,%eax
  100778:	01 d0                	add    %edx,%eax
  10077a:	c1 e0 02             	shl    $0x2,%eax
  10077d:	89 c2                	mov    %eax,%edx
  10077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100782:	01 d0                	add    %edx,%eax
  100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100788:	3c 84                	cmp    $0x84,%al
  10078a:	74 39                	je     1007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  10078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10078f:	89 c2                	mov    %eax,%edx
  100791:	89 d0                	mov    %edx,%eax
  100793:	01 c0                	add    %eax,%eax
  100795:	01 d0                	add    %edx,%eax
  100797:	c1 e0 02             	shl    $0x2,%eax
  10079a:	89 c2                	mov    %eax,%edx
  10079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10079f:	01 d0                	add    %edx,%eax
  1007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1007a5:	3c 64                	cmp    $0x64,%al
  1007a7:	75 b3                	jne    10075c <debuginfo_eip+0x229>
  1007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007ac:	89 c2                	mov    %eax,%edx
  1007ae:	89 d0                	mov    %edx,%eax
  1007b0:	01 c0                	add    %eax,%eax
  1007b2:	01 d0                	add    %edx,%eax
  1007b4:	c1 e0 02             	shl    $0x2,%eax
  1007b7:	89 c2                	mov    %eax,%edx
  1007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007bc:	01 d0                	add    %edx,%eax
  1007be:	8b 40 08             	mov    0x8(%eax),%eax
  1007c1:	85 c0                	test   %eax,%eax
  1007c3:	74 97                	je     10075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007cb:	39 c2                	cmp    %eax,%edx
  1007cd:	7c 46                	jl     100815 <debuginfo_eip+0x2e2>
  1007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007d2:	89 c2                	mov    %eax,%edx
  1007d4:	89 d0                	mov    %edx,%eax
  1007d6:	01 c0                	add    %eax,%eax
  1007d8:	01 d0                	add    %edx,%eax
  1007da:	c1 e0 02             	shl    $0x2,%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007e2:	01 d0                	add    %edx,%eax
  1007e4:	8b 10                	mov    (%eax),%edx
  1007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007ec:	29 c1                	sub    %eax,%ecx
  1007ee:	89 c8                	mov    %ecx,%eax
  1007f0:	39 c2                	cmp    %eax,%edx
  1007f2:	73 21                	jae    100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007f7:	89 c2                	mov    %eax,%edx
  1007f9:	89 d0                	mov    %edx,%eax
  1007fb:	01 c0                	add    %eax,%eax
  1007fd:	01 d0                	add    %edx,%eax
  1007ff:	c1 e0 02             	shl    $0x2,%eax
  100802:	89 c2                	mov    %eax,%edx
  100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100807:	01 d0                	add    %edx,%eax
  100809:	8b 10                	mov    (%eax),%edx
  10080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10080e:	01 c2                	add    %eax,%edx
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10081b:	39 c2                	cmp    %eax,%edx
  10081d:	7d 4a                	jge    100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  10081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  100828:	eb 18                	jmp    100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  10082a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10082d:	8b 40 14             	mov    0x14(%eax),%eax
  100830:	8d 50 01             	lea    0x1(%eax),%edx
  100833:	8b 45 0c             	mov    0xc(%ebp),%eax
  100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083c:	83 c0 01             	add    $0x1,%eax
  10083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  100848:	39 c2                	cmp    %eax,%edx
  10084a:	7d 1d                	jge    100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10084f:	89 c2                	mov    %eax,%edx
  100851:	89 d0                	mov    %edx,%eax
  100853:	01 c0                	add    %eax,%eax
  100855:	01 d0                	add    %edx,%eax
  100857:	c1 e0 02             	shl    $0x2,%eax
  10085a:	89 c2                	mov    %eax,%edx
  10085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10085f:	01 d0                	add    %edx,%eax
  100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100865:	3c a0                	cmp    $0xa0,%al
  100867:	74 c1                	je     10082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10086e:	c9                   	leave  
  10086f:	c3                   	ret    

00100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100870:	55                   	push   %ebp
  100871:	89 e5                	mov    %esp,%ebp
  100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100876:	c7 04 24 36 60 10 00 	movl   $0x106036,(%esp)
  10087d:	e8 ba fa ff ff       	call   10033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100882:	c7 44 24 04 2a 00 10 	movl   $0x10002a,0x4(%esp)
  100889:	00 
  10088a:	c7 04 24 4f 60 10 00 	movl   $0x10604f,(%esp)
  100891:	e8 a6 fa ff ff       	call   10033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100896:	c7 44 24 04 62 5f 10 	movl   $0x105f62,0x4(%esp)
  10089d:	00 
  10089e:	c7 04 24 67 60 10 00 	movl   $0x106067,(%esp)
  1008a5:	e8 92 fa ff ff       	call   10033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  1008aa:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  1008b1:	00 
  1008b2:	c7 04 24 7f 60 10 00 	movl   $0x10607f,(%esp)
  1008b9:	e8 7e fa ff ff       	call   10033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008be:	c7 44 24 04 68 89 11 	movl   $0x118968,0x4(%esp)
  1008c5:	00 
  1008c6:	c7 04 24 97 60 10 00 	movl   $0x106097,(%esp)
  1008cd:	e8 6a fa ff ff       	call   10033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008d2:	b8 68 89 11 00       	mov    $0x118968,%eax
  1008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008dd:	b8 2a 00 10 00       	mov    $0x10002a,%eax
  1008e2:	29 c2                	sub    %eax,%edx
  1008e4:	89 d0                	mov    %edx,%eax
  1008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008ec:	85 c0                	test   %eax,%eax
  1008ee:	0f 48 c2             	cmovs  %edx,%eax
  1008f1:	c1 f8 0a             	sar    $0xa,%eax
  1008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008f8:	c7 04 24 b0 60 10 00 	movl   $0x1060b0,(%esp)
  1008ff:	e8 38 fa ff ff       	call   10033c <cprintf>
}
  100904:	c9                   	leave  
  100905:	c3                   	ret    

00100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  100906:	55                   	push   %ebp
  100907:	89 e5                	mov    %esp,%ebp
  100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  10090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100912:	89 44 24 04          	mov    %eax,0x4(%esp)
  100916:	8b 45 08             	mov    0x8(%ebp),%eax
  100919:	89 04 24             	mov    %eax,(%esp)
  10091c:	e8 12 fc ff ff       	call   100533 <debuginfo_eip>
  100921:	85 c0                	test   %eax,%eax
  100923:	74 15                	je     10093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  100925:	8b 45 08             	mov    0x8(%ebp),%eax
  100928:	89 44 24 04          	mov    %eax,0x4(%esp)
  10092c:	c7 04 24 da 60 10 00 	movl   $0x1060da,(%esp)
  100933:	e8 04 fa ff ff       	call   10033c <cprintf>
  100938:	eb 6d                	jmp    1009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100941:	eb 1c                	jmp    10095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100949:	01 d0                	add    %edx,%eax
  10094b:	0f b6 00             	movzbl (%eax),%eax
  10094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100957:	01 ca                	add    %ecx,%edx
  100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  10095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  100965:	7f dc                	jg     100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  10096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100970:	01 d0                	add    %edx,%eax
  100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100978:	8b 55 08             	mov    0x8(%ebp),%edx
  10097b:	89 d1                	mov    %edx,%ecx
  10097d:	29 c1                	sub    %eax,%ecx
  10097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100993:	89 54 24 08          	mov    %edx,0x8(%esp)
  100997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099b:	c7 04 24 f6 60 10 00 	movl   $0x1060f6,(%esp)
  1009a2:	e8 95 f9 ff ff       	call   10033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  1009af:	8b 45 04             	mov    0x4(%ebp),%eax
  1009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  1009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1009b8:	c9                   	leave  
  1009b9:	c3                   	ret    

001009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009ba:	55                   	push   %ebp
  1009bb:	89 e5                	mov    %esp,%ebp
  1009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009c0:	89 e8                	mov    %ebp,%eax
  1009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  1009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009cb:	e8 d9 ff ff ff       	call   1009a9 <read_eip>
  1009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j = 0;
  1009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
  1009da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009e1:	e9 88 00 00 00       	jmp    100a6e <print_stackframe+0xb4>
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
  1009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009e9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f4:	c7 04 24 08 61 10 00 	movl   $0x106108,(%esp)
  1009fb:	e8 3c f9 ff ff       	call   10033c <cprintf>
		uint32_t* arguments = (uint32_t*)ebp + 2;
  100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a03:	83 c0 08             	add    $0x8,%eax
  100a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j < 4;j++)
  100a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  100a10:	eb 25                	jmp    100a37 <print_stackframe+0x7d>
			cprintf("0x%08x ",arguments[j]);
  100a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a1f:	01 d0                	add    %edx,%eax
  100a21:	8b 00                	mov    (%eax),%eax
  100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a27:	c7 04 24 25 61 10 00 	movl   $0x106125,(%esp)
  100a2e:	e8 09 f9 ff ff       	call   10033c <cprintf>
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
		uint32_t* arguments = (uint32_t*)ebp + 2;
		for(j = 0;j < 4;j++)
  100a33:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a37:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a3b:	7e d5                	jle    100a12 <print_stackframe+0x58>
			cprintf("0x%08x ",arguments[j]);
		cprintf("\n");
  100a3d:	c7 04 24 2d 61 10 00 	movl   $0x10612d,(%esp)
  100a44:	e8 f3 f8 ff ff       	call   10033c <cprintf>
		print_debuginfo(eip - 1);
  100a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a4c:	83 e8 01             	sub    $0x1,%eax
  100a4f:	89 04 24             	mov    %eax,(%esp)
  100a52:	e8 af fe ff ff       	call   100906 <print_debuginfo>
		eip = *((uint32_t*)ebp + 1);
  100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a5a:	83 c0 04             	add    $0x4,%eax
  100a5d:	8b 00                	mov    (%eax),%eax
  100a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
  100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a65:	8b 00                	mov    (%eax),%eax
  100a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
  100a6a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a6e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a72:	7f 0a                	jg     100a7e <print_stackframe+0xc4>
  100a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a78:	0f 85 68 ff ff ff    	jne    1009e6 <print_stackframe+0x2c>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)ebp + 1);
		ebp = *((uint32_t*)ebp);
	}
}
  100a7e:	c9                   	leave  
  100a7f:	c3                   	ret    

00100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a80:	55                   	push   %ebp
  100a81:	89 e5                	mov    %esp,%ebp
  100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a8d:	eb 0c                	jmp    100a9b <parse+0x1b>
            *buf ++ = '\0';
  100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  100a92:	8d 50 01             	lea    0x1(%eax),%edx
  100a95:	89 55 08             	mov    %edx,0x8(%ebp)
  100a98:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9e:	0f b6 00             	movzbl (%eax),%eax
  100aa1:	84 c0                	test   %al,%al
  100aa3:	74 1d                	je     100ac2 <parse+0x42>
  100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  100aa8:	0f b6 00             	movzbl (%eax),%eax
  100aab:	0f be c0             	movsbl %al,%eax
  100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab2:	c7 04 24 b0 61 10 00 	movl   $0x1061b0,(%esp)
  100ab9:	e8 5c 51 00 00       	call   105c1a <strchr>
  100abe:	85 c0                	test   %eax,%eax
  100ac0:	75 cd                	jne    100a8f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  100ac5:	0f b6 00             	movzbl (%eax),%eax
  100ac8:	84 c0                	test   %al,%al
  100aca:	75 02                	jne    100ace <parse+0x4e>
            break;
  100acc:	eb 67                	jmp    100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ad2:	75 14                	jne    100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100adb:	00 
  100adc:	c7 04 24 b5 61 10 00 	movl   $0x1061b5,(%esp)
  100ae3:	e8 54 f8 ff ff       	call   10033c <cprintf>
        }
        argv[argc ++] = buf;
  100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100aeb:	8d 50 01             	lea    0x1(%eax),%edx
  100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  100afb:	01 c2                	add    %eax,%edx
  100afd:	8b 45 08             	mov    0x8(%ebp),%eax
  100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b02:	eb 04                	jmp    100b08 <parse+0x88>
            buf ++;
  100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b08:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0b:	0f b6 00             	movzbl (%eax),%eax
  100b0e:	84 c0                	test   %al,%al
  100b10:	74 1d                	je     100b2f <parse+0xaf>
  100b12:	8b 45 08             	mov    0x8(%ebp),%eax
  100b15:	0f b6 00             	movzbl (%eax),%eax
  100b18:	0f be c0             	movsbl %al,%eax
  100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1f:	c7 04 24 b0 61 10 00 	movl   $0x1061b0,(%esp)
  100b26:	e8 ef 50 00 00       	call   105c1a <strchr>
  100b2b:	85 c0                	test   %eax,%eax
  100b2d:	74 d5                	je     100b04 <parse+0x84>
            buf ++;
        }
    }
  100b2f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b30:	e9 66 ff ff ff       	jmp    100a9b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b38:	c9                   	leave  
  100b39:	c3                   	ret    

00100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b3a:	55                   	push   %ebp
  100b3b:	89 e5                	mov    %esp,%ebp
  100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b47:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4a:	89 04 24             	mov    %eax,(%esp)
  100b4d:	e8 2e ff ff ff       	call   100a80 <parse>
  100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b59:	75 0a                	jne    100b65 <runcmd+0x2b>
        return 0;
  100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
  100b60:	e9 85 00 00 00       	jmp    100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b6c:	eb 5c                	jmp    100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b74:	89 d0                	mov    %edx,%eax
  100b76:	01 c0                	add    %eax,%eax
  100b78:	01 d0                	add    %edx,%eax
  100b7a:	c1 e0 02             	shl    $0x2,%eax
  100b7d:	05 20 70 11 00       	add    $0x117020,%eax
  100b82:	8b 00                	mov    (%eax),%eax
  100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b88:	89 04 24             	mov    %eax,(%esp)
  100b8b:	e8 eb 4f 00 00       	call   105b7b <strcmp>
  100b90:	85 c0                	test   %eax,%eax
  100b92:	75 32                	jne    100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b97:	89 d0                	mov    %edx,%eax
  100b99:	01 c0                	add    %eax,%eax
  100b9b:	01 d0                	add    %edx,%eax
  100b9d:	c1 e0 02             	shl    $0x2,%eax
  100ba0:	05 20 70 11 00       	add    $0x117020,%eax
  100ba5:	8b 40 08             	mov    0x8(%eax),%eax
  100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
  100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
  100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100bb8:	83 c2 04             	add    $0x4,%edx
  100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
  100bbf:	89 0c 24             	mov    %ecx,(%esp)
  100bc2:	ff d0                	call   *%eax
  100bc4:	eb 24                	jmp    100bea <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bcd:	83 f8 02             	cmp    $0x2,%eax
  100bd0:	76 9c                	jbe    100b6e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bd9:	c7 04 24 d3 61 10 00 	movl   $0x1061d3,(%esp)
  100be0:	e8 57 f7 ff ff       	call   10033c <cprintf>
    return 0;
  100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bea:	c9                   	leave  
  100beb:	c3                   	ret    

00100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bec:	55                   	push   %ebp
  100bed:	89 e5                	mov    %esp,%ebp
  100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bf2:	c7 04 24 ec 61 10 00 	movl   $0x1061ec,(%esp)
  100bf9:	e8 3e f7 ff ff       	call   10033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bfe:	c7 04 24 14 62 10 00 	movl   $0x106214,(%esp)
  100c05:	e8 32 f7 ff ff       	call   10033c <cprintf>

    if (tf != NULL) {
  100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c0e:	74 0b                	je     100c1b <kmonitor+0x2f>
        print_trapframe(tf);
  100c10:	8b 45 08             	mov    0x8(%ebp),%eax
  100c13:	89 04 24             	mov    %eax,(%esp)
  100c16:	e8 37 0e 00 00       	call   101a52 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c1b:	c7 04 24 39 62 10 00 	movl   $0x106239,(%esp)
  100c22:	e8 0c f6 ff ff       	call   100233 <readline>
  100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c2e:	74 18                	je     100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c30:	8b 45 08             	mov    0x8(%ebp),%eax
  100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c3a:	89 04 24             	mov    %eax,(%esp)
  100c3d:	e8 f8 fe ff ff       	call   100b3a <runcmd>
  100c42:	85 c0                	test   %eax,%eax
  100c44:	79 02                	jns    100c48 <kmonitor+0x5c>
                break;
  100c46:	eb 02                	jmp    100c4a <kmonitor+0x5e>
            }
        }
    }
  100c48:	eb d1                	jmp    100c1b <kmonitor+0x2f>
}
  100c4a:	c9                   	leave  
  100c4b:	c3                   	ret    

00100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c4c:	55                   	push   %ebp
  100c4d:	89 e5                	mov    %esp,%ebp
  100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c59:	eb 3f                	jmp    100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c5e:	89 d0                	mov    %edx,%eax
  100c60:	01 c0                	add    %eax,%eax
  100c62:	01 d0                	add    %edx,%eax
  100c64:	c1 e0 02             	shl    $0x2,%eax
  100c67:	05 20 70 11 00       	add    $0x117020,%eax
  100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
  100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c72:	89 d0                	mov    %edx,%eax
  100c74:	01 c0                	add    %eax,%eax
  100c76:	01 d0                	add    %edx,%eax
  100c78:	c1 e0 02             	shl    $0x2,%eax
  100c7b:	05 20 70 11 00       	add    $0x117020,%eax
  100c80:	8b 00                	mov    (%eax),%eax
  100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c8a:	c7 04 24 3d 62 10 00 	movl   $0x10623d,(%esp)
  100c91:	e8 a6 f6 ff ff       	call   10033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c9d:	83 f8 02             	cmp    $0x2,%eax
  100ca0:	76 b9                	jbe    100c5b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca7:	c9                   	leave  
  100ca8:	c3                   	ret    

00100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100ca9:	55                   	push   %ebp
  100caa:	89 e5                	mov    %esp,%ebp
  100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100caf:	e8 bc fb ff ff       	call   100870 <print_kerninfo>
    return 0;
  100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb9:	c9                   	leave  
  100cba:	c3                   	ret    

00100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100cc1:	e8 f4 fc ff ff       	call   1009ba <print_stackframe>
    return 0;
  100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ccb:	c9                   	leave  
  100ccc:	c3                   	ret    

00100ccd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ccd:	55                   	push   %ebp
  100cce:	89 e5                	mov    %esp,%ebp
  100cd0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cd3:	a1 60 7e 11 00       	mov    0x117e60,%eax
  100cd8:	85 c0                	test   %eax,%eax
  100cda:	74 02                	je     100cde <__panic+0x11>
        goto panic_dead;
  100cdc:	eb 48                	jmp    100d26 <__panic+0x59>
    }
    is_panic = 1;
  100cde:	c7 05 60 7e 11 00 01 	movl   $0x1,0x117e60
  100ce5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100ce8:	8d 45 14             	lea    0x14(%ebp),%eax
  100ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cfc:	c7 04 24 46 62 10 00 	movl   $0x106246,(%esp)
  100d03:	e8 34 f6 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  100d12:	89 04 24             	mov    %eax,(%esp)
  100d15:	e8 ef f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d1a:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
  100d21:	e8 16 f6 ff ff       	call   10033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d26:	e8 85 09 00 00       	call   1016b0 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d32:	e8 b5 fe ff ff       	call   100bec <kmonitor>
    }
  100d37:	eb f2                	jmp    100d2b <__panic+0x5e>

00100d39 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d39:	55                   	push   %ebp
  100d3a:	89 e5                	mov    %esp,%ebp
  100d3c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d3f:	8d 45 14             	lea    0x14(%ebp),%eax
  100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d48:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d53:	c7 04 24 64 62 10 00 	movl   $0x106264,(%esp)
  100d5a:	e8 dd f5 ff ff       	call   10033c <cprintf>
    vcprintf(fmt, ap);
  100d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d66:	8b 45 10             	mov    0x10(%ebp),%eax
  100d69:	89 04 24             	mov    %eax,(%esp)
  100d6c:	e8 98 f5 ff ff       	call   100309 <vcprintf>
    cprintf("\n");
  100d71:	c7 04 24 62 62 10 00 	movl   $0x106262,(%esp)
  100d78:	e8 bf f5 ff ff       	call   10033c <cprintf>
    va_end(ap);
}
  100d7d:	c9                   	leave  
  100d7e:	c3                   	ret    

00100d7f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d7f:	55                   	push   %ebp
  100d80:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d82:	a1 60 7e 11 00       	mov    0x117e60,%eax
}
  100d87:	5d                   	pop    %ebp
  100d88:	c3                   	ret    

00100d89 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d89:	55                   	push   %ebp
  100d8a:	89 e5                	mov    %esp,%ebp
  100d8c:	83 ec 28             	sub    $0x28,%esp
  100d8f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d95:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d99:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d9d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100da1:	ee                   	out    %al,(%dx)
  100da2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100da8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100dac:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100db0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100db4:	ee                   	out    %al,(%dx)
  100db5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100dbb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100dbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100dc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dc7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dc8:	c7 05 4c 89 11 00 00 	movl   $0x0,0x11894c
  100dcf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100dd2:	c7 04 24 82 62 10 00 	movl   $0x106282,(%esp)
  100dd9:	e8 5e f5 ff ff       	call   10033c <cprintf>
    pic_enable(IRQ_TIMER);
  100dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100de5:	e8 24 09 00 00       	call   10170e <pic_enable>
}
  100dea:	c9                   	leave  
  100deb:	c3                   	ret    

00100dec <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dec:	55                   	push   %ebp
  100ded:	89 e5                	mov    %esp,%ebp
  100def:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100df2:	9c                   	pushf  
  100df3:	58                   	pop    %eax
  100df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100dfa:	25 00 02 00 00       	and    $0x200,%eax
  100dff:	85 c0                	test   %eax,%eax
  100e01:	74 0c                	je     100e0f <__intr_save+0x23>
        intr_disable();
  100e03:	e8 a8 08 00 00       	call   1016b0 <intr_disable>
        return 1;
  100e08:	b8 01 00 00 00       	mov    $0x1,%eax
  100e0d:	eb 05                	jmp    100e14 <__intr_save+0x28>
    }
    return 0;
  100e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100e14:	c9                   	leave  
  100e15:	c3                   	ret    

00100e16 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100e16:	55                   	push   %ebp
  100e17:	89 e5                	mov    %esp,%ebp
  100e19:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e20:	74 05                	je     100e27 <__intr_restore+0x11>
        intr_enable();
  100e22:	e8 83 08 00 00       	call   1016aa <intr_enable>
    }
}
  100e27:	c9                   	leave  
  100e28:	c3                   	ret    

00100e29 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e29:	55                   	push   %ebp
  100e2a:	89 e5                	mov    %esp,%ebp
  100e2c:	83 ec 10             	sub    $0x10,%esp
  100e2f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e35:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e39:	89 c2                	mov    %eax,%edx
  100e3b:	ec                   	in     (%dx),%al
  100e3c:	88 45 fd             	mov    %al,-0x3(%ebp)
  100e3f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e45:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e49:	89 c2                	mov    %eax,%edx
  100e4b:	ec                   	in     (%dx),%al
  100e4c:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e4f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e55:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e59:	89 c2                	mov    %eax,%edx
  100e5b:	ec                   	in     (%dx),%al
  100e5c:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e5f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e69:	89 c2                	mov    %eax,%edx
  100e6b:	ec                   	in     (%dx),%al
  100e6c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e6f:	c9                   	leave  
  100e70:	c3                   	ret    

00100e71 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e71:	55                   	push   %ebp
  100e72:	89 e5                	mov    %esp,%ebp
  100e74:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e77:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e81:	0f b7 00             	movzwl (%eax),%eax
  100e84:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e8b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e93:	0f b7 00             	movzwl (%eax),%eax
  100e96:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e9a:	74 12                	je     100eae <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e9c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100ea3:	66 c7 05 86 7e 11 00 	movw   $0x3b4,0x117e86
  100eaa:	b4 03 
  100eac:	eb 13                	jmp    100ec1 <cga_init+0x50>
    } else {
        *cp = was;
  100eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100eb5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100eb8:	66 c7 05 86 7e 11 00 	movw   $0x3d4,0x117e86
  100ebf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ec1:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ec8:	0f b7 c0             	movzwl %ax,%eax
  100ecb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100ecf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ed3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100ed7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100edb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100edc:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100ee3:	83 c0 01             	add    $0x1,%eax
  100ee6:	0f b7 c0             	movzwl %ax,%eax
  100ee9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100eed:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100ef1:	89 c2                	mov    %eax,%edx
  100ef3:	ec                   	in     (%dx),%al
  100ef4:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ef7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100efb:	0f b6 c0             	movzbl %al,%eax
  100efe:	c1 e0 08             	shl    $0x8,%eax
  100f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100f04:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f0b:	0f b7 c0             	movzwl %ax,%eax
  100f0e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100f12:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f1f:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  100f26:	83 c0 01             	add    $0x1,%eax
  100f29:	0f b7 c0             	movzwl %ax,%eax
  100f2c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f30:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100f34:	89 c2                	mov    %eax,%edx
  100f36:	ec                   	in     (%dx),%al
  100f37:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100f3a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3e:	0f b6 c0             	movzbl %al,%eax
  100f41:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f47:	a3 80 7e 11 00       	mov    %eax,0x117e80
    crt_pos = pos;
  100f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f4f:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
}
  100f55:	c9                   	leave  
  100f56:	c3                   	ret    

00100f57 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f57:	55                   	push   %ebp
  100f58:	89 e5                	mov    %esp,%ebp
  100f5a:	83 ec 48             	sub    $0x48,%esp
  100f5d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f63:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f67:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f6b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f6f:	ee                   	out    %al,(%dx)
  100f70:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f76:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f7a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f82:	ee                   	out    %al,(%dx)
  100f83:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f89:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f8d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f91:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f95:	ee                   	out    %al,(%dx)
  100f96:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f9c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fa0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fa4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fa8:	ee                   	out    %al,(%dx)
  100fa9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100faf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fb3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fbb:	ee                   	out    %al,(%dx)
  100fbc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fc2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fc6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fca:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fce:	ee                   	out    %al,(%dx)
  100fcf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100fd5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100fd9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100fdd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100fe1:	ee                   	out    %al,(%dx)
  100fe2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fe8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100fec:	89 c2                	mov    %eax,%edx
  100fee:	ec                   	in     (%dx),%al
  100fef:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100ff2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100ff6:	3c ff                	cmp    $0xff,%al
  100ff8:	0f 95 c0             	setne  %al
  100ffb:	0f b6 c0             	movzbl %al,%eax
  100ffe:	a3 88 7e 11 00       	mov    %eax,0x117e88
  101003:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101009:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  10100d:	89 c2                	mov    %eax,%edx
  10100f:	ec                   	in     (%dx),%al
  101010:	88 45 d5             	mov    %al,-0x2b(%ebp)
  101013:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  101019:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  10101d:	89 c2                	mov    %eax,%edx
  10101f:	ec                   	in     (%dx),%al
  101020:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  101023:	a1 88 7e 11 00       	mov    0x117e88,%eax
  101028:	85 c0                	test   %eax,%eax
  10102a:	74 0c                	je     101038 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  10102c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  101033:	e8 d6 06 00 00       	call   10170e <pic_enable>
    }
}
  101038:	c9                   	leave  
  101039:	c3                   	ret    

0010103a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10103a:	55                   	push   %ebp
  10103b:	89 e5                	mov    %esp,%ebp
  10103d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101047:	eb 09                	jmp    101052 <lpt_putc_sub+0x18>
        delay();
  101049:	e8 db fd ff ff       	call   100e29 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10104e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101052:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101058:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10105c:	89 c2                	mov    %eax,%edx
  10105e:	ec                   	in     (%dx),%al
  10105f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101062:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101066:	84 c0                	test   %al,%al
  101068:	78 09                	js     101073 <lpt_putc_sub+0x39>
  10106a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101071:	7e d6                	jle    101049 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  101073:	8b 45 08             	mov    0x8(%ebp),%eax
  101076:	0f b6 c0             	movzbl %al,%eax
  101079:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  10107f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101082:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101086:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10108a:	ee                   	out    %al,(%dx)
  10108b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101091:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101095:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101099:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10109d:	ee                   	out    %al,(%dx)
  10109e:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010a4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  1010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010b0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010b1:	c9                   	leave  
  1010b2:	c3                   	ret    

001010b3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  1010b3:	55                   	push   %ebp
  1010b4:	89 e5                	mov    %esp,%ebp
  1010b6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010b9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010bd:	74 0d                	je     1010cc <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  1010c2:	89 04 24             	mov    %eax,(%esp)
  1010c5:	e8 70 ff ff ff       	call   10103a <lpt_putc_sub>
  1010ca:	eb 24                	jmp    1010f0 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  1010cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d3:	e8 62 ff ff ff       	call   10103a <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010df:	e8 56 ff ff ff       	call   10103a <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010eb:	e8 4a ff ff ff       	call   10103a <lpt_putc_sub>
    }
}
  1010f0:	c9                   	leave  
  1010f1:	c3                   	ret    

001010f2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010f2:	55                   	push   %ebp
  1010f3:	89 e5                	mov    %esp,%ebp
  1010f5:	53                   	push   %ebx
  1010f6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fc:	b0 00                	mov    $0x0,%al
  1010fe:	85 c0                	test   %eax,%eax
  101100:	75 07                	jne    101109 <cga_putc+0x17>
        c |= 0x0700;
  101102:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101109:	8b 45 08             	mov    0x8(%ebp),%eax
  10110c:	0f b6 c0             	movzbl %al,%eax
  10110f:	83 f8 0a             	cmp    $0xa,%eax
  101112:	74 4c                	je     101160 <cga_putc+0x6e>
  101114:	83 f8 0d             	cmp    $0xd,%eax
  101117:	74 57                	je     101170 <cga_putc+0x7e>
  101119:	83 f8 08             	cmp    $0x8,%eax
  10111c:	0f 85 88 00 00 00    	jne    1011aa <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  101122:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101129:	66 85 c0             	test   %ax,%ax
  10112c:	74 30                	je     10115e <cga_putc+0x6c>
            crt_pos --;
  10112e:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101135:	83 e8 01             	sub    $0x1,%eax
  101138:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10113e:	a1 80 7e 11 00       	mov    0x117e80,%eax
  101143:	0f b7 15 84 7e 11 00 	movzwl 0x117e84,%edx
  10114a:	0f b7 d2             	movzwl %dx,%edx
  10114d:	01 d2                	add    %edx,%edx
  10114f:	01 c2                	add    %eax,%edx
  101151:	8b 45 08             	mov    0x8(%ebp),%eax
  101154:	b0 00                	mov    $0x0,%al
  101156:	83 c8 20             	or     $0x20,%eax
  101159:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  10115c:	eb 72                	jmp    1011d0 <cga_putc+0xde>
  10115e:	eb 70                	jmp    1011d0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101160:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  101167:	83 c0 50             	add    $0x50,%eax
  10116a:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101170:	0f b7 1d 84 7e 11 00 	movzwl 0x117e84,%ebx
  101177:	0f b7 0d 84 7e 11 00 	movzwl 0x117e84,%ecx
  10117e:	0f b7 c1             	movzwl %cx,%eax
  101181:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101187:	c1 e8 10             	shr    $0x10,%eax
  10118a:	89 c2                	mov    %eax,%edx
  10118c:	66 c1 ea 06          	shr    $0x6,%dx
  101190:	89 d0                	mov    %edx,%eax
  101192:	c1 e0 02             	shl    $0x2,%eax
  101195:	01 d0                	add    %edx,%eax
  101197:	c1 e0 04             	shl    $0x4,%eax
  10119a:	29 c1                	sub    %eax,%ecx
  10119c:	89 ca                	mov    %ecx,%edx
  10119e:	89 d8                	mov    %ebx,%eax
  1011a0:	29 d0                	sub    %edx,%eax
  1011a2:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
        break;
  1011a8:	eb 26                	jmp    1011d0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011aa:	8b 0d 80 7e 11 00    	mov    0x117e80,%ecx
  1011b0:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011b7:	8d 50 01             	lea    0x1(%eax),%edx
  1011ba:	66 89 15 84 7e 11 00 	mov    %dx,0x117e84
  1011c1:	0f b7 c0             	movzwl %ax,%eax
  1011c4:	01 c0                	add    %eax,%eax
  1011c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1011cc:	66 89 02             	mov    %ax,(%edx)
        break;
  1011cf:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011d0:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1011d7:	66 3d cf 07          	cmp    $0x7cf,%ax
  1011db:	76 5b                	jbe    101238 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011dd:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e8:	a1 80 7e 11 00       	mov    0x117e80,%eax
  1011ed:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f4:	00 
  1011f5:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f9:	89 04 24             	mov    %eax,(%esp)
  1011fc:	e8 17 4c 00 00       	call   105e18 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101201:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101208:	eb 15                	jmp    10121f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  10120a:	a1 80 7e 11 00       	mov    0x117e80,%eax
  10120f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101212:	01 d2                	add    %edx,%edx
  101214:	01 d0                	add    %edx,%eax
  101216:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10121f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101226:	7e e2                	jle    10120a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  101228:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10122f:	83 e8 50             	sub    $0x50,%eax
  101232:	66 a3 84 7e 11 00    	mov    %ax,0x117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101238:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  10123f:	0f b7 c0             	movzwl %ax,%eax
  101242:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101246:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10124a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101252:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101253:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  10125a:	66 c1 e8 08          	shr    $0x8,%ax
  10125e:	0f b6 c0             	movzbl %al,%eax
  101261:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  101268:	83 c2 01             	add    $0x1,%edx
  10126b:	0f b7 d2             	movzwl %dx,%edx
  10126e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  101272:	88 45 ed             	mov    %al,-0x13(%ebp)
  101275:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101279:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10127d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127e:	0f b7 05 86 7e 11 00 	movzwl 0x117e86,%eax
  101285:	0f b7 c0             	movzwl %ax,%eax
  101288:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  10128c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101290:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101294:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101298:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101299:	0f b7 05 84 7e 11 00 	movzwl 0x117e84,%eax
  1012a0:	0f b6 c0             	movzbl %al,%eax
  1012a3:	0f b7 15 86 7e 11 00 	movzwl 0x117e86,%edx
  1012aa:	83 c2 01             	add    $0x1,%edx
  1012ad:	0f b7 d2             	movzwl %dx,%edx
  1012b0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  1012b4:	88 45 e5             	mov    %al,-0x1b(%ebp)
  1012b7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1012bb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1012bf:	ee                   	out    %al,(%dx)
}
  1012c0:	83 c4 34             	add    $0x34,%esp
  1012c3:	5b                   	pop    %ebx
  1012c4:	5d                   	pop    %ebp
  1012c5:	c3                   	ret    

001012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c6:	55                   	push   %ebp
  1012c7:	89 e5                	mov    %esp,%ebp
  1012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012d3:	eb 09                	jmp    1012de <serial_putc_sub+0x18>
        delay();
  1012d5:	e8 4f fb ff ff       	call   100e29 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1012de:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012e4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e8:	89 c2                	mov    %eax,%edx
  1012ea:	ec                   	in     (%dx),%al
  1012eb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012f2:	0f b6 c0             	movzbl %al,%eax
  1012f5:	83 e0 20             	and    $0x20,%eax
  1012f8:	85 c0                	test   %eax,%eax
  1012fa:	75 09                	jne    101305 <serial_putc_sub+0x3f>
  1012fc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101303:	7e d0                	jle    1012d5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101305:	8b 45 08             	mov    0x8(%ebp),%eax
  101308:	0f b6 c0             	movzbl %al,%eax
  10130b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101311:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101314:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101318:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10131c:	ee                   	out    %al,(%dx)
}
  10131d:	c9                   	leave  
  10131e:	c3                   	ret    

0010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10131f:	55                   	push   %ebp
  101320:	89 e5                	mov    %esp,%ebp
  101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101329:	74 0d                	je     101338 <serial_putc+0x19>
        serial_putc_sub(c);
  10132b:	8b 45 08             	mov    0x8(%ebp),%eax
  10132e:	89 04 24             	mov    %eax,(%esp)
  101331:	e8 90 ff ff ff       	call   1012c6 <serial_putc_sub>
  101336:	eb 24                	jmp    10135c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10133f:	e8 82 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub(' ');
  101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10134b:	e8 76 ff ff ff       	call   1012c6 <serial_putc_sub>
        serial_putc_sub('\b');
  101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101357:	e8 6a ff ff ff       	call   1012c6 <serial_putc_sub>
    }
}
  10135c:	c9                   	leave  
  10135d:	c3                   	ret    

0010135e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  10135e:	55                   	push   %ebp
  10135f:	89 e5                	mov    %esp,%ebp
  101361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  101364:	eb 33                	jmp    101399 <cons_intr+0x3b>
        if (c != 0) {
  101366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10136a:	74 2d                	je     101399 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  10136c:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101371:	8d 50 01             	lea    0x1(%eax),%edx
  101374:	89 15 a4 80 11 00    	mov    %edx,0x1180a4
  10137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10137d:	88 90 a0 7e 11 00    	mov    %dl,0x117ea0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  101383:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101388:	3d 00 02 00 00       	cmp    $0x200,%eax
  10138d:	75 0a                	jne    101399 <cons_intr+0x3b>
                cons.wpos = 0;
  10138f:	c7 05 a4 80 11 00 00 	movl   $0x0,0x1180a4
  101396:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101399:	8b 45 08             	mov    0x8(%ebp),%eax
  10139c:	ff d0                	call   *%eax
  10139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1013a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a5:	75 bf                	jne    101366 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  1013a7:	c9                   	leave  
  1013a8:	c3                   	ret    

001013a9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a9:	55                   	push   %ebp
  1013aa:	89 e5                	mov    %esp,%ebp
  1013ac:	83 ec 10             	sub    $0x10,%esp
  1013af:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b9:	89 c2                	mov    %eax,%edx
  1013bb:	ec                   	in     (%dx),%al
  1013bc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013bf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013c3:	0f b6 c0             	movzbl %al,%eax
  1013c6:	83 e0 01             	and    $0x1,%eax
  1013c9:	85 c0                	test   %eax,%eax
  1013cb:	75 07                	jne    1013d4 <serial_proc_data+0x2b>
        return -1;
  1013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013d2:	eb 2a                	jmp    1013fe <serial_proc_data+0x55>
  1013d4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013da:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013de:	89 c2                	mov    %eax,%edx
  1013e0:	ec                   	in     (%dx),%al
  1013e1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e8:	0f b6 c0             	movzbl %al,%eax
  1013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ee:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013f2:	75 07                	jne    1013fb <serial_proc_data+0x52>
        c = '\b';
  1013f4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fe:	c9                   	leave  
  1013ff:	c3                   	ret    

00101400 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101400:	55                   	push   %ebp
  101401:	89 e5                	mov    %esp,%ebp
  101403:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101406:	a1 88 7e 11 00       	mov    0x117e88,%eax
  10140b:	85 c0                	test   %eax,%eax
  10140d:	74 0c                	je     10141b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140f:	c7 04 24 a9 13 10 00 	movl   $0x1013a9,(%esp)
  101416:	e8 43 ff ff ff       	call   10135e <cons_intr>
    }
}
  10141b:	c9                   	leave  
  10141c:	c3                   	ret    

0010141d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141d:	55                   	push   %ebp
  10141e:	89 e5                	mov    %esp,%ebp
  101420:	83 ec 38             	sub    $0x38,%esp
  101423:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10142d:	89 c2                	mov    %eax,%edx
  10142f:	ec                   	in     (%dx),%al
  101430:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  101433:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101437:	0f b6 c0             	movzbl %al,%eax
  10143a:	83 e0 01             	and    $0x1,%eax
  10143d:	85 c0                	test   %eax,%eax
  10143f:	75 0a                	jne    10144b <kbd_proc_data+0x2e>
        return -1;
  101441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101446:	e9 59 01 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
  10144b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101451:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101455:	89 c2                	mov    %eax,%edx
  101457:	ec                   	in     (%dx),%al
  101458:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  10145b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  101462:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101466:	75 17                	jne    10147f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101468:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10146d:	83 c8 40             	or     $0x40,%eax
  101470:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  101475:	b8 00 00 00 00       	mov    $0x0,%eax
  10147a:	e9 25 01 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  10147f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101483:	84 c0                	test   %al,%al
  101485:	79 47                	jns    1014ce <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101487:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  10148c:	83 e0 40             	and    $0x40,%eax
  10148f:	85 c0                	test   %eax,%eax
  101491:	75 09                	jne    10149c <kbd_proc_data+0x7f>
  101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101497:	83 e0 7f             	and    $0x7f,%eax
  10149a:	eb 04                	jmp    1014a0 <kbd_proc_data+0x83>
  10149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  1014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a7:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014ae:	83 c8 40             	or     $0x40,%eax
  1014b1:	0f b6 c0             	movzbl %al,%eax
  1014b4:	f7 d0                	not    %eax
  1014b6:	89 c2                	mov    %eax,%edx
  1014b8:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014bd:	21 d0                	and    %edx,%eax
  1014bf:	a3 a8 80 11 00       	mov    %eax,0x1180a8
        return 0;
  1014c4:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c9:	e9 d6 00 00 00       	jmp    1015a4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  1014ce:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014d3:	83 e0 40             	and    $0x40,%eax
  1014d6:	85 c0                	test   %eax,%eax
  1014d8:	74 11                	je     1014eb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014da:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014de:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014e3:	83 e0 bf             	and    $0xffffffbf,%eax
  1014e6:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    }

    shift |= shiftcode[data];
  1014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014ef:	0f b6 80 60 70 11 00 	movzbl 0x117060(%eax),%eax
  1014f6:	0f b6 d0             	movzbl %al,%edx
  1014f9:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  1014fe:	09 d0                	or     %edx,%eax
  101500:	a3 a8 80 11 00       	mov    %eax,0x1180a8
    shift ^= togglecode[data];
  101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101509:	0f b6 80 60 71 11 00 	movzbl 0x117160(%eax),%eax
  101510:	0f b6 d0             	movzbl %al,%edx
  101513:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101518:	31 d0                	xor    %edx,%eax
  10151a:	a3 a8 80 11 00       	mov    %eax,0x1180a8

    c = charcode[shift & (CTL | SHIFT)][data];
  10151f:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101524:	83 e0 03             	and    $0x3,%eax
  101527:	8b 14 85 60 75 11 00 	mov    0x117560(,%eax,4),%edx
  10152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101532:	01 d0                	add    %edx,%eax
  101534:	0f b6 00             	movzbl (%eax),%eax
  101537:	0f b6 c0             	movzbl %al,%eax
  10153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  10153d:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101542:	83 e0 08             	and    $0x8,%eax
  101545:	85 c0                	test   %eax,%eax
  101547:	74 22                	je     10156b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  101549:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  10154d:	7e 0c                	jle    10155b <kbd_proc_data+0x13e>
  10154f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  101553:	7f 06                	jg     10155b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  101555:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101559:	eb 10                	jmp    10156b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  10155b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  10155f:	7e 0a                	jle    10156b <kbd_proc_data+0x14e>
  101561:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  101565:	7f 04                	jg     10156b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101567:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  10156b:	a1 a8 80 11 00       	mov    0x1180a8,%eax
  101570:	f7 d0                	not    %eax
  101572:	83 e0 06             	and    $0x6,%eax
  101575:	85 c0                	test   %eax,%eax
  101577:	75 28                	jne    1015a1 <kbd_proc_data+0x184>
  101579:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101580:	75 1f                	jne    1015a1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  101582:	c7 04 24 9d 62 10 00 	movl   $0x10629d,(%esp)
  101589:	e8 ae ed ff ff       	call   10033c <cprintf>
  10158e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101594:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101598:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  10159c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  1015a0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  1015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1015a4:	c9                   	leave  
  1015a5:	c3                   	ret    

001015a6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  1015a6:	55                   	push   %ebp
  1015a7:	89 e5                	mov    %esp,%ebp
  1015a9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015ac:	c7 04 24 1d 14 10 00 	movl   $0x10141d,(%esp)
  1015b3:	e8 a6 fd ff ff       	call   10135e <cons_intr>
}
  1015b8:	c9                   	leave  
  1015b9:	c3                   	ret    

001015ba <kbd_init>:

static void
kbd_init(void) {
  1015ba:	55                   	push   %ebp
  1015bb:	89 e5                	mov    %esp,%ebp
  1015bd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015c0:	e8 e1 ff ff ff       	call   1015a6 <kbd_intr>
    pic_enable(IRQ_KBD);
  1015c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015cc:	e8 3d 01 00 00       	call   10170e <pic_enable>
}
  1015d1:	c9                   	leave  
  1015d2:	c3                   	ret    

001015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015d3:	55                   	push   %ebp
  1015d4:	89 e5                	mov    %esp,%ebp
  1015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d9:	e8 93 f8 ff ff       	call   100e71 <cga_init>
    serial_init();
  1015de:	e8 74 f9 ff ff       	call   100f57 <serial_init>
    kbd_init();
  1015e3:	e8 d2 ff ff ff       	call   1015ba <kbd_init>
    if (!serial_exists) {
  1015e8:	a1 88 7e 11 00       	mov    0x117e88,%eax
  1015ed:	85 c0                	test   %eax,%eax
  1015ef:	75 0c                	jne    1015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015f1:	c7 04 24 a9 62 10 00 	movl   $0x1062a9,(%esp)
  1015f8:	e8 3f ed ff ff       	call   10033c <cprintf>
    }
}
  1015fd:	c9                   	leave  
  1015fe:	c3                   	ret    

001015ff <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015ff:	55                   	push   %ebp
  101600:	89 e5                	mov    %esp,%ebp
  101602:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101605:	e8 e2 f7 ff ff       	call   100dec <__intr_save>
  10160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  10160d:	8b 45 08             	mov    0x8(%ebp),%eax
  101610:	89 04 24             	mov    %eax,(%esp)
  101613:	e8 9b fa ff ff       	call   1010b3 <lpt_putc>
        cga_putc(c);
  101618:	8b 45 08             	mov    0x8(%ebp),%eax
  10161b:	89 04 24             	mov    %eax,(%esp)
  10161e:	e8 cf fa ff ff       	call   1010f2 <cga_putc>
        serial_putc(c);
  101623:	8b 45 08             	mov    0x8(%ebp),%eax
  101626:	89 04 24             	mov    %eax,(%esp)
  101629:	e8 f1 fc ff ff       	call   10131f <serial_putc>
    }
    local_intr_restore(intr_flag);
  10162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101631:	89 04 24             	mov    %eax,(%esp)
  101634:	e8 dd f7 ff ff       	call   100e16 <__intr_restore>
}
  101639:	c9                   	leave  
  10163a:	c3                   	ret    

0010163b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  10163b:	55                   	push   %ebp
  10163c:	89 e5                	mov    %esp,%ebp
  10163e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  101641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101648:	e8 9f f7 ff ff       	call   100dec <__intr_save>
  10164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  101650:	e8 ab fd ff ff       	call   101400 <serial_intr>
        kbd_intr();
  101655:	e8 4c ff ff ff       	call   1015a6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  10165a:	8b 15 a0 80 11 00    	mov    0x1180a0,%edx
  101660:	a1 a4 80 11 00       	mov    0x1180a4,%eax
  101665:	39 c2                	cmp    %eax,%edx
  101667:	74 31                	je     10169a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101669:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  10166e:	8d 50 01             	lea    0x1(%eax),%edx
  101671:	89 15 a0 80 11 00    	mov    %edx,0x1180a0
  101677:	0f b6 80 a0 7e 11 00 	movzbl 0x117ea0(%eax),%eax
  10167e:	0f b6 c0             	movzbl %al,%eax
  101681:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101684:	a1 a0 80 11 00       	mov    0x1180a0,%eax
  101689:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168e:	75 0a                	jne    10169a <cons_getc+0x5f>
                cons.rpos = 0;
  101690:	c7 05 a0 80 11 00 00 	movl   $0x0,0x1180a0
  101697:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  10169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10169d:	89 04 24             	mov    %eax,(%esp)
  1016a0:	e8 71 f7 ff ff       	call   100e16 <__intr_restore>
    return c;
  1016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a8:	c9                   	leave  
  1016a9:	c3                   	ret    

001016aa <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1016aa:	55                   	push   %ebp
  1016ab:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  1016ad:	fb                   	sti    
    sti();
}
  1016ae:	5d                   	pop    %ebp
  1016af:	c3                   	ret    

001016b0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1016b0:	55                   	push   %ebp
  1016b1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  1016b3:	fa                   	cli    
    cli();
}
  1016b4:	5d                   	pop    %ebp
  1016b5:	c3                   	ret    

001016b6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016b6:	55                   	push   %ebp
  1016b7:	89 e5                	mov    %esp,%ebp
  1016b9:	83 ec 14             	sub    $0x14,%esp
  1016bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1016bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016c7:	66 a3 70 75 11 00    	mov    %ax,0x117570
    if (did_init) {
  1016cd:	a1 ac 80 11 00       	mov    0x1180ac,%eax
  1016d2:	85 c0                	test   %eax,%eax
  1016d4:	74 36                	je     10170c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016da:	0f b6 c0             	movzbl %al,%eax
  1016dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016e3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1016e6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016ea:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016ee:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016f3:	66 c1 e8 08          	shr    $0x8,%ax
  1016f7:	0f b6 c0             	movzbl %al,%eax
  1016fa:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101700:	88 45 f9             	mov    %al,-0x7(%ebp)
  101703:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101707:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10170b:	ee                   	out    %al,(%dx)
    }
}
  10170c:	c9                   	leave  
  10170d:	c3                   	ret    

0010170e <pic_enable>:

void
pic_enable(unsigned int irq) {
  10170e:	55                   	push   %ebp
  10170f:	89 e5                	mov    %esp,%ebp
  101711:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101714:	8b 45 08             	mov    0x8(%ebp),%eax
  101717:	ba 01 00 00 00       	mov    $0x1,%edx
  10171c:	89 c1                	mov    %eax,%ecx
  10171e:	d3 e2                	shl    %cl,%edx
  101720:	89 d0                	mov    %edx,%eax
  101722:	f7 d0                	not    %eax
  101724:	89 c2                	mov    %eax,%edx
  101726:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10172d:	21 d0                	and    %edx,%eax
  10172f:	0f b7 c0             	movzwl %ax,%eax
  101732:	89 04 24             	mov    %eax,(%esp)
  101735:	e8 7c ff ff ff       	call   1016b6 <pic_setmask>
}
  10173a:	c9                   	leave  
  10173b:	c3                   	ret    

0010173c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  10173c:	55                   	push   %ebp
  10173d:	89 e5                	mov    %esp,%ebp
  10173f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101742:	c7 05 ac 80 11 00 01 	movl   $0x1,0x1180ac
  101749:	00 00 00 
  10174c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101752:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  101756:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10175a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10175e:	ee                   	out    %al,(%dx)
  10175f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101765:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  101769:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10176d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101771:	ee                   	out    %al,(%dx)
  101772:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101778:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10177c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101780:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101784:	ee                   	out    %al,(%dx)
  101785:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10178b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  10178f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101793:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101797:	ee                   	out    %al,(%dx)
  101798:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10179e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  1017a2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017a6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017aa:	ee                   	out    %al,(%dx)
  1017ab:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  1017b1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  1017b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017bd:	ee                   	out    %al,(%dx)
  1017be:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  1017c4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  1017c8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017cc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d0:	ee                   	out    %al,(%dx)
  1017d1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  1017d7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  1017db:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017df:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017e3:	ee                   	out    %al,(%dx)
  1017e4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  1017ea:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  1017ee:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017f2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017f6:	ee                   	out    %al,(%dx)
  1017f7:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  1017fd:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101801:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101805:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101809:	ee                   	out    %al,(%dx)
  10180a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101810:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101814:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101818:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10181c:	ee                   	out    %al,(%dx)
  10181d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101823:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  101827:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10182b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10182f:	ee                   	out    %al,(%dx)
  101830:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  101836:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  10183a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  10183e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101842:	ee                   	out    %al,(%dx)
  101843:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  101849:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  10184d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101851:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101855:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  101856:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10185d:	66 83 f8 ff          	cmp    $0xffff,%ax
  101861:	74 12                	je     101875 <pic_init+0x139>
        pic_setmask(irq_mask);
  101863:	0f b7 05 70 75 11 00 	movzwl 0x117570,%eax
  10186a:	0f b7 c0             	movzwl %ax,%eax
  10186d:	89 04 24             	mov    %eax,(%esp)
  101870:	e8 41 fe ff ff       	call   1016b6 <pic_setmask>
    }
}
  101875:	c9                   	leave  
  101876:	c3                   	ret    

00101877 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101877:	55                   	push   %ebp
  101878:	89 e5                	mov    %esp,%ebp
  10187a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10187d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101884:	00 
  101885:	c7 04 24 e0 62 10 00 	movl   $0x1062e0,(%esp)
  10188c:	e8 ab ea ff ff       	call   10033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101891:	c9                   	leave  
  101892:	c3                   	ret    

00101893 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101893:	55                   	push   %ebp
  101894:	89 e5                	mov    %esp,%ebp
  101896:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  101899:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
  1018a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018a7:	e9 c3 00 00 00       	jmp    10196f <idt_init+0xdc>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018af:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  1018b6:	89 c2                	mov    %eax,%edx
  1018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018bb:	66 89 14 c5 c0 80 11 	mov    %dx,0x1180c0(,%eax,8)
  1018c2:	00 
  1018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c6:	66 c7 04 c5 c2 80 11 	movw   $0x8,0x1180c2(,%eax,8)
  1018cd:	00 08 00 
  1018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d3:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018da:	00 
  1018db:	83 e2 e0             	and    $0xffffffe0,%edx
  1018de:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e8:	0f b6 14 c5 c4 80 11 	movzbl 0x1180c4(,%eax,8),%edx
  1018ef:	00 
  1018f0:	83 e2 1f             	and    $0x1f,%edx
  1018f3:	88 14 c5 c4 80 11 00 	mov    %dl,0x1180c4(,%eax,8)
  1018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018fd:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101904:	00 
  101905:	83 e2 f0             	and    $0xfffffff0,%edx
  101908:	83 ca 0e             	or     $0xe,%edx
  10190b:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101915:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  10191c:	00 
  10191d:	83 e2 ef             	and    $0xffffffef,%edx
  101920:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101927:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10192a:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101931:	00 
  101932:	83 e2 9f             	and    $0xffffff9f,%edx
  101935:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  10193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10193f:	0f b6 14 c5 c5 80 11 	movzbl 0x1180c5(,%eax,8),%edx
  101946:	00 
  101947:	83 ca 80             	or     $0xffffff80,%edx
  10194a:	88 14 c5 c5 80 11 00 	mov    %dl,0x1180c5(,%eax,8)
  101951:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101954:	8b 04 85 00 76 11 00 	mov    0x117600(,%eax,4),%eax
  10195b:	c1 e8 10             	shr    $0x10,%eax
  10195e:	89 c2                	mov    %eax,%edx
  101960:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101963:	66 89 14 c5 c6 80 11 	mov    %dx,0x1180c6(,%eax,8)
  10196a:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
  10196b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  10196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101972:	3d ff 00 00 00       	cmp    $0xff,%eax
  101977:	0f 86 2f ff ff ff    	jbe    1018ac <idt_init+0x19>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10197d:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  101982:	66 a3 88 84 11 00    	mov    %ax,0x118488
  101988:	66 c7 05 8a 84 11 00 	movw   $0x8,0x11848a
  10198f:	08 00 
  101991:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  101998:	83 e0 e0             	and    $0xffffffe0,%eax
  10199b:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019a0:	0f b6 05 8c 84 11 00 	movzbl 0x11848c,%eax
  1019a7:	83 e0 1f             	and    $0x1f,%eax
  1019aa:	a2 8c 84 11 00       	mov    %al,0x11848c
  1019af:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019b6:	83 e0 f0             	and    $0xfffffff0,%eax
  1019b9:	83 c8 0e             	or     $0xe,%eax
  1019bc:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019c1:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019c8:	83 e0 ef             	and    $0xffffffef,%eax
  1019cb:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019d0:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019d7:	83 c8 60             	or     $0x60,%eax
  1019da:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019df:	0f b6 05 8d 84 11 00 	movzbl 0x11848d,%eax
  1019e6:	83 c8 80             	or     $0xffffff80,%eax
  1019e9:	a2 8d 84 11 00       	mov    %al,0x11848d
  1019ee:	a1 e4 77 11 00       	mov    0x1177e4,%eax
  1019f3:	c1 e8 10             	shr    $0x10,%eax
  1019f6:	66 a3 8e 84 11 00    	mov    %ax,0x11848e
  1019fc:	c7 45 f8 80 75 11 00 	movl   $0x117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a03:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a06:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101a09:	c9                   	leave  
  101a0a:	c3                   	ret    

00101a0b <trapname>:

static const char *
trapname(int trapno) {
  101a0b:	55                   	push   %ebp
  101a0c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a11:	83 f8 13             	cmp    $0x13,%eax
  101a14:	77 0c                	ja     101a22 <trapname+0x17>
        return excnames[trapno];
  101a16:	8b 45 08             	mov    0x8(%ebp),%eax
  101a19:	8b 04 85 40 66 10 00 	mov    0x106640(,%eax,4),%eax
  101a20:	eb 18                	jmp    101a3a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a22:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a26:	7e 0d                	jle    101a35 <trapname+0x2a>
  101a28:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a2c:	7f 07                	jg     101a35 <trapname+0x2a>
        return "Hardware Interrupt";
  101a2e:	b8 ea 62 10 00       	mov    $0x1062ea,%eax
  101a33:	eb 05                	jmp    101a3a <trapname+0x2f>
    }
    return "(unknown trap)";
  101a35:	b8 fd 62 10 00       	mov    $0x1062fd,%eax
}
  101a3a:	5d                   	pop    %ebp
  101a3b:	c3                   	ret    

00101a3c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a3c:	55                   	push   %ebp
  101a3d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a42:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a46:	66 83 f8 08          	cmp    $0x8,%ax
  101a4a:	0f 94 c0             	sete   %al
  101a4d:	0f b6 c0             	movzbl %al,%eax
}
  101a50:	5d                   	pop    %ebp
  101a51:	c3                   	ret    

00101a52 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a52:	55                   	push   %ebp
  101a53:	89 e5                	mov    %esp,%ebp
  101a55:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a58:	8b 45 08             	mov    0x8(%ebp),%eax
  101a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5f:	c7 04 24 3e 63 10 00 	movl   $0x10633e,(%esp)
  101a66:	e8 d1 e8 ff ff       	call   10033c <cprintf>
    print_regs(&tf->tf_regs);
  101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6e:	89 04 24             	mov    %eax,(%esp)
  101a71:	e8 a1 01 00 00       	call   101c17 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a76:	8b 45 08             	mov    0x8(%ebp),%eax
  101a79:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a7d:	0f b7 c0             	movzwl %ax,%eax
  101a80:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a84:	c7 04 24 4f 63 10 00 	movl   $0x10634f,(%esp)
  101a8b:	e8 ac e8 ff ff       	call   10033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a90:	8b 45 08             	mov    0x8(%ebp),%eax
  101a93:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a97:	0f b7 c0             	movzwl %ax,%eax
  101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9e:	c7 04 24 62 63 10 00 	movl   $0x106362,(%esp)
  101aa5:	e8 92 e8 ff ff       	call   10033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  101aad:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ab1:	0f b7 c0             	movzwl %ax,%eax
  101ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab8:	c7 04 24 75 63 10 00 	movl   $0x106375,(%esp)
  101abf:	e8 78 e8 ff ff       	call   10033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac7:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101acb:	0f b7 c0             	movzwl %ax,%eax
  101ace:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad2:	c7 04 24 88 63 10 00 	movl   $0x106388,(%esp)
  101ad9:	e8 5e e8 ff ff       	call   10033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ade:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae1:	8b 40 30             	mov    0x30(%eax),%eax
  101ae4:	89 04 24             	mov    %eax,(%esp)
  101ae7:	e8 1f ff ff ff       	call   101a0b <trapname>
  101aec:	8b 55 08             	mov    0x8(%ebp),%edx
  101aef:	8b 52 30             	mov    0x30(%edx),%edx
  101af2:	89 44 24 08          	mov    %eax,0x8(%esp)
  101af6:	89 54 24 04          	mov    %edx,0x4(%esp)
  101afa:	c7 04 24 9b 63 10 00 	movl   $0x10639b,(%esp)
  101b01:	e8 36 e8 ff ff       	call   10033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b06:	8b 45 08             	mov    0x8(%ebp),%eax
  101b09:	8b 40 34             	mov    0x34(%eax),%eax
  101b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b10:	c7 04 24 ad 63 10 00 	movl   $0x1063ad,(%esp)
  101b17:	e8 20 e8 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1f:	8b 40 38             	mov    0x38(%eax),%eax
  101b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b26:	c7 04 24 bc 63 10 00 	movl   $0x1063bc,(%esp)
  101b2d:	e8 0a e8 ff ff       	call   10033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b32:	8b 45 08             	mov    0x8(%ebp),%eax
  101b35:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b39:	0f b7 c0             	movzwl %ax,%eax
  101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b40:	c7 04 24 cb 63 10 00 	movl   $0x1063cb,(%esp)
  101b47:	e8 f0 e7 ff ff       	call   10033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4f:	8b 40 40             	mov    0x40(%eax),%eax
  101b52:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b56:	c7 04 24 de 63 10 00 	movl   $0x1063de,(%esp)
  101b5d:	e8 da e7 ff ff       	call   10033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b69:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b70:	eb 3e                	jmp    101bb0 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b72:	8b 45 08             	mov    0x8(%ebp),%eax
  101b75:	8b 50 40             	mov    0x40(%eax),%edx
  101b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b7b:	21 d0                	and    %edx,%eax
  101b7d:	85 c0                	test   %eax,%eax
  101b7f:	74 28                	je     101ba9 <print_trapframe+0x157>
  101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b84:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b8b:	85 c0                	test   %eax,%eax
  101b8d:	74 1a                	je     101ba9 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b92:	8b 04 85 a0 75 11 00 	mov    0x1175a0(,%eax,4),%eax
  101b99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9d:	c7 04 24 ed 63 10 00 	movl   $0x1063ed,(%esp)
  101ba4:	e8 93 e7 ff ff       	call   10033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101bad:	d1 65 f0             	shll   -0x10(%ebp)
  101bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101bb3:	83 f8 17             	cmp    $0x17,%eax
  101bb6:	76 ba                	jbe    101b72 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbb:	8b 40 40             	mov    0x40(%eax),%eax
  101bbe:	25 00 30 00 00       	and    $0x3000,%eax
  101bc3:	c1 e8 0c             	shr    $0xc,%eax
  101bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bca:	c7 04 24 f1 63 10 00 	movl   $0x1063f1,(%esp)
  101bd1:	e8 66 e7 ff ff       	call   10033c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	89 04 24             	mov    %eax,(%esp)
  101bdc:	e8 5b fe ff ff       	call   101a3c <trap_in_kernel>
  101be1:	85 c0                	test   %eax,%eax
  101be3:	75 30                	jne    101c15 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101be5:	8b 45 08             	mov    0x8(%ebp),%eax
  101be8:	8b 40 44             	mov    0x44(%eax),%eax
  101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bef:	c7 04 24 fa 63 10 00 	movl   $0x1063fa,(%esp)
  101bf6:	e8 41 e7 ff ff       	call   10033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfe:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c02:	0f b7 c0             	movzwl %ax,%eax
  101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c09:	c7 04 24 09 64 10 00 	movl   $0x106409,(%esp)
  101c10:	e8 27 e7 ff ff       	call   10033c <cprintf>
    }
}
  101c15:	c9                   	leave  
  101c16:	c3                   	ret    

00101c17 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c17:	55                   	push   %ebp
  101c18:	89 e5                	mov    %esp,%ebp
  101c1a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c20:	8b 00                	mov    (%eax),%eax
  101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c26:	c7 04 24 1c 64 10 00 	movl   $0x10641c,(%esp)
  101c2d:	e8 0a e7 ff ff       	call   10033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c32:	8b 45 08             	mov    0x8(%ebp),%eax
  101c35:	8b 40 04             	mov    0x4(%eax),%eax
  101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3c:	c7 04 24 2b 64 10 00 	movl   $0x10642b,(%esp)
  101c43:	e8 f4 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c48:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4b:	8b 40 08             	mov    0x8(%eax),%eax
  101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c52:	c7 04 24 3a 64 10 00 	movl   $0x10643a,(%esp)
  101c59:	e8 de e6 ff ff       	call   10033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c61:	8b 40 0c             	mov    0xc(%eax),%eax
  101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c68:	c7 04 24 49 64 10 00 	movl   $0x106449,(%esp)
  101c6f:	e8 c8 e6 ff ff       	call   10033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c74:	8b 45 08             	mov    0x8(%ebp),%eax
  101c77:	8b 40 10             	mov    0x10(%eax),%eax
  101c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7e:	c7 04 24 58 64 10 00 	movl   $0x106458,(%esp)
  101c85:	e8 b2 e6 ff ff       	call   10033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c8d:	8b 40 14             	mov    0x14(%eax),%eax
  101c90:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c94:	c7 04 24 67 64 10 00 	movl   $0x106467,(%esp)
  101c9b:	e8 9c e6 ff ff       	call   10033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ca3:	8b 40 18             	mov    0x18(%eax),%eax
  101ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101caa:	c7 04 24 76 64 10 00 	movl   $0x106476,(%esp)
  101cb1:	e8 86 e6 ff ff       	call   10033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb9:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc0:	c7 04 24 85 64 10 00 	movl   $0x106485,(%esp)
  101cc7:	e8 70 e6 ff ff       	call   10033c <cprintf>
}
  101ccc:	c9                   	leave  
  101ccd:	c3                   	ret    

00101cce <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cce:	55                   	push   %ebp
  101ccf:	89 e5                	mov    %esp,%ebp
  101cd1:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd7:	8b 40 30             	mov    0x30(%eax),%eax
  101cda:	83 f8 2f             	cmp    $0x2f,%eax
  101cdd:	77 21                	ja     101d00 <trap_dispatch+0x32>
  101cdf:	83 f8 2e             	cmp    $0x2e,%eax
  101ce2:	0f 83 04 01 00 00    	jae    101dec <trap_dispatch+0x11e>
  101ce8:	83 f8 21             	cmp    $0x21,%eax
  101ceb:	0f 84 81 00 00 00    	je     101d72 <trap_dispatch+0xa4>
  101cf1:	83 f8 24             	cmp    $0x24,%eax
  101cf4:	74 56                	je     101d4c <trap_dispatch+0x7e>
  101cf6:	83 f8 20             	cmp    $0x20,%eax
  101cf9:	74 16                	je     101d11 <trap_dispatch+0x43>
  101cfb:	e9 b4 00 00 00       	jmp    101db4 <trap_dispatch+0xe6>
  101d00:	83 e8 78             	sub    $0x78,%eax
  101d03:	83 f8 01             	cmp    $0x1,%eax
  101d06:	0f 87 a8 00 00 00    	ja     101db4 <trap_dispatch+0xe6>
  101d0c:	e9 87 00 00 00       	jmp    101d98 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
  101d11:	a1 4c 89 11 00       	mov    0x11894c,%eax
  101d16:	83 c0 01             	add    $0x1,%eax
  101d19:	a3 4c 89 11 00       	mov    %eax,0x11894c
        if (ticks % TICK_NUM == 0)
  101d1e:	8b 0d 4c 89 11 00    	mov    0x11894c,%ecx
  101d24:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d29:	89 c8                	mov    %ecx,%eax
  101d2b:	f7 e2                	mul    %edx
  101d2d:	89 d0                	mov    %edx,%eax
  101d2f:	c1 e8 05             	shr    $0x5,%eax
  101d32:	6b c0 64             	imul   $0x64,%eax,%eax
  101d35:	29 c1                	sub    %eax,%ecx
  101d37:	89 c8                	mov    %ecx,%eax
  101d39:	85 c0                	test   %eax,%eax
  101d3b:	75 0a                	jne    101d47 <trap_dispatch+0x79>
		print_ticks();
  101d3d:	e8 35 fb ff ff       	call   101877 <print_ticks>
        break;
  101d42:	e9 a6 00 00 00       	jmp    101ded <trap_dispatch+0x11f>
  101d47:	e9 a1 00 00 00       	jmp    101ded <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d4c:	e8 ea f8 ff ff       	call   10163b <cons_getc>
  101d51:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d54:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d58:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d5c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d64:	c7 04 24 94 64 10 00 	movl   $0x106494,(%esp)
  101d6b:	e8 cc e5 ff ff       	call   10033c <cprintf>
        break;
  101d70:	eb 7b                	jmp    101ded <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d72:	e8 c4 f8 ff ff       	call   10163b <cons_getc>
  101d77:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d7a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d7e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d82:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d86:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8a:	c7 04 24 a6 64 10 00 	movl   $0x1064a6,(%esp)
  101d91:	e8 a6 e5 ff ff       	call   10033c <cprintf>
        break;
  101d96:	eb 55                	jmp    101ded <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d98:	c7 44 24 08 b5 64 10 	movl   $0x1064b5,0x8(%esp)
  101d9f:	00 
  101da0:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  101da7:	00 
  101da8:	c7 04 24 c5 64 10 00 	movl   $0x1064c5,(%esp)
  101daf:	e8 19 ef ff ff       	call   100ccd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101db4:	8b 45 08             	mov    0x8(%ebp),%eax
  101db7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101dbb:	0f b7 c0             	movzwl %ax,%eax
  101dbe:	83 e0 03             	and    $0x3,%eax
  101dc1:	85 c0                	test   %eax,%eax
  101dc3:	75 28                	jne    101ded <trap_dispatch+0x11f>
            print_trapframe(tf);
  101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc8:	89 04 24             	mov    %eax,(%esp)
  101dcb:	e8 82 fc ff ff       	call   101a52 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101dd0:	c7 44 24 08 d6 64 10 	movl   $0x1064d6,0x8(%esp)
  101dd7:	00 
  101dd8:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101ddf:	00 
  101de0:	c7 04 24 c5 64 10 00 	movl   $0x1064c5,(%esp)
  101de7:	e8 e1 ee ff ff       	call   100ccd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101dec:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101ded:	c9                   	leave  
  101dee:	c3                   	ret    

00101def <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101def:	55                   	push   %ebp
  101df0:	89 e5                	mov    %esp,%ebp
  101df2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101df5:	8b 45 08             	mov    0x8(%ebp),%eax
  101df8:	89 04 24             	mov    %eax,(%esp)
  101dfb:	e8 ce fe ff ff       	call   101cce <trap_dispatch>
}
  101e00:	c9                   	leave  
  101e01:	c3                   	ret    

00101e02 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e02:	1e                   	push   %ds
    pushl %es
  101e03:	06                   	push   %es
    pushl %fs
  101e04:	0f a0                	push   %fs
    pushl %gs
  101e06:	0f a8                	push   %gs
    pushal
  101e08:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e09:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e0e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e10:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101e12:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101e13:	e8 d7 ff ff ff       	call   101def <trap>

    # pop the pushed stack pointer
    popl %esp
  101e18:	5c                   	pop    %esp

00101e19 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101e19:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101e1a:	0f a9                	pop    %gs
    popl %fs
  101e1c:	0f a1                	pop    %fs
    popl %es
  101e1e:	07                   	pop    %es
    popl %ds
  101e1f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101e20:	83 c4 08             	add    $0x8,%esp
    iret
  101e23:	cf                   	iret   

00101e24 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101e24:	6a 00                	push   $0x0
  pushl $0
  101e26:	6a 00                	push   $0x0
  jmp __alltraps
  101e28:	e9 d5 ff ff ff       	jmp    101e02 <__alltraps>

00101e2d <vector1>:
.globl vector1
vector1:
  pushl $0
  101e2d:	6a 00                	push   $0x0
  pushl $1
  101e2f:	6a 01                	push   $0x1
  jmp __alltraps
  101e31:	e9 cc ff ff ff       	jmp    101e02 <__alltraps>

00101e36 <vector2>:
.globl vector2
vector2:
  pushl $0
  101e36:	6a 00                	push   $0x0
  pushl $2
  101e38:	6a 02                	push   $0x2
  jmp __alltraps
  101e3a:	e9 c3 ff ff ff       	jmp    101e02 <__alltraps>

00101e3f <vector3>:
.globl vector3
vector3:
  pushl $0
  101e3f:	6a 00                	push   $0x0
  pushl $3
  101e41:	6a 03                	push   $0x3
  jmp __alltraps
  101e43:	e9 ba ff ff ff       	jmp    101e02 <__alltraps>

00101e48 <vector4>:
.globl vector4
vector4:
  pushl $0
  101e48:	6a 00                	push   $0x0
  pushl $4
  101e4a:	6a 04                	push   $0x4
  jmp __alltraps
  101e4c:	e9 b1 ff ff ff       	jmp    101e02 <__alltraps>

00101e51 <vector5>:
.globl vector5
vector5:
  pushl $0
  101e51:	6a 00                	push   $0x0
  pushl $5
  101e53:	6a 05                	push   $0x5
  jmp __alltraps
  101e55:	e9 a8 ff ff ff       	jmp    101e02 <__alltraps>

00101e5a <vector6>:
.globl vector6
vector6:
  pushl $0
  101e5a:	6a 00                	push   $0x0
  pushl $6
  101e5c:	6a 06                	push   $0x6
  jmp __alltraps
  101e5e:	e9 9f ff ff ff       	jmp    101e02 <__alltraps>

00101e63 <vector7>:
.globl vector7
vector7:
  pushl $0
  101e63:	6a 00                	push   $0x0
  pushl $7
  101e65:	6a 07                	push   $0x7
  jmp __alltraps
  101e67:	e9 96 ff ff ff       	jmp    101e02 <__alltraps>

00101e6c <vector8>:
.globl vector8
vector8:
  pushl $8
  101e6c:	6a 08                	push   $0x8
  jmp __alltraps
  101e6e:	e9 8f ff ff ff       	jmp    101e02 <__alltraps>

00101e73 <vector9>:
.globl vector9
vector9:
  pushl $9
  101e73:	6a 09                	push   $0x9
  jmp __alltraps
  101e75:	e9 88 ff ff ff       	jmp    101e02 <__alltraps>

00101e7a <vector10>:
.globl vector10
vector10:
  pushl $10
  101e7a:	6a 0a                	push   $0xa
  jmp __alltraps
  101e7c:	e9 81 ff ff ff       	jmp    101e02 <__alltraps>

00101e81 <vector11>:
.globl vector11
vector11:
  pushl $11
  101e81:	6a 0b                	push   $0xb
  jmp __alltraps
  101e83:	e9 7a ff ff ff       	jmp    101e02 <__alltraps>

00101e88 <vector12>:
.globl vector12
vector12:
  pushl $12
  101e88:	6a 0c                	push   $0xc
  jmp __alltraps
  101e8a:	e9 73 ff ff ff       	jmp    101e02 <__alltraps>

00101e8f <vector13>:
.globl vector13
vector13:
  pushl $13
  101e8f:	6a 0d                	push   $0xd
  jmp __alltraps
  101e91:	e9 6c ff ff ff       	jmp    101e02 <__alltraps>

00101e96 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e96:	6a 0e                	push   $0xe
  jmp __alltraps
  101e98:	e9 65 ff ff ff       	jmp    101e02 <__alltraps>

00101e9d <vector15>:
.globl vector15
vector15:
  pushl $0
  101e9d:	6a 00                	push   $0x0
  pushl $15
  101e9f:	6a 0f                	push   $0xf
  jmp __alltraps
  101ea1:	e9 5c ff ff ff       	jmp    101e02 <__alltraps>

00101ea6 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ea6:	6a 00                	push   $0x0
  pushl $16
  101ea8:	6a 10                	push   $0x10
  jmp __alltraps
  101eaa:	e9 53 ff ff ff       	jmp    101e02 <__alltraps>

00101eaf <vector17>:
.globl vector17
vector17:
  pushl $17
  101eaf:	6a 11                	push   $0x11
  jmp __alltraps
  101eb1:	e9 4c ff ff ff       	jmp    101e02 <__alltraps>

00101eb6 <vector18>:
.globl vector18
vector18:
  pushl $0
  101eb6:	6a 00                	push   $0x0
  pushl $18
  101eb8:	6a 12                	push   $0x12
  jmp __alltraps
  101eba:	e9 43 ff ff ff       	jmp    101e02 <__alltraps>

00101ebf <vector19>:
.globl vector19
vector19:
  pushl $0
  101ebf:	6a 00                	push   $0x0
  pushl $19
  101ec1:	6a 13                	push   $0x13
  jmp __alltraps
  101ec3:	e9 3a ff ff ff       	jmp    101e02 <__alltraps>

00101ec8 <vector20>:
.globl vector20
vector20:
  pushl $0
  101ec8:	6a 00                	push   $0x0
  pushl $20
  101eca:	6a 14                	push   $0x14
  jmp __alltraps
  101ecc:	e9 31 ff ff ff       	jmp    101e02 <__alltraps>

00101ed1 <vector21>:
.globl vector21
vector21:
  pushl $0
  101ed1:	6a 00                	push   $0x0
  pushl $21
  101ed3:	6a 15                	push   $0x15
  jmp __alltraps
  101ed5:	e9 28 ff ff ff       	jmp    101e02 <__alltraps>

00101eda <vector22>:
.globl vector22
vector22:
  pushl $0
  101eda:	6a 00                	push   $0x0
  pushl $22
  101edc:	6a 16                	push   $0x16
  jmp __alltraps
  101ede:	e9 1f ff ff ff       	jmp    101e02 <__alltraps>

00101ee3 <vector23>:
.globl vector23
vector23:
  pushl $0
  101ee3:	6a 00                	push   $0x0
  pushl $23
  101ee5:	6a 17                	push   $0x17
  jmp __alltraps
  101ee7:	e9 16 ff ff ff       	jmp    101e02 <__alltraps>

00101eec <vector24>:
.globl vector24
vector24:
  pushl $0
  101eec:	6a 00                	push   $0x0
  pushl $24
  101eee:	6a 18                	push   $0x18
  jmp __alltraps
  101ef0:	e9 0d ff ff ff       	jmp    101e02 <__alltraps>

00101ef5 <vector25>:
.globl vector25
vector25:
  pushl $0
  101ef5:	6a 00                	push   $0x0
  pushl $25
  101ef7:	6a 19                	push   $0x19
  jmp __alltraps
  101ef9:	e9 04 ff ff ff       	jmp    101e02 <__alltraps>

00101efe <vector26>:
.globl vector26
vector26:
  pushl $0
  101efe:	6a 00                	push   $0x0
  pushl $26
  101f00:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f02:	e9 fb fe ff ff       	jmp    101e02 <__alltraps>

00101f07 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f07:	6a 00                	push   $0x0
  pushl $27
  101f09:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f0b:	e9 f2 fe ff ff       	jmp    101e02 <__alltraps>

00101f10 <vector28>:
.globl vector28
vector28:
  pushl $0
  101f10:	6a 00                	push   $0x0
  pushl $28
  101f12:	6a 1c                	push   $0x1c
  jmp __alltraps
  101f14:	e9 e9 fe ff ff       	jmp    101e02 <__alltraps>

00101f19 <vector29>:
.globl vector29
vector29:
  pushl $0
  101f19:	6a 00                	push   $0x0
  pushl $29
  101f1b:	6a 1d                	push   $0x1d
  jmp __alltraps
  101f1d:	e9 e0 fe ff ff       	jmp    101e02 <__alltraps>

00101f22 <vector30>:
.globl vector30
vector30:
  pushl $0
  101f22:	6a 00                	push   $0x0
  pushl $30
  101f24:	6a 1e                	push   $0x1e
  jmp __alltraps
  101f26:	e9 d7 fe ff ff       	jmp    101e02 <__alltraps>

00101f2b <vector31>:
.globl vector31
vector31:
  pushl $0
  101f2b:	6a 00                	push   $0x0
  pushl $31
  101f2d:	6a 1f                	push   $0x1f
  jmp __alltraps
  101f2f:	e9 ce fe ff ff       	jmp    101e02 <__alltraps>

00101f34 <vector32>:
.globl vector32
vector32:
  pushl $0
  101f34:	6a 00                	push   $0x0
  pushl $32
  101f36:	6a 20                	push   $0x20
  jmp __alltraps
  101f38:	e9 c5 fe ff ff       	jmp    101e02 <__alltraps>

00101f3d <vector33>:
.globl vector33
vector33:
  pushl $0
  101f3d:	6a 00                	push   $0x0
  pushl $33
  101f3f:	6a 21                	push   $0x21
  jmp __alltraps
  101f41:	e9 bc fe ff ff       	jmp    101e02 <__alltraps>

00101f46 <vector34>:
.globl vector34
vector34:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $34
  101f48:	6a 22                	push   $0x22
  jmp __alltraps
  101f4a:	e9 b3 fe ff ff       	jmp    101e02 <__alltraps>

00101f4f <vector35>:
.globl vector35
vector35:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $35
  101f51:	6a 23                	push   $0x23
  jmp __alltraps
  101f53:	e9 aa fe ff ff       	jmp    101e02 <__alltraps>

00101f58 <vector36>:
.globl vector36
vector36:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $36
  101f5a:	6a 24                	push   $0x24
  jmp __alltraps
  101f5c:	e9 a1 fe ff ff       	jmp    101e02 <__alltraps>

00101f61 <vector37>:
.globl vector37
vector37:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $37
  101f63:	6a 25                	push   $0x25
  jmp __alltraps
  101f65:	e9 98 fe ff ff       	jmp    101e02 <__alltraps>

00101f6a <vector38>:
.globl vector38
vector38:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $38
  101f6c:	6a 26                	push   $0x26
  jmp __alltraps
  101f6e:	e9 8f fe ff ff       	jmp    101e02 <__alltraps>

00101f73 <vector39>:
.globl vector39
vector39:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $39
  101f75:	6a 27                	push   $0x27
  jmp __alltraps
  101f77:	e9 86 fe ff ff       	jmp    101e02 <__alltraps>

00101f7c <vector40>:
.globl vector40
vector40:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $40
  101f7e:	6a 28                	push   $0x28
  jmp __alltraps
  101f80:	e9 7d fe ff ff       	jmp    101e02 <__alltraps>

00101f85 <vector41>:
.globl vector41
vector41:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $41
  101f87:	6a 29                	push   $0x29
  jmp __alltraps
  101f89:	e9 74 fe ff ff       	jmp    101e02 <__alltraps>

00101f8e <vector42>:
.globl vector42
vector42:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $42
  101f90:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f92:	e9 6b fe ff ff       	jmp    101e02 <__alltraps>

00101f97 <vector43>:
.globl vector43
vector43:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $43
  101f99:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f9b:	e9 62 fe ff ff       	jmp    101e02 <__alltraps>

00101fa0 <vector44>:
.globl vector44
vector44:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $44
  101fa2:	6a 2c                	push   $0x2c
  jmp __alltraps
  101fa4:	e9 59 fe ff ff       	jmp    101e02 <__alltraps>

00101fa9 <vector45>:
.globl vector45
vector45:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $45
  101fab:	6a 2d                	push   $0x2d
  jmp __alltraps
  101fad:	e9 50 fe ff ff       	jmp    101e02 <__alltraps>

00101fb2 <vector46>:
.globl vector46
vector46:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $46
  101fb4:	6a 2e                	push   $0x2e
  jmp __alltraps
  101fb6:	e9 47 fe ff ff       	jmp    101e02 <__alltraps>

00101fbb <vector47>:
.globl vector47
vector47:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $47
  101fbd:	6a 2f                	push   $0x2f
  jmp __alltraps
  101fbf:	e9 3e fe ff ff       	jmp    101e02 <__alltraps>

00101fc4 <vector48>:
.globl vector48
vector48:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $48
  101fc6:	6a 30                	push   $0x30
  jmp __alltraps
  101fc8:	e9 35 fe ff ff       	jmp    101e02 <__alltraps>

00101fcd <vector49>:
.globl vector49
vector49:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $49
  101fcf:	6a 31                	push   $0x31
  jmp __alltraps
  101fd1:	e9 2c fe ff ff       	jmp    101e02 <__alltraps>

00101fd6 <vector50>:
.globl vector50
vector50:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $50
  101fd8:	6a 32                	push   $0x32
  jmp __alltraps
  101fda:	e9 23 fe ff ff       	jmp    101e02 <__alltraps>

00101fdf <vector51>:
.globl vector51
vector51:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $51
  101fe1:	6a 33                	push   $0x33
  jmp __alltraps
  101fe3:	e9 1a fe ff ff       	jmp    101e02 <__alltraps>

00101fe8 <vector52>:
.globl vector52
vector52:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $52
  101fea:	6a 34                	push   $0x34
  jmp __alltraps
  101fec:	e9 11 fe ff ff       	jmp    101e02 <__alltraps>

00101ff1 <vector53>:
.globl vector53
vector53:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $53
  101ff3:	6a 35                	push   $0x35
  jmp __alltraps
  101ff5:	e9 08 fe ff ff       	jmp    101e02 <__alltraps>

00101ffa <vector54>:
.globl vector54
vector54:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $54
  101ffc:	6a 36                	push   $0x36
  jmp __alltraps
  101ffe:	e9 ff fd ff ff       	jmp    101e02 <__alltraps>

00102003 <vector55>:
.globl vector55
vector55:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $55
  102005:	6a 37                	push   $0x37
  jmp __alltraps
  102007:	e9 f6 fd ff ff       	jmp    101e02 <__alltraps>

0010200c <vector56>:
.globl vector56
vector56:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $56
  10200e:	6a 38                	push   $0x38
  jmp __alltraps
  102010:	e9 ed fd ff ff       	jmp    101e02 <__alltraps>

00102015 <vector57>:
.globl vector57
vector57:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $57
  102017:	6a 39                	push   $0x39
  jmp __alltraps
  102019:	e9 e4 fd ff ff       	jmp    101e02 <__alltraps>

0010201e <vector58>:
.globl vector58
vector58:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $58
  102020:	6a 3a                	push   $0x3a
  jmp __alltraps
  102022:	e9 db fd ff ff       	jmp    101e02 <__alltraps>

00102027 <vector59>:
.globl vector59
vector59:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $59
  102029:	6a 3b                	push   $0x3b
  jmp __alltraps
  10202b:	e9 d2 fd ff ff       	jmp    101e02 <__alltraps>

00102030 <vector60>:
.globl vector60
vector60:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $60
  102032:	6a 3c                	push   $0x3c
  jmp __alltraps
  102034:	e9 c9 fd ff ff       	jmp    101e02 <__alltraps>

00102039 <vector61>:
.globl vector61
vector61:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $61
  10203b:	6a 3d                	push   $0x3d
  jmp __alltraps
  10203d:	e9 c0 fd ff ff       	jmp    101e02 <__alltraps>

00102042 <vector62>:
.globl vector62
vector62:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $62
  102044:	6a 3e                	push   $0x3e
  jmp __alltraps
  102046:	e9 b7 fd ff ff       	jmp    101e02 <__alltraps>

0010204b <vector63>:
.globl vector63
vector63:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $63
  10204d:	6a 3f                	push   $0x3f
  jmp __alltraps
  10204f:	e9 ae fd ff ff       	jmp    101e02 <__alltraps>

00102054 <vector64>:
.globl vector64
vector64:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $64
  102056:	6a 40                	push   $0x40
  jmp __alltraps
  102058:	e9 a5 fd ff ff       	jmp    101e02 <__alltraps>

0010205d <vector65>:
.globl vector65
vector65:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $65
  10205f:	6a 41                	push   $0x41
  jmp __alltraps
  102061:	e9 9c fd ff ff       	jmp    101e02 <__alltraps>

00102066 <vector66>:
.globl vector66
vector66:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $66
  102068:	6a 42                	push   $0x42
  jmp __alltraps
  10206a:	e9 93 fd ff ff       	jmp    101e02 <__alltraps>

0010206f <vector67>:
.globl vector67
vector67:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $67
  102071:	6a 43                	push   $0x43
  jmp __alltraps
  102073:	e9 8a fd ff ff       	jmp    101e02 <__alltraps>

00102078 <vector68>:
.globl vector68
vector68:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $68
  10207a:	6a 44                	push   $0x44
  jmp __alltraps
  10207c:	e9 81 fd ff ff       	jmp    101e02 <__alltraps>

00102081 <vector69>:
.globl vector69
vector69:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $69
  102083:	6a 45                	push   $0x45
  jmp __alltraps
  102085:	e9 78 fd ff ff       	jmp    101e02 <__alltraps>

0010208a <vector70>:
.globl vector70
vector70:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $70
  10208c:	6a 46                	push   $0x46
  jmp __alltraps
  10208e:	e9 6f fd ff ff       	jmp    101e02 <__alltraps>

00102093 <vector71>:
.globl vector71
vector71:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $71
  102095:	6a 47                	push   $0x47
  jmp __alltraps
  102097:	e9 66 fd ff ff       	jmp    101e02 <__alltraps>

0010209c <vector72>:
.globl vector72
vector72:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $72
  10209e:	6a 48                	push   $0x48
  jmp __alltraps
  1020a0:	e9 5d fd ff ff       	jmp    101e02 <__alltraps>

001020a5 <vector73>:
.globl vector73
vector73:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $73
  1020a7:	6a 49                	push   $0x49
  jmp __alltraps
  1020a9:	e9 54 fd ff ff       	jmp    101e02 <__alltraps>

001020ae <vector74>:
.globl vector74
vector74:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $74
  1020b0:	6a 4a                	push   $0x4a
  jmp __alltraps
  1020b2:	e9 4b fd ff ff       	jmp    101e02 <__alltraps>

001020b7 <vector75>:
.globl vector75
vector75:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $75
  1020b9:	6a 4b                	push   $0x4b
  jmp __alltraps
  1020bb:	e9 42 fd ff ff       	jmp    101e02 <__alltraps>

001020c0 <vector76>:
.globl vector76
vector76:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $76
  1020c2:	6a 4c                	push   $0x4c
  jmp __alltraps
  1020c4:	e9 39 fd ff ff       	jmp    101e02 <__alltraps>

001020c9 <vector77>:
.globl vector77
vector77:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $77
  1020cb:	6a 4d                	push   $0x4d
  jmp __alltraps
  1020cd:	e9 30 fd ff ff       	jmp    101e02 <__alltraps>

001020d2 <vector78>:
.globl vector78
vector78:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $78
  1020d4:	6a 4e                	push   $0x4e
  jmp __alltraps
  1020d6:	e9 27 fd ff ff       	jmp    101e02 <__alltraps>

001020db <vector79>:
.globl vector79
vector79:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $79
  1020dd:	6a 4f                	push   $0x4f
  jmp __alltraps
  1020df:	e9 1e fd ff ff       	jmp    101e02 <__alltraps>

001020e4 <vector80>:
.globl vector80
vector80:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $80
  1020e6:	6a 50                	push   $0x50
  jmp __alltraps
  1020e8:	e9 15 fd ff ff       	jmp    101e02 <__alltraps>

001020ed <vector81>:
.globl vector81
vector81:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $81
  1020ef:	6a 51                	push   $0x51
  jmp __alltraps
  1020f1:	e9 0c fd ff ff       	jmp    101e02 <__alltraps>

001020f6 <vector82>:
.globl vector82
vector82:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $82
  1020f8:	6a 52                	push   $0x52
  jmp __alltraps
  1020fa:	e9 03 fd ff ff       	jmp    101e02 <__alltraps>

001020ff <vector83>:
.globl vector83
vector83:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $83
  102101:	6a 53                	push   $0x53
  jmp __alltraps
  102103:	e9 fa fc ff ff       	jmp    101e02 <__alltraps>

00102108 <vector84>:
.globl vector84
vector84:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $84
  10210a:	6a 54                	push   $0x54
  jmp __alltraps
  10210c:	e9 f1 fc ff ff       	jmp    101e02 <__alltraps>

00102111 <vector85>:
.globl vector85
vector85:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $85
  102113:	6a 55                	push   $0x55
  jmp __alltraps
  102115:	e9 e8 fc ff ff       	jmp    101e02 <__alltraps>

0010211a <vector86>:
.globl vector86
vector86:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $86
  10211c:	6a 56                	push   $0x56
  jmp __alltraps
  10211e:	e9 df fc ff ff       	jmp    101e02 <__alltraps>

00102123 <vector87>:
.globl vector87
vector87:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $87
  102125:	6a 57                	push   $0x57
  jmp __alltraps
  102127:	e9 d6 fc ff ff       	jmp    101e02 <__alltraps>

0010212c <vector88>:
.globl vector88
vector88:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $88
  10212e:	6a 58                	push   $0x58
  jmp __alltraps
  102130:	e9 cd fc ff ff       	jmp    101e02 <__alltraps>

00102135 <vector89>:
.globl vector89
vector89:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $89
  102137:	6a 59                	push   $0x59
  jmp __alltraps
  102139:	e9 c4 fc ff ff       	jmp    101e02 <__alltraps>

0010213e <vector90>:
.globl vector90
vector90:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $90
  102140:	6a 5a                	push   $0x5a
  jmp __alltraps
  102142:	e9 bb fc ff ff       	jmp    101e02 <__alltraps>

00102147 <vector91>:
.globl vector91
vector91:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $91
  102149:	6a 5b                	push   $0x5b
  jmp __alltraps
  10214b:	e9 b2 fc ff ff       	jmp    101e02 <__alltraps>

00102150 <vector92>:
.globl vector92
vector92:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $92
  102152:	6a 5c                	push   $0x5c
  jmp __alltraps
  102154:	e9 a9 fc ff ff       	jmp    101e02 <__alltraps>

00102159 <vector93>:
.globl vector93
vector93:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $93
  10215b:	6a 5d                	push   $0x5d
  jmp __alltraps
  10215d:	e9 a0 fc ff ff       	jmp    101e02 <__alltraps>

00102162 <vector94>:
.globl vector94
vector94:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $94
  102164:	6a 5e                	push   $0x5e
  jmp __alltraps
  102166:	e9 97 fc ff ff       	jmp    101e02 <__alltraps>

0010216b <vector95>:
.globl vector95
vector95:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $95
  10216d:	6a 5f                	push   $0x5f
  jmp __alltraps
  10216f:	e9 8e fc ff ff       	jmp    101e02 <__alltraps>

00102174 <vector96>:
.globl vector96
vector96:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $96
  102176:	6a 60                	push   $0x60
  jmp __alltraps
  102178:	e9 85 fc ff ff       	jmp    101e02 <__alltraps>

0010217d <vector97>:
.globl vector97
vector97:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $97
  10217f:	6a 61                	push   $0x61
  jmp __alltraps
  102181:	e9 7c fc ff ff       	jmp    101e02 <__alltraps>

00102186 <vector98>:
.globl vector98
vector98:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $98
  102188:	6a 62                	push   $0x62
  jmp __alltraps
  10218a:	e9 73 fc ff ff       	jmp    101e02 <__alltraps>

0010218f <vector99>:
.globl vector99
vector99:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $99
  102191:	6a 63                	push   $0x63
  jmp __alltraps
  102193:	e9 6a fc ff ff       	jmp    101e02 <__alltraps>

00102198 <vector100>:
.globl vector100
vector100:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $100
  10219a:	6a 64                	push   $0x64
  jmp __alltraps
  10219c:	e9 61 fc ff ff       	jmp    101e02 <__alltraps>

001021a1 <vector101>:
.globl vector101
vector101:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $101
  1021a3:	6a 65                	push   $0x65
  jmp __alltraps
  1021a5:	e9 58 fc ff ff       	jmp    101e02 <__alltraps>

001021aa <vector102>:
.globl vector102
vector102:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $102
  1021ac:	6a 66                	push   $0x66
  jmp __alltraps
  1021ae:	e9 4f fc ff ff       	jmp    101e02 <__alltraps>

001021b3 <vector103>:
.globl vector103
vector103:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $103
  1021b5:	6a 67                	push   $0x67
  jmp __alltraps
  1021b7:	e9 46 fc ff ff       	jmp    101e02 <__alltraps>

001021bc <vector104>:
.globl vector104
vector104:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $104
  1021be:	6a 68                	push   $0x68
  jmp __alltraps
  1021c0:	e9 3d fc ff ff       	jmp    101e02 <__alltraps>

001021c5 <vector105>:
.globl vector105
vector105:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $105
  1021c7:	6a 69                	push   $0x69
  jmp __alltraps
  1021c9:	e9 34 fc ff ff       	jmp    101e02 <__alltraps>

001021ce <vector106>:
.globl vector106
vector106:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $106
  1021d0:	6a 6a                	push   $0x6a
  jmp __alltraps
  1021d2:	e9 2b fc ff ff       	jmp    101e02 <__alltraps>

001021d7 <vector107>:
.globl vector107
vector107:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $107
  1021d9:	6a 6b                	push   $0x6b
  jmp __alltraps
  1021db:	e9 22 fc ff ff       	jmp    101e02 <__alltraps>

001021e0 <vector108>:
.globl vector108
vector108:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $108
  1021e2:	6a 6c                	push   $0x6c
  jmp __alltraps
  1021e4:	e9 19 fc ff ff       	jmp    101e02 <__alltraps>

001021e9 <vector109>:
.globl vector109
vector109:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $109
  1021eb:	6a 6d                	push   $0x6d
  jmp __alltraps
  1021ed:	e9 10 fc ff ff       	jmp    101e02 <__alltraps>

001021f2 <vector110>:
.globl vector110
vector110:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $110
  1021f4:	6a 6e                	push   $0x6e
  jmp __alltraps
  1021f6:	e9 07 fc ff ff       	jmp    101e02 <__alltraps>

001021fb <vector111>:
.globl vector111
vector111:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $111
  1021fd:	6a 6f                	push   $0x6f
  jmp __alltraps
  1021ff:	e9 fe fb ff ff       	jmp    101e02 <__alltraps>

00102204 <vector112>:
.globl vector112
vector112:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $112
  102206:	6a 70                	push   $0x70
  jmp __alltraps
  102208:	e9 f5 fb ff ff       	jmp    101e02 <__alltraps>

0010220d <vector113>:
.globl vector113
vector113:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $113
  10220f:	6a 71                	push   $0x71
  jmp __alltraps
  102211:	e9 ec fb ff ff       	jmp    101e02 <__alltraps>

00102216 <vector114>:
.globl vector114
vector114:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $114
  102218:	6a 72                	push   $0x72
  jmp __alltraps
  10221a:	e9 e3 fb ff ff       	jmp    101e02 <__alltraps>

0010221f <vector115>:
.globl vector115
vector115:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $115
  102221:	6a 73                	push   $0x73
  jmp __alltraps
  102223:	e9 da fb ff ff       	jmp    101e02 <__alltraps>

00102228 <vector116>:
.globl vector116
vector116:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $116
  10222a:	6a 74                	push   $0x74
  jmp __alltraps
  10222c:	e9 d1 fb ff ff       	jmp    101e02 <__alltraps>

00102231 <vector117>:
.globl vector117
vector117:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $117
  102233:	6a 75                	push   $0x75
  jmp __alltraps
  102235:	e9 c8 fb ff ff       	jmp    101e02 <__alltraps>

0010223a <vector118>:
.globl vector118
vector118:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $118
  10223c:	6a 76                	push   $0x76
  jmp __alltraps
  10223e:	e9 bf fb ff ff       	jmp    101e02 <__alltraps>

00102243 <vector119>:
.globl vector119
vector119:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $119
  102245:	6a 77                	push   $0x77
  jmp __alltraps
  102247:	e9 b6 fb ff ff       	jmp    101e02 <__alltraps>

0010224c <vector120>:
.globl vector120
vector120:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $120
  10224e:	6a 78                	push   $0x78
  jmp __alltraps
  102250:	e9 ad fb ff ff       	jmp    101e02 <__alltraps>

00102255 <vector121>:
.globl vector121
vector121:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $121
  102257:	6a 79                	push   $0x79
  jmp __alltraps
  102259:	e9 a4 fb ff ff       	jmp    101e02 <__alltraps>

0010225e <vector122>:
.globl vector122
vector122:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $122
  102260:	6a 7a                	push   $0x7a
  jmp __alltraps
  102262:	e9 9b fb ff ff       	jmp    101e02 <__alltraps>

00102267 <vector123>:
.globl vector123
vector123:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $123
  102269:	6a 7b                	push   $0x7b
  jmp __alltraps
  10226b:	e9 92 fb ff ff       	jmp    101e02 <__alltraps>

00102270 <vector124>:
.globl vector124
vector124:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $124
  102272:	6a 7c                	push   $0x7c
  jmp __alltraps
  102274:	e9 89 fb ff ff       	jmp    101e02 <__alltraps>

00102279 <vector125>:
.globl vector125
vector125:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $125
  10227b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10227d:	e9 80 fb ff ff       	jmp    101e02 <__alltraps>

00102282 <vector126>:
.globl vector126
vector126:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $126
  102284:	6a 7e                	push   $0x7e
  jmp __alltraps
  102286:	e9 77 fb ff ff       	jmp    101e02 <__alltraps>

0010228b <vector127>:
.globl vector127
vector127:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $127
  10228d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10228f:	e9 6e fb ff ff       	jmp    101e02 <__alltraps>

00102294 <vector128>:
.globl vector128
vector128:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $128
  102296:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10229b:	e9 62 fb ff ff       	jmp    101e02 <__alltraps>

001022a0 <vector129>:
.globl vector129
vector129:
  pushl $0
  1022a0:	6a 00                	push   $0x0
  pushl $129
  1022a2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1022a7:	e9 56 fb ff ff       	jmp    101e02 <__alltraps>

001022ac <vector130>:
.globl vector130
vector130:
  pushl $0
  1022ac:	6a 00                	push   $0x0
  pushl $130
  1022ae:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1022b3:	e9 4a fb ff ff       	jmp    101e02 <__alltraps>

001022b8 <vector131>:
.globl vector131
vector131:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $131
  1022ba:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1022bf:	e9 3e fb ff ff       	jmp    101e02 <__alltraps>

001022c4 <vector132>:
.globl vector132
vector132:
  pushl $0
  1022c4:	6a 00                	push   $0x0
  pushl $132
  1022c6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1022cb:	e9 32 fb ff ff       	jmp    101e02 <__alltraps>

001022d0 <vector133>:
.globl vector133
vector133:
  pushl $0
  1022d0:	6a 00                	push   $0x0
  pushl $133
  1022d2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1022d7:	e9 26 fb ff ff       	jmp    101e02 <__alltraps>

001022dc <vector134>:
.globl vector134
vector134:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $134
  1022de:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1022e3:	e9 1a fb ff ff       	jmp    101e02 <__alltraps>

001022e8 <vector135>:
.globl vector135
vector135:
  pushl $0
  1022e8:	6a 00                	push   $0x0
  pushl $135
  1022ea:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  1022ef:	e9 0e fb ff ff       	jmp    101e02 <__alltraps>

001022f4 <vector136>:
.globl vector136
vector136:
  pushl $0
  1022f4:	6a 00                	push   $0x0
  pushl $136
  1022f6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  1022fb:	e9 02 fb ff ff       	jmp    101e02 <__alltraps>

00102300 <vector137>:
.globl vector137
vector137:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $137
  102302:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102307:	e9 f6 fa ff ff       	jmp    101e02 <__alltraps>

0010230c <vector138>:
.globl vector138
vector138:
  pushl $0
  10230c:	6a 00                	push   $0x0
  pushl $138
  10230e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102313:	e9 ea fa ff ff       	jmp    101e02 <__alltraps>

00102318 <vector139>:
.globl vector139
vector139:
  pushl $0
  102318:	6a 00                	push   $0x0
  pushl $139
  10231a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10231f:	e9 de fa ff ff       	jmp    101e02 <__alltraps>

00102324 <vector140>:
.globl vector140
vector140:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $140
  102326:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10232b:	e9 d2 fa ff ff       	jmp    101e02 <__alltraps>

00102330 <vector141>:
.globl vector141
vector141:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $141
  102332:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102337:	e9 c6 fa ff ff       	jmp    101e02 <__alltraps>

0010233c <vector142>:
.globl vector142
vector142:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $142
  10233e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102343:	e9 ba fa ff ff       	jmp    101e02 <__alltraps>

00102348 <vector143>:
.globl vector143
vector143:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $143
  10234a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10234f:	e9 ae fa ff ff       	jmp    101e02 <__alltraps>

00102354 <vector144>:
.globl vector144
vector144:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $144
  102356:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  10235b:	e9 a2 fa ff ff       	jmp    101e02 <__alltraps>

00102360 <vector145>:
.globl vector145
vector145:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $145
  102362:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102367:	e9 96 fa ff ff       	jmp    101e02 <__alltraps>

0010236c <vector146>:
.globl vector146
vector146:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $146
  10236e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102373:	e9 8a fa ff ff       	jmp    101e02 <__alltraps>

00102378 <vector147>:
.globl vector147
vector147:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $147
  10237a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10237f:	e9 7e fa ff ff       	jmp    101e02 <__alltraps>

00102384 <vector148>:
.globl vector148
vector148:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $148
  102386:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10238b:	e9 72 fa ff ff       	jmp    101e02 <__alltraps>

00102390 <vector149>:
.globl vector149
vector149:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $149
  102392:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102397:	e9 66 fa ff ff       	jmp    101e02 <__alltraps>

0010239c <vector150>:
.globl vector150
vector150:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $150
  10239e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1023a3:	e9 5a fa ff ff       	jmp    101e02 <__alltraps>

001023a8 <vector151>:
.globl vector151
vector151:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $151
  1023aa:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1023af:	e9 4e fa ff ff       	jmp    101e02 <__alltraps>

001023b4 <vector152>:
.globl vector152
vector152:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $152
  1023b6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1023bb:	e9 42 fa ff ff       	jmp    101e02 <__alltraps>

001023c0 <vector153>:
.globl vector153
vector153:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $153
  1023c2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1023c7:	e9 36 fa ff ff       	jmp    101e02 <__alltraps>

001023cc <vector154>:
.globl vector154
vector154:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $154
  1023ce:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1023d3:	e9 2a fa ff ff       	jmp    101e02 <__alltraps>

001023d8 <vector155>:
.globl vector155
vector155:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $155
  1023da:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1023df:	e9 1e fa ff ff       	jmp    101e02 <__alltraps>

001023e4 <vector156>:
.globl vector156
vector156:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $156
  1023e6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  1023eb:	e9 12 fa ff ff       	jmp    101e02 <__alltraps>

001023f0 <vector157>:
.globl vector157
vector157:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $157
  1023f2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  1023f7:	e9 06 fa ff ff       	jmp    101e02 <__alltraps>

001023fc <vector158>:
.globl vector158
vector158:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $158
  1023fe:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102403:	e9 fa f9 ff ff       	jmp    101e02 <__alltraps>

00102408 <vector159>:
.globl vector159
vector159:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $159
  10240a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10240f:	e9 ee f9 ff ff       	jmp    101e02 <__alltraps>

00102414 <vector160>:
.globl vector160
vector160:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $160
  102416:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10241b:	e9 e2 f9 ff ff       	jmp    101e02 <__alltraps>

00102420 <vector161>:
.globl vector161
vector161:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $161
  102422:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102427:	e9 d6 f9 ff ff       	jmp    101e02 <__alltraps>

0010242c <vector162>:
.globl vector162
vector162:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $162
  10242e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102433:	e9 ca f9 ff ff       	jmp    101e02 <__alltraps>

00102438 <vector163>:
.globl vector163
vector163:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $163
  10243a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10243f:	e9 be f9 ff ff       	jmp    101e02 <__alltraps>

00102444 <vector164>:
.globl vector164
vector164:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $164
  102446:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10244b:	e9 b2 f9 ff ff       	jmp    101e02 <__alltraps>

00102450 <vector165>:
.globl vector165
vector165:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $165
  102452:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102457:	e9 a6 f9 ff ff       	jmp    101e02 <__alltraps>

0010245c <vector166>:
.globl vector166
vector166:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $166
  10245e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  102463:	e9 9a f9 ff ff       	jmp    101e02 <__alltraps>

00102468 <vector167>:
.globl vector167
vector167:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $167
  10246a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10246f:	e9 8e f9 ff ff       	jmp    101e02 <__alltraps>

00102474 <vector168>:
.globl vector168
vector168:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $168
  102476:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10247b:	e9 82 f9 ff ff       	jmp    101e02 <__alltraps>

00102480 <vector169>:
.globl vector169
vector169:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $169
  102482:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102487:	e9 76 f9 ff ff       	jmp    101e02 <__alltraps>

0010248c <vector170>:
.globl vector170
vector170:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $170
  10248e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102493:	e9 6a f9 ff ff       	jmp    101e02 <__alltraps>

00102498 <vector171>:
.globl vector171
vector171:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $171
  10249a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10249f:	e9 5e f9 ff ff       	jmp    101e02 <__alltraps>

001024a4 <vector172>:
.globl vector172
vector172:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $172
  1024a6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1024ab:	e9 52 f9 ff ff       	jmp    101e02 <__alltraps>

001024b0 <vector173>:
.globl vector173
vector173:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $173
  1024b2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1024b7:	e9 46 f9 ff ff       	jmp    101e02 <__alltraps>

001024bc <vector174>:
.globl vector174
vector174:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $174
  1024be:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1024c3:	e9 3a f9 ff ff       	jmp    101e02 <__alltraps>

001024c8 <vector175>:
.globl vector175
vector175:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $175
  1024ca:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1024cf:	e9 2e f9 ff ff       	jmp    101e02 <__alltraps>

001024d4 <vector176>:
.globl vector176
vector176:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $176
  1024d6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1024db:	e9 22 f9 ff ff       	jmp    101e02 <__alltraps>

001024e0 <vector177>:
.globl vector177
vector177:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $177
  1024e2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  1024e7:	e9 16 f9 ff ff       	jmp    101e02 <__alltraps>

001024ec <vector178>:
.globl vector178
vector178:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $178
  1024ee:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  1024f3:	e9 0a f9 ff ff       	jmp    101e02 <__alltraps>

001024f8 <vector179>:
.globl vector179
vector179:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $179
  1024fa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  1024ff:	e9 fe f8 ff ff       	jmp    101e02 <__alltraps>

00102504 <vector180>:
.globl vector180
vector180:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $180
  102506:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10250b:	e9 f2 f8 ff ff       	jmp    101e02 <__alltraps>

00102510 <vector181>:
.globl vector181
vector181:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $181
  102512:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102517:	e9 e6 f8 ff ff       	jmp    101e02 <__alltraps>

0010251c <vector182>:
.globl vector182
vector182:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $182
  10251e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102523:	e9 da f8 ff ff       	jmp    101e02 <__alltraps>

00102528 <vector183>:
.globl vector183
vector183:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $183
  10252a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10252f:	e9 ce f8 ff ff       	jmp    101e02 <__alltraps>

00102534 <vector184>:
.globl vector184
vector184:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $184
  102536:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10253b:	e9 c2 f8 ff ff       	jmp    101e02 <__alltraps>

00102540 <vector185>:
.globl vector185
vector185:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $185
  102542:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102547:	e9 b6 f8 ff ff       	jmp    101e02 <__alltraps>

0010254c <vector186>:
.globl vector186
vector186:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $186
  10254e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  102553:	e9 aa f8 ff ff       	jmp    101e02 <__alltraps>

00102558 <vector187>:
.globl vector187
vector187:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $187
  10255a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10255f:	e9 9e f8 ff ff       	jmp    101e02 <__alltraps>

00102564 <vector188>:
.globl vector188
vector188:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $188
  102566:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  10256b:	e9 92 f8 ff ff       	jmp    101e02 <__alltraps>

00102570 <vector189>:
.globl vector189
vector189:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $189
  102572:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102577:	e9 86 f8 ff ff       	jmp    101e02 <__alltraps>

0010257c <vector190>:
.globl vector190
vector190:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $190
  10257e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102583:	e9 7a f8 ff ff       	jmp    101e02 <__alltraps>

00102588 <vector191>:
.globl vector191
vector191:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $191
  10258a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10258f:	e9 6e f8 ff ff       	jmp    101e02 <__alltraps>

00102594 <vector192>:
.globl vector192
vector192:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $192
  102596:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10259b:	e9 62 f8 ff ff       	jmp    101e02 <__alltraps>

001025a0 <vector193>:
.globl vector193
vector193:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $193
  1025a2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1025a7:	e9 56 f8 ff ff       	jmp    101e02 <__alltraps>

001025ac <vector194>:
.globl vector194
vector194:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $194
  1025ae:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1025b3:	e9 4a f8 ff ff       	jmp    101e02 <__alltraps>

001025b8 <vector195>:
.globl vector195
vector195:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $195
  1025ba:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1025bf:	e9 3e f8 ff ff       	jmp    101e02 <__alltraps>

001025c4 <vector196>:
.globl vector196
vector196:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $196
  1025c6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1025cb:	e9 32 f8 ff ff       	jmp    101e02 <__alltraps>

001025d0 <vector197>:
.globl vector197
vector197:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $197
  1025d2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1025d7:	e9 26 f8 ff ff       	jmp    101e02 <__alltraps>

001025dc <vector198>:
.globl vector198
vector198:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $198
  1025de:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1025e3:	e9 1a f8 ff ff       	jmp    101e02 <__alltraps>

001025e8 <vector199>:
.globl vector199
vector199:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $199
  1025ea:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  1025ef:	e9 0e f8 ff ff       	jmp    101e02 <__alltraps>

001025f4 <vector200>:
.globl vector200
vector200:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $200
  1025f6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  1025fb:	e9 02 f8 ff ff       	jmp    101e02 <__alltraps>

00102600 <vector201>:
.globl vector201
vector201:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $201
  102602:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102607:	e9 f6 f7 ff ff       	jmp    101e02 <__alltraps>

0010260c <vector202>:
.globl vector202
vector202:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $202
  10260e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102613:	e9 ea f7 ff ff       	jmp    101e02 <__alltraps>

00102618 <vector203>:
.globl vector203
vector203:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $203
  10261a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10261f:	e9 de f7 ff ff       	jmp    101e02 <__alltraps>

00102624 <vector204>:
.globl vector204
vector204:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $204
  102626:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10262b:	e9 d2 f7 ff ff       	jmp    101e02 <__alltraps>

00102630 <vector205>:
.globl vector205
vector205:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $205
  102632:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102637:	e9 c6 f7 ff ff       	jmp    101e02 <__alltraps>

0010263c <vector206>:
.globl vector206
vector206:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $206
  10263e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102643:	e9 ba f7 ff ff       	jmp    101e02 <__alltraps>

00102648 <vector207>:
.globl vector207
vector207:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $207
  10264a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10264f:	e9 ae f7 ff ff       	jmp    101e02 <__alltraps>

00102654 <vector208>:
.globl vector208
vector208:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $208
  102656:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  10265b:	e9 a2 f7 ff ff       	jmp    101e02 <__alltraps>

00102660 <vector209>:
.globl vector209
vector209:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $209
  102662:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102667:	e9 96 f7 ff ff       	jmp    101e02 <__alltraps>

0010266c <vector210>:
.globl vector210
vector210:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $210
  10266e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102673:	e9 8a f7 ff ff       	jmp    101e02 <__alltraps>

00102678 <vector211>:
.globl vector211
vector211:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $211
  10267a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10267f:	e9 7e f7 ff ff       	jmp    101e02 <__alltraps>

00102684 <vector212>:
.globl vector212
vector212:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $212
  102686:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10268b:	e9 72 f7 ff ff       	jmp    101e02 <__alltraps>

00102690 <vector213>:
.globl vector213
vector213:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $213
  102692:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102697:	e9 66 f7 ff ff       	jmp    101e02 <__alltraps>

0010269c <vector214>:
.globl vector214
vector214:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $214
  10269e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1026a3:	e9 5a f7 ff ff       	jmp    101e02 <__alltraps>

001026a8 <vector215>:
.globl vector215
vector215:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $215
  1026aa:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1026af:	e9 4e f7 ff ff       	jmp    101e02 <__alltraps>

001026b4 <vector216>:
.globl vector216
vector216:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $216
  1026b6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1026bb:	e9 42 f7 ff ff       	jmp    101e02 <__alltraps>

001026c0 <vector217>:
.globl vector217
vector217:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $217
  1026c2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1026c7:	e9 36 f7 ff ff       	jmp    101e02 <__alltraps>

001026cc <vector218>:
.globl vector218
vector218:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $218
  1026ce:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1026d3:	e9 2a f7 ff ff       	jmp    101e02 <__alltraps>

001026d8 <vector219>:
.globl vector219
vector219:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $219
  1026da:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1026df:	e9 1e f7 ff ff       	jmp    101e02 <__alltraps>

001026e4 <vector220>:
.globl vector220
vector220:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $220
  1026e6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  1026eb:	e9 12 f7 ff ff       	jmp    101e02 <__alltraps>

001026f0 <vector221>:
.globl vector221
vector221:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $221
  1026f2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  1026f7:	e9 06 f7 ff ff       	jmp    101e02 <__alltraps>

001026fc <vector222>:
.globl vector222
vector222:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $222
  1026fe:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102703:	e9 fa f6 ff ff       	jmp    101e02 <__alltraps>

00102708 <vector223>:
.globl vector223
vector223:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $223
  10270a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10270f:	e9 ee f6 ff ff       	jmp    101e02 <__alltraps>

00102714 <vector224>:
.globl vector224
vector224:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $224
  102716:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10271b:	e9 e2 f6 ff ff       	jmp    101e02 <__alltraps>

00102720 <vector225>:
.globl vector225
vector225:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $225
  102722:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102727:	e9 d6 f6 ff ff       	jmp    101e02 <__alltraps>

0010272c <vector226>:
.globl vector226
vector226:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $226
  10272e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102733:	e9 ca f6 ff ff       	jmp    101e02 <__alltraps>

00102738 <vector227>:
.globl vector227
vector227:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $227
  10273a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10273f:	e9 be f6 ff ff       	jmp    101e02 <__alltraps>

00102744 <vector228>:
.globl vector228
vector228:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $228
  102746:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10274b:	e9 b2 f6 ff ff       	jmp    101e02 <__alltraps>

00102750 <vector229>:
.globl vector229
vector229:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $229
  102752:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102757:	e9 a6 f6 ff ff       	jmp    101e02 <__alltraps>

0010275c <vector230>:
.globl vector230
vector230:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $230
  10275e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  102763:	e9 9a f6 ff ff       	jmp    101e02 <__alltraps>

00102768 <vector231>:
.globl vector231
vector231:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $231
  10276a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10276f:	e9 8e f6 ff ff       	jmp    101e02 <__alltraps>

00102774 <vector232>:
.globl vector232
vector232:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $232
  102776:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10277b:	e9 82 f6 ff ff       	jmp    101e02 <__alltraps>

00102780 <vector233>:
.globl vector233
vector233:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $233
  102782:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102787:	e9 76 f6 ff ff       	jmp    101e02 <__alltraps>

0010278c <vector234>:
.globl vector234
vector234:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $234
  10278e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102793:	e9 6a f6 ff ff       	jmp    101e02 <__alltraps>

00102798 <vector235>:
.globl vector235
vector235:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $235
  10279a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10279f:	e9 5e f6 ff ff       	jmp    101e02 <__alltraps>

001027a4 <vector236>:
.globl vector236
vector236:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $236
  1027a6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1027ab:	e9 52 f6 ff ff       	jmp    101e02 <__alltraps>

001027b0 <vector237>:
.globl vector237
vector237:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $237
  1027b2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1027b7:	e9 46 f6 ff ff       	jmp    101e02 <__alltraps>

001027bc <vector238>:
.globl vector238
vector238:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $238
  1027be:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1027c3:	e9 3a f6 ff ff       	jmp    101e02 <__alltraps>

001027c8 <vector239>:
.globl vector239
vector239:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $239
  1027ca:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1027cf:	e9 2e f6 ff ff       	jmp    101e02 <__alltraps>

001027d4 <vector240>:
.globl vector240
vector240:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $240
  1027d6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1027db:	e9 22 f6 ff ff       	jmp    101e02 <__alltraps>

001027e0 <vector241>:
.globl vector241
vector241:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $241
  1027e2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  1027e7:	e9 16 f6 ff ff       	jmp    101e02 <__alltraps>

001027ec <vector242>:
.globl vector242
vector242:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $242
  1027ee:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  1027f3:	e9 0a f6 ff ff       	jmp    101e02 <__alltraps>

001027f8 <vector243>:
.globl vector243
vector243:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $243
  1027fa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  1027ff:	e9 fe f5 ff ff       	jmp    101e02 <__alltraps>

00102804 <vector244>:
.globl vector244
vector244:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $244
  102806:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10280b:	e9 f2 f5 ff ff       	jmp    101e02 <__alltraps>

00102810 <vector245>:
.globl vector245
vector245:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $245
  102812:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102817:	e9 e6 f5 ff ff       	jmp    101e02 <__alltraps>

0010281c <vector246>:
.globl vector246
vector246:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $246
  10281e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102823:	e9 da f5 ff ff       	jmp    101e02 <__alltraps>

00102828 <vector247>:
.globl vector247
vector247:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $247
  10282a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10282f:	e9 ce f5 ff ff       	jmp    101e02 <__alltraps>

00102834 <vector248>:
.globl vector248
vector248:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $248
  102836:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10283b:	e9 c2 f5 ff ff       	jmp    101e02 <__alltraps>

00102840 <vector249>:
.globl vector249
vector249:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $249
  102842:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102847:	e9 b6 f5 ff ff       	jmp    101e02 <__alltraps>

0010284c <vector250>:
.globl vector250
vector250:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $250
  10284e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  102853:	e9 aa f5 ff ff       	jmp    101e02 <__alltraps>

00102858 <vector251>:
.globl vector251
vector251:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $251
  10285a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10285f:	e9 9e f5 ff ff       	jmp    101e02 <__alltraps>

00102864 <vector252>:
.globl vector252
vector252:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $252
  102866:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  10286b:	e9 92 f5 ff ff       	jmp    101e02 <__alltraps>

00102870 <vector253>:
.globl vector253
vector253:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $253
  102872:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102877:	e9 86 f5 ff ff       	jmp    101e02 <__alltraps>

0010287c <vector254>:
.globl vector254
vector254:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $254
  10287e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102883:	e9 7a f5 ff ff       	jmp    101e02 <__alltraps>

00102888 <vector255>:
.globl vector255
vector255:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $255
  10288a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10288f:	e9 6e f5 ff ff       	jmp    101e02 <__alltraps>

00102894 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102894:	55                   	push   %ebp
  102895:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102897:	8b 55 08             	mov    0x8(%ebp),%edx
  10289a:	a1 64 89 11 00       	mov    0x118964,%eax
  10289f:	29 c2                	sub    %eax,%edx
  1028a1:	89 d0                	mov    %edx,%eax
  1028a3:	c1 f8 02             	sar    $0x2,%eax
  1028a6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1028ac:	5d                   	pop    %ebp
  1028ad:	c3                   	ret    

001028ae <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1028ae:	55                   	push   %ebp
  1028af:	89 e5                	mov    %esp,%ebp
  1028b1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1028b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1028b7:	89 04 24             	mov    %eax,(%esp)
  1028ba:	e8 d5 ff ff ff       	call   102894 <page2ppn>
  1028bf:	c1 e0 0c             	shl    $0xc,%eax
}
  1028c2:	c9                   	leave  
  1028c3:	c3                   	ret    

001028c4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  1028c4:	55                   	push   %ebp
  1028c5:	89 e5                	mov    %esp,%ebp
    return page->ref;
  1028c7:	8b 45 08             	mov    0x8(%ebp),%eax
  1028ca:	8b 00                	mov    (%eax),%eax
}
  1028cc:	5d                   	pop    %ebp
  1028cd:	c3                   	ret    

001028ce <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  1028ce:	55                   	push   %ebp
  1028cf:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  1028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1028d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1028d7:	89 10                	mov    %edx,(%eax)
}
  1028d9:	5d                   	pop    %ebp
  1028da:	c3                   	ret    

001028db <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  1028db:	55                   	push   %ebp
  1028dc:	89 e5                	mov    %esp,%ebp
  1028de:	83 ec 10             	sub    $0x10,%esp
  1028e1:	c7 45 fc 50 89 11 00 	movl   $0x118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1028e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1028ee:	89 50 04             	mov    %edx,0x4(%eax)
  1028f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028f4:	8b 50 04             	mov    0x4(%eax),%edx
  1028f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1028fa:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  1028fc:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  102903:	00 00 00 
}
  102906:	c9                   	leave  
  102907:	c3                   	ret    

00102908 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  102908:	55                   	push   %ebp
  102909:	89 e5                	mov    %esp,%ebp
  10290b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  10290e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102912:	75 24                	jne    102938 <default_init_memmap+0x30>
  102914:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  10291b:	00 
  10291c:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102923:	00 
  102924:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  10292b:	00 
  10292c:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102933:	e8 95 e3 ff ff       	call   100ccd <__panic>
    struct Page *p = base;
  102938:	8b 45 08             	mov    0x8(%ebp),%eax
  10293b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  10293e:	e9 eb 00 00 00       	jmp    102a2e <default_init_memmap+0x126>
        assert(PageReserved(p));
  102943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102946:	83 c0 04             	add    $0x4,%eax
  102949:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  102950:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102953:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102956:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102959:	0f a3 10             	bt     %edx,(%eax)
  10295c:	19 c0                	sbb    %eax,%eax
  10295e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  102961:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102965:	0f 95 c0             	setne  %al
  102968:	0f b6 c0             	movzbl %al,%eax
  10296b:	85 c0                	test   %eax,%eax
  10296d:	75 24                	jne    102993 <default_init_memmap+0x8b>
  10296f:	c7 44 24 0c c1 66 10 	movl   $0x1066c1,0xc(%esp)
  102976:	00 
  102977:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10297e:	00 
  10297f:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102986:	00 
  102987:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10298e:	e8 3a e3 ff ff       	call   100ccd <__panic>
        p->flags = p->property = 0;
  102993:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102996:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  10299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a0:	8b 50 08             	mov    0x8(%eax),%edx
  1029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029a6:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  1029a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1029b0:	00 
  1029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029b4:	89 04 24             	mov    %eax,(%esp)
  1029b7:	e8 12 ff ff ff       	call   1028ce <set_page_ref>
        SetPageProperty(p);
  1029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029bf:	83 c0 04             	add    $0x4,%eax
  1029c2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  1029c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1029cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1029d2:	0f ab 10             	bts    %edx,(%eax)
        list_add(&free_list,&(p->page_link));
  1029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029d8:	83 c0 0c             	add    $0xc,%eax
  1029db:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
  1029e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
  1029e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1029eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1029ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1029f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1029f4:	8b 40 04             	mov    0x4(%eax),%eax
  1029f7:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1029fa:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1029fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a00:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102a03:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102a06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a09:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102a0c:	89 10                	mov    %edx,(%eax)
  102a0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102a11:	8b 10                	mov    (%eax),%edx
  102a13:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102a16:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102a19:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a1c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102a1f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102a22:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102a25:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102a28:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102a2a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a31:	89 d0                	mov    %edx,%eax
  102a33:	c1 e0 02             	shl    $0x2,%eax
  102a36:	01 d0                	add    %edx,%eax
  102a38:	c1 e0 02             	shl    $0x2,%eax
  102a3b:	89 c2                	mov    %eax,%edx
  102a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a40:	01 d0                	add    %edx,%eax
  102a42:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102a45:	0f 85 f8 fe ff ff    	jne    102943 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
        list_add(&free_list,&(p->page_link));
    }
    base->property = n;
  102a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  102a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a51:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    nr_free += n;
  102a54:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a5d:	01 d0                	add    %edx,%eax
  102a5f:	a3 58 89 11 00       	mov    %eax,0x118958
    //list_add(&free_list, &(base->page_link));
}
  102a64:	c9                   	leave  
  102a65:	c3                   	ret    

00102a66 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102a66:	55                   	push   %ebp
  102a67:	89 e5                	mov    %esp,%ebp
  102a69:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102a6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102a70:	75 24                	jne    102a96 <default_alloc_pages+0x30>
  102a72:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  102a79:	00 
  102a7a:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102a81:	00 
  102a82:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
  102a89:	00 
  102a8a:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102a91:	e8 37 e2 ff ff       	call   100ccd <__panic>
    if (n > nr_free) {
  102a96:	a1 58 89 11 00       	mov    0x118958,%eax
  102a9b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102a9e:	73 0a                	jae    102aaa <default_alloc_pages+0x44>
        return NULL;
  102aa0:	b8 00 00 00 00       	mov    $0x0,%eax
  102aa5:	e9 30 01 00 00       	jmp    102bda <default_alloc_pages+0x174>
    }
    struct Page *page = NULL;
  102aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102ab1:	c7 45 f0 50 89 11 00 	movl   $0x118950,-0x10(%ebp)
    while ((le = list_prev(le)) != &free_list) {
  102ab8:	eb 1c                	jmp    102ad6 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  102aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102abd:	83 e8 0c             	sub    $0xc,%eax
  102ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
  102ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ac6:	8b 40 08             	mov    0x8(%eax),%eax
  102ac9:	3b 45 08             	cmp    0x8(%ebp),%eax
  102acc:	72 08                	jb     102ad6 <default_alloc_pages+0x70>
            page = p;
  102ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102ad4:	eb 17                	jmp    102aed <default_alloc_pages+0x87>
  102ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ad9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102adf:	8b 00                	mov    (%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_prev(le)) != &free_list) {
  102ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102ae4:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102aeb:	75 cd                	jne    102aba <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102af1:	0f 84 e0 00 00 00    	je     102bd7 <default_alloc_pages+0x171>
    	list_entry_t *to_del = &(page->page_link);
  102af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102afa:	83 c0 0c             	add    $0xc,%eax
  102afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	list_entry_t *to_del_prev;
    	int i = 0;
  102b00:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    	for(i = 0;i < n;i++) {
  102b07:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  102b0e:	eb 7b                	jmp    102b8b <default_alloc_pages+0x125>
  102b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b13:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b16:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b19:	8b 00                	mov    (%eax),%eax
    		to_del_prev = list_prev(to_del);
  102b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    		struct Page *page_to_del = le2page(to_del, page_link);
  102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b21:	83 e8 0c             	sub    $0xc,%eax
  102b24:	89 45 dc             	mov    %eax,-0x24(%ebp)
    		SetPageReserved(page_to_del);
  102b27:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b2a:	83 c0 04             	add    $0x4,%eax
  102b2d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
  102b34:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102b37:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102b3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102b3d:	0f ab 10             	bts    %edx,(%eax)
    		ClearPageProperty(page_to_del);
  102b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b43:	83 c0 04             	add    $0x4,%eax
  102b46:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  102b4d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b50:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b53:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b56:	0f b3 10             	btr    %edx,(%eax)
  102b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102b5c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102b5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102b62:	8b 40 04             	mov    0x4(%eax),%eax
  102b65:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b68:	8b 12                	mov    (%edx),%edx
  102b6a:	89 55 b8             	mov    %edx,-0x48(%ebp)
  102b6d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102b70:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b73:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  102b76:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102b79:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b7c:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102b7f:	89 10                	mov    %edx,(%eax)
    		list_del(to_del);
    		to_del = to_del_prev;
  102b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    }
    if (page != NULL) {
    	list_entry_t *to_del = &(page->page_link);
    	list_entry_t *to_del_prev;
    	int i = 0;
    	for(i = 0;i < n;i++) {
  102b87:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  102b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b8e:	3b 45 08             	cmp    0x8(%ebp),%eax
  102b91:	0f 82 79 ff ff ff    	jb     102b10 <default_alloc_pages+0xaa>
    		ClearPageProperty(page_to_del);
    		list_del(to_del);
    		to_del = to_del_prev;
    	}
        //list_del(&(page->page_link));
        if (page->property > n) {
  102b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b9a:	8b 40 08             	mov    0x8(%eax),%eax
  102b9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  102ba0:	76 28                	jbe    102bca <default_alloc_pages+0x164>
            struct Page *p = page + n;
  102ba2:	8b 55 08             	mov    0x8(%ebp),%edx
  102ba5:	89 d0                	mov    %edx,%eax
  102ba7:	c1 e0 02             	shl    $0x2,%eax
  102baa:	01 d0                	add    %edx,%eax
  102bac:	c1 e0 02             	shl    $0x2,%eax
  102baf:	89 c2                	mov    %eax,%edx
  102bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bb4:	01 d0                	add    %edx,%eax
  102bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;
  102bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bbc:	8b 40 08             	mov    0x8(%eax),%eax
  102bbf:	2b 45 08             	sub    0x8(%ebp),%eax
  102bc2:	89 c2                	mov    %eax,%edx
  102bc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102bc7:	89 50 08             	mov    %edx,0x8(%eax)
            //list_add(&free_list, &(p->page_link));
        }
        nr_free -= n;
  102bca:	a1 58 89 11 00       	mov    0x118958,%eax
  102bcf:	2b 45 08             	sub    0x8(%ebp),%eax
  102bd2:	a3 58 89 11 00       	mov    %eax,0x118958
        //ClearPageProperty(page);
    }
    return page;
  102bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102bda:	c9                   	leave  
  102bdb:	c3                   	ret    

00102bdc <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102bdc:	55                   	push   %ebp
  102bdd:	89 e5                	mov    %esp,%ebp
  102bdf:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  102be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102be6:	75 24                	jne    102c0c <default_free_pages+0x30>
  102be8:	c7 44 24 0c 90 66 10 	movl   $0x106690,0xc(%esp)
  102bef:	00 
  102bf0:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102bf7:	00 
  102bf8:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
  102bff:	00 
  102c00:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102c07:	e8 c1 e0 ff ff       	call   100ccd <__panic>
    struct Page *p = base;
  102c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  102c12:	eb 21                	jmp    102c35 <default_free_pages+0x59>
        //assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
  102c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  102c1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102c25:	00 
  102c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102c29:	89 04 24             	mov    %eax,(%esp)
  102c2c:	e8 9d fc ff ff       	call   1028ce <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
  102c31:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102c35:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c38:	89 d0                	mov    %edx,%eax
  102c3a:	c1 e0 02             	shl    $0x2,%eax
  102c3d:	01 d0                	add    %edx,%eax
  102c3f:	c1 e0 02             	shl    $0x2,%eax
  102c42:	89 c2                	mov    %eax,%edx
  102c44:	8b 45 08             	mov    0x8(%ebp),%eax
  102c47:	01 d0                	add    %edx,%eax
  102c49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102c4c:	75 c6                	jne    102c14 <default_free_pages+0x38>
        //assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
  102c4e:	8b 45 08             	mov    0x8(%ebp),%eax
  102c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c54:	89 50 08             	mov    %edx,0x8(%eax)
    ClearPageReserved(base);
  102c57:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5a:	83 c0 04             	add    $0x4,%eax
  102c5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  102c64:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102c6d:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102c70:	8b 45 08             	mov    0x8(%ebp),%eax
  102c73:	83 c0 04             	add    $0x4,%eax
  102c76:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  102c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102c80:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102c83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102c86:	0f ab 10             	bts    %edx,(%eax)
  102c89:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c93:	8b 00                	mov    (%eax),%eax
    list_entry_t *le = list_prev(&free_list);
  102c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  102c98:	eb 21                	jmp    102cbb <default_free_pages+0xdf>
        p = le2page(le, page_link);
  102c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c9d:	83 e8 0c             	sub    $0xc,%eax
  102ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base < p) {
  102ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  102ca6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ca9:	73 02                	jae    102cad <default_free_pages+0xd1>
        			le = list_next(le);
        			p = le2page(le, page_link);
        		}
        	}  */
//pay attention to the situation when all the pages have been allocated and the list is empty
        	break;
  102cab:	eb 17                	jmp    102cc4 <default_free_pages+0xe8>
  102cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cb0:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102cb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102cb6:	8b 00                	mov    (%eax),%eax
//            p->property += base->property;
//            ClearPageProperty(base);
//            base = p;
//            list_del(&(p->page_link));
//        }
        le = list_prev(le);
  102cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    base->property = n;
    ClearPageReserved(base);
    SetPageProperty(base);
    list_entry_t *le = list_prev(&free_list);
    while (le != &free_list) {
  102cbb:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102cc2:	75 d6                	jne    102c9a <default_free_pages+0xbe>
//            base = p;
//            list_del(&(p->page_link));
//        }
        le = list_prev(le);
    }
    p = le2page(le, page_link);
  102cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102cc7:	83 e8 0c             	sub    $0xc,%eax
  102cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (base + n == p) {
  102ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cd0:	89 d0                	mov    %edx,%eax
  102cd2:	c1 e0 02             	shl    $0x2,%eax
  102cd5:	01 d0                	add    %edx,%eax
  102cd7:	c1 e0 02             	shl    $0x2,%eax
  102cda:	89 c2                	mov    %eax,%edx
  102cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  102cdf:	01 d0                	add    %edx,%eax
  102ce1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ce4:	75 1e                	jne    102d04 <default_free_pages+0x128>
		base->property += p->property;
  102ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce9:	8b 50 08             	mov    0x8(%eax),%edx
  102cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cef:	8b 40 08             	mov    0x8(%eax),%eax
  102cf2:	01 c2                	add    %eax,%edx
  102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf7:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
  102cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	for(p = base;p < base + n;p++) {
  102d04:	8b 45 08             	mov    0x8(%ebp),%eax
  102d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102d0a:	eb 58                	jmp    102d64 <default_free_pages+0x188>
		list_add(le, &(p->page_link));
  102d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d0f:	8d 50 0c             	lea    0xc(%eax),%edx
  102d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102d18:	89 55 d0             	mov    %edx,-0x30(%ebp)
  102d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102d1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
  102d21:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102d24:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102d27:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102d2a:	8b 40 04             	mov    0x4(%eax),%eax
  102d2d:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102d30:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  102d33:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102d36:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102d39:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102d3c:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d3f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102d42:	89 10                	mov    %edx,(%eax)
  102d44:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d47:	8b 10                	mov    (%eax),%edx
  102d49:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d4c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102d4f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d52:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102d55:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102d58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d5b:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102d5e:	89 10                	mov    %edx,(%eax)
    p = le2page(le, page_link);
	if (base + n == p) {
		base->property += p->property;
		p->property = 0;
	}
	for(p = base;p < base + n;p++) {
  102d60:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102d64:	8b 55 0c             	mov    0xc(%ebp),%edx
  102d67:	89 d0                	mov    %edx,%eax
  102d69:	c1 e0 02             	shl    $0x2,%eax
  102d6c:	01 d0                	add    %edx,%eax
  102d6e:	c1 e0 02             	shl    $0x2,%eax
  102d71:	89 c2                	mov    %eax,%edx
  102d73:	8b 45 08             	mov    0x8(%ebp),%eax
  102d76:	01 d0                	add    %edx,%eax
  102d78:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102d7b:	77 8f                	ja     102d0c <default_free_pages+0x130>
		list_add(le, &(p->page_link));
	}
	le = list_next(&(base->page_link));
  102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d80:	83 c0 0c             	add    $0xc,%eax
  102d83:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102d86:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102d89:	8b 40 04             	mov    0x4(%eax),%eax
  102d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le, page_link);
  102d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d92:	83 e8 0c             	sub    $0xc,%eax
  102d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (le != &free_list && p == base - 1) {
  102d98:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102d9f:	74 58                	je     102df9 <default_free_pages+0x21d>
  102da1:	8b 45 08             	mov    0x8(%ebp),%eax
  102da4:	83 e8 14             	sub    $0x14,%eax
  102da7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102daa:	75 4d                	jne    102df9 <default_free_pages+0x21d>
		while (le != &free_list) {
  102dac:	eb 42                	jmp    102df0 <default_free_pages+0x214>
			if (p->property) {
  102dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102db1:	8b 40 08             	mov    0x8(%eax),%eax
  102db4:	85 c0                	test   %eax,%eax
  102db6:	74 20                	je     102dd8 <default_free_pages+0x1fc>
				p->property += base->property;
  102db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dbb:	8b 50 08             	mov    0x8(%eax),%edx
  102dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  102dc1:	8b 40 08             	mov    0x8(%eax),%eax
  102dc4:	01 c2                	add    %eax,%edx
  102dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102dc9:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
  102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  102dcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
  102dd6:	eb 21                	jmp    102df9 <default_free_pages+0x21d>
  102dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ddb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102dde:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102de1:	8b 40 04             	mov    0x4(%eax),%eax
			}
			le = list_next(le);
  102de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			p = le2page(le, page_link);
  102de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102dea:	83 e8 0c             	sub    $0xc,%eax
  102ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
		list_add(le, &(p->page_link));
	}
	le = list_next(&(base->page_link));
	p = le2page(le, page_link);
	if (le != &free_list && p == base - 1) {
		while (le != &free_list) {
  102df0:	81 7d f0 50 89 11 00 	cmpl   $0x118950,-0x10(%ebp)
  102df7:	75 b5                	jne    102dae <default_free_pages+0x1d2>
			}
			le = list_next(le);
			p = le2page(le, page_link);
		}
	}
    nr_free += n;
  102df9:	8b 15 58 89 11 00    	mov    0x118958,%edx
  102dff:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e02:	01 d0                	add    %edx,%eax
  102e04:	a3 58 89 11 00       	mov    %eax,0x118958
//    cprintf("%d\n", le2page(list_prev(&free_list), page_link)->property);
//    list_add(&free_list, &(base->page_link));
}
  102e09:	c9                   	leave  
  102e0a:	c3                   	ret    

00102e0b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  102e0b:	55                   	push   %ebp
  102e0c:	89 e5                	mov    %esp,%ebp
    return nr_free;
  102e0e:	a1 58 89 11 00       	mov    0x118958,%eax
}
  102e13:	5d                   	pop    %ebp
  102e14:	c3                   	ret    

00102e15 <basic_check>:

static void
basic_check(void) {
  102e15:	55                   	push   %ebp
  102e16:	89 e5                	mov    %esp,%ebp
  102e18:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  102e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  102e2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e35:	e8 85 0e 00 00       	call   103cbf <alloc_pages>
  102e3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  102e41:	75 24                	jne    102e67 <basic_check+0x52>
  102e43:	c7 44 24 0c d1 66 10 	movl   $0x1066d1,0xc(%esp)
  102e4a:	00 
  102e4b:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102e52:	00 
  102e53:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  102e5a:	00 
  102e5b:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102e62:	e8 66 de ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
  102e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102e6e:	e8 4c 0e 00 00       	call   103cbf <alloc_pages>
  102e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102e7a:	75 24                	jne    102ea0 <basic_check+0x8b>
  102e7c:	c7 44 24 0c ed 66 10 	movl   $0x1066ed,0xc(%esp)
  102e83:	00 
  102e84:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102e8b:	00 
  102e8c:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  102e93:	00 
  102e94:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102e9b:	e8 2d de ff ff       	call   100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
  102ea0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  102ea7:	e8 13 0e 00 00       	call   103cbf <alloc_pages>
  102eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102eb3:	75 24                	jne    102ed9 <basic_check+0xc4>
  102eb5:	c7 44 24 0c 09 67 10 	movl   $0x106709,0xc(%esp)
  102ebc:	00 
  102ebd:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102ec4:	00 
  102ec5:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  102ecc:	00 
  102ecd:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102ed4:	e8 f4 dd ff ff       	call   100ccd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  102ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102edc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  102edf:	74 10                	je     102ef1 <basic_check+0xdc>
  102ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ee4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102ee7:	74 08                	je     102ef1 <basic_check+0xdc>
  102ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102eec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102eef:	75 24                	jne    102f15 <basic_check+0x100>
  102ef1:	c7 44 24 0c 28 67 10 	movl   $0x106728,0xc(%esp)
  102ef8:	00 
  102ef9:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102f00:	00 
  102f01:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  102f08:	00 
  102f09:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102f10:	e8 b8 dd ff ff       	call   100ccd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  102f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f18:	89 04 24             	mov    %eax,(%esp)
  102f1b:	e8 a4 f9 ff ff       	call   1028c4 <page_ref>
  102f20:	85 c0                	test   %eax,%eax
  102f22:	75 1e                	jne    102f42 <basic_check+0x12d>
  102f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f27:	89 04 24             	mov    %eax,(%esp)
  102f2a:	e8 95 f9 ff ff       	call   1028c4 <page_ref>
  102f2f:	85 c0                	test   %eax,%eax
  102f31:	75 0f                	jne    102f42 <basic_check+0x12d>
  102f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102f36:	89 04 24             	mov    %eax,(%esp)
  102f39:	e8 86 f9 ff ff       	call   1028c4 <page_ref>
  102f3e:	85 c0                	test   %eax,%eax
  102f40:	74 24                	je     102f66 <basic_check+0x151>
  102f42:	c7 44 24 0c 4c 67 10 	movl   $0x10674c,0xc(%esp)
  102f49:	00 
  102f4a:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102f51:	00 
  102f52:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
  102f59:	00 
  102f5a:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102f61:	e8 67 dd ff ff       	call   100ccd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  102f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f69:	89 04 24             	mov    %eax,(%esp)
  102f6c:	e8 3d f9 ff ff       	call   1028ae <page2pa>
  102f71:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102f77:	c1 e2 0c             	shl    $0xc,%edx
  102f7a:	39 d0                	cmp    %edx,%eax
  102f7c:	72 24                	jb     102fa2 <basic_check+0x18d>
  102f7e:	c7 44 24 0c 88 67 10 	movl   $0x106788,0xc(%esp)
  102f85:	00 
  102f86:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102f8d:	00 
  102f8e:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102f95:	00 
  102f96:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102f9d:	e8 2b dd ff ff       	call   100ccd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fa5:	89 04 24             	mov    %eax,(%esp)
  102fa8:	e8 01 f9 ff ff       	call   1028ae <page2pa>
  102fad:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fb3:	c1 e2 0c             	shl    $0xc,%edx
  102fb6:	39 d0                	cmp    %edx,%eax
  102fb8:	72 24                	jb     102fde <basic_check+0x1c9>
  102fba:	c7 44 24 0c a5 67 10 	movl   $0x1067a5,0xc(%esp)
  102fc1:	00 
  102fc2:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  102fc9:	00 
  102fca:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  102fd1:	00 
  102fd2:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  102fd9:	e8 ef dc ff ff       	call   100ccd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  102fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102fe1:	89 04 24             	mov    %eax,(%esp)
  102fe4:	e8 c5 f8 ff ff       	call   1028ae <page2pa>
  102fe9:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  102fef:	c1 e2 0c             	shl    $0xc,%edx
  102ff2:	39 d0                	cmp    %edx,%eax
  102ff4:	72 24                	jb     10301a <basic_check+0x205>
  102ff6:	c7 44 24 0c c2 67 10 	movl   $0x1067c2,0xc(%esp)
  102ffd:	00 
  102ffe:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103005:	00 
  103006:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  10300d:	00 
  10300e:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103015:	e8 b3 dc ff ff       	call   100ccd <__panic>

    list_entry_t free_list_store = free_list;
  10301a:	a1 50 89 11 00       	mov    0x118950,%eax
  10301f:	8b 15 54 89 11 00    	mov    0x118954,%edx
  103025:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103028:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10302b:	c7 45 e0 50 89 11 00 	movl   $0x118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  103032:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103035:	8b 55 e0             	mov    -0x20(%ebp),%edx
  103038:	89 50 04             	mov    %edx,0x4(%eax)
  10303b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10303e:	8b 50 04             	mov    0x4(%eax),%edx
  103041:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103044:	89 10                	mov    %edx,(%eax)
  103046:	c7 45 dc 50 89 11 00 	movl   $0x118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  10304d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103050:	8b 40 04             	mov    0x4(%eax),%eax
  103053:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  103056:	0f 94 c0             	sete   %al
  103059:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  10305c:	85 c0                	test   %eax,%eax
  10305e:	75 24                	jne    103084 <basic_check+0x26f>
  103060:	c7 44 24 0c df 67 10 	movl   $0x1067df,0xc(%esp)
  103067:	00 
  103068:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10306f:	00 
  103070:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  103077:	00 
  103078:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10307f:	e8 49 dc ff ff       	call   100ccd <__panic>

    unsigned int nr_free_store = nr_free;
  103084:	a1 58 89 11 00       	mov    0x118958,%eax
  103089:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  10308c:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103093:	00 00 00 

    assert(alloc_page() == NULL);
  103096:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10309d:	e8 1d 0c 00 00       	call   103cbf <alloc_pages>
  1030a2:	85 c0                	test   %eax,%eax
  1030a4:	74 24                	je     1030ca <basic_check+0x2b5>
  1030a6:	c7 44 24 0c f6 67 10 	movl   $0x1067f6,0xc(%esp)
  1030ad:	00 
  1030ae:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1030b5:	00 
  1030b6:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
  1030bd:	00 
  1030be:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1030c5:	e8 03 dc ff ff       	call   100ccd <__panic>

    free_page(p0);
  1030ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030d1:	00 
  1030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1030d5:	89 04 24             	mov    %eax,(%esp)
  1030d8:	e8 1a 0c 00 00       	call   103cf7 <free_pages>
    free_page(p1);
  1030dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030e4:	00 
  1030e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030e8:	89 04 24             	mov    %eax,(%esp)
  1030eb:	e8 07 0c 00 00       	call   103cf7 <free_pages>
    free_page(p2);
  1030f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1030f7:	00 
  1030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030fb:	89 04 24             	mov    %eax,(%esp)
  1030fe:	e8 f4 0b 00 00       	call   103cf7 <free_pages>
    assert(nr_free == 3);
  103103:	a1 58 89 11 00       	mov    0x118958,%eax
  103108:	83 f8 03             	cmp    $0x3,%eax
  10310b:	74 24                	je     103131 <basic_check+0x31c>
  10310d:	c7 44 24 0c 0b 68 10 	movl   $0x10680b,0xc(%esp)
  103114:	00 
  103115:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10311c:	00 
  10311d:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
  103124:	00 
  103125:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10312c:	e8 9c db ff ff       	call   100ccd <__panic>

    assert((p0 = alloc_page()) != NULL);
  103131:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103138:	e8 82 0b 00 00       	call   103cbf <alloc_pages>
  10313d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103140:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  103144:	75 24                	jne    10316a <basic_check+0x355>
  103146:	c7 44 24 0c d1 66 10 	movl   $0x1066d1,0xc(%esp)
  10314d:	00 
  10314e:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103155:	00 
  103156:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
  10315d:	00 
  10315e:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103165:	e8 63 db ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
  10316a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103171:	e8 49 0b 00 00       	call   103cbf <alloc_pages>
  103176:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103179:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10317d:	75 24                	jne    1031a3 <basic_check+0x38e>
  10317f:	c7 44 24 0c ed 66 10 	movl   $0x1066ed,0xc(%esp)
  103186:	00 
  103187:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10318e:	00 
  10318f:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
  103196:	00 
  103197:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10319e:	e8 2a db ff ff       	call   100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
  1031a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031aa:	e8 10 0b 00 00       	call   103cbf <alloc_pages>
  1031af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1031b6:	75 24                	jne    1031dc <basic_check+0x3c7>
  1031b8:	c7 44 24 0c 09 67 10 	movl   $0x106709,0xc(%esp)
  1031bf:	00 
  1031c0:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1031c7:	00 
  1031c8:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  1031cf:	00 
  1031d0:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1031d7:	e8 f1 da ff ff       	call   100ccd <__panic>

    assert(alloc_page() == NULL);
  1031dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1031e3:	e8 d7 0a 00 00       	call   103cbf <alloc_pages>
  1031e8:	85 c0                	test   %eax,%eax
  1031ea:	74 24                	je     103210 <basic_check+0x3fb>
  1031ec:	c7 44 24 0c f6 67 10 	movl   $0x1067f6,0xc(%esp)
  1031f3:	00 
  1031f4:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1031fb:	00 
  1031fc:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
  103203:	00 
  103204:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10320b:	e8 bd da ff ff       	call   100ccd <__panic>

    free_page(p0);
  103210:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103217:	00 
  103218:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10321b:	89 04 24             	mov    %eax,(%esp)
  10321e:	e8 d4 0a 00 00       	call   103cf7 <free_pages>
  103223:	c7 45 d8 50 89 11 00 	movl   $0x118950,-0x28(%ebp)
  10322a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10322d:	8b 40 04             	mov    0x4(%eax),%eax
  103230:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  103233:	0f 94 c0             	sete   %al
  103236:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  103239:	85 c0                	test   %eax,%eax
  10323b:	74 24                	je     103261 <basic_check+0x44c>
  10323d:	c7 44 24 0c 18 68 10 	movl   $0x106818,0xc(%esp)
  103244:	00 
  103245:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10324c:	00 
  10324d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  103254:	00 
  103255:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10325c:	e8 6c da ff ff       	call   100ccd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  103261:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103268:	e8 52 0a 00 00       	call   103cbf <alloc_pages>
  10326d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103273:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103276:	74 24                	je     10329c <basic_check+0x487>
  103278:	c7 44 24 0c 30 68 10 	movl   $0x106830,0xc(%esp)
  10327f:	00 
  103280:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103287:	00 
  103288:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  10328f:	00 
  103290:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103297:	e8 31 da ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  10329c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1032a3:	e8 17 0a 00 00       	call   103cbf <alloc_pages>
  1032a8:	85 c0                	test   %eax,%eax
  1032aa:	74 24                	je     1032d0 <basic_check+0x4bb>
  1032ac:	c7 44 24 0c f6 67 10 	movl   $0x1067f6,0xc(%esp)
  1032b3:	00 
  1032b4:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1032bb:	00 
  1032bc:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  1032c3:	00 
  1032c4:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1032cb:	e8 fd d9 ff ff       	call   100ccd <__panic>

    assert(nr_free == 0);
  1032d0:	a1 58 89 11 00       	mov    0x118958,%eax
  1032d5:	85 c0                	test   %eax,%eax
  1032d7:	74 24                	je     1032fd <basic_check+0x4e8>
  1032d9:	c7 44 24 0c 49 68 10 	movl   $0x106849,0xc(%esp)
  1032e0:	00 
  1032e1:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1032e8:	00 
  1032e9:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
  1032f0:	00 
  1032f1:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1032f8:	e8 d0 d9 ff ff       	call   100ccd <__panic>
    free_list = free_list_store;
  1032fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103300:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103303:	a3 50 89 11 00       	mov    %eax,0x118950
  103308:	89 15 54 89 11 00    	mov    %edx,0x118954
    nr_free = nr_free_store;
  10330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103311:	a3 58 89 11 00       	mov    %eax,0x118958

    free_page(p);
  103316:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10331d:	00 
  10331e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103321:	89 04 24             	mov    %eax,(%esp)
  103324:	e8 ce 09 00 00       	call   103cf7 <free_pages>
    free_page(p1);
  103329:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103330:	00 
  103331:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103334:	89 04 24             	mov    %eax,(%esp)
  103337:	e8 bb 09 00 00       	call   103cf7 <free_pages>
    free_page(p2);
  10333c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103343:	00 
  103344:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103347:	89 04 24             	mov    %eax,(%esp)
  10334a:	e8 a8 09 00 00       	call   103cf7 <free_pages>
}
  10334f:	c9                   	leave  
  103350:	c3                   	ret    

00103351 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  103351:	55                   	push   %ebp
  103352:	89 e5                	mov    %esp,%ebp
  103354:	53                   	push   %ebx
  103355:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  10335b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103362:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  103369:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103370:	eb 6b                	jmp    1033dd <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  103372:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103375:	83 e8 0c             	sub    $0xc,%eax
  103378:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  10337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10337e:	83 c0 04             	add    $0x4,%eax
  103381:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103388:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10338b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10338e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  103391:	0f a3 10             	bt     %edx,(%eax)
  103394:	19 c0                	sbb    %eax,%eax
  103396:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  103399:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10339d:	0f 95 c0             	setne  %al
  1033a0:	0f b6 c0             	movzbl %al,%eax
  1033a3:	85 c0                	test   %eax,%eax
  1033a5:	75 24                	jne    1033cb <default_check+0x7a>
  1033a7:	c7 44 24 0c 56 68 10 	movl   $0x106856,0xc(%esp)
  1033ae:	00 
  1033af:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1033b6:	00 
  1033b7:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1033be:	00 
  1033bf:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1033c6:	e8 02 d9 ff ff       	call   100ccd <__panic>
        count ++, total += p->property;
  1033cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033d2:	8b 50 08             	mov    0x8(%eax),%edx
  1033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033d8:	01 d0                	add    %edx,%eax
  1033da:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  1033e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1033e6:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  1033e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033ec:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  1033f3:	0f 85 79 ff ff ff    	jne    103372 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  1033f9:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  1033fc:	e8 28 09 00 00       	call   103d29 <nr_free_pages>
  103401:	39 c3                	cmp    %eax,%ebx
  103403:	74 24                	je     103429 <default_check+0xd8>
  103405:	c7 44 24 0c 66 68 10 	movl   $0x106866,0xc(%esp)
  10340c:	00 
  10340d:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103414:	00 
  103415:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
  10341c:	00 
  10341d:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103424:	e8 a4 d8 ff ff       	call   100ccd <__panic>

    basic_check();
  103429:	e8 e7 f9 ff ff       	call   102e15 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  10342e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103435:	e8 85 08 00 00       	call   103cbf <alloc_pages>
  10343a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  10343d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103441:	75 24                	jne    103467 <default_check+0x116>
  103443:	c7 44 24 0c 7f 68 10 	movl   $0x10687f,0xc(%esp)
  10344a:	00 
  10344b:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103452:	00 
  103453:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
  10345a:	00 
  10345b:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103462:	e8 66 d8 ff ff       	call   100ccd <__panic>
    assert(!PageProperty(p0));
  103467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10346a:	83 c0 04             	add    $0x4,%eax
  10346d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103474:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103477:	8b 45 bc             	mov    -0x44(%ebp),%eax
  10347a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10347d:	0f a3 10             	bt     %edx,(%eax)
  103480:	19 c0                	sbb    %eax,%eax
  103482:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  103485:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103489:	0f 95 c0             	setne  %al
  10348c:	0f b6 c0             	movzbl %al,%eax
  10348f:	85 c0                	test   %eax,%eax
  103491:	74 24                	je     1034b7 <default_check+0x166>
  103493:	c7 44 24 0c 8a 68 10 	movl   $0x10688a,0xc(%esp)
  10349a:	00 
  10349b:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1034a2:	00 
  1034a3:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1034aa:	00 
  1034ab:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1034b2:	e8 16 d8 ff ff       	call   100ccd <__panic>

    list_entry_t free_list_store = free_list;
  1034b7:	a1 50 89 11 00       	mov    0x118950,%eax
  1034bc:	8b 15 54 89 11 00    	mov    0x118954,%edx
  1034c2:	89 45 80             	mov    %eax,-0x80(%ebp)
  1034c5:	89 55 84             	mov    %edx,-0x7c(%ebp)
  1034c8:	c7 45 b4 50 89 11 00 	movl   $0x118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1034cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034d2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  1034d5:	89 50 04             	mov    %edx,0x4(%eax)
  1034d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034db:	8b 50 04             	mov    0x4(%eax),%edx
  1034de:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1034e1:	89 10                	mov    %edx,(%eax)
  1034e3:	c7 45 b0 50 89 11 00 	movl   $0x118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1034ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
  1034ed:	8b 40 04             	mov    0x4(%eax),%eax
  1034f0:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  1034f3:	0f 94 c0             	sete   %al
  1034f6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1034f9:	85 c0                	test   %eax,%eax
  1034fb:	75 24                	jne    103521 <default_check+0x1d0>
  1034fd:	c7 44 24 0c df 67 10 	movl   $0x1067df,0xc(%esp)
  103504:	00 
  103505:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10350c:	00 
  10350d:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
  103514:	00 
  103515:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10351c:	e8 ac d7 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  103521:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103528:	e8 92 07 00 00       	call   103cbf <alloc_pages>
  10352d:	85 c0                	test   %eax,%eax
  10352f:	74 24                	je     103555 <default_check+0x204>
  103531:	c7 44 24 0c f6 67 10 	movl   $0x1067f6,0xc(%esp)
  103538:	00 
  103539:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103540:	00 
  103541:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  103548:	00 
  103549:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103550:	e8 78 d7 ff ff       	call   100ccd <__panic>

    unsigned int nr_free_store = nr_free;
  103555:	a1 58 89 11 00       	mov    0x118958,%eax
  10355a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  10355d:	c7 05 58 89 11 00 00 	movl   $0x0,0x118958
  103564:	00 00 00 

    free_pages(p0 + 2, 3);
  103567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10356a:	83 c0 28             	add    $0x28,%eax
  10356d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103574:	00 
  103575:	89 04 24             	mov    %eax,(%esp)
  103578:	e8 7a 07 00 00       	call   103cf7 <free_pages>
    assert(alloc_pages(4) == NULL);
  10357d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103584:	e8 36 07 00 00       	call   103cbf <alloc_pages>
  103589:	85 c0                	test   %eax,%eax
  10358b:	74 24                	je     1035b1 <default_check+0x260>
  10358d:	c7 44 24 0c 9c 68 10 	movl   $0x10689c,0xc(%esp)
  103594:	00 
  103595:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10359c:	00 
  10359d:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
  1035a4:	00 
  1035a5:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1035ac:	e8 1c d7 ff ff       	call   100ccd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  1035b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035b4:	83 c0 28             	add    $0x28,%eax
  1035b7:	83 c0 04             	add    $0x4,%eax
  1035ba:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  1035c1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1035c4:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1035c7:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1035ca:	0f a3 10             	bt     %edx,(%eax)
  1035cd:	19 c0                	sbb    %eax,%eax
  1035cf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  1035d2:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  1035d6:	0f 95 c0             	setne  %al
  1035d9:	0f b6 c0             	movzbl %al,%eax
  1035dc:	85 c0                	test   %eax,%eax
  1035de:	74 0e                	je     1035ee <default_check+0x29d>
  1035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035e3:	83 c0 28             	add    $0x28,%eax
  1035e6:	8b 40 08             	mov    0x8(%eax),%eax
  1035e9:	83 f8 03             	cmp    $0x3,%eax
  1035ec:	74 24                	je     103612 <default_check+0x2c1>
  1035ee:	c7 44 24 0c b4 68 10 	movl   $0x1068b4,0xc(%esp)
  1035f5:	00 
  1035f6:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1035fd:	00 
  1035fe:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
  103605:	00 
  103606:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10360d:	e8 bb d6 ff ff       	call   100ccd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  103612:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  103619:	e8 a1 06 00 00       	call   103cbf <alloc_pages>
  10361e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103621:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103625:	75 24                	jne    10364b <default_check+0x2fa>
  103627:	c7 44 24 0c e0 68 10 	movl   $0x1068e0,0xc(%esp)
  10362e:	00 
  10362f:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103636:	00 
  103637:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
  10363e:	00 
  10363f:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103646:	e8 82 d6 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  10364b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103652:	e8 68 06 00 00       	call   103cbf <alloc_pages>
  103657:	85 c0                	test   %eax,%eax
  103659:	74 24                	je     10367f <default_check+0x32e>
  10365b:	c7 44 24 0c f6 67 10 	movl   $0x1067f6,0xc(%esp)
  103662:	00 
  103663:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10366a:	00 
  10366b:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
  103672:	00 
  103673:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10367a:	e8 4e d6 ff ff       	call   100ccd <__panic>
    assert(p0 + 2 == p1);
  10367f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103682:	83 c0 28             	add    $0x28,%eax
  103685:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103688:	74 24                	je     1036ae <default_check+0x35d>
  10368a:	c7 44 24 0c fe 68 10 	movl   $0x1068fe,0xc(%esp)
  103691:	00 
  103692:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103699:	00 
  10369a:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
  1036a1:	00 
  1036a2:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1036a9:	e8 1f d6 ff ff       	call   100ccd <__panic>

    p2 = p0 + 1;
  1036ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036b1:	83 c0 14             	add    $0x14,%eax
  1036b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  1036b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1036be:	00 
  1036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036c2:	89 04 24             	mov    %eax,(%esp)
  1036c5:	e8 2d 06 00 00       	call   103cf7 <free_pages>
    free_pages(p1, 3);
  1036ca:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1036d1:	00 
  1036d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1036d5:	89 04 24             	mov    %eax,(%esp)
  1036d8:	e8 1a 06 00 00       	call   103cf7 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1036dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036e0:	83 c0 04             	add    $0x4,%eax
  1036e3:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1036ea:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1036ed:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1036f0:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1036f3:	0f a3 10             	bt     %edx,(%eax)
  1036f6:	19 c0                	sbb    %eax,%eax
  1036f8:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1036fb:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  1036ff:	0f 95 c0             	setne  %al
  103702:	0f b6 c0             	movzbl %al,%eax
  103705:	85 c0                	test   %eax,%eax
  103707:	74 0b                	je     103714 <default_check+0x3c3>
  103709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10370c:	8b 40 08             	mov    0x8(%eax),%eax
  10370f:	83 f8 01             	cmp    $0x1,%eax
  103712:	74 24                	je     103738 <default_check+0x3e7>
  103714:	c7 44 24 0c 0c 69 10 	movl   $0x10690c,0xc(%esp)
  10371b:	00 
  10371c:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103723:	00 
  103724:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
  10372b:	00 
  10372c:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103733:	e8 95 d5 ff ff       	call   100ccd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  103738:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10373b:	83 c0 04             	add    $0x4,%eax
  10373e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  103745:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103748:	8b 45 90             	mov    -0x70(%ebp),%eax
  10374b:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10374e:	0f a3 10             	bt     %edx,(%eax)
  103751:	19 c0                	sbb    %eax,%eax
  103753:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  103756:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10375a:	0f 95 c0             	setne  %al
  10375d:	0f b6 c0             	movzbl %al,%eax
  103760:	85 c0                	test   %eax,%eax
  103762:	74 0b                	je     10376f <default_check+0x41e>
  103764:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103767:	8b 40 08             	mov    0x8(%eax),%eax
  10376a:	83 f8 03             	cmp    $0x3,%eax
  10376d:	74 24                	je     103793 <default_check+0x442>
  10376f:	c7 44 24 0c 34 69 10 	movl   $0x106934,0xc(%esp)
  103776:	00 
  103777:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10377e:	00 
  10377f:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
  103786:	00 
  103787:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10378e:	e8 3a d5 ff ff       	call   100ccd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103793:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10379a:	e8 20 05 00 00       	call   103cbf <alloc_pages>
  10379f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037a5:	83 e8 14             	sub    $0x14,%eax
  1037a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037ab:	74 24                	je     1037d1 <default_check+0x480>
  1037ad:	c7 44 24 0c 5a 69 10 	movl   $0x10695a,0xc(%esp)
  1037b4:	00 
  1037b5:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1037bc:	00 
  1037bd:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1037c4:	00 
  1037c5:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1037cc:	e8 fc d4 ff ff       	call   100ccd <__panic>
    free_page(p0);
  1037d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1037d8:	00 
  1037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037dc:	89 04 24             	mov    %eax,(%esp)
  1037df:	e8 13 05 00 00       	call   103cf7 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1037e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1037eb:	e8 cf 04 00 00       	call   103cbf <alloc_pages>
  1037f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1037f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1037f6:	83 c0 14             	add    $0x14,%eax
  1037f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  1037fc:	74 24                	je     103822 <default_check+0x4d1>
  1037fe:	c7 44 24 0c 78 69 10 	movl   $0x106978,0xc(%esp)
  103805:	00 
  103806:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10380d:	00 
  10380e:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
  103815:	00 
  103816:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10381d:	e8 ab d4 ff ff       	call   100ccd <__panic>

    free_pages(p0, 2);
  103822:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103829:	00 
  10382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10382d:	89 04 24             	mov    %eax,(%esp)
  103830:	e8 c2 04 00 00       	call   103cf7 <free_pages>
    free_page(p2);
  103835:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10383c:	00 
  10383d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103840:	89 04 24             	mov    %eax,(%esp)
  103843:	e8 af 04 00 00       	call   103cf7 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103848:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10384f:	e8 6b 04 00 00       	call   103cbf <alloc_pages>
  103854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10385b:	75 24                	jne    103881 <default_check+0x530>
  10385d:	c7 44 24 0c 98 69 10 	movl   $0x106998,0xc(%esp)
  103864:	00 
  103865:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10386c:	00 
  10386d:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
  103874:	00 
  103875:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10387c:	e8 4c d4 ff ff       	call   100ccd <__panic>
    assert(alloc_page() == NULL);
  103881:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103888:	e8 32 04 00 00       	call   103cbf <alloc_pages>
  10388d:	85 c0                	test   %eax,%eax
  10388f:	74 24                	je     1038b5 <default_check+0x564>
  103891:	c7 44 24 0c f6 67 10 	movl   $0x1067f6,0xc(%esp)
  103898:	00 
  103899:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1038a0:	00 
  1038a1:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
  1038a8:	00 
  1038a9:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1038b0:	e8 18 d4 ff ff       	call   100ccd <__panic>

    assert(nr_free == 0);
  1038b5:	a1 58 89 11 00       	mov    0x118958,%eax
  1038ba:	85 c0                	test   %eax,%eax
  1038bc:	74 24                	je     1038e2 <default_check+0x591>
  1038be:	c7 44 24 0c 49 68 10 	movl   $0x106849,0xc(%esp)
  1038c5:	00 
  1038c6:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  1038cd:	00 
  1038ce:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
  1038d5:	00 
  1038d6:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  1038dd:	e8 eb d3 ff ff       	call   100ccd <__panic>
    nr_free = nr_free_store;
  1038e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1038e5:	a3 58 89 11 00       	mov    %eax,0x118958

    free_list = free_list_store;
  1038ea:	8b 45 80             	mov    -0x80(%ebp),%eax
  1038ed:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1038f0:	a3 50 89 11 00       	mov    %eax,0x118950
  1038f5:	89 15 54 89 11 00    	mov    %edx,0x118954
    free_pages(p0, 5);
  1038fb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103902:	00 
  103903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103906:	89 04 24             	mov    %eax,(%esp)
  103909:	e8 e9 03 00 00       	call   103cf7 <free_pages>

    le = &free_list;
  10390e:	c7 45 ec 50 89 11 00 	movl   $0x118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103915:	eb 1d                	jmp    103934 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
  103917:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10391a:	83 e8 0c             	sub    $0xc,%eax
  10391d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103920:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103924:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10392a:	8b 40 08             	mov    0x8(%eax),%eax
  10392d:	29 c2                	sub    %eax,%edx
  10392f:	89 d0                	mov    %edx,%eax
  103931:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103937:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  10393a:	8b 45 88             	mov    -0x78(%ebp),%eax
  10393d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103940:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103943:	81 7d ec 50 89 11 00 	cmpl   $0x118950,-0x14(%ebp)
  10394a:	75 cb                	jne    103917 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  10394c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103950:	74 24                	je     103976 <default_check+0x625>
  103952:	c7 44 24 0c b6 69 10 	movl   $0x1069b6,0xc(%esp)
  103959:	00 
  10395a:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  103961:	00 
  103962:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
  103969:	00 
  10396a:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  103971:	e8 57 d3 ff ff       	call   100ccd <__panic>
    assert(total == 0);
  103976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10397a:	74 24                	je     1039a0 <default_check+0x64f>
  10397c:	c7 44 24 0c c1 69 10 	movl   $0x1069c1,0xc(%esp)
  103983:	00 
  103984:	c7 44 24 08 96 66 10 	movl   $0x106696,0x8(%esp)
  10398b:	00 
  10398c:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
  103993:	00 
  103994:	c7 04 24 ab 66 10 00 	movl   $0x1066ab,(%esp)
  10399b:	e8 2d d3 ff ff       	call   100ccd <__panic>
}
  1039a0:	81 c4 94 00 00 00    	add    $0x94,%esp
  1039a6:	5b                   	pop    %ebx
  1039a7:	5d                   	pop    %ebp
  1039a8:	c3                   	ret    

001039a9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  1039a9:	55                   	push   %ebp
  1039aa:	89 e5                	mov    %esp,%ebp
    return page - pages;
  1039ac:	8b 55 08             	mov    0x8(%ebp),%edx
  1039af:	a1 64 89 11 00       	mov    0x118964,%eax
  1039b4:	29 c2                	sub    %eax,%edx
  1039b6:	89 d0                	mov    %edx,%eax
  1039b8:	c1 f8 02             	sar    $0x2,%eax
  1039bb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  1039c1:	5d                   	pop    %ebp
  1039c2:	c3                   	ret    

001039c3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  1039c3:	55                   	push   %ebp
  1039c4:	89 e5                	mov    %esp,%ebp
  1039c6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  1039c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1039cc:	89 04 24             	mov    %eax,(%esp)
  1039cf:	e8 d5 ff ff ff       	call   1039a9 <page2ppn>
  1039d4:	c1 e0 0c             	shl    $0xc,%eax
}
  1039d7:	c9                   	leave  
  1039d8:	c3                   	ret    

001039d9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  1039d9:	55                   	push   %ebp
  1039da:	89 e5                	mov    %esp,%ebp
  1039dc:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  1039df:	8b 45 08             	mov    0x8(%ebp),%eax
  1039e2:	c1 e8 0c             	shr    $0xc,%eax
  1039e5:	89 c2                	mov    %eax,%edx
  1039e7:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  1039ec:	39 c2                	cmp    %eax,%edx
  1039ee:	72 1c                	jb     103a0c <pa2page+0x33>
        panic("pa2page called with invalid pa");
  1039f0:	c7 44 24 08 fc 69 10 	movl   $0x1069fc,0x8(%esp)
  1039f7:	00 
  1039f8:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  1039ff:	00 
  103a00:	c7 04 24 1b 6a 10 00 	movl   $0x106a1b,(%esp)
  103a07:	e8 c1 d2 ff ff       	call   100ccd <__panic>
    }
    return &pages[PPN(pa)];
  103a0c:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103a12:	8b 45 08             	mov    0x8(%ebp),%eax
  103a15:	c1 e8 0c             	shr    $0xc,%eax
  103a18:	89 c2                	mov    %eax,%edx
  103a1a:	89 d0                	mov    %edx,%eax
  103a1c:	c1 e0 02             	shl    $0x2,%eax
  103a1f:	01 d0                	add    %edx,%eax
  103a21:	c1 e0 02             	shl    $0x2,%eax
  103a24:	01 c8                	add    %ecx,%eax
}
  103a26:	c9                   	leave  
  103a27:	c3                   	ret    

00103a28 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103a28:	55                   	push   %ebp
  103a29:	89 e5                	mov    %esp,%ebp
  103a2b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  103a31:	89 04 24             	mov    %eax,(%esp)
  103a34:	e8 8a ff ff ff       	call   1039c3 <page2pa>
  103a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a3f:	c1 e8 0c             	shr    $0xc,%eax
  103a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a45:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103a4a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103a4d:	72 23                	jb     103a72 <page2kva+0x4a>
  103a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103a56:	c7 44 24 08 2c 6a 10 	movl   $0x106a2c,0x8(%esp)
  103a5d:	00 
  103a5e:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103a65:	00 
  103a66:	c7 04 24 1b 6a 10 00 	movl   $0x106a1b,(%esp)
  103a6d:	e8 5b d2 ff ff       	call   100ccd <__panic>
  103a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103a75:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103a7a:	c9                   	leave  
  103a7b:	c3                   	ret    

00103a7c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103a7c:	55                   	push   %ebp
  103a7d:	89 e5                	mov    %esp,%ebp
  103a7f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103a82:	8b 45 08             	mov    0x8(%ebp),%eax
  103a85:	83 e0 01             	and    $0x1,%eax
  103a88:	85 c0                	test   %eax,%eax
  103a8a:	75 1c                	jne    103aa8 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103a8c:	c7 44 24 08 50 6a 10 	movl   $0x106a50,0x8(%esp)
  103a93:	00 
  103a94:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103a9b:	00 
  103a9c:	c7 04 24 1b 6a 10 00 	movl   $0x106a1b,(%esp)
  103aa3:	e8 25 d2 ff ff       	call   100ccd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  103aab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ab0:	89 04 24             	mov    %eax,(%esp)
  103ab3:	e8 21 ff ff ff       	call   1039d9 <pa2page>
}
  103ab8:	c9                   	leave  
  103ab9:	c3                   	ret    

00103aba <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  103aba:	55                   	push   %ebp
  103abb:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103abd:	8b 45 08             	mov    0x8(%ebp),%eax
  103ac0:	8b 00                	mov    (%eax),%eax
}
  103ac2:	5d                   	pop    %ebp
  103ac3:	c3                   	ret    

00103ac4 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103ac4:	55                   	push   %ebp
  103ac5:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103ac7:	8b 45 08             	mov    0x8(%ebp),%eax
  103aca:	8b 55 0c             	mov    0xc(%ebp),%edx
  103acd:	89 10                	mov    %edx,(%eax)
}
  103acf:	5d                   	pop    %ebp
  103ad0:	c3                   	ret    

00103ad1 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103ad1:	55                   	push   %ebp
  103ad2:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  103ad7:	8b 00                	mov    (%eax),%eax
  103ad9:	8d 50 01             	lea    0x1(%eax),%edx
  103adc:	8b 45 08             	mov    0x8(%ebp),%eax
  103adf:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  103ae4:	8b 00                	mov    (%eax),%eax
}
  103ae6:	5d                   	pop    %ebp
  103ae7:	c3                   	ret    

00103ae8 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103ae8:	55                   	push   %ebp
  103ae9:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  103aee:	8b 00                	mov    (%eax),%eax
  103af0:	8d 50 ff             	lea    -0x1(%eax),%edx
  103af3:	8b 45 08             	mov    0x8(%ebp),%eax
  103af6:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103af8:	8b 45 08             	mov    0x8(%ebp),%eax
  103afb:	8b 00                	mov    (%eax),%eax
}
  103afd:	5d                   	pop    %ebp
  103afe:	c3                   	ret    

00103aff <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103aff:	55                   	push   %ebp
  103b00:	89 e5                	mov    %esp,%ebp
  103b02:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103b05:	9c                   	pushf  
  103b06:	58                   	pop    %eax
  103b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  103b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103b0d:	25 00 02 00 00       	and    $0x200,%eax
  103b12:	85 c0                	test   %eax,%eax
  103b14:	74 0c                	je     103b22 <__intr_save+0x23>
        intr_disable();
  103b16:	e8 95 db ff ff       	call   1016b0 <intr_disable>
        return 1;
  103b1b:	b8 01 00 00 00       	mov    $0x1,%eax
  103b20:	eb 05                	jmp    103b27 <__intr_save+0x28>
    }
    return 0;
  103b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103b27:	c9                   	leave  
  103b28:	c3                   	ret    

00103b29 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103b29:	55                   	push   %ebp
  103b2a:	89 e5                	mov    %esp,%ebp
  103b2c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103b2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103b33:	74 05                	je     103b3a <__intr_restore+0x11>
        intr_enable();
  103b35:	e8 70 db ff ff       	call   1016aa <intr_enable>
    }
}
  103b3a:	c9                   	leave  
  103b3b:	c3                   	ret    

00103b3c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103b3c:	55                   	push   %ebp
  103b3d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  103b42:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103b45:	b8 23 00 00 00       	mov    $0x23,%eax
  103b4a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103b4c:	b8 23 00 00 00       	mov    $0x23,%eax
  103b51:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103b53:	b8 10 00 00 00       	mov    $0x10,%eax
  103b58:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103b5a:	b8 10 00 00 00       	mov    $0x10,%eax
  103b5f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103b61:	b8 10 00 00 00       	mov    $0x10,%eax
  103b66:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103b68:	ea 6f 3b 10 00 08 00 	ljmp   $0x8,$0x103b6f
}
  103b6f:	5d                   	pop    %ebp
  103b70:	c3                   	ret    

00103b71 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103b71:	55                   	push   %ebp
  103b72:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103b74:	8b 45 08             	mov    0x8(%ebp),%eax
  103b77:	a3 e4 88 11 00       	mov    %eax,0x1188e4
}
  103b7c:	5d                   	pop    %ebp
  103b7d:	c3                   	ret    

00103b7e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103b7e:	55                   	push   %ebp
  103b7f:	89 e5                	mov    %esp,%ebp
  103b81:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103b84:	b8 00 70 11 00       	mov    $0x117000,%eax
  103b89:	89 04 24             	mov    %eax,(%esp)
  103b8c:	e8 e0 ff ff ff       	call   103b71 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103b91:	66 c7 05 e8 88 11 00 	movw   $0x10,0x1188e8
  103b98:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103b9a:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  103ba1:	68 00 
  103ba3:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103ba8:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  103bae:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103bb3:	c1 e8 10             	shr    $0x10,%eax
  103bb6:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  103bbb:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bc2:	83 e0 f0             	and    $0xfffffff0,%eax
  103bc5:	83 c8 09             	or     $0x9,%eax
  103bc8:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bcd:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bd4:	83 e0 ef             	and    $0xffffffef,%eax
  103bd7:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bdc:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103be3:	83 e0 9f             	and    $0xffffff9f,%eax
  103be6:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103beb:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  103bf2:	83 c8 80             	or     $0xffffff80,%eax
  103bf5:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  103bfa:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c01:	83 e0 f0             	and    $0xfffffff0,%eax
  103c04:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c09:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c10:	83 e0 ef             	and    $0xffffffef,%eax
  103c13:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c18:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c1f:	83 e0 df             	and    $0xffffffdf,%eax
  103c22:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c27:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c2e:	83 c8 40             	or     $0x40,%eax
  103c31:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c36:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  103c3d:	83 e0 7f             	and    $0x7f,%eax
  103c40:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  103c45:	b8 e0 88 11 00       	mov    $0x1188e0,%eax
  103c4a:	c1 e8 18             	shr    $0x18,%eax
  103c4d:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103c52:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  103c59:	e8 de fe ff ff       	call   103b3c <lgdt>
  103c5e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103c64:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103c68:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103c6b:	c9                   	leave  
  103c6c:	c3                   	ret    

00103c6d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103c6d:	55                   	push   %ebp
  103c6e:	89 e5                	mov    %esp,%ebp
  103c70:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103c73:	c7 05 5c 89 11 00 e0 	movl   $0x1069e0,0x11895c
  103c7a:	69 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103c7d:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c82:	8b 00                	mov    (%eax),%eax
  103c84:	89 44 24 04          	mov    %eax,0x4(%esp)
  103c88:	c7 04 24 7c 6a 10 00 	movl   $0x106a7c,(%esp)
  103c8f:	e8 a8 c6 ff ff       	call   10033c <cprintf>
    pmm_manager->init();
  103c94:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103c99:	8b 40 04             	mov    0x4(%eax),%eax
  103c9c:	ff d0                	call   *%eax
}
  103c9e:	c9                   	leave  
  103c9f:	c3                   	ret    

00103ca0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103ca0:	55                   	push   %ebp
  103ca1:	89 e5                	mov    %esp,%ebp
  103ca3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103ca6:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cab:	8b 40 08             	mov    0x8(%eax),%eax
  103cae:	8b 55 0c             	mov    0xc(%ebp),%edx
  103cb1:	89 54 24 04          	mov    %edx,0x4(%esp)
  103cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  103cb8:	89 14 24             	mov    %edx,(%esp)
  103cbb:	ff d0                	call   *%eax
}
  103cbd:	c9                   	leave  
  103cbe:	c3                   	ret    

00103cbf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103cbf:	55                   	push   %ebp
  103cc0:	89 e5                	mov    %esp,%ebp
  103cc2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103cc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103ccc:	e8 2e fe ff ff       	call   103aff <__intr_save>
  103cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103cd4:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103cd9:	8b 40 0c             	mov    0xc(%eax),%eax
  103cdc:	8b 55 08             	mov    0x8(%ebp),%edx
  103cdf:	89 14 24             	mov    %edx,(%esp)
  103ce2:	ff d0                	call   *%eax
  103ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103cea:	89 04 24             	mov    %eax,(%esp)
  103ced:	e8 37 fe ff ff       	call   103b29 <__intr_restore>
    return page;
  103cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103cf5:	c9                   	leave  
  103cf6:	c3                   	ret    

00103cf7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103cf7:	55                   	push   %ebp
  103cf8:	89 e5                	mov    %esp,%ebp
  103cfa:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103cfd:	e8 fd fd ff ff       	call   103aff <__intr_save>
  103d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103d05:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d0a:	8b 40 10             	mov    0x10(%eax),%eax
  103d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d10:	89 54 24 04          	mov    %edx,0x4(%esp)
  103d14:	8b 55 08             	mov    0x8(%ebp),%edx
  103d17:	89 14 24             	mov    %edx,(%esp)
  103d1a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  103d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d1f:	89 04 24             	mov    %eax,(%esp)
  103d22:	e8 02 fe ff ff       	call   103b29 <__intr_restore>
}
  103d27:	c9                   	leave  
  103d28:	c3                   	ret    

00103d29 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103d29:	55                   	push   %ebp
  103d2a:	89 e5                	mov    %esp,%ebp
  103d2c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103d2f:	e8 cb fd ff ff       	call   103aff <__intr_save>
  103d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103d37:	a1 5c 89 11 00       	mov    0x11895c,%eax
  103d3c:	8b 40 14             	mov    0x14(%eax),%eax
  103d3f:	ff d0                	call   *%eax
  103d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d47:	89 04 24             	mov    %eax,(%esp)
  103d4a:	e8 da fd ff ff       	call   103b29 <__intr_restore>
    return ret;
  103d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  103d52:	c9                   	leave  
  103d53:	c3                   	ret    

00103d54 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  103d54:	55                   	push   %ebp
  103d55:	89 e5                	mov    %esp,%ebp
  103d57:	57                   	push   %edi
  103d58:	56                   	push   %esi
  103d59:	53                   	push   %ebx
  103d5a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  103d60:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  103d67:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  103d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  103d75:	c7 04 24 93 6a 10 00 	movl   $0x106a93,(%esp)
  103d7c:	e8 bb c5 ff ff       	call   10033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103d81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103d88:	e9 15 01 00 00       	jmp    103ea2 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103d8d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103d93:	89 d0                	mov    %edx,%eax
  103d95:	c1 e0 02             	shl    $0x2,%eax
  103d98:	01 d0                	add    %edx,%eax
  103d9a:	c1 e0 02             	shl    $0x2,%eax
  103d9d:	01 c8                	add    %ecx,%eax
  103d9f:	8b 50 08             	mov    0x8(%eax),%edx
  103da2:	8b 40 04             	mov    0x4(%eax),%eax
  103da5:	89 45 b8             	mov    %eax,-0x48(%ebp)
  103da8:	89 55 bc             	mov    %edx,-0x44(%ebp)
  103dab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103db1:	89 d0                	mov    %edx,%eax
  103db3:	c1 e0 02             	shl    $0x2,%eax
  103db6:	01 d0                	add    %edx,%eax
  103db8:	c1 e0 02             	shl    $0x2,%eax
  103dbb:	01 c8                	add    %ecx,%eax
  103dbd:	8b 48 0c             	mov    0xc(%eax),%ecx
  103dc0:	8b 58 10             	mov    0x10(%eax),%ebx
  103dc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103dc6:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103dc9:	01 c8                	add    %ecx,%eax
  103dcb:	11 da                	adc    %ebx,%edx
  103dcd:	89 45 b0             	mov    %eax,-0x50(%ebp)
  103dd0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  103dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103dd9:	89 d0                	mov    %edx,%eax
  103ddb:	c1 e0 02             	shl    $0x2,%eax
  103dde:	01 d0                	add    %edx,%eax
  103de0:	c1 e0 02             	shl    $0x2,%eax
  103de3:	01 c8                	add    %ecx,%eax
  103de5:	83 c0 14             	add    $0x14,%eax
  103de8:	8b 00                	mov    (%eax),%eax
  103dea:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
  103df0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103df3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103df6:	83 c0 ff             	add    $0xffffffff,%eax
  103df9:	83 d2 ff             	adc    $0xffffffff,%edx
  103dfc:	89 c6                	mov    %eax,%esi
  103dfe:	89 d7                	mov    %edx,%edi
  103e00:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e03:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e06:	89 d0                	mov    %edx,%eax
  103e08:	c1 e0 02             	shl    $0x2,%eax
  103e0b:	01 d0                	add    %edx,%eax
  103e0d:	c1 e0 02             	shl    $0x2,%eax
  103e10:	01 c8                	add    %ecx,%eax
  103e12:	8b 48 0c             	mov    0xc(%eax),%ecx
  103e15:	8b 58 10             	mov    0x10(%eax),%ebx
  103e18:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  103e1e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  103e22:	89 74 24 14          	mov    %esi,0x14(%esp)
  103e26:	89 7c 24 18          	mov    %edi,0x18(%esp)
  103e2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  103e2d:	8b 55 bc             	mov    -0x44(%ebp),%edx
  103e30:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103e34:	89 54 24 10          	mov    %edx,0x10(%esp)
  103e38:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  103e3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  103e40:	c7 04 24 a0 6a 10 00 	movl   $0x106aa0,(%esp)
  103e47:	e8 f0 c4 ff ff       	call   10033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  103e4c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103e52:	89 d0                	mov    %edx,%eax
  103e54:	c1 e0 02             	shl    $0x2,%eax
  103e57:	01 d0                	add    %edx,%eax
  103e59:	c1 e0 02             	shl    $0x2,%eax
  103e5c:	01 c8                	add    %ecx,%eax
  103e5e:	83 c0 14             	add    $0x14,%eax
  103e61:	8b 00                	mov    (%eax),%eax
  103e63:	83 f8 01             	cmp    $0x1,%eax
  103e66:	75 36                	jne    103e9e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
  103e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103e6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103e6e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e71:	77 2b                	ja     103e9e <page_init+0x14a>
  103e73:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  103e76:	72 05                	jb     103e7d <page_init+0x129>
  103e78:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  103e7b:	73 21                	jae    103e9e <page_init+0x14a>
  103e7d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e81:	77 1b                	ja     103e9e <page_init+0x14a>
  103e83:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  103e87:	72 09                	jb     103e92 <page_init+0x13e>
  103e89:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  103e90:	77 0c                	ja     103e9e <page_init+0x14a>
                maxpa = end;
  103e92:	8b 45 b0             	mov    -0x50(%ebp),%eax
  103e95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103e9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  103e9e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103ea2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103ea5:	8b 00                	mov    (%eax),%eax
  103ea7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103eaa:	0f 8f dd fe ff ff    	jg     103d8d <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  103eb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eb4:	72 1d                	jb     103ed3 <page_init+0x17f>
  103eb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103eba:	77 09                	ja     103ec5 <page_init+0x171>
  103ebc:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  103ec3:	76 0e                	jbe    103ed3 <page_init+0x17f>
        maxpa = KMEMSIZE;
  103ec5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  103ecc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  103ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103ed6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103ed9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  103edd:	c1 ea 0c             	shr    $0xc,%edx
  103ee0:	a3 c0 88 11 00       	mov    %eax,0x1188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  103ee5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  103eec:	b8 68 89 11 00       	mov    $0x118968,%eax
  103ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
  103ef4:	8b 45 ac             	mov    -0x54(%ebp),%eax
  103ef7:	01 d0                	add    %edx,%eax
  103ef9:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103efc:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103eff:	ba 00 00 00 00       	mov    $0x0,%edx
  103f04:	f7 75 ac             	divl   -0x54(%ebp)
  103f07:	89 d0                	mov    %edx,%eax
  103f09:	8b 55 a8             	mov    -0x58(%ebp),%edx
  103f0c:	29 c2                	sub    %eax,%edx
  103f0e:	89 d0                	mov    %edx,%eax
  103f10:	a3 64 89 11 00       	mov    %eax,0x118964

    for (i = 0; i < npage; i ++) {
  103f15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103f1c:	eb 2f                	jmp    103f4d <page_init+0x1f9>
        SetPageReserved(pages + i);
  103f1e:	8b 0d 64 89 11 00    	mov    0x118964,%ecx
  103f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f27:	89 d0                	mov    %edx,%eax
  103f29:	c1 e0 02             	shl    $0x2,%eax
  103f2c:	01 d0                	add    %edx,%eax
  103f2e:	c1 e0 02             	shl    $0x2,%eax
  103f31:	01 c8                	add    %ecx,%eax
  103f33:	83 c0 04             	add    $0x4,%eax
  103f36:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  103f3d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  103f40:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103f43:	8b 55 90             	mov    -0x70(%ebp),%edx
  103f46:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  103f49:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  103f4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103f50:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  103f55:	39 c2                	cmp    %eax,%edx
  103f57:	72 c5                	jb     103f1e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  103f59:	8b 15 c0 88 11 00    	mov    0x1188c0,%edx
  103f5f:	89 d0                	mov    %edx,%eax
  103f61:	c1 e0 02             	shl    $0x2,%eax
  103f64:	01 d0                	add    %edx,%eax
  103f66:	c1 e0 02             	shl    $0x2,%eax
  103f69:	89 c2                	mov    %eax,%edx
  103f6b:	a1 64 89 11 00       	mov    0x118964,%eax
  103f70:	01 d0                	add    %edx,%eax
  103f72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  103f75:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  103f7c:	77 23                	ja     103fa1 <page_init+0x24d>
  103f7e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103f81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103f85:	c7 44 24 08 d0 6a 10 	movl   $0x106ad0,0x8(%esp)
  103f8c:	00 
  103f8d:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  103f94:	00 
  103f95:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  103f9c:	e8 2c cd ff ff       	call   100ccd <__panic>
  103fa1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  103fa4:	05 00 00 00 40       	add    $0x40000000,%eax
  103fa9:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  103fac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  103fb3:	e9 74 01 00 00       	jmp    10412c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  103fb8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fbe:	89 d0                	mov    %edx,%eax
  103fc0:	c1 e0 02             	shl    $0x2,%eax
  103fc3:	01 d0                	add    %edx,%eax
  103fc5:	c1 e0 02             	shl    $0x2,%eax
  103fc8:	01 c8                	add    %ecx,%eax
  103fca:	8b 50 08             	mov    0x8(%eax),%edx
  103fcd:	8b 40 04             	mov    0x4(%eax),%eax
  103fd0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  103fd3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103fd6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  103fd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  103fdc:	89 d0                	mov    %edx,%eax
  103fde:	c1 e0 02             	shl    $0x2,%eax
  103fe1:	01 d0                	add    %edx,%eax
  103fe3:	c1 e0 02             	shl    $0x2,%eax
  103fe6:	01 c8                	add    %ecx,%eax
  103fe8:	8b 48 0c             	mov    0xc(%eax),%ecx
  103feb:	8b 58 10             	mov    0x10(%eax),%ebx
  103fee:	8b 45 d0             	mov    -0x30(%ebp),%eax
  103ff1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103ff4:	01 c8                	add    %ecx,%eax
  103ff6:	11 da                	adc    %ebx,%edx
  103ff8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  103ffb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  103ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  104001:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104004:	89 d0                	mov    %edx,%eax
  104006:	c1 e0 02             	shl    $0x2,%eax
  104009:	01 d0                	add    %edx,%eax
  10400b:	c1 e0 02             	shl    $0x2,%eax
  10400e:	01 c8                	add    %ecx,%eax
  104010:	83 c0 14             	add    $0x14,%eax
  104013:	8b 00                	mov    (%eax),%eax
  104015:	83 f8 01             	cmp    $0x1,%eax
  104018:	0f 85 0a 01 00 00    	jne    104128 <page_init+0x3d4>
            if (begin < freemem) {
  10401e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104021:	ba 00 00 00 00       	mov    $0x0,%edx
  104026:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  104029:	72 17                	jb     104042 <page_init+0x2ee>
  10402b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10402e:	77 05                	ja     104035 <page_init+0x2e1>
  104030:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  104033:	76 0d                	jbe    104042 <page_init+0x2ee>
                begin = freemem;
  104035:	8b 45 a0             	mov    -0x60(%ebp),%eax
  104038:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10403b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  104042:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  104046:	72 1d                	jb     104065 <page_init+0x311>
  104048:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  10404c:	77 09                	ja     104057 <page_init+0x303>
  10404e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  104055:	76 0e                	jbe    104065 <page_init+0x311>
                end = KMEMSIZE;
  104057:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  10405e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104065:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104068:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10406b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10406e:	0f 87 b4 00 00 00    	ja     104128 <page_init+0x3d4>
  104074:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104077:	72 09                	jb     104082 <page_init+0x32e>
  104079:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10407c:	0f 83 a6 00 00 00    	jae    104128 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
  104082:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104089:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10408c:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10408f:	01 d0                	add    %edx,%eax
  104091:	83 e8 01             	sub    $0x1,%eax
  104094:	89 45 98             	mov    %eax,-0x68(%ebp)
  104097:	8b 45 98             	mov    -0x68(%ebp),%eax
  10409a:	ba 00 00 00 00       	mov    $0x0,%edx
  10409f:	f7 75 9c             	divl   -0x64(%ebp)
  1040a2:	89 d0                	mov    %edx,%eax
  1040a4:	8b 55 98             	mov    -0x68(%ebp),%edx
  1040a7:	29 c2                	sub    %eax,%edx
  1040a9:	89 d0                	mov    %edx,%eax
  1040ab:	ba 00 00 00 00       	mov    $0x0,%edx
  1040b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1040b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  1040b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1040b9:	89 45 94             	mov    %eax,-0x6c(%ebp)
  1040bc:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1040bf:	ba 00 00 00 00       	mov    $0x0,%edx
  1040c4:	89 c7                	mov    %eax,%edi
  1040c6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  1040cc:	89 7d 80             	mov    %edi,-0x80(%ebp)
  1040cf:	89 d0                	mov    %edx,%eax
  1040d1:	83 e0 00             	and    $0x0,%eax
  1040d4:	89 45 84             	mov    %eax,-0x7c(%ebp)
  1040d7:	8b 45 80             	mov    -0x80(%ebp),%eax
  1040da:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1040dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1040e0:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  1040e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1040e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1040e9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040ec:	77 3a                	ja     104128 <page_init+0x3d4>
  1040ee:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  1040f1:	72 05                	jb     1040f8 <page_init+0x3a4>
  1040f3:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1040f6:	73 30                	jae    104128 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1040f8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1040fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1040fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104101:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104104:	29 c8                	sub    %ecx,%eax
  104106:	19 da                	sbb    %ebx,%edx
  104108:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  10410c:	c1 ea 0c             	shr    $0xc,%edx
  10410f:	89 c3                	mov    %eax,%ebx
  104111:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104114:	89 04 24             	mov    %eax,(%esp)
  104117:	e8 bd f8 ff ff       	call   1039d9 <pa2page>
  10411c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  104120:	89 04 24             	mov    %eax,(%esp)
  104123:	e8 78 fb ff ff       	call   103ca0 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  104128:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  10412c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10412f:	8b 00                	mov    (%eax),%eax
  104131:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  104134:	0f 8f 7e fe ff ff    	jg     103fb8 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  10413a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  104140:	5b                   	pop    %ebx
  104141:	5e                   	pop    %esi
  104142:	5f                   	pop    %edi
  104143:	5d                   	pop    %ebp
  104144:	c3                   	ret    

00104145 <enable_paging>:

static void
enable_paging(void) {
  104145:	55                   	push   %ebp
  104146:	89 e5                	mov    %esp,%ebp
  104148:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  10414b:	a1 60 89 11 00       	mov    0x118960,%eax
  104150:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104153:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104156:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104159:	0f 20 c0             	mov    %cr0,%eax
  10415c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
  10415f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  104162:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104165:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  10416c:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
  104170:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104179:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  10417c:	c9                   	leave  
  10417d:	c3                   	ret    

0010417e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10417e:	55                   	push   %ebp
  10417f:	89 e5                	mov    %esp,%ebp
  104181:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104184:	8b 45 14             	mov    0x14(%ebp),%eax
  104187:	8b 55 0c             	mov    0xc(%ebp),%edx
  10418a:	31 d0                	xor    %edx,%eax
  10418c:	25 ff 0f 00 00       	and    $0xfff,%eax
  104191:	85 c0                	test   %eax,%eax
  104193:	74 24                	je     1041b9 <boot_map_segment+0x3b>
  104195:	c7 44 24 0c 02 6b 10 	movl   $0x106b02,0xc(%esp)
  10419c:	00 
  10419d:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  1041a4:	00 
  1041a5:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  1041ac:	00 
  1041ad:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1041b4:	e8 14 cb ff ff       	call   100ccd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  1041b9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  1041c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041c3:	25 ff 0f 00 00       	and    $0xfff,%eax
  1041c8:	89 c2                	mov    %eax,%edx
  1041ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1041cd:	01 c2                	add    %eax,%edx
  1041cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1041d2:	01 d0                	add    %edx,%eax
  1041d4:	83 e8 01             	sub    $0x1,%eax
  1041d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1041da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1041dd:	ba 00 00 00 00       	mov    $0x0,%edx
  1041e2:	f7 75 f0             	divl   -0x10(%ebp)
  1041e5:	89 d0                	mov    %edx,%eax
  1041e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1041ea:	29 c2                	sub    %eax,%edx
  1041ec:	89 d0                	mov    %edx,%eax
  1041ee:	c1 e8 0c             	shr    $0xc,%eax
  1041f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1041f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1041f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1041fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1041fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104202:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  104205:	8b 45 14             	mov    0x14(%ebp),%eax
  104208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10420b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10420e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104213:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104216:	eb 6b                	jmp    104283 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
  104218:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10421f:	00 
  104220:	8b 45 0c             	mov    0xc(%ebp),%eax
  104223:	89 44 24 04          	mov    %eax,0x4(%esp)
  104227:	8b 45 08             	mov    0x8(%ebp),%eax
  10422a:	89 04 24             	mov    %eax,(%esp)
  10422d:	e8 cc 01 00 00       	call   1043fe <get_pte>
  104232:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  104235:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  104239:	75 24                	jne    10425f <boot_map_segment+0xe1>
  10423b:	c7 44 24 0c 2e 6b 10 	movl   $0x106b2e,0xc(%esp)
  104242:	00 
  104243:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  10424a:	00 
  10424b:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  104252:	00 
  104253:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10425a:	e8 6e ca ff ff       	call   100ccd <__panic>
        *ptep = pa | PTE_P | perm;
  10425f:	8b 45 18             	mov    0x18(%ebp),%eax
  104262:	8b 55 14             	mov    0x14(%ebp),%edx
  104265:	09 d0                	or     %edx,%eax
  104267:	83 c8 01             	or     $0x1,%eax
  10426a:	89 c2                	mov    %eax,%edx
  10426c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10426f:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  104271:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104275:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  10427c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104287:	75 8f                	jne    104218 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104289:	c9                   	leave  
  10428a:	c3                   	ret    

0010428b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  10428b:	55                   	push   %ebp
  10428c:	89 e5                	mov    %esp,%ebp
  10428e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  104291:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104298:	e8 22 fa ff ff       	call   103cbf <alloc_pages>
  10429d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1042a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1042a4:	75 1c                	jne    1042c2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1042a6:	c7 44 24 08 3b 6b 10 	movl   $0x106b3b,0x8(%esp)
  1042ad:	00 
  1042ae:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  1042b5:	00 
  1042b6:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1042bd:	e8 0b ca ff ff       	call   100ccd <__panic>
    }
    return page2kva(p);
  1042c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042c5:	89 04 24             	mov    %eax,(%esp)
  1042c8:	e8 5b f7 ff ff       	call   103a28 <page2kva>
}
  1042cd:	c9                   	leave  
  1042ce:	c3                   	ret    

001042cf <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  1042cf:	55                   	push   %ebp
  1042d0:	89 e5                	mov    %esp,%ebp
  1042d2:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  1042d5:	e8 93 f9 ff ff       	call   103c6d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  1042da:	e8 75 fa ff ff       	call   103d54 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  1042df:	e8 8c 04 00 00       	call   104770 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  1042e4:	e8 a2 ff ff ff       	call   10428b <boot_alloc_page>
  1042e9:	a3 c4 88 11 00       	mov    %eax,0x1188c4
    memset(boot_pgdir, 0, PGSIZE);
  1042ee:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1042f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1042fa:	00 
  1042fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104302:	00 
  104303:	89 04 24             	mov    %eax,(%esp)
  104306:	e8 ce 1a 00 00       	call   105dd9 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  10430b:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104310:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104313:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10431a:	77 23                	ja     10433f <pmm_init+0x70>
  10431c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10431f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104323:	c7 44 24 08 d0 6a 10 	movl   $0x106ad0,0x8(%esp)
  10432a:	00 
  10432b:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  104332:	00 
  104333:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10433a:	e8 8e c9 ff ff       	call   100ccd <__panic>
  10433f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104342:	05 00 00 00 40       	add    $0x40000000,%eax
  104347:	a3 60 89 11 00       	mov    %eax,0x118960

    check_pgdir();
  10434c:	e8 3d 04 00 00       	call   10478e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  104351:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104356:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  10435c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104361:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104364:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  10436b:	77 23                	ja     104390 <pmm_init+0xc1>
  10436d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104370:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104374:	c7 44 24 08 d0 6a 10 	movl   $0x106ad0,0x8(%esp)
  10437b:	00 
  10437c:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104383:	00 
  104384:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10438b:	e8 3d c9 ff ff       	call   100ccd <__panic>
  104390:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104393:	05 00 00 00 40       	add    $0x40000000,%eax
  104398:	83 c8 03             	or     $0x3,%eax
  10439b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10439d:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043a2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1043a9:	00 
  1043aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1043b1:	00 
  1043b2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1043b9:	38 
  1043ba:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1043c1:	c0 
  1043c2:	89 04 24             	mov    %eax,(%esp)
  1043c5:	e8 b4 fd ff ff       	call   10417e <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  1043ca:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043cf:	8b 15 c4 88 11 00    	mov    0x1188c4,%edx
  1043d5:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  1043db:	89 10                	mov    %edx,(%eax)

    enable_paging();
  1043dd:	e8 63 fd ff ff       	call   104145 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1043e2:	e8 97 f7 ff ff       	call   103b7e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  1043e7:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1043ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1043f2:	e8 32 0a 00 00       	call   104e29 <check_boot_pgdir>

    print_pgdir();
  1043f7:	e8 bf 0e 00 00       	call   1052bb <print_pgdir>

}
  1043fc:	c9                   	leave  
  1043fd:	c3                   	ret    

001043fe <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1043fe:	55                   	push   %ebp
  1043ff:	89 e5                	mov    %esp,%ebp
  104401:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    if (!(pgdir[PDX(la)] & PTE_P)) {          //page table does not exist
  104404:	8b 45 0c             	mov    0xc(%ebp),%eax
  104407:	c1 e8 16             	shr    $0x16,%eax
  10440a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104411:	8b 45 08             	mov    0x8(%ebp),%eax
  104414:	01 d0                	add    %edx,%eax
  104416:	8b 00                	mov    (%eax),%eax
  104418:	83 e0 01             	and    $0x1,%eax
  10441b:	85 c0                	test   %eax,%eax
  10441d:	0f 85 cc 00 00 00    	jne    1044ef <get_pte+0xf1>
    	struct Page *p;
    	if (!create)
  104423:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104427:	75 0a                	jne    104433 <get_pte+0x35>
    		return NULL;
  104429:	b8 00 00 00 00       	mov    $0x0,%eax
  10442e:	e9 27 01 00 00       	jmp    10455a <get_pte+0x15c>
    	if ((p = alloc_page()) == NULL)
  104433:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10443a:	e8 80 f8 ff ff       	call   103cbf <alloc_pages>
  10443f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104446:	75 0a                	jne    104452 <get_pte+0x54>
    		return NULL;
  104448:	b8 00 00 00 00       	mov    $0x0,%eax
  10444d:	e9 08 01 00 00       	jmp    10455a <get_pte+0x15c>
    	set_page_ref(p, 1);
  104452:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104459:	00 
  10445a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10445d:	89 04 24             	mov    %eax,(%esp)
  104460:	e8 5f f6 ff ff       	call   103ac4 <set_page_ref>
    	uintptr_t pa = page2pa(p);
  104465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104468:	89 04 24             	mov    %eax,(%esp)
  10446b:	e8 53 f5 ff ff       	call   1039c3 <page2pa>
  104470:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	memset(KADDR(pa),0,PGSIZE);
  104473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104476:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104479:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10447c:	c1 e8 0c             	shr    $0xc,%eax
  10447f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104482:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104487:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  10448a:	72 23                	jb     1044af <get_pte+0xb1>
  10448c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10448f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104493:	c7 44 24 08 2c 6a 10 	movl   $0x106a2c,0x8(%esp)
  10449a:	00 
  10449b:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
  1044a2:	00 
  1044a3:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1044aa:	e8 1e c8 ff ff       	call   100ccd <__panic>
  1044af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1044b2:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1044b7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1044be:	00 
  1044bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1044c6:	00 
  1044c7:	89 04 24             	mov    %eax,(%esp)
  1044ca:	e8 0a 19 00 00       	call   105dd9 <memset>
    	pgdir[PDX(la)] = (pa & ~0xFFF) | PTE_U | PTE_W | PTE_P;
  1044cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044d2:	c1 e8 16             	shr    $0x16,%eax
  1044d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1044dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1044df:	01 d0                	add    %edx,%eax
  1044e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1044e4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1044ea:	83 ca 07             	or     $0x7,%edx
  1044ed:	89 10                	mov    %edx,(%eax)
    }
    return (pte_t *)(KADDR(PDE_ADDR(pgdir[PDX(la)]))) + PTX(la);
  1044ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044f2:	c1 e8 16             	shr    $0x16,%eax
  1044f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1044fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1044ff:	01 d0                	add    %edx,%eax
  104501:	8b 00                	mov    (%eax),%eax
  104503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10450b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10450e:	c1 e8 0c             	shr    $0xc,%eax
  104511:	89 45 e0             	mov    %eax,-0x20(%ebp)
  104514:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104519:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10451c:	72 23                	jb     104541 <get_pte+0x143>
  10451e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104521:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104525:	c7 44 24 08 2c 6a 10 	movl   $0x106a2c,0x8(%esp)
  10452c:	00 
  10452d:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
  104534:	00 
  104535:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10453c:	e8 8c c7 ff ff       	call   100ccd <__panic>
  104541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104544:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104549:	8b 55 0c             	mov    0xc(%ebp),%edx
  10454c:	c1 ea 0c             	shr    $0xc,%edx
  10454f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  104555:	c1 e2 02             	shl    $0x2,%edx
  104558:	01 d0                	add    %edx,%eax
}
  10455a:	c9                   	leave  
  10455b:	c3                   	ret    

0010455c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10455c:	55                   	push   %ebp
  10455d:	89 e5                	mov    %esp,%ebp
  10455f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  104562:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104569:	00 
  10456a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10456d:	89 44 24 04          	mov    %eax,0x4(%esp)
  104571:	8b 45 08             	mov    0x8(%ebp),%eax
  104574:	89 04 24             	mov    %eax,(%esp)
  104577:	e8 82 fe ff ff       	call   1043fe <get_pte>
  10457c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  10457f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104583:	74 08                	je     10458d <get_page+0x31>
        *ptep_store = ptep;
  104585:	8b 45 10             	mov    0x10(%ebp),%eax
  104588:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10458b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10458d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104591:	74 1b                	je     1045ae <get_page+0x52>
  104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104596:	8b 00                	mov    (%eax),%eax
  104598:	83 e0 01             	and    $0x1,%eax
  10459b:	85 c0                	test   %eax,%eax
  10459d:	74 0f                	je     1045ae <get_page+0x52>
        return pa2page(*ptep);
  10459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045a2:	8b 00                	mov    (%eax),%eax
  1045a4:	89 04 24             	mov    %eax,(%esp)
  1045a7:	e8 2d f4 ff ff       	call   1039d9 <pa2page>
  1045ac:	eb 05                	jmp    1045b3 <get_page+0x57>
    }
    return NULL;
  1045ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1045b3:	c9                   	leave  
  1045b4:	c3                   	ret    

001045b5 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1045b5:	55                   	push   %ebp
  1045b6:	89 e5                	mov    %esp,%ebp
  1045b8:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
  1045bb:	8b 45 10             	mov    0x10(%ebp),%eax
  1045be:	8b 00                	mov    (%eax),%eax
  1045c0:	83 e0 01             	and    $0x1,%eax
  1045c3:	85 c0                	test   %eax,%eax
  1045c5:	74 4d                	je     104614 <page_remove_pte+0x5f>
            struct Page *page = pte2page(*ptep);
  1045c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1045ca:	8b 00                	mov    (%eax),%eax
  1045cc:	89 04 24             	mov    %eax,(%esp)
  1045cf:	e8 a8 f4 ff ff       	call   103a7c <pte2page>
  1045d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (page_ref_dec(page) == 0) {
  1045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045da:	89 04 24             	mov    %eax,(%esp)
  1045dd:	e8 06 f5 ff ff       	call   103ae8 <page_ref_dec>
  1045e2:	85 c0                	test   %eax,%eax
  1045e4:	75 13                	jne    1045f9 <page_remove_pte+0x44>
                free_page(page);
  1045e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1045ed:	00 
  1045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045f1:	89 04 24             	mov    %eax,(%esp)
  1045f4:	e8 fe f6 ff ff       	call   103cf7 <free_pages>
            }
            *ptep = 0;
  1045f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1045fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            tlb_invalidate(pgdir, la);
  104602:	8b 45 0c             	mov    0xc(%ebp),%eax
  104605:	89 44 24 04          	mov    %eax,0x4(%esp)
  104609:	8b 45 08             	mov    0x8(%ebp),%eax
  10460c:	89 04 24             	mov    %eax,(%esp)
  10460f:	e8 ff 00 00 00       	call   104713 <tlb_invalidate>
        }
}
  104614:	c9                   	leave  
  104615:	c3                   	ret    

00104616 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  104616:	55                   	push   %ebp
  104617:	89 e5                	mov    %esp,%ebp
  104619:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  10461c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104623:	00 
  104624:	8b 45 0c             	mov    0xc(%ebp),%eax
  104627:	89 44 24 04          	mov    %eax,0x4(%esp)
  10462b:	8b 45 08             	mov    0x8(%ebp),%eax
  10462e:	89 04 24             	mov    %eax,(%esp)
  104631:	e8 c8 fd ff ff       	call   1043fe <get_pte>
  104636:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  104639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10463d:	74 19                	je     104658 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  10463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104642:	89 44 24 08          	mov    %eax,0x8(%esp)
  104646:	8b 45 0c             	mov    0xc(%ebp),%eax
  104649:	89 44 24 04          	mov    %eax,0x4(%esp)
  10464d:	8b 45 08             	mov    0x8(%ebp),%eax
  104650:	89 04 24             	mov    %eax,(%esp)
  104653:	e8 5d ff ff ff       	call   1045b5 <page_remove_pte>
    }
}
  104658:	c9                   	leave  
  104659:	c3                   	ret    

0010465a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10465a:	55                   	push   %ebp
  10465b:	89 e5                	mov    %esp,%ebp
  10465d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  104660:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104667:	00 
  104668:	8b 45 10             	mov    0x10(%ebp),%eax
  10466b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10466f:	8b 45 08             	mov    0x8(%ebp),%eax
  104672:	89 04 24             	mov    %eax,(%esp)
  104675:	e8 84 fd ff ff       	call   1043fe <get_pte>
  10467a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  10467d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104681:	75 0a                	jne    10468d <page_insert+0x33>
        return -E_NO_MEM;
  104683:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104688:	e9 84 00 00 00       	jmp    104711 <page_insert+0xb7>
    }
    page_ref_inc(page);
  10468d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104690:	89 04 24             	mov    %eax,(%esp)
  104693:	e8 39 f4 ff ff       	call   103ad1 <page_ref_inc>
    if (*ptep & PTE_P) {
  104698:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10469b:	8b 00                	mov    (%eax),%eax
  10469d:	83 e0 01             	and    $0x1,%eax
  1046a0:	85 c0                	test   %eax,%eax
  1046a2:	74 3e                	je     1046e2 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046a7:	8b 00                	mov    (%eax),%eax
  1046a9:	89 04 24             	mov    %eax,(%esp)
  1046ac:	e8 cb f3 ff ff       	call   103a7c <pte2page>
  1046b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1046b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1046ba:	75 0d                	jne    1046c9 <page_insert+0x6f>
            page_ref_dec(page);
  1046bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046bf:	89 04 24             	mov    %eax,(%esp)
  1046c2:	e8 21 f4 ff ff       	call   103ae8 <page_ref_dec>
  1046c7:	eb 19                	jmp    1046e2 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1046c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1046d0:	8b 45 10             	mov    0x10(%ebp),%eax
  1046d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1046d7:	8b 45 08             	mov    0x8(%ebp),%eax
  1046da:	89 04 24             	mov    %eax,(%esp)
  1046dd:	e8 d3 fe ff ff       	call   1045b5 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1046e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046e5:	89 04 24             	mov    %eax,(%esp)
  1046e8:	e8 d6 f2 ff ff       	call   1039c3 <page2pa>
  1046ed:	0b 45 14             	or     0x14(%ebp),%eax
  1046f0:	83 c8 01             	or     $0x1,%eax
  1046f3:	89 c2                	mov    %eax,%edx
  1046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046f8:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  1046fa:	8b 45 10             	mov    0x10(%ebp),%eax
  1046fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  104701:	8b 45 08             	mov    0x8(%ebp),%eax
  104704:	89 04 24             	mov    %eax,(%esp)
  104707:	e8 07 00 00 00       	call   104713 <tlb_invalidate>
    return 0;
  10470c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104711:	c9                   	leave  
  104712:	c3                   	ret    

00104713 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  104713:	55                   	push   %ebp
  104714:	89 e5                	mov    %esp,%ebp
  104716:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  104719:	0f 20 d8             	mov    %cr3,%eax
  10471c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  10471f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  104722:	89 c2                	mov    %eax,%edx
  104724:	8b 45 08             	mov    0x8(%ebp),%eax
  104727:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10472a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  104731:	77 23                	ja     104756 <tlb_invalidate+0x43>
  104733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104736:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10473a:	c7 44 24 08 d0 6a 10 	movl   $0x106ad0,0x8(%esp)
  104741:	00 
  104742:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  104749:	00 
  10474a:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104751:	e8 77 c5 ff ff       	call   100ccd <__panic>
  104756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104759:	05 00 00 00 40       	add    $0x40000000,%eax
  10475e:	39 c2                	cmp    %eax,%edx
  104760:	75 0c                	jne    10476e <tlb_invalidate+0x5b>
        invlpg((void *)la);
  104762:	8b 45 0c             	mov    0xc(%ebp),%eax
  104765:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10476b:	0f 01 38             	invlpg (%eax)
    }
}
  10476e:	c9                   	leave  
  10476f:	c3                   	ret    

00104770 <check_alloc_page>:

static void
check_alloc_page(void) {
  104770:	55                   	push   %ebp
  104771:	89 e5                	mov    %esp,%ebp
  104773:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104776:	a1 5c 89 11 00       	mov    0x11895c,%eax
  10477b:	8b 40 18             	mov    0x18(%eax),%eax
  10477e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104780:	c7 04 24 54 6b 10 00 	movl   $0x106b54,(%esp)
  104787:	e8 b0 bb ff ff       	call   10033c <cprintf>
}
  10478c:	c9                   	leave  
  10478d:	c3                   	ret    

0010478e <check_pgdir>:

static void
check_pgdir(void) {
  10478e:	55                   	push   %ebp
  10478f:	89 e5                	mov    %esp,%ebp
  104791:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104794:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104799:	3d 00 80 03 00       	cmp    $0x38000,%eax
  10479e:	76 24                	jbe    1047c4 <check_pgdir+0x36>
  1047a0:	c7 44 24 0c 73 6b 10 	movl   $0x106b73,0xc(%esp)
  1047a7:	00 
  1047a8:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  1047af:	00 
  1047b0:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  1047b7:	00 
  1047b8:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1047bf:	e8 09 c5 ff ff       	call   100ccd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1047c4:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047c9:	85 c0                	test   %eax,%eax
  1047cb:	74 0e                	je     1047db <check_pgdir+0x4d>
  1047cd:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1047d2:	25 ff 0f 00 00       	and    $0xfff,%eax
  1047d7:	85 c0                	test   %eax,%eax
  1047d9:	74 24                	je     1047ff <check_pgdir+0x71>
  1047db:	c7 44 24 0c 90 6b 10 	movl   $0x106b90,0xc(%esp)
  1047e2:	00 
  1047e3:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  1047ea:	00 
  1047eb:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  1047f2:	00 
  1047f3:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1047fa:	e8 ce c4 ff ff       	call   100ccd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  1047ff:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104804:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10480b:	00 
  10480c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104813:	00 
  104814:	89 04 24             	mov    %eax,(%esp)
  104817:	e8 40 fd ff ff       	call   10455c <get_page>
  10481c:	85 c0                	test   %eax,%eax
  10481e:	74 24                	je     104844 <check_pgdir+0xb6>
  104820:	c7 44 24 0c c8 6b 10 	movl   $0x106bc8,0xc(%esp)
  104827:	00 
  104828:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  10482f:	00 
  104830:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104837:	00 
  104838:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10483f:	e8 89 c4 ff ff       	call   100ccd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10484b:	e8 6f f4 ff ff       	call   103cbf <alloc_pages>
  104850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104853:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104858:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10485f:	00 
  104860:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104867:	00 
  104868:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10486b:	89 54 24 04          	mov    %edx,0x4(%esp)
  10486f:	89 04 24             	mov    %eax,(%esp)
  104872:	e8 e3 fd ff ff       	call   10465a <page_insert>
  104877:	85 c0                	test   %eax,%eax
  104879:	74 24                	je     10489f <check_pgdir+0x111>
  10487b:	c7 44 24 0c f0 6b 10 	movl   $0x106bf0,0xc(%esp)
  104882:	00 
  104883:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  10488a:	00 
  10488b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104892:	00 
  104893:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10489a:	e8 2e c4 ff ff       	call   100ccd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  10489f:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1048a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048ab:	00 
  1048ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1048b3:	00 
  1048b4:	89 04 24             	mov    %eax,(%esp)
  1048b7:	e8 42 fb ff ff       	call   1043fe <get_pte>
  1048bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1048bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1048c3:	75 24                	jne    1048e9 <check_pgdir+0x15b>
  1048c5:	c7 44 24 0c 1c 6c 10 	movl   $0x106c1c,0xc(%esp)
  1048cc:	00 
  1048cd:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  1048d4:	00 
  1048d5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  1048dc:	00 
  1048dd:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1048e4:	e8 e4 c3 ff ff       	call   100ccd <__panic>
    assert(pa2page(*ptep) == p1);
  1048e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048ec:	8b 00                	mov    (%eax),%eax
  1048ee:	89 04 24             	mov    %eax,(%esp)
  1048f1:	e8 e3 f0 ff ff       	call   1039d9 <pa2page>
  1048f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048f9:	74 24                	je     10491f <check_pgdir+0x191>
  1048fb:	c7 44 24 0c 49 6c 10 	movl   $0x106c49,0xc(%esp)
  104902:	00 
  104903:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  10490a:	00 
  10490b:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104912:	00 
  104913:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10491a:	e8 ae c3 ff ff       	call   100ccd <__panic>
    assert(page_ref(p1) == 1);
  10491f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104922:	89 04 24             	mov    %eax,(%esp)
  104925:	e8 90 f1 ff ff       	call   103aba <page_ref>
  10492a:	83 f8 01             	cmp    $0x1,%eax
  10492d:	74 24                	je     104953 <check_pgdir+0x1c5>
  10492f:	c7 44 24 0c 5e 6c 10 	movl   $0x106c5e,0xc(%esp)
  104936:	00 
  104937:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  10493e:	00 
  10493f:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104946:	00 
  104947:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10494e:	e8 7a c3 ff ff       	call   100ccd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104953:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104958:	8b 00                	mov    (%eax),%eax
  10495a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10495f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104962:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104965:	c1 e8 0c             	shr    $0xc,%eax
  104968:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10496b:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104970:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104973:	72 23                	jb     104998 <check_pgdir+0x20a>
  104975:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104978:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10497c:	c7 44 24 08 2c 6a 10 	movl   $0x106a2c,0x8(%esp)
  104983:	00 
  104984:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  10498b:	00 
  10498c:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104993:	e8 35 c3 ff ff       	call   100ccd <__panic>
  104998:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10499b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1049a0:	83 c0 04             	add    $0x4,%eax
  1049a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1049a6:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1049ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1049b2:	00 
  1049b3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1049ba:	00 
  1049bb:	89 04 24             	mov    %eax,(%esp)
  1049be:	e8 3b fa ff ff       	call   1043fe <get_pte>
  1049c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1049c6:	74 24                	je     1049ec <check_pgdir+0x25e>
  1049c8:	c7 44 24 0c 70 6c 10 	movl   $0x106c70,0xc(%esp)
  1049cf:	00 
  1049d0:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  1049d7:	00 
  1049d8:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  1049df:	00 
  1049e0:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1049e7:	e8 e1 c2 ff ff       	call   100ccd <__panic>

    p2 = alloc_page();
  1049ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1049f3:	e8 c7 f2 ff ff       	call   103cbf <alloc_pages>
  1049f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  1049fb:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a00:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104a07:	00 
  104a08:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104a0f:	00 
  104a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104a13:	89 54 24 04          	mov    %edx,0x4(%esp)
  104a17:	89 04 24             	mov    %eax,(%esp)
  104a1a:	e8 3b fc ff ff       	call   10465a <page_insert>
  104a1f:	85 c0                	test   %eax,%eax
  104a21:	74 24                	je     104a47 <check_pgdir+0x2b9>
  104a23:	c7 44 24 0c 98 6c 10 	movl   $0x106c98,0xc(%esp)
  104a2a:	00 
  104a2b:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104a32:	00 
  104a33:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104a3a:	00 
  104a3b:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104a42:	e8 86 c2 ff ff       	call   100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104a47:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104a4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104a53:	00 
  104a54:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104a5b:	00 
  104a5c:	89 04 24             	mov    %eax,(%esp)
  104a5f:	e8 9a f9 ff ff       	call   1043fe <get_pte>
  104a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104a6b:	75 24                	jne    104a91 <check_pgdir+0x303>
  104a6d:	c7 44 24 0c d0 6c 10 	movl   $0x106cd0,0xc(%esp)
  104a74:	00 
  104a75:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104a7c:	00 
  104a7d:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104a84:	00 
  104a85:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104a8c:	e8 3c c2 ff ff       	call   100ccd <__panic>
    assert(*ptep & PTE_U);
  104a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104a94:	8b 00                	mov    (%eax),%eax
  104a96:	83 e0 04             	and    $0x4,%eax
  104a99:	85 c0                	test   %eax,%eax
  104a9b:	75 24                	jne    104ac1 <check_pgdir+0x333>
  104a9d:	c7 44 24 0c 00 6d 10 	movl   $0x106d00,0xc(%esp)
  104aa4:	00 
  104aa5:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104aac:	00 
  104aad:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104ab4:	00 
  104ab5:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104abc:	e8 0c c2 ff ff       	call   100ccd <__panic>
    assert(*ptep & PTE_W);
  104ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ac4:	8b 00                	mov    (%eax),%eax
  104ac6:	83 e0 02             	and    $0x2,%eax
  104ac9:	85 c0                	test   %eax,%eax
  104acb:	75 24                	jne    104af1 <check_pgdir+0x363>
  104acd:	c7 44 24 0c 0e 6d 10 	movl   $0x106d0e,0xc(%esp)
  104ad4:	00 
  104ad5:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104adc:	00 
  104add:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104ae4:	00 
  104ae5:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104aec:	e8 dc c1 ff ff       	call   100ccd <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104af1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104af6:	8b 00                	mov    (%eax),%eax
  104af8:	83 e0 04             	and    $0x4,%eax
  104afb:	85 c0                	test   %eax,%eax
  104afd:	75 24                	jne    104b23 <check_pgdir+0x395>
  104aff:	c7 44 24 0c 1c 6d 10 	movl   $0x106d1c,0xc(%esp)
  104b06:	00 
  104b07:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104b0e:	00 
  104b0f:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104b16:	00 
  104b17:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104b1e:	e8 aa c1 ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 1);
  104b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104b26:	89 04 24             	mov    %eax,(%esp)
  104b29:	e8 8c ef ff ff       	call   103aba <page_ref>
  104b2e:	83 f8 01             	cmp    $0x1,%eax
  104b31:	74 24                	je     104b57 <check_pgdir+0x3c9>
  104b33:	c7 44 24 0c 32 6d 10 	movl   $0x106d32,0xc(%esp)
  104b3a:	00 
  104b3b:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104b42:	00 
  104b43:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104b4a:	00 
  104b4b:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104b52:	e8 76 c1 ff ff       	call   100ccd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104b57:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104b5c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104b63:	00 
  104b64:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104b6b:	00 
  104b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b6f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b73:	89 04 24             	mov    %eax,(%esp)
  104b76:	e8 df fa ff ff       	call   10465a <page_insert>
  104b7b:	85 c0                	test   %eax,%eax
  104b7d:	74 24                	je     104ba3 <check_pgdir+0x415>
  104b7f:	c7 44 24 0c 44 6d 10 	movl   $0x106d44,0xc(%esp)
  104b86:	00 
  104b87:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104b8e:	00 
  104b8f:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104b96:	00 
  104b97:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104b9e:	e8 2a c1 ff ff       	call   100ccd <__panic>
    assert(page_ref(p1) == 2);
  104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ba6:	89 04 24             	mov    %eax,(%esp)
  104ba9:	e8 0c ef ff ff       	call   103aba <page_ref>
  104bae:	83 f8 02             	cmp    $0x2,%eax
  104bb1:	74 24                	je     104bd7 <check_pgdir+0x449>
  104bb3:	c7 44 24 0c 70 6d 10 	movl   $0x106d70,0xc(%esp)
  104bba:	00 
  104bbb:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104bc2:	00 
  104bc3:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104bca:	00 
  104bcb:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104bd2:	e8 f6 c0 ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104bda:	89 04 24             	mov    %eax,(%esp)
  104bdd:	e8 d8 ee ff ff       	call   103aba <page_ref>
  104be2:	85 c0                	test   %eax,%eax
  104be4:	74 24                	je     104c0a <check_pgdir+0x47c>
  104be6:	c7 44 24 0c 82 6d 10 	movl   $0x106d82,0xc(%esp)
  104bed:	00 
  104bee:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104bf5:	00 
  104bf6:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104bfd:	00 
  104bfe:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104c05:	e8 c3 c0 ff ff       	call   100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104c0a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104c0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c16:	00 
  104c17:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c1e:	00 
  104c1f:	89 04 24             	mov    %eax,(%esp)
  104c22:	e8 d7 f7 ff ff       	call   1043fe <get_pte>
  104c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104c2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104c2e:	75 24                	jne    104c54 <check_pgdir+0x4c6>
  104c30:	c7 44 24 0c d0 6c 10 	movl   $0x106cd0,0xc(%esp)
  104c37:	00 
  104c38:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104c3f:	00 
  104c40:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104c47:	00 
  104c48:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104c4f:	e8 79 c0 ff ff       	call   100ccd <__panic>
    assert(pa2page(*ptep) == p1);
  104c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c57:	8b 00                	mov    (%eax),%eax
  104c59:	89 04 24             	mov    %eax,(%esp)
  104c5c:	e8 78 ed ff ff       	call   1039d9 <pa2page>
  104c61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104c64:	74 24                	je     104c8a <check_pgdir+0x4fc>
  104c66:	c7 44 24 0c 49 6c 10 	movl   $0x106c49,0xc(%esp)
  104c6d:	00 
  104c6e:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104c75:	00 
  104c76:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104c7d:	00 
  104c7e:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104c85:	e8 43 c0 ff ff       	call   100ccd <__panic>
    assert((*ptep & PTE_U) == 0);
  104c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104c8d:	8b 00                	mov    (%eax),%eax
  104c8f:	83 e0 04             	and    $0x4,%eax
  104c92:	85 c0                	test   %eax,%eax
  104c94:	74 24                	je     104cba <check_pgdir+0x52c>
  104c96:	c7 44 24 0c 94 6d 10 	movl   $0x106d94,0xc(%esp)
  104c9d:	00 
  104c9e:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104ca5:	00 
  104ca6:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104cad:	00 
  104cae:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104cb5:	e8 13 c0 ff ff       	call   100ccd <__panic>

    page_remove(boot_pgdir, 0x0);
  104cba:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104cbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104cc6:	00 
  104cc7:	89 04 24             	mov    %eax,(%esp)
  104cca:	e8 47 f9 ff ff       	call   104616 <page_remove>
    assert(page_ref(p1) == 1);
  104ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104cd2:	89 04 24             	mov    %eax,(%esp)
  104cd5:	e8 e0 ed ff ff       	call   103aba <page_ref>
  104cda:	83 f8 01             	cmp    $0x1,%eax
  104cdd:	74 24                	je     104d03 <check_pgdir+0x575>
  104cdf:	c7 44 24 0c 5e 6c 10 	movl   $0x106c5e,0xc(%esp)
  104ce6:	00 
  104ce7:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104cee:	00 
  104cef:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104cf6:	00 
  104cf7:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104cfe:	e8 ca bf ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d06:	89 04 24             	mov    %eax,(%esp)
  104d09:	e8 ac ed ff ff       	call   103aba <page_ref>
  104d0e:	85 c0                	test   %eax,%eax
  104d10:	74 24                	je     104d36 <check_pgdir+0x5a8>
  104d12:	c7 44 24 0c 82 6d 10 	movl   $0x106d82,0xc(%esp)
  104d19:	00 
  104d1a:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104d21:	00 
  104d22:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104d29:	00 
  104d2a:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104d31:	e8 97 bf ff ff       	call   100ccd <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104d36:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104d3b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104d42:	00 
  104d43:	89 04 24             	mov    %eax,(%esp)
  104d46:	e8 cb f8 ff ff       	call   104616 <page_remove>
    assert(page_ref(p1) == 0);
  104d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d4e:	89 04 24             	mov    %eax,(%esp)
  104d51:	e8 64 ed ff ff       	call   103aba <page_ref>
  104d56:	85 c0                	test   %eax,%eax
  104d58:	74 24                	je     104d7e <check_pgdir+0x5f0>
  104d5a:	c7 44 24 0c a9 6d 10 	movl   $0x106da9,0xc(%esp)
  104d61:	00 
  104d62:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104d69:	00 
  104d6a:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  104d71:	00 
  104d72:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104d79:	e8 4f bf ff ff       	call   100ccd <__panic>
    assert(page_ref(p2) == 0);
  104d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d81:	89 04 24             	mov    %eax,(%esp)
  104d84:	e8 31 ed ff ff       	call   103aba <page_ref>
  104d89:	85 c0                	test   %eax,%eax
  104d8b:	74 24                	je     104db1 <check_pgdir+0x623>
  104d8d:	c7 44 24 0c 82 6d 10 	movl   $0x106d82,0xc(%esp)
  104d94:	00 
  104d95:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104d9c:	00 
  104d9d:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  104da4:	00 
  104da5:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104dac:	e8 1c bf ff ff       	call   100ccd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
  104db1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104db6:	8b 00                	mov    (%eax),%eax
  104db8:	89 04 24             	mov    %eax,(%esp)
  104dbb:	e8 19 ec ff ff       	call   1039d9 <pa2page>
  104dc0:	89 04 24             	mov    %eax,(%esp)
  104dc3:	e8 f2 ec ff ff       	call   103aba <page_ref>
  104dc8:	83 f8 01             	cmp    $0x1,%eax
  104dcb:	74 24                	je     104df1 <check_pgdir+0x663>
  104dcd:	c7 44 24 0c bc 6d 10 	movl   $0x106dbc,0xc(%esp)
  104dd4:	00 
  104dd5:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104ddc:	00 
  104ddd:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  104de4:	00 
  104de5:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104dec:	e8 dc be ff ff       	call   100ccd <__panic>
    free_page(pa2page(boot_pgdir[0]));
  104df1:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104df6:	8b 00                	mov    (%eax),%eax
  104df8:	89 04 24             	mov    %eax,(%esp)
  104dfb:	e8 d9 eb ff ff       	call   1039d9 <pa2page>
  104e00:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104e07:	00 
  104e08:	89 04 24             	mov    %eax,(%esp)
  104e0b:	e8 e7 ee ff ff       	call   103cf7 <free_pages>
    boot_pgdir[0] = 0;
  104e10:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  104e1b:	c7 04 24 e2 6d 10 00 	movl   $0x106de2,(%esp)
  104e22:	e8 15 b5 ff ff       	call   10033c <cprintf>
}
  104e27:	c9                   	leave  
  104e28:	c3                   	ret    

00104e29 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  104e29:	55                   	push   %ebp
  104e2a:	89 e5                	mov    %esp,%ebp
  104e2c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104e2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104e36:	e9 ca 00 00 00       	jmp    104f05 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  104e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e44:	c1 e8 0c             	shr    $0xc,%eax
  104e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104e4a:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104e4f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  104e52:	72 23                	jb     104e77 <check_boot_pgdir+0x4e>
  104e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e57:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104e5b:	c7 44 24 08 2c 6a 10 	movl   $0x106a2c,0x8(%esp)
  104e62:	00 
  104e63:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104e6a:	00 
  104e6b:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104e72:	e8 56 be ff ff       	call   100ccd <__panic>
  104e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e7a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104e7f:	89 c2                	mov    %eax,%edx
  104e81:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104e86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104e8d:	00 
  104e8e:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e92:	89 04 24             	mov    %eax,(%esp)
  104e95:	e8 64 f5 ff ff       	call   1043fe <get_pte>
  104e9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104e9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104ea1:	75 24                	jne    104ec7 <check_boot_pgdir+0x9e>
  104ea3:	c7 44 24 0c fc 6d 10 	movl   $0x106dfc,0xc(%esp)
  104eaa:	00 
  104eab:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104eb2:	00 
  104eb3:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  104eba:	00 
  104ebb:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104ec2:	e8 06 be ff ff       	call   100ccd <__panic>
        assert(PTE_ADDR(*ptep) == i);
  104ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104eca:	8b 00                	mov    (%eax),%eax
  104ecc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104ed1:	89 c2                	mov    %eax,%edx
  104ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104ed6:	39 c2                	cmp    %eax,%edx
  104ed8:	74 24                	je     104efe <check_boot_pgdir+0xd5>
  104eda:	c7 44 24 0c 39 6e 10 	movl   $0x106e39,0xc(%esp)
  104ee1:	00 
  104ee2:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104ee9:	00 
  104eea:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  104ef1:	00 
  104ef2:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104ef9:	e8 cf bd ff ff       	call   100ccd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  104efe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104f08:	a1 c0 88 11 00       	mov    0x1188c0,%eax
  104f0d:	39 c2                	cmp    %eax,%edx
  104f0f:	0f 82 26 ff ff ff    	jb     104e3b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  104f15:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f1a:	05 ac 0f 00 00       	add    $0xfac,%eax
  104f1f:	8b 00                	mov    (%eax),%eax
  104f21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104f26:	89 c2                	mov    %eax,%edx
  104f28:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104f30:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  104f37:	77 23                	ja     104f5c <check_boot_pgdir+0x133>
  104f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104f40:	c7 44 24 08 d0 6a 10 	movl   $0x106ad0,0x8(%esp)
  104f47:	00 
  104f48:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104f4f:	00 
  104f50:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104f57:	e8 71 bd ff ff       	call   100ccd <__panic>
  104f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104f5f:	05 00 00 00 40       	add    $0x40000000,%eax
  104f64:	39 c2                	cmp    %eax,%edx
  104f66:	74 24                	je     104f8c <check_boot_pgdir+0x163>
  104f68:	c7 44 24 0c 50 6e 10 	movl   $0x106e50,0xc(%esp)
  104f6f:	00 
  104f70:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104f77:	00 
  104f78:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  104f7f:	00 
  104f80:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104f87:	e8 41 bd ff ff       	call   100ccd <__panic>

    assert(boot_pgdir[0] == 0);
  104f8c:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104f91:	8b 00                	mov    (%eax),%eax
  104f93:	85 c0                	test   %eax,%eax
  104f95:	74 24                	je     104fbb <check_boot_pgdir+0x192>
  104f97:	c7 44 24 0c 84 6e 10 	movl   $0x106e84,0xc(%esp)
  104f9e:	00 
  104f9f:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  104fa6:	00 
  104fa7:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  104fae:	00 
  104faf:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  104fb6:	e8 12 bd ff ff       	call   100ccd <__panic>

    struct Page *p;
    p = alloc_page();
  104fbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104fc2:	e8 f8 ec ff ff       	call   103cbf <alloc_pages>
  104fc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  104fca:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  104fcf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  104fd6:	00 
  104fd7:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  104fde:	00 
  104fdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
  104fe6:	89 04 24             	mov    %eax,(%esp)
  104fe9:	e8 6c f6 ff ff       	call   10465a <page_insert>
  104fee:	85 c0                	test   %eax,%eax
  104ff0:	74 24                	je     105016 <check_boot_pgdir+0x1ed>
  104ff2:	c7 44 24 0c 98 6e 10 	movl   $0x106e98,0xc(%esp)
  104ff9:	00 
  104ffa:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  105001:	00 
  105002:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  105009:	00 
  10500a:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  105011:	e8 b7 bc ff ff       	call   100ccd <__panic>
    assert(page_ref(p) == 1);
  105016:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105019:	89 04 24             	mov    %eax,(%esp)
  10501c:	e8 99 ea ff ff       	call   103aba <page_ref>
  105021:	83 f8 01             	cmp    $0x1,%eax
  105024:	74 24                	je     10504a <check_boot_pgdir+0x221>
  105026:	c7 44 24 0c c6 6e 10 	movl   $0x106ec6,0xc(%esp)
  10502d:	00 
  10502e:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  105035:	00 
  105036:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  10503d:	00 
  10503e:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  105045:	e8 83 bc ff ff       	call   100ccd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  10504a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10504f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105056:	00 
  105057:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  10505e:	00 
  10505f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105062:	89 54 24 04          	mov    %edx,0x4(%esp)
  105066:	89 04 24             	mov    %eax,(%esp)
  105069:	e8 ec f5 ff ff       	call   10465a <page_insert>
  10506e:	85 c0                	test   %eax,%eax
  105070:	74 24                	je     105096 <check_boot_pgdir+0x26d>
  105072:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  105079:	00 
  10507a:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  105081:	00 
  105082:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  105089:	00 
  10508a:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  105091:	e8 37 bc ff ff       	call   100ccd <__panic>
    assert(page_ref(p) == 2);
  105096:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105099:	89 04 24             	mov    %eax,(%esp)
  10509c:	e8 19 ea ff ff       	call   103aba <page_ref>
  1050a1:	83 f8 02             	cmp    $0x2,%eax
  1050a4:	74 24                	je     1050ca <check_boot_pgdir+0x2a1>
  1050a6:	c7 44 24 0c 0f 6f 10 	movl   $0x106f0f,0xc(%esp)
  1050ad:	00 
  1050ae:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  1050b5:	00 
  1050b6:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  1050bd:	00 
  1050be:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  1050c5:	e8 03 bc ff ff       	call   100ccd <__panic>

    const char *str = "ucore: Hello world!!";
  1050ca:	c7 45 dc 20 6f 10 00 	movl   $0x106f20,-0x24(%ebp)
    strcpy((void *)0x100, str);
  1050d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1050d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1050d8:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050df:	e8 1e 0a 00 00       	call   105b02 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  1050e4:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  1050eb:	00 
  1050ec:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1050f3:	e8 83 0a 00 00       	call   105b7b <strcmp>
  1050f8:	85 c0                	test   %eax,%eax
  1050fa:	74 24                	je     105120 <check_boot_pgdir+0x2f7>
  1050fc:	c7 44 24 0c 38 6f 10 	movl   $0x106f38,0xc(%esp)
  105103:	00 
  105104:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  10510b:	00 
  10510c:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  105113:	00 
  105114:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  10511b:	e8 ad bb ff ff       	call   100ccd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  105120:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105123:	89 04 24             	mov    %eax,(%esp)
  105126:	e8 fd e8 ff ff       	call   103a28 <page2kva>
  10512b:	05 00 01 00 00       	add    $0x100,%eax
  105130:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  105133:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  10513a:	e8 6b 09 00 00       	call   105aaa <strlen>
  10513f:	85 c0                	test   %eax,%eax
  105141:	74 24                	je     105167 <check_boot_pgdir+0x33e>
  105143:	c7 44 24 0c 70 6f 10 	movl   $0x106f70,0xc(%esp)
  10514a:	00 
  10514b:	c7 44 24 08 19 6b 10 	movl   $0x106b19,0x8(%esp)
  105152:	00 
  105153:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  10515a:	00 
  10515b:	c7 04 24 f4 6a 10 00 	movl   $0x106af4,(%esp)
  105162:	e8 66 bb ff ff       	call   100ccd <__panic>

    free_page(p);
  105167:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10516e:	00 
  10516f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105172:	89 04 24             	mov    %eax,(%esp)
  105175:	e8 7d eb ff ff       	call   103cf7 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
  10517a:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  10517f:	8b 00                	mov    (%eax),%eax
  105181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  105186:	89 04 24             	mov    %eax,(%esp)
  105189:	e8 4b e8 ff ff       	call   1039d9 <pa2page>
  10518e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105195:	00 
  105196:	89 04 24             	mov    %eax,(%esp)
  105199:	e8 59 eb ff ff       	call   103cf7 <free_pages>
    boot_pgdir[0] = 0;
  10519e:	a1 c4 88 11 00       	mov    0x1188c4,%eax
  1051a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  1051a9:	c7 04 24 94 6f 10 00 	movl   $0x106f94,(%esp)
  1051b0:	e8 87 b1 ff ff       	call   10033c <cprintf>
}
  1051b5:	c9                   	leave  
  1051b6:	c3                   	ret    

001051b7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  1051b7:	55                   	push   %ebp
  1051b8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  1051ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1051bd:	83 e0 04             	and    $0x4,%eax
  1051c0:	85 c0                	test   %eax,%eax
  1051c2:	74 07                	je     1051cb <perm2str+0x14>
  1051c4:	b8 75 00 00 00       	mov    $0x75,%eax
  1051c9:	eb 05                	jmp    1051d0 <perm2str+0x19>
  1051cb:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051d0:	a2 48 89 11 00       	mov    %al,0x118948
    str[1] = 'r';
  1051d5:	c6 05 49 89 11 00 72 	movb   $0x72,0x118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  1051dc:	8b 45 08             	mov    0x8(%ebp),%eax
  1051df:	83 e0 02             	and    $0x2,%eax
  1051e2:	85 c0                	test   %eax,%eax
  1051e4:	74 07                	je     1051ed <perm2str+0x36>
  1051e6:	b8 77 00 00 00       	mov    $0x77,%eax
  1051eb:	eb 05                	jmp    1051f2 <perm2str+0x3b>
  1051ed:	b8 2d 00 00 00       	mov    $0x2d,%eax
  1051f2:	a2 4a 89 11 00       	mov    %al,0x11894a
    str[3] = '\0';
  1051f7:	c6 05 4b 89 11 00 00 	movb   $0x0,0x11894b
    return str;
  1051fe:	b8 48 89 11 00       	mov    $0x118948,%eax
}
  105203:	5d                   	pop    %ebp
  105204:	c3                   	ret    

00105205 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  105205:	55                   	push   %ebp
  105206:	89 e5                	mov    %esp,%ebp
  105208:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  10520b:	8b 45 10             	mov    0x10(%ebp),%eax
  10520e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105211:	72 0a                	jb     10521d <get_pgtable_items+0x18>
        return 0;
  105213:	b8 00 00 00 00       	mov    $0x0,%eax
  105218:	e9 9c 00 00 00       	jmp    1052b9 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
  10521d:	eb 04                	jmp    105223 <get_pgtable_items+0x1e>
        start ++;
  10521f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  105223:	8b 45 10             	mov    0x10(%ebp),%eax
  105226:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105229:	73 18                	jae    105243 <get_pgtable_items+0x3e>
  10522b:	8b 45 10             	mov    0x10(%ebp),%eax
  10522e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105235:	8b 45 14             	mov    0x14(%ebp),%eax
  105238:	01 d0                	add    %edx,%eax
  10523a:	8b 00                	mov    (%eax),%eax
  10523c:	83 e0 01             	and    $0x1,%eax
  10523f:	85 c0                	test   %eax,%eax
  105241:	74 dc                	je     10521f <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
  105243:	8b 45 10             	mov    0x10(%ebp),%eax
  105246:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105249:	73 69                	jae    1052b4 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
  10524b:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  10524f:	74 08                	je     105259 <get_pgtable_items+0x54>
            *left_store = start;
  105251:	8b 45 18             	mov    0x18(%ebp),%eax
  105254:	8b 55 10             	mov    0x10(%ebp),%edx
  105257:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  105259:	8b 45 10             	mov    0x10(%ebp),%eax
  10525c:	8d 50 01             	lea    0x1(%eax),%edx
  10525f:	89 55 10             	mov    %edx,0x10(%ebp)
  105262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  105269:	8b 45 14             	mov    0x14(%ebp),%eax
  10526c:	01 d0                	add    %edx,%eax
  10526e:	8b 00                	mov    (%eax),%eax
  105270:	83 e0 07             	and    $0x7,%eax
  105273:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105276:	eb 04                	jmp    10527c <get_pgtable_items+0x77>
            start ++;
  105278:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  10527c:	8b 45 10             	mov    0x10(%ebp),%eax
  10527f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105282:	73 1d                	jae    1052a1 <get_pgtable_items+0x9c>
  105284:	8b 45 10             	mov    0x10(%ebp),%eax
  105287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10528e:	8b 45 14             	mov    0x14(%ebp),%eax
  105291:	01 d0                	add    %edx,%eax
  105293:	8b 00                	mov    (%eax),%eax
  105295:	83 e0 07             	and    $0x7,%eax
  105298:	89 c2                	mov    %eax,%edx
  10529a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10529d:	39 c2                	cmp    %eax,%edx
  10529f:	74 d7                	je     105278 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
  1052a1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1052a5:	74 08                	je     1052af <get_pgtable_items+0xaa>
            *right_store = start;
  1052a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1052aa:	8b 55 10             	mov    0x10(%ebp),%edx
  1052ad:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1052af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1052b2:	eb 05                	jmp    1052b9 <get_pgtable_items+0xb4>
    }
    return 0;
  1052b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1052b9:	c9                   	leave  
  1052ba:	c3                   	ret    

001052bb <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1052bb:	55                   	push   %ebp
  1052bc:	89 e5                	mov    %esp,%ebp
  1052be:	57                   	push   %edi
  1052bf:	56                   	push   %esi
  1052c0:	53                   	push   %ebx
  1052c1:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1052c4:	c7 04 24 b4 6f 10 00 	movl   $0x106fb4,(%esp)
  1052cb:	e8 6c b0 ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
  1052d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1052d7:	e9 fa 00 00 00       	jmp    1053d6 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052df:	89 04 24             	mov    %eax,(%esp)
  1052e2:	e8 d0 fe ff ff       	call   1051b7 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1052e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1052ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1052ed:	29 d1                	sub    %edx,%ecx
  1052ef:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1052f1:	89 d6                	mov    %edx,%esi
  1052f3:	c1 e6 16             	shl    $0x16,%esi
  1052f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1052f9:	89 d3                	mov    %edx,%ebx
  1052fb:	c1 e3 16             	shl    $0x16,%ebx
  1052fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105301:	89 d1                	mov    %edx,%ecx
  105303:	c1 e1 16             	shl    $0x16,%ecx
  105306:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105309:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10530c:	29 d7                	sub    %edx,%edi
  10530e:	89 fa                	mov    %edi,%edx
  105310:	89 44 24 14          	mov    %eax,0x14(%esp)
  105314:	89 74 24 10          	mov    %esi,0x10(%esp)
  105318:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10531c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105320:	89 54 24 04          	mov    %edx,0x4(%esp)
  105324:	c7 04 24 e5 6f 10 00 	movl   $0x106fe5,(%esp)
  10532b:	e8 0c b0 ff ff       	call   10033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  105330:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105333:	c1 e0 0a             	shl    $0xa,%eax
  105336:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105339:	eb 54                	jmp    10538f <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10533b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10533e:	89 04 24             	mov    %eax,(%esp)
  105341:	e8 71 fe ff ff       	call   1051b7 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  105346:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  105349:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10534c:	29 d1                	sub    %edx,%ecx
  10534e:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  105350:	89 d6                	mov    %edx,%esi
  105352:	c1 e6 0c             	shl    $0xc,%esi
  105355:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105358:	89 d3                	mov    %edx,%ebx
  10535a:	c1 e3 0c             	shl    $0xc,%ebx
  10535d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  105360:	c1 e2 0c             	shl    $0xc,%edx
  105363:	89 d1                	mov    %edx,%ecx
  105365:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  105368:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10536b:	29 d7                	sub    %edx,%edi
  10536d:	89 fa                	mov    %edi,%edx
  10536f:	89 44 24 14          	mov    %eax,0x14(%esp)
  105373:	89 74 24 10          	mov    %esi,0x10(%esp)
  105377:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10537b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  10537f:	89 54 24 04          	mov    %edx,0x4(%esp)
  105383:	c7 04 24 04 70 10 00 	movl   $0x107004,(%esp)
  10538a:	e8 ad af ff ff       	call   10033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10538f:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
  105394:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  105397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10539a:	89 ce                	mov    %ecx,%esi
  10539c:	c1 e6 0a             	shl    $0xa,%esi
  10539f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  1053a2:	89 cb                	mov    %ecx,%ebx
  1053a4:	c1 e3 0a             	shl    $0xa,%ebx
  1053a7:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  1053aa:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053ae:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  1053b1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053bd:	89 74 24 04          	mov    %esi,0x4(%esp)
  1053c1:	89 1c 24             	mov    %ebx,(%esp)
  1053c4:	e8 3c fe ff ff       	call   105205 <get_pgtable_items>
  1053c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1053cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1053d0:	0f 85 65 ff ff ff    	jne    10533b <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1053d6:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
  1053db:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1053de:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  1053e1:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  1053e5:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  1053e8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  1053ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1053f0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1053f4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1053fb:	00 
  1053fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  105403:	e8 fd fd ff ff       	call   105205 <get_pgtable_items>
  105408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10540b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10540f:	0f 85 c7 fe ff ff    	jne    1052dc <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  105415:	c7 04 24 28 70 10 00 	movl   $0x107028,(%esp)
  10541c:	e8 1b af ff ff       	call   10033c <cprintf>
}
  105421:	83 c4 4c             	add    $0x4c,%esp
  105424:	5b                   	pop    %ebx
  105425:	5e                   	pop    %esi
  105426:	5f                   	pop    %edi
  105427:	5d                   	pop    %ebp
  105428:	c3                   	ret    

00105429 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  105429:	55                   	push   %ebp
  10542a:	89 e5                	mov    %esp,%ebp
  10542c:	83 ec 58             	sub    $0x58,%esp
  10542f:	8b 45 10             	mov    0x10(%ebp),%eax
  105432:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105435:	8b 45 14             	mov    0x14(%ebp),%eax
  105438:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10543b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10543e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  105441:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105444:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  105447:	8b 45 18             	mov    0x18(%ebp),%eax
  10544a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10544d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105450:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105453:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105456:	89 55 f0             	mov    %edx,-0x10(%ebp)
  105459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10545c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10545f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105463:	74 1c                	je     105481 <printnum+0x58>
  105465:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105468:	ba 00 00 00 00       	mov    $0x0,%edx
  10546d:	f7 75 e4             	divl   -0x1c(%ebp)
  105470:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105476:	ba 00 00 00 00       	mov    $0x0,%edx
  10547b:	f7 75 e4             	divl   -0x1c(%ebp)
  10547e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105481:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105484:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105487:	f7 75 e4             	divl   -0x1c(%ebp)
  10548a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10548d:	89 55 dc             	mov    %edx,-0x24(%ebp)
  105490:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105493:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105496:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105499:	89 55 ec             	mov    %edx,-0x14(%ebp)
  10549c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10549f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1054a2:	8b 45 18             	mov    0x18(%ebp),%eax
  1054a5:	ba 00 00 00 00       	mov    $0x0,%edx
  1054aa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054ad:	77 56                	ja     105505 <printnum+0xdc>
  1054af:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1054b2:	72 05                	jb     1054b9 <printnum+0x90>
  1054b4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1054b7:	77 4c                	ja     105505 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1054b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1054bc:	8d 50 ff             	lea    -0x1(%eax),%edx
  1054bf:	8b 45 20             	mov    0x20(%ebp),%eax
  1054c2:	89 44 24 18          	mov    %eax,0x18(%esp)
  1054c6:	89 54 24 14          	mov    %edx,0x14(%esp)
  1054ca:	8b 45 18             	mov    0x18(%ebp),%eax
  1054cd:	89 44 24 10          	mov    %eax,0x10(%esp)
  1054d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1054d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1054d7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1054db:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1054df:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1054e9:	89 04 24             	mov    %eax,(%esp)
  1054ec:	e8 38 ff ff ff       	call   105429 <printnum>
  1054f1:	eb 1c                	jmp    10550f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1054f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1054fa:	8b 45 20             	mov    0x20(%ebp),%eax
  1054fd:	89 04 24             	mov    %eax,(%esp)
  105500:	8b 45 08             	mov    0x8(%ebp),%eax
  105503:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  105505:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  105509:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10550d:	7f e4                	jg     1054f3 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10550f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105512:	05 dc 70 10 00       	add    $0x1070dc,%eax
  105517:	0f b6 00             	movzbl (%eax),%eax
  10551a:	0f be c0             	movsbl %al,%eax
  10551d:	8b 55 0c             	mov    0xc(%ebp),%edx
  105520:	89 54 24 04          	mov    %edx,0x4(%esp)
  105524:	89 04 24             	mov    %eax,(%esp)
  105527:	8b 45 08             	mov    0x8(%ebp),%eax
  10552a:	ff d0                	call   *%eax
}
  10552c:	c9                   	leave  
  10552d:	c3                   	ret    

0010552e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  10552e:	55                   	push   %ebp
  10552f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105531:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105535:	7e 14                	jle    10554b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105537:	8b 45 08             	mov    0x8(%ebp),%eax
  10553a:	8b 00                	mov    (%eax),%eax
  10553c:	8d 48 08             	lea    0x8(%eax),%ecx
  10553f:	8b 55 08             	mov    0x8(%ebp),%edx
  105542:	89 0a                	mov    %ecx,(%edx)
  105544:	8b 50 04             	mov    0x4(%eax),%edx
  105547:	8b 00                	mov    (%eax),%eax
  105549:	eb 30                	jmp    10557b <getuint+0x4d>
    }
    else if (lflag) {
  10554b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10554f:	74 16                	je     105567 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  105551:	8b 45 08             	mov    0x8(%ebp),%eax
  105554:	8b 00                	mov    (%eax),%eax
  105556:	8d 48 04             	lea    0x4(%eax),%ecx
  105559:	8b 55 08             	mov    0x8(%ebp),%edx
  10555c:	89 0a                	mov    %ecx,(%edx)
  10555e:	8b 00                	mov    (%eax),%eax
  105560:	ba 00 00 00 00       	mov    $0x0,%edx
  105565:	eb 14                	jmp    10557b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105567:	8b 45 08             	mov    0x8(%ebp),%eax
  10556a:	8b 00                	mov    (%eax),%eax
  10556c:	8d 48 04             	lea    0x4(%eax),%ecx
  10556f:	8b 55 08             	mov    0x8(%ebp),%edx
  105572:	89 0a                	mov    %ecx,(%edx)
  105574:	8b 00                	mov    (%eax),%eax
  105576:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  10557b:	5d                   	pop    %ebp
  10557c:	c3                   	ret    

0010557d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10557d:	55                   	push   %ebp
  10557e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105580:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105584:	7e 14                	jle    10559a <getint+0x1d>
        return va_arg(*ap, long long);
  105586:	8b 45 08             	mov    0x8(%ebp),%eax
  105589:	8b 00                	mov    (%eax),%eax
  10558b:	8d 48 08             	lea    0x8(%eax),%ecx
  10558e:	8b 55 08             	mov    0x8(%ebp),%edx
  105591:	89 0a                	mov    %ecx,(%edx)
  105593:	8b 50 04             	mov    0x4(%eax),%edx
  105596:	8b 00                	mov    (%eax),%eax
  105598:	eb 28                	jmp    1055c2 <getint+0x45>
    }
    else if (lflag) {
  10559a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10559e:	74 12                	je     1055b2 <getint+0x35>
        return va_arg(*ap, long);
  1055a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1055a3:	8b 00                	mov    (%eax),%eax
  1055a5:	8d 48 04             	lea    0x4(%eax),%ecx
  1055a8:	8b 55 08             	mov    0x8(%ebp),%edx
  1055ab:	89 0a                	mov    %ecx,(%edx)
  1055ad:	8b 00                	mov    (%eax),%eax
  1055af:	99                   	cltd   
  1055b0:	eb 10                	jmp    1055c2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  1055b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1055b5:	8b 00                	mov    (%eax),%eax
  1055b7:	8d 48 04             	lea    0x4(%eax),%ecx
  1055ba:	8b 55 08             	mov    0x8(%ebp),%edx
  1055bd:	89 0a                	mov    %ecx,(%edx)
  1055bf:	8b 00                	mov    (%eax),%eax
  1055c1:	99                   	cltd   
    }
}
  1055c2:	5d                   	pop    %ebp
  1055c3:	c3                   	ret    

001055c4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  1055c4:	55                   	push   %ebp
  1055c5:	89 e5                	mov    %esp,%ebp
  1055c7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1055ca:	8d 45 14             	lea    0x14(%ebp),%eax
  1055cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  1055d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1055d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1055d7:	8b 45 10             	mov    0x10(%ebp),%eax
  1055da:	89 44 24 08          	mov    %eax,0x8(%esp)
  1055de:	8b 45 0c             	mov    0xc(%ebp),%eax
  1055e1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1055e5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055e8:	89 04 24             	mov    %eax,(%esp)
  1055eb:	e8 02 00 00 00       	call   1055f2 <vprintfmt>
    va_end(ap);
}
  1055f0:	c9                   	leave  
  1055f1:	c3                   	ret    

001055f2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1055f2:	55                   	push   %ebp
  1055f3:	89 e5                	mov    %esp,%ebp
  1055f5:	56                   	push   %esi
  1055f6:	53                   	push   %ebx
  1055f7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1055fa:	eb 18                	jmp    105614 <vprintfmt+0x22>
            if (ch == '\0') {
  1055fc:	85 db                	test   %ebx,%ebx
  1055fe:	75 05                	jne    105605 <vprintfmt+0x13>
                return;
  105600:	e9 d1 03 00 00       	jmp    1059d6 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  105605:	8b 45 0c             	mov    0xc(%ebp),%eax
  105608:	89 44 24 04          	mov    %eax,0x4(%esp)
  10560c:	89 1c 24             	mov    %ebx,(%esp)
  10560f:	8b 45 08             	mov    0x8(%ebp),%eax
  105612:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105614:	8b 45 10             	mov    0x10(%ebp),%eax
  105617:	8d 50 01             	lea    0x1(%eax),%edx
  10561a:	89 55 10             	mov    %edx,0x10(%ebp)
  10561d:	0f b6 00             	movzbl (%eax),%eax
  105620:	0f b6 d8             	movzbl %al,%ebx
  105623:	83 fb 25             	cmp    $0x25,%ebx
  105626:	75 d4                	jne    1055fc <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105628:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  10562c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105636:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105639:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105643:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105646:	8b 45 10             	mov    0x10(%ebp),%eax
  105649:	8d 50 01             	lea    0x1(%eax),%edx
  10564c:	89 55 10             	mov    %edx,0x10(%ebp)
  10564f:	0f b6 00             	movzbl (%eax),%eax
  105652:	0f b6 d8             	movzbl %al,%ebx
  105655:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105658:	83 f8 55             	cmp    $0x55,%eax
  10565b:	0f 87 44 03 00 00    	ja     1059a5 <vprintfmt+0x3b3>
  105661:	8b 04 85 00 71 10 00 	mov    0x107100(,%eax,4),%eax
  105668:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10566a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10566e:	eb d6                	jmp    105646 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105670:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105674:	eb d0                	jmp    105646 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105676:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10567d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105680:	89 d0                	mov    %edx,%eax
  105682:	c1 e0 02             	shl    $0x2,%eax
  105685:	01 d0                	add    %edx,%eax
  105687:	01 c0                	add    %eax,%eax
  105689:	01 d8                	add    %ebx,%eax
  10568b:	83 e8 30             	sub    $0x30,%eax
  10568e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105691:	8b 45 10             	mov    0x10(%ebp),%eax
  105694:	0f b6 00             	movzbl (%eax),%eax
  105697:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10569a:	83 fb 2f             	cmp    $0x2f,%ebx
  10569d:	7e 0b                	jle    1056aa <vprintfmt+0xb8>
  10569f:	83 fb 39             	cmp    $0x39,%ebx
  1056a2:	7f 06                	jg     1056aa <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  1056a4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  1056a8:	eb d3                	jmp    10567d <vprintfmt+0x8b>
            goto process_precision;
  1056aa:	eb 33                	jmp    1056df <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  1056ac:	8b 45 14             	mov    0x14(%ebp),%eax
  1056af:	8d 50 04             	lea    0x4(%eax),%edx
  1056b2:	89 55 14             	mov    %edx,0x14(%ebp)
  1056b5:	8b 00                	mov    (%eax),%eax
  1056b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  1056ba:	eb 23                	jmp    1056df <vprintfmt+0xed>

        case '.':
            if (width < 0)
  1056bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056c0:	79 0c                	jns    1056ce <vprintfmt+0xdc>
                width = 0;
  1056c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1056c9:	e9 78 ff ff ff       	jmp    105646 <vprintfmt+0x54>
  1056ce:	e9 73 ff ff ff       	jmp    105646 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  1056d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1056da:	e9 67 ff ff ff       	jmp    105646 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  1056df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1056e3:	79 12                	jns    1056f7 <vprintfmt+0x105>
                width = precision, precision = -1;
  1056e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1056e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1056f2:	e9 4f ff ff ff       	jmp    105646 <vprintfmt+0x54>
  1056f7:	e9 4a ff ff ff       	jmp    105646 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1056fc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  105700:	e9 41 ff ff ff       	jmp    105646 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105705:	8b 45 14             	mov    0x14(%ebp),%eax
  105708:	8d 50 04             	lea    0x4(%eax),%edx
  10570b:	89 55 14             	mov    %edx,0x14(%ebp)
  10570e:	8b 00                	mov    (%eax),%eax
  105710:	8b 55 0c             	mov    0xc(%ebp),%edx
  105713:	89 54 24 04          	mov    %edx,0x4(%esp)
  105717:	89 04 24             	mov    %eax,(%esp)
  10571a:	8b 45 08             	mov    0x8(%ebp),%eax
  10571d:	ff d0                	call   *%eax
            break;
  10571f:	e9 ac 02 00 00       	jmp    1059d0 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105724:	8b 45 14             	mov    0x14(%ebp),%eax
  105727:	8d 50 04             	lea    0x4(%eax),%edx
  10572a:	89 55 14             	mov    %edx,0x14(%ebp)
  10572d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  10572f:	85 db                	test   %ebx,%ebx
  105731:	79 02                	jns    105735 <vprintfmt+0x143>
                err = -err;
  105733:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105735:	83 fb 06             	cmp    $0x6,%ebx
  105738:	7f 0b                	jg     105745 <vprintfmt+0x153>
  10573a:	8b 34 9d c0 70 10 00 	mov    0x1070c0(,%ebx,4),%esi
  105741:	85 f6                	test   %esi,%esi
  105743:	75 23                	jne    105768 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  105745:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105749:	c7 44 24 08 ed 70 10 	movl   $0x1070ed,0x8(%esp)
  105750:	00 
  105751:	8b 45 0c             	mov    0xc(%ebp),%eax
  105754:	89 44 24 04          	mov    %eax,0x4(%esp)
  105758:	8b 45 08             	mov    0x8(%ebp),%eax
  10575b:	89 04 24             	mov    %eax,(%esp)
  10575e:	e8 61 fe ff ff       	call   1055c4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105763:	e9 68 02 00 00       	jmp    1059d0 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105768:	89 74 24 0c          	mov    %esi,0xc(%esp)
  10576c:	c7 44 24 08 f6 70 10 	movl   $0x1070f6,0x8(%esp)
  105773:	00 
  105774:	8b 45 0c             	mov    0xc(%ebp),%eax
  105777:	89 44 24 04          	mov    %eax,0x4(%esp)
  10577b:	8b 45 08             	mov    0x8(%ebp),%eax
  10577e:	89 04 24             	mov    %eax,(%esp)
  105781:	e8 3e fe ff ff       	call   1055c4 <printfmt>
            }
            break;
  105786:	e9 45 02 00 00       	jmp    1059d0 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10578b:	8b 45 14             	mov    0x14(%ebp),%eax
  10578e:	8d 50 04             	lea    0x4(%eax),%edx
  105791:	89 55 14             	mov    %edx,0x14(%ebp)
  105794:	8b 30                	mov    (%eax),%esi
  105796:	85 f6                	test   %esi,%esi
  105798:	75 05                	jne    10579f <vprintfmt+0x1ad>
                p = "(null)";
  10579a:	be f9 70 10 00       	mov    $0x1070f9,%esi
            }
            if (width > 0 && padc != '-') {
  10579f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057a3:	7e 3e                	jle    1057e3 <vprintfmt+0x1f1>
  1057a5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  1057a9:	74 38                	je     1057e3 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057ab:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  1057ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057b5:	89 34 24             	mov    %esi,(%esp)
  1057b8:	e8 15 03 00 00       	call   105ad2 <strnlen>
  1057bd:	29 c3                	sub    %eax,%ebx
  1057bf:	89 d8                	mov    %ebx,%eax
  1057c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1057c4:	eb 17                	jmp    1057dd <vprintfmt+0x1eb>
                    putch(padc, putdat);
  1057c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  1057ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057cd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057d1:	89 04 24             	mov    %eax,(%esp)
  1057d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1057d7:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  1057d9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  1057dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1057e1:	7f e3                	jg     1057c6 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  1057e3:	eb 38                	jmp    10581d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  1057e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1057e9:	74 1f                	je     10580a <vprintfmt+0x218>
  1057eb:	83 fb 1f             	cmp    $0x1f,%ebx
  1057ee:	7e 05                	jle    1057f5 <vprintfmt+0x203>
  1057f0:	83 fb 7e             	cmp    $0x7e,%ebx
  1057f3:	7e 15                	jle    10580a <vprintfmt+0x218>
                    putch('?', putdat);
  1057f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105803:	8b 45 08             	mov    0x8(%ebp),%eax
  105806:	ff d0                	call   *%eax
  105808:	eb 0f                	jmp    105819 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  10580a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10580d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105811:	89 1c 24             	mov    %ebx,(%esp)
  105814:	8b 45 08             	mov    0x8(%ebp),%eax
  105817:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105819:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  10581d:	89 f0                	mov    %esi,%eax
  10581f:	8d 70 01             	lea    0x1(%eax),%esi
  105822:	0f b6 00             	movzbl (%eax),%eax
  105825:	0f be d8             	movsbl %al,%ebx
  105828:	85 db                	test   %ebx,%ebx
  10582a:	74 10                	je     10583c <vprintfmt+0x24a>
  10582c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105830:	78 b3                	js     1057e5 <vprintfmt+0x1f3>
  105832:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105836:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10583a:	79 a9                	jns    1057e5 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  10583c:	eb 17                	jmp    105855 <vprintfmt+0x263>
                putch(' ', putdat);
  10583e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105841:	89 44 24 04          	mov    %eax,0x4(%esp)
  105845:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10584c:	8b 45 08             	mov    0x8(%ebp),%eax
  10584f:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105851:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105859:	7f e3                	jg     10583e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  10585b:	e9 70 01 00 00       	jmp    1059d0 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105860:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105863:	89 44 24 04          	mov    %eax,0x4(%esp)
  105867:	8d 45 14             	lea    0x14(%ebp),%eax
  10586a:	89 04 24             	mov    %eax,(%esp)
  10586d:	e8 0b fd ff ff       	call   10557d <getint>
  105872:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105875:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105878:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10587b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10587e:	85 d2                	test   %edx,%edx
  105880:	79 26                	jns    1058a8 <vprintfmt+0x2b6>
                putch('-', putdat);
  105882:	8b 45 0c             	mov    0xc(%ebp),%eax
  105885:	89 44 24 04          	mov    %eax,0x4(%esp)
  105889:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105890:	8b 45 08             	mov    0x8(%ebp),%eax
  105893:	ff d0                	call   *%eax
                num = -(long long)num;
  105895:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105898:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10589b:	f7 d8                	neg    %eax
  10589d:	83 d2 00             	adc    $0x0,%edx
  1058a0:	f7 da                	neg    %edx
  1058a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  1058a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058af:	e9 a8 00 00 00       	jmp    10595c <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  1058b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bb:	8d 45 14             	lea    0x14(%ebp),%eax
  1058be:	89 04 24             	mov    %eax,(%esp)
  1058c1:	e8 68 fc ff ff       	call   10552e <getuint>
  1058c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  1058cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  1058d3:	e9 84 00 00 00       	jmp    10595c <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  1058d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058df:	8d 45 14             	lea    0x14(%ebp),%eax
  1058e2:	89 04 24             	mov    %eax,(%esp)
  1058e5:	e8 44 fc ff ff       	call   10552e <getuint>
  1058ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  1058f0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  1058f7:	eb 63                	jmp    10595c <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  1058f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058fc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105900:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105907:	8b 45 08             	mov    0x8(%ebp),%eax
  10590a:	ff d0                	call   *%eax
            putch('x', putdat);
  10590c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10590f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105913:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  10591a:	8b 45 08             	mov    0x8(%ebp),%eax
  10591d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10591f:	8b 45 14             	mov    0x14(%ebp),%eax
  105922:	8d 50 04             	lea    0x4(%eax),%edx
  105925:	89 55 14             	mov    %edx,0x14(%ebp)
  105928:	8b 00                	mov    (%eax),%eax
  10592a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10592d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105934:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  10593b:	eb 1f                	jmp    10595c <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  10593d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105940:	89 44 24 04          	mov    %eax,0x4(%esp)
  105944:	8d 45 14             	lea    0x14(%ebp),%eax
  105947:	89 04 24             	mov    %eax,(%esp)
  10594a:	e8 df fb ff ff       	call   10552e <getuint>
  10594f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105952:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105955:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  10595c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105960:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105963:	89 54 24 18          	mov    %edx,0x18(%esp)
  105967:	8b 55 e8             	mov    -0x18(%ebp),%edx
  10596a:	89 54 24 14          	mov    %edx,0x14(%esp)
  10596e:	89 44 24 10          	mov    %eax,0x10(%esp)
  105972:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105975:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105978:	89 44 24 08          	mov    %eax,0x8(%esp)
  10597c:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105980:	8b 45 0c             	mov    0xc(%ebp),%eax
  105983:	89 44 24 04          	mov    %eax,0x4(%esp)
  105987:	8b 45 08             	mov    0x8(%ebp),%eax
  10598a:	89 04 24             	mov    %eax,(%esp)
  10598d:	e8 97 fa ff ff       	call   105429 <printnum>
            break;
  105992:	eb 3c                	jmp    1059d0 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105994:	8b 45 0c             	mov    0xc(%ebp),%eax
  105997:	89 44 24 04          	mov    %eax,0x4(%esp)
  10599b:	89 1c 24             	mov    %ebx,(%esp)
  10599e:	8b 45 08             	mov    0x8(%ebp),%eax
  1059a1:	ff d0                	call   *%eax
            break;
  1059a3:	eb 2b                	jmp    1059d0 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1059a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1059ac:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1059b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1059b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059bc:	eb 04                	jmp    1059c2 <vprintfmt+0x3d0>
  1059be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1059c2:	8b 45 10             	mov    0x10(%ebp),%eax
  1059c5:	83 e8 01             	sub    $0x1,%eax
  1059c8:	0f b6 00             	movzbl (%eax),%eax
  1059cb:	3c 25                	cmp    $0x25,%al
  1059cd:	75 ef                	jne    1059be <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1059cf:	90                   	nop
        }
    }
  1059d0:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1059d1:	e9 3e fc ff ff       	jmp    105614 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1059d6:	83 c4 40             	add    $0x40,%esp
  1059d9:	5b                   	pop    %ebx
  1059da:	5e                   	pop    %esi
  1059db:	5d                   	pop    %ebp
  1059dc:	c3                   	ret    

001059dd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1059dd:	55                   	push   %ebp
  1059de:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1059e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059e3:	8b 40 08             	mov    0x8(%eax),%eax
  1059e6:	8d 50 01             	lea    0x1(%eax),%edx
  1059e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059ec:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1059ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f2:	8b 10                	mov    (%eax),%edx
  1059f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1059f7:	8b 40 04             	mov    0x4(%eax),%eax
  1059fa:	39 c2                	cmp    %eax,%edx
  1059fc:	73 12                	jae    105a10 <sprintputch+0x33>
        *b->buf ++ = ch;
  1059fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a01:	8b 00                	mov    (%eax),%eax
  105a03:	8d 48 01             	lea    0x1(%eax),%ecx
  105a06:	8b 55 0c             	mov    0xc(%ebp),%edx
  105a09:	89 0a                	mov    %ecx,(%edx)
  105a0b:	8b 55 08             	mov    0x8(%ebp),%edx
  105a0e:	88 10                	mov    %dl,(%eax)
    }
}
  105a10:	5d                   	pop    %ebp
  105a11:	c3                   	ret    

00105a12 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105a12:	55                   	push   %ebp
  105a13:	89 e5                	mov    %esp,%ebp
  105a15:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105a18:	8d 45 14             	lea    0x14(%ebp),%eax
  105a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a21:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a25:	8b 45 10             	mov    0x10(%ebp),%eax
  105a28:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a33:	8b 45 08             	mov    0x8(%ebp),%eax
  105a36:	89 04 24             	mov    %eax,(%esp)
  105a39:	e8 08 00 00 00       	call   105a46 <vsnprintf>
  105a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105a44:	c9                   	leave  
  105a45:	c3                   	ret    

00105a46 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105a46:	55                   	push   %ebp
  105a47:	89 e5                	mov    %esp,%ebp
  105a49:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a55:	8d 50 ff             	lea    -0x1(%eax),%edx
  105a58:	8b 45 08             	mov    0x8(%ebp),%eax
  105a5b:	01 d0                	add    %edx,%eax
  105a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105a60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105a67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105a6b:	74 0a                	je     105a77 <vsnprintf+0x31>
  105a6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105a73:	39 c2                	cmp    %eax,%edx
  105a75:	76 07                	jbe    105a7e <vsnprintf+0x38>
        return -E_INVAL;
  105a77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105a7c:	eb 2a                	jmp    105aa8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105a7e:	8b 45 14             	mov    0x14(%ebp),%eax
  105a81:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a85:	8b 45 10             	mov    0x10(%ebp),%eax
  105a88:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a93:	c7 04 24 dd 59 10 00 	movl   $0x1059dd,(%esp)
  105a9a:	e8 53 fb ff ff       	call   1055f2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105aa2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105aa8:	c9                   	leave  
  105aa9:	c3                   	ret    

00105aaa <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105aaa:	55                   	push   %ebp
  105aab:	89 e5                	mov    %esp,%ebp
  105aad:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ab0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105ab7:	eb 04                	jmp    105abd <strlen+0x13>
        cnt ++;
  105ab9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105abd:	8b 45 08             	mov    0x8(%ebp),%eax
  105ac0:	8d 50 01             	lea    0x1(%eax),%edx
  105ac3:	89 55 08             	mov    %edx,0x8(%ebp)
  105ac6:	0f b6 00             	movzbl (%eax),%eax
  105ac9:	84 c0                	test   %al,%al
  105acb:	75 ec                	jne    105ab9 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105ad0:	c9                   	leave  
  105ad1:	c3                   	ret    

00105ad2 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105ad2:	55                   	push   %ebp
  105ad3:	89 e5                	mov    %esp,%ebp
  105ad5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105adf:	eb 04                	jmp    105ae5 <strnlen+0x13>
        cnt ++;
  105ae1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105ae8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105aeb:	73 10                	jae    105afd <strnlen+0x2b>
  105aed:	8b 45 08             	mov    0x8(%ebp),%eax
  105af0:	8d 50 01             	lea    0x1(%eax),%edx
  105af3:	89 55 08             	mov    %edx,0x8(%ebp)
  105af6:	0f b6 00             	movzbl (%eax),%eax
  105af9:	84 c0                	test   %al,%al
  105afb:	75 e4                	jne    105ae1 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105b00:	c9                   	leave  
  105b01:	c3                   	ret    

00105b02 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105b02:	55                   	push   %ebp
  105b03:	89 e5                	mov    %esp,%ebp
  105b05:	57                   	push   %edi
  105b06:	56                   	push   %esi
  105b07:	83 ec 20             	sub    $0x20,%esp
  105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  105b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105b1c:	89 d1                	mov    %edx,%ecx
  105b1e:	89 c2                	mov    %eax,%edx
  105b20:	89 ce                	mov    %ecx,%esi
  105b22:	89 d7                	mov    %edx,%edi
  105b24:	ac                   	lods   %ds:(%esi),%al
  105b25:	aa                   	stos   %al,%es:(%edi)
  105b26:	84 c0                	test   %al,%al
  105b28:	75 fa                	jne    105b24 <strcpy+0x22>
  105b2a:	89 fa                	mov    %edi,%edx
  105b2c:	89 f1                	mov    %esi,%ecx
  105b2e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105b31:	89 55 e8             	mov    %edx,-0x18(%ebp)
  105b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105b3a:	83 c4 20             	add    $0x20,%esp
  105b3d:	5e                   	pop    %esi
  105b3e:	5f                   	pop    %edi
  105b3f:	5d                   	pop    %ebp
  105b40:	c3                   	ret    

00105b41 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105b41:	55                   	push   %ebp
  105b42:	89 e5                	mov    %esp,%ebp
  105b44:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105b47:	8b 45 08             	mov    0x8(%ebp),%eax
  105b4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105b4d:	eb 21                	jmp    105b70 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b52:	0f b6 10             	movzbl (%eax),%edx
  105b55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b58:	88 10                	mov    %dl,(%eax)
  105b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105b5d:	0f b6 00             	movzbl (%eax),%eax
  105b60:	84 c0                	test   %al,%al
  105b62:	74 04                	je     105b68 <strncpy+0x27>
            src ++;
  105b64:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105b68:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105b6c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105b70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105b74:	75 d9                	jne    105b4f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105b76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105b79:	c9                   	leave  
  105b7a:	c3                   	ret    

00105b7b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105b7b:	55                   	push   %ebp
  105b7c:	89 e5                	mov    %esp,%ebp
  105b7e:	57                   	push   %edi
  105b7f:	56                   	push   %esi
  105b80:	83 ec 20             	sub    $0x20,%esp
  105b83:	8b 45 08             	mov    0x8(%ebp),%eax
  105b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b95:	89 d1                	mov    %edx,%ecx
  105b97:	89 c2                	mov    %eax,%edx
  105b99:	89 ce                	mov    %ecx,%esi
  105b9b:	89 d7                	mov    %edx,%edi
  105b9d:	ac                   	lods   %ds:(%esi),%al
  105b9e:	ae                   	scas   %es:(%edi),%al
  105b9f:	75 08                	jne    105ba9 <strcmp+0x2e>
  105ba1:	84 c0                	test   %al,%al
  105ba3:	75 f8                	jne    105b9d <strcmp+0x22>
  105ba5:	31 c0                	xor    %eax,%eax
  105ba7:	eb 04                	jmp    105bad <strcmp+0x32>
  105ba9:	19 c0                	sbb    %eax,%eax
  105bab:	0c 01                	or     $0x1,%al
  105bad:	89 fa                	mov    %edi,%edx
  105baf:	89 f1                	mov    %esi,%ecx
  105bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105bb4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105bb7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105bbd:	83 c4 20             	add    $0x20,%esp
  105bc0:	5e                   	pop    %esi
  105bc1:	5f                   	pop    %edi
  105bc2:	5d                   	pop    %ebp
  105bc3:	c3                   	ret    

00105bc4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105bc4:	55                   	push   %ebp
  105bc5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bc7:	eb 0c                	jmp    105bd5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105bc9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105bcd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105bd1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105bd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bd9:	74 1a                	je     105bf5 <strncmp+0x31>
  105bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bde:	0f b6 00             	movzbl (%eax),%eax
  105be1:	84 c0                	test   %al,%al
  105be3:	74 10                	je     105bf5 <strncmp+0x31>
  105be5:	8b 45 08             	mov    0x8(%ebp),%eax
  105be8:	0f b6 10             	movzbl (%eax),%edx
  105beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bee:	0f b6 00             	movzbl (%eax),%eax
  105bf1:	38 c2                	cmp    %al,%dl
  105bf3:	74 d4                	je     105bc9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105bf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105bf9:	74 18                	je     105c13 <strncmp+0x4f>
  105bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfe:	0f b6 00             	movzbl (%eax),%eax
  105c01:	0f b6 d0             	movzbl %al,%edx
  105c04:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c07:	0f b6 00             	movzbl (%eax),%eax
  105c0a:	0f b6 c0             	movzbl %al,%eax
  105c0d:	29 c2                	sub    %eax,%edx
  105c0f:	89 d0                	mov    %edx,%eax
  105c11:	eb 05                	jmp    105c18 <strncmp+0x54>
  105c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c18:	5d                   	pop    %ebp
  105c19:	c3                   	ret    

00105c1a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105c1a:	55                   	push   %ebp
  105c1b:	89 e5                	mov    %esp,%ebp
  105c1d:	83 ec 04             	sub    $0x4,%esp
  105c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c23:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c26:	eb 14                	jmp    105c3c <strchr+0x22>
        if (*s == c) {
  105c28:	8b 45 08             	mov    0x8(%ebp),%eax
  105c2b:	0f b6 00             	movzbl (%eax),%eax
  105c2e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c31:	75 05                	jne    105c38 <strchr+0x1e>
            return (char *)s;
  105c33:	8b 45 08             	mov    0x8(%ebp),%eax
  105c36:	eb 13                	jmp    105c4b <strchr+0x31>
        }
        s ++;
  105c38:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c3f:	0f b6 00             	movzbl (%eax),%eax
  105c42:	84 c0                	test   %al,%al
  105c44:	75 e2                	jne    105c28 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105c4b:	c9                   	leave  
  105c4c:	c3                   	ret    

00105c4d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105c4d:	55                   	push   %ebp
  105c4e:	89 e5                	mov    %esp,%ebp
  105c50:	83 ec 04             	sub    $0x4,%esp
  105c53:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c56:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105c59:	eb 11                	jmp    105c6c <strfind+0x1f>
        if (*s == c) {
  105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5e:	0f b6 00             	movzbl (%eax),%eax
  105c61:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105c64:	75 02                	jne    105c68 <strfind+0x1b>
            break;
  105c66:	eb 0e                	jmp    105c76 <strfind+0x29>
        }
        s ++;
  105c68:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6f:	0f b6 00             	movzbl (%eax),%eax
  105c72:	84 c0                	test   %al,%al
  105c74:	75 e5                	jne    105c5b <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  105c76:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105c79:	c9                   	leave  
  105c7a:	c3                   	ret    

00105c7b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105c7b:	55                   	push   %ebp
  105c7c:	89 e5                	mov    %esp,%ebp
  105c7e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105c88:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c8f:	eb 04                	jmp    105c95 <strtol+0x1a>
        s ++;
  105c91:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105c95:	8b 45 08             	mov    0x8(%ebp),%eax
  105c98:	0f b6 00             	movzbl (%eax),%eax
  105c9b:	3c 20                	cmp    $0x20,%al
  105c9d:	74 f2                	je     105c91 <strtol+0x16>
  105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca2:	0f b6 00             	movzbl (%eax),%eax
  105ca5:	3c 09                	cmp    $0x9,%al
  105ca7:	74 e8                	je     105c91 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cac:	0f b6 00             	movzbl (%eax),%eax
  105caf:	3c 2b                	cmp    $0x2b,%al
  105cb1:	75 06                	jne    105cb9 <strtol+0x3e>
        s ++;
  105cb3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cb7:	eb 15                	jmp    105cce <strtol+0x53>
    }
    else if (*s == '-') {
  105cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  105cbc:	0f b6 00             	movzbl (%eax),%eax
  105cbf:	3c 2d                	cmp    $0x2d,%al
  105cc1:	75 0b                	jne    105cce <strtol+0x53>
        s ++, neg = 1;
  105cc3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105cc7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105cd2:	74 06                	je     105cda <strtol+0x5f>
  105cd4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105cd8:	75 24                	jne    105cfe <strtol+0x83>
  105cda:	8b 45 08             	mov    0x8(%ebp),%eax
  105cdd:	0f b6 00             	movzbl (%eax),%eax
  105ce0:	3c 30                	cmp    $0x30,%al
  105ce2:	75 1a                	jne    105cfe <strtol+0x83>
  105ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce7:	83 c0 01             	add    $0x1,%eax
  105cea:	0f b6 00             	movzbl (%eax),%eax
  105ced:	3c 78                	cmp    $0x78,%al
  105cef:	75 0d                	jne    105cfe <strtol+0x83>
        s += 2, base = 16;
  105cf1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105cf5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105cfc:	eb 2a                	jmp    105d28 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d02:	75 17                	jne    105d1b <strtol+0xa0>
  105d04:	8b 45 08             	mov    0x8(%ebp),%eax
  105d07:	0f b6 00             	movzbl (%eax),%eax
  105d0a:	3c 30                	cmp    $0x30,%al
  105d0c:	75 0d                	jne    105d1b <strtol+0xa0>
        s ++, base = 8;
  105d0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105d12:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105d19:	eb 0d                	jmp    105d28 <strtol+0xad>
    }
    else if (base == 0) {
  105d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105d1f:	75 07                	jne    105d28 <strtol+0xad>
        base = 10;
  105d21:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105d28:	8b 45 08             	mov    0x8(%ebp),%eax
  105d2b:	0f b6 00             	movzbl (%eax),%eax
  105d2e:	3c 2f                	cmp    $0x2f,%al
  105d30:	7e 1b                	jle    105d4d <strtol+0xd2>
  105d32:	8b 45 08             	mov    0x8(%ebp),%eax
  105d35:	0f b6 00             	movzbl (%eax),%eax
  105d38:	3c 39                	cmp    $0x39,%al
  105d3a:	7f 11                	jg     105d4d <strtol+0xd2>
            dig = *s - '0';
  105d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d3f:	0f b6 00             	movzbl (%eax),%eax
  105d42:	0f be c0             	movsbl %al,%eax
  105d45:	83 e8 30             	sub    $0x30,%eax
  105d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d4b:	eb 48                	jmp    105d95 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105d50:	0f b6 00             	movzbl (%eax),%eax
  105d53:	3c 60                	cmp    $0x60,%al
  105d55:	7e 1b                	jle    105d72 <strtol+0xf7>
  105d57:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5a:	0f b6 00             	movzbl (%eax),%eax
  105d5d:	3c 7a                	cmp    $0x7a,%al
  105d5f:	7f 11                	jg     105d72 <strtol+0xf7>
            dig = *s - 'a' + 10;
  105d61:	8b 45 08             	mov    0x8(%ebp),%eax
  105d64:	0f b6 00             	movzbl (%eax),%eax
  105d67:	0f be c0             	movsbl %al,%eax
  105d6a:	83 e8 57             	sub    $0x57,%eax
  105d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105d70:	eb 23                	jmp    105d95 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  105d72:	8b 45 08             	mov    0x8(%ebp),%eax
  105d75:	0f b6 00             	movzbl (%eax),%eax
  105d78:	3c 40                	cmp    $0x40,%al
  105d7a:	7e 3d                	jle    105db9 <strtol+0x13e>
  105d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d7f:	0f b6 00             	movzbl (%eax),%eax
  105d82:	3c 5a                	cmp    $0x5a,%al
  105d84:	7f 33                	jg     105db9 <strtol+0x13e>
            dig = *s - 'A' + 10;
  105d86:	8b 45 08             	mov    0x8(%ebp),%eax
  105d89:	0f b6 00             	movzbl (%eax),%eax
  105d8c:	0f be c0             	movsbl %al,%eax
  105d8f:	83 e8 37             	sub    $0x37,%eax
  105d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  105d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105d98:	3b 45 10             	cmp    0x10(%ebp),%eax
  105d9b:	7c 02                	jl     105d9f <strtol+0x124>
            break;
  105d9d:	eb 1a                	jmp    105db9 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  105d9f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105da6:	0f af 45 10          	imul   0x10(%ebp),%eax
  105daa:	89 c2                	mov    %eax,%edx
  105dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105daf:	01 d0                	add    %edx,%eax
  105db1:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  105db4:	e9 6f ff ff ff       	jmp    105d28 <strtol+0xad>

    if (endptr) {
  105db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105dbd:	74 08                	je     105dc7 <strtol+0x14c>
        *endptr = (char *) s;
  105dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  105dc5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  105dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  105dcb:	74 07                	je     105dd4 <strtol+0x159>
  105dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105dd0:	f7 d8                	neg    %eax
  105dd2:	eb 03                	jmp    105dd7 <strtol+0x15c>
  105dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105dd7:	c9                   	leave  
  105dd8:	c3                   	ret    

00105dd9 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105dd9:	55                   	push   %ebp
  105dda:	89 e5                	mov    %esp,%ebp
  105ddc:	57                   	push   %edi
  105ddd:	83 ec 24             	sub    $0x24,%esp
  105de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105de3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  105de6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105dea:	8b 55 08             	mov    0x8(%ebp),%edx
  105ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105df0:	88 45 f7             	mov    %al,-0x9(%ebp)
  105df3:	8b 45 10             	mov    0x10(%ebp),%eax
  105df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105df9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105dfc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105e00:	8b 55 f8             	mov    -0x8(%ebp),%edx
  105e03:	89 d7                	mov    %edx,%edi
  105e05:	f3 aa                	rep stos %al,%es:(%edi)
  105e07:	89 fa                	mov    %edi,%edx
  105e09:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105e0c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  105e12:	83 c4 24             	add    $0x24,%esp
  105e15:	5f                   	pop    %edi
  105e16:	5d                   	pop    %ebp
  105e17:	c3                   	ret    

00105e18 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105e18:	55                   	push   %ebp
  105e19:	89 e5                	mov    %esp,%ebp
  105e1b:	57                   	push   %edi
  105e1c:	56                   	push   %esi
  105e1d:	53                   	push   %ebx
  105e1e:	83 ec 30             	sub    $0x30,%esp
  105e21:	8b 45 08             	mov    0x8(%ebp),%eax
  105e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e27:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105e2d:	8b 45 10             	mov    0x10(%ebp),%eax
  105e30:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  105e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105e39:	73 42                	jae    105e7d <memmove+0x65>
  105e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e44:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105e47:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e4a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105e50:	c1 e8 02             	shr    $0x2,%eax
  105e53:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105e55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105e5b:	89 d7                	mov    %edx,%edi
  105e5d:	89 c6                	mov    %eax,%esi
  105e5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105e61:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105e64:	83 e1 03             	and    $0x3,%ecx
  105e67:	74 02                	je     105e6b <memmove+0x53>
  105e69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105e6b:	89 f0                	mov    %esi,%eax
  105e6d:	89 fa                	mov    %edi,%edx
  105e6f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  105e72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  105e75:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105e7b:	eb 36                	jmp    105eb3 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  105e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e80:	8d 50 ff             	lea    -0x1(%eax),%edx
  105e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e86:	01 c2                	add    %eax,%edx
  105e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e8b:	8d 48 ff             	lea    -0x1(%eax),%ecx
  105e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e91:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  105e94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105e97:	89 c1                	mov    %eax,%ecx
  105e99:	89 d8                	mov    %ebx,%eax
  105e9b:	89 d6                	mov    %edx,%esi
  105e9d:	89 c7                	mov    %eax,%edi
  105e9f:	fd                   	std    
  105ea0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ea2:	fc                   	cld    
  105ea3:	89 f8                	mov    %edi,%eax
  105ea5:	89 f2                	mov    %esi,%edx
  105ea7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  105eaa:	89 55 c8             	mov    %edx,-0x38(%ebp)
  105ead:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  105eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  105eb3:	83 c4 30             	add    $0x30,%esp
  105eb6:	5b                   	pop    %ebx
  105eb7:	5e                   	pop    %esi
  105eb8:	5f                   	pop    %edi
  105eb9:	5d                   	pop    %ebp
  105eba:	c3                   	ret    

00105ebb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  105ebb:	55                   	push   %ebp
  105ebc:	89 e5                	mov    %esp,%ebp
  105ebe:	57                   	push   %edi
  105ebf:	56                   	push   %esi
  105ec0:	83 ec 20             	sub    $0x20,%esp
  105ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  105ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105ecf:	8b 45 10             	mov    0x10(%ebp),%eax
  105ed2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ed8:	c1 e8 02             	shr    $0x2,%eax
  105edb:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  105edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ee3:	89 d7                	mov    %edx,%edi
  105ee5:	89 c6                	mov    %eax,%esi
  105ee7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105ee9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105eec:	83 e1 03             	and    $0x3,%ecx
  105eef:	74 02                	je     105ef3 <memcpy+0x38>
  105ef1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105ef3:	89 f0                	mov    %esi,%eax
  105ef5:	89 fa                	mov    %edi,%edx
  105ef7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105efa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105efd:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  105f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  105f03:	83 c4 20             	add    $0x20,%esp
  105f06:	5e                   	pop    %esi
  105f07:	5f                   	pop    %edi
  105f08:	5d                   	pop    %ebp
  105f09:	c3                   	ret    

00105f0a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105f0a:	55                   	push   %ebp
  105f0b:	89 e5                	mov    %esp,%ebp
  105f0d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  105f10:	8b 45 08             	mov    0x8(%ebp),%eax
  105f13:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105f16:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f19:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105f1c:	eb 30                	jmp    105f4e <memcmp+0x44>
        if (*s1 != *s2) {
  105f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f21:	0f b6 10             	movzbl (%eax),%edx
  105f24:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f27:	0f b6 00             	movzbl (%eax),%eax
  105f2a:	38 c2                	cmp    %al,%dl
  105f2c:	74 18                	je     105f46 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105f31:	0f b6 00             	movzbl (%eax),%eax
  105f34:	0f b6 d0             	movzbl %al,%edx
  105f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105f3a:	0f b6 00             	movzbl (%eax),%eax
  105f3d:	0f b6 c0             	movzbl %al,%eax
  105f40:	29 c2                	sub    %eax,%edx
  105f42:	89 d0                	mov    %edx,%eax
  105f44:	eb 1a                	jmp    105f60 <memcmp+0x56>
        }
        s1 ++, s2 ++;
  105f46:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105f4a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  105f4e:	8b 45 10             	mov    0x10(%ebp),%eax
  105f51:	8d 50 ff             	lea    -0x1(%eax),%edx
  105f54:	89 55 10             	mov    %edx,0x10(%ebp)
  105f57:	85 c0                	test   %eax,%eax
  105f59:	75 c3                	jne    105f1e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  105f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f60:	c9                   	leave  
  105f61:	c3                   	ret    
