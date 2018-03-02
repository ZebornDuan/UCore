## 思考题

- 你理解的对于类似ucore这样需要进程/虚存/文件系统的操作系统，在硬件设计上至少需要有哪些直接的支持？至少应该提供哪些功能的特权指令？

进程需要能够获取CPU的状态，以及对中断的支持；虚存和文件系统分别需要内存和硬盘的支持。

硬件上至少需要提供状态转换，开关中断和访问某些特殊寄存器的特权指令。

- 你理解的x86的实模式和保护模式有什么区别？物理地址、线性地址、逻辑地址的含义分别是什么？
实模式和保护模式有什么区别：

可访问的物理内存空间大小不同，实模式下可访问的物理内存空间不超过1MB，
在保护方式下，全部32条地址线有效，可寻址高达4G字节的物理地址空间。

保护模式和实模式的根本区别是进程内存是否受保护，实模式将整个物理内存看成分段的区域,程序代码和数据位于不同区域，
系统程序和用户程序没有区别对待，而且每一个指针都是指向物理地址。
这样一来，用户程序的一个指针如果指向了系统程序区域或其他用户程序区域，并改变了值，那么对于这个被修改的系统程序或用户程序，
其后果就很可能是灾难性的。为了克服这种低劣的内存管理方式，处理器厂商开发出保护模式。
这样，物理内存地址不能直接被程序访问，程序内部的地址（虚拟地址）要由操作系统转化为物理地址去访问，程序对此一无所知。

CPU启动环境为16位实模式，之后切换到保护模式，这主要是因为下x86需要向下兼容

物理地址：是处理器提交到总线上用于访问计算机系统中的内存和外设的最终地址。一个计算机系统中只有一个物理地址空间。 

逻辑地址：在有地址变换功能的计算机中,访问指令给出的地址叫逻辑地址。 

线性地址：线性地址是逻辑地址到物理地址变换之间的中间层，处理器通过段(Segment)机制控制下的形成的地址空间。

- 理解list_entry双向链表数据结构及其4个基本操作函数和ucore中一些基于它的代码实现（此题不用填写内容）

- 对于如下的代码段，请说明":"后面的数字是什么含义
```
 /* Gate descriptors for interrupts and traps */
 struct gatedesc {
    unsigned gd_off_15_0 : 16;        // low 16 bits of offset in segment
    unsigned gd_ss : 16;            // segment selector
    unsigned gd_args : 5;            // # args, 0 for interrupt/trap gates
    unsigned gd_rsv1 : 3;            // reserved(should be zero I guess)
    unsigned gd_type : 4;            // type(STS_{TG,IG32,TG32})
    unsigned gd_s : 1;                // must be 0 (system)
    unsigned gd_dpl : 2;            // descriptor(meaning new) privilege level
    unsigned gd_p : 1;                // Present
    unsigned gd_off_31_16 : 16;        // high bits of offset in segment
 };
```

- 对于如下的代码段，

每一个成员变量结构中所占的位数。

```
#define SETGATE(gate, istrap, sel, off, dpl) {            \
    (gate).gd_off_15_0 = (uint32_t)(off) & 0xffff;        \
    (gate).gd_ss = (sel);                                \
    (gate).gd_args = 0;                                    \
    (gate).gd_rsv1 = 0;                                    \
    (gate).gd_type = (istrap) ? STS_TG32 : STS_IG32;    \
    (gate).gd_s = 0;                                    \
    (gate).gd_dpl = (dpl);                                \
    (gate).gd_p = 1;                                    \
    (gate).gd_off_31_16 = (uint32_t)(off) >> 16;        \
}
```
如果在其他代码段中有如下语句，
```
unsigned intr;
intr=8;
SETGATE(intr, 1,2,3,0);
```
请问执行上述指令后， intr的值是多少？

0x10002(32位整数，低16位是off & 0xffff，即off，高16位是sel)