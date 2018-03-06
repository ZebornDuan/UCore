
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 70 11 00 	lgdtl  0x117018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 02 00 00 00       	call   c010002a <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>

c010002a <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002a:	55                   	push   %ebp
c010002b:	89 e5                	mov    %esp,%ebp
c010002d:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100030:	ba 68 89 11 c0       	mov    $0xc0118968,%edx
c0100035:	b8 36 7a 11 c0       	mov    $0xc0117a36,%eax
c010003a:	29 c2                	sub    %eax,%edx
c010003c:	89 d0                	mov    %edx,%eax
c010003e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100042:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100049:	00 
c010004a:	c7 04 24 36 7a 11 c0 	movl   $0xc0117a36,(%esp)
c0100051:	e8 83 5d 00 00       	call   c0105dd9 <memset>

    cons_init();                // init the console
c0100056:	e8 78 15 00 00       	call   c01015d3 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005b:	c7 45 f4 80 5f 10 c0 	movl   $0xc0105f80,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100062:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100065:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100069:	c7 04 24 9c 5f 10 c0 	movl   $0xc0105f9c,(%esp)
c0100070:	e8 c7 02 00 00       	call   c010033c <cprintf>

    print_kerninfo();
c0100075:	e8 f6 07 00 00       	call   c0100870 <print_kerninfo>

    grade_backtrace();
c010007a:	e8 86 00 00 00       	call   c0100105 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010007f:	e8 4b 42 00 00       	call   c01042cf <pmm_init>

    pic_init();                 // init interrupt controller
c0100084:	e8 b3 16 00 00       	call   c010173c <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100089:	e8 05 18 00 00       	call   c0101893 <idt_init>

    clock_init();               // init clock interrupt
c010008e:	e8 f6 0c 00 00       	call   c0100d89 <clock_init>
    intr_enable();              // enable irq interrupt
c0100093:	e8 12 16 00 00       	call   c01016aa <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c0100098:	eb fe                	jmp    c0100098 <kern_init+0x6e>

c010009a <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009a:	55                   	push   %ebp
c010009b:	89 e5                	mov    %esp,%ebp
c010009d:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000a7:	00 
c01000a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000af:	00 
c01000b0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000b7:	e8 ff 0b 00 00       	call   c0100cbb <mon_backtrace>
}
c01000bc:	c9                   	leave  
c01000bd:	c3                   	ret    

c01000be <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000be:	55                   	push   %ebp
c01000bf:	89 e5                	mov    %esp,%ebp
c01000c1:	53                   	push   %ebx
c01000c2:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c5:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000c8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cb:	8d 55 08             	lea    0x8(%ebp),%edx
c01000ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d5:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000d9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000dd:	89 04 24             	mov    %eax,(%esp)
c01000e0:	e8 b5 ff ff ff       	call   c010009a <grade_backtrace2>
}
c01000e5:	83 c4 14             	add    $0x14,%esp
c01000e8:	5b                   	pop    %ebx
c01000e9:	5d                   	pop    %ebp
c01000ea:	c3                   	ret    

c01000eb <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000eb:	55                   	push   %ebp
c01000ec:	89 e5                	mov    %esp,%ebp
c01000ee:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01000fb:	89 04 24             	mov    %eax,(%esp)
c01000fe:	e8 bb ff ff ff       	call   c01000be <grade_backtrace1>
}
c0100103:	c9                   	leave  
c0100104:	c3                   	ret    

c0100105 <grade_backtrace>:

void
grade_backtrace(void) {
c0100105:	55                   	push   %ebp
c0100106:	89 e5                	mov    %esp,%ebp
c0100108:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010b:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c0100110:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100117:	ff 
c0100118:	89 44 24 04          	mov    %eax,0x4(%esp)
c010011c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100123:	e8 c3 ff ff ff       	call   c01000eb <grade_backtrace0>
}
c0100128:	c9                   	leave  
c0100129:	c3                   	ret    

c010012a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012a:	55                   	push   %ebp
c010012b:	89 e5                	mov    %esp,%ebp
c010012d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100130:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100133:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100136:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100139:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100140:	0f b7 c0             	movzwl %ax,%eax
c0100143:	83 e0 03             	and    $0x3,%eax
c0100146:	89 c2                	mov    %eax,%edx
c0100148:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010014d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100151:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100155:	c7 04 24 a1 5f 10 c0 	movl   $0xc0105fa1,(%esp)
c010015c:	e8 db 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100161:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100165:	0f b7 d0             	movzwl %ax,%edx
c0100168:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010016d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100171:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100175:	c7 04 24 af 5f 10 c0 	movl   $0xc0105faf,(%esp)
c010017c:	e8 bb 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100181:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100185:	0f b7 d0             	movzwl %ax,%edx
c0100188:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c010018d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100191:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100195:	c7 04 24 bd 5f 10 c0 	movl   $0xc0105fbd,(%esp)
c010019c:	e8 9b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a5:	0f b7 d0             	movzwl %ax,%edx
c01001a8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001ad:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b5:	c7 04 24 cb 5f 10 c0 	movl   $0xc0105fcb,(%esp)
c01001bc:	e8 7b 01 00 00       	call   c010033c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c1:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c5:	0f b7 d0             	movzwl %ax,%edx
c01001c8:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001cd:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d5:	c7 04 24 d9 5f 10 c0 	movl   $0xc0105fd9,(%esp)
c01001dc:	e8 5b 01 00 00       	call   c010033c <cprintf>
    round ++;
c01001e1:	a1 40 7a 11 c0       	mov    0xc0117a40,%eax
c01001e6:	83 c0 01             	add    $0x1,%eax
c01001e9:	a3 40 7a 11 c0       	mov    %eax,0xc0117a40
}
c01001ee:	c9                   	leave  
c01001ef:	c3                   	ret    

c01001f0 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f0:	55                   	push   %ebp
c01001f1:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f3:	5d                   	pop    %ebp
c01001f4:	c3                   	ret    

c01001f5 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f5:	55                   	push   %ebp
c01001f6:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001f8:	5d                   	pop    %ebp
c01001f9:	c3                   	ret    

c01001fa <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fa:	55                   	push   %ebp
c01001fb:	89 e5                	mov    %esp,%ebp
c01001fd:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100200:	e8 25 ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100205:	c7 04 24 e8 5f 10 c0 	movl   $0xc0105fe8,(%esp)
c010020c:	e8 2b 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_user();
c0100211:	e8 da ff ff ff       	call   c01001f0 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100216:	e8 0f ff ff ff       	call   c010012a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021b:	c7 04 24 08 60 10 c0 	movl   $0xc0106008,(%esp)
c0100222:	e8 15 01 00 00       	call   c010033c <cprintf>
    lab1_switch_to_kernel();
c0100227:	e8 c9 ff ff ff       	call   c01001f5 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010022c:	e8 f9 fe ff ff       	call   c010012a <lab1_print_cur_status>
}
c0100231:	c9                   	leave  
c0100232:	c3                   	ret    

c0100233 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100233:	55                   	push   %ebp
c0100234:	89 e5                	mov    %esp,%ebp
c0100236:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100239:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010023d:	74 13                	je     c0100252 <readline+0x1f>
        cprintf("%s", prompt);
c010023f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100242:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100246:	c7 04 24 27 60 10 c0 	movl   $0xc0106027,(%esp)
c010024d:	e8 ea 00 00 00       	call   c010033c <cprintf>
    }
    int i = 0, c;
c0100252:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c0100259:	e8 66 01 00 00       	call   c01003c4 <getchar>
c010025e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100261:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100265:	79 07                	jns    c010026e <readline+0x3b>
            return NULL;
c0100267:	b8 00 00 00 00       	mov    $0x0,%eax
c010026c:	eb 79                	jmp    c01002e7 <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010026e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100272:	7e 28                	jle    c010029c <readline+0x69>
c0100274:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010027b:	7f 1f                	jg     c010029c <readline+0x69>
            cputchar(c);
c010027d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100280:	89 04 24             	mov    %eax,(%esp)
c0100283:	e8 da 00 00 00       	call   c0100362 <cputchar>
            buf[i ++] = c;
c0100288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010028b:	8d 50 01             	lea    0x1(%eax),%edx
c010028e:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100291:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100294:	88 90 60 7a 11 c0    	mov    %dl,-0x3fee85a0(%eax)
c010029a:	eb 46                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
c010029c:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a0:	75 17                	jne    c01002b9 <readline+0x86>
c01002a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002a6:	7e 11                	jle    c01002b9 <readline+0x86>
            cputchar(c);
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	89 04 24             	mov    %eax,(%esp)
c01002ae:	e8 af 00 00 00       	call   c0100362 <cputchar>
            i --;
c01002b3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002b7:	eb 29                	jmp    c01002e2 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
c01002b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002bd:	74 06                	je     c01002c5 <readline+0x92>
c01002bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002c3:	75 1d                	jne    c01002e2 <readline+0xaf>
            cputchar(c);
c01002c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c8:	89 04 24             	mov    %eax,(%esp)
c01002cb:	e8 92 00 00 00       	call   c0100362 <cputchar>
            buf[i] = '\0';
c01002d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002d3:	05 60 7a 11 c0       	add    $0xc0117a60,%eax
c01002d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002db:	b8 60 7a 11 c0       	mov    $0xc0117a60,%eax
c01002e0:	eb 05                	jmp    c01002e7 <readline+0xb4>
        }
    }
c01002e2:	e9 72 ff ff ff       	jmp    c0100259 <readline+0x26>
}
c01002e7:	c9                   	leave  
c01002e8:	c3                   	ret    

c01002e9 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002e9:	55                   	push   %ebp
c01002ea:	89 e5                	mov    %esp,%ebp
c01002ec:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f2:	89 04 24             	mov    %eax,(%esp)
c01002f5:	e8 05 13 00 00       	call   c01015ff <cons_putc>
    (*cnt) ++;
c01002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01002fd:	8b 00                	mov    (%eax),%eax
c01002ff:	8d 50 01             	lea    0x1(%eax),%edx
c0100302:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100305:	89 10                	mov    %edx,(%eax)
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    

c0100309 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100309:	55                   	push   %ebp
c010030a:	89 e5                	mov    %esp,%ebp
c010030c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010030f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100316:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100319:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010031d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100320:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100324:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010032b:	c7 04 24 e9 02 10 c0 	movl   $0xc01002e9,(%esp)
c0100332:	e8 bb 52 00 00       	call   c01055f2 <vprintfmt>
    return cnt;
c0100337:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010033a:	c9                   	leave  
c010033b:	c3                   	ret    

c010033c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010033c:	55                   	push   %ebp
c010033d:	89 e5                	mov    %esp,%ebp
c010033f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100342:	8d 45 0c             	lea    0xc(%ebp),%eax
c0100345:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c0100348:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010034b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100352:	89 04 24             	mov    %eax,(%esp)
c0100355:	e8 af ff ff ff       	call   c0100309 <vcprintf>
c010035a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010035d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100360:	c9                   	leave  
c0100361:	c3                   	ret    

c0100362 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100362:	55                   	push   %ebp
c0100363:	89 e5                	mov    %esp,%ebp
c0100365:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100368:	8b 45 08             	mov    0x8(%ebp),%eax
c010036b:	89 04 24             	mov    %eax,(%esp)
c010036e:	e8 8c 12 00 00       	call   c01015ff <cons_putc>
}
c0100373:	c9                   	leave  
c0100374:	c3                   	ret    

c0100375 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100375:	55                   	push   %ebp
c0100376:	89 e5                	mov    %esp,%ebp
c0100378:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010037b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c0100382:	eb 13                	jmp    c0100397 <cputs+0x22>
        cputch(c, &cnt);
c0100384:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100388:	8d 55 f0             	lea    -0x10(%ebp),%edx
c010038b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010038f:	89 04 24             	mov    %eax,(%esp)
c0100392:	e8 52 ff ff ff       	call   c01002e9 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c0100397:	8b 45 08             	mov    0x8(%ebp),%eax
c010039a:	8d 50 01             	lea    0x1(%eax),%edx
c010039d:	89 55 08             	mov    %edx,0x8(%ebp)
c01003a0:	0f b6 00             	movzbl (%eax),%eax
c01003a3:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003a6:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003aa:	75 d8                	jne    c0100384 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003ac:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003af:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003b3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ba:	e8 2a ff ff ff       	call   c01002e9 <cputch>
    return cnt;
c01003bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003c2:	c9                   	leave  
c01003c3:	c3                   	ret    

c01003c4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003c4:	55                   	push   %ebp
c01003c5:	89 e5                	mov    %esp,%ebp
c01003c7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ca:	e8 6c 12 00 00       	call   c010163b <cons_getc>
c01003cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003d6:	74 f2                	je     c01003ca <getchar+0x6>
        /* do nothing */;
    return c;
c01003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003db:	c9                   	leave  
c01003dc:	c3                   	ret    

c01003dd <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003dd:	55                   	push   %ebp
c01003de:	89 e5                	mov    %esp,%ebp
c01003e0:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003e6:	8b 00                	mov    (%eax),%eax
c01003e8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01003ee:	8b 00                	mov    (%eax),%eax
c01003f0:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01003f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01003fa:	e9 d2 00 00 00       	jmp    c01004d1 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
c01003ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100402:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100405:	01 d0                	add    %edx,%eax
c0100407:	89 c2                	mov    %eax,%edx
c0100409:	c1 ea 1f             	shr    $0x1f,%edx
c010040c:	01 d0                	add    %edx,%eax
c010040e:	d1 f8                	sar    %eax
c0100410:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100413:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100416:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100419:	eb 04                	jmp    c010041f <stab_binsearch+0x42>
            m --;
c010041b:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010041f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100422:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100425:	7c 1f                	jl     c0100446 <stab_binsearch+0x69>
c0100427:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010042a:	89 d0                	mov    %edx,%eax
c010042c:	01 c0                	add    %eax,%eax
c010042e:	01 d0                	add    %edx,%eax
c0100430:	c1 e0 02             	shl    $0x2,%eax
c0100433:	89 c2                	mov    %eax,%edx
c0100435:	8b 45 08             	mov    0x8(%ebp),%eax
c0100438:	01 d0                	add    %edx,%eax
c010043a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010043e:	0f b6 c0             	movzbl %al,%eax
c0100441:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100444:	75 d5                	jne    c010041b <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100446:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100449:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010044c:	7d 0b                	jge    c0100459 <stab_binsearch+0x7c>
            l = true_m + 1;
c010044e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100451:	83 c0 01             	add    $0x1,%eax
c0100454:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100457:	eb 78                	jmp    c01004d1 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
c0100459:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100460:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100463:	89 d0                	mov    %edx,%eax
c0100465:	01 c0                	add    %eax,%eax
c0100467:	01 d0                	add    %edx,%eax
c0100469:	c1 e0 02             	shl    $0x2,%eax
c010046c:	89 c2                	mov    %eax,%edx
c010046e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100471:	01 d0                	add    %edx,%eax
c0100473:	8b 40 08             	mov    0x8(%eax),%eax
c0100476:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100479:	73 13                	jae    c010048e <stab_binsearch+0xb1>
            *region_left = m;
c010047b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010047e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100481:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c0100483:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100486:	83 c0 01             	add    $0x1,%eax
c0100489:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010048c:	eb 43                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
c010048e:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100491:	89 d0                	mov    %edx,%eax
c0100493:	01 c0                	add    %eax,%eax
c0100495:	01 d0                	add    %edx,%eax
c0100497:	c1 e0 02             	shl    $0x2,%eax
c010049a:	89 c2                	mov    %eax,%edx
c010049c:	8b 45 08             	mov    0x8(%ebp),%eax
c010049f:	01 d0                	add    %edx,%eax
c01004a1:	8b 40 08             	mov    0x8(%eax),%eax
c01004a4:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004a7:	76 16                	jbe    c01004bf <stab_binsearch+0xe2>
            *region_right = m - 1;
c01004a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ac:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004af:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b2:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b7:	83 e8 01             	sub    $0x1,%eax
c01004ba:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004bd:	eb 12                	jmp    c01004d1 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c2:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004c5:	89 10                	mov    %edx,(%eax)
            l = m;
c01004c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004cd:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004d4:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004d7:	0f 8e 22 ff ff ff    	jle    c01003ff <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e1:	75 0f                	jne    c01004f2 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
c01004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e6:	8b 00                	mov    (%eax),%eax
c01004e8:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01004ee:	89 10                	mov    %edx,(%eax)
c01004f0:	eb 3f                	jmp    c0100531 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	8b 00                	mov    (%eax),%eax
c01004f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01004fa:	eb 04                	jmp    c0100500 <stab_binsearch+0x123>
c01004fc:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100500:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100503:	8b 00                	mov    (%eax),%eax
c0100505:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100508:	7d 1f                	jge    c0100529 <stab_binsearch+0x14c>
c010050a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010050d:	89 d0                	mov    %edx,%eax
c010050f:	01 c0                	add    %eax,%eax
c0100511:	01 d0                	add    %edx,%eax
c0100513:	c1 e0 02             	shl    $0x2,%eax
c0100516:	89 c2                	mov    %eax,%edx
c0100518:	8b 45 08             	mov    0x8(%ebp),%eax
c010051b:	01 d0                	add    %edx,%eax
c010051d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100521:	0f b6 c0             	movzbl %al,%eax
c0100524:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100527:	75 d3                	jne    c01004fc <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
c0100529:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052f:	89 10                	mov    %edx,(%eax)
    }
}
c0100531:	c9                   	leave  
c0100532:	c3                   	ret    

c0100533 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100533:	55                   	push   %ebp
c0100534:	89 e5                	mov    %esp,%ebp
c0100536:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100539:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053c:	c7 00 2c 60 10 c0    	movl   $0xc010602c,(%eax)
    info->eip_line = 0;
c0100542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100545:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010054c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010054f:	c7 40 08 2c 60 10 c0 	movl   $0xc010602c,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	8b 55 08             	mov    0x8(%ebp),%edx
c0100566:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100569:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100573:	c7 45 f4 58 72 10 c0 	movl   $0xc0107258,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057a:	c7 45 f0 48 1e 11 c0 	movl   $0xc0111e48,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100581:	c7 45 ec 49 1e 11 c0 	movl   $0xc0111e49,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c0100588:	c7 45 e8 a2 48 11 c0 	movl   $0xc01148a2,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c010058f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100592:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100595:	76 0d                	jbe    c01005a4 <debuginfo_eip+0x71>
c0100597:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059a:	83 e8 01             	sub    $0x1,%eax
c010059d:	0f b6 00             	movzbl (%eax),%eax
c01005a0:	84 c0                	test   %al,%al
c01005a2:	74 0a                	je     c01005ae <debuginfo_eip+0x7b>
        return -1;
c01005a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005a9:	e9 c0 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ae:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bb:	29 c2                	sub    %eax,%edx
c01005bd:	89 d0                	mov    %edx,%eax
c01005bf:	c1 f8 02             	sar    $0x2,%eax
c01005c2:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005c8:	83 e8 01             	sub    $0x1,%eax
c01005cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d1:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005d5:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005dc:	00 
c01005dd:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005e4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005ee:	89 04 24             	mov    %eax,(%esp)
c01005f1:	e8 e7 fd ff ff       	call   c01003dd <stab_binsearch>
    if (lfile == 0)
c01005f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005f9:	85 c0                	test   %eax,%eax
c01005fb:	75 0a                	jne    c0100607 <debuginfo_eip+0xd4>
        return -1;
c01005fd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100602:	e9 67 02 00 00       	jmp    c010086e <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100607:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060a:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010060d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100610:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100613:	8b 45 08             	mov    0x8(%ebp),%eax
c0100616:	89 44 24 10          	mov    %eax,0x10(%esp)
c010061a:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100621:	00 
c0100622:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100625:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100629:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010062c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100630:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100633:	89 04 24             	mov    %eax,(%esp)
c0100636:	e8 a2 fd ff ff       	call   c01003dd <stab_binsearch>

    if (lfun <= rfun) {
c010063b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010063e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100641:	39 c2                	cmp    %eax,%edx
c0100643:	7f 7c                	jg     c01006c1 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100645:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100648:	89 c2                	mov    %eax,%edx
c010064a:	89 d0                	mov    %edx,%eax
c010064c:	01 c0                	add    %eax,%eax
c010064e:	01 d0                	add    %edx,%eax
c0100650:	c1 e0 02             	shl    $0x2,%eax
c0100653:	89 c2                	mov    %eax,%edx
c0100655:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100658:	01 d0                	add    %edx,%eax
c010065a:	8b 10                	mov    (%eax),%edx
c010065c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010065f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100662:	29 c1                	sub    %eax,%ecx
c0100664:	89 c8                	mov    %ecx,%eax
c0100666:	39 c2                	cmp    %eax,%edx
c0100668:	73 22                	jae    c010068c <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010066d:	89 c2                	mov    %eax,%edx
c010066f:	89 d0                	mov    %edx,%eax
c0100671:	01 c0                	add    %eax,%eax
c0100673:	01 d0                	add    %edx,%eax
c0100675:	c1 e0 02             	shl    $0x2,%eax
c0100678:	89 c2                	mov    %eax,%edx
c010067a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010067d:	01 d0                	add    %edx,%eax
c010067f:	8b 10                	mov    (%eax),%edx
c0100681:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100684:	01 c2                	add    %eax,%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	89 c2                	mov    %eax,%edx
c010069c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010069f:	01 d0                	add    %edx,%eax
c01006a1:	8b 50 08             	mov    0x8(%eax),%edx
c01006a4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a7:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006aa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ad:	8b 40 10             	mov    0x10(%eax),%eax
c01006b0:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006b3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b6:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bf:	eb 15                	jmp    c01006d6 <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006c1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c4:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c7:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006cd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d9:	8b 40 08             	mov    0x8(%eax),%eax
c01006dc:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006e3:	00 
c01006e4:	89 04 24             	mov    %eax,(%esp)
c01006e7:	e8 61 55 00 00       	call   c0105c4d <strfind>
c01006ec:	89 c2                	mov    %eax,%edx
c01006ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f1:	8b 40 08             	mov    0x8(%eax),%eax
c01006f4:	29 c2                	sub    %eax,%edx
c01006f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f9:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01006ff:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100703:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010070a:	00 
c010070b:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100712:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100715:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100719:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010071c:	89 04 24             	mov    %eax,(%esp)
c010071f:	e8 b9 fc ff ff       	call   c01003dd <stab_binsearch>
    if (lline <= rline) {
c0100724:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100727:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072a:	39 c2                	cmp    %eax,%edx
c010072c:	7f 24                	jg     c0100752 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
c010072e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100731:	89 c2                	mov    %eax,%edx
c0100733:	89 d0                	mov    %edx,%eax
c0100735:	01 c0                	add    %eax,%eax
c0100737:	01 d0                	add    %edx,%eax
c0100739:	c1 e0 02             	shl    $0x2,%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100741:	01 d0                	add    %edx,%eax
c0100743:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100747:	0f b7 d0             	movzwl %ax,%edx
c010074a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010074d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100750:	eb 13                	jmp    c0100765 <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100752:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100757:	e9 12 01 00 00       	jmp    c010086e <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010075c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010075f:	83 e8 01             	sub    $0x1,%eax
c0100762:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100765:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100768:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010076b:	39 c2                	cmp    %eax,%edx
c010076d:	7c 56                	jl     c01007c5 <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
c010076f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100772:	89 c2                	mov    %eax,%edx
c0100774:	89 d0                	mov    %edx,%eax
c0100776:	01 c0                	add    %eax,%eax
c0100778:	01 d0                	add    %edx,%eax
c010077a:	c1 e0 02             	shl    $0x2,%eax
c010077d:	89 c2                	mov    %eax,%edx
c010077f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100782:	01 d0                	add    %edx,%eax
c0100784:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100788:	3c 84                	cmp    $0x84,%al
c010078a:	74 39                	je     c01007c5 <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c010078c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010078f:	89 c2                	mov    %eax,%edx
c0100791:	89 d0                	mov    %edx,%eax
c0100793:	01 c0                	add    %eax,%eax
c0100795:	01 d0                	add    %edx,%eax
c0100797:	c1 e0 02             	shl    $0x2,%eax
c010079a:	89 c2                	mov    %eax,%edx
c010079c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010079f:	01 d0                	add    %edx,%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 b3                	jne    c010075c <debuginfo_eip+0x229>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	89 c2                	mov    %eax,%edx
c01007b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007bc:	01 d0                	add    %edx,%eax
c01007be:	8b 40 08             	mov    0x8(%eax),%eax
c01007c1:	85 c0                	test   %eax,%eax
c01007c3:	74 97                	je     c010075c <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c5:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cb:	39 c2                	cmp    %eax,%edx
c01007cd:	7c 46                	jl     c0100815 <debuginfo_eip+0x2e2>
c01007cf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d2:	89 c2                	mov    %eax,%edx
c01007d4:	89 d0                	mov    %edx,%eax
c01007d6:	01 c0                	add    %eax,%eax
c01007d8:	01 d0                	add    %edx,%eax
c01007da:	c1 e0 02             	shl    $0x2,%eax
c01007dd:	89 c2                	mov    %eax,%edx
c01007df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007e2:	01 d0                	add    %edx,%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	29 c1                	sub    %eax,%ecx
c01007ee:	89 c8                	mov    %ecx,%eax
c01007f0:	39 c2                	cmp    %eax,%edx
c01007f2:	73 21                	jae    c0100815 <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f7:	89 c2                	mov    %eax,%edx
c01007f9:	89 d0                	mov    %edx,%eax
c01007fb:	01 c0                	add    %eax,%eax
c01007fd:	01 d0                	add    %edx,%eax
c01007ff:	c1 e0 02             	shl    $0x2,%eax
c0100802:	89 c2                	mov    %eax,%edx
c0100804:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100807:	01 d0                	add    %edx,%eax
c0100809:	8b 10                	mov    (%eax),%edx
c010080b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010080e:	01 c2                	add    %eax,%edx
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100815:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100818:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010081b:	39 c2                	cmp    %eax,%edx
c010081d:	7d 4a                	jge    c0100869 <debuginfo_eip+0x336>
        for (lline = lfun + 1;
c010081f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100828:	eb 18                	jmp    c0100842 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c010082a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082d:	8b 40 14             	mov    0x14(%eax),%eax
c0100830:	8d 50 01             	lea    0x1(%eax),%edx
c0100833:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100836:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100839:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083c:	83 c0 01             	add    $0x1,%eax
c010083f:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100845:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100848:	39 c2                	cmp    %eax,%edx
c010084a:	7d 1d                	jge    c0100869 <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084f:	89 c2                	mov    %eax,%edx
c0100851:	89 d0                	mov    %edx,%eax
c0100853:	01 c0                	add    %eax,%eax
c0100855:	01 d0                	add    %edx,%eax
c0100857:	c1 e0 02             	shl    $0x2,%eax
c010085a:	89 c2                	mov    %eax,%edx
c010085c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010085f:	01 d0                	add    %edx,%eax
c0100861:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100865:	3c a0                	cmp    $0xa0,%al
c0100867:	74 c1                	je     c010082a <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100869:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010086e:	c9                   	leave  
c010086f:	c3                   	ret    

c0100870 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100870:	55                   	push   %ebp
c0100871:	89 e5                	mov    %esp,%ebp
c0100873:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100876:	c7 04 24 36 60 10 c0 	movl   $0xc0106036,(%esp)
c010087d:	e8 ba fa ff ff       	call   c010033c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100882:	c7 44 24 04 2a 00 10 	movl   $0xc010002a,0x4(%esp)
c0100889:	c0 
c010088a:	c7 04 24 4f 60 10 c0 	movl   $0xc010604f,(%esp)
c0100891:	e8 a6 fa ff ff       	call   c010033c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100896:	c7 44 24 04 62 5f 10 	movl   $0xc0105f62,0x4(%esp)
c010089d:	c0 
c010089e:	c7 04 24 67 60 10 c0 	movl   $0xc0106067,(%esp)
c01008a5:	e8 92 fa ff ff       	call   c010033c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008aa:	c7 44 24 04 36 7a 11 	movl   $0xc0117a36,0x4(%esp)
c01008b1:	c0 
c01008b2:	c7 04 24 7f 60 10 c0 	movl   $0xc010607f,(%esp)
c01008b9:	e8 7e fa ff ff       	call   c010033c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008be:	c7 44 24 04 68 89 11 	movl   $0xc0118968,0x4(%esp)
c01008c5:	c0 
c01008c6:	c7 04 24 97 60 10 c0 	movl   $0xc0106097,(%esp)
c01008cd:	e8 6a fa ff ff       	call   c010033c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d2:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c01008d7:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008dd:	b8 2a 00 10 c0       	mov    $0xc010002a,%eax
c01008e2:	29 c2                	sub    %eax,%edx
c01008e4:	89 d0                	mov    %edx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 b0 60 10 c0 	movl   $0xc01060b0,(%esp)
c01008ff:	e8 38 fa ff ff       	call   c010033c <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 12 fc ff ff       	call   c0100533 <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 da 60 10 c0 	movl   $0xc01060da,(%esp)
c0100933:	e8 04 fa ff ff       	call   c010033c <cprintf>
c0100938:	eb 6d                	jmp    c01009a7 <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1c                	jmp    c010095f <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 00             	movzbl (%eax),%eax
c010094e:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100954:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100957:	01 ca                	add    %ecx,%edx
c0100959:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010095b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100962:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100965:	7f dc                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100967:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c010096d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100970:	01 d0                	add    %edx,%eax
c0100972:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100975:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100978:	8b 55 08             	mov    0x8(%ebp),%edx
c010097b:	89 d1                	mov    %edx,%ecx
c010097d:	29 c1                	sub    %eax,%ecx
c010097f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100982:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100985:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100989:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100993:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010099b:	c7 04 24 f6 60 10 c0 	movl   $0xc01060f6,(%esp)
c01009a2:	e8 95 f9 ff ff       	call   c010033c <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a7:	c9                   	leave  
c01009a8:	c3                   	ret    

c01009a9 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a9:	55                   	push   %ebp
c01009aa:	89 e5                	mov    %esp,%ebp
c01009ac:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009af:	8b 45 04             	mov    0x4(%ebp),%eax
c01009b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c01009b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01009b8:	c9                   	leave  
c01009b9:	c3                   	ret    

c01009ba <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009ba:	55                   	push   %ebp
c01009bb:	89 e5                	mov    %esp,%ebp
c01009bd:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c0:	89 e8                	mov    %ebp,%eax
c01009c2:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
c01009c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
c01009c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
c01009cb:	e8 d9 ff ff ff       	call   c01009a9 <read_eip>
c01009d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j = 0;
c01009d3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
c01009da:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009e1:	e9 88 00 00 00       	jmp    c0100a6e <print_stackframe+0xb4>
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
c01009e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f4:	c7 04 24 08 61 10 c0 	movl   $0xc0106108,(%esp)
c01009fb:	e8 3c f9 ff ff       	call   c010033c <cprintf>
		uint32_t* arguments = (uint32_t*)ebp + 2;
c0100a00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a03:	83 c0 08             	add    $0x8,%eax
c0100a06:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j < 4;j++)
c0100a09:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a10:	eb 25                	jmp    c0100a37 <print_stackframe+0x7d>
			cprintf("0x%08x ",arguments[j]);
c0100a12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a15:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100a1c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100a1f:	01 d0                	add    %edx,%eax
c0100a21:	8b 00                	mov    (%eax),%eax
c0100a23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a27:	c7 04 24 25 61 10 c0 	movl   $0xc0106125,(%esp)
c0100a2e:	e8 09 f9 ff ff       	call   c010033c <cprintf>
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
		uint32_t* arguments = (uint32_t*)ebp + 2;
		for(j = 0;j < 4;j++)
c0100a33:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a37:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a3b:	7e d5                	jle    c0100a12 <print_stackframe+0x58>
			cprintf("0x%08x ",arguments[j]);
		cprintf("\n");
c0100a3d:	c7 04 24 2d 61 10 c0 	movl   $0xc010612d,(%esp)
c0100a44:	e8 f3 f8 ff ff       	call   c010033c <cprintf>
		print_debuginfo(eip - 1);
c0100a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a4c:	83 e8 01             	sub    $0x1,%eax
c0100a4f:	89 04 24             	mov    %eax,(%esp)
c0100a52:	e8 af fe ff ff       	call   c0100906 <print_debuginfo>
		eip = *((uint32_t*)ebp + 1);
c0100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5a:	83 c0 04             	add    $0x4,%eax
c0100a5d:	8b 00                	mov    (%eax),%eax
c0100a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
c0100a62:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a65:	8b 00                	mov    (%eax),%eax
c0100a67:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
c0100a6a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a6e:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a72:	7f 0a                	jg     c0100a7e <print_stackframe+0xc4>
c0100a74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a78:	0f 85 68 ff ff ff    	jne    c01009e6 <print_stackframe+0x2c>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)ebp + 1);
		ebp = *((uint32_t*)ebp);
	}
}
c0100a7e:	c9                   	leave  
c0100a7f:	c3                   	ret    

c0100a80 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a80:	55                   	push   %ebp
c0100a81:	89 e5                	mov    %esp,%ebp
c0100a83:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a86:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8d:	eb 0c                	jmp    c0100a9b <parse+0x1b>
            *buf ++ = '\0';
c0100a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a92:	8d 50 01             	lea    0x1(%eax),%edx
c0100a95:	89 55 08             	mov    %edx,0x8(%ebp)
c0100a98:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a9b:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9e:	0f b6 00             	movzbl (%eax),%eax
c0100aa1:	84 c0                	test   %al,%al
c0100aa3:	74 1d                	je     c0100ac2 <parse+0x42>
c0100aa5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa8:	0f b6 00             	movzbl (%eax),%eax
c0100aab:	0f be c0             	movsbl %al,%eax
c0100aae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ab2:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100ab9:	e8 5c 51 00 00       	call   c0105c1a <strchr>
c0100abe:	85 c0                	test   %eax,%eax
c0100ac0:	75 cd                	jne    c0100a8f <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ac2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac5:	0f b6 00             	movzbl (%eax),%eax
c0100ac8:	84 c0                	test   %al,%al
c0100aca:	75 02                	jne    c0100ace <parse+0x4e>
            break;
c0100acc:	eb 67                	jmp    c0100b35 <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ace:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ad2:	75 14                	jne    c0100ae8 <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ad4:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100adb:	00 
c0100adc:	c7 04 24 b5 61 10 c0 	movl   $0xc01061b5,(%esp)
c0100ae3:	e8 54 f8 ff ff       	call   c010033c <cprintf>
        }
        argv[argc ++] = buf;
c0100ae8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100aeb:	8d 50 01             	lea    0x1(%eax),%edx
c0100aee:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100af1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100af8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100afb:	01 c2                	add    %eax,%edx
c0100afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b00:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b02:	eb 04                	jmp    c0100b08 <parse+0x88>
            buf ++;
c0100b04:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b0b:	0f b6 00             	movzbl (%eax),%eax
c0100b0e:	84 c0                	test   %al,%al
c0100b10:	74 1d                	je     c0100b2f <parse+0xaf>
c0100b12:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b15:	0f b6 00             	movzbl (%eax),%eax
c0100b18:	0f be c0             	movsbl %al,%eax
c0100b1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b1f:	c7 04 24 b0 61 10 c0 	movl   $0xc01061b0,(%esp)
c0100b26:	e8 ef 50 00 00       	call   c0105c1a <strchr>
c0100b2b:	85 c0                	test   %eax,%eax
c0100b2d:	74 d5                	je     c0100b04 <parse+0x84>
            buf ++;
        }
    }
c0100b2f:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b30:	e9 66 ff ff ff       	jmp    c0100a9b <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b38:	c9                   	leave  
c0100b39:	c3                   	ret    

c0100b3a <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b3a:	55                   	push   %ebp
c0100b3b:	89 e5                	mov    %esp,%ebp
c0100b3d:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b40:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4a:	89 04 24             	mov    %eax,(%esp)
c0100b4d:	e8 2e ff ff ff       	call   c0100a80 <parse>
c0100b52:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b55:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b59:	75 0a                	jne    c0100b65 <runcmd+0x2b>
        return 0;
c0100b5b:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b60:	e9 85 00 00 00       	jmp    c0100bea <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b6c:	eb 5c                	jmp    c0100bca <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b6e:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b71:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b74:	89 d0                	mov    %edx,%eax
c0100b76:	01 c0                	add    %eax,%eax
c0100b78:	01 d0                	add    %edx,%eax
c0100b7a:	c1 e0 02             	shl    $0x2,%eax
c0100b7d:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100b82:	8b 00                	mov    (%eax),%eax
c0100b84:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b88:	89 04 24             	mov    %eax,(%esp)
c0100b8b:	e8 eb 4f 00 00       	call   c0105b7b <strcmp>
c0100b90:	85 c0                	test   %eax,%eax
c0100b92:	75 32                	jne    c0100bc6 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b97:	89 d0                	mov    %edx,%eax
c0100b99:	01 c0                	add    %eax,%eax
c0100b9b:	01 d0                	add    %edx,%eax
c0100b9d:	c1 e0 02             	shl    $0x2,%eax
c0100ba0:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100ba5:	8b 40 08             	mov    0x8(%eax),%eax
c0100ba8:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100bab:	8d 4a ff             	lea    -0x1(%edx),%ecx
c0100bae:	8b 55 0c             	mov    0xc(%ebp),%edx
c0100bb1:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100bb5:	8d 55 b0             	lea    -0x50(%ebp),%edx
c0100bb8:	83 c2 04             	add    $0x4,%edx
c0100bbb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0100bbf:	89 0c 24             	mov    %ecx,(%esp)
c0100bc2:	ff d0                	call   *%eax
c0100bc4:	eb 24                	jmp    c0100bea <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bc6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bcd:	83 f8 02             	cmp    $0x2,%eax
c0100bd0:	76 9c                	jbe    c0100b6e <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bd2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bd9:	c7 04 24 d3 61 10 c0 	movl   $0xc01061d3,(%esp)
c0100be0:	e8 57 f7 ff ff       	call   c010033c <cprintf>
    return 0;
c0100be5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bea:	c9                   	leave  
c0100beb:	c3                   	ret    

c0100bec <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bec:	55                   	push   %ebp
c0100bed:	89 e5                	mov    %esp,%ebp
c0100bef:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bf2:	c7 04 24 ec 61 10 c0 	movl   $0xc01061ec,(%esp)
c0100bf9:	e8 3e f7 ff ff       	call   c010033c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bfe:	c7 04 24 14 62 10 c0 	movl   $0xc0106214,(%esp)
c0100c05:	e8 32 f7 ff ff       	call   c010033c <cprintf>

    if (tf != NULL) {
c0100c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c0e:	74 0b                	je     c0100c1b <kmonitor+0x2f>
        print_trapframe(tf);
c0100c10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c13:	89 04 24             	mov    %eax,(%esp)
c0100c16:	e8 37 0e 00 00       	call   c0101a52 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c1b:	c7 04 24 39 62 10 c0 	movl   $0xc0106239,(%esp)
c0100c22:	e8 0c f6 ff ff       	call   c0100233 <readline>
c0100c27:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c2a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c2e:	74 18                	je     c0100c48 <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
c0100c30:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c3a:	89 04 24             	mov    %eax,(%esp)
c0100c3d:	e8 f8 fe ff ff       	call   c0100b3a <runcmd>
c0100c42:	85 c0                	test   %eax,%eax
c0100c44:	79 02                	jns    c0100c48 <kmonitor+0x5c>
                break;
c0100c46:	eb 02                	jmp    c0100c4a <kmonitor+0x5e>
            }
        }
    }
c0100c48:	eb d1                	jmp    c0100c1b <kmonitor+0x2f>
}
c0100c4a:	c9                   	leave  
c0100c4b:	c3                   	ret    

c0100c4c <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c4c:	55                   	push   %ebp
c0100c4d:	89 e5                	mov    %esp,%ebp
c0100c4f:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c59:	eb 3f                	jmp    c0100c9a <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5e:	89 d0                	mov    %edx,%eax
c0100c60:	01 c0                	add    %eax,%eax
c0100c62:	01 d0                	add    %edx,%eax
c0100c64:	c1 e0 02             	shl    $0x2,%eax
c0100c67:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c6c:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c72:	89 d0                	mov    %edx,%eax
c0100c74:	01 c0                	add    %eax,%eax
c0100c76:	01 d0                	add    %edx,%eax
c0100c78:	c1 e0 02             	shl    $0x2,%eax
c0100c7b:	05 20 70 11 c0       	add    $0xc0117020,%eax
c0100c80:	8b 00                	mov    (%eax),%eax
c0100c82:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c8a:	c7 04 24 3d 62 10 c0 	movl   $0xc010623d,(%esp)
c0100c91:	e8 a6 f6 ff ff       	call   c010033c <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c96:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c9d:	83 f8 02             	cmp    $0x2,%eax
c0100ca0:	76 b9                	jbe    c0100c5b <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100ca2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca7:	c9                   	leave  
c0100ca8:	c3                   	ret    

c0100ca9 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100ca9:	55                   	push   %ebp
c0100caa:	89 e5                	mov    %esp,%ebp
c0100cac:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100caf:	e8 bc fb ff ff       	call   c0100870 <print_kerninfo>
    return 0;
c0100cb4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb9:	c9                   	leave  
c0100cba:	c3                   	ret    

c0100cbb <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cbb:	55                   	push   %ebp
c0100cbc:	89 e5                	mov    %esp,%ebp
c0100cbe:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cc1:	e8 f4 fc ff ff       	call   c01009ba <print_stackframe>
    return 0;
c0100cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ccb:	c9                   	leave  
c0100ccc:	c3                   	ret    

c0100ccd <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ccd:	55                   	push   %ebp
c0100cce:	89 e5                	mov    %esp,%ebp
c0100cd0:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cd3:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
c0100cd8:	85 c0                	test   %eax,%eax
c0100cda:	74 02                	je     c0100cde <__panic+0x11>
        goto panic_dead;
c0100cdc:	eb 48                	jmp    c0100d26 <__panic+0x59>
    }
    is_panic = 1;
c0100cde:	c7 05 60 7e 11 c0 01 	movl   $0x1,0xc0117e60
c0100ce5:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100ce8:	8d 45 14             	lea    0x14(%ebp),%eax
c0100ceb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cee:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cf1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cf8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfc:	c7 04 24 46 62 10 c0 	movl   $0xc0106246,(%esp)
c0100d03:	e8 34 f6 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d0f:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d12:	89 04 24             	mov    %eax,(%esp)
c0100d15:	e8 ef f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d1a:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
c0100d21:	e8 16 f6 ff ff       	call   c010033c <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
c0100d26:	e8 85 09 00 00       	call   c01016b0 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d2b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d32:	e8 b5 fe ff ff       	call   c0100bec <kmonitor>
    }
c0100d37:	eb f2                	jmp    c0100d2b <__panic+0x5e>

c0100d39 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d39:	55                   	push   %ebp
c0100d3a:	89 e5                	mov    %esp,%ebp
c0100d3c:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d3f:	8d 45 14             	lea    0x14(%ebp),%eax
c0100d42:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d48:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d4f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d53:	c7 04 24 64 62 10 c0 	movl   $0xc0106264,(%esp)
c0100d5a:	e8 dd f5 ff ff       	call   c010033c <cprintf>
    vcprintf(fmt, ap);
c0100d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d62:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d66:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d69:	89 04 24             	mov    %eax,(%esp)
c0100d6c:	e8 98 f5 ff ff       	call   c0100309 <vcprintf>
    cprintf("\n");
c0100d71:	c7 04 24 62 62 10 c0 	movl   $0xc0106262,(%esp)
c0100d78:	e8 bf f5 ff ff       	call   c010033c <cprintf>
    va_end(ap);
}
c0100d7d:	c9                   	leave  
c0100d7e:	c3                   	ret    

c0100d7f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d7f:	55                   	push   %ebp
c0100d80:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d82:	a1 60 7e 11 c0       	mov    0xc0117e60,%eax
}
c0100d87:	5d                   	pop    %ebp
c0100d88:	c3                   	ret    

c0100d89 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d89:	55                   	push   %ebp
c0100d8a:	89 e5                	mov    %esp,%ebp
c0100d8c:	83 ec 28             	sub    $0x28,%esp
c0100d8f:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d95:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d99:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d9d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100da1:	ee                   	out    %al,(%dx)
c0100da2:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da8:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100dac:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100db0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100db4:	ee                   	out    %al,(%dx)
c0100db5:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dbb:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dbf:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dc3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc7:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc8:	c7 05 4c 89 11 c0 00 	movl   $0x0,0xc011894c
c0100dcf:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dd2:	c7 04 24 82 62 10 c0 	movl   $0xc0106282,(%esp)
c0100dd9:	e8 5e f5 ff ff       	call   c010033c <cprintf>
    pic_enable(IRQ_TIMER);
c0100dde:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de5:	e8 24 09 00 00       	call   c010170e <pic_enable>
}
c0100dea:	c9                   	leave  
c0100deb:	c3                   	ret    

c0100dec <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dec:	55                   	push   %ebp
c0100ded:	89 e5                	mov    %esp,%ebp
c0100def:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100df2:	9c                   	pushf  
c0100df3:	58                   	pop    %eax
c0100df4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100dfa:	25 00 02 00 00       	and    $0x200,%eax
c0100dff:	85 c0                	test   %eax,%eax
c0100e01:	74 0c                	je     c0100e0f <__intr_save+0x23>
        intr_disable();
c0100e03:	e8 a8 08 00 00       	call   c01016b0 <intr_disable>
        return 1;
c0100e08:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0d:	eb 05                	jmp    c0100e14 <__intr_save+0x28>
    }
    return 0;
c0100e0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e14:	c9                   	leave  
c0100e15:	c3                   	ret    

c0100e16 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e16:	55                   	push   %ebp
c0100e17:	89 e5                	mov    %esp,%ebp
c0100e19:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e20:	74 05                	je     c0100e27 <__intr_restore+0x11>
        intr_enable();
c0100e22:	e8 83 08 00 00       	call   c01016aa <intr_enable>
    }
}
c0100e27:	c9                   	leave  
c0100e28:	c3                   	ret    

c0100e29 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e29:	55                   	push   %ebp
c0100e2a:	89 e5                	mov    %esp,%ebp
c0100e2c:	83 ec 10             	sub    $0x10,%esp
c0100e2f:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e35:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e39:	89 c2                	mov    %eax,%edx
c0100e3b:	ec                   	in     (%dx),%al
c0100e3c:	88 45 fd             	mov    %al,-0x3(%ebp)
c0100e3f:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e45:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e49:	89 c2                	mov    %eax,%edx
c0100e4b:	ec                   	in     (%dx),%al
c0100e4c:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e4f:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e55:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e59:	89 c2                	mov    %eax,%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e5f:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
c0100e65:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e69:	89 c2                	mov    %eax,%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e6f:	c9                   	leave  
c0100e70:	c3                   	ret    

c0100e71 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e71:	55                   	push   %ebp
c0100e72:	89 e5                	mov    %esp,%ebp
c0100e74:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e77:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e81:	0f b7 00             	movzwl (%eax),%eax
c0100e84:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e8b:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e90:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e93:	0f b7 00             	movzwl (%eax),%eax
c0100e96:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100e9a:	74 12                	je     c0100eae <cga_init+0x3d>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e9c:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100ea3:	66 c7 05 86 7e 11 c0 	movw   $0x3b4,0xc0117e86
c0100eaa:	b4 03 
c0100eac:	eb 13                	jmp    c0100ec1 <cga_init+0x50>
    } else {
        *cp = was;
c0100eae:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100eb1:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100eb5:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100eb8:	66 c7 05 86 7e 11 c0 	movw   $0x3d4,0xc0117e86
c0100ebf:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ec1:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ec8:	0f b7 c0             	movzwl %ax,%eax
c0100ecb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0100ecf:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ed3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ed7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100edb:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100edc:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100ee3:	83 c0 01             	add    $0x1,%eax
c0100ee6:	0f b7 c0             	movzwl %ax,%eax
c0100ee9:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100eed:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100ef1:	89 c2                	mov    %eax,%edx
c0100ef3:	ec                   	in     (%dx),%al
c0100ef4:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100ef7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efb:	0f b6 c0             	movzbl %al,%eax
c0100efe:	c1 e0 08             	shl    $0x8,%eax
c0100f01:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100f04:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f0b:	0f b7 c0             	movzwl %ax,%eax
c0100f0e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c0100f12:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f16:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f1a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f1e:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f1f:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0100f26:	83 c0 01             	add    $0x1,%eax
c0100f29:	0f b7 c0             	movzwl %ax,%eax
c0100f2c:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f30:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0100f34:	89 c2                	mov    %eax,%edx
c0100f36:	ec                   	in     (%dx),%al
c0100f37:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
c0100f3a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f3e:	0f b6 c0             	movzbl %al,%eax
c0100f41:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f44:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f47:	a3 80 7e 11 c0       	mov    %eax,0xc0117e80
    crt_pos = pos;
c0100f4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f4f:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
}
c0100f55:	c9                   	leave  
c0100f56:	c3                   	ret    

c0100f57 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f57:	55                   	push   %ebp
c0100f58:	89 e5                	mov    %esp,%ebp
c0100f5a:	83 ec 48             	sub    $0x48,%esp
c0100f5d:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f63:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f67:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f6b:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f6f:	ee                   	out    %al,(%dx)
c0100f70:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f76:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f7a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f7e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f82:	ee                   	out    %al,(%dx)
c0100f83:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100f89:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100f8d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f91:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f95:	ee                   	out    %al,(%dx)
c0100f96:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100f9c:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fa0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fa4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fa8:	ee                   	out    %al,(%dx)
c0100fa9:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100faf:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fb3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb7:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fbb:	ee                   	out    %al,(%dx)
c0100fbc:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fc2:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fc6:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fca:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fce:	ee                   	out    %al,(%dx)
c0100fcf:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100fd5:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100fd9:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100fdd:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100fe1:	ee                   	out    %al,(%dx)
c0100fe2:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fe8:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0100fec:	89 c2                	mov    %eax,%edx
c0100fee:	ec                   	in     (%dx),%al
c0100fef:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
c0100ff2:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100ff6:	3c ff                	cmp    $0xff,%al
c0100ff8:	0f 95 c0             	setne  %al
c0100ffb:	0f b6 c0             	movzbl %al,%eax
c0100ffe:	a3 88 7e 11 c0       	mov    %eax,0xc0117e88
c0101003:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101009:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
c010100d:	89 c2                	mov    %eax,%edx
c010100f:	ec                   	in     (%dx),%al
c0101010:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101013:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
c0101019:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
c010101d:	89 c2                	mov    %eax,%edx
c010101f:	ec                   	in     (%dx),%al
c0101020:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101023:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c0101028:	85 c0                	test   %eax,%eax
c010102a:	74 0c                	je     c0101038 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c010102c:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101033:	e8 d6 06 00 00       	call   c010170e <pic_enable>
    }
}
c0101038:	c9                   	leave  
c0101039:	c3                   	ret    

c010103a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010103a:	55                   	push   %ebp
c010103b:	89 e5                	mov    %esp,%ebp
c010103d:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101047:	eb 09                	jmp    c0101052 <lpt_putc_sub+0x18>
        delay();
c0101049:	e8 db fd ff ff       	call   c0100e29 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010104e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0101052:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101058:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c010105c:	89 c2                	mov    %eax,%edx
c010105e:	ec                   	in     (%dx),%al
c010105f:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c0101062:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101066:	84 c0                	test   %al,%al
c0101068:	78 09                	js     c0101073 <lpt_putc_sub+0x39>
c010106a:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101071:	7e d6                	jle    c0101049 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
c0101073:	8b 45 08             	mov    0x8(%ebp),%eax
c0101076:	0f b6 c0             	movzbl %al,%eax
c0101079:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
c010107f:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101082:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101086:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010108a:	ee                   	out    %al,(%dx)
c010108b:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101091:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c0101095:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101099:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010109d:	ee                   	out    %al,(%dx)
c010109e:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010a4:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
c01010a8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010ac:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010b0:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010b1:	c9                   	leave  
c01010b2:	c3                   	ret    

c01010b3 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c01010b3:	55                   	push   %ebp
c01010b4:	89 e5                	mov    %esp,%ebp
c01010b6:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010b9:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010bd:	74 0d                	je     c01010cc <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01010c2:	89 04 24             	mov    %eax,(%esp)
c01010c5:	e8 70 ff ff ff       	call   c010103a <lpt_putc_sub>
c01010ca:	eb 24                	jmp    c01010f0 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c01010cc:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d3:	e8 62 ff ff ff       	call   c010103a <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010df:	e8 56 ff ff ff       	call   c010103a <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010eb:	e8 4a ff ff ff       	call   c010103a <lpt_putc_sub>
    }
}
c01010f0:	c9                   	leave  
c01010f1:	c3                   	ret    

c01010f2 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010f2:	55                   	push   %ebp
c01010f3:	89 e5                	mov    %esp,%ebp
c01010f5:	53                   	push   %ebx
c01010f6:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01010fc:	b0 00                	mov    $0x0,%al
c01010fe:	85 c0                	test   %eax,%eax
c0101100:	75 07                	jne    c0101109 <cga_putc+0x17>
        c |= 0x0700;
c0101102:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101109:	8b 45 08             	mov    0x8(%ebp),%eax
c010110c:	0f b6 c0             	movzbl %al,%eax
c010110f:	83 f8 0a             	cmp    $0xa,%eax
c0101112:	74 4c                	je     c0101160 <cga_putc+0x6e>
c0101114:	83 f8 0d             	cmp    $0xd,%eax
c0101117:	74 57                	je     c0101170 <cga_putc+0x7e>
c0101119:	83 f8 08             	cmp    $0x8,%eax
c010111c:	0f 85 88 00 00 00    	jne    c01011aa <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
c0101122:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101129:	66 85 c0             	test   %ax,%ax
c010112c:	74 30                	je     c010115e <cga_putc+0x6c>
            crt_pos --;
c010112e:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101135:	83 e8 01             	sub    $0x1,%eax
c0101138:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010113e:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c0101143:	0f b7 15 84 7e 11 c0 	movzwl 0xc0117e84,%edx
c010114a:	0f b7 d2             	movzwl %dx,%edx
c010114d:	01 d2                	add    %edx,%edx
c010114f:	01 c2                	add    %eax,%edx
c0101151:	8b 45 08             	mov    0x8(%ebp),%eax
c0101154:	b0 00                	mov    $0x0,%al
c0101156:	83 c8 20             	or     $0x20,%eax
c0101159:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c010115c:	eb 72                	jmp    c01011d0 <cga_putc+0xde>
c010115e:	eb 70                	jmp    c01011d0 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
c0101160:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c0101167:	83 c0 50             	add    $0x50,%eax
c010116a:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101170:	0f b7 1d 84 7e 11 c0 	movzwl 0xc0117e84,%ebx
c0101177:	0f b7 0d 84 7e 11 c0 	movzwl 0xc0117e84,%ecx
c010117e:	0f b7 c1             	movzwl %cx,%eax
c0101181:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c0101187:	c1 e8 10             	shr    $0x10,%eax
c010118a:	89 c2                	mov    %eax,%edx
c010118c:	66 c1 ea 06          	shr    $0x6,%dx
c0101190:	89 d0                	mov    %edx,%eax
c0101192:	c1 e0 02             	shl    $0x2,%eax
c0101195:	01 d0                	add    %edx,%eax
c0101197:	c1 e0 04             	shl    $0x4,%eax
c010119a:	29 c1                	sub    %eax,%ecx
c010119c:	89 ca                	mov    %ecx,%edx
c010119e:	89 d8                	mov    %ebx,%eax
c01011a0:	29 d0                	sub    %edx,%eax
c01011a2:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
        break;
c01011a8:	eb 26                	jmp    c01011d0 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011aa:	8b 0d 80 7e 11 c0    	mov    0xc0117e80,%ecx
c01011b0:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011b7:	8d 50 01             	lea    0x1(%eax),%edx
c01011ba:	66 89 15 84 7e 11 c0 	mov    %dx,0xc0117e84
c01011c1:	0f b7 c0             	movzwl %ax,%eax
c01011c4:	01 c0                	add    %eax,%eax
c01011c6:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cc:	66 89 02             	mov    %ax,(%edx)
        break;
c01011cf:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011d0:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01011d7:	66 3d cf 07          	cmp    $0x7cf,%ax
c01011db:	76 5b                	jbe    c0101238 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011dd:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011e2:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e8:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c01011ed:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f4:	00 
c01011f5:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f9:	89 04 24             	mov    %eax,(%esp)
c01011fc:	e8 17 4c 00 00       	call   c0105e18 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101201:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101208:	eb 15                	jmp    c010121f <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
c010120a:	a1 80 7e 11 c0       	mov    0xc0117e80,%eax
c010120f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101212:	01 d2                	add    %edx,%edx
c0101214:	01 d0                	add    %edx,%eax
c0101216:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010121f:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101226:	7e e2                	jle    c010120a <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101228:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010122f:	83 e8 50             	sub    $0x50,%eax
c0101232:	66 a3 84 7e 11 c0    	mov    %ax,0xc0117e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101238:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c010123f:	0f b7 c0             	movzwl %ax,%eax
c0101242:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101246:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010124a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010124e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101252:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101253:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c010125a:	66 c1 e8 08          	shr    $0x8,%ax
c010125e:	0f b6 c0             	movzbl %al,%eax
c0101261:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c0101268:	83 c2 01             	add    $0x1,%edx
c010126b:	0f b7 d2             	movzwl %dx,%edx
c010126e:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c0101272:	88 45 ed             	mov    %al,-0x13(%ebp)
c0101275:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101279:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010127d:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127e:	0f b7 05 86 7e 11 c0 	movzwl 0xc0117e86,%eax
c0101285:	0f b7 c0             	movzwl %ax,%eax
c0101288:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c010128c:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c0101290:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101294:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101298:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101299:	0f b7 05 84 7e 11 c0 	movzwl 0xc0117e84,%eax
c01012a0:	0f b6 c0             	movzbl %al,%eax
c01012a3:	0f b7 15 86 7e 11 c0 	movzwl 0xc0117e86,%edx
c01012aa:	83 c2 01             	add    $0x1,%edx
c01012ad:	0f b7 d2             	movzwl %dx,%edx
c01012b0:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c01012b4:	88 45 e5             	mov    %al,-0x1b(%ebp)
c01012b7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01012bb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01012bf:	ee                   	out    %al,(%dx)
}
c01012c0:	83 c4 34             	add    $0x34,%esp
c01012c3:	5b                   	pop    %ebx
c01012c4:	5d                   	pop    %ebp
c01012c5:	c3                   	ret    

c01012c6 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c6:	55                   	push   %ebp
c01012c7:	89 e5                	mov    %esp,%ebp
c01012c9:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012cc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012d3:	eb 09                	jmp    c01012de <serial_putc_sub+0x18>
        delay();
c01012d5:	e8 4f fb ff ff       	call   c0100e29 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012da:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01012de:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012e4:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e8:	89 c2                	mov    %eax,%edx
c01012ea:	ec                   	in     (%dx),%al
c01012eb:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012ee:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012f2:	0f b6 c0             	movzbl %al,%eax
c01012f5:	83 e0 20             	and    $0x20,%eax
c01012f8:	85 c0                	test   %eax,%eax
c01012fa:	75 09                	jne    c0101305 <serial_putc_sub+0x3f>
c01012fc:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101303:	7e d0                	jle    c01012d5 <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101305:	8b 45 08             	mov    0x8(%ebp),%eax
c0101308:	0f b6 c0             	movzbl %al,%eax
c010130b:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101311:	88 45 f5             	mov    %al,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101314:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101318:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010131c:	ee                   	out    %al,(%dx)
}
c010131d:	c9                   	leave  
c010131e:	c3                   	ret    

c010131f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010131f:	55                   	push   %ebp
c0101320:	89 e5                	mov    %esp,%ebp
c0101322:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101325:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101329:	74 0d                	je     c0101338 <serial_putc+0x19>
        serial_putc_sub(c);
c010132b:	8b 45 08             	mov    0x8(%ebp),%eax
c010132e:	89 04 24             	mov    %eax,(%esp)
c0101331:	e8 90 ff ff ff       	call   c01012c6 <serial_putc_sub>
c0101336:	eb 24                	jmp    c010135c <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101338:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010133f:	e8 82 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub(' ');
c0101344:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010134b:	e8 76 ff ff ff       	call   c01012c6 <serial_putc_sub>
        serial_putc_sub('\b');
c0101350:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101357:	e8 6a ff ff ff       	call   c01012c6 <serial_putc_sub>
    }
}
c010135c:	c9                   	leave  
c010135d:	c3                   	ret    

c010135e <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c010135e:	55                   	push   %ebp
c010135f:	89 e5                	mov    %esp,%ebp
c0101361:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c0101364:	eb 33                	jmp    c0101399 <cons_intr+0x3b>
        if (c != 0) {
c0101366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010136a:	74 2d                	je     c0101399 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c010136c:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101371:	8d 50 01             	lea    0x1(%eax),%edx
c0101374:	89 15 a4 80 11 c0    	mov    %edx,0xc01180a4
c010137a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010137d:	88 90 a0 7e 11 c0    	mov    %dl,-0x3fee8160(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c0101383:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101388:	3d 00 02 00 00       	cmp    $0x200,%eax
c010138d:	75 0a                	jne    c0101399 <cons_intr+0x3b>
                cons.wpos = 0;
c010138f:	c7 05 a4 80 11 c0 00 	movl   $0x0,0xc01180a4
c0101396:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101399:	8b 45 08             	mov    0x8(%ebp),%eax
c010139c:	ff d0                	call   *%eax
c010139e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01013a1:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a5:	75 bf                	jne    c0101366 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c01013a7:	c9                   	leave  
c01013a8:	c3                   	ret    

c01013a9 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a9:	55                   	push   %ebp
c01013aa:	89 e5                	mov    %esp,%ebp
c01013ac:	83 ec 10             	sub    $0x10,%esp
c01013af:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b5:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b9:	89 c2                	mov    %eax,%edx
c01013bb:	ec                   	in     (%dx),%al
c01013bc:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bf:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013c3:	0f b6 c0             	movzbl %al,%eax
c01013c6:	83 e0 01             	and    $0x1,%eax
c01013c9:	85 c0                	test   %eax,%eax
c01013cb:	75 07                	jne    c01013d4 <serial_proc_data+0x2b>
        return -1;
c01013cd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013d2:	eb 2a                	jmp    c01013fe <serial_proc_data+0x55>
c01013d4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013da:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013de:	89 c2                	mov    %eax,%edx
c01013e0:	ec                   	in     (%dx),%al
c01013e1:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e4:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e8:	0f b6 c0             	movzbl %al,%eax
c01013eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ee:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013f2:	75 07                	jne    c01013fb <serial_proc_data+0x52>
        c = '\b';
c01013f4:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013fb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fe:	c9                   	leave  
c01013ff:	c3                   	ret    

c0101400 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101400:	55                   	push   %ebp
c0101401:	89 e5                	mov    %esp,%ebp
c0101403:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101406:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c010140b:	85 c0                	test   %eax,%eax
c010140d:	74 0c                	je     c010141b <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140f:	c7 04 24 a9 13 10 c0 	movl   $0xc01013a9,(%esp)
c0101416:	e8 43 ff ff ff       	call   c010135e <cons_intr>
    }
}
c010141b:	c9                   	leave  
c010141c:	c3                   	ret    

c010141d <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141d:	55                   	push   %ebp
c010141e:	89 e5                	mov    %esp,%ebp
c0101420:	83 ec 38             	sub    $0x38,%esp
c0101423:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101429:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c010142d:	89 c2                	mov    %eax,%edx
c010142f:	ec                   	in     (%dx),%al
c0101430:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c0101433:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101437:	0f b6 c0             	movzbl %al,%eax
c010143a:	83 e0 01             	and    $0x1,%eax
c010143d:	85 c0                	test   %eax,%eax
c010143f:	75 0a                	jne    c010144b <kbd_proc_data+0x2e>
        return -1;
c0101441:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101446:	e9 59 01 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
c010144b:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101451:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101455:	89 c2                	mov    %eax,%edx
c0101457:	ec                   	in     (%dx),%al
c0101458:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c010145b:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145f:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c0101462:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101466:	75 17                	jne    c010147f <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
c0101468:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010146d:	83 c8 40             	or     $0x40,%eax
c0101470:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c0101475:	b8 00 00 00 00       	mov    $0x0,%eax
c010147a:	e9 25 01 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
    } else if (data & 0x80) {
c010147f:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101483:	84 c0                	test   %al,%al
c0101485:	79 47                	jns    c01014ce <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101487:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c010148c:	83 e0 40             	and    $0x40,%eax
c010148f:	85 c0                	test   %eax,%eax
c0101491:	75 09                	jne    c010149c <kbd_proc_data+0x7f>
c0101493:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101497:	83 e0 7f             	and    $0x7f,%eax
c010149a:	eb 04                	jmp    c01014a0 <kbd_proc_data+0x83>
c010149c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a0:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c01014a3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a7:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014ae:	83 c8 40             	or     $0x40,%eax
c01014b1:	0f b6 c0             	movzbl %al,%eax
c01014b4:	f7 d0                	not    %eax
c01014b6:	89 c2                	mov    %eax,%edx
c01014b8:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014bd:	21 d0                	and    %edx,%eax
c01014bf:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
        return 0;
c01014c4:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c9:	e9 d6 00 00 00       	jmp    c01015a4 <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
c01014ce:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014d3:	83 e0 40             	and    $0x40,%eax
c01014d6:	85 c0                	test   %eax,%eax
c01014d8:	74 11                	je     c01014eb <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014da:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014de:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014e3:	83 e0 bf             	and    $0xffffffbf,%eax
c01014e6:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    }

    shift |= shiftcode[data];
c01014eb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014ef:	0f b6 80 60 70 11 c0 	movzbl -0x3fee8fa0(%eax),%eax
c01014f6:	0f b6 d0             	movzbl %al,%edx
c01014f9:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c01014fe:	09 d0                	or     %edx,%eax
c0101500:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8
    shift ^= togglecode[data];
c0101505:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101509:	0f b6 80 60 71 11 c0 	movzbl -0x3fee8ea0(%eax),%eax
c0101510:	0f b6 d0             	movzbl %al,%edx
c0101513:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101518:	31 d0                	xor    %edx,%eax
c010151a:	a3 a8 80 11 c0       	mov    %eax,0xc01180a8

    c = charcode[shift & (CTL | SHIFT)][data];
c010151f:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101524:	83 e0 03             	and    $0x3,%eax
c0101527:	8b 14 85 60 75 11 c0 	mov    -0x3fee8aa0(,%eax,4),%edx
c010152e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101532:	01 d0                	add    %edx,%eax
c0101534:	0f b6 00             	movzbl (%eax),%eax
c0101537:	0f b6 c0             	movzbl %al,%eax
c010153a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c010153d:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101542:	83 e0 08             	and    $0x8,%eax
c0101545:	85 c0                	test   %eax,%eax
c0101547:	74 22                	je     c010156b <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
c0101549:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c010154d:	7e 0c                	jle    c010155b <kbd_proc_data+0x13e>
c010154f:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c0101553:	7f 06                	jg     c010155b <kbd_proc_data+0x13e>
            c += 'A' - 'a';
c0101555:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101559:	eb 10                	jmp    c010156b <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
c010155b:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c010155f:	7e 0a                	jle    c010156b <kbd_proc_data+0x14e>
c0101561:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101565:	7f 04                	jg     c010156b <kbd_proc_data+0x14e>
            c += 'a' - 'A';
c0101567:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c010156b:	a1 a8 80 11 c0       	mov    0xc01180a8,%eax
c0101570:	f7 d0                	not    %eax
c0101572:	83 e0 06             	and    $0x6,%eax
c0101575:	85 c0                	test   %eax,%eax
c0101577:	75 28                	jne    c01015a1 <kbd_proc_data+0x184>
c0101579:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101580:	75 1f                	jne    c01015a1 <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
c0101582:	c7 04 24 9d 62 10 c0 	movl   $0xc010629d,(%esp)
c0101589:	e8 ae ed ff ff       	call   c010033c <cprintf>
c010158e:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101594:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101598:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c010159c:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c01015a0:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c01015a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01015a4:	c9                   	leave  
c01015a5:	c3                   	ret    

c01015a6 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c01015a6:	55                   	push   %ebp
c01015a7:	89 e5                	mov    %esp,%ebp
c01015a9:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015ac:	c7 04 24 1d 14 10 c0 	movl   $0xc010141d,(%esp)
c01015b3:	e8 a6 fd ff ff       	call   c010135e <cons_intr>
}
c01015b8:	c9                   	leave  
c01015b9:	c3                   	ret    

c01015ba <kbd_init>:

static void
kbd_init(void) {
c01015ba:	55                   	push   %ebp
c01015bb:	89 e5                	mov    %esp,%ebp
c01015bd:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015c0:	e8 e1 ff ff ff       	call   c01015a6 <kbd_intr>
    pic_enable(IRQ_KBD);
c01015c5:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015cc:	e8 3d 01 00 00       	call   c010170e <pic_enable>
}
c01015d1:	c9                   	leave  
c01015d2:	c3                   	ret    

c01015d3 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015d3:	55                   	push   %ebp
c01015d4:	89 e5                	mov    %esp,%ebp
c01015d6:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d9:	e8 93 f8 ff ff       	call   c0100e71 <cga_init>
    serial_init();
c01015de:	e8 74 f9 ff ff       	call   c0100f57 <serial_init>
    kbd_init();
c01015e3:	e8 d2 ff ff ff       	call   c01015ba <kbd_init>
    if (!serial_exists) {
c01015e8:	a1 88 7e 11 c0       	mov    0xc0117e88,%eax
c01015ed:	85 c0                	test   %eax,%eax
c01015ef:	75 0c                	jne    c01015fd <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015f1:	c7 04 24 a9 62 10 c0 	movl   $0xc01062a9,(%esp)
c01015f8:	e8 3f ed ff ff       	call   c010033c <cprintf>
    }
}
c01015fd:	c9                   	leave  
c01015fe:	c3                   	ret    

c01015ff <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015ff:	55                   	push   %ebp
c0101600:	89 e5                	mov    %esp,%ebp
c0101602:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101605:	e8 e2 f7 ff ff       	call   c0100dec <__intr_save>
c010160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c010160d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101610:	89 04 24             	mov    %eax,(%esp)
c0101613:	e8 9b fa ff ff       	call   c01010b3 <lpt_putc>
        cga_putc(c);
c0101618:	8b 45 08             	mov    0x8(%ebp),%eax
c010161b:	89 04 24             	mov    %eax,(%esp)
c010161e:	e8 cf fa ff ff       	call   c01010f2 <cga_putc>
        serial_putc(c);
c0101623:	8b 45 08             	mov    0x8(%ebp),%eax
c0101626:	89 04 24             	mov    %eax,(%esp)
c0101629:	e8 f1 fc ff ff       	call   c010131f <serial_putc>
    }
    local_intr_restore(intr_flag);
c010162e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101631:	89 04 24             	mov    %eax,(%esp)
c0101634:	e8 dd f7 ff ff       	call   c0100e16 <__intr_restore>
}
c0101639:	c9                   	leave  
c010163a:	c3                   	ret    

c010163b <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c010163b:	55                   	push   %ebp
c010163c:	89 e5                	mov    %esp,%ebp
c010163e:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c0101641:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101648:	e8 9f f7 ff ff       	call   c0100dec <__intr_save>
c010164d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c0101650:	e8 ab fd ff ff       	call   c0101400 <serial_intr>
        kbd_intr();
c0101655:	e8 4c ff ff ff       	call   c01015a6 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c010165a:	8b 15 a0 80 11 c0    	mov    0xc01180a0,%edx
c0101660:	a1 a4 80 11 c0       	mov    0xc01180a4,%eax
c0101665:	39 c2                	cmp    %eax,%edx
c0101667:	74 31                	je     c010169a <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101669:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c010166e:	8d 50 01             	lea    0x1(%eax),%edx
c0101671:	89 15 a0 80 11 c0    	mov    %edx,0xc01180a0
c0101677:	0f b6 80 a0 7e 11 c0 	movzbl -0x3fee8160(%eax),%eax
c010167e:	0f b6 c0             	movzbl %al,%eax
c0101681:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101684:	a1 a0 80 11 c0       	mov    0xc01180a0,%eax
c0101689:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168e:	75 0a                	jne    c010169a <cons_getc+0x5f>
                cons.rpos = 0;
c0101690:	c7 05 a0 80 11 c0 00 	movl   $0x0,0xc01180a0
c0101697:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010169a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010169d:	89 04 24             	mov    %eax,(%esp)
c01016a0:	e8 71 f7 ff ff       	call   c0100e16 <__intr_restore>
    return c;
c01016a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a8:	c9                   	leave  
c01016a9:	c3                   	ret    

c01016aa <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01016aa:	55                   	push   %ebp
c01016ab:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01016ad:	fb                   	sti    
    sti();
}
c01016ae:	5d                   	pop    %ebp
c01016af:	c3                   	ret    

c01016b0 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01016b0:	55                   	push   %ebp
c01016b1:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01016b3:	fa                   	cli    
    cli();
}
c01016b4:	5d                   	pop    %ebp
c01016b5:	c3                   	ret    

c01016b6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016b6:	55                   	push   %ebp
c01016b7:	89 e5                	mov    %esp,%ebp
c01016b9:	83 ec 14             	sub    $0x14,%esp
c01016bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bf:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016c3:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016c7:	66 a3 70 75 11 c0    	mov    %ax,0xc0117570
    if (did_init) {
c01016cd:	a1 ac 80 11 c0       	mov    0xc01180ac,%eax
c01016d2:	85 c0                	test   %eax,%eax
c01016d4:	74 36                	je     c010170c <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016d6:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016da:	0f b6 c0             	movzbl %al,%eax
c01016dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01016e3:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01016e6:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016ea:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016ee:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016ef:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016f3:	66 c1 e8 08          	shr    $0x8,%ax
c01016f7:	0f b6 c0             	movzbl %al,%eax
c01016fa:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101700:	88 45 f9             	mov    %al,-0x7(%ebp)
c0101703:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101707:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c010170b:	ee                   	out    %al,(%dx)
    }
}
c010170c:	c9                   	leave  
c010170d:	c3                   	ret    

c010170e <pic_enable>:

void
pic_enable(unsigned int irq) {
c010170e:	55                   	push   %ebp
c010170f:	89 e5                	mov    %esp,%ebp
c0101711:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101714:	8b 45 08             	mov    0x8(%ebp),%eax
c0101717:	ba 01 00 00 00       	mov    $0x1,%edx
c010171c:	89 c1                	mov    %eax,%ecx
c010171e:	d3 e2                	shl    %cl,%edx
c0101720:	89 d0                	mov    %edx,%eax
c0101722:	f7 d0                	not    %eax
c0101724:	89 c2                	mov    %eax,%edx
c0101726:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010172d:	21 d0                	and    %edx,%eax
c010172f:	0f b7 c0             	movzwl %ax,%eax
c0101732:	89 04 24             	mov    %eax,(%esp)
c0101735:	e8 7c ff ff ff       	call   c01016b6 <pic_setmask>
}
c010173a:	c9                   	leave  
c010173b:	c3                   	ret    

c010173c <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c010173c:	55                   	push   %ebp
c010173d:	89 e5                	mov    %esp,%ebp
c010173f:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101742:	c7 05 ac 80 11 c0 01 	movl   $0x1,0xc01180ac
c0101749:	00 00 00 
c010174c:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0101752:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0101756:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010175a:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010175e:	ee                   	out    %al,(%dx)
c010175f:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0101765:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c0101769:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010176d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101771:	ee                   	out    %al,(%dx)
c0101772:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101778:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010177c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101780:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101784:	ee                   	out    %al,(%dx)
c0101785:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010178b:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c010178f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101793:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101797:	ee                   	out    %al,(%dx)
c0101798:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010179e:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01017a2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017a6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017aa:	ee                   	out    %al,(%dx)
c01017ab:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01017b1:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01017b5:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017b9:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017bd:	ee                   	out    %al,(%dx)
c01017be:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c01017c4:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c01017c8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017cc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d0:	ee                   	out    %al,(%dx)
c01017d1:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c01017d7:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c01017db:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017df:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017e3:	ee                   	out    %al,(%dx)
c01017e4:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c01017ea:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c01017ee:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017f2:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017f6:	ee                   	out    %al,(%dx)
c01017f7:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c01017fd:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101801:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101805:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101809:	ee                   	out    %al,(%dx)
c010180a:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0101810:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0101814:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101818:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010181c:	ee                   	out    %al,(%dx)
c010181d:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0101823:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0101827:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c010182b:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010182f:	ee                   	out    %al,(%dx)
c0101830:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0101836:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010183a:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010183e:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101842:	ee                   	out    %al,(%dx)
c0101843:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0101849:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010184d:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101851:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101855:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0101856:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010185d:	66 83 f8 ff          	cmp    $0xffff,%ax
c0101861:	74 12                	je     c0101875 <pic_init+0x139>
        pic_setmask(irq_mask);
c0101863:	0f b7 05 70 75 11 c0 	movzwl 0xc0117570,%eax
c010186a:	0f b7 c0             	movzwl %ax,%eax
c010186d:	89 04 24             	mov    %eax,(%esp)
c0101870:	e8 41 fe ff ff       	call   c01016b6 <pic_setmask>
    }
}
c0101875:	c9                   	leave  
c0101876:	c3                   	ret    

c0101877 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101877:	55                   	push   %ebp
c0101878:	89 e5                	mov    %esp,%ebp
c010187a:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010187d:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101884:	00 
c0101885:	c7 04 24 e0 62 10 c0 	movl   $0xc01062e0,(%esp)
c010188c:	e8 ab ea ff ff       	call   c010033c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101891:	c9                   	leave  
c0101892:	c3                   	ret    

c0101893 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101893:	55                   	push   %ebp
c0101894:	89 e5                	mov    %esp,%ebp
c0101896:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
c0101899:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
c01018a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018a7:	e9 c3 00 00 00       	jmp    c010196f <idt_init+0xdc>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018af:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c01018b6:	89 c2                	mov    %eax,%edx
c01018b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018bb:	66 89 14 c5 c0 80 11 	mov    %dx,-0x3fee7f40(,%eax,8)
c01018c2:	c0 
c01018c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018c6:	66 c7 04 c5 c2 80 11 	movw   $0x8,-0x3fee7f3e(,%eax,8)
c01018cd:	c0 08 00 
c01018d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d3:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018da:	c0 
c01018db:	83 e2 e0             	and    $0xffffffe0,%edx
c01018de:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e8:	0f b6 14 c5 c4 80 11 	movzbl -0x3fee7f3c(,%eax,8),%edx
c01018ef:	c0 
c01018f0:	83 e2 1f             	and    $0x1f,%edx
c01018f3:	88 14 c5 c4 80 11 c0 	mov    %dl,-0x3fee7f3c(,%eax,8)
c01018fa:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018fd:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101904:	c0 
c0101905:	83 e2 f0             	and    $0xfffffff0,%edx
c0101908:	83 ca 0e             	or     $0xe,%edx
c010190b:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101912:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101915:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c010191c:	c0 
c010191d:	83 e2 ef             	and    $0xffffffef,%edx
c0101920:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101927:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010192a:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101931:	c0 
c0101932:	83 e2 9f             	and    $0xffffff9f,%edx
c0101935:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c010193c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010193f:	0f b6 14 c5 c5 80 11 	movzbl -0x3fee7f3b(,%eax,8),%edx
c0101946:	c0 
c0101947:	83 ca 80             	or     $0xffffff80,%edx
c010194a:	88 14 c5 c5 80 11 c0 	mov    %dl,-0x3fee7f3b(,%eax,8)
c0101951:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101954:	8b 04 85 00 76 11 c0 	mov    -0x3fee8a00(,%eax,4),%eax
c010195b:	c1 e8 10             	shr    $0x10,%eax
c010195e:	89 c2                	mov    %eax,%edx
c0101960:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101963:	66 89 14 c5 c6 80 11 	mov    %dx,-0x3fee7f3a(,%eax,8)
c010196a:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
c010196b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101972:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101977:	0f 86 2f ff ff ff    	jbe    c01018ac <idt_init+0x19>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c010197d:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c0101982:	66 a3 88 84 11 c0    	mov    %ax,0xc0118488
c0101988:	66 c7 05 8a 84 11 c0 	movw   $0x8,0xc011848a
c010198f:	08 00 
c0101991:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c0101998:	83 e0 e0             	and    $0xffffffe0,%eax
c010199b:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019a0:	0f b6 05 8c 84 11 c0 	movzbl 0xc011848c,%eax
c01019a7:	83 e0 1f             	and    $0x1f,%eax
c01019aa:	a2 8c 84 11 c0       	mov    %al,0xc011848c
c01019af:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019b6:	83 e0 f0             	and    $0xfffffff0,%eax
c01019b9:	83 c8 0e             	or     $0xe,%eax
c01019bc:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019c1:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019c8:	83 e0 ef             	and    $0xffffffef,%eax
c01019cb:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019d0:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019d7:	83 c8 60             	or     $0x60,%eax
c01019da:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019df:	0f b6 05 8d 84 11 c0 	movzbl 0xc011848d,%eax
c01019e6:	83 c8 80             	or     $0xffffff80,%eax
c01019e9:	a2 8d 84 11 c0       	mov    %al,0xc011848d
c01019ee:	a1 e4 77 11 c0       	mov    0xc01177e4,%eax
c01019f3:	c1 e8 10             	shr    $0x10,%eax
c01019f6:	66 a3 8e 84 11 c0    	mov    %ax,0xc011848e
c01019fc:	c7 45 f8 80 75 11 c0 	movl   $0xc0117580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a03:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a06:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
c0101a09:	c9                   	leave  
c0101a0a:	c3                   	ret    

c0101a0b <trapname>:

static const char *
trapname(int trapno) {
c0101a0b:	55                   	push   %ebp
c0101a0c:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a11:	83 f8 13             	cmp    $0x13,%eax
c0101a14:	77 0c                	ja     c0101a22 <trapname+0x17>
        return excnames[trapno];
c0101a16:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a19:	8b 04 85 40 66 10 c0 	mov    -0x3fef99c0(,%eax,4),%eax
c0101a20:	eb 18                	jmp    c0101a3a <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101a22:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101a26:	7e 0d                	jle    c0101a35 <trapname+0x2a>
c0101a28:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101a2c:	7f 07                	jg     c0101a35 <trapname+0x2a>
        return "Hardware Interrupt";
c0101a2e:	b8 ea 62 10 c0       	mov    $0xc01062ea,%eax
c0101a33:	eb 05                	jmp    c0101a3a <trapname+0x2f>
    }
    return "(unknown trap)";
c0101a35:	b8 fd 62 10 c0       	mov    $0xc01062fd,%eax
}
c0101a3a:	5d                   	pop    %ebp
c0101a3b:	c3                   	ret    

c0101a3c <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101a3c:	55                   	push   %ebp
c0101a3d:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101a3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a42:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101a46:	66 83 f8 08          	cmp    $0x8,%ax
c0101a4a:	0f 94 c0             	sete   %al
c0101a4d:	0f b6 c0             	movzbl %al,%eax
}
c0101a50:	5d                   	pop    %ebp
c0101a51:	c3                   	ret    

c0101a52 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101a52:	55                   	push   %ebp
c0101a53:	89 e5                	mov    %esp,%ebp
c0101a55:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a5f:	c7 04 24 3e 63 10 c0 	movl   $0xc010633e,(%esp)
c0101a66:	e8 d1 e8 ff ff       	call   c010033c <cprintf>
    print_regs(&tf->tf_regs);
c0101a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a6e:	89 04 24             	mov    %eax,(%esp)
c0101a71:	e8 a1 01 00 00       	call   c0101c17 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a79:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a7d:	0f b7 c0             	movzwl %ax,%eax
c0101a80:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a84:	c7 04 24 4f 63 10 c0 	movl   $0xc010634f,(%esp)
c0101a8b:	e8 ac e8 ff ff       	call   c010033c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a93:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a97:	0f b7 c0             	movzwl %ax,%eax
c0101a9a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a9e:	c7 04 24 62 63 10 c0 	movl   $0xc0106362,(%esp)
c0101aa5:	e8 92 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101aaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aad:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101ab1:	0f b7 c0             	movzwl %ax,%eax
c0101ab4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ab8:	c7 04 24 75 63 10 c0 	movl   $0xc0106375,(%esp)
c0101abf:	e8 78 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ac7:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101acb:	0f b7 c0             	movzwl %ax,%eax
c0101ace:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad2:	c7 04 24 88 63 10 c0 	movl   $0xc0106388,(%esp)
c0101ad9:	e8 5e e8 ff ff       	call   c010033c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae1:	8b 40 30             	mov    0x30(%eax),%eax
c0101ae4:	89 04 24             	mov    %eax,(%esp)
c0101ae7:	e8 1f ff ff ff       	call   c0101a0b <trapname>
c0101aec:	8b 55 08             	mov    0x8(%ebp),%edx
c0101aef:	8b 52 30             	mov    0x30(%edx),%edx
c0101af2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101af6:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101afa:	c7 04 24 9b 63 10 c0 	movl   $0xc010639b,(%esp)
c0101b01:	e8 36 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b06:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b09:	8b 40 34             	mov    0x34(%eax),%eax
c0101b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b10:	c7 04 24 ad 63 10 c0 	movl   $0xc01063ad,(%esp)
c0101b17:	e8 20 e8 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101b1c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1f:	8b 40 38             	mov    0x38(%eax),%eax
c0101b22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b26:	c7 04 24 bc 63 10 c0 	movl   $0xc01063bc,(%esp)
c0101b2d:	e8 0a e8 ff ff       	call   c010033c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b35:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101b39:	0f b7 c0             	movzwl %ax,%eax
c0101b3c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b40:	c7 04 24 cb 63 10 c0 	movl   $0xc01063cb,(%esp)
c0101b47:	e8 f0 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b4f:	8b 40 40             	mov    0x40(%eax),%eax
c0101b52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b56:	c7 04 24 de 63 10 c0 	movl   $0xc01063de,(%esp)
c0101b5d:	e8 da e7 ff ff       	call   c010033c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b62:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101b69:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b70:	eb 3e                	jmp    c0101bb0 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b72:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b75:	8b 50 40             	mov    0x40(%eax),%edx
c0101b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b7b:	21 d0                	and    %edx,%eax
c0101b7d:	85 c0                	test   %eax,%eax
c0101b7f:	74 28                	je     c0101ba9 <print_trapframe+0x157>
c0101b81:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b84:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b8b:	85 c0                	test   %eax,%eax
c0101b8d:	74 1a                	je     c0101ba9 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101b8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b92:	8b 04 85 a0 75 11 c0 	mov    -0x3fee8a60(,%eax,4),%eax
c0101b99:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b9d:	c7 04 24 ed 63 10 c0 	movl   $0xc01063ed,(%esp)
c0101ba4:	e8 93 e7 ff ff       	call   c010033c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101ba9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101bad:	d1 65 f0             	shll   -0x10(%ebp)
c0101bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101bb3:	83 f8 17             	cmp    $0x17,%eax
c0101bb6:	76 ba                	jbe    c0101b72 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbb:	8b 40 40             	mov    0x40(%eax),%eax
c0101bbe:	25 00 30 00 00       	and    $0x3000,%eax
c0101bc3:	c1 e8 0c             	shr    $0xc,%eax
c0101bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bca:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0101bd1:	e8 66 e7 ff ff       	call   c010033c <cprintf>

    if (!trap_in_kernel(tf)) {
c0101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd9:	89 04 24             	mov    %eax,(%esp)
c0101bdc:	e8 5b fe ff ff       	call   c0101a3c <trap_in_kernel>
c0101be1:	85 c0                	test   %eax,%eax
c0101be3:	75 30                	jne    c0101c15 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101be8:	8b 40 44             	mov    0x44(%eax),%eax
c0101beb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bef:	c7 04 24 fa 63 10 c0 	movl   $0xc01063fa,(%esp)
c0101bf6:	e8 41 e7 ff ff       	call   c010033c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bfe:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c02:	0f b7 c0             	movzwl %ax,%eax
c0101c05:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c09:	c7 04 24 09 64 10 c0 	movl   $0xc0106409,(%esp)
c0101c10:	e8 27 e7 ff ff       	call   c010033c <cprintf>
    }
}
c0101c15:	c9                   	leave  
c0101c16:	c3                   	ret    

c0101c17 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101c17:	55                   	push   %ebp
c0101c18:	89 e5                	mov    %esp,%ebp
c0101c1a:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101c1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c20:	8b 00                	mov    (%eax),%eax
c0101c22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c26:	c7 04 24 1c 64 10 c0 	movl   $0xc010641c,(%esp)
c0101c2d:	e8 0a e7 ff ff       	call   c010033c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c35:	8b 40 04             	mov    0x4(%eax),%eax
c0101c38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3c:	c7 04 24 2b 64 10 c0 	movl   $0xc010642b,(%esp)
c0101c43:	e8 f4 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101c48:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4b:	8b 40 08             	mov    0x8(%eax),%eax
c0101c4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c52:	c7 04 24 3a 64 10 c0 	movl   $0xc010643a,(%esp)
c0101c59:	e8 de e6 ff ff       	call   c010033c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101c5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c61:	8b 40 0c             	mov    0xc(%eax),%eax
c0101c64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c68:	c7 04 24 49 64 10 c0 	movl   $0xc0106449,(%esp)
c0101c6f:	e8 c8 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c74:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c77:	8b 40 10             	mov    0x10(%eax),%eax
c0101c7a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c7e:	c7 04 24 58 64 10 c0 	movl   $0xc0106458,(%esp)
c0101c85:	e8 b2 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c8d:	8b 40 14             	mov    0x14(%eax),%eax
c0101c90:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c94:	c7 04 24 67 64 10 c0 	movl   $0xc0106467,(%esp)
c0101c9b:	e8 9c e6 ff ff       	call   c010033c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101ca0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ca3:	8b 40 18             	mov    0x18(%eax),%eax
c0101ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101caa:	c7 04 24 76 64 10 c0 	movl   $0xc0106476,(%esp)
c0101cb1:	e8 86 e6 ff ff       	call   c010033c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101cb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cb9:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101cbc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc0:	c7 04 24 85 64 10 c0 	movl   $0xc0106485,(%esp)
c0101cc7:	e8 70 e6 ff ff       	call   c010033c <cprintf>
}
c0101ccc:	c9                   	leave  
c0101ccd:	c3                   	ret    

c0101cce <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101cce:	55                   	push   %ebp
c0101ccf:	89 e5                	mov    %esp,%ebp
c0101cd1:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101cd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd7:	8b 40 30             	mov    0x30(%eax),%eax
c0101cda:	83 f8 2f             	cmp    $0x2f,%eax
c0101cdd:	77 21                	ja     c0101d00 <trap_dispatch+0x32>
c0101cdf:	83 f8 2e             	cmp    $0x2e,%eax
c0101ce2:	0f 83 04 01 00 00    	jae    c0101dec <trap_dispatch+0x11e>
c0101ce8:	83 f8 21             	cmp    $0x21,%eax
c0101ceb:	0f 84 81 00 00 00    	je     c0101d72 <trap_dispatch+0xa4>
c0101cf1:	83 f8 24             	cmp    $0x24,%eax
c0101cf4:	74 56                	je     c0101d4c <trap_dispatch+0x7e>
c0101cf6:	83 f8 20             	cmp    $0x20,%eax
c0101cf9:	74 16                	je     c0101d11 <trap_dispatch+0x43>
c0101cfb:	e9 b4 00 00 00       	jmp    c0101db4 <trap_dispatch+0xe6>
c0101d00:	83 e8 78             	sub    $0x78,%eax
c0101d03:	83 f8 01             	cmp    $0x1,%eax
c0101d06:	0f 87 a8 00 00 00    	ja     c0101db4 <trap_dispatch+0xe6>
c0101d0c:	e9 87 00 00 00       	jmp    c0101d98 <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
c0101d11:	a1 4c 89 11 c0       	mov    0xc011894c,%eax
c0101d16:	83 c0 01             	add    $0x1,%eax
c0101d19:	a3 4c 89 11 c0       	mov    %eax,0xc011894c
        if (ticks % TICK_NUM == 0)
c0101d1e:	8b 0d 4c 89 11 c0    	mov    0xc011894c,%ecx
c0101d24:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101d29:	89 c8                	mov    %ecx,%eax
c0101d2b:	f7 e2                	mul    %edx
c0101d2d:	89 d0                	mov    %edx,%eax
c0101d2f:	c1 e8 05             	shr    $0x5,%eax
c0101d32:	6b c0 64             	imul   $0x64,%eax,%eax
c0101d35:	29 c1                	sub    %eax,%ecx
c0101d37:	89 c8                	mov    %ecx,%eax
c0101d39:	85 c0                	test   %eax,%eax
c0101d3b:	75 0a                	jne    c0101d47 <trap_dispatch+0x79>
		print_ticks();
c0101d3d:	e8 35 fb ff ff       	call   c0101877 <print_ticks>
        break;
c0101d42:	e9 a6 00 00 00       	jmp    c0101ded <trap_dispatch+0x11f>
c0101d47:	e9 a1 00 00 00       	jmp    c0101ded <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101d4c:	e8 ea f8 ff ff       	call   c010163b <cons_getc>
c0101d51:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101d54:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d58:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d5c:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d60:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d64:	c7 04 24 94 64 10 c0 	movl   $0xc0106494,(%esp)
c0101d6b:	e8 cc e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d70:	eb 7b                	jmp    c0101ded <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101d72:	e8 c4 f8 ff ff       	call   c010163b <cons_getc>
c0101d77:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d7a:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d7e:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d82:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d86:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d8a:	c7 04 24 a6 64 10 c0 	movl   $0xc01064a6,(%esp)
c0101d91:	e8 a6 e5 ff ff       	call   c010033c <cprintf>
        break;
c0101d96:	eb 55                	jmp    c0101ded <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101d98:	c7 44 24 08 b5 64 10 	movl   $0xc01064b5,0x8(%esp)
c0101d9f:	c0 
c0101da0:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
c0101da7:	00 
c0101da8:	c7 04 24 c5 64 10 c0 	movl   $0xc01064c5,(%esp)
c0101daf:	e8 19 ef ff ff       	call   c0100ccd <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101db4:	8b 45 08             	mov    0x8(%ebp),%eax
c0101db7:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101dbb:	0f b7 c0             	movzwl %ax,%eax
c0101dbe:	83 e0 03             	and    $0x3,%eax
c0101dc1:	85 c0                	test   %eax,%eax
c0101dc3:	75 28                	jne    c0101ded <trap_dispatch+0x11f>
            print_trapframe(tf);
c0101dc5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dc8:	89 04 24             	mov    %eax,(%esp)
c0101dcb:	e8 82 fc ff ff       	call   c0101a52 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101dd0:	c7 44 24 08 d6 64 10 	movl   $0xc01064d6,0x8(%esp)
c0101dd7:	c0 
c0101dd8:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0101ddf:	00 
c0101de0:	c7 04 24 c5 64 10 c0 	movl   $0xc01064c5,(%esp)
c0101de7:	e8 e1 ee ff ff       	call   c0100ccd <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101dec:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101ded:	c9                   	leave  
c0101dee:	c3                   	ret    

c0101def <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101def:	55                   	push   %ebp
c0101df0:	89 e5                	mov    %esp,%ebp
c0101df2:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101df5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101df8:	89 04 24             	mov    %eax,(%esp)
c0101dfb:	e8 ce fe ff ff       	call   c0101cce <trap_dispatch>
}
c0101e00:	c9                   	leave  
c0101e01:	c3                   	ret    

c0101e02 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e02:	1e                   	push   %ds
    pushl %es
c0101e03:	06                   	push   %es
    pushl %fs
c0101e04:	0f a0                	push   %fs
    pushl %gs
c0101e06:	0f a8                	push   %gs
    pushal
c0101e08:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e09:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e0e:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e10:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101e12:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101e13:	e8 d7 ff ff ff       	call   c0101def <trap>

    # pop the pushed stack pointer
    popl %esp
c0101e18:	5c                   	pop    %esp

c0101e19 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101e19:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101e1a:	0f a9                	pop    %gs
    popl %fs
c0101e1c:	0f a1                	pop    %fs
    popl %es
c0101e1e:	07                   	pop    %es
    popl %ds
c0101e1f:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101e20:	83 c4 08             	add    $0x8,%esp
    iret
c0101e23:	cf                   	iret   

c0101e24 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101e24:	6a 00                	push   $0x0
  pushl $0
c0101e26:	6a 00                	push   $0x0
  jmp __alltraps
c0101e28:	e9 d5 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e2d <vector1>:
.globl vector1
vector1:
  pushl $0
c0101e2d:	6a 00                	push   $0x0
  pushl $1
c0101e2f:	6a 01                	push   $0x1
  jmp __alltraps
c0101e31:	e9 cc ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e36 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101e36:	6a 00                	push   $0x0
  pushl $2
c0101e38:	6a 02                	push   $0x2
  jmp __alltraps
c0101e3a:	e9 c3 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e3f <vector3>:
.globl vector3
vector3:
  pushl $0
c0101e3f:	6a 00                	push   $0x0
  pushl $3
c0101e41:	6a 03                	push   $0x3
  jmp __alltraps
c0101e43:	e9 ba ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e48 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101e48:	6a 00                	push   $0x0
  pushl $4
c0101e4a:	6a 04                	push   $0x4
  jmp __alltraps
c0101e4c:	e9 b1 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e51 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101e51:	6a 00                	push   $0x0
  pushl $5
c0101e53:	6a 05                	push   $0x5
  jmp __alltraps
c0101e55:	e9 a8 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e5a <vector6>:
.globl vector6
vector6:
  pushl $0
c0101e5a:	6a 00                	push   $0x0
  pushl $6
c0101e5c:	6a 06                	push   $0x6
  jmp __alltraps
c0101e5e:	e9 9f ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e63 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101e63:	6a 00                	push   $0x0
  pushl $7
c0101e65:	6a 07                	push   $0x7
  jmp __alltraps
c0101e67:	e9 96 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e6c <vector8>:
.globl vector8
vector8:
  pushl $8
c0101e6c:	6a 08                	push   $0x8
  jmp __alltraps
c0101e6e:	e9 8f ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e73 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101e73:	6a 09                	push   $0x9
  jmp __alltraps
c0101e75:	e9 88 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e7a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101e7a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101e7c:	e9 81 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e81 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101e81:	6a 0b                	push   $0xb
  jmp __alltraps
c0101e83:	e9 7a ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e88 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101e88:	6a 0c                	push   $0xc
  jmp __alltraps
c0101e8a:	e9 73 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e8f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101e8f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101e91:	e9 6c ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e96 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101e96:	6a 0e                	push   $0xe
  jmp __alltraps
c0101e98:	e9 65 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101e9d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101e9d:	6a 00                	push   $0x0
  pushl $15
c0101e9f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101ea1:	e9 5c ff ff ff       	jmp    c0101e02 <__alltraps>

c0101ea6 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101ea6:	6a 00                	push   $0x0
  pushl $16
c0101ea8:	6a 10                	push   $0x10
  jmp __alltraps
c0101eaa:	e9 53 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101eaf <vector17>:
.globl vector17
vector17:
  pushl $17
c0101eaf:	6a 11                	push   $0x11
  jmp __alltraps
c0101eb1:	e9 4c ff ff ff       	jmp    c0101e02 <__alltraps>

c0101eb6 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  pushl $18
c0101eb8:	6a 12                	push   $0x12
  jmp __alltraps
c0101eba:	e9 43 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101ebf <vector19>:
.globl vector19
vector19:
  pushl $0
c0101ebf:	6a 00                	push   $0x0
  pushl $19
c0101ec1:	6a 13                	push   $0x13
  jmp __alltraps
c0101ec3:	e9 3a ff ff ff       	jmp    c0101e02 <__alltraps>

c0101ec8 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101ec8:	6a 00                	push   $0x0
  pushl $20
c0101eca:	6a 14                	push   $0x14
  jmp __alltraps
c0101ecc:	e9 31 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101ed1 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101ed1:	6a 00                	push   $0x0
  pushl $21
c0101ed3:	6a 15                	push   $0x15
  jmp __alltraps
c0101ed5:	e9 28 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101eda <vector22>:
.globl vector22
vector22:
  pushl $0
c0101eda:	6a 00                	push   $0x0
  pushl $22
c0101edc:	6a 16                	push   $0x16
  jmp __alltraps
c0101ede:	e9 1f ff ff ff       	jmp    c0101e02 <__alltraps>

c0101ee3 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101ee3:	6a 00                	push   $0x0
  pushl $23
c0101ee5:	6a 17                	push   $0x17
  jmp __alltraps
c0101ee7:	e9 16 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101eec <vector24>:
.globl vector24
vector24:
  pushl $0
c0101eec:	6a 00                	push   $0x0
  pushl $24
c0101eee:	6a 18                	push   $0x18
  jmp __alltraps
c0101ef0:	e9 0d ff ff ff       	jmp    c0101e02 <__alltraps>

c0101ef5 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101ef5:	6a 00                	push   $0x0
  pushl $25
c0101ef7:	6a 19                	push   $0x19
  jmp __alltraps
c0101ef9:	e9 04 ff ff ff       	jmp    c0101e02 <__alltraps>

c0101efe <vector26>:
.globl vector26
vector26:
  pushl $0
c0101efe:	6a 00                	push   $0x0
  pushl $26
c0101f00:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f02:	e9 fb fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f07 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f07:	6a 00                	push   $0x0
  pushl $27
c0101f09:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f0b:	e9 f2 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f10 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101f10:	6a 00                	push   $0x0
  pushl $28
c0101f12:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101f14:	e9 e9 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f19 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101f19:	6a 00                	push   $0x0
  pushl $29
c0101f1b:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101f1d:	e9 e0 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f22 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101f22:	6a 00                	push   $0x0
  pushl $30
c0101f24:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101f26:	e9 d7 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f2b <vector31>:
.globl vector31
vector31:
  pushl $0
c0101f2b:	6a 00                	push   $0x0
  pushl $31
c0101f2d:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101f2f:	e9 ce fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f34 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101f34:	6a 00                	push   $0x0
  pushl $32
c0101f36:	6a 20                	push   $0x20
  jmp __alltraps
c0101f38:	e9 c5 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f3d <vector33>:
.globl vector33
vector33:
  pushl $0
c0101f3d:	6a 00                	push   $0x0
  pushl $33
c0101f3f:	6a 21                	push   $0x21
  jmp __alltraps
c0101f41:	e9 bc fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f46 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $34
c0101f48:	6a 22                	push   $0x22
  jmp __alltraps
c0101f4a:	e9 b3 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f4f <vector35>:
.globl vector35
vector35:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $35
c0101f51:	6a 23                	push   $0x23
  jmp __alltraps
c0101f53:	e9 aa fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f58 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $36
c0101f5a:	6a 24                	push   $0x24
  jmp __alltraps
c0101f5c:	e9 a1 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f61 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $37
c0101f63:	6a 25                	push   $0x25
  jmp __alltraps
c0101f65:	e9 98 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f6a <vector38>:
.globl vector38
vector38:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $38
c0101f6c:	6a 26                	push   $0x26
  jmp __alltraps
c0101f6e:	e9 8f fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f73 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $39
c0101f75:	6a 27                	push   $0x27
  jmp __alltraps
c0101f77:	e9 86 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f7c <vector40>:
.globl vector40
vector40:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $40
c0101f7e:	6a 28                	push   $0x28
  jmp __alltraps
c0101f80:	e9 7d fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f85 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $41
c0101f87:	6a 29                	push   $0x29
  jmp __alltraps
c0101f89:	e9 74 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f8e <vector42>:
.globl vector42
vector42:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $42
c0101f90:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101f92:	e9 6b fe ff ff       	jmp    c0101e02 <__alltraps>

c0101f97 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $43
c0101f99:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101f9b:	e9 62 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fa0 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $44
c0101fa2:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101fa4:	e9 59 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fa9 <vector45>:
.globl vector45
vector45:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $45
c0101fab:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101fad:	e9 50 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fb2 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $46
c0101fb4:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101fb6:	e9 47 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fbb <vector47>:
.globl vector47
vector47:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $47
c0101fbd:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101fbf:	e9 3e fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fc4 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $48
c0101fc6:	6a 30                	push   $0x30
  jmp __alltraps
c0101fc8:	e9 35 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fcd <vector49>:
.globl vector49
vector49:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $49
c0101fcf:	6a 31                	push   $0x31
  jmp __alltraps
c0101fd1:	e9 2c fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fd6 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $50
c0101fd8:	6a 32                	push   $0x32
  jmp __alltraps
c0101fda:	e9 23 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fdf <vector51>:
.globl vector51
vector51:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $51
c0101fe1:	6a 33                	push   $0x33
  jmp __alltraps
c0101fe3:	e9 1a fe ff ff       	jmp    c0101e02 <__alltraps>

c0101fe8 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $52
c0101fea:	6a 34                	push   $0x34
  jmp __alltraps
c0101fec:	e9 11 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101ff1 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $53
c0101ff3:	6a 35                	push   $0x35
  jmp __alltraps
c0101ff5:	e9 08 fe ff ff       	jmp    c0101e02 <__alltraps>

c0101ffa <vector54>:
.globl vector54
vector54:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $54
c0101ffc:	6a 36                	push   $0x36
  jmp __alltraps
c0101ffe:	e9 ff fd ff ff       	jmp    c0101e02 <__alltraps>

c0102003 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $55
c0102005:	6a 37                	push   $0x37
  jmp __alltraps
c0102007:	e9 f6 fd ff ff       	jmp    c0101e02 <__alltraps>

c010200c <vector56>:
.globl vector56
vector56:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $56
c010200e:	6a 38                	push   $0x38
  jmp __alltraps
c0102010:	e9 ed fd ff ff       	jmp    c0101e02 <__alltraps>

c0102015 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $57
c0102017:	6a 39                	push   $0x39
  jmp __alltraps
c0102019:	e9 e4 fd ff ff       	jmp    c0101e02 <__alltraps>

c010201e <vector58>:
.globl vector58
vector58:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $58
c0102020:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102022:	e9 db fd ff ff       	jmp    c0101e02 <__alltraps>

c0102027 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $59
c0102029:	6a 3b                	push   $0x3b
  jmp __alltraps
c010202b:	e9 d2 fd ff ff       	jmp    c0101e02 <__alltraps>

c0102030 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $60
c0102032:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102034:	e9 c9 fd ff ff       	jmp    c0101e02 <__alltraps>

c0102039 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $61
c010203b:	6a 3d                	push   $0x3d
  jmp __alltraps
c010203d:	e9 c0 fd ff ff       	jmp    c0101e02 <__alltraps>

c0102042 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $62
c0102044:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102046:	e9 b7 fd ff ff       	jmp    c0101e02 <__alltraps>

c010204b <vector63>:
.globl vector63
vector63:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $63
c010204d:	6a 3f                	push   $0x3f
  jmp __alltraps
c010204f:	e9 ae fd ff ff       	jmp    c0101e02 <__alltraps>

c0102054 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $64
c0102056:	6a 40                	push   $0x40
  jmp __alltraps
c0102058:	e9 a5 fd ff ff       	jmp    c0101e02 <__alltraps>

c010205d <vector65>:
.globl vector65
vector65:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $65
c010205f:	6a 41                	push   $0x41
  jmp __alltraps
c0102061:	e9 9c fd ff ff       	jmp    c0101e02 <__alltraps>

c0102066 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $66
c0102068:	6a 42                	push   $0x42
  jmp __alltraps
c010206a:	e9 93 fd ff ff       	jmp    c0101e02 <__alltraps>

c010206f <vector67>:
.globl vector67
vector67:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $67
c0102071:	6a 43                	push   $0x43
  jmp __alltraps
c0102073:	e9 8a fd ff ff       	jmp    c0101e02 <__alltraps>

c0102078 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $68
c010207a:	6a 44                	push   $0x44
  jmp __alltraps
c010207c:	e9 81 fd ff ff       	jmp    c0101e02 <__alltraps>

c0102081 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $69
c0102083:	6a 45                	push   $0x45
  jmp __alltraps
c0102085:	e9 78 fd ff ff       	jmp    c0101e02 <__alltraps>

c010208a <vector70>:
.globl vector70
vector70:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $70
c010208c:	6a 46                	push   $0x46
  jmp __alltraps
c010208e:	e9 6f fd ff ff       	jmp    c0101e02 <__alltraps>

c0102093 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $71
c0102095:	6a 47                	push   $0x47
  jmp __alltraps
c0102097:	e9 66 fd ff ff       	jmp    c0101e02 <__alltraps>

c010209c <vector72>:
.globl vector72
vector72:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $72
c010209e:	6a 48                	push   $0x48
  jmp __alltraps
c01020a0:	e9 5d fd ff ff       	jmp    c0101e02 <__alltraps>

c01020a5 <vector73>:
.globl vector73
vector73:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $73
c01020a7:	6a 49                	push   $0x49
  jmp __alltraps
c01020a9:	e9 54 fd ff ff       	jmp    c0101e02 <__alltraps>

c01020ae <vector74>:
.globl vector74
vector74:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $74
c01020b0:	6a 4a                	push   $0x4a
  jmp __alltraps
c01020b2:	e9 4b fd ff ff       	jmp    c0101e02 <__alltraps>

c01020b7 <vector75>:
.globl vector75
vector75:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $75
c01020b9:	6a 4b                	push   $0x4b
  jmp __alltraps
c01020bb:	e9 42 fd ff ff       	jmp    c0101e02 <__alltraps>

c01020c0 <vector76>:
.globl vector76
vector76:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $76
c01020c2:	6a 4c                	push   $0x4c
  jmp __alltraps
c01020c4:	e9 39 fd ff ff       	jmp    c0101e02 <__alltraps>

c01020c9 <vector77>:
.globl vector77
vector77:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $77
c01020cb:	6a 4d                	push   $0x4d
  jmp __alltraps
c01020cd:	e9 30 fd ff ff       	jmp    c0101e02 <__alltraps>

c01020d2 <vector78>:
.globl vector78
vector78:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $78
c01020d4:	6a 4e                	push   $0x4e
  jmp __alltraps
c01020d6:	e9 27 fd ff ff       	jmp    c0101e02 <__alltraps>

c01020db <vector79>:
.globl vector79
vector79:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $79
c01020dd:	6a 4f                	push   $0x4f
  jmp __alltraps
c01020df:	e9 1e fd ff ff       	jmp    c0101e02 <__alltraps>

c01020e4 <vector80>:
.globl vector80
vector80:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $80
c01020e6:	6a 50                	push   $0x50
  jmp __alltraps
c01020e8:	e9 15 fd ff ff       	jmp    c0101e02 <__alltraps>

c01020ed <vector81>:
.globl vector81
vector81:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $81
c01020ef:	6a 51                	push   $0x51
  jmp __alltraps
c01020f1:	e9 0c fd ff ff       	jmp    c0101e02 <__alltraps>

c01020f6 <vector82>:
.globl vector82
vector82:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $82
c01020f8:	6a 52                	push   $0x52
  jmp __alltraps
c01020fa:	e9 03 fd ff ff       	jmp    c0101e02 <__alltraps>

c01020ff <vector83>:
.globl vector83
vector83:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $83
c0102101:	6a 53                	push   $0x53
  jmp __alltraps
c0102103:	e9 fa fc ff ff       	jmp    c0101e02 <__alltraps>

c0102108 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $84
c010210a:	6a 54                	push   $0x54
  jmp __alltraps
c010210c:	e9 f1 fc ff ff       	jmp    c0101e02 <__alltraps>

c0102111 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $85
c0102113:	6a 55                	push   $0x55
  jmp __alltraps
c0102115:	e9 e8 fc ff ff       	jmp    c0101e02 <__alltraps>

c010211a <vector86>:
.globl vector86
vector86:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $86
c010211c:	6a 56                	push   $0x56
  jmp __alltraps
c010211e:	e9 df fc ff ff       	jmp    c0101e02 <__alltraps>

c0102123 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $87
c0102125:	6a 57                	push   $0x57
  jmp __alltraps
c0102127:	e9 d6 fc ff ff       	jmp    c0101e02 <__alltraps>

c010212c <vector88>:
.globl vector88
vector88:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $88
c010212e:	6a 58                	push   $0x58
  jmp __alltraps
c0102130:	e9 cd fc ff ff       	jmp    c0101e02 <__alltraps>

c0102135 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $89
c0102137:	6a 59                	push   $0x59
  jmp __alltraps
c0102139:	e9 c4 fc ff ff       	jmp    c0101e02 <__alltraps>

c010213e <vector90>:
.globl vector90
vector90:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $90
c0102140:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102142:	e9 bb fc ff ff       	jmp    c0101e02 <__alltraps>

c0102147 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $91
c0102149:	6a 5b                	push   $0x5b
  jmp __alltraps
c010214b:	e9 b2 fc ff ff       	jmp    c0101e02 <__alltraps>

c0102150 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $92
c0102152:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102154:	e9 a9 fc ff ff       	jmp    c0101e02 <__alltraps>

c0102159 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $93
c010215b:	6a 5d                	push   $0x5d
  jmp __alltraps
c010215d:	e9 a0 fc ff ff       	jmp    c0101e02 <__alltraps>

c0102162 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $94
c0102164:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102166:	e9 97 fc ff ff       	jmp    c0101e02 <__alltraps>

c010216b <vector95>:
.globl vector95
vector95:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $95
c010216d:	6a 5f                	push   $0x5f
  jmp __alltraps
c010216f:	e9 8e fc ff ff       	jmp    c0101e02 <__alltraps>

c0102174 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $96
c0102176:	6a 60                	push   $0x60
  jmp __alltraps
c0102178:	e9 85 fc ff ff       	jmp    c0101e02 <__alltraps>

c010217d <vector97>:
.globl vector97
vector97:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $97
c010217f:	6a 61                	push   $0x61
  jmp __alltraps
c0102181:	e9 7c fc ff ff       	jmp    c0101e02 <__alltraps>

c0102186 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $98
c0102188:	6a 62                	push   $0x62
  jmp __alltraps
c010218a:	e9 73 fc ff ff       	jmp    c0101e02 <__alltraps>

c010218f <vector99>:
.globl vector99
vector99:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $99
c0102191:	6a 63                	push   $0x63
  jmp __alltraps
c0102193:	e9 6a fc ff ff       	jmp    c0101e02 <__alltraps>

c0102198 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $100
c010219a:	6a 64                	push   $0x64
  jmp __alltraps
c010219c:	e9 61 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021a1 <vector101>:
.globl vector101
vector101:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $101
c01021a3:	6a 65                	push   $0x65
  jmp __alltraps
c01021a5:	e9 58 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021aa <vector102>:
.globl vector102
vector102:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $102
c01021ac:	6a 66                	push   $0x66
  jmp __alltraps
c01021ae:	e9 4f fc ff ff       	jmp    c0101e02 <__alltraps>

c01021b3 <vector103>:
.globl vector103
vector103:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $103
c01021b5:	6a 67                	push   $0x67
  jmp __alltraps
c01021b7:	e9 46 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021bc <vector104>:
.globl vector104
vector104:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $104
c01021be:	6a 68                	push   $0x68
  jmp __alltraps
c01021c0:	e9 3d fc ff ff       	jmp    c0101e02 <__alltraps>

c01021c5 <vector105>:
.globl vector105
vector105:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $105
c01021c7:	6a 69                	push   $0x69
  jmp __alltraps
c01021c9:	e9 34 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021ce <vector106>:
.globl vector106
vector106:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $106
c01021d0:	6a 6a                	push   $0x6a
  jmp __alltraps
c01021d2:	e9 2b fc ff ff       	jmp    c0101e02 <__alltraps>

c01021d7 <vector107>:
.globl vector107
vector107:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $107
c01021d9:	6a 6b                	push   $0x6b
  jmp __alltraps
c01021db:	e9 22 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021e0 <vector108>:
.globl vector108
vector108:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $108
c01021e2:	6a 6c                	push   $0x6c
  jmp __alltraps
c01021e4:	e9 19 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021e9 <vector109>:
.globl vector109
vector109:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $109
c01021eb:	6a 6d                	push   $0x6d
  jmp __alltraps
c01021ed:	e9 10 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021f2 <vector110>:
.globl vector110
vector110:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $110
c01021f4:	6a 6e                	push   $0x6e
  jmp __alltraps
c01021f6:	e9 07 fc ff ff       	jmp    c0101e02 <__alltraps>

c01021fb <vector111>:
.globl vector111
vector111:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $111
c01021fd:	6a 6f                	push   $0x6f
  jmp __alltraps
c01021ff:	e9 fe fb ff ff       	jmp    c0101e02 <__alltraps>

c0102204 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $112
c0102206:	6a 70                	push   $0x70
  jmp __alltraps
c0102208:	e9 f5 fb ff ff       	jmp    c0101e02 <__alltraps>

c010220d <vector113>:
.globl vector113
vector113:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $113
c010220f:	6a 71                	push   $0x71
  jmp __alltraps
c0102211:	e9 ec fb ff ff       	jmp    c0101e02 <__alltraps>

c0102216 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $114
c0102218:	6a 72                	push   $0x72
  jmp __alltraps
c010221a:	e9 e3 fb ff ff       	jmp    c0101e02 <__alltraps>

c010221f <vector115>:
.globl vector115
vector115:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $115
c0102221:	6a 73                	push   $0x73
  jmp __alltraps
c0102223:	e9 da fb ff ff       	jmp    c0101e02 <__alltraps>

c0102228 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $116
c010222a:	6a 74                	push   $0x74
  jmp __alltraps
c010222c:	e9 d1 fb ff ff       	jmp    c0101e02 <__alltraps>

c0102231 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $117
c0102233:	6a 75                	push   $0x75
  jmp __alltraps
c0102235:	e9 c8 fb ff ff       	jmp    c0101e02 <__alltraps>

c010223a <vector118>:
.globl vector118
vector118:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $118
c010223c:	6a 76                	push   $0x76
  jmp __alltraps
c010223e:	e9 bf fb ff ff       	jmp    c0101e02 <__alltraps>

c0102243 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $119
c0102245:	6a 77                	push   $0x77
  jmp __alltraps
c0102247:	e9 b6 fb ff ff       	jmp    c0101e02 <__alltraps>

c010224c <vector120>:
.globl vector120
vector120:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $120
c010224e:	6a 78                	push   $0x78
  jmp __alltraps
c0102250:	e9 ad fb ff ff       	jmp    c0101e02 <__alltraps>

c0102255 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $121
c0102257:	6a 79                	push   $0x79
  jmp __alltraps
c0102259:	e9 a4 fb ff ff       	jmp    c0101e02 <__alltraps>

c010225e <vector122>:
.globl vector122
vector122:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $122
c0102260:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102262:	e9 9b fb ff ff       	jmp    c0101e02 <__alltraps>

c0102267 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $123
c0102269:	6a 7b                	push   $0x7b
  jmp __alltraps
c010226b:	e9 92 fb ff ff       	jmp    c0101e02 <__alltraps>

c0102270 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $124
c0102272:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102274:	e9 89 fb ff ff       	jmp    c0101e02 <__alltraps>

c0102279 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $125
c010227b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010227d:	e9 80 fb ff ff       	jmp    c0101e02 <__alltraps>

c0102282 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $126
c0102284:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102286:	e9 77 fb ff ff       	jmp    c0101e02 <__alltraps>

c010228b <vector127>:
.globl vector127
vector127:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $127
c010228d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010228f:	e9 6e fb ff ff       	jmp    c0101e02 <__alltraps>

c0102294 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $128
c0102296:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010229b:	e9 62 fb ff ff       	jmp    c0101e02 <__alltraps>

c01022a0 <vector129>:
.globl vector129
vector129:
  pushl $0
c01022a0:	6a 00                	push   $0x0
  pushl $129
c01022a2:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c01022a7:	e9 56 fb ff ff       	jmp    c0101e02 <__alltraps>

c01022ac <vector130>:
.globl vector130
vector130:
  pushl $0
c01022ac:	6a 00                	push   $0x0
  pushl $130
c01022ae:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c01022b3:	e9 4a fb ff ff       	jmp    c0101e02 <__alltraps>

c01022b8 <vector131>:
.globl vector131
vector131:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $131
c01022ba:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c01022bf:	e9 3e fb ff ff       	jmp    c0101e02 <__alltraps>

c01022c4 <vector132>:
.globl vector132
vector132:
  pushl $0
c01022c4:	6a 00                	push   $0x0
  pushl $132
c01022c6:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c01022cb:	e9 32 fb ff ff       	jmp    c0101e02 <__alltraps>

c01022d0 <vector133>:
.globl vector133
vector133:
  pushl $0
c01022d0:	6a 00                	push   $0x0
  pushl $133
c01022d2:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c01022d7:	e9 26 fb ff ff       	jmp    c0101e02 <__alltraps>

c01022dc <vector134>:
.globl vector134
vector134:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $134
c01022de:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c01022e3:	e9 1a fb ff ff       	jmp    c0101e02 <__alltraps>

c01022e8 <vector135>:
.globl vector135
vector135:
  pushl $0
c01022e8:	6a 00                	push   $0x0
  pushl $135
c01022ea:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c01022ef:	e9 0e fb ff ff       	jmp    c0101e02 <__alltraps>

c01022f4 <vector136>:
.globl vector136
vector136:
  pushl $0
c01022f4:	6a 00                	push   $0x0
  pushl $136
c01022f6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c01022fb:	e9 02 fb ff ff       	jmp    c0101e02 <__alltraps>

c0102300 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $137
c0102302:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102307:	e9 f6 fa ff ff       	jmp    c0101e02 <__alltraps>

c010230c <vector138>:
.globl vector138
vector138:
  pushl $0
c010230c:	6a 00                	push   $0x0
  pushl $138
c010230e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102313:	e9 ea fa ff ff       	jmp    c0101e02 <__alltraps>

c0102318 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102318:	6a 00                	push   $0x0
  pushl $139
c010231a:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c010231f:	e9 de fa ff ff       	jmp    c0101e02 <__alltraps>

c0102324 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $140
c0102326:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010232b:	e9 d2 fa ff ff       	jmp    c0101e02 <__alltraps>

c0102330 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $141
c0102332:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102337:	e9 c6 fa ff ff       	jmp    c0101e02 <__alltraps>

c010233c <vector142>:
.globl vector142
vector142:
  pushl $0
c010233c:	6a 00                	push   $0x0
  pushl $142
c010233e:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102343:	e9 ba fa ff ff       	jmp    c0101e02 <__alltraps>

c0102348 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $143
c010234a:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c010234f:	e9 ae fa ff ff       	jmp    c0101e02 <__alltraps>

c0102354 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $144
c0102356:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010235b:	e9 a2 fa ff ff       	jmp    c0101e02 <__alltraps>

c0102360 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102360:	6a 00                	push   $0x0
  pushl $145
c0102362:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102367:	e9 96 fa ff ff       	jmp    c0101e02 <__alltraps>

c010236c <vector146>:
.globl vector146
vector146:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $146
c010236e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102373:	e9 8a fa ff ff       	jmp    c0101e02 <__alltraps>

c0102378 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $147
c010237a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010237f:	e9 7e fa ff ff       	jmp    c0101e02 <__alltraps>

c0102384 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102384:	6a 00                	push   $0x0
  pushl $148
c0102386:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010238b:	e9 72 fa ff ff       	jmp    c0101e02 <__alltraps>

c0102390 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $149
c0102392:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102397:	e9 66 fa ff ff       	jmp    c0101e02 <__alltraps>

c010239c <vector150>:
.globl vector150
vector150:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $150
c010239e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01023a3:	e9 5a fa ff ff       	jmp    c0101e02 <__alltraps>

c01023a8 <vector151>:
.globl vector151
vector151:
  pushl $0
c01023a8:	6a 00                	push   $0x0
  pushl $151
c01023aa:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01023af:	e9 4e fa ff ff       	jmp    c0101e02 <__alltraps>

c01023b4 <vector152>:
.globl vector152
vector152:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $152
c01023b6:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01023bb:	e9 42 fa ff ff       	jmp    c0101e02 <__alltraps>

c01023c0 <vector153>:
.globl vector153
vector153:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $153
c01023c2:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01023c7:	e9 36 fa ff ff       	jmp    c0101e02 <__alltraps>

c01023cc <vector154>:
.globl vector154
vector154:
  pushl $0
c01023cc:	6a 00                	push   $0x0
  pushl $154
c01023ce:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01023d3:	e9 2a fa ff ff       	jmp    c0101e02 <__alltraps>

c01023d8 <vector155>:
.globl vector155
vector155:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $155
c01023da:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c01023df:	e9 1e fa ff ff       	jmp    c0101e02 <__alltraps>

c01023e4 <vector156>:
.globl vector156
vector156:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $156
c01023e6:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c01023eb:	e9 12 fa ff ff       	jmp    c0101e02 <__alltraps>

c01023f0 <vector157>:
.globl vector157
vector157:
  pushl $0
c01023f0:	6a 00                	push   $0x0
  pushl $157
c01023f2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c01023f7:	e9 06 fa ff ff       	jmp    c0101e02 <__alltraps>

c01023fc <vector158>:
.globl vector158
vector158:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $158
c01023fe:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102403:	e9 fa f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102408 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $159
c010240a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010240f:	e9 ee f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102414 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102414:	6a 00                	push   $0x0
  pushl $160
c0102416:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010241b:	e9 e2 f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102420 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $161
c0102422:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102427:	e9 d6 f9 ff ff       	jmp    c0101e02 <__alltraps>

c010242c <vector162>:
.globl vector162
vector162:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $162
c010242e:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102433:	e9 ca f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102438 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102438:	6a 00                	push   $0x0
  pushl $163
c010243a:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c010243f:	e9 be f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102444 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $164
c0102446:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010244b:	e9 b2 f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102450 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $165
c0102452:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102457:	e9 a6 f9 ff ff       	jmp    c0101e02 <__alltraps>

c010245c <vector166>:
.globl vector166
vector166:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $166
c010245e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102463:	e9 9a f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102468 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $167
c010246a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c010246f:	e9 8e f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102474 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $168
c0102476:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010247b:	e9 82 f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102480 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $169
c0102482:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102487:	e9 76 f9 ff ff       	jmp    c0101e02 <__alltraps>

c010248c <vector170>:
.globl vector170
vector170:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $170
c010248e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102493:	e9 6a f9 ff ff       	jmp    c0101e02 <__alltraps>

c0102498 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $171
c010249a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010249f:	e9 5e f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024a4 <vector172>:
.globl vector172
vector172:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $172
c01024a6:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01024ab:	e9 52 f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024b0 <vector173>:
.globl vector173
vector173:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $173
c01024b2:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01024b7:	e9 46 f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024bc <vector174>:
.globl vector174
vector174:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $174
c01024be:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01024c3:	e9 3a f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024c8 <vector175>:
.globl vector175
vector175:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $175
c01024ca:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01024cf:	e9 2e f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024d4 <vector176>:
.globl vector176
vector176:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $176
c01024d6:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01024db:	e9 22 f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024e0 <vector177>:
.globl vector177
vector177:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $177
c01024e2:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c01024e7:	e9 16 f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024ec <vector178>:
.globl vector178
vector178:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $178
c01024ee:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c01024f3:	e9 0a f9 ff ff       	jmp    c0101e02 <__alltraps>

c01024f8 <vector179>:
.globl vector179
vector179:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $179
c01024fa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c01024ff:	e9 fe f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102504 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $180
c0102506:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010250b:	e9 f2 f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102510 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $181
c0102512:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102517:	e9 e6 f8 ff ff       	jmp    c0101e02 <__alltraps>

c010251c <vector182>:
.globl vector182
vector182:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $182
c010251e:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102523:	e9 da f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102528 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $183
c010252a:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c010252f:	e9 ce f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102534 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $184
c0102536:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010253b:	e9 c2 f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102540 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $185
c0102542:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102547:	e9 b6 f8 ff ff       	jmp    c0101e02 <__alltraps>

c010254c <vector186>:
.globl vector186
vector186:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $186
c010254e:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102553:	e9 aa f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102558 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $187
c010255a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010255f:	e9 9e f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102564 <vector188>:
.globl vector188
vector188:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $188
c0102566:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010256b:	e9 92 f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102570 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $189
c0102572:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102577:	e9 86 f8 ff ff       	jmp    c0101e02 <__alltraps>

c010257c <vector190>:
.globl vector190
vector190:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $190
c010257e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102583:	e9 7a f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102588 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $191
c010258a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010258f:	e9 6e f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102594 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $192
c0102596:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010259b:	e9 62 f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025a0 <vector193>:
.globl vector193
vector193:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $193
c01025a2:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01025a7:	e9 56 f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025ac <vector194>:
.globl vector194
vector194:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $194
c01025ae:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01025b3:	e9 4a f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025b8 <vector195>:
.globl vector195
vector195:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $195
c01025ba:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01025bf:	e9 3e f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025c4 <vector196>:
.globl vector196
vector196:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $196
c01025c6:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01025cb:	e9 32 f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025d0 <vector197>:
.globl vector197
vector197:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $197
c01025d2:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01025d7:	e9 26 f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025dc <vector198>:
.globl vector198
vector198:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $198
c01025de:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c01025e3:	e9 1a f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025e8 <vector199>:
.globl vector199
vector199:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $199
c01025ea:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c01025ef:	e9 0e f8 ff ff       	jmp    c0101e02 <__alltraps>

c01025f4 <vector200>:
.globl vector200
vector200:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $200
c01025f6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01025fb:	e9 02 f8 ff ff       	jmp    c0101e02 <__alltraps>

c0102600 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $201
c0102602:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102607:	e9 f6 f7 ff ff       	jmp    c0101e02 <__alltraps>

c010260c <vector202>:
.globl vector202
vector202:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $202
c010260e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102613:	e9 ea f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102618 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $203
c010261a:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c010261f:	e9 de f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102624 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $204
c0102626:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010262b:	e9 d2 f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102630 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $205
c0102632:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102637:	e9 c6 f7 ff ff       	jmp    c0101e02 <__alltraps>

c010263c <vector206>:
.globl vector206
vector206:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $206
c010263e:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0102643:	e9 ba f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102648 <vector207>:
.globl vector207
vector207:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $207
c010264a:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c010264f:	e9 ae f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102654 <vector208>:
.globl vector208
vector208:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $208
c0102656:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010265b:	e9 a2 f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102660 <vector209>:
.globl vector209
vector209:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $209
c0102662:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0102667:	e9 96 f7 ff ff       	jmp    c0101e02 <__alltraps>

c010266c <vector210>:
.globl vector210
vector210:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $210
c010266e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102673:	e9 8a f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102678 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $211
c010267a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010267f:	e9 7e f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102684 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $212
c0102686:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010268b:	e9 72 f7 ff ff       	jmp    c0101e02 <__alltraps>

c0102690 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $213
c0102692:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102697:	e9 66 f7 ff ff       	jmp    c0101e02 <__alltraps>

c010269c <vector214>:
.globl vector214
vector214:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $214
c010269e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01026a3:	e9 5a f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026a8 <vector215>:
.globl vector215
vector215:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $215
c01026aa:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01026af:	e9 4e f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026b4 <vector216>:
.globl vector216
vector216:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $216
c01026b6:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01026bb:	e9 42 f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026c0 <vector217>:
.globl vector217
vector217:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $217
c01026c2:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01026c7:	e9 36 f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026cc <vector218>:
.globl vector218
vector218:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $218
c01026ce:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01026d3:	e9 2a f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026d8 <vector219>:
.globl vector219
vector219:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $219
c01026da:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c01026df:	e9 1e f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026e4 <vector220>:
.globl vector220
vector220:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $220
c01026e6:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c01026eb:	e9 12 f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026f0 <vector221>:
.globl vector221
vector221:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $221
c01026f2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01026f7:	e9 06 f7 ff ff       	jmp    c0101e02 <__alltraps>

c01026fc <vector222>:
.globl vector222
vector222:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $222
c01026fe:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102703:	e9 fa f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102708 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $223
c010270a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010270f:	e9 ee f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102714 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $224
c0102716:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010271b:	e9 e2 f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102720 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $225
c0102722:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102727:	e9 d6 f6 ff ff       	jmp    c0101e02 <__alltraps>

c010272c <vector226>:
.globl vector226
vector226:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $226
c010272e:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102733:	e9 ca f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102738 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $227
c010273a:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c010273f:	e9 be f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102744 <vector228>:
.globl vector228
vector228:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $228
c0102746:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010274b:	e9 b2 f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102750 <vector229>:
.globl vector229
vector229:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $229
c0102752:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0102757:	e9 a6 f6 ff ff       	jmp    c0101e02 <__alltraps>

c010275c <vector230>:
.globl vector230
vector230:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $230
c010275e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0102763:	e9 9a f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102768 <vector231>:
.globl vector231
vector231:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $231
c010276a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010276f:	e9 8e f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102774 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $232
c0102776:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010277b:	e9 82 f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102780 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $233
c0102782:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102787:	e9 76 f6 ff ff       	jmp    c0101e02 <__alltraps>

c010278c <vector234>:
.globl vector234
vector234:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $234
c010278e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102793:	e9 6a f6 ff ff       	jmp    c0101e02 <__alltraps>

c0102798 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $235
c010279a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010279f:	e9 5e f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027a4 <vector236>:
.globl vector236
vector236:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $236
c01027a6:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01027ab:	e9 52 f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027b0 <vector237>:
.globl vector237
vector237:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $237
c01027b2:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01027b7:	e9 46 f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027bc <vector238>:
.globl vector238
vector238:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $238
c01027be:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01027c3:	e9 3a f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027c8 <vector239>:
.globl vector239
vector239:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $239
c01027ca:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01027cf:	e9 2e f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027d4 <vector240>:
.globl vector240
vector240:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $240
c01027d6:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01027db:	e9 22 f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027e0 <vector241>:
.globl vector241
vector241:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $241
c01027e2:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c01027e7:	e9 16 f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027ec <vector242>:
.globl vector242
vector242:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $242
c01027ee:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01027f3:	e9 0a f6 ff ff       	jmp    c0101e02 <__alltraps>

c01027f8 <vector243>:
.globl vector243
vector243:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $243
c01027fa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01027ff:	e9 fe f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102804 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $244
c0102806:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010280b:	e9 f2 f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102810 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $245
c0102812:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102817:	e9 e6 f5 ff ff       	jmp    c0101e02 <__alltraps>

c010281c <vector246>:
.globl vector246
vector246:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $246
c010281e:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102823:	e9 da f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102828 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $247
c010282a:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c010282f:	e9 ce f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102834 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $248
c0102836:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010283b:	e9 c2 f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102840 <vector249>:
.globl vector249
vector249:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $249
c0102842:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c0102847:	e9 b6 f5 ff ff       	jmp    c0101e02 <__alltraps>

c010284c <vector250>:
.globl vector250
vector250:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $250
c010284e:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0102853:	e9 aa f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102858 <vector251>:
.globl vector251
vector251:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $251
c010285a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010285f:	e9 9e f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102864 <vector252>:
.globl vector252
vector252:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $252
c0102866:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010286b:	e9 92 f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102870 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $253
c0102872:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102877:	e9 86 f5 ff ff       	jmp    c0101e02 <__alltraps>

c010287c <vector254>:
.globl vector254
vector254:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $254
c010287e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102883:	e9 7a f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102888 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $255
c010288a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010288f:	e9 6e f5 ff ff       	jmp    c0101e02 <__alltraps>

c0102894 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102894:	55                   	push   %ebp
c0102895:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102897:	8b 55 08             	mov    0x8(%ebp),%edx
c010289a:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c010289f:	29 c2                	sub    %eax,%edx
c01028a1:	89 d0                	mov    %edx,%eax
c01028a3:	c1 f8 02             	sar    $0x2,%eax
c01028a6:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01028ac:	5d                   	pop    %ebp
c01028ad:	c3                   	ret    

c01028ae <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01028ae:	55                   	push   %ebp
c01028af:	89 e5                	mov    %esp,%ebp
c01028b1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01028b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01028b7:	89 04 24             	mov    %eax,(%esp)
c01028ba:	e8 d5 ff ff ff       	call   c0102894 <page2ppn>
c01028bf:	c1 e0 0c             	shl    $0xc,%eax
}
c01028c2:	c9                   	leave  
c01028c3:	c3                   	ret    

c01028c4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01028c4:	55                   	push   %ebp
c01028c5:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01028c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01028ca:	8b 00                	mov    (%eax),%eax
}
c01028cc:	5d                   	pop    %ebp
c01028cd:	c3                   	ret    

c01028ce <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01028ce:	55                   	push   %ebp
c01028cf:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01028d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01028d4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01028d7:	89 10                	mov    %edx,(%eax)
}
c01028d9:	5d                   	pop    %ebp
c01028da:	c3                   	ret    

c01028db <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01028db:	55                   	push   %ebp
c01028dc:	89 e5                	mov    %esp,%ebp
c01028de:	83 ec 10             	sub    $0x10,%esp
c01028e1:	c7 45 fc 50 89 11 c0 	movl   $0xc0118950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01028e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028eb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01028ee:	89 50 04             	mov    %edx,0x4(%eax)
c01028f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028f4:	8b 50 04             	mov    0x4(%eax),%edx
c01028f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01028fa:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01028fc:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0102903:	00 00 00 
}
c0102906:	c9                   	leave  
c0102907:	c3                   	ret    

c0102908 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0102908:	55                   	push   %ebp
c0102909:	89 e5                	mov    %esp,%ebp
c010290b:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c010290e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102912:	75 24                	jne    c0102938 <default_init_memmap+0x30>
c0102914:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c010291b:	c0 
c010291c:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102923:	c0 
c0102924:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010292b:	00 
c010292c:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102933:	e8 95 e3 ff ff       	call   c0100ccd <__panic>
    struct Page *p = base;
c0102938:	8b 45 08             	mov    0x8(%ebp),%eax
c010293b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010293e:	e9 eb 00 00 00       	jmp    c0102a2e <default_init_memmap+0x126>
        assert(PageReserved(p));
c0102943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102946:	83 c0 04             	add    $0x4,%eax
c0102949:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0102950:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102953:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102956:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0102959:	0f a3 10             	bt     %edx,(%eax)
c010295c:	19 c0                	sbb    %eax,%eax
c010295e:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c0102961:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0102965:	0f 95 c0             	setne  %al
c0102968:	0f b6 c0             	movzbl %al,%eax
c010296b:	85 c0                	test   %eax,%eax
c010296d:	75 24                	jne    c0102993 <default_init_memmap+0x8b>
c010296f:	c7 44 24 0c c1 66 10 	movl   $0xc01066c1,0xc(%esp)
c0102976:	c0 
c0102977:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010297e:	c0 
c010297f:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102986:	00 
c0102987:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010298e:	e8 3a e3 ff ff       	call   c0100ccd <__panic>
        p->flags = p->property = 0;
c0102993:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102996:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c010299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a0:	8b 50 08             	mov    0x8(%eax),%edx
c01029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029a6:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c01029a9:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01029b0:	00 
c01029b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029b4:	89 04 24             	mov    %eax,(%esp)
c01029b7:	e8 12 ff ff ff       	call   c01028ce <set_page_ref>
        SetPageProperty(p);
c01029bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029bf:	83 c0 04             	add    $0x4,%eax
c01029c2:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01029c9:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01029cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01029cf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01029d2:	0f ab 10             	bts    %edx,(%eax)
        list_add(&free_list,&(p->page_link));
c01029d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029d8:	83 c0 0c             	add    $0xc,%eax
c01029db:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
c01029e2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01029e5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01029e8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01029eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01029ee:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01029f1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01029f4:	8b 40 04             	mov    0x4(%eax),%eax
c01029f7:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01029fa:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01029fd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a00:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102a03:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102a06:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a09:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102a0c:	89 10                	mov    %edx,(%eax)
c0102a0e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102a11:	8b 10                	mov    (%eax),%edx
c0102a13:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102a16:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102a19:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a1c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102a1f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102a22:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102a25:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102a28:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102a2a:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a2e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a31:	89 d0                	mov    %edx,%eax
c0102a33:	c1 e0 02             	shl    $0x2,%eax
c0102a36:	01 d0                	add    %edx,%eax
c0102a38:	c1 e0 02             	shl    $0x2,%eax
c0102a3b:	89 c2                	mov    %eax,%edx
c0102a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a40:	01 d0                	add    %edx,%eax
c0102a42:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102a45:	0f 85 f8 fe ff ff    	jne    c0102943 <default_init_memmap+0x3b>
        p->flags = p->property = 0;
        set_page_ref(p, 0);
        SetPageProperty(p);
        list_add(&free_list,&(p->page_link));
    }
    base->property = n;
c0102a4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a4e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a51:	89 50 08             	mov    %edx,0x8(%eax)
    //SetPageProperty(base);
    nr_free += n;
c0102a54:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102a5a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102a5d:	01 d0                	add    %edx,%eax
c0102a5f:	a3 58 89 11 c0       	mov    %eax,0xc0118958
    //list_add(&free_list, &(base->page_link));
}
c0102a64:	c9                   	leave  
c0102a65:	c3                   	ret    

c0102a66 <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102a66:	55                   	push   %ebp
c0102a67:	89 e5                	mov    %esp,%ebp
c0102a69:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102a6c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102a70:	75 24                	jne    c0102a96 <default_alloc_pages+0x30>
c0102a72:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c0102a79:	c0 
c0102a7a:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102a81:	c0 
c0102a82:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0102a89:	00 
c0102a8a:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102a91:	e8 37 e2 ff ff       	call   c0100ccd <__panic>
    if (n > nr_free) {
c0102a96:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102a9b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102a9e:	73 0a                	jae    c0102aaa <default_alloc_pages+0x44>
        return NULL;
c0102aa0:	b8 00 00 00 00       	mov    $0x0,%eax
c0102aa5:	e9 30 01 00 00       	jmp    c0102bda <default_alloc_pages+0x174>
    }
    struct Page *page = NULL;
c0102aaa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102ab1:	c7 45 f0 50 89 11 c0 	movl   $0xc0118950,-0x10(%ebp)
    while ((le = list_prev(le)) != &free_list) {
c0102ab8:	eb 1c                	jmp    c0102ad6 <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0102aba:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102abd:	83 e8 0c             	sub    $0xc,%eax
c0102ac0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if (p->property >= n) {
c0102ac3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ac6:	8b 40 08             	mov    0x8(%eax),%eax
c0102ac9:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102acc:	72 08                	jb     c0102ad6 <default_alloc_pages+0x70>
            page = p;
c0102ace:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102ad1:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102ad4:	eb 17                	jmp    c0102aed <default_alloc_pages+0x87>
c0102ad6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ad9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102adc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102adf:	8b 00                	mov    (%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_prev(le)) != &free_list) {
c0102ae1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102ae4:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102aeb:	75 cd                	jne    c0102aba <default_alloc_pages+0x54>
        if (p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102aed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102af1:	0f 84 e0 00 00 00    	je     c0102bd7 <default_alloc_pages+0x171>
    	list_entry_t *to_del = &(page->page_link);
c0102af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102afa:	83 c0 0c             	add    $0xc,%eax
c0102afd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    	list_entry_t *to_del_prev;
    	int i = 0;
c0102b00:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
    	for(i = 0;i < n;i++) {
c0102b07:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0102b0e:	eb 7b                	jmp    c0102b8b <default_alloc_pages+0x125>
c0102b10:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b13:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102b16:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102b19:	8b 00                	mov    (%eax),%eax
    		to_del_prev = list_prev(to_del);
c0102b1b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    		struct Page *page_to_del = le2page(to_del, page_link);
c0102b1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b21:	83 e8 0c             	sub    $0xc,%eax
c0102b24:	89 45 dc             	mov    %eax,-0x24(%ebp)
    		SetPageReserved(page_to_del);
c0102b27:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b2a:	83 c0 04             	add    $0x4,%eax
c0102b2d:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
c0102b34:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102b37:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102b3a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102b3d:	0f ab 10             	bts    %edx,(%eax)
    		ClearPageProperty(page_to_del);
c0102b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102b43:	83 c0 04             	add    $0x4,%eax
c0102b46:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0102b4d:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b50:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b53:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b56:	0f b3 10             	btr    %edx,(%eax)
c0102b59:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102b5c:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102b5f:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102b62:	8b 40 04             	mov    0x4(%eax),%eax
c0102b65:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b68:	8b 12                	mov    (%edx),%edx
c0102b6a:	89 55 b8             	mov    %edx,-0x48(%ebp)
c0102b6d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102b70:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b73:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0102b76:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102b79:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b7c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102b7f:	89 10                	mov    %edx,(%eax)
    		list_del(to_del);
    		to_del = to_del_prev;
c0102b81:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102b84:	89 45 ec             	mov    %eax,-0x14(%ebp)
    }
    if (page != NULL) {
    	list_entry_t *to_del = &(page->page_link);
    	list_entry_t *to_del_prev;
    	int i = 0;
    	for(i = 0;i < n;i++) {
c0102b87:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0102b8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102b8e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102b91:	0f 82 79 ff ff ff    	jb     c0102b10 <default_alloc_pages+0xaa>
    		ClearPageProperty(page_to_del);
    		list_del(to_del);
    		to_del = to_del_prev;
    	}
        //list_del(&(page->page_link));
        if (page->property > n) {
c0102b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102b9a:	8b 40 08             	mov    0x8(%eax),%eax
c0102b9d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102ba0:	76 28                	jbe    c0102bca <default_alloc_pages+0x164>
            struct Page *p = page + n;
c0102ba2:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ba5:	89 d0                	mov    %edx,%eax
c0102ba7:	c1 e0 02             	shl    $0x2,%eax
c0102baa:	01 d0                	add    %edx,%eax
c0102bac:	c1 e0 02             	shl    $0x2,%eax
c0102baf:	89 c2                	mov    %eax,%edx
c0102bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bb4:	01 d0                	add    %edx,%eax
c0102bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
            p->property = page->property - n;
c0102bb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bbc:	8b 40 08             	mov    0x8(%eax),%eax
c0102bbf:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bc2:	89 c2                	mov    %eax,%edx
c0102bc4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102bc7:	89 50 08             	mov    %edx,0x8(%eax)
            //list_add(&free_list, &(p->page_link));
        }
        nr_free -= n;
c0102bca:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0102bcf:	2b 45 08             	sub    0x8(%ebp),%eax
c0102bd2:	a3 58 89 11 c0       	mov    %eax,0xc0118958
        //ClearPageProperty(page);
    }
    return page;
c0102bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102bda:	c9                   	leave  
c0102bdb:	c3                   	ret    

c0102bdc <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102bdc:	55                   	push   %ebp
c0102bdd:	89 e5                	mov    %esp,%ebp
c0102bdf:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0102be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102be6:	75 24                	jne    c0102c0c <default_free_pages+0x30>
c0102be8:	c7 44 24 0c 90 66 10 	movl   $0xc0106690,0xc(%esp)
c0102bef:	c0 
c0102bf0:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102bf7:	c0 
c0102bf8:	c7 44 24 04 7e 00 00 	movl   $0x7e,0x4(%esp)
c0102bff:	00 
c0102c00:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102c07:	e8 c1 e0 ff ff       	call   c0100ccd <__panic>
    struct Page *p = base;
c0102c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c0102c12:	eb 21                	jmp    c0102c35 <default_free_pages+0x59>
        //assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
c0102c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0102c1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102c25:	00 
c0102c26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102c29:	89 04 24             	mov    %eax,(%esp)
c0102c2c:	e8 9d fc ff ff       	call   c01028ce <set_page_ref>

static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c0102c31:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102c35:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c38:	89 d0                	mov    %edx,%eax
c0102c3a:	c1 e0 02             	shl    $0x2,%eax
c0102c3d:	01 d0                	add    %edx,%eax
c0102c3f:	c1 e0 02             	shl    $0x2,%eax
c0102c42:	89 c2                	mov    %eax,%edx
c0102c44:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c47:	01 d0                	add    %edx,%eax
c0102c49:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102c4c:	75 c6                	jne    c0102c14 <default_free_pages+0x38>
        //assert(!PageReserved(p) && !PageProperty(p));
        p->flags = 0;
        set_page_ref(p, 0);
    }
    base->property = n;
c0102c4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c51:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102c54:	89 50 08             	mov    %edx,0x8(%eax)
    ClearPageReserved(base);
c0102c57:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c5a:	83 c0 04             	add    $0x4,%eax
c0102c5d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0102c64:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0102c67:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c6a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0102c6d:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0102c73:	83 c0 04             	add    $0x4,%eax
c0102c76:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0102c7d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102c80:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102c83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102c86:	0f ab 10             	bts    %edx,(%eax)
c0102c89:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102c90:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c93:	8b 00                	mov    (%eax),%eax
    list_entry_t *le = list_prev(&free_list);
c0102c95:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0102c98:	eb 21                	jmp    c0102cbb <default_free_pages+0xdf>
        p = le2page(le, page_link);
c0102c9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c9d:	83 e8 0c             	sub    $0xc,%eax
c0102ca0:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (base < p) {
c0102ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ca6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ca9:	73 02                	jae    c0102cad <default_free_pages+0xd1>
        			le = list_next(le);
        			p = le2page(le, page_link);
        		}
        	}  */
//pay attention to the situation when all the pages have been allocated and the list is empty
        	break;
c0102cab:	eb 17                	jmp    c0102cc4 <default_free_pages+0xe8>
c0102cad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cb0:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102cb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102cb6:	8b 00                	mov    (%eax),%eax
//            p->property += base->property;
//            ClearPageProperty(base);
//            base = p;
//            list_del(&(p->page_link));
//        }
        le = list_prev(le);
c0102cb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    base->property = n;
    ClearPageReserved(base);
    SetPageProperty(base);
    list_entry_t *le = list_prev(&free_list);
    while (le != &free_list) {
c0102cbb:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102cc2:	75 d6                	jne    c0102c9a <default_free_pages+0xbe>
//            base = p;
//            list_del(&(p->page_link));
//        }
        le = list_prev(le);
    }
    p = le2page(le, page_link);
c0102cc4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102cc7:	83 e8 0c             	sub    $0xc,%eax
c0102cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (base + n == p) {
c0102ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102cd0:	89 d0                	mov    %edx,%eax
c0102cd2:	c1 e0 02             	shl    $0x2,%eax
c0102cd5:	01 d0                	add    %edx,%eax
c0102cd7:	c1 e0 02             	shl    $0x2,%eax
c0102cda:	89 c2                	mov    %eax,%edx
c0102cdc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cdf:	01 d0                	add    %edx,%eax
c0102ce1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ce4:	75 1e                	jne    c0102d04 <default_free_pages+0x128>
		base->property += p->property;
c0102ce6:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ce9:	8b 50 08             	mov    0x8(%eax),%edx
c0102cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cef:	8b 40 08             	mov    0x8(%eax),%eax
c0102cf2:	01 c2                	add    %eax,%edx
c0102cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102cf7:	89 50 08             	mov    %edx,0x8(%eax)
		p->property = 0;
c0102cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cfd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	}
	for(p = base;p < base + n;p++) {
c0102d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d07:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102d0a:	eb 58                	jmp    c0102d64 <default_free_pages+0x188>
		list_add(le, &(p->page_link));
c0102d0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d0f:	8d 50 0c             	lea    0xc(%eax),%edx
c0102d12:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d15:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102d18:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0102d1b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102d1e:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0102d21:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102d24:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102d27:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102d2a:	8b 40 04             	mov    0x4(%eax),%eax
c0102d2d:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102d30:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0102d33:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102d36:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102d39:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102d3c:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d3f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102d42:	89 10                	mov    %edx,(%eax)
c0102d44:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d47:	8b 10                	mov    (%eax),%edx
c0102d49:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d4c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d4f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d52:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102d55:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d58:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d5b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102d5e:	89 10                	mov    %edx,(%eax)
    p = le2page(le, page_link);
	if (base + n == p) {
		base->property += p->property;
		p->property = 0;
	}
	for(p = base;p < base + n;p++) {
c0102d60:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102d64:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102d67:	89 d0                	mov    %edx,%eax
c0102d69:	c1 e0 02             	shl    $0x2,%eax
c0102d6c:	01 d0                	add    %edx,%eax
c0102d6e:	c1 e0 02             	shl    $0x2,%eax
c0102d71:	89 c2                	mov    %eax,%edx
c0102d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d76:	01 d0                	add    %edx,%eax
c0102d78:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102d7b:	77 8f                	ja     c0102d0c <default_free_pages+0x130>
		list_add(le, &(p->page_link));
	}
	le = list_next(&(base->page_link));
c0102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102d80:	83 c0 0c             	add    $0xc,%eax
c0102d83:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102d86:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102d89:	8b 40 04             	mov    0x4(%eax),%eax
c0102d8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	p = le2page(le, page_link);
c0102d8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d92:	83 e8 0c             	sub    $0xc,%eax
c0102d95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	if (le != &free_list && p == base - 1) {
c0102d98:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102d9f:	74 58                	je     c0102df9 <default_free_pages+0x21d>
c0102da1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102da4:	83 e8 14             	sub    $0x14,%eax
c0102da7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102daa:	75 4d                	jne    c0102df9 <default_free_pages+0x21d>
		while (le != &free_list) {
c0102dac:	eb 42                	jmp    c0102df0 <default_free_pages+0x214>
			if (p->property) {
c0102dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102db1:	8b 40 08             	mov    0x8(%eax),%eax
c0102db4:	85 c0                	test   %eax,%eax
c0102db6:	74 20                	je     c0102dd8 <default_free_pages+0x1fc>
				p->property += base->property;
c0102db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dbb:	8b 50 08             	mov    0x8(%eax),%edx
c0102dbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dc1:	8b 40 08             	mov    0x8(%eax),%eax
c0102dc4:	01 c2                	add    %eax,%edx
c0102dc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102dc9:	89 50 08             	mov    %edx,0x8(%eax)
				base->property = 0;
c0102dcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0102dcf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
				break;
c0102dd6:	eb 21                	jmp    c0102df9 <default_free_pages+0x21d>
c0102dd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102ddb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102dde:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102de1:	8b 40 04             	mov    0x4(%eax),%eax
			}
			le = list_next(le);
c0102de4:	89 45 f0             	mov    %eax,-0x10(%ebp)
			p = le2page(le, page_link);
c0102de7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102dea:	83 e8 0c             	sub    $0xc,%eax
c0102ded:	89 45 f4             	mov    %eax,-0xc(%ebp)
		list_add(le, &(p->page_link));
	}
	le = list_next(&(base->page_link));
	p = le2page(le, page_link);
	if (le != &free_list && p == base - 1) {
		while (le != &free_list) {
c0102df0:	81 7d f0 50 89 11 c0 	cmpl   $0xc0118950,-0x10(%ebp)
c0102df7:	75 b5                	jne    c0102dae <default_free_pages+0x1d2>
			}
			le = list_next(le);
			p = le2page(le, page_link);
		}
	}
    nr_free += n;
c0102df9:	8b 15 58 89 11 c0    	mov    0xc0118958,%edx
c0102dff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102e02:	01 d0                	add    %edx,%eax
c0102e04:	a3 58 89 11 c0       	mov    %eax,0xc0118958
//    cprintf("%d\n", le2page(list_prev(&free_list), page_link)->property);
//    list_add(&free_list, &(base->page_link));
}
c0102e09:	c9                   	leave  
c0102e0a:	c3                   	ret    

c0102e0b <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0102e0b:	55                   	push   %ebp
c0102e0c:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0102e0e:	a1 58 89 11 c0       	mov    0xc0118958,%eax
}
c0102e13:	5d                   	pop    %ebp
c0102e14:	c3                   	ret    

c0102e15 <basic_check>:

static void
basic_check(void) {
c0102e15:	55                   	push   %ebp
c0102e16:	89 e5                	mov    %esp,%ebp
c0102e18:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0102e1b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0102e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e25:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102e2b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0102e2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e35:	e8 85 0e 00 00       	call   c0103cbf <alloc_pages>
c0102e3a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102e3d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0102e41:	75 24                	jne    c0102e67 <basic_check+0x52>
c0102e43:	c7 44 24 0c d1 66 10 	movl   $0xc01066d1,0xc(%esp)
c0102e4a:	c0 
c0102e4b:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102e52:	c0 
c0102e53:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0102e5a:	00 
c0102e5b:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102e62:	e8 66 de ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
c0102e67:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102e6e:	e8 4c 0e 00 00       	call   c0103cbf <alloc_pages>
c0102e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102e76:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102e7a:	75 24                	jne    c0102ea0 <basic_check+0x8b>
c0102e7c:	c7 44 24 0c ed 66 10 	movl   $0xc01066ed,0xc(%esp)
c0102e83:	c0 
c0102e84:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102e8b:	c0 
c0102e8c:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0102e93:	00 
c0102e94:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102e9b:	e8 2d de ff ff       	call   c0100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
c0102ea0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0102ea7:	e8 13 0e 00 00       	call   c0103cbf <alloc_pages>
c0102eac:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102eaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102eb3:	75 24                	jne    c0102ed9 <basic_check+0xc4>
c0102eb5:	c7 44 24 0c 09 67 10 	movl   $0xc0106709,0xc(%esp)
c0102ebc:	c0 
c0102ebd:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102ec4:	c0 
c0102ec5:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0102ecc:	00 
c0102ecd:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102ed4:	e8 f4 dd ff ff       	call   c0100ccd <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0102ed9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102edc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0102edf:	74 10                	je     c0102ef1 <basic_check+0xdc>
c0102ee1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ee4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102ee7:	74 08                	je     c0102ef1 <basic_check+0xdc>
c0102ee9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102eec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102eef:	75 24                	jne    c0102f15 <basic_check+0x100>
c0102ef1:	c7 44 24 0c 28 67 10 	movl   $0xc0106728,0xc(%esp)
c0102ef8:	c0 
c0102ef9:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102f00:	c0 
c0102f01:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0102f08:	00 
c0102f09:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102f10:	e8 b8 dd ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0102f15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f18:	89 04 24             	mov    %eax,(%esp)
c0102f1b:	e8 a4 f9 ff ff       	call   c01028c4 <page_ref>
c0102f20:	85 c0                	test   %eax,%eax
c0102f22:	75 1e                	jne    c0102f42 <basic_check+0x12d>
c0102f24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f27:	89 04 24             	mov    %eax,(%esp)
c0102f2a:	e8 95 f9 ff ff       	call   c01028c4 <page_ref>
c0102f2f:	85 c0                	test   %eax,%eax
c0102f31:	75 0f                	jne    c0102f42 <basic_check+0x12d>
c0102f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102f36:	89 04 24             	mov    %eax,(%esp)
c0102f39:	e8 86 f9 ff ff       	call   c01028c4 <page_ref>
c0102f3e:	85 c0                	test   %eax,%eax
c0102f40:	74 24                	je     c0102f66 <basic_check+0x151>
c0102f42:	c7 44 24 0c 4c 67 10 	movl   $0xc010674c,0xc(%esp)
c0102f49:	c0 
c0102f4a:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102f51:	c0 
c0102f52:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0102f59:	00 
c0102f5a:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102f61:	e8 67 dd ff ff       	call   c0100ccd <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0102f66:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f69:	89 04 24             	mov    %eax,(%esp)
c0102f6c:	e8 3d f9 ff ff       	call   c01028ae <page2pa>
c0102f71:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102f77:	c1 e2 0c             	shl    $0xc,%edx
c0102f7a:	39 d0                	cmp    %edx,%eax
c0102f7c:	72 24                	jb     c0102fa2 <basic_check+0x18d>
c0102f7e:	c7 44 24 0c 88 67 10 	movl   $0xc0106788,0xc(%esp)
c0102f85:	c0 
c0102f86:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102f8d:	c0 
c0102f8e:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102f95:	00 
c0102f96:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102f9d:	e8 2b dd ff ff       	call   c0100ccd <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0102fa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102fa5:	89 04 24             	mov    %eax,(%esp)
c0102fa8:	e8 01 f9 ff ff       	call   c01028ae <page2pa>
c0102fad:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fb3:	c1 e2 0c             	shl    $0xc,%edx
c0102fb6:	39 d0                	cmp    %edx,%eax
c0102fb8:	72 24                	jb     c0102fde <basic_check+0x1c9>
c0102fba:	c7 44 24 0c a5 67 10 	movl   $0xc01067a5,0xc(%esp)
c0102fc1:	c0 
c0102fc2:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0102fc9:	c0 
c0102fca:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0102fd1:	00 
c0102fd2:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0102fd9:	e8 ef dc ff ff       	call   c0100ccd <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0102fde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102fe1:	89 04 24             	mov    %eax,(%esp)
c0102fe4:	e8 c5 f8 ff ff       	call   c01028ae <page2pa>
c0102fe9:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0102fef:	c1 e2 0c             	shl    $0xc,%edx
c0102ff2:	39 d0                	cmp    %edx,%eax
c0102ff4:	72 24                	jb     c010301a <basic_check+0x205>
c0102ff6:	c7 44 24 0c c2 67 10 	movl   $0xc01067c2,0xc(%esp)
c0102ffd:	c0 
c0102ffe:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103005:	c0 
c0103006:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010300d:	00 
c010300e:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103015:	e8 b3 dc ff ff       	call   c0100ccd <__panic>

    list_entry_t free_list_store = free_list;
c010301a:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c010301f:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c0103025:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103028:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010302b:	c7 45 e0 50 89 11 c0 	movl   $0xc0118950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103032:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103035:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103038:	89 50 04             	mov    %edx,0x4(%eax)
c010303b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010303e:	8b 50 04             	mov    0x4(%eax),%edx
c0103041:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103044:	89 10                	mov    %edx,(%eax)
c0103046:	c7 45 dc 50 89 11 c0 	movl   $0xc0118950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c010304d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103050:	8b 40 04             	mov    0x4(%eax),%eax
c0103053:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103056:	0f 94 c0             	sete   %al
c0103059:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010305c:	85 c0                	test   %eax,%eax
c010305e:	75 24                	jne    c0103084 <basic_check+0x26f>
c0103060:	c7 44 24 0c df 67 10 	movl   $0xc01067df,0xc(%esp)
c0103067:	c0 
c0103068:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010306f:	c0 
c0103070:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0103077:	00 
c0103078:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010307f:	e8 49 dc ff ff       	call   c0100ccd <__panic>

    unsigned int nr_free_store = nr_free;
c0103084:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103089:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c010308c:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103093:	00 00 00 

    assert(alloc_page() == NULL);
c0103096:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010309d:	e8 1d 0c 00 00       	call   c0103cbf <alloc_pages>
c01030a2:	85 c0                	test   %eax,%eax
c01030a4:	74 24                	je     c01030ca <basic_check+0x2b5>
c01030a6:	c7 44 24 0c f6 67 10 	movl   $0xc01067f6,0xc(%esp)
c01030ad:	c0 
c01030ae:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01030b5:	c0 
c01030b6:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01030bd:	00 
c01030be:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01030c5:	e8 03 dc ff ff       	call   c0100ccd <__panic>

    free_page(p0);
c01030ca:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030d1:	00 
c01030d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01030d5:	89 04 24             	mov    %eax,(%esp)
c01030d8:	e8 1a 0c 00 00       	call   c0103cf7 <free_pages>
    free_page(p1);
c01030dd:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030e4:	00 
c01030e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030e8:	89 04 24             	mov    %eax,(%esp)
c01030eb:	e8 07 0c 00 00       	call   c0103cf7 <free_pages>
    free_page(p2);
c01030f0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01030f7:	00 
c01030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030fb:	89 04 24             	mov    %eax,(%esp)
c01030fe:	e8 f4 0b 00 00       	call   c0103cf7 <free_pages>
    assert(nr_free == 3);
c0103103:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c0103108:	83 f8 03             	cmp    $0x3,%eax
c010310b:	74 24                	je     c0103131 <basic_check+0x31c>
c010310d:	c7 44 24 0c 0b 68 10 	movl   $0xc010680b,0xc(%esp)
c0103114:	c0 
c0103115:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010311c:	c0 
c010311d:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c0103124:	00 
c0103125:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010312c:	e8 9c db ff ff       	call   c0100ccd <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103131:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103138:	e8 82 0b 00 00       	call   c0103cbf <alloc_pages>
c010313d:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103140:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103144:	75 24                	jne    c010316a <basic_check+0x355>
c0103146:	c7 44 24 0c d1 66 10 	movl   $0xc01066d1,0xc(%esp)
c010314d:	c0 
c010314e:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103155:	c0 
c0103156:	c7 44 24 04 ee 00 00 	movl   $0xee,0x4(%esp)
c010315d:	00 
c010315e:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103165:	e8 63 db ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_page()) != NULL);
c010316a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103171:	e8 49 0b 00 00       	call   c0103cbf <alloc_pages>
c0103176:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103179:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010317d:	75 24                	jne    c01031a3 <basic_check+0x38e>
c010317f:	c7 44 24 0c ed 66 10 	movl   $0xc01066ed,0xc(%esp)
c0103186:	c0 
c0103187:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010318e:	c0 
c010318f:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103196:	00 
c0103197:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010319e:	e8 2a db ff ff       	call   c0100ccd <__panic>
    assert((p2 = alloc_page()) != NULL);
c01031a3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031aa:	e8 10 0b 00 00       	call   c0103cbf <alloc_pages>
c01031af:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01031b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01031b6:	75 24                	jne    c01031dc <basic_check+0x3c7>
c01031b8:	c7 44 24 0c 09 67 10 	movl   $0xc0106709,0xc(%esp)
c01031bf:	c0 
c01031c0:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01031c7:	c0 
c01031c8:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01031cf:	00 
c01031d0:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01031d7:	e8 f1 da ff ff       	call   c0100ccd <__panic>

    assert(alloc_page() == NULL);
c01031dc:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01031e3:	e8 d7 0a 00 00       	call   c0103cbf <alloc_pages>
c01031e8:	85 c0                	test   %eax,%eax
c01031ea:	74 24                	je     c0103210 <basic_check+0x3fb>
c01031ec:	c7 44 24 0c f6 67 10 	movl   $0xc01067f6,0xc(%esp)
c01031f3:	c0 
c01031f4:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01031fb:	c0 
c01031fc:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0103203:	00 
c0103204:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010320b:	e8 bd da ff ff       	call   c0100ccd <__panic>

    free_page(p0);
c0103210:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103217:	00 
c0103218:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010321b:	89 04 24             	mov    %eax,(%esp)
c010321e:	e8 d4 0a 00 00       	call   c0103cf7 <free_pages>
c0103223:	c7 45 d8 50 89 11 c0 	movl   $0xc0118950,-0x28(%ebp)
c010322a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010322d:	8b 40 04             	mov    0x4(%eax),%eax
c0103230:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103233:	0f 94 c0             	sete   %al
c0103236:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103239:	85 c0                	test   %eax,%eax
c010323b:	74 24                	je     c0103261 <basic_check+0x44c>
c010323d:	c7 44 24 0c 18 68 10 	movl   $0xc0106818,0xc(%esp)
c0103244:	c0 
c0103245:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010324c:	c0 
c010324d:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103254:	00 
c0103255:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010325c:	e8 6c da ff ff       	call   c0100ccd <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103261:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103268:	e8 52 0a 00 00       	call   c0103cbf <alloc_pages>
c010326d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103270:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103273:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103276:	74 24                	je     c010329c <basic_check+0x487>
c0103278:	c7 44 24 0c 30 68 10 	movl   $0xc0106830,0xc(%esp)
c010327f:	c0 
c0103280:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103287:	c0 
c0103288:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010328f:	00 
c0103290:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103297:	e8 31 da ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c010329c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01032a3:	e8 17 0a 00 00       	call   c0103cbf <alloc_pages>
c01032a8:	85 c0                	test   %eax,%eax
c01032aa:	74 24                	je     c01032d0 <basic_check+0x4bb>
c01032ac:	c7 44 24 0c f6 67 10 	movl   $0xc01067f6,0xc(%esp)
c01032b3:	c0 
c01032b4:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01032bb:	c0 
c01032bc:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01032c3:	00 
c01032c4:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01032cb:	e8 fd d9 ff ff       	call   c0100ccd <__panic>

    assert(nr_free == 0);
c01032d0:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01032d5:	85 c0                	test   %eax,%eax
c01032d7:	74 24                	je     c01032fd <basic_check+0x4e8>
c01032d9:	c7 44 24 0c 49 68 10 	movl   $0xc0106849,0xc(%esp)
c01032e0:	c0 
c01032e1:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01032e8:	c0 
c01032e9:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01032f0:	00 
c01032f1:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01032f8:	e8 d0 d9 ff ff       	call   c0100ccd <__panic>
    free_list = free_list_store;
c01032fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103300:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103303:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c0103308:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    nr_free = nr_free_store;
c010330e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103311:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_page(p);
c0103316:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010331d:	00 
c010331e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103321:	89 04 24             	mov    %eax,(%esp)
c0103324:	e8 ce 09 00 00       	call   c0103cf7 <free_pages>
    free_page(p1);
c0103329:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103330:	00 
c0103331:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103334:	89 04 24             	mov    %eax,(%esp)
c0103337:	e8 bb 09 00 00       	call   c0103cf7 <free_pages>
    free_page(p2);
c010333c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103343:	00 
c0103344:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103347:	89 04 24             	mov    %eax,(%esp)
c010334a:	e8 a8 09 00 00       	call   c0103cf7 <free_pages>
}
c010334f:	c9                   	leave  
c0103350:	c3                   	ret    

c0103351 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103351:	55                   	push   %ebp
c0103352:	89 e5                	mov    %esp,%ebp
c0103354:	53                   	push   %ebx
c0103355:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010335b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103362:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103369:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103370:	eb 6b                	jmp    c01033dd <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103372:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103375:	83 e8 0c             	sub    $0xc,%eax
c0103378:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010337b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010337e:	83 c0 04             	add    $0x4,%eax
c0103381:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103388:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010338b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010338e:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103391:	0f a3 10             	bt     %edx,(%eax)
c0103394:	19 c0                	sbb    %eax,%eax
c0103396:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0103399:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010339d:	0f 95 c0             	setne  %al
c01033a0:	0f b6 c0             	movzbl %al,%eax
c01033a3:	85 c0                	test   %eax,%eax
c01033a5:	75 24                	jne    c01033cb <default_check+0x7a>
c01033a7:	c7 44 24 0c 56 68 10 	movl   $0xc0106856,0xc(%esp)
c01033ae:	c0 
c01033af:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01033b6:	c0 
c01033b7:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01033be:	00 
c01033bf:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01033c6:	e8 02 d9 ff ff       	call   c0100ccd <__panic>
        count ++, total += p->property;
c01033cb:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01033cf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01033d2:	8b 50 08             	mov    0x8(%eax),%edx
c01033d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033d8:	01 d0                	add    %edx,%eax
c01033da:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01033dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033e0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01033e3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01033e6:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01033e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033ec:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c01033f3:	0f 85 79 ff ff ff    	jne    c0103372 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c01033f9:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c01033fc:	e8 28 09 00 00       	call   c0103d29 <nr_free_pages>
c0103401:	39 c3                	cmp    %eax,%ebx
c0103403:	74 24                	je     c0103429 <default_check+0xd8>
c0103405:	c7 44 24 0c 66 68 10 	movl   $0xc0106866,0xc(%esp)
c010340c:	c0 
c010340d:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103414:	c0 
c0103415:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c010341c:	00 
c010341d:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103424:	e8 a4 d8 ff ff       	call   c0100ccd <__panic>

    basic_check();
c0103429:	e8 e7 f9 ff ff       	call   c0102e15 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010342e:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103435:	e8 85 08 00 00       	call   c0103cbf <alloc_pages>
c010343a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010343d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103441:	75 24                	jne    c0103467 <default_check+0x116>
c0103443:	c7 44 24 0c 7f 68 10 	movl   $0xc010687f,0xc(%esp)
c010344a:	c0 
c010344b:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103452:	c0 
c0103453:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c010345a:	00 
c010345b:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103462:	e8 66 d8 ff ff       	call   c0100ccd <__panic>
    assert(!PageProperty(p0));
c0103467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010346a:	83 c0 04             	add    $0x4,%eax
c010346d:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103474:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103477:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010347a:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010347d:	0f a3 10             	bt     %edx,(%eax)
c0103480:	19 c0                	sbb    %eax,%eax
c0103482:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0103485:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103489:	0f 95 c0             	setne  %al
c010348c:	0f b6 c0             	movzbl %al,%eax
c010348f:	85 c0                	test   %eax,%eax
c0103491:	74 24                	je     c01034b7 <default_check+0x166>
c0103493:	c7 44 24 0c 8a 68 10 	movl   $0xc010688a,0xc(%esp)
c010349a:	c0 
c010349b:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01034a2:	c0 
c01034a3:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01034aa:	00 
c01034ab:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01034b2:	e8 16 d8 ff ff       	call   c0100ccd <__panic>

    list_entry_t free_list_store = free_list;
c01034b7:	a1 50 89 11 c0       	mov    0xc0118950,%eax
c01034bc:	8b 15 54 89 11 c0    	mov    0xc0118954,%edx
c01034c2:	89 45 80             	mov    %eax,-0x80(%ebp)
c01034c5:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01034c8:	c7 45 b4 50 89 11 c0 	movl   $0xc0118950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01034cf:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034d2:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01034d5:	89 50 04             	mov    %edx,0x4(%eax)
c01034d8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034db:	8b 50 04             	mov    0x4(%eax),%edx
c01034de:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01034e1:	89 10                	mov    %edx,(%eax)
c01034e3:	c7 45 b0 50 89 11 c0 	movl   $0xc0118950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01034ea:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01034ed:	8b 40 04             	mov    0x4(%eax),%eax
c01034f0:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c01034f3:	0f 94 c0             	sete   %al
c01034f6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01034f9:	85 c0                	test   %eax,%eax
c01034fb:	75 24                	jne    c0103521 <default_check+0x1d0>
c01034fd:	c7 44 24 0c df 67 10 	movl   $0xc01067df,0xc(%esp)
c0103504:	c0 
c0103505:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010350c:	c0 
c010350d:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c0103514:	00 
c0103515:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010351c:	e8 ac d7 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c0103521:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103528:	e8 92 07 00 00       	call   c0103cbf <alloc_pages>
c010352d:	85 c0                	test   %eax,%eax
c010352f:	74 24                	je     c0103555 <default_check+0x204>
c0103531:	c7 44 24 0c f6 67 10 	movl   $0xc01067f6,0xc(%esp)
c0103538:	c0 
c0103539:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103540:	c0 
c0103541:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0103548:	00 
c0103549:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103550:	e8 78 d7 ff ff       	call   c0100ccd <__panic>

    unsigned int nr_free_store = nr_free;
c0103555:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c010355a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010355d:	c7 05 58 89 11 c0 00 	movl   $0x0,0xc0118958
c0103564:	00 00 00 

    free_pages(p0 + 2, 3);
c0103567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010356a:	83 c0 28             	add    $0x28,%eax
c010356d:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103574:	00 
c0103575:	89 04 24             	mov    %eax,(%esp)
c0103578:	e8 7a 07 00 00       	call   c0103cf7 <free_pages>
    assert(alloc_pages(4) == NULL);
c010357d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103584:	e8 36 07 00 00       	call   c0103cbf <alloc_pages>
c0103589:	85 c0                	test   %eax,%eax
c010358b:	74 24                	je     c01035b1 <default_check+0x260>
c010358d:	c7 44 24 0c 9c 68 10 	movl   $0xc010689c,0xc(%esp)
c0103594:	c0 
c0103595:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010359c:	c0 
c010359d:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c01035a4:	00 
c01035a5:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01035ac:	e8 1c d7 ff ff       	call   c0100ccd <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01035b1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035b4:	83 c0 28             	add    $0x28,%eax
c01035b7:	83 c0 04             	add    $0x4,%eax
c01035ba:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01035c1:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01035c4:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01035c7:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01035ca:	0f a3 10             	bt     %edx,(%eax)
c01035cd:	19 c0                	sbb    %eax,%eax
c01035cf:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c01035d2:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01035d6:	0f 95 c0             	setne  %al
c01035d9:	0f b6 c0             	movzbl %al,%eax
c01035dc:	85 c0                	test   %eax,%eax
c01035de:	74 0e                	je     c01035ee <default_check+0x29d>
c01035e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035e3:	83 c0 28             	add    $0x28,%eax
c01035e6:	8b 40 08             	mov    0x8(%eax),%eax
c01035e9:	83 f8 03             	cmp    $0x3,%eax
c01035ec:	74 24                	je     c0103612 <default_check+0x2c1>
c01035ee:	c7 44 24 0c b4 68 10 	movl   $0xc01068b4,0xc(%esp)
c01035f5:	c0 
c01035f6:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01035fd:	c0 
c01035fe:	c7 44 24 04 21 01 00 	movl   $0x121,0x4(%esp)
c0103605:	00 
c0103606:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010360d:	e8 bb d6 ff ff       	call   c0100ccd <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0103612:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c0103619:	e8 a1 06 00 00       	call   c0103cbf <alloc_pages>
c010361e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103621:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103625:	75 24                	jne    c010364b <default_check+0x2fa>
c0103627:	c7 44 24 0c e0 68 10 	movl   $0xc01068e0,0xc(%esp)
c010362e:	c0 
c010362f:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103636:	c0 
c0103637:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c010363e:	00 
c010363f:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103646:	e8 82 d6 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c010364b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103652:	e8 68 06 00 00       	call   c0103cbf <alloc_pages>
c0103657:	85 c0                	test   %eax,%eax
c0103659:	74 24                	je     c010367f <default_check+0x32e>
c010365b:	c7 44 24 0c f6 67 10 	movl   $0xc01067f6,0xc(%esp)
c0103662:	c0 
c0103663:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010366a:	c0 
c010366b:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0103672:	00 
c0103673:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010367a:	e8 4e d6 ff ff       	call   c0100ccd <__panic>
    assert(p0 + 2 == p1);
c010367f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103682:	83 c0 28             	add    $0x28,%eax
c0103685:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103688:	74 24                	je     c01036ae <default_check+0x35d>
c010368a:	c7 44 24 0c fe 68 10 	movl   $0xc01068fe,0xc(%esp)
c0103691:	c0 
c0103692:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103699:	c0 
c010369a:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01036a1:	00 
c01036a2:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01036a9:	e8 1f d6 ff ff       	call   c0100ccd <__panic>

    p2 = p0 + 1;
c01036ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036b1:	83 c0 14             	add    $0x14,%eax
c01036b4:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01036b7:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01036be:	00 
c01036bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036c2:	89 04 24             	mov    %eax,(%esp)
c01036c5:	e8 2d 06 00 00       	call   c0103cf7 <free_pages>
    free_pages(p1, 3);
c01036ca:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01036d1:	00 
c01036d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01036d5:	89 04 24             	mov    %eax,(%esp)
c01036d8:	e8 1a 06 00 00       	call   c0103cf7 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01036dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036e0:	83 c0 04             	add    $0x4,%eax
c01036e3:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01036ea:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036ed:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01036f0:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01036f3:	0f a3 10             	bt     %edx,(%eax)
c01036f6:	19 c0                	sbb    %eax,%eax
c01036f8:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01036fb:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c01036ff:	0f 95 c0             	setne  %al
c0103702:	0f b6 c0             	movzbl %al,%eax
c0103705:	85 c0                	test   %eax,%eax
c0103707:	74 0b                	je     c0103714 <default_check+0x3c3>
c0103709:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010370c:	8b 40 08             	mov    0x8(%eax),%eax
c010370f:	83 f8 01             	cmp    $0x1,%eax
c0103712:	74 24                	je     c0103738 <default_check+0x3e7>
c0103714:	c7 44 24 0c 0c 69 10 	movl   $0xc010690c,0xc(%esp)
c010371b:	c0 
c010371c:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103723:	c0 
c0103724:	c7 44 24 04 29 01 00 	movl   $0x129,0x4(%esp)
c010372b:	00 
c010372c:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103733:	e8 95 d5 ff ff       	call   c0100ccd <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0103738:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010373b:	83 c0 04             	add    $0x4,%eax
c010373e:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0103745:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103748:	8b 45 90             	mov    -0x70(%ebp),%eax
c010374b:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010374e:	0f a3 10             	bt     %edx,(%eax)
c0103751:	19 c0                	sbb    %eax,%eax
c0103753:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0103756:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010375a:	0f 95 c0             	setne  %al
c010375d:	0f b6 c0             	movzbl %al,%eax
c0103760:	85 c0                	test   %eax,%eax
c0103762:	74 0b                	je     c010376f <default_check+0x41e>
c0103764:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103767:	8b 40 08             	mov    0x8(%eax),%eax
c010376a:	83 f8 03             	cmp    $0x3,%eax
c010376d:	74 24                	je     c0103793 <default_check+0x442>
c010376f:	c7 44 24 0c 34 69 10 	movl   $0xc0106934,0xc(%esp)
c0103776:	c0 
c0103777:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010377e:	c0 
c010377f:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0103786:	00 
c0103787:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010378e:	e8 3a d5 ff ff       	call   c0100ccd <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103793:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010379a:	e8 20 05 00 00       	call   c0103cbf <alloc_pages>
c010379f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037a5:	83 e8 14             	sub    $0x14,%eax
c01037a8:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037ab:	74 24                	je     c01037d1 <default_check+0x480>
c01037ad:	c7 44 24 0c 5a 69 10 	movl   $0xc010695a,0xc(%esp)
c01037b4:	c0 
c01037b5:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01037bc:	c0 
c01037bd:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01037c4:	00 
c01037c5:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01037cc:	e8 fc d4 ff ff       	call   c0100ccd <__panic>
    free_page(p0);
c01037d1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01037d8:	00 
c01037d9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037dc:	89 04 24             	mov    %eax,(%esp)
c01037df:	e8 13 05 00 00       	call   c0103cf7 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01037e4:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01037eb:	e8 cf 04 00 00       	call   c0103cbf <alloc_pages>
c01037f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01037f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01037f6:	83 c0 14             	add    $0x14,%eax
c01037f9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01037fc:	74 24                	je     c0103822 <default_check+0x4d1>
c01037fe:	c7 44 24 0c 78 69 10 	movl   $0xc0106978,0xc(%esp)
c0103805:	c0 
c0103806:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010380d:	c0 
c010380e:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0103815:	00 
c0103816:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010381d:	e8 ab d4 ff ff       	call   c0100ccd <__panic>

    free_pages(p0, 2);
c0103822:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103829:	00 
c010382a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010382d:	89 04 24             	mov    %eax,(%esp)
c0103830:	e8 c2 04 00 00       	call   c0103cf7 <free_pages>
    free_page(p2);
c0103835:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010383c:	00 
c010383d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103840:	89 04 24             	mov    %eax,(%esp)
c0103843:	e8 af 04 00 00       	call   c0103cf7 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103848:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c010384f:	e8 6b 04 00 00       	call   c0103cbf <alloc_pages>
c0103854:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103857:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010385b:	75 24                	jne    c0103881 <default_check+0x530>
c010385d:	c7 44 24 0c 98 69 10 	movl   $0xc0106998,0xc(%esp)
c0103864:	c0 
c0103865:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010386c:	c0 
c010386d:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c0103874:	00 
c0103875:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010387c:	e8 4c d4 ff ff       	call   c0100ccd <__panic>
    assert(alloc_page() == NULL);
c0103881:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103888:	e8 32 04 00 00       	call   c0103cbf <alloc_pages>
c010388d:	85 c0                	test   %eax,%eax
c010388f:	74 24                	je     c01038b5 <default_check+0x564>
c0103891:	c7 44 24 0c f6 67 10 	movl   $0xc01067f6,0xc(%esp)
c0103898:	c0 
c0103899:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01038a0:	c0 
c01038a1:	c7 44 24 04 34 01 00 	movl   $0x134,0x4(%esp)
c01038a8:	00 
c01038a9:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01038b0:	e8 18 d4 ff ff       	call   c0100ccd <__panic>

    assert(nr_free == 0);
c01038b5:	a1 58 89 11 c0       	mov    0xc0118958,%eax
c01038ba:	85 c0                	test   %eax,%eax
c01038bc:	74 24                	je     c01038e2 <default_check+0x591>
c01038be:	c7 44 24 0c 49 68 10 	movl   $0xc0106849,0xc(%esp)
c01038c5:	c0 
c01038c6:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c01038cd:	c0 
c01038ce:	c7 44 24 04 36 01 00 	movl   $0x136,0x4(%esp)
c01038d5:	00 
c01038d6:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c01038dd:	e8 eb d3 ff ff       	call   c0100ccd <__panic>
    nr_free = nr_free_store;
c01038e2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01038e5:	a3 58 89 11 c0       	mov    %eax,0xc0118958

    free_list = free_list_store;
c01038ea:	8b 45 80             	mov    -0x80(%ebp),%eax
c01038ed:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01038f0:	a3 50 89 11 c0       	mov    %eax,0xc0118950
c01038f5:	89 15 54 89 11 c0    	mov    %edx,0xc0118954
    free_pages(p0, 5);
c01038fb:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103902:	00 
c0103903:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103906:	89 04 24             	mov    %eax,(%esp)
c0103909:	e8 e9 03 00 00       	call   c0103cf7 <free_pages>

    le = &free_list;
c010390e:	c7 45 ec 50 89 11 c0 	movl   $0xc0118950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103915:	eb 1d                	jmp    c0103934 <default_check+0x5e3>
        struct Page *p = le2page(le, page_link);
c0103917:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010391a:	83 e8 0c             	sub    $0xc,%eax
c010391d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103920:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103924:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103927:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010392a:	8b 40 08             	mov    0x8(%eax),%eax
c010392d:	29 c2                	sub    %eax,%edx
c010392f:	89 d0                	mov    %edx,%eax
c0103931:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103934:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103937:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010393a:	8b 45 88             	mov    -0x78(%ebp),%eax
c010393d:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103940:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103943:	81 7d ec 50 89 11 c0 	cmpl   $0xc0118950,-0x14(%ebp)
c010394a:	75 cb                	jne    c0103917 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010394c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103950:	74 24                	je     c0103976 <default_check+0x625>
c0103952:	c7 44 24 0c b6 69 10 	movl   $0xc01069b6,0xc(%esp)
c0103959:	c0 
c010395a:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c0103961:	c0 
c0103962:	c7 44 24 04 41 01 00 	movl   $0x141,0x4(%esp)
c0103969:	00 
c010396a:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c0103971:	e8 57 d3 ff ff       	call   c0100ccd <__panic>
    assert(total == 0);
c0103976:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010397a:	74 24                	je     c01039a0 <default_check+0x64f>
c010397c:	c7 44 24 0c c1 69 10 	movl   $0xc01069c1,0xc(%esp)
c0103983:	c0 
c0103984:	c7 44 24 08 96 66 10 	movl   $0xc0106696,0x8(%esp)
c010398b:	c0 
c010398c:	c7 44 24 04 42 01 00 	movl   $0x142,0x4(%esp)
c0103993:	00 
c0103994:	c7 04 24 ab 66 10 c0 	movl   $0xc01066ab,(%esp)
c010399b:	e8 2d d3 ff ff       	call   c0100ccd <__panic>
}
c01039a0:	81 c4 94 00 00 00    	add    $0x94,%esp
c01039a6:	5b                   	pop    %ebx
c01039a7:	5d                   	pop    %ebp
c01039a8:	c3                   	ret    

c01039a9 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01039a9:	55                   	push   %ebp
c01039aa:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01039ac:	8b 55 08             	mov    0x8(%ebp),%edx
c01039af:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c01039b4:	29 c2                	sub    %eax,%edx
c01039b6:	89 d0                	mov    %edx,%eax
c01039b8:	c1 f8 02             	sar    $0x2,%eax
c01039bb:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c01039c1:	5d                   	pop    %ebp
c01039c2:	c3                   	ret    

c01039c3 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01039c3:	55                   	push   %ebp
c01039c4:	89 e5                	mov    %esp,%ebp
c01039c6:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01039c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01039cc:	89 04 24             	mov    %eax,(%esp)
c01039cf:	e8 d5 ff ff ff       	call   c01039a9 <page2ppn>
c01039d4:	c1 e0 0c             	shl    $0xc,%eax
}
c01039d7:	c9                   	leave  
c01039d8:	c3                   	ret    

c01039d9 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01039d9:	55                   	push   %ebp
c01039da:	89 e5                	mov    %esp,%ebp
c01039dc:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01039df:	8b 45 08             	mov    0x8(%ebp),%eax
c01039e2:	c1 e8 0c             	shr    $0xc,%eax
c01039e5:	89 c2                	mov    %eax,%edx
c01039e7:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c01039ec:	39 c2                	cmp    %eax,%edx
c01039ee:	72 1c                	jb     c0103a0c <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01039f0:	c7 44 24 08 fc 69 10 	movl   $0xc01069fc,0x8(%esp)
c01039f7:	c0 
c01039f8:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01039ff:	00 
c0103a00:	c7 04 24 1b 6a 10 c0 	movl   $0xc0106a1b,(%esp)
c0103a07:	e8 c1 d2 ff ff       	call   c0100ccd <__panic>
    }
    return &pages[PPN(pa)];
c0103a0c:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103a12:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a15:	c1 e8 0c             	shr    $0xc,%eax
c0103a18:	89 c2                	mov    %eax,%edx
c0103a1a:	89 d0                	mov    %edx,%eax
c0103a1c:	c1 e0 02             	shl    $0x2,%eax
c0103a1f:	01 d0                	add    %edx,%eax
c0103a21:	c1 e0 02             	shl    $0x2,%eax
c0103a24:	01 c8                	add    %ecx,%eax
}
c0103a26:	c9                   	leave  
c0103a27:	c3                   	ret    

c0103a28 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103a28:	55                   	push   %ebp
c0103a29:	89 e5                	mov    %esp,%ebp
c0103a2b:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103a2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a31:	89 04 24             	mov    %eax,(%esp)
c0103a34:	e8 8a ff ff ff       	call   c01039c3 <page2pa>
c0103a39:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103a3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a3f:	c1 e8 0c             	shr    $0xc,%eax
c0103a42:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a45:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103a4a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103a4d:	72 23                	jb     c0103a72 <page2kva+0x4a>
c0103a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a52:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103a56:	c7 44 24 08 2c 6a 10 	movl   $0xc0106a2c,0x8(%esp)
c0103a5d:	c0 
c0103a5e:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103a65:	00 
c0103a66:	c7 04 24 1b 6a 10 c0 	movl   $0xc0106a1b,(%esp)
c0103a6d:	e8 5b d2 ff ff       	call   c0100ccd <__panic>
c0103a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a75:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103a7a:	c9                   	leave  
c0103a7b:	c3                   	ret    

c0103a7c <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103a7c:	55                   	push   %ebp
c0103a7d:	89 e5                	mov    %esp,%ebp
c0103a7f:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103a82:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a85:	83 e0 01             	and    $0x1,%eax
c0103a88:	85 c0                	test   %eax,%eax
c0103a8a:	75 1c                	jne    c0103aa8 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103a8c:	c7 44 24 08 50 6a 10 	movl   $0xc0106a50,0x8(%esp)
c0103a93:	c0 
c0103a94:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103a9b:	00 
c0103a9c:	c7 04 24 1b 6a 10 c0 	movl   $0xc0106a1b,(%esp)
c0103aa3:	e8 25 d2 ff ff       	call   c0100ccd <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103aa8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aab:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ab0:	89 04 24             	mov    %eax,(%esp)
c0103ab3:	e8 21 ff ff ff       	call   c01039d9 <pa2page>
}
c0103ab8:	c9                   	leave  
c0103ab9:	c3                   	ret    

c0103aba <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103aba:	55                   	push   %ebp
c0103abb:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ac0:	8b 00                	mov    (%eax),%eax
}
c0103ac2:	5d                   	pop    %ebp
c0103ac3:	c3                   	ret    

c0103ac4 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103ac4:	55                   	push   %ebp
c0103ac5:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103ac7:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aca:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103acd:	89 10                	mov    %edx,(%eax)
}
c0103acf:	5d                   	pop    %ebp
c0103ad0:	c3                   	ret    

c0103ad1 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103ad1:	55                   	push   %ebp
c0103ad2:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103ad4:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad7:	8b 00                	mov    (%eax),%eax
c0103ad9:	8d 50 01             	lea    0x1(%eax),%edx
c0103adc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103adf:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae4:	8b 00                	mov    (%eax),%eax
}
c0103ae6:	5d                   	pop    %ebp
c0103ae7:	c3                   	ret    

c0103ae8 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103ae8:	55                   	push   %ebp
c0103ae9:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103aeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0103aee:	8b 00                	mov    (%eax),%eax
c0103af0:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103af6:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103af8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103afb:	8b 00                	mov    (%eax),%eax
}
c0103afd:	5d                   	pop    %ebp
c0103afe:	c3                   	ret    

c0103aff <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103aff:	55                   	push   %ebp
c0103b00:	89 e5                	mov    %esp,%ebp
c0103b02:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103b05:	9c                   	pushf  
c0103b06:	58                   	pop    %eax
c0103b07:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0103b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103b0d:	25 00 02 00 00       	and    $0x200,%eax
c0103b12:	85 c0                	test   %eax,%eax
c0103b14:	74 0c                	je     c0103b22 <__intr_save+0x23>
        intr_disable();
c0103b16:	e8 95 db ff ff       	call   c01016b0 <intr_disable>
        return 1;
c0103b1b:	b8 01 00 00 00       	mov    $0x1,%eax
c0103b20:	eb 05                	jmp    c0103b27 <__intr_save+0x28>
    }
    return 0;
c0103b22:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103b27:	c9                   	leave  
c0103b28:	c3                   	ret    

c0103b29 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103b29:	55                   	push   %ebp
c0103b2a:	89 e5                	mov    %esp,%ebp
c0103b2c:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103b2f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103b33:	74 05                	je     c0103b3a <__intr_restore+0x11>
        intr_enable();
c0103b35:	e8 70 db ff ff       	call   c01016aa <intr_enable>
    }
}
c0103b3a:	c9                   	leave  
c0103b3b:	c3                   	ret    

c0103b3c <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103b3c:	55                   	push   %ebp
c0103b3d:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103b3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b42:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103b45:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b4a:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103b4c:	b8 23 00 00 00       	mov    $0x23,%eax
c0103b51:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103b53:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b58:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103b5a:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b5f:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103b61:	b8 10 00 00 00       	mov    $0x10,%eax
c0103b66:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103b68:	ea 6f 3b 10 c0 08 00 	ljmp   $0x8,$0xc0103b6f
}
c0103b6f:	5d                   	pop    %ebp
c0103b70:	c3                   	ret    

c0103b71 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103b71:	55                   	push   %ebp
c0103b72:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103b74:	8b 45 08             	mov    0x8(%ebp),%eax
c0103b77:	a3 e4 88 11 c0       	mov    %eax,0xc01188e4
}
c0103b7c:	5d                   	pop    %ebp
c0103b7d:	c3                   	ret    

c0103b7e <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103b7e:	55                   	push   %ebp
c0103b7f:	89 e5                	mov    %esp,%ebp
c0103b81:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103b84:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0103b89:	89 04 24             	mov    %eax,(%esp)
c0103b8c:	e8 e0 ff ff ff       	call   c0103b71 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103b91:	66 c7 05 e8 88 11 c0 	movw   $0x10,0xc01188e8
c0103b98:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103b9a:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0103ba1:	68 00 
c0103ba3:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103ba8:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0103bae:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103bb3:	c1 e8 10             	shr    $0x10,%eax
c0103bb6:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0103bbb:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bc2:	83 e0 f0             	and    $0xfffffff0,%eax
c0103bc5:	83 c8 09             	or     $0x9,%eax
c0103bc8:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bcd:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bd4:	83 e0 ef             	and    $0xffffffef,%eax
c0103bd7:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bdc:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103be3:	83 e0 9f             	and    $0xffffff9f,%eax
c0103be6:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103beb:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0103bf2:	83 c8 80             	or     $0xffffff80,%eax
c0103bf5:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0103bfa:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c01:	83 e0 f0             	and    $0xfffffff0,%eax
c0103c04:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c09:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c10:	83 e0 ef             	and    $0xffffffef,%eax
c0103c13:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c18:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c1f:	83 e0 df             	and    $0xffffffdf,%eax
c0103c22:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c27:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c2e:	83 c8 40             	or     $0x40,%eax
c0103c31:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c36:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0103c3d:	83 e0 7f             	and    $0x7f,%eax
c0103c40:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0103c45:	b8 e0 88 11 c0       	mov    $0xc01188e0,%eax
c0103c4a:	c1 e8 18             	shr    $0x18,%eax
c0103c4d:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103c52:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0103c59:	e8 de fe ff ff       	call   c0103b3c <lgdt>
c0103c5e:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103c64:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103c68:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103c6b:	c9                   	leave  
c0103c6c:	c3                   	ret    

c0103c6d <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103c6d:	55                   	push   %ebp
c0103c6e:	89 e5                	mov    %esp,%ebp
c0103c70:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103c73:	c7 05 5c 89 11 c0 e0 	movl   $0xc01069e0,0xc011895c
c0103c7a:	69 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103c7d:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c82:	8b 00                	mov    (%eax),%eax
c0103c84:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103c88:	c7 04 24 7c 6a 10 c0 	movl   $0xc0106a7c,(%esp)
c0103c8f:	e8 a8 c6 ff ff       	call   c010033c <cprintf>
    pmm_manager->init();
c0103c94:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103c99:	8b 40 04             	mov    0x4(%eax),%eax
c0103c9c:	ff d0                	call   *%eax
}
c0103c9e:	c9                   	leave  
c0103c9f:	c3                   	ret    

c0103ca0 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103ca0:	55                   	push   %ebp
c0103ca1:	89 e5                	mov    %esp,%ebp
c0103ca3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103ca6:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cab:	8b 40 08             	mov    0x8(%eax),%eax
c0103cae:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103cb1:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103cb5:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cb8:	89 14 24             	mov    %edx,(%esp)
c0103cbb:	ff d0                	call   *%eax
}
c0103cbd:	c9                   	leave  
c0103cbe:	c3                   	ret    

c0103cbf <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103cbf:	55                   	push   %ebp
c0103cc0:	89 e5                	mov    %esp,%ebp
c0103cc2:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103cc5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103ccc:	e8 2e fe ff ff       	call   c0103aff <__intr_save>
c0103cd1:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103cd4:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103cd9:	8b 40 0c             	mov    0xc(%eax),%eax
c0103cdc:	8b 55 08             	mov    0x8(%ebp),%edx
c0103cdf:	89 14 24             	mov    %edx,(%esp)
c0103ce2:	ff d0                	call   *%eax
c0103ce4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ce7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cea:	89 04 24             	mov    %eax,(%esp)
c0103ced:	e8 37 fe ff ff       	call   c0103b29 <__intr_restore>
    return page;
c0103cf2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103cf5:	c9                   	leave  
c0103cf6:	c3                   	ret    

c0103cf7 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103cf7:	55                   	push   %ebp
c0103cf8:	89 e5                	mov    %esp,%ebp
c0103cfa:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103cfd:	e8 fd fd ff ff       	call   c0103aff <__intr_save>
c0103d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103d05:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d0a:	8b 40 10             	mov    0x10(%eax),%eax
c0103d0d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d10:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103d14:	8b 55 08             	mov    0x8(%ebp),%edx
c0103d17:	89 14 24             	mov    %edx,(%esp)
c0103d1a:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0103d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d1f:	89 04 24             	mov    %eax,(%esp)
c0103d22:	e8 02 fe ff ff       	call   c0103b29 <__intr_restore>
}
c0103d27:	c9                   	leave  
c0103d28:	c3                   	ret    

c0103d29 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103d29:	55                   	push   %ebp
c0103d2a:	89 e5                	mov    %esp,%ebp
c0103d2c:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103d2f:	e8 cb fd ff ff       	call   c0103aff <__intr_save>
c0103d34:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103d37:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c0103d3c:	8b 40 14             	mov    0x14(%eax),%eax
c0103d3f:	ff d0                	call   *%eax
c0103d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103d44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d47:	89 04 24             	mov    %eax,(%esp)
c0103d4a:	e8 da fd ff ff       	call   c0103b29 <__intr_restore>
    return ret;
c0103d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0103d52:	c9                   	leave  
c0103d53:	c3                   	ret    

c0103d54 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0103d54:	55                   	push   %ebp
c0103d55:	89 e5                	mov    %esp,%ebp
c0103d57:	57                   	push   %edi
c0103d58:	56                   	push   %esi
c0103d59:	53                   	push   %ebx
c0103d5a:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0103d60:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0103d67:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0103d6e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0103d75:	c7 04 24 93 6a 10 c0 	movl   $0xc0106a93,(%esp)
c0103d7c:	e8 bb c5 ff ff       	call   c010033c <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103d81:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103d88:	e9 15 01 00 00       	jmp    c0103ea2 <page_init+0x14e>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103d8d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103d90:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103d93:	89 d0                	mov    %edx,%eax
c0103d95:	c1 e0 02             	shl    $0x2,%eax
c0103d98:	01 d0                	add    %edx,%eax
c0103d9a:	c1 e0 02             	shl    $0x2,%eax
c0103d9d:	01 c8                	add    %ecx,%eax
c0103d9f:	8b 50 08             	mov    0x8(%eax),%edx
c0103da2:	8b 40 04             	mov    0x4(%eax),%eax
c0103da5:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0103da8:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0103dab:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dae:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103db1:	89 d0                	mov    %edx,%eax
c0103db3:	c1 e0 02             	shl    $0x2,%eax
c0103db6:	01 d0                	add    %edx,%eax
c0103db8:	c1 e0 02             	shl    $0x2,%eax
c0103dbb:	01 c8                	add    %ecx,%eax
c0103dbd:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103dc0:	8b 58 10             	mov    0x10(%eax),%ebx
c0103dc3:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103dc6:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103dc9:	01 c8                	add    %ecx,%eax
c0103dcb:	11 da                	adc    %ebx,%edx
c0103dcd:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0103dd0:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0103dd3:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103dd6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103dd9:	89 d0                	mov    %edx,%eax
c0103ddb:	c1 e0 02             	shl    $0x2,%eax
c0103dde:	01 d0                	add    %edx,%eax
c0103de0:	c1 e0 02             	shl    $0x2,%eax
c0103de3:	01 c8                	add    %ecx,%eax
c0103de5:	83 c0 14             	add    $0x14,%eax
c0103de8:	8b 00                	mov    (%eax),%eax
c0103dea:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
c0103df0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103df3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103df6:	83 c0 ff             	add    $0xffffffff,%eax
c0103df9:	83 d2 ff             	adc    $0xffffffff,%edx
c0103dfc:	89 c6                	mov    %eax,%esi
c0103dfe:	89 d7                	mov    %edx,%edi
c0103e00:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e03:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e06:	89 d0                	mov    %edx,%eax
c0103e08:	c1 e0 02             	shl    $0x2,%eax
c0103e0b:	01 d0                	add    %edx,%eax
c0103e0d:	c1 e0 02             	shl    $0x2,%eax
c0103e10:	01 c8                	add    %ecx,%eax
c0103e12:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103e15:	8b 58 10             	mov    0x10(%eax),%ebx
c0103e18:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0103e1e:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0103e22:	89 74 24 14          	mov    %esi,0x14(%esp)
c0103e26:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0103e2a:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103e2d:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0103e30:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103e34:	89 54 24 10          	mov    %edx,0x10(%esp)
c0103e38:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0103e3c:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0103e40:	c7 04 24 a0 6a 10 c0 	movl   $0xc0106aa0,(%esp)
c0103e47:	e8 f0 c4 ff ff       	call   c010033c <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0103e4c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103e52:	89 d0                	mov    %edx,%eax
c0103e54:	c1 e0 02             	shl    $0x2,%eax
c0103e57:	01 d0                	add    %edx,%eax
c0103e59:	c1 e0 02             	shl    $0x2,%eax
c0103e5c:	01 c8                	add    %ecx,%eax
c0103e5e:	83 c0 14             	add    $0x14,%eax
c0103e61:	8b 00                	mov    (%eax),%eax
c0103e63:	83 f8 01             	cmp    $0x1,%eax
c0103e66:	75 36                	jne    c0103e9e <page_init+0x14a>
            if (maxpa < end && begin < KMEMSIZE) {
c0103e68:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103e6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103e6e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e71:	77 2b                	ja     c0103e9e <page_init+0x14a>
c0103e73:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0103e76:	72 05                	jb     c0103e7d <page_init+0x129>
c0103e78:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0103e7b:	73 21                	jae    c0103e9e <page_init+0x14a>
c0103e7d:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e81:	77 1b                	ja     c0103e9e <page_init+0x14a>
c0103e83:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0103e87:	72 09                	jb     c0103e92 <page_init+0x13e>
c0103e89:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0103e90:	77 0c                	ja     c0103e9e <page_init+0x14a>
                maxpa = end;
c0103e92:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103e95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103e9b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0103e9e:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103ea2:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103ea5:	8b 00                	mov    (%eax),%eax
c0103ea7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103eaa:	0f 8f dd fe ff ff    	jg     c0103d8d <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0103eb0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eb4:	72 1d                	jb     c0103ed3 <page_init+0x17f>
c0103eb6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103eba:	77 09                	ja     c0103ec5 <page_init+0x171>
c0103ebc:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0103ec3:	76 0e                	jbe    c0103ed3 <page_init+0x17f>
        maxpa = KMEMSIZE;
c0103ec5:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0103ecc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0103ed3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ed6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103ed9:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0103edd:	c1 ea 0c             	shr    $0xc,%edx
c0103ee0:	a3 c0 88 11 c0       	mov    %eax,0xc01188c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0103ee5:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0103eec:	b8 68 89 11 c0       	mov    $0xc0118968,%eax
c0103ef1:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103ef4:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0103ef7:	01 d0                	add    %edx,%eax
c0103ef9:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103efc:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103eff:	ba 00 00 00 00       	mov    $0x0,%edx
c0103f04:	f7 75 ac             	divl   -0x54(%ebp)
c0103f07:	89 d0                	mov    %edx,%eax
c0103f09:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0103f0c:	29 c2                	sub    %eax,%edx
c0103f0e:	89 d0                	mov    %edx,%eax
c0103f10:	a3 64 89 11 c0       	mov    %eax,0xc0118964

    for (i = 0; i < npage; i ++) {
c0103f15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103f1c:	eb 2f                	jmp    c0103f4d <page_init+0x1f9>
        SetPageReserved(pages + i);
c0103f1e:	8b 0d 64 89 11 c0    	mov    0xc0118964,%ecx
c0103f24:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f27:	89 d0                	mov    %edx,%eax
c0103f29:	c1 e0 02             	shl    $0x2,%eax
c0103f2c:	01 d0                	add    %edx,%eax
c0103f2e:	c1 e0 02             	shl    $0x2,%eax
c0103f31:	01 c8                	add    %ecx,%eax
c0103f33:	83 c0 04             	add    $0x4,%eax
c0103f36:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0103f3d:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103f40:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103f43:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103f46:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0103f49:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0103f4d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103f50:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0103f55:	39 c2                	cmp    %eax,%edx
c0103f57:	72 c5                	jb     c0103f1e <page_init+0x1ca>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0103f59:	8b 15 c0 88 11 c0    	mov    0xc01188c0,%edx
c0103f5f:	89 d0                	mov    %edx,%eax
c0103f61:	c1 e0 02             	shl    $0x2,%eax
c0103f64:	01 d0                	add    %edx,%eax
c0103f66:	c1 e0 02             	shl    $0x2,%eax
c0103f69:	89 c2                	mov    %eax,%edx
c0103f6b:	a1 64 89 11 c0       	mov    0xc0118964,%eax
c0103f70:	01 d0                	add    %edx,%eax
c0103f72:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0103f75:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0103f7c:	77 23                	ja     c0103fa1 <page_init+0x24d>
c0103f7e:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103f81:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103f85:	c7 44 24 08 d0 6a 10 	movl   $0xc0106ad0,0x8(%esp)
c0103f8c:	c0 
c0103f8d:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0103f94:	00 
c0103f95:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0103f9c:	e8 2c cd ff ff       	call   c0100ccd <__panic>
c0103fa1:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0103fa4:	05 00 00 00 40       	add    $0x40000000,%eax
c0103fa9:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0103fac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103fb3:	e9 74 01 00 00       	jmp    c010412c <page_init+0x3d8>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0103fb8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fbb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fbe:	89 d0                	mov    %edx,%eax
c0103fc0:	c1 e0 02             	shl    $0x2,%eax
c0103fc3:	01 d0                	add    %edx,%eax
c0103fc5:	c1 e0 02             	shl    $0x2,%eax
c0103fc8:	01 c8                	add    %ecx,%eax
c0103fca:	8b 50 08             	mov    0x8(%eax),%edx
c0103fcd:	8b 40 04             	mov    0x4(%eax),%eax
c0103fd0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103fd3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103fd6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0103fd9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103fdc:	89 d0                	mov    %edx,%eax
c0103fde:	c1 e0 02             	shl    $0x2,%eax
c0103fe1:	01 d0                	add    %edx,%eax
c0103fe3:	c1 e0 02             	shl    $0x2,%eax
c0103fe6:	01 c8                	add    %ecx,%eax
c0103fe8:	8b 48 0c             	mov    0xc(%eax),%ecx
c0103feb:	8b 58 10             	mov    0x10(%eax),%ebx
c0103fee:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103ff1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103ff4:	01 c8                	add    %ecx,%eax
c0103ff6:	11 da                	adc    %ebx,%edx
c0103ff8:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0103ffb:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0103ffe:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104001:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104004:	89 d0                	mov    %edx,%eax
c0104006:	c1 e0 02             	shl    $0x2,%eax
c0104009:	01 d0                	add    %edx,%eax
c010400b:	c1 e0 02             	shl    $0x2,%eax
c010400e:	01 c8                	add    %ecx,%eax
c0104010:	83 c0 14             	add    $0x14,%eax
c0104013:	8b 00                	mov    (%eax),%eax
c0104015:	83 f8 01             	cmp    $0x1,%eax
c0104018:	0f 85 0a 01 00 00    	jne    c0104128 <page_init+0x3d4>
            if (begin < freemem) {
c010401e:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104021:	ba 00 00 00 00       	mov    $0x0,%edx
c0104026:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104029:	72 17                	jb     c0104042 <page_init+0x2ee>
c010402b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010402e:	77 05                	ja     c0104035 <page_init+0x2e1>
c0104030:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104033:	76 0d                	jbe    c0104042 <page_init+0x2ee>
                begin = freemem;
c0104035:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104038:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010403b:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104042:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104046:	72 1d                	jb     c0104065 <page_init+0x311>
c0104048:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010404c:	77 09                	ja     c0104057 <page_init+0x303>
c010404e:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104055:	76 0e                	jbe    c0104065 <page_init+0x311>
                end = KMEMSIZE;
c0104057:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c010405e:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104065:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104068:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010406b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010406e:	0f 87 b4 00 00 00    	ja     c0104128 <page_init+0x3d4>
c0104074:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104077:	72 09                	jb     c0104082 <page_init+0x32e>
c0104079:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010407c:	0f 83 a6 00 00 00    	jae    c0104128 <page_init+0x3d4>
                begin = ROUNDUP(begin, PGSIZE);
c0104082:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104089:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010408c:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010408f:	01 d0                	add    %edx,%eax
c0104091:	83 e8 01             	sub    $0x1,%eax
c0104094:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104097:	8b 45 98             	mov    -0x68(%ebp),%eax
c010409a:	ba 00 00 00 00       	mov    $0x0,%edx
c010409f:	f7 75 9c             	divl   -0x64(%ebp)
c01040a2:	89 d0                	mov    %edx,%eax
c01040a4:	8b 55 98             	mov    -0x68(%ebp),%edx
c01040a7:	29 c2                	sub    %eax,%edx
c01040a9:	89 d0                	mov    %edx,%eax
c01040ab:	ba 00 00 00 00       	mov    $0x0,%edx
c01040b0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01040b3:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01040b6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01040b9:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01040bc:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01040bf:	ba 00 00 00 00       	mov    $0x0,%edx
c01040c4:	89 c7                	mov    %eax,%edi
c01040c6:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
c01040cc:	89 7d 80             	mov    %edi,-0x80(%ebp)
c01040cf:	89 d0                	mov    %edx,%eax
c01040d1:	83 e0 00             	and    $0x0,%eax
c01040d4:	89 45 84             	mov    %eax,-0x7c(%ebp)
c01040d7:	8b 45 80             	mov    -0x80(%ebp),%eax
c01040da:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01040dd:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01040e0:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c01040e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01040e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01040e9:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040ec:	77 3a                	ja     c0104128 <page_init+0x3d4>
c01040ee:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c01040f1:	72 05                	jb     c01040f8 <page_init+0x3a4>
c01040f3:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01040f6:	73 30                	jae    c0104128 <page_init+0x3d4>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01040f8:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01040fb:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01040fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104101:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104104:	29 c8                	sub    %ecx,%eax
c0104106:	19 da                	sbb    %ebx,%edx
c0104108:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010410c:	c1 ea 0c             	shr    $0xc,%edx
c010410f:	89 c3                	mov    %eax,%ebx
c0104111:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104114:	89 04 24             	mov    %eax,(%esp)
c0104117:	e8 bd f8 ff ff       	call   c01039d9 <pa2page>
c010411c:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104120:	89 04 24             	mov    %eax,(%esp)
c0104123:	e8 78 fb ff ff       	call   c0103ca0 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104128:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010412c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010412f:	8b 00                	mov    (%eax),%eax
c0104131:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104134:	0f 8f 7e fe ff ff    	jg     c0103fb8 <page_init+0x264>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c010413a:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104140:	5b                   	pop    %ebx
c0104141:	5e                   	pop    %esi
c0104142:	5f                   	pop    %edi
c0104143:	5d                   	pop    %ebp
c0104144:	c3                   	ret    

c0104145 <enable_paging>:

static void
enable_paging(void) {
c0104145:	55                   	push   %ebp
c0104146:	89 e5                	mov    %esp,%ebp
c0104148:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010414b:	a1 60 89 11 c0       	mov    0xc0118960,%eax
c0104150:	89 45 f8             	mov    %eax,-0x8(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104153:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104156:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104159:	0f 20 c0             	mov    %cr0,%eax
c010415c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return cr0;
c010415f:	8b 45 f4             	mov    -0xc(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104162:	89 45 fc             	mov    %eax,-0x4(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104165:	81 4d fc 2f 00 05 80 	orl    $0x8005002f,-0x4(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010416c:	83 65 fc f3          	andl   $0xfffffff3,-0x4(%ebp)
c0104170:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104173:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104176:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104179:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c010417c:	c9                   	leave  
c010417d:	c3                   	ret    

c010417e <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010417e:	55                   	push   %ebp
c010417f:	89 e5                	mov    %esp,%ebp
c0104181:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104184:	8b 45 14             	mov    0x14(%ebp),%eax
c0104187:	8b 55 0c             	mov    0xc(%ebp),%edx
c010418a:	31 d0                	xor    %edx,%eax
c010418c:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104191:	85 c0                	test   %eax,%eax
c0104193:	74 24                	je     c01041b9 <boot_map_segment+0x3b>
c0104195:	c7 44 24 0c 02 6b 10 	movl   $0xc0106b02,0xc(%esp)
c010419c:	c0 
c010419d:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c01041a4:	c0 
c01041a5:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041ac:	00 
c01041ad:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01041b4:	e8 14 cb ff ff       	call   c0100ccd <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01041b9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01041c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041c3:	25 ff 0f 00 00       	and    $0xfff,%eax
c01041c8:	89 c2                	mov    %eax,%edx
c01041ca:	8b 45 10             	mov    0x10(%ebp),%eax
c01041cd:	01 c2                	add    %eax,%edx
c01041cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01041d2:	01 d0                	add    %edx,%eax
c01041d4:	83 e8 01             	sub    $0x1,%eax
c01041d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01041da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01041dd:	ba 00 00 00 00       	mov    $0x0,%edx
c01041e2:	f7 75 f0             	divl   -0x10(%ebp)
c01041e5:	89 d0                	mov    %edx,%eax
c01041e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01041ea:	29 c2                	sub    %eax,%edx
c01041ec:	89 d0                	mov    %edx,%eax
c01041ee:	c1 e8 0c             	shr    $0xc,%eax
c01041f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01041f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01041f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01041fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01041fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104202:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104205:	8b 45 14             	mov    0x14(%ebp),%eax
c0104208:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010420b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010420e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104213:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104216:	eb 6b                	jmp    c0104283 <boot_map_segment+0x105>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104218:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010421f:	00 
c0104220:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104223:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104227:	8b 45 08             	mov    0x8(%ebp),%eax
c010422a:	89 04 24             	mov    %eax,(%esp)
c010422d:	e8 cc 01 00 00       	call   c01043fe <get_pte>
c0104232:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104235:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104239:	75 24                	jne    c010425f <boot_map_segment+0xe1>
c010423b:	c7 44 24 0c 2e 6b 10 	movl   $0xc0106b2e,0xc(%esp)
c0104242:	c0 
c0104243:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c010424a:	c0 
c010424b:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104252:	00 
c0104253:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010425a:	e8 6e ca ff ff       	call   c0100ccd <__panic>
        *ptep = pa | PTE_P | perm;
c010425f:	8b 45 18             	mov    0x18(%ebp),%eax
c0104262:	8b 55 14             	mov    0x14(%ebp),%edx
c0104265:	09 d0                	or     %edx,%eax
c0104267:	83 c8 01             	or     $0x1,%eax
c010426a:	89 c2                	mov    %eax,%edx
c010426c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010426f:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104271:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104275:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c010427c:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104283:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104287:	75 8f                	jne    c0104218 <boot_map_segment+0x9a>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104289:	c9                   	leave  
c010428a:	c3                   	ret    

c010428b <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010428b:	55                   	push   %ebp
c010428c:	89 e5                	mov    %esp,%ebp
c010428e:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104291:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104298:	e8 22 fa ff ff       	call   c0103cbf <alloc_pages>
c010429d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01042a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01042a4:	75 1c                	jne    c01042c2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01042a6:	c7 44 24 08 3b 6b 10 	movl   $0xc0106b3b,0x8(%esp)
c01042ad:	c0 
c01042ae:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c01042b5:	00 
c01042b6:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01042bd:	e8 0b ca ff ff       	call   c0100ccd <__panic>
    }
    return page2kva(p);
c01042c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042c5:	89 04 24             	mov    %eax,(%esp)
c01042c8:	e8 5b f7 ff ff       	call   c0103a28 <page2kva>
}
c01042cd:	c9                   	leave  
c01042ce:	c3                   	ret    

c01042cf <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01042cf:	55                   	push   %ebp
c01042d0:	89 e5                	mov    %esp,%ebp
c01042d2:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c01042d5:	e8 93 f9 ff ff       	call   c0103c6d <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c01042da:	e8 75 fa ff ff       	call   c0103d54 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c01042df:	e8 8c 04 00 00       	call   c0104770 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c01042e4:	e8 a2 ff ff ff       	call   c010428b <boot_alloc_page>
c01042e9:	a3 c4 88 11 c0       	mov    %eax,0xc01188c4
    memset(boot_pgdir, 0, PGSIZE);
c01042ee:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01042f3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01042fa:	00 
c01042fb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104302:	00 
c0104303:	89 04 24             	mov    %eax,(%esp)
c0104306:	e8 ce 1a 00 00       	call   c0105dd9 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010430b:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104310:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104313:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010431a:	77 23                	ja     c010433f <pmm_init+0x70>
c010431c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010431f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104323:	c7 44 24 08 d0 6a 10 	movl   $0xc0106ad0,0x8(%esp)
c010432a:	c0 
c010432b:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0104332:	00 
c0104333:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010433a:	e8 8e c9 ff ff       	call   c0100ccd <__panic>
c010433f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104342:	05 00 00 00 40       	add    $0x40000000,%eax
c0104347:	a3 60 89 11 c0       	mov    %eax,0xc0118960

    check_pgdir();
c010434c:	e8 3d 04 00 00       	call   c010478e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104351:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104356:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010435c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104361:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104364:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010436b:	77 23                	ja     c0104390 <pmm_init+0xc1>
c010436d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104370:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104374:	c7 44 24 08 d0 6a 10 	movl   $0xc0106ad0,0x8(%esp)
c010437b:	c0 
c010437c:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104383:	00 
c0104384:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010438b:	e8 3d c9 ff ff       	call   c0100ccd <__panic>
c0104390:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104393:	05 00 00 00 40       	add    $0x40000000,%eax
c0104398:	83 c8 03             	or     $0x3,%eax
c010439b:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010439d:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043a2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01043a9:	00 
c01043aa:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01043b1:	00 
c01043b2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01043b9:	38 
c01043ba:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01043c1:	c0 
c01043c2:	89 04 24             	mov    %eax,(%esp)
c01043c5:	e8 b4 fd ff ff       	call   c010417e <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01043ca:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043cf:	8b 15 c4 88 11 c0    	mov    0xc01188c4,%edx
c01043d5:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c01043db:	89 10                	mov    %edx,(%eax)

    enable_paging();
c01043dd:	e8 63 fd ff ff       	call   c0104145 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01043e2:	e8 97 f7 ff ff       	call   c0103b7e <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c01043e7:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01043ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01043f2:	e8 32 0a 00 00       	call   c0104e29 <check_boot_pgdir>

    print_pgdir();
c01043f7:	e8 bf 0e 00 00       	call   c01052bb <print_pgdir>

}
c01043fc:	c9                   	leave  
c01043fd:	c3                   	ret    

c01043fe <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01043fe:	55                   	push   %ebp
c01043ff:	89 e5                	mov    %esp,%ebp
c0104401:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    if (!(pgdir[PDX(la)] & PTE_P)) {          //page table does not exist
c0104404:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104407:	c1 e8 16             	shr    $0x16,%eax
c010440a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104411:	8b 45 08             	mov    0x8(%ebp),%eax
c0104414:	01 d0                	add    %edx,%eax
c0104416:	8b 00                	mov    (%eax),%eax
c0104418:	83 e0 01             	and    $0x1,%eax
c010441b:	85 c0                	test   %eax,%eax
c010441d:	0f 85 cc 00 00 00    	jne    c01044ef <get_pte+0xf1>
    	struct Page *p;
    	if (!create)
c0104423:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104427:	75 0a                	jne    c0104433 <get_pte+0x35>
    		return NULL;
c0104429:	b8 00 00 00 00       	mov    $0x0,%eax
c010442e:	e9 27 01 00 00       	jmp    c010455a <get_pte+0x15c>
    	if ((p = alloc_page()) == NULL)
c0104433:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010443a:	e8 80 f8 ff ff       	call   c0103cbf <alloc_pages>
c010443f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104442:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104446:	75 0a                	jne    c0104452 <get_pte+0x54>
    		return NULL;
c0104448:	b8 00 00 00 00       	mov    $0x0,%eax
c010444d:	e9 08 01 00 00       	jmp    c010455a <get_pte+0x15c>
    	set_page_ref(p, 1);
c0104452:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104459:	00 
c010445a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010445d:	89 04 24             	mov    %eax,(%esp)
c0104460:	e8 5f f6 ff ff       	call   c0103ac4 <set_page_ref>
    	uintptr_t pa = page2pa(p);
c0104465:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104468:	89 04 24             	mov    %eax,(%esp)
c010446b:	e8 53 f5 ff ff       	call   c01039c3 <page2pa>
c0104470:	89 45 f0             	mov    %eax,-0x10(%ebp)
    	memset(KADDR(pa),0,PGSIZE);
c0104473:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104476:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104479:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010447c:	c1 e8 0c             	shr    $0xc,%eax
c010447f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104482:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104487:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010448a:	72 23                	jb     c01044af <get_pte+0xb1>
c010448c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010448f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104493:	c7 44 24 08 2c 6a 10 	movl   $0xc0106a2c,0x8(%esp)
c010449a:	c0 
c010449b:	c7 44 24 04 87 01 00 	movl   $0x187,0x4(%esp)
c01044a2:	00 
c01044a3:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01044aa:	e8 1e c8 ff ff       	call   c0100ccd <__panic>
c01044af:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01044b2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01044b7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01044be:	00 
c01044bf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01044c6:	00 
c01044c7:	89 04 24             	mov    %eax,(%esp)
c01044ca:	e8 0a 19 00 00       	call   c0105dd9 <memset>
    	pgdir[PDX(la)] = (pa & ~0xFFF) | PTE_U | PTE_W | PTE_P;
c01044cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044d2:	c1 e8 16             	shr    $0x16,%eax
c01044d5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01044dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044df:	01 d0                	add    %edx,%eax
c01044e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01044e4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c01044ea:	83 ca 07             	or     $0x7,%edx
c01044ed:	89 10                	mov    %edx,(%eax)
    }
    return (pte_t *)(KADDR(PDE_ADDR(pgdir[PDX(la)]))) + PTX(la);
c01044ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044f2:	c1 e8 16             	shr    $0x16,%eax
c01044f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c01044fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044ff:	01 d0                	add    %edx,%eax
c0104501:	8b 00                	mov    (%eax),%eax
c0104503:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104508:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010450b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010450e:	c1 e8 0c             	shr    $0xc,%eax
c0104511:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104514:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104519:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010451c:	72 23                	jb     c0104541 <get_pte+0x143>
c010451e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104521:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104525:	c7 44 24 08 2c 6a 10 	movl   $0xc0106a2c,0x8(%esp)
c010452c:	c0 
c010452d:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c0104534:	00 
c0104535:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010453c:	e8 8c c7 ff ff       	call   c0100ccd <__panic>
c0104541:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104544:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104549:	8b 55 0c             	mov    0xc(%ebp),%edx
c010454c:	c1 ea 0c             	shr    $0xc,%edx
c010454f:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0104555:	c1 e2 02             	shl    $0x2,%edx
c0104558:	01 d0                	add    %edx,%eax
}
c010455a:	c9                   	leave  
c010455b:	c3                   	ret    

c010455c <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010455c:	55                   	push   %ebp
c010455d:	89 e5                	mov    %esp,%ebp
c010455f:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0104562:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104569:	00 
c010456a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010456d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104571:	8b 45 08             	mov    0x8(%ebp),%eax
c0104574:	89 04 24             	mov    %eax,(%esp)
c0104577:	e8 82 fe ff ff       	call   c01043fe <get_pte>
c010457c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010457f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104583:	74 08                	je     c010458d <get_page+0x31>
        *ptep_store = ptep;
c0104585:	8b 45 10             	mov    0x10(%ebp),%eax
c0104588:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010458b:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010458d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104591:	74 1b                	je     c01045ae <get_page+0x52>
c0104593:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104596:	8b 00                	mov    (%eax),%eax
c0104598:	83 e0 01             	and    $0x1,%eax
c010459b:	85 c0                	test   %eax,%eax
c010459d:	74 0f                	je     c01045ae <get_page+0x52>
        return pa2page(*ptep);
c010459f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045a2:	8b 00                	mov    (%eax),%eax
c01045a4:	89 04 24             	mov    %eax,(%esp)
c01045a7:	e8 2d f4 ff ff       	call   c01039d9 <pa2page>
c01045ac:	eb 05                	jmp    c01045b3 <get_page+0x57>
    }
    return NULL;
c01045ae:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01045b3:	c9                   	leave  
c01045b4:	c3                   	ret    

c01045b5 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01045b5:	55                   	push   %ebp
c01045b6:	89 e5                	mov    %esp,%ebp
c01045b8:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c01045bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01045be:	8b 00                	mov    (%eax),%eax
c01045c0:	83 e0 01             	and    $0x1,%eax
c01045c3:	85 c0                	test   %eax,%eax
c01045c5:	74 4d                	je     c0104614 <page_remove_pte+0x5f>
            struct Page *page = pte2page(*ptep);
c01045c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01045ca:	8b 00                	mov    (%eax),%eax
c01045cc:	89 04 24             	mov    %eax,(%esp)
c01045cf:	e8 a8 f4 ff ff       	call   c0103a7c <pte2page>
c01045d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (page_ref_dec(page) == 0) {
c01045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045da:	89 04 24             	mov    %eax,(%esp)
c01045dd:	e8 06 f5 ff ff       	call   c0103ae8 <page_ref_dec>
c01045e2:	85 c0                	test   %eax,%eax
c01045e4:	75 13                	jne    c01045f9 <page_remove_pte+0x44>
                free_page(page);
c01045e6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01045ed:	00 
c01045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045f1:	89 04 24             	mov    %eax,(%esp)
c01045f4:	e8 fe f6 ff ff       	call   c0103cf7 <free_pages>
            }
            *ptep = 0;
c01045f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01045fc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
            tlb_invalidate(pgdir, la);
c0104602:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104605:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104609:	8b 45 08             	mov    0x8(%ebp),%eax
c010460c:	89 04 24             	mov    %eax,(%esp)
c010460f:	e8 ff 00 00 00       	call   c0104713 <tlb_invalidate>
        }
}
c0104614:	c9                   	leave  
c0104615:	c3                   	ret    

c0104616 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0104616:	55                   	push   %ebp
c0104617:	89 e5                	mov    %esp,%ebp
c0104619:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010461c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104623:	00 
c0104624:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104627:	89 44 24 04          	mov    %eax,0x4(%esp)
c010462b:	8b 45 08             	mov    0x8(%ebp),%eax
c010462e:	89 04 24             	mov    %eax,(%esp)
c0104631:	e8 c8 fd ff ff       	call   c01043fe <get_pte>
c0104636:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0104639:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010463d:	74 19                	je     c0104658 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c010463f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104642:	89 44 24 08          	mov    %eax,0x8(%esp)
c0104646:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104649:	89 44 24 04          	mov    %eax,0x4(%esp)
c010464d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104650:	89 04 24             	mov    %eax,(%esp)
c0104653:	e8 5d ff ff ff       	call   c01045b5 <page_remove_pte>
    }
}
c0104658:	c9                   	leave  
c0104659:	c3                   	ret    

c010465a <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010465a:	55                   	push   %ebp
c010465b:	89 e5                	mov    %esp,%ebp
c010465d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0104660:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104667:	00 
c0104668:	8b 45 10             	mov    0x10(%ebp),%eax
c010466b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010466f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104672:	89 04 24             	mov    %eax,(%esp)
c0104675:	e8 84 fd ff ff       	call   c01043fe <get_pte>
c010467a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c010467d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104681:	75 0a                	jne    c010468d <page_insert+0x33>
        return -E_NO_MEM;
c0104683:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104688:	e9 84 00 00 00       	jmp    c0104711 <page_insert+0xb7>
    }
    page_ref_inc(page);
c010468d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104690:	89 04 24             	mov    %eax,(%esp)
c0104693:	e8 39 f4 ff ff       	call   c0103ad1 <page_ref_inc>
    if (*ptep & PTE_P) {
c0104698:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010469b:	8b 00                	mov    (%eax),%eax
c010469d:	83 e0 01             	and    $0x1,%eax
c01046a0:	85 c0                	test   %eax,%eax
c01046a2:	74 3e                	je     c01046e2 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01046a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046a7:	8b 00                	mov    (%eax),%eax
c01046a9:	89 04 24             	mov    %eax,(%esp)
c01046ac:	e8 cb f3 ff ff       	call   c0103a7c <pte2page>
c01046b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01046b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01046ba:	75 0d                	jne    c01046c9 <page_insert+0x6f>
            page_ref_dec(page);
c01046bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046bf:	89 04 24             	mov    %eax,(%esp)
c01046c2:	e8 21 f4 ff ff       	call   c0103ae8 <page_ref_dec>
c01046c7:	eb 19                	jmp    c01046e2 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01046c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046cc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01046d0:	8b 45 10             	mov    0x10(%ebp),%eax
c01046d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01046d7:	8b 45 08             	mov    0x8(%ebp),%eax
c01046da:	89 04 24             	mov    %eax,(%esp)
c01046dd:	e8 d3 fe ff ff       	call   c01045b5 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01046e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046e5:	89 04 24             	mov    %eax,(%esp)
c01046e8:	e8 d6 f2 ff ff       	call   c01039c3 <page2pa>
c01046ed:	0b 45 14             	or     0x14(%ebp),%eax
c01046f0:	83 c8 01             	or     $0x1,%eax
c01046f3:	89 c2                	mov    %eax,%edx
c01046f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046f8:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01046fa:	8b 45 10             	mov    0x10(%ebp),%eax
c01046fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104701:	8b 45 08             	mov    0x8(%ebp),%eax
c0104704:	89 04 24             	mov    %eax,(%esp)
c0104707:	e8 07 00 00 00       	call   c0104713 <tlb_invalidate>
    return 0;
c010470c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104711:	c9                   	leave  
c0104712:	c3                   	ret    

c0104713 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0104713:	55                   	push   %ebp
c0104714:	89 e5                	mov    %esp,%ebp
c0104716:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0104719:	0f 20 d8             	mov    %cr3,%eax
c010471c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c010471f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0104722:	89 c2                	mov    %eax,%edx
c0104724:	8b 45 08             	mov    0x8(%ebp),%eax
c0104727:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010472a:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104731:	77 23                	ja     c0104756 <tlb_invalidate+0x43>
c0104733:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104736:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010473a:	c7 44 24 08 d0 6a 10 	movl   $0xc0106ad0,0x8(%esp)
c0104741:	c0 
c0104742:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c0104749:	00 
c010474a:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104751:	e8 77 c5 ff ff       	call   c0100ccd <__panic>
c0104756:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104759:	05 00 00 00 40       	add    $0x40000000,%eax
c010475e:	39 c2                	cmp    %eax,%edx
c0104760:	75 0c                	jne    c010476e <tlb_invalidate+0x5b>
        invlpg((void *)la);
c0104762:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104765:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104768:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010476b:	0f 01 38             	invlpg (%eax)
    }
}
c010476e:	c9                   	leave  
c010476f:	c3                   	ret    

c0104770 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104770:	55                   	push   %ebp
c0104771:	89 e5                	mov    %esp,%ebp
c0104773:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104776:	a1 5c 89 11 c0       	mov    0xc011895c,%eax
c010477b:	8b 40 18             	mov    0x18(%eax),%eax
c010477e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104780:	c7 04 24 54 6b 10 c0 	movl   $0xc0106b54,(%esp)
c0104787:	e8 b0 bb ff ff       	call   c010033c <cprintf>
}
c010478c:	c9                   	leave  
c010478d:	c3                   	ret    

c010478e <check_pgdir>:

static void
check_pgdir(void) {
c010478e:	55                   	push   %ebp
c010478f:	89 e5                	mov    %esp,%ebp
c0104791:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104794:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104799:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010479e:	76 24                	jbe    c01047c4 <check_pgdir+0x36>
c01047a0:	c7 44 24 0c 73 6b 10 	movl   $0xc0106b73,0xc(%esp)
c01047a7:	c0 
c01047a8:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c01047af:	c0 
c01047b0:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c01047b7:	00 
c01047b8:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01047bf:	e8 09 c5 ff ff       	call   c0100ccd <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01047c4:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047c9:	85 c0                	test   %eax,%eax
c01047cb:	74 0e                	je     c01047db <check_pgdir+0x4d>
c01047cd:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01047d2:	25 ff 0f 00 00       	and    $0xfff,%eax
c01047d7:	85 c0                	test   %eax,%eax
c01047d9:	74 24                	je     c01047ff <check_pgdir+0x71>
c01047db:	c7 44 24 0c 90 6b 10 	movl   $0xc0106b90,0xc(%esp)
c01047e2:	c0 
c01047e3:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c01047ea:	c0 
c01047eb:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c01047f2:	00 
c01047f3:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01047fa:	e8 ce c4 ff ff       	call   c0100ccd <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01047ff:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104804:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010480b:	00 
c010480c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104813:	00 
c0104814:	89 04 24             	mov    %eax,(%esp)
c0104817:	e8 40 fd ff ff       	call   c010455c <get_page>
c010481c:	85 c0                	test   %eax,%eax
c010481e:	74 24                	je     c0104844 <check_pgdir+0xb6>
c0104820:	c7 44 24 0c c8 6b 10 	movl   $0xc0106bc8,0xc(%esp)
c0104827:	c0 
c0104828:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c010482f:	c0 
c0104830:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104837:	00 
c0104838:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010483f:	e8 89 c4 ff ff       	call   c0100ccd <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104844:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010484b:	e8 6f f4 ff ff       	call   c0103cbf <alloc_pages>
c0104850:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104853:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104858:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010485f:	00 
c0104860:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104867:	00 
c0104868:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010486b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010486f:	89 04 24             	mov    %eax,(%esp)
c0104872:	e8 e3 fd ff ff       	call   c010465a <page_insert>
c0104877:	85 c0                	test   %eax,%eax
c0104879:	74 24                	je     c010489f <check_pgdir+0x111>
c010487b:	c7 44 24 0c f0 6b 10 	movl   $0xc0106bf0,0xc(%esp)
c0104882:	c0 
c0104883:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c010488a:	c0 
c010488b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104892:	00 
c0104893:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010489a:	e8 2e c4 ff ff       	call   c0100ccd <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010489f:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01048a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048ab:	00 
c01048ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01048b3:	00 
c01048b4:	89 04 24             	mov    %eax,(%esp)
c01048b7:	e8 42 fb ff ff       	call   c01043fe <get_pte>
c01048bc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01048bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01048c3:	75 24                	jne    c01048e9 <check_pgdir+0x15b>
c01048c5:	c7 44 24 0c 1c 6c 10 	movl   $0xc0106c1c,0xc(%esp)
c01048cc:	c0 
c01048cd:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c01048d4:	c0 
c01048d5:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c01048dc:	00 
c01048dd:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01048e4:	e8 e4 c3 ff ff       	call   c0100ccd <__panic>
    assert(pa2page(*ptep) == p1);
c01048e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ec:	8b 00                	mov    (%eax),%eax
c01048ee:	89 04 24             	mov    %eax,(%esp)
c01048f1:	e8 e3 f0 ff ff       	call   c01039d9 <pa2page>
c01048f6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048f9:	74 24                	je     c010491f <check_pgdir+0x191>
c01048fb:	c7 44 24 0c 49 6c 10 	movl   $0xc0106c49,0xc(%esp)
c0104902:	c0 
c0104903:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c010490a:	c0 
c010490b:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104912:	00 
c0104913:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010491a:	e8 ae c3 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p1) == 1);
c010491f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104922:	89 04 24             	mov    %eax,(%esp)
c0104925:	e8 90 f1 ff ff       	call   c0103aba <page_ref>
c010492a:	83 f8 01             	cmp    $0x1,%eax
c010492d:	74 24                	je     c0104953 <check_pgdir+0x1c5>
c010492f:	c7 44 24 0c 5e 6c 10 	movl   $0xc0106c5e,0xc(%esp)
c0104936:	c0 
c0104937:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c010493e:	c0 
c010493f:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104946:	00 
c0104947:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010494e:	e8 7a c3 ff ff       	call   c0100ccd <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104953:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104958:	8b 00                	mov    (%eax),%eax
c010495a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010495f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104962:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104965:	c1 e8 0c             	shr    $0xc,%eax
c0104968:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010496b:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104970:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104973:	72 23                	jb     c0104998 <check_pgdir+0x20a>
c0104975:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104978:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010497c:	c7 44 24 08 2c 6a 10 	movl   $0xc0106a2c,0x8(%esp)
c0104983:	c0 
c0104984:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c010498b:	00 
c010498c:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104993:	e8 35 c3 ff ff       	call   c0100ccd <__panic>
c0104998:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010499b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01049a0:	83 c0 04             	add    $0x4,%eax
c01049a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01049a6:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01049ab:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049b2:	00 
c01049b3:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01049ba:	00 
c01049bb:	89 04 24             	mov    %eax,(%esp)
c01049be:	e8 3b fa ff ff       	call   c01043fe <get_pte>
c01049c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01049c6:	74 24                	je     c01049ec <check_pgdir+0x25e>
c01049c8:	c7 44 24 0c 70 6c 10 	movl   $0xc0106c70,0xc(%esp)
c01049cf:	c0 
c01049d0:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c01049d7:	c0 
c01049d8:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c01049df:	00 
c01049e0:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01049e7:	e8 e1 c2 ff ff       	call   c0100ccd <__panic>

    p2 = alloc_page();
c01049ec:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01049f3:	e8 c7 f2 ff ff       	call   c0103cbf <alloc_pages>
c01049f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01049fb:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a00:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104a07:	00 
c0104a08:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104a0f:	00 
c0104a10:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104a13:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104a17:	89 04 24             	mov    %eax,(%esp)
c0104a1a:	e8 3b fc ff ff       	call   c010465a <page_insert>
c0104a1f:	85 c0                	test   %eax,%eax
c0104a21:	74 24                	je     c0104a47 <check_pgdir+0x2b9>
c0104a23:	c7 44 24 0c 98 6c 10 	movl   $0xc0106c98,0xc(%esp)
c0104a2a:	c0 
c0104a2b:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104a32:	c0 
c0104a33:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104a3a:	00 
c0104a3b:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104a42:	e8 86 c2 ff ff       	call   c0100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104a47:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104a4c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104a53:	00 
c0104a54:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a5b:	00 
c0104a5c:	89 04 24             	mov    %eax,(%esp)
c0104a5f:	e8 9a f9 ff ff       	call   c01043fe <get_pte>
c0104a64:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104a67:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a6b:	75 24                	jne    c0104a91 <check_pgdir+0x303>
c0104a6d:	c7 44 24 0c d0 6c 10 	movl   $0xc0106cd0,0xc(%esp)
c0104a74:	c0 
c0104a75:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104a7c:	c0 
c0104a7d:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104a84:	00 
c0104a85:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104a8c:	e8 3c c2 ff ff       	call   c0100ccd <__panic>
    assert(*ptep & PTE_U);
c0104a91:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a94:	8b 00                	mov    (%eax),%eax
c0104a96:	83 e0 04             	and    $0x4,%eax
c0104a99:	85 c0                	test   %eax,%eax
c0104a9b:	75 24                	jne    c0104ac1 <check_pgdir+0x333>
c0104a9d:	c7 44 24 0c 00 6d 10 	movl   $0xc0106d00,0xc(%esp)
c0104aa4:	c0 
c0104aa5:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104aac:	c0 
c0104aad:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104ab4:	00 
c0104ab5:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104abc:	e8 0c c2 ff ff       	call   c0100ccd <__panic>
    assert(*ptep & PTE_W);
c0104ac1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ac4:	8b 00                	mov    (%eax),%eax
c0104ac6:	83 e0 02             	and    $0x2,%eax
c0104ac9:	85 c0                	test   %eax,%eax
c0104acb:	75 24                	jne    c0104af1 <check_pgdir+0x363>
c0104acd:	c7 44 24 0c 0e 6d 10 	movl   $0xc0106d0e,0xc(%esp)
c0104ad4:	c0 
c0104ad5:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104adc:	c0 
c0104add:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104ae4:	00 
c0104ae5:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104aec:	e8 dc c1 ff ff       	call   c0100ccd <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104af1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104af6:	8b 00                	mov    (%eax),%eax
c0104af8:	83 e0 04             	and    $0x4,%eax
c0104afb:	85 c0                	test   %eax,%eax
c0104afd:	75 24                	jne    c0104b23 <check_pgdir+0x395>
c0104aff:	c7 44 24 0c 1c 6d 10 	movl   $0xc0106d1c,0xc(%esp)
c0104b06:	c0 
c0104b07:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104b0e:	c0 
c0104b0f:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104b16:	00 
c0104b17:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104b1e:	e8 aa c1 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 1);
c0104b23:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104b26:	89 04 24             	mov    %eax,(%esp)
c0104b29:	e8 8c ef ff ff       	call   c0103aba <page_ref>
c0104b2e:	83 f8 01             	cmp    $0x1,%eax
c0104b31:	74 24                	je     c0104b57 <check_pgdir+0x3c9>
c0104b33:	c7 44 24 0c 32 6d 10 	movl   $0xc0106d32,0xc(%esp)
c0104b3a:	c0 
c0104b3b:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104b42:	c0 
c0104b43:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104b4a:	00 
c0104b4b:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104b52:	e8 76 c1 ff ff       	call   c0100ccd <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104b57:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104b5c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104b63:	00 
c0104b64:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104b6b:	00 
c0104b6c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b6f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b73:	89 04 24             	mov    %eax,(%esp)
c0104b76:	e8 df fa ff ff       	call   c010465a <page_insert>
c0104b7b:	85 c0                	test   %eax,%eax
c0104b7d:	74 24                	je     c0104ba3 <check_pgdir+0x415>
c0104b7f:	c7 44 24 0c 44 6d 10 	movl   $0xc0106d44,0xc(%esp)
c0104b86:	c0 
c0104b87:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104b8e:	c0 
c0104b8f:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104b96:	00 
c0104b97:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104b9e:	e8 2a c1 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p1) == 2);
c0104ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ba6:	89 04 24             	mov    %eax,(%esp)
c0104ba9:	e8 0c ef ff ff       	call   c0103aba <page_ref>
c0104bae:	83 f8 02             	cmp    $0x2,%eax
c0104bb1:	74 24                	je     c0104bd7 <check_pgdir+0x449>
c0104bb3:	c7 44 24 0c 70 6d 10 	movl   $0xc0106d70,0xc(%esp)
c0104bba:	c0 
c0104bbb:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104bc2:	c0 
c0104bc3:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104bca:	00 
c0104bcb:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104bd2:	e8 f6 c0 ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104bd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104bda:	89 04 24             	mov    %eax,(%esp)
c0104bdd:	e8 d8 ee ff ff       	call   c0103aba <page_ref>
c0104be2:	85 c0                	test   %eax,%eax
c0104be4:	74 24                	je     c0104c0a <check_pgdir+0x47c>
c0104be6:	c7 44 24 0c 82 6d 10 	movl   $0xc0106d82,0xc(%esp)
c0104bed:	c0 
c0104bee:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104bf5:	c0 
c0104bf6:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104bfd:	00 
c0104bfe:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104c05:	e8 c3 c0 ff ff       	call   c0100ccd <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104c0a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104c0f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c16:	00 
c0104c17:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c1e:	00 
c0104c1f:	89 04 24             	mov    %eax,(%esp)
c0104c22:	e8 d7 f7 ff ff       	call   c01043fe <get_pte>
c0104c27:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c2a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c2e:	75 24                	jne    c0104c54 <check_pgdir+0x4c6>
c0104c30:	c7 44 24 0c d0 6c 10 	movl   $0xc0106cd0,0xc(%esp)
c0104c37:	c0 
c0104c38:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104c3f:	c0 
c0104c40:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104c47:	00 
c0104c48:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104c4f:	e8 79 c0 ff ff       	call   c0100ccd <__panic>
    assert(pa2page(*ptep) == p1);
c0104c54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c57:	8b 00                	mov    (%eax),%eax
c0104c59:	89 04 24             	mov    %eax,(%esp)
c0104c5c:	e8 78 ed ff ff       	call   c01039d9 <pa2page>
c0104c61:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104c64:	74 24                	je     c0104c8a <check_pgdir+0x4fc>
c0104c66:	c7 44 24 0c 49 6c 10 	movl   $0xc0106c49,0xc(%esp)
c0104c6d:	c0 
c0104c6e:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104c75:	c0 
c0104c76:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104c7d:	00 
c0104c7e:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104c85:	e8 43 c0 ff ff       	call   c0100ccd <__panic>
    assert((*ptep & PTE_U) == 0);
c0104c8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c8d:	8b 00                	mov    (%eax),%eax
c0104c8f:	83 e0 04             	and    $0x4,%eax
c0104c92:	85 c0                	test   %eax,%eax
c0104c94:	74 24                	je     c0104cba <check_pgdir+0x52c>
c0104c96:	c7 44 24 0c 94 6d 10 	movl   $0xc0106d94,0xc(%esp)
c0104c9d:	c0 
c0104c9e:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104ca5:	c0 
c0104ca6:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104cad:	00 
c0104cae:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104cb5:	e8 13 c0 ff ff       	call   c0100ccd <__panic>

    page_remove(boot_pgdir, 0x0);
c0104cba:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104cbf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cc6:	00 
c0104cc7:	89 04 24             	mov    %eax,(%esp)
c0104cca:	e8 47 f9 ff ff       	call   c0104616 <page_remove>
    assert(page_ref(p1) == 1);
c0104ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104cd2:	89 04 24             	mov    %eax,(%esp)
c0104cd5:	e8 e0 ed ff ff       	call   c0103aba <page_ref>
c0104cda:	83 f8 01             	cmp    $0x1,%eax
c0104cdd:	74 24                	je     c0104d03 <check_pgdir+0x575>
c0104cdf:	c7 44 24 0c 5e 6c 10 	movl   $0xc0106c5e,0xc(%esp)
c0104ce6:	c0 
c0104ce7:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104cee:	c0 
c0104cef:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104cf6:	00 
c0104cf7:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104cfe:	e8 ca bf ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104d03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d06:	89 04 24             	mov    %eax,(%esp)
c0104d09:	e8 ac ed ff ff       	call   c0103aba <page_ref>
c0104d0e:	85 c0                	test   %eax,%eax
c0104d10:	74 24                	je     c0104d36 <check_pgdir+0x5a8>
c0104d12:	c7 44 24 0c 82 6d 10 	movl   $0xc0106d82,0xc(%esp)
c0104d19:	c0 
c0104d1a:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104d21:	c0 
c0104d22:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104d29:	00 
c0104d2a:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104d31:	e8 97 bf ff ff       	call   c0100ccd <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104d36:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104d3b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104d42:	00 
c0104d43:	89 04 24             	mov    %eax,(%esp)
c0104d46:	e8 cb f8 ff ff       	call   c0104616 <page_remove>
    assert(page_ref(p1) == 0);
c0104d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d4e:	89 04 24             	mov    %eax,(%esp)
c0104d51:	e8 64 ed ff ff       	call   c0103aba <page_ref>
c0104d56:	85 c0                	test   %eax,%eax
c0104d58:	74 24                	je     c0104d7e <check_pgdir+0x5f0>
c0104d5a:	c7 44 24 0c a9 6d 10 	movl   $0xc0106da9,0xc(%esp)
c0104d61:	c0 
c0104d62:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104d69:	c0 
c0104d6a:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0104d71:	00 
c0104d72:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104d79:	e8 4f bf ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p2) == 0);
c0104d7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d81:	89 04 24             	mov    %eax,(%esp)
c0104d84:	e8 31 ed ff ff       	call   c0103aba <page_ref>
c0104d89:	85 c0                	test   %eax,%eax
c0104d8b:	74 24                	je     c0104db1 <check_pgdir+0x623>
c0104d8d:	c7 44 24 0c 82 6d 10 	movl   $0xc0106d82,0xc(%esp)
c0104d94:	c0 
c0104d95:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104d9c:	c0 
c0104d9d:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0104da4:	00 
c0104da5:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104dac:	e8 1c bf ff ff       	call   c0100ccd <__panic>

    assert(page_ref(pa2page(boot_pgdir[0])) == 1);
c0104db1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104db6:	8b 00                	mov    (%eax),%eax
c0104db8:	89 04 24             	mov    %eax,(%esp)
c0104dbb:	e8 19 ec ff ff       	call   c01039d9 <pa2page>
c0104dc0:	89 04 24             	mov    %eax,(%esp)
c0104dc3:	e8 f2 ec ff ff       	call   c0103aba <page_ref>
c0104dc8:	83 f8 01             	cmp    $0x1,%eax
c0104dcb:	74 24                	je     c0104df1 <check_pgdir+0x663>
c0104dcd:	c7 44 24 0c bc 6d 10 	movl   $0xc0106dbc,0xc(%esp)
c0104dd4:	c0 
c0104dd5:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104ddc:	c0 
c0104ddd:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0104de4:	00 
c0104de5:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104dec:	e8 dc be ff ff       	call   c0100ccd <__panic>
    free_page(pa2page(boot_pgdir[0]));
c0104df1:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104df6:	8b 00                	mov    (%eax),%eax
c0104df8:	89 04 24             	mov    %eax,(%esp)
c0104dfb:	e8 d9 eb ff ff       	call   c01039d9 <pa2page>
c0104e00:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104e07:	00 
c0104e08:	89 04 24             	mov    %eax,(%esp)
c0104e0b:	e8 e7 ee ff ff       	call   c0103cf7 <free_pages>
    boot_pgdir[0] = 0;
c0104e10:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e15:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0104e1b:	c7 04 24 e2 6d 10 c0 	movl   $0xc0106de2,(%esp)
c0104e22:	e8 15 b5 ff ff       	call   c010033c <cprintf>
}
c0104e27:	c9                   	leave  
c0104e28:	c3                   	ret    

c0104e29 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0104e29:	55                   	push   %ebp
c0104e2a:	89 e5                	mov    %esp,%ebp
c0104e2c:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104e2f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104e36:	e9 ca 00 00 00       	jmp    c0104f05 <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0104e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e44:	c1 e8 0c             	shr    $0xc,%eax
c0104e47:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104e4a:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104e4f:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0104e52:	72 23                	jb     c0104e77 <check_boot_pgdir+0x4e>
c0104e54:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e57:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e5b:	c7 44 24 08 2c 6a 10 	movl   $0xc0106a2c,0x8(%esp)
c0104e62:	c0 
c0104e63:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104e6a:	00 
c0104e6b:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104e72:	e8 56 be ff ff       	call   c0100ccd <__panic>
c0104e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e7a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104e7f:	89 c2                	mov    %eax,%edx
c0104e81:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104e86:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104e8d:	00 
c0104e8e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e92:	89 04 24             	mov    %eax,(%esp)
c0104e95:	e8 64 f5 ff ff       	call   c01043fe <get_pte>
c0104e9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104e9d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104ea1:	75 24                	jne    c0104ec7 <check_boot_pgdir+0x9e>
c0104ea3:	c7 44 24 0c fc 6d 10 	movl   $0xc0106dfc,0xc(%esp)
c0104eaa:	c0 
c0104eab:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104eb2:	c0 
c0104eb3:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0104eba:	00 
c0104ebb:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104ec2:	e8 06 be ff ff       	call   c0100ccd <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0104ec7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104eca:	8b 00                	mov    (%eax),%eax
c0104ecc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ed1:	89 c2                	mov    %eax,%edx
c0104ed3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ed6:	39 c2                	cmp    %eax,%edx
c0104ed8:	74 24                	je     c0104efe <check_boot_pgdir+0xd5>
c0104eda:	c7 44 24 0c 39 6e 10 	movl   $0xc0106e39,0xc(%esp)
c0104ee1:	c0 
c0104ee2:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104ee9:	c0 
c0104eea:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0104ef1:	00 
c0104ef2:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104ef9:	e8 cf bd ff ff       	call   c0100ccd <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0104efe:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0104f05:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104f08:	a1 c0 88 11 c0       	mov    0xc01188c0,%eax
c0104f0d:	39 c2                	cmp    %eax,%edx
c0104f0f:	0f 82 26 ff ff ff    	jb     c0104e3b <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0104f15:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f1a:	05 ac 0f 00 00       	add    $0xfac,%eax
c0104f1f:	8b 00                	mov    (%eax),%eax
c0104f21:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f26:	89 c2                	mov    %eax,%edx
c0104f28:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f2d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f30:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0104f37:	77 23                	ja     c0104f5c <check_boot_pgdir+0x133>
c0104f39:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104f40:	c7 44 24 08 d0 6a 10 	movl   $0xc0106ad0,0x8(%esp)
c0104f47:	c0 
c0104f48:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104f4f:	00 
c0104f50:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104f57:	e8 71 bd ff ff       	call   c0100ccd <__panic>
c0104f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104f5f:	05 00 00 00 40       	add    $0x40000000,%eax
c0104f64:	39 c2                	cmp    %eax,%edx
c0104f66:	74 24                	je     c0104f8c <check_boot_pgdir+0x163>
c0104f68:	c7 44 24 0c 50 6e 10 	movl   $0xc0106e50,0xc(%esp)
c0104f6f:	c0 
c0104f70:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104f77:	c0 
c0104f78:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0104f7f:	00 
c0104f80:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104f87:	e8 41 bd ff ff       	call   c0100ccd <__panic>

    assert(boot_pgdir[0] == 0);
c0104f8c:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104f91:	8b 00                	mov    (%eax),%eax
c0104f93:	85 c0                	test   %eax,%eax
c0104f95:	74 24                	je     c0104fbb <check_boot_pgdir+0x192>
c0104f97:	c7 44 24 0c 84 6e 10 	movl   $0xc0106e84,0xc(%esp)
c0104f9e:	c0 
c0104f9f:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0104fa6:	c0 
c0104fa7:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0104fae:	00 
c0104faf:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0104fb6:	e8 12 bd ff ff       	call   c0100ccd <__panic>

    struct Page *p;
    p = alloc_page();
c0104fbb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104fc2:	e8 f8 ec ff ff       	call   c0103cbf <alloc_pages>
c0104fc7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0104fca:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c0104fcf:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0104fd6:	00 
c0104fd7:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0104fde:	00 
c0104fdf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104fe2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104fe6:	89 04 24             	mov    %eax,(%esp)
c0104fe9:	e8 6c f6 ff ff       	call   c010465a <page_insert>
c0104fee:	85 c0                	test   %eax,%eax
c0104ff0:	74 24                	je     c0105016 <check_boot_pgdir+0x1ed>
c0104ff2:	c7 44 24 0c 98 6e 10 	movl   $0xc0106e98,0xc(%esp)
c0104ff9:	c0 
c0104ffa:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0105001:	c0 
c0105002:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c0105009:	00 
c010500a:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0105011:	e8 b7 bc ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p) == 1);
c0105016:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105019:	89 04 24             	mov    %eax,(%esp)
c010501c:	e8 99 ea ff ff       	call   c0103aba <page_ref>
c0105021:	83 f8 01             	cmp    $0x1,%eax
c0105024:	74 24                	je     c010504a <check_boot_pgdir+0x221>
c0105026:	c7 44 24 0c c6 6e 10 	movl   $0xc0106ec6,0xc(%esp)
c010502d:	c0 
c010502e:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0105035:	c0 
c0105036:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c010503d:	00 
c010503e:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0105045:	e8 83 bc ff ff       	call   c0100ccd <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010504a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010504f:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105056:	00 
c0105057:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c010505e:	00 
c010505f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105062:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105066:	89 04 24             	mov    %eax,(%esp)
c0105069:	e8 ec f5 ff ff       	call   c010465a <page_insert>
c010506e:	85 c0                	test   %eax,%eax
c0105070:	74 24                	je     c0105096 <check_boot_pgdir+0x26d>
c0105072:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0105079:	c0 
c010507a:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0105081:	c0 
c0105082:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105089:	00 
c010508a:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0105091:	e8 37 bc ff ff       	call   c0100ccd <__panic>
    assert(page_ref(p) == 2);
c0105096:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105099:	89 04 24             	mov    %eax,(%esp)
c010509c:	e8 19 ea ff ff       	call   c0103aba <page_ref>
c01050a1:	83 f8 02             	cmp    $0x2,%eax
c01050a4:	74 24                	je     c01050ca <check_boot_pgdir+0x2a1>
c01050a6:	c7 44 24 0c 0f 6f 10 	movl   $0xc0106f0f,0xc(%esp)
c01050ad:	c0 
c01050ae:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c01050b5:	c0 
c01050b6:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c01050bd:	00 
c01050be:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c01050c5:	e8 03 bc ff ff       	call   c0100ccd <__panic>

    const char *str = "ucore: Hello world!!";
c01050ca:	c7 45 dc 20 6f 10 c0 	movl   $0xc0106f20,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01050d1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01050d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01050d8:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050df:	e8 1e 0a 00 00       	call   c0105b02 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01050e4:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01050eb:	00 
c01050ec:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01050f3:	e8 83 0a 00 00       	call   c0105b7b <strcmp>
c01050f8:	85 c0                	test   %eax,%eax
c01050fa:	74 24                	je     c0105120 <check_boot_pgdir+0x2f7>
c01050fc:	c7 44 24 0c 38 6f 10 	movl   $0xc0106f38,0xc(%esp)
c0105103:	c0 
c0105104:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c010510b:	c0 
c010510c:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c0105113:	00 
c0105114:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c010511b:	e8 ad bb ff ff       	call   c0100ccd <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105120:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105123:	89 04 24             	mov    %eax,(%esp)
c0105126:	e8 fd e8 ff ff       	call   c0103a28 <page2kva>
c010512b:	05 00 01 00 00       	add    $0x100,%eax
c0105130:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105133:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010513a:	e8 6b 09 00 00       	call   c0105aaa <strlen>
c010513f:	85 c0                	test   %eax,%eax
c0105141:	74 24                	je     c0105167 <check_boot_pgdir+0x33e>
c0105143:	c7 44 24 0c 70 6f 10 	movl   $0xc0106f70,0xc(%esp)
c010514a:	c0 
c010514b:	c7 44 24 08 19 6b 10 	movl   $0xc0106b19,0x8(%esp)
c0105152:	c0 
c0105153:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c010515a:	00 
c010515b:	c7 04 24 f4 6a 10 c0 	movl   $0xc0106af4,(%esp)
c0105162:	e8 66 bb ff ff       	call   c0100ccd <__panic>

    free_page(p);
c0105167:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010516e:	00 
c010516f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105172:	89 04 24             	mov    %eax,(%esp)
c0105175:	e8 7d eb ff ff       	call   c0103cf7 <free_pages>
    free_page(pa2page(PDE_ADDR(boot_pgdir[0])));
c010517a:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c010517f:	8b 00                	mov    (%eax),%eax
c0105181:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105186:	89 04 24             	mov    %eax,(%esp)
c0105189:	e8 4b e8 ff ff       	call   c01039d9 <pa2page>
c010518e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105195:	00 
c0105196:	89 04 24             	mov    %eax,(%esp)
c0105199:	e8 59 eb ff ff       	call   c0103cf7 <free_pages>
    boot_pgdir[0] = 0;
c010519e:	a1 c4 88 11 c0       	mov    0xc01188c4,%eax
c01051a3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c01051a9:	c7 04 24 94 6f 10 c0 	movl   $0xc0106f94,(%esp)
c01051b0:	e8 87 b1 ff ff       	call   c010033c <cprintf>
}
c01051b5:	c9                   	leave  
c01051b6:	c3                   	ret    

c01051b7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01051b7:	55                   	push   %ebp
c01051b8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01051ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01051bd:	83 e0 04             	and    $0x4,%eax
c01051c0:	85 c0                	test   %eax,%eax
c01051c2:	74 07                	je     c01051cb <perm2str+0x14>
c01051c4:	b8 75 00 00 00       	mov    $0x75,%eax
c01051c9:	eb 05                	jmp    c01051d0 <perm2str+0x19>
c01051cb:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051d0:	a2 48 89 11 c0       	mov    %al,0xc0118948
    str[1] = 'r';
c01051d5:	c6 05 49 89 11 c0 72 	movb   $0x72,0xc0118949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01051dc:	8b 45 08             	mov    0x8(%ebp),%eax
c01051df:	83 e0 02             	and    $0x2,%eax
c01051e2:	85 c0                	test   %eax,%eax
c01051e4:	74 07                	je     c01051ed <perm2str+0x36>
c01051e6:	b8 77 00 00 00       	mov    $0x77,%eax
c01051eb:	eb 05                	jmp    c01051f2 <perm2str+0x3b>
c01051ed:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01051f2:	a2 4a 89 11 c0       	mov    %al,0xc011894a
    str[3] = '\0';
c01051f7:	c6 05 4b 89 11 c0 00 	movb   $0x0,0xc011894b
    return str;
c01051fe:	b8 48 89 11 c0       	mov    $0xc0118948,%eax
}
c0105203:	5d                   	pop    %ebp
c0105204:	c3                   	ret    

c0105205 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105205:	55                   	push   %ebp
c0105206:	89 e5                	mov    %esp,%ebp
c0105208:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c010520b:	8b 45 10             	mov    0x10(%ebp),%eax
c010520e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105211:	72 0a                	jb     c010521d <get_pgtable_items+0x18>
        return 0;
c0105213:	b8 00 00 00 00       	mov    $0x0,%eax
c0105218:	e9 9c 00 00 00       	jmp    c01052b9 <get_pgtable_items+0xb4>
    }
    while (start < right && !(table[start] & PTE_P)) {
c010521d:	eb 04                	jmp    c0105223 <get_pgtable_items+0x1e>
        start ++;
c010521f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105223:	8b 45 10             	mov    0x10(%ebp),%eax
c0105226:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105229:	73 18                	jae    c0105243 <get_pgtable_items+0x3e>
c010522b:	8b 45 10             	mov    0x10(%ebp),%eax
c010522e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105235:	8b 45 14             	mov    0x14(%ebp),%eax
c0105238:	01 d0                	add    %edx,%eax
c010523a:	8b 00                	mov    (%eax),%eax
c010523c:	83 e0 01             	and    $0x1,%eax
c010523f:	85 c0                	test   %eax,%eax
c0105241:	74 dc                	je     c010521f <get_pgtable_items+0x1a>
        start ++;
    }
    if (start < right) {
c0105243:	8b 45 10             	mov    0x10(%ebp),%eax
c0105246:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105249:	73 69                	jae    c01052b4 <get_pgtable_items+0xaf>
        if (left_store != NULL) {
c010524b:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c010524f:	74 08                	je     c0105259 <get_pgtable_items+0x54>
            *left_store = start;
c0105251:	8b 45 18             	mov    0x18(%ebp),%eax
c0105254:	8b 55 10             	mov    0x10(%ebp),%edx
c0105257:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105259:	8b 45 10             	mov    0x10(%ebp),%eax
c010525c:	8d 50 01             	lea    0x1(%eax),%edx
c010525f:	89 55 10             	mov    %edx,0x10(%ebp)
c0105262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0105269:	8b 45 14             	mov    0x14(%ebp),%eax
c010526c:	01 d0                	add    %edx,%eax
c010526e:	8b 00                	mov    (%eax),%eax
c0105270:	83 e0 07             	and    $0x7,%eax
c0105273:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105276:	eb 04                	jmp    c010527c <get_pgtable_items+0x77>
            start ++;
c0105278:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010527c:	8b 45 10             	mov    0x10(%ebp),%eax
c010527f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105282:	73 1d                	jae    c01052a1 <get_pgtable_items+0x9c>
c0105284:	8b 45 10             	mov    0x10(%ebp),%eax
c0105287:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010528e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105291:	01 d0                	add    %edx,%eax
c0105293:	8b 00                	mov    (%eax),%eax
c0105295:	83 e0 07             	and    $0x7,%eax
c0105298:	89 c2                	mov    %eax,%edx
c010529a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010529d:	39 c2                	cmp    %eax,%edx
c010529f:	74 d7                	je     c0105278 <get_pgtable_items+0x73>
            start ++;
        }
        if (right_store != NULL) {
c01052a1:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01052a5:	74 08                	je     c01052af <get_pgtable_items+0xaa>
            *right_store = start;
c01052a7:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01052aa:	8b 55 10             	mov    0x10(%ebp),%edx
c01052ad:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01052af:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01052b2:	eb 05                	jmp    c01052b9 <get_pgtable_items+0xb4>
    }
    return 0;
c01052b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01052b9:	c9                   	leave  
c01052ba:	c3                   	ret    

c01052bb <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01052bb:	55                   	push   %ebp
c01052bc:	89 e5                	mov    %esp,%ebp
c01052be:	57                   	push   %edi
c01052bf:	56                   	push   %esi
c01052c0:	53                   	push   %ebx
c01052c1:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01052c4:	c7 04 24 b4 6f 10 c0 	movl   $0xc0106fb4,(%esp)
c01052cb:	e8 6c b0 ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
c01052d0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01052d7:	e9 fa 00 00 00       	jmp    c01053d6 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052df:	89 04 24             	mov    %eax,(%esp)
c01052e2:	e8 d0 fe ff ff       	call   c01051b7 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01052e7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01052ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01052ed:	29 d1                	sub    %edx,%ecx
c01052ef:	89 ca                	mov    %ecx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01052f1:	89 d6                	mov    %edx,%esi
c01052f3:	c1 e6 16             	shl    $0x16,%esi
c01052f6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052f9:	89 d3                	mov    %edx,%ebx
c01052fb:	c1 e3 16             	shl    $0x16,%ebx
c01052fe:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105301:	89 d1                	mov    %edx,%ecx
c0105303:	c1 e1 16             	shl    $0x16,%ecx
c0105306:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105309:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010530c:	29 d7                	sub    %edx,%edi
c010530e:	89 fa                	mov    %edi,%edx
c0105310:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105314:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105318:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010531c:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105320:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105324:	c7 04 24 e5 6f 10 c0 	movl   $0xc0106fe5,(%esp)
c010532b:	e8 0c b0 ff ff       	call   c010033c <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105330:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105333:	c1 e0 0a             	shl    $0xa,%eax
c0105336:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105339:	eb 54                	jmp    c010538f <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010533b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010533e:	89 04 24             	mov    %eax,(%esp)
c0105341:	e8 71 fe ff ff       	call   c01051b7 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105346:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105349:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010534c:	29 d1                	sub    %edx,%ecx
c010534e:	89 ca                	mov    %ecx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105350:	89 d6                	mov    %edx,%esi
c0105352:	c1 e6 0c             	shl    $0xc,%esi
c0105355:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105358:	89 d3                	mov    %edx,%ebx
c010535a:	c1 e3 0c             	shl    $0xc,%ebx
c010535d:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105360:	c1 e2 0c             	shl    $0xc,%edx
c0105363:	89 d1                	mov    %edx,%ecx
c0105365:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105368:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010536b:	29 d7                	sub    %edx,%edi
c010536d:	89 fa                	mov    %edi,%edx
c010536f:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105373:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105377:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010537b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c010537f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105383:	c7 04 24 04 70 10 c0 	movl   $0xc0107004,(%esp)
c010538a:	e8 ad af ff ff       	call   c010033c <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010538f:	ba 00 00 c0 fa       	mov    $0xfac00000,%edx
c0105394:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105397:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010539a:	89 ce                	mov    %ecx,%esi
c010539c:	c1 e6 0a             	shl    $0xa,%esi
c010539f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01053a2:	89 cb                	mov    %ecx,%ebx
c01053a4:	c1 e3 0a             	shl    $0xa,%ebx
c01053a7:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c01053aa:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053ae:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c01053b1:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053b5:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053b9:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053bd:	89 74 24 04          	mov    %esi,0x4(%esp)
c01053c1:	89 1c 24             	mov    %ebx,(%esp)
c01053c4:	e8 3c fe ff ff       	call   c0105205 <get_pgtable_items>
c01053c9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01053cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01053d0:	0f 85 65 ff ff ff    	jne    c010533b <print_pgdir+0x80>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01053d6:	ba 00 b0 fe fa       	mov    $0xfafeb000,%edx
c01053db:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01053de:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01053e1:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01053e5:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01053e8:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01053ec:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01053f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01053f4:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01053fb:	00 
c01053fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105403:	e8 fd fd ff ff       	call   c0105205 <get_pgtable_items>
c0105408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010540b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010540f:	0f 85 c7 fe ff ff    	jne    c01052dc <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105415:	c7 04 24 28 70 10 c0 	movl   $0xc0107028,(%esp)
c010541c:	e8 1b af ff ff       	call   c010033c <cprintf>
}
c0105421:	83 c4 4c             	add    $0x4c,%esp
c0105424:	5b                   	pop    %ebx
c0105425:	5e                   	pop    %esi
c0105426:	5f                   	pop    %edi
c0105427:	5d                   	pop    %ebp
c0105428:	c3                   	ret    

c0105429 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c0105429:	55                   	push   %ebp
c010542a:	89 e5                	mov    %esp,%ebp
c010542c:	83 ec 58             	sub    $0x58,%esp
c010542f:	8b 45 10             	mov    0x10(%ebp),%eax
c0105432:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105435:	8b 45 14             	mov    0x14(%ebp),%eax
c0105438:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010543b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010543e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105441:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105444:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c0105447:	8b 45 18             	mov    0x18(%ebp),%eax
c010544a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010544d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105450:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105453:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105456:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0105459:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010545c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010545f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105463:	74 1c                	je     c0105481 <printnum+0x58>
c0105465:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105468:	ba 00 00 00 00       	mov    $0x0,%edx
c010546d:	f7 75 e4             	divl   -0x1c(%ebp)
c0105470:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105473:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105476:	ba 00 00 00 00       	mov    $0x0,%edx
c010547b:	f7 75 e4             	divl   -0x1c(%ebp)
c010547e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105481:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105484:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105487:	f7 75 e4             	divl   -0x1c(%ebp)
c010548a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010548d:	89 55 dc             	mov    %edx,-0x24(%ebp)
c0105490:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105493:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105496:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105499:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010549c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010549f:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c01054a2:	8b 45 18             	mov    0x18(%ebp),%eax
c01054a5:	ba 00 00 00 00       	mov    $0x0,%edx
c01054aa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054ad:	77 56                	ja     c0105505 <printnum+0xdc>
c01054af:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054b2:	72 05                	jb     c01054b9 <printnum+0x90>
c01054b4:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054b7:	77 4c                	ja     c0105505 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c01054b9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01054bc:	8d 50 ff             	lea    -0x1(%eax),%edx
c01054bf:	8b 45 20             	mov    0x20(%ebp),%eax
c01054c2:	89 44 24 18          	mov    %eax,0x18(%esp)
c01054c6:	89 54 24 14          	mov    %edx,0x14(%esp)
c01054ca:	8b 45 18             	mov    0x18(%ebp),%eax
c01054cd:	89 44 24 10          	mov    %eax,0x10(%esp)
c01054d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01054d4:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01054d7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01054db:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01054df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054e2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01054e9:	89 04 24             	mov    %eax,(%esp)
c01054ec:	e8 38 ff ff ff       	call   c0105429 <printnum>
c01054f1:	eb 1c                	jmp    c010550f <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01054f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01054fa:	8b 45 20             	mov    0x20(%ebp),%eax
c01054fd:	89 04 24             	mov    %eax,(%esp)
c0105500:	8b 45 08             	mov    0x8(%ebp),%eax
c0105503:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c0105505:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c0105509:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010550d:	7f e4                	jg     c01054f3 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010550f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105512:	05 dc 70 10 c0       	add    $0xc01070dc,%eax
c0105517:	0f b6 00             	movzbl (%eax),%eax
c010551a:	0f be c0             	movsbl %al,%eax
c010551d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105520:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105524:	89 04 24             	mov    %eax,(%esp)
c0105527:	8b 45 08             	mov    0x8(%ebp),%eax
c010552a:	ff d0                	call   *%eax
}
c010552c:	c9                   	leave  
c010552d:	c3                   	ret    

c010552e <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010552e:	55                   	push   %ebp
c010552f:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105531:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105535:	7e 14                	jle    c010554b <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105537:	8b 45 08             	mov    0x8(%ebp),%eax
c010553a:	8b 00                	mov    (%eax),%eax
c010553c:	8d 48 08             	lea    0x8(%eax),%ecx
c010553f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105542:	89 0a                	mov    %ecx,(%edx)
c0105544:	8b 50 04             	mov    0x4(%eax),%edx
c0105547:	8b 00                	mov    (%eax),%eax
c0105549:	eb 30                	jmp    c010557b <getuint+0x4d>
    }
    else if (lflag) {
c010554b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010554f:	74 16                	je     c0105567 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0105551:	8b 45 08             	mov    0x8(%ebp),%eax
c0105554:	8b 00                	mov    (%eax),%eax
c0105556:	8d 48 04             	lea    0x4(%eax),%ecx
c0105559:	8b 55 08             	mov    0x8(%ebp),%edx
c010555c:	89 0a                	mov    %ecx,(%edx)
c010555e:	8b 00                	mov    (%eax),%eax
c0105560:	ba 00 00 00 00       	mov    $0x0,%edx
c0105565:	eb 14                	jmp    c010557b <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105567:	8b 45 08             	mov    0x8(%ebp),%eax
c010556a:	8b 00                	mov    (%eax),%eax
c010556c:	8d 48 04             	lea    0x4(%eax),%ecx
c010556f:	8b 55 08             	mov    0x8(%ebp),%edx
c0105572:	89 0a                	mov    %ecx,(%edx)
c0105574:	8b 00                	mov    (%eax),%eax
c0105576:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010557b:	5d                   	pop    %ebp
c010557c:	c3                   	ret    

c010557d <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010557d:	55                   	push   %ebp
c010557e:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105580:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105584:	7e 14                	jle    c010559a <getint+0x1d>
        return va_arg(*ap, long long);
c0105586:	8b 45 08             	mov    0x8(%ebp),%eax
c0105589:	8b 00                	mov    (%eax),%eax
c010558b:	8d 48 08             	lea    0x8(%eax),%ecx
c010558e:	8b 55 08             	mov    0x8(%ebp),%edx
c0105591:	89 0a                	mov    %ecx,(%edx)
c0105593:	8b 50 04             	mov    0x4(%eax),%edx
c0105596:	8b 00                	mov    (%eax),%eax
c0105598:	eb 28                	jmp    c01055c2 <getint+0x45>
    }
    else if (lflag) {
c010559a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010559e:	74 12                	je     c01055b2 <getint+0x35>
        return va_arg(*ap, long);
c01055a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01055a3:	8b 00                	mov    (%eax),%eax
c01055a5:	8d 48 04             	lea    0x4(%eax),%ecx
c01055a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01055ab:	89 0a                	mov    %ecx,(%edx)
c01055ad:	8b 00                	mov    (%eax),%eax
c01055af:	99                   	cltd   
c01055b0:	eb 10                	jmp    c01055c2 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c01055b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01055b5:	8b 00                	mov    (%eax),%eax
c01055b7:	8d 48 04             	lea    0x4(%eax),%ecx
c01055ba:	8b 55 08             	mov    0x8(%ebp),%edx
c01055bd:	89 0a                	mov    %ecx,(%edx)
c01055bf:	8b 00                	mov    (%eax),%eax
c01055c1:	99                   	cltd   
    }
}
c01055c2:	5d                   	pop    %ebp
c01055c3:	c3                   	ret    

c01055c4 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01055c4:	55                   	push   %ebp
c01055c5:	89 e5                	mov    %esp,%ebp
c01055c7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01055ca:	8d 45 14             	lea    0x14(%ebp),%eax
c01055cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c01055d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055d7:	8b 45 10             	mov    0x10(%ebp),%eax
c01055da:	89 44 24 08          	mov    %eax,0x8(%esp)
c01055de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01055e1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01055e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055e8:	89 04 24             	mov    %eax,(%esp)
c01055eb:	e8 02 00 00 00       	call   c01055f2 <vprintfmt>
    va_end(ap);
}
c01055f0:	c9                   	leave  
c01055f1:	c3                   	ret    

c01055f2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01055f2:	55                   	push   %ebp
c01055f3:	89 e5                	mov    %esp,%ebp
c01055f5:	56                   	push   %esi
c01055f6:	53                   	push   %ebx
c01055f7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01055fa:	eb 18                	jmp    c0105614 <vprintfmt+0x22>
            if (ch == '\0') {
c01055fc:	85 db                	test   %ebx,%ebx
c01055fe:	75 05                	jne    c0105605 <vprintfmt+0x13>
                return;
c0105600:	e9 d1 03 00 00       	jmp    c01059d6 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
c0105605:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105608:	89 44 24 04          	mov    %eax,0x4(%esp)
c010560c:	89 1c 24             	mov    %ebx,(%esp)
c010560f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105612:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105614:	8b 45 10             	mov    0x10(%ebp),%eax
c0105617:	8d 50 01             	lea    0x1(%eax),%edx
c010561a:	89 55 10             	mov    %edx,0x10(%ebp)
c010561d:	0f b6 00             	movzbl (%eax),%eax
c0105620:	0f b6 d8             	movzbl %al,%ebx
c0105623:	83 fb 25             	cmp    $0x25,%ebx
c0105626:	75 d4                	jne    c01055fc <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105628:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010562c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105633:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105636:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105639:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105640:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105643:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105646:	8b 45 10             	mov    0x10(%ebp),%eax
c0105649:	8d 50 01             	lea    0x1(%eax),%edx
c010564c:	89 55 10             	mov    %edx,0x10(%ebp)
c010564f:	0f b6 00             	movzbl (%eax),%eax
c0105652:	0f b6 d8             	movzbl %al,%ebx
c0105655:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105658:	83 f8 55             	cmp    $0x55,%eax
c010565b:	0f 87 44 03 00 00    	ja     c01059a5 <vprintfmt+0x3b3>
c0105661:	8b 04 85 00 71 10 c0 	mov    -0x3fef8f00(,%eax,4),%eax
c0105668:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010566a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010566e:	eb d6                	jmp    c0105646 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105670:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105674:	eb d0                	jmp    c0105646 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105676:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010567d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105680:	89 d0                	mov    %edx,%eax
c0105682:	c1 e0 02             	shl    $0x2,%eax
c0105685:	01 d0                	add    %edx,%eax
c0105687:	01 c0                	add    %eax,%eax
c0105689:	01 d8                	add    %ebx,%eax
c010568b:	83 e8 30             	sub    $0x30,%eax
c010568e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105691:	8b 45 10             	mov    0x10(%ebp),%eax
c0105694:	0f b6 00             	movzbl (%eax),%eax
c0105697:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010569a:	83 fb 2f             	cmp    $0x2f,%ebx
c010569d:	7e 0b                	jle    c01056aa <vprintfmt+0xb8>
c010569f:	83 fb 39             	cmp    $0x39,%ebx
c01056a2:	7f 06                	jg     c01056aa <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c01056a4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01056a8:	eb d3                	jmp    c010567d <vprintfmt+0x8b>
            goto process_precision;
c01056aa:	eb 33                	jmp    c01056df <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
c01056ac:	8b 45 14             	mov    0x14(%ebp),%eax
c01056af:	8d 50 04             	lea    0x4(%eax),%edx
c01056b2:	89 55 14             	mov    %edx,0x14(%ebp)
c01056b5:	8b 00                	mov    (%eax),%eax
c01056b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01056ba:	eb 23                	jmp    c01056df <vprintfmt+0xed>

        case '.':
            if (width < 0)
c01056bc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056c0:	79 0c                	jns    c01056ce <vprintfmt+0xdc>
                width = 0;
c01056c2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01056c9:	e9 78 ff ff ff       	jmp    c0105646 <vprintfmt+0x54>
c01056ce:	e9 73 ff ff ff       	jmp    c0105646 <vprintfmt+0x54>

        case '#':
            altflag = 1;
c01056d3:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01056da:	e9 67 ff ff ff       	jmp    c0105646 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
c01056df:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01056e3:	79 12                	jns    c01056f7 <vprintfmt+0x105>
                width = precision, precision = -1;
c01056e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056e8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056eb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01056f2:	e9 4f ff ff ff       	jmp    c0105646 <vprintfmt+0x54>
c01056f7:	e9 4a ff ff ff       	jmp    c0105646 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01056fc:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c0105700:	e9 41 ff ff ff       	jmp    c0105646 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105705:	8b 45 14             	mov    0x14(%ebp),%eax
c0105708:	8d 50 04             	lea    0x4(%eax),%edx
c010570b:	89 55 14             	mov    %edx,0x14(%ebp)
c010570e:	8b 00                	mov    (%eax),%eax
c0105710:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105713:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105717:	89 04 24             	mov    %eax,(%esp)
c010571a:	8b 45 08             	mov    0x8(%ebp),%eax
c010571d:	ff d0                	call   *%eax
            break;
c010571f:	e9 ac 02 00 00       	jmp    c01059d0 <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105724:	8b 45 14             	mov    0x14(%ebp),%eax
c0105727:	8d 50 04             	lea    0x4(%eax),%edx
c010572a:	89 55 14             	mov    %edx,0x14(%ebp)
c010572d:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010572f:	85 db                	test   %ebx,%ebx
c0105731:	79 02                	jns    c0105735 <vprintfmt+0x143>
                err = -err;
c0105733:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105735:	83 fb 06             	cmp    $0x6,%ebx
c0105738:	7f 0b                	jg     c0105745 <vprintfmt+0x153>
c010573a:	8b 34 9d c0 70 10 c0 	mov    -0x3fef8f40(,%ebx,4),%esi
c0105741:	85 f6                	test   %esi,%esi
c0105743:	75 23                	jne    c0105768 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
c0105745:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105749:	c7 44 24 08 ed 70 10 	movl   $0xc01070ed,0x8(%esp)
c0105750:	c0 
c0105751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105754:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105758:	8b 45 08             	mov    0x8(%ebp),%eax
c010575b:	89 04 24             	mov    %eax,(%esp)
c010575e:	e8 61 fe ff ff       	call   c01055c4 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105763:	e9 68 02 00 00       	jmp    c01059d0 <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105768:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010576c:	c7 44 24 08 f6 70 10 	movl   $0xc01070f6,0x8(%esp)
c0105773:	c0 
c0105774:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105777:	89 44 24 04          	mov    %eax,0x4(%esp)
c010577b:	8b 45 08             	mov    0x8(%ebp),%eax
c010577e:	89 04 24             	mov    %eax,(%esp)
c0105781:	e8 3e fe ff ff       	call   c01055c4 <printfmt>
            }
            break;
c0105786:	e9 45 02 00 00       	jmp    c01059d0 <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010578b:	8b 45 14             	mov    0x14(%ebp),%eax
c010578e:	8d 50 04             	lea    0x4(%eax),%edx
c0105791:	89 55 14             	mov    %edx,0x14(%ebp)
c0105794:	8b 30                	mov    (%eax),%esi
c0105796:	85 f6                	test   %esi,%esi
c0105798:	75 05                	jne    c010579f <vprintfmt+0x1ad>
                p = "(null)";
c010579a:	be f9 70 10 c0       	mov    $0xc01070f9,%esi
            }
            if (width > 0 && padc != '-') {
c010579f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057a3:	7e 3e                	jle    c01057e3 <vprintfmt+0x1f1>
c01057a5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c01057a9:	74 38                	je     c01057e3 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057ab:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c01057ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057b1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057b5:	89 34 24             	mov    %esi,(%esp)
c01057b8:	e8 15 03 00 00       	call   c0105ad2 <strnlen>
c01057bd:	29 c3                	sub    %eax,%ebx
c01057bf:	89 d8                	mov    %ebx,%eax
c01057c1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01057c4:	eb 17                	jmp    c01057dd <vprintfmt+0x1eb>
                    putch(padc, putdat);
c01057c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01057ca:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057cd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057d1:	89 04 24             	mov    %eax,(%esp)
c01057d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01057d7:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01057d9:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01057dd:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01057e1:	7f e3                	jg     c01057c6 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01057e3:	eb 38                	jmp    c010581d <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
c01057e5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01057e9:	74 1f                	je     c010580a <vprintfmt+0x218>
c01057eb:	83 fb 1f             	cmp    $0x1f,%ebx
c01057ee:	7e 05                	jle    c01057f5 <vprintfmt+0x203>
c01057f0:	83 fb 7e             	cmp    $0x7e,%ebx
c01057f3:	7e 15                	jle    c010580a <vprintfmt+0x218>
                    putch('?', putdat);
c01057f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057fc:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105803:	8b 45 08             	mov    0x8(%ebp),%eax
c0105806:	ff d0                	call   *%eax
c0105808:	eb 0f                	jmp    c0105819 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
c010580a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010580d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105811:	89 1c 24             	mov    %ebx,(%esp)
c0105814:	8b 45 08             	mov    0x8(%ebp),%eax
c0105817:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105819:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010581d:	89 f0                	mov    %esi,%eax
c010581f:	8d 70 01             	lea    0x1(%eax),%esi
c0105822:	0f b6 00             	movzbl (%eax),%eax
c0105825:	0f be d8             	movsbl %al,%ebx
c0105828:	85 db                	test   %ebx,%ebx
c010582a:	74 10                	je     c010583c <vprintfmt+0x24a>
c010582c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105830:	78 b3                	js     c01057e5 <vprintfmt+0x1f3>
c0105832:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105836:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010583a:	79 a9                	jns    c01057e5 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010583c:	eb 17                	jmp    c0105855 <vprintfmt+0x263>
                putch(' ', putdat);
c010583e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105841:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105845:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010584c:	8b 45 08             	mov    0x8(%ebp),%eax
c010584f:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105851:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105855:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105859:	7f e3                	jg     c010583e <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
c010585b:	e9 70 01 00 00       	jmp    c01059d0 <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105860:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105863:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105867:	8d 45 14             	lea    0x14(%ebp),%eax
c010586a:	89 04 24             	mov    %eax,(%esp)
c010586d:	e8 0b fd ff ff       	call   c010557d <getint>
c0105872:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105875:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105878:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010587b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010587e:	85 d2                	test   %edx,%edx
c0105880:	79 26                	jns    c01058a8 <vprintfmt+0x2b6>
                putch('-', putdat);
c0105882:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105885:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105889:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105890:	8b 45 08             	mov    0x8(%ebp),%eax
c0105893:	ff d0                	call   *%eax
                num = -(long long)num;
c0105895:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105898:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010589b:	f7 d8                	neg    %eax
c010589d:	83 d2 00             	adc    $0x0,%edx
c01058a0:	f7 da                	neg    %edx
c01058a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01058a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058af:	e9 a8 00 00 00       	jmp    c010595c <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01058b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bb:	8d 45 14             	lea    0x14(%ebp),%eax
c01058be:	89 04 24             	mov    %eax,(%esp)
c01058c1:	e8 68 fc ff ff       	call   c010552e <getuint>
c01058c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01058cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01058d3:	e9 84 00 00 00       	jmp    c010595c <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01058d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058df:	8d 45 14             	lea    0x14(%ebp),%eax
c01058e2:	89 04 24             	mov    %eax,(%esp)
c01058e5:	e8 44 fc ff ff       	call   c010552e <getuint>
c01058ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01058f0:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01058f7:	eb 63                	jmp    c010595c <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
c01058f9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058fc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105900:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105907:	8b 45 08             	mov    0x8(%ebp),%eax
c010590a:	ff d0                	call   *%eax
            putch('x', putdat);
c010590c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010590f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105913:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010591a:	8b 45 08             	mov    0x8(%ebp),%eax
c010591d:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010591f:	8b 45 14             	mov    0x14(%ebp),%eax
c0105922:	8d 50 04             	lea    0x4(%eax),%edx
c0105925:	89 55 14             	mov    %edx,0x14(%ebp)
c0105928:	8b 00                	mov    (%eax),%eax
c010592a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010592d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105934:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010593b:	eb 1f                	jmp    c010595c <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010593d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105940:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105944:	8d 45 14             	lea    0x14(%ebp),%eax
c0105947:	89 04 24             	mov    %eax,(%esp)
c010594a:	e8 df fb ff ff       	call   c010552e <getuint>
c010594f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105952:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105955:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010595c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105960:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105963:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105967:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010596a:	89 54 24 14          	mov    %edx,0x14(%esp)
c010596e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105972:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105975:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105978:	89 44 24 08          	mov    %eax,0x8(%esp)
c010597c:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105980:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105983:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105987:	8b 45 08             	mov    0x8(%ebp),%eax
c010598a:	89 04 24             	mov    %eax,(%esp)
c010598d:	e8 97 fa ff ff       	call   c0105429 <printnum>
            break;
c0105992:	eb 3c                	jmp    c01059d0 <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105994:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105997:	89 44 24 04          	mov    %eax,0x4(%esp)
c010599b:	89 1c 24             	mov    %ebx,(%esp)
c010599e:	8b 45 08             	mov    0x8(%ebp),%eax
c01059a1:	ff d0                	call   *%eax
            break;
c01059a3:	eb 2b                	jmp    c01059d0 <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c01059a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059a8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059ac:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01059b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b6:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01059b8:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059bc:	eb 04                	jmp    c01059c2 <vprintfmt+0x3d0>
c01059be:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01059c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01059c5:	83 e8 01             	sub    $0x1,%eax
c01059c8:	0f b6 00             	movzbl (%eax),%eax
c01059cb:	3c 25                	cmp    $0x25,%al
c01059cd:	75 ef                	jne    c01059be <vprintfmt+0x3cc>
                /* do nothing */;
            break;
c01059cf:	90                   	nop
        }
    }
c01059d0:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01059d1:	e9 3e fc ff ff       	jmp    c0105614 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01059d6:	83 c4 40             	add    $0x40,%esp
c01059d9:	5b                   	pop    %ebx
c01059da:	5e                   	pop    %esi
c01059db:	5d                   	pop    %ebp
c01059dc:	c3                   	ret    

c01059dd <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01059dd:	55                   	push   %ebp
c01059de:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01059e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059e3:	8b 40 08             	mov    0x8(%eax),%eax
c01059e6:	8d 50 01             	lea    0x1(%eax),%edx
c01059e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ec:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01059ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f2:	8b 10                	mov    (%eax),%edx
c01059f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059f7:	8b 40 04             	mov    0x4(%eax),%eax
c01059fa:	39 c2                	cmp    %eax,%edx
c01059fc:	73 12                	jae    c0105a10 <sprintputch+0x33>
        *b->buf ++ = ch;
c01059fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a01:	8b 00                	mov    (%eax),%eax
c0105a03:	8d 48 01             	lea    0x1(%eax),%ecx
c0105a06:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a09:	89 0a                	mov    %ecx,(%edx)
c0105a0b:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a0e:	88 10                	mov    %dl,(%eax)
    }
}
c0105a10:	5d                   	pop    %ebp
c0105a11:	c3                   	ret    

c0105a12 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105a12:	55                   	push   %ebp
c0105a13:	89 e5                	mov    %esp,%ebp
c0105a15:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105a18:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a21:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a25:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a28:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a2c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a36:	89 04 24             	mov    %eax,(%esp)
c0105a39:	e8 08 00 00 00       	call   c0105a46 <vsnprintf>
c0105a3e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105a41:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a44:	c9                   	leave  
c0105a45:	c3                   	ret    

c0105a46 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105a46:	55                   	push   %ebp
c0105a47:	89 e5                	mov    %esp,%ebp
c0105a49:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105a4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a55:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105a58:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a5b:	01 d0                	add    %edx,%eax
c0105a5d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a60:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105a67:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105a6b:	74 0a                	je     c0105a77 <vsnprintf+0x31>
c0105a6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105a70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a73:	39 c2                	cmp    %eax,%edx
c0105a75:	76 07                	jbe    c0105a7e <vsnprintf+0x38>
        return -E_INVAL;
c0105a77:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105a7c:	eb 2a                	jmp    c0105aa8 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105a7e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a81:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a85:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a88:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a8c:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a93:	c7 04 24 dd 59 10 c0 	movl   $0xc01059dd,(%esp)
c0105a9a:	e8 53 fb ff ff       	call   c01055f2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105a9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105aa2:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105aa5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105aa8:	c9                   	leave  
c0105aa9:	c3                   	ret    

c0105aaa <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105aaa:	55                   	push   %ebp
c0105aab:	89 e5                	mov    %esp,%ebp
c0105aad:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ab0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105ab7:	eb 04                	jmp    c0105abd <strlen+0x13>
        cnt ++;
c0105ab9:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105abd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ac0:	8d 50 01             	lea    0x1(%eax),%edx
c0105ac3:	89 55 08             	mov    %edx,0x8(%ebp)
c0105ac6:	0f b6 00             	movzbl (%eax),%eax
c0105ac9:	84 c0                	test   %al,%al
c0105acb:	75 ec                	jne    c0105ab9 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105acd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105ad0:	c9                   	leave  
c0105ad1:	c3                   	ret    

c0105ad2 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105ad2:	55                   	push   %ebp
c0105ad3:	89 e5                	mov    %esp,%ebp
c0105ad5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105ad8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105adf:	eb 04                	jmp    c0105ae5 <strnlen+0x13>
        cnt ++;
c0105ae1:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105ae5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105ae8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105aeb:	73 10                	jae    c0105afd <strnlen+0x2b>
c0105aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af0:	8d 50 01             	lea    0x1(%eax),%edx
c0105af3:	89 55 08             	mov    %edx,0x8(%ebp)
c0105af6:	0f b6 00             	movzbl (%eax),%eax
c0105af9:	84 c0                	test   %al,%al
c0105afb:	75 e4                	jne    c0105ae1 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105afd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105b00:	c9                   	leave  
c0105b01:	c3                   	ret    

c0105b02 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105b02:	55                   	push   %ebp
c0105b03:	89 e5                	mov    %esp,%ebp
c0105b05:	57                   	push   %edi
c0105b06:	56                   	push   %esi
c0105b07:	83 ec 20             	sub    $0x20,%esp
c0105b0a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b13:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b1c:	89 d1                	mov    %edx,%ecx
c0105b1e:	89 c2                	mov    %eax,%edx
c0105b20:	89 ce                	mov    %ecx,%esi
c0105b22:	89 d7                	mov    %edx,%edi
c0105b24:	ac                   	lods   %ds:(%esi),%al
c0105b25:	aa                   	stos   %al,%es:(%edi)
c0105b26:	84 c0                	test   %al,%al
c0105b28:	75 fa                	jne    c0105b24 <strcpy+0x22>
c0105b2a:	89 fa                	mov    %edi,%edx
c0105b2c:	89 f1                	mov    %esi,%ecx
c0105b2e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105b31:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0105b34:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105b37:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105b3a:	83 c4 20             	add    $0x20,%esp
c0105b3d:	5e                   	pop    %esi
c0105b3e:	5f                   	pop    %edi
c0105b3f:	5d                   	pop    %ebp
c0105b40:	c3                   	ret    

c0105b41 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105b41:	55                   	push   %ebp
c0105b42:	89 e5                	mov    %esp,%ebp
c0105b44:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105b47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105b4d:	eb 21                	jmp    c0105b70 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b52:	0f b6 10             	movzbl (%eax),%edx
c0105b55:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b58:	88 10                	mov    %dl,(%eax)
c0105b5a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105b5d:	0f b6 00             	movzbl (%eax),%eax
c0105b60:	84 c0                	test   %al,%al
c0105b62:	74 04                	je     c0105b68 <strncpy+0x27>
            src ++;
c0105b64:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105b68:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105b6c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105b70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105b74:	75 d9                	jne    c0105b4f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105b76:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105b79:	c9                   	leave  
c0105b7a:	c3                   	ret    

c0105b7b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105b7b:	55                   	push   %ebp
c0105b7c:	89 e5                	mov    %esp,%ebp
c0105b7e:	57                   	push   %edi
c0105b7f:	56                   	push   %esi
c0105b80:	83 ec 20             	sub    $0x20,%esp
c0105b83:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b86:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105b89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b8c:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105b8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b92:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b95:	89 d1                	mov    %edx,%ecx
c0105b97:	89 c2                	mov    %eax,%edx
c0105b99:	89 ce                	mov    %ecx,%esi
c0105b9b:	89 d7                	mov    %edx,%edi
c0105b9d:	ac                   	lods   %ds:(%esi),%al
c0105b9e:	ae                   	scas   %es:(%edi),%al
c0105b9f:	75 08                	jne    c0105ba9 <strcmp+0x2e>
c0105ba1:	84 c0                	test   %al,%al
c0105ba3:	75 f8                	jne    c0105b9d <strcmp+0x22>
c0105ba5:	31 c0                	xor    %eax,%eax
c0105ba7:	eb 04                	jmp    c0105bad <strcmp+0x32>
c0105ba9:	19 c0                	sbb    %eax,%eax
c0105bab:	0c 01                	or     $0x1,%al
c0105bad:	89 fa                	mov    %edi,%edx
c0105baf:	89 f1                	mov    %esi,%ecx
c0105bb1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105bb4:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105bb7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105bba:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105bbd:	83 c4 20             	add    $0x20,%esp
c0105bc0:	5e                   	pop    %esi
c0105bc1:	5f                   	pop    %edi
c0105bc2:	5d                   	pop    %ebp
c0105bc3:	c3                   	ret    

c0105bc4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105bc4:	55                   	push   %ebp
c0105bc5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bc7:	eb 0c                	jmp    c0105bd5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105bc9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105bcd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105bd1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105bd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bd9:	74 1a                	je     c0105bf5 <strncmp+0x31>
c0105bdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bde:	0f b6 00             	movzbl (%eax),%eax
c0105be1:	84 c0                	test   %al,%al
c0105be3:	74 10                	je     c0105bf5 <strncmp+0x31>
c0105be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105be8:	0f b6 10             	movzbl (%eax),%edx
c0105beb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bee:	0f b6 00             	movzbl (%eax),%eax
c0105bf1:	38 c2                	cmp    %al,%dl
c0105bf3:	74 d4                	je     c0105bc9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105bf5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105bf9:	74 18                	je     c0105c13 <strncmp+0x4f>
c0105bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfe:	0f b6 00             	movzbl (%eax),%eax
c0105c01:	0f b6 d0             	movzbl %al,%edx
c0105c04:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c07:	0f b6 00             	movzbl (%eax),%eax
c0105c0a:	0f b6 c0             	movzbl %al,%eax
c0105c0d:	29 c2                	sub    %eax,%edx
c0105c0f:	89 d0                	mov    %edx,%eax
c0105c11:	eb 05                	jmp    c0105c18 <strncmp+0x54>
c0105c13:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c18:	5d                   	pop    %ebp
c0105c19:	c3                   	ret    

c0105c1a <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105c1a:	55                   	push   %ebp
c0105c1b:	89 e5                	mov    %esp,%ebp
c0105c1d:	83 ec 04             	sub    $0x4,%esp
c0105c20:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c23:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c26:	eb 14                	jmp    c0105c3c <strchr+0x22>
        if (*s == c) {
c0105c28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c2b:	0f b6 00             	movzbl (%eax),%eax
c0105c2e:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c31:	75 05                	jne    c0105c38 <strchr+0x1e>
            return (char *)s;
c0105c33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c36:	eb 13                	jmp    c0105c4b <strchr+0x31>
        }
        s ++;
c0105c38:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105c3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c3f:	0f b6 00             	movzbl (%eax),%eax
c0105c42:	84 c0                	test   %al,%al
c0105c44:	75 e2                	jne    c0105c28 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105c46:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105c4b:	c9                   	leave  
c0105c4c:	c3                   	ret    

c0105c4d <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105c4d:	55                   	push   %ebp
c0105c4e:	89 e5                	mov    %esp,%ebp
c0105c50:	83 ec 04             	sub    $0x4,%esp
c0105c53:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c56:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105c59:	eb 11                	jmp    c0105c6c <strfind+0x1f>
        if (*s == c) {
c0105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5e:	0f b6 00             	movzbl (%eax),%eax
c0105c61:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105c64:	75 02                	jne    c0105c68 <strfind+0x1b>
            break;
c0105c66:	eb 0e                	jmp    c0105c76 <strfind+0x29>
        }
        s ++;
c0105c68:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6f:	0f b6 00             	movzbl (%eax),%eax
c0105c72:	84 c0                	test   %al,%al
c0105c74:	75 e5                	jne    c0105c5b <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
c0105c76:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105c79:	c9                   	leave  
c0105c7a:	c3                   	ret    

c0105c7b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105c7b:	55                   	push   %ebp
c0105c7c:	89 e5                	mov    %esp,%ebp
c0105c7e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105c81:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105c88:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c8f:	eb 04                	jmp    c0105c95 <strtol+0x1a>
        s ++;
c0105c91:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c98:	0f b6 00             	movzbl (%eax),%eax
c0105c9b:	3c 20                	cmp    $0x20,%al
c0105c9d:	74 f2                	je     c0105c91 <strtol+0x16>
c0105c9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca2:	0f b6 00             	movzbl (%eax),%eax
c0105ca5:	3c 09                	cmp    $0x9,%al
c0105ca7:	74 e8                	je     c0105c91 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105ca9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cac:	0f b6 00             	movzbl (%eax),%eax
c0105caf:	3c 2b                	cmp    $0x2b,%al
c0105cb1:	75 06                	jne    c0105cb9 <strtol+0x3e>
        s ++;
c0105cb3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cb7:	eb 15                	jmp    c0105cce <strtol+0x53>
    }
    else if (*s == '-') {
c0105cb9:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cbc:	0f b6 00             	movzbl (%eax),%eax
c0105cbf:	3c 2d                	cmp    $0x2d,%al
c0105cc1:	75 0b                	jne    c0105cce <strtol+0x53>
        s ++, neg = 1;
c0105cc3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105cc7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105cd2:	74 06                	je     c0105cda <strtol+0x5f>
c0105cd4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105cd8:	75 24                	jne    c0105cfe <strtol+0x83>
c0105cda:	8b 45 08             	mov    0x8(%ebp),%eax
c0105cdd:	0f b6 00             	movzbl (%eax),%eax
c0105ce0:	3c 30                	cmp    $0x30,%al
c0105ce2:	75 1a                	jne    c0105cfe <strtol+0x83>
c0105ce4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce7:	83 c0 01             	add    $0x1,%eax
c0105cea:	0f b6 00             	movzbl (%eax),%eax
c0105ced:	3c 78                	cmp    $0x78,%al
c0105cef:	75 0d                	jne    c0105cfe <strtol+0x83>
        s += 2, base = 16;
c0105cf1:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105cf5:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105cfc:	eb 2a                	jmp    c0105d28 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105cfe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d02:	75 17                	jne    c0105d1b <strtol+0xa0>
c0105d04:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d07:	0f b6 00             	movzbl (%eax),%eax
c0105d0a:	3c 30                	cmp    $0x30,%al
c0105d0c:	75 0d                	jne    c0105d1b <strtol+0xa0>
        s ++, base = 8;
c0105d0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105d12:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105d19:	eb 0d                	jmp    c0105d28 <strtol+0xad>
    }
    else if (base == 0) {
c0105d1b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105d1f:	75 07                	jne    c0105d28 <strtol+0xad>
        base = 10;
c0105d21:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105d28:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d2b:	0f b6 00             	movzbl (%eax),%eax
c0105d2e:	3c 2f                	cmp    $0x2f,%al
c0105d30:	7e 1b                	jle    c0105d4d <strtol+0xd2>
c0105d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d35:	0f b6 00             	movzbl (%eax),%eax
c0105d38:	3c 39                	cmp    $0x39,%al
c0105d3a:	7f 11                	jg     c0105d4d <strtol+0xd2>
            dig = *s - '0';
c0105d3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d3f:	0f b6 00             	movzbl (%eax),%eax
c0105d42:	0f be c0             	movsbl %al,%eax
c0105d45:	83 e8 30             	sub    $0x30,%eax
c0105d48:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d4b:	eb 48                	jmp    c0105d95 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d50:	0f b6 00             	movzbl (%eax),%eax
c0105d53:	3c 60                	cmp    $0x60,%al
c0105d55:	7e 1b                	jle    c0105d72 <strtol+0xf7>
c0105d57:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5a:	0f b6 00             	movzbl (%eax),%eax
c0105d5d:	3c 7a                	cmp    $0x7a,%al
c0105d5f:	7f 11                	jg     c0105d72 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0105d61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d64:	0f b6 00             	movzbl (%eax),%eax
c0105d67:	0f be c0             	movsbl %al,%eax
c0105d6a:	83 e8 57             	sub    $0x57,%eax
c0105d6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105d70:	eb 23                	jmp    c0105d95 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0105d72:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d75:	0f b6 00             	movzbl (%eax),%eax
c0105d78:	3c 40                	cmp    $0x40,%al
c0105d7a:	7e 3d                	jle    c0105db9 <strtol+0x13e>
c0105d7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d7f:	0f b6 00             	movzbl (%eax),%eax
c0105d82:	3c 5a                	cmp    $0x5a,%al
c0105d84:	7f 33                	jg     c0105db9 <strtol+0x13e>
            dig = *s - 'A' + 10;
c0105d86:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d89:	0f b6 00             	movzbl (%eax),%eax
c0105d8c:	0f be c0             	movsbl %al,%eax
c0105d8f:	83 e8 37             	sub    $0x37,%eax
c0105d92:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0105d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d98:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105d9b:	7c 02                	jl     c0105d9f <strtol+0x124>
            break;
c0105d9d:	eb 1a                	jmp    c0105db9 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
c0105d9f:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105da3:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105da6:	0f af 45 10          	imul   0x10(%ebp),%eax
c0105daa:	89 c2                	mov    %eax,%edx
c0105dac:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105daf:	01 d0                	add    %edx,%eax
c0105db1:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0105db4:	e9 6f ff ff ff       	jmp    c0105d28 <strtol+0xad>

    if (endptr) {
c0105db9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105dbd:	74 08                	je     c0105dc7 <strtol+0x14c>
        *endptr = (char *) s;
c0105dbf:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dc2:	8b 55 08             	mov    0x8(%ebp),%edx
c0105dc5:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0105dc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0105dcb:	74 07                	je     c0105dd4 <strtol+0x159>
c0105dcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105dd0:	f7 d8                	neg    %eax
c0105dd2:	eb 03                	jmp    c0105dd7 <strtol+0x15c>
c0105dd4:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105dd7:	c9                   	leave  
c0105dd8:	c3                   	ret    

c0105dd9 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105dd9:	55                   	push   %ebp
c0105dda:	89 e5                	mov    %esp,%ebp
c0105ddc:	57                   	push   %edi
c0105ddd:	83 ec 24             	sub    $0x24,%esp
c0105de0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105de3:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0105de6:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105dea:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105df0:	88 45 f7             	mov    %al,-0x9(%ebp)
c0105df3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105df9:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105dfc:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105e00:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0105e03:	89 d7                	mov    %edx,%edi
c0105e05:	f3 aa                	rep stos %al,%es:(%edi)
c0105e07:	89 fa                	mov    %edi,%edx
c0105e09:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105e0c:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105e0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0105e12:	83 c4 24             	add    $0x24,%esp
c0105e15:	5f                   	pop    %edi
c0105e16:	5d                   	pop    %ebp
c0105e17:	c3                   	ret    

c0105e18 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105e18:	55                   	push   %ebp
c0105e19:	89 e5                	mov    %esp,%ebp
c0105e1b:	57                   	push   %edi
c0105e1c:	56                   	push   %esi
c0105e1d:	53                   	push   %ebx
c0105e1e:	83 ec 30             	sub    $0x30,%esp
c0105e21:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e24:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e27:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e2a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105e2d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e30:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0105e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e36:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105e39:	73 42                	jae    c0105e7d <memmove+0x65>
c0105e3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105e41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e44:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105e47:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e4a:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105e4d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105e50:	c1 e8 02             	shr    $0x2,%eax
c0105e53:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105e55:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105e58:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e5b:	89 d7                	mov    %edx,%edi
c0105e5d:	89 c6                	mov    %eax,%esi
c0105e5f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105e61:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e64:	83 e1 03             	and    $0x3,%ecx
c0105e67:	74 02                	je     c0105e6b <memmove+0x53>
c0105e69:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105e6b:	89 f0                	mov    %esi,%eax
c0105e6d:	89 fa                	mov    %edi,%edx
c0105e6f:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0105e72:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105e75:	89 45 d0             	mov    %eax,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105e78:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e7b:	eb 36                	jmp    c0105eb3 <memmove+0x9b>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0105e7d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e80:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105e83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e86:	01 c2                	add    %eax,%edx
c0105e88:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e8b:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0105e8e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e91:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0105e94:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e97:	89 c1                	mov    %eax,%ecx
c0105e99:	89 d8                	mov    %ebx,%eax
c0105e9b:	89 d6                	mov    %edx,%esi
c0105e9d:	89 c7                	mov    %eax,%edi
c0105e9f:	fd                   	std    
c0105ea0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ea2:	fc                   	cld    
c0105ea3:	89 f8                	mov    %edi,%eax
c0105ea5:	89 f2                	mov    %esi,%edx
c0105ea7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0105eaa:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0105ead:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0105eb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0105eb3:	83 c4 30             	add    $0x30,%esp
c0105eb6:	5b                   	pop    %ebx
c0105eb7:	5e                   	pop    %esi
c0105eb8:	5f                   	pop    %edi
c0105eb9:	5d                   	pop    %ebp
c0105eba:	c3                   	ret    

c0105ebb <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0105ebb:	55                   	push   %ebp
c0105ebc:	89 e5                	mov    %esp,%ebp
c0105ebe:	57                   	push   %edi
c0105ebf:	56                   	push   %esi
c0105ec0:	83 ec 20             	sub    $0x20,%esp
c0105ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ec6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105ec9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ecc:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105ecf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ed2:	89 45 ec             	mov    %eax,-0x14(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105ed5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ed8:	c1 e8 02             	shr    $0x2,%eax
c0105edb:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0105edd:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ee0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ee3:	89 d7                	mov    %edx,%edi
c0105ee5:	89 c6                	mov    %eax,%esi
c0105ee7:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105ee9:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105eec:	83 e1 03             	and    $0x3,%ecx
c0105eef:	74 02                	je     c0105ef3 <memcpy+0x38>
c0105ef1:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105ef3:	89 f0                	mov    %esi,%eax
c0105ef5:	89 fa                	mov    %edi,%edx
c0105ef7:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105efa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105efd:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0105f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0105f03:	83 c4 20             	add    $0x20,%esp
c0105f06:	5e                   	pop    %esi
c0105f07:	5f                   	pop    %edi
c0105f08:	5d                   	pop    %ebp
c0105f09:	c3                   	ret    

c0105f0a <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105f0a:	55                   	push   %ebp
c0105f0b:	89 e5                	mov    %esp,%ebp
c0105f0d:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0105f10:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f13:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105f16:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f19:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105f1c:	eb 30                	jmp    c0105f4e <memcmp+0x44>
        if (*s1 != *s2) {
c0105f1e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f21:	0f b6 10             	movzbl (%eax),%edx
c0105f24:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f27:	0f b6 00             	movzbl (%eax),%eax
c0105f2a:	38 c2                	cmp    %al,%dl
c0105f2c:	74 18                	je     c0105f46 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105f31:	0f b6 00             	movzbl (%eax),%eax
c0105f34:	0f b6 d0             	movzbl %al,%edx
c0105f37:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105f3a:	0f b6 00             	movzbl (%eax),%eax
c0105f3d:	0f b6 c0             	movzbl %al,%eax
c0105f40:	29 c2                	sub    %eax,%edx
c0105f42:	89 d0                	mov    %edx,%eax
c0105f44:	eb 1a                	jmp    c0105f60 <memcmp+0x56>
        }
        s1 ++, s2 ++;
c0105f46:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105f4a:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0105f4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f51:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105f54:	89 55 10             	mov    %edx,0x10(%ebp)
c0105f57:	85 c0                	test   %eax,%eax
c0105f59:	75 c3                	jne    c0105f1e <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0105f5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f60:	c9                   	leave  
c0105f61:	c3                   	ret    
