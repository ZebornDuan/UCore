
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba 20 fd 10 00       	mov    $0x10fd20,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 a8 34 00 00       	call   1034d4 <memset>

    cons_init();                // init the console
  10002c:	e8 4b 15 00 00       	call   10157c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 60 36 10 00 	movl   $0x103660,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 7c 36 10 00 	movl   $0x10367c,(%esp)
  100046:	e8 d7 02 00 00       	call   100322 <cprintf>

    print_kerninfo();
  10004b:	e8 06 08 00 00       	call   100856 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8b 00 00 00       	call   1000e0 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 c0 2a 00 00       	call   102b1a <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 60 16 00 00       	call   1016bf <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 b2 17 00 00       	call   101816 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 06 0d 00 00       	call   100d6f <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 bf 15 00 00       	call   10162d <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6d 01 00 00       	call   1001e0 <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 0a 0c 00 00       	call   100ca1 <mon_backtrace>
}
  100097:	c9                   	leave  
  100098:	c3                   	ret    

00100099 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100099:	55                   	push   %ebp
  10009a:	89 e5                	mov    %esp,%ebp
  10009c:	53                   	push   %ebx
  10009d:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000a3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a6:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ac:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000b0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000b4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b8:	89 04 24             	mov    %eax,(%esp)
  1000bb:	e8 b5 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c0:	83 c4 14             	add    $0x14,%esp
  1000c3:	5b                   	pop    %ebx
  1000c4:	5d                   	pop    %ebp
  1000c5:	c3                   	ret    

001000c6 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c6:	55                   	push   %ebp
  1000c7:	89 e5                	mov    %esp,%ebp
  1000c9:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1000cf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d3:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d6:	89 04 24             	mov    %eax,(%esp)
  1000d9:	e8 bb ff ff ff       	call   100099 <grade_backtrace1>
}
  1000de:	c9                   	leave  
  1000df:	c3                   	ret    

001000e0 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e0:	55                   	push   %ebp
  1000e1:	89 e5                	mov    %esp,%ebp
  1000e3:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e6:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000eb:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f2:	ff 
  1000f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000fe:	e8 c3 ff ff ff       	call   1000c6 <grade_backtrace0>
}
  100103:	c9                   	leave  
  100104:	c3                   	ret    

00100105 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100105:	55                   	push   %ebp
  100106:	89 e5                	mov    %esp,%ebp
  100108:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  10010e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100111:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100114:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100117:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011b:	0f b7 c0             	movzwl %ax,%eax
  10011e:	83 e0 03             	and    $0x3,%eax
  100121:	89 c2                	mov    %eax,%edx
  100123:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100128:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100130:	c7 04 24 81 36 10 00 	movl   $0x103681,(%esp)
  100137:	e8 e6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100140:	0f b7 d0             	movzwl %ax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 8f 36 10 00 	movl   $0x10368f,(%esp)
  100157:	e8 c6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	0f b7 d0             	movzwl %ax,%edx
  100163:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100168:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100170:	c7 04 24 9d 36 10 00 	movl   $0x10369d,(%esp)
  100177:	e8 a6 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017c:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100180:	0f b7 d0             	movzwl %ax,%edx
  100183:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100188:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100190:	c7 04 24 ab 36 10 00 	movl   $0x1036ab,(%esp)
  100197:	e8 86 01 00 00       	call   100322 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019c:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001a0:	0f b7 d0             	movzwl %ax,%edx
  1001a3:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b0:	c7 04 24 b9 36 10 00 	movl   $0x1036b9,(%esp)
  1001b7:	e8 66 01 00 00       	call   100322 <cprintf>
    round ++;
  1001bc:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001c1:	83 c0 01             	add    $0x1,%eax
  1001c4:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c9:	c9                   	leave  
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    asm volatile (
  1001ce:	83 ec 08             	sub    $0x8,%esp
  1001d1:	cd 78                	int    $0x78
  1001d3:	89 ec                	mov    %ebp,%esp
    		"int %0 \n"
    		"movl %%ebp, %%esp \n"
    		:
    		:"i"(T_SWITCH_TOU)
    	);
}
  1001d5:	5d                   	pop    %ebp
  1001d6:	c3                   	ret    

001001d7 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d7:	55                   	push   %ebp
  1001d8:	89 e5                	mov    %esp,%ebp
	asm volatile (
  1001da:	cd 79                	int    $0x79
  1001dc:	89 ec                	mov    %ebp,%esp
			"int %0 \n"
			"movl %%ebp, %%esp \n"
			:
			:"i"(T_SWITCH_TOK)
		);
}
  1001de:	5d                   	pop    %ebp
  1001df:	c3                   	ret    

001001e0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001e0:	55                   	push   %ebp
  1001e1:	89 e5                	mov    %esp,%ebp
  1001e3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e6:	e8 1a ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001eb:	c7 04 24 c8 36 10 00 	movl   $0x1036c8,(%esp)
  1001f2:	e8 2b 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_user();
  1001f7:	e8 cf ff ff ff       	call   1001cb <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fc:	e8 04 ff ff ff       	call   100105 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100201:	c7 04 24 e8 36 10 00 	movl   $0x1036e8,(%esp)
  100208:	e8 15 01 00 00       	call   100322 <cprintf>
    lab1_switch_to_kernel();
  10020d:	e8 c5 ff ff ff       	call   1001d7 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100212:	e8 ee fe ff ff       	call   100105 <lab1_print_cur_status>
}
  100217:	c9                   	leave  
  100218:	c3                   	ret    

00100219 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100219:	55                   	push   %ebp
  10021a:	89 e5                	mov    %esp,%ebp
  10021c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10021f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100223:	74 13                	je     100238 <readline+0x1f>
        cprintf("%s", prompt);
  100225:	8b 45 08             	mov    0x8(%ebp),%eax
  100228:	89 44 24 04          	mov    %eax,0x4(%esp)
  10022c:	c7 04 24 07 37 10 00 	movl   $0x103707,(%esp)
  100233:	e8 ea 00 00 00       	call   100322 <cprintf>
    }
    int i = 0, c;
  100238:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10023f:	e8 66 01 00 00       	call   1003aa <getchar>
  100244:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100247:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10024b:	79 07                	jns    100254 <readline+0x3b>
            return NULL;
  10024d:	b8 00 00 00 00       	mov    $0x0,%eax
  100252:	eb 79                	jmp    1002cd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100254:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100258:	7e 28                	jle    100282 <readline+0x69>
  10025a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100261:	7f 1f                	jg     100282 <readline+0x69>
            cputchar(c);
  100263:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100266:	89 04 24             	mov    %eax,(%esp)
  100269:	e8 da 00 00 00       	call   100348 <cputchar>
            buf[i ++] = c;
  10026e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100271:	8d 50 01             	lea    0x1(%eax),%edx
  100274:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100277:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10027a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100280:	eb 46                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100282:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100286:	75 17                	jne    10029f <readline+0x86>
  100288:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10028c:	7e 11                	jle    10029f <readline+0x86>
            cputchar(c);
  10028e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100291:	89 04 24             	mov    %eax,(%esp)
  100294:	e8 af 00 00 00       	call   100348 <cputchar>
            i --;
  100299:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10029d:	eb 29                	jmp    1002c8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10029f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002a3:	74 06                	je     1002ab <readline+0x92>
  1002a5:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002a9:	75 1d                	jne    1002c8 <readline+0xaf>
            cputchar(c);
  1002ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002ae:	89 04 24             	mov    %eax,(%esp)
  1002b1:	e8 92 00 00 00       	call   100348 <cputchar>
            buf[i] = '\0';
  1002b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002b9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002be:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002c1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002c6:	eb 05                	jmp    1002cd <readline+0xb4>
        }
    }
  1002c8:	e9 72 ff ff ff       	jmp    10023f <readline+0x26>
}
  1002cd:	c9                   	leave  
  1002ce:	c3                   	ret    

001002cf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002cf:	55                   	push   %ebp
  1002d0:	89 e5                	mov    %esp,%ebp
  1002d2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002d8:	89 04 24             	mov    %eax,(%esp)
  1002db:	e8 c8 12 00 00       	call   1015a8 <cons_putc>
    (*cnt) ++;
  1002e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002e3:	8b 00                	mov    (%eax),%eax
  1002e5:	8d 50 01             	lea    0x1(%eax),%edx
  1002e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002eb:	89 10                	mov    %edx,(%eax)
}
  1002ed:	c9                   	leave  
  1002ee:	c3                   	ret    

001002ef <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002ef:	55                   	push   %ebp
  1002f0:	89 e5                	mov    %esp,%ebp
  1002f2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100303:	8b 45 08             	mov    0x8(%ebp),%eax
  100306:	89 44 24 08          	mov    %eax,0x8(%esp)
  10030a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10030d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100311:	c7 04 24 cf 02 10 00 	movl   $0x1002cf,(%esp)
  100318:	e8 d0 29 00 00       	call   102ced <vprintfmt>
    return cnt;
  10031d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100320:	c9                   	leave  
  100321:	c3                   	ret    

00100322 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100322:	55                   	push   %ebp
  100323:	89 e5                	mov    %esp,%ebp
  100325:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100328:	8d 45 0c             	lea    0xc(%ebp),%eax
  10032b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10032e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100331:	89 44 24 04          	mov    %eax,0x4(%esp)
  100335:	8b 45 08             	mov    0x8(%ebp),%eax
  100338:	89 04 24             	mov    %eax,(%esp)
  10033b:	e8 af ff ff ff       	call   1002ef <vcprintf>
  100340:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100343:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100346:	c9                   	leave  
  100347:	c3                   	ret    

00100348 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100348:	55                   	push   %ebp
  100349:	89 e5                	mov    %esp,%ebp
  10034b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10034e:	8b 45 08             	mov    0x8(%ebp),%eax
  100351:	89 04 24             	mov    %eax,(%esp)
  100354:	e8 4f 12 00 00       	call   1015a8 <cons_putc>
}
  100359:	c9                   	leave  
  10035a:	c3                   	ret    

0010035b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10035b:	55                   	push   %ebp
  10035c:	89 e5                	mov    %esp,%ebp
  10035e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100361:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100368:	eb 13                	jmp    10037d <cputs+0x22>
        cputch(c, &cnt);
  10036a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10036e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100371:	89 54 24 04          	mov    %edx,0x4(%esp)
  100375:	89 04 24             	mov    %eax,(%esp)
  100378:	e8 52 ff ff ff       	call   1002cf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10037d:	8b 45 08             	mov    0x8(%ebp),%eax
  100380:	8d 50 01             	lea    0x1(%eax),%edx
  100383:	89 55 08             	mov    %edx,0x8(%ebp)
  100386:	0f b6 00             	movzbl (%eax),%eax
  100389:	88 45 f7             	mov    %al,-0x9(%ebp)
  10038c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100390:	75 d8                	jne    10036a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100392:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100395:	89 44 24 04          	mov    %eax,0x4(%esp)
  100399:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003a0:	e8 2a ff ff ff       	call   1002cf <cputch>
    return cnt;
  1003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003a8:	c9                   	leave  
  1003a9:	c3                   	ret    

001003aa <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003aa:	55                   	push   %ebp
  1003ab:	89 e5                	mov    %esp,%ebp
  1003ad:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003b0:	e8 1c 12 00 00       	call   1015d1 <cons_getc>
  1003b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003bc:	74 f2                	je     1003b0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003be:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003cc:	8b 00                	mov    (%eax),%eax
  1003ce:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003d4:	8b 00                	mov    (%eax),%eax
  1003d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003d9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003e0:	e9 d2 00 00 00       	jmp    1004b7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003e8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003eb:	01 d0                	add    %edx,%eax
  1003ed:	89 c2                	mov    %eax,%edx
  1003ef:	c1 ea 1f             	shr    $0x1f,%edx
  1003f2:	01 d0                	add    %edx,%eax
  1003f4:	d1 f8                	sar    %eax
  1003f6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ff:	eb 04                	jmp    100405 <stab_binsearch+0x42>
            m --;
  100401:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100405:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100408:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10040b:	7c 1f                	jl     10042c <stab_binsearch+0x69>
  10040d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100410:	89 d0                	mov    %edx,%eax
  100412:	01 c0                	add    %eax,%eax
  100414:	01 d0                	add    %edx,%eax
  100416:	c1 e0 02             	shl    $0x2,%eax
  100419:	89 c2                	mov    %eax,%edx
  10041b:	8b 45 08             	mov    0x8(%ebp),%eax
  10041e:	01 d0                	add    %edx,%eax
  100420:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100424:	0f b6 c0             	movzbl %al,%eax
  100427:	3b 45 14             	cmp    0x14(%ebp),%eax
  10042a:	75 d5                	jne    100401 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10042c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10042f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100432:	7d 0b                	jge    10043f <stab_binsearch+0x7c>
            l = true_m + 1;
  100434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100437:	83 c0 01             	add    $0x1,%eax
  10043a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10043d:	eb 78                	jmp    1004b7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10043f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100446:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100449:	89 d0                	mov    %edx,%eax
  10044b:	01 c0                	add    %eax,%eax
  10044d:	01 d0                	add    %edx,%eax
  10044f:	c1 e0 02             	shl    $0x2,%eax
  100452:	89 c2                	mov    %eax,%edx
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	01 d0                	add    %edx,%eax
  100459:	8b 40 08             	mov    0x8(%eax),%eax
  10045c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10045f:	73 13                	jae    100474 <stab_binsearch+0xb1>
            *region_left = m;
  100461:	8b 45 0c             	mov    0xc(%ebp),%eax
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10046c:	83 c0 01             	add    $0x1,%eax
  10046f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100472:	eb 43                	jmp    1004b7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100474:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100477:	89 d0                	mov    %edx,%eax
  100479:	01 c0                	add    %eax,%eax
  10047b:	01 d0                	add    %edx,%eax
  10047d:	c1 e0 02             	shl    $0x2,%eax
  100480:	89 c2                	mov    %eax,%edx
  100482:	8b 45 08             	mov    0x8(%ebp),%eax
  100485:	01 d0                	add    %edx,%eax
  100487:	8b 40 08             	mov    0x8(%eax),%eax
  10048a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10048d:	76 16                	jbe    1004a5 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10048f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100492:	8d 50 ff             	lea    -0x1(%eax),%edx
  100495:	8b 45 10             	mov    0x10(%ebp),%eax
  100498:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10049a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10049d:	83 e8 01             	sub    $0x1,%eax
  1004a0:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a3:	eb 12                	jmp    1004b7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004a8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004ab:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004b3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004ba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004bd:	0f 8e 22 ff ff ff    	jle    1003e5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004c3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004c7:	75 0f                	jne    1004d8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004cc:	8b 00                	mov    (%eax),%eax
  1004ce:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004d1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004d4:	89 10                	mov    %edx,(%eax)
  1004d6:	eb 3f                	jmp    100517 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004db:	8b 00                	mov    (%eax),%eax
  1004dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004e0:	eb 04                	jmp    1004e6 <stab_binsearch+0x123>
  1004e2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004e9:	8b 00                	mov    (%eax),%eax
  1004eb:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ee:	7d 1f                	jge    10050f <stab_binsearch+0x14c>
  1004f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004f3:	89 d0                	mov    %edx,%eax
  1004f5:	01 c0                	add    %eax,%eax
  1004f7:	01 d0                	add    %edx,%eax
  1004f9:	c1 e0 02             	shl    $0x2,%eax
  1004fc:	89 c2                	mov    %eax,%edx
  1004fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100501:	01 d0                	add    %edx,%eax
  100503:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100507:	0f b6 c0             	movzbl %al,%eax
  10050a:	3b 45 14             	cmp    0x14(%ebp),%eax
  10050d:	75 d3                	jne    1004e2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100515:	89 10                	mov    %edx,(%eax)
    }
}
  100517:	c9                   	leave  
  100518:	c3                   	ret    

00100519 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100519:	55                   	push   %ebp
  10051a:	89 e5                	mov    %esp,%ebp
  10051c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10051f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100522:	c7 00 0c 37 10 00    	movl   $0x10370c,(%eax)
    info->eip_line = 0;
  100528:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100532:	8b 45 0c             	mov    0xc(%ebp),%eax
  100535:	c7 40 08 0c 37 10 00 	movl   $0x10370c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10053c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10053f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100546:	8b 45 0c             	mov    0xc(%ebp),%eax
  100549:	8b 55 08             	mov    0x8(%ebp),%edx
  10054c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10054f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100552:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100559:	c7 45 f4 6c 3f 10 00 	movl   $0x103f6c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100560:	c7 45 f0 d8 b7 10 00 	movl   $0x10b7d8,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100567:	c7 45 ec d9 b7 10 00 	movl   $0x10b7d9,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10056e:	c7 45 e8 c9 d7 10 00 	movl   $0x10d7c9,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100578:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10057b:	76 0d                	jbe    10058a <debuginfo_eip+0x71>
  10057d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100580:	83 e8 01             	sub    $0x1,%eax
  100583:	0f b6 00             	movzbl (%eax),%eax
  100586:	84 c0                	test   %al,%al
  100588:	74 0a                	je     100594 <debuginfo_eip+0x7b>
        return -1;
  10058a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10058f:	e9 c0 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100594:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10059b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10059e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005a1:	29 c2                	sub    %eax,%edx
  1005a3:	89 d0                	mov    %edx,%eax
  1005a5:	c1 f8 02             	sar    $0x2,%eax
  1005a8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ae:	83 e8 01             	sub    $0x1,%eax
  1005b1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005b7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005bb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005c2:	00 
  1005c3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005c6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ca:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005cd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005d4:	89 04 24             	mov    %eax,(%esp)
  1005d7:	e8 e7 fd ff ff       	call   1003c3 <stab_binsearch>
    if (lfile == 0)
  1005dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005df:	85 c0                	test   %eax,%eax
  1005e1:	75 0a                	jne    1005ed <debuginfo_eip+0xd4>
        return -1;
  1005e3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005e8:	e9 67 02 00 00       	jmp    100854 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005fc:	89 44 24 10          	mov    %eax,0x10(%esp)
  100600:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100607:	00 
  100608:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10060b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10060f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100612:	89 44 24 04          	mov    %eax,0x4(%esp)
  100616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100619:	89 04 24             	mov    %eax,(%esp)
  10061c:	e8 a2 fd ff ff       	call   1003c3 <stab_binsearch>

    if (lfun <= rfun) {
  100621:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100624:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100627:	39 c2                	cmp    %eax,%edx
  100629:	7f 7c                	jg     1006a7 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10062b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10062e:	89 c2                	mov    %eax,%edx
  100630:	89 d0                	mov    %edx,%eax
  100632:	01 c0                	add    %eax,%eax
  100634:	01 d0                	add    %edx,%eax
  100636:	c1 e0 02             	shl    $0x2,%eax
  100639:	89 c2                	mov    %eax,%edx
  10063b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10063e:	01 d0                	add    %edx,%eax
  100640:	8b 10                	mov    (%eax),%edx
  100642:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100645:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100648:	29 c1                	sub    %eax,%ecx
  10064a:	89 c8                	mov    %ecx,%eax
  10064c:	39 c2                	cmp    %eax,%edx
  10064e:	73 22                	jae    100672 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100650:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100653:	89 c2                	mov    %eax,%edx
  100655:	89 d0                	mov    %edx,%eax
  100657:	01 c0                	add    %eax,%eax
  100659:	01 d0                	add    %edx,%eax
  10065b:	c1 e0 02             	shl    $0x2,%eax
  10065e:	89 c2                	mov    %eax,%edx
  100660:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100663:	01 d0                	add    %edx,%eax
  100665:	8b 10                	mov    (%eax),%edx
  100667:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10066a:	01 c2                	add    %eax,%edx
  10066c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10066f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100672:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100675:	89 c2                	mov    %eax,%edx
  100677:	89 d0                	mov    %edx,%eax
  100679:	01 c0                	add    %eax,%eax
  10067b:	01 d0                	add    %edx,%eax
  10067d:	c1 e0 02             	shl    $0x2,%eax
  100680:	89 c2                	mov    %eax,%edx
  100682:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100685:	01 d0                	add    %edx,%eax
  100687:	8b 50 08             	mov    0x8(%eax),%edx
  10068a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10068d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100690:	8b 45 0c             	mov    0xc(%ebp),%eax
  100693:	8b 40 10             	mov    0x10(%eax),%eax
  100696:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100699:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10069c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10069f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006a5:	eb 15                	jmp    1006bc <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006a7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006aa:	8b 55 08             	mov    0x8(%ebp),%edx
  1006ad:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006bf:	8b 40 08             	mov    0x8(%eax),%eax
  1006c2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006c9:	00 
  1006ca:	89 04 24             	mov    %eax,(%esp)
  1006cd:	e8 76 2c 00 00       	call   103348 <strfind>
  1006d2:	89 c2                	mov    %eax,%edx
  1006d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d7:	8b 40 08             	mov    0x8(%eax),%eax
  1006da:	29 c2                	sub    %eax,%edx
  1006dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006df:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006f0:	00 
  1006f1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100702:	89 04 24             	mov    %eax,(%esp)
  100705:	e8 b9 fc ff ff       	call   1003c3 <stab_binsearch>
    if (lline <= rline) {
  10070a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10070d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100710:	39 c2                	cmp    %eax,%edx
  100712:	7f 24                	jg     100738 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100714:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	89 d0                	mov    %edx,%eax
  10071b:	01 c0                	add    %eax,%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	c1 e0 02             	shl    $0x2,%eax
  100722:	89 c2                	mov    %eax,%edx
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	01 d0                	add    %edx,%eax
  100729:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10072d:	0f b7 d0             	movzwl %ax,%edx
  100730:	8b 45 0c             	mov    0xc(%ebp),%eax
  100733:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100736:	eb 13                	jmp    10074b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100738:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10073d:	e9 12 01 00 00       	jmp    100854 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100742:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100745:	83 e8 01             	sub    $0x1,%eax
  100748:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10074b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10074e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100751:	39 c2                	cmp    %eax,%edx
  100753:	7c 56                	jl     1007ab <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100755:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100758:	89 c2                	mov    %eax,%edx
  10075a:	89 d0                	mov    %edx,%eax
  10075c:	01 c0                	add    %eax,%eax
  10075e:	01 d0                	add    %edx,%eax
  100760:	c1 e0 02             	shl    $0x2,%eax
  100763:	89 c2                	mov    %eax,%edx
  100765:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100768:	01 d0                	add    %edx,%eax
  10076a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10076e:	3c 84                	cmp    $0x84,%al
  100770:	74 39                	je     1007ab <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100772:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100775:	89 c2                	mov    %eax,%edx
  100777:	89 d0                	mov    %edx,%eax
  100779:	01 c0                	add    %eax,%eax
  10077b:	01 d0                	add    %edx,%eax
  10077d:	c1 e0 02             	shl    $0x2,%eax
  100780:	89 c2                	mov    %eax,%edx
  100782:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100785:	01 d0                	add    %edx,%eax
  100787:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10078b:	3c 64                	cmp    $0x64,%al
  10078d:	75 b3                	jne    100742 <debuginfo_eip+0x229>
  10078f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100792:	89 c2                	mov    %eax,%edx
  100794:	89 d0                	mov    %edx,%eax
  100796:	01 c0                	add    %eax,%eax
  100798:	01 d0                	add    %edx,%eax
  10079a:	c1 e0 02             	shl    $0x2,%eax
  10079d:	89 c2                	mov    %eax,%edx
  10079f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	8b 40 08             	mov    0x8(%eax),%eax
  1007a7:	85 c0                	test   %eax,%eax
  1007a9:	74 97                	je     100742 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007ab:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007ae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b1:	39 c2                	cmp    %eax,%edx
  1007b3:	7c 46                	jl     1007fb <debuginfo_eip+0x2e2>
  1007b5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007b8:	89 c2                	mov    %eax,%edx
  1007ba:	89 d0                	mov    %edx,%eax
  1007bc:	01 c0                	add    %eax,%eax
  1007be:	01 d0                	add    %edx,%eax
  1007c0:	c1 e0 02             	shl    $0x2,%eax
  1007c3:	89 c2                	mov    %eax,%edx
  1007c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c8:	01 d0                	add    %edx,%eax
  1007ca:	8b 10                	mov    (%eax),%edx
  1007cc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d2:	29 c1                	sub    %eax,%ecx
  1007d4:	89 c8                	mov    %ecx,%eax
  1007d6:	39 c2                	cmp    %eax,%edx
  1007d8:	73 21                	jae    1007fb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007da:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007dd:	89 c2                	mov    %eax,%edx
  1007df:	89 d0                	mov    %edx,%eax
  1007e1:	01 c0                	add    %eax,%eax
  1007e3:	01 d0                	add    %edx,%eax
  1007e5:	c1 e0 02             	shl    $0x2,%eax
  1007e8:	89 c2                	mov    %eax,%edx
  1007ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ed:	01 d0                	add    %edx,%eax
  1007ef:	8b 10                	mov    (%eax),%edx
  1007f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007f4:	01 c2                	add    %eax,%edx
  1007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7d 4a                	jge    10084f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100808:	83 c0 01             	add    $0x1,%eax
  10080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080e:	eb 18                	jmp    100828 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	8b 40 14             	mov    0x14(%eax),%eax
  100816:	8d 50 01             	lea    0x1(%eax),%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10082e:	39 c2                	cmp    %eax,%edx
  100830:	7d 1d                	jge    10084f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c a0                	cmp    $0xa0,%al
  10084d:	74 c1                	je     100810 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10084f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100854:	c9                   	leave  
  100855:	c3                   	ret    

00100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100856:	55                   	push   %ebp
  100857:	89 e5                	mov    %esp,%ebp
  100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10085c:	c7 04 24 16 37 10 00 	movl   $0x103716,(%esp)
  100863:	e8 ba fa ff ff       	call   100322 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100868:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10086f:	00 
  100870:	c7 04 24 2f 37 10 00 	movl   $0x10372f,(%esp)
  100877:	e8 a6 fa ff ff       	call   100322 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10087c:	c7 44 24 04 5d 36 10 	movl   $0x10365d,0x4(%esp)
  100883:	00 
  100884:	c7 04 24 47 37 10 00 	movl   $0x103747,(%esp)
  10088b:	e8 92 fa ff ff       	call   100322 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100890:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100897:	00 
  100898:	c7 04 24 5f 37 10 00 	movl   $0x10375f,(%esp)
  10089f:	e8 7e fa ff ff       	call   100322 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a4:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  1008ab:	00 
  1008ac:	c7 04 24 77 37 10 00 	movl   $0x103777,(%esp)
  1008b3:	e8 6a fa ff ff       	call   100322 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008c8:	29 c2                	sub    %eax,%edx
  1008ca:	89 d0                	mov    %edx,%eax
  1008cc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008d2:	85 c0                	test   %eax,%eax
  1008d4:	0f 48 c2             	cmovs  %edx,%eax
  1008d7:	c1 f8 0a             	sar    $0xa,%eax
  1008da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008de:	c7 04 24 90 37 10 00 	movl   $0x103790,(%esp)
  1008e5:	e8 38 fa ff ff       	call   100322 <cprintf>
}
  1008ea:	c9                   	leave  
  1008eb:	c3                   	ret    

001008ec <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ec:	55                   	push   %ebp
  1008ed:	89 e5                	mov    %esp,%ebp
  1008ef:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ff:	89 04 24             	mov    %eax,(%esp)
  100902:	e8 12 fc ff ff       	call   100519 <debuginfo_eip>
  100907:	85 c0                	test   %eax,%eax
  100909:	74 15                	je     100920 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10090b:	8b 45 08             	mov    0x8(%ebp),%eax
  10090e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100912:	c7 04 24 ba 37 10 00 	movl   $0x1037ba,(%esp)
  100919:	e8 04 fa ff ff       	call   100322 <cprintf>
  10091e:	eb 6d                	jmp    10098d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100920:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100927:	eb 1c                	jmp    100945 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100929:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10092c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10092f:	01 d0                	add    %edx,%eax
  100931:	0f b6 00             	movzbl (%eax),%eax
  100934:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10093a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10093d:	01 ca                	add    %ecx,%edx
  10093f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10094b:	7f dc                	jg     100929 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10094d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100953:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100956:	01 d0                	add    %edx,%eax
  100958:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10095b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10095e:	8b 55 08             	mov    0x8(%ebp),%edx
  100961:	89 d1                	mov    %edx,%ecx
  100963:	29 c1                	sub    %eax,%ecx
  100965:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100968:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10096b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10096f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100975:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100979:	89 54 24 08          	mov    %edx,0x8(%esp)
  10097d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100981:	c7 04 24 d6 37 10 00 	movl   $0x1037d6,(%esp)
  100988:	e8 95 f9 ff ff       	call   100322 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10098d:	c9                   	leave  
  10098e:	c3                   	ret    

0010098f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098f:	55                   	push   %ebp
  100990:	89 e5                	mov    %esp,%ebp
  100992:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100995:	8b 45 04             	mov    0x4(%ebp),%eax
  100998:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10099b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10099e:	c9                   	leave  
  10099f:	c3                   	ret    

001009a0 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009a0:	55                   	push   %ebp
  1009a1:	89 e5                	mov    %esp,%ebp
  1009a3:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009a6:	89 e8                	mov    %ebp,%eax
  1009a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  1009ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  1009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009b1:	e8 d9 ff ff ff       	call   10098f <read_eip>
  1009b6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j = 0;
  1009b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
  1009c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c7:	e9 88 00 00 00       	jmp    100a54 <print_stackframe+0xb4>
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
  1009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009cf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009da:	c7 04 24 e8 37 10 00 	movl   $0x1037e8,(%esp)
  1009e1:	e8 3c f9 ff ff       	call   100322 <cprintf>
		uint32_t* arguments = (uint32_t*)ebp + 2;
  1009e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e9:	83 c0 08             	add    $0x8,%eax
  1009ec:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j < 4;j++)
  1009ef:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009f6:	eb 25                	jmp    100a1d <print_stackframe+0x7d>
			cprintf("0x%08x ",arguments[j]);
  1009f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009fb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100a02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100a05:	01 d0                	add    %edx,%eax
  100a07:	8b 00                	mov    (%eax),%eax
  100a09:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a0d:	c7 04 24 05 38 10 00 	movl   $0x103805,(%esp)
  100a14:	e8 09 f9 ff ff       	call   100322 <cprintf>
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
		uint32_t* arguments = (uint32_t*)ebp + 2;
		for(j = 0;j < 4;j++)
  100a19:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a1d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a21:	7e d5                	jle    1009f8 <print_stackframe+0x58>
			cprintf("0x%08x ",arguments[j]);
		cprintf("\n");
  100a23:	c7 04 24 0d 38 10 00 	movl   $0x10380d,(%esp)
  100a2a:	e8 f3 f8 ff ff       	call   100322 <cprintf>
		print_debuginfo(eip - 1);
  100a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a32:	83 e8 01             	sub    $0x1,%eax
  100a35:	89 04 24             	mov    %eax,(%esp)
  100a38:	e8 af fe ff ff       	call   1008ec <print_debuginfo>
		eip = *((uint32_t*)ebp + 1);
  100a3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a40:	83 c0 04             	add    $0x4,%eax
  100a43:	8b 00                	mov    (%eax),%eax
  100a45:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
  100a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a4b:	8b 00                	mov    (%eax),%eax
  100a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
  100a50:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a54:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a58:	7f 0a                	jg     100a64 <print_stackframe+0xc4>
  100a5a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a5e:	0f 85 68 ff ff ff    	jne    1009cc <print_stackframe+0x2c>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)ebp + 1);
		ebp = *((uint32_t*)ebp);
	}
}
  100a64:	c9                   	leave  
  100a65:	c3                   	ret    

00100a66 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a66:	55                   	push   %ebp
  100a67:	89 e5                	mov    %esp,%ebp
  100a69:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a6c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a73:	eb 0c                	jmp    100a81 <parse+0x1b>
            *buf ++ = '\0';
  100a75:	8b 45 08             	mov    0x8(%ebp),%eax
  100a78:	8d 50 01             	lea    0x1(%eax),%edx
  100a7b:	89 55 08             	mov    %edx,0x8(%ebp)
  100a7e:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a81:	8b 45 08             	mov    0x8(%ebp),%eax
  100a84:	0f b6 00             	movzbl (%eax),%eax
  100a87:	84 c0                	test   %al,%al
  100a89:	74 1d                	je     100aa8 <parse+0x42>
  100a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8e:	0f b6 00             	movzbl (%eax),%eax
  100a91:	0f be c0             	movsbl %al,%eax
  100a94:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a98:	c7 04 24 90 38 10 00 	movl   $0x103890,(%esp)
  100a9f:	e8 71 28 00 00       	call   103315 <strchr>
  100aa4:	85 c0                	test   %eax,%eax
  100aa6:	75 cd                	jne    100a75 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aab:	0f b6 00             	movzbl (%eax),%eax
  100aae:	84 c0                	test   %al,%al
  100ab0:	75 02                	jne    100ab4 <parse+0x4e>
            break;
  100ab2:	eb 67                	jmp    100b1b <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ab4:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ab8:	75 14                	jne    100ace <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aba:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ac1:	00 
  100ac2:	c7 04 24 95 38 10 00 	movl   $0x103895,(%esp)
  100ac9:	e8 54 f8 ff ff       	call   100322 <cprintf>
        }
        argv[argc ++] = buf;
  100ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad1:	8d 50 01             	lea    0x1(%eax),%edx
  100ad4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ad7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ade:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ae1:	01 c2                	add    %eax,%edx
  100ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae6:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae8:	eb 04                	jmp    100aee <parse+0x88>
            buf ++;
  100aea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100aee:	8b 45 08             	mov    0x8(%ebp),%eax
  100af1:	0f b6 00             	movzbl (%eax),%eax
  100af4:	84 c0                	test   %al,%al
  100af6:	74 1d                	je     100b15 <parse+0xaf>
  100af8:	8b 45 08             	mov    0x8(%ebp),%eax
  100afb:	0f b6 00             	movzbl (%eax),%eax
  100afe:	0f be c0             	movsbl %al,%eax
  100b01:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b05:	c7 04 24 90 38 10 00 	movl   $0x103890,(%esp)
  100b0c:	e8 04 28 00 00       	call   103315 <strchr>
  100b11:	85 c0                	test   %eax,%eax
  100b13:	74 d5                	je     100aea <parse+0x84>
            buf ++;
        }
    }
  100b15:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b16:	e9 66 ff ff ff       	jmp    100a81 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b1e:	c9                   	leave  
  100b1f:	c3                   	ret    

00100b20 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b20:	55                   	push   %ebp
  100b21:	89 e5                	mov    %esp,%ebp
  100b23:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b26:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b29:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b30:	89 04 24             	mov    %eax,(%esp)
  100b33:	e8 2e ff ff ff       	call   100a66 <parse>
  100b38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b3f:	75 0a                	jne    100b4b <runcmd+0x2b>
        return 0;
  100b41:	b8 00 00 00 00       	mov    $0x0,%eax
  100b46:	e9 85 00 00 00       	jmp    100bd0 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b4b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b52:	eb 5c                	jmp    100bb0 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b54:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b57:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b5a:	89 d0                	mov    %edx,%eax
  100b5c:	01 c0                	add    %eax,%eax
  100b5e:	01 d0                	add    %edx,%eax
  100b60:	c1 e0 02             	shl    $0x2,%eax
  100b63:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b68:	8b 00                	mov    (%eax),%eax
  100b6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b6e:	89 04 24             	mov    %eax,(%esp)
  100b71:	e8 00 27 00 00       	call   103276 <strcmp>
  100b76:	85 c0                	test   %eax,%eax
  100b78:	75 32                	jne    100bac <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b7a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b7d:	89 d0                	mov    %edx,%eax
  100b7f:	01 c0                	add    %eax,%eax
  100b81:	01 d0                	add    %edx,%eax
  100b83:	c1 e0 02             	shl    $0x2,%eax
  100b86:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b8b:	8b 40 08             	mov    0x8(%eax),%eax
  100b8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b91:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b94:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b97:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b9b:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b9e:	83 c2 04             	add    $0x4,%edx
  100ba1:	89 54 24 04          	mov    %edx,0x4(%esp)
  100ba5:	89 0c 24             	mov    %ecx,(%esp)
  100ba8:	ff d0                	call   *%eax
  100baa:	eb 24                	jmp    100bd0 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bac:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100bb3:	83 f8 02             	cmp    $0x2,%eax
  100bb6:	76 9c                	jbe    100b54 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bb8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bbf:	c7 04 24 b3 38 10 00 	movl   $0x1038b3,(%esp)
  100bc6:	e8 57 f7 ff ff       	call   100322 <cprintf>
    return 0;
  100bcb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bd0:	c9                   	leave  
  100bd1:	c3                   	ret    

00100bd2 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bd2:	55                   	push   %ebp
  100bd3:	89 e5                	mov    %esp,%ebp
  100bd5:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bd8:	c7 04 24 cc 38 10 00 	movl   $0x1038cc,(%esp)
  100bdf:	e8 3e f7 ff ff       	call   100322 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100be4:	c7 04 24 f4 38 10 00 	movl   $0x1038f4,(%esp)
  100beb:	e8 32 f7 ff ff       	call   100322 <cprintf>

    if (tf != NULL) {
  100bf0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100bf4:	74 0b                	je     100c01 <kmonitor+0x2f>
        print_trapframe(tf);
  100bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  100bf9:	89 04 24             	mov    %eax,(%esp)
  100bfc:	e8 4d 0e 00 00       	call   101a4e <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c01:	c7 04 24 19 39 10 00 	movl   $0x103919,(%esp)
  100c08:	e8 0c f6 ff ff       	call   100219 <readline>
  100c0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c14:	74 18                	je     100c2e <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c16:	8b 45 08             	mov    0x8(%ebp),%eax
  100c19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c20:	89 04 24             	mov    %eax,(%esp)
  100c23:	e8 f8 fe ff ff       	call   100b20 <runcmd>
  100c28:	85 c0                	test   %eax,%eax
  100c2a:	79 02                	jns    100c2e <kmonitor+0x5c>
                break;
  100c2c:	eb 02                	jmp    100c30 <kmonitor+0x5e>
            }
        }
    }
  100c2e:	eb d1                	jmp    100c01 <kmonitor+0x2f>
}
  100c30:	c9                   	leave  
  100c31:	c3                   	ret    

00100c32 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c32:	55                   	push   %ebp
  100c33:	89 e5                	mov    %esp,%ebp
  100c35:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c3f:	eb 3f                	jmp    100c80 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c44:	89 d0                	mov    %edx,%eax
  100c46:	01 c0                	add    %eax,%eax
  100c48:	01 d0                	add    %edx,%eax
  100c4a:	c1 e0 02             	shl    $0x2,%eax
  100c4d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c52:	8b 48 04             	mov    0x4(%eax),%ecx
  100c55:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c58:	89 d0                	mov    %edx,%eax
  100c5a:	01 c0                	add    %eax,%eax
  100c5c:	01 d0                	add    %edx,%eax
  100c5e:	c1 e0 02             	shl    $0x2,%eax
  100c61:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c66:	8b 00                	mov    (%eax),%eax
  100c68:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c6c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c70:	c7 04 24 1d 39 10 00 	movl   $0x10391d,(%esp)
  100c77:	e8 a6 f6 ff ff       	call   100322 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c7c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c83:	83 f8 02             	cmp    $0x2,%eax
  100c86:	76 b9                	jbe    100c41 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8d:	c9                   	leave  
  100c8e:	c3                   	ret    

00100c8f <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c8f:	55                   	push   %ebp
  100c90:	89 e5                	mov    %esp,%ebp
  100c92:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c95:	e8 bc fb ff ff       	call   100856 <print_kerninfo>
    return 0;
  100c9a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c9f:	c9                   	leave  
  100ca0:	c3                   	ret    

00100ca1 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100ca1:	55                   	push   %ebp
  100ca2:	89 e5                	mov    %esp,%ebp
  100ca4:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100ca7:	e8 f4 fc ff ff       	call   1009a0 <print_stackframe>
    return 0;
  100cac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100cb1:	c9                   	leave  
  100cb2:	c3                   	ret    

00100cb3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100cb3:	55                   	push   %ebp
  100cb4:	89 e5                	mov    %esp,%ebp
  100cb6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cb9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cbe:	85 c0                	test   %eax,%eax
  100cc0:	74 02                	je     100cc4 <__panic+0x11>
        goto panic_dead;
  100cc2:	eb 48                	jmp    100d0c <__panic+0x59>
    }
    is_panic = 1;
  100cc4:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100ccb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cce:	8d 45 14             	lea    0x14(%ebp),%eax
  100cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cd7:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cde:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce2:	c7 04 24 26 39 10 00 	movl   $0x103926,(%esp)
  100ce9:	e8 34 f6 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf5:	8b 45 10             	mov    0x10(%ebp),%eax
  100cf8:	89 04 24             	mov    %eax,(%esp)
  100cfb:	e8 ef f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100d00:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100d07:	e8 16 f6 ff ff       	call   100322 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100d0c:	e8 22 09 00 00       	call   101633 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d11:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d18:	e8 b5 fe ff ff       	call   100bd2 <kmonitor>
    }
  100d1d:	eb f2                	jmp    100d11 <__panic+0x5e>

00100d1f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d1f:	55                   	push   %ebp
  100d20:	89 e5                	mov    %esp,%ebp
  100d22:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d25:	8d 45 14             	lea    0x14(%ebp),%eax
  100d28:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d2e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d32:	8b 45 08             	mov    0x8(%ebp),%eax
  100d35:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d39:	c7 04 24 44 39 10 00 	movl   $0x103944,(%esp)
  100d40:	e8 dd f5 ff ff       	call   100322 <cprintf>
    vcprintf(fmt, ap);
  100d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d48:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  100d4f:	89 04 24             	mov    %eax,(%esp)
  100d52:	e8 98 f5 ff ff       	call   1002ef <vcprintf>
    cprintf("\n");
  100d57:	c7 04 24 42 39 10 00 	movl   $0x103942,(%esp)
  100d5e:	e8 bf f5 ff ff       	call   100322 <cprintf>
    va_end(ap);
}
  100d63:	c9                   	leave  
  100d64:	c3                   	ret    

00100d65 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d65:	55                   	push   %ebp
  100d66:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d68:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d6d:	5d                   	pop    %ebp
  100d6e:	c3                   	ret    

00100d6f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d6f:	55                   	push   %ebp
  100d70:	89 e5                	mov    %esp,%ebp
  100d72:	83 ec 28             	sub    $0x28,%esp
  100d75:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d7b:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d7f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d83:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d87:	ee                   	out    %al,(%dx)
  100d88:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d92:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d96:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9a:	ee                   	out    %al,(%dx)
  100d9b:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100da1:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da5:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da9:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100dad:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dae:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100db5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db8:	c7 04 24 62 39 10 00 	movl   $0x103962,(%esp)
  100dbf:	e8 5e f5 ff ff       	call   100322 <cprintf>
    pic_enable(IRQ_TIMER);
  100dc4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dcb:	e8 c1 08 00 00       	call   101691 <pic_enable>
}
  100dd0:	c9                   	leave  
  100dd1:	c3                   	ret    

00100dd2 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dd2:	55                   	push   %ebp
  100dd3:	89 e5                	mov    %esp,%ebp
  100dd5:	83 ec 10             	sub    $0x10,%esp
  100dd8:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dde:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100de2:	89 c2                	mov    %eax,%edx
  100de4:	ec                   	in     (%dx),%al
  100de5:	88 45 fd             	mov    %al,-0x3(%ebp)
  100de8:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dee:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100df2:	89 c2                	mov    %eax,%edx
  100df4:	ec                   	in     (%dx),%al
  100df5:	88 45 f9             	mov    %al,-0x7(%ebp)
  100df8:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dfe:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e02:	89 c2                	mov    %eax,%edx
  100e04:	ec                   	in     (%dx),%al
  100e05:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e08:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100e0e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e12:	89 c2                	mov    %eax,%edx
  100e14:	ec                   	in     (%dx),%al
  100e15:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e18:	c9                   	leave  
  100e19:	c3                   	ret    

00100e1a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e1a:	55                   	push   %ebp
  100e1b:	89 e5                	mov    %esp,%ebp
  100e1d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e20:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2a:	0f b7 00             	movzwl (%eax),%eax
  100e2d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e31:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e34:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e39:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e3c:	0f b7 00             	movzwl (%eax),%eax
  100e3f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e43:	74 12                	je     100e57 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e45:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e4c:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e53:	b4 03 
  100e55:	eb 13                	jmp    100e6a <cga_init+0x50>
    } else {
        *cp = was;
  100e57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e5a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e5e:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e61:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e68:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e6a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e71:	0f b7 c0             	movzwl %ax,%eax
  100e74:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e78:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e7c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e80:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e84:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e85:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e8c:	83 c0 01             	add    $0x1,%eax
  100e8f:	0f b7 c0             	movzwl %ax,%eax
  100e92:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e96:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e9a:	89 c2                	mov    %eax,%edx
  100e9c:	ec                   	in     (%dx),%al
  100e9d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100ea0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ea4:	0f b6 c0             	movzbl %al,%eax
  100ea7:	c1 e0 08             	shl    $0x8,%eax
  100eaa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100ead:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100eb4:	0f b7 c0             	movzwl %ax,%eax
  100eb7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100ebb:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ebf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ec3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100ec7:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100ec8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ecf:	83 c0 01             	add    $0x1,%eax
  100ed2:	0f b7 c0             	movzwl %ax,%eax
  100ed5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ed9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100edd:	89 c2                	mov    %eax,%edx
  100edf:	ec                   	in     (%dx),%al
  100ee0:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ee3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ee7:	0f b6 c0             	movzbl %al,%eax
  100eea:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100eed:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ef0:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ef8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100efe:	c9                   	leave  
  100eff:	c3                   	ret    

00100f00 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f00:	55                   	push   %ebp
  100f01:	89 e5                	mov    %esp,%ebp
  100f03:	83 ec 48             	sub    $0x48,%esp
  100f06:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f0c:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f10:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f14:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f18:	ee                   	out    %al,(%dx)
  100f19:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f1f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f23:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f27:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f2b:	ee                   	out    %al,(%dx)
  100f2c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f32:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f36:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f3a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f3e:	ee                   	out    %al,(%dx)
  100f3f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f45:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f49:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f4d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f51:	ee                   	out    %al,(%dx)
  100f52:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f58:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f5c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f60:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f64:	ee                   	out    %al,(%dx)
  100f65:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f6b:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f6f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f73:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f77:	ee                   	out    %al,(%dx)
  100f78:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f7e:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f82:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f86:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f8a:	ee                   	out    %al,(%dx)
  100f8b:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f91:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f95:	89 c2                	mov    %eax,%edx
  100f97:	ec                   	in     (%dx),%al
  100f98:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f9b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f9f:	3c ff                	cmp    $0xff,%al
  100fa1:	0f 95 c0             	setne  %al
  100fa4:	0f b6 c0             	movzbl %al,%eax
  100fa7:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100fac:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fb2:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fb6:	89 c2                	mov    %eax,%edx
  100fb8:	ec                   	in     (%dx),%al
  100fb9:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fbc:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fc2:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fc6:	89 c2                	mov    %eax,%edx
  100fc8:	ec                   	in     (%dx),%al
  100fc9:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fcc:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fd1:	85 c0                	test   %eax,%eax
  100fd3:	74 0c                	je     100fe1 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fd5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fdc:	e8 b0 06 00 00       	call   101691 <pic_enable>
    }
}
  100fe1:	c9                   	leave  
  100fe2:	c3                   	ret    

00100fe3 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fe3:	55                   	push   %ebp
  100fe4:	89 e5                	mov    %esp,%ebp
  100fe6:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100ff0:	eb 09                	jmp    100ffb <lpt_putc_sub+0x18>
        delay();
  100ff2:	e8 db fd ff ff       	call   100dd2 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100ff7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100ffb:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101001:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101005:	89 c2                	mov    %eax,%edx
  101007:	ec                   	in     (%dx),%al
  101008:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10100b:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10100f:	84 c0                	test   %al,%al
  101011:	78 09                	js     10101c <lpt_putc_sub+0x39>
  101013:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10101a:	7e d6                	jle    100ff2 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10101c:	8b 45 08             	mov    0x8(%ebp),%eax
  10101f:	0f b6 c0             	movzbl %al,%eax
  101022:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101028:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10102b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10102f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101033:	ee                   	out    %al,(%dx)
  101034:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10103a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10103e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101042:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101046:	ee                   	out    %al,(%dx)
  101047:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10104d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101051:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101055:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101059:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10105a:	c9                   	leave  
  10105b:	c3                   	ret    

0010105c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10105c:	55                   	push   %ebp
  10105d:	89 e5                	mov    %esp,%ebp
  10105f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101062:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101066:	74 0d                	je     101075 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101068:	8b 45 08             	mov    0x8(%ebp),%eax
  10106b:	89 04 24             	mov    %eax,(%esp)
  10106e:	e8 70 ff ff ff       	call   100fe3 <lpt_putc_sub>
  101073:	eb 24                	jmp    101099 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101075:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10107c:	e8 62 ff ff ff       	call   100fe3 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101081:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101088:	e8 56 ff ff ff       	call   100fe3 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10108d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101094:	e8 4a ff ff ff       	call   100fe3 <lpt_putc_sub>
    }
}
  101099:	c9                   	leave  
  10109a:	c3                   	ret    

0010109b <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10109b:	55                   	push   %ebp
  10109c:	89 e5                	mov    %esp,%ebp
  10109e:	53                   	push   %ebx
  10109f:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a5:	b0 00                	mov    $0x0,%al
  1010a7:	85 c0                	test   %eax,%eax
  1010a9:	75 07                	jne    1010b2 <cga_putc+0x17>
        c |= 0x0700;
  1010ab:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010b5:	0f b6 c0             	movzbl %al,%eax
  1010b8:	83 f8 0a             	cmp    $0xa,%eax
  1010bb:	74 4c                	je     101109 <cga_putc+0x6e>
  1010bd:	83 f8 0d             	cmp    $0xd,%eax
  1010c0:	74 57                	je     101119 <cga_putc+0x7e>
  1010c2:	83 f8 08             	cmp    $0x8,%eax
  1010c5:	0f 85 88 00 00 00    	jne    101153 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010cb:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010d2:	66 85 c0             	test   %ax,%ax
  1010d5:	74 30                	je     101107 <cga_putc+0x6c>
            crt_pos --;
  1010d7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010de:	83 e8 01             	sub    $0x1,%eax
  1010e1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010e7:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010ec:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010f3:	0f b7 d2             	movzwl %dx,%edx
  1010f6:	01 d2                	add    %edx,%edx
  1010f8:	01 c2                	add    %eax,%edx
  1010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1010fd:	b0 00                	mov    $0x0,%al
  1010ff:	83 c8 20             	or     $0x20,%eax
  101102:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101105:	eb 72                	jmp    101179 <cga_putc+0xde>
  101107:	eb 70                	jmp    101179 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  101109:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101110:	83 c0 50             	add    $0x50,%eax
  101113:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101119:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101120:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101127:	0f b7 c1             	movzwl %cx,%eax
  10112a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101130:	c1 e8 10             	shr    $0x10,%eax
  101133:	89 c2                	mov    %eax,%edx
  101135:	66 c1 ea 06          	shr    $0x6,%dx
  101139:	89 d0                	mov    %edx,%eax
  10113b:	c1 e0 02             	shl    $0x2,%eax
  10113e:	01 d0                	add    %edx,%eax
  101140:	c1 e0 04             	shl    $0x4,%eax
  101143:	29 c1                	sub    %eax,%ecx
  101145:	89 ca                	mov    %ecx,%edx
  101147:	89 d8                	mov    %ebx,%eax
  101149:	29 d0                	sub    %edx,%eax
  10114b:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101151:	eb 26                	jmp    101179 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101153:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101159:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101160:	8d 50 01             	lea    0x1(%eax),%edx
  101163:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10116a:	0f b7 c0             	movzwl %ax,%eax
  10116d:	01 c0                	add    %eax,%eax
  10116f:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101172:	8b 45 08             	mov    0x8(%ebp),%eax
  101175:	66 89 02             	mov    %ax,(%edx)
        break;
  101178:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101179:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101180:	66 3d cf 07          	cmp    $0x7cf,%ax
  101184:	76 5b                	jbe    1011e1 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101186:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10118b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101191:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101196:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10119d:	00 
  10119e:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011a2:	89 04 24             	mov    %eax,(%esp)
  1011a5:	e8 69 23 00 00       	call   103513 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011aa:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011b1:	eb 15                	jmp    1011c8 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011b3:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011bb:	01 d2                	add    %edx,%edx
  1011bd:	01 d0                	add    %edx,%eax
  1011bf:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011c4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011c8:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011cf:	7e e2                	jle    1011b3 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011d1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011d8:	83 e8 50             	sub    $0x50,%eax
  1011db:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011e1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011e8:	0f b7 c0             	movzwl %ax,%eax
  1011eb:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011ef:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011f3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011f7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011fb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011fc:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101203:	66 c1 e8 08          	shr    $0x8,%ax
  101207:	0f b6 c0             	movzbl %al,%eax
  10120a:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101211:	83 c2 01             	add    $0x1,%edx
  101214:	0f b7 d2             	movzwl %dx,%edx
  101217:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10121b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10121e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101222:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101226:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101227:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10122e:	0f b7 c0             	movzwl %ax,%eax
  101231:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101235:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101239:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10123d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101241:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101242:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101249:	0f b6 c0             	movzbl %al,%eax
  10124c:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101253:	83 c2 01             	add    $0x1,%edx
  101256:	0f b7 d2             	movzwl %dx,%edx
  101259:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10125d:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101260:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101264:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101268:	ee                   	out    %al,(%dx)
}
  101269:	83 c4 34             	add    $0x34,%esp
  10126c:	5b                   	pop    %ebx
  10126d:	5d                   	pop    %ebp
  10126e:	c3                   	ret    

0010126f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10126f:	55                   	push   %ebp
  101270:	89 e5                	mov    %esp,%ebp
  101272:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101275:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10127c:	eb 09                	jmp    101287 <serial_putc_sub+0x18>
        delay();
  10127e:	e8 4f fb ff ff       	call   100dd2 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101283:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101287:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10128d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101291:	89 c2                	mov    %eax,%edx
  101293:	ec                   	in     (%dx),%al
  101294:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101297:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10129b:	0f b6 c0             	movzbl %al,%eax
  10129e:	83 e0 20             	and    $0x20,%eax
  1012a1:	85 c0                	test   %eax,%eax
  1012a3:	75 09                	jne    1012ae <serial_putc_sub+0x3f>
  1012a5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012ac:	7e d0                	jle    10127e <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  1012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b1:	0f b6 c0             	movzbl %al,%eax
  1012b4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012ba:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012bd:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012c1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012c5:	ee                   	out    %al,(%dx)
}
  1012c6:	c9                   	leave  
  1012c7:	c3                   	ret    

001012c8 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012c8:	55                   	push   %ebp
  1012c9:	89 e5                	mov    %esp,%ebp
  1012cb:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012ce:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012d2:	74 0d                	je     1012e1 <serial_putc+0x19>
        serial_putc_sub(c);
  1012d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1012d7:	89 04 24             	mov    %eax,(%esp)
  1012da:	e8 90 ff ff ff       	call   10126f <serial_putc_sub>
  1012df:	eb 24                	jmp    101305 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012e1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012e8:	e8 82 ff ff ff       	call   10126f <serial_putc_sub>
        serial_putc_sub(' ');
  1012ed:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012f4:	e8 76 ff ff ff       	call   10126f <serial_putc_sub>
        serial_putc_sub('\b');
  1012f9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101300:	e8 6a ff ff ff       	call   10126f <serial_putc_sub>
    }
}
  101305:	c9                   	leave  
  101306:	c3                   	ret    

00101307 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101307:	55                   	push   %ebp
  101308:	89 e5                	mov    %esp,%ebp
  10130a:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10130d:	eb 33                	jmp    101342 <cons_intr+0x3b>
        if (c != 0) {
  10130f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101313:	74 2d                	je     101342 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101315:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10131a:	8d 50 01             	lea    0x1(%eax),%edx
  10131d:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101323:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101326:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10132c:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101331:	3d 00 02 00 00       	cmp    $0x200,%eax
  101336:	75 0a                	jne    101342 <cons_intr+0x3b>
                cons.wpos = 0;
  101338:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10133f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101342:	8b 45 08             	mov    0x8(%ebp),%eax
  101345:	ff d0                	call   *%eax
  101347:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10134a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10134e:	75 bf                	jne    10130f <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101350:	c9                   	leave  
  101351:	c3                   	ret    

00101352 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101352:	55                   	push   %ebp
  101353:	89 e5                	mov    %esp,%ebp
  101355:	83 ec 10             	sub    $0x10,%esp
  101358:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10135e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101362:	89 c2                	mov    %eax,%edx
  101364:	ec                   	in     (%dx),%al
  101365:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101368:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10136c:	0f b6 c0             	movzbl %al,%eax
  10136f:	83 e0 01             	and    $0x1,%eax
  101372:	85 c0                	test   %eax,%eax
  101374:	75 07                	jne    10137d <serial_proc_data+0x2b>
        return -1;
  101376:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10137b:	eb 2a                	jmp    1013a7 <serial_proc_data+0x55>
  10137d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101383:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101387:	89 c2                	mov    %eax,%edx
  101389:	ec                   	in     (%dx),%al
  10138a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10138d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101391:	0f b6 c0             	movzbl %al,%eax
  101394:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101397:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10139b:	75 07                	jne    1013a4 <serial_proc_data+0x52>
        c = '\b';
  10139d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013a7:	c9                   	leave  
  1013a8:	c3                   	ret    

001013a9 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013a9:	55                   	push   %ebp
  1013aa:	89 e5                	mov    %esp,%ebp
  1013ac:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  1013af:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013b4:	85 c0                	test   %eax,%eax
  1013b6:	74 0c                	je     1013c4 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013b8:	c7 04 24 52 13 10 00 	movl   $0x101352,(%esp)
  1013bf:	e8 43 ff ff ff       	call   101307 <cons_intr>
    }
}
  1013c4:	c9                   	leave  
  1013c5:	c3                   	ret    

001013c6 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013c6:	55                   	push   %ebp
  1013c7:	89 e5                	mov    %esp,%ebp
  1013c9:	83 ec 38             	sub    $0x38,%esp
  1013cc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d2:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013d6:	89 c2                	mov    %eax,%edx
  1013d8:	ec                   	in     (%dx),%al
  1013d9:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013dc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013e0:	0f b6 c0             	movzbl %al,%eax
  1013e3:	83 e0 01             	and    $0x1,%eax
  1013e6:	85 c0                	test   %eax,%eax
  1013e8:	75 0a                	jne    1013f4 <kbd_proc_data+0x2e>
        return -1;
  1013ea:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ef:	e9 59 01 00 00       	jmp    10154d <kbd_proc_data+0x187>
  1013f4:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013fa:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013fe:	89 c2                	mov    %eax,%edx
  101400:	ec                   	in     (%dx),%al
  101401:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101404:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  101408:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10140b:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  10140f:	75 17                	jne    101428 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101411:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101416:	83 c8 40             	or     $0x40,%eax
  101419:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10141e:	b8 00 00 00 00       	mov    $0x0,%eax
  101423:	e9 25 01 00 00       	jmp    10154d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101428:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142c:	84 c0                	test   %al,%al
  10142e:	79 47                	jns    101477 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101430:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101435:	83 e0 40             	and    $0x40,%eax
  101438:	85 c0                	test   %eax,%eax
  10143a:	75 09                	jne    101445 <kbd_proc_data+0x7f>
  10143c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101440:	83 e0 7f             	and    $0x7f,%eax
  101443:	eb 04                	jmp    101449 <kbd_proc_data+0x83>
  101445:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101449:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10144c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101450:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101457:	83 c8 40             	or     $0x40,%eax
  10145a:	0f b6 c0             	movzbl %al,%eax
  10145d:	f7 d0                	not    %eax
  10145f:	89 c2                	mov    %eax,%edx
  101461:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101466:	21 d0                	and    %edx,%eax
  101468:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10146d:	b8 00 00 00 00       	mov    $0x0,%eax
  101472:	e9 d6 00 00 00       	jmp    10154d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101477:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147c:	83 e0 40             	and    $0x40,%eax
  10147f:	85 c0                	test   %eax,%eax
  101481:	74 11                	je     101494 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101483:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101487:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10148c:	83 e0 bf             	and    $0xffffffbf,%eax
  10148f:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101494:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101498:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10149f:	0f b6 d0             	movzbl %al,%edx
  1014a2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a7:	09 d0                	or     %edx,%eax
  1014a9:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  1014ae:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b2:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014b9:	0f b6 d0             	movzbl %al,%edx
  1014bc:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c1:	31 d0                	xor    %edx,%eax
  1014c3:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014c8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014cd:	83 e0 03             	and    $0x3,%eax
  1014d0:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014d7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014db:	01 d0                	add    %edx,%eax
  1014dd:	0f b6 00             	movzbl (%eax),%eax
  1014e0:	0f b6 c0             	movzbl %al,%eax
  1014e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014e6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014eb:	83 e0 08             	and    $0x8,%eax
  1014ee:	85 c0                	test   %eax,%eax
  1014f0:	74 22                	je     101514 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014f2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014f6:	7e 0c                	jle    101504 <kbd_proc_data+0x13e>
  1014f8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014fc:	7f 06                	jg     101504 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014fe:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101502:	eb 10                	jmp    101514 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  101504:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101508:	7e 0a                	jle    101514 <kbd_proc_data+0x14e>
  10150a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10150e:	7f 04                	jg     101514 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101510:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101514:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101519:	f7 d0                	not    %eax
  10151b:	83 e0 06             	and    $0x6,%eax
  10151e:	85 c0                	test   %eax,%eax
  101520:	75 28                	jne    10154a <kbd_proc_data+0x184>
  101522:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101529:	75 1f                	jne    10154a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10152b:	c7 04 24 7d 39 10 00 	movl   $0x10397d,(%esp)
  101532:	e8 eb ed ff ff       	call   100322 <cprintf>
  101537:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10153d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101541:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101545:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101549:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10154a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10154d:	c9                   	leave  
  10154e:	c3                   	ret    

0010154f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10154f:	55                   	push   %ebp
  101550:	89 e5                	mov    %esp,%ebp
  101552:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101555:	c7 04 24 c6 13 10 00 	movl   $0x1013c6,(%esp)
  10155c:	e8 a6 fd ff ff       	call   101307 <cons_intr>
}
  101561:	c9                   	leave  
  101562:	c3                   	ret    

00101563 <kbd_init>:

static void
kbd_init(void) {
  101563:	55                   	push   %ebp
  101564:	89 e5                	mov    %esp,%ebp
  101566:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101569:	e8 e1 ff ff ff       	call   10154f <kbd_intr>
    pic_enable(IRQ_KBD);
  10156e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101575:	e8 17 01 00 00       	call   101691 <pic_enable>
}
  10157a:	c9                   	leave  
  10157b:	c3                   	ret    

0010157c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10157c:	55                   	push   %ebp
  10157d:	89 e5                	mov    %esp,%ebp
  10157f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101582:	e8 93 f8 ff ff       	call   100e1a <cga_init>
    serial_init();
  101587:	e8 74 f9 ff ff       	call   100f00 <serial_init>
    kbd_init();
  10158c:	e8 d2 ff ff ff       	call   101563 <kbd_init>
    if (!serial_exists) {
  101591:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101596:	85 c0                	test   %eax,%eax
  101598:	75 0c                	jne    1015a6 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10159a:	c7 04 24 89 39 10 00 	movl   $0x103989,(%esp)
  1015a1:	e8 7c ed ff ff       	call   100322 <cprintf>
    }
}
  1015a6:	c9                   	leave  
  1015a7:	c3                   	ret    

001015a8 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015a8:	55                   	push   %ebp
  1015a9:	89 e5                	mov    %esp,%ebp
  1015ab:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  1015ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b1:	89 04 24             	mov    %eax,(%esp)
  1015b4:	e8 a3 fa ff ff       	call   10105c <lpt_putc>
    cga_putc(c);
  1015b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015bc:	89 04 24             	mov    %eax,(%esp)
  1015bf:	e8 d7 fa ff ff       	call   10109b <cga_putc>
    serial_putc(c);
  1015c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015c7:	89 04 24             	mov    %eax,(%esp)
  1015ca:	e8 f9 fc ff ff       	call   1012c8 <serial_putc>
}
  1015cf:	c9                   	leave  
  1015d0:	c3                   	ret    

001015d1 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015d1:	55                   	push   %ebp
  1015d2:	89 e5                	mov    %esp,%ebp
  1015d4:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015d7:	e8 cd fd ff ff       	call   1013a9 <serial_intr>
    kbd_intr();
  1015dc:	e8 6e ff ff ff       	call   10154f <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015e1:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015e7:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015ec:	39 c2                	cmp    %eax,%edx
  1015ee:	74 36                	je     101626 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015f0:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015f5:	8d 50 01             	lea    0x1(%eax),%edx
  1015f8:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015fe:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  101605:	0f b6 c0             	movzbl %al,%eax
  101608:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  10160b:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101610:	3d 00 02 00 00       	cmp    $0x200,%eax
  101615:	75 0a                	jne    101621 <cons_getc+0x50>
            cons.rpos = 0;
  101617:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10161e:	00 00 00 
        }
        return c;
  101621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101624:	eb 05                	jmp    10162b <cons_getc+0x5a>
    }
    return 0;
  101626:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10162b:	c9                   	leave  
  10162c:	c3                   	ret    

0010162d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10162d:	55                   	push   %ebp
  10162e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101630:	fb                   	sti    
    sti();
}
  101631:	5d                   	pop    %ebp
  101632:	c3                   	ret    

00101633 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101633:	55                   	push   %ebp
  101634:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101636:	fa                   	cli    
    cli();
}
  101637:	5d                   	pop    %ebp
  101638:	c3                   	ret    

00101639 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101639:	55                   	push   %ebp
  10163a:	89 e5                	mov    %esp,%ebp
  10163c:	83 ec 14             	sub    $0x14,%esp
  10163f:	8b 45 08             	mov    0x8(%ebp),%eax
  101642:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101646:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164a:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101650:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101655:	85 c0                	test   %eax,%eax
  101657:	74 36                	je     10168f <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101659:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10165d:	0f b6 c0             	movzbl %al,%eax
  101660:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101666:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101669:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10166d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101671:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101672:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101676:	66 c1 e8 08          	shr    $0x8,%ax
  10167a:	0f b6 c0             	movzbl %al,%eax
  10167d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101683:	88 45 f9             	mov    %al,-0x7(%ebp)
  101686:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10168a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10168e:	ee                   	out    %al,(%dx)
    }
}
  10168f:	c9                   	leave  
  101690:	c3                   	ret    

00101691 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101691:	55                   	push   %ebp
  101692:	89 e5                	mov    %esp,%ebp
  101694:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101697:	8b 45 08             	mov    0x8(%ebp),%eax
  10169a:	ba 01 00 00 00       	mov    $0x1,%edx
  10169f:	89 c1                	mov    %eax,%ecx
  1016a1:	d3 e2                	shl    %cl,%edx
  1016a3:	89 d0                	mov    %edx,%eax
  1016a5:	f7 d0                	not    %eax
  1016a7:	89 c2                	mov    %eax,%edx
  1016a9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016b0:	21 d0                	and    %edx,%eax
  1016b2:	0f b7 c0             	movzwl %ax,%eax
  1016b5:	89 04 24             	mov    %eax,(%esp)
  1016b8:	e8 7c ff ff ff       	call   101639 <pic_setmask>
}
  1016bd:	c9                   	leave  
  1016be:	c3                   	ret    

001016bf <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016bf:	55                   	push   %ebp
  1016c0:	89 e5                	mov    %esp,%ebp
  1016c2:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016c5:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016cc:	00 00 00 
  1016cf:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016d5:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016d9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016dd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016e1:	ee                   	out    %al,(%dx)
  1016e2:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016e8:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016ec:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016f0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016f4:	ee                   	out    %al,(%dx)
  1016f5:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016fb:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016ff:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101703:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101707:	ee                   	out    %al,(%dx)
  101708:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10170e:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101712:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101716:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10171a:	ee                   	out    %al,(%dx)
  10171b:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101721:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101725:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101729:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10172d:	ee                   	out    %al,(%dx)
  10172e:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101734:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101738:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10173c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101740:	ee                   	out    %al,(%dx)
  101741:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101747:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10174b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10174f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101753:	ee                   	out    %al,(%dx)
  101754:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10175a:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10175e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101762:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101766:	ee                   	out    %al,(%dx)
  101767:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10176d:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101771:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101775:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101779:	ee                   	out    %al,(%dx)
  10177a:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101780:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101784:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101788:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10178c:	ee                   	out    %al,(%dx)
  10178d:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101793:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101797:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10179b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10179f:	ee                   	out    %al,(%dx)
  1017a0:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1017a6:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1017aa:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1017ae:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017b2:	ee                   	out    %al,(%dx)
  1017b3:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017b9:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017bd:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017c1:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017c5:	ee                   	out    %al,(%dx)
  1017c6:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017cc:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017d0:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017d4:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017d8:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017d9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017e0:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017e4:	74 12                	je     1017f8 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017e6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017ed:	0f b7 c0             	movzwl %ax,%eax
  1017f0:	89 04 24             	mov    %eax,(%esp)
  1017f3:	e8 41 fe ff ff       	call   101639 <pic_setmask>
    }
}
  1017f8:	c9                   	leave  
  1017f9:	c3                   	ret    

001017fa <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017fa:	55                   	push   %ebp
  1017fb:	89 e5                	mov    %esp,%ebp
  1017fd:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101800:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101807:	00 
  101808:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  10180f:	e8 0e eb ff ff       	call   100322 <cprintf>
/*#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif*/
}
  101814:	c9                   	leave  
  101815:	c3                   	ret    

00101816 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101816:	55                   	push   %ebp
  101817:	89 e5                	mov    %esp,%ebp
  101819:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  10181c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
  101823:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10182a:	e9 c3 00 00 00       	jmp    1018f2 <idt_init+0xdc>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10182f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101832:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101839:	89 c2                	mov    %eax,%edx
  10183b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10183e:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101845:	00 
  101846:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101849:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101850:	00 08 00 
  101853:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101856:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10185d:	00 
  10185e:	83 e2 e0             	and    $0xffffffe0,%edx
  101861:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101868:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10186b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101872:	00 
  101873:	83 e2 1f             	and    $0x1f,%edx
  101876:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10187d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101880:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101887:	00 
  101888:	83 e2 f0             	and    $0xfffffff0,%edx
  10188b:	83 ca 0e             	or     $0xe,%edx
  10188e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101895:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101898:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10189f:	00 
  1018a0:	83 e2 ef             	and    $0xffffffef,%edx
  1018a3:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018aa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ad:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b4:	00 
  1018b5:	83 e2 9f             	and    $0xffffff9f,%edx
  1018b8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018bf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018c9:	00 
  1018ca:	83 ca 80             	or     $0xffffff80,%edx
  1018cd:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018de:	c1 e8 10             	shr    $0x10,%eax
  1018e1:	89 c2                	mov    %eax,%edx
  1018e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e6:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018ed:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
  1018ee:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f5:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018fa:	0f 86 2f ff ff ff    	jbe    10182f <idt_init+0x19>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SYSCALL], 1, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
  101900:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  101905:	66 a3 a0 f4 10 00    	mov    %ax,0x10f4a0
  10190b:	66 c7 05 a2 f4 10 00 	movw   $0x8,0x10f4a2
  101912:	08 00 
  101914:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  10191b:	83 e0 e0             	and    $0xffffffe0,%eax
  10191e:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  101923:	0f b6 05 a4 f4 10 00 	movzbl 0x10f4a4,%eax
  10192a:	83 e0 1f             	and    $0x1f,%eax
  10192d:	a2 a4 f4 10 00       	mov    %al,0x10f4a4
  101932:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101939:	83 c8 0f             	or     $0xf,%eax
  10193c:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101941:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101948:	83 e0 ef             	and    $0xffffffef,%eax
  10194b:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  101950:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101957:	83 c8 60             	or     $0x60,%eax
  10195a:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  10195f:	0f b6 05 a5 f4 10 00 	movzbl 0x10f4a5,%eax
  101966:	83 c8 80             	or     $0xffffff80,%eax
  101969:	a2 a5 f4 10 00       	mov    %al,0x10f4a5
  10196e:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  101973:	c1 e8 10             	shr    $0x10,%eax
  101976:	66 a3 a6 f4 10 00    	mov    %ax,0x10f4a6
	SETGATE(idt[T_SWITCH_TOK], 1, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  10197c:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101981:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  101987:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  10198e:	08 00 
  101990:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  101997:	83 e0 e0             	and    $0xffffffe0,%eax
  10199a:	a2 6c f4 10 00       	mov    %al,0x10f46c
  10199f:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  1019a6:	83 e0 1f             	and    $0x1f,%eax
  1019a9:	a2 6c f4 10 00       	mov    %al,0x10f46c
  1019ae:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019b5:	83 c8 0f             	or     $0xf,%eax
  1019b8:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019bd:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019c4:	83 e0 ef             	and    $0xffffffef,%eax
  1019c7:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019cc:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019d3:	83 c8 60             	or     $0x60,%eax
  1019d6:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019db:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  1019e2:	83 c8 80             	or     $0xffffff80,%eax
  1019e5:	a2 6d f4 10 00       	mov    %al,0x10f46d
  1019ea:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1019ef:	c1 e8 10             	shr    $0x10,%eax
  1019f2:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  1019f8:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  1019ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a02:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  101a05:	c9                   	leave  
  101a06:	c3                   	ret    

00101a07 <trapname>:

static const char *
trapname(int trapno) {
  101a07:	55                   	push   %ebp
  101a08:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  101a0d:	83 f8 13             	cmp    $0x13,%eax
  101a10:	77 0c                	ja     101a1e <trapname+0x17>
        return excnames[trapno];
  101a12:	8b 45 08             	mov    0x8(%ebp),%eax
  101a15:	8b 04 85 20 3d 10 00 	mov    0x103d20(,%eax,4),%eax
  101a1c:	eb 18                	jmp    101a36 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a1e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a22:	7e 0d                	jle    101a31 <trapname+0x2a>
  101a24:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a28:	7f 07                	jg     101a31 <trapname+0x2a>
        return "Hardware Interrupt";
  101a2a:	b8 ca 39 10 00       	mov    $0x1039ca,%eax
  101a2f:	eb 05                	jmp    101a36 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a31:	b8 dd 39 10 00       	mov    $0x1039dd,%eax
}
  101a36:	5d                   	pop    %ebp
  101a37:	c3                   	ret    

00101a38 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a38:	55                   	push   %ebp
  101a39:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a42:	66 83 f8 08          	cmp    $0x8,%ax
  101a46:	0f 94 c0             	sete   %al
  101a49:	0f b6 c0             	movzbl %al,%eax
}
  101a4c:	5d                   	pop    %ebp
  101a4d:	c3                   	ret    

00101a4e <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a4e:	55                   	push   %ebp
  101a4f:	89 e5                	mov    %esp,%ebp
  101a51:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a54:	8b 45 08             	mov    0x8(%ebp),%eax
  101a57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a5b:	c7 04 24 1e 3a 10 00 	movl   $0x103a1e,(%esp)
  101a62:	e8 bb e8 ff ff       	call   100322 <cprintf>
    print_regs(&tf->tf_regs);
  101a67:	8b 45 08             	mov    0x8(%ebp),%eax
  101a6a:	89 04 24             	mov    %eax,(%esp)
  101a6d:	e8 a1 01 00 00       	call   101c13 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a72:	8b 45 08             	mov    0x8(%ebp),%eax
  101a75:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a79:	0f b7 c0             	movzwl %ax,%eax
  101a7c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a80:	c7 04 24 2f 3a 10 00 	movl   $0x103a2f,(%esp)
  101a87:	e8 96 e8 ff ff       	call   100322 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a8f:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a93:	0f b7 c0             	movzwl %ax,%eax
  101a96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9a:	c7 04 24 42 3a 10 00 	movl   $0x103a42,(%esp)
  101aa1:	e8 7c e8 ff ff       	call   100322 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa9:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101aad:	0f b7 c0             	movzwl %ax,%eax
  101ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab4:	c7 04 24 55 3a 10 00 	movl   $0x103a55,(%esp)
  101abb:	e8 62 e8 ff ff       	call   100322 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac3:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ac7:	0f b7 c0             	movzwl %ax,%eax
  101aca:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ace:	c7 04 24 68 3a 10 00 	movl   $0x103a68,(%esp)
  101ad5:	e8 48 e8 ff ff       	call   100322 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ada:	8b 45 08             	mov    0x8(%ebp),%eax
  101add:	8b 40 30             	mov    0x30(%eax),%eax
  101ae0:	89 04 24             	mov    %eax,(%esp)
  101ae3:	e8 1f ff ff ff       	call   101a07 <trapname>
  101ae8:	8b 55 08             	mov    0x8(%ebp),%edx
  101aeb:	8b 52 30             	mov    0x30(%edx),%edx
  101aee:	89 44 24 08          	mov    %eax,0x8(%esp)
  101af2:	89 54 24 04          	mov    %edx,0x4(%esp)
  101af6:	c7 04 24 7b 3a 10 00 	movl   $0x103a7b,(%esp)
  101afd:	e8 20 e8 ff ff       	call   100322 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b02:	8b 45 08             	mov    0x8(%ebp),%eax
  101b05:	8b 40 34             	mov    0x34(%eax),%eax
  101b08:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0c:	c7 04 24 8d 3a 10 00 	movl   $0x103a8d,(%esp)
  101b13:	e8 0a e8 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b18:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1b:	8b 40 38             	mov    0x38(%eax),%eax
  101b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b22:	c7 04 24 9c 3a 10 00 	movl   $0x103a9c,(%esp)
  101b29:	e8 f4 e7 ff ff       	call   100322 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b31:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b35:	0f b7 c0             	movzwl %ax,%eax
  101b38:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3c:	c7 04 24 ab 3a 10 00 	movl   $0x103aab,(%esp)
  101b43:	e8 da e7 ff ff       	call   100322 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b48:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4b:	8b 40 40             	mov    0x40(%eax),%eax
  101b4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b52:	c7 04 24 be 3a 10 00 	movl   $0x103abe,(%esp)
  101b59:	e8 c4 e7 ff ff       	call   100322 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b65:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b6c:	eb 3e                	jmp    101bac <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b71:	8b 50 40             	mov    0x40(%eax),%edx
  101b74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b77:	21 d0                	and    %edx,%eax
  101b79:	85 c0                	test   %eax,%eax
  101b7b:	74 28                	je     101ba5 <print_trapframe+0x157>
  101b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b80:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b87:	85 c0                	test   %eax,%eax
  101b89:	74 1a                	je     101ba5 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b8e:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b99:	c7 04 24 cd 3a 10 00 	movl   $0x103acd,(%esp)
  101ba0:	e8 7d e7 ff ff       	call   100322 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba5:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101ba9:	d1 65 f0             	shll   -0x10(%ebp)
  101bac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101baf:	83 f8 17             	cmp    $0x17,%eax
  101bb2:	76 ba                	jbe    101b6e <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb7:	8b 40 40             	mov    0x40(%eax),%eax
  101bba:	25 00 30 00 00       	and    $0x3000,%eax
  101bbf:	c1 e8 0c             	shr    $0xc,%eax
  101bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc6:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101bcd:	e8 50 e7 ff ff       	call   100322 <cprintf>

    if (!trap_in_kernel(tf)) {
  101bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd5:	89 04 24             	mov    %eax,(%esp)
  101bd8:	e8 5b fe ff ff       	call   101a38 <trap_in_kernel>
  101bdd:	85 c0                	test   %eax,%eax
  101bdf:	75 30                	jne    101c11 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101be1:	8b 45 08             	mov    0x8(%ebp),%eax
  101be4:	8b 40 44             	mov    0x44(%eax),%eax
  101be7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101beb:	c7 04 24 da 3a 10 00 	movl   $0x103ada,(%esp)
  101bf2:	e8 2b e7 ff ff       	call   100322 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bfa:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bfe:	0f b7 c0             	movzwl %ax,%eax
  101c01:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c05:	c7 04 24 e9 3a 10 00 	movl   $0x103ae9,(%esp)
  101c0c:	e8 11 e7 ff ff       	call   100322 <cprintf>
    }
}
  101c11:	c9                   	leave  
  101c12:	c3                   	ret    

00101c13 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c13:	55                   	push   %ebp
  101c14:	89 e5                	mov    %esp,%ebp
  101c16:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c19:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1c:	8b 00                	mov    (%eax),%eax
  101c1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c22:	c7 04 24 fc 3a 10 00 	movl   $0x103afc,(%esp)
  101c29:	e8 f4 e6 ff ff       	call   100322 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  101c31:	8b 40 04             	mov    0x4(%eax),%eax
  101c34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c38:	c7 04 24 0b 3b 10 00 	movl   $0x103b0b,(%esp)
  101c3f:	e8 de e6 ff ff       	call   100322 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c44:	8b 45 08             	mov    0x8(%ebp),%eax
  101c47:	8b 40 08             	mov    0x8(%eax),%eax
  101c4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c4e:	c7 04 24 1a 3b 10 00 	movl   $0x103b1a,(%esp)
  101c55:	e8 c8 e6 ff ff       	call   100322 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  101c5d:	8b 40 0c             	mov    0xc(%eax),%eax
  101c60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c64:	c7 04 24 29 3b 10 00 	movl   $0x103b29,(%esp)
  101c6b:	e8 b2 e6 ff ff       	call   100322 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c70:	8b 45 08             	mov    0x8(%ebp),%eax
  101c73:	8b 40 10             	mov    0x10(%eax),%eax
  101c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c7a:	c7 04 24 38 3b 10 00 	movl   $0x103b38,(%esp)
  101c81:	e8 9c e6 ff ff       	call   100322 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c86:	8b 45 08             	mov    0x8(%ebp),%eax
  101c89:	8b 40 14             	mov    0x14(%eax),%eax
  101c8c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c90:	c7 04 24 47 3b 10 00 	movl   $0x103b47,(%esp)
  101c97:	e8 86 e6 ff ff       	call   100322 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c9c:	8b 45 08             	mov    0x8(%ebp),%eax
  101c9f:	8b 40 18             	mov    0x18(%eax),%eax
  101ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ca6:	c7 04 24 56 3b 10 00 	movl   $0x103b56,(%esp)
  101cad:	e8 70 e6 ff ff       	call   100322 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cb5:	8b 40 1c             	mov    0x1c(%eax),%eax
  101cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cbc:	c7 04 24 65 3b 10 00 	movl   $0x103b65,(%esp)
  101cc3:	e8 5a e6 ff ff       	call   100322 <cprintf>
}
  101cc8:	c9                   	leave  
  101cc9:	c3                   	ret    

00101cca <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cca:	55                   	push   %ebp
  101ccb:	89 e5                	mov    %esp,%ebp
  101ccd:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd3:	8b 40 30             	mov    0x30(%eax),%eax
  101cd6:	83 f8 2f             	cmp    $0x2f,%eax
  101cd9:	77 21                	ja     101cfc <trap_dispatch+0x32>
  101cdb:	83 f8 2e             	cmp    $0x2e,%eax
  101cde:	0f 83 59 02 00 00    	jae    101f3d <trap_dispatch+0x273>
  101ce4:	83 f8 21             	cmp    $0x21,%eax
  101ce7:	0f 84 8a 00 00 00    	je     101d77 <trap_dispatch+0xad>
  101ced:	83 f8 24             	cmp    $0x24,%eax
  101cf0:	74 5c                	je     101d4e <trap_dispatch+0x84>
  101cf2:	83 f8 20             	cmp    $0x20,%eax
  101cf5:	74 1c                	je     101d13 <trap_dispatch+0x49>
  101cf7:	e9 09 02 00 00       	jmp    101f05 <trap_dispatch+0x23b>
  101cfc:	83 f8 78             	cmp    $0x78,%eax
  101cff:	0f 84 5a 01 00 00    	je     101e5f <trap_dispatch+0x195>
  101d05:	83 f8 79             	cmp    $0x79,%eax
  101d08:	0f 84 a7 01 00 00    	je     101eb5 <trap_dispatch+0x1eb>
  101d0e:	e9 f2 01 00 00       	jmp    101f05 <trap_dispatch+0x23b>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
  101d13:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101d18:	83 c0 01             	add    $0x1,%eax
  101d1b:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0)
  101d20:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101d26:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101d2b:	89 c8                	mov    %ecx,%eax
  101d2d:	f7 e2                	mul    %edx
  101d2f:	89 d0                	mov    %edx,%eax
  101d31:	c1 e8 05             	shr    $0x5,%eax
  101d34:	6b c0 64             	imul   $0x64,%eax,%eax
  101d37:	29 c1                	sub    %eax,%ecx
  101d39:	89 c8                	mov    %ecx,%eax
  101d3b:	85 c0                	test   %eax,%eax
  101d3d:	75 0a                	jne    101d49 <trap_dispatch+0x7f>
		print_ticks();
  101d3f:	e8 b6 fa ff ff       	call   1017fa <print_ticks>
        break;
  101d44:	e9 f5 01 00 00       	jmp    101f3e <trap_dispatch+0x274>
  101d49:	e9 f0 01 00 00       	jmp    101f3e <trap_dispatch+0x274>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d4e:	e8 7e f8 ff ff       	call   1015d1 <cons_getc>
  101d53:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d56:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d5a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d5e:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d62:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d66:	c7 04 24 74 3b 10 00 	movl   $0x103b74,(%esp)
  101d6d:	e8 b0 e5 ff ff       	call   100322 <cprintf>
        break;
  101d72:	e9 c7 01 00 00       	jmp    101f3e <trap_dispatch+0x274>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d77:	e8 55 f8 ff ff       	call   1015d1 <cons_getc>
  101d7c:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d7f:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d83:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d87:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d8b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d8f:	c7 04 24 86 3b 10 00 	movl   $0x103b86,(%esp)
  101d96:	e8 87 e5 ff ff       	call   100322 <cprintf>
        if (c == '0') {
  101d9b:	80 7d f7 30          	cmpb   $0x30,-0x9(%ebp)
  101d9f:	75 57                	jne    101df8 <trap_dispatch+0x12e>
        	if (tf->tf_cs != KERNEL_CS) {
  101da1:	8b 45 08             	mov    0x8(%ebp),%eax
  101da4:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101da8:	66 83 f8 08          	cmp    $0x8,%ax
  101dac:	74 3f                	je     101ded <trap_dispatch+0x123>
				tf->tf_cs = KERNEL_CS;
  101dae:	8b 45 08             	mov    0x8(%ebp),%eax
  101db1:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
				tf->tf_ds = tf->tf_ss = tf->tf_es = KERNEL_DS;
  101db7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dba:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  101dc3:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dca:	66 89 50 48          	mov    %dx,0x48(%eax)
  101dce:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd1:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  101dd8:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags &= ~FL_IOPL_MASK;
  101ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  101ddf:	8b 40 40             	mov    0x40(%eax),%eax
  101de2:	80 e4 cf             	and    $0xcf,%ah
  101de5:	89 c2                	mov    %eax,%edx
  101de7:	8b 45 08             	mov    0x8(%ebp),%eax
  101dea:	89 50 40             	mov    %edx,0x40(%eax)
			}
        	print_trapframe(tf);
  101ded:	8b 45 08             	mov    0x8(%ebp),%eax
  101df0:	89 04 24             	mov    %eax,(%esp)
  101df3:	e8 56 fc ff ff       	call   101a4e <print_trapframe>
        }
        if (c == '3') {
  101df8:	80 7d f7 33          	cmpb   $0x33,-0x9(%ebp)
  101dfc:	75 5c                	jne    101e5a <trap_dispatch+0x190>
        	if (tf->tf_cs != USER_CS) {
  101dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101e01:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e05:	66 83 f8 1b          	cmp    $0x1b,%ax
  101e09:	74 3f                	je     101e4a <trap_dispatch+0x180>
				tf->tf_cs = USER_CS;
  101e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e0e:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
				tf->tf_ds = tf->tf_ss = tf->tf_es = USER_DS;
  101e14:	8b 45 08             	mov    0x8(%ebp),%eax
  101e17:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
  101e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e20:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e24:	8b 45 08             	mov    0x8(%ebp),%eax
  101e27:	66 89 50 48          	mov    %dx,0x48(%eax)
  101e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e2e:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e32:	8b 45 08             	mov    0x8(%ebp),%eax
  101e35:	66 89 50 2c          	mov    %dx,0x2c(%eax)
				tf->tf_eflags |= FL_IOPL_MASK;
  101e39:	8b 45 08             	mov    0x8(%ebp),%eax
  101e3c:	8b 40 40             	mov    0x40(%eax),%eax
  101e3f:	80 cc 30             	or     $0x30,%ah
  101e42:	89 c2                	mov    %eax,%edx
  101e44:	8b 45 08             	mov    0x8(%ebp),%eax
  101e47:	89 50 40             	mov    %edx,0x40(%eax)
			}
        	print_trapframe(tf);
  101e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e4d:	89 04 24             	mov    %eax,(%esp)
  101e50:	e8 f9 fb ff ff       	call   101a4e <print_trapframe>
        }
        break;
  101e55:	e9 e4 00 00 00       	jmp    101f3e <trap_dispatch+0x274>
  101e5a:	e9 df 00 00 00       	jmp    101f3e <trap_dispatch+0x274>
    //LAB1 CHALLENGE 1 : 2015011385 you should modify below codes.
    case T_SWITCH_TOU:
    	if (tf->tf_cs != USER_CS) {
  101e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e62:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e66:	66 83 f8 1b          	cmp    $0x1b,%ax
  101e6a:	74 44                	je     101eb0 <trap_dispatch+0x1e6>
    		tf->tf_cs = USER_CS;
  101e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6f:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    		tf->tf_ds = tf->tf_ss = tf->tf_es = USER_DS;
  101e75:	8b 45 08             	mov    0x8(%ebp),%eax
  101e78:	66 c7 40 28 23 00    	movw   $0x23,0x28(%eax)
  101e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  101e81:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e85:	8b 45 08             	mov    0x8(%ebp),%eax
  101e88:	66 89 50 48          	mov    %dx,0x48(%eax)
  101e8c:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8f:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101e93:	8b 45 08             	mov    0x8(%ebp),%eax
  101e96:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    		tf->tf_eflags |= FL_IOPL_MASK;
  101e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9d:	8b 40 40             	mov    0x40(%eax),%eax
  101ea0:	80 cc 30             	or     $0x30,%ah
  101ea3:	89 c2                	mov    %eax,%edx
  101ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea8:	89 50 40             	mov    %edx,0x40(%eax)
    	}
    	break;
  101eab:	e9 8e 00 00 00       	jmp    101f3e <trap_dispatch+0x274>
  101eb0:	e9 89 00 00 00       	jmp    101f3e <trap_dispatch+0x274>
    case T_SWITCH_TOK:
    	if (tf->tf_cs != KERNEL_CS) {
  101eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  101eb8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ebc:	66 83 f8 08          	cmp    $0x8,%ax
  101ec0:	74 41                	je     101f03 <trap_dispatch+0x239>
    	   	tf->tf_cs = KERNEL_CS;
  101ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ec5:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
			tf->tf_ds = tf->tf_ss = tf->tf_es = KERNEL_DS;
  101ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ece:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  101ed7:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101edb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ede:	66 89 50 48          	mov    %dx,0x48(%eax)
  101ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee5:	0f b7 50 48          	movzwl 0x48(%eax),%edx
  101ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  101eec:	66 89 50 2c          	mov    %dx,0x2c(%eax)
			tf->tf_eflags &= ~FL_IOPL_MASK;
  101ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef3:	8b 40 40             	mov    0x40(%eax),%eax
  101ef6:	80 e4 cf             	and    $0xcf,%ah
  101ef9:	89 c2                	mov    %eax,%edx
  101efb:	8b 45 08             	mov    0x8(%ebp),%eax
  101efe:	89 50 40             	mov    %edx,0x40(%eax)
		}
		break;
  101f01:	eb 3b                	jmp    101f3e <trap_dispatch+0x274>
  101f03:	eb 39                	jmp    101f3e <trap_dispatch+0x274>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101f05:	8b 45 08             	mov    0x8(%ebp),%eax
  101f08:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101f0c:	0f b7 c0             	movzwl %ax,%eax
  101f0f:	83 e0 03             	and    $0x3,%eax
  101f12:	85 c0                	test   %eax,%eax
  101f14:	75 28                	jne    101f3e <trap_dispatch+0x274>
            print_trapframe(tf);
  101f16:	8b 45 08             	mov    0x8(%ebp),%eax
  101f19:	89 04 24             	mov    %eax,(%esp)
  101f1c:	e8 2d fb ff ff       	call   101a4e <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f21:	c7 44 24 08 95 3b 10 	movl   $0x103b95,0x8(%esp)
  101f28:	00 
  101f29:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  101f30:	00 
  101f31:	c7 04 24 b1 3b 10 00 	movl   $0x103bb1,(%esp)
  101f38:	e8 76 ed ff ff       	call   100cb3 <__panic>
		}
		break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101f3d:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101f3e:	c9                   	leave  
  101f3f:	c3                   	ret    

00101f40 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f40:	55                   	push   %ebp
  101f41:	89 e5                	mov    %esp,%ebp
  101f43:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f46:	8b 45 08             	mov    0x8(%ebp),%eax
  101f49:	89 04 24             	mov    %eax,(%esp)
  101f4c:	e8 79 fd ff ff       	call   101cca <trap_dispatch>
}
  101f51:	c9                   	leave  
  101f52:	c3                   	ret    

00101f53 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101f53:	1e                   	push   %ds
    pushl %es
  101f54:	06                   	push   %es
    pushl %fs
  101f55:	0f a0                	push   %fs
    pushl %gs
  101f57:	0f a8                	push   %gs
    pushal
  101f59:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101f5a:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101f5f:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101f61:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101f63:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101f64:	e8 d7 ff ff ff       	call   101f40 <trap>

    # pop the pushed stack pointer
    popl %esp
  101f69:	5c                   	pop    %esp

00101f6a <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101f6a:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101f6b:	0f a9                	pop    %gs
    popl %fs
  101f6d:	0f a1                	pop    %fs
    popl %es
  101f6f:	07                   	pop    %es
    popl %ds
  101f70:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101f71:	83 c4 08             	add    $0x8,%esp
    iret
  101f74:	cf                   	iret   

00101f75 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f75:	6a 00                	push   $0x0
  pushl $0
  101f77:	6a 00                	push   $0x0
  jmp __alltraps
  101f79:	e9 d5 ff ff ff       	jmp    101f53 <__alltraps>

00101f7e <vector1>:
.globl vector1
vector1:
  pushl $0
  101f7e:	6a 00                	push   $0x0
  pushl $1
  101f80:	6a 01                	push   $0x1
  jmp __alltraps
  101f82:	e9 cc ff ff ff       	jmp    101f53 <__alltraps>

00101f87 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f87:	6a 00                	push   $0x0
  pushl $2
  101f89:	6a 02                	push   $0x2
  jmp __alltraps
  101f8b:	e9 c3 ff ff ff       	jmp    101f53 <__alltraps>

00101f90 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f90:	6a 00                	push   $0x0
  pushl $3
  101f92:	6a 03                	push   $0x3
  jmp __alltraps
  101f94:	e9 ba ff ff ff       	jmp    101f53 <__alltraps>

00101f99 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f99:	6a 00                	push   $0x0
  pushl $4
  101f9b:	6a 04                	push   $0x4
  jmp __alltraps
  101f9d:	e9 b1 ff ff ff       	jmp    101f53 <__alltraps>

00101fa2 <vector5>:
.globl vector5
vector5:
  pushl $0
  101fa2:	6a 00                	push   $0x0
  pushl $5
  101fa4:	6a 05                	push   $0x5
  jmp __alltraps
  101fa6:	e9 a8 ff ff ff       	jmp    101f53 <__alltraps>

00101fab <vector6>:
.globl vector6
vector6:
  pushl $0
  101fab:	6a 00                	push   $0x0
  pushl $6
  101fad:	6a 06                	push   $0x6
  jmp __alltraps
  101faf:	e9 9f ff ff ff       	jmp    101f53 <__alltraps>

00101fb4 <vector7>:
.globl vector7
vector7:
  pushl $0
  101fb4:	6a 00                	push   $0x0
  pushl $7
  101fb6:	6a 07                	push   $0x7
  jmp __alltraps
  101fb8:	e9 96 ff ff ff       	jmp    101f53 <__alltraps>

00101fbd <vector8>:
.globl vector8
vector8:
  pushl $8
  101fbd:	6a 08                	push   $0x8
  jmp __alltraps
  101fbf:	e9 8f ff ff ff       	jmp    101f53 <__alltraps>

00101fc4 <vector9>:
.globl vector9
vector9:
  pushl $9
  101fc4:	6a 09                	push   $0x9
  jmp __alltraps
  101fc6:	e9 88 ff ff ff       	jmp    101f53 <__alltraps>

00101fcb <vector10>:
.globl vector10
vector10:
  pushl $10
  101fcb:	6a 0a                	push   $0xa
  jmp __alltraps
  101fcd:	e9 81 ff ff ff       	jmp    101f53 <__alltraps>

00101fd2 <vector11>:
.globl vector11
vector11:
  pushl $11
  101fd2:	6a 0b                	push   $0xb
  jmp __alltraps
  101fd4:	e9 7a ff ff ff       	jmp    101f53 <__alltraps>

00101fd9 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fd9:	6a 0c                	push   $0xc
  jmp __alltraps
  101fdb:	e9 73 ff ff ff       	jmp    101f53 <__alltraps>

00101fe0 <vector13>:
.globl vector13
vector13:
  pushl $13
  101fe0:	6a 0d                	push   $0xd
  jmp __alltraps
  101fe2:	e9 6c ff ff ff       	jmp    101f53 <__alltraps>

00101fe7 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fe7:	6a 0e                	push   $0xe
  jmp __alltraps
  101fe9:	e9 65 ff ff ff       	jmp    101f53 <__alltraps>

00101fee <vector15>:
.globl vector15
vector15:
  pushl $0
  101fee:	6a 00                	push   $0x0
  pushl $15
  101ff0:	6a 0f                	push   $0xf
  jmp __alltraps
  101ff2:	e9 5c ff ff ff       	jmp    101f53 <__alltraps>

00101ff7 <vector16>:
.globl vector16
vector16:
  pushl $0
  101ff7:	6a 00                	push   $0x0
  pushl $16
  101ff9:	6a 10                	push   $0x10
  jmp __alltraps
  101ffb:	e9 53 ff ff ff       	jmp    101f53 <__alltraps>

00102000 <vector17>:
.globl vector17
vector17:
  pushl $17
  102000:	6a 11                	push   $0x11
  jmp __alltraps
  102002:	e9 4c ff ff ff       	jmp    101f53 <__alltraps>

00102007 <vector18>:
.globl vector18
vector18:
  pushl $0
  102007:	6a 00                	push   $0x0
  pushl $18
  102009:	6a 12                	push   $0x12
  jmp __alltraps
  10200b:	e9 43 ff ff ff       	jmp    101f53 <__alltraps>

00102010 <vector19>:
.globl vector19
vector19:
  pushl $0
  102010:	6a 00                	push   $0x0
  pushl $19
  102012:	6a 13                	push   $0x13
  jmp __alltraps
  102014:	e9 3a ff ff ff       	jmp    101f53 <__alltraps>

00102019 <vector20>:
.globl vector20
vector20:
  pushl $0
  102019:	6a 00                	push   $0x0
  pushl $20
  10201b:	6a 14                	push   $0x14
  jmp __alltraps
  10201d:	e9 31 ff ff ff       	jmp    101f53 <__alltraps>

00102022 <vector21>:
.globl vector21
vector21:
  pushl $0
  102022:	6a 00                	push   $0x0
  pushl $21
  102024:	6a 15                	push   $0x15
  jmp __alltraps
  102026:	e9 28 ff ff ff       	jmp    101f53 <__alltraps>

0010202b <vector22>:
.globl vector22
vector22:
  pushl $0
  10202b:	6a 00                	push   $0x0
  pushl $22
  10202d:	6a 16                	push   $0x16
  jmp __alltraps
  10202f:	e9 1f ff ff ff       	jmp    101f53 <__alltraps>

00102034 <vector23>:
.globl vector23
vector23:
  pushl $0
  102034:	6a 00                	push   $0x0
  pushl $23
  102036:	6a 17                	push   $0x17
  jmp __alltraps
  102038:	e9 16 ff ff ff       	jmp    101f53 <__alltraps>

0010203d <vector24>:
.globl vector24
vector24:
  pushl $0
  10203d:	6a 00                	push   $0x0
  pushl $24
  10203f:	6a 18                	push   $0x18
  jmp __alltraps
  102041:	e9 0d ff ff ff       	jmp    101f53 <__alltraps>

00102046 <vector25>:
.globl vector25
vector25:
  pushl $0
  102046:	6a 00                	push   $0x0
  pushl $25
  102048:	6a 19                	push   $0x19
  jmp __alltraps
  10204a:	e9 04 ff ff ff       	jmp    101f53 <__alltraps>

0010204f <vector26>:
.globl vector26
vector26:
  pushl $0
  10204f:	6a 00                	push   $0x0
  pushl $26
  102051:	6a 1a                	push   $0x1a
  jmp __alltraps
  102053:	e9 fb fe ff ff       	jmp    101f53 <__alltraps>

00102058 <vector27>:
.globl vector27
vector27:
  pushl $0
  102058:	6a 00                	push   $0x0
  pushl $27
  10205a:	6a 1b                	push   $0x1b
  jmp __alltraps
  10205c:	e9 f2 fe ff ff       	jmp    101f53 <__alltraps>

00102061 <vector28>:
.globl vector28
vector28:
  pushl $0
  102061:	6a 00                	push   $0x0
  pushl $28
  102063:	6a 1c                	push   $0x1c
  jmp __alltraps
  102065:	e9 e9 fe ff ff       	jmp    101f53 <__alltraps>

0010206a <vector29>:
.globl vector29
vector29:
  pushl $0
  10206a:	6a 00                	push   $0x0
  pushl $29
  10206c:	6a 1d                	push   $0x1d
  jmp __alltraps
  10206e:	e9 e0 fe ff ff       	jmp    101f53 <__alltraps>

00102073 <vector30>:
.globl vector30
vector30:
  pushl $0
  102073:	6a 00                	push   $0x0
  pushl $30
  102075:	6a 1e                	push   $0x1e
  jmp __alltraps
  102077:	e9 d7 fe ff ff       	jmp    101f53 <__alltraps>

0010207c <vector31>:
.globl vector31
vector31:
  pushl $0
  10207c:	6a 00                	push   $0x0
  pushl $31
  10207e:	6a 1f                	push   $0x1f
  jmp __alltraps
  102080:	e9 ce fe ff ff       	jmp    101f53 <__alltraps>

00102085 <vector32>:
.globl vector32
vector32:
  pushl $0
  102085:	6a 00                	push   $0x0
  pushl $32
  102087:	6a 20                	push   $0x20
  jmp __alltraps
  102089:	e9 c5 fe ff ff       	jmp    101f53 <__alltraps>

0010208e <vector33>:
.globl vector33
vector33:
  pushl $0
  10208e:	6a 00                	push   $0x0
  pushl $33
  102090:	6a 21                	push   $0x21
  jmp __alltraps
  102092:	e9 bc fe ff ff       	jmp    101f53 <__alltraps>

00102097 <vector34>:
.globl vector34
vector34:
  pushl $0
  102097:	6a 00                	push   $0x0
  pushl $34
  102099:	6a 22                	push   $0x22
  jmp __alltraps
  10209b:	e9 b3 fe ff ff       	jmp    101f53 <__alltraps>

001020a0 <vector35>:
.globl vector35
vector35:
  pushl $0
  1020a0:	6a 00                	push   $0x0
  pushl $35
  1020a2:	6a 23                	push   $0x23
  jmp __alltraps
  1020a4:	e9 aa fe ff ff       	jmp    101f53 <__alltraps>

001020a9 <vector36>:
.globl vector36
vector36:
  pushl $0
  1020a9:	6a 00                	push   $0x0
  pushl $36
  1020ab:	6a 24                	push   $0x24
  jmp __alltraps
  1020ad:	e9 a1 fe ff ff       	jmp    101f53 <__alltraps>

001020b2 <vector37>:
.globl vector37
vector37:
  pushl $0
  1020b2:	6a 00                	push   $0x0
  pushl $37
  1020b4:	6a 25                	push   $0x25
  jmp __alltraps
  1020b6:	e9 98 fe ff ff       	jmp    101f53 <__alltraps>

001020bb <vector38>:
.globl vector38
vector38:
  pushl $0
  1020bb:	6a 00                	push   $0x0
  pushl $38
  1020bd:	6a 26                	push   $0x26
  jmp __alltraps
  1020bf:	e9 8f fe ff ff       	jmp    101f53 <__alltraps>

001020c4 <vector39>:
.globl vector39
vector39:
  pushl $0
  1020c4:	6a 00                	push   $0x0
  pushl $39
  1020c6:	6a 27                	push   $0x27
  jmp __alltraps
  1020c8:	e9 86 fe ff ff       	jmp    101f53 <__alltraps>

001020cd <vector40>:
.globl vector40
vector40:
  pushl $0
  1020cd:	6a 00                	push   $0x0
  pushl $40
  1020cf:	6a 28                	push   $0x28
  jmp __alltraps
  1020d1:	e9 7d fe ff ff       	jmp    101f53 <__alltraps>

001020d6 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020d6:	6a 00                	push   $0x0
  pushl $41
  1020d8:	6a 29                	push   $0x29
  jmp __alltraps
  1020da:	e9 74 fe ff ff       	jmp    101f53 <__alltraps>

001020df <vector42>:
.globl vector42
vector42:
  pushl $0
  1020df:	6a 00                	push   $0x0
  pushl $42
  1020e1:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020e3:	e9 6b fe ff ff       	jmp    101f53 <__alltraps>

001020e8 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020e8:	6a 00                	push   $0x0
  pushl $43
  1020ea:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020ec:	e9 62 fe ff ff       	jmp    101f53 <__alltraps>

001020f1 <vector44>:
.globl vector44
vector44:
  pushl $0
  1020f1:	6a 00                	push   $0x0
  pushl $44
  1020f3:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020f5:	e9 59 fe ff ff       	jmp    101f53 <__alltraps>

001020fa <vector45>:
.globl vector45
vector45:
  pushl $0
  1020fa:	6a 00                	push   $0x0
  pushl $45
  1020fc:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020fe:	e9 50 fe ff ff       	jmp    101f53 <__alltraps>

00102103 <vector46>:
.globl vector46
vector46:
  pushl $0
  102103:	6a 00                	push   $0x0
  pushl $46
  102105:	6a 2e                	push   $0x2e
  jmp __alltraps
  102107:	e9 47 fe ff ff       	jmp    101f53 <__alltraps>

0010210c <vector47>:
.globl vector47
vector47:
  pushl $0
  10210c:	6a 00                	push   $0x0
  pushl $47
  10210e:	6a 2f                	push   $0x2f
  jmp __alltraps
  102110:	e9 3e fe ff ff       	jmp    101f53 <__alltraps>

00102115 <vector48>:
.globl vector48
vector48:
  pushl $0
  102115:	6a 00                	push   $0x0
  pushl $48
  102117:	6a 30                	push   $0x30
  jmp __alltraps
  102119:	e9 35 fe ff ff       	jmp    101f53 <__alltraps>

0010211e <vector49>:
.globl vector49
vector49:
  pushl $0
  10211e:	6a 00                	push   $0x0
  pushl $49
  102120:	6a 31                	push   $0x31
  jmp __alltraps
  102122:	e9 2c fe ff ff       	jmp    101f53 <__alltraps>

00102127 <vector50>:
.globl vector50
vector50:
  pushl $0
  102127:	6a 00                	push   $0x0
  pushl $50
  102129:	6a 32                	push   $0x32
  jmp __alltraps
  10212b:	e9 23 fe ff ff       	jmp    101f53 <__alltraps>

00102130 <vector51>:
.globl vector51
vector51:
  pushl $0
  102130:	6a 00                	push   $0x0
  pushl $51
  102132:	6a 33                	push   $0x33
  jmp __alltraps
  102134:	e9 1a fe ff ff       	jmp    101f53 <__alltraps>

00102139 <vector52>:
.globl vector52
vector52:
  pushl $0
  102139:	6a 00                	push   $0x0
  pushl $52
  10213b:	6a 34                	push   $0x34
  jmp __alltraps
  10213d:	e9 11 fe ff ff       	jmp    101f53 <__alltraps>

00102142 <vector53>:
.globl vector53
vector53:
  pushl $0
  102142:	6a 00                	push   $0x0
  pushl $53
  102144:	6a 35                	push   $0x35
  jmp __alltraps
  102146:	e9 08 fe ff ff       	jmp    101f53 <__alltraps>

0010214b <vector54>:
.globl vector54
vector54:
  pushl $0
  10214b:	6a 00                	push   $0x0
  pushl $54
  10214d:	6a 36                	push   $0x36
  jmp __alltraps
  10214f:	e9 ff fd ff ff       	jmp    101f53 <__alltraps>

00102154 <vector55>:
.globl vector55
vector55:
  pushl $0
  102154:	6a 00                	push   $0x0
  pushl $55
  102156:	6a 37                	push   $0x37
  jmp __alltraps
  102158:	e9 f6 fd ff ff       	jmp    101f53 <__alltraps>

0010215d <vector56>:
.globl vector56
vector56:
  pushl $0
  10215d:	6a 00                	push   $0x0
  pushl $56
  10215f:	6a 38                	push   $0x38
  jmp __alltraps
  102161:	e9 ed fd ff ff       	jmp    101f53 <__alltraps>

00102166 <vector57>:
.globl vector57
vector57:
  pushl $0
  102166:	6a 00                	push   $0x0
  pushl $57
  102168:	6a 39                	push   $0x39
  jmp __alltraps
  10216a:	e9 e4 fd ff ff       	jmp    101f53 <__alltraps>

0010216f <vector58>:
.globl vector58
vector58:
  pushl $0
  10216f:	6a 00                	push   $0x0
  pushl $58
  102171:	6a 3a                	push   $0x3a
  jmp __alltraps
  102173:	e9 db fd ff ff       	jmp    101f53 <__alltraps>

00102178 <vector59>:
.globl vector59
vector59:
  pushl $0
  102178:	6a 00                	push   $0x0
  pushl $59
  10217a:	6a 3b                	push   $0x3b
  jmp __alltraps
  10217c:	e9 d2 fd ff ff       	jmp    101f53 <__alltraps>

00102181 <vector60>:
.globl vector60
vector60:
  pushl $0
  102181:	6a 00                	push   $0x0
  pushl $60
  102183:	6a 3c                	push   $0x3c
  jmp __alltraps
  102185:	e9 c9 fd ff ff       	jmp    101f53 <__alltraps>

0010218a <vector61>:
.globl vector61
vector61:
  pushl $0
  10218a:	6a 00                	push   $0x0
  pushl $61
  10218c:	6a 3d                	push   $0x3d
  jmp __alltraps
  10218e:	e9 c0 fd ff ff       	jmp    101f53 <__alltraps>

00102193 <vector62>:
.globl vector62
vector62:
  pushl $0
  102193:	6a 00                	push   $0x0
  pushl $62
  102195:	6a 3e                	push   $0x3e
  jmp __alltraps
  102197:	e9 b7 fd ff ff       	jmp    101f53 <__alltraps>

0010219c <vector63>:
.globl vector63
vector63:
  pushl $0
  10219c:	6a 00                	push   $0x0
  pushl $63
  10219e:	6a 3f                	push   $0x3f
  jmp __alltraps
  1021a0:	e9 ae fd ff ff       	jmp    101f53 <__alltraps>

001021a5 <vector64>:
.globl vector64
vector64:
  pushl $0
  1021a5:	6a 00                	push   $0x0
  pushl $64
  1021a7:	6a 40                	push   $0x40
  jmp __alltraps
  1021a9:	e9 a5 fd ff ff       	jmp    101f53 <__alltraps>

001021ae <vector65>:
.globl vector65
vector65:
  pushl $0
  1021ae:	6a 00                	push   $0x0
  pushl $65
  1021b0:	6a 41                	push   $0x41
  jmp __alltraps
  1021b2:	e9 9c fd ff ff       	jmp    101f53 <__alltraps>

001021b7 <vector66>:
.globl vector66
vector66:
  pushl $0
  1021b7:	6a 00                	push   $0x0
  pushl $66
  1021b9:	6a 42                	push   $0x42
  jmp __alltraps
  1021bb:	e9 93 fd ff ff       	jmp    101f53 <__alltraps>

001021c0 <vector67>:
.globl vector67
vector67:
  pushl $0
  1021c0:	6a 00                	push   $0x0
  pushl $67
  1021c2:	6a 43                	push   $0x43
  jmp __alltraps
  1021c4:	e9 8a fd ff ff       	jmp    101f53 <__alltraps>

001021c9 <vector68>:
.globl vector68
vector68:
  pushl $0
  1021c9:	6a 00                	push   $0x0
  pushl $68
  1021cb:	6a 44                	push   $0x44
  jmp __alltraps
  1021cd:	e9 81 fd ff ff       	jmp    101f53 <__alltraps>

001021d2 <vector69>:
.globl vector69
vector69:
  pushl $0
  1021d2:	6a 00                	push   $0x0
  pushl $69
  1021d4:	6a 45                	push   $0x45
  jmp __alltraps
  1021d6:	e9 78 fd ff ff       	jmp    101f53 <__alltraps>

001021db <vector70>:
.globl vector70
vector70:
  pushl $0
  1021db:	6a 00                	push   $0x0
  pushl $70
  1021dd:	6a 46                	push   $0x46
  jmp __alltraps
  1021df:	e9 6f fd ff ff       	jmp    101f53 <__alltraps>

001021e4 <vector71>:
.globl vector71
vector71:
  pushl $0
  1021e4:	6a 00                	push   $0x0
  pushl $71
  1021e6:	6a 47                	push   $0x47
  jmp __alltraps
  1021e8:	e9 66 fd ff ff       	jmp    101f53 <__alltraps>

001021ed <vector72>:
.globl vector72
vector72:
  pushl $0
  1021ed:	6a 00                	push   $0x0
  pushl $72
  1021ef:	6a 48                	push   $0x48
  jmp __alltraps
  1021f1:	e9 5d fd ff ff       	jmp    101f53 <__alltraps>

001021f6 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021f6:	6a 00                	push   $0x0
  pushl $73
  1021f8:	6a 49                	push   $0x49
  jmp __alltraps
  1021fa:	e9 54 fd ff ff       	jmp    101f53 <__alltraps>

001021ff <vector74>:
.globl vector74
vector74:
  pushl $0
  1021ff:	6a 00                	push   $0x0
  pushl $74
  102201:	6a 4a                	push   $0x4a
  jmp __alltraps
  102203:	e9 4b fd ff ff       	jmp    101f53 <__alltraps>

00102208 <vector75>:
.globl vector75
vector75:
  pushl $0
  102208:	6a 00                	push   $0x0
  pushl $75
  10220a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10220c:	e9 42 fd ff ff       	jmp    101f53 <__alltraps>

00102211 <vector76>:
.globl vector76
vector76:
  pushl $0
  102211:	6a 00                	push   $0x0
  pushl $76
  102213:	6a 4c                	push   $0x4c
  jmp __alltraps
  102215:	e9 39 fd ff ff       	jmp    101f53 <__alltraps>

0010221a <vector77>:
.globl vector77
vector77:
  pushl $0
  10221a:	6a 00                	push   $0x0
  pushl $77
  10221c:	6a 4d                	push   $0x4d
  jmp __alltraps
  10221e:	e9 30 fd ff ff       	jmp    101f53 <__alltraps>

00102223 <vector78>:
.globl vector78
vector78:
  pushl $0
  102223:	6a 00                	push   $0x0
  pushl $78
  102225:	6a 4e                	push   $0x4e
  jmp __alltraps
  102227:	e9 27 fd ff ff       	jmp    101f53 <__alltraps>

0010222c <vector79>:
.globl vector79
vector79:
  pushl $0
  10222c:	6a 00                	push   $0x0
  pushl $79
  10222e:	6a 4f                	push   $0x4f
  jmp __alltraps
  102230:	e9 1e fd ff ff       	jmp    101f53 <__alltraps>

00102235 <vector80>:
.globl vector80
vector80:
  pushl $0
  102235:	6a 00                	push   $0x0
  pushl $80
  102237:	6a 50                	push   $0x50
  jmp __alltraps
  102239:	e9 15 fd ff ff       	jmp    101f53 <__alltraps>

0010223e <vector81>:
.globl vector81
vector81:
  pushl $0
  10223e:	6a 00                	push   $0x0
  pushl $81
  102240:	6a 51                	push   $0x51
  jmp __alltraps
  102242:	e9 0c fd ff ff       	jmp    101f53 <__alltraps>

00102247 <vector82>:
.globl vector82
vector82:
  pushl $0
  102247:	6a 00                	push   $0x0
  pushl $82
  102249:	6a 52                	push   $0x52
  jmp __alltraps
  10224b:	e9 03 fd ff ff       	jmp    101f53 <__alltraps>

00102250 <vector83>:
.globl vector83
vector83:
  pushl $0
  102250:	6a 00                	push   $0x0
  pushl $83
  102252:	6a 53                	push   $0x53
  jmp __alltraps
  102254:	e9 fa fc ff ff       	jmp    101f53 <__alltraps>

00102259 <vector84>:
.globl vector84
vector84:
  pushl $0
  102259:	6a 00                	push   $0x0
  pushl $84
  10225b:	6a 54                	push   $0x54
  jmp __alltraps
  10225d:	e9 f1 fc ff ff       	jmp    101f53 <__alltraps>

00102262 <vector85>:
.globl vector85
vector85:
  pushl $0
  102262:	6a 00                	push   $0x0
  pushl $85
  102264:	6a 55                	push   $0x55
  jmp __alltraps
  102266:	e9 e8 fc ff ff       	jmp    101f53 <__alltraps>

0010226b <vector86>:
.globl vector86
vector86:
  pushl $0
  10226b:	6a 00                	push   $0x0
  pushl $86
  10226d:	6a 56                	push   $0x56
  jmp __alltraps
  10226f:	e9 df fc ff ff       	jmp    101f53 <__alltraps>

00102274 <vector87>:
.globl vector87
vector87:
  pushl $0
  102274:	6a 00                	push   $0x0
  pushl $87
  102276:	6a 57                	push   $0x57
  jmp __alltraps
  102278:	e9 d6 fc ff ff       	jmp    101f53 <__alltraps>

0010227d <vector88>:
.globl vector88
vector88:
  pushl $0
  10227d:	6a 00                	push   $0x0
  pushl $88
  10227f:	6a 58                	push   $0x58
  jmp __alltraps
  102281:	e9 cd fc ff ff       	jmp    101f53 <__alltraps>

00102286 <vector89>:
.globl vector89
vector89:
  pushl $0
  102286:	6a 00                	push   $0x0
  pushl $89
  102288:	6a 59                	push   $0x59
  jmp __alltraps
  10228a:	e9 c4 fc ff ff       	jmp    101f53 <__alltraps>

0010228f <vector90>:
.globl vector90
vector90:
  pushl $0
  10228f:	6a 00                	push   $0x0
  pushl $90
  102291:	6a 5a                	push   $0x5a
  jmp __alltraps
  102293:	e9 bb fc ff ff       	jmp    101f53 <__alltraps>

00102298 <vector91>:
.globl vector91
vector91:
  pushl $0
  102298:	6a 00                	push   $0x0
  pushl $91
  10229a:	6a 5b                	push   $0x5b
  jmp __alltraps
  10229c:	e9 b2 fc ff ff       	jmp    101f53 <__alltraps>

001022a1 <vector92>:
.globl vector92
vector92:
  pushl $0
  1022a1:	6a 00                	push   $0x0
  pushl $92
  1022a3:	6a 5c                	push   $0x5c
  jmp __alltraps
  1022a5:	e9 a9 fc ff ff       	jmp    101f53 <__alltraps>

001022aa <vector93>:
.globl vector93
vector93:
  pushl $0
  1022aa:	6a 00                	push   $0x0
  pushl $93
  1022ac:	6a 5d                	push   $0x5d
  jmp __alltraps
  1022ae:	e9 a0 fc ff ff       	jmp    101f53 <__alltraps>

001022b3 <vector94>:
.globl vector94
vector94:
  pushl $0
  1022b3:	6a 00                	push   $0x0
  pushl $94
  1022b5:	6a 5e                	push   $0x5e
  jmp __alltraps
  1022b7:	e9 97 fc ff ff       	jmp    101f53 <__alltraps>

001022bc <vector95>:
.globl vector95
vector95:
  pushl $0
  1022bc:	6a 00                	push   $0x0
  pushl $95
  1022be:	6a 5f                	push   $0x5f
  jmp __alltraps
  1022c0:	e9 8e fc ff ff       	jmp    101f53 <__alltraps>

001022c5 <vector96>:
.globl vector96
vector96:
  pushl $0
  1022c5:	6a 00                	push   $0x0
  pushl $96
  1022c7:	6a 60                	push   $0x60
  jmp __alltraps
  1022c9:	e9 85 fc ff ff       	jmp    101f53 <__alltraps>

001022ce <vector97>:
.globl vector97
vector97:
  pushl $0
  1022ce:	6a 00                	push   $0x0
  pushl $97
  1022d0:	6a 61                	push   $0x61
  jmp __alltraps
  1022d2:	e9 7c fc ff ff       	jmp    101f53 <__alltraps>

001022d7 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022d7:	6a 00                	push   $0x0
  pushl $98
  1022d9:	6a 62                	push   $0x62
  jmp __alltraps
  1022db:	e9 73 fc ff ff       	jmp    101f53 <__alltraps>

001022e0 <vector99>:
.globl vector99
vector99:
  pushl $0
  1022e0:	6a 00                	push   $0x0
  pushl $99
  1022e2:	6a 63                	push   $0x63
  jmp __alltraps
  1022e4:	e9 6a fc ff ff       	jmp    101f53 <__alltraps>

001022e9 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022e9:	6a 00                	push   $0x0
  pushl $100
  1022eb:	6a 64                	push   $0x64
  jmp __alltraps
  1022ed:	e9 61 fc ff ff       	jmp    101f53 <__alltraps>

001022f2 <vector101>:
.globl vector101
vector101:
  pushl $0
  1022f2:	6a 00                	push   $0x0
  pushl $101
  1022f4:	6a 65                	push   $0x65
  jmp __alltraps
  1022f6:	e9 58 fc ff ff       	jmp    101f53 <__alltraps>

001022fb <vector102>:
.globl vector102
vector102:
  pushl $0
  1022fb:	6a 00                	push   $0x0
  pushl $102
  1022fd:	6a 66                	push   $0x66
  jmp __alltraps
  1022ff:	e9 4f fc ff ff       	jmp    101f53 <__alltraps>

00102304 <vector103>:
.globl vector103
vector103:
  pushl $0
  102304:	6a 00                	push   $0x0
  pushl $103
  102306:	6a 67                	push   $0x67
  jmp __alltraps
  102308:	e9 46 fc ff ff       	jmp    101f53 <__alltraps>

0010230d <vector104>:
.globl vector104
vector104:
  pushl $0
  10230d:	6a 00                	push   $0x0
  pushl $104
  10230f:	6a 68                	push   $0x68
  jmp __alltraps
  102311:	e9 3d fc ff ff       	jmp    101f53 <__alltraps>

00102316 <vector105>:
.globl vector105
vector105:
  pushl $0
  102316:	6a 00                	push   $0x0
  pushl $105
  102318:	6a 69                	push   $0x69
  jmp __alltraps
  10231a:	e9 34 fc ff ff       	jmp    101f53 <__alltraps>

0010231f <vector106>:
.globl vector106
vector106:
  pushl $0
  10231f:	6a 00                	push   $0x0
  pushl $106
  102321:	6a 6a                	push   $0x6a
  jmp __alltraps
  102323:	e9 2b fc ff ff       	jmp    101f53 <__alltraps>

00102328 <vector107>:
.globl vector107
vector107:
  pushl $0
  102328:	6a 00                	push   $0x0
  pushl $107
  10232a:	6a 6b                	push   $0x6b
  jmp __alltraps
  10232c:	e9 22 fc ff ff       	jmp    101f53 <__alltraps>

00102331 <vector108>:
.globl vector108
vector108:
  pushl $0
  102331:	6a 00                	push   $0x0
  pushl $108
  102333:	6a 6c                	push   $0x6c
  jmp __alltraps
  102335:	e9 19 fc ff ff       	jmp    101f53 <__alltraps>

0010233a <vector109>:
.globl vector109
vector109:
  pushl $0
  10233a:	6a 00                	push   $0x0
  pushl $109
  10233c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10233e:	e9 10 fc ff ff       	jmp    101f53 <__alltraps>

00102343 <vector110>:
.globl vector110
vector110:
  pushl $0
  102343:	6a 00                	push   $0x0
  pushl $110
  102345:	6a 6e                	push   $0x6e
  jmp __alltraps
  102347:	e9 07 fc ff ff       	jmp    101f53 <__alltraps>

0010234c <vector111>:
.globl vector111
vector111:
  pushl $0
  10234c:	6a 00                	push   $0x0
  pushl $111
  10234e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102350:	e9 fe fb ff ff       	jmp    101f53 <__alltraps>

00102355 <vector112>:
.globl vector112
vector112:
  pushl $0
  102355:	6a 00                	push   $0x0
  pushl $112
  102357:	6a 70                	push   $0x70
  jmp __alltraps
  102359:	e9 f5 fb ff ff       	jmp    101f53 <__alltraps>

0010235e <vector113>:
.globl vector113
vector113:
  pushl $0
  10235e:	6a 00                	push   $0x0
  pushl $113
  102360:	6a 71                	push   $0x71
  jmp __alltraps
  102362:	e9 ec fb ff ff       	jmp    101f53 <__alltraps>

00102367 <vector114>:
.globl vector114
vector114:
  pushl $0
  102367:	6a 00                	push   $0x0
  pushl $114
  102369:	6a 72                	push   $0x72
  jmp __alltraps
  10236b:	e9 e3 fb ff ff       	jmp    101f53 <__alltraps>

00102370 <vector115>:
.globl vector115
vector115:
  pushl $0
  102370:	6a 00                	push   $0x0
  pushl $115
  102372:	6a 73                	push   $0x73
  jmp __alltraps
  102374:	e9 da fb ff ff       	jmp    101f53 <__alltraps>

00102379 <vector116>:
.globl vector116
vector116:
  pushl $0
  102379:	6a 00                	push   $0x0
  pushl $116
  10237b:	6a 74                	push   $0x74
  jmp __alltraps
  10237d:	e9 d1 fb ff ff       	jmp    101f53 <__alltraps>

00102382 <vector117>:
.globl vector117
vector117:
  pushl $0
  102382:	6a 00                	push   $0x0
  pushl $117
  102384:	6a 75                	push   $0x75
  jmp __alltraps
  102386:	e9 c8 fb ff ff       	jmp    101f53 <__alltraps>

0010238b <vector118>:
.globl vector118
vector118:
  pushl $0
  10238b:	6a 00                	push   $0x0
  pushl $118
  10238d:	6a 76                	push   $0x76
  jmp __alltraps
  10238f:	e9 bf fb ff ff       	jmp    101f53 <__alltraps>

00102394 <vector119>:
.globl vector119
vector119:
  pushl $0
  102394:	6a 00                	push   $0x0
  pushl $119
  102396:	6a 77                	push   $0x77
  jmp __alltraps
  102398:	e9 b6 fb ff ff       	jmp    101f53 <__alltraps>

0010239d <vector120>:
.globl vector120
vector120:
  pushl $0
  10239d:	6a 00                	push   $0x0
  pushl $120
  10239f:	6a 78                	push   $0x78
  jmp __alltraps
  1023a1:	e9 ad fb ff ff       	jmp    101f53 <__alltraps>

001023a6 <vector121>:
.globl vector121
vector121:
  pushl $0
  1023a6:	6a 00                	push   $0x0
  pushl $121
  1023a8:	6a 79                	push   $0x79
  jmp __alltraps
  1023aa:	e9 a4 fb ff ff       	jmp    101f53 <__alltraps>

001023af <vector122>:
.globl vector122
vector122:
  pushl $0
  1023af:	6a 00                	push   $0x0
  pushl $122
  1023b1:	6a 7a                	push   $0x7a
  jmp __alltraps
  1023b3:	e9 9b fb ff ff       	jmp    101f53 <__alltraps>

001023b8 <vector123>:
.globl vector123
vector123:
  pushl $0
  1023b8:	6a 00                	push   $0x0
  pushl $123
  1023ba:	6a 7b                	push   $0x7b
  jmp __alltraps
  1023bc:	e9 92 fb ff ff       	jmp    101f53 <__alltraps>

001023c1 <vector124>:
.globl vector124
vector124:
  pushl $0
  1023c1:	6a 00                	push   $0x0
  pushl $124
  1023c3:	6a 7c                	push   $0x7c
  jmp __alltraps
  1023c5:	e9 89 fb ff ff       	jmp    101f53 <__alltraps>

001023ca <vector125>:
.globl vector125
vector125:
  pushl $0
  1023ca:	6a 00                	push   $0x0
  pushl $125
  1023cc:	6a 7d                	push   $0x7d
  jmp __alltraps
  1023ce:	e9 80 fb ff ff       	jmp    101f53 <__alltraps>

001023d3 <vector126>:
.globl vector126
vector126:
  pushl $0
  1023d3:	6a 00                	push   $0x0
  pushl $126
  1023d5:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023d7:	e9 77 fb ff ff       	jmp    101f53 <__alltraps>

001023dc <vector127>:
.globl vector127
vector127:
  pushl $0
  1023dc:	6a 00                	push   $0x0
  pushl $127
  1023de:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023e0:	e9 6e fb ff ff       	jmp    101f53 <__alltraps>

001023e5 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023e5:	6a 00                	push   $0x0
  pushl $128
  1023e7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023ec:	e9 62 fb ff ff       	jmp    101f53 <__alltraps>

001023f1 <vector129>:
.globl vector129
vector129:
  pushl $0
  1023f1:	6a 00                	push   $0x0
  pushl $129
  1023f3:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023f8:	e9 56 fb ff ff       	jmp    101f53 <__alltraps>

001023fd <vector130>:
.globl vector130
vector130:
  pushl $0
  1023fd:	6a 00                	push   $0x0
  pushl $130
  1023ff:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102404:	e9 4a fb ff ff       	jmp    101f53 <__alltraps>

00102409 <vector131>:
.globl vector131
vector131:
  pushl $0
  102409:	6a 00                	push   $0x0
  pushl $131
  10240b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102410:	e9 3e fb ff ff       	jmp    101f53 <__alltraps>

00102415 <vector132>:
.globl vector132
vector132:
  pushl $0
  102415:	6a 00                	push   $0x0
  pushl $132
  102417:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10241c:	e9 32 fb ff ff       	jmp    101f53 <__alltraps>

00102421 <vector133>:
.globl vector133
vector133:
  pushl $0
  102421:	6a 00                	push   $0x0
  pushl $133
  102423:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102428:	e9 26 fb ff ff       	jmp    101f53 <__alltraps>

0010242d <vector134>:
.globl vector134
vector134:
  pushl $0
  10242d:	6a 00                	push   $0x0
  pushl $134
  10242f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102434:	e9 1a fb ff ff       	jmp    101f53 <__alltraps>

00102439 <vector135>:
.globl vector135
vector135:
  pushl $0
  102439:	6a 00                	push   $0x0
  pushl $135
  10243b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102440:	e9 0e fb ff ff       	jmp    101f53 <__alltraps>

00102445 <vector136>:
.globl vector136
vector136:
  pushl $0
  102445:	6a 00                	push   $0x0
  pushl $136
  102447:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10244c:	e9 02 fb ff ff       	jmp    101f53 <__alltraps>

00102451 <vector137>:
.globl vector137
vector137:
  pushl $0
  102451:	6a 00                	push   $0x0
  pushl $137
  102453:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102458:	e9 f6 fa ff ff       	jmp    101f53 <__alltraps>

0010245d <vector138>:
.globl vector138
vector138:
  pushl $0
  10245d:	6a 00                	push   $0x0
  pushl $138
  10245f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102464:	e9 ea fa ff ff       	jmp    101f53 <__alltraps>

00102469 <vector139>:
.globl vector139
vector139:
  pushl $0
  102469:	6a 00                	push   $0x0
  pushl $139
  10246b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102470:	e9 de fa ff ff       	jmp    101f53 <__alltraps>

00102475 <vector140>:
.globl vector140
vector140:
  pushl $0
  102475:	6a 00                	push   $0x0
  pushl $140
  102477:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10247c:	e9 d2 fa ff ff       	jmp    101f53 <__alltraps>

00102481 <vector141>:
.globl vector141
vector141:
  pushl $0
  102481:	6a 00                	push   $0x0
  pushl $141
  102483:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102488:	e9 c6 fa ff ff       	jmp    101f53 <__alltraps>

0010248d <vector142>:
.globl vector142
vector142:
  pushl $0
  10248d:	6a 00                	push   $0x0
  pushl $142
  10248f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  102494:	e9 ba fa ff ff       	jmp    101f53 <__alltraps>

00102499 <vector143>:
.globl vector143
vector143:
  pushl $0
  102499:	6a 00                	push   $0x0
  pushl $143
  10249b:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1024a0:	e9 ae fa ff ff       	jmp    101f53 <__alltraps>

001024a5 <vector144>:
.globl vector144
vector144:
  pushl $0
  1024a5:	6a 00                	push   $0x0
  pushl $144
  1024a7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1024ac:	e9 a2 fa ff ff       	jmp    101f53 <__alltraps>

001024b1 <vector145>:
.globl vector145
vector145:
  pushl $0
  1024b1:	6a 00                	push   $0x0
  pushl $145
  1024b3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1024b8:	e9 96 fa ff ff       	jmp    101f53 <__alltraps>

001024bd <vector146>:
.globl vector146
vector146:
  pushl $0
  1024bd:	6a 00                	push   $0x0
  pushl $146
  1024bf:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1024c4:	e9 8a fa ff ff       	jmp    101f53 <__alltraps>

001024c9 <vector147>:
.globl vector147
vector147:
  pushl $0
  1024c9:	6a 00                	push   $0x0
  pushl $147
  1024cb:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1024d0:	e9 7e fa ff ff       	jmp    101f53 <__alltraps>

001024d5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024d5:	6a 00                	push   $0x0
  pushl $148
  1024d7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024dc:	e9 72 fa ff ff       	jmp    101f53 <__alltraps>

001024e1 <vector149>:
.globl vector149
vector149:
  pushl $0
  1024e1:	6a 00                	push   $0x0
  pushl $149
  1024e3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024e8:	e9 66 fa ff ff       	jmp    101f53 <__alltraps>

001024ed <vector150>:
.globl vector150
vector150:
  pushl $0
  1024ed:	6a 00                	push   $0x0
  pushl $150
  1024ef:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024f4:	e9 5a fa ff ff       	jmp    101f53 <__alltraps>

001024f9 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024f9:	6a 00                	push   $0x0
  pushl $151
  1024fb:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102500:	e9 4e fa ff ff       	jmp    101f53 <__alltraps>

00102505 <vector152>:
.globl vector152
vector152:
  pushl $0
  102505:	6a 00                	push   $0x0
  pushl $152
  102507:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10250c:	e9 42 fa ff ff       	jmp    101f53 <__alltraps>

00102511 <vector153>:
.globl vector153
vector153:
  pushl $0
  102511:	6a 00                	push   $0x0
  pushl $153
  102513:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102518:	e9 36 fa ff ff       	jmp    101f53 <__alltraps>

0010251d <vector154>:
.globl vector154
vector154:
  pushl $0
  10251d:	6a 00                	push   $0x0
  pushl $154
  10251f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102524:	e9 2a fa ff ff       	jmp    101f53 <__alltraps>

00102529 <vector155>:
.globl vector155
vector155:
  pushl $0
  102529:	6a 00                	push   $0x0
  pushl $155
  10252b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102530:	e9 1e fa ff ff       	jmp    101f53 <__alltraps>

00102535 <vector156>:
.globl vector156
vector156:
  pushl $0
  102535:	6a 00                	push   $0x0
  pushl $156
  102537:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10253c:	e9 12 fa ff ff       	jmp    101f53 <__alltraps>

00102541 <vector157>:
.globl vector157
vector157:
  pushl $0
  102541:	6a 00                	push   $0x0
  pushl $157
  102543:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102548:	e9 06 fa ff ff       	jmp    101f53 <__alltraps>

0010254d <vector158>:
.globl vector158
vector158:
  pushl $0
  10254d:	6a 00                	push   $0x0
  pushl $158
  10254f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102554:	e9 fa f9 ff ff       	jmp    101f53 <__alltraps>

00102559 <vector159>:
.globl vector159
vector159:
  pushl $0
  102559:	6a 00                	push   $0x0
  pushl $159
  10255b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102560:	e9 ee f9 ff ff       	jmp    101f53 <__alltraps>

00102565 <vector160>:
.globl vector160
vector160:
  pushl $0
  102565:	6a 00                	push   $0x0
  pushl $160
  102567:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10256c:	e9 e2 f9 ff ff       	jmp    101f53 <__alltraps>

00102571 <vector161>:
.globl vector161
vector161:
  pushl $0
  102571:	6a 00                	push   $0x0
  pushl $161
  102573:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102578:	e9 d6 f9 ff ff       	jmp    101f53 <__alltraps>

0010257d <vector162>:
.globl vector162
vector162:
  pushl $0
  10257d:	6a 00                	push   $0x0
  pushl $162
  10257f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102584:	e9 ca f9 ff ff       	jmp    101f53 <__alltraps>

00102589 <vector163>:
.globl vector163
vector163:
  pushl $0
  102589:	6a 00                	push   $0x0
  pushl $163
  10258b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  102590:	e9 be f9 ff ff       	jmp    101f53 <__alltraps>

00102595 <vector164>:
.globl vector164
vector164:
  pushl $0
  102595:	6a 00                	push   $0x0
  pushl $164
  102597:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  10259c:	e9 b2 f9 ff ff       	jmp    101f53 <__alltraps>

001025a1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1025a1:	6a 00                	push   $0x0
  pushl $165
  1025a3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1025a8:	e9 a6 f9 ff ff       	jmp    101f53 <__alltraps>

001025ad <vector166>:
.globl vector166
vector166:
  pushl $0
  1025ad:	6a 00                	push   $0x0
  pushl $166
  1025af:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1025b4:	e9 9a f9 ff ff       	jmp    101f53 <__alltraps>

001025b9 <vector167>:
.globl vector167
vector167:
  pushl $0
  1025b9:	6a 00                	push   $0x0
  pushl $167
  1025bb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1025c0:	e9 8e f9 ff ff       	jmp    101f53 <__alltraps>

001025c5 <vector168>:
.globl vector168
vector168:
  pushl $0
  1025c5:	6a 00                	push   $0x0
  pushl $168
  1025c7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1025cc:	e9 82 f9 ff ff       	jmp    101f53 <__alltraps>

001025d1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1025d1:	6a 00                	push   $0x0
  pushl $169
  1025d3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025d8:	e9 76 f9 ff ff       	jmp    101f53 <__alltraps>

001025dd <vector170>:
.globl vector170
vector170:
  pushl $0
  1025dd:	6a 00                	push   $0x0
  pushl $170
  1025df:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025e4:	e9 6a f9 ff ff       	jmp    101f53 <__alltraps>

001025e9 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025e9:	6a 00                	push   $0x0
  pushl $171
  1025eb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025f0:	e9 5e f9 ff ff       	jmp    101f53 <__alltraps>

001025f5 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025f5:	6a 00                	push   $0x0
  pushl $172
  1025f7:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025fc:	e9 52 f9 ff ff       	jmp    101f53 <__alltraps>

00102601 <vector173>:
.globl vector173
vector173:
  pushl $0
  102601:	6a 00                	push   $0x0
  pushl $173
  102603:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102608:	e9 46 f9 ff ff       	jmp    101f53 <__alltraps>

0010260d <vector174>:
.globl vector174
vector174:
  pushl $0
  10260d:	6a 00                	push   $0x0
  pushl $174
  10260f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102614:	e9 3a f9 ff ff       	jmp    101f53 <__alltraps>

00102619 <vector175>:
.globl vector175
vector175:
  pushl $0
  102619:	6a 00                	push   $0x0
  pushl $175
  10261b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102620:	e9 2e f9 ff ff       	jmp    101f53 <__alltraps>

00102625 <vector176>:
.globl vector176
vector176:
  pushl $0
  102625:	6a 00                	push   $0x0
  pushl $176
  102627:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10262c:	e9 22 f9 ff ff       	jmp    101f53 <__alltraps>

00102631 <vector177>:
.globl vector177
vector177:
  pushl $0
  102631:	6a 00                	push   $0x0
  pushl $177
  102633:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102638:	e9 16 f9 ff ff       	jmp    101f53 <__alltraps>

0010263d <vector178>:
.globl vector178
vector178:
  pushl $0
  10263d:	6a 00                	push   $0x0
  pushl $178
  10263f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102644:	e9 0a f9 ff ff       	jmp    101f53 <__alltraps>

00102649 <vector179>:
.globl vector179
vector179:
  pushl $0
  102649:	6a 00                	push   $0x0
  pushl $179
  10264b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102650:	e9 fe f8 ff ff       	jmp    101f53 <__alltraps>

00102655 <vector180>:
.globl vector180
vector180:
  pushl $0
  102655:	6a 00                	push   $0x0
  pushl $180
  102657:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10265c:	e9 f2 f8 ff ff       	jmp    101f53 <__alltraps>

00102661 <vector181>:
.globl vector181
vector181:
  pushl $0
  102661:	6a 00                	push   $0x0
  pushl $181
  102663:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102668:	e9 e6 f8 ff ff       	jmp    101f53 <__alltraps>

0010266d <vector182>:
.globl vector182
vector182:
  pushl $0
  10266d:	6a 00                	push   $0x0
  pushl $182
  10266f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102674:	e9 da f8 ff ff       	jmp    101f53 <__alltraps>

00102679 <vector183>:
.globl vector183
vector183:
  pushl $0
  102679:	6a 00                	push   $0x0
  pushl $183
  10267b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102680:	e9 ce f8 ff ff       	jmp    101f53 <__alltraps>

00102685 <vector184>:
.globl vector184
vector184:
  pushl $0
  102685:	6a 00                	push   $0x0
  pushl $184
  102687:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10268c:	e9 c2 f8 ff ff       	jmp    101f53 <__alltraps>

00102691 <vector185>:
.globl vector185
vector185:
  pushl $0
  102691:	6a 00                	push   $0x0
  pushl $185
  102693:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102698:	e9 b6 f8 ff ff       	jmp    101f53 <__alltraps>

0010269d <vector186>:
.globl vector186
vector186:
  pushl $0
  10269d:	6a 00                	push   $0x0
  pushl $186
  10269f:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1026a4:	e9 aa f8 ff ff       	jmp    101f53 <__alltraps>

001026a9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1026a9:	6a 00                	push   $0x0
  pushl $187
  1026ab:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1026b0:	e9 9e f8 ff ff       	jmp    101f53 <__alltraps>

001026b5 <vector188>:
.globl vector188
vector188:
  pushl $0
  1026b5:	6a 00                	push   $0x0
  pushl $188
  1026b7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1026bc:	e9 92 f8 ff ff       	jmp    101f53 <__alltraps>

001026c1 <vector189>:
.globl vector189
vector189:
  pushl $0
  1026c1:	6a 00                	push   $0x0
  pushl $189
  1026c3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1026c8:	e9 86 f8 ff ff       	jmp    101f53 <__alltraps>

001026cd <vector190>:
.globl vector190
vector190:
  pushl $0
  1026cd:	6a 00                	push   $0x0
  pushl $190
  1026cf:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1026d4:	e9 7a f8 ff ff       	jmp    101f53 <__alltraps>

001026d9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026d9:	6a 00                	push   $0x0
  pushl $191
  1026db:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026e0:	e9 6e f8 ff ff       	jmp    101f53 <__alltraps>

001026e5 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026e5:	6a 00                	push   $0x0
  pushl $192
  1026e7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026ec:	e9 62 f8 ff ff       	jmp    101f53 <__alltraps>

001026f1 <vector193>:
.globl vector193
vector193:
  pushl $0
  1026f1:	6a 00                	push   $0x0
  pushl $193
  1026f3:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026f8:	e9 56 f8 ff ff       	jmp    101f53 <__alltraps>

001026fd <vector194>:
.globl vector194
vector194:
  pushl $0
  1026fd:	6a 00                	push   $0x0
  pushl $194
  1026ff:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102704:	e9 4a f8 ff ff       	jmp    101f53 <__alltraps>

00102709 <vector195>:
.globl vector195
vector195:
  pushl $0
  102709:	6a 00                	push   $0x0
  pushl $195
  10270b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102710:	e9 3e f8 ff ff       	jmp    101f53 <__alltraps>

00102715 <vector196>:
.globl vector196
vector196:
  pushl $0
  102715:	6a 00                	push   $0x0
  pushl $196
  102717:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10271c:	e9 32 f8 ff ff       	jmp    101f53 <__alltraps>

00102721 <vector197>:
.globl vector197
vector197:
  pushl $0
  102721:	6a 00                	push   $0x0
  pushl $197
  102723:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102728:	e9 26 f8 ff ff       	jmp    101f53 <__alltraps>

0010272d <vector198>:
.globl vector198
vector198:
  pushl $0
  10272d:	6a 00                	push   $0x0
  pushl $198
  10272f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102734:	e9 1a f8 ff ff       	jmp    101f53 <__alltraps>

00102739 <vector199>:
.globl vector199
vector199:
  pushl $0
  102739:	6a 00                	push   $0x0
  pushl $199
  10273b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102740:	e9 0e f8 ff ff       	jmp    101f53 <__alltraps>

00102745 <vector200>:
.globl vector200
vector200:
  pushl $0
  102745:	6a 00                	push   $0x0
  pushl $200
  102747:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10274c:	e9 02 f8 ff ff       	jmp    101f53 <__alltraps>

00102751 <vector201>:
.globl vector201
vector201:
  pushl $0
  102751:	6a 00                	push   $0x0
  pushl $201
  102753:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102758:	e9 f6 f7 ff ff       	jmp    101f53 <__alltraps>

0010275d <vector202>:
.globl vector202
vector202:
  pushl $0
  10275d:	6a 00                	push   $0x0
  pushl $202
  10275f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102764:	e9 ea f7 ff ff       	jmp    101f53 <__alltraps>

00102769 <vector203>:
.globl vector203
vector203:
  pushl $0
  102769:	6a 00                	push   $0x0
  pushl $203
  10276b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102770:	e9 de f7 ff ff       	jmp    101f53 <__alltraps>

00102775 <vector204>:
.globl vector204
vector204:
  pushl $0
  102775:	6a 00                	push   $0x0
  pushl $204
  102777:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10277c:	e9 d2 f7 ff ff       	jmp    101f53 <__alltraps>

00102781 <vector205>:
.globl vector205
vector205:
  pushl $0
  102781:	6a 00                	push   $0x0
  pushl $205
  102783:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102788:	e9 c6 f7 ff ff       	jmp    101f53 <__alltraps>

0010278d <vector206>:
.globl vector206
vector206:
  pushl $0
  10278d:	6a 00                	push   $0x0
  pushl $206
  10278f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  102794:	e9 ba f7 ff ff       	jmp    101f53 <__alltraps>

00102799 <vector207>:
.globl vector207
vector207:
  pushl $0
  102799:	6a 00                	push   $0x0
  pushl $207
  10279b:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1027a0:	e9 ae f7 ff ff       	jmp    101f53 <__alltraps>

001027a5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1027a5:	6a 00                	push   $0x0
  pushl $208
  1027a7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1027ac:	e9 a2 f7 ff ff       	jmp    101f53 <__alltraps>

001027b1 <vector209>:
.globl vector209
vector209:
  pushl $0
  1027b1:	6a 00                	push   $0x0
  pushl $209
  1027b3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1027b8:	e9 96 f7 ff ff       	jmp    101f53 <__alltraps>

001027bd <vector210>:
.globl vector210
vector210:
  pushl $0
  1027bd:	6a 00                	push   $0x0
  pushl $210
  1027bf:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1027c4:	e9 8a f7 ff ff       	jmp    101f53 <__alltraps>

001027c9 <vector211>:
.globl vector211
vector211:
  pushl $0
  1027c9:	6a 00                	push   $0x0
  pushl $211
  1027cb:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1027d0:	e9 7e f7 ff ff       	jmp    101f53 <__alltraps>

001027d5 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027d5:	6a 00                	push   $0x0
  pushl $212
  1027d7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027dc:	e9 72 f7 ff ff       	jmp    101f53 <__alltraps>

001027e1 <vector213>:
.globl vector213
vector213:
  pushl $0
  1027e1:	6a 00                	push   $0x0
  pushl $213
  1027e3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027e8:	e9 66 f7 ff ff       	jmp    101f53 <__alltraps>

001027ed <vector214>:
.globl vector214
vector214:
  pushl $0
  1027ed:	6a 00                	push   $0x0
  pushl $214
  1027ef:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027f4:	e9 5a f7 ff ff       	jmp    101f53 <__alltraps>

001027f9 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027f9:	6a 00                	push   $0x0
  pushl $215
  1027fb:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102800:	e9 4e f7 ff ff       	jmp    101f53 <__alltraps>

00102805 <vector216>:
.globl vector216
vector216:
  pushl $0
  102805:	6a 00                	push   $0x0
  pushl $216
  102807:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10280c:	e9 42 f7 ff ff       	jmp    101f53 <__alltraps>

00102811 <vector217>:
.globl vector217
vector217:
  pushl $0
  102811:	6a 00                	push   $0x0
  pushl $217
  102813:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102818:	e9 36 f7 ff ff       	jmp    101f53 <__alltraps>

0010281d <vector218>:
.globl vector218
vector218:
  pushl $0
  10281d:	6a 00                	push   $0x0
  pushl $218
  10281f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102824:	e9 2a f7 ff ff       	jmp    101f53 <__alltraps>

00102829 <vector219>:
.globl vector219
vector219:
  pushl $0
  102829:	6a 00                	push   $0x0
  pushl $219
  10282b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102830:	e9 1e f7 ff ff       	jmp    101f53 <__alltraps>

00102835 <vector220>:
.globl vector220
vector220:
  pushl $0
  102835:	6a 00                	push   $0x0
  pushl $220
  102837:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10283c:	e9 12 f7 ff ff       	jmp    101f53 <__alltraps>

00102841 <vector221>:
.globl vector221
vector221:
  pushl $0
  102841:	6a 00                	push   $0x0
  pushl $221
  102843:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102848:	e9 06 f7 ff ff       	jmp    101f53 <__alltraps>

0010284d <vector222>:
.globl vector222
vector222:
  pushl $0
  10284d:	6a 00                	push   $0x0
  pushl $222
  10284f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102854:	e9 fa f6 ff ff       	jmp    101f53 <__alltraps>

00102859 <vector223>:
.globl vector223
vector223:
  pushl $0
  102859:	6a 00                	push   $0x0
  pushl $223
  10285b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102860:	e9 ee f6 ff ff       	jmp    101f53 <__alltraps>

00102865 <vector224>:
.globl vector224
vector224:
  pushl $0
  102865:	6a 00                	push   $0x0
  pushl $224
  102867:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10286c:	e9 e2 f6 ff ff       	jmp    101f53 <__alltraps>

00102871 <vector225>:
.globl vector225
vector225:
  pushl $0
  102871:	6a 00                	push   $0x0
  pushl $225
  102873:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102878:	e9 d6 f6 ff ff       	jmp    101f53 <__alltraps>

0010287d <vector226>:
.globl vector226
vector226:
  pushl $0
  10287d:	6a 00                	push   $0x0
  pushl $226
  10287f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102884:	e9 ca f6 ff ff       	jmp    101f53 <__alltraps>

00102889 <vector227>:
.globl vector227
vector227:
  pushl $0
  102889:	6a 00                	push   $0x0
  pushl $227
  10288b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  102890:	e9 be f6 ff ff       	jmp    101f53 <__alltraps>

00102895 <vector228>:
.globl vector228
vector228:
  pushl $0
  102895:	6a 00                	push   $0x0
  pushl $228
  102897:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  10289c:	e9 b2 f6 ff ff       	jmp    101f53 <__alltraps>

001028a1 <vector229>:
.globl vector229
vector229:
  pushl $0
  1028a1:	6a 00                	push   $0x0
  pushl $229
  1028a3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1028a8:	e9 a6 f6 ff ff       	jmp    101f53 <__alltraps>

001028ad <vector230>:
.globl vector230
vector230:
  pushl $0
  1028ad:	6a 00                	push   $0x0
  pushl $230
  1028af:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1028b4:	e9 9a f6 ff ff       	jmp    101f53 <__alltraps>

001028b9 <vector231>:
.globl vector231
vector231:
  pushl $0
  1028b9:	6a 00                	push   $0x0
  pushl $231
  1028bb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1028c0:	e9 8e f6 ff ff       	jmp    101f53 <__alltraps>

001028c5 <vector232>:
.globl vector232
vector232:
  pushl $0
  1028c5:	6a 00                	push   $0x0
  pushl $232
  1028c7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1028cc:	e9 82 f6 ff ff       	jmp    101f53 <__alltraps>

001028d1 <vector233>:
.globl vector233
vector233:
  pushl $0
  1028d1:	6a 00                	push   $0x0
  pushl $233
  1028d3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028d8:	e9 76 f6 ff ff       	jmp    101f53 <__alltraps>

001028dd <vector234>:
.globl vector234
vector234:
  pushl $0
  1028dd:	6a 00                	push   $0x0
  pushl $234
  1028df:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028e4:	e9 6a f6 ff ff       	jmp    101f53 <__alltraps>

001028e9 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028e9:	6a 00                	push   $0x0
  pushl $235
  1028eb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028f0:	e9 5e f6 ff ff       	jmp    101f53 <__alltraps>

001028f5 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028f5:	6a 00                	push   $0x0
  pushl $236
  1028f7:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028fc:	e9 52 f6 ff ff       	jmp    101f53 <__alltraps>

00102901 <vector237>:
.globl vector237
vector237:
  pushl $0
  102901:	6a 00                	push   $0x0
  pushl $237
  102903:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102908:	e9 46 f6 ff ff       	jmp    101f53 <__alltraps>

0010290d <vector238>:
.globl vector238
vector238:
  pushl $0
  10290d:	6a 00                	push   $0x0
  pushl $238
  10290f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102914:	e9 3a f6 ff ff       	jmp    101f53 <__alltraps>

00102919 <vector239>:
.globl vector239
vector239:
  pushl $0
  102919:	6a 00                	push   $0x0
  pushl $239
  10291b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102920:	e9 2e f6 ff ff       	jmp    101f53 <__alltraps>

00102925 <vector240>:
.globl vector240
vector240:
  pushl $0
  102925:	6a 00                	push   $0x0
  pushl $240
  102927:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10292c:	e9 22 f6 ff ff       	jmp    101f53 <__alltraps>

00102931 <vector241>:
.globl vector241
vector241:
  pushl $0
  102931:	6a 00                	push   $0x0
  pushl $241
  102933:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102938:	e9 16 f6 ff ff       	jmp    101f53 <__alltraps>

0010293d <vector242>:
.globl vector242
vector242:
  pushl $0
  10293d:	6a 00                	push   $0x0
  pushl $242
  10293f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102944:	e9 0a f6 ff ff       	jmp    101f53 <__alltraps>

00102949 <vector243>:
.globl vector243
vector243:
  pushl $0
  102949:	6a 00                	push   $0x0
  pushl $243
  10294b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102950:	e9 fe f5 ff ff       	jmp    101f53 <__alltraps>

00102955 <vector244>:
.globl vector244
vector244:
  pushl $0
  102955:	6a 00                	push   $0x0
  pushl $244
  102957:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10295c:	e9 f2 f5 ff ff       	jmp    101f53 <__alltraps>

00102961 <vector245>:
.globl vector245
vector245:
  pushl $0
  102961:	6a 00                	push   $0x0
  pushl $245
  102963:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102968:	e9 e6 f5 ff ff       	jmp    101f53 <__alltraps>

0010296d <vector246>:
.globl vector246
vector246:
  pushl $0
  10296d:	6a 00                	push   $0x0
  pushl $246
  10296f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102974:	e9 da f5 ff ff       	jmp    101f53 <__alltraps>

00102979 <vector247>:
.globl vector247
vector247:
  pushl $0
  102979:	6a 00                	push   $0x0
  pushl $247
  10297b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102980:	e9 ce f5 ff ff       	jmp    101f53 <__alltraps>

00102985 <vector248>:
.globl vector248
vector248:
  pushl $0
  102985:	6a 00                	push   $0x0
  pushl $248
  102987:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10298c:	e9 c2 f5 ff ff       	jmp    101f53 <__alltraps>

00102991 <vector249>:
.globl vector249
vector249:
  pushl $0
  102991:	6a 00                	push   $0x0
  pushl $249
  102993:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102998:	e9 b6 f5 ff ff       	jmp    101f53 <__alltraps>

0010299d <vector250>:
.globl vector250
vector250:
  pushl $0
  10299d:	6a 00                	push   $0x0
  pushl $250
  10299f:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1029a4:	e9 aa f5 ff ff       	jmp    101f53 <__alltraps>

001029a9 <vector251>:
.globl vector251
vector251:
  pushl $0
  1029a9:	6a 00                	push   $0x0
  pushl $251
  1029ab:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1029b0:	e9 9e f5 ff ff       	jmp    101f53 <__alltraps>

001029b5 <vector252>:
.globl vector252
vector252:
  pushl $0
  1029b5:	6a 00                	push   $0x0
  pushl $252
  1029b7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1029bc:	e9 92 f5 ff ff       	jmp    101f53 <__alltraps>

001029c1 <vector253>:
.globl vector253
vector253:
  pushl $0
  1029c1:	6a 00                	push   $0x0
  pushl $253
  1029c3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1029c8:	e9 86 f5 ff ff       	jmp    101f53 <__alltraps>

001029cd <vector254>:
.globl vector254
vector254:
  pushl $0
  1029cd:	6a 00                	push   $0x0
  pushl $254
  1029cf:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1029d4:	e9 7a f5 ff ff       	jmp    101f53 <__alltraps>

001029d9 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029d9:	6a 00                	push   $0x0
  pushl $255
  1029db:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029e0:	e9 6e f5 ff ff       	jmp    101f53 <__alltraps>

001029e5 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029e5:	55                   	push   %ebp
  1029e6:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1029eb:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029ee:	b8 23 00 00 00       	mov    $0x23,%eax
  1029f3:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029f5:	b8 23 00 00 00       	mov    $0x23,%eax
  1029fa:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029fc:	b8 10 00 00 00       	mov    $0x10,%eax
  102a01:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102a03:	b8 10 00 00 00       	mov    $0x10,%eax
  102a08:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  102a0a:	b8 10 00 00 00       	mov    $0x10,%eax
  102a0f:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102a11:	ea 18 2a 10 00 08 00 	ljmp   $0x8,$0x102a18
}
  102a18:	5d                   	pop    %ebp
  102a19:	c3                   	ret    

00102a1a <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a1a:	55                   	push   %ebp
  102a1b:	89 e5                	mov    %esp,%ebp
  102a1d:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a20:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102a25:	05 00 04 00 00       	add    $0x400,%eax
  102a2a:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102a2f:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102a36:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a38:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102a3f:	68 00 
  102a41:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a46:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102a4c:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102a51:	c1 e8 10             	shr    $0x10,%eax
  102a54:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102a59:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a60:	83 e0 f0             	and    $0xfffffff0,%eax
  102a63:	83 c8 09             	or     $0x9,%eax
  102a66:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a6b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a72:	83 c8 10             	or     $0x10,%eax
  102a75:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a7a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a81:	83 e0 9f             	and    $0xffffff9f,%eax
  102a84:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a89:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a90:	83 c8 80             	or     $0xffffff80,%eax
  102a93:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a98:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a9f:	83 e0 f0             	and    $0xfffffff0,%eax
  102aa2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102aa7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102aae:	83 e0 ef             	and    $0xffffffef,%eax
  102ab1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ab6:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102abd:	83 e0 df             	and    $0xffffffdf,%eax
  102ac0:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ac5:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102acc:	83 c8 40             	or     $0x40,%eax
  102acf:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ad4:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102adb:	83 e0 7f             	and    $0x7f,%eax
  102ade:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102ae3:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102ae8:	c1 e8 18             	shr    $0x18,%eax
  102aeb:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102af0:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102af7:	83 e0 ef             	and    $0xffffffef,%eax
  102afa:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102aff:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102b06:	e8 da fe ff ff       	call   1029e5 <lgdt>
  102b0b:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102b11:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102b15:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102b18:	c9                   	leave  
  102b19:	c3                   	ret    

00102b1a <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b1a:	55                   	push   %ebp
  102b1b:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b1d:	e8 f8 fe ff ff       	call   102a1a <gdt_init>
}
  102b22:	5d                   	pop    %ebp
  102b23:	c3                   	ret    

00102b24 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102b24:	55                   	push   %ebp
  102b25:	89 e5                	mov    %esp,%ebp
  102b27:	83 ec 58             	sub    $0x58,%esp
  102b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  102b2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102b30:	8b 45 14             	mov    0x14(%ebp),%eax
  102b33:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102b36:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102b39:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102b3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b3f:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102b42:	8b 45 18             	mov    0x18(%ebp),%eax
  102b45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102b4b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102b4e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b51:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102b54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b57:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102b5e:	74 1c                	je     102b7c <printnum+0x58>
  102b60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b63:	ba 00 00 00 00       	mov    $0x0,%edx
  102b68:	f7 75 e4             	divl   -0x1c(%ebp)
  102b6b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102b6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b71:	ba 00 00 00 00       	mov    $0x0,%edx
  102b76:	f7 75 e4             	divl   -0x1c(%ebp)
  102b79:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102b7c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102b82:	f7 75 e4             	divl   -0x1c(%ebp)
  102b85:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102b88:	89 55 dc             	mov    %edx,-0x24(%ebp)
  102b8b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102b8e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b91:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102b94:	89 55 ec             	mov    %edx,-0x14(%ebp)
  102b97:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b9a:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  102b9d:	8b 45 18             	mov    0x18(%ebp),%eax
  102ba0:	ba 00 00 00 00       	mov    $0x0,%edx
  102ba5:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102ba8:	77 56                	ja     102c00 <printnum+0xdc>
  102baa:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  102bad:	72 05                	jb     102bb4 <printnum+0x90>
  102baf:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  102bb2:	77 4c                	ja     102c00 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  102bb4:	8b 45 1c             	mov    0x1c(%ebp),%eax
  102bb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  102bba:	8b 45 20             	mov    0x20(%ebp),%eax
  102bbd:	89 44 24 18          	mov    %eax,0x18(%esp)
  102bc1:	89 54 24 14          	mov    %edx,0x14(%esp)
  102bc5:	8b 45 18             	mov    0x18(%ebp),%eax
  102bc8:	89 44 24 10          	mov    %eax,0x10(%esp)
  102bcc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102bcf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102bd2:	89 44 24 08          	mov    %eax,0x8(%esp)
  102bd6:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  102be1:	8b 45 08             	mov    0x8(%ebp),%eax
  102be4:	89 04 24             	mov    %eax,(%esp)
  102be7:	e8 38 ff ff ff       	call   102b24 <printnum>
  102bec:	eb 1c                	jmp    102c0a <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102bee:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bf1:	89 44 24 04          	mov    %eax,0x4(%esp)
  102bf5:	8b 45 20             	mov    0x20(%ebp),%eax
  102bf8:	89 04 24             	mov    %eax,(%esp)
  102bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  102bfe:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102c00:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102c04:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102c08:	7f e4                	jg     102bee <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102c0a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102c0d:	05 f0 3d 10 00       	add    $0x103df0,%eax
  102c12:	0f b6 00             	movzbl (%eax),%eax
  102c15:	0f be c0             	movsbl %al,%eax
  102c18:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c1b:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c1f:	89 04 24             	mov    %eax,(%esp)
  102c22:	8b 45 08             	mov    0x8(%ebp),%eax
  102c25:	ff d0                	call   *%eax
}
  102c27:	c9                   	leave  
  102c28:	c3                   	ret    

00102c29 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102c29:	55                   	push   %ebp
  102c2a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c2c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c30:	7e 14                	jle    102c46 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102c32:	8b 45 08             	mov    0x8(%ebp),%eax
  102c35:	8b 00                	mov    (%eax),%eax
  102c37:	8d 48 08             	lea    0x8(%eax),%ecx
  102c3a:	8b 55 08             	mov    0x8(%ebp),%edx
  102c3d:	89 0a                	mov    %ecx,(%edx)
  102c3f:	8b 50 04             	mov    0x4(%eax),%edx
  102c42:	8b 00                	mov    (%eax),%eax
  102c44:	eb 30                	jmp    102c76 <getuint+0x4d>
    }
    else if (lflag) {
  102c46:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c4a:	74 16                	je     102c62 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  102c4f:	8b 00                	mov    (%eax),%eax
  102c51:	8d 48 04             	lea    0x4(%eax),%ecx
  102c54:	8b 55 08             	mov    0x8(%ebp),%edx
  102c57:	89 0a                	mov    %ecx,(%edx)
  102c59:	8b 00                	mov    (%eax),%eax
  102c5b:	ba 00 00 00 00       	mov    $0x0,%edx
  102c60:	eb 14                	jmp    102c76 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102c62:	8b 45 08             	mov    0x8(%ebp),%eax
  102c65:	8b 00                	mov    (%eax),%eax
  102c67:	8d 48 04             	lea    0x4(%eax),%ecx
  102c6a:	8b 55 08             	mov    0x8(%ebp),%edx
  102c6d:	89 0a                	mov    %ecx,(%edx)
  102c6f:	8b 00                	mov    (%eax),%eax
  102c71:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102c76:	5d                   	pop    %ebp
  102c77:	c3                   	ret    

00102c78 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102c78:	55                   	push   %ebp
  102c79:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102c7b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102c7f:	7e 14                	jle    102c95 <getint+0x1d>
        return va_arg(*ap, long long);
  102c81:	8b 45 08             	mov    0x8(%ebp),%eax
  102c84:	8b 00                	mov    (%eax),%eax
  102c86:	8d 48 08             	lea    0x8(%eax),%ecx
  102c89:	8b 55 08             	mov    0x8(%ebp),%edx
  102c8c:	89 0a                	mov    %ecx,(%edx)
  102c8e:	8b 50 04             	mov    0x4(%eax),%edx
  102c91:	8b 00                	mov    (%eax),%eax
  102c93:	eb 28                	jmp    102cbd <getint+0x45>
    }
    else if (lflag) {
  102c95:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102c99:	74 12                	je     102cad <getint+0x35>
        return va_arg(*ap, long);
  102c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9e:	8b 00                	mov    (%eax),%eax
  102ca0:	8d 48 04             	lea    0x4(%eax),%ecx
  102ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  102ca6:	89 0a                	mov    %ecx,(%edx)
  102ca8:	8b 00                	mov    (%eax),%eax
  102caa:	99                   	cltd   
  102cab:	eb 10                	jmp    102cbd <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102cad:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb0:	8b 00                	mov    (%eax),%eax
  102cb2:	8d 48 04             	lea    0x4(%eax),%ecx
  102cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  102cb8:	89 0a                	mov    %ecx,(%edx)
  102cba:	8b 00                	mov    (%eax),%eax
  102cbc:	99                   	cltd   
    }
}
  102cbd:	5d                   	pop    %ebp
  102cbe:	c3                   	ret    

00102cbf <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102cbf:	55                   	push   %ebp
  102cc0:	89 e5                	mov    %esp,%ebp
  102cc2:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102cc5:	8d 45 14             	lea    0x14(%ebp),%eax
  102cc8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cce:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cd2:	8b 45 10             	mov    0x10(%ebp),%eax
  102cd5:	89 44 24 08          	mov    %eax,0x8(%esp)
  102cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ce0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ce3:	89 04 24             	mov    %eax,(%esp)
  102ce6:	e8 02 00 00 00       	call   102ced <vprintfmt>
    va_end(ap);
}
  102ceb:	c9                   	leave  
  102cec:	c3                   	ret    

00102ced <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102ced:	55                   	push   %ebp
  102cee:	89 e5                	mov    %esp,%ebp
  102cf0:	56                   	push   %esi
  102cf1:	53                   	push   %ebx
  102cf2:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102cf5:	eb 18                	jmp    102d0f <vprintfmt+0x22>
            if (ch == '\0') {
  102cf7:	85 db                	test   %ebx,%ebx
  102cf9:	75 05                	jne    102d00 <vprintfmt+0x13>
                return;
  102cfb:	e9 d1 03 00 00       	jmp    1030d1 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d03:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d07:	89 1c 24             	mov    %ebx,(%esp)
  102d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d0d:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102d0f:	8b 45 10             	mov    0x10(%ebp),%eax
  102d12:	8d 50 01             	lea    0x1(%eax),%edx
  102d15:	89 55 10             	mov    %edx,0x10(%ebp)
  102d18:	0f b6 00             	movzbl (%eax),%eax
  102d1b:	0f b6 d8             	movzbl %al,%ebx
  102d1e:	83 fb 25             	cmp    $0x25,%ebx
  102d21:	75 d4                	jne    102cf7 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102d23:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102d27:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102d2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d31:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102d34:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102d3b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102d3e:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102d41:	8b 45 10             	mov    0x10(%ebp),%eax
  102d44:	8d 50 01             	lea    0x1(%eax),%edx
  102d47:	89 55 10             	mov    %edx,0x10(%ebp)
  102d4a:	0f b6 00             	movzbl (%eax),%eax
  102d4d:	0f b6 d8             	movzbl %al,%ebx
  102d50:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102d53:	83 f8 55             	cmp    $0x55,%eax
  102d56:	0f 87 44 03 00 00    	ja     1030a0 <vprintfmt+0x3b3>
  102d5c:	8b 04 85 14 3e 10 00 	mov    0x103e14(,%eax,4),%eax
  102d63:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102d65:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102d69:	eb d6                	jmp    102d41 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102d6b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102d6f:	eb d0                	jmp    102d41 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d71:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102d78:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d7b:	89 d0                	mov    %edx,%eax
  102d7d:	c1 e0 02             	shl    $0x2,%eax
  102d80:	01 d0                	add    %edx,%eax
  102d82:	01 c0                	add    %eax,%eax
  102d84:	01 d8                	add    %ebx,%eax
  102d86:	83 e8 30             	sub    $0x30,%eax
  102d89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102d8c:	8b 45 10             	mov    0x10(%ebp),%eax
  102d8f:	0f b6 00             	movzbl (%eax),%eax
  102d92:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102d95:	83 fb 2f             	cmp    $0x2f,%ebx
  102d98:	7e 0b                	jle    102da5 <vprintfmt+0xb8>
  102d9a:	83 fb 39             	cmp    $0x39,%ebx
  102d9d:	7f 06                	jg     102da5 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102d9f:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102da3:	eb d3                	jmp    102d78 <vprintfmt+0x8b>
            goto process_precision;
  102da5:	eb 33                	jmp    102dda <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102da7:	8b 45 14             	mov    0x14(%ebp),%eax
  102daa:	8d 50 04             	lea    0x4(%eax),%edx
  102dad:	89 55 14             	mov    %edx,0x14(%ebp)
  102db0:	8b 00                	mov    (%eax),%eax
  102db2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102db5:	eb 23                	jmp    102dda <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102db7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dbb:	79 0c                	jns    102dc9 <vprintfmt+0xdc>
                width = 0;
  102dbd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102dc4:	e9 78 ff ff ff       	jmp    102d41 <vprintfmt+0x54>
  102dc9:	e9 73 ff ff ff       	jmp    102d41 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102dce:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102dd5:	e9 67 ff ff ff       	jmp    102d41 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102dda:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102dde:	79 12                	jns    102df2 <vprintfmt+0x105>
                width = precision, precision = -1;
  102de0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102de3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102de6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102ded:	e9 4f ff ff ff       	jmp    102d41 <vprintfmt+0x54>
  102df2:	e9 4a ff ff ff       	jmp    102d41 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102df7:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102dfb:	e9 41 ff ff ff       	jmp    102d41 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102e00:	8b 45 14             	mov    0x14(%ebp),%eax
  102e03:	8d 50 04             	lea    0x4(%eax),%edx
  102e06:	89 55 14             	mov    %edx,0x14(%ebp)
  102e09:	8b 00                	mov    (%eax),%eax
  102e0b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e0e:	89 54 24 04          	mov    %edx,0x4(%esp)
  102e12:	89 04 24             	mov    %eax,(%esp)
  102e15:	8b 45 08             	mov    0x8(%ebp),%eax
  102e18:	ff d0                	call   *%eax
            break;
  102e1a:	e9 ac 02 00 00       	jmp    1030cb <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102e1f:	8b 45 14             	mov    0x14(%ebp),%eax
  102e22:	8d 50 04             	lea    0x4(%eax),%edx
  102e25:	89 55 14             	mov    %edx,0x14(%ebp)
  102e28:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102e2a:	85 db                	test   %ebx,%ebx
  102e2c:	79 02                	jns    102e30 <vprintfmt+0x143>
                err = -err;
  102e2e:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102e30:	83 fb 06             	cmp    $0x6,%ebx
  102e33:	7f 0b                	jg     102e40 <vprintfmt+0x153>
  102e35:	8b 34 9d d4 3d 10 00 	mov    0x103dd4(,%ebx,4),%esi
  102e3c:	85 f6                	test   %esi,%esi
  102e3e:	75 23                	jne    102e63 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102e40:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102e44:	c7 44 24 08 01 3e 10 	movl   $0x103e01,0x8(%esp)
  102e4b:	00 
  102e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e4f:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e53:	8b 45 08             	mov    0x8(%ebp),%eax
  102e56:	89 04 24             	mov    %eax,(%esp)
  102e59:	e8 61 fe ff ff       	call   102cbf <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102e5e:	e9 68 02 00 00       	jmp    1030cb <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102e63:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102e67:	c7 44 24 08 0a 3e 10 	movl   $0x103e0a,0x8(%esp)
  102e6e:	00 
  102e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e72:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e76:	8b 45 08             	mov    0x8(%ebp),%eax
  102e79:	89 04 24             	mov    %eax,(%esp)
  102e7c:	e8 3e fe ff ff       	call   102cbf <printfmt>
            }
            break;
  102e81:	e9 45 02 00 00       	jmp    1030cb <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102e86:	8b 45 14             	mov    0x14(%ebp),%eax
  102e89:	8d 50 04             	lea    0x4(%eax),%edx
  102e8c:	89 55 14             	mov    %edx,0x14(%ebp)
  102e8f:	8b 30                	mov    (%eax),%esi
  102e91:	85 f6                	test   %esi,%esi
  102e93:	75 05                	jne    102e9a <vprintfmt+0x1ad>
                p = "(null)";
  102e95:	be 0d 3e 10 00       	mov    $0x103e0d,%esi
            }
            if (width > 0 && padc != '-') {
  102e9a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102e9e:	7e 3e                	jle    102ede <vprintfmt+0x1f1>
  102ea0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102ea4:	74 38                	je     102ede <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ea6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102eac:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eb0:	89 34 24             	mov    %esi,(%esp)
  102eb3:	e8 15 03 00 00       	call   1031cd <strnlen>
  102eb8:	29 c3                	sub    %eax,%ebx
  102eba:	89 d8                	mov    %ebx,%eax
  102ebc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ebf:	eb 17                	jmp    102ed8 <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102ec1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ec5:	8b 55 0c             	mov    0xc(%ebp),%edx
  102ec8:	89 54 24 04          	mov    %edx,0x4(%esp)
  102ecc:	89 04 24             	mov    %eax,(%esp)
  102ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed2:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102ed4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102ed8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102edc:	7f e3                	jg     102ec1 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102ede:	eb 38                	jmp    102f18 <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102ee0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102ee4:	74 1f                	je     102f05 <vprintfmt+0x218>
  102ee6:	83 fb 1f             	cmp    $0x1f,%ebx
  102ee9:	7e 05                	jle    102ef0 <vprintfmt+0x203>
  102eeb:	83 fb 7e             	cmp    $0x7e,%ebx
  102eee:	7e 15                	jle    102f05 <vprintfmt+0x218>
                    putch('?', putdat);
  102ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ef3:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ef7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102efe:	8b 45 08             	mov    0x8(%ebp),%eax
  102f01:	ff d0                	call   *%eax
  102f03:	eb 0f                	jmp    102f14 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f08:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f0c:	89 1c 24             	mov    %ebx,(%esp)
  102f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  102f12:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102f14:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102f18:	89 f0                	mov    %esi,%eax
  102f1a:	8d 70 01             	lea    0x1(%eax),%esi
  102f1d:	0f b6 00             	movzbl (%eax),%eax
  102f20:	0f be d8             	movsbl %al,%ebx
  102f23:	85 db                	test   %ebx,%ebx
  102f25:	74 10                	je     102f37 <vprintfmt+0x24a>
  102f27:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f2b:	78 b3                	js     102ee0 <vprintfmt+0x1f3>
  102f2d:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102f31:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102f35:	79 a9                	jns    102ee0 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102f37:	eb 17                	jmp    102f50 <vprintfmt+0x263>
                putch(' ', putdat);
  102f39:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f40:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102f47:	8b 45 08             	mov    0x8(%ebp),%eax
  102f4a:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102f4c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102f50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102f54:	7f e3                	jg     102f39 <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102f56:	e9 70 01 00 00       	jmp    1030cb <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102f5b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102f5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f62:	8d 45 14             	lea    0x14(%ebp),%eax
  102f65:	89 04 24             	mov    %eax,(%esp)
  102f68:	e8 0b fd ff ff       	call   102c78 <getint>
  102f6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f70:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102f73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f79:	85 d2                	test   %edx,%edx
  102f7b:	79 26                	jns    102fa3 <vprintfmt+0x2b6>
                putch('-', putdat);
  102f7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f80:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f84:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  102f8e:	ff d0                	call   *%eax
                num = -(long long)num;
  102f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f93:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f96:	f7 d8                	neg    %eax
  102f98:	83 d2 00             	adc    $0x0,%edx
  102f9b:	f7 da                	neg    %edx
  102f9d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fa0:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102fa3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102faa:	e9 a8 00 00 00       	jmp    103057 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102faf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fb2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb6:	8d 45 14             	lea    0x14(%ebp),%eax
  102fb9:	89 04 24             	mov    %eax,(%esp)
  102fbc:	e8 68 fc ff ff       	call   102c29 <getuint>
  102fc1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fc4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102fc7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102fce:	e9 84 00 00 00       	jmp    103057 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102fd3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102fd6:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fda:	8d 45 14             	lea    0x14(%ebp),%eax
  102fdd:	89 04 24             	mov    %eax,(%esp)
  102fe0:	e8 44 fc ff ff       	call   102c29 <getuint>
  102fe5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102fe8:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102feb:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102ff2:	eb 63                	jmp    103057 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ffb:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103002:	8b 45 08             	mov    0x8(%ebp),%eax
  103005:	ff d0                	call   *%eax
            putch('x', putdat);
  103007:	8b 45 0c             	mov    0xc(%ebp),%eax
  10300a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10300e:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103015:	8b 45 08             	mov    0x8(%ebp),%eax
  103018:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10301a:	8b 45 14             	mov    0x14(%ebp),%eax
  10301d:	8d 50 04             	lea    0x4(%eax),%edx
  103020:	89 55 14             	mov    %edx,0x14(%ebp)
  103023:	8b 00                	mov    (%eax),%eax
  103025:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103028:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  10302f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  103036:	eb 1f                	jmp    103057 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  103038:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10303b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10303f:	8d 45 14             	lea    0x14(%ebp),%eax
  103042:	89 04 24             	mov    %eax,(%esp)
  103045:	e8 df fb ff ff       	call   102c29 <getuint>
  10304a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10304d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  103050:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  103057:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  10305b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10305e:	89 54 24 18          	mov    %edx,0x18(%esp)
  103062:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103065:	89 54 24 14          	mov    %edx,0x14(%esp)
  103069:	89 44 24 10          	mov    %eax,0x10(%esp)
  10306d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103070:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103073:	89 44 24 08          	mov    %eax,0x8(%esp)
  103077:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10307b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10307e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103082:	8b 45 08             	mov    0x8(%ebp),%eax
  103085:	89 04 24             	mov    %eax,(%esp)
  103088:	e8 97 fa ff ff       	call   102b24 <printnum>
            break;
  10308d:	eb 3c                	jmp    1030cb <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  10308f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103092:	89 44 24 04          	mov    %eax,0x4(%esp)
  103096:	89 1c 24             	mov    %ebx,(%esp)
  103099:	8b 45 08             	mov    0x8(%ebp),%eax
  10309c:	ff d0                	call   *%eax
            break;
  10309e:	eb 2b                	jmp    1030cb <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  1030a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1030a7:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  1030ae:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b1:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  1030b3:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030b7:	eb 04                	jmp    1030bd <vprintfmt+0x3d0>
  1030b9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030bd:	8b 45 10             	mov    0x10(%ebp),%eax
  1030c0:	83 e8 01             	sub    $0x1,%eax
  1030c3:	0f b6 00             	movzbl (%eax),%eax
  1030c6:	3c 25                	cmp    $0x25,%al
  1030c8:	75 ef                	jne    1030b9 <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  1030ca:	90                   	nop
        }
    }
  1030cb:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1030cc:	e9 3e fc ff ff       	jmp    102d0f <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  1030d1:	83 c4 40             	add    $0x40,%esp
  1030d4:	5b                   	pop    %ebx
  1030d5:	5e                   	pop    %esi
  1030d6:	5d                   	pop    %ebp
  1030d7:	c3                   	ret    

001030d8 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  1030d8:	55                   	push   %ebp
  1030d9:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  1030db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030de:	8b 40 08             	mov    0x8(%eax),%eax
  1030e1:	8d 50 01             	lea    0x1(%eax),%edx
  1030e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030e7:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  1030ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030ed:	8b 10                	mov    (%eax),%edx
  1030ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030f2:	8b 40 04             	mov    0x4(%eax),%eax
  1030f5:	39 c2                	cmp    %eax,%edx
  1030f7:	73 12                	jae    10310b <sprintputch+0x33>
        *b->buf ++ = ch;
  1030f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030fc:	8b 00                	mov    (%eax),%eax
  1030fe:	8d 48 01             	lea    0x1(%eax),%ecx
  103101:	8b 55 0c             	mov    0xc(%ebp),%edx
  103104:	89 0a                	mov    %ecx,(%edx)
  103106:	8b 55 08             	mov    0x8(%ebp),%edx
  103109:	88 10                	mov    %dl,(%eax)
    }
}
  10310b:	5d                   	pop    %ebp
  10310c:	c3                   	ret    

0010310d <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10310d:	55                   	push   %ebp
  10310e:	89 e5                	mov    %esp,%ebp
  103110:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103113:	8d 45 14             	lea    0x14(%ebp),%eax
  103116:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  103119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10311c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103120:	8b 45 10             	mov    0x10(%ebp),%eax
  103123:	89 44 24 08          	mov    %eax,0x8(%esp)
  103127:	8b 45 0c             	mov    0xc(%ebp),%eax
  10312a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10312e:	8b 45 08             	mov    0x8(%ebp),%eax
  103131:	89 04 24             	mov    %eax,(%esp)
  103134:	e8 08 00 00 00       	call   103141 <vsnprintf>
  103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10313c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10313f:	c9                   	leave  
  103140:	c3                   	ret    

00103141 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  103141:	55                   	push   %ebp
  103142:	89 e5                	mov    %esp,%ebp
  103144:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  103147:	8b 45 08             	mov    0x8(%ebp),%eax
  10314a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10314d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103150:	8d 50 ff             	lea    -0x1(%eax),%edx
  103153:	8b 45 08             	mov    0x8(%ebp),%eax
  103156:	01 d0                	add    %edx,%eax
  103158:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10315b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  103162:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103166:	74 0a                	je     103172 <vsnprintf+0x31>
  103168:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10316b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10316e:	39 c2                	cmp    %eax,%edx
  103170:	76 07                	jbe    103179 <vsnprintf+0x38>
        return -E_INVAL;
  103172:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  103177:	eb 2a                	jmp    1031a3 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  103179:	8b 45 14             	mov    0x14(%ebp),%eax
  10317c:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103180:	8b 45 10             	mov    0x10(%ebp),%eax
  103183:	89 44 24 08          	mov    %eax,0x8(%esp)
  103187:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10318a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10318e:	c7 04 24 d8 30 10 00 	movl   $0x1030d8,(%esp)
  103195:	e8 53 fb ff ff       	call   102ced <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10319a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10319d:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  1031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1031a3:	c9                   	leave  
  1031a4:	c3                   	ret    

001031a5 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1031a5:	55                   	push   %ebp
  1031a6:	89 e5                	mov    %esp,%ebp
  1031a8:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031ab:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1031b2:	eb 04                	jmp    1031b8 <strlen+0x13>
        cnt ++;
  1031b4:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  1031b8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bb:	8d 50 01             	lea    0x1(%eax),%edx
  1031be:	89 55 08             	mov    %edx,0x8(%ebp)
  1031c1:	0f b6 00             	movzbl (%eax),%eax
  1031c4:	84 c0                	test   %al,%al
  1031c6:	75 ec                	jne    1031b4 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  1031c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031cb:	c9                   	leave  
  1031cc:	c3                   	ret    

001031cd <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  1031cd:	55                   	push   %ebp
  1031ce:	89 e5                	mov    %esp,%ebp
  1031d0:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1031d3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  1031da:	eb 04                	jmp    1031e0 <strnlen+0x13>
        cnt ++;
  1031dc:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  1031e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1031e3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1031e6:	73 10                	jae    1031f8 <strnlen+0x2b>
  1031e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1031eb:	8d 50 01             	lea    0x1(%eax),%edx
  1031ee:	89 55 08             	mov    %edx,0x8(%ebp)
  1031f1:	0f b6 00             	movzbl (%eax),%eax
  1031f4:	84 c0                	test   %al,%al
  1031f6:	75 e4                	jne    1031dc <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  1031f8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1031fb:	c9                   	leave  
  1031fc:	c3                   	ret    

001031fd <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  1031fd:	55                   	push   %ebp
  1031fe:	89 e5                	mov    %esp,%ebp
  103200:	57                   	push   %edi
  103201:	56                   	push   %esi
  103202:	83 ec 20             	sub    $0x20,%esp
  103205:	8b 45 08             	mov    0x8(%ebp),%eax
  103208:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10320b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10320e:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103211:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103214:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103217:	89 d1                	mov    %edx,%ecx
  103219:	89 c2                	mov    %eax,%edx
  10321b:	89 ce                	mov    %ecx,%esi
  10321d:	89 d7                	mov    %edx,%edi
  10321f:	ac                   	lods   %ds:(%esi),%al
  103220:	aa                   	stos   %al,%es:(%edi)
  103221:	84 c0                	test   %al,%al
  103223:	75 fa                	jne    10321f <strcpy+0x22>
  103225:	89 fa                	mov    %edi,%edx
  103227:	89 f1                	mov    %esi,%ecx
  103229:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10322c:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10322f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103232:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103235:	83 c4 20             	add    $0x20,%esp
  103238:	5e                   	pop    %esi
  103239:	5f                   	pop    %edi
  10323a:	5d                   	pop    %ebp
  10323b:	c3                   	ret    

0010323c <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10323c:	55                   	push   %ebp
  10323d:	89 e5                	mov    %esp,%ebp
  10323f:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103242:	8b 45 08             	mov    0x8(%ebp),%eax
  103245:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  103248:	eb 21                	jmp    10326b <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10324a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10324d:	0f b6 10             	movzbl (%eax),%edx
  103250:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103253:	88 10                	mov    %dl,(%eax)
  103255:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103258:	0f b6 00             	movzbl (%eax),%eax
  10325b:	84 c0                	test   %al,%al
  10325d:	74 04                	je     103263 <strncpy+0x27>
            src ++;
  10325f:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103263:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103267:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10326b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10326f:	75 d9                	jne    10324a <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103271:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103274:	c9                   	leave  
  103275:	c3                   	ret    

00103276 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103276:	55                   	push   %ebp
  103277:	89 e5                	mov    %esp,%ebp
  103279:	57                   	push   %edi
  10327a:	56                   	push   %esi
  10327b:	83 ec 20             	sub    $0x20,%esp
  10327e:	8b 45 08             	mov    0x8(%ebp),%eax
  103281:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103284:	8b 45 0c             	mov    0xc(%ebp),%eax
  103287:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  10328a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10328d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103290:	89 d1                	mov    %edx,%ecx
  103292:	89 c2                	mov    %eax,%edx
  103294:	89 ce                	mov    %ecx,%esi
  103296:	89 d7                	mov    %edx,%edi
  103298:	ac                   	lods   %ds:(%esi),%al
  103299:	ae                   	scas   %es:(%edi),%al
  10329a:	75 08                	jne    1032a4 <strcmp+0x2e>
  10329c:	84 c0                	test   %al,%al
  10329e:	75 f8                	jne    103298 <strcmp+0x22>
  1032a0:	31 c0                	xor    %eax,%eax
  1032a2:	eb 04                	jmp    1032a8 <strcmp+0x32>
  1032a4:	19 c0                	sbb    %eax,%eax
  1032a6:	0c 01                	or     $0x1,%al
  1032a8:	89 fa                	mov    %edi,%edx
  1032aa:	89 f1                	mov    %esi,%ecx
  1032ac:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1032af:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1032b2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1032b5:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1032b8:	83 c4 20             	add    $0x20,%esp
  1032bb:	5e                   	pop    %esi
  1032bc:	5f                   	pop    %edi
  1032bd:	5d                   	pop    %ebp
  1032be:	c3                   	ret    

001032bf <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1032bf:	55                   	push   %ebp
  1032c0:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032c2:	eb 0c                	jmp    1032d0 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1032c4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1032c8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032cc:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1032d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032d4:	74 1a                	je     1032f0 <strncmp+0x31>
  1032d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032d9:	0f b6 00             	movzbl (%eax),%eax
  1032dc:	84 c0                	test   %al,%al
  1032de:	74 10                	je     1032f0 <strncmp+0x31>
  1032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1032e3:	0f b6 10             	movzbl (%eax),%edx
  1032e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032e9:	0f b6 00             	movzbl (%eax),%eax
  1032ec:	38 c2                	cmp    %al,%dl
  1032ee:	74 d4                	je     1032c4 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  1032f0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1032f4:	74 18                	je     10330e <strncmp+0x4f>
  1032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1032f9:	0f b6 00             	movzbl (%eax),%eax
  1032fc:	0f b6 d0             	movzbl %al,%edx
  1032ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103302:	0f b6 00             	movzbl (%eax),%eax
  103305:	0f b6 c0             	movzbl %al,%eax
  103308:	29 c2                	sub    %eax,%edx
  10330a:	89 d0                	mov    %edx,%eax
  10330c:	eb 05                	jmp    103313 <strncmp+0x54>
  10330e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103313:	5d                   	pop    %ebp
  103314:	c3                   	ret    

00103315 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103315:	55                   	push   %ebp
  103316:	89 e5                	mov    %esp,%ebp
  103318:	83 ec 04             	sub    $0x4,%esp
  10331b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10331e:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103321:	eb 14                	jmp    103337 <strchr+0x22>
        if (*s == c) {
  103323:	8b 45 08             	mov    0x8(%ebp),%eax
  103326:	0f b6 00             	movzbl (%eax),%eax
  103329:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10332c:	75 05                	jne    103333 <strchr+0x1e>
            return (char *)s;
  10332e:	8b 45 08             	mov    0x8(%ebp),%eax
  103331:	eb 13                	jmp    103346 <strchr+0x31>
        }
        s ++;
  103333:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103337:	8b 45 08             	mov    0x8(%ebp),%eax
  10333a:	0f b6 00             	movzbl (%eax),%eax
  10333d:	84 c0                	test   %al,%al
  10333f:	75 e2                	jne    103323 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103341:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103346:	c9                   	leave  
  103347:	c3                   	ret    

00103348 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  103348:	55                   	push   %ebp
  103349:	89 e5                	mov    %esp,%ebp
  10334b:	83 ec 04             	sub    $0x4,%esp
  10334e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103351:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103354:	eb 11                	jmp    103367 <strfind+0x1f>
        if (*s == c) {
  103356:	8b 45 08             	mov    0x8(%ebp),%eax
  103359:	0f b6 00             	movzbl (%eax),%eax
  10335c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10335f:	75 02                	jne    103363 <strfind+0x1b>
            break;
  103361:	eb 0e                	jmp    103371 <strfind+0x29>
        }
        s ++;
  103363:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  103367:	8b 45 08             	mov    0x8(%ebp),%eax
  10336a:	0f b6 00             	movzbl (%eax),%eax
  10336d:	84 c0                	test   %al,%al
  10336f:	75 e5                	jne    103356 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103371:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103374:	c9                   	leave  
  103375:	c3                   	ret    

00103376 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103376:	55                   	push   %ebp
  103377:	89 e5                	mov    %esp,%ebp
  103379:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10337c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  103383:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  10338a:	eb 04                	jmp    103390 <strtol+0x1a>
        s ++;
  10338c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  103390:	8b 45 08             	mov    0x8(%ebp),%eax
  103393:	0f b6 00             	movzbl (%eax),%eax
  103396:	3c 20                	cmp    $0x20,%al
  103398:	74 f2                	je     10338c <strtol+0x16>
  10339a:	8b 45 08             	mov    0x8(%ebp),%eax
  10339d:	0f b6 00             	movzbl (%eax),%eax
  1033a0:	3c 09                	cmp    $0x9,%al
  1033a2:	74 e8                	je     10338c <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033a7:	0f b6 00             	movzbl (%eax),%eax
  1033aa:	3c 2b                	cmp    $0x2b,%al
  1033ac:	75 06                	jne    1033b4 <strtol+0x3e>
        s ++;
  1033ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033b2:	eb 15                	jmp    1033c9 <strtol+0x53>
    }
    else if (*s == '-') {
  1033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1033b7:	0f b6 00             	movzbl (%eax),%eax
  1033ba:	3c 2d                	cmp    $0x2d,%al
  1033bc:	75 0b                	jne    1033c9 <strtol+0x53>
        s ++, neg = 1;
  1033be:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1033c2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1033c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033cd:	74 06                	je     1033d5 <strtol+0x5f>
  1033cf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1033d3:	75 24                	jne    1033f9 <strtol+0x83>
  1033d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1033d8:	0f b6 00             	movzbl (%eax),%eax
  1033db:	3c 30                	cmp    $0x30,%al
  1033dd:	75 1a                	jne    1033f9 <strtol+0x83>
  1033df:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e2:	83 c0 01             	add    $0x1,%eax
  1033e5:	0f b6 00             	movzbl (%eax),%eax
  1033e8:	3c 78                	cmp    $0x78,%al
  1033ea:	75 0d                	jne    1033f9 <strtol+0x83>
        s += 2, base = 16;
  1033ec:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  1033f0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  1033f7:	eb 2a                	jmp    103423 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  1033f9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1033fd:	75 17                	jne    103416 <strtol+0xa0>
  1033ff:	8b 45 08             	mov    0x8(%ebp),%eax
  103402:	0f b6 00             	movzbl (%eax),%eax
  103405:	3c 30                	cmp    $0x30,%al
  103407:	75 0d                	jne    103416 <strtol+0xa0>
        s ++, base = 8;
  103409:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10340d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103414:	eb 0d                	jmp    103423 <strtol+0xad>
    }
    else if (base == 0) {
  103416:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10341a:	75 07                	jne    103423 <strtol+0xad>
        base = 10;
  10341c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103423:	8b 45 08             	mov    0x8(%ebp),%eax
  103426:	0f b6 00             	movzbl (%eax),%eax
  103429:	3c 2f                	cmp    $0x2f,%al
  10342b:	7e 1b                	jle    103448 <strtol+0xd2>
  10342d:	8b 45 08             	mov    0x8(%ebp),%eax
  103430:	0f b6 00             	movzbl (%eax),%eax
  103433:	3c 39                	cmp    $0x39,%al
  103435:	7f 11                	jg     103448 <strtol+0xd2>
            dig = *s - '0';
  103437:	8b 45 08             	mov    0x8(%ebp),%eax
  10343a:	0f b6 00             	movzbl (%eax),%eax
  10343d:	0f be c0             	movsbl %al,%eax
  103440:	83 e8 30             	sub    $0x30,%eax
  103443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103446:	eb 48                	jmp    103490 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  103448:	8b 45 08             	mov    0x8(%ebp),%eax
  10344b:	0f b6 00             	movzbl (%eax),%eax
  10344e:	3c 60                	cmp    $0x60,%al
  103450:	7e 1b                	jle    10346d <strtol+0xf7>
  103452:	8b 45 08             	mov    0x8(%ebp),%eax
  103455:	0f b6 00             	movzbl (%eax),%eax
  103458:	3c 7a                	cmp    $0x7a,%al
  10345a:	7f 11                	jg     10346d <strtol+0xf7>
            dig = *s - 'a' + 10;
  10345c:	8b 45 08             	mov    0x8(%ebp),%eax
  10345f:	0f b6 00             	movzbl (%eax),%eax
  103462:	0f be c0             	movsbl %al,%eax
  103465:	83 e8 57             	sub    $0x57,%eax
  103468:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10346b:	eb 23                	jmp    103490 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10346d:	8b 45 08             	mov    0x8(%ebp),%eax
  103470:	0f b6 00             	movzbl (%eax),%eax
  103473:	3c 40                	cmp    $0x40,%al
  103475:	7e 3d                	jle    1034b4 <strtol+0x13e>
  103477:	8b 45 08             	mov    0x8(%ebp),%eax
  10347a:	0f b6 00             	movzbl (%eax),%eax
  10347d:	3c 5a                	cmp    $0x5a,%al
  10347f:	7f 33                	jg     1034b4 <strtol+0x13e>
            dig = *s - 'A' + 10;
  103481:	8b 45 08             	mov    0x8(%ebp),%eax
  103484:	0f b6 00             	movzbl (%eax),%eax
  103487:	0f be c0             	movsbl %al,%eax
  10348a:	83 e8 37             	sub    $0x37,%eax
  10348d:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  103490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103493:	3b 45 10             	cmp    0x10(%ebp),%eax
  103496:	7c 02                	jl     10349a <strtol+0x124>
            break;
  103498:	eb 1a                	jmp    1034b4 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  10349a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10349e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1034a1:	0f af 45 10          	imul   0x10(%ebp),%eax
  1034a5:	89 c2                	mov    %eax,%edx
  1034a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034aa:	01 d0                	add    %edx,%eax
  1034ac:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1034af:	e9 6f ff ff ff       	jmp    103423 <strtol+0xad>

    if (endptr) {
  1034b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1034b8:	74 08                	je     1034c2 <strtol+0x14c>
        *endptr = (char *) s;
  1034ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034bd:	8b 55 08             	mov    0x8(%ebp),%edx
  1034c0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1034c2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1034c6:	74 07                	je     1034cf <strtol+0x159>
  1034c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1034cb:	f7 d8                	neg    %eax
  1034cd:	eb 03                	jmp    1034d2 <strtol+0x15c>
  1034cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1034d2:	c9                   	leave  
  1034d3:	c3                   	ret    

001034d4 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1034d4:	55                   	push   %ebp
  1034d5:	89 e5                	mov    %esp,%ebp
  1034d7:	57                   	push   %edi
  1034d8:	83 ec 24             	sub    $0x24,%esp
  1034db:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034de:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1034e1:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  1034e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1034e8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  1034eb:	88 45 f7             	mov    %al,-0x9(%ebp)
  1034ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1034f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1034f4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  1034f7:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  1034fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  1034fe:	89 d7                	mov    %edx,%edi
  103500:	f3 aa                	rep stos %al,%es:(%edi)
  103502:	89 fa                	mov    %edi,%edx
  103504:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103507:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10350a:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10350d:	83 c4 24             	add    $0x24,%esp
  103510:	5f                   	pop    %edi
  103511:	5d                   	pop    %ebp
  103512:	c3                   	ret    

00103513 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103513:	55                   	push   %ebp
  103514:	89 e5                	mov    %esp,%ebp
  103516:	57                   	push   %edi
  103517:	56                   	push   %esi
  103518:	53                   	push   %ebx
  103519:	83 ec 30             	sub    $0x30,%esp
  10351c:	8b 45 08             	mov    0x8(%ebp),%eax
  10351f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103522:	8b 45 0c             	mov    0xc(%ebp),%eax
  103525:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103528:	8b 45 10             	mov    0x10(%ebp),%eax
  10352b:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10352e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103531:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103534:	73 42                	jae    103578 <memmove+0x65>
  103536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10353c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10353f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103542:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103545:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  103548:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10354b:	c1 e8 02             	shr    $0x2,%eax
  10354e:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103550:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103553:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103556:	89 d7                	mov    %edx,%edi
  103558:	89 c6                	mov    %eax,%esi
  10355a:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10355c:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10355f:	83 e1 03             	and    $0x3,%ecx
  103562:	74 02                	je     103566 <memmove+0x53>
  103564:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103566:	89 f0                	mov    %esi,%eax
  103568:	89 fa                	mov    %edi,%edx
  10356a:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10356d:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103570:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103576:	eb 36                	jmp    1035ae <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  103578:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10357b:	8d 50 ff             	lea    -0x1(%eax),%edx
  10357e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103581:	01 c2                	add    %eax,%edx
  103583:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103586:	8d 48 ff             	lea    -0x1(%eax),%ecx
  103589:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10358c:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  10358f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103592:	89 c1                	mov    %eax,%ecx
  103594:	89 d8                	mov    %ebx,%eax
  103596:	89 d6                	mov    %edx,%esi
  103598:	89 c7                	mov    %eax,%edi
  10359a:	fd                   	std    
  10359b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10359d:	fc                   	cld    
  10359e:	89 f8                	mov    %edi,%eax
  1035a0:	89 f2                	mov    %esi,%edx
  1035a2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1035a5:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1035a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1035ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1035ae:	83 c4 30             	add    $0x30,%esp
  1035b1:	5b                   	pop    %ebx
  1035b2:	5e                   	pop    %esi
  1035b3:	5f                   	pop    %edi
  1035b4:	5d                   	pop    %ebp
  1035b5:	c3                   	ret    

001035b6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1035b6:	55                   	push   %ebp
  1035b7:	89 e5                	mov    %esp,%ebp
  1035b9:	57                   	push   %edi
  1035ba:	56                   	push   %esi
  1035bb:	83 ec 20             	sub    $0x20,%esp
  1035be:	8b 45 08             	mov    0x8(%ebp),%eax
  1035c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1035c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035ca:	8b 45 10             	mov    0x10(%ebp),%eax
  1035cd:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1035d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1035d3:	c1 e8 02             	shr    $0x2,%eax
  1035d6:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1035d8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1035db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035de:	89 d7                	mov    %edx,%edi
  1035e0:	89 c6                	mov    %eax,%esi
  1035e2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1035e4:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  1035e7:	83 e1 03             	and    $0x3,%ecx
  1035ea:	74 02                	je     1035ee <memcpy+0x38>
  1035ec:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1035ee:	89 f0                	mov    %esi,%eax
  1035f0:	89 fa                	mov    %edi,%edx
  1035f2:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1035f5:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  1035f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  1035fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  1035fe:	83 c4 20             	add    $0x20,%esp
  103601:	5e                   	pop    %esi
  103602:	5f                   	pop    %edi
  103603:	5d                   	pop    %ebp
  103604:	c3                   	ret    

00103605 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103605:	55                   	push   %ebp
  103606:	89 e5                	mov    %esp,%ebp
  103608:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10360b:	8b 45 08             	mov    0x8(%ebp),%eax
  10360e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103611:	8b 45 0c             	mov    0xc(%ebp),%eax
  103614:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103617:	eb 30                	jmp    103649 <memcmp+0x44>
        if (*s1 != *s2) {
  103619:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10361c:	0f b6 10             	movzbl (%eax),%edx
  10361f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103622:	0f b6 00             	movzbl (%eax),%eax
  103625:	38 c2                	cmp    %al,%dl
  103627:	74 18                	je     103641 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  103629:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10362c:	0f b6 00             	movzbl (%eax),%eax
  10362f:	0f b6 d0             	movzbl %al,%edx
  103632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103635:	0f b6 00             	movzbl (%eax),%eax
  103638:	0f b6 c0             	movzbl %al,%eax
  10363b:	29 c2                	sub    %eax,%edx
  10363d:	89 d0                	mov    %edx,%eax
  10363f:	eb 1a                	jmp    10365b <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103641:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103645:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  103649:	8b 45 10             	mov    0x10(%ebp),%eax
  10364c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10364f:	89 55 10             	mov    %edx,0x10(%ebp)
  103652:	85 c0                	test   %eax,%eax
  103654:	75 c3                	jne    103619 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103656:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10365b:	c9                   	leave  
  10365c:	c3                   	ret    
