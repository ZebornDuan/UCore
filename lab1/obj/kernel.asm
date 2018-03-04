
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
  100027:	e8 ca 32 00 00       	call   1032f6 <memset>

    cons_init();                // init the console
  10002c:	e8 3b 15 00 00       	call   10156c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 80 34 10 00 	movl   $0x103480,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 9c 34 10 00 	movl   $0x10349c,(%esp)
  100046:	e8 c7 02 00 00       	call   100312 <cprintf>

    print_kerninfo();
  10004b:	e8 f6 07 00 00       	call   100846 <print_kerninfo>

    grade_backtrace();
  100050:	e8 86 00 00 00       	call   1000db <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 e2 28 00 00       	call   10293c <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 50 16 00 00       	call   1016af <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 a2 17 00 00       	call   101806 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 f6 0c 00 00       	call   100d5f <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 af 15 00 00       	call   10161d <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10006e:	eb fe                	jmp    10006e <kern_init+0x6e>

00100070 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100070:	55                   	push   %ebp
  100071:	89 e5                	mov    %esp,%ebp
  100073:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  100076:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10007d:	00 
  10007e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100085:	00 
  100086:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10008d:	e8 ff 0b 00 00       	call   100c91 <mon_backtrace>
}
  100092:	c9                   	leave  
  100093:	c3                   	ret    

00100094 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  100094:	55                   	push   %ebp
  100095:	89 e5                	mov    %esp,%ebp
  100097:	53                   	push   %ebx
  100098:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  10009b:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  10009e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000a1:	8d 55 08             	lea    0x8(%ebp),%edx
  1000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1000a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000b3:	89 04 24             	mov    %eax,(%esp)
  1000b6:	e8 b5 ff ff ff       	call   100070 <grade_backtrace2>
}
  1000bb:	83 c4 14             	add    $0x14,%esp
  1000be:	5b                   	pop    %ebx
  1000bf:	5d                   	pop    %ebp
  1000c0:	c3                   	ret    

001000c1 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c1:	55                   	push   %ebp
  1000c2:	89 e5                	mov    %esp,%ebp
  1000c4:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000c7:	8b 45 10             	mov    0x10(%ebp),%eax
  1000ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d1:	89 04 24             	mov    %eax,(%esp)
  1000d4:	e8 bb ff ff ff       	call   100094 <grade_backtrace1>
}
  1000d9:	c9                   	leave  
  1000da:	c3                   	ret    

001000db <grade_backtrace>:

void
grade_backtrace(void) {
  1000db:	55                   	push   %ebp
  1000dc:	89 e5                	mov    %esp,%ebp
  1000de:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e1:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000e6:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000ed:	ff 
  1000ee:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000f2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000f9:	e8 c3 ff ff ff       	call   1000c1 <grade_backtrace0>
}
  1000fe:	c9                   	leave  
  1000ff:	c3                   	ret    

00100100 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100100:	55                   	push   %ebp
  100101:	89 e5                	mov    %esp,%ebp
  100103:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100106:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100109:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10010c:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10010f:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100112:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100116:	0f b7 c0             	movzwl %ax,%eax
  100119:	83 e0 03             	and    $0x3,%eax
  10011c:	89 c2                	mov    %eax,%edx
  10011e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100123:	89 54 24 08          	mov    %edx,0x8(%esp)
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 a1 34 10 00 	movl   $0x1034a1,(%esp)
  100132:	e8 db 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100137:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10013b:	0f b7 d0             	movzwl %ax,%edx
  10013e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100143:	89 54 24 08          	mov    %edx,0x8(%esp)
  100147:	89 44 24 04          	mov    %eax,0x4(%esp)
  10014b:	c7 04 24 af 34 10 00 	movl   $0x1034af,(%esp)
  100152:	e8 bb 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100157:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  10015b:	0f b7 d0             	movzwl %ax,%edx
  10015e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100163:	89 54 24 08          	mov    %edx,0x8(%esp)
  100167:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016b:	c7 04 24 bd 34 10 00 	movl   $0x1034bd,(%esp)
  100172:	e8 9b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  100177:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017b:	0f b7 d0             	movzwl %ax,%edx
  10017e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100183:	89 54 24 08          	mov    %edx,0x8(%esp)
  100187:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018b:	c7 04 24 cb 34 10 00 	movl   $0x1034cb,(%esp)
  100192:	e8 7b 01 00 00       	call   100312 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  100197:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019b:	0f b7 d0             	movzwl %ax,%edx
  10019e:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a3:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ab:	c7 04 24 d9 34 10 00 	movl   $0x1034d9,(%esp)
  1001b2:	e8 5b 01 00 00       	call   100312 <cprintf>
    round ++;
  1001b7:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001bc:	83 c0 01             	add    $0x1,%eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	c9                   	leave  
  1001c5:	c3                   	ret    

001001c6 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c6:	55                   	push   %ebp
  1001c7:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001c9:	5d                   	pop    %ebp
  1001ca:	c3                   	ret    

001001cb <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001cb:	55                   	push   %ebp
  1001cc:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001ce:	5d                   	pop    %ebp
  1001cf:	c3                   	ret    

001001d0 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001d0:	55                   	push   %ebp
  1001d1:	89 e5                	mov    %esp,%ebp
  1001d3:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001d6:	e8 25 ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001db:	c7 04 24 e8 34 10 00 	movl   $0x1034e8,(%esp)
  1001e2:	e8 2b 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_user();
  1001e7:	e8 da ff ff ff       	call   1001c6 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001ec:	e8 0f ff ff ff       	call   100100 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001f1:	c7 04 24 08 35 10 00 	movl   $0x103508,(%esp)
  1001f8:	e8 15 01 00 00       	call   100312 <cprintf>
    lab1_switch_to_kernel();
  1001fd:	e8 c9 ff ff ff       	call   1001cb <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100202:	e8 f9 fe ff ff       	call   100100 <lab1_print_cur_status>
}
  100207:	c9                   	leave  
  100208:	c3                   	ret    

00100209 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100209:	55                   	push   %ebp
  10020a:	89 e5                	mov    %esp,%ebp
  10020c:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10020f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100213:	74 13                	je     100228 <readline+0x1f>
        cprintf("%s", prompt);
  100215:	8b 45 08             	mov    0x8(%ebp),%eax
  100218:	89 44 24 04          	mov    %eax,0x4(%esp)
  10021c:	c7 04 24 27 35 10 00 	movl   $0x103527,(%esp)
  100223:	e8 ea 00 00 00       	call   100312 <cprintf>
    }
    int i = 0, c;
  100228:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10022f:	e8 66 01 00 00       	call   10039a <getchar>
  100234:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100237:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10023b:	79 07                	jns    100244 <readline+0x3b>
            return NULL;
  10023d:	b8 00 00 00 00       	mov    $0x0,%eax
  100242:	eb 79                	jmp    1002bd <readline+0xb4>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100244:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100248:	7e 28                	jle    100272 <readline+0x69>
  10024a:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100251:	7f 1f                	jg     100272 <readline+0x69>
            cputchar(c);
  100253:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100256:	89 04 24             	mov    %eax,(%esp)
  100259:	e8 da 00 00 00       	call   100338 <cputchar>
            buf[i ++] = c;
  10025e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100261:	8d 50 01             	lea    0x1(%eax),%edx
  100264:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100267:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10026a:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100270:	eb 46                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\b' && i > 0) {
  100272:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  100276:	75 17                	jne    10028f <readline+0x86>
  100278:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10027c:	7e 11                	jle    10028f <readline+0x86>
            cputchar(c);
  10027e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100281:	89 04 24             	mov    %eax,(%esp)
  100284:	e8 af 00 00 00       	call   100338 <cputchar>
            i --;
  100289:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  10028d:	eb 29                	jmp    1002b8 <readline+0xaf>
        }
        else if (c == '\n' || c == '\r') {
  10028f:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100293:	74 06                	je     10029b <readline+0x92>
  100295:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  100299:	75 1d                	jne    1002b8 <readline+0xaf>
            cputchar(c);
  10029b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10029e:	89 04 24             	mov    %eax,(%esp)
  1002a1:	e8 92 00 00 00       	call   100338 <cputchar>
            buf[i] = '\0';
  1002a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002a9:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1002ae:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002b1:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1002b6:	eb 05                	jmp    1002bd <readline+0xb4>
        }
    }
  1002b8:	e9 72 ff ff ff       	jmp    10022f <readline+0x26>
}
  1002bd:	c9                   	leave  
  1002be:	c3                   	ret    

001002bf <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002bf:	55                   	push   %ebp
  1002c0:	89 e5                	mov    %esp,%ebp
  1002c2:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c8:	89 04 24             	mov    %eax,(%esp)
  1002cb:	e8 c8 12 00 00       	call   101598 <cons_putc>
    (*cnt) ++;
  1002d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002d3:	8b 00                	mov    (%eax),%eax
  1002d5:	8d 50 01             	lea    0x1(%eax),%edx
  1002d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002db:	89 10                	mov    %edx,(%eax)
}
  1002dd:	c9                   	leave  
  1002de:	c3                   	ret    

001002df <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  1002df:	55                   	push   %ebp
  1002e0:	89 e5                	mov    %esp,%ebp
  1002e2:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002e5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  1002ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  1002ef:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1002f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1002fa:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1002fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100301:	c7 04 24 bf 02 10 00 	movl   $0x1002bf,(%esp)
  100308:	e8 02 28 00 00       	call   102b0f <vprintfmt>
    return cnt;
  10030d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100310:	c9                   	leave  
  100311:	c3                   	ret    

00100312 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100312:	55                   	push   %ebp
  100313:	89 e5                	mov    %esp,%ebp
  100315:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100318:	8d 45 0c             	lea    0xc(%ebp),%eax
  10031b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10031e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100321:	89 44 24 04          	mov    %eax,0x4(%esp)
  100325:	8b 45 08             	mov    0x8(%ebp),%eax
  100328:	89 04 24             	mov    %eax,(%esp)
  10032b:	e8 af ff ff ff       	call   1002df <vcprintf>
  100330:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  100333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100336:	c9                   	leave  
  100337:	c3                   	ret    

00100338 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100338:	55                   	push   %ebp
  100339:	89 e5                	mov    %esp,%ebp
  10033b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10033e:	8b 45 08             	mov    0x8(%ebp),%eax
  100341:	89 04 24             	mov    %eax,(%esp)
  100344:	e8 4f 12 00 00       	call   101598 <cons_putc>
}
  100349:	c9                   	leave  
  10034a:	c3                   	ret    

0010034b <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  10034b:	55                   	push   %ebp
  10034c:	89 e5                	mov    %esp,%ebp
  10034e:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100351:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  100358:	eb 13                	jmp    10036d <cputs+0x22>
        cputch(c, &cnt);
  10035a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  10035e:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100361:	89 54 24 04          	mov    %edx,0x4(%esp)
  100365:	89 04 24             	mov    %eax,(%esp)
  100368:	e8 52 ff ff ff       	call   1002bf <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  10036d:	8b 45 08             	mov    0x8(%ebp),%eax
  100370:	8d 50 01             	lea    0x1(%eax),%edx
  100373:	89 55 08             	mov    %edx,0x8(%ebp)
  100376:	0f b6 00             	movzbl (%eax),%eax
  100379:	88 45 f7             	mov    %al,-0x9(%ebp)
  10037c:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100380:	75 d8                	jne    10035a <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  100382:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100385:	89 44 24 04          	mov    %eax,0x4(%esp)
  100389:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100390:	e8 2a ff ff ff       	call   1002bf <cputch>
    return cnt;
  100395:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100398:	c9                   	leave  
  100399:	c3                   	ret    

0010039a <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10039a:	55                   	push   %ebp
  10039b:	89 e5                	mov    %esp,%ebp
  10039d:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003a0:	e8 1c 12 00 00       	call   1015c1 <cons_getc>
  1003a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003ac:	74 f2                	je     1003a0 <getchar+0x6>
        /* do nothing */;
    return c;
  1003ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003b1:	c9                   	leave  
  1003b2:	c3                   	ret    

001003b3 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003b3:	55                   	push   %ebp
  1003b4:	89 e5                	mov    %esp,%ebp
  1003b6:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003bc:	8b 00                	mov    (%eax),%eax
  1003be:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1003c4:	8b 00                	mov    (%eax),%eax
  1003c6:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1003c9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1003d0:	e9 d2 00 00 00       	jmp    1004a7 <stab_binsearch+0xf4>
        int true_m = (l + r) / 2, m = true_m;
  1003d5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1003d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1003db:	01 d0                	add    %edx,%eax
  1003dd:	89 c2                	mov    %eax,%edx
  1003df:	c1 ea 1f             	shr    $0x1f,%edx
  1003e2:	01 d0                	add    %edx,%eax
  1003e4:	d1 f8                	sar    %eax
  1003e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1003e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1003ec:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003ef:	eb 04                	jmp    1003f5 <stab_binsearch+0x42>
            m --;
  1003f1:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1003f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003f8:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1003fb:	7c 1f                	jl     10041c <stab_binsearch+0x69>
  1003fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100400:	89 d0                	mov    %edx,%eax
  100402:	01 c0                	add    %eax,%eax
  100404:	01 d0                	add    %edx,%eax
  100406:	c1 e0 02             	shl    $0x2,%eax
  100409:	89 c2                	mov    %eax,%edx
  10040b:	8b 45 08             	mov    0x8(%ebp),%eax
  10040e:	01 d0                	add    %edx,%eax
  100410:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100414:	0f b6 c0             	movzbl %al,%eax
  100417:	3b 45 14             	cmp    0x14(%ebp),%eax
  10041a:	75 d5                	jne    1003f1 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  10041c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10041f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100422:	7d 0b                	jge    10042f <stab_binsearch+0x7c>
            l = true_m + 1;
  100424:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100427:	83 c0 01             	add    $0x1,%eax
  10042a:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10042d:	eb 78                	jmp    1004a7 <stab_binsearch+0xf4>
        }

        // actual binary search
        any_matches = 1;
  10042f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100436:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100439:	89 d0                	mov    %edx,%eax
  10043b:	01 c0                	add    %eax,%eax
  10043d:	01 d0                	add    %edx,%eax
  10043f:	c1 e0 02             	shl    $0x2,%eax
  100442:	89 c2                	mov    %eax,%edx
  100444:	8b 45 08             	mov    0x8(%ebp),%eax
  100447:	01 d0                	add    %edx,%eax
  100449:	8b 40 08             	mov    0x8(%eax),%eax
  10044c:	3b 45 18             	cmp    0x18(%ebp),%eax
  10044f:	73 13                	jae    100464 <stab_binsearch+0xb1>
            *region_left = m;
  100451:	8b 45 0c             	mov    0xc(%ebp),%eax
  100454:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100457:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10045c:	83 c0 01             	add    $0x1,%eax
  10045f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100462:	eb 43                	jmp    1004a7 <stab_binsearch+0xf4>
        } else if (stabs[m].n_value > addr) {
  100464:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100467:	89 d0                	mov    %edx,%eax
  100469:	01 c0                	add    %eax,%eax
  10046b:	01 d0                	add    %edx,%eax
  10046d:	c1 e0 02             	shl    $0x2,%eax
  100470:	89 c2                	mov    %eax,%edx
  100472:	8b 45 08             	mov    0x8(%ebp),%eax
  100475:	01 d0                	add    %edx,%eax
  100477:	8b 40 08             	mov    0x8(%eax),%eax
  10047a:	3b 45 18             	cmp    0x18(%ebp),%eax
  10047d:	76 16                	jbe    100495 <stab_binsearch+0xe2>
            *region_right = m - 1;
  10047f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100482:	8d 50 ff             	lea    -0x1(%eax),%edx
  100485:	8b 45 10             	mov    0x10(%ebp),%eax
  100488:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10048a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10048d:	83 e8 01             	sub    $0x1,%eax
  100490:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100493:	eb 12                	jmp    1004a7 <stab_binsearch+0xf4>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100495:	8b 45 0c             	mov    0xc(%ebp),%eax
  100498:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049b:	89 10                	mov    %edx,(%eax)
            l = m;
  10049d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004a3:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004a7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004aa:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004ad:	0f 8e 22 ff ff ff    	jle    1003d5 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004b7:	75 0f                	jne    1004c8 <stab_binsearch+0x115>
        *region_right = *region_left - 1;
  1004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004bc:	8b 00                	mov    (%eax),%eax
  1004be:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004c1:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c4:	89 10                	mov    %edx,(%eax)
  1004c6:	eb 3f                	jmp    100507 <stab_binsearch+0x154>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004c8:	8b 45 10             	mov    0x10(%ebp),%eax
  1004cb:	8b 00                	mov    (%eax),%eax
  1004cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1004d0:	eb 04                	jmp    1004d6 <stab_binsearch+0x123>
  1004d2:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  1004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004d9:	8b 00                	mov    (%eax),%eax
  1004db:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004de:	7d 1f                	jge    1004ff <stab_binsearch+0x14c>
  1004e0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004e3:	89 d0                	mov    %edx,%eax
  1004e5:	01 c0                	add    %eax,%eax
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	c1 e0 02             	shl    $0x2,%eax
  1004ec:	89 c2                	mov    %eax,%edx
  1004ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1004f1:	01 d0                	add    %edx,%eax
  1004f3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f7:	0f b6 c0             	movzbl %al,%eax
  1004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  1004fd:	75 d3                	jne    1004d2 <stab_binsearch+0x11f>
            /* do nothing */;
        *region_left = l;
  1004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  100502:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100505:	89 10                	mov    %edx,(%eax)
    }
}
  100507:	c9                   	leave  
  100508:	c3                   	ret    

00100509 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100509:	55                   	push   %ebp
  10050a:	89 e5                	mov    %esp,%ebp
  10050c:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10050f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100512:	c7 00 2c 35 10 00    	movl   $0x10352c,(%eax)
    info->eip_line = 0;
  100518:	8b 45 0c             	mov    0xc(%ebp),%eax
  10051b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100522:	8b 45 0c             	mov    0xc(%ebp),%eax
  100525:	c7 40 08 2c 35 10 00 	movl   $0x10352c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100536:	8b 45 0c             	mov    0xc(%ebp),%eax
  100539:	8b 55 08             	mov    0x8(%ebp),%edx
  10053c:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10053f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100542:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100549:	c7 45 f4 8c 3d 10 00 	movl   $0x103d8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100550:	c7 45 f0 cc b4 10 00 	movl   $0x10b4cc,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100557:	c7 45 ec cd b4 10 00 	movl   $0x10b4cd,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10055e:	c7 45 e8 bd d4 10 00 	movl   $0x10d4bd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100565:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100568:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  10056b:	76 0d                	jbe    10057a <debuginfo_eip+0x71>
  10056d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100570:	83 e8 01             	sub    $0x1,%eax
  100573:	0f b6 00             	movzbl (%eax),%eax
  100576:	84 c0                	test   %al,%al
  100578:	74 0a                	je     100584 <debuginfo_eip+0x7b>
        return -1;
  10057a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10057f:	e9 c0 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100584:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  10058b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10058e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100591:	29 c2                	sub    %eax,%edx
  100593:	89 d0                	mov    %edx,%eax
  100595:	c1 f8 02             	sar    $0x2,%eax
  100598:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005a7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005ab:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005b2:	00 
  1005b3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ba:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005c4:	89 04 24             	mov    %eax,(%esp)
  1005c7:	e8 e7 fd ff ff       	call   1003b3 <stab_binsearch>
    if (lfile == 0)
  1005cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005cf:	85 c0                	test   %eax,%eax
  1005d1:	75 0a                	jne    1005dd <debuginfo_eip+0xd4>
        return -1;
  1005d3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005d8:	e9 67 02 00 00       	jmp    100844 <debuginfo_eip+0x33b>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005e0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1005e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1005e6:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1005e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ec:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005f0:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1005f7:	00 
  1005f8:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1005fb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ff:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100602:	89 44 24 04          	mov    %eax,0x4(%esp)
  100606:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100609:	89 04 24             	mov    %eax,(%esp)
  10060c:	e8 a2 fd ff ff       	call   1003b3 <stab_binsearch>

    if (lfun <= rfun) {
  100611:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100614:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100617:	39 c2                	cmp    %eax,%edx
  100619:	7f 7c                	jg     100697 <debuginfo_eip+0x18e>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10061b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10061e:	89 c2                	mov    %eax,%edx
  100620:	89 d0                	mov    %edx,%eax
  100622:	01 c0                	add    %eax,%eax
  100624:	01 d0                	add    %edx,%eax
  100626:	c1 e0 02             	shl    $0x2,%eax
  100629:	89 c2                	mov    %eax,%edx
  10062b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10062e:	01 d0                	add    %edx,%eax
  100630:	8b 10                	mov    (%eax),%edx
  100632:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100635:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100638:	29 c1                	sub    %eax,%ecx
  10063a:	89 c8                	mov    %ecx,%eax
  10063c:	39 c2                	cmp    %eax,%edx
  10063e:	73 22                	jae    100662 <debuginfo_eip+0x159>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100640:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100643:	89 c2                	mov    %eax,%edx
  100645:	89 d0                	mov    %edx,%eax
  100647:	01 c0                	add    %eax,%eax
  100649:	01 d0                	add    %edx,%eax
  10064b:	c1 e0 02             	shl    $0x2,%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100653:	01 d0                	add    %edx,%eax
  100655:	8b 10                	mov    (%eax),%edx
  100657:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10065a:	01 c2                	add    %eax,%edx
  10065c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10065f:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100662:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100665:	89 c2                	mov    %eax,%edx
  100667:	89 d0                	mov    %edx,%eax
  100669:	01 c0                	add    %eax,%eax
  10066b:	01 d0                	add    %edx,%eax
  10066d:	c1 e0 02             	shl    $0x2,%eax
  100670:	89 c2                	mov    %eax,%edx
  100672:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100675:	01 d0                	add    %edx,%eax
  100677:	8b 50 08             	mov    0x8(%eax),%edx
  10067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10067d:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100680:	8b 45 0c             	mov    0xc(%ebp),%eax
  100683:	8b 40 10             	mov    0x10(%eax),%eax
  100686:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100689:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  10068f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100692:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100695:	eb 15                	jmp    1006ac <debuginfo_eip+0x1a3>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100697:	8b 45 0c             	mov    0xc(%ebp),%eax
  10069a:	8b 55 08             	mov    0x8(%ebp),%edx
  10069d:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a3:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006af:	8b 40 08             	mov    0x8(%eax),%eax
  1006b2:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006b9:	00 
  1006ba:	89 04 24             	mov    %eax,(%esp)
  1006bd:	e8 a8 2a 00 00       	call   10316a <strfind>
  1006c2:	89 c2                	mov    %eax,%edx
  1006c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c7:	8b 40 08             	mov    0x8(%eax),%eax
  1006ca:	29 c2                	sub    %eax,%edx
  1006cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006cf:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006d5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006d9:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1006e0:	00 
  1006e1:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1006e4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006e8:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1006eb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006f2:	89 04 24             	mov    %eax,(%esp)
  1006f5:	e8 b9 fc ff ff       	call   1003b3 <stab_binsearch>
    if (lline <= rline) {
  1006fa:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1006fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100700:	39 c2                	cmp    %eax,%edx
  100702:	7f 24                	jg     100728 <debuginfo_eip+0x21f>
        info->eip_line = stabs[rline].n_desc;
  100704:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100707:	89 c2                	mov    %eax,%edx
  100709:	89 d0                	mov    %edx,%eax
  10070b:	01 c0                	add    %eax,%eax
  10070d:	01 d0                	add    %edx,%eax
  10070f:	c1 e0 02             	shl    $0x2,%eax
  100712:	89 c2                	mov    %eax,%edx
  100714:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100717:	01 d0                	add    %edx,%eax
  100719:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10071d:	0f b7 d0             	movzwl %ax,%edx
  100720:	8b 45 0c             	mov    0xc(%ebp),%eax
  100723:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100726:	eb 13                	jmp    10073b <debuginfo_eip+0x232>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  100728:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10072d:	e9 12 01 00 00       	jmp    100844 <debuginfo_eip+0x33b>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100732:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100735:	83 e8 01             	sub    $0x1,%eax
  100738:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10073b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10073e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100741:	39 c2                	cmp    %eax,%edx
  100743:	7c 56                	jl     10079b <debuginfo_eip+0x292>
           && stabs[lline].n_type != N_SOL
  100745:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100748:	89 c2                	mov    %eax,%edx
  10074a:	89 d0                	mov    %edx,%eax
  10074c:	01 c0                	add    %eax,%eax
  10074e:	01 d0                	add    %edx,%eax
  100750:	c1 e0 02             	shl    $0x2,%eax
  100753:	89 c2                	mov    %eax,%edx
  100755:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100758:	01 d0                	add    %edx,%eax
  10075a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10075e:	3c 84                	cmp    $0x84,%al
  100760:	74 39                	je     10079b <debuginfo_eip+0x292>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100762:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100765:	89 c2                	mov    %eax,%edx
  100767:	89 d0                	mov    %edx,%eax
  100769:	01 c0                	add    %eax,%eax
  10076b:	01 d0                	add    %edx,%eax
  10076d:	c1 e0 02             	shl    $0x2,%eax
  100770:	89 c2                	mov    %eax,%edx
  100772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100775:	01 d0                	add    %edx,%eax
  100777:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077b:	3c 64                	cmp    $0x64,%al
  10077d:	75 b3                	jne    100732 <debuginfo_eip+0x229>
  10077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100782:	89 c2                	mov    %eax,%edx
  100784:	89 d0                	mov    %edx,%eax
  100786:	01 c0                	add    %eax,%eax
  100788:	01 d0                	add    %edx,%eax
  10078a:	c1 e0 02             	shl    $0x2,%eax
  10078d:	89 c2                	mov    %eax,%edx
  10078f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100792:	01 d0                	add    %edx,%eax
  100794:	8b 40 08             	mov    0x8(%eax),%eax
  100797:	85 c0                	test   %eax,%eax
  100799:	74 97                	je     100732 <debuginfo_eip+0x229>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10079b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10079e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007a1:	39 c2                	cmp    %eax,%edx
  1007a3:	7c 46                	jl     1007eb <debuginfo_eip+0x2e2>
  1007a5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007a8:	89 c2                	mov    %eax,%edx
  1007aa:	89 d0                	mov    %edx,%eax
  1007ac:	01 c0                	add    %eax,%eax
  1007ae:	01 d0                	add    %edx,%eax
  1007b0:	c1 e0 02             	shl    $0x2,%eax
  1007b3:	89 c2                	mov    %eax,%edx
  1007b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007b8:	01 d0                	add    %edx,%eax
  1007ba:	8b 10                	mov    (%eax),%edx
  1007bc:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007c2:	29 c1                	sub    %eax,%ecx
  1007c4:	89 c8                	mov    %ecx,%eax
  1007c6:	39 c2                	cmp    %eax,%edx
  1007c8:	73 21                	jae    1007eb <debuginfo_eip+0x2e2>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007ca:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007cd:	89 c2                	mov    %eax,%edx
  1007cf:	89 d0                	mov    %edx,%eax
  1007d1:	01 c0                	add    %eax,%eax
  1007d3:	01 d0                	add    %edx,%eax
  1007d5:	c1 e0 02             	shl    $0x2,%eax
  1007d8:	89 c2                	mov    %eax,%edx
  1007da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007dd:	01 d0                	add    %edx,%eax
  1007df:	8b 10                	mov    (%eax),%edx
  1007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007e4:	01 c2                	add    %eax,%edx
  1007e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007e9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007eb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1007f1:	39 c2                	cmp    %eax,%edx
  1007f3:	7d 4a                	jge    10083f <debuginfo_eip+0x336>
        for (lline = lfun + 1;
  1007f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1007f8:	83 c0 01             	add    $0x1,%eax
  1007fb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1007fe:	eb 18                	jmp    100818 <debuginfo_eip+0x30f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100800:	8b 45 0c             	mov    0xc(%ebp),%eax
  100803:	8b 40 14             	mov    0x14(%eax),%eax
  100806:	8d 50 01             	lea    0x1(%eax),%edx
  100809:	8b 45 0c             	mov    0xc(%ebp),%eax
  10080c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10080f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100812:	83 c0 01             	add    $0x1,%eax
  100815:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100818:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10081b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10081e:	39 c2                	cmp    %eax,%edx
  100820:	7d 1d                	jge    10083f <debuginfo_eip+0x336>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100822:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100825:	89 c2                	mov    %eax,%edx
  100827:	89 d0                	mov    %edx,%eax
  100829:	01 c0                	add    %eax,%eax
  10082b:	01 d0                	add    %edx,%eax
  10082d:	c1 e0 02             	shl    $0x2,%eax
  100830:	89 c2                	mov    %eax,%edx
  100832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100835:	01 d0                	add    %edx,%eax
  100837:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10083b:	3c a0                	cmp    $0xa0,%al
  10083d:	74 c1                	je     100800 <debuginfo_eip+0x2f7>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10083f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100844:	c9                   	leave  
  100845:	c3                   	ret    

00100846 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100846:	55                   	push   %ebp
  100847:	89 e5                	mov    %esp,%ebp
  100849:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10084c:	c7 04 24 36 35 10 00 	movl   $0x103536,(%esp)
  100853:	e8 ba fa ff ff       	call   100312 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100858:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10085f:	00 
  100860:	c7 04 24 4f 35 10 00 	movl   $0x10354f,(%esp)
  100867:	e8 a6 fa ff ff       	call   100312 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10086c:	c7 44 24 04 7f 34 10 	movl   $0x10347f,0x4(%esp)
  100873:	00 
  100874:	c7 04 24 67 35 10 00 	movl   $0x103567,(%esp)
  10087b:	e8 92 fa ff ff       	call   100312 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100880:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100887:	00 
  100888:	c7 04 24 7f 35 10 00 	movl   $0x10357f,(%esp)
  10088f:	e8 7e fa ff ff       	call   100312 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100894:	c7 44 24 04 20 fd 10 	movl   $0x10fd20,0x4(%esp)
  10089b:	00 
  10089c:	c7 04 24 97 35 10 00 	movl   $0x103597,(%esp)
  1008a3:	e8 6a fa ff ff       	call   100312 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008a8:	b8 20 fd 10 00       	mov    $0x10fd20,%eax
  1008ad:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008b3:	b8 00 00 10 00       	mov    $0x100000,%eax
  1008b8:	29 c2                	sub    %eax,%edx
  1008ba:	89 d0                	mov    %edx,%eax
  1008bc:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c2:	85 c0                	test   %eax,%eax
  1008c4:	0f 48 c2             	cmovs  %edx,%eax
  1008c7:	c1 f8 0a             	sar    $0xa,%eax
  1008ca:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ce:	c7 04 24 b0 35 10 00 	movl   $0x1035b0,(%esp)
  1008d5:	e8 38 fa ff ff       	call   100312 <cprintf>
}
  1008da:	c9                   	leave  
  1008db:	c3                   	ret    

001008dc <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008dc:	55                   	push   %ebp
  1008dd:	89 e5                	mov    %esp,%ebp
  1008df:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008e5:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1008ef:	89 04 24             	mov    %eax,(%esp)
  1008f2:	e8 12 fc ff ff       	call   100509 <debuginfo_eip>
  1008f7:	85 c0                	test   %eax,%eax
  1008f9:	74 15                	je     100910 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1008fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1008fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  100902:	c7 04 24 da 35 10 00 	movl   $0x1035da,(%esp)
  100909:	e8 04 fa ff ff       	call   100312 <cprintf>
  10090e:	eb 6d                	jmp    10097d <print_debuginfo+0xa1>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100917:	eb 1c                	jmp    100935 <print_debuginfo+0x59>
            fnname[j] = info.eip_fn_name[j];
  100919:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10091c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10091f:	01 d0                	add    %edx,%eax
  100921:	0f b6 00             	movzbl (%eax),%eax
  100924:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  10092a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10092d:	01 ca                	add    %ecx,%edx
  10092f:	88 02                	mov    %al,(%edx)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100931:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100935:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100938:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10093b:	7f dc                	jg     100919 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10093d:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100943:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100946:	01 d0                	add    %edx,%eax
  100948:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  10094b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10094e:	8b 55 08             	mov    0x8(%ebp),%edx
  100951:	89 d1                	mov    %edx,%ecx
  100953:	29 c1                	sub    %eax,%ecx
  100955:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100958:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10095b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10095f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100965:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100969:	89 54 24 08          	mov    %edx,0x8(%esp)
  10096d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100971:	c7 04 24 f6 35 10 00 	movl   $0x1035f6,(%esp)
  100978:	e8 95 f9 ff ff       	call   100312 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10097d:	c9                   	leave  
  10097e:	c3                   	ret    

0010097f <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10097f:	55                   	push   %ebp
  100980:	89 e5                	mov    %esp,%ebp
  100982:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100985:	8b 45 04             	mov    0x4(%ebp),%eax
  100988:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  10098b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10098e:	c9                   	leave  
  10098f:	c3                   	ret    

00100990 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100990:	55                   	push   %ebp
  100991:	89 e5                	mov    %esp,%ebp
  100993:	83 ec 38             	sub    $0x38,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100996:	89 e8                	mov    %ebp,%eax
  100998:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return ebp;
  10099b:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
  10099e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	uint32_t eip = read_eip();
  1009a1:	e8 d9 ff ff ff       	call   10097f <read_eip>
  1009a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int i,j = 0;
  1009a9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
  1009b0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009b7:	e9 88 00 00 00       	jmp    100a44 <print_stackframe+0xb4>
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
  1009bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009bf:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009ca:	c7 04 24 08 36 10 00 	movl   $0x103608,(%esp)
  1009d1:	e8 3c f9 ff ff       	call   100312 <cprintf>
		uint32_t* arguments = (uint32_t*)ebp + 2;
  1009d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d9:	83 c0 08             	add    $0x8,%eax
  1009dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		for(j = 0;j < 4;j++)
  1009df:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009e6:	eb 25                	jmp    100a0d <print_stackframe+0x7d>
			cprintf("0x%08x ",arguments[j]);
  1009e8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  1009f2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1009f5:	01 d0                	add    %edx,%eax
  1009f7:	8b 00                	mov    (%eax),%eax
  1009f9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009fd:	c7 04 24 25 36 10 00 	movl   $0x103625,(%esp)
  100a04:	e8 09 f9 ff ff       	call   100312 <cprintf>
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
		cprintf("ebp:0x%08x eip:0x%08x args: ",ebp,eip);
		uint32_t* arguments = (uint32_t*)ebp + 2;
		for(j = 0;j < 4;j++)
  100a09:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a0d:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a11:	7e d5                	jle    1009e8 <print_stackframe+0x58>
			cprintf("0x%08x ",arguments[j]);
		cprintf("\n");
  100a13:	c7 04 24 2d 36 10 00 	movl   $0x10362d,(%esp)
  100a1a:	e8 f3 f8 ff ff       	call   100312 <cprintf>
		print_debuginfo(eip - 1);
  100a1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a22:	83 e8 01             	sub    $0x1,%eax
  100a25:	89 04 24             	mov    %eax,(%esp)
  100a28:	e8 af fe ff ff       	call   1008dc <print_debuginfo>
		eip = *((uint32_t*)ebp + 1);
  100a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a30:	83 c0 04             	add    $0x4,%eax
  100a33:	8b 00                	mov    (%eax),%eax
  100a35:	89 45 f0             	mov    %eax,-0x10(%ebp)
		ebp = *((uint32_t*)ebp);
  100a38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a3b:	8b 00                	mov    (%eax),%eax
  100a3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
	uint32_t ebp = read_ebp();
	uint32_t eip = read_eip();
	int i,j = 0;
	for(i = 0;i < STACKFRAME_DEPTH && ebp != 0;i++) {
  100a40:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a44:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a48:	7f 0a                	jg     100a54 <print_stackframe+0xc4>
  100a4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a4e:	0f 85 68 ff ff ff    	jne    1009bc <print_stackframe+0x2c>
		cprintf("\n");
		print_debuginfo(eip - 1);
		eip = *((uint32_t*)ebp + 1);
		ebp = *((uint32_t*)ebp);
	}
}
  100a54:	c9                   	leave  
  100a55:	c3                   	ret    

00100a56 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a56:	55                   	push   %ebp
  100a57:	89 e5                	mov    %esp,%ebp
  100a59:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a63:	eb 0c                	jmp    100a71 <parse+0x1b>
            *buf ++ = '\0';
  100a65:	8b 45 08             	mov    0x8(%ebp),%eax
  100a68:	8d 50 01             	lea    0x1(%eax),%edx
  100a6b:	89 55 08             	mov    %edx,0x8(%ebp)
  100a6e:	c6 00 00             	movb   $0x0,(%eax)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a71:	8b 45 08             	mov    0x8(%ebp),%eax
  100a74:	0f b6 00             	movzbl (%eax),%eax
  100a77:	84 c0                	test   %al,%al
  100a79:	74 1d                	je     100a98 <parse+0x42>
  100a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  100a7e:	0f b6 00             	movzbl (%eax),%eax
  100a81:	0f be c0             	movsbl %al,%eax
  100a84:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a88:	c7 04 24 b0 36 10 00 	movl   $0x1036b0,(%esp)
  100a8f:	e8 a3 26 00 00       	call   103137 <strchr>
  100a94:	85 c0                	test   %eax,%eax
  100a96:	75 cd                	jne    100a65 <parse+0xf>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100a98:	8b 45 08             	mov    0x8(%ebp),%eax
  100a9b:	0f b6 00             	movzbl (%eax),%eax
  100a9e:	84 c0                	test   %al,%al
  100aa0:	75 02                	jne    100aa4 <parse+0x4e>
            break;
  100aa2:	eb 67                	jmp    100b0b <parse+0xb5>
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100aa4:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100aa8:	75 14                	jne    100abe <parse+0x68>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100aaa:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100ab1:	00 
  100ab2:	c7 04 24 b5 36 10 00 	movl   $0x1036b5,(%esp)
  100ab9:	e8 54 f8 ff ff       	call   100312 <cprintf>
        }
        argv[argc ++] = buf;
  100abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ac1:	8d 50 01             	lea    0x1(%eax),%edx
  100ac4:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100ac7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100ace:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ad1:	01 c2                	add    %eax,%edx
  100ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  100ad6:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ad8:	eb 04                	jmp    100ade <parse+0x88>
            buf ++;
  100ada:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ade:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae1:	0f b6 00             	movzbl (%eax),%eax
  100ae4:	84 c0                	test   %al,%al
  100ae6:	74 1d                	je     100b05 <parse+0xaf>
  100ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  100aeb:	0f b6 00             	movzbl (%eax),%eax
  100aee:	0f be c0             	movsbl %al,%eax
  100af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100af5:	c7 04 24 b0 36 10 00 	movl   $0x1036b0,(%esp)
  100afc:	e8 36 26 00 00       	call   103137 <strchr>
  100b01:	85 c0                	test   %eax,%eax
  100b03:	74 d5                	je     100ada <parse+0x84>
            buf ++;
        }
    }
  100b05:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b06:	e9 66 ff ff ff       	jmp    100a71 <parse+0x1b>
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b0e:	c9                   	leave  
  100b0f:	c3                   	ret    

00100b10 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b10:	55                   	push   %ebp
  100b11:	89 e5                	mov    %esp,%ebp
  100b13:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b16:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b19:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  100b20:	89 04 24             	mov    %eax,(%esp)
  100b23:	e8 2e ff ff ff       	call   100a56 <parse>
  100b28:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b2b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b2f:	75 0a                	jne    100b3b <runcmd+0x2b>
        return 0;
  100b31:	b8 00 00 00 00       	mov    $0x0,%eax
  100b36:	e9 85 00 00 00       	jmp    100bc0 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b42:	eb 5c                	jmp    100ba0 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b44:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b47:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4a:	89 d0                	mov    %edx,%eax
  100b4c:	01 c0                	add    %eax,%eax
  100b4e:	01 d0                	add    %edx,%eax
  100b50:	c1 e0 02             	shl    $0x2,%eax
  100b53:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b58:	8b 00                	mov    (%eax),%eax
  100b5a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b5e:	89 04 24             	mov    %eax,(%esp)
  100b61:	e8 32 25 00 00       	call   103098 <strcmp>
  100b66:	85 c0                	test   %eax,%eax
  100b68:	75 32                	jne    100b9c <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b6a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b6d:	89 d0                	mov    %edx,%eax
  100b6f:	01 c0                	add    %eax,%eax
  100b71:	01 d0                	add    %edx,%eax
  100b73:	c1 e0 02             	shl    $0x2,%eax
  100b76:	05 00 e0 10 00       	add    $0x10e000,%eax
  100b7b:	8b 40 08             	mov    0x8(%eax),%eax
  100b7e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100b81:	8d 4a ff             	lea    -0x1(%edx),%ecx
  100b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  100b87:	89 54 24 08          	mov    %edx,0x8(%esp)
  100b8b:	8d 55 b0             	lea    -0x50(%ebp),%edx
  100b8e:	83 c2 04             	add    $0x4,%edx
  100b91:	89 54 24 04          	mov    %edx,0x4(%esp)
  100b95:	89 0c 24             	mov    %ecx,(%esp)
  100b98:	ff d0                	call   *%eax
  100b9a:	eb 24                	jmp    100bc0 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b9c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba3:	83 f8 02             	cmp    $0x2,%eax
  100ba6:	76 9c                	jbe    100b44 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100ba8:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  100baf:	c7 04 24 d3 36 10 00 	movl   $0x1036d3,(%esp)
  100bb6:	e8 57 f7 ff ff       	call   100312 <cprintf>
    return 0;
  100bbb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc0:	c9                   	leave  
  100bc1:	c3                   	ret    

00100bc2 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bc2:	55                   	push   %ebp
  100bc3:	89 e5                	mov    %esp,%ebp
  100bc5:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bc8:	c7 04 24 ec 36 10 00 	movl   $0x1036ec,(%esp)
  100bcf:	e8 3e f7 ff ff       	call   100312 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd4:	c7 04 24 14 37 10 00 	movl   $0x103714,(%esp)
  100bdb:	e8 32 f7 ff ff       	call   100312 <cprintf>

    if (tf != NULL) {
  100be0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be4:	74 0b                	je     100bf1 <kmonitor+0x2f>
        print_trapframe(tf);
  100be6:	8b 45 08             	mov    0x8(%ebp),%eax
  100be9:	89 04 24             	mov    %eax,(%esp)
  100bec:	e8 d4 0d 00 00       	call   1019c5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf1:	c7 04 24 39 37 10 00 	movl   $0x103739,(%esp)
  100bf8:	e8 0c f6 ff ff       	call   100209 <readline>
  100bfd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c04:	74 18                	je     100c1e <kmonitor+0x5c>
            if (runcmd(buf, tf) < 0) {
  100c06:	8b 45 08             	mov    0x8(%ebp),%eax
  100c09:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c10:	89 04 24             	mov    %eax,(%esp)
  100c13:	e8 f8 fe ff ff       	call   100b10 <runcmd>
  100c18:	85 c0                	test   %eax,%eax
  100c1a:	79 02                	jns    100c1e <kmonitor+0x5c>
                break;
  100c1c:	eb 02                	jmp    100c20 <kmonitor+0x5e>
            }
        }
    }
  100c1e:	eb d1                	jmp    100bf1 <kmonitor+0x2f>
}
  100c20:	c9                   	leave  
  100c21:	c3                   	ret    

00100c22 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c22:	55                   	push   %ebp
  100c23:	89 e5                	mov    %esp,%ebp
  100c25:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c28:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c2f:	eb 3f                	jmp    100c70 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c34:	89 d0                	mov    %edx,%eax
  100c36:	01 c0                	add    %eax,%eax
  100c38:	01 d0                	add    %edx,%eax
  100c3a:	c1 e0 02             	shl    $0x2,%eax
  100c3d:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c42:	8b 48 04             	mov    0x4(%eax),%ecx
  100c45:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c48:	89 d0                	mov    %edx,%eax
  100c4a:	01 c0                	add    %eax,%eax
  100c4c:	01 d0                	add    %edx,%eax
  100c4e:	c1 e0 02             	shl    $0x2,%eax
  100c51:	05 00 e0 10 00       	add    $0x10e000,%eax
  100c56:	8b 00                	mov    (%eax),%eax
  100c58:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c5c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c60:	c7 04 24 3d 37 10 00 	movl   $0x10373d,(%esp)
  100c67:	e8 a6 f6 ff ff       	call   100312 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c6c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c73:	83 f8 02             	cmp    $0x2,%eax
  100c76:	76 b9                	jbe    100c31 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c78:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c7d:	c9                   	leave  
  100c7e:	c3                   	ret    

00100c7f <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c7f:	55                   	push   %ebp
  100c80:	89 e5                	mov    %esp,%ebp
  100c82:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c85:	e8 bc fb ff ff       	call   100846 <print_kerninfo>
    return 0;
  100c8a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8f:	c9                   	leave  
  100c90:	c3                   	ret    

00100c91 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c91:	55                   	push   %ebp
  100c92:	89 e5                	mov    %esp,%ebp
  100c94:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c97:	e8 f4 fc ff ff       	call   100990 <print_stackframe>
    return 0;
  100c9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca1:	c9                   	leave  
  100ca2:	c3                   	ret    

00100ca3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca3:	55                   	push   %ebp
  100ca4:	89 e5                	mov    %esp,%ebp
  100ca6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100ca9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  100cae:	85 c0                	test   %eax,%eax
  100cb0:	74 02                	je     100cb4 <__panic+0x11>
        goto panic_dead;
  100cb2:	eb 48                	jmp    100cfc <__panic+0x59>
    }
    is_panic = 1;
  100cb4:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  100cbb:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cbe:	8d 45 14             	lea    0x14(%ebp),%eax
  100cc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  100cc7:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  100cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd2:	c7 04 24 46 37 10 00 	movl   $0x103746,(%esp)
  100cd9:	e8 34 f6 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100cde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce1:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ce5:	8b 45 10             	mov    0x10(%ebp),%eax
  100ce8:	89 04 24             	mov    %eax,(%esp)
  100ceb:	e8 ef f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100cf0:	c7 04 24 62 37 10 00 	movl   $0x103762,(%esp)
  100cf7:	e8 16 f6 ff ff       	call   100312 <cprintf>
    va_end(ap);

panic_dead:
    intr_disable();
  100cfc:	e8 22 09 00 00       	call   101623 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d01:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d08:	e8 b5 fe ff ff       	call   100bc2 <kmonitor>
    }
  100d0d:	eb f2                	jmp    100d01 <__panic+0x5e>

00100d0f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d0f:	55                   	push   %ebp
  100d10:	89 e5                	mov    %esp,%ebp
  100d12:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d15:	8d 45 14             	lea    0x14(%ebp),%eax
  100d18:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d1e:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d22:	8b 45 08             	mov    0x8(%ebp),%eax
  100d25:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d29:	c7 04 24 64 37 10 00 	movl   $0x103764,(%esp)
  100d30:	e8 dd f5 ff ff       	call   100312 <cprintf>
    vcprintf(fmt, ap);
  100d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d38:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d3c:	8b 45 10             	mov    0x10(%ebp),%eax
  100d3f:	89 04 24             	mov    %eax,(%esp)
  100d42:	e8 98 f5 ff ff       	call   1002df <vcprintf>
    cprintf("\n");
  100d47:	c7 04 24 62 37 10 00 	movl   $0x103762,(%esp)
  100d4e:	e8 bf f5 ff ff       	call   100312 <cprintf>
    va_end(ap);
}
  100d53:	c9                   	leave  
  100d54:	c3                   	ret    

00100d55 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d55:	55                   	push   %ebp
  100d56:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d58:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100d5d:	5d                   	pop    %ebp
  100d5e:	c3                   	ret    

00100d5f <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d5f:	55                   	push   %ebp
  100d60:	89 e5                	mov    %esp,%ebp
  100d62:	83 ec 28             	sub    $0x28,%esp
  100d65:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d6b:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d6f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d73:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d77:	ee                   	out    %al,(%dx)
  100d78:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d7e:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d82:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d86:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d8a:	ee                   	out    %al,(%dx)
  100d8b:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d91:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100d95:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d99:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d9d:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d9e:	c7 05 08 f9 10 00 00 	movl   $0x0,0x10f908
  100da5:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100da8:	c7 04 24 82 37 10 00 	movl   $0x103782,(%esp)
  100daf:	e8 5e f5 ff ff       	call   100312 <cprintf>
    pic_enable(IRQ_TIMER);
  100db4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dbb:	e8 c1 08 00 00       	call   101681 <pic_enable>
}
  100dc0:	c9                   	leave  
  100dc1:	c3                   	ret    

00100dc2 <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100dc2:	55                   	push   %ebp
  100dc3:	89 e5                	mov    %esp,%ebp
  100dc5:	83 ec 10             	sub    $0x10,%esp
  100dc8:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100dce:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dd2:	89 c2                	mov    %eax,%edx
  100dd4:	ec                   	in     (%dx),%al
  100dd5:	88 45 fd             	mov    %al,-0x3(%ebp)
  100dd8:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dde:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100de2:	89 c2                	mov    %eax,%edx
  100de4:	ec                   	in     (%dx),%al
  100de5:	88 45 f9             	mov    %al,-0x7(%ebp)
  100de8:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dee:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100df2:	89 c2                	mov    %eax,%edx
  100df4:	ec                   	in     (%dx),%al
  100df5:	88 45 f5             	mov    %al,-0xb(%ebp)
  100df8:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
  100dfe:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e02:	89 c2                	mov    %eax,%edx
  100e04:	ec                   	in     (%dx),%al
  100e05:	88 45 f1             	mov    %al,-0xf(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e08:	c9                   	leave  
  100e09:	c3                   	ret    

00100e0a <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e0a:	55                   	push   %ebp
  100e0b:	89 e5                	mov    %esp,%ebp
  100e0d:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;
  100e10:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e1a:	0f b7 00             	movzwl (%eax),%eax
  100e1d:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e24:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e29:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2c:	0f b7 00             	movzwl (%eax),%eax
  100e2f:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100e33:	74 12                	je     100e47 <cga_init+0x3d>
        cp = (uint16_t*)MONO_BUF;
  100e35:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e3c:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e43:	b4 03 
  100e45:	eb 13                	jmp    100e5a <cga_init+0x50>
    } else {
        *cp = was;
  100e47:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e4a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e4e:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100e51:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e58:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100e5a:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e61:	0f b7 c0             	movzwl %ax,%eax
  100e64:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  100e68:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e6c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100e70:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e74:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100e75:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e7c:	83 c0 01             	add    $0x1,%eax
  100e7f:	0f b7 c0             	movzwl %ax,%eax
  100e82:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e86:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100e8a:	89 c2                	mov    %eax,%edx
  100e8c:	ec                   	in     (%dx),%al
  100e8d:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100e90:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e94:	0f b6 c0             	movzbl %al,%eax
  100e97:	c1 e0 08             	shl    $0x8,%eax
  100e9a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e9d:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ea4:	0f b7 c0             	movzwl %ax,%eax
  100ea7:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  100eab:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100eaf:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100eb3:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100eb7:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100eb8:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100ebf:	83 c0 01             	add    $0x1,%eax
  100ec2:	0f b7 c0             	movzwl %ax,%eax
  100ec5:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ec9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
  100ecd:	89 c2                	mov    %eax,%edx
  100ecf:	ec                   	in     (%dx),%al
  100ed0:	88 45 e5             	mov    %al,-0x1b(%ebp)
    return data;
  100ed3:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ed7:	0f b6 c0             	movzbl %al,%eax
  100eda:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100ee0:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;
  100ee5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ee8:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100eee:	c9                   	leave  
  100eef:	c3                   	ret    

00100ef0 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ef0:	55                   	push   %ebp
  100ef1:	89 e5                	mov    %esp,%ebp
  100ef3:	83 ec 48             	sub    $0x48,%esp
  100ef6:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100efc:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100f00:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f04:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f08:	ee                   	out    %al,(%dx)
  100f09:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f0f:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f13:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f17:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100f1b:	ee                   	out    %al,(%dx)
  100f1c:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100f22:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100f26:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f2a:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f2e:	ee                   	out    %al,(%dx)
  100f2f:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f35:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100f39:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f3d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f41:	ee                   	out    %al,(%dx)
  100f42:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100f48:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100f4c:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f50:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f54:	ee                   	out    %al,(%dx)
  100f55:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100f5b:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100f5f:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f63:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f67:	ee                   	out    %al,(%dx)
  100f68:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f6e:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100f72:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f76:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f7a:	ee                   	out    %al,(%dx)
  100f7b:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f81:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
  100f85:	89 c2                	mov    %eax,%edx
  100f87:	ec                   	in     (%dx),%al
  100f88:	88 45 d9             	mov    %al,-0x27(%ebp)
    return data;
  100f8b:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f8f:	3c ff                	cmp    $0xff,%al
  100f91:	0f 95 c0             	setne  %al
  100f94:	0f b6 c0             	movzbl %al,%eax
  100f97:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f9c:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100fa2:	0f b7 45 d6          	movzwl -0x2a(%ebp),%eax
  100fa6:	89 c2                	mov    %eax,%edx
  100fa8:	ec                   	in     (%dx),%al
  100fa9:	88 45 d5             	mov    %al,-0x2b(%ebp)
  100fac:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
  100fb2:	0f b7 45 d2          	movzwl -0x2e(%ebp),%eax
  100fb6:	89 c2                	mov    %eax,%edx
  100fb8:	ec                   	in     (%dx),%al
  100fb9:	88 45 d1             	mov    %al,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100fbc:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100fc1:	85 c0                	test   %eax,%eax
  100fc3:	74 0c                	je     100fd1 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fc5:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fcc:	e8 b0 06 00 00       	call   101681 <pic_enable>
    }
}
  100fd1:	c9                   	leave  
  100fd2:	c3                   	ret    

00100fd3 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100fd3:	55                   	push   %ebp
  100fd4:	89 e5                	mov    %esp,%ebp
  100fd6:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fe0:	eb 09                	jmp    100feb <lpt_putc_sub+0x18>
        delay();
  100fe2:	e8 db fd ff ff       	call   100dc2 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fe7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  100feb:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100ff1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100ff5:	89 c2                	mov    %eax,%edx
  100ff7:	ec                   	in     (%dx),%al
  100ff8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100ffb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fff:	84 c0                	test   %al,%al
  101001:	78 09                	js     10100c <lpt_putc_sub+0x39>
  101003:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10100a:	7e d6                	jle    100fe2 <lpt_putc_sub+0xf>
        delay();
    }
    outb(LPTPORT + 0, c);
  10100c:	8b 45 08             	mov    0x8(%ebp),%eax
  10100f:	0f b6 c0             	movzbl %al,%eax
  101012:	66 c7 45 f6 78 03    	movw   $0x378,-0xa(%ebp)
  101018:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10101b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10101f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101023:	ee                   	out    %al,(%dx)
  101024:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  10102a:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10102e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101032:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101036:	ee                   	out    %al,(%dx)
  101037:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  10103d:	c6 45 ed 08          	movb   $0x8,-0x13(%ebp)
  101041:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101045:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101049:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  10104a:	c9                   	leave  
  10104b:	c3                   	ret    

0010104c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10104c:	55                   	push   %ebp
  10104d:	89 e5                	mov    %esp,%ebp
  10104f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101052:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101056:	74 0d                	je     101065 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101058:	8b 45 08             	mov    0x8(%ebp),%eax
  10105b:	89 04 24             	mov    %eax,(%esp)
  10105e:	e8 70 ff ff ff       	call   100fd3 <lpt_putc_sub>
  101063:	eb 24                	jmp    101089 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101065:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10106c:	e8 62 ff ff ff       	call   100fd3 <lpt_putc_sub>
        lpt_putc_sub(' ');
  101071:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101078:	e8 56 ff ff ff       	call   100fd3 <lpt_putc_sub>
        lpt_putc_sub('\b');
  10107d:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101084:	e8 4a ff ff ff       	call   100fd3 <lpt_putc_sub>
    }
}
  101089:	c9                   	leave  
  10108a:	c3                   	ret    

0010108b <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10108b:	55                   	push   %ebp
  10108c:	89 e5                	mov    %esp,%ebp
  10108e:	53                   	push   %ebx
  10108f:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101092:	8b 45 08             	mov    0x8(%ebp),%eax
  101095:	b0 00                	mov    $0x0,%al
  101097:	85 c0                	test   %eax,%eax
  101099:	75 07                	jne    1010a2 <cga_putc+0x17>
        c |= 0x0700;
  10109b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1010a5:	0f b6 c0             	movzbl %al,%eax
  1010a8:	83 f8 0a             	cmp    $0xa,%eax
  1010ab:	74 4c                	je     1010f9 <cga_putc+0x6e>
  1010ad:	83 f8 0d             	cmp    $0xd,%eax
  1010b0:	74 57                	je     101109 <cga_putc+0x7e>
  1010b2:	83 f8 08             	cmp    $0x8,%eax
  1010b5:	0f 85 88 00 00 00    	jne    101143 <cga_putc+0xb8>
    case '\b':
        if (crt_pos > 0) {
  1010bb:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010c2:	66 85 c0             	test   %ax,%ax
  1010c5:	74 30                	je     1010f7 <cga_putc+0x6c>
            crt_pos --;
  1010c7:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010ce:	83 e8 01             	sub    $0x1,%eax
  1010d1:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010d7:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1010dc:	0f b7 15 64 ee 10 00 	movzwl 0x10ee64,%edx
  1010e3:	0f b7 d2             	movzwl %dx,%edx
  1010e6:	01 d2                	add    %edx,%edx
  1010e8:	01 c2                	add    %eax,%edx
  1010ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ed:	b0 00                	mov    $0x0,%al
  1010ef:	83 c8 20             	or     $0x20,%eax
  1010f2:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010f5:	eb 72                	jmp    101169 <cga_putc+0xde>
  1010f7:	eb 70                	jmp    101169 <cga_putc+0xde>
    case '\n':
        crt_pos += CRT_COLS;
  1010f9:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101100:	83 c0 50             	add    $0x50,%eax
  101103:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101109:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  101110:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101117:	0f b7 c1             	movzwl %cx,%eax
  10111a:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  101120:	c1 e8 10             	shr    $0x10,%eax
  101123:	89 c2                	mov    %eax,%edx
  101125:	66 c1 ea 06          	shr    $0x6,%dx
  101129:	89 d0                	mov    %edx,%eax
  10112b:	c1 e0 02             	shl    $0x2,%eax
  10112e:	01 d0                	add    %edx,%eax
  101130:	c1 e0 04             	shl    $0x4,%eax
  101133:	29 c1                	sub    %eax,%ecx
  101135:	89 ca                	mov    %ecx,%edx
  101137:	89 d8                	mov    %ebx,%eax
  101139:	29 d0                	sub    %edx,%eax
  10113b:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  101141:	eb 26                	jmp    101169 <cga_putc+0xde>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  101143:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101149:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101150:	8d 50 01             	lea    0x1(%eax),%edx
  101153:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  10115a:	0f b7 c0             	movzwl %ax,%eax
  10115d:	01 c0                	add    %eax,%eax
  10115f:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  101162:	8b 45 08             	mov    0x8(%ebp),%eax
  101165:	66 89 02             	mov    %ax,(%edx)
        break;
  101168:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101169:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101170:	66 3d cf 07          	cmp    $0x7cf,%ax
  101174:	76 5b                	jbe    1011d1 <cga_putc+0x146>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101176:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10117b:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101181:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101186:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10118d:	00 
  10118e:	89 54 24 04          	mov    %edx,0x4(%esp)
  101192:	89 04 24             	mov    %eax,(%esp)
  101195:	e8 9b 21 00 00       	call   103335 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10119a:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  1011a1:	eb 15                	jmp    1011b8 <cga_putc+0x12d>
            crt_buf[i] = 0x0700 | ' ';
  1011a3:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  1011a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1011ab:	01 d2                	add    %edx,%edx
  1011ad:	01 d0                	add    %edx,%eax
  1011af:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011b4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1011b8:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011bf:	7e e2                	jle    1011a3 <cga_putc+0x118>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  1011c1:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011c8:	83 e8 50             	sub    $0x50,%eax
  1011cb:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011d1:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011d8:	0f b7 c0             	movzwl %ax,%eax
  1011db:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  1011df:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  1011e3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1011e7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1011eb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011ec:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011f3:	66 c1 e8 08          	shr    $0x8,%ax
  1011f7:	0f b6 c0             	movzbl %al,%eax
  1011fa:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101201:	83 c2 01             	add    $0x1,%edx
  101204:	0f b7 d2             	movzwl %dx,%edx
  101207:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  10120b:	88 45 ed             	mov    %al,-0x13(%ebp)
  10120e:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101212:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101216:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101217:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10121e:	0f b7 c0             	movzwl %ax,%eax
  101221:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  101225:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  101229:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10122d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101231:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101232:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101239:	0f b6 c0             	movzbl %al,%eax
  10123c:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101243:	83 c2 01             	add    $0x1,%edx
  101246:	0f b7 d2             	movzwl %dx,%edx
  101249:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  10124d:	88 45 e5             	mov    %al,-0x1b(%ebp)
  101250:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  101254:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101258:	ee                   	out    %al,(%dx)
}
  101259:	83 c4 34             	add    $0x34,%esp
  10125c:	5b                   	pop    %ebx
  10125d:	5d                   	pop    %ebp
  10125e:	c3                   	ret    

0010125f <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10125f:	55                   	push   %ebp
  101260:	89 e5                	mov    %esp,%ebp
  101262:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101265:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10126c:	eb 09                	jmp    101277 <serial_putc_sub+0x18>
        delay();
  10126e:	e8 4f fb ff ff       	call   100dc2 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101273:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  101277:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10127d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101281:	89 c2                	mov    %eax,%edx
  101283:	ec                   	in     (%dx),%al
  101284:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101287:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10128b:	0f b6 c0             	movzbl %al,%eax
  10128e:	83 e0 20             	and    $0x20,%eax
  101291:	85 c0                	test   %eax,%eax
  101293:	75 09                	jne    10129e <serial_putc_sub+0x3f>
  101295:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  10129c:	7e d0                	jle    10126e <serial_putc_sub+0xf>
        delay();
    }
    outb(COM1 + COM_TX, c);
  10129e:	8b 45 08             	mov    0x8(%ebp),%eax
  1012a1:	0f b6 c0             	movzbl %al,%eax
  1012a4:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  1012aa:	88 45 f5             	mov    %al,-0xb(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  1012ad:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1012b1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012b5:	ee                   	out    %al,(%dx)
}
  1012b6:	c9                   	leave  
  1012b7:	c3                   	ret    

001012b8 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012b8:	55                   	push   %ebp
  1012b9:	89 e5                	mov    %esp,%ebp
  1012bb:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012be:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012c2:	74 0d                	je     1012d1 <serial_putc+0x19>
        serial_putc_sub(c);
  1012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1012c7:	89 04 24             	mov    %eax,(%esp)
  1012ca:	e8 90 ff ff ff       	call   10125f <serial_putc_sub>
  1012cf:	eb 24                	jmp    1012f5 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  1012d1:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012d8:	e8 82 ff ff ff       	call   10125f <serial_putc_sub>
        serial_putc_sub(' ');
  1012dd:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012e4:	e8 76 ff ff ff       	call   10125f <serial_putc_sub>
        serial_putc_sub('\b');
  1012e9:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012f0:	e8 6a ff ff ff       	call   10125f <serial_putc_sub>
    }
}
  1012f5:	c9                   	leave  
  1012f6:	c3                   	ret    

001012f7 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012f7:	55                   	push   %ebp
  1012f8:	89 e5                	mov    %esp,%ebp
  1012fa:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012fd:	eb 33                	jmp    101332 <cons_intr+0x3b>
        if (c != 0) {
  1012ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101303:	74 2d                	je     101332 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101305:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10130a:	8d 50 01             	lea    0x1(%eax),%edx
  10130d:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101313:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101316:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10131c:	a1 84 f0 10 00       	mov    0x10f084,%eax
  101321:	3d 00 02 00 00       	cmp    $0x200,%eax
  101326:	75 0a                	jne    101332 <cons_intr+0x3b>
                cons.wpos = 0;
  101328:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10132f:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  101332:	8b 45 08             	mov    0x8(%ebp),%eax
  101335:	ff d0                	call   *%eax
  101337:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10133a:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10133e:	75 bf                	jne    1012ff <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101340:	c9                   	leave  
  101341:	c3                   	ret    

00101342 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101342:	55                   	push   %ebp
  101343:	89 e5                	mov    %esp,%ebp
  101345:	83 ec 10             	sub    $0x10,%esp
  101348:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10134e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101352:	89 c2                	mov    %eax,%edx
  101354:	ec                   	in     (%dx),%al
  101355:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101358:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10135c:	0f b6 c0             	movzbl %al,%eax
  10135f:	83 e0 01             	and    $0x1,%eax
  101362:	85 c0                	test   %eax,%eax
  101364:	75 07                	jne    10136d <serial_proc_data+0x2b>
        return -1;
  101366:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10136b:	eb 2a                	jmp    101397 <serial_proc_data+0x55>
  10136d:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101373:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101377:	89 c2                	mov    %eax,%edx
  101379:	ec                   	in     (%dx),%al
  10137a:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10137d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101381:	0f b6 c0             	movzbl %al,%eax
  101384:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101387:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10138b:	75 07                	jne    101394 <serial_proc_data+0x52>
        c = '\b';
  10138d:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101394:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101397:	c9                   	leave  
  101398:	c3                   	ret    

00101399 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101399:	55                   	push   %ebp
  10139a:	89 e5                	mov    %esp,%ebp
  10139c:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10139f:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  1013a4:	85 c0                	test   %eax,%eax
  1013a6:	74 0c                	je     1013b4 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  1013a8:	c7 04 24 42 13 10 00 	movl   $0x101342,(%esp)
  1013af:	e8 43 ff ff ff       	call   1012f7 <cons_intr>
    }
}
  1013b4:	c9                   	leave  
  1013b5:	c3                   	ret    

001013b6 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013b6:	55                   	push   %ebp
  1013b7:	89 e5                	mov    %esp,%ebp
  1013b9:	83 ec 38             	sub    $0x38,%esp
  1013bc:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013c2:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1013c6:	89 c2                	mov    %eax,%edx
  1013c8:	ec                   	in     (%dx),%al
  1013c9:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013cc:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013d0:	0f b6 c0             	movzbl %al,%eax
  1013d3:	83 e0 01             	and    $0x1,%eax
  1013d6:	85 c0                	test   %eax,%eax
  1013d8:	75 0a                	jne    1013e4 <kbd_proc_data+0x2e>
        return -1;
  1013da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013df:	e9 59 01 00 00       	jmp    10153d <kbd_proc_data+0x187>
  1013e4:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void ltr(uint16_t sel) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013ea:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1013ee:	89 c2                	mov    %eax,%edx
  1013f0:	ec                   	in     (%dx),%al
  1013f1:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013f4:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013f8:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013fb:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013ff:	75 17                	jne    101418 <kbd_proc_data+0x62>
        // E0 escape character
        shift |= E0ESC;
  101401:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101406:	83 c8 40             	or     $0x40,%eax
  101409:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10140e:	b8 00 00 00 00       	mov    $0x0,%eax
  101413:	e9 25 01 00 00       	jmp    10153d <kbd_proc_data+0x187>
    } else if (data & 0x80) {
  101418:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141c:	84 c0                	test   %al,%al
  10141e:	79 47                	jns    101467 <kbd_proc_data+0xb1>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101420:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101425:	83 e0 40             	and    $0x40,%eax
  101428:	85 c0                	test   %eax,%eax
  10142a:	75 09                	jne    101435 <kbd_proc_data+0x7f>
  10142c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101430:	83 e0 7f             	and    $0x7f,%eax
  101433:	eb 04                	jmp    101439 <kbd_proc_data+0x83>
  101435:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101439:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10143c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101440:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101447:	83 c8 40             	or     $0x40,%eax
  10144a:	0f b6 c0             	movzbl %al,%eax
  10144d:	f7 d0                	not    %eax
  10144f:	89 c2                	mov    %eax,%edx
  101451:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101456:	21 d0                	and    %edx,%eax
  101458:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  10145d:	b8 00 00 00 00       	mov    $0x0,%eax
  101462:	e9 d6 00 00 00       	jmp    10153d <kbd_proc_data+0x187>
    } else if (shift & E0ESC) {
  101467:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10146c:	83 e0 40             	and    $0x40,%eax
  10146f:	85 c0                	test   %eax,%eax
  101471:	74 11                	je     101484 <kbd_proc_data+0xce>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  101473:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101477:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10147c:	83 e0 bf             	and    $0xffffffbf,%eax
  10147f:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101484:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101488:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10148f:	0f b6 d0             	movzbl %al,%edx
  101492:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101497:	09 d0                	or     %edx,%eax
  101499:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10149e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a2:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  1014a9:	0f b6 d0             	movzbl %al,%edx
  1014ac:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014b1:	31 d0                	xor    %edx,%eax
  1014b3:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014b8:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014bd:	83 e0 03             	and    $0x3,%eax
  1014c0:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014c7:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014cb:	01 d0                	add    %edx,%eax
  1014cd:	0f b6 00             	movzbl (%eax),%eax
  1014d0:	0f b6 c0             	movzbl %al,%eax
  1014d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014d6:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014db:	83 e0 08             	and    $0x8,%eax
  1014de:	85 c0                	test   %eax,%eax
  1014e0:	74 22                	je     101504 <kbd_proc_data+0x14e>
        if ('a' <= c && c <= 'z')
  1014e2:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014e6:	7e 0c                	jle    1014f4 <kbd_proc_data+0x13e>
  1014e8:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014ec:	7f 06                	jg     1014f4 <kbd_proc_data+0x13e>
            c += 'A' - 'a';
  1014ee:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014f2:	eb 10                	jmp    101504 <kbd_proc_data+0x14e>
        else if ('A' <= c && c <= 'Z')
  1014f4:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014f8:	7e 0a                	jle    101504 <kbd_proc_data+0x14e>
  1014fa:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014fe:	7f 04                	jg     101504 <kbd_proc_data+0x14e>
            c += 'a' - 'A';
  101500:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101504:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101509:	f7 d0                	not    %eax
  10150b:	83 e0 06             	and    $0x6,%eax
  10150e:	85 c0                	test   %eax,%eax
  101510:	75 28                	jne    10153a <kbd_proc_data+0x184>
  101512:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101519:	75 1f                	jne    10153a <kbd_proc_data+0x184>
        cprintf("Rebooting!\n");
  10151b:	c7 04 24 9d 37 10 00 	movl   $0x10379d,(%esp)
  101522:	e8 eb ed ff ff       	call   100312 <cprintf>
  101527:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10152d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101531:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101535:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101539:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  10153a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10153d:	c9                   	leave  
  10153e:	c3                   	ret    

0010153f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10153f:	55                   	push   %ebp
  101540:	89 e5                	mov    %esp,%ebp
  101542:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101545:	c7 04 24 b6 13 10 00 	movl   $0x1013b6,(%esp)
  10154c:	e8 a6 fd ff ff       	call   1012f7 <cons_intr>
}
  101551:	c9                   	leave  
  101552:	c3                   	ret    

00101553 <kbd_init>:

static void
kbd_init(void) {
  101553:	55                   	push   %ebp
  101554:	89 e5                	mov    %esp,%ebp
  101556:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101559:	e8 e1 ff ff ff       	call   10153f <kbd_intr>
    pic_enable(IRQ_KBD);
  10155e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101565:	e8 17 01 00 00       	call   101681 <pic_enable>
}
  10156a:	c9                   	leave  
  10156b:	c3                   	ret    

0010156c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10156c:	55                   	push   %ebp
  10156d:	89 e5                	mov    %esp,%ebp
  10156f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101572:	e8 93 f8 ff ff       	call   100e0a <cga_init>
    serial_init();
  101577:	e8 74 f9 ff ff       	call   100ef0 <serial_init>
    kbd_init();
  10157c:	e8 d2 ff ff ff       	call   101553 <kbd_init>
    if (!serial_exists) {
  101581:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101586:	85 c0                	test   %eax,%eax
  101588:	75 0c                	jne    101596 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10158a:	c7 04 24 a9 37 10 00 	movl   $0x1037a9,(%esp)
  101591:	e8 7c ed ff ff       	call   100312 <cprintf>
    }
}
  101596:	c9                   	leave  
  101597:	c3                   	ret    

00101598 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101598:	55                   	push   %ebp
  101599:	89 e5                	mov    %esp,%ebp
  10159b:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10159e:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a1:	89 04 24             	mov    %eax,(%esp)
  1015a4:	e8 a3 fa ff ff       	call   10104c <lpt_putc>
    cga_putc(c);
  1015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  1015ac:	89 04 24             	mov    %eax,(%esp)
  1015af:	e8 d7 fa ff ff       	call   10108b <cga_putc>
    serial_putc(c);
  1015b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1015b7:	89 04 24             	mov    %eax,(%esp)
  1015ba:	e8 f9 fc ff ff       	call   1012b8 <serial_putc>
}
  1015bf:	c9                   	leave  
  1015c0:	c3                   	ret    

001015c1 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015c1:	55                   	push   %ebp
  1015c2:	89 e5                	mov    %esp,%ebp
  1015c4:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015c7:	e8 cd fd ff ff       	call   101399 <serial_intr>
    kbd_intr();
  1015cc:	e8 6e ff ff ff       	call   10153f <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015d1:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015d7:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015dc:	39 c2                	cmp    %eax,%edx
  1015de:	74 36                	je     101616 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015e0:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015e5:	8d 50 01             	lea    0x1(%eax),%edx
  1015e8:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015ee:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015f5:	0f b6 c0             	movzbl %al,%eax
  1015f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015fb:	a1 80 f0 10 00       	mov    0x10f080,%eax
  101600:	3d 00 02 00 00       	cmp    $0x200,%eax
  101605:	75 0a                	jne    101611 <cons_getc+0x50>
            cons.rpos = 0;
  101607:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  10160e:	00 00 00 
        }
        return c;
  101611:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101614:	eb 05                	jmp    10161b <cons_getc+0x5a>
    }
    return 0;
  101616:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10161b:	c9                   	leave  
  10161c:	c3                   	ret    

0010161d <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10161d:	55                   	push   %ebp
  10161e:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  101620:	fb                   	sti    
    sti();
}
  101621:	5d                   	pop    %ebp
  101622:	c3                   	ret    

00101623 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101623:	55                   	push   %ebp
  101624:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  101626:	fa                   	cli    
    cli();
}
  101627:	5d                   	pop    %ebp
  101628:	c3                   	ret    

00101629 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101629:	55                   	push   %ebp
  10162a:	89 e5                	mov    %esp,%ebp
  10162c:	83 ec 14             	sub    $0x14,%esp
  10162f:	8b 45 08             	mov    0x8(%ebp),%eax
  101632:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101636:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10163a:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101640:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101645:	85 c0                	test   %eax,%eax
  101647:	74 36                	je     10167f <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101649:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10164d:	0f b6 c0             	movzbl %al,%eax
  101650:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  101656:	88 45 fd             	mov    %al,-0x3(%ebp)
            : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101659:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10165d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101661:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101662:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101666:	66 c1 e8 08          	shr    $0x8,%ax
  10166a:	0f b6 c0             	movzbl %al,%eax
  10166d:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  101673:	88 45 f9             	mov    %al,-0x7(%ebp)
  101676:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10167a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10167e:	ee                   	out    %al,(%dx)
    }
}
  10167f:	c9                   	leave  
  101680:	c3                   	ret    

00101681 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101681:	55                   	push   %ebp
  101682:	89 e5                	mov    %esp,%ebp
  101684:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101687:	8b 45 08             	mov    0x8(%ebp),%eax
  10168a:	ba 01 00 00 00       	mov    $0x1,%edx
  10168f:	89 c1                	mov    %eax,%ecx
  101691:	d3 e2                	shl    %cl,%edx
  101693:	89 d0                	mov    %edx,%eax
  101695:	f7 d0                	not    %eax
  101697:	89 c2                	mov    %eax,%edx
  101699:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1016a0:	21 d0                	and    %edx,%eax
  1016a2:	0f b7 c0             	movzwl %ax,%eax
  1016a5:	89 04 24             	mov    %eax,(%esp)
  1016a8:	e8 7c ff ff ff       	call   101629 <pic_setmask>
}
  1016ad:	c9                   	leave  
  1016ae:	c3                   	ret    

001016af <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1016af:	55                   	push   %ebp
  1016b0:	89 e5                	mov    %esp,%ebp
  1016b2:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1016b5:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016bc:	00 00 00 
  1016bf:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1016c5:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1016c9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016cd:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016d1:	ee                   	out    %al,(%dx)
  1016d2:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1016d8:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1016dc:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016e0:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016e4:	ee                   	out    %al,(%dx)
  1016e5:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  1016eb:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  1016ef:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1016f3:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1016f7:	ee                   	out    %al,(%dx)
  1016f8:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  1016fe:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101702:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101706:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  10170a:	ee                   	out    %al,(%dx)
  10170b:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  101711:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101715:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101719:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10171d:	ee                   	out    %al,(%dx)
  10171e:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101724:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101728:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10172c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101730:	ee                   	out    %al,(%dx)
  101731:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101737:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  10173b:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10173f:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101743:	ee                   	out    %al,(%dx)
  101744:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  10174a:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10174e:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101752:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101756:	ee                   	out    %al,(%dx)
  101757:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10175d:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  101761:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101765:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101769:	ee                   	out    %al,(%dx)
  10176a:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  101770:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101774:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101778:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10177c:	ee                   	out    %al,(%dx)
  10177d:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  101783:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  101787:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  10178b:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10178f:	ee                   	out    %al,(%dx)
  101790:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  101796:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  10179a:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  10179e:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1017a2:	ee                   	out    %al,(%dx)
  1017a3:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1017a9:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1017ad:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1017b1:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1017b5:	ee                   	out    %al,(%dx)
  1017b6:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1017bc:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1017c0:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1017c4:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1017c8:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017c9:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017d0:	66 83 f8 ff          	cmp    $0xffff,%ax
  1017d4:	74 12                	je     1017e8 <pic_init+0x139>
        pic_setmask(irq_mask);
  1017d6:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017dd:	0f b7 c0             	movzwl %ax,%eax
  1017e0:	89 04 24             	mov    %eax,(%esp)
  1017e3:	e8 41 fe ff ff       	call   101629 <pic_setmask>
    }
}
  1017e8:	c9                   	leave  
  1017e9:	c3                   	ret    

001017ea <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  1017ea:	55                   	push   %ebp
  1017eb:	89 e5                	mov    %esp,%ebp
  1017ed:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017f0:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017f7:	00 
  1017f8:	c7 04 24 e0 37 10 00 	movl   $0x1037e0,(%esp)
  1017ff:	e8 0e eb ff ff       	call   100312 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101804:	c9                   	leave  
  101805:	c3                   	ret    

00101806 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101806:	55                   	push   %ebp
  101807:	89 e5                	mov    %esp,%ebp
  101809:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
  10180c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
  101813:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10181a:	e9 c3 00 00 00       	jmp    1018e2 <idt_init+0xdc>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  10181f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101822:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  101829:	89 c2                	mov    %eax,%edx
  10182b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10182e:	66 89 14 c5 a0 f0 10 	mov    %dx,0x10f0a0(,%eax,8)
  101835:	00 
  101836:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101839:	66 c7 04 c5 a2 f0 10 	movw   $0x8,0x10f0a2(,%eax,8)
  101840:	00 08 00 
  101843:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101846:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  10184d:	00 
  10184e:	83 e2 e0             	and    $0xffffffe0,%edx
  101851:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  101858:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185b:	0f b6 14 c5 a4 f0 10 	movzbl 0x10f0a4(,%eax,8),%edx
  101862:	00 
  101863:	83 e2 1f             	and    $0x1f,%edx
  101866:	88 14 c5 a4 f0 10 00 	mov    %dl,0x10f0a4(,%eax,8)
  10186d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101870:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  101877:	00 
  101878:	83 e2 f0             	and    $0xfffffff0,%edx
  10187b:	83 ca 0e             	or     $0xe,%edx
  10187e:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  101885:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101888:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  10188f:	00 
  101890:	83 e2 ef             	and    $0xffffffef,%edx
  101893:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  10189a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189d:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018a4:	00 
  1018a5:	83 e2 9f             	and    $0xffffff9f,%edx
  1018a8:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b2:	0f b6 14 c5 a5 f0 10 	movzbl 0x10f0a5(,%eax,8),%edx
  1018b9:	00 
  1018ba:	83 ca 80             	or     $0xffffff80,%edx
  1018bd:	88 14 c5 a5 f0 10 00 	mov    %dl,0x10f0a5(,%eax,8)
  1018c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c7:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018ce:	c1 e8 10             	shr    $0x10,%eax
  1018d1:	89 c2                	mov    %eax,%edx
  1018d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d6:	66 89 14 c5 a6 f0 10 	mov    %dx,0x10f0a6(,%eax,8)
  1018dd:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
	extern uintptr_t __vectors[];
	int i = 0;
	for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc);i++)
  1018de:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1018e2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  1018ea:	0f 86 2f ff ff ff    	jbe    10181f <idt_init+0x19>
		SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
	SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  1018f0:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1018f5:	66 a3 68 f4 10 00    	mov    %ax,0x10f468
  1018fb:	66 c7 05 6a f4 10 00 	movw   $0x8,0x10f46a
  101902:	08 00 
  101904:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10190b:	83 e0 e0             	and    $0xffffffe0,%eax
  10190e:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101913:	0f b6 05 6c f4 10 00 	movzbl 0x10f46c,%eax
  10191a:	83 e0 1f             	and    $0x1f,%eax
  10191d:	a2 6c f4 10 00       	mov    %al,0x10f46c
  101922:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101929:	83 e0 f0             	and    $0xfffffff0,%eax
  10192c:	83 c8 0e             	or     $0xe,%eax
  10192f:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101934:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10193b:	83 e0 ef             	and    $0xffffffef,%eax
  10193e:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101943:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  10194a:	83 c8 60             	or     $0x60,%eax
  10194d:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101952:	0f b6 05 6d f4 10 00 	movzbl 0x10f46d,%eax
  101959:	83 c8 80             	or     $0xffffff80,%eax
  10195c:	a2 6d f4 10 00       	mov    %al,0x10f46d
  101961:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101966:	c1 e8 10             	shr    $0x10,%eax
  101969:	66 a3 6e f4 10 00    	mov    %ax,0x10f46e
  10196f:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    return ebp;
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd));
  101976:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101979:	0f 01 18             	lidtl  (%eax)
	lidt(&idt_pd);
}
  10197c:	c9                   	leave  
  10197d:	c3                   	ret    

0010197e <trapname>:

static const char *
trapname(int trapno) {
  10197e:	55                   	push   %ebp
  10197f:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101981:	8b 45 08             	mov    0x8(%ebp),%eax
  101984:	83 f8 13             	cmp    $0x13,%eax
  101987:	77 0c                	ja     101995 <trapname+0x17>
        return excnames[trapno];
  101989:	8b 45 08             	mov    0x8(%ebp),%eax
  10198c:	8b 04 85 40 3b 10 00 	mov    0x103b40(,%eax,4),%eax
  101993:	eb 18                	jmp    1019ad <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101995:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101999:	7e 0d                	jle    1019a8 <trapname+0x2a>
  10199b:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  10199f:	7f 07                	jg     1019a8 <trapname+0x2a>
        return "Hardware Interrupt";
  1019a1:	b8 ea 37 10 00       	mov    $0x1037ea,%eax
  1019a6:	eb 05                	jmp    1019ad <trapname+0x2f>
    }
    return "(unknown trap)";
  1019a8:	b8 fd 37 10 00       	mov    $0x1037fd,%eax
}
  1019ad:	5d                   	pop    %ebp
  1019ae:	c3                   	ret    

001019af <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019af:	55                   	push   %ebp
  1019b0:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b5:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019b9:	66 83 f8 08          	cmp    $0x8,%ax
  1019bd:	0f 94 c0             	sete   %al
  1019c0:	0f b6 c0             	movzbl %al,%eax
}
  1019c3:	5d                   	pop    %ebp
  1019c4:	c3                   	ret    

001019c5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019c5:	55                   	push   %ebp
  1019c6:	89 e5                	mov    %esp,%ebp
  1019c8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019d2:	c7 04 24 3e 38 10 00 	movl   $0x10383e,(%esp)
  1019d9:	e8 34 e9 ff ff       	call   100312 <cprintf>
    print_regs(&tf->tf_regs);
  1019de:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e1:	89 04 24             	mov    %eax,(%esp)
  1019e4:	e8 a1 01 00 00       	call   101b8a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  1019e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1019ec:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  1019f0:	0f b7 c0             	movzwl %ax,%eax
  1019f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1019f7:	c7 04 24 4f 38 10 00 	movl   $0x10384f,(%esp)
  1019fe:	e8 0f e9 ff ff       	call   100312 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a03:	8b 45 08             	mov    0x8(%ebp),%eax
  101a06:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a0a:	0f b7 c0             	movzwl %ax,%eax
  101a0d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a11:	c7 04 24 62 38 10 00 	movl   $0x103862,(%esp)
  101a18:	e8 f5 e8 ff ff       	call   100312 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a20:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a24:	0f b7 c0             	movzwl %ax,%eax
  101a27:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a2b:	c7 04 24 75 38 10 00 	movl   $0x103875,(%esp)
  101a32:	e8 db e8 ff ff       	call   100312 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a37:	8b 45 08             	mov    0x8(%ebp),%eax
  101a3a:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a3e:	0f b7 c0             	movzwl %ax,%eax
  101a41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a45:	c7 04 24 88 38 10 00 	movl   $0x103888,(%esp)
  101a4c:	e8 c1 e8 ff ff       	call   100312 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a51:	8b 45 08             	mov    0x8(%ebp),%eax
  101a54:	8b 40 30             	mov    0x30(%eax),%eax
  101a57:	89 04 24             	mov    %eax,(%esp)
  101a5a:	e8 1f ff ff ff       	call   10197e <trapname>
  101a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  101a62:	8b 52 30             	mov    0x30(%edx),%edx
  101a65:	89 44 24 08          	mov    %eax,0x8(%esp)
  101a69:	89 54 24 04          	mov    %edx,0x4(%esp)
  101a6d:	c7 04 24 9b 38 10 00 	movl   $0x10389b,(%esp)
  101a74:	e8 99 e8 ff ff       	call   100312 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a79:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7c:	8b 40 34             	mov    0x34(%eax),%eax
  101a7f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a83:	c7 04 24 ad 38 10 00 	movl   $0x1038ad,(%esp)
  101a8a:	e8 83 e8 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  101a92:	8b 40 38             	mov    0x38(%eax),%eax
  101a95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a99:	c7 04 24 bc 38 10 00 	movl   $0x1038bc,(%esp)
  101aa0:	e8 6d e8 ff ff       	call   100312 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa8:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101aac:	0f b7 c0             	movzwl %ax,%eax
  101aaf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab3:	c7 04 24 cb 38 10 00 	movl   $0x1038cb,(%esp)
  101aba:	e8 53 e8 ff ff       	call   100312 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101abf:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac2:	8b 40 40             	mov    0x40(%eax),%eax
  101ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ac9:	c7 04 24 de 38 10 00 	movl   $0x1038de,(%esp)
  101ad0:	e8 3d e8 ff ff       	call   100312 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ad5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101adc:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101ae3:	eb 3e                	jmp    101b23 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae8:	8b 50 40             	mov    0x40(%eax),%edx
  101aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101aee:	21 d0                	and    %edx,%eax
  101af0:	85 c0                	test   %eax,%eax
  101af2:	74 28                	je     101b1c <print_trapframe+0x157>
  101af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101af7:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101afe:	85 c0                	test   %eax,%eax
  101b00:	74 1a                	je     101b1c <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b05:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b10:	c7 04 24 ed 38 10 00 	movl   $0x1038ed,(%esp)
  101b17:	e8 f6 e7 ff ff       	call   100312 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b1c:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101b20:	d1 65 f0             	shll   -0x10(%ebp)
  101b23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b26:	83 f8 17             	cmp    $0x17,%eax
  101b29:	76 ba                	jbe    101ae5 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  101b2e:	8b 40 40             	mov    0x40(%eax),%eax
  101b31:	25 00 30 00 00       	and    $0x3000,%eax
  101b36:	c1 e8 0c             	shr    $0xc,%eax
  101b39:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b3d:	c7 04 24 f1 38 10 00 	movl   $0x1038f1,(%esp)
  101b44:	e8 c9 e7 ff ff       	call   100312 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b49:	8b 45 08             	mov    0x8(%ebp),%eax
  101b4c:	89 04 24             	mov    %eax,(%esp)
  101b4f:	e8 5b fe ff ff       	call   1019af <trap_in_kernel>
  101b54:	85 c0                	test   %eax,%eax
  101b56:	75 30                	jne    101b88 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b58:	8b 45 08             	mov    0x8(%ebp),%eax
  101b5b:	8b 40 44             	mov    0x44(%eax),%eax
  101b5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b62:	c7 04 24 fa 38 10 00 	movl   $0x1038fa,(%esp)
  101b69:	e8 a4 e7 ff ff       	call   100312 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b71:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b75:	0f b7 c0             	movzwl %ax,%eax
  101b78:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b7c:	c7 04 24 09 39 10 00 	movl   $0x103909,(%esp)
  101b83:	e8 8a e7 ff ff       	call   100312 <cprintf>
    }
}
  101b88:	c9                   	leave  
  101b89:	c3                   	ret    

00101b8a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101b8a:	55                   	push   %ebp
  101b8b:	89 e5                	mov    %esp,%ebp
  101b8d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	8b 00                	mov    (%eax),%eax
  101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b99:	c7 04 24 1c 39 10 00 	movl   $0x10391c,(%esp)
  101ba0:	e8 6d e7 ff ff       	call   100312 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101ba5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba8:	8b 40 04             	mov    0x4(%eax),%eax
  101bab:	89 44 24 04          	mov    %eax,0x4(%esp)
  101baf:	c7 04 24 2b 39 10 00 	movl   $0x10392b,(%esp)
  101bb6:	e8 57 e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbe:	8b 40 08             	mov    0x8(%eax),%eax
  101bc1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bc5:	c7 04 24 3a 39 10 00 	movl   $0x10393a,(%esp)
  101bcc:	e8 41 e7 ff ff       	call   100312 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd4:	8b 40 0c             	mov    0xc(%eax),%eax
  101bd7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bdb:	c7 04 24 49 39 10 00 	movl   $0x103949,(%esp)
  101be2:	e8 2b e7 ff ff       	call   100312 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101be7:	8b 45 08             	mov    0x8(%ebp),%eax
  101bea:	8b 40 10             	mov    0x10(%eax),%eax
  101bed:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf1:	c7 04 24 58 39 10 00 	movl   $0x103958,(%esp)
  101bf8:	e8 15 e7 ff ff       	call   100312 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  101c00:	8b 40 14             	mov    0x14(%eax),%eax
  101c03:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c07:	c7 04 24 67 39 10 00 	movl   $0x103967,(%esp)
  101c0e:	e8 ff e6 ff ff       	call   100312 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c13:	8b 45 08             	mov    0x8(%ebp),%eax
  101c16:	8b 40 18             	mov    0x18(%eax),%eax
  101c19:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c1d:	c7 04 24 76 39 10 00 	movl   $0x103976,(%esp)
  101c24:	e8 e9 e6 ff ff       	call   100312 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c29:	8b 45 08             	mov    0x8(%ebp),%eax
  101c2c:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c33:	c7 04 24 85 39 10 00 	movl   $0x103985,(%esp)
  101c3a:	e8 d3 e6 ff ff       	call   100312 <cprintf>
}
  101c3f:	c9                   	leave  
  101c40:	c3                   	ret    

00101c41 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c41:	55                   	push   %ebp
  101c42:	89 e5                	mov    %esp,%ebp
  101c44:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c47:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4a:	8b 40 30             	mov    0x30(%eax),%eax
  101c4d:	83 f8 2f             	cmp    $0x2f,%eax
  101c50:	77 21                	ja     101c73 <trap_dispatch+0x32>
  101c52:	83 f8 2e             	cmp    $0x2e,%eax
  101c55:	0f 83 04 01 00 00    	jae    101d5f <trap_dispatch+0x11e>
  101c5b:	83 f8 21             	cmp    $0x21,%eax
  101c5e:	0f 84 81 00 00 00    	je     101ce5 <trap_dispatch+0xa4>
  101c64:	83 f8 24             	cmp    $0x24,%eax
  101c67:	74 56                	je     101cbf <trap_dispatch+0x7e>
  101c69:	83 f8 20             	cmp    $0x20,%eax
  101c6c:	74 16                	je     101c84 <trap_dispatch+0x43>
  101c6e:	e9 b4 00 00 00       	jmp    101d27 <trap_dispatch+0xe6>
  101c73:	83 e8 78             	sub    $0x78,%eax
  101c76:	83 f8 01             	cmp    $0x1,%eax
  101c79:	0f 87 a8 00 00 00    	ja     101d27 <trap_dispatch+0xe6>
  101c7f:	e9 87 00 00 00       	jmp    101d0b <trap_dispatch+0xca>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
	ticks++;
  101c84:	a1 08 f9 10 00       	mov    0x10f908,%eax
  101c89:	83 c0 01             	add    $0x1,%eax
  101c8c:	a3 08 f9 10 00       	mov    %eax,0x10f908
        if (ticks % TICK_NUM == 0)
  101c91:	8b 0d 08 f9 10 00    	mov    0x10f908,%ecx
  101c97:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101c9c:	89 c8                	mov    %ecx,%eax
  101c9e:	f7 e2                	mul    %edx
  101ca0:	89 d0                	mov    %edx,%eax
  101ca2:	c1 e8 05             	shr    $0x5,%eax
  101ca5:	6b c0 64             	imul   $0x64,%eax,%eax
  101ca8:	29 c1                	sub    %eax,%ecx
  101caa:	89 c8                	mov    %ecx,%eax
  101cac:	85 c0                	test   %eax,%eax
  101cae:	75 0a                	jne    101cba <trap_dispatch+0x79>
		print_ticks();
  101cb0:	e8 35 fb ff ff       	call   1017ea <print_ticks>
        break;
  101cb5:	e9 a6 00 00 00       	jmp    101d60 <trap_dispatch+0x11f>
  101cba:	e9 a1 00 00 00       	jmp    101d60 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101cbf:	e8 fd f8 ff ff       	call   1015c1 <cons_getc>
  101cc4:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cc7:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101ccb:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101ccf:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cd7:	c7 04 24 94 39 10 00 	movl   $0x103994,(%esp)
  101cde:	e8 2f e6 ff ff       	call   100312 <cprintf>
        break;
  101ce3:	eb 7b                	jmp    101d60 <trap_dispatch+0x11f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101ce5:	e8 d7 f8 ff ff       	call   1015c1 <cons_getc>
  101cea:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101ced:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cf5:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cf9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cfd:	c7 04 24 a6 39 10 00 	movl   $0x1039a6,(%esp)
  101d04:	e8 09 e6 ff ff       	call   100312 <cprintf>
        break;
  101d09:	eb 55                	jmp    101d60 <trap_dispatch+0x11f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101d0b:	c7 44 24 08 b5 39 10 	movl   $0x1039b5,0x8(%esp)
  101d12:	00 
  101d13:	c7 44 24 04 ab 00 00 	movl   $0xab,0x4(%esp)
  101d1a:	00 
  101d1b:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d22:	e8 7c ef ff ff       	call   100ca3 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d27:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d2e:	0f b7 c0             	movzwl %ax,%eax
  101d31:	83 e0 03             	and    $0x3,%eax
  101d34:	85 c0                	test   %eax,%eax
  101d36:	75 28                	jne    101d60 <trap_dispatch+0x11f>
            print_trapframe(tf);
  101d38:	8b 45 08             	mov    0x8(%ebp),%eax
  101d3b:	89 04 24             	mov    %eax,(%esp)
  101d3e:	e8 82 fc ff ff       	call   1019c5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d43:	c7 44 24 08 d6 39 10 	movl   $0x1039d6,0x8(%esp)
  101d4a:	00 
  101d4b:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
  101d52:	00 
  101d53:	c7 04 24 c5 39 10 00 	movl   $0x1039c5,(%esp)
  101d5a:	e8 44 ef ff ff       	call   100ca3 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101d5f:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101d60:	c9                   	leave  
  101d61:	c3                   	ret    

00101d62 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d62:	55                   	push   %ebp
  101d63:	89 e5                	mov    %esp,%ebp
  101d65:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d68:	8b 45 08             	mov    0x8(%ebp),%eax
  101d6b:	89 04 24             	mov    %eax,(%esp)
  101d6e:	e8 ce fe ff ff       	call   101c41 <trap_dispatch>
}
  101d73:	c9                   	leave  
  101d74:	c3                   	ret    

00101d75 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101d75:	1e                   	push   %ds
    pushl %es
  101d76:	06                   	push   %es
    pushl %fs
  101d77:	0f a0                	push   %fs
    pushl %gs
  101d79:	0f a8                	push   %gs
    pushal
  101d7b:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101d7c:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101d81:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101d83:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101d85:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101d86:	e8 d7 ff ff ff       	call   101d62 <trap>

    # pop the pushed stack pointer
    popl %esp
  101d8b:	5c                   	pop    %esp

00101d8c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101d8c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101d8d:	0f a9                	pop    %gs
    popl %fs
  101d8f:	0f a1                	pop    %fs
    popl %es
  101d91:	07                   	pop    %es
    popl %ds
  101d92:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101d93:	83 c4 08             	add    $0x8,%esp
    iret
  101d96:	cf                   	iret   

00101d97 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d97:	6a 00                	push   $0x0
  pushl $0
  101d99:	6a 00                	push   $0x0
  jmp __alltraps
  101d9b:	e9 d5 ff ff ff       	jmp    101d75 <__alltraps>

00101da0 <vector1>:
.globl vector1
vector1:
  pushl $0
  101da0:	6a 00                	push   $0x0
  pushl $1
  101da2:	6a 01                	push   $0x1
  jmp __alltraps
  101da4:	e9 cc ff ff ff       	jmp    101d75 <__alltraps>

00101da9 <vector2>:
.globl vector2
vector2:
  pushl $0
  101da9:	6a 00                	push   $0x0
  pushl $2
  101dab:	6a 02                	push   $0x2
  jmp __alltraps
  101dad:	e9 c3 ff ff ff       	jmp    101d75 <__alltraps>

00101db2 <vector3>:
.globl vector3
vector3:
  pushl $0
  101db2:	6a 00                	push   $0x0
  pushl $3
  101db4:	6a 03                	push   $0x3
  jmp __alltraps
  101db6:	e9 ba ff ff ff       	jmp    101d75 <__alltraps>

00101dbb <vector4>:
.globl vector4
vector4:
  pushl $0
  101dbb:	6a 00                	push   $0x0
  pushl $4
  101dbd:	6a 04                	push   $0x4
  jmp __alltraps
  101dbf:	e9 b1 ff ff ff       	jmp    101d75 <__alltraps>

00101dc4 <vector5>:
.globl vector5
vector5:
  pushl $0
  101dc4:	6a 00                	push   $0x0
  pushl $5
  101dc6:	6a 05                	push   $0x5
  jmp __alltraps
  101dc8:	e9 a8 ff ff ff       	jmp    101d75 <__alltraps>

00101dcd <vector6>:
.globl vector6
vector6:
  pushl $0
  101dcd:	6a 00                	push   $0x0
  pushl $6
  101dcf:	6a 06                	push   $0x6
  jmp __alltraps
  101dd1:	e9 9f ff ff ff       	jmp    101d75 <__alltraps>

00101dd6 <vector7>:
.globl vector7
vector7:
  pushl $0
  101dd6:	6a 00                	push   $0x0
  pushl $7
  101dd8:	6a 07                	push   $0x7
  jmp __alltraps
  101dda:	e9 96 ff ff ff       	jmp    101d75 <__alltraps>

00101ddf <vector8>:
.globl vector8
vector8:
  pushl $8
  101ddf:	6a 08                	push   $0x8
  jmp __alltraps
  101de1:	e9 8f ff ff ff       	jmp    101d75 <__alltraps>

00101de6 <vector9>:
.globl vector9
vector9:
  pushl $9
  101de6:	6a 09                	push   $0x9
  jmp __alltraps
  101de8:	e9 88 ff ff ff       	jmp    101d75 <__alltraps>

00101ded <vector10>:
.globl vector10
vector10:
  pushl $10
  101ded:	6a 0a                	push   $0xa
  jmp __alltraps
  101def:	e9 81 ff ff ff       	jmp    101d75 <__alltraps>

00101df4 <vector11>:
.globl vector11
vector11:
  pushl $11
  101df4:	6a 0b                	push   $0xb
  jmp __alltraps
  101df6:	e9 7a ff ff ff       	jmp    101d75 <__alltraps>

00101dfb <vector12>:
.globl vector12
vector12:
  pushl $12
  101dfb:	6a 0c                	push   $0xc
  jmp __alltraps
  101dfd:	e9 73 ff ff ff       	jmp    101d75 <__alltraps>

00101e02 <vector13>:
.globl vector13
vector13:
  pushl $13
  101e02:	6a 0d                	push   $0xd
  jmp __alltraps
  101e04:	e9 6c ff ff ff       	jmp    101d75 <__alltraps>

00101e09 <vector14>:
.globl vector14
vector14:
  pushl $14
  101e09:	6a 0e                	push   $0xe
  jmp __alltraps
  101e0b:	e9 65 ff ff ff       	jmp    101d75 <__alltraps>

00101e10 <vector15>:
.globl vector15
vector15:
  pushl $0
  101e10:	6a 00                	push   $0x0
  pushl $15
  101e12:	6a 0f                	push   $0xf
  jmp __alltraps
  101e14:	e9 5c ff ff ff       	jmp    101d75 <__alltraps>

00101e19 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e19:	6a 00                	push   $0x0
  pushl $16
  101e1b:	6a 10                	push   $0x10
  jmp __alltraps
  101e1d:	e9 53 ff ff ff       	jmp    101d75 <__alltraps>

00101e22 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e22:	6a 11                	push   $0x11
  jmp __alltraps
  101e24:	e9 4c ff ff ff       	jmp    101d75 <__alltraps>

00101e29 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $18
  101e2b:	6a 12                	push   $0x12
  jmp __alltraps
  101e2d:	e9 43 ff ff ff       	jmp    101d75 <__alltraps>

00101e32 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $19
  101e34:	6a 13                	push   $0x13
  jmp __alltraps
  101e36:	e9 3a ff ff ff       	jmp    101d75 <__alltraps>

00101e3b <vector20>:
.globl vector20
vector20:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $20
  101e3d:	6a 14                	push   $0x14
  jmp __alltraps
  101e3f:	e9 31 ff ff ff       	jmp    101d75 <__alltraps>

00101e44 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $21
  101e46:	6a 15                	push   $0x15
  jmp __alltraps
  101e48:	e9 28 ff ff ff       	jmp    101d75 <__alltraps>

00101e4d <vector22>:
.globl vector22
vector22:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $22
  101e4f:	6a 16                	push   $0x16
  jmp __alltraps
  101e51:	e9 1f ff ff ff       	jmp    101d75 <__alltraps>

00101e56 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $23
  101e58:	6a 17                	push   $0x17
  jmp __alltraps
  101e5a:	e9 16 ff ff ff       	jmp    101d75 <__alltraps>

00101e5f <vector24>:
.globl vector24
vector24:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $24
  101e61:	6a 18                	push   $0x18
  jmp __alltraps
  101e63:	e9 0d ff ff ff       	jmp    101d75 <__alltraps>

00101e68 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $25
  101e6a:	6a 19                	push   $0x19
  jmp __alltraps
  101e6c:	e9 04 ff ff ff       	jmp    101d75 <__alltraps>

00101e71 <vector26>:
.globl vector26
vector26:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $26
  101e73:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e75:	e9 fb fe ff ff       	jmp    101d75 <__alltraps>

00101e7a <vector27>:
.globl vector27
vector27:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $27
  101e7c:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e7e:	e9 f2 fe ff ff       	jmp    101d75 <__alltraps>

00101e83 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $28
  101e85:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e87:	e9 e9 fe ff ff       	jmp    101d75 <__alltraps>

00101e8c <vector29>:
.globl vector29
vector29:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $29
  101e8e:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e90:	e9 e0 fe ff ff       	jmp    101d75 <__alltraps>

00101e95 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $30
  101e97:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e99:	e9 d7 fe ff ff       	jmp    101d75 <__alltraps>

00101e9e <vector31>:
.globl vector31
vector31:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $31
  101ea0:	6a 1f                	push   $0x1f
  jmp __alltraps
  101ea2:	e9 ce fe ff ff       	jmp    101d75 <__alltraps>

00101ea7 <vector32>:
.globl vector32
vector32:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $32
  101ea9:	6a 20                	push   $0x20
  jmp __alltraps
  101eab:	e9 c5 fe ff ff       	jmp    101d75 <__alltraps>

00101eb0 <vector33>:
.globl vector33
vector33:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $33
  101eb2:	6a 21                	push   $0x21
  jmp __alltraps
  101eb4:	e9 bc fe ff ff       	jmp    101d75 <__alltraps>

00101eb9 <vector34>:
.globl vector34
vector34:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $34
  101ebb:	6a 22                	push   $0x22
  jmp __alltraps
  101ebd:	e9 b3 fe ff ff       	jmp    101d75 <__alltraps>

00101ec2 <vector35>:
.globl vector35
vector35:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $35
  101ec4:	6a 23                	push   $0x23
  jmp __alltraps
  101ec6:	e9 aa fe ff ff       	jmp    101d75 <__alltraps>

00101ecb <vector36>:
.globl vector36
vector36:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $36
  101ecd:	6a 24                	push   $0x24
  jmp __alltraps
  101ecf:	e9 a1 fe ff ff       	jmp    101d75 <__alltraps>

00101ed4 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $37
  101ed6:	6a 25                	push   $0x25
  jmp __alltraps
  101ed8:	e9 98 fe ff ff       	jmp    101d75 <__alltraps>

00101edd <vector38>:
.globl vector38
vector38:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $38
  101edf:	6a 26                	push   $0x26
  jmp __alltraps
  101ee1:	e9 8f fe ff ff       	jmp    101d75 <__alltraps>

00101ee6 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $39
  101ee8:	6a 27                	push   $0x27
  jmp __alltraps
  101eea:	e9 86 fe ff ff       	jmp    101d75 <__alltraps>

00101eef <vector40>:
.globl vector40
vector40:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $40
  101ef1:	6a 28                	push   $0x28
  jmp __alltraps
  101ef3:	e9 7d fe ff ff       	jmp    101d75 <__alltraps>

00101ef8 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $41
  101efa:	6a 29                	push   $0x29
  jmp __alltraps
  101efc:	e9 74 fe ff ff       	jmp    101d75 <__alltraps>

00101f01 <vector42>:
.globl vector42
vector42:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $42
  101f03:	6a 2a                	push   $0x2a
  jmp __alltraps
  101f05:	e9 6b fe ff ff       	jmp    101d75 <__alltraps>

00101f0a <vector43>:
.globl vector43
vector43:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $43
  101f0c:	6a 2b                	push   $0x2b
  jmp __alltraps
  101f0e:	e9 62 fe ff ff       	jmp    101d75 <__alltraps>

00101f13 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $44
  101f15:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f17:	e9 59 fe ff ff       	jmp    101d75 <__alltraps>

00101f1c <vector45>:
.globl vector45
vector45:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $45
  101f1e:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f20:	e9 50 fe ff ff       	jmp    101d75 <__alltraps>

00101f25 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $46
  101f27:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f29:	e9 47 fe ff ff       	jmp    101d75 <__alltraps>

00101f2e <vector47>:
.globl vector47
vector47:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $47
  101f30:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f32:	e9 3e fe ff ff       	jmp    101d75 <__alltraps>

00101f37 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $48
  101f39:	6a 30                	push   $0x30
  jmp __alltraps
  101f3b:	e9 35 fe ff ff       	jmp    101d75 <__alltraps>

00101f40 <vector49>:
.globl vector49
vector49:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $49
  101f42:	6a 31                	push   $0x31
  jmp __alltraps
  101f44:	e9 2c fe ff ff       	jmp    101d75 <__alltraps>

00101f49 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $50
  101f4b:	6a 32                	push   $0x32
  jmp __alltraps
  101f4d:	e9 23 fe ff ff       	jmp    101d75 <__alltraps>

00101f52 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $51
  101f54:	6a 33                	push   $0x33
  jmp __alltraps
  101f56:	e9 1a fe ff ff       	jmp    101d75 <__alltraps>

00101f5b <vector52>:
.globl vector52
vector52:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $52
  101f5d:	6a 34                	push   $0x34
  jmp __alltraps
  101f5f:	e9 11 fe ff ff       	jmp    101d75 <__alltraps>

00101f64 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $53
  101f66:	6a 35                	push   $0x35
  jmp __alltraps
  101f68:	e9 08 fe ff ff       	jmp    101d75 <__alltraps>

00101f6d <vector54>:
.globl vector54
vector54:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $54
  101f6f:	6a 36                	push   $0x36
  jmp __alltraps
  101f71:	e9 ff fd ff ff       	jmp    101d75 <__alltraps>

00101f76 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $55
  101f78:	6a 37                	push   $0x37
  jmp __alltraps
  101f7a:	e9 f6 fd ff ff       	jmp    101d75 <__alltraps>

00101f7f <vector56>:
.globl vector56
vector56:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $56
  101f81:	6a 38                	push   $0x38
  jmp __alltraps
  101f83:	e9 ed fd ff ff       	jmp    101d75 <__alltraps>

00101f88 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $57
  101f8a:	6a 39                	push   $0x39
  jmp __alltraps
  101f8c:	e9 e4 fd ff ff       	jmp    101d75 <__alltraps>

00101f91 <vector58>:
.globl vector58
vector58:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $58
  101f93:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f95:	e9 db fd ff ff       	jmp    101d75 <__alltraps>

00101f9a <vector59>:
.globl vector59
vector59:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $59
  101f9c:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f9e:	e9 d2 fd ff ff       	jmp    101d75 <__alltraps>

00101fa3 <vector60>:
.globl vector60
vector60:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $60
  101fa5:	6a 3c                	push   $0x3c
  jmp __alltraps
  101fa7:	e9 c9 fd ff ff       	jmp    101d75 <__alltraps>

00101fac <vector61>:
.globl vector61
vector61:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $61
  101fae:	6a 3d                	push   $0x3d
  jmp __alltraps
  101fb0:	e9 c0 fd ff ff       	jmp    101d75 <__alltraps>

00101fb5 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $62
  101fb7:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fb9:	e9 b7 fd ff ff       	jmp    101d75 <__alltraps>

00101fbe <vector63>:
.globl vector63
vector63:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $63
  101fc0:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fc2:	e9 ae fd ff ff       	jmp    101d75 <__alltraps>

00101fc7 <vector64>:
.globl vector64
vector64:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $64
  101fc9:	6a 40                	push   $0x40
  jmp __alltraps
  101fcb:	e9 a5 fd ff ff       	jmp    101d75 <__alltraps>

00101fd0 <vector65>:
.globl vector65
vector65:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $65
  101fd2:	6a 41                	push   $0x41
  jmp __alltraps
  101fd4:	e9 9c fd ff ff       	jmp    101d75 <__alltraps>

00101fd9 <vector66>:
.globl vector66
vector66:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $66
  101fdb:	6a 42                	push   $0x42
  jmp __alltraps
  101fdd:	e9 93 fd ff ff       	jmp    101d75 <__alltraps>

00101fe2 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $67
  101fe4:	6a 43                	push   $0x43
  jmp __alltraps
  101fe6:	e9 8a fd ff ff       	jmp    101d75 <__alltraps>

00101feb <vector68>:
.globl vector68
vector68:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $68
  101fed:	6a 44                	push   $0x44
  jmp __alltraps
  101fef:	e9 81 fd ff ff       	jmp    101d75 <__alltraps>

00101ff4 <vector69>:
.globl vector69
vector69:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $69
  101ff6:	6a 45                	push   $0x45
  jmp __alltraps
  101ff8:	e9 78 fd ff ff       	jmp    101d75 <__alltraps>

00101ffd <vector70>:
.globl vector70
vector70:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $70
  101fff:	6a 46                	push   $0x46
  jmp __alltraps
  102001:	e9 6f fd ff ff       	jmp    101d75 <__alltraps>

00102006 <vector71>:
.globl vector71
vector71:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $71
  102008:	6a 47                	push   $0x47
  jmp __alltraps
  10200a:	e9 66 fd ff ff       	jmp    101d75 <__alltraps>

0010200f <vector72>:
.globl vector72
vector72:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $72
  102011:	6a 48                	push   $0x48
  jmp __alltraps
  102013:	e9 5d fd ff ff       	jmp    101d75 <__alltraps>

00102018 <vector73>:
.globl vector73
vector73:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $73
  10201a:	6a 49                	push   $0x49
  jmp __alltraps
  10201c:	e9 54 fd ff ff       	jmp    101d75 <__alltraps>

00102021 <vector74>:
.globl vector74
vector74:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $74
  102023:	6a 4a                	push   $0x4a
  jmp __alltraps
  102025:	e9 4b fd ff ff       	jmp    101d75 <__alltraps>

0010202a <vector75>:
.globl vector75
vector75:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $75
  10202c:	6a 4b                	push   $0x4b
  jmp __alltraps
  10202e:	e9 42 fd ff ff       	jmp    101d75 <__alltraps>

00102033 <vector76>:
.globl vector76
vector76:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $76
  102035:	6a 4c                	push   $0x4c
  jmp __alltraps
  102037:	e9 39 fd ff ff       	jmp    101d75 <__alltraps>

0010203c <vector77>:
.globl vector77
vector77:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $77
  10203e:	6a 4d                	push   $0x4d
  jmp __alltraps
  102040:	e9 30 fd ff ff       	jmp    101d75 <__alltraps>

00102045 <vector78>:
.globl vector78
vector78:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $78
  102047:	6a 4e                	push   $0x4e
  jmp __alltraps
  102049:	e9 27 fd ff ff       	jmp    101d75 <__alltraps>

0010204e <vector79>:
.globl vector79
vector79:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $79
  102050:	6a 4f                	push   $0x4f
  jmp __alltraps
  102052:	e9 1e fd ff ff       	jmp    101d75 <__alltraps>

00102057 <vector80>:
.globl vector80
vector80:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $80
  102059:	6a 50                	push   $0x50
  jmp __alltraps
  10205b:	e9 15 fd ff ff       	jmp    101d75 <__alltraps>

00102060 <vector81>:
.globl vector81
vector81:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $81
  102062:	6a 51                	push   $0x51
  jmp __alltraps
  102064:	e9 0c fd ff ff       	jmp    101d75 <__alltraps>

00102069 <vector82>:
.globl vector82
vector82:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $82
  10206b:	6a 52                	push   $0x52
  jmp __alltraps
  10206d:	e9 03 fd ff ff       	jmp    101d75 <__alltraps>

00102072 <vector83>:
.globl vector83
vector83:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $83
  102074:	6a 53                	push   $0x53
  jmp __alltraps
  102076:	e9 fa fc ff ff       	jmp    101d75 <__alltraps>

0010207b <vector84>:
.globl vector84
vector84:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $84
  10207d:	6a 54                	push   $0x54
  jmp __alltraps
  10207f:	e9 f1 fc ff ff       	jmp    101d75 <__alltraps>

00102084 <vector85>:
.globl vector85
vector85:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $85
  102086:	6a 55                	push   $0x55
  jmp __alltraps
  102088:	e9 e8 fc ff ff       	jmp    101d75 <__alltraps>

0010208d <vector86>:
.globl vector86
vector86:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $86
  10208f:	6a 56                	push   $0x56
  jmp __alltraps
  102091:	e9 df fc ff ff       	jmp    101d75 <__alltraps>

00102096 <vector87>:
.globl vector87
vector87:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $87
  102098:	6a 57                	push   $0x57
  jmp __alltraps
  10209a:	e9 d6 fc ff ff       	jmp    101d75 <__alltraps>

0010209f <vector88>:
.globl vector88
vector88:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $88
  1020a1:	6a 58                	push   $0x58
  jmp __alltraps
  1020a3:	e9 cd fc ff ff       	jmp    101d75 <__alltraps>

001020a8 <vector89>:
.globl vector89
vector89:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $89
  1020aa:	6a 59                	push   $0x59
  jmp __alltraps
  1020ac:	e9 c4 fc ff ff       	jmp    101d75 <__alltraps>

001020b1 <vector90>:
.globl vector90
vector90:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $90
  1020b3:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020b5:	e9 bb fc ff ff       	jmp    101d75 <__alltraps>

001020ba <vector91>:
.globl vector91
vector91:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $91
  1020bc:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020be:	e9 b2 fc ff ff       	jmp    101d75 <__alltraps>

001020c3 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $92
  1020c5:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020c7:	e9 a9 fc ff ff       	jmp    101d75 <__alltraps>

001020cc <vector93>:
.globl vector93
vector93:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $93
  1020ce:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020d0:	e9 a0 fc ff ff       	jmp    101d75 <__alltraps>

001020d5 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $94
  1020d7:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020d9:	e9 97 fc ff ff       	jmp    101d75 <__alltraps>

001020de <vector95>:
.globl vector95
vector95:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $95
  1020e0:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020e2:	e9 8e fc ff ff       	jmp    101d75 <__alltraps>

001020e7 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $96
  1020e9:	6a 60                	push   $0x60
  jmp __alltraps
  1020eb:	e9 85 fc ff ff       	jmp    101d75 <__alltraps>

001020f0 <vector97>:
.globl vector97
vector97:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $97
  1020f2:	6a 61                	push   $0x61
  jmp __alltraps
  1020f4:	e9 7c fc ff ff       	jmp    101d75 <__alltraps>

001020f9 <vector98>:
.globl vector98
vector98:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $98
  1020fb:	6a 62                	push   $0x62
  jmp __alltraps
  1020fd:	e9 73 fc ff ff       	jmp    101d75 <__alltraps>

00102102 <vector99>:
.globl vector99
vector99:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $99
  102104:	6a 63                	push   $0x63
  jmp __alltraps
  102106:	e9 6a fc ff ff       	jmp    101d75 <__alltraps>

0010210b <vector100>:
.globl vector100
vector100:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $100
  10210d:	6a 64                	push   $0x64
  jmp __alltraps
  10210f:	e9 61 fc ff ff       	jmp    101d75 <__alltraps>

00102114 <vector101>:
.globl vector101
vector101:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $101
  102116:	6a 65                	push   $0x65
  jmp __alltraps
  102118:	e9 58 fc ff ff       	jmp    101d75 <__alltraps>

0010211d <vector102>:
.globl vector102
vector102:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $102
  10211f:	6a 66                	push   $0x66
  jmp __alltraps
  102121:	e9 4f fc ff ff       	jmp    101d75 <__alltraps>

00102126 <vector103>:
.globl vector103
vector103:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $103
  102128:	6a 67                	push   $0x67
  jmp __alltraps
  10212a:	e9 46 fc ff ff       	jmp    101d75 <__alltraps>

0010212f <vector104>:
.globl vector104
vector104:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $104
  102131:	6a 68                	push   $0x68
  jmp __alltraps
  102133:	e9 3d fc ff ff       	jmp    101d75 <__alltraps>

00102138 <vector105>:
.globl vector105
vector105:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $105
  10213a:	6a 69                	push   $0x69
  jmp __alltraps
  10213c:	e9 34 fc ff ff       	jmp    101d75 <__alltraps>

00102141 <vector106>:
.globl vector106
vector106:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $106
  102143:	6a 6a                	push   $0x6a
  jmp __alltraps
  102145:	e9 2b fc ff ff       	jmp    101d75 <__alltraps>

0010214a <vector107>:
.globl vector107
vector107:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $107
  10214c:	6a 6b                	push   $0x6b
  jmp __alltraps
  10214e:	e9 22 fc ff ff       	jmp    101d75 <__alltraps>

00102153 <vector108>:
.globl vector108
vector108:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $108
  102155:	6a 6c                	push   $0x6c
  jmp __alltraps
  102157:	e9 19 fc ff ff       	jmp    101d75 <__alltraps>

0010215c <vector109>:
.globl vector109
vector109:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $109
  10215e:	6a 6d                	push   $0x6d
  jmp __alltraps
  102160:	e9 10 fc ff ff       	jmp    101d75 <__alltraps>

00102165 <vector110>:
.globl vector110
vector110:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $110
  102167:	6a 6e                	push   $0x6e
  jmp __alltraps
  102169:	e9 07 fc ff ff       	jmp    101d75 <__alltraps>

0010216e <vector111>:
.globl vector111
vector111:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $111
  102170:	6a 6f                	push   $0x6f
  jmp __alltraps
  102172:	e9 fe fb ff ff       	jmp    101d75 <__alltraps>

00102177 <vector112>:
.globl vector112
vector112:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $112
  102179:	6a 70                	push   $0x70
  jmp __alltraps
  10217b:	e9 f5 fb ff ff       	jmp    101d75 <__alltraps>

00102180 <vector113>:
.globl vector113
vector113:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $113
  102182:	6a 71                	push   $0x71
  jmp __alltraps
  102184:	e9 ec fb ff ff       	jmp    101d75 <__alltraps>

00102189 <vector114>:
.globl vector114
vector114:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $114
  10218b:	6a 72                	push   $0x72
  jmp __alltraps
  10218d:	e9 e3 fb ff ff       	jmp    101d75 <__alltraps>

00102192 <vector115>:
.globl vector115
vector115:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $115
  102194:	6a 73                	push   $0x73
  jmp __alltraps
  102196:	e9 da fb ff ff       	jmp    101d75 <__alltraps>

0010219b <vector116>:
.globl vector116
vector116:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $116
  10219d:	6a 74                	push   $0x74
  jmp __alltraps
  10219f:	e9 d1 fb ff ff       	jmp    101d75 <__alltraps>

001021a4 <vector117>:
.globl vector117
vector117:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $117
  1021a6:	6a 75                	push   $0x75
  jmp __alltraps
  1021a8:	e9 c8 fb ff ff       	jmp    101d75 <__alltraps>

001021ad <vector118>:
.globl vector118
vector118:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $118
  1021af:	6a 76                	push   $0x76
  jmp __alltraps
  1021b1:	e9 bf fb ff ff       	jmp    101d75 <__alltraps>

001021b6 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $119
  1021b8:	6a 77                	push   $0x77
  jmp __alltraps
  1021ba:	e9 b6 fb ff ff       	jmp    101d75 <__alltraps>

001021bf <vector120>:
.globl vector120
vector120:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $120
  1021c1:	6a 78                	push   $0x78
  jmp __alltraps
  1021c3:	e9 ad fb ff ff       	jmp    101d75 <__alltraps>

001021c8 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $121
  1021ca:	6a 79                	push   $0x79
  jmp __alltraps
  1021cc:	e9 a4 fb ff ff       	jmp    101d75 <__alltraps>

001021d1 <vector122>:
.globl vector122
vector122:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $122
  1021d3:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021d5:	e9 9b fb ff ff       	jmp    101d75 <__alltraps>

001021da <vector123>:
.globl vector123
vector123:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $123
  1021dc:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021de:	e9 92 fb ff ff       	jmp    101d75 <__alltraps>

001021e3 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $124
  1021e5:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021e7:	e9 89 fb ff ff       	jmp    101d75 <__alltraps>

001021ec <vector125>:
.globl vector125
vector125:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $125
  1021ee:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021f0:	e9 80 fb ff ff       	jmp    101d75 <__alltraps>

001021f5 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $126
  1021f7:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021f9:	e9 77 fb ff ff       	jmp    101d75 <__alltraps>

001021fe <vector127>:
.globl vector127
vector127:
  pushl $0
  1021fe:	6a 00                	push   $0x0
  pushl $127
  102200:	6a 7f                	push   $0x7f
  jmp __alltraps
  102202:	e9 6e fb ff ff       	jmp    101d75 <__alltraps>

00102207 <vector128>:
.globl vector128
vector128:
  pushl $0
  102207:	6a 00                	push   $0x0
  pushl $128
  102209:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10220e:	e9 62 fb ff ff       	jmp    101d75 <__alltraps>

00102213 <vector129>:
.globl vector129
vector129:
  pushl $0
  102213:	6a 00                	push   $0x0
  pushl $129
  102215:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  10221a:	e9 56 fb ff ff       	jmp    101d75 <__alltraps>

0010221f <vector130>:
.globl vector130
vector130:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $130
  102221:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102226:	e9 4a fb ff ff       	jmp    101d75 <__alltraps>

0010222b <vector131>:
.globl vector131
vector131:
  pushl $0
  10222b:	6a 00                	push   $0x0
  pushl $131
  10222d:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102232:	e9 3e fb ff ff       	jmp    101d75 <__alltraps>

00102237 <vector132>:
.globl vector132
vector132:
  pushl $0
  102237:	6a 00                	push   $0x0
  pushl $132
  102239:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10223e:	e9 32 fb ff ff       	jmp    101d75 <__alltraps>

00102243 <vector133>:
.globl vector133
vector133:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $133
  102245:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  10224a:	e9 26 fb ff ff       	jmp    101d75 <__alltraps>

0010224f <vector134>:
.globl vector134
vector134:
  pushl $0
  10224f:	6a 00                	push   $0x0
  pushl $134
  102251:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102256:	e9 1a fb ff ff       	jmp    101d75 <__alltraps>

0010225b <vector135>:
.globl vector135
vector135:
  pushl $0
  10225b:	6a 00                	push   $0x0
  pushl $135
  10225d:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102262:	e9 0e fb ff ff       	jmp    101d75 <__alltraps>

00102267 <vector136>:
.globl vector136
vector136:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $136
  102269:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10226e:	e9 02 fb ff ff       	jmp    101d75 <__alltraps>

00102273 <vector137>:
.globl vector137
vector137:
  pushl $0
  102273:	6a 00                	push   $0x0
  pushl $137
  102275:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  10227a:	e9 f6 fa ff ff       	jmp    101d75 <__alltraps>

0010227f <vector138>:
.globl vector138
vector138:
  pushl $0
  10227f:	6a 00                	push   $0x0
  pushl $138
  102281:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102286:	e9 ea fa ff ff       	jmp    101d75 <__alltraps>

0010228b <vector139>:
.globl vector139
vector139:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $139
  10228d:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102292:	e9 de fa ff ff       	jmp    101d75 <__alltraps>

00102297 <vector140>:
.globl vector140
vector140:
  pushl $0
  102297:	6a 00                	push   $0x0
  pushl $140
  102299:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10229e:	e9 d2 fa ff ff       	jmp    101d75 <__alltraps>

001022a3 <vector141>:
.globl vector141
vector141:
  pushl $0
  1022a3:	6a 00                	push   $0x0
  pushl $141
  1022a5:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1022aa:	e9 c6 fa ff ff       	jmp    101d75 <__alltraps>

001022af <vector142>:
.globl vector142
vector142:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $142
  1022b1:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022b6:	e9 ba fa ff ff       	jmp    101d75 <__alltraps>

001022bb <vector143>:
.globl vector143
vector143:
  pushl $0
  1022bb:	6a 00                	push   $0x0
  pushl $143
  1022bd:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022c2:	e9 ae fa ff ff       	jmp    101d75 <__alltraps>

001022c7 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022c7:	6a 00                	push   $0x0
  pushl $144
  1022c9:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022ce:	e9 a2 fa ff ff       	jmp    101d75 <__alltraps>

001022d3 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $145
  1022d5:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022da:	e9 96 fa ff ff       	jmp    101d75 <__alltraps>

001022df <vector146>:
.globl vector146
vector146:
  pushl $0
  1022df:	6a 00                	push   $0x0
  pushl $146
  1022e1:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022e6:	e9 8a fa ff ff       	jmp    101d75 <__alltraps>

001022eb <vector147>:
.globl vector147
vector147:
  pushl $0
  1022eb:	6a 00                	push   $0x0
  pushl $147
  1022ed:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022f2:	e9 7e fa ff ff       	jmp    101d75 <__alltraps>

001022f7 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $148
  1022f9:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022fe:	e9 72 fa ff ff       	jmp    101d75 <__alltraps>

00102303 <vector149>:
.globl vector149
vector149:
  pushl $0
  102303:	6a 00                	push   $0x0
  pushl $149
  102305:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  10230a:	e9 66 fa ff ff       	jmp    101d75 <__alltraps>

0010230f <vector150>:
.globl vector150
vector150:
  pushl $0
  10230f:	6a 00                	push   $0x0
  pushl $150
  102311:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102316:	e9 5a fa ff ff       	jmp    101d75 <__alltraps>

0010231b <vector151>:
.globl vector151
vector151:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $151
  10231d:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102322:	e9 4e fa ff ff       	jmp    101d75 <__alltraps>

00102327 <vector152>:
.globl vector152
vector152:
  pushl $0
  102327:	6a 00                	push   $0x0
  pushl $152
  102329:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10232e:	e9 42 fa ff ff       	jmp    101d75 <__alltraps>

00102333 <vector153>:
.globl vector153
vector153:
  pushl $0
  102333:	6a 00                	push   $0x0
  pushl $153
  102335:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  10233a:	e9 36 fa ff ff       	jmp    101d75 <__alltraps>

0010233f <vector154>:
.globl vector154
vector154:
  pushl $0
  10233f:	6a 00                	push   $0x0
  pushl $154
  102341:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102346:	e9 2a fa ff ff       	jmp    101d75 <__alltraps>

0010234b <vector155>:
.globl vector155
vector155:
  pushl $0
  10234b:	6a 00                	push   $0x0
  pushl $155
  10234d:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102352:	e9 1e fa ff ff       	jmp    101d75 <__alltraps>

00102357 <vector156>:
.globl vector156
vector156:
  pushl $0
  102357:	6a 00                	push   $0x0
  pushl $156
  102359:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10235e:	e9 12 fa ff ff       	jmp    101d75 <__alltraps>

00102363 <vector157>:
.globl vector157
vector157:
  pushl $0
  102363:	6a 00                	push   $0x0
  pushl $157
  102365:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  10236a:	e9 06 fa ff ff       	jmp    101d75 <__alltraps>

0010236f <vector158>:
.globl vector158
vector158:
  pushl $0
  10236f:	6a 00                	push   $0x0
  pushl $158
  102371:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102376:	e9 fa f9 ff ff       	jmp    101d75 <__alltraps>

0010237b <vector159>:
.globl vector159
vector159:
  pushl $0
  10237b:	6a 00                	push   $0x0
  pushl $159
  10237d:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102382:	e9 ee f9 ff ff       	jmp    101d75 <__alltraps>

00102387 <vector160>:
.globl vector160
vector160:
  pushl $0
  102387:	6a 00                	push   $0x0
  pushl $160
  102389:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10238e:	e9 e2 f9 ff ff       	jmp    101d75 <__alltraps>

00102393 <vector161>:
.globl vector161
vector161:
  pushl $0
  102393:	6a 00                	push   $0x0
  pushl $161
  102395:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  10239a:	e9 d6 f9 ff ff       	jmp    101d75 <__alltraps>

0010239f <vector162>:
.globl vector162
vector162:
  pushl $0
  10239f:	6a 00                	push   $0x0
  pushl $162
  1023a1:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1023a6:	e9 ca f9 ff ff       	jmp    101d75 <__alltraps>

001023ab <vector163>:
.globl vector163
vector163:
  pushl $0
  1023ab:	6a 00                	push   $0x0
  pushl $163
  1023ad:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023b2:	e9 be f9 ff ff       	jmp    101d75 <__alltraps>

001023b7 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023b7:	6a 00                	push   $0x0
  pushl $164
  1023b9:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023be:	e9 b2 f9 ff ff       	jmp    101d75 <__alltraps>

001023c3 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023c3:	6a 00                	push   $0x0
  pushl $165
  1023c5:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023ca:	e9 a6 f9 ff ff       	jmp    101d75 <__alltraps>

001023cf <vector166>:
.globl vector166
vector166:
  pushl $0
  1023cf:	6a 00                	push   $0x0
  pushl $166
  1023d1:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023d6:	e9 9a f9 ff ff       	jmp    101d75 <__alltraps>

001023db <vector167>:
.globl vector167
vector167:
  pushl $0
  1023db:	6a 00                	push   $0x0
  pushl $167
  1023dd:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023e2:	e9 8e f9 ff ff       	jmp    101d75 <__alltraps>

001023e7 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023e7:	6a 00                	push   $0x0
  pushl $168
  1023e9:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023ee:	e9 82 f9 ff ff       	jmp    101d75 <__alltraps>

001023f3 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023f3:	6a 00                	push   $0x0
  pushl $169
  1023f5:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023fa:	e9 76 f9 ff ff       	jmp    101d75 <__alltraps>

001023ff <vector170>:
.globl vector170
vector170:
  pushl $0
  1023ff:	6a 00                	push   $0x0
  pushl $170
  102401:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102406:	e9 6a f9 ff ff       	jmp    101d75 <__alltraps>

0010240b <vector171>:
.globl vector171
vector171:
  pushl $0
  10240b:	6a 00                	push   $0x0
  pushl $171
  10240d:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102412:	e9 5e f9 ff ff       	jmp    101d75 <__alltraps>

00102417 <vector172>:
.globl vector172
vector172:
  pushl $0
  102417:	6a 00                	push   $0x0
  pushl $172
  102419:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10241e:	e9 52 f9 ff ff       	jmp    101d75 <__alltraps>

00102423 <vector173>:
.globl vector173
vector173:
  pushl $0
  102423:	6a 00                	push   $0x0
  pushl $173
  102425:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  10242a:	e9 46 f9 ff ff       	jmp    101d75 <__alltraps>

0010242f <vector174>:
.globl vector174
vector174:
  pushl $0
  10242f:	6a 00                	push   $0x0
  pushl $174
  102431:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102436:	e9 3a f9 ff ff       	jmp    101d75 <__alltraps>

0010243b <vector175>:
.globl vector175
vector175:
  pushl $0
  10243b:	6a 00                	push   $0x0
  pushl $175
  10243d:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102442:	e9 2e f9 ff ff       	jmp    101d75 <__alltraps>

00102447 <vector176>:
.globl vector176
vector176:
  pushl $0
  102447:	6a 00                	push   $0x0
  pushl $176
  102449:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10244e:	e9 22 f9 ff ff       	jmp    101d75 <__alltraps>

00102453 <vector177>:
.globl vector177
vector177:
  pushl $0
  102453:	6a 00                	push   $0x0
  pushl $177
  102455:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  10245a:	e9 16 f9 ff ff       	jmp    101d75 <__alltraps>

0010245f <vector178>:
.globl vector178
vector178:
  pushl $0
  10245f:	6a 00                	push   $0x0
  pushl $178
  102461:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102466:	e9 0a f9 ff ff       	jmp    101d75 <__alltraps>

0010246b <vector179>:
.globl vector179
vector179:
  pushl $0
  10246b:	6a 00                	push   $0x0
  pushl $179
  10246d:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102472:	e9 fe f8 ff ff       	jmp    101d75 <__alltraps>

00102477 <vector180>:
.globl vector180
vector180:
  pushl $0
  102477:	6a 00                	push   $0x0
  pushl $180
  102479:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10247e:	e9 f2 f8 ff ff       	jmp    101d75 <__alltraps>

00102483 <vector181>:
.globl vector181
vector181:
  pushl $0
  102483:	6a 00                	push   $0x0
  pushl $181
  102485:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  10248a:	e9 e6 f8 ff ff       	jmp    101d75 <__alltraps>

0010248f <vector182>:
.globl vector182
vector182:
  pushl $0
  10248f:	6a 00                	push   $0x0
  pushl $182
  102491:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102496:	e9 da f8 ff ff       	jmp    101d75 <__alltraps>

0010249b <vector183>:
.globl vector183
vector183:
  pushl $0
  10249b:	6a 00                	push   $0x0
  pushl $183
  10249d:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1024a2:	e9 ce f8 ff ff       	jmp    101d75 <__alltraps>

001024a7 <vector184>:
.globl vector184
vector184:
  pushl $0
  1024a7:	6a 00                	push   $0x0
  pushl $184
  1024a9:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1024ae:	e9 c2 f8 ff ff       	jmp    101d75 <__alltraps>

001024b3 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024b3:	6a 00                	push   $0x0
  pushl $185
  1024b5:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024ba:	e9 b6 f8 ff ff       	jmp    101d75 <__alltraps>

001024bf <vector186>:
.globl vector186
vector186:
  pushl $0
  1024bf:	6a 00                	push   $0x0
  pushl $186
  1024c1:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024c6:	e9 aa f8 ff ff       	jmp    101d75 <__alltraps>

001024cb <vector187>:
.globl vector187
vector187:
  pushl $0
  1024cb:	6a 00                	push   $0x0
  pushl $187
  1024cd:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024d2:	e9 9e f8 ff ff       	jmp    101d75 <__alltraps>

001024d7 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024d7:	6a 00                	push   $0x0
  pushl $188
  1024d9:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024de:	e9 92 f8 ff ff       	jmp    101d75 <__alltraps>

001024e3 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024e3:	6a 00                	push   $0x0
  pushl $189
  1024e5:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024ea:	e9 86 f8 ff ff       	jmp    101d75 <__alltraps>

001024ef <vector190>:
.globl vector190
vector190:
  pushl $0
  1024ef:	6a 00                	push   $0x0
  pushl $190
  1024f1:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024f6:	e9 7a f8 ff ff       	jmp    101d75 <__alltraps>

001024fb <vector191>:
.globl vector191
vector191:
  pushl $0
  1024fb:	6a 00                	push   $0x0
  pushl $191
  1024fd:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  102502:	e9 6e f8 ff ff       	jmp    101d75 <__alltraps>

00102507 <vector192>:
.globl vector192
vector192:
  pushl $0
  102507:	6a 00                	push   $0x0
  pushl $192
  102509:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10250e:	e9 62 f8 ff ff       	jmp    101d75 <__alltraps>

00102513 <vector193>:
.globl vector193
vector193:
  pushl $0
  102513:	6a 00                	push   $0x0
  pushl $193
  102515:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  10251a:	e9 56 f8 ff ff       	jmp    101d75 <__alltraps>

0010251f <vector194>:
.globl vector194
vector194:
  pushl $0
  10251f:	6a 00                	push   $0x0
  pushl $194
  102521:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102526:	e9 4a f8 ff ff       	jmp    101d75 <__alltraps>

0010252b <vector195>:
.globl vector195
vector195:
  pushl $0
  10252b:	6a 00                	push   $0x0
  pushl $195
  10252d:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102532:	e9 3e f8 ff ff       	jmp    101d75 <__alltraps>

00102537 <vector196>:
.globl vector196
vector196:
  pushl $0
  102537:	6a 00                	push   $0x0
  pushl $196
  102539:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10253e:	e9 32 f8 ff ff       	jmp    101d75 <__alltraps>

00102543 <vector197>:
.globl vector197
vector197:
  pushl $0
  102543:	6a 00                	push   $0x0
  pushl $197
  102545:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  10254a:	e9 26 f8 ff ff       	jmp    101d75 <__alltraps>

0010254f <vector198>:
.globl vector198
vector198:
  pushl $0
  10254f:	6a 00                	push   $0x0
  pushl $198
  102551:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102556:	e9 1a f8 ff ff       	jmp    101d75 <__alltraps>

0010255b <vector199>:
.globl vector199
vector199:
  pushl $0
  10255b:	6a 00                	push   $0x0
  pushl $199
  10255d:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102562:	e9 0e f8 ff ff       	jmp    101d75 <__alltraps>

00102567 <vector200>:
.globl vector200
vector200:
  pushl $0
  102567:	6a 00                	push   $0x0
  pushl $200
  102569:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10256e:	e9 02 f8 ff ff       	jmp    101d75 <__alltraps>

00102573 <vector201>:
.globl vector201
vector201:
  pushl $0
  102573:	6a 00                	push   $0x0
  pushl $201
  102575:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  10257a:	e9 f6 f7 ff ff       	jmp    101d75 <__alltraps>

0010257f <vector202>:
.globl vector202
vector202:
  pushl $0
  10257f:	6a 00                	push   $0x0
  pushl $202
  102581:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102586:	e9 ea f7 ff ff       	jmp    101d75 <__alltraps>

0010258b <vector203>:
.globl vector203
vector203:
  pushl $0
  10258b:	6a 00                	push   $0x0
  pushl $203
  10258d:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102592:	e9 de f7 ff ff       	jmp    101d75 <__alltraps>

00102597 <vector204>:
.globl vector204
vector204:
  pushl $0
  102597:	6a 00                	push   $0x0
  pushl $204
  102599:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10259e:	e9 d2 f7 ff ff       	jmp    101d75 <__alltraps>

001025a3 <vector205>:
.globl vector205
vector205:
  pushl $0
  1025a3:	6a 00                	push   $0x0
  pushl $205
  1025a5:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1025aa:	e9 c6 f7 ff ff       	jmp    101d75 <__alltraps>

001025af <vector206>:
.globl vector206
vector206:
  pushl $0
  1025af:	6a 00                	push   $0x0
  pushl $206
  1025b1:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025b6:	e9 ba f7 ff ff       	jmp    101d75 <__alltraps>

001025bb <vector207>:
.globl vector207
vector207:
  pushl $0
  1025bb:	6a 00                	push   $0x0
  pushl $207
  1025bd:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025c2:	e9 ae f7 ff ff       	jmp    101d75 <__alltraps>

001025c7 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025c7:	6a 00                	push   $0x0
  pushl $208
  1025c9:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025ce:	e9 a2 f7 ff ff       	jmp    101d75 <__alltraps>

001025d3 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025d3:	6a 00                	push   $0x0
  pushl $209
  1025d5:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025da:	e9 96 f7 ff ff       	jmp    101d75 <__alltraps>

001025df <vector210>:
.globl vector210
vector210:
  pushl $0
  1025df:	6a 00                	push   $0x0
  pushl $210
  1025e1:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025e6:	e9 8a f7 ff ff       	jmp    101d75 <__alltraps>

001025eb <vector211>:
.globl vector211
vector211:
  pushl $0
  1025eb:	6a 00                	push   $0x0
  pushl $211
  1025ed:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025f2:	e9 7e f7 ff ff       	jmp    101d75 <__alltraps>

001025f7 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025f7:	6a 00                	push   $0x0
  pushl $212
  1025f9:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025fe:	e9 72 f7 ff ff       	jmp    101d75 <__alltraps>

00102603 <vector213>:
.globl vector213
vector213:
  pushl $0
  102603:	6a 00                	push   $0x0
  pushl $213
  102605:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  10260a:	e9 66 f7 ff ff       	jmp    101d75 <__alltraps>

0010260f <vector214>:
.globl vector214
vector214:
  pushl $0
  10260f:	6a 00                	push   $0x0
  pushl $214
  102611:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102616:	e9 5a f7 ff ff       	jmp    101d75 <__alltraps>

0010261b <vector215>:
.globl vector215
vector215:
  pushl $0
  10261b:	6a 00                	push   $0x0
  pushl $215
  10261d:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102622:	e9 4e f7 ff ff       	jmp    101d75 <__alltraps>

00102627 <vector216>:
.globl vector216
vector216:
  pushl $0
  102627:	6a 00                	push   $0x0
  pushl $216
  102629:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10262e:	e9 42 f7 ff ff       	jmp    101d75 <__alltraps>

00102633 <vector217>:
.globl vector217
vector217:
  pushl $0
  102633:	6a 00                	push   $0x0
  pushl $217
  102635:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  10263a:	e9 36 f7 ff ff       	jmp    101d75 <__alltraps>

0010263f <vector218>:
.globl vector218
vector218:
  pushl $0
  10263f:	6a 00                	push   $0x0
  pushl $218
  102641:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102646:	e9 2a f7 ff ff       	jmp    101d75 <__alltraps>

0010264b <vector219>:
.globl vector219
vector219:
  pushl $0
  10264b:	6a 00                	push   $0x0
  pushl $219
  10264d:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102652:	e9 1e f7 ff ff       	jmp    101d75 <__alltraps>

00102657 <vector220>:
.globl vector220
vector220:
  pushl $0
  102657:	6a 00                	push   $0x0
  pushl $220
  102659:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10265e:	e9 12 f7 ff ff       	jmp    101d75 <__alltraps>

00102663 <vector221>:
.globl vector221
vector221:
  pushl $0
  102663:	6a 00                	push   $0x0
  pushl $221
  102665:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  10266a:	e9 06 f7 ff ff       	jmp    101d75 <__alltraps>

0010266f <vector222>:
.globl vector222
vector222:
  pushl $0
  10266f:	6a 00                	push   $0x0
  pushl $222
  102671:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102676:	e9 fa f6 ff ff       	jmp    101d75 <__alltraps>

0010267b <vector223>:
.globl vector223
vector223:
  pushl $0
  10267b:	6a 00                	push   $0x0
  pushl $223
  10267d:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102682:	e9 ee f6 ff ff       	jmp    101d75 <__alltraps>

00102687 <vector224>:
.globl vector224
vector224:
  pushl $0
  102687:	6a 00                	push   $0x0
  pushl $224
  102689:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10268e:	e9 e2 f6 ff ff       	jmp    101d75 <__alltraps>

00102693 <vector225>:
.globl vector225
vector225:
  pushl $0
  102693:	6a 00                	push   $0x0
  pushl $225
  102695:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  10269a:	e9 d6 f6 ff ff       	jmp    101d75 <__alltraps>

0010269f <vector226>:
.globl vector226
vector226:
  pushl $0
  10269f:	6a 00                	push   $0x0
  pushl $226
  1026a1:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1026a6:	e9 ca f6 ff ff       	jmp    101d75 <__alltraps>

001026ab <vector227>:
.globl vector227
vector227:
  pushl $0
  1026ab:	6a 00                	push   $0x0
  pushl $227
  1026ad:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026b2:	e9 be f6 ff ff       	jmp    101d75 <__alltraps>

001026b7 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026b7:	6a 00                	push   $0x0
  pushl $228
  1026b9:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026be:	e9 b2 f6 ff ff       	jmp    101d75 <__alltraps>

001026c3 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026c3:	6a 00                	push   $0x0
  pushl $229
  1026c5:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026ca:	e9 a6 f6 ff ff       	jmp    101d75 <__alltraps>

001026cf <vector230>:
.globl vector230
vector230:
  pushl $0
  1026cf:	6a 00                	push   $0x0
  pushl $230
  1026d1:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026d6:	e9 9a f6 ff ff       	jmp    101d75 <__alltraps>

001026db <vector231>:
.globl vector231
vector231:
  pushl $0
  1026db:	6a 00                	push   $0x0
  pushl $231
  1026dd:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026e2:	e9 8e f6 ff ff       	jmp    101d75 <__alltraps>

001026e7 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026e7:	6a 00                	push   $0x0
  pushl $232
  1026e9:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026ee:	e9 82 f6 ff ff       	jmp    101d75 <__alltraps>

001026f3 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026f3:	6a 00                	push   $0x0
  pushl $233
  1026f5:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026fa:	e9 76 f6 ff ff       	jmp    101d75 <__alltraps>

001026ff <vector234>:
.globl vector234
vector234:
  pushl $0
  1026ff:	6a 00                	push   $0x0
  pushl $234
  102701:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102706:	e9 6a f6 ff ff       	jmp    101d75 <__alltraps>

0010270b <vector235>:
.globl vector235
vector235:
  pushl $0
  10270b:	6a 00                	push   $0x0
  pushl $235
  10270d:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102712:	e9 5e f6 ff ff       	jmp    101d75 <__alltraps>

00102717 <vector236>:
.globl vector236
vector236:
  pushl $0
  102717:	6a 00                	push   $0x0
  pushl $236
  102719:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10271e:	e9 52 f6 ff ff       	jmp    101d75 <__alltraps>

00102723 <vector237>:
.globl vector237
vector237:
  pushl $0
  102723:	6a 00                	push   $0x0
  pushl $237
  102725:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  10272a:	e9 46 f6 ff ff       	jmp    101d75 <__alltraps>

0010272f <vector238>:
.globl vector238
vector238:
  pushl $0
  10272f:	6a 00                	push   $0x0
  pushl $238
  102731:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102736:	e9 3a f6 ff ff       	jmp    101d75 <__alltraps>

0010273b <vector239>:
.globl vector239
vector239:
  pushl $0
  10273b:	6a 00                	push   $0x0
  pushl $239
  10273d:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102742:	e9 2e f6 ff ff       	jmp    101d75 <__alltraps>

00102747 <vector240>:
.globl vector240
vector240:
  pushl $0
  102747:	6a 00                	push   $0x0
  pushl $240
  102749:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10274e:	e9 22 f6 ff ff       	jmp    101d75 <__alltraps>

00102753 <vector241>:
.globl vector241
vector241:
  pushl $0
  102753:	6a 00                	push   $0x0
  pushl $241
  102755:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  10275a:	e9 16 f6 ff ff       	jmp    101d75 <__alltraps>

0010275f <vector242>:
.globl vector242
vector242:
  pushl $0
  10275f:	6a 00                	push   $0x0
  pushl $242
  102761:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102766:	e9 0a f6 ff ff       	jmp    101d75 <__alltraps>

0010276b <vector243>:
.globl vector243
vector243:
  pushl $0
  10276b:	6a 00                	push   $0x0
  pushl $243
  10276d:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102772:	e9 fe f5 ff ff       	jmp    101d75 <__alltraps>

00102777 <vector244>:
.globl vector244
vector244:
  pushl $0
  102777:	6a 00                	push   $0x0
  pushl $244
  102779:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10277e:	e9 f2 f5 ff ff       	jmp    101d75 <__alltraps>

00102783 <vector245>:
.globl vector245
vector245:
  pushl $0
  102783:	6a 00                	push   $0x0
  pushl $245
  102785:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  10278a:	e9 e6 f5 ff ff       	jmp    101d75 <__alltraps>

0010278f <vector246>:
.globl vector246
vector246:
  pushl $0
  10278f:	6a 00                	push   $0x0
  pushl $246
  102791:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102796:	e9 da f5 ff ff       	jmp    101d75 <__alltraps>

0010279b <vector247>:
.globl vector247
vector247:
  pushl $0
  10279b:	6a 00                	push   $0x0
  pushl $247
  10279d:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1027a2:	e9 ce f5 ff ff       	jmp    101d75 <__alltraps>

001027a7 <vector248>:
.globl vector248
vector248:
  pushl $0
  1027a7:	6a 00                	push   $0x0
  pushl $248
  1027a9:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1027ae:	e9 c2 f5 ff ff       	jmp    101d75 <__alltraps>

001027b3 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027b3:	6a 00                	push   $0x0
  pushl $249
  1027b5:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027ba:	e9 b6 f5 ff ff       	jmp    101d75 <__alltraps>

001027bf <vector250>:
.globl vector250
vector250:
  pushl $0
  1027bf:	6a 00                	push   $0x0
  pushl $250
  1027c1:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027c6:	e9 aa f5 ff ff       	jmp    101d75 <__alltraps>

001027cb <vector251>:
.globl vector251
vector251:
  pushl $0
  1027cb:	6a 00                	push   $0x0
  pushl $251
  1027cd:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027d2:	e9 9e f5 ff ff       	jmp    101d75 <__alltraps>

001027d7 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027d7:	6a 00                	push   $0x0
  pushl $252
  1027d9:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027de:	e9 92 f5 ff ff       	jmp    101d75 <__alltraps>

001027e3 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027e3:	6a 00                	push   $0x0
  pushl $253
  1027e5:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027ea:	e9 86 f5 ff ff       	jmp    101d75 <__alltraps>

001027ef <vector254>:
.globl vector254
vector254:
  pushl $0
  1027ef:	6a 00                	push   $0x0
  pushl $254
  1027f1:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027f6:	e9 7a f5 ff ff       	jmp    101d75 <__alltraps>

001027fb <vector255>:
.globl vector255
vector255:
  pushl $0
  1027fb:	6a 00                	push   $0x0
  pushl $255
  1027fd:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  102802:	e9 6e f5 ff ff       	jmp    101d75 <__alltraps>

00102807 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  102807:	55                   	push   %ebp
  102808:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  10280a:	8b 45 08             	mov    0x8(%ebp),%eax
  10280d:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  102810:	b8 23 00 00 00       	mov    $0x23,%eax
  102815:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  102817:	b8 23 00 00 00       	mov    $0x23,%eax
  10281c:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  10281e:	b8 10 00 00 00       	mov    $0x10,%eax
  102823:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  102825:	b8 10 00 00 00       	mov    $0x10,%eax
  10282a:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  10282c:	b8 10 00 00 00       	mov    $0x10,%eax
  102831:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  102833:	ea 3a 28 10 00 08 00 	ljmp   $0x8,$0x10283a
}
  10283a:	5d                   	pop    %ebp
  10283b:	c3                   	ret    

0010283c <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  10283c:	55                   	push   %ebp
  10283d:	89 e5                	mov    %esp,%ebp
  10283f:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102842:	b8 20 f9 10 00       	mov    $0x10f920,%eax
  102847:	05 00 04 00 00       	add    $0x400,%eax
  10284c:	a3 a4 f8 10 00       	mov    %eax,0x10f8a4
    ts.ts_ss0 = KERNEL_DS;
  102851:	66 c7 05 a8 f8 10 00 	movw   $0x10,0x10f8a8
  102858:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  10285a:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102861:	68 00 
  102863:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102868:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  10286e:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  102873:	c1 e8 10             	shr    $0x10,%eax
  102876:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  10287b:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102882:	83 e0 f0             	and    $0xfffffff0,%eax
  102885:	83 c8 09             	or     $0x9,%eax
  102888:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10288d:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102894:	83 c8 10             	or     $0x10,%eax
  102897:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  10289c:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028a3:	83 e0 9f             	and    $0xffffff9f,%eax
  1028a6:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028ab:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  1028b2:	83 c8 80             	or     $0xffffff80,%eax
  1028b5:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  1028ba:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028c1:	83 e0 f0             	and    $0xfffffff0,%eax
  1028c4:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028c9:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028d0:	83 e0 ef             	and    $0xffffffef,%eax
  1028d3:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028d8:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028df:	83 e0 df             	and    $0xffffffdf,%eax
  1028e2:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028e7:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028ee:	83 c8 40             	or     $0x40,%eax
  1028f1:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  1028f6:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  1028fd:	83 e0 7f             	and    $0x7f,%eax
  102900:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102905:	b8 a0 f8 10 00       	mov    $0x10f8a0,%eax
  10290a:	c1 e8 18             	shr    $0x18,%eax
  10290d:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102912:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102919:	83 e0 ef             	and    $0xffffffef,%eax
  10291c:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102921:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102928:	e8 da fe ff ff       	call   102807 <lgdt>
  10292d:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102933:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102937:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  10293a:	c9                   	leave  
  10293b:	c3                   	ret    

0010293c <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  10293c:	55                   	push   %ebp
  10293d:	89 e5                	mov    %esp,%ebp
    gdt_init();
  10293f:	e8 f8 fe ff ff       	call   10283c <gdt_init>
}
  102944:	5d                   	pop    %ebp
  102945:	c3                   	ret    

00102946 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102946:	55                   	push   %ebp
  102947:	89 e5                	mov    %esp,%ebp
  102949:	83 ec 58             	sub    $0x58,%esp
  10294c:	8b 45 10             	mov    0x10(%ebp),%eax
  10294f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102952:	8b 45 14             	mov    0x14(%ebp),%eax
  102955:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102958:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10295b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10295e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102961:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102964:	8b 45 18             	mov    0x18(%ebp),%eax
  102967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10296a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10296d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102970:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102973:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102976:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102979:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10297c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102980:	74 1c                	je     10299e <printnum+0x58>
  102982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102985:	ba 00 00 00 00       	mov    $0x0,%edx
  10298a:	f7 75 e4             	divl   -0x1c(%ebp)
  10298d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102990:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102993:	ba 00 00 00 00       	mov    $0x0,%edx
  102998:	f7 75 e4             	divl   -0x1c(%ebp)
  10299b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10299e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1029a4:	f7 75 e4             	divl   -0x1c(%ebp)
  1029a7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1029aa:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1029ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1029b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1029b6:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1029b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1029bc:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  1029bf:	8b 45 18             	mov    0x18(%ebp),%eax
  1029c2:	ba 00 00 00 00       	mov    $0x0,%edx
  1029c7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029ca:	77 56                	ja     102a22 <printnum+0xdc>
  1029cc:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1029cf:	72 05                	jb     1029d6 <printnum+0x90>
  1029d1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1029d4:	77 4c                	ja     102a22 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  1029d6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1029d9:	8d 50 ff             	lea    -0x1(%eax),%edx
  1029dc:	8b 45 20             	mov    0x20(%ebp),%eax
  1029df:	89 44 24 18          	mov    %eax,0x18(%esp)
  1029e3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1029e7:	8b 45 18             	mov    0x18(%ebp),%eax
  1029ea:	89 44 24 10          	mov    %eax,0x10(%esp)
  1029ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1029f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1029f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1029f8:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1029fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1029ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a03:	8b 45 08             	mov    0x8(%ebp),%eax
  102a06:	89 04 24             	mov    %eax,(%esp)
  102a09:	e8 38 ff ff ff       	call   102946 <printnum>
  102a0e:	eb 1c                	jmp    102a2c <printnum+0xe6>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  102a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  102a13:	89 44 24 04          	mov    %eax,0x4(%esp)
  102a17:	8b 45 20             	mov    0x20(%ebp),%eax
  102a1a:	89 04 24             	mov    %eax,(%esp)
  102a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  102a20:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  102a22:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  102a26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  102a2a:	7f e4                	jg     102a10 <printnum+0xca>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  102a2c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a2f:	05 10 3c 10 00       	add    $0x103c10,%eax
  102a34:	0f b6 00             	movzbl (%eax),%eax
  102a37:	0f be c0             	movsbl %al,%eax
  102a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a3d:	89 54 24 04          	mov    %edx,0x4(%esp)
  102a41:	89 04 24             	mov    %eax,(%esp)
  102a44:	8b 45 08             	mov    0x8(%ebp),%eax
  102a47:	ff d0                	call   *%eax
}
  102a49:	c9                   	leave  
  102a4a:	c3                   	ret    

00102a4b <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  102a4b:	55                   	push   %ebp
  102a4c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a4e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102a52:	7e 14                	jle    102a68 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  102a54:	8b 45 08             	mov    0x8(%ebp),%eax
  102a57:	8b 00                	mov    (%eax),%eax
  102a59:	8d 48 08             	lea    0x8(%eax),%ecx
  102a5c:	8b 55 08             	mov    0x8(%ebp),%edx
  102a5f:	89 0a                	mov    %ecx,(%edx)
  102a61:	8b 50 04             	mov    0x4(%eax),%edx
  102a64:	8b 00                	mov    (%eax),%eax
  102a66:	eb 30                	jmp    102a98 <getuint+0x4d>
    }
    else if (lflag) {
  102a68:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102a6c:	74 16                	je     102a84 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  102a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  102a71:	8b 00                	mov    (%eax),%eax
  102a73:	8d 48 04             	lea    0x4(%eax),%ecx
  102a76:	8b 55 08             	mov    0x8(%ebp),%edx
  102a79:	89 0a                	mov    %ecx,(%edx)
  102a7b:	8b 00                	mov    (%eax),%eax
  102a7d:	ba 00 00 00 00       	mov    $0x0,%edx
  102a82:	eb 14                	jmp    102a98 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  102a84:	8b 45 08             	mov    0x8(%ebp),%eax
  102a87:	8b 00                	mov    (%eax),%eax
  102a89:	8d 48 04             	lea    0x4(%eax),%ecx
  102a8c:	8b 55 08             	mov    0x8(%ebp),%edx
  102a8f:	89 0a                	mov    %ecx,(%edx)
  102a91:	8b 00                	mov    (%eax),%eax
  102a93:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  102a98:	5d                   	pop    %ebp
  102a99:	c3                   	ret    

00102a9a <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  102a9a:	55                   	push   %ebp
  102a9b:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  102a9d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  102aa1:	7e 14                	jle    102ab7 <getint+0x1d>
        return va_arg(*ap, long long);
  102aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  102aa6:	8b 00                	mov    (%eax),%eax
  102aa8:	8d 48 08             	lea    0x8(%eax),%ecx
  102aab:	8b 55 08             	mov    0x8(%ebp),%edx
  102aae:	89 0a                	mov    %ecx,(%edx)
  102ab0:	8b 50 04             	mov    0x4(%eax),%edx
  102ab3:	8b 00                	mov    (%eax),%eax
  102ab5:	eb 28                	jmp    102adf <getint+0x45>
    }
    else if (lflag) {
  102ab7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102abb:	74 12                	je     102acf <getint+0x35>
        return va_arg(*ap, long);
  102abd:	8b 45 08             	mov    0x8(%ebp),%eax
  102ac0:	8b 00                	mov    (%eax),%eax
  102ac2:	8d 48 04             	lea    0x4(%eax),%ecx
  102ac5:	8b 55 08             	mov    0x8(%ebp),%edx
  102ac8:	89 0a                	mov    %ecx,(%edx)
  102aca:	8b 00                	mov    (%eax),%eax
  102acc:	99                   	cltd   
  102acd:	eb 10                	jmp    102adf <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  102acf:	8b 45 08             	mov    0x8(%ebp),%eax
  102ad2:	8b 00                	mov    (%eax),%eax
  102ad4:	8d 48 04             	lea    0x4(%eax),%ecx
  102ad7:	8b 55 08             	mov    0x8(%ebp),%edx
  102ada:	89 0a                	mov    %ecx,(%edx)
  102adc:	8b 00                	mov    (%eax),%eax
  102ade:	99                   	cltd   
    }
}
  102adf:	5d                   	pop    %ebp
  102ae0:	c3                   	ret    

00102ae1 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  102ae1:	55                   	push   %ebp
  102ae2:	89 e5                	mov    %esp,%ebp
  102ae4:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  102ae7:	8d 45 14             	lea    0x14(%ebp),%eax
  102aea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  102aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102af0:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102af4:	8b 45 10             	mov    0x10(%ebp),%eax
  102af7:	89 44 24 08          	mov    %eax,0x8(%esp)
  102afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  102afe:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b02:	8b 45 08             	mov    0x8(%ebp),%eax
  102b05:	89 04 24             	mov    %eax,(%esp)
  102b08:	e8 02 00 00 00       	call   102b0f <vprintfmt>
    va_end(ap);
}
  102b0d:	c9                   	leave  
  102b0e:	c3                   	ret    

00102b0f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  102b0f:	55                   	push   %ebp
  102b10:	89 e5                	mov    %esp,%ebp
  102b12:	56                   	push   %esi
  102b13:	53                   	push   %ebx
  102b14:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b17:	eb 18                	jmp    102b31 <vprintfmt+0x22>
            if (ch == '\0') {
  102b19:	85 db                	test   %ebx,%ebx
  102b1b:	75 05                	jne    102b22 <vprintfmt+0x13>
                return;
  102b1d:	e9 d1 03 00 00       	jmp    102ef3 <vprintfmt+0x3e4>
            }
            putch(ch, putdat);
  102b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b25:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b29:	89 1c 24             	mov    %ebx,(%esp)
  102b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  102b2f:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102b31:	8b 45 10             	mov    0x10(%ebp),%eax
  102b34:	8d 50 01             	lea    0x1(%eax),%edx
  102b37:	89 55 10             	mov    %edx,0x10(%ebp)
  102b3a:	0f b6 00             	movzbl (%eax),%eax
  102b3d:	0f b6 d8             	movzbl %al,%ebx
  102b40:	83 fb 25             	cmp    $0x25,%ebx
  102b43:	75 d4                	jne    102b19 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  102b45:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  102b49:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  102b50:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102b53:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  102b56:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102b5d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102b60:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  102b63:	8b 45 10             	mov    0x10(%ebp),%eax
  102b66:	8d 50 01             	lea    0x1(%eax),%edx
  102b69:	89 55 10             	mov    %edx,0x10(%ebp)
  102b6c:	0f b6 00             	movzbl (%eax),%eax
  102b6f:	0f b6 d8             	movzbl %al,%ebx
  102b72:	8d 43 dd             	lea    -0x23(%ebx),%eax
  102b75:	83 f8 55             	cmp    $0x55,%eax
  102b78:	0f 87 44 03 00 00    	ja     102ec2 <vprintfmt+0x3b3>
  102b7e:	8b 04 85 34 3c 10 00 	mov    0x103c34(,%eax,4),%eax
  102b85:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  102b87:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  102b8b:	eb d6                	jmp    102b63 <vprintfmt+0x54>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  102b8d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  102b91:	eb d0                	jmp    102b63 <vprintfmt+0x54>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102b93:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  102b9a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102b9d:	89 d0                	mov    %edx,%eax
  102b9f:	c1 e0 02             	shl    $0x2,%eax
  102ba2:	01 d0                	add    %edx,%eax
  102ba4:	01 c0                	add    %eax,%eax
  102ba6:	01 d8                	add    %ebx,%eax
  102ba8:	83 e8 30             	sub    $0x30,%eax
  102bab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  102bae:	8b 45 10             	mov    0x10(%ebp),%eax
  102bb1:	0f b6 00             	movzbl (%eax),%eax
  102bb4:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  102bb7:	83 fb 2f             	cmp    $0x2f,%ebx
  102bba:	7e 0b                	jle    102bc7 <vprintfmt+0xb8>
  102bbc:	83 fb 39             	cmp    $0x39,%ebx
  102bbf:	7f 06                	jg     102bc7 <vprintfmt+0xb8>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  102bc1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  102bc5:	eb d3                	jmp    102b9a <vprintfmt+0x8b>
            goto process_precision;
  102bc7:	eb 33                	jmp    102bfc <vprintfmt+0xed>

        case '*':
            precision = va_arg(ap, int);
  102bc9:	8b 45 14             	mov    0x14(%ebp),%eax
  102bcc:	8d 50 04             	lea    0x4(%eax),%edx
  102bcf:	89 55 14             	mov    %edx,0x14(%ebp)
  102bd2:	8b 00                	mov    (%eax),%eax
  102bd4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  102bd7:	eb 23                	jmp    102bfc <vprintfmt+0xed>

        case '.':
            if (width < 0)
  102bd9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102bdd:	79 0c                	jns    102beb <vprintfmt+0xdc>
                width = 0;
  102bdf:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  102be6:	e9 78 ff ff ff       	jmp    102b63 <vprintfmt+0x54>
  102beb:	e9 73 ff ff ff       	jmp    102b63 <vprintfmt+0x54>

        case '#':
            altflag = 1;
  102bf0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  102bf7:	e9 67 ff ff ff       	jmp    102b63 <vprintfmt+0x54>

        process_precision:
            if (width < 0)
  102bfc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102c00:	79 12                	jns    102c14 <vprintfmt+0x105>
                width = precision, precision = -1;
  102c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102c05:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102c08:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  102c0f:	e9 4f ff ff ff       	jmp    102b63 <vprintfmt+0x54>
  102c14:	e9 4a ff ff ff       	jmp    102b63 <vprintfmt+0x54>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  102c19:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  102c1d:	e9 41 ff ff ff       	jmp    102b63 <vprintfmt+0x54>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  102c22:	8b 45 14             	mov    0x14(%ebp),%eax
  102c25:	8d 50 04             	lea    0x4(%eax),%edx
  102c28:	89 55 14             	mov    %edx,0x14(%ebp)
  102c2b:	8b 00                	mov    (%eax),%eax
  102c2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  102c30:	89 54 24 04          	mov    %edx,0x4(%esp)
  102c34:	89 04 24             	mov    %eax,(%esp)
  102c37:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3a:	ff d0                	call   *%eax
            break;
  102c3c:	e9 ac 02 00 00       	jmp    102eed <vprintfmt+0x3de>

        // error message
        case 'e':
            err = va_arg(ap, int);
  102c41:	8b 45 14             	mov    0x14(%ebp),%eax
  102c44:	8d 50 04             	lea    0x4(%eax),%edx
  102c47:	89 55 14             	mov    %edx,0x14(%ebp)
  102c4a:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  102c4c:	85 db                	test   %ebx,%ebx
  102c4e:	79 02                	jns    102c52 <vprintfmt+0x143>
                err = -err;
  102c50:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  102c52:	83 fb 06             	cmp    $0x6,%ebx
  102c55:	7f 0b                	jg     102c62 <vprintfmt+0x153>
  102c57:	8b 34 9d f4 3b 10 00 	mov    0x103bf4(,%ebx,4),%esi
  102c5e:	85 f6                	test   %esi,%esi
  102c60:	75 23                	jne    102c85 <vprintfmt+0x176>
                printfmt(putch, putdat, "error %d", err);
  102c62:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  102c66:	c7 44 24 08 21 3c 10 	movl   $0x103c21,0x8(%esp)
  102c6d:	00 
  102c6e:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c71:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c75:	8b 45 08             	mov    0x8(%ebp),%eax
  102c78:	89 04 24             	mov    %eax,(%esp)
  102c7b:	e8 61 fe ff ff       	call   102ae1 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  102c80:	e9 68 02 00 00       	jmp    102eed <vprintfmt+0x3de>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  102c85:	89 74 24 0c          	mov    %esi,0xc(%esp)
  102c89:	c7 44 24 08 2a 3c 10 	movl   $0x103c2a,0x8(%esp)
  102c90:	00 
  102c91:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c94:	89 44 24 04          	mov    %eax,0x4(%esp)
  102c98:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9b:	89 04 24             	mov    %eax,(%esp)
  102c9e:	e8 3e fe ff ff       	call   102ae1 <printfmt>
            }
            break;
  102ca3:	e9 45 02 00 00       	jmp    102eed <vprintfmt+0x3de>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  102ca8:	8b 45 14             	mov    0x14(%ebp),%eax
  102cab:	8d 50 04             	lea    0x4(%eax),%edx
  102cae:	89 55 14             	mov    %edx,0x14(%ebp)
  102cb1:	8b 30                	mov    (%eax),%esi
  102cb3:	85 f6                	test   %esi,%esi
  102cb5:	75 05                	jne    102cbc <vprintfmt+0x1ad>
                p = "(null)";
  102cb7:	be 2d 3c 10 00       	mov    $0x103c2d,%esi
            }
            if (width > 0 && padc != '-') {
  102cbc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cc0:	7e 3e                	jle    102d00 <vprintfmt+0x1f1>
  102cc2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  102cc6:	74 38                	je     102d00 <vprintfmt+0x1f1>
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cc8:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  102ccb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cce:	89 44 24 04          	mov    %eax,0x4(%esp)
  102cd2:	89 34 24             	mov    %esi,(%esp)
  102cd5:	e8 15 03 00 00       	call   102fef <strnlen>
  102cda:	29 c3                	sub    %eax,%ebx
  102cdc:	89 d8                	mov    %ebx,%eax
  102cde:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102ce1:	eb 17                	jmp    102cfa <vprintfmt+0x1eb>
                    putch(padc, putdat);
  102ce3:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  102ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  102cea:	89 54 24 04          	mov    %edx,0x4(%esp)
  102cee:	89 04 24             	mov    %eax,(%esp)
  102cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf4:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  102cf6:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102cfa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102cfe:	7f e3                	jg     102ce3 <vprintfmt+0x1d4>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d00:	eb 38                	jmp    102d3a <vprintfmt+0x22b>
                if (altflag && (ch < ' ' || ch > '~')) {
  102d02:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  102d06:	74 1f                	je     102d27 <vprintfmt+0x218>
  102d08:	83 fb 1f             	cmp    $0x1f,%ebx
  102d0b:	7e 05                	jle    102d12 <vprintfmt+0x203>
  102d0d:	83 fb 7e             	cmp    $0x7e,%ebx
  102d10:	7e 15                	jle    102d27 <vprintfmt+0x218>
                    putch('?', putdat);
  102d12:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d15:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d19:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  102d20:	8b 45 08             	mov    0x8(%ebp),%eax
  102d23:	ff d0                	call   *%eax
  102d25:	eb 0f                	jmp    102d36 <vprintfmt+0x227>
                }
                else {
                    putch(ch, putdat);
  102d27:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d2e:	89 1c 24             	mov    %ebx,(%esp)
  102d31:	8b 45 08             	mov    0x8(%ebp),%eax
  102d34:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  102d36:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d3a:	89 f0                	mov    %esi,%eax
  102d3c:	8d 70 01             	lea    0x1(%eax),%esi
  102d3f:	0f b6 00             	movzbl (%eax),%eax
  102d42:	0f be d8             	movsbl %al,%ebx
  102d45:	85 db                	test   %ebx,%ebx
  102d47:	74 10                	je     102d59 <vprintfmt+0x24a>
  102d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d4d:	78 b3                	js     102d02 <vprintfmt+0x1f3>
  102d4f:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  102d53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d57:	79 a9                	jns    102d02 <vprintfmt+0x1f3>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d59:	eb 17                	jmp    102d72 <vprintfmt+0x263>
                putch(' ', putdat);
  102d5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102d5e:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d62:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  102d69:	8b 45 08             	mov    0x8(%ebp),%eax
  102d6c:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  102d6e:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  102d72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  102d76:	7f e3                	jg     102d5b <vprintfmt+0x24c>
                putch(' ', putdat);
            }
            break;
  102d78:	e9 70 01 00 00       	jmp    102eed <vprintfmt+0x3de>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  102d7d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d80:	89 44 24 04          	mov    %eax,0x4(%esp)
  102d84:	8d 45 14             	lea    0x14(%ebp),%eax
  102d87:	89 04 24             	mov    %eax,(%esp)
  102d8a:	e8 0b fd ff ff       	call   102a9a <getint>
  102d8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102d92:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  102d95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d98:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102d9b:	85 d2                	test   %edx,%edx
  102d9d:	79 26                	jns    102dc5 <vprintfmt+0x2b6>
                putch('-', putdat);
  102d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102da2:	89 44 24 04          	mov    %eax,0x4(%esp)
  102da6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  102dad:	8b 45 08             	mov    0x8(%ebp),%eax
  102db0:	ff d0                	call   *%eax
                num = -(long long)num;
  102db2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102db5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102db8:	f7 d8                	neg    %eax
  102dba:	83 d2 00             	adc    $0x0,%edx
  102dbd:	f7 da                	neg    %edx
  102dbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102dc2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  102dc5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102dcc:	e9 a8 00 00 00       	jmp    102e79 <vprintfmt+0x36a>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  102dd1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102dd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dd8:	8d 45 14             	lea    0x14(%ebp),%eax
  102ddb:	89 04 24             	mov    %eax,(%esp)
  102dde:	e8 68 fc ff ff       	call   102a4b <getuint>
  102de3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102de6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  102de9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  102df0:	e9 84 00 00 00       	jmp    102e79 <vprintfmt+0x36a>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  102df5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102df8:	89 44 24 04          	mov    %eax,0x4(%esp)
  102dfc:	8d 45 14             	lea    0x14(%ebp),%eax
  102dff:	89 04 24             	mov    %eax,(%esp)
  102e02:	e8 44 fc ff ff       	call   102a4b <getuint>
  102e07:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e0a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  102e0d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  102e14:	eb 63                	jmp    102e79 <vprintfmt+0x36a>

        // pointer
        case 'p':
            putch('0', putdat);
  102e16:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e19:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e1d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  102e24:	8b 45 08             	mov    0x8(%ebp),%eax
  102e27:	ff d0                	call   *%eax
            putch('x', putdat);
  102e29:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e2c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e30:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  102e37:	8b 45 08             	mov    0x8(%ebp),%eax
  102e3a:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  102e3c:	8b 45 14             	mov    0x14(%ebp),%eax
  102e3f:	8d 50 04             	lea    0x4(%eax),%edx
  102e42:	89 55 14             	mov    %edx,0x14(%ebp)
  102e45:	8b 00                	mov    (%eax),%eax
  102e47:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  102e51:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  102e58:	eb 1f                	jmp    102e79 <vprintfmt+0x36a>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  102e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102e5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  102e61:	8d 45 14             	lea    0x14(%ebp),%eax
  102e64:	89 04 24             	mov    %eax,(%esp)
  102e67:	e8 df fb ff ff       	call   102a4b <getuint>
  102e6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e6f:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  102e72:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  102e79:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  102e7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e80:	89 54 24 18          	mov    %edx,0x18(%esp)
  102e84:	8b 55 e8             	mov    -0x18(%ebp),%edx
  102e87:	89 54 24 14          	mov    %edx,0x14(%esp)
  102e8b:	89 44 24 10          	mov    %eax,0x10(%esp)
  102e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e92:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102e95:	89 44 24 08          	mov    %eax,0x8(%esp)
  102e99:	89 54 24 0c          	mov    %edx,0xc(%esp)
  102e9d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ea0:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  102ea7:	89 04 24             	mov    %eax,(%esp)
  102eaa:	e8 97 fa ff ff       	call   102946 <printnum>
            break;
  102eaf:	eb 3c                	jmp    102eed <vprintfmt+0x3de>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  102eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  102eb4:	89 44 24 04          	mov    %eax,0x4(%esp)
  102eb8:	89 1c 24             	mov    %ebx,(%esp)
  102ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebe:	ff d0                	call   *%eax
            break;
  102ec0:	eb 2b                	jmp    102eed <vprintfmt+0x3de>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  102ec2:	8b 45 0c             	mov    0xc(%ebp),%eax
  102ec5:	89 44 24 04          	mov    %eax,0x4(%esp)
  102ec9:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  102ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed3:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  102ed5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102ed9:	eb 04                	jmp    102edf <vprintfmt+0x3d0>
  102edb:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  102edf:	8b 45 10             	mov    0x10(%ebp),%eax
  102ee2:	83 e8 01             	sub    $0x1,%eax
  102ee5:	0f b6 00             	movzbl (%eax),%eax
  102ee8:	3c 25                	cmp    $0x25,%al
  102eea:	75 ef                	jne    102edb <vprintfmt+0x3cc>
                /* do nothing */;
            break;
  102eec:	90                   	nop
        }
    }
  102eed:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  102eee:	e9 3e fc ff ff       	jmp    102b31 <vprintfmt+0x22>
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  102ef3:	83 c4 40             	add    $0x40,%esp
  102ef6:	5b                   	pop    %ebx
  102ef7:	5e                   	pop    %esi
  102ef8:	5d                   	pop    %ebp
  102ef9:	c3                   	ret    

00102efa <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  102efa:	55                   	push   %ebp
  102efb:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  102efd:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f00:	8b 40 08             	mov    0x8(%eax),%eax
  102f03:	8d 50 01             	lea    0x1(%eax),%edx
  102f06:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f09:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  102f0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f0f:	8b 10                	mov    (%eax),%edx
  102f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f14:	8b 40 04             	mov    0x4(%eax),%eax
  102f17:	39 c2                	cmp    %eax,%edx
  102f19:	73 12                	jae    102f2d <sprintputch+0x33>
        *b->buf ++ = ch;
  102f1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f1e:	8b 00                	mov    (%eax),%eax
  102f20:	8d 48 01             	lea    0x1(%eax),%ecx
  102f23:	8b 55 0c             	mov    0xc(%ebp),%edx
  102f26:	89 0a                	mov    %ecx,(%edx)
  102f28:	8b 55 08             	mov    0x8(%ebp),%edx
  102f2b:	88 10                	mov    %dl,(%eax)
    }
}
  102f2d:	5d                   	pop    %ebp
  102f2e:	c3                   	ret    

00102f2f <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  102f2f:	55                   	push   %ebp
  102f30:	89 e5                	mov    %esp,%ebp
  102f32:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  102f35:	8d 45 14             	lea    0x14(%ebp),%eax
  102f38:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  102f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f3e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102f42:	8b 45 10             	mov    0x10(%ebp),%eax
  102f45:	89 44 24 08          	mov    %eax,0x8(%esp)
  102f49:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f4c:	89 44 24 04          	mov    %eax,0x4(%esp)
  102f50:	8b 45 08             	mov    0x8(%ebp),%eax
  102f53:	89 04 24             	mov    %eax,(%esp)
  102f56:	e8 08 00 00 00       	call   102f63 <vsnprintf>
  102f5b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  102f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102f61:	c9                   	leave  
  102f62:	c3                   	ret    

00102f63 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  102f63:	55                   	push   %ebp
  102f64:	89 e5                	mov    %esp,%ebp
  102f66:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  102f69:	8b 45 08             	mov    0x8(%ebp),%eax
  102f6c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f72:	8d 50 ff             	lea    -0x1(%eax),%edx
  102f75:	8b 45 08             	mov    0x8(%ebp),%eax
  102f78:	01 d0                	add    %edx,%eax
  102f7a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f7d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  102f84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102f88:	74 0a                	je     102f94 <vsnprintf+0x31>
  102f8a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102f8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f90:	39 c2                	cmp    %eax,%edx
  102f92:	76 07                	jbe    102f9b <vsnprintf+0x38>
        return -E_INVAL;
  102f94:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  102f99:	eb 2a                	jmp    102fc5 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  102f9b:	8b 45 14             	mov    0x14(%ebp),%eax
  102f9e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102fa2:	8b 45 10             	mov    0x10(%ebp),%eax
  102fa5:	89 44 24 08          	mov    %eax,0x8(%esp)
  102fa9:	8d 45 ec             	lea    -0x14(%ebp),%eax
  102fac:	89 44 24 04          	mov    %eax,0x4(%esp)
  102fb0:	c7 04 24 fa 2e 10 00 	movl   $0x102efa,(%esp)
  102fb7:	e8 53 fb ff ff       	call   102b0f <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  102fbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fbf:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  102fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102fc5:	c9                   	leave  
  102fc6:	c3                   	ret    

00102fc7 <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102fc7:	55                   	push   %ebp
  102fc8:	89 e5                	mov    %esp,%ebp
  102fca:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102fcd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102fd4:	eb 04                	jmp    102fda <strlen+0x13>
        cnt ++;
  102fd6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  102fda:	8b 45 08             	mov    0x8(%ebp),%eax
  102fdd:	8d 50 01             	lea    0x1(%eax),%edx
  102fe0:	89 55 08             	mov    %edx,0x8(%ebp)
  102fe3:	0f b6 00             	movzbl (%eax),%eax
  102fe6:	84 c0                	test   %al,%al
  102fe8:	75 ec                	jne    102fd6 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  102fea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102fed:	c9                   	leave  
  102fee:	c3                   	ret    

00102fef <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102fef:	55                   	push   %ebp
  102ff0:	89 e5                	mov    %esp,%ebp
  102ff2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102ff5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102ffc:	eb 04                	jmp    103002 <strnlen+0x13>
        cnt ++;
  102ffe:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  103002:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103005:	3b 45 0c             	cmp    0xc(%ebp),%eax
  103008:	73 10                	jae    10301a <strnlen+0x2b>
  10300a:	8b 45 08             	mov    0x8(%ebp),%eax
  10300d:	8d 50 01             	lea    0x1(%eax),%edx
  103010:	89 55 08             	mov    %edx,0x8(%ebp)
  103013:	0f b6 00             	movzbl (%eax),%eax
  103016:	84 c0                	test   %al,%al
  103018:	75 e4                	jne    102ffe <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  10301a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  10301d:	c9                   	leave  
  10301e:	c3                   	ret    

0010301f <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  10301f:	55                   	push   %ebp
  103020:	89 e5                	mov    %esp,%ebp
  103022:	57                   	push   %edi
  103023:	56                   	push   %esi
  103024:	83 ec 20             	sub    $0x20,%esp
  103027:	8b 45 08             	mov    0x8(%ebp),%eax
  10302a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10302d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103030:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  103033:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103036:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103039:	89 d1                	mov    %edx,%ecx
  10303b:	89 c2                	mov    %eax,%edx
  10303d:	89 ce                	mov    %ecx,%esi
  10303f:	89 d7                	mov    %edx,%edi
  103041:	ac                   	lods   %ds:(%esi),%al
  103042:	aa                   	stos   %al,%es:(%edi)
  103043:	84 c0                	test   %al,%al
  103045:	75 fa                	jne    103041 <strcpy+0x22>
  103047:	89 fa                	mov    %edi,%edx
  103049:	89 f1                	mov    %esi,%ecx
  10304b:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  10304e:	89 55 e8             	mov    %edx,-0x18(%ebp)
  103051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  103054:	8b 45 f4             	mov    -0xc(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  103057:	83 c4 20             	add    $0x20,%esp
  10305a:	5e                   	pop    %esi
  10305b:	5f                   	pop    %edi
  10305c:	5d                   	pop    %ebp
  10305d:	c3                   	ret    

0010305e <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  10305e:	55                   	push   %ebp
  10305f:	89 e5                	mov    %esp,%ebp
  103061:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  103064:	8b 45 08             	mov    0x8(%ebp),%eax
  103067:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  10306a:	eb 21                	jmp    10308d <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  10306c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306f:	0f b6 10             	movzbl (%eax),%edx
  103072:	8b 45 fc             	mov    -0x4(%ebp),%eax
  103075:	88 10                	mov    %dl,(%eax)
  103077:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10307a:	0f b6 00             	movzbl (%eax),%eax
  10307d:	84 c0                	test   %al,%al
  10307f:	74 04                	je     103085 <strncpy+0x27>
            src ++;
  103081:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  103085:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103089:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  10308d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103091:	75 d9                	jne    10306c <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  103093:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103096:	c9                   	leave  
  103097:	c3                   	ret    

00103098 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  103098:	55                   	push   %ebp
  103099:	89 e5                	mov    %esp,%ebp
  10309b:	57                   	push   %edi
  10309c:	56                   	push   %esi
  10309d:	83 ec 20             	sub    $0x20,%esp
  1030a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1030a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1030a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1030a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  1030ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1030af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b2:	89 d1                	mov    %edx,%ecx
  1030b4:	89 c2                	mov    %eax,%edx
  1030b6:	89 ce                	mov    %ecx,%esi
  1030b8:	89 d7                	mov    %edx,%edi
  1030ba:	ac                   	lods   %ds:(%esi),%al
  1030bb:	ae                   	scas   %es:(%edi),%al
  1030bc:	75 08                	jne    1030c6 <strcmp+0x2e>
  1030be:	84 c0                	test   %al,%al
  1030c0:	75 f8                	jne    1030ba <strcmp+0x22>
  1030c2:	31 c0                	xor    %eax,%eax
  1030c4:	eb 04                	jmp    1030ca <strcmp+0x32>
  1030c6:	19 c0                	sbb    %eax,%eax
  1030c8:	0c 01                	or     $0x1,%al
  1030ca:	89 fa                	mov    %edi,%edx
  1030cc:	89 f1                	mov    %esi,%ecx
  1030ce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030d1:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1030d4:	89 55 e4             	mov    %edx,-0x1c(%ebp)
            "orb $1, %%al;"
            "3:"
            : "=a" (ret), "=&S" (d0), "=&D" (d1)
            : "1" (s1), "2" (s2)
            : "memory");
    return ret;
  1030d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1030da:	83 c4 20             	add    $0x20,%esp
  1030dd:	5e                   	pop    %esi
  1030de:	5f                   	pop    %edi
  1030df:	5d                   	pop    %ebp
  1030e0:	c3                   	ret    

001030e1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1030e1:	55                   	push   %ebp
  1030e2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030e4:	eb 0c                	jmp    1030f2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  1030e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  1030ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1030ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1030f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1030f6:	74 1a                	je     103112 <strncmp+0x31>
  1030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1030fb:	0f b6 00             	movzbl (%eax),%eax
  1030fe:	84 c0                	test   %al,%al
  103100:	74 10                	je     103112 <strncmp+0x31>
  103102:	8b 45 08             	mov    0x8(%ebp),%eax
  103105:	0f b6 10             	movzbl (%eax),%edx
  103108:	8b 45 0c             	mov    0xc(%ebp),%eax
  10310b:	0f b6 00             	movzbl (%eax),%eax
  10310e:	38 c2                	cmp    %al,%dl
  103110:	74 d4                	je     1030e6 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  103112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103116:	74 18                	je     103130 <strncmp+0x4f>
  103118:	8b 45 08             	mov    0x8(%ebp),%eax
  10311b:	0f b6 00             	movzbl (%eax),%eax
  10311e:	0f b6 d0             	movzbl %al,%edx
  103121:	8b 45 0c             	mov    0xc(%ebp),%eax
  103124:	0f b6 00             	movzbl (%eax),%eax
  103127:	0f b6 c0             	movzbl %al,%eax
  10312a:	29 c2                	sub    %eax,%edx
  10312c:	89 d0                	mov    %edx,%eax
  10312e:	eb 05                	jmp    103135 <strncmp+0x54>
  103130:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103135:	5d                   	pop    %ebp
  103136:	c3                   	ret    

00103137 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  103137:	55                   	push   %ebp
  103138:	89 e5                	mov    %esp,%ebp
  10313a:	83 ec 04             	sub    $0x4,%esp
  10313d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103140:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103143:	eb 14                	jmp    103159 <strchr+0x22>
        if (*s == c) {
  103145:	8b 45 08             	mov    0x8(%ebp),%eax
  103148:	0f b6 00             	movzbl (%eax),%eax
  10314b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  10314e:	75 05                	jne    103155 <strchr+0x1e>
            return (char *)s;
  103150:	8b 45 08             	mov    0x8(%ebp),%eax
  103153:	eb 13                	jmp    103168 <strchr+0x31>
        }
        s ++;
  103155:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  103159:	8b 45 08             	mov    0x8(%ebp),%eax
  10315c:	0f b6 00             	movzbl (%eax),%eax
  10315f:	84 c0                	test   %al,%al
  103161:	75 e2                	jne    103145 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  103163:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103168:	c9                   	leave  
  103169:	c3                   	ret    

0010316a <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10316a:	55                   	push   %ebp
  10316b:	89 e5                	mov    %esp,%ebp
  10316d:	83 ec 04             	sub    $0x4,%esp
  103170:	8b 45 0c             	mov    0xc(%ebp),%eax
  103173:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  103176:	eb 11                	jmp    103189 <strfind+0x1f>
        if (*s == c) {
  103178:	8b 45 08             	mov    0x8(%ebp),%eax
  10317b:	0f b6 00             	movzbl (%eax),%eax
  10317e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  103181:	75 02                	jne    103185 <strfind+0x1b>
            break;
  103183:	eb 0e                	jmp    103193 <strfind+0x29>
        }
        s ++;
  103185:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  103189:	8b 45 08             	mov    0x8(%ebp),%eax
  10318c:	0f b6 00             	movzbl (%eax),%eax
  10318f:	84 c0                	test   %al,%al
  103191:	75 e5                	jne    103178 <strfind+0xe>
        if (*s == c) {
            break;
        }
        s ++;
    }
    return (char *)s;
  103193:	8b 45 08             	mov    0x8(%ebp),%eax
}
  103196:	c9                   	leave  
  103197:	c3                   	ret    

00103198 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  103198:	55                   	push   %ebp
  103199:	89 e5                	mov    %esp,%ebp
  10319b:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  10319e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1031a5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031ac:	eb 04                	jmp    1031b2 <strtol+0x1a>
        s ++;
  1031ae:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1031b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1031b5:	0f b6 00             	movzbl (%eax),%eax
  1031b8:	3c 20                	cmp    $0x20,%al
  1031ba:	74 f2                	je     1031ae <strtol+0x16>
  1031bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1031bf:	0f b6 00             	movzbl (%eax),%eax
  1031c2:	3c 09                	cmp    $0x9,%al
  1031c4:	74 e8                	je     1031ae <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  1031c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031c9:	0f b6 00             	movzbl (%eax),%eax
  1031cc:	3c 2b                	cmp    $0x2b,%al
  1031ce:	75 06                	jne    1031d6 <strtol+0x3e>
        s ++;
  1031d0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031d4:	eb 15                	jmp    1031eb <strtol+0x53>
    }
    else if (*s == '-') {
  1031d6:	8b 45 08             	mov    0x8(%ebp),%eax
  1031d9:	0f b6 00             	movzbl (%eax),%eax
  1031dc:	3c 2d                	cmp    $0x2d,%al
  1031de:	75 0b                	jne    1031eb <strtol+0x53>
        s ++, neg = 1;
  1031e0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1031e4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1031eb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1031ef:	74 06                	je     1031f7 <strtol+0x5f>
  1031f1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  1031f5:	75 24                	jne    10321b <strtol+0x83>
  1031f7:	8b 45 08             	mov    0x8(%ebp),%eax
  1031fa:	0f b6 00             	movzbl (%eax),%eax
  1031fd:	3c 30                	cmp    $0x30,%al
  1031ff:	75 1a                	jne    10321b <strtol+0x83>
  103201:	8b 45 08             	mov    0x8(%ebp),%eax
  103204:	83 c0 01             	add    $0x1,%eax
  103207:	0f b6 00             	movzbl (%eax),%eax
  10320a:	3c 78                	cmp    $0x78,%al
  10320c:	75 0d                	jne    10321b <strtol+0x83>
        s += 2, base = 16;
  10320e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  103212:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  103219:	eb 2a                	jmp    103245 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  10321b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10321f:	75 17                	jne    103238 <strtol+0xa0>
  103221:	8b 45 08             	mov    0x8(%ebp),%eax
  103224:	0f b6 00             	movzbl (%eax),%eax
  103227:	3c 30                	cmp    $0x30,%al
  103229:	75 0d                	jne    103238 <strtol+0xa0>
        s ++, base = 8;
  10322b:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  10322f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  103236:	eb 0d                	jmp    103245 <strtol+0xad>
    }
    else if (base == 0) {
  103238:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10323c:	75 07                	jne    103245 <strtol+0xad>
        base = 10;
  10323e:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  103245:	8b 45 08             	mov    0x8(%ebp),%eax
  103248:	0f b6 00             	movzbl (%eax),%eax
  10324b:	3c 2f                	cmp    $0x2f,%al
  10324d:	7e 1b                	jle    10326a <strtol+0xd2>
  10324f:	8b 45 08             	mov    0x8(%ebp),%eax
  103252:	0f b6 00             	movzbl (%eax),%eax
  103255:	3c 39                	cmp    $0x39,%al
  103257:	7f 11                	jg     10326a <strtol+0xd2>
            dig = *s - '0';
  103259:	8b 45 08             	mov    0x8(%ebp),%eax
  10325c:	0f b6 00             	movzbl (%eax),%eax
  10325f:	0f be c0             	movsbl %al,%eax
  103262:	83 e8 30             	sub    $0x30,%eax
  103265:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103268:	eb 48                	jmp    1032b2 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  10326a:	8b 45 08             	mov    0x8(%ebp),%eax
  10326d:	0f b6 00             	movzbl (%eax),%eax
  103270:	3c 60                	cmp    $0x60,%al
  103272:	7e 1b                	jle    10328f <strtol+0xf7>
  103274:	8b 45 08             	mov    0x8(%ebp),%eax
  103277:	0f b6 00             	movzbl (%eax),%eax
  10327a:	3c 7a                	cmp    $0x7a,%al
  10327c:	7f 11                	jg     10328f <strtol+0xf7>
            dig = *s - 'a' + 10;
  10327e:	8b 45 08             	mov    0x8(%ebp),%eax
  103281:	0f b6 00             	movzbl (%eax),%eax
  103284:	0f be c0             	movsbl %al,%eax
  103287:	83 e8 57             	sub    $0x57,%eax
  10328a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10328d:	eb 23                	jmp    1032b2 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10328f:	8b 45 08             	mov    0x8(%ebp),%eax
  103292:	0f b6 00             	movzbl (%eax),%eax
  103295:	3c 40                	cmp    $0x40,%al
  103297:	7e 3d                	jle    1032d6 <strtol+0x13e>
  103299:	8b 45 08             	mov    0x8(%ebp),%eax
  10329c:	0f b6 00             	movzbl (%eax),%eax
  10329f:	3c 5a                	cmp    $0x5a,%al
  1032a1:	7f 33                	jg     1032d6 <strtol+0x13e>
            dig = *s - 'A' + 10;
  1032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a6:	0f b6 00             	movzbl (%eax),%eax
  1032a9:	0f be c0             	movsbl %al,%eax
  1032ac:	83 e8 37             	sub    $0x37,%eax
  1032af:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1032b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032b5:	3b 45 10             	cmp    0x10(%ebp),%eax
  1032b8:	7c 02                	jl     1032bc <strtol+0x124>
            break;
  1032ba:	eb 1a                	jmp    1032d6 <strtol+0x13e>
        }
        s ++, val = (val * base) + dig;
  1032bc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1032c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032c3:	0f af 45 10          	imul   0x10(%ebp),%eax
  1032c7:	89 c2                	mov    %eax,%edx
  1032c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032cc:	01 d0                	add    %edx,%eax
  1032ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1032d1:	e9 6f ff ff ff       	jmp    103245 <strtol+0xad>

    if (endptr) {
  1032d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1032da:	74 08                	je     1032e4 <strtol+0x14c>
        *endptr = (char *) s;
  1032dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032df:	8b 55 08             	mov    0x8(%ebp),%edx
  1032e2:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1032e4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1032e8:	74 07                	je     1032f1 <strtol+0x159>
  1032ea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1032ed:	f7 d8                	neg    %eax
  1032ef:	eb 03                	jmp    1032f4 <strtol+0x15c>
  1032f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1032f4:	c9                   	leave  
  1032f5:	c3                   	ret    

001032f6 <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1032f6:	55                   	push   %ebp
  1032f7:	89 e5                	mov    %esp,%ebp
  1032f9:	57                   	push   %edi
  1032fa:	83 ec 24             	sub    $0x24,%esp
  1032fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  103300:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  103303:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  103307:	8b 55 08             	mov    0x8(%ebp),%edx
  10330a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  10330d:	88 45 f7             	mov    %al,-0x9(%ebp)
  103310:	8b 45 10             	mov    0x10(%ebp),%eax
  103313:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  103316:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  103319:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  10331d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  103320:	89 d7                	mov    %edx,%edi
  103322:	f3 aa                	rep stos %al,%es:(%edi)
  103324:	89 fa                	mov    %edi,%edx
  103326:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  103329:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  10332c:	8b 45 f8             	mov    -0x8(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10332f:	83 c4 24             	add    $0x24,%esp
  103332:	5f                   	pop    %edi
  103333:	5d                   	pop    %ebp
  103334:	c3                   	ret    

00103335 <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  103335:	55                   	push   %ebp
  103336:	89 e5                	mov    %esp,%ebp
  103338:	57                   	push   %edi
  103339:	56                   	push   %esi
  10333a:	53                   	push   %ebx
  10333b:	83 ec 30             	sub    $0x30,%esp
  10333e:	8b 45 08             	mov    0x8(%ebp),%eax
  103341:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103344:	8b 45 0c             	mov    0xc(%ebp),%eax
  103347:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10334a:	8b 45 10             	mov    0x10(%ebp),%eax
  10334d:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  103350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103353:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103356:	73 42                	jae    10339a <memmove+0x65>
  103358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10335b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10335e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103361:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103364:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103367:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  10336a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10336d:	c1 e8 02             	shr    $0x2,%eax
  103370:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  103372:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103375:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103378:	89 d7                	mov    %edx,%edi
  10337a:	89 c6                	mov    %eax,%esi
  10337c:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10337e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  103381:	83 e1 03             	and    $0x3,%ecx
  103384:	74 02                	je     103388 <memmove+0x53>
  103386:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103388:	89 f0                	mov    %esi,%eax
  10338a:	89 fa                	mov    %edi,%edx
  10338c:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10338f:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  103392:	89 45 d0             	mov    %eax,-0x30(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  103395:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103398:	eb 36                	jmp    1033d0 <memmove+0x9b>
    asm volatile (
            "std;"
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  10339a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10339d:	8d 50 ff             	lea    -0x1(%eax),%edx
  1033a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033a3:	01 c2                	add    %eax,%edx
  1033a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033a8:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1033ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033ae:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  1033b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1033b4:	89 c1                	mov    %eax,%ecx
  1033b6:	89 d8                	mov    %ebx,%eax
  1033b8:	89 d6                	mov    %edx,%esi
  1033ba:	89 c7                	mov    %eax,%edi
  1033bc:	fd                   	std    
  1033bd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1033bf:	fc                   	cld    
  1033c0:	89 f8                	mov    %edi,%eax
  1033c2:	89 f2                	mov    %esi,%edx
  1033c4:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1033c7:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1033ca:	89 45 c4             	mov    %eax,-0x3c(%ebp)
            "rep; movsb;"
            "cld;"
            : "=&c" (d0), "=&S" (d1), "=&D" (d2)
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
            : "memory");
    return dst;
  1033cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1033d0:	83 c4 30             	add    $0x30,%esp
  1033d3:	5b                   	pop    %ebx
  1033d4:	5e                   	pop    %esi
  1033d5:	5f                   	pop    %edi
  1033d6:	5d                   	pop    %ebp
  1033d7:	c3                   	ret    

001033d8 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1033d8:	55                   	push   %ebp
  1033d9:	89 e5                	mov    %esp,%ebp
  1033db:	57                   	push   %edi
  1033dc:	56                   	push   %esi
  1033dd:	83 ec 20             	sub    $0x20,%esp
  1033e0:	8b 45 08             	mov    0x8(%ebp),%eax
  1033e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1033e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033ec:	8b 45 10             	mov    0x10(%ebp),%eax
  1033ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1033f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1033f5:	c1 e8 02             	shr    $0x2,%eax
  1033f8:	89 c1                	mov    %eax,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1033fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103400:	89 d7                	mov    %edx,%edi
  103402:	89 c6                	mov    %eax,%esi
  103404:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  103406:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  103409:	83 e1 03             	and    $0x3,%ecx
  10340c:	74 02                	je     103410 <memcpy+0x38>
  10340e:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  103410:	89 f0                	mov    %esi,%eax
  103412:	89 fa                	mov    %edi,%edx
  103414:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  103417:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  10341a:	89 45 e0             	mov    %eax,-0x20(%ebp)
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
            : "memory");
    return dst;
  10341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  103420:	83 c4 20             	add    $0x20,%esp
  103423:	5e                   	pop    %esi
  103424:	5f                   	pop    %edi
  103425:	5d                   	pop    %ebp
  103426:	c3                   	ret    

00103427 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  103427:	55                   	push   %ebp
  103428:	89 e5                	mov    %esp,%ebp
  10342a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10342d:	8b 45 08             	mov    0x8(%ebp),%eax
  103430:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  103433:	8b 45 0c             	mov    0xc(%ebp),%eax
  103436:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  103439:	eb 30                	jmp    10346b <memcmp+0x44>
        if (*s1 != *s2) {
  10343b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10343e:	0f b6 10             	movzbl (%eax),%edx
  103441:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103444:	0f b6 00             	movzbl (%eax),%eax
  103447:	38 c2                	cmp    %al,%dl
  103449:	74 18                	je     103463 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  10344b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10344e:	0f b6 00             	movzbl (%eax),%eax
  103451:	0f b6 d0             	movzbl %al,%edx
  103454:	8b 45 f8             	mov    -0x8(%ebp),%eax
  103457:	0f b6 00             	movzbl (%eax),%eax
  10345a:	0f b6 c0             	movzbl %al,%eax
  10345d:	29 c2                	sub    %eax,%edx
  10345f:	89 d0                	mov    %edx,%eax
  103461:	eb 1a                	jmp    10347d <memcmp+0x56>
        }
        s1 ++, s2 ++;
  103463:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  103467:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  10346b:	8b 45 10             	mov    0x10(%ebp),%eax
  10346e:	8d 50 ff             	lea    -0x1(%eax),%edx
  103471:	89 55 10             	mov    %edx,0x10(%ebp)
  103474:	85 c0                	test   %eax,%eax
  103476:	75 c3                	jne    10343b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  103478:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10347d:	c9                   	leave  
  10347e:	c3                   	ret    
