# Lab1 report

## [练习1]

[练习1.1] 操作系统镜像文件 ucore.img 是如何一步一步生成的?(需要比较详细地解释 Makefile 中
每一条相关命令和命令参数的含义,以及说明命令导致的结果)
```
ucore.img 通过make的最后三个dd命令生成：
dd if=/dev/zero of=/bin/ucore.img count=10000 
生成一个有10000个块的文件，每个块默认512字节，用0填充

dd if=/bin/bootblock of=/bin/ucore.img conv=notrunc
复制bootblock到第一个块

dd if=/bin/kernel of=/bin/ucore.img seek=1 conv=notrunc
从第二个块开始写kernel中的内容


生成bootblock执行以下命令：
gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootasm.S -o obj/boot/bootasm.o

gcc -Iboot/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Os -nostdinc -c boot/bootmain.c -o obj/boot/bootmain.o

gcc -Itools/ -g -Wall -O2 -c tools/sign.c -o obj/sign/tools/sign.o
gcc -g -Wall -O2 obj/sign/tools/sign.o -o bin/sign

ld -m    elf_i386 -nostdlib -N -e start -Ttext 0x7C00 obj/boot/bootasm.o obj/boot/bootmain.o -o obj/bootblock.o

编译bootasm.S bootmain.c sign.c然后链接生成bootblock.o

objcopy -S -O binary obj/bootblock.o obj/bootblock.out
将bootblock.o拷贝到bootblock.out中并利用sign工具生成/bin/bootblock

生成kernel执行以下命令：
gcc -Ikern/init/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/init/init.c -o obj/kern/init/init.o

gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/readline.c -o obj/kern/libs/readline.o

gcc -Ikern/libs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/libs/stdio.c -o obj/kern/libs/stdio.o

gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kdebug.c -o obj/kern/debug/kdebug.o

gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/kmonitor.c -o obj/kern/debug/kmonitor.o

gcc -Ikern/debug/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/debug/panic.c -o obj/kern/debug/panic.o

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/clock.c -o obj/kern/driver/clock.o

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/console.c -o obj/kern/driver/console.o

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/intr.c -o obj/kern/driver/intr.o

gcc -Ikern/driver/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/driver/picirq.c -o obj/kern/driver/picirq.o

gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trap.c -o obj/kern/trap/trap.o

gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/trapentry.S -o obj/kern/trap/trapentry.o

gcc -Ikern/trap/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/trap/vectors.S -o obj/kern/trap/vectors.o

gcc -Ikern/mm/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/ -Ikern/debug/ -Ikern/driver/ -Ikern/trap/ -Ikern/mm/ -c kern/mm/pmm.c -o obj/kern/mm/pmm.o

gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/printfmt.c -o obj/libs/printfmt.o

gcc -Ilibs/ -fno-builtin -Wall -ggdb -m32 -gstabs -nostdinc  -fno-stack-protector -Ilibs/  -c libs/string.c -o obj/libs/string.o

ld -m    elf_i386 -nostdlib -T tools/kernel.ld -o bin/kernel  obj/kern/init/init.o obj/kern/libs/readline.o obj/kern/libs/stdio.o obj/kern/debug/kdebug.o obj/kern/debug/kmonitor.o obj/kern/debug/panic.o obj/kern/driver/clock.o obj/kern/driver/console.o obj/kern/driver/intr.o obj/kern/driver/picirq.o obj/kern/trap/trap.o obj/kern/trap/trapentry.o obj/kern/trap/vectors.o obj/kern/mm/pmm.o  obj/libs/printfmt.o obj/libs/string.o

将相关文件编译链接后生成kernel
```
[练习1.2] 一个被系统认为是符合规范的硬盘主引导扇区的特征是什么?
```
char buf[512];
    memset(buf, 0, sizeof(buf));
    FILE *ifp = fopen(argv[1], "rb");
    int size = fread(buf, 1, st.st_size, ifp);
    if (size != st.st_size) {
        fprintf(stderr, "read '%s' error, size is %d.\n", argv[1], size);
        return -1;
    }
    fclose(ifp);
    buf[510] = 0x55;
    buf[511] = 0xAA;
    FILE *ofp = fopen(argv[2], "wb+");
    size = fwrite(buf, 1, 512, ofp);
    if (size != 512) {
        fprintf(stderr, "write '%s' error, size is %d.\n", argv[2], size);
        return -1;
    }
    fclose(ofp);
printf("build 512 bytes boot sector: '%s' success!\n", argv[2]);

从sign.c中这段代码可以看出，符合规范的硬盘主引导扇区的最后两个字节必须是0x55AA
```

## [练习2]

[练习2.1] 从 CPU 加电后执行的第一条指令开始,单步跟踪 BIOS 的执行。

编辑lab1/tools/gdbinit为:
```
target remote :1234
set architecture i8086
```

在lab1目录下，执行
```
make debug
```
之后使用si命令可使BIOS单步执行

在gdb中执行`x /2i 0xffff0`可以看到该地址处的第一条指令是`ljmp $0xf0000,$0xe05b`

接下来可执行`x /10i 0xfe05b`继续跟踪执行过程

[练习2.2] 在初始化位置0x7c00 设置实地址断点,测试断点正常。

编辑lab1/tools/gdbinit为:
```
target remote :1234
set architecture i8086  
b *0x7c00  
c          
x /10i $pc  
```
执行make debug便可得到
```
Breakpoint 1, 0x00007c00 in ?? ()
=> 0x7c00:      cli    
   0x7c01:      cld    
---Type <return> to continue, or q <return> to quit---
```

[练习2.3] 在调用qemu 时增加-d in_asm -D q.log 参数，便可以将运行的汇编指令保存在q.log 中。
将执行的汇编代码与bootasm.S 和 bootblock.asm 进行比较，看看二者是否一致。

首先修改Makefile文件在调用qemu时增加-d in_asm -D q.log 参数，然后执行make debug

在/lab1/bin/q.log可以找到执行的汇编指令，与/lab1/boot/bootasm.S中的代码相同
```
----------------
IN: 
0x00007c00:  cli    

----------------
IN: 
0x00007c01:  cld    
0x00007c02:  xor    %ax,%ax
0x00007c04:  mov    %ax,%ds
0x00007c06:  mov    %ax,%es
0x00007c08:  mov    %ax,%ss

----------------
IN: 
0x00007c0a:  in     $0x64,%al

----------------
IN: 
0x00007c0c:  test   $0x2,%al
0x00007c0e:  jne    0x7c0a

----------------
IN: 
0x00007c10:  mov    $0xd1,%al
0x00007c12:  out    %al,$0x64
0x00007c14:  in     $0x64,%al
0x00007c16:  test   $0x2,%al
0x00007c18:  jne    0x7c14
...
```

## [练习3]
分析bootloader 进入保护模式的过程。

从0x7c00开始执行，首先执行如下代码进行初始化
```
.code16
    cli              #禁止中断发生
    cld              #将标志寄存器Flag的方向标志位DF清零
    xorw %ax, %ax
    movw %ax, %ds
    movw %ax, %es
    movw %ax, %ss    #段寄存器置0
```

打开A20地址线控制
```
seta20.1:               
    inb $0x64, %al       
    testb $0x2, %al     #等待8042 Input Buffer为空
    jnz seta20.1        

    movb $0xd1, %al     #发送write 8042 Output Port(P2)命令到8042 Input Buffer
    outb %al, $0x64     

seta20.1:               
    inb $0x64, %al       
    testb $0x2, %al     #等待8042 Input Buffer为空
    jnz seta20.1        

    movb $0xdf, %al     #将8042 Output Port(P2)得到字节的第2位置1
    outb %al, $0x60     #写入到8042 Input Buffer
```

初始化GDT表
```
lgdt gdtdesc
```

修改cr0寄存器，进入保护模式
```
movl %cr0, %eax
orl $CR0_PE_ON, %eax
movl %eax, %cr0
```

通过长跳转更新cs的基地址
```
ljmp $PROT_MODE_CSEG, $protcseg
.code32
protcseg:
```

设置段寄存器，并建立堆栈
```
movw $PROT_MODE_DSEG, %ax
movw %ax, %ds
movw %ax, %es
movw %ax, %fs
movw %ax, %gs
movw %ax, %ss
movl $0x0, %ebp
movl $start, %esp   #设置栈指针
```
转到保护模式完成，进入boot主方法
```
call bootmain
```

## [练习4]
分析bootloader是如何读取磁盘扇区的。

bootloader采用PIO的方式从硬盘中读取操作系统内核所在的各个扇区。首先，PIO操作相关的端口一共有8个，地址通常为0x1F0~0x1F7[[相关文档](http://wiki.osdev.org/ATA_PIO_Mode)]，这些端口的功能和描述如下：

| 端口   | 功能              | 描述          |
| ---- | --------------- | ----------- |
| 0    | 数据端口            | 读取/写入数据     |
| 2    | 扇区数量            | 读取或者写入的扇区数量 |
| s    | 扇区号/ LBA低字节     |             |
| 4    | 柱面号低字节/ LBA中字节  |             |
| 5    | 柱面号高字节 / LBA高字节 |             |
| 6    | 驱动器号            |             |
| 7    | 命令端口 / 状态端口     | 发送命令或者读取状态  |

**磁盘等待**

由于磁盘读取速度慢于CPU执行速度，在对磁盘进行操作之前，需要检查磁盘是否空闲，即从状态端口读取状态，状态字相关的位如下：

| 位    | 名称   | 功能                   |
| ---- | ---- | -------------------- |
| 6    | RDY  | 当磁盘空闲或者发生错误之后清零，否则置1 |
| 7    | BSY  | 表示驱动器正在写入/读取数据       |

每次进行磁盘操作前反复检查状态字的第6,7位，直到BSY为0且RDY为1时候才可以对磁盘进行操作。

**扇区读取**

每个扇区可以由LBA（逻辑区块地址）指定，28位LBA地址各个字节意义如下：

| 位     | 意义     |
| ----- | ------ |
| 0-7   | 扇区号    |
| 8-15  | 柱面号低字节 |
| 16-23 | 柱面号高字节 |
| 23-27 | 驱动器号   |

扇区的读取完整流程如下：

- 等待磁盘空闲
- 将LBA的各个部分送入对应的端口，将读取命令0x20送入命令端口
- 等待磁盘读取完毕
- 从数据端口读取一个扇区的数据


分析bootloader加载ELF格式的OS的过程。

bootmain函数中，首先调用了readseg函数从磁盘读取ELF文件的头部到指定位置，然后通过比较头部的e_magic成员变量来判断读取到的文件是否是ELF文件。ELF文件头正确读取后，根据文件头的描述表成员变量将ELF文件读取到内存中的指定位置。最后执行`((void (*)(void))(ELFHDR->e_entry & 0xFFFFFF))();`这句代码将ELF文件头的e_entry成员强制转化为函数指针并调用，从而进入了操作系统内核态。

## [练习5] 
实现函数调用堆栈跟踪函数 

函数调用的堆栈过程大致如下：
```
      |________________| <- esp
      |__caller's ebp__| <- callee's ebp
      |_return address_|
      |___argument_1___|
      |___argument_2___|
      |___argument_3___|
      |______..._______|

```


输出为
```
ebp:0x00007b08 eip:0x001009a6 args: 0x00010094 0x00000000 0x00007b38 0x00100092
    kern/debug/kdebug.c:306: print_stackframe+21
ebp:0x00007b18 eip:0x00100c9c args: 0x00000000 0x00000000 0x00000000 0x00007b88
    kern/debug/kmonitor.c:125: mon_backtrace+10
ebp:0x00007b38 eip:0x00100092 args: 0x00000000 0x00007b60 0xffff0000 0x00007b64
    kern/init/init.c:48: grade_backtrace2+33
ebp:0x00007b58 eip:0x001000bb args: 0x00000000 0xffff0000 0x00007b84 0x00000029
    kern/init/init.c:53: grade_backtrace1+38
ebp:0x00007b78 eip:0x001000d9 args: 0x00000000 0x00100000 0xffff0000 0x0000001d
    kern/init/init.c:58: grade_backtrace0+23
ebp:0x00007b98 eip:0x001000fe args: 0x0010349c 0x00103480 0x0000130a 0x00000000
    kern/init/init.c:63: grade_backtrace+34
ebp:0x00007bc8 eip:0x00100055 args: 0x00000000 0x00000000 0x00000000 0x00010094
    kern/init/init.c:28: kern_init+84
ebp:0x00007bf8 eip:0x00007d68 args: 0xc031fcfa 0xc08ed88e 0x64e4d08e 0xfa7502a8
    <unknow>: -- 0x00007d67 --
```

其中最后一行对应的是第一个使用堆栈的函数，即bootmain.c中的bootmain

bootloader设置的堆栈从0x7c00开始，使用"call bootmain"转入bootmain函数，
call指令压栈，所以bootmain中ebp为0x7bf8

## [练习6]
完善中断初始化和处理

[练习6.1] 中断向量表中一个表项占多少字节？其中哪几位代表中断处理代码的入口？

中断向量表中一个表项占用8字节，其中2,3字节是段选择子，0,1字节和6,7字节拼成位移，
两者联合得到中断处理程序的入口地址。

[练习6.2] 请编程完善kern/trap/trap.c中对中断向量表进行初始化的函数idt_init。

见代码

[练习6.3] 请编程完善trap.c中的中断处理函数trap，在对时钟中断进行处理的部分填写trap函数

见代码

## 扩展练习 Challenge 1

当前执行代码的特权级与IOPL、CPL、DPL和RPL字段有关。当内核陷入中断之后，中断前的EFLAGS、DS、ES、CS、SS都保存在栈中，当中断处理结束之后，这些值都会恢复到相应的寄存器中，所以要想改变特权级就要改变保存在栈中的寄存器值相应的字段。

模式的切换通过中断来完成。内核态到用户态的切换，需要从内核态栈中弹出用户态栈的ss和esp的值，为此在调用中断之前需要预留8字节的空间。在调用中断返回之后，恢复中断处理之前的栈指针。同时为了能使T_SWITCH_TOK能在用户模式下被调用，在建立IDT时，需要设置其DPL为3，并且设置陷入标志。

具体实现可见/lab1/kern/trap/trap.c与/lab1/kern/init/init.c。

## 扩展练习 Challenge 2

在产生键盘中断时，对键盘的值进行判断，如果输入是‘0’或者‘3’就执行特权级转换的代码即可。

具体实现可见/lab1/kern/trap/trap.c。