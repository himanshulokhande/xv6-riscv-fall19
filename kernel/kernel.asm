
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	0000b117          	auipc	sp,0xb
    80000004:	80010113          	addi	sp,sp,-2048 # 8000a800 <stack0>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	070000ef          	jal	ra,80000086 <start>

000000008000001a <junk>:
    8000001a:	a001                	j	8000001a <junk>

000000008000001c <timerinit>:
// which arrive at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e422                	sd	s0,8(sp)
    80000020:	0800                	addi	s0,sp,16
// which hart (core) is this?
static inline uint64
r_mhartid()
{
  uint64 x;
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80000022:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80000026:	0037969b          	slliw	a3,a5,0x3
    8000002a:	02004737          	lui	a4,0x2004
    8000002e:	96ba                	add	a3,a3,a4
    80000030:	0200c737          	lui	a4,0x200c
    80000034:	ff873603          	ld	a2,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80000038:	000f4737          	lui	a4,0xf4
    8000003c:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80000040:	963a                	add	a2,a2,a4
    80000042:	e290                	sd	a2,0(a3)

  // prepare information in scratch[] for timervec.
  // scratch[0..3] : space for timervec to save registers.
  // scratch[4] : address of CLINT MTIMECMP register.
  // scratch[5] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &mscratch0[32 * id];
    80000044:	0057979b          	slliw	a5,a5,0x5
    80000048:	078e                	slli	a5,a5,0x3
    8000004a:	0000a617          	auipc	a2,0xa
    8000004e:	fb660613          	addi	a2,a2,-74 # 8000a000 <mscratch0>
    80000052:	97b2                	add	a5,a5,a2
  scratch[4] = CLINT_MTIMECMP(id);
    80000054:	f394                	sd	a3,32(a5)
  scratch[5] = interval;
    80000056:	f798                	sd	a4,40(a5)
}

static inline void 
w_mscratch(uint64 x)
{
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80000058:	34079073          	csrw	mscratch,a5
  asm volatile("csrw mtvec, %0" : : "r" (x));
    8000005c:	00006797          	auipc	a5,0x6
    80000060:	eb478793          	addi	a5,a5,-332 # 80005f10 <timervec>
    80000064:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80000068:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    8000006c:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80000070:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80000074:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80000078:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    8000007c:	30479073          	csrw	mie,a5
}
    80000080:	6422                	ld	s0,8(sp)
    80000082:	0141                	addi	sp,sp,16
    80000084:	8082                	ret

0000000080000086 <start>:
{
    80000086:	1141                	addi	sp,sp,-16
    80000088:	e406                	sd	ra,8(sp)
    8000008a:	e022                	sd	s0,0(sp)
    8000008c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000008e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000092:	7779                	lui	a4,0xffffe
    80000094:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd67a3>
    80000098:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000009a:	6705                	lui	a4,0x1
    8000009c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800000a0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800000a2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800000a6:	00001797          	auipc	a5,0x1
    800000aa:	e8a78793          	addi	a5,a5,-374 # 80000f30 <main>
    800000ae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800000b2:	4781                	li	a5,0
    800000b4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800000b8:	67c1                	lui	a5,0x10
    800000ba:	17fd                	addi	a5,a5,-1
    800000bc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800000c0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800000c4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    800000c8:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    800000cc:	10479073          	csrw	sie,a5
  timerinit();
    800000d0:	00000097          	auipc	ra,0x0
    800000d4:	f4c080e7          	jalr	-180(ra) # 8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800000d8:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000dc:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    800000de:	823e                	mv	tp,a5
  asm volatile("mret");
    800000e0:	30200073          	mret
}
    800000e4:	60a2                	ld	ra,8(sp)
    800000e6:	6402                	ld	s0,0(sp)
    800000e8:	0141                	addi	sp,sp,16
    800000ea:	8082                	ret

00000000800000ec <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(struct file *f, int user_dst, uint64 dst, int n)
{
    800000ec:	7119                	addi	sp,sp,-128
    800000ee:	fc86                	sd	ra,120(sp)
    800000f0:	f8a2                	sd	s0,112(sp)
    800000f2:	f4a6                	sd	s1,104(sp)
    800000f4:	f0ca                	sd	s2,96(sp)
    800000f6:	ecce                	sd	s3,88(sp)
    800000f8:	e8d2                	sd	s4,80(sp)
    800000fa:	e4d6                	sd	s5,72(sp)
    800000fc:	e0da                	sd	s6,64(sp)
    800000fe:	fc5e                	sd	s7,56(sp)
    80000100:	f862                	sd	s8,48(sp)
    80000102:	f466                	sd	s9,40(sp)
    80000104:	f06a                	sd	s10,32(sp)
    80000106:	ec6e                	sd	s11,24(sp)
    80000108:	0100                	addi	s0,sp,128
    8000010a:	8b2e                	mv	s6,a1
    8000010c:	8ab2                	mv	s5,a2
    8000010e:	8a36                	mv	s4,a3
  uint target;
  int c;
  char cbuf;

  target = n;
    80000110:	00068b9b          	sext.w	s7,a3
  acquire(&cons.lock);
    80000114:	00012517          	auipc	a0,0x12
    80000118:	6ec50513          	addi	a0,a0,1772 # 80012800 <cons>
    8000011c:	00001097          	auipc	ra,0x1
    80000120:	994080e7          	jalr	-1644(ra) # 80000ab0 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80000124:	00012497          	auipc	s1,0x12
    80000128:	6dc48493          	addi	s1,s1,1756 # 80012800 <cons>
      if(myproc()->killed){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000012c:	89a6                	mv	s3,s1
    8000012e:	00012917          	auipc	s2,0x12
    80000132:	77290913          	addi	s2,s2,1906 # 800128a0 <cons+0xa0>
    }

    c = cons.buf[cons.r++ % INPUT_BUF];

    if(c == C('D')){  // end-of-file
    80000136:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000138:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    8000013a:	4da9                	li	s11,10
  while(n > 0){
    8000013c:	07405863          	blez	s4,800001ac <consoleread+0xc0>
    while(cons.r == cons.w){
    80000140:	0a04a783          	lw	a5,160(s1)
    80000144:	0a44a703          	lw	a4,164(s1)
    80000148:	02f71463          	bne	a4,a5,80000170 <consoleread+0x84>
      if(myproc()->killed){
    8000014c:	00002097          	auipc	ra,0x2
    80000150:	9ea080e7          	jalr	-1558(ra) # 80001b36 <myproc>
    80000154:	5d1c                	lw	a5,56(a0)
    80000156:	e7b5                	bnez	a5,800001c2 <consoleread+0xd6>
      sleep(&cons.r, &cons.lock);
    80000158:	85ce                	mv	a1,s3
    8000015a:	854a                	mv	a0,s2
    8000015c:	00002097          	auipc	ra,0x2
    80000160:	196080e7          	jalr	406(ra) # 800022f2 <sleep>
    while(cons.r == cons.w){
    80000164:	0a04a783          	lw	a5,160(s1)
    80000168:	0a44a703          	lw	a4,164(s1)
    8000016c:	fef700e3          	beq	a4,a5,8000014c <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF];
    80000170:	0017871b          	addiw	a4,a5,1
    80000174:	0ae4a023          	sw	a4,160(s1)
    80000178:	07f7f713          	andi	a4,a5,127
    8000017c:	9726                	add	a4,a4,s1
    8000017e:	02074703          	lbu	a4,32(a4)
    80000182:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80000186:	079c0663          	beq	s8,s9,800001f2 <consoleread+0x106>
    cbuf = c;
    8000018a:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    8000018e:	4685                	li	a3,1
    80000190:	f8f40613          	addi	a2,s0,-113
    80000194:	85d6                	mv	a1,s5
    80000196:	855a                	mv	a0,s6
    80000198:	00002097          	auipc	ra,0x2
    8000019c:	3ba080e7          	jalr	954(ra) # 80002552 <either_copyout>
    800001a0:	01a50663          	beq	a0,s10,800001ac <consoleread+0xc0>
    dst++;
    800001a4:	0a85                	addi	s5,s5,1
    --n;
    800001a6:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    800001a8:	f9bc1ae3          	bne	s8,s11,8000013c <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    800001ac:	00012517          	auipc	a0,0x12
    800001b0:	65450513          	addi	a0,a0,1620 # 80012800 <cons>
    800001b4:	00001097          	auipc	ra,0x1
    800001b8:	9cc080e7          	jalr	-1588(ra) # 80000b80 <release>

  return target - n;
    800001bc:	414b853b          	subw	a0,s7,s4
    800001c0:	a811                	j	800001d4 <consoleread+0xe8>
        release(&cons.lock);
    800001c2:	00012517          	auipc	a0,0x12
    800001c6:	63e50513          	addi	a0,a0,1598 # 80012800 <cons>
    800001ca:	00001097          	auipc	ra,0x1
    800001ce:	9b6080e7          	jalr	-1610(ra) # 80000b80 <release>
        return -1;
    800001d2:	557d                	li	a0,-1
}
    800001d4:	70e6                	ld	ra,120(sp)
    800001d6:	7446                	ld	s0,112(sp)
    800001d8:	74a6                	ld	s1,104(sp)
    800001da:	7906                	ld	s2,96(sp)
    800001dc:	69e6                	ld	s3,88(sp)
    800001de:	6a46                	ld	s4,80(sp)
    800001e0:	6aa6                	ld	s5,72(sp)
    800001e2:	6b06                	ld	s6,64(sp)
    800001e4:	7be2                	ld	s7,56(sp)
    800001e6:	7c42                	ld	s8,48(sp)
    800001e8:	7ca2                	ld	s9,40(sp)
    800001ea:	7d02                	ld	s10,32(sp)
    800001ec:	6de2                	ld	s11,24(sp)
    800001ee:	6109                	addi	sp,sp,128
    800001f0:	8082                	ret
      if(n < target){
    800001f2:	000a071b          	sext.w	a4,s4
    800001f6:	fb777be3          	bgeu	a4,s7,800001ac <consoleread+0xc0>
        cons.r--;
    800001fa:	00012717          	auipc	a4,0x12
    800001fe:	6af72323          	sw	a5,1702(a4) # 800128a0 <cons+0xa0>
    80000202:	b76d                	j	800001ac <consoleread+0xc0>

0000000080000204 <consputc>:
  if(panicked){
    80000204:	00028797          	auipc	a5,0x28
    80000208:	e1c7a783          	lw	a5,-484(a5) # 80028020 <panicked>
    8000020c:	c391                	beqz	a5,80000210 <consputc+0xc>
    for(;;)
    8000020e:	a001                	j	8000020e <consputc+0xa>
{
    80000210:	1141                	addi	sp,sp,-16
    80000212:	e406                	sd	ra,8(sp)
    80000214:	e022                	sd	s0,0(sp)
    80000216:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80000218:	10000793          	li	a5,256
    8000021c:	00f50a63          	beq	a0,a5,80000230 <consputc+0x2c>
    uartputc(c);
    80000220:	00000097          	auipc	ra,0x0
    80000224:	5e2080e7          	jalr	1506(ra) # 80000802 <uartputc>
}
    80000228:	60a2                	ld	ra,8(sp)
    8000022a:	6402                	ld	s0,0(sp)
    8000022c:	0141                	addi	sp,sp,16
    8000022e:	8082                	ret
    uartputc('\b'); uartputc(' '); uartputc('\b');
    80000230:	4521                	li	a0,8
    80000232:	00000097          	auipc	ra,0x0
    80000236:	5d0080e7          	jalr	1488(ra) # 80000802 <uartputc>
    8000023a:	02000513          	li	a0,32
    8000023e:	00000097          	auipc	ra,0x0
    80000242:	5c4080e7          	jalr	1476(ra) # 80000802 <uartputc>
    80000246:	4521                	li	a0,8
    80000248:	00000097          	auipc	ra,0x0
    8000024c:	5ba080e7          	jalr	1466(ra) # 80000802 <uartputc>
    80000250:	bfe1                	j	80000228 <consputc+0x24>

0000000080000252 <consolewrite>:
{
    80000252:	715d                	addi	sp,sp,-80
    80000254:	e486                	sd	ra,72(sp)
    80000256:	e0a2                	sd	s0,64(sp)
    80000258:	fc26                	sd	s1,56(sp)
    8000025a:	f84a                	sd	s2,48(sp)
    8000025c:	f44e                	sd	s3,40(sp)
    8000025e:	f052                	sd	s4,32(sp)
    80000260:	ec56                	sd	s5,24(sp)
    80000262:	0880                	addi	s0,sp,80
    80000264:	89ae                	mv	s3,a1
    80000266:	84b2                	mv	s1,a2
    80000268:	8ab6                	mv	s5,a3
  acquire(&cons.lock);
    8000026a:	00012517          	auipc	a0,0x12
    8000026e:	59650513          	addi	a0,a0,1430 # 80012800 <cons>
    80000272:	00001097          	auipc	ra,0x1
    80000276:	83e080e7          	jalr	-1986(ra) # 80000ab0 <acquire>
  for(i = 0; i < n; i++){
    8000027a:	03505e63          	blez	s5,800002b6 <consolewrite+0x64>
    8000027e:	00148913          	addi	s2,s1,1
    80000282:	fffa879b          	addiw	a5,s5,-1
    80000286:	1782                	slli	a5,a5,0x20
    80000288:	9381                	srli	a5,a5,0x20
    8000028a:	993e                	add	s2,s2,a5
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    8000028c:	5a7d                	li	s4,-1
    8000028e:	4685                	li	a3,1
    80000290:	8626                	mv	a2,s1
    80000292:	85ce                	mv	a1,s3
    80000294:	fbf40513          	addi	a0,s0,-65
    80000298:	00002097          	auipc	ra,0x2
    8000029c:	310080e7          	jalr	784(ra) # 800025a8 <either_copyin>
    800002a0:	01450b63          	beq	a0,s4,800002b6 <consolewrite+0x64>
    consputc(c);
    800002a4:	fbf44503          	lbu	a0,-65(s0)
    800002a8:	00000097          	auipc	ra,0x0
    800002ac:	f5c080e7          	jalr	-164(ra) # 80000204 <consputc>
  for(i = 0; i < n; i++){
    800002b0:	0485                	addi	s1,s1,1
    800002b2:	fd249ee3          	bne	s1,s2,8000028e <consolewrite+0x3c>
  release(&cons.lock);
    800002b6:	00012517          	auipc	a0,0x12
    800002ba:	54a50513          	addi	a0,a0,1354 # 80012800 <cons>
    800002be:	00001097          	auipc	ra,0x1
    800002c2:	8c2080e7          	jalr	-1854(ra) # 80000b80 <release>
}
    800002c6:	8556                	mv	a0,s5
    800002c8:	60a6                	ld	ra,72(sp)
    800002ca:	6406                	ld	s0,64(sp)
    800002cc:	74e2                	ld	s1,56(sp)
    800002ce:	7942                	ld	s2,48(sp)
    800002d0:	79a2                	ld	s3,40(sp)
    800002d2:	7a02                	ld	s4,32(sp)
    800002d4:	6ae2                	ld	s5,24(sp)
    800002d6:	6161                	addi	sp,sp,80
    800002d8:	8082                	ret

00000000800002da <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002da:	1101                	addi	sp,sp,-32
    800002dc:	ec06                	sd	ra,24(sp)
    800002de:	e822                	sd	s0,16(sp)
    800002e0:	e426                	sd	s1,8(sp)
    800002e2:	e04a                	sd	s2,0(sp)
    800002e4:	1000                	addi	s0,sp,32
    800002e6:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002e8:	00012517          	auipc	a0,0x12
    800002ec:	51850513          	addi	a0,a0,1304 # 80012800 <cons>
    800002f0:	00000097          	auipc	ra,0x0
    800002f4:	7c0080e7          	jalr	1984(ra) # 80000ab0 <acquire>

  switch(c){
    800002f8:	47d5                	li	a5,21
    800002fa:	0af48663          	beq	s1,a5,800003a6 <consoleintr+0xcc>
    800002fe:	0297ca63          	blt	a5,s1,80000332 <consoleintr+0x58>
    80000302:	47a1                	li	a5,8
    80000304:	0ef48763          	beq	s1,a5,800003f2 <consoleintr+0x118>
    80000308:	47c1                	li	a5,16
    8000030a:	10f49a63          	bne	s1,a5,8000041e <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    8000030e:	00002097          	auipc	ra,0x2
    80000312:	2f0080e7          	jalr	752(ra) # 800025fe <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80000316:	00012517          	auipc	a0,0x12
    8000031a:	4ea50513          	addi	a0,a0,1258 # 80012800 <cons>
    8000031e:	00001097          	auipc	ra,0x1
    80000322:	862080e7          	jalr	-1950(ra) # 80000b80 <release>
}
    80000326:	60e2                	ld	ra,24(sp)
    80000328:	6442                	ld	s0,16(sp)
    8000032a:	64a2                	ld	s1,8(sp)
    8000032c:	6902                	ld	s2,0(sp)
    8000032e:	6105                	addi	sp,sp,32
    80000330:	8082                	ret
  switch(c){
    80000332:	07f00793          	li	a5,127
    80000336:	0af48e63          	beq	s1,a5,800003f2 <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000033a:	00012717          	auipc	a4,0x12
    8000033e:	4c670713          	addi	a4,a4,1222 # 80012800 <cons>
    80000342:	0a872783          	lw	a5,168(a4)
    80000346:	0a072703          	lw	a4,160(a4)
    8000034a:	9f99                	subw	a5,a5,a4
    8000034c:	07f00713          	li	a4,127
    80000350:	fcf763e3          	bltu	a4,a5,80000316 <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80000354:	47b5                	li	a5,13
    80000356:	0cf48763          	beq	s1,a5,80000424 <consoleintr+0x14a>
      consputc(c);
    8000035a:	8526                	mv	a0,s1
    8000035c:	00000097          	auipc	ra,0x0
    80000360:	ea8080e7          	jalr	-344(ra) # 80000204 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    80000364:	00012797          	auipc	a5,0x12
    80000368:	49c78793          	addi	a5,a5,1180 # 80012800 <cons>
    8000036c:	0a87a703          	lw	a4,168(a5)
    80000370:	0017069b          	addiw	a3,a4,1
    80000374:	0006861b          	sext.w	a2,a3
    80000378:	0ad7a423          	sw	a3,168(a5)
    8000037c:	07f77713          	andi	a4,a4,127
    80000380:	97ba                	add	a5,a5,a4
    80000382:	02978023          	sb	s1,32(a5)
      if(c == '\n' || c == C('D') || cons.e == cons.r+INPUT_BUF){
    80000386:	47a9                	li	a5,10
    80000388:	0cf48563          	beq	s1,a5,80000452 <consoleintr+0x178>
    8000038c:	4791                	li	a5,4
    8000038e:	0cf48263          	beq	s1,a5,80000452 <consoleintr+0x178>
    80000392:	00012797          	auipc	a5,0x12
    80000396:	50e7a783          	lw	a5,1294(a5) # 800128a0 <cons+0xa0>
    8000039a:	0807879b          	addiw	a5,a5,128
    8000039e:	f6f61ce3          	bne	a2,a5,80000316 <consoleintr+0x3c>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    800003a2:	863e                	mv	a2,a5
    800003a4:	a07d                	j	80000452 <consoleintr+0x178>
    while(cons.e != cons.w &&
    800003a6:	00012717          	auipc	a4,0x12
    800003aa:	45a70713          	addi	a4,a4,1114 # 80012800 <cons>
    800003ae:	0a872783          	lw	a5,168(a4)
    800003b2:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003b6:	00012497          	auipc	s1,0x12
    800003ba:	44a48493          	addi	s1,s1,1098 # 80012800 <cons>
    while(cons.e != cons.w &&
    800003be:	4929                	li	s2,10
    800003c0:	f4f70be3          	beq	a4,a5,80000316 <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF] != '\n'){
    800003c4:	37fd                	addiw	a5,a5,-1
    800003c6:	07f7f713          	andi	a4,a5,127
    800003ca:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800003cc:	02074703          	lbu	a4,32(a4)
    800003d0:	f52703e3          	beq	a4,s2,80000316 <consoleintr+0x3c>
      cons.e--;
    800003d4:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    800003d8:	10000513          	li	a0,256
    800003dc:	00000097          	auipc	ra,0x0
    800003e0:	e28080e7          	jalr	-472(ra) # 80000204 <consputc>
    while(cons.e != cons.w &&
    800003e4:	0a84a783          	lw	a5,168(s1)
    800003e8:	0a44a703          	lw	a4,164(s1)
    800003ec:	fcf71ce3          	bne	a4,a5,800003c4 <consoleintr+0xea>
    800003f0:	b71d                	j	80000316 <consoleintr+0x3c>
    if(cons.e != cons.w){
    800003f2:	00012717          	auipc	a4,0x12
    800003f6:	40e70713          	addi	a4,a4,1038 # 80012800 <cons>
    800003fa:	0a872783          	lw	a5,168(a4)
    800003fe:	0a472703          	lw	a4,164(a4)
    80000402:	f0f70ae3          	beq	a4,a5,80000316 <consoleintr+0x3c>
      cons.e--;
    80000406:	37fd                	addiw	a5,a5,-1
    80000408:	00012717          	auipc	a4,0x12
    8000040c:	4af72023          	sw	a5,1184(a4) # 800128a8 <cons+0xa8>
      consputc(BACKSPACE);
    80000410:	10000513          	li	a0,256
    80000414:	00000097          	auipc	ra,0x0
    80000418:	df0080e7          	jalr	-528(ra) # 80000204 <consputc>
    8000041c:	bded                	j	80000316 <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF){
    8000041e:	ee048ce3          	beqz	s1,80000316 <consoleintr+0x3c>
    80000422:	bf21                	j	8000033a <consoleintr+0x60>
      consputc(c);
    80000424:	4529                	li	a0,10
    80000426:	00000097          	auipc	ra,0x0
    8000042a:	dde080e7          	jalr	-546(ra) # 80000204 <consputc>
      cons.buf[cons.e++ % INPUT_BUF] = c;
    8000042e:	00012797          	auipc	a5,0x12
    80000432:	3d278793          	addi	a5,a5,978 # 80012800 <cons>
    80000436:	0a87a703          	lw	a4,168(a5)
    8000043a:	0017069b          	addiw	a3,a4,1
    8000043e:	0006861b          	sext.w	a2,a3
    80000442:	0ad7a423          	sw	a3,168(a5)
    80000446:	07f77713          	andi	a4,a4,127
    8000044a:	97ba                	add	a5,a5,a4
    8000044c:	4729                	li	a4,10
    8000044e:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    80000452:	00012797          	auipc	a5,0x12
    80000456:	44c7a923          	sw	a2,1106(a5) # 800128a4 <cons+0xa4>
        wakeup(&cons.r);
    8000045a:	00012517          	auipc	a0,0x12
    8000045e:	44650513          	addi	a0,a0,1094 # 800128a0 <cons+0xa0>
    80000462:	00002097          	auipc	ra,0x2
    80000466:	016080e7          	jalr	22(ra) # 80002478 <wakeup>
    8000046a:	b575                	j	80000316 <consoleintr+0x3c>

000000008000046c <consoleinit>:

void
consoleinit(void)
{
    8000046c:	1141                	addi	sp,sp,-16
    8000046e:	e406                	sd	ra,8(sp)
    80000470:	e022                	sd	s0,0(sp)
    80000472:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000474:	00008597          	auipc	a1,0x8
    80000478:	ca458593          	addi	a1,a1,-860 # 80008118 <userret+0x88>
    8000047c:	00012517          	auipc	a0,0x12
    80000480:	38450513          	addi	a0,a0,900 # 80012800 <cons>
    80000484:	00000097          	auipc	ra,0x0
    80000488:	558080e7          	jalr	1368(ra) # 800009dc <initlock>

  uartinit();
    8000048c:	00000097          	auipc	ra,0x0
    80000490:	340080e7          	jalr	832(ra) # 800007cc <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80000494:	00020797          	auipc	a5,0x20
    80000498:	bcc78793          	addi	a5,a5,-1076 # 80020060 <devsw>
    8000049c:	00000717          	auipc	a4,0x0
    800004a0:	c5070713          	addi	a4,a4,-944 # 800000ec <consoleread>
    800004a4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800004a6:	00000717          	auipc	a4,0x0
    800004aa:	dac70713          	addi	a4,a4,-596 # 80000252 <consolewrite>
    800004ae:	ef98                	sd	a4,24(a5)
}
    800004b0:	60a2                	ld	ra,8(sp)
    800004b2:	6402                	ld	s0,0(sp)
    800004b4:	0141                	addi	sp,sp,16
    800004b6:	8082                	ret

00000000800004b8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    800004b8:	7179                	addi	sp,sp,-48
    800004ba:	f406                	sd	ra,40(sp)
    800004bc:	f022                	sd	s0,32(sp)
    800004be:	ec26                	sd	s1,24(sp)
    800004c0:	e84a                	sd	s2,16(sp)
    800004c2:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    800004c4:	c219                	beqz	a2,800004ca <printint+0x12>
    800004c6:	08054663          	bltz	a0,80000552 <printint+0x9a>
    x = -xx;
  else
    x = xx;
    800004ca:	2501                	sext.w	a0,a0
    800004cc:	4881                	li	a7,0
    800004ce:	fd040693          	addi	a3,s0,-48

  i = 0;
    800004d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800004d4:	2581                	sext.w	a1,a1
    800004d6:	00009617          	auipc	a2,0x9
    800004da:	81260613          	addi	a2,a2,-2030 # 80008ce8 <digits>
    800004de:	883a                	mv	a6,a4
    800004e0:	2705                	addiw	a4,a4,1
    800004e2:	02b577bb          	remuw	a5,a0,a1
    800004e6:	1782                	slli	a5,a5,0x20
    800004e8:	9381                	srli	a5,a5,0x20
    800004ea:	97b2                	add	a5,a5,a2
    800004ec:	0007c783          	lbu	a5,0(a5)
    800004f0:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800004f4:	0005079b          	sext.w	a5,a0
    800004f8:	02b5553b          	divuw	a0,a0,a1
    800004fc:	0685                	addi	a3,a3,1
    800004fe:	feb7f0e3          	bgeu	a5,a1,800004de <printint+0x26>

  if(sign)
    80000502:	00088b63          	beqz	a7,80000518 <printint+0x60>
    buf[i++] = '-';
    80000506:	fe040793          	addi	a5,s0,-32
    8000050a:	973e                	add	a4,a4,a5
    8000050c:	02d00793          	li	a5,45
    80000510:	fef70823          	sb	a5,-16(a4)
    80000514:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80000518:	02e05763          	blez	a4,80000546 <printint+0x8e>
    8000051c:	fd040793          	addi	a5,s0,-48
    80000520:	00e784b3          	add	s1,a5,a4
    80000524:	fff78913          	addi	s2,a5,-1
    80000528:	993a                	add	s2,s2,a4
    8000052a:	377d                	addiw	a4,a4,-1
    8000052c:	1702                	slli	a4,a4,0x20
    8000052e:	9301                	srli	a4,a4,0x20
    80000530:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80000534:	fff4c503          	lbu	a0,-1(s1)
    80000538:	00000097          	auipc	ra,0x0
    8000053c:	ccc080e7          	jalr	-820(ra) # 80000204 <consputc>
  while(--i >= 0)
    80000540:	14fd                	addi	s1,s1,-1
    80000542:	ff2499e3          	bne	s1,s2,80000534 <printint+0x7c>
}
    80000546:	70a2                	ld	ra,40(sp)
    80000548:	7402                	ld	s0,32(sp)
    8000054a:	64e2                	ld	s1,24(sp)
    8000054c:	6942                	ld	s2,16(sp)
    8000054e:	6145                	addi	sp,sp,48
    80000550:	8082                	ret
    x = -xx;
    80000552:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80000556:	4885                	li	a7,1
    x = -xx;
    80000558:	bf9d                	j	800004ce <printint+0x16>

000000008000055a <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    8000055a:	1101                	addi	sp,sp,-32
    8000055c:	ec06                	sd	ra,24(sp)
    8000055e:	e822                	sd	s0,16(sp)
    80000560:	e426                	sd	s1,8(sp)
    80000562:	1000                	addi	s0,sp,32
    80000564:	84aa                	mv	s1,a0
  pr.locking = 0;
    80000566:	00012797          	auipc	a5,0x12
    8000056a:	3607a523          	sw	zero,874(a5) # 800128d0 <pr+0x20>
  printf("PANIC: ");
    8000056e:	00008517          	auipc	a0,0x8
    80000572:	bb250513          	addi	a0,a0,-1102 # 80008120 <userret+0x90>
    80000576:	00000097          	auipc	ra,0x0
    8000057a:	03e080e7          	jalr	62(ra) # 800005b4 <printf>
  printf(s);
    8000057e:	8526                	mv	a0,s1
    80000580:	00000097          	auipc	ra,0x0
    80000584:	034080e7          	jalr	52(ra) # 800005b4 <printf>
  printf("\n");
    80000588:	00008517          	auipc	a0,0x8
    8000058c:	d0850513          	addi	a0,a0,-760 # 80008290 <userret+0x200>
    80000590:	00000097          	auipc	ra,0x0
    80000594:	024080e7          	jalr	36(ra) # 800005b4 <printf>
  printf("HINT: restart xv6 using 'make qemu-gdb', type 'b panic' (to set breakpoint in panic) in the gdb window, followed by 'c' (continue), and when the kernel hits the breakpoint, type 'bt' to get a backtrace\n");
    80000598:	00008517          	auipc	a0,0x8
    8000059c:	b9050513          	addi	a0,a0,-1136 # 80008128 <userret+0x98>
    800005a0:	00000097          	auipc	ra,0x0
    800005a4:	014080e7          	jalr	20(ra) # 800005b4 <printf>
  panicked = 1; // freeze other CPUs
    800005a8:	4785                	li	a5,1
    800005aa:	00028717          	auipc	a4,0x28
    800005ae:	a6f72b23          	sw	a5,-1418(a4) # 80028020 <panicked>
  for(;;)
    800005b2:	a001                	j	800005b2 <panic+0x58>

00000000800005b4 <printf>:
{
    800005b4:	7131                	addi	sp,sp,-192
    800005b6:	fc86                	sd	ra,120(sp)
    800005b8:	f8a2                	sd	s0,112(sp)
    800005ba:	f4a6                	sd	s1,104(sp)
    800005bc:	f0ca                	sd	s2,96(sp)
    800005be:	ecce                	sd	s3,88(sp)
    800005c0:	e8d2                	sd	s4,80(sp)
    800005c2:	e4d6                	sd	s5,72(sp)
    800005c4:	e0da                	sd	s6,64(sp)
    800005c6:	fc5e                	sd	s7,56(sp)
    800005c8:	f862                	sd	s8,48(sp)
    800005ca:	f466                	sd	s9,40(sp)
    800005cc:	f06a                	sd	s10,32(sp)
    800005ce:	ec6e                	sd	s11,24(sp)
    800005d0:	0100                	addi	s0,sp,128
    800005d2:	8a2a                	mv	s4,a0
    800005d4:	e40c                	sd	a1,8(s0)
    800005d6:	e810                	sd	a2,16(s0)
    800005d8:	ec14                	sd	a3,24(s0)
    800005da:	f018                	sd	a4,32(s0)
    800005dc:	f41c                	sd	a5,40(s0)
    800005de:	03043823          	sd	a6,48(s0)
    800005e2:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800005e6:	00012d97          	auipc	s11,0x12
    800005ea:	2eadad83          	lw	s11,746(s11) # 800128d0 <pr+0x20>
  if(locking)
    800005ee:	020d9b63          	bnez	s11,80000624 <printf+0x70>
  if (fmt == 0)
    800005f2:	040a0263          	beqz	s4,80000636 <printf+0x82>
  va_start(ap, fmt);
    800005f6:	00840793          	addi	a5,s0,8
    800005fa:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800005fe:	000a4503          	lbu	a0,0(s4)
    80000602:	16050263          	beqz	a0,80000766 <printf+0x1b2>
    80000606:	4481                	li	s1,0
    if(c != '%'){
    80000608:	02500a93          	li	s5,37
    switch(c){
    8000060c:	07000b13          	li	s6,112
  consputc('x');
    80000610:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80000612:	00008b97          	auipc	s7,0x8
    80000616:	6d6b8b93          	addi	s7,s7,1750 # 80008ce8 <digits>
    switch(c){
    8000061a:	07300c93          	li	s9,115
    8000061e:	06400c13          	li	s8,100
    80000622:	a82d                	j	8000065c <printf+0xa8>
    acquire(&pr.lock);
    80000624:	00012517          	auipc	a0,0x12
    80000628:	28c50513          	addi	a0,a0,652 # 800128b0 <pr>
    8000062c:	00000097          	auipc	ra,0x0
    80000630:	484080e7          	jalr	1156(ra) # 80000ab0 <acquire>
    80000634:	bf7d                	j	800005f2 <printf+0x3e>
    panic("null fmt");
    80000636:	00008517          	auipc	a0,0x8
    8000063a:	bca50513          	addi	a0,a0,-1078 # 80008200 <userret+0x170>
    8000063e:	00000097          	auipc	ra,0x0
    80000642:	f1c080e7          	jalr	-228(ra) # 8000055a <panic>
      consputc(c);
    80000646:	00000097          	auipc	ra,0x0
    8000064a:	bbe080e7          	jalr	-1090(ra) # 80000204 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    8000064e:	2485                	addiw	s1,s1,1
    80000650:	009a07b3          	add	a5,s4,s1
    80000654:	0007c503          	lbu	a0,0(a5)
    80000658:	10050763          	beqz	a0,80000766 <printf+0x1b2>
    if(c != '%'){
    8000065c:	ff5515e3          	bne	a0,s5,80000646 <printf+0x92>
    c = fmt[++i] & 0xff;
    80000660:	2485                	addiw	s1,s1,1
    80000662:	009a07b3          	add	a5,s4,s1
    80000666:	0007c783          	lbu	a5,0(a5)
    8000066a:	0007891b          	sext.w	s2,a5
    if(c == 0)
    8000066e:	cfe5                	beqz	a5,80000766 <printf+0x1b2>
    switch(c){
    80000670:	05678a63          	beq	a5,s6,800006c4 <printf+0x110>
    80000674:	02fb7663          	bgeu	s6,a5,800006a0 <printf+0xec>
    80000678:	09978963          	beq	a5,s9,8000070a <printf+0x156>
    8000067c:	07800713          	li	a4,120
    80000680:	0ce79863          	bne	a5,a4,80000750 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80000684:	f8843783          	ld	a5,-120(s0)
    80000688:	00878713          	addi	a4,a5,8
    8000068c:	f8e43423          	sd	a4,-120(s0)
    80000690:	4605                	li	a2,1
    80000692:	85ea                	mv	a1,s10
    80000694:	4388                	lw	a0,0(a5)
    80000696:	00000097          	auipc	ra,0x0
    8000069a:	e22080e7          	jalr	-478(ra) # 800004b8 <printint>
      break;
    8000069e:	bf45                	j	8000064e <printf+0x9a>
    switch(c){
    800006a0:	0b578263          	beq	a5,s5,80000744 <printf+0x190>
    800006a4:	0b879663          	bne	a5,s8,80000750 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800006a8:	f8843783          	ld	a5,-120(s0)
    800006ac:	00878713          	addi	a4,a5,8
    800006b0:	f8e43423          	sd	a4,-120(s0)
    800006b4:	4605                	li	a2,1
    800006b6:	45a9                	li	a1,10
    800006b8:	4388                	lw	a0,0(a5)
    800006ba:	00000097          	auipc	ra,0x0
    800006be:	dfe080e7          	jalr	-514(ra) # 800004b8 <printint>
      break;
    800006c2:	b771                	j	8000064e <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800006c4:	f8843783          	ld	a5,-120(s0)
    800006c8:	00878713          	addi	a4,a5,8
    800006cc:	f8e43423          	sd	a4,-120(s0)
    800006d0:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800006d4:	03000513          	li	a0,48
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	b2c080e7          	jalr	-1236(ra) # 80000204 <consputc>
  consputc('x');
    800006e0:	07800513          	li	a0,120
    800006e4:	00000097          	auipc	ra,0x0
    800006e8:	b20080e7          	jalr	-1248(ra) # 80000204 <consputc>
    800006ec:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006ee:	03c9d793          	srli	a5,s3,0x3c
    800006f2:	97de                	add	a5,a5,s7
    800006f4:	0007c503          	lbu	a0,0(a5)
    800006f8:	00000097          	auipc	ra,0x0
    800006fc:	b0c080e7          	jalr	-1268(ra) # 80000204 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80000700:	0992                	slli	s3,s3,0x4
    80000702:	397d                	addiw	s2,s2,-1
    80000704:	fe0915e3          	bnez	s2,800006ee <printf+0x13a>
    80000708:	b799                	j	8000064e <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    8000070a:	f8843783          	ld	a5,-120(s0)
    8000070e:	00878713          	addi	a4,a5,8
    80000712:	f8e43423          	sd	a4,-120(s0)
    80000716:	0007b903          	ld	s2,0(a5)
    8000071a:	00090e63          	beqz	s2,80000736 <printf+0x182>
      for(; *s; s++)
    8000071e:	00094503          	lbu	a0,0(s2)
    80000722:	d515                	beqz	a0,8000064e <printf+0x9a>
        consputc(*s);
    80000724:	00000097          	auipc	ra,0x0
    80000728:	ae0080e7          	jalr	-1312(ra) # 80000204 <consputc>
      for(; *s; s++)
    8000072c:	0905                	addi	s2,s2,1
    8000072e:	00094503          	lbu	a0,0(s2)
    80000732:	f96d                	bnez	a0,80000724 <printf+0x170>
    80000734:	bf29                	j	8000064e <printf+0x9a>
        s = "(null)";
    80000736:	00008917          	auipc	s2,0x8
    8000073a:	ac290913          	addi	s2,s2,-1342 # 800081f8 <userret+0x168>
      for(; *s; s++)
    8000073e:	02800513          	li	a0,40
    80000742:	b7cd                	j	80000724 <printf+0x170>
      consputc('%');
    80000744:	8556                	mv	a0,s5
    80000746:	00000097          	auipc	ra,0x0
    8000074a:	abe080e7          	jalr	-1346(ra) # 80000204 <consputc>
      break;
    8000074e:	b701                	j	8000064e <printf+0x9a>
      consputc('%');
    80000750:	8556                	mv	a0,s5
    80000752:	00000097          	auipc	ra,0x0
    80000756:	ab2080e7          	jalr	-1358(ra) # 80000204 <consputc>
      consputc(c);
    8000075a:	854a                	mv	a0,s2
    8000075c:	00000097          	auipc	ra,0x0
    80000760:	aa8080e7          	jalr	-1368(ra) # 80000204 <consputc>
      break;
    80000764:	b5ed                	j	8000064e <printf+0x9a>
  if(locking)
    80000766:	020d9163          	bnez	s11,80000788 <printf+0x1d4>
}
    8000076a:	70e6                	ld	ra,120(sp)
    8000076c:	7446                	ld	s0,112(sp)
    8000076e:	74a6                	ld	s1,104(sp)
    80000770:	7906                	ld	s2,96(sp)
    80000772:	69e6                	ld	s3,88(sp)
    80000774:	6a46                	ld	s4,80(sp)
    80000776:	6aa6                	ld	s5,72(sp)
    80000778:	6b06                	ld	s6,64(sp)
    8000077a:	7be2                	ld	s7,56(sp)
    8000077c:	7c42                	ld	s8,48(sp)
    8000077e:	7ca2                	ld	s9,40(sp)
    80000780:	7d02                	ld	s10,32(sp)
    80000782:	6de2                	ld	s11,24(sp)
    80000784:	6129                	addi	sp,sp,192
    80000786:	8082                	ret
    release(&pr.lock);
    80000788:	00012517          	auipc	a0,0x12
    8000078c:	12850513          	addi	a0,a0,296 # 800128b0 <pr>
    80000790:	00000097          	auipc	ra,0x0
    80000794:	3f0080e7          	jalr	1008(ra) # 80000b80 <release>
}
    80000798:	bfc9                	j	8000076a <printf+0x1b6>

000000008000079a <printfinit>:
    ;
}

void
printfinit(void)
{
    8000079a:	1101                	addi	sp,sp,-32
    8000079c:	ec06                	sd	ra,24(sp)
    8000079e:	e822                	sd	s0,16(sp)
    800007a0:	e426                	sd	s1,8(sp)
    800007a2:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800007a4:	00012497          	auipc	s1,0x12
    800007a8:	10c48493          	addi	s1,s1,268 # 800128b0 <pr>
    800007ac:	00008597          	auipc	a1,0x8
    800007b0:	a6458593          	addi	a1,a1,-1436 # 80008210 <userret+0x180>
    800007b4:	8526                	mv	a0,s1
    800007b6:	00000097          	auipc	ra,0x0
    800007ba:	226080e7          	jalr	550(ra) # 800009dc <initlock>
  pr.locking = 1;
    800007be:	4785                	li	a5,1
    800007c0:	d09c                	sw	a5,32(s1)
}
    800007c2:	60e2                	ld	ra,24(sp)
    800007c4:	6442                	ld	s0,16(sp)
    800007c6:	64a2                	ld	s1,8(sp)
    800007c8:	6105                	addi	sp,sp,32
    800007ca:	8082                	ret

00000000800007cc <uartinit>:
#define ReadReg(reg) (*(Reg(reg)))
#define WriteReg(reg, v) (*(Reg(reg)) = (v))

void
uartinit(void)
{
    800007cc:	1141                	addi	sp,sp,-16
    800007ce:	e422                	sd	s0,8(sp)
    800007d0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800007d2:	100007b7          	lui	a5,0x10000
    800007d6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, 0x80);
    800007da:	f8000713          	li	a4,-128
    800007de:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800007e2:	470d                	li	a4,3
    800007e4:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800007e8:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, 0x03);
    800007ec:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, 0x07);
    800007f0:	471d                	li	a4,7
    800007f2:	00e78123          	sb	a4,2(a5)

  // enable receive interrupts.
  WriteReg(IER, 0x01);
    800007f6:	4705                	li	a4,1
    800007f8:	00e780a3          	sb	a4,1(a5)
}
    800007fc:	6422                	ld	s0,8(sp)
    800007fe:	0141                	addi	sp,sp,16
    80000800:	8082                	ret

0000000080000802 <uartputc>:

// write one output character to the UART.
void
uartputc(int c)
{
    80000802:	1141                	addi	sp,sp,-16
    80000804:	e422                	sd	s0,8(sp)
    80000806:	0800                	addi	s0,sp,16
  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & (1 << 5)) == 0)
    80000808:	10000737          	lui	a4,0x10000
    8000080c:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    80000810:	0ff7f793          	andi	a5,a5,255
    80000814:	0207f793          	andi	a5,a5,32
    80000818:	dbf5                	beqz	a5,8000080c <uartputc+0xa>
    ;
  WriteReg(THR, c);
    8000081a:	0ff57513          	andi	a0,a0,255
    8000081e:	100007b7          	lui	a5,0x10000
    80000822:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>
}
    80000826:	6422                	ld	s0,8(sp)
    80000828:	0141                	addi	sp,sp,16
    8000082a:	8082                	ret

000000008000082c <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    8000082c:	1141                	addi	sp,sp,-16
    8000082e:	e422                	sd	s0,8(sp)
    80000830:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    80000832:	100007b7          	lui	a5,0x10000
    80000836:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000083a:	8b85                	andi	a5,a5,1
    8000083c:	cb91                	beqz	a5,80000850 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    8000083e:	100007b7          	lui	a5,0x10000
    80000842:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    80000846:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    8000084a:	6422                	ld	s0,8(sp)
    8000084c:	0141                	addi	sp,sp,16
    8000084e:	8082                	ret
    return -1;
    80000850:	557d                	li	a0,-1
    80000852:	bfe5                	j	8000084a <uartgetc+0x1e>

0000000080000854 <uartintr>:

// trap.c calls here when the uart interrupts.
void
uartintr(void)
{
    80000854:	1101                	addi	sp,sp,-32
    80000856:	ec06                	sd	ra,24(sp)
    80000858:	e822                	sd	s0,16(sp)
    8000085a:	e426                	sd	s1,8(sp)
    8000085c:	1000                	addi	s0,sp,32
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000085e:	54fd                	li	s1,-1
    int c = uartgetc();
    80000860:	00000097          	auipc	ra,0x0
    80000864:	fcc080e7          	jalr	-52(ra) # 8000082c <uartgetc>
    if(c == -1)
    80000868:	00950763          	beq	a0,s1,80000876 <uartintr+0x22>
      break;
    consoleintr(c);
    8000086c:	00000097          	auipc	ra,0x0
    80000870:	a6e080e7          	jalr	-1426(ra) # 800002da <consoleintr>
  while(1){
    80000874:	b7f5                	j	80000860 <uartintr+0xc>
  }
}
    80000876:	60e2                	ld	ra,24(sp)
    80000878:	6442                	ld	s0,16(sp)
    8000087a:	64a2                	ld	s1,8(sp)
    8000087c:	6105                	addi	sp,sp,32
    8000087e:	8082                	ret

0000000080000880 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000880:	1101                	addi	sp,sp,-32
    80000882:	ec06                	sd	ra,24(sp)
    80000884:	e822                	sd	s0,16(sp)
    80000886:	e426                	sd	s1,8(sp)
    80000888:	e04a                	sd	s2,0(sp)
    8000088a:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000088c:	03451793          	slli	a5,a0,0x34
    80000890:	ebb9                	bnez	a5,800008e6 <kfree+0x66>
    80000892:	84aa                	mv	s1,a0
    80000894:	00027797          	auipc	a5,0x27
    80000898:	7c878793          	addi	a5,a5,1992 # 8002805c <end>
    8000089c:	04f56563          	bltu	a0,a5,800008e6 <kfree+0x66>
    800008a0:	47c5                	li	a5,17
    800008a2:	07ee                	slli	a5,a5,0x1b
    800008a4:	04f57163          	bgeu	a0,a5,800008e6 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    800008a8:	6605                	lui	a2,0x1
    800008aa:	4585                	li	a1,1
    800008ac:	00000097          	auipc	ra,0x0
    800008b0:	4d2080e7          	jalr	1234(ra) # 80000d7e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    800008b4:	00012917          	auipc	s2,0x12
    800008b8:	02490913          	addi	s2,s2,36 # 800128d8 <kmem>
    800008bc:	854a                	mv	a0,s2
    800008be:	00000097          	auipc	ra,0x0
    800008c2:	1f2080e7          	jalr	498(ra) # 80000ab0 <acquire>
  r->next = kmem.freelist;
    800008c6:	02093783          	ld	a5,32(s2)
    800008ca:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    800008cc:	02993023          	sd	s1,32(s2)
  release(&kmem.lock);
    800008d0:	854a                	mv	a0,s2
    800008d2:	00000097          	auipc	ra,0x0
    800008d6:	2ae080e7          	jalr	686(ra) # 80000b80 <release>
}
    800008da:	60e2                	ld	ra,24(sp)
    800008dc:	6442                	ld	s0,16(sp)
    800008de:	64a2                	ld	s1,8(sp)
    800008e0:	6902                	ld	s2,0(sp)
    800008e2:	6105                	addi	sp,sp,32
    800008e4:	8082                	ret
    panic("kfree");
    800008e6:	00008517          	auipc	a0,0x8
    800008ea:	93250513          	addi	a0,a0,-1742 # 80008218 <userret+0x188>
    800008ee:	00000097          	auipc	ra,0x0
    800008f2:	c6c080e7          	jalr	-916(ra) # 8000055a <panic>

00000000800008f6 <freerange>:
{
    800008f6:	7179                	addi	sp,sp,-48
    800008f8:	f406                	sd	ra,40(sp)
    800008fa:	f022                	sd	s0,32(sp)
    800008fc:	ec26                	sd	s1,24(sp)
    800008fe:	e84a                	sd	s2,16(sp)
    80000900:	e44e                	sd	s3,8(sp)
    80000902:	e052                	sd	s4,0(sp)
    80000904:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000906:	6785                	lui	a5,0x1
    80000908:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    8000090c:	94aa                	add	s1,s1,a0
    8000090e:	757d                	lui	a0,0xfffff
    80000910:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    80000912:	94be                	add	s1,s1,a5
    80000914:	0095ee63          	bltu	a1,s1,80000930 <freerange+0x3a>
    80000918:	892e                	mv	s2,a1
    kfree(p);
    8000091a:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000091c:	6985                	lui	s3,0x1
    kfree(p);
    8000091e:	01448533          	add	a0,s1,s4
    80000922:	00000097          	auipc	ra,0x0
    80000926:	f5e080e7          	jalr	-162(ra) # 80000880 <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    8000092a:	94ce                	add	s1,s1,s3
    8000092c:	fe9979e3          	bgeu	s2,s1,8000091e <freerange+0x28>
}
    80000930:	70a2                	ld	ra,40(sp)
    80000932:	7402                	ld	s0,32(sp)
    80000934:	64e2                	ld	s1,24(sp)
    80000936:	6942                	ld	s2,16(sp)
    80000938:	69a2                	ld	s3,8(sp)
    8000093a:	6a02                	ld	s4,0(sp)
    8000093c:	6145                	addi	sp,sp,48
    8000093e:	8082                	ret

0000000080000940 <kinit>:
{
    80000940:	1141                	addi	sp,sp,-16
    80000942:	e406                	sd	ra,8(sp)
    80000944:	e022                	sd	s0,0(sp)
    80000946:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000948:	00008597          	auipc	a1,0x8
    8000094c:	8d858593          	addi	a1,a1,-1832 # 80008220 <userret+0x190>
    80000950:	00012517          	auipc	a0,0x12
    80000954:	f8850513          	addi	a0,a0,-120 # 800128d8 <kmem>
    80000958:	00000097          	auipc	ra,0x0
    8000095c:	084080e7          	jalr	132(ra) # 800009dc <initlock>
  freerange(end, (void*)PHYSTOP);
    80000960:	45c5                	li	a1,17
    80000962:	05ee                	slli	a1,a1,0x1b
    80000964:	00027517          	auipc	a0,0x27
    80000968:	6f850513          	addi	a0,a0,1784 # 8002805c <end>
    8000096c:	00000097          	auipc	ra,0x0
    80000970:	f8a080e7          	jalr	-118(ra) # 800008f6 <freerange>
}
    80000974:	60a2                	ld	ra,8(sp)
    80000976:	6402                	ld	s0,0(sp)
    80000978:	0141                	addi	sp,sp,16
    8000097a:	8082                	ret

000000008000097c <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    8000097c:	1101                	addi	sp,sp,-32
    8000097e:	ec06                	sd	ra,24(sp)
    80000980:	e822                	sd	s0,16(sp)
    80000982:	e426                	sd	s1,8(sp)
    80000984:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000986:	00012497          	auipc	s1,0x12
    8000098a:	f5248493          	addi	s1,s1,-174 # 800128d8 <kmem>
    8000098e:	8526                	mv	a0,s1
    80000990:	00000097          	auipc	ra,0x0
    80000994:	120080e7          	jalr	288(ra) # 80000ab0 <acquire>
  r = kmem.freelist;
    80000998:	7084                	ld	s1,32(s1)
  if(r)
    8000099a:	c885                	beqz	s1,800009ca <kalloc+0x4e>
    kmem.freelist = r->next;
    8000099c:	609c                	ld	a5,0(s1)
    8000099e:	00012517          	auipc	a0,0x12
    800009a2:	f3a50513          	addi	a0,a0,-198 # 800128d8 <kmem>
    800009a6:	f11c                	sd	a5,32(a0)
  release(&kmem.lock);
    800009a8:	00000097          	auipc	ra,0x0
    800009ac:	1d8080e7          	jalr	472(ra) # 80000b80 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800009b0:	6605                	lui	a2,0x1
    800009b2:	4595                	li	a1,5
    800009b4:	8526                	mv	a0,s1
    800009b6:	00000097          	auipc	ra,0x0
    800009ba:	3c8080e7          	jalr	968(ra) # 80000d7e <memset>
  return (void*)r;
}
    800009be:	8526                	mv	a0,s1
    800009c0:	60e2                	ld	ra,24(sp)
    800009c2:	6442                	ld	s0,16(sp)
    800009c4:	64a2                	ld	s1,8(sp)
    800009c6:	6105                	addi	sp,sp,32
    800009c8:	8082                	ret
  release(&kmem.lock);
    800009ca:	00012517          	auipc	a0,0x12
    800009ce:	f0e50513          	addi	a0,a0,-242 # 800128d8 <kmem>
    800009d2:	00000097          	auipc	ra,0x0
    800009d6:	1ae080e7          	jalr	430(ra) # 80000b80 <release>
  if(r)
    800009da:	b7d5                	j	800009be <kalloc+0x42>

00000000800009dc <initlock>:

// assumes locks are not freed
void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
    800009dc:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800009de:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800009e2:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    800009e6:	00052e23          	sw	zero,28(a0)
  lk->n = 0;
    800009ea:	00052c23          	sw	zero,24(a0)
  if(nlock >= NLOCK)
    800009ee:	00027797          	auipc	a5,0x27
    800009f2:	6367a783          	lw	a5,1590(a5) # 80028024 <nlock>
    800009f6:	3e700713          	li	a4,999
    800009fa:	02f74063          	blt	a4,a5,80000a1a <initlock+0x3e>
    panic("initlock");
  locks[nlock] = lk;
    800009fe:	00379693          	slli	a3,a5,0x3
    80000a02:	00012717          	auipc	a4,0x12
    80000a06:	efe70713          	addi	a4,a4,-258 # 80012900 <locks>
    80000a0a:	9736                	add	a4,a4,a3
    80000a0c:	e308                	sd	a0,0(a4)
  nlock++;
    80000a0e:	2785                	addiw	a5,a5,1
    80000a10:	00027717          	auipc	a4,0x27
    80000a14:	60f72a23          	sw	a5,1556(a4) # 80028024 <nlock>
    80000a18:	8082                	ret
{
    80000a1a:	1141                	addi	sp,sp,-16
    80000a1c:	e406                	sd	ra,8(sp)
    80000a1e:	e022                	sd	s0,0(sp)
    80000a20:	0800                	addi	s0,sp,16
    panic("initlock");
    80000a22:	00008517          	auipc	a0,0x8
    80000a26:	80650513          	addi	a0,a0,-2042 # 80008228 <userret+0x198>
    80000a2a:	00000097          	auipc	ra,0x0
    80000a2e:	b30080e7          	jalr	-1232(ra) # 8000055a <panic>

0000000080000a32 <holding>:
// Must be called with interrupts off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000a32:	411c                	lw	a5,0(a0)
    80000a34:	e399                	bnez	a5,80000a3a <holding+0x8>
    80000a36:	4501                	li	a0,0
  return r;
}
    80000a38:	8082                	ret
{
    80000a3a:	1101                	addi	sp,sp,-32
    80000a3c:	ec06                	sd	ra,24(sp)
    80000a3e:	e822                	sd	s0,16(sp)
    80000a40:	e426                	sd	s1,8(sp)
    80000a42:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000a44:	6904                	ld	s1,16(a0)
    80000a46:	00001097          	auipc	ra,0x1
    80000a4a:	0d4080e7          	jalr	212(ra) # 80001b1a <mycpu>
    80000a4e:	40a48533          	sub	a0,s1,a0
    80000a52:	00153513          	seqz	a0,a0
}
    80000a56:	60e2                	ld	ra,24(sp)
    80000a58:	6442                	ld	s0,16(sp)
    80000a5a:	64a2                	ld	s1,8(sp)
    80000a5c:	6105                	addi	sp,sp,32
    80000a5e:	8082                	ret

0000000080000a60 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000a60:	1101                	addi	sp,sp,-32
    80000a62:	ec06                	sd	ra,24(sp)
    80000a64:	e822                	sd	s0,16(sp)
    80000a66:	e426                	sd	s1,8(sp)
    80000a68:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a6a:	100024f3          	csrr	s1,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000a6e:	8889                	andi	s1,s1,2
  int old = intr_get();
  if(old)
    80000a70:	c491                	beqz	s1,80000a7c <push_off+0x1c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000a72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80000a76:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000a78:	10079073          	csrw	sstatus,a5
    intr_off();
  if(mycpu()->noff == 0)
    80000a7c:	00001097          	auipc	ra,0x1
    80000a80:	09e080e7          	jalr	158(ra) # 80001b1a <mycpu>
    80000a84:	5d3c                	lw	a5,120(a0)
    80000a86:	cf89                	beqz	a5,80000aa0 <push_off+0x40>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000a88:	00001097          	auipc	ra,0x1
    80000a8c:	092080e7          	jalr	146(ra) # 80001b1a <mycpu>
    80000a90:	5d3c                	lw	a5,120(a0)
    80000a92:	2785                	addiw	a5,a5,1
    80000a94:	dd3c                	sw	a5,120(a0)
}
    80000a96:	60e2                	ld	ra,24(sp)
    80000a98:	6442                	ld	s0,16(sp)
    80000a9a:	64a2                	ld	s1,8(sp)
    80000a9c:	6105                	addi	sp,sp,32
    80000a9e:	8082                	ret
    mycpu()->intena = old;
    80000aa0:	00001097          	auipc	ra,0x1
    80000aa4:	07a080e7          	jalr	122(ra) # 80001b1a <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80000aa8:	009034b3          	snez	s1,s1
    80000aac:	dd64                	sw	s1,124(a0)
    80000aae:	bfe9                	j	80000a88 <push_off+0x28>

0000000080000ab0 <acquire>:
{
    80000ab0:	1101                	addi	sp,sp,-32
    80000ab2:	ec06                	sd	ra,24(sp)
    80000ab4:	e822                	sd	s0,16(sp)
    80000ab6:	e426                	sd	s1,8(sp)
    80000ab8:	1000                	addi	s0,sp,32
    80000aba:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000abc:	00000097          	auipc	ra,0x0
    80000ac0:	fa4080e7          	jalr	-92(ra) # 80000a60 <push_off>
  if(holding(lk))
    80000ac4:	8526                	mv	a0,s1
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	f6c080e7          	jalr	-148(ra) # 80000a32 <holding>
    80000ace:	e911                	bnez	a0,80000ae2 <acquire+0x32>
  __sync_fetch_and_add(&(lk->n), 1);
    80000ad0:	4785                	li	a5,1
    80000ad2:	01848713          	addi	a4,s1,24
    80000ad6:	0f50000f          	fence	iorw,ow
    80000ada:	04f7202f          	amoadd.w.aq	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000ade:	4705                	li	a4,1
    80000ae0:	a839                	j	80000afe <acquire+0x4e>
    panic("acquire");
    80000ae2:	00007517          	auipc	a0,0x7
    80000ae6:	75650513          	addi	a0,a0,1878 # 80008238 <userret+0x1a8>
    80000aea:	00000097          	auipc	ra,0x0
    80000aee:	a70080e7          	jalr	-1424(ra) # 8000055a <panic>
     __sync_fetch_and_add(&lk->nts, 1);
    80000af2:	01c48793          	addi	a5,s1,28
    80000af6:	0f50000f          	fence	iorw,ow
    80000afa:	04e7a02f          	amoadd.w.aq	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80000afe:	87ba                	mv	a5,a4
    80000b00:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80000b04:	2781                	sext.w	a5,a5
    80000b06:	f7f5                	bnez	a5,80000af2 <acquire+0x42>
  __sync_synchronize();
    80000b08:	0ff0000f          	fence
  lk->cpu = mycpu();
    80000b0c:	00001097          	auipc	ra,0x1
    80000b10:	00e080e7          	jalr	14(ra) # 80001b1a <mycpu>
    80000b14:	e888                	sd	a0,16(s1)
}
    80000b16:	60e2                	ld	ra,24(sp)
    80000b18:	6442                	ld	s0,16(sp)
    80000b1a:	64a2                	ld	s1,8(sp)
    80000b1c:	6105                	addi	sp,sp,32
    80000b1e:	8082                	ret

0000000080000b20 <pop_off>:

void
pop_off(void)
{
    80000b20:	1141                	addi	sp,sp,-16
    80000b22:	e406                	sd	ra,8(sp)
    80000b24:	e022                	sd	s0,0(sp)
    80000b26:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b28:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000b2c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80000b2e:	eb8d                	bnez	a5,80000b60 <pop_off+0x40>
    panic("pop_off - interruptible");
  struct cpu *c = mycpu();
    80000b30:	00001097          	auipc	ra,0x1
    80000b34:	fea080e7          	jalr	-22(ra) # 80001b1a <mycpu>
  if(c->noff < 1)
    80000b38:	5d3c                	lw	a5,120(a0)
    80000b3a:	02f05b63          	blez	a5,80000b70 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    80000b3e:	37fd                	addiw	a5,a5,-1
    80000b40:	0007871b          	sext.w	a4,a5
    80000b44:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80000b46:	eb09                	bnez	a4,80000b58 <pop_off+0x38>
    80000b48:	5d7c                	lw	a5,124(a0)
    80000b4a:	c799                	beqz	a5,80000b58 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80000b4c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80000b50:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80000b54:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80000b58:	60a2                	ld	ra,8(sp)
    80000b5a:	6402                	ld	s0,0(sp)
    80000b5c:	0141                	addi	sp,sp,16
    80000b5e:	8082                	ret
    panic("pop_off - interruptible");
    80000b60:	00007517          	auipc	a0,0x7
    80000b64:	6e050513          	addi	a0,a0,1760 # 80008240 <userret+0x1b0>
    80000b68:	00000097          	auipc	ra,0x0
    80000b6c:	9f2080e7          	jalr	-1550(ra) # 8000055a <panic>
    panic("pop_off");
    80000b70:	00007517          	auipc	a0,0x7
    80000b74:	6e850513          	addi	a0,a0,1768 # 80008258 <userret+0x1c8>
    80000b78:	00000097          	auipc	ra,0x0
    80000b7c:	9e2080e7          	jalr	-1566(ra) # 8000055a <panic>

0000000080000b80 <release>:
{
    80000b80:	1101                	addi	sp,sp,-32
    80000b82:	ec06                	sd	ra,24(sp)
    80000b84:	e822                	sd	s0,16(sp)
    80000b86:	e426                	sd	s1,8(sp)
    80000b88:	1000                	addi	s0,sp,32
    80000b8a:	84aa                	mv	s1,a0
  if(!holding(lk))
    80000b8c:	00000097          	auipc	ra,0x0
    80000b90:	ea6080e7          	jalr	-346(ra) # 80000a32 <holding>
    80000b94:	c115                	beqz	a0,80000bb8 <release+0x38>
  lk->cpu = 0;
    80000b96:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80000b9a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    80000b9e:	0f50000f          	fence	iorw,ow
    80000ba2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80000ba6:	00000097          	auipc	ra,0x0
    80000baa:	f7a080e7          	jalr	-134(ra) # 80000b20 <pop_off>
}
    80000bae:	60e2                	ld	ra,24(sp)
    80000bb0:	6442                	ld	s0,16(sp)
    80000bb2:	64a2                	ld	s1,8(sp)
    80000bb4:	6105                	addi	sp,sp,32
    80000bb6:	8082                	ret
    panic("release");
    80000bb8:	00007517          	auipc	a0,0x7
    80000bbc:	6a850513          	addi	a0,a0,1704 # 80008260 <userret+0x1d0>
    80000bc0:	00000097          	auipc	ra,0x0
    80000bc4:	99a080e7          	jalr	-1638(ra) # 8000055a <panic>

0000000080000bc8 <print_lock>:

void
print_lock(struct spinlock *lk)
{
  if(lk->n > 0) 
    80000bc8:	4d14                	lw	a3,24(a0)
    80000bca:	e291                	bnez	a3,80000bce <print_lock+0x6>
    80000bcc:	8082                	ret
{
    80000bce:	1141                	addi	sp,sp,-16
    80000bd0:	e406                	sd	ra,8(sp)
    80000bd2:	e022                	sd	s0,0(sp)
    80000bd4:	0800                	addi	s0,sp,16
    printf("lock: %s: #test-and-set %d #acquire() %d\n", lk->name, lk->nts, lk->n);
    80000bd6:	4d50                	lw	a2,28(a0)
    80000bd8:	650c                	ld	a1,8(a0)
    80000bda:	00007517          	auipc	a0,0x7
    80000bde:	68e50513          	addi	a0,a0,1678 # 80008268 <userret+0x1d8>
    80000be2:	00000097          	auipc	ra,0x0
    80000be6:	9d2080e7          	jalr	-1582(ra) # 800005b4 <printf>
}
    80000bea:	60a2                	ld	ra,8(sp)
    80000bec:	6402                	ld	s0,0(sp)
    80000bee:	0141                	addi	sp,sp,16
    80000bf0:	8082                	ret

0000000080000bf2 <sys_ntas>:

uint64
sys_ntas(void)
{
    80000bf2:	711d                	addi	sp,sp,-96
    80000bf4:	ec86                	sd	ra,88(sp)
    80000bf6:	e8a2                	sd	s0,80(sp)
    80000bf8:	e4a6                	sd	s1,72(sp)
    80000bfa:	e0ca                	sd	s2,64(sp)
    80000bfc:	fc4e                	sd	s3,56(sp)
    80000bfe:	f852                	sd	s4,48(sp)
    80000c00:	f456                	sd	s5,40(sp)
    80000c02:	f05a                	sd	s6,32(sp)
    80000c04:	ec5e                	sd	s7,24(sp)
    80000c06:	e862                	sd	s8,16(sp)
    80000c08:	1080                	addi	s0,sp,96
  int zero = 0;
    80000c0a:	fa042623          	sw	zero,-84(s0)
  int tot = 0;
  
  if (argint(0, &zero) < 0) {
    80000c0e:	fac40593          	addi	a1,s0,-84
    80000c12:	4501                	li	a0,0
    80000c14:	00002097          	auipc	ra,0x2
    80000c18:	0d8080e7          	jalr	216(ra) # 80002cec <argint>
    80000c1c:	14054d63          	bltz	a0,80000d76 <sys_ntas+0x184>
    return -1;
  }
  if(zero == 0) {
    80000c20:	fac42783          	lw	a5,-84(s0)
    80000c24:	e78d                	bnez	a5,80000c4e <sys_ntas+0x5c>
    80000c26:	00012797          	auipc	a5,0x12
    80000c2a:	cda78793          	addi	a5,a5,-806 # 80012900 <locks>
    80000c2e:	00014697          	auipc	a3,0x14
    80000c32:	c1268693          	addi	a3,a3,-1006 # 80014840 <pid_lock>
    for(int i = 0; i < NLOCK; i++) {
      if(locks[i] == 0)
    80000c36:	6398                	ld	a4,0(a5)
    80000c38:	14070163          	beqz	a4,80000d7a <sys_ntas+0x188>
        break;
      locks[i]->nts = 0;
    80000c3c:	00072e23          	sw	zero,28(a4)
      locks[i]->n = 0;
    80000c40:	00072c23          	sw	zero,24(a4)
    for(int i = 0; i < NLOCK; i++) {
    80000c44:	07a1                	addi	a5,a5,8
    80000c46:	fed798e3          	bne	a5,a3,80000c36 <sys_ntas+0x44>
    }
    return 0;
    80000c4a:	4501                	li	a0,0
    80000c4c:	aa09                	j	80000d5e <sys_ntas+0x16c>
  }

  printf("=== lock kmem/bcache stats\n");
    80000c4e:	00007517          	auipc	a0,0x7
    80000c52:	64a50513          	addi	a0,a0,1610 # 80008298 <userret+0x208>
    80000c56:	00000097          	auipc	ra,0x0
    80000c5a:	95e080e7          	jalr	-1698(ra) # 800005b4 <printf>
  for(int i = 0; i < NLOCK; i++) {
    80000c5e:	00012b17          	auipc	s6,0x12
    80000c62:	ca2b0b13          	addi	s6,s6,-862 # 80012900 <locks>
    80000c66:	00014b97          	auipc	s7,0x14
    80000c6a:	bdab8b93          	addi	s7,s7,-1062 # 80014840 <pid_lock>
  printf("=== lock kmem/bcache stats\n");
    80000c6e:	84da                	mv	s1,s6
  int tot = 0;
    80000c70:	4981                	li	s3,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000c72:	00007a17          	auipc	s4,0x7
    80000c76:	646a0a13          	addi	s4,s4,1606 # 800082b8 <userret+0x228>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000c7a:	00007c17          	auipc	s8,0x7
    80000c7e:	5a6c0c13          	addi	s8,s8,1446 # 80008220 <userret+0x190>
    80000c82:	a829                	j	80000c9c <sys_ntas+0xaa>
      tot += locks[i]->nts;
    80000c84:	00093503          	ld	a0,0(s2)
    80000c88:	4d5c                	lw	a5,28(a0)
    80000c8a:	013789bb          	addw	s3,a5,s3
      print_lock(locks[i]);
    80000c8e:	00000097          	auipc	ra,0x0
    80000c92:	f3a080e7          	jalr	-198(ra) # 80000bc8 <print_lock>
  for(int i = 0; i < NLOCK; i++) {
    80000c96:	04a1                	addi	s1,s1,8
    80000c98:	05748763          	beq	s1,s7,80000ce6 <sys_ntas+0xf4>
    if(locks[i] == 0)
    80000c9c:	8926                	mv	s2,s1
    80000c9e:	609c                	ld	a5,0(s1)
    80000ca0:	c3b9                	beqz	a5,80000ce6 <sys_ntas+0xf4>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000ca2:	0087ba83          	ld	s5,8(a5)
    80000ca6:	8552                	mv	a0,s4
    80000ca8:	00000097          	auipc	ra,0x0
    80000cac:	25e080e7          	jalr	606(ra) # 80000f06 <strlen>
    80000cb0:	0005061b          	sext.w	a2,a0
    80000cb4:	85d2                	mv	a1,s4
    80000cb6:	8556                	mv	a0,s5
    80000cb8:	00000097          	auipc	ra,0x0
    80000cbc:	1a2080e7          	jalr	418(ra) # 80000e5a <strncmp>
    80000cc0:	d171                	beqz	a0,80000c84 <sys_ntas+0x92>
       strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80000cc2:	609c                	ld	a5,0(s1)
    80000cc4:	0087ba83          	ld	s5,8(a5)
    80000cc8:	8562                	mv	a0,s8
    80000cca:	00000097          	auipc	ra,0x0
    80000cce:	23c080e7          	jalr	572(ra) # 80000f06 <strlen>
    80000cd2:	0005061b          	sext.w	a2,a0
    80000cd6:	85e2                	mv	a1,s8
    80000cd8:	8556                	mv	a0,s5
    80000cda:	00000097          	auipc	ra,0x0
    80000cde:	180080e7          	jalr	384(ra) # 80000e5a <strncmp>
    if(strncmp(locks[i]->name, "bcache", strlen("bcache")) == 0 ||
    80000ce2:	f955                	bnez	a0,80000c96 <sys_ntas+0xa4>
    80000ce4:	b745                	j	80000c84 <sys_ntas+0x92>
    }
  }

  printf("=== top 5 contended locks:\n");
    80000ce6:	00007517          	auipc	a0,0x7
    80000cea:	5da50513          	addi	a0,a0,1498 # 800082c0 <userret+0x230>
    80000cee:	00000097          	auipc	ra,0x0
    80000cf2:	8c6080e7          	jalr	-1850(ra) # 800005b4 <printf>
    80000cf6:	4a15                	li	s4,5
  int last = 100000000;
    80000cf8:	05f5e537          	lui	a0,0x5f5e
    80000cfc:	10050513          	addi	a0,a0,256 # 5f5e100 <_entry-0x7a0a1f00>
  // stupid way to compute top 5 contended locks
  for(int t= 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
    80000d00:	4a81                	li	s5,0
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d02:	00012497          	auipc	s1,0x12
    80000d06:	bfe48493          	addi	s1,s1,-1026 # 80012900 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80000d0a:	3e800913          	li	s2,1000
    80000d0e:	a091                	j	80000d52 <sys_ntas+0x160>
    80000d10:	2705                	addiw	a4,a4,1
    80000d12:	06a1                	addi	a3,a3,8
    80000d14:	03270063          	beq	a4,s2,80000d34 <sys_ntas+0x142>
      if(locks[i] == 0)
    80000d18:	629c                	ld	a5,0(a3)
    80000d1a:	cf89                	beqz	a5,80000d34 <sys_ntas+0x142>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d1c:	4fd0                	lw	a2,28(a5)
    80000d1e:	00359793          	slli	a5,a1,0x3
    80000d22:	97a6                	add	a5,a5,s1
    80000d24:	639c                	ld	a5,0(a5)
    80000d26:	4fdc                	lw	a5,28(a5)
    80000d28:	fec7f4e3          	bgeu	a5,a2,80000d10 <sys_ntas+0x11e>
    80000d2c:	fea672e3          	bgeu	a2,a0,80000d10 <sys_ntas+0x11e>
    80000d30:	85ba                	mv	a1,a4
    80000d32:	bff9                	j	80000d10 <sys_ntas+0x11e>
        top = i;
      }
    }
    print_lock(locks[top]);
    80000d34:	058e                	slli	a1,a1,0x3
    80000d36:	00b48bb3          	add	s7,s1,a1
    80000d3a:	000bb503          	ld	a0,0(s7)
    80000d3e:	00000097          	auipc	ra,0x0
    80000d42:	e8a080e7          	jalr	-374(ra) # 80000bc8 <print_lock>
    last = locks[top]->nts;
    80000d46:	000bb783          	ld	a5,0(s7)
    80000d4a:	4fc8                	lw	a0,28(a5)
  for(int t= 0; t < 5; t++) {
    80000d4c:	3a7d                	addiw	s4,s4,-1
    80000d4e:	000a0763          	beqz	s4,80000d5c <sys_ntas+0x16a>
  int tot = 0;
    80000d52:	86da                	mv	a3,s6
    for(int i = 0; i < NLOCK; i++) {
    80000d54:	8756                	mv	a4,s5
    int top = 0;
    80000d56:	85d6                	mv	a1,s5
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80000d58:	2501                	sext.w	a0,a0
    80000d5a:	bf7d                	j	80000d18 <sys_ntas+0x126>
  }
  return tot;
    80000d5c:	854e                	mv	a0,s3
}
    80000d5e:	60e6                	ld	ra,88(sp)
    80000d60:	6446                	ld	s0,80(sp)
    80000d62:	64a6                	ld	s1,72(sp)
    80000d64:	6906                	ld	s2,64(sp)
    80000d66:	79e2                	ld	s3,56(sp)
    80000d68:	7a42                	ld	s4,48(sp)
    80000d6a:	7aa2                	ld	s5,40(sp)
    80000d6c:	7b02                	ld	s6,32(sp)
    80000d6e:	6be2                	ld	s7,24(sp)
    80000d70:	6c42                	ld	s8,16(sp)
    80000d72:	6125                	addi	sp,sp,96
    80000d74:	8082                	ret
    return -1;
    80000d76:	557d                	li	a0,-1
    80000d78:	b7dd                	j	80000d5e <sys_ntas+0x16c>
    return 0;
    80000d7a:	4501                	li	a0,0
    80000d7c:	b7cd                	j	80000d5e <sys_ntas+0x16c>

0000000080000d7e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000d7e:	1141                	addi	sp,sp,-16
    80000d80:	e422                	sd	s0,8(sp)
    80000d82:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000d84:	ce09                	beqz	a2,80000d9e <memset+0x20>
    80000d86:	87aa                	mv	a5,a0
    80000d88:	fff6071b          	addiw	a4,a2,-1
    80000d8c:	1702                	slli	a4,a4,0x20
    80000d8e:	9301                	srli	a4,a4,0x20
    80000d90:	0705                	addi	a4,a4,1
    80000d92:	972a                	add	a4,a4,a0
    cdst[i] = c;
    80000d94:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000d98:	0785                	addi	a5,a5,1
    80000d9a:	fee79de3          	bne	a5,a4,80000d94 <memset+0x16>
  }
  return dst;
}
    80000d9e:	6422                	ld	s0,8(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e422                	sd	s0,8(sp)
    80000da8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    80000daa:	ca05                	beqz	a2,80000dda <memcmp+0x36>
    80000dac:	fff6069b          	addiw	a3,a2,-1
    80000db0:	1682                	slli	a3,a3,0x20
    80000db2:	9281                	srli	a3,a3,0x20
    80000db4:	0685                	addi	a3,a3,1
    80000db6:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    80000db8:	00054783          	lbu	a5,0(a0)
    80000dbc:	0005c703          	lbu	a4,0(a1)
    80000dc0:	00e79863          	bne	a5,a4,80000dd0 <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    80000dc4:	0505                	addi	a0,a0,1
    80000dc6:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000dc8:	fed518e3          	bne	a0,a3,80000db8 <memcmp+0x14>
  }

  return 0;
    80000dcc:	4501                	li	a0,0
    80000dce:	a019                	j	80000dd4 <memcmp+0x30>
      return *s1 - *s2;
    80000dd0:	40e7853b          	subw	a0,a5,a4
}
    80000dd4:	6422                	ld	s0,8(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret
  return 0;
    80000dda:	4501                	li	a0,0
    80000ddc:	bfe5                	j	80000dd4 <memcmp+0x30>

0000000080000dde <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000dde:	1141                	addi	sp,sp,-16
    80000de0:	e422                	sd	s0,8(sp)
    80000de2:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000de4:	02a5e563          	bltu	a1,a0,80000e0e <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000de8:	fff6069b          	addiw	a3,a2,-1
    80000dec:	ce11                	beqz	a2,80000e08 <memmove+0x2a>
    80000dee:	1682                	slli	a3,a3,0x20
    80000df0:	9281                	srli	a3,a3,0x20
    80000df2:	0685                	addi	a3,a3,1
    80000df4:	96ae                	add	a3,a3,a1
    80000df6:	87aa                	mv	a5,a0
      *d++ = *s++;
    80000df8:	0585                	addi	a1,a1,1
    80000dfa:	0785                	addi	a5,a5,1
    80000dfc:	fff5c703          	lbu	a4,-1(a1)
    80000e00:	fee78fa3          	sb	a4,-1(a5)
    while(n-- > 0)
    80000e04:	fed59ae3          	bne	a1,a3,80000df8 <memmove+0x1a>

  return dst;
}
    80000e08:	6422                	ld	s0,8(sp)
    80000e0a:	0141                	addi	sp,sp,16
    80000e0c:	8082                	ret
  if(s < d && s + n > d){
    80000e0e:	02061713          	slli	a4,a2,0x20
    80000e12:	9301                	srli	a4,a4,0x20
    80000e14:	00e587b3          	add	a5,a1,a4
    80000e18:	fcf578e3          	bgeu	a0,a5,80000de8 <memmove+0xa>
    d += n;
    80000e1c:	972a                	add	a4,a4,a0
    while(n-- > 0)
    80000e1e:	fff6069b          	addiw	a3,a2,-1
    80000e22:	d27d                	beqz	a2,80000e08 <memmove+0x2a>
    80000e24:	02069613          	slli	a2,a3,0x20
    80000e28:	9201                	srli	a2,a2,0x20
    80000e2a:	fff64613          	not	a2,a2
    80000e2e:	963e                	add	a2,a2,a5
      *--d = *--s;
    80000e30:	17fd                	addi	a5,a5,-1
    80000e32:	177d                	addi	a4,a4,-1
    80000e34:	0007c683          	lbu	a3,0(a5)
    80000e38:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    80000e3c:	fec79ae3          	bne	a5,a2,80000e30 <memmove+0x52>
    80000e40:	b7e1                	j	80000e08 <memmove+0x2a>

0000000080000e42 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000e42:	1141                	addi	sp,sp,-16
    80000e44:	e406                	sd	ra,8(sp)
    80000e46:	e022                	sd	s0,0(sp)
    80000e48:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000e4a:	00000097          	auipc	ra,0x0
    80000e4e:	f94080e7          	jalr	-108(ra) # 80000dde <memmove>
}
    80000e52:	60a2                	ld	ra,8(sp)
    80000e54:	6402                	ld	s0,0(sp)
    80000e56:	0141                	addi	sp,sp,16
    80000e58:	8082                	ret

0000000080000e5a <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000e5a:	1141                	addi	sp,sp,-16
    80000e5c:	e422                	sd	s0,8(sp)
    80000e5e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000e60:	ce11                	beqz	a2,80000e7c <strncmp+0x22>
    80000e62:	00054783          	lbu	a5,0(a0)
    80000e66:	cf89                	beqz	a5,80000e80 <strncmp+0x26>
    80000e68:	0005c703          	lbu	a4,0(a1)
    80000e6c:	00f71a63          	bne	a4,a5,80000e80 <strncmp+0x26>
    n--, p++, q++;
    80000e70:	367d                	addiw	a2,a2,-1
    80000e72:	0505                	addi	a0,a0,1
    80000e74:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000e76:	f675                	bnez	a2,80000e62 <strncmp+0x8>
  if(n == 0)
    return 0;
    80000e78:	4501                	li	a0,0
    80000e7a:	a809                	j	80000e8c <strncmp+0x32>
    80000e7c:	4501                	li	a0,0
    80000e7e:	a039                	j	80000e8c <strncmp+0x32>
  if(n == 0)
    80000e80:	ca09                	beqz	a2,80000e92 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000e82:	00054503          	lbu	a0,0(a0)
    80000e86:	0005c783          	lbu	a5,0(a1)
    80000e8a:	9d1d                	subw	a0,a0,a5
}
    80000e8c:	6422                	ld	s0,8(sp)
    80000e8e:	0141                	addi	sp,sp,16
    80000e90:	8082                	ret
    return 0;
    80000e92:	4501                	li	a0,0
    80000e94:	bfe5                	j	80000e8c <strncmp+0x32>

0000000080000e96 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    80000e96:	1141                	addi	sp,sp,-16
    80000e98:	e422                	sd	s0,8(sp)
    80000e9a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000e9c:	872a                	mv	a4,a0
    80000e9e:	8832                	mv	a6,a2
    80000ea0:	367d                	addiw	a2,a2,-1
    80000ea2:	01005963          	blez	a6,80000eb4 <strncpy+0x1e>
    80000ea6:	0705                	addi	a4,a4,1
    80000ea8:	0005c783          	lbu	a5,0(a1)
    80000eac:	fef70fa3          	sb	a5,-1(a4)
    80000eb0:	0585                	addi	a1,a1,1
    80000eb2:	f7f5                	bnez	a5,80000e9e <strncpy+0x8>
    ;
  while(n-- > 0)
    80000eb4:	86ba                	mv	a3,a4
    80000eb6:	00c05c63          	blez	a2,80000ece <strncpy+0x38>
    *s++ = 0;
    80000eba:	0685                	addi	a3,a3,1
    80000ebc:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    80000ec0:	fff6c793          	not	a5,a3
    80000ec4:	9fb9                	addw	a5,a5,a4
    80000ec6:	010787bb          	addw	a5,a5,a6
    80000eca:	fef048e3          	bgtz	a5,80000eba <strncpy+0x24>
  return os;
}
    80000ece:	6422                	ld	s0,8(sp)
    80000ed0:	0141                	addi	sp,sp,16
    80000ed2:	8082                	ret

0000000080000ed4 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000ed4:	1141                	addi	sp,sp,-16
    80000ed6:	e422                	sd	s0,8(sp)
    80000ed8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000eda:	02c05363          	blez	a2,80000f00 <safestrcpy+0x2c>
    80000ede:	fff6069b          	addiw	a3,a2,-1
    80000ee2:	1682                	slli	a3,a3,0x20
    80000ee4:	9281                	srli	a3,a3,0x20
    80000ee6:	96ae                	add	a3,a3,a1
    80000ee8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000eea:	00d58963          	beq	a1,a3,80000efc <safestrcpy+0x28>
    80000eee:	0585                	addi	a1,a1,1
    80000ef0:	0785                	addi	a5,a5,1
    80000ef2:	fff5c703          	lbu	a4,-1(a1)
    80000ef6:	fee78fa3          	sb	a4,-1(a5)
    80000efa:	fb65                	bnez	a4,80000eea <safestrcpy+0x16>
    ;
  *s = 0;
    80000efc:	00078023          	sb	zero,0(a5)
  return os;
}
    80000f00:	6422                	ld	s0,8(sp)
    80000f02:	0141                	addi	sp,sp,16
    80000f04:	8082                	ret

0000000080000f06 <strlen>:

int
strlen(const char *s)
{
    80000f06:	1141                	addi	sp,sp,-16
    80000f08:	e422                	sd	s0,8(sp)
    80000f0a:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000f0c:	00054783          	lbu	a5,0(a0)
    80000f10:	cf91                	beqz	a5,80000f2c <strlen+0x26>
    80000f12:	0505                	addi	a0,a0,1
    80000f14:	87aa                	mv	a5,a0
    80000f16:	4685                	li	a3,1
    80000f18:	9e89                	subw	a3,a3,a0
    80000f1a:	00f6853b          	addw	a0,a3,a5
    80000f1e:	0785                	addi	a5,a5,1
    80000f20:	fff7c703          	lbu	a4,-1(a5)
    80000f24:	fb7d                	bnez	a4,80000f1a <strlen+0x14>
    ;
  return n;
}
    80000f26:	6422                	ld	s0,8(sp)
    80000f28:	0141                	addi	sp,sp,16
    80000f2a:	8082                	ret
  for(n = 0; s[n]; n++)
    80000f2c:	4501                	li	a0,0
    80000f2e:	bfe5                	j	80000f26 <strlen+0x20>

0000000080000f30 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000f30:	1141                	addi	sp,sp,-16
    80000f32:	e406                	sd	ra,8(sp)
    80000f34:	e022                	sd	s0,0(sp)
    80000f36:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000f38:	00001097          	auipc	ra,0x1
    80000f3c:	bd2080e7          	jalr	-1070(ra) # 80001b0a <cpuid>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000f40:	00027717          	auipc	a4,0x27
    80000f44:	0e870713          	addi	a4,a4,232 # 80028028 <started>
  if(cpuid() == 0){
    80000f48:	c139                	beqz	a0,80000f8e <main+0x5e>
    while(started == 0)
    80000f4a:	431c                	lw	a5,0(a4)
    80000f4c:	2781                	sext.w	a5,a5
    80000f4e:	dff5                	beqz	a5,80000f4a <main+0x1a>
      ;
    __sync_synchronize();
    80000f50:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    80000f54:	00001097          	auipc	ra,0x1
    80000f58:	bb6080e7          	jalr	-1098(ra) # 80001b0a <cpuid>
    80000f5c:	85aa                	mv	a1,a0
    80000f5e:	00007517          	auipc	a0,0x7
    80000f62:	39a50513          	addi	a0,a0,922 # 800082f8 <userret+0x268>
    80000f66:	fffff097          	auipc	ra,0xfffff
    80000f6a:	64e080e7          	jalr	1614(ra) # 800005b4 <printf>
    kvminithart();    // turn on paging
    80000f6e:	00000097          	auipc	ra,0x0
    80000f72:	1ea080e7          	jalr	490(ra) # 80001158 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000f76:	00002097          	auipc	ra,0x2
    80000f7a:	862080e7          	jalr	-1950(ra) # 800027d8 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000f7e:	00005097          	auipc	ra,0x5
    80000f82:	fd2080e7          	jalr	-46(ra) # 80005f50 <plicinithart>
  }

  scheduler();        
    80000f86:	00001097          	auipc	ra,0x1
    80000f8a:	08a080e7          	jalr	138(ra) # 80002010 <scheduler>
    consoleinit();
    80000f8e:	fffff097          	auipc	ra,0xfffff
    80000f92:	4de080e7          	jalr	1246(ra) # 8000046c <consoleinit>
    printfinit();
    80000f96:	00000097          	auipc	ra,0x0
    80000f9a:	804080e7          	jalr	-2044(ra) # 8000079a <printfinit>
    printf("\n");
    80000f9e:	00007517          	auipc	a0,0x7
    80000fa2:	2f250513          	addi	a0,a0,754 # 80008290 <userret+0x200>
    80000fa6:	fffff097          	auipc	ra,0xfffff
    80000faa:	60e080e7          	jalr	1550(ra) # 800005b4 <printf>
    printf("xv6 kernel is booting\n");
    80000fae:	00007517          	auipc	a0,0x7
    80000fb2:	33250513          	addi	a0,a0,818 # 800082e0 <userret+0x250>
    80000fb6:	fffff097          	auipc	ra,0xfffff
    80000fba:	5fe080e7          	jalr	1534(ra) # 800005b4 <printf>
    printf("\n");
    80000fbe:	00007517          	auipc	a0,0x7
    80000fc2:	2d250513          	addi	a0,a0,722 # 80008290 <userret+0x200>
    80000fc6:	fffff097          	auipc	ra,0xfffff
    80000fca:	5ee080e7          	jalr	1518(ra) # 800005b4 <printf>
    kinit();         // physical page allocator
    80000fce:	00000097          	auipc	ra,0x0
    80000fd2:	972080e7          	jalr	-1678(ra) # 80000940 <kinit>
    kvminit();       // create kernel page table
    80000fd6:	00000097          	auipc	ra,0x0
    80000fda:	30c080e7          	jalr	780(ra) # 800012e2 <kvminit>
    kvminithart();   // turn on paging
    80000fde:	00000097          	auipc	ra,0x0
    80000fe2:	17a080e7          	jalr	378(ra) # 80001158 <kvminithart>
    procinit();      // process table
    80000fe6:	00001097          	auipc	ra,0x1
    80000fea:	a54080e7          	jalr	-1452(ra) # 80001a3a <procinit>
    trapinit();      // trap vectors
    80000fee:	00001097          	auipc	ra,0x1
    80000ff2:	7c2080e7          	jalr	1986(ra) # 800027b0 <trapinit>
    trapinithart();  // install kernel trap vector
    80000ff6:	00001097          	auipc	ra,0x1
    80000ffa:	7e2080e7          	jalr	2018(ra) # 800027d8 <trapinithart>
    plicinit();      // set up interrupt controller
    80000ffe:	00005097          	auipc	ra,0x5
    80001002:	f3c080e7          	jalr	-196(ra) # 80005f3a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80001006:	00005097          	auipc	ra,0x5
    8000100a:	f4a080e7          	jalr	-182(ra) # 80005f50 <plicinithart>
    binit();         // buffer cache
    8000100e:	00002097          	auipc	ra,0x2
    80001012:	fe2080e7          	jalr	-30(ra) # 80002ff0 <binit>
    iinit();         // inode cache
    80001016:	00002097          	auipc	ra,0x2
    8000101a:	676080e7          	jalr	1654(ra) # 8000368c <iinit>
    fileinit();      // file table
    8000101e:	00003097          	auipc	ra,0x3
    80001022:	700080e7          	jalr	1792(ra) # 8000471e <fileinit>
    virtio_disk_init(minor(ROOTDEV)); // emulated hard disk
    80001026:	4501                	li	a0,0
    80001028:	00005097          	auipc	ra,0x5
    8000102c:	04a080e7          	jalr	74(ra) # 80006072 <virtio_disk_init>
    userinit();      // first user process
    80001030:	00001097          	auipc	ra,0x1
    80001034:	d7a080e7          	jalr	-646(ra) # 80001daa <userinit>
    __sync_synchronize();
    80001038:	0ff0000f          	fence
    started = 1;
    8000103c:	4785                	li	a5,1
    8000103e:	00027717          	auipc	a4,0x27
    80001042:	fef72523          	sw	a5,-22(a4) # 80028028 <started>
    80001046:	b781                	j	80000f86 <main+0x56>

0000000080001048 <walk>:
//   39..63 -- must be zero.
//   30..38 -- 9 bits of level-2 index.
//   21..39 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..12 -- 12 bits of byte offset within the page.
static pte_t *walk(pagetable_t pagetable, uint64 va, int alloc) {
    80001048:	7139                	addi	sp,sp,-64
    8000104a:	fc06                	sd	ra,56(sp)
    8000104c:	f822                	sd	s0,48(sp)
    8000104e:	f426                	sd	s1,40(sp)
    80001050:	f04a                	sd	s2,32(sp)
    80001052:	ec4e                	sd	s3,24(sp)
    80001054:	e852                	sd	s4,16(sp)
    80001056:	e456                	sd	s5,8(sp)
    80001058:	e05a                	sd	s6,0(sp)
    8000105a:	0080                	addi	s0,sp,64
    8000105c:	84aa                	mv	s1,a0
    8000105e:	89ae                	mv	s3,a1
    80001060:	8ab2                	mv	s5,a2
  if (va >= MAXVA)
    80001062:	57fd                	li	a5,-1
    80001064:	83e9                	srli	a5,a5,0x1a
    80001066:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80001068:	4b31                	li	s6,12
  if (va >= MAXVA)
    8000106a:	04b7f263          	bgeu	a5,a1,800010ae <walk+0x66>
    panic("walk");
    8000106e:	00007517          	auipc	a0,0x7
    80001072:	2a250513          	addi	a0,a0,674 # 80008310 <userret+0x280>
    80001076:	fffff097          	auipc	ra,0xfffff
    8000107a:	4e4080e7          	jalr	1252(ra) # 8000055a <panic>
    pte_t *pte = &pagetable[PX(level, va)];
    if (*pte & PTE_V) {
      pagetable = (pagetable_t)PTE2PA(*pte);
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    8000107e:	060a8663          	beqz	s5,800010ea <walk+0xa2>
    80001082:	00000097          	auipc	ra,0x0
    80001086:	8fa080e7          	jalr	-1798(ra) # 8000097c <kalloc>
    8000108a:	84aa                	mv	s1,a0
    8000108c:	c529                	beqz	a0,800010d6 <walk+0x8e>
        return 0;
      memset(pagetable, 0, PGSIZE);
    8000108e:	6605                	lui	a2,0x1
    80001090:	4581                	li	a1,0
    80001092:	00000097          	auipc	ra,0x0
    80001096:	cec080e7          	jalr	-788(ra) # 80000d7e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    8000109a:	00c4d793          	srli	a5,s1,0xc
    8000109e:	07aa                	slli	a5,a5,0xa
    800010a0:	0017e793          	ori	a5,a5,1
    800010a4:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    800010a8:	3a5d                	addiw	s4,s4,-9
    800010aa:	036a0063          	beq	s4,s6,800010ca <walk+0x82>
    pte_t *pte = &pagetable[PX(level, va)];
    800010ae:	0149d933          	srl	s2,s3,s4
    800010b2:	1ff97913          	andi	s2,s2,511
    800010b6:	090e                	slli	s2,s2,0x3
    800010b8:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    800010ba:	00093483          	ld	s1,0(s2)
    800010be:	0014f793          	andi	a5,s1,1
    800010c2:	dfd5                	beqz	a5,8000107e <walk+0x36>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800010c4:	80a9                	srli	s1,s1,0xa
    800010c6:	04b2                	slli	s1,s1,0xc
    800010c8:	b7c5                	j	800010a8 <walk+0x60>
    }
  }
  return &pagetable[PX(0, va)];
    800010ca:	00c9d513          	srli	a0,s3,0xc
    800010ce:	1ff57513          	andi	a0,a0,511
    800010d2:	050e                	slli	a0,a0,0x3
    800010d4:	9526                	add	a0,a0,s1
}
    800010d6:	70e2                	ld	ra,56(sp)
    800010d8:	7442                	ld	s0,48(sp)
    800010da:	74a2                	ld	s1,40(sp)
    800010dc:	7902                	ld	s2,32(sp)
    800010de:	69e2                	ld	s3,24(sp)
    800010e0:	6a42                	ld	s4,16(sp)
    800010e2:	6aa2                	ld	s5,8(sp)
    800010e4:	6b02                	ld	s6,0(sp)
    800010e6:	6121                	addi	sp,sp,64
    800010e8:	8082                	ret
        return 0;
    800010ea:	4501                	li	a0,0
    800010ec:	b7ed                	j	800010d6 <walk+0x8e>

00000000800010ee <freewalk>:
  return newsz;
}

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
static void freewalk(pagetable_t pagetable) {
    800010ee:	7179                	addi	sp,sp,-48
    800010f0:	f406                	sd	ra,40(sp)
    800010f2:	f022                	sd	s0,32(sp)
    800010f4:	ec26                	sd	s1,24(sp)
    800010f6:	e84a                	sd	s2,16(sp)
    800010f8:	e44e                	sd	s3,8(sp)
    800010fa:	e052                	sd	s4,0(sp)
    800010fc:	1800                	addi	s0,sp,48
    800010fe:	8a2a                	mv	s4,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001100:	84aa                	mv	s1,a0
    80001102:	6905                	lui	s2,0x1
    80001104:	992a                	add	s2,s2,a0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001106:	4985                	li	s3,1
    80001108:	a821                	j	80001120 <freewalk+0x32>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
    8000110a:	8129                	srli	a0,a0,0xa
      freewalk((pagetable_t)child);
    8000110c:	0532                	slli	a0,a0,0xc
    8000110e:	00000097          	auipc	ra,0x0
    80001112:	fe0080e7          	jalr	-32(ra) # 800010ee <freewalk>
      pagetable[i] = 0;
    80001116:	0004b023          	sd	zero,0(s1)
  for (int i = 0; i < 512; i++) {
    8000111a:	04a1                	addi	s1,s1,8
    8000111c:	03248163          	beq	s1,s2,8000113e <freewalk+0x50>
    pte_t pte = pagetable[i];
    80001120:	6088                	ld	a0,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001122:	00f57793          	andi	a5,a0,15
    80001126:	ff3782e3          	beq	a5,s3,8000110a <freewalk+0x1c>
    } else if (pte & PTE_V) {
    8000112a:	8905                	andi	a0,a0,1
    8000112c:	d57d                	beqz	a0,8000111a <freewalk+0x2c>
      panic("freewalk: leaf ");
    8000112e:	00007517          	auipc	a0,0x7
    80001132:	1ea50513          	addi	a0,a0,490 # 80008318 <userret+0x288>
    80001136:	fffff097          	auipc	ra,0xfffff
    8000113a:	424080e7          	jalr	1060(ra) # 8000055a <panic>
    }
  }
  kfree((void *)pagetable);
    8000113e:	8552                	mv	a0,s4
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	740080e7          	jalr	1856(ra) # 80000880 <kfree>
}
    80001148:	70a2                	ld	ra,40(sp)
    8000114a:	7402                	ld	s0,32(sp)
    8000114c:	64e2                	ld	s1,24(sp)
    8000114e:	6942                	ld	s2,16(sp)
    80001150:	69a2                	ld	s3,8(sp)
    80001152:	6a02                	ld	s4,0(sp)
    80001154:	6145                	addi	sp,sp,48
    80001156:	8082                	ret

0000000080001158 <kvminithart>:
void kvminithart() {
    80001158:	1141                	addi	sp,sp,-16
    8000115a:	e422                	sd	s0,8(sp)
    8000115c:	0800                	addi	s0,sp,16
  w_satp(MAKE_SATP(kernel_pagetable));
    8000115e:	00027797          	auipc	a5,0x27
    80001162:	ed27b783          	ld	a5,-302(a5) # 80028030 <kernel_pagetable>
    80001166:	83b1                	srli	a5,a5,0xc
    80001168:	577d                	li	a4,-1
    8000116a:	177e                	slli	a4,a4,0x3f
    8000116c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    8000116e:	18079073          	csrw	satp,a5
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80001172:	12000073          	sfence.vma
}
    80001176:	6422                	ld	s0,8(sp)
    80001178:	0141                	addi	sp,sp,16
    8000117a:	8082                	ret

000000008000117c <walkaddr>:
  if (va >= MAXVA)
    8000117c:	57fd                	li	a5,-1
    8000117e:	83e9                	srli	a5,a5,0x1a
    80001180:	00b7f463          	bgeu	a5,a1,80001188 <walkaddr+0xc>
    return 0;
    80001184:	4501                	li	a0,0
}
    80001186:	8082                	ret
uint64 walkaddr(pagetable_t pagetable, uint64 va) {
    80001188:	1141                	addi	sp,sp,-16
    8000118a:	e406                	sd	ra,8(sp)
    8000118c:	e022                	sd	s0,0(sp)
    8000118e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001190:	4601                	li	a2,0
    80001192:	00000097          	auipc	ra,0x0
    80001196:	eb6080e7          	jalr	-330(ra) # 80001048 <walk>
  if (pte == 0)
    8000119a:	c105                	beqz	a0,800011ba <walkaddr+0x3e>
  if ((*pte & PTE_V) == 0)
    8000119c:	611c                	ld	a5,0(a0)
  if ((*pte & PTE_U) == 0)
    8000119e:	0117f693          	andi	a3,a5,17
    800011a2:	4745                	li	a4,17
    return 0;
    800011a4:	4501                	li	a0,0
  if ((*pte & PTE_U) == 0)
    800011a6:	00e68663          	beq	a3,a4,800011b2 <walkaddr+0x36>
}
    800011aa:	60a2                	ld	ra,8(sp)
    800011ac:	6402                	ld	s0,0(sp)
    800011ae:	0141                	addi	sp,sp,16
    800011b0:	8082                	ret
  pa = PTE2PA(*pte);
    800011b2:	00a7d513          	srli	a0,a5,0xa
    800011b6:	0532                	slli	a0,a0,0xc
  return pa;
    800011b8:	bfcd                	j	800011aa <walkaddr+0x2e>
    return 0;
    800011ba:	4501                	li	a0,0
    800011bc:	b7fd                	j	800011aa <walkaddr+0x2e>

00000000800011be <kvmpa>:
uint64 kvmpa(uint64 va) {
    800011be:	1101                	addi	sp,sp,-32
    800011c0:	ec06                	sd	ra,24(sp)
    800011c2:	e822                	sd	s0,16(sp)
    800011c4:	e426                	sd	s1,8(sp)
    800011c6:	1000                	addi	s0,sp,32
    800011c8:	85aa                	mv	a1,a0
  uint64 off = va % PGSIZE;
    800011ca:	1552                	slli	a0,a0,0x34
    800011cc:	03455493          	srli	s1,a0,0x34
  pte = walk(kernel_pagetable, va, 0);
    800011d0:	4601                	li	a2,0
    800011d2:	00027517          	auipc	a0,0x27
    800011d6:	e5e53503          	ld	a0,-418(a0) # 80028030 <kernel_pagetable>
    800011da:	00000097          	auipc	ra,0x0
    800011de:	e6e080e7          	jalr	-402(ra) # 80001048 <walk>
  if (pte == 0)
    800011e2:	cd09                	beqz	a0,800011fc <kvmpa+0x3e>
  if ((*pte & PTE_V) == 0)
    800011e4:	6108                	ld	a0,0(a0)
    800011e6:	00157793          	andi	a5,a0,1
    800011ea:	c38d                	beqz	a5,8000120c <kvmpa+0x4e>
  pa = PTE2PA(*pte);
    800011ec:	8129                	srli	a0,a0,0xa
    800011ee:	0532                	slli	a0,a0,0xc
}
    800011f0:	9526                	add	a0,a0,s1
    800011f2:	60e2                	ld	ra,24(sp)
    800011f4:	6442                	ld	s0,16(sp)
    800011f6:	64a2                	ld	s1,8(sp)
    800011f8:	6105                	addi	sp,sp,32
    800011fa:	8082                	ret
    panic("kvmpa");
    800011fc:	00007517          	auipc	a0,0x7
    80001200:	12c50513          	addi	a0,a0,300 # 80008328 <userret+0x298>
    80001204:	fffff097          	auipc	ra,0xfffff
    80001208:	356080e7          	jalr	854(ra) # 8000055a <panic>
    panic("kvmpa");
    8000120c:	00007517          	auipc	a0,0x7
    80001210:	11c50513          	addi	a0,a0,284 # 80008328 <userret+0x298>
    80001214:	fffff097          	auipc	ra,0xfffff
    80001218:	346080e7          	jalr	838(ra) # 8000055a <panic>

000000008000121c <mappages>:
             int perm) {
    8000121c:	715d                	addi	sp,sp,-80
    8000121e:	e486                	sd	ra,72(sp)
    80001220:	e0a2                	sd	s0,64(sp)
    80001222:	fc26                	sd	s1,56(sp)
    80001224:	f84a                	sd	s2,48(sp)
    80001226:	f44e                	sd	s3,40(sp)
    80001228:	f052                	sd	s4,32(sp)
    8000122a:	ec56                	sd	s5,24(sp)
    8000122c:	e85a                	sd	s6,16(sp)
    8000122e:	e45e                	sd	s7,8(sp)
    80001230:	0880                	addi	s0,sp,80
    80001232:	8aaa                	mv	s5,a0
    80001234:	8b3a                	mv	s6,a4
  a = PGROUNDDOWN(va);
    80001236:	777d                	lui	a4,0xfffff
    80001238:	00e5f7b3          	and	a5,a1,a4
  last = PGROUNDDOWN(va + size - 1);
    8000123c:	167d                	addi	a2,a2,-1
    8000123e:	00b609b3          	add	s3,a2,a1
    80001242:	00e9f9b3          	and	s3,s3,a4
  a = PGROUNDDOWN(va);
    80001246:	893e                	mv	s2,a5
    80001248:	40f68a33          	sub	s4,a3,a5
    a += PGSIZE;
    8000124c:	6b85                	lui	s7,0x1
    8000124e:	012a04b3          	add	s1,s4,s2
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001252:	4605                	li	a2,1
    80001254:	85ca                	mv	a1,s2
    80001256:	8556                	mv	a0,s5
    80001258:	00000097          	auipc	ra,0x0
    8000125c:	df0080e7          	jalr	-528(ra) # 80001048 <walk>
    80001260:	c51d                	beqz	a0,8000128e <mappages+0x72>
    if (*pte & PTE_V)
    80001262:	611c                	ld	a5,0(a0)
    80001264:	8b85                	andi	a5,a5,1
    80001266:	ef81                	bnez	a5,8000127e <mappages+0x62>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001268:	80b1                	srli	s1,s1,0xc
    8000126a:	04aa                	slli	s1,s1,0xa
    8000126c:	0164e4b3          	or	s1,s1,s6
    80001270:	0014e493          	ori	s1,s1,1
    80001274:	e104                	sd	s1,0(a0)
    if (a == last)
    80001276:	03390863          	beq	s2,s3,800012a6 <mappages+0x8a>
    a += PGSIZE;
    8000127a:	995e                	add	s2,s2,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000127c:	bfc9                	j	8000124e <mappages+0x32>
      panic("remap");
    8000127e:	00007517          	auipc	a0,0x7
    80001282:	0b250513          	addi	a0,a0,178 # 80008330 <userret+0x2a0>
    80001286:	fffff097          	auipc	ra,0xfffff
    8000128a:	2d4080e7          	jalr	724(ra) # 8000055a <panic>
      return -1;
    8000128e:	557d                	li	a0,-1
}
    80001290:	60a6                	ld	ra,72(sp)
    80001292:	6406                	ld	s0,64(sp)
    80001294:	74e2                	ld	s1,56(sp)
    80001296:	7942                	ld	s2,48(sp)
    80001298:	79a2                	ld	s3,40(sp)
    8000129a:	7a02                	ld	s4,32(sp)
    8000129c:	6ae2                	ld	s5,24(sp)
    8000129e:	6b42                	ld	s6,16(sp)
    800012a0:	6ba2                	ld	s7,8(sp)
    800012a2:	6161                	addi	sp,sp,80
    800012a4:	8082                	ret
  return 0;
    800012a6:	4501                	li	a0,0
    800012a8:	b7e5                	j	80001290 <mappages+0x74>

00000000800012aa <kvmmap>:
void kvmmap(uint64 va, uint64 pa, uint64 sz, int perm) {
    800012aa:	1141                	addi	sp,sp,-16
    800012ac:	e406                	sd	ra,8(sp)
    800012ae:	e022                	sd	s0,0(sp)
    800012b0:	0800                	addi	s0,sp,16
    800012b2:	8736                	mv	a4,a3
  if (mappages(kernel_pagetable, va, sz, pa, perm) != 0)
    800012b4:	86ae                	mv	a3,a1
    800012b6:	85aa                	mv	a1,a0
    800012b8:	00027517          	auipc	a0,0x27
    800012bc:	d7853503          	ld	a0,-648(a0) # 80028030 <kernel_pagetable>
    800012c0:	00000097          	auipc	ra,0x0
    800012c4:	f5c080e7          	jalr	-164(ra) # 8000121c <mappages>
    800012c8:	e509                	bnez	a0,800012d2 <kvmmap+0x28>
}
    800012ca:	60a2                	ld	ra,8(sp)
    800012cc:	6402                	ld	s0,0(sp)
    800012ce:	0141                	addi	sp,sp,16
    800012d0:	8082                	ret
    panic("kvmmap");
    800012d2:	00007517          	auipc	a0,0x7
    800012d6:	06650513          	addi	a0,a0,102 # 80008338 <userret+0x2a8>
    800012da:	fffff097          	auipc	ra,0xfffff
    800012de:	280080e7          	jalr	640(ra) # 8000055a <panic>

00000000800012e2 <kvminit>:
void kvminit() {
    800012e2:	1101                	addi	sp,sp,-32
    800012e4:	ec06                	sd	ra,24(sp)
    800012e6:	e822                	sd	s0,16(sp)
    800012e8:	e426                	sd	s1,8(sp)
    800012ea:	1000                	addi	s0,sp,32
  kernel_pagetable = (pagetable_t)kalloc();
    800012ec:	fffff097          	auipc	ra,0xfffff
    800012f0:	690080e7          	jalr	1680(ra) # 8000097c <kalloc>
    800012f4:	00027797          	auipc	a5,0x27
    800012f8:	d2a7be23          	sd	a0,-708(a5) # 80028030 <kernel_pagetable>
  memset(kernel_pagetable, 0, PGSIZE);
    800012fc:	6605                	lui	a2,0x1
    800012fe:	4581                	li	a1,0
    80001300:	00000097          	auipc	ra,0x0
    80001304:	a7e080e7          	jalr	-1410(ra) # 80000d7e <memset>
  kvmmap(UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001308:	4699                	li	a3,6
    8000130a:	6605                	lui	a2,0x1
    8000130c:	100005b7          	lui	a1,0x10000
    80001310:	10000537          	lui	a0,0x10000
    80001314:	00000097          	auipc	ra,0x0
    80001318:	f96080e7          	jalr	-106(ra) # 800012aa <kvmmap>
  kvmmap(VIRTION(0), VIRTION(0), PGSIZE, PTE_R | PTE_W);
    8000131c:	4699                	li	a3,6
    8000131e:	6605                	lui	a2,0x1
    80001320:	100015b7          	lui	a1,0x10001
    80001324:	10001537          	lui	a0,0x10001
    80001328:	00000097          	auipc	ra,0x0
    8000132c:	f82080e7          	jalr	-126(ra) # 800012aa <kvmmap>
  kvmmap(VIRTION(1), VIRTION(1), PGSIZE, PTE_R | PTE_W);
    80001330:	4699                	li	a3,6
    80001332:	6605                	lui	a2,0x1
    80001334:	100025b7          	lui	a1,0x10002
    80001338:	10002537          	lui	a0,0x10002
    8000133c:	00000097          	auipc	ra,0x0
    80001340:	f6e080e7          	jalr	-146(ra) # 800012aa <kvmmap>
  kvmmap(CLINT, CLINT, 0x10000, PTE_R | PTE_W);
    80001344:	4699                	li	a3,6
    80001346:	6641                	lui	a2,0x10
    80001348:	020005b7          	lui	a1,0x2000
    8000134c:	02000537          	lui	a0,0x2000
    80001350:	00000097          	auipc	ra,0x0
    80001354:	f5a080e7          	jalr	-166(ra) # 800012aa <kvmmap>
  kvmmap(PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    80001358:	4699                	li	a3,6
    8000135a:	00400637          	lui	a2,0x400
    8000135e:	0c0005b7          	lui	a1,0xc000
    80001362:	0c000537          	lui	a0,0xc000
    80001366:	00000097          	auipc	ra,0x0
    8000136a:	f44080e7          	jalr	-188(ra) # 800012aa <kvmmap>
  kvmmap(KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    8000136e:	00008497          	auipc	s1,0x8
    80001372:	c9248493          	addi	s1,s1,-878 # 80009000 <initcode>
    80001376:	46a9                	li	a3,10
    80001378:	80008617          	auipc	a2,0x80008
    8000137c:	c8860613          	addi	a2,a2,-888 # 9000 <_entry-0x7fff7000>
    80001380:	4585                	li	a1,1
    80001382:	05fe                	slli	a1,a1,0x1f
    80001384:	852e                	mv	a0,a1
    80001386:	00000097          	auipc	ra,0x0
    8000138a:	f24080e7          	jalr	-220(ra) # 800012aa <kvmmap>
  kvmmap((uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    8000138e:	4699                	li	a3,6
    80001390:	4645                	li	a2,17
    80001392:	066e                	slli	a2,a2,0x1b
    80001394:	8e05                	sub	a2,a2,s1
    80001396:	85a6                	mv	a1,s1
    80001398:	8526                	mv	a0,s1
    8000139a:	00000097          	auipc	ra,0x0
    8000139e:	f10080e7          	jalr	-240(ra) # 800012aa <kvmmap>
  kvmmap(TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800013a2:	46a9                	li	a3,10
    800013a4:	6605                	lui	a2,0x1
    800013a6:	00007597          	auipc	a1,0x7
    800013aa:	c5a58593          	addi	a1,a1,-934 # 80008000 <trampoline>
    800013ae:	04000537          	lui	a0,0x4000
    800013b2:	157d                	addi	a0,a0,-1
    800013b4:	0532                	slli	a0,a0,0xc
    800013b6:	00000097          	auipc	ra,0x0
    800013ba:	ef4080e7          	jalr	-268(ra) # 800012aa <kvmmap>
}
    800013be:	60e2                	ld	ra,24(sp)
    800013c0:	6442                	ld	s0,16(sp)
    800013c2:	64a2                	ld	s1,8(sp)
    800013c4:	6105                	addi	sp,sp,32
    800013c6:	8082                	ret

00000000800013c8 <uvmunmap>:
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 size, int do_free) {
    800013c8:	715d                	addi	sp,sp,-80
    800013ca:	e486                	sd	ra,72(sp)
    800013cc:	e0a2                	sd	s0,64(sp)
    800013ce:	fc26                	sd	s1,56(sp)
    800013d0:	f84a                	sd	s2,48(sp)
    800013d2:	f44e                	sd	s3,40(sp)
    800013d4:	f052                	sd	s4,32(sp)
    800013d6:	ec56                	sd	s5,24(sp)
    800013d8:	e85a                	sd	s6,16(sp)
    800013da:	e45e                	sd	s7,8(sp)
    800013dc:	0880                	addi	s0,sp,80
  a = PGROUNDDOWN(va);
    800013de:	77fd                	lui	a5,0xfffff
    800013e0:	00f5f933          	and	s2,a1,a5
  last = PGROUNDDOWN(va + size - 1);
    800013e4:	167d                	addi	a2,a2,-1
    800013e6:	00b609b3          	add	s3,a2,a1
    800013ea:	00f9f9b3          	and	s3,s3,a5
  for (; a <= last; a += PGSIZE, pa += PGSIZE) {
    800013ee:	0529ef63          	bltu	s3,s2,8000144c <uvmunmap+0x84>
    800013f2:	8a2a                	mv	s4,a0
    800013f4:	8b36                	mv	s6,a3
    if (PTE_FLAGS(*pte) == PTE_V)
    800013f6:	4b85                	li	s7,1
  for (; a <= last; a += PGSIZE, pa += PGSIZE) {
    800013f8:	6a85                	lui	s5,0x1
    800013fa:	a02d                	j	80001424 <uvmunmap+0x5c>
      panic("uvmunmap: not a leaf");
    800013fc:	00007517          	auipc	a0,0x7
    80001400:	f4450513          	addi	a0,a0,-188 # 80008340 <userret+0x2b0>
    80001404:	fffff097          	auipc	ra,0xfffff
    80001408:	156080e7          	jalr	342(ra) # 8000055a <panic>
      pa = PTE2PA(*pte);
    8000140c:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    8000140e:	00c79513          	slli	a0,a5,0xc
    80001412:	fffff097          	auipc	ra,0xfffff
    80001416:	46e080e7          	jalr	1134(ra) # 80000880 <kfree>
    *pte = 0;
    8000141a:	0004b023          	sd	zero,0(s1)
  for (; a <= last; a += PGSIZE, pa += PGSIZE) {
    8000141e:	9956                	add	s2,s2,s5
    80001420:	0329e663          	bltu	s3,s2,8000144c <uvmunmap+0x84>
    if ((pte = walk(pagetable, a, 0)) == 0) {
    80001424:	4601                	li	a2,0
    80001426:	85ca                	mv	a1,s2
    80001428:	8552                	mv	a0,s4
    8000142a:	00000097          	auipc	ra,0x0
    8000142e:	c1e080e7          	jalr	-994(ra) # 80001048 <walk>
    80001432:	84aa                	mv	s1,a0
    80001434:	d56d                	beqz	a0,8000141e <uvmunmap+0x56>
    if (((*pte & PTE_V) == 0)) {
    80001436:	611c                	ld	a5,0(a0)
    80001438:	0017f713          	andi	a4,a5,1
    8000143c:	d36d                	beqz	a4,8000141e <uvmunmap+0x56>
    if (PTE_FLAGS(*pte) == PTE_V)
    8000143e:	3ff7f713          	andi	a4,a5,1023
    80001442:	fb770de3          	beq	a4,s7,800013fc <uvmunmap+0x34>
    if (do_free) {
    80001446:	fc0b0ae3          	beqz	s6,8000141a <uvmunmap+0x52>
    8000144a:	b7c9                	j	8000140c <uvmunmap+0x44>
}
    8000144c:	60a6                	ld	ra,72(sp)
    8000144e:	6406                	ld	s0,64(sp)
    80001450:	74e2                	ld	s1,56(sp)
    80001452:	7942                	ld	s2,48(sp)
    80001454:	79a2                	ld	s3,40(sp)
    80001456:	7a02                	ld	s4,32(sp)
    80001458:	6ae2                	ld	s5,24(sp)
    8000145a:	6b42                	ld	s6,16(sp)
    8000145c:	6ba2                	ld	s7,8(sp)
    8000145e:	6161                	addi	sp,sp,80
    80001460:	8082                	ret

0000000080001462 <uvmcreate>:
pagetable_t uvmcreate() {
    80001462:	1101                	addi	sp,sp,-32
    80001464:	ec06                	sd	ra,24(sp)
    80001466:	e822                	sd	s0,16(sp)
    80001468:	e426                	sd	s1,8(sp)
    8000146a:	1000                	addi	s0,sp,32
  pagetable = (pagetable_t)kalloc();
    8000146c:	fffff097          	auipc	ra,0xfffff
    80001470:	510080e7          	jalr	1296(ra) # 8000097c <kalloc>
  if (pagetable == 0)
    80001474:	cd11                	beqz	a0,80001490 <uvmcreate+0x2e>
    80001476:	84aa                	mv	s1,a0
  memset(pagetable, 0, PGSIZE);
    80001478:	6605                	lui	a2,0x1
    8000147a:	4581                	li	a1,0
    8000147c:	00000097          	auipc	ra,0x0
    80001480:	902080e7          	jalr	-1790(ra) # 80000d7e <memset>
}
    80001484:	8526                	mv	a0,s1
    80001486:	60e2                	ld	ra,24(sp)
    80001488:	6442                	ld	s0,16(sp)
    8000148a:	64a2                	ld	s1,8(sp)
    8000148c:	6105                	addi	sp,sp,32
    8000148e:	8082                	ret
    panic("uvmcreate: out of memory");
    80001490:	00007517          	auipc	a0,0x7
    80001494:	ec850513          	addi	a0,a0,-312 # 80008358 <userret+0x2c8>
    80001498:	fffff097          	auipc	ra,0xfffff
    8000149c:	0c2080e7          	jalr	194(ra) # 8000055a <panic>

00000000800014a0 <uvminit>:
void uvminit(pagetable_t pagetable, uchar *src, uint sz) {
    800014a0:	7179                	addi	sp,sp,-48
    800014a2:	f406                	sd	ra,40(sp)
    800014a4:	f022                	sd	s0,32(sp)
    800014a6:	ec26                	sd	s1,24(sp)
    800014a8:	e84a                	sd	s2,16(sp)
    800014aa:	e44e                	sd	s3,8(sp)
    800014ac:	e052                	sd	s4,0(sp)
    800014ae:	1800                	addi	s0,sp,48
  if (sz >= PGSIZE)
    800014b0:	6785                	lui	a5,0x1
    800014b2:	04f67863          	bgeu	a2,a5,80001502 <uvminit+0x62>
    800014b6:	8a2a                	mv	s4,a0
    800014b8:	89ae                	mv	s3,a1
    800014ba:	84b2                	mv	s1,a2
  mem = kalloc();
    800014bc:	fffff097          	auipc	ra,0xfffff
    800014c0:	4c0080e7          	jalr	1216(ra) # 8000097c <kalloc>
    800014c4:	892a                	mv	s2,a0
  memset(mem, 0, PGSIZE);
    800014c6:	6605                	lui	a2,0x1
    800014c8:	4581                	li	a1,0
    800014ca:	00000097          	auipc	ra,0x0
    800014ce:	8b4080e7          	jalr	-1868(ra) # 80000d7e <memset>
  mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    800014d2:	4779                	li	a4,30
    800014d4:	86ca                	mv	a3,s2
    800014d6:	6605                	lui	a2,0x1
    800014d8:	4581                	li	a1,0
    800014da:	8552                	mv	a0,s4
    800014dc:	00000097          	auipc	ra,0x0
    800014e0:	d40080e7          	jalr	-704(ra) # 8000121c <mappages>
  memmove(mem, src, sz);
    800014e4:	8626                	mv	a2,s1
    800014e6:	85ce                	mv	a1,s3
    800014e8:	854a                	mv	a0,s2
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	8f4080e7          	jalr	-1804(ra) # 80000dde <memmove>
}
    800014f2:	70a2                	ld	ra,40(sp)
    800014f4:	7402                	ld	s0,32(sp)
    800014f6:	64e2                	ld	s1,24(sp)
    800014f8:	6942                	ld	s2,16(sp)
    800014fa:	69a2                	ld	s3,8(sp)
    800014fc:	6a02                	ld	s4,0(sp)
    800014fe:	6145                	addi	sp,sp,48
    80001500:	8082                	ret
    panic("inituvm: more than a page");
    80001502:	00007517          	auipc	a0,0x7
    80001506:	e7650513          	addi	a0,a0,-394 # 80008378 <userret+0x2e8>
    8000150a:	fffff097          	auipc	ra,0xfffff
    8000150e:	050080e7          	jalr	80(ra) # 8000055a <panic>

0000000080001512 <uvmdealloc>:
uint64 uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    80001512:	1101                	addi	sp,sp,-32
    80001514:	ec06                	sd	ra,24(sp)
    80001516:	e822                	sd	s0,16(sp)
    80001518:	e426                	sd	s1,8(sp)
    8000151a:	1000                	addi	s0,sp,32
    return oldsz;
    8000151c:	84ae                	mv	s1,a1
  if (newsz >= oldsz)
    8000151e:	00b67d63          	bgeu	a2,a1,80001538 <uvmdealloc+0x26>
    80001522:	84b2                	mv	s1,a2
  uint64 newup = PGROUNDUP(newsz);
    80001524:	6785                	lui	a5,0x1
    80001526:	17fd                	addi	a5,a5,-1
    80001528:	00f60733          	add	a4,a2,a5
    8000152c:	76fd                	lui	a3,0xfffff
    8000152e:	8f75                	and	a4,a4,a3
  if (newup < PGROUNDUP(oldsz))
    80001530:	97ae                	add	a5,a5,a1
    80001532:	8ff5                	and	a5,a5,a3
    80001534:	00f76863          	bltu	a4,a5,80001544 <uvmdealloc+0x32>
}
    80001538:	8526                	mv	a0,s1
    8000153a:	60e2                	ld	ra,24(sp)
    8000153c:	6442                	ld	s0,16(sp)
    8000153e:	64a2                	ld	s1,8(sp)
    80001540:	6105                	addi	sp,sp,32
    80001542:	8082                	ret
    uvmunmap(pagetable, newup, oldsz - newup, 1);
    80001544:	4685                	li	a3,1
    80001546:	40e58633          	sub	a2,a1,a4
    8000154a:	85ba                	mv	a1,a4
    8000154c:	00000097          	auipc	ra,0x0
    80001550:	e7c080e7          	jalr	-388(ra) # 800013c8 <uvmunmap>
    80001554:	b7d5                	j	80001538 <uvmdealloc+0x26>

0000000080001556 <uvmalloc>:
  if (newsz < oldsz)
    80001556:	0ab66163          	bltu	a2,a1,800015f8 <uvmalloc+0xa2>
uint64 uvmalloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz) {
    8000155a:	7139                	addi	sp,sp,-64
    8000155c:	fc06                	sd	ra,56(sp)
    8000155e:	f822                	sd	s0,48(sp)
    80001560:	f426                	sd	s1,40(sp)
    80001562:	f04a                	sd	s2,32(sp)
    80001564:	ec4e                	sd	s3,24(sp)
    80001566:	e852                	sd	s4,16(sp)
    80001568:	e456                	sd	s5,8(sp)
    8000156a:	0080                	addi	s0,sp,64
    8000156c:	8aaa                	mv	s5,a0
    8000156e:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80001570:	6985                	lui	s3,0x1
    80001572:	19fd                	addi	s3,s3,-1
    80001574:	95ce                	add	a1,a1,s3
    80001576:	79fd                	lui	s3,0xfffff
    80001578:	0135f9b3          	and	s3,a1,s3
  for (; a < newsz; a += PGSIZE) {
    8000157c:	08c9f063          	bgeu	s3,a2,800015fc <uvmalloc+0xa6>
  a = oldsz;
    80001580:	894e                	mv	s2,s3
    mem = kalloc();
    80001582:	fffff097          	auipc	ra,0xfffff
    80001586:	3fa080e7          	jalr	1018(ra) # 8000097c <kalloc>
    8000158a:	84aa                	mv	s1,a0
    if (mem == 0) {
    8000158c:	c51d                	beqz	a0,800015ba <uvmalloc+0x64>
    memset(mem, 0, PGSIZE);
    8000158e:	6605                	lui	a2,0x1
    80001590:	4581                	li	a1,0
    80001592:	fffff097          	auipc	ra,0xfffff
    80001596:	7ec080e7          	jalr	2028(ra) # 80000d7e <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem,
    8000159a:	4779                	li	a4,30
    8000159c:	86a6                	mv	a3,s1
    8000159e:	6605                	lui	a2,0x1
    800015a0:	85ca                	mv	a1,s2
    800015a2:	8556                	mv	a0,s5
    800015a4:	00000097          	auipc	ra,0x0
    800015a8:	c78080e7          	jalr	-904(ra) # 8000121c <mappages>
    800015ac:	e905                	bnez	a0,800015dc <uvmalloc+0x86>
  for (; a < newsz; a += PGSIZE) {
    800015ae:	6785                	lui	a5,0x1
    800015b0:	993e                	add	s2,s2,a5
    800015b2:	fd4968e3          	bltu	s2,s4,80001582 <uvmalloc+0x2c>
  return newsz;
    800015b6:	8552                	mv	a0,s4
    800015b8:	a809                	j	800015ca <uvmalloc+0x74>
      uvmdealloc(pagetable, a, oldsz);
    800015ba:	864e                	mv	a2,s3
    800015bc:	85ca                	mv	a1,s2
    800015be:	8556                	mv	a0,s5
    800015c0:	00000097          	auipc	ra,0x0
    800015c4:	f52080e7          	jalr	-174(ra) # 80001512 <uvmdealloc>
      return 0;
    800015c8:	4501                	li	a0,0
}
    800015ca:	70e2                	ld	ra,56(sp)
    800015cc:	7442                	ld	s0,48(sp)
    800015ce:	74a2                	ld	s1,40(sp)
    800015d0:	7902                	ld	s2,32(sp)
    800015d2:	69e2                	ld	s3,24(sp)
    800015d4:	6a42                	ld	s4,16(sp)
    800015d6:	6aa2                	ld	s5,8(sp)
    800015d8:	6121                	addi	sp,sp,64
    800015da:	8082                	ret
      kfree(mem);
    800015dc:	8526                	mv	a0,s1
    800015de:	fffff097          	auipc	ra,0xfffff
    800015e2:	2a2080e7          	jalr	674(ra) # 80000880 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800015e6:	864e                	mv	a2,s3
    800015e8:	85ca                	mv	a1,s2
    800015ea:	8556                	mv	a0,s5
    800015ec:	00000097          	auipc	ra,0x0
    800015f0:	f26080e7          	jalr	-218(ra) # 80001512 <uvmdealloc>
      return 0;
    800015f4:	4501                	li	a0,0
    800015f6:	bfd1                	j	800015ca <uvmalloc+0x74>
    return oldsz;
    800015f8:	852e                	mv	a0,a1
}
    800015fa:	8082                	ret
  return newsz;
    800015fc:	8532                	mv	a0,a2
    800015fe:	b7f1                	j	800015ca <uvmalloc+0x74>

0000000080001600 <print>:
void vmprint(pagetable_t pagetable) {
  printf("page table %p\n", pagetable);
  print(pagetable, 1);
}

void print(pagetable_t pagetable, int level) {
    80001600:	7159                	addi	sp,sp,-112
    80001602:	f486                	sd	ra,104(sp)
    80001604:	f0a2                	sd	s0,96(sp)
    80001606:	eca6                	sd	s1,88(sp)
    80001608:	e8ca                	sd	s2,80(sp)
    8000160a:	e4ce                	sd	s3,72(sp)
    8000160c:	e0d2                	sd	s4,64(sp)
    8000160e:	fc56                	sd	s5,56(sp)
    80001610:	f85a                	sd	s6,48(sp)
    80001612:	f45e                	sd	s7,40(sp)
    80001614:	f062                	sd	s8,32(sp)
    80001616:	ec66                	sd	s9,24(sp)
    80001618:	e86a                	sd	s10,16(sp)
    8000161a:	e46e                	sd	s11,8(sp)
    8000161c:	1880                	addi	s0,sp,112
    8000161e:	84ae                	mv	s1,a1
  for (int i = 0; i < 512; i++) {
    80001620:	8b2a                	mv	s6,a0
    80001622:	4a01                	li	s4,0
    pte_t pte = pagetable[i];
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001624:	4c05                	li	s8,1
      print((pagetable_t)child, level + 1);
    } else if (pte & PTE_V) {
      for (int j = 0; j < level; j++) {
        printf(".. ", level);
      }
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    80001626:	00007d17          	auipc	s10,0x7
    8000162a:	d7ad0d13          	addi	s10,s10,-646 # 800083a0 <userret+0x310>
        printf(".. ", level);
    8000162e:	00007a97          	auipc	s5,0x7
    80001632:	d6aa8a93          	addi	s5,s5,-662 # 80008398 <userret+0x308>
      print((pagetable_t)child, level + 1);
    80001636:	00158d9b          	addiw	s11,a1,1
  for (int i = 0; i < 512; i++) {
    8000163a:	20000b93          	li	s7,512
    8000163e:	a8a9                	j	80001698 <print+0x98>
      uint64 child = PTE2PA(pte);
    80001640:	00a9dc93          	srli	s9,s3,0xa
    80001644:	0cb2                	slli	s9,s9,0xc
      for (int j = 0; j < level; j++) {
    80001646:	00905c63          	blez	s1,8000165e <print+0x5e>
    8000164a:	4901                	li	s2,0
        printf(".. ", level);
    8000164c:	85a6                	mv	a1,s1
    8000164e:	8556                	mv	a0,s5
    80001650:	fffff097          	auipc	ra,0xfffff
    80001654:	f64080e7          	jalr	-156(ra) # 800005b4 <printf>
      for (int j = 0; j < level; j++) {
    80001658:	2905                	addiw	s2,s2,1
    8000165a:	ff2499e3          	bne	s1,s2,8000164c <print+0x4c>
      printf("%d: pte %p pa %p\n", i, pte, child);
    8000165e:	86e6                	mv	a3,s9
    80001660:	864e                	mv	a2,s3
    80001662:	85d2                	mv	a1,s4
    80001664:	856a                	mv	a0,s10
    80001666:	fffff097          	auipc	ra,0xfffff
    8000166a:	f4e080e7          	jalr	-178(ra) # 800005b4 <printf>
      print((pagetable_t)child, level + 1);
    8000166e:	85ee                	mv	a1,s11
    80001670:	8566                	mv	a0,s9
    80001672:	00000097          	auipc	ra,0x0
    80001676:	f8e080e7          	jalr	-114(ra) # 80001600 <print>
    8000167a:	a819                	j	80001690 <print+0x90>
      printf("%d: pte %p pa %p\n", i, pte, PTE2PA(pte));
    8000167c:	00a9d693          	srli	a3,s3,0xa
    80001680:	06b2                	slli	a3,a3,0xc
    80001682:	864e                	mv	a2,s3
    80001684:	85d2                	mv	a1,s4
    80001686:	856a                	mv	a0,s10
    80001688:	fffff097          	auipc	ra,0xfffff
    8000168c:	f2c080e7          	jalr	-212(ra) # 800005b4 <printf>
  for (int i = 0; i < 512; i++) {
    80001690:	2a05                	addiw	s4,s4,1
    80001692:	0b21                	addi	s6,s6,8
    80001694:	037a0863          	beq	s4,s7,800016c4 <print+0xc4>
    pte_t pte = pagetable[i];
    80001698:	000b3983          	ld	s3,0(s6)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000169c:	00f9f793          	andi	a5,s3,15
    800016a0:	fb8780e3          	beq	a5,s8,80001640 <print+0x40>
    } else if (pte & PTE_V) {
    800016a4:	0019f793          	andi	a5,s3,1
    800016a8:	d7e5                	beqz	a5,80001690 <print+0x90>
      for (int j = 0; j < level; j++) {
    800016aa:	fc9059e3          	blez	s1,8000167c <print+0x7c>
    800016ae:	4901                	li	s2,0
        printf(".. ", level);
    800016b0:	85a6                	mv	a1,s1
    800016b2:	8556                	mv	a0,s5
    800016b4:	fffff097          	auipc	ra,0xfffff
    800016b8:	f00080e7          	jalr	-256(ra) # 800005b4 <printf>
      for (int j = 0; j < level; j++) {
    800016bc:	2905                	addiw	s2,s2,1
    800016be:	ff2499e3          	bne	s1,s2,800016b0 <print+0xb0>
    800016c2:	bf6d                	j	8000167c <print+0x7c>
    }
  }
}
    800016c4:	70a6                	ld	ra,104(sp)
    800016c6:	7406                	ld	s0,96(sp)
    800016c8:	64e6                	ld	s1,88(sp)
    800016ca:	6946                	ld	s2,80(sp)
    800016cc:	69a6                	ld	s3,72(sp)
    800016ce:	6a06                	ld	s4,64(sp)
    800016d0:	7ae2                	ld	s5,56(sp)
    800016d2:	7b42                	ld	s6,48(sp)
    800016d4:	7ba2                	ld	s7,40(sp)
    800016d6:	7c02                	ld	s8,32(sp)
    800016d8:	6ce2                	ld	s9,24(sp)
    800016da:	6d42                	ld	s10,16(sp)
    800016dc:	6da2                	ld	s11,8(sp)
    800016de:	6165                	addi	sp,sp,112
    800016e0:	8082                	ret

00000000800016e2 <vmprint>:
void vmprint(pagetable_t pagetable) {
    800016e2:	1101                	addi	sp,sp,-32
    800016e4:	ec06                	sd	ra,24(sp)
    800016e6:	e822                	sd	s0,16(sp)
    800016e8:	e426                	sd	s1,8(sp)
    800016ea:	1000                	addi	s0,sp,32
    800016ec:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    800016ee:	85aa                	mv	a1,a0
    800016f0:	00007517          	auipc	a0,0x7
    800016f4:	cc850513          	addi	a0,a0,-824 # 800083b8 <userret+0x328>
    800016f8:	fffff097          	auipc	ra,0xfffff
    800016fc:	ebc080e7          	jalr	-324(ra) # 800005b4 <printf>
  print(pagetable, 1);
    80001700:	4585                	li	a1,1
    80001702:	8526                	mv	a0,s1
    80001704:	00000097          	auipc	ra,0x0
    80001708:	efc080e7          	jalr	-260(ra) # 80001600 <print>
}
    8000170c:	60e2                	ld	ra,24(sp)
    8000170e:	6442                	ld	s0,16(sp)
    80001710:	64a2                	ld	s1,8(sp)
    80001712:	6105                	addi	sp,sp,32
    80001714:	8082                	ret

0000000080001716 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz) {
    80001716:	1101                	addi	sp,sp,-32
    80001718:	ec06                	sd	ra,24(sp)
    8000171a:	e822                	sd	s0,16(sp)
    8000171c:	e426                	sd	s1,8(sp)
    8000171e:	1000                	addi	s0,sp,32
    80001720:	84aa                	mv	s1,a0
    80001722:	862e                	mv	a2,a1
  uvmunmap(pagetable, 0, sz, 1);
    80001724:	4685                	li	a3,1
    80001726:	4581                	li	a1,0
    80001728:	00000097          	auipc	ra,0x0
    8000172c:	ca0080e7          	jalr	-864(ra) # 800013c8 <uvmunmap>
  freewalk(pagetable);
    80001730:	8526                	mv	a0,s1
    80001732:	00000097          	auipc	ra,0x0
    80001736:	9bc080e7          	jalr	-1604(ra) # 800010ee <freewalk>
}
    8000173a:	60e2                	ld	ra,24(sp)
    8000173c:	6442                	ld	s0,16(sp)
    8000173e:	64a2                	ld	s1,8(sp)
    80001740:	6105                	addi	sp,sp,32
    80001742:	8082                	ret

0000000080001744 <uvmcopy>:
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;
  for (i = 0; i < sz; i += PGSIZE) {
    80001744:	ca45                	beqz	a2,800017f4 <uvmcopy+0xb0>
int uvmcopy(pagetable_t old, pagetable_t new, uint64 sz) {
    80001746:	715d                	addi	sp,sp,-80
    80001748:	e486                	sd	ra,72(sp)
    8000174a:	e0a2                	sd	s0,64(sp)
    8000174c:	fc26                	sd	s1,56(sp)
    8000174e:	f84a                	sd	s2,48(sp)
    80001750:	f44e                	sd	s3,40(sp)
    80001752:	f052                	sd	s4,32(sp)
    80001754:	ec56                	sd	s5,24(sp)
    80001756:	e85a                	sd	s6,16(sp)
    80001758:	e45e                	sd	s7,8(sp)
    8000175a:	0880                	addi	s0,sp,80
    8000175c:	8aaa                	mv	s5,a0
    8000175e:	8b2e                	mv	s6,a1
    80001760:	8a32                	mv	s4,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001762:	4481                	li	s1,0
    80001764:	a029                	j	8000176e <uvmcopy+0x2a>
    80001766:	6785                	lui	a5,0x1
    80001768:	94be                	add	s1,s1,a5
    8000176a:	0744f963          	bgeu	s1,s4,800017dc <uvmcopy+0x98>
    if ((pte = walk(old, i, 0)) == 0) {
    8000176e:	4601                	li	a2,0
    80001770:	85a6                	mv	a1,s1
    80001772:	8556                	mv	a0,s5
    80001774:	00000097          	auipc	ra,0x0
    80001778:	8d4080e7          	jalr	-1836(ra) # 80001048 <walk>
    8000177c:	d56d                	beqz	a0,80001766 <uvmcopy+0x22>
      continue;
      // panic("uvmcopy: pte should exist");
    }
    if ((*pte & PTE_V) == 0) {
    8000177e:	6118                	ld	a4,0(a0)
    80001780:	00177793          	andi	a5,a4,1
    80001784:	d3ed                	beqz	a5,80001766 <uvmcopy+0x22>
      // page not yet allocated
      continue;
    }
    pa = PTE2PA(*pte);
    80001786:	00a75593          	srli	a1,a4,0xa
    8000178a:	00c59b93          	slli	s7,a1,0xc
    flags = PTE_FLAGS(*pte);
    8000178e:	3ff77913          	andi	s2,a4,1023
    if ((mem = kalloc()) == 0)
    80001792:	fffff097          	auipc	ra,0xfffff
    80001796:	1ea080e7          	jalr	490(ra) # 8000097c <kalloc>
    8000179a:	89aa                	mv	s3,a0
    8000179c:	c515                	beqz	a0,800017c8 <uvmcopy+0x84>
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    8000179e:	6605                	lui	a2,0x1
    800017a0:	85de                	mv	a1,s7
    800017a2:	fffff097          	auipc	ra,0xfffff
    800017a6:	63c080e7          	jalr	1596(ra) # 80000dde <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    800017aa:	874a                	mv	a4,s2
    800017ac:	86ce                	mv	a3,s3
    800017ae:	6605                	lui	a2,0x1
    800017b0:	85a6                	mv	a1,s1
    800017b2:	855a                	mv	a0,s6
    800017b4:	00000097          	auipc	ra,0x0
    800017b8:	a68080e7          	jalr	-1432(ra) # 8000121c <mappages>
    800017bc:	d54d                	beqz	a0,80001766 <uvmcopy+0x22>
      kfree(mem);
    800017be:	854e                	mv	a0,s3
    800017c0:	fffff097          	auipc	ra,0xfffff
    800017c4:	0c0080e7          	jalr	192(ra) # 80000880 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i, 1);
    800017c8:	4685                	li	a3,1
    800017ca:	8626                	mv	a2,s1
    800017cc:	4581                	li	a1,0
    800017ce:	855a                	mv	a0,s6
    800017d0:	00000097          	auipc	ra,0x0
    800017d4:	bf8080e7          	jalr	-1032(ra) # 800013c8 <uvmunmap>
  return -1;
    800017d8:	557d                	li	a0,-1
    800017da:	a011                	j	800017de <uvmcopy+0x9a>
  return 0;
    800017dc:	4501                	li	a0,0
}
    800017de:	60a6                	ld	ra,72(sp)
    800017e0:	6406                	ld	s0,64(sp)
    800017e2:	74e2                	ld	s1,56(sp)
    800017e4:	7942                	ld	s2,48(sp)
    800017e6:	79a2                	ld	s3,40(sp)
    800017e8:	7a02                	ld	s4,32(sp)
    800017ea:	6ae2                	ld	s5,24(sp)
    800017ec:	6b42                	ld	s6,16(sp)
    800017ee:	6ba2                	ld	s7,8(sp)
    800017f0:	6161                	addi	sp,sp,80
    800017f2:	8082                	ret
  return 0;
    800017f4:	4501                	li	a0,0
}
    800017f6:	8082                	ret

00000000800017f8 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va) {
    800017f8:	1141                	addi	sp,sp,-16
    800017fa:	e406                	sd	ra,8(sp)
    800017fc:	e022                	sd	s0,0(sp)
    800017fe:	0800                	addi	s0,sp,16
  pte_t *pte;
  pte = walk(pagetable, va, 0);
    80001800:	4601                	li	a2,0
    80001802:	00000097          	auipc	ra,0x0
    80001806:	846080e7          	jalr	-1978(ra) # 80001048 <walk>
  if (pte == 0)
    8000180a:	c901                	beqz	a0,8000181a <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000180c:	611c                	ld	a5,0(a0)
    8000180e:	9bbd                	andi	a5,a5,-17
    80001810:	e11c                	sd	a5,0(a0)
}
    80001812:	60a2                	ld	ra,8(sp)
    80001814:	6402                	ld	s0,0(sp)
    80001816:	0141                	addi	sp,sp,16
    80001818:	8082                	ret
    panic("uvmclear");
    8000181a:	00007517          	auipc	a0,0x7
    8000181e:	bae50513          	addi	a0,a0,-1106 # 800083c8 <userret+0x338>
    80001822:	fffff097          	auipc	ra,0xfffff
    80001826:	d38080e7          	jalr	-712(ra) # 8000055a <panic>

000000008000182a <copyout>:
// Copy len bytes from src to virtual address dstva in a given page table.
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    8000182a:	c6bd                	beqz	a3,80001898 <copyout+0x6e>
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len) {
    8000182c:	715d                	addi	sp,sp,-80
    8000182e:	e486                	sd	ra,72(sp)
    80001830:	e0a2                	sd	s0,64(sp)
    80001832:	fc26                	sd	s1,56(sp)
    80001834:	f84a                	sd	s2,48(sp)
    80001836:	f44e                	sd	s3,40(sp)
    80001838:	f052                	sd	s4,32(sp)
    8000183a:	ec56                	sd	s5,24(sp)
    8000183c:	e85a                	sd	s6,16(sp)
    8000183e:	e45e                	sd	s7,8(sp)
    80001840:	e062                	sd	s8,0(sp)
    80001842:	0880                	addi	s0,sp,80
    80001844:	8b2a                	mv	s6,a0
    80001846:	8c2e                	mv	s8,a1
    80001848:	8a32                	mv	s4,a2
    8000184a:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(dstva);
    8000184c:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (dstva - va0);
    8000184e:	6a85                	lui	s5,0x1
    80001850:	a015                	j	80001874 <copyout+0x4a>
    if (n > len)
      n = len;
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001852:	9562                	add	a0,a0,s8
    80001854:	0004861b          	sext.w	a2,s1
    80001858:	85d2                	mv	a1,s4
    8000185a:	41250533          	sub	a0,a0,s2
    8000185e:	fffff097          	auipc	ra,0xfffff
    80001862:	580080e7          	jalr	1408(ra) # 80000dde <memmove>

    len -= n;
    80001866:	409989b3          	sub	s3,s3,s1
    src += n;
    8000186a:	9a26                	add	s4,s4,s1
    dstva = va0 + PGSIZE;
    8000186c:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    80001870:	02098263          	beqz	s3,80001894 <copyout+0x6a>
    va0 = PGROUNDDOWN(dstva);
    80001874:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001878:	85ca                	mv	a1,s2
    8000187a:	855a                	mv	a0,s6
    8000187c:	00000097          	auipc	ra,0x0
    80001880:	900080e7          	jalr	-1792(ra) # 8000117c <walkaddr>
    if (pa0 == 0)
    80001884:	cd01                	beqz	a0,8000189c <copyout+0x72>
    n = PGSIZE - (dstva - va0);
    80001886:	418904b3          	sub	s1,s2,s8
    8000188a:	94d6                	add	s1,s1,s5
    if (n > len)
    8000188c:	fc99f3e3          	bgeu	s3,s1,80001852 <copyout+0x28>
    80001890:	84ce                	mv	s1,s3
    80001892:	b7c1                	j	80001852 <copyout+0x28>
  }
  return 0;
    80001894:	4501                	li	a0,0
    80001896:	a021                	j	8000189e <copyout+0x74>
    80001898:	4501                	li	a0,0
}
    8000189a:	8082                	ret
      return -1;
    8000189c:	557d                	li	a0,-1
}
    8000189e:	60a6                	ld	ra,72(sp)
    800018a0:	6406                	ld	s0,64(sp)
    800018a2:	74e2                	ld	s1,56(sp)
    800018a4:	7942                	ld	s2,48(sp)
    800018a6:	79a2                	ld	s3,40(sp)
    800018a8:	7a02                	ld	s4,32(sp)
    800018aa:	6ae2                	ld	s5,24(sp)
    800018ac:	6b42                	ld	s6,16(sp)
    800018ae:	6ba2                	ld	s7,8(sp)
    800018b0:	6c02                	ld	s8,0(sp)
    800018b2:	6161                	addi	sp,sp,80
    800018b4:	8082                	ret

00000000800018b6 <copyin>:
// Copy len bytes to dst from virtual address srcva in a given page table.
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
  uint64 n, va0, pa0;

  while (len > 0) {
    800018b6:	c6bd                	beqz	a3,80001924 <copyin+0x6e>
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len) {
    800018b8:	715d                	addi	sp,sp,-80
    800018ba:	e486                	sd	ra,72(sp)
    800018bc:	e0a2                	sd	s0,64(sp)
    800018be:	fc26                	sd	s1,56(sp)
    800018c0:	f84a                	sd	s2,48(sp)
    800018c2:	f44e                	sd	s3,40(sp)
    800018c4:	f052                	sd	s4,32(sp)
    800018c6:	ec56                	sd	s5,24(sp)
    800018c8:	e85a                	sd	s6,16(sp)
    800018ca:	e45e                	sd	s7,8(sp)
    800018cc:	e062                	sd	s8,0(sp)
    800018ce:	0880                	addi	s0,sp,80
    800018d0:	8b2a                	mv	s6,a0
    800018d2:	8a2e                	mv	s4,a1
    800018d4:	8c32                	mv	s8,a2
    800018d6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800018d8:	7bfd                	lui	s7,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800018da:	6a85                	lui	s5,0x1
    800018dc:	a015                	j	80001900 <copyin+0x4a>
    if (n > len)
      n = len;
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800018de:	9562                	add	a0,a0,s8
    800018e0:	0004861b          	sext.w	a2,s1
    800018e4:	412505b3          	sub	a1,a0,s2
    800018e8:	8552                	mv	a0,s4
    800018ea:	fffff097          	auipc	ra,0xfffff
    800018ee:	4f4080e7          	jalr	1268(ra) # 80000dde <memmove>

    len -= n;
    800018f2:	409989b3          	sub	s3,s3,s1
    dst += n;
    800018f6:	9a26                	add	s4,s4,s1
    srcva = va0 + PGSIZE;
    800018f8:	01590c33          	add	s8,s2,s5
  while (len > 0) {
    800018fc:	02098263          	beqz	s3,80001920 <copyin+0x6a>
    va0 = PGROUNDDOWN(srcva);
    80001900:	017c7933          	and	s2,s8,s7
    pa0 = walkaddr(pagetable, va0);
    80001904:	85ca                	mv	a1,s2
    80001906:	855a                	mv	a0,s6
    80001908:	00000097          	auipc	ra,0x0
    8000190c:	874080e7          	jalr	-1932(ra) # 8000117c <walkaddr>
    if (pa0 == 0)
    80001910:	cd01                	beqz	a0,80001928 <copyin+0x72>
    n = PGSIZE - (srcva - va0);
    80001912:	418904b3          	sub	s1,s2,s8
    80001916:	94d6                	add	s1,s1,s5
    if (n > len)
    80001918:	fc99f3e3          	bgeu	s3,s1,800018de <copyin+0x28>
    8000191c:	84ce                	mv	s1,s3
    8000191e:	b7c1                	j	800018de <copyin+0x28>
  }
  return 0;
    80001920:	4501                	li	a0,0
    80001922:	a021                	j	8000192a <copyin+0x74>
    80001924:	4501                	li	a0,0
}
    80001926:	8082                	ret
      return -1;
    80001928:	557d                	li	a0,-1
}
    8000192a:	60a6                	ld	ra,72(sp)
    8000192c:	6406                	ld	s0,64(sp)
    8000192e:	74e2                	ld	s1,56(sp)
    80001930:	7942                	ld	s2,48(sp)
    80001932:	79a2                	ld	s3,40(sp)
    80001934:	7a02                	ld	s4,32(sp)
    80001936:	6ae2                	ld	s5,24(sp)
    80001938:	6b42                	ld	s6,16(sp)
    8000193a:	6ba2                	ld	s7,8(sp)
    8000193c:	6c02                	ld	s8,0(sp)
    8000193e:	6161                	addi	sp,sp,80
    80001940:	8082                	ret

0000000080001942 <copyinstr>:
// Return 0 on success, -1 on error.
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    80001942:	c6c5                	beqz	a3,800019ea <copyinstr+0xa8>
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max) {
    80001944:	715d                	addi	sp,sp,-80
    80001946:	e486                	sd	ra,72(sp)
    80001948:	e0a2                	sd	s0,64(sp)
    8000194a:	fc26                	sd	s1,56(sp)
    8000194c:	f84a                	sd	s2,48(sp)
    8000194e:	f44e                	sd	s3,40(sp)
    80001950:	f052                	sd	s4,32(sp)
    80001952:	ec56                	sd	s5,24(sp)
    80001954:	e85a                	sd	s6,16(sp)
    80001956:	e45e                	sd	s7,8(sp)
    80001958:	0880                	addi	s0,sp,80
    8000195a:	8a2a                	mv	s4,a0
    8000195c:	8b2e                	mv	s6,a1
    8000195e:	8bb2                	mv	s7,a2
    80001960:	84b6                	mv	s1,a3
    va0 = PGROUNDDOWN(srcva);
    80001962:	7afd                	lui	s5,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80001964:	6985                	lui	s3,0x1
    80001966:	a035                	j	80001992 <copyinstr+0x50>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    80001968:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    8000196c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    8000196e:	0017b793          	seqz	a5,a5
    80001972:	40f00533          	neg	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80001976:	60a6                	ld	ra,72(sp)
    80001978:	6406                	ld	s0,64(sp)
    8000197a:	74e2                	ld	s1,56(sp)
    8000197c:	7942                	ld	s2,48(sp)
    8000197e:	79a2                	ld	s3,40(sp)
    80001980:	7a02                	ld	s4,32(sp)
    80001982:	6ae2                	ld	s5,24(sp)
    80001984:	6b42                	ld	s6,16(sp)
    80001986:	6ba2                	ld	s7,8(sp)
    80001988:	6161                	addi	sp,sp,80
    8000198a:	8082                	ret
    srcva = va0 + PGSIZE;
    8000198c:	01390bb3          	add	s7,s2,s3
  while (got_null == 0 && max > 0) {
    80001990:	c8a9                	beqz	s1,800019e2 <copyinstr+0xa0>
    va0 = PGROUNDDOWN(srcva);
    80001992:	015bf933          	and	s2,s7,s5
    pa0 = walkaddr(pagetable, va0);
    80001996:	85ca                	mv	a1,s2
    80001998:	8552                	mv	a0,s4
    8000199a:	fffff097          	auipc	ra,0xfffff
    8000199e:	7e2080e7          	jalr	2018(ra) # 8000117c <walkaddr>
    if (pa0 == 0)
    800019a2:	c131                	beqz	a0,800019e6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800019a4:	41790833          	sub	a6,s2,s7
    800019a8:	984e                	add	a6,a6,s3
    if (n > max)
    800019aa:	0104f363          	bgeu	s1,a6,800019b0 <copyinstr+0x6e>
    800019ae:	8826                	mv	a6,s1
    char *p = (char *)(pa0 + (srcva - va0));
    800019b0:	955e                	add	a0,a0,s7
    800019b2:	41250533          	sub	a0,a0,s2
    while (n > 0) {
    800019b6:	fc080be3          	beqz	a6,8000198c <copyinstr+0x4a>
    800019ba:	985a                	add	a6,a6,s6
    800019bc:	87da                	mv	a5,s6
      if (*p == '\0') {
    800019be:	41650633          	sub	a2,a0,s6
    800019c2:	14fd                	addi	s1,s1,-1
    800019c4:	9b26                	add	s6,s6,s1
    800019c6:	00f60733          	add	a4,a2,a5
    800019ca:	00074703          	lbu	a4,0(a4) # fffffffffffff000 <end+0xffffffff7ffd6fa4>
    800019ce:	df49                	beqz	a4,80001968 <copyinstr+0x26>
        *dst = *p;
    800019d0:	00e78023          	sb	a4,0(a5)
      --max;
    800019d4:	40fb04b3          	sub	s1,s6,a5
      dst++;
    800019d8:	0785                	addi	a5,a5,1
    while (n > 0) {
    800019da:	ff0796e3          	bne	a5,a6,800019c6 <copyinstr+0x84>
      dst++;
    800019de:	8b42                	mv	s6,a6
    800019e0:	b775                	j	8000198c <copyinstr+0x4a>
    800019e2:	4781                	li	a5,0
    800019e4:	b769                	j	8000196e <copyinstr+0x2c>
      return -1;
    800019e6:	557d                	li	a0,-1
    800019e8:	b779                	j	80001976 <copyinstr+0x34>
  int got_null = 0;
    800019ea:	4781                	li	a5,0
  if (got_null) {
    800019ec:	0017b793          	seqz	a5,a5
    800019f0:	40f00533          	neg	a0,a5
}
    800019f4:	8082                	ret

00000000800019f6 <wakeup1>:

// Wake up p if it is sleeping in wait(); used by exit().
// Caller must hold p->lock.
static void
wakeup1(struct proc *p)
{
    800019f6:	1101                	addi	sp,sp,-32
    800019f8:	ec06                	sd	ra,24(sp)
    800019fa:	e822                	sd	s0,16(sp)
    800019fc:	e426                	sd	s1,8(sp)
    800019fe:	1000                	addi	s0,sp,32
    80001a00:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001a02:	fffff097          	auipc	ra,0xfffff
    80001a06:	030080e7          	jalr	48(ra) # 80000a32 <holding>
    80001a0a:	c909                	beqz	a0,80001a1c <wakeup1+0x26>
    panic("wakeup1");
  if(p->chan == p && p->state == SLEEPING) {
    80001a0c:	789c                	ld	a5,48(s1)
    80001a0e:	00978f63          	beq	a5,s1,80001a2c <wakeup1+0x36>
    p->state = RUNNABLE;
  }
}
    80001a12:	60e2                	ld	ra,24(sp)
    80001a14:	6442                	ld	s0,16(sp)
    80001a16:	64a2                	ld	s1,8(sp)
    80001a18:	6105                	addi	sp,sp,32
    80001a1a:	8082                	ret
    panic("wakeup1");
    80001a1c:	00007517          	auipc	a0,0x7
    80001a20:	9bc50513          	addi	a0,a0,-1604 # 800083d8 <userret+0x348>
    80001a24:	fffff097          	auipc	ra,0xfffff
    80001a28:	b36080e7          	jalr	-1226(ra) # 8000055a <panic>
  if(p->chan == p && p->state == SLEEPING) {
    80001a2c:	5098                	lw	a4,32(s1)
    80001a2e:	4785                	li	a5,1
    80001a30:	fef711e3          	bne	a4,a5,80001a12 <wakeup1+0x1c>
    p->state = RUNNABLE;
    80001a34:	4789                	li	a5,2
    80001a36:	d09c                	sw	a5,32(s1)
}
    80001a38:	bfe9                	j	80001a12 <wakeup1+0x1c>

0000000080001a3a <procinit>:
{
    80001a3a:	715d                	addi	sp,sp,-80
    80001a3c:	e486                	sd	ra,72(sp)
    80001a3e:	e0a2                	sd	s0,64(sp)
    80001a40:	fc26                	sd	s1,56(sp)
    80001a42:	f84a                	sd	s2,48(sp)
    80001a44:	f44e                	sd	s3,40(sp)
    80001a46:	f052                	sd	s4,32(sp)
    80001a48:	ec56                	sd	s5,24(sp)
    80001a4a:	e85a                	sd	s6,16(sp)
    80001a4c:	e45e                	sd	s7,8(sp)
    80001a4e:	0880                	addi	s0,sp,80
  initlock(&pid_lock, "nextpid");
    80001a50:	00007597          	auipc	a1,0x7
    80001a54:	99058593          	addi	a1,a1,-1648 # 800083e0 <userret+0x350>
    80001a58:	00013517          	auipc	a0,0x13
    80001a5c:	de850513          	addi	a0,a0,-536 # 80014840 <pid_lock>
    80001a60:	fffff097          	auipc	ra,0xfffff
    80001a64:	f7c080e7          	jalr	-132(ra) # 800009dc <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a68:	00013917          	auipc	s2,0x13
    80001a6c:	1f890913          	addi	s2,s2,504 # 80014c60 <proc>
      initlock(&p->lock, "proc");
    80001a70:	00007a17          	auipc	s4,0x7
    80001a74:	978a0a13          	addi	s4,s4,-1672 # 800083e8 <userret+0x358>
      uint64 va = KSTACK((int) (p - proc));
    80001a78:	8bca                	mv	s7,s2
    80001a7a:	00007b17          	auipc	s6,0x7
    80001a7e:	47eb0b13          	addi	s6,s6,1150 # 80008ef8 <syscalls+0xb8>
    80001a82:	040009b7          	lui	s3,0x4000
    80001a86:	19fd                	addi	s3,s3,-1
    80001a88:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a8a:	00014a97          	auipc	s5,0x14
    80001a8e:	036a8a93          	addi	s5,s5,54 # 80015ac0 <tickslock>
      initlock(&p->lock, "proc");
    80001a92:	85d2                	mv	a1,s4
    80001a94:	854a                	mv	a0,s2
    80001a96:	fffff097          	auipc	ra,0xfffff
    80001a9a:	f46080e7          	jalr	-186(ra) # 800009dc <initlock>
      char *pa = kalloc();
    80001a9e:	fffff097          	auipc	ra,0xfffff
    80001aa2:	ede080e7          	jalr	-290(ra) # 8000097c <kalloc>
    80001aa6:	85aa                	mv	a1,a0
      if(pa == 0)
    80001aa8:	c929                	beqz	a0,80001afa <procinit+0xc0>
      uint64 va = KSTACK((int) (p - proc));
    80001aaa:	417904b3          	sub	s1,s2,s7
    80001aae:	8491                	srai	s1,s1,0x4
    80001ab0:	000b3783          	ld	a5,0(s6)
    80001ab4:	02f484b3          	mul	s1,s1,a5
    80001ab8:	2485                	addiw	s1,s1,1
    80001aba:	00d4949b          	slliw	s1,s1,0xd
    80001abe:	409984b3          	sub	s1,s3,s1
      kvmmap(va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001ac2:	4699                	li	a3,6
    80001ac4:	6605                	lui	a2,0x1
    80001ac6:	8526                	mv	a0,s1
    80001ac8:	fffff097          	auipc	ra,0xfffff
    80001acc:	7e2080e7          	jalr	2018(ra) # 800012aa <kvmmap>
      p->kstack = va;
    80001ad0:	04993423          	sd	s1,72(s2)
  for(p = proc; p < &proc[NPROC]; p++) {
    80001ad4:	17090913          	addi	s2,s2,368
    80001ad8:	fb591de3          	bne	s2,s5,80001a92 <procinit+0x58>
  kvminithart();
    80001adc:	fffff097          	auipc	ra,0xfffff
    80001ae0:	67c080e7          	jalr	1660(ra) # 80001158 <kvminithart>
}
    80001ae4:	60a6                	ld	ra,72(sp)
    80001ae6:	6406                	ld	s0,64(sp)
    80001ae8:	74e2                	ld	s1,56(sp)
    80001aea:	7942                	ld	s2,48(sp)
    80001aec:	79a2                	ld	s3,40(sp)
    80001aee:	7a02                	ld	s4,32(sp)
    80001af0:	6ae2                	ld	s5,24(sp)
    80001af2:	6b42                	ld	s6,16(sp)
    80001af4:	6ba2                	ld	s7,8(sp)
    80001af6:	6161                	addi	sp,sp,80
    80001af8:	8082                	ret
        panic("kalloc");
    80001afa:	00007517          	auipc	a0,0x7
    80001afe:	8f650513          	addi	a0,a0,-1802 # 800083f0 <userret+0x360>
    80001b02:	fffff097          	auipc	ra,0xfffff
    80001b06:	a58080e7          	jalr	-1448(ra) # 8000055a <panic>

0000000080001b0a <cpuid>:
{
    80001b0a:	1141                	addi	sp,sp,-16
    80001b0c:	e422                	sd	s0,8(sp)
    80001b0e:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b10:	8512                	mv	a0,tp
}
    80001b12:	2501                	sext.w	a0,a0
    80001b14:	6422                	ld	s0,8(sp)
    80001b16:	0141                	addi	sp,sp,16
    80001b18:	8082                	ret

0000000080001b1a <mycpu>:
mycpu(void) {
    80001b1a:	1141                	addi	sp,sp,-16
    80001b1c:	e422                	sd	s0,8(sp)
    80001b1e:	0800                	addi	s0,sp,16
    80001b20:	8792                	mv	a5,tp
  struct cpu *c = &cpus[id];
    80001b22:	2781                	sext.w	a5,a5
    80001b24:	079e                	slli	a5,a5,0x7
}
    80001b26:	00013517          	auipc	a0,0x13
    80001b2a:	d3a50513          	addi	a0,a0,-710 # 80014860 <cpus>
    80001b2e:	953e                	add	a0,a0,a5
    80001b30:	6422                	ld	s0,8(sp)
    80001b32:	0141                	addi	sp,sp,16
    80001b34:	8082                	ret

0000000080001b36 <myproc>:
myproc(void) {
    80001b36:	1101                	addi	sp,sp,-32
    80001b38:	ec06                	sd	ra,24(sp)
    80001b3a:	e822                	sd	s0,16(sp)
    80001b3c:	e426                	sd	s1,8(sp)
    80001b3e:	1000                	addi	s0,sp,32
  push_off();
    80001b40:	fffff097          	auipc	ra,0xfffff
    80001b44:	f20080e7          	jalr	-224(ra) # 80000a60 <push_off>
    80001b48:	8792                	mv	a5,tp
  struct proc *p = c->proc;
    80001b4a:	2781                	sext.w	a5,a5
    80001b4c:	079e                	slli	a5,a5,0x7
    80001b4e:	00013717          	auipc	a4,0x13
    80001b52:	cf270713          	addi	a4,a4,-782 # 80014840 <pid_lock>
    80001b56:	97ba                	add	a5,a5,a4
    80001b58:	7384                	ld	s1,32(a5)
  pop_off();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	fc6080e7          	jalr	-58(ra) # 80000b20 <pop_off>
}
    80001b62:	8526                	mv	a0,s1
    80001b64:	60e2                	ld	ra,24(sp)
    80001b66:	6442                	ld	s0,16(sp)
    80001b68:	64a2                	ld	s1,8(sp)
    80001b6a:	6105                	addi	sp,sp,32
    80001b6c:	8082                	ret

0000000080001b6e <forkret>:
{
    80001b6e:	1141                	addi	sp,sp,-16
    80001b70:	e406                	sd	ra,8(sp)
    80001b72:	e022                	sd	s0,0(sp)
    80001b74:	0800                	addi	s0,sp,16
  release(&myproc()->lock);
    80001b76:	00000097          	auipc	ra,0x0
    80001b7a:	fc0080e7          	jalr	-64(ra) # 80001b36 <myproc>
    80001b7e:	fffff097          	auipc	ra,0xfffff
    80001b82:	002080e7          	jalr	2(ra) # 80000b80 <release>
  if (first) {
    80001b86:	00007797          	auipc	a5,0x7
    80001b8a:	4ae7a783          	lw	a5,1198(a5) # 80009034 <first.1747>
    80001b8e:	eb89                	bnez	a5,80001ba0 <forkret+0x32>
  usertrapret();
    80001b90:	00001097          	auipc	ra,0x1
    80001b94:	c60080e7          	jalr	-928(ra) # 800027f0 <usertrapret>
}
    80001b98:	60a2                	ld	ra,8(sp)
    80001b9a:	6402                	ld	s0,0(sp)
    80001b9c:	0141                	addi	sp,sp,16
    80001b9e:	8082                	ret
    first = 0;
    80001ba0:	00007797          	auipc	a5,0x7
    80001ba4:	4807aa23          	sw	zero,1172(a5) # 80009034 <first.1747>
    fsinit(minor(ROOTDEV));
    80001ba8:	4501                	li	a0,0
    80001baa:	00002097          	auipc	ra,0x2
    80001bae:	a62080e7          	jalr	-1438(ra) # 8000360c <fsinit>
    80001bb2:	bff9                	j	80001b90 <forkret+0x22>

0000000080001bb4 <allocpid>:
allocpid() {
    80001bb4:	1101                	addi	sp,sp,-32
    80001bb6:	ec06                	sd	ra,24(sp)
    80001bb8:	e822                	sd	s0,16(sp)
    80001bba:	e426                	sd	s1,8(sp)
    80001bbc:	e04a                	sd	s2,0(sp)
    80001bbe:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001bc0:	00013917          	auipc	s2,0x13
    80001bc4:	c8090913          	addi	s2,s2,-896 # 80014840 <pid_lock>
    80001bc8:	854a                	mv	a0,s2
    80001bca:	fffff097          	auipc	ra,0xfffff
    80001bce:	ee6080e7          	jalr	-282(ra) # 80000ab0 <acquire>
  pid = nextpid;
    80001bd2:	00007797          	auipc	a5,0x7
    80001bd6:	46678793          	addi	a5,a5,1126 # 80009038 <nextpid>
    80001bda:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80001bdc:	0014871b          	addiw	a4,s1,1
    80001be0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001be2:	854a                	mv	a0,s2
    80001be4:	fffff097          	auipc	ra,0xfffff
    80001be8:	f9c080e7          	jalr	-100(ra) # 80000b80 <release>
}
    80001bec:	8526                	mv	a0,s1
    80001bee:	60e2                	ld	ra,24(sp)
    80001bf0:	6442                	ld	s0,16(sp)
    80001bf2:	64a2                	ld	s1,8(sp)
    80001bf4:	6902                	ld	s2,0(sp)
    80001bf6:	6105                	addi	sp,sp,32
    80001bf8:	8082                	ret

0000000080001bfa <proc_pagetable>:
{
    80001bfa:	1101                	addi	sp,sp,-32
    80001bfc:	ec06                	sd	ra,24(sp)
    80001bfe:	e822                	sd	s0,16(sp)
    80001c00:	e426                	sd	s1,8(sp)
    80001c02:	e04a                	sd	s2,0(sp)
    80001c04:	1000                	addi	s0,sp,32
    80001c06:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001c08:	00000097          	auipc	ra,0x0
    80001c0c:	85a080e7          	jalr	-1958(ra) # 80001462 <uvmcreate>
    80001c10:	84aa                	mv	s1,a0
  mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001c12:	4729                	li	a4,10
    80001c14:	00006697          	auipc	a3,0x6
    80001c18:	3ec68693          	addi	a3,a3,1004 # 80008000 <trampoline>
    80001c1c:	6605                	lui	a2,0x1
    80001c1e:	040005b7          	lui	a1,0x4000
    80001c22:	15fd                	addi	a1,a1,-1
    80001c24:	05b2                	slli	a1,a1,0xc
    80001c26:	fffff097          	auipc	ra,0xfffff
    80001c2a:	5f6080e7          	jalr	1526(ra) # 8000121c <mappages>
  mappages(pagetable, TRAPFRAME, PGSIZE,
    80001c2e:	4719                	li	a4,6
    80001c30:	06093683          	ld	a3,96(s2)
    80001c34:	6605                	lui	a2,0x1
    80001c36:	020005b7          	lui	a1,0x2000
    80001c3a:	15fd                	addi	a1,a1,-1
    80001c3c:	05b6                	slli	a1,a1,0xd
    80001c3e:	8526                	mv	a0,s1
    80001c40:	fffff097          	auipc	ra,0xfffff
    80001c44:	5dc080e7          	jalr	1500(ra) # 8000121c <mappages>
}
    80001c48:	8526                	mv	a0,s1
    80001c4a:	60e2                	ld	ra,24(sp)
    80001c4c:	6442                	ld	s0,16(sp)
    80001c4e:	64a2                	ld	s1,8(sp)
    80001c50:	6902                	ld	s2,0(sp)
    80001c52:	6105                	addi	sp,sp,32
    80001c54:	8082                	ret

0000000080001c56 <allocproc>:
{
    80001c56:	1101                	addi	sp,sp,-32
    80001c58:	ec06                	sd	ra,24(sp)
    80001c5a:	e822                	sd	s0,16(sp)
    80001c5c:	e426                	sd	s1,8(sp)
    80001c5e:	e04a                	sd	s2,0(sp)
    80001c60:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c62:	00013497          	auipc	s1,0x13
    80001c66:	ffe48493          	addi	s1,s1,-2 # 80014c60 <proc>
    80001c6a:	00014917          	auipc	s2,0x14
    80001c6e:	e5690913          	addi	s2,s2,-426 # 80015ac0 <tickslock>
    acquire(&p->lock);
    80001c72:	8526                	mv	a0,s1
    80001c74:	fffff097          	auipc	ra,0xfffff
    80001c78:	e3c080e7          	jalr	-452(ra) # 80000ab0 <acquire>
    if(p->state == UNUSED) {
    80001c7c:	509c                	lw	a5,32(s1)
    80001c7e:	c395                	beqz	a5,80001ca2 <allocproc+0x4c>
      release(&p->lock);
    80001c80:	8526                	mv	a0,s1
    80001c82:	fffff097          	auipc	ra,0xfffff
    80001c86:	efe080e7          	jalr	-258(ra) # 80000b80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001c8a:	17048493          	addi	s1,s1,368
    80001c8e:	ff2492e3          	bne	s1,s2,80001c72 <allocproc+0x1c>
  return 0;
    80001c92:	4481                	li	s1,0
}
    80001c94:	8526                	mv	a0,s1
    80001c96:	60e2                	ld	ra,24(sp)
    80001c98:	6442                	ld	s0,16(sp)
    80001c9a:	64a2                	ld	s1,8(sp)
    80001c9c:	6902                	ld	s2,0(sp)
    80001c9e:	6105                	addi	sp,sp,32
    80001ca0:	8082                	ret
  p->pid = allocpid();
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	f12080e7          	jalr	-238(ra) # 80001bb4 <allocpid>
    80001caa:	c0a8                	sw	a0,64(s1)
  if((p->tf = (struct trapframe *)kalloc()) == 0){
    80001cac:	fffff097          	auipc	ra,0xfffff
    80001cb0:	cd0080e7          	jalr	-816(ra) # 8000097c <kalloc>
    80001cb4:	892a                	mv	s2,a0
    80001cb6:	f0a8                	sd	a0,96(s1)
    80001cb8:	c915                	beqz	a0,80001cec <allocproc+0x96>
  p->pagetable = proc_pagetable(p);
    80001cba:	8526                	mv	a0,s1
    80001cbc:	00000097          	auipc	ra,0x0
    80001cc0:	f3e080e7          	jalr	-194(ra) # 80001bfa <proc_pagetable>
    80001cc4:	eca8                	sd	a0,88(s1)
  memset(&p->context, 0, sizeof p->context);
    80001cc6:	07000613          	li	a2,112
    80001cca:	4581                	li	a1,0
    80001ccc:	06848513          	addi	a0,s1,104
    80001cd0:	fffff097          	auipc	ra,0xfffff
    80001cd4:	0ae080e7          	jalr	174(ra) # 80000d7e <memset>
  p->context.ra = (uint64)forkret;
    80001cd8:	00000797          	auipc	a5,0x0
    80001cdc:	e9678793          	addi	a5,a5,-362 # 80001b6e <forkret>
    80001ce0:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001ce2:	64bc                	ld	a5,72(s1)
    80001ce4:	6705                	lui	a4,0x1
    80001ce6:	97ba                	add	a5,a5,a4
    80001ce8:	f8bc                	sd	a5,112(s1)
  return p;
    80001cea:	b76d                	j	80001c94 <allocproc+0x3e>
    release(&p->lock);
    80001cec:	8526                	mv	a0,s1
    80001cee:	fffff097          	auipc	ra,0xfffff
    80001cf2:	e92080e7          	jalr	-366(ra) # 80000b80 <release>
    return 0;
    80001cf6:	84ca                	mv	s1,s2
    80001cf8:	bf71                	j	80001c94 <allocproc+0x3e>

0000000080001cfa <proc_freepagetable>:
{
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	e04a                	sd	s2,0(sp)
    80001d04:	1000                	addi	s0,sp,32
    80001d06:	84aa                	mv	s1,a0
    80001d08:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, PGSIZE, 0);
    80001d0a:	4681                	li	a3,0
    80001d0c:	6605                	lui	a2,0x1
    80001d0e:	040005b7          	lui	a1,0x4000
    80001d12:	15fd                	addi	a1,a1,-1
    80001d14:	05b2                	slli	a1,a1,0xc
    80001d16:	fffff097          	auipc	ra,0xfffff
    80001d1a:	6b2080e7          	jalr	1714(ra) # 800013c8 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, PGSIZE, 0);
    80001d1e:	4681                	li	a3,0
    80001d20:	6605                	lui	a2,0x1
    80001d22:	020005b7          	lui	a1,0x2000
    80001d26:	15fd                	addi	a1,a1,-1
    80001d28:	05b6                	slli	a1,a1,0xd
    80001d2a:	8526                	mv	a0,s1
    80001d2c:	fffff097          	auipc	ra,0xfffff
    80001d30:	69c080e7          	jalr	1692(ra) # 800013c8 <uvmunmap>
  if(sz > 0)
    80001d34:	00091863          	bnez	s2,80001d44 <proc_freepagetable+0x4a>
}
    80001d38:	60e2                	ld	ra,24(sp)
    80001d3a:	6442                	ld	s0,16(sp)
    80001d3c:	64a2                	ld	s1,8(sp)
    80001d3e:	6902                	ld	s2,0(sp)
    80001d40:	6105                	addi	sp,sp,32
    80001d42:	8082                	ret
    uvmfree(pagetable, sz);
    80001d44:	85ca                	mv	a1,s2
    80001d46:	8526                	mv	a0,s1
    80001d48:	00000097          	auipc	ra,0x0
    80001d4c:	9ce080e7          	jalr	-1586(ra) # 80001716 <uvmfree>
}
    80001d50:	b7e5                	j	80001d38 <proc_freepagetable+0x3e>

0000000080001d52 <freeproc>:
{
    80001d52:	1101                	addi	sp,sp,-32
    80001d54:	ec06                	sd	ra,24(sp)
    80001d56:	e822                	sd	s0,16(sp)
    80001d58:	e426                	sd	s1,8(sp)
    80001d5a:	1000                	addi	s0,sp,32
    80001d5c:	84aa                	mv	s1,a0
  if(p->tf)
    80001d5e:	7128                	ld	a0,96(a0)
    80001d60:	c509                	beqz	a0,80001d6a <freeproc+0x18>
    kfree((void*)p->tf);
    80001d62:	fffff097          	auipc	ra,0xfffff
    80001d66:	b1e080e7          	jalr	-1250(ra) # 80000880 <kfree>
  p->tf = 0;
    80001d6a:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001d6e:	6ca8                	ld	a0,88(s1)
    80001d70:	c511                	beqz	a0,80001d7c <freeproc+0x2a>
    proc_freepagetable(p->pagetable, p->sz);
    80001d72:	68ac                	ld	a1,80(s1)
    80001d74:	00000097          	auipc	ra,0x0
    80001d78:	f86080e7          	jalr	-122(ra) # 80001cfa <proc_freepagetable>
  p->pagetable = 0;
    80001d7c:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    80001d80:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    80001d84:	0404a023          	sw	zero,64(s1)
  p->parent = 0;
    80001d88:	0204b423          	sd	zero,40(s1)
  p->name[0] = 0;
    80001d8c:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001d90:	0204b823          	sd	zero,48(s1)
  p->killed = 0;
    80001d94:	0204ac23          	sw	zero,56(s1)
  p->xstate = 0;
    80001d98:	0204ae23          	sw	zero,60(s1)
  p->state = UNUSED;
    80001d9c:	0204a023          	sw	zero,32(s1)
}
    80001da0:	60e2                	ld	ra,24(sp)
    80001da2:	6442                	ld	s0,16(sp)
    80001da4:	64a2                	ld	s1,8(sp)
    80001da6:	6105                	addi	sp,sp,32
    80001da8:	8082                	ret

0000000080001daa <userinit>:
{
    80001daa:	1101                	addi	sp,sp,-32
    80001dac:	ec06                	sd	ra,24(sp)
    80001dae:	e822                	sd	s0,16(sp)
    80001db0:	e426                	sd	s1,8(sp)
    80001db2:	1000                	addi	s0,sp,32
  p = allocproc();
    80001db4:	00000097          	auipc	ra,0x0
    80001db8:	ea2080e7          	jalr	-350(ra) # 80001c56 <allocproc>
    80001dbc:	84aa                	mv	s1,a0
  initproc = p;
    80001dbe:	00026797          	auipc	a5,0x26
    80001dc2:	26a7bd23          	sd	a0,634(a5) # 80028038 <initproc>
  uvminit(p->pagetable, initcode, sizeof(initcode));
    80001dc6:	03300613          	li	a2,51
    80001dca:	00007597          	auipc	a1,0x7
    80001dce:	23658593          	addi	a1,a1,566 # 80009000 <initcode>
    80001dd2:	6d28                	ld	a0,88(a0)
    80001dd4:	fffff097          	auipc	ra,0xfffff
    80001dd8:	6cc080e7          	jalr	1740(ra) # 800014a0 <uvminit>
  p->sz = PGSIZE;
    80001ddc:	6785                	lui	a5,0x1
    80001dde:	e8bc                	sd	a5,80(s1)
  p->tf->epc = 0;      // user program counter
    80001de0:	70b8                	ld	a4,96(s1)
    80001de2:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
  p->tf->sp = PGSIZE;  // user stack pointer
    80001de6:	70b8                	ld	a4,96(s1)
    80001de8:	fb1c                	sd	a5,48(a4)
  safestrcpy(p->name, "initcode", sizeof(p->name));
    80001dea:	4641                	li	a2,16
    80001dec:	00006597          	auipc	a1,0x6
    80001df0:	60c58593          	addi	a1,a1,1548 # 800083f8 <userret+0x368>
    80001df4:	16048513          	addi	a0,s1,352
    80001df8:	fffff097          	auipc	ra,0xfffff
    80001dfc:	0dc080e7          	jalr	220(ra) # 80000ed4 <safestrcpy>
  p->cwd = namei("/");
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	60850513          	addi	a0,a0,1544 # 80008408 <userret+0x378>
    80001e08:	00002097          	auipc	ra,0x2
    80001e0c:	206080e7          	jalr	518(ra) # 8000400e <namei>
    80001e10:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001e14:	4789                	li	a5,2
    80001e16:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    80001e18:	8526                	mv	a0,s1
    80001e1a:	fffff097          	auipc	ra,0xfffff
    80001e1e:	d66080e7          	jalr	-666(ra) # 80000b80 <release>
}
    80001e22:	60e2                	ld	ra,24(sp)
    80001e24:	6442                	ld	s0,16(sp)
    80001e26:	64a2                	ld	s1,8(sp)
    80001e28:	6105                	addi	sp,sp,32
    80001e2a:	8082                	ret

0000000080001e2c <growproc>:
{
    80001e2c:	1101                	addi	sp,sp,-32
    80001e2e:	ec06                	sd	ra,24(sp)
    80001e30:	e822                	sd	s0,16(sp)
    80001e32:	e426                	sd	s1,8(sp)
    80001e34:	e04a                	sd	s2,0(sp)
    80001e36:	1000                	addi	s0,sp,32
    80001e38:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e3a:	00000097          	auipc	ra,0x0
    80001e3e:	cfc080e7          	jalr	-772(ra) # 80001b36 <myproc>
    80001e42:	892a                	mv	s2,a0
  sz = p->sz;
    80001e44:	692c                	ld	a1,80(a0)
    80001e46:	0005861b          	sext.w	a2,a1
  if(n > 0){
    80001e4a:	00904f63          	bgtz	s1,80001e68 <growproc+0x3c>
  } else if(n < 0){
    80001e4e:	0204cc63          	bltz	s1,80001e86 <growproc+0x5a>
  p->sz = sz;
    80001e52:	1602                	slli	a2,a2,0x20
    80001e54:	9201                	srli	a2,a2,0x20
    80001e56:	04c93823          	sd	a2,80(s2)
  return 0;
    80001e5a:	4501                	li	a0,0
}
    80001e5c:	60e2                	ld	ra,24(sp)
    80001e5e:	6442                	ld	s0,16(sp)
    80001e60:	64a2                	ld	s1,8(sp)
    80001e62:	6902                	ld	s2,0(sp)
    80001e64:	6105                	addi	sp,sp,32
    80001e66:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n)) == 0) {
    80001e68:	9e25                	addw	a2,a2,s1
    80001e6a:	1602                	slli	a2,a2,0x20
    80001e6c:	9201                	srli	a2,a2,0x20
    80001e6e:	1582                	slli	a1,a1,0x20
    80001e70:	9181                	srli	a1,a1,0x20
    80001e72:	6d28                	ld	a0,88(a0)
    80001e74:	fffff097          	auipc	ra,0xfffff
    80001e78:	6e2080e7          	jalr	1762(ra) # 80001556 <uvmalloc>
    80001e7c:	0005061b          	sext.w	a2,a0
    80001e80:	fa69                	bnez	a2,80001e52 <growproc+0x26>
      return -1;
    80001e82:	557d                	li	a0,-1
    80001e84:	bfe1                	j	80001e5c <growproc+0x30>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001e86:	9e25                	addw	a2,a2,s1
    80001e88:	1602                	slli	a2,a2,0x20
    80001e8a:	9201                	srli	a2,a2,0x20
    80001e8c:	1582                	slli	a1,a1,0x20
    80001e8e:	9181                	srli	a1,a1,0x20
    80001e90:	6d28                	ld	a0,88(a0)
    80001e92:	fffff097          	auipc	ra,0xfffff
    80001e96:	680080e7          	jalr	1664(ra) # 80001512 <uvmdealloc>
    80001e9a:	0005061b          	sext.w	a2,a0
    80001e9e:	bf55                	j	80001e52 <growproc+0x26>

0000000080001ea0 <fork>:
{
    80001ea0:	7179                	addi	sp,sp,-48
    80001ea2:	f406                	sd	ra,40(sp)
    80001ea4:	f022                	sd	s0,32(sp)
    80001ea6:	ec26                	sd	s1,24(sp)
    80001ea8:	e84a                	sd	s2,16(sp)
    80001eaa:	e44e                	sd	s3,8(sp)
    80001eac:	e052                	sd	s4,0(sp)
    80001eae:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001eb0:	00000097          	auipc	ra,0x0
    80001eb4:	c86080e7          	jalr	-890(ra) # 80001b36 <myproc>
    80001eb8:	892a                	mv	s2,a0
  if((np = allocproc()) == 0){
    80001eba:	00000097          	auipc	ra,0x0
    80001ebe:	d9c080e7          	jalr	-612(ra) # 80001c56 <allocproc>
    80001ec2:	c175                	beqz	a0,80001fa6 <fork+0x106>
    80001ec4:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001ec6:	05093603          	ld	a2,80(s2)
    80001eca:	6d2c                	ld	a1,88(a0)
    80001ecc:	05893503          	ld	a0,88(s2)
    80001ed0:	00000097          	auipc	ra,0x0
    80001ed4:	874080e7          	jalr	-1932(ra) # 80001744 <uvmcopy>
    80001ed8:	04054863          	bltz	a0,80001f28 <fork+0x88>
  np->sz = p->sz;
    80001edc:	05093783          	ld	a5,80(s2)
    80001ee0:	04f9b823          	sd	a5,80(s3) # 4000050 <_entry-0x7bffffb0>
  np->parent = p;
    80001ee4:	0329b423          	sd	s2,40(s3)
  *(np->tf) = *(p->tf);
    80001ee8:	06093683          	ld	a3,96(s2)
    80001eec:	87b6                	mv	a5,a3
    80001eee:	0609b703          	ld	a4,96(s3)
    80001ef2:	12068693          	addi	a3,a3,288
    80001ef6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001efa:	6788                	ld	a0,8(a5)
    80001efc:	6b8c                	ld	a1,16(a5)
    80001efe:	6f90                	ld	a2,24(a5)
    80001f00:	01073023          	sd	a6,0(a4)
    80001f04:	e708                	sd	a0,8(a4)
    80001f06:	eb0c                	sd	a1,16(a4)
    80001f08:	ef10                	sd	a2,24(a4)
    80001f0a:	02078793          	addi	a5,a5,32
    80001f0e:	02070713          	addi	a4,a4,32
    80001f12:	fed792e3          	bne	a5,a3,80001ef6 <fork+0x56>
  np->tf->a0 = 0;
    80001f16:	0609b783          	ld	a5,96(s3)
    80001f1a:	0607b823          	sd	zero,112(a5)
    80001f1e:	0d800493          	li	s1,216
  for(i = 0; i < NOFILE; i++)
    80001f22:	15800a13          	li	s4,344
    80001f26:	a03d                	j	80001f54 <fork+0xb4>
    freeproc(np);
    80001f28:	854e                	mv	a0,s3
    80001f2a:	00000097          	auipc	ra,0x0
    80001f2e:	e28080e7          	jalr	-472(ra) # 80001d52 <freeproc>
    release(&np->lock);
    80001f32:	854e                	mv	a0,s3
    80001f34:	fffff097          	auipc	ra,0xfffff
    80001f38:	c4c080e7          	jalr	-948(ra) # 80000b80 <release>
    return -1;
    80001f3c:	54fd                	li	s1,-1
    80001f3e:	a899                	j	80001f94 <fork+0xf4>
      np->ofile[i] = filedup(p->ofile[i]);
    80001f40:	00003097          	auipc	ra,0x3
    80001f44:	870080e7          	jalr	-1936(ra) # 800047b0 <filedup>
    80001f48:	009987b3          	add	a5,s3,s1
    80001f4c:	e388                	sd	a0,0(a5)
  for(i = 0; i < NOFILE; i++)
    80001f4e:	04a1                	addi	s1,s1,8
    80001f50:	01448763          	beq	s1,s4,80001f5e <fork+0xbe>
    if(p->ofile[i])
    80001f54:	009907b3          	add	a5,s2,s1
    80001f58:	6388                	ld	a0,0(a5)
    80001f5a:	f17d                	bnez	a0,80001f40 <fork+0xa0>
    80001f5c:	bfcd                	j	80001f4e <fork+0xae>
  np->cwd = idup(p->cwd);
    80001f5e:	15893503          	ld	a0,344(s2)
    80001f62:	00002097          	auipc	ra,0x2
    80001f66:	8e4080e7          	jalr	-1820(ra) # 80003846 <idup>
    80001f6a:	14a9bc23          	sd	a0,344(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001f6e:	4641                	li	a2,16
    80001f70:	16090593          	addi	a1,s2,352
    80001f74:	16098513          	addi	a0,s3,352
    80001f78:	fffff097          	auipc	ra,0xfffff
    80001f7c:	f5c080e7          	jalr	-164(ra) # 80000ed4 <safestrcpy>
  pid = np->pid;
    80001f80:	0409a483          	lw	s1,64(s3)
  np->state = RUNNABLE;
    80001f84:	4789                	li	a5,2
    80001f86:	02f9a023          	sw	a5,32(s3)
  release(&np->lock);
    80001f8a:	854e                	mv	a0,s3
    80001f8c:	fffff097          	auipc	ra,0xfffff
    80001f90:	bf4080e7          	jalr	-1036(ra) # 80000b80 <release>
}
    80001f94:	8526                	mv	a0,s1
    80001f96:	70a2                	ld	ra,40(sp)
    80001f98:	7402                	ld	s0,32(sp)
    80001f9a:	64e2                	ld	s1,24(sp)
    80001f9c:	6942                	ld	s2,16(sp)
    80001f9e:	69a2                	ld	s3,8(sp)
    80001fa0:	6a02                	ld	s4,0(sp)
    80001fa2:	6145                	addi	sp,sp,48
    80001fa4:	8082                	ret
    return -1;
    80001fa6:	54fd                	li	s1,-1
    80001fa8:	b7f5                	j	80001f94 <fork+0xf4>

0000000080001faa <reparent>:
{
    80001faa:	7179                	addi	sp,sp,-48
    80001fac:	f406                	sd	ra,40(sp)
    80001fae:	f022                	sd	s0,32(sp)
    80001fb0:	ec26                	sd	s1,24(sp)
    80001fb2:	e84a                	sd	s2,16(sp)
    80001fb4:	e44e                	sd	s3,8(sp)
    80001fb6:	e052                	sd	s4,0(sp)
    80001fb8:	1800                	addi	s0,sp,48
    80001fba:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fbc:	00013497          	auipc	s1,0x13
    80001fc0:	ca448493          	addi	s1,s1,-860 # 80014c60 <proc>
      pp->parent = initproc;
    80001fc4:	00026a17          	auipc	s4,0x26
    80001fc8:	074a0a13          	addi	s4,s4,116 # 80028038 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001fcc:	00014997          	auipc	s3,0x14
    80001fd0:	af498993          	addi	s3,s3,-1292 # 80015ac0 <tickslock>
    80001fd4:	a029                	j	80001fde <reparent+0x34>
    80001fd6:	17048493          	addi	s1,s1,368
    80001fda:	03348363          	beq	s1,s3,80002000 <reparent+0x56>
    if(pp->parent == p){
    80001fde:	749c                	ld	a5,40(s1)
    80001fe0:	ff279be3          	bne	a5,s2,80001fd6 <reparent+0x2c>
      acquire(&pp->lock);
    80001fe4:	8526                	mv	a0,s1
    80001fe6:	fffff097          	auipc	ra,0xfffff
    80001fea:	aca080e7          	jalr	-1334(ra) # 80000ab0 <acquire>
      pp->parent = initproc;
    80001fee:	000a3783          	ld	a5,0(s4)
    80001ff2:	f49c                	sd	a5,40(s1)
      release(&pp->lock);
    80001ff4:	8526                	mv	a0,s1
    80001ff6:	fffff097          	auipc	ra,0xfffff
    80001ffa:	b8a080e7          	jalr	-1142(ra) # 80000b80 <release>
    80001ffe:	bfe1                	j	80001fd6 <reparent+0x2c>
}
    80002000:	70a2                	ld	ra,40(sp)
    80002002:	7402                	ld	s0,32(sp)
    80002004:	64e2                	ld	s1,24(sp)
    80002006:	6942                	ld	s2,16(sp)
    80002008:	69a2                	ld	s3,8(sp)
    8000200a:	6a02                	ld	s4,0(sp)
    8000200c:	6145                	addi	sp,sp,48
    8000200e:	8082                	ret

0000000080002010 <scheduler>:
{
    80002010:	715d                	addi	sp,sp,-80
    80002012:	e486                	sd	ra,72(sp)
    80002014:	e0a2                	sd	s0,64(sp)
    80002016:	fc26                	sd	s1,56(sp)
    80002018:	f84a                	sd	s2,48(sp)
    8000201a:	f44e                	sd	s3,40(sp)
    8000201c:	f052                	sd	s4,32(sp)
    8000201e:	ec56                	sd	s5,24(sp)
    80002020:	e85a                	sd	s6,16(sp)
    80002022:	e45e                	sd	s7,8(sp)
    80002024:	e062                	sd	s8,0(sp)
    80002026:	0880                	addi	s0,sp,80
    80002028:	8792                	mv	a5,tp
  int id = r_tp();
    8000202a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000202c:	00779b13          	slli	s6,a5,0x7
    80002030:	00013717          	auipc	a4,0x13
    80002034:	81070713          	addi	a4,a4,-2032 # 80014840 <pid_lock>
    80002038:	975a                	add	a4,a4,s6
    8000203a:	02073023          	sd	zero,32(a4)
        swtch(&c->scheduler, &p->context);
    8000203e:	00013717          	auipc	a4,0x13
    80002042:	82a70713          	addi	a4,a4,-2006 # 80014868 <cpus+0x8>
    80002046:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80002048:	4b8d                	li	s7,3
        c->proc = p;
    8000204a:	079e                	slli	a5,a5,0x7
    8000204c:	00012917          	auipc	s2,0x12
    80002050:	7f490913          	addi	s2,s2,2036 # 80014840 <pid_lock>
    80002054:	993e                	add	s2,s2,a5
    for(p = proc; p < &proc[NPROC]; p++) {
    80002056:	00014a17          	auipc	s4,0x14
    8000205a:	a6aa0a13          	addi	s4,s4,-1430 # 80015ac0 <tickslock>
    8000205e:	a0b9                	j	800020ac <scheduler+0x9c>
        p->state = RUNNING;
    80002060:	0374a023          	sw	s7,32(s1)
        c->proc = p;
    80002064:	02993023          	sd	s1,32(s2)
        swtch(&c->scheduler, &p->context);
    80002068:	06848593          	addi	a1,s1,104
    8000206c:	855a                	mv	a0,s6
    8000206e:	00000097          	auipc	ra,0x0
    80002072:	63e080e7          	jalr	1598(ra) # 800026ac <swtch>
        c->proc = 0;
    80002076:	02093023          	sd	zero,32(s2)
        found = 1;
    8000207a:	8ae2                	mv	s5,s8
      c->intena = 0;
    8000207c:	08092e23          	sw	zero,156(s2)
      release(&p->lock);
    80002080:	8526                	mv	a0,s1
    80002082:	fffff097          	auipc	ra,0xfffff
    80002086:	afe080e7          	jalr	-1282(ra) # 80000b80 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000208a:	17048493          	addi	s1,s1,368
    8000208e:	01448b63          	beq	s1,s4,800020a4 <scheduler+0x94>
      acquire(&p->lock);
    80002092:	8526                	mv	a0,s1
    80002094:	fffff097          	auipc	ra,0xfffff
    80002098:	a1c080e7          	jalr	-1508(ra) # 80000ab0 <acquire>
      if(p->state == RUNNABLE) {
    8000209c:	509c                	lw	a5,32(s1)
    8000209e:	fd379fe3          	bne	a5,s3,8000207c <scheduler+0x6c>
    800020a2:	bf7d                	j	80002060 <scheduler+0x50>
    if(found == 0){
    800020a4:	000a9463          	bnez	s5,800020ac <scheduler+0x9c>
      asm volatile("wfi");
    800020a8:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020b4:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020b8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800020bc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020be:	10079073          	csrw	sstatus,a5
    int found = 0;
    800020c2:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800020c4:	00013497          	auipc	s1,0x13
    800020c8:	b9c48493          	addi	s1,s1,-1124 # 80014c60 <proc>
      if(p->state == RUNNABLE) {
    800020cc:	4989                	li	s3,2
        found = 1;
    800020ce:	4c05                	li	s8,1
    800020d0:	b7c9                	j	80002092 <scheduler+0x82>

00000000800020d2 <sched>:
{
    800020d2:	7179                	addi	sp,sp,-48
    800020d4:	f406                	sd	ra,40(sp)
    800020d6:	f022                	sd	s0,32(sp)
    800020d8:	ec26                	sd	s1,24(sp)
    800020da:	e84a                	sd	s2,16(sp)
    800020dc:	e44e                	sd	s3,8(sp)
    800020de:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800020e0:	00000097          	auipc	ra,0x0
    800020e4:	a56080e7          	jalr	-1450(ra) # 80001b36 <myproc>
    800020e8:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800020ea:	fffff097          	auipc	ra,0xfffff
    800020ee:	948080e7          	jalr	-1720(ra) # 80000a32 <holding>
    800020f2:	c93d                	beqz	a0,80002168 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    800020f4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800020f6:	2781                	sext.w	a5,a5
    800020f8:	079e                	slli	a5,a5,0x7
    800020fa:	00012717          	auipc	a4,0x12
    800020fe:	74670713          	addi	a4,a4,1862 # 80014840 <pid_lock>
    80002102:	97ba                	add	a5,a5,a4
    80002104:	0987a703          	lw	a4,152(a5)
    80002108:	4785                	li	a5,1
    8000210a:	06f71763          	bne	a4,a5,80002178 <sched+0xa6>
  if(p->state == RUNNING)
    8000210e:	5098                	lw	a4,32(s1)
    80002110:	478d                	li	a5,3
    80002112:	06f70b63          	beq	a4,a5,80002188 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002116:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000211a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000211c:	efb5                	bnez	a5,80002198 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000211e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80002120:	00012917          	auipc	s2,0x12
    80002124:	72090913          	addi	s2,s2,1824 # 80014840 <pid_lock>
    80002128:	2781                	sext.w	a5,a5
    8000212a:	079e                	slli	a5,a5,0x7
    8000212c:	97ca                	add	a5,a5,s2
    8000212e:	09c7a983          	lw	s3,156(a5)
    80002132:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->scheduler);
    80002134:	2781                	sext.w	a5,a5
    80002136:	079e                	slli	a5,a5,0x7
    80002138:	00012597          	auipc	a1,0x12
    8000213c:	73058593          	addi	a1,a1,1840 # 80014868 <cpus+0x8>
    80002140:	95be                	add	a1,a1,a5
    80002142:	06848513          	addi	a0,s1,104
    80002146:	00000097          	auipc	ra,0x0
    8000214a:	566080e7          	jalr	1382(ra) # 800026ac <swtch>
    8000214e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80002150:	2781                	sext.w	a5,a5
    80002152:	079e                	slli	a5,a5,0x7
    80002154:	97ca                	add	a5,a5,s2
    80002156:	0937ae23          	sw	s3,156(a5)
}
    8000215a:	70a2                	ld	ra,40(sp)
    8000215c:	7402                	ld	s0,32(sp)
    8000215e:	64e2                	ld	s1,24(sp)
    80002160:	6942                	ld	s2,16(sp)
    80002162:	69a2                	ld	s3,8(sp)
    80002164:	6145                	addi	sp,sp,48
    80002166:	8082                	ret
    panic("sched p->lock");
    80002168:	00006517          	auipc	a0,0x6
    8000216c:	2a850513          	addi	a0,a0,680 # 80008410 <userret+0x380>
    80002170:	ffffe097          	auipc	ra,0xffffe
    80002174:	3ea080e7          	jalr	1002(ra) # 8000055a <panic>
    panic("sched locks");
    80002178:	00006517          	auipc	a0,0x6
    8000217c:	2a850513          	addi	a0,a0,680 # 80008420 <userret+0x390>
    80002180:	ffffe097          	auipc	ra,0xffffe
    80002184:	3da080e7          	jalr	986(ra) # 8000055a <panic>
    panic("sched running");
    80002188:	00006517          	auipc	a0,0x6
    8000218c:	2a850513          	addi	a0,a0,680 # 80008430 <userret+0x3a0>
    80002190:	ffffe097          	auipc	ra,0xffffe
    80002194:	3ca080e7          	jalr	970(ra) # 8000055a <panic>
    panic("sched interruptible");
    80002198:	00006517          	auipc	a0,0x6
    8000219c:	2a850513          	addi	a0,a0,680 # 80008440 <userret+0x3b0>
    800021a0:	ffffe097          	auipc	ra,0xffffe
    800021a4:	3ba080e7          	jalr	954(ra) # 8000055a <panic>

00000000800021a8 <exit>:
{
    800021a8:	7179                	addi	sp,sp,-48
    800021aa:	f406                	sd	ra,40(sp)
    800021ac:	f022                	sd	s0,32(sp)
    800021ae:	ec26                	sd	s1,24(sp)
    800021b0:	e84a                	sd	s2,16(sp)
    800021b2:	e44e                	sd	s3,8(sp)
    800021b4:	e052                	sd	s4,0(sp)
    800021b6:	1800                	addi	s0,sp,48
    800021b8:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800021ba:	00000097          	auipc	ra,0x0
    800021be:	97c080e7          	jalr	-1668(ra) # 80001b36 <myproc>
    800021c2:	89aa                	mv	s3,a0
  if(p == initproc)
    800021c4:	00026797          	auipc	a5,0x26
    800021c8:	e747b783          	ld	a5,-396(a5) # 80028038 <initproc>
    800021cc:	0d850493          	addi	s1,a0,216
    800021d0:	15850913          	addi	s2,a0,344
    800021d4:	02a79363          	bne	a5,a0,800021fa <exit+0x52>
    panic("init exiting");
    800021d8:	00006517          	auipc	a0,0x6
    800021dc:	28050513          	addi	a0,a0,640 # 80008458 <userret+0x3c8>
    800021e0:	ffffe097          	auipc	ra,0xffffe
    800021e4:	37a080e7          	jalr	890(ra) # 8000055a <panic>
      fileclose(f);
    800021e8:	00002097          	auipc	ra,0x2
    800021ec:	61a080e7          	jalr	1562(ra) # 80004802 <fileclose>
      p->ofile[fd] = 0;
    800021f0:	0004b023          	sd	zero,0(s1)
  for(int fd = 0; fd < NOFILE; fd++){
    800021f4:	04a1                	addi	s1,s1,8
    800021f6:	01248563          	beq	s1,s2,80002200 <exit+0x58>
    if(p->ofile[fd]){
    800021fa:	6088                	ld	a0,0(s1)
    800021fc:	f575                	bnez	a0,800021e8 <exit+0x40>
    800021fe:	bfdd                	j	800021f4 <exit+0x4c>
  begin_op(ROOTDEV);
    80002200:	4501                	li	a0,0
    80002202:	00002097          	auipc	ra,0x2
    80002206:	066080e7          	jalr	102(ra) # 80004268 <begin_op>
  iput(p->cwd);
    8000220a:	1589b503          	ld	a0,344(s3)
    8000220e:	00001097          	auipc	ra,0x1
    80002212:	784080e7          	jalr	1924(ra) # 80003992 <iput>
  end_op(ROOTDEV);
    80002216:	4501                	li	a0,0
    80002218:	00002097          	auipc	ra,0x2
    8000221c:	0fa080e7          	jalr	250(ra) # 80004312 <end_op>
  p->cwd = 0;
    80002220:	1409bc23          	sd	zero,344(s3)
  acquire(&initproc->lock);
    80002224:	00026497          	auipc	s1,0x26
    80002228:	e1448493          	addi	s1,s1,-492 # 80028038 <initproc>
    8000222c:	6088                	ld	a0,0(s1)
    8000222e:	fffff097          	auipc	ra,0xfffff
    80002232:	882080e7          	jalr	-1918(ra) # 80000ab0 <acquire>
  wakeup1(initproc);
    80002236:	6088                	ld	a0,0(s1)
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	7be080e7          	jalr	1982(ra) # 800019f6 <wakeup1>
  release(&initproc->lock);
    80002240:	6088                	ld	a0,0(s1)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	93e080e7          	jalr	-1730(ra) # 80000b80 <release>
  acquire(&p->lock);
    8000224a:	854e                	mv	a0,s3
    8000224c:	fffff097          	auipc	ra,0xfffff
    80002250:	864080e7          	jalr	-1948(ra) # 80000ab0 <acquire>
  struct proc *original_parent = p->parent;
    80002254:	0289b483          	ld	s1,40(s3)
  release(&p->lock);
    80002258:	854e                	mv	a0,s3
    8000225a:	fffff097          	auipc	ra,0xfffff
    8000225e:	926080e7          	jalr	-1754(ra) # 80000b80 <release>
  acquire(&original_parent->lock);
    80002262:	8526                	mv	a0,s1
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	84c080e7          	jalr	-1972(ra) # 80000ab0 <acquire>
  acquire(&p->lock);
    8000226c:	854e                	mv	a0,s3
    8000226e:	fffff097          	auipc	ra,0xfffff
    80002272:	842080e7          	jalr	-1982(ra) # 80000ab0 <acquire>
  reparent(p);
    80002276:	854e                	mv	a0,s3
    80002278:	00000097          	auipc	ra,0x0
    8000227c:	d32080e7          	jalr	-718(ra) # 80001faa <reparent>
  wakeup1(original_parent);
    80002280:	8526                	mv	a0,s1
    80002282:	fffff097          	auipc	ra,0xfffff
    80002286:	774080e7          	jalr	1908(ra) # 800019f6 <wakeup1>
  p->xstate = status;
    8000228a:	0349ae23          	sw	s4,60(s3)
  p->state = ZOMBIE;
    8000228e:	4791                	li	a5,4
    80002290:	02f9a023          	sw	a5,32(s3)
  release(&original_parent->lock);
    80002294:	8526                	mv	a0,s1
    80002296:	fffff097          	auipc	ra,0xfffff
    8000229a:	8ea080e7          	jalr	-1814(ra) # 80000b80 <release>
  sched();
    8000229e:	00000097          	auipc	ra,0x0
    800022a2:	e34080e7          	jalr	-460(ra) # 800020d2 <sched>
  panic("zombie exit");
    800022a6:	00006517          	auipc	a0,0x6
    800022aa:	1c250513          	addi	a0,a0,450 # 80008468 <userret+0x3d8>
    800022ae:	ffffe097          	auipc	ra,0xffffe
    800022b2:	2ac080e7          	jalr	684(ra) # 8000055a <panic>

00000000800022b6 <yield>:
{
    800022b6:	1101                	addi	sp,sp,-32
    800022b8:	ec06                	sd	ra,24(sp)
    800022ba:	e822                	sd	s0,16(sp)
    800022bc:	e426                	sd	s1,8(sp)
    800022be:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800022c0:	00000097          	auipc	ra,0x0
    800022c4:	876080e7          	jalr	-1930(ra) # 80001b36 <myproc>
    800022c8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800022ca:	ffffe097          	auipc	ra,0xffffe
    800022ce:	7e6080e7          	jalr	2022(ra) # 80000ab0 <acquire>
  p->state = RUNNABLE;
    800022d2:	4789                	li	a5,2
    800022d4:	d09c                	sw	a5,32(s1)
  sched();
    800022d6:	00000097          	auipc	ra,0x0
    800022da:	dfc080e7          	jalr	-516(ra) # 800020d2 <sched>
  release(&p->lock);
    800022de:	8526                	mv	a0,s1
    800022e0:	fffff097          	auipc	ra,0xfffff
    800022e4:	8a0080e7          	jalr	-1888(ra) # 80000b80 <release>
}
    800022e8:	60e2                	ld	ra,24(sp)
    800022ea:	6442                	ld	s0,16(sp)
    800022ec:	64a2                	ld	s1,8(sp)
    800022ee:	6105                	addi	sp,sp,32
    800022f0:	8082                	ret

00000000800022f2 <sleep>:
{
    800022f2:	7179                	addi	sp,sp,-48
    800022f4:	f406                	sd	ra,40(sp)
    800022f6:	f022                	sd	s0,32(sp)
    800022f8:	ec26                	sd	s1,24(sp)
    800022fa:	e84a                	sd	s2,16(sp)
    800022fc:	e44e                	sd	s3,8(sp)
    800022fe:	1800                	addi	s0,sp,48
    80002300:	89aa                	mv	s3,a0
    80002302:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002304:	00000097          	auipc	ra,0x0
    80002308:	832080e7          	jalr	-1998(ra) # 80001b36 <myproc>
    8000230c:	84aa                	mv	s1,a0
  if(lk != &p->lock){  //DOC: sleeplock0
    8000230e:	05250663          	beq	a0,s2,8000235a <sleep+0x68>
    acquire(&p->lock);  //DOC: sleeplock1
    80002312:	ffffe097          	auipc	ra,0xffffe
    80002316:	79e080e7          	jalr	1950(ra) # 80000ab0 <acquire>
    release(lk);
    8000231a:	854a                	mv	a0,s2
    8000231c:	fffff097          	auipc	ra,0xfffff
    80002320:	864080e7          	jalr	-1948(ra) # 80000b80 <release>
  p->chan = chan;
    80002324:	0334b823          	sd	s3,48(s1)
  p->state = SLEEPING;
    80002328:	4785                	li	a5,1
    8000232a:	d09c                	sw	a5,32(s1)
  sched();
    8000232c:	00000097          	auipc	ra,0x0
    80002330:	da6080e7          	jalr	-602(ra) # 800020d2 <sched>
  p->chan = 0;
    80002334:	0204b823          	sd	zero,48(s1)
    release(&p->lock);
    80002338:	8526                	mv	a0,s1
    8000233a:	fffff097          	auipc	ra,0xfffff
    8000233e:	846080e7          	jalr	-1978(ra) # 80000b80 <release>
    acquire(lk);
    80002342:	854a                	mv	a0,s2
    80002344:	ffffe097          	auipc	ra,0xffffe
    80002348:	76c080e7          	jalr	1900(ra) # 80000ab0 <acquire>
}
    8000234c:	70a2                	ld	ra,40(sp)
    8000234e:	7402                	ld	s0,32(sp)
    80002350:	64e2                	ld	s1,24(sp)
    80002352:	6942                	ld	s2,16(sp)
    80002354:	69a2                	ld	s3,8(sp)
    80002356:	6145                	addi	sp,sp,48
    80002358:	8082                	ret
  p->chan = chan;
    8000235a:	03353823          	sd	s3,48(a0)
  p->state = SLEEPING;
    8000235e:	4785                	li	a5,1
    80002360:	d11c                	sw	a5,32(a0)
  sched();
    80002362:	00000097          	auipc	ra,0x0
    80002366:	d70080e7          	jalr	-656(ra) # 800020d2 <sched>
  p->chan = 0;
    8000236a:	0204b823          	sd	zero,48(s1)
  if(lk != &p->lock){
    8000236e:	bff9                	j	8000234c <sleep+0x5a>

0000000080002370 <wait>:
{
    80002370:	715d                	addi	sp,sp,-80
    80002372:	e486                	sd	ra,72(sp)
    80002374:	e0a2                	sd	s0,64(sp)
    80002376:	fc26                	sd	s1,56(sp)
    80002378:	f84a                	sd	s2,48(sp)
    8000237a:	f44e                	sd	s3,40(sp)
    8000237c:	f052                	sd	s4,32(sp)
    8000237e:	ec56                	sd	s5,24(sp)
    80002380:	e85a                	sd	s6,16(sp)
    80002382:	e45e                	sd	s7,8(sp)
    80002384:	e062                	sd	s8,0(sp)
    80002386:	0880                	addi	s0,sp,80
    80002388:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    8000238a:	fffff097          	auipc	ra,0xfffff
    8000238e:	7ac080e7          	jalr	1964(ra) # 80001b36 <myproc>
    80002392:	892a                	mv	s2,a0
  acquire(&p->lock);
    80002394:	8c2a                	mv	s8,a0
    80002396:	ffffe097          	auipc	ra,0xffffe
    8000239a:	71a080e7          	jalr	1818(ra) # 80000ab0 <acquire>
    havekids = 0;
    8000239e:	4b81                	li	s7,0
        if(np->state == ZOMBIE){
    800023a0:	4a11                	li	s4,4
    for(np = proc; np < &proc[NPROC]; np++){
    800023a2:	00013997          	auipc	s3,0x13
    800023a6:	71e98993          	addi	s3,s3,1822 # 80015ac0 <tickslock>
        havekids = 1;
    800023aa:	4b05                	li	s6,1
    havekids = 0;
    800023ac:	875e                	mv	a4,s7
    for(np = proc; np < &proc[NPROC]; np++){
    800023ae:	00013497          	auipc	s1,0x13
    800023b2:	8b248493          	addi	s1,s1,-1870 # 80014c60 <proc>
    800023b6:	a08d                	j	80002418 <wait+0xa8>
          pid = np->pid;
    800023b8:	0404a983          	lw	s3,64(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&np->xstate,
    800023bc:	000a8e63          	beqz	s5,800023d8 <wait+0x68>
    800023c0:	4691                	li	a3,4
    800023c2:	03c48613          	addi	a2,s1,60
    800023c6:	85d6                	mv	a1,s5
    800023c8:	05893503          	ld	a0,88(s2)
    800023cc:	fffff097          	auipc	ra,0xfffff
    800023d0:	45e080e7          	jalr	1118(ra) # 8000182a <copyout>
    800023d4:	02054263          	bltz	a0,800023f8 <wait+0x88>
          freeproc(np);
    800023d8:	8526                	mv	a0,s1
    800023da:	00000097          	auipc	ra,0x0
    800023de:	978080e7          	jalr	-1672(ra) # 80001d52 <freeproc>
          release(&np->lock);
    800023e2:	8526                	mv	a0,s1
    800023e4:	ffffe097          	auipc	ra,0xffffe
    800023e8:	79c080e7          	jalr	1948(ra) # 80000b80 <release>
          release(&p->lock);
    800023ec:	854a                	mv	a0,s2
    800023ee:	ffffe097          	auipc	ra,0xffffe
    800023f2:	792080e7          	jalr	1938(ra) # 80000b80 <release>
          return pid;
    800023f6:	a8a9                	j	80002450 <wait+0xe0>
            release(&np->lock);
    800023f8:	8526                	mv	a0,s1
    800023fa:	ffffe097          	auipc	ra,0xffffe
    800023fe:	786080e7          	jalr	1926(ra) # 80000b80 <release>
            release(&p->lock);
    80002402:	854a                	mv	a0,s2
    80002404:	ffffe097          	auipc	ra,0xffffe
    80002408:	77c080e7          	jalr	1916(ra) # 80000b80 <release>
            return -1;
    8000240c:	59fd                	li	s3,-1
    8000240e:	a089                	j	80002450 <wait+0xe0>
    for(np = proc; np < &proc[NPROC]; np++){
    80002410:	17048493          	addi	s1,s1,368
    80002414:	03348463          	beq	s1,s3,8000243c <wait+0xcc>
      if(np->parent == p){
    80002418:	749c                	ld	a5,40(s1)
    8000241a:	ff279be3          	bne	a5,s2,80002410 <wait+0xa0>
        acquire(&np->lock);
    8000241e:	8526                	mv	a0,s1
    80002420:	ffffe097          	auipc	ra,0xffffe
    80002424:	690080e7          	jalr	1680(ra) # 80000ab0 <acquire>
        if(np->state == ZOMBIE){
    80002428:	509c                	lw	a5,32(s1)
    8000242a:	f94787e3          	beq	a5,s4,800023b8 <wait+0x48>
        release(&np->lock);
    8000242e:	8526                	mv	a0,s1
    80002430:	ffffe097          	auipc	ra,0xffffe
    80002434:	750080e7          	jalr	1872(ra) # 80000b80 <release>
        havekids = 1;
    80002438:	875a                	mv	a4,s6
    8000243a:	bfd9                	j	80002410 <wait+0xa0>
    if(!havekids || p->killed){
    8000243c:	c701                	beqz	a4,80002444 <wait+0xd4>
    8000243e:	03892783          	lw	a5,56(s2)
    80002442:	c785                	beqz	a5,8000246a <wait+0xfa>
      release(&p->lock);
    80002444:	854a                	mv	a0,s2
    80002446:	ffffe097          	auipc	ra,0xffffe
    8000244a:	73a080e7          	jalr	1850(ra) # 80000b80 <release>
      return -1;
    8000244e:	59fd                	li	s3,-1
}
    80002450:	854e                	mv	a0,s3
    80002452:	60a6                	ld	ra,72(sp)
    80002454:	6406                	ld	s0,64(sp)
    80002456:	74e2                	ld	s1,56(sp)
    80002458:	7942                	ld	s2,48(sp)
    8000245a:	79a2                	ld	s3,40(sp)
    8000245c:	7a02                	ld	s4,32(sp)
    8000245e:	6ae2                	ld	s5,24(sp)
    80002460:	6b42                	ld	s6,16(sp)
    80002462:	6ba2                	ld	s7,8(sp)
    80002464:	6c02                	ld	s8,0(sp)
    80002466:	6161                	addi	sp,sp,80
    80002468:	8082                	ret
    sleep(p, &p->lock);  //DOC: wait-sleep
    8000246a:	85e2                	mv	a1,s8
    8000246c:	854a                	mv	a0,s2
    8000246e:	00000097          	auipc	ra,0x0
    80002472:	e84080e7          	jalr	-380(ra) # 800022f2 <sleep>
    havekids = 0;
    80002476:	bf1d                	j	800023ac <wait+0x3c>

0000000080002478 <wakeup>:
{
    80002478:	7139                	addi	sp,sp,-64
    8000247a:	fc06                	sd	ra,56(sp)
    8000247c:	f822                	sd	s0,48(sp)
    8000247e:	f426                	sd	s1,40(sp)
    80002480:	f04a                	sd	s2,32(sp)
    80002482:	ec4e                	sd	s3,24(sp)
    80002484:	e852                	sd	s4,16(sp)
    80002486:	e456                	sd	s5,8(sp)
    80002488:	0080                	addi	s0,sp,64
    8000248a:	8a2a                	mv	s4,a0
  for(p = proc; p < &proc[NPROC]; p++) {
    8000248c:	00012497          	auipc	s1,0x12
    80002490:	7d448493          	addi	s1,s1,2004 # 80014c60 <proc>
    if(p->state == SLEEPING && p->chan == chan) {
    80002494:	4985                	li	s3,1
      p->state = RUNNABLE;
    80002496:	4a89                	li	s5,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80002498:	00013917          	auipc	s2,0x13
    8000249c:	62890913          	addi	s2,s2,1576 # 80015ac0 <tickslock>
    800024a0:	a821                	j	800024b8 <wakeup+0x40>
      p->state = RUNNABLE;
    800024a2:	0354a023          	sw	s5,32(s1)
    release(&p->lock);
    800024a6:	8526                	mv	a0,s1
    800024a8:	ffffe097          	auipc	ra,0xffffe
    800024ac:	6d8080e7          	jalr	1752(ra) # 80000b80 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800024b0:	17048493          	addi	s1,s1,368
    800024b4:	01248e63          	beq	s1,s2,800024d0 <wakeup+0x58>
    acquire(&p->lock);
    800024b8:	8526                	mv	a0,s1
    800024ba:	ffffe097          	auipc	ra,0xffffe
    800024be:	5f6080e7          	jalr	1526(ra) # 80000ab0 <acquire>
    if(p->state == SLEEPING && p->chan == chan) {
    800024c2:	509c                	lw	a5,32(s1)
    800024c4:	ff3791e3          	bne	a5,s3,800024a6 <wakeup+0x2e>
    800024c8:	789c                	ld	a5,48(s1)
    800024ca:	fd479ee3          	bne	a5,s4,800024a6 <wakeup+0x2e>
    800024ce:	bfd1                	j	800024a2 <wakeup+0x2a>
}
    800024d0:	70e2                	ld	ra,56(sp)
    800024d2:	7442                	ld	s0,48(sp)
    800024d4:	74a2                	ld	s1,40(sp)
    800024d6:	7902                	ld	s2,32(sp)
    800024d8:	69e2                	ld	s3,24(sp)
    800024da:	6a42                	ld	s4,16(sp)
    800024dc:	6aa2                	ld	s5,8(sp)
    800024de:	6121                	addi	sp,sp,64
    800024e0:	8082                	ret

00000000800024e2 <kill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kill(int pid)
{
    800024e2:	7179                	addi	sp,sp,-48
    800024e4:	f406                	sd	ra,40(sp)
    800024e6:	f022                	sd	s0,32(sp)
    800024e8:	ec26                	sd	s1,24(sp)
    800024ea:	e84a                	sd	s2,16(sp)
    800024ec:	e44e                	sd	s3,8(sp)
    800024ee:	1800                	addi	s0,sp,48
    800024f0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800024f2:	00012497          	auipc	s1,0x12
    800024f6:	76e48493          	addi	s1,s1,1902 # 80014c60 <proc>
    800024fa:	00013997          	auipc	s3,0x13
    800024fe:	5c698993          	addi	s3,s3,1478 # 80015ac0 <tickslock>
    acquire(&p->lock);
    80002502:	8526                	mv	a0,s1
    80002504:	ffffe097          	auipc	ra,0xffffe
    80002508:	5ac080e7          	jalr	1452(ra) # 80000ab0 <acquire>
    if(p->pid == pid){
    8000250c:	40bc                	lw	a5,64(s1)
    8000250e:	03278363          	beq	a5,s2,80002534 <kill+0x52>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80002512:	8526                	mv	a0,s1
    80002514:	ffffe097          	auipc	ra,0xffffe
    80002518:	66c080e7          	jalr	1644(ra) # 80000b80 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000251c:	17048493          	addi	s1,s1,368
    80002520:	ff3491e3          	bne	s1,s3,80002502 <kill+0x20>
  }
  return -1;
    80002524:	557d                	li	a0,-1
}
    80002526:	70a2                	ld	ra,40(sp)
    80002528:	7402                	ld	s0,32(sp)
    8000252a:	64e2                	ld	s1,24(sp)
    8000252c:	6942                	ld	s2,16(sp)
    8000252e:	69a2                	ld	s3,8(sp)
    80002530:	6145                	addi	sp,sp,48
    80002532:	8082                	ret
      p->killed = 1;
    80002534:	4785                	li	a5,1
    80002536:	dc9c                	sw	a5,56(s1)
      if(p->state == SLEEPING){
    80002538:	5098                	lw	a4,32(s1)
    8000253a:	00f70963          	beq	a4,a5,8000254c <kill+0x6a>
      release(&p->lock);
    8000253e:	8526                	mv	a0,s1
    80002540:	ffffe097          	auipc	ra,0xffffe
    80002544:	640080e7          	jalr	1600(ra) # 80000b80 <release>
      return 0;
    80002548:	4501                	li	a0,0
    8000254a:	bff1                	j	80002526 <kill+0x44>
        p->state = RUNNABLE;
    8000254c:	4789                	li	a5,2
    8000254e:	d09c                	sw	a5,32(s1)
    80002550:	b7fd                	j	8000253e <kill+0x5c>

0000000080002552 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002552:	7179                	addi	sp,sp,-48
    80002554:	f406                	sd	ra,40(sp)
    80002556:	f022                	sd	s0,32(sp)
    80002558:	ec26                	sd	s1,24(sp)
    8000255a:	e84a                	sd	s2,16(sp)
    8000255c:	e44e                	sd	s3,8(sp)
    8000255e:	e052                	sd	s4,0(sp)
    80002560:	1800                	addi	s0,sp,48
    80002562:	84aa                	mv	s1,a0
    80002564:	892e                	mv	s2,a1
    80002566:	89b2                	mv	s3,a2
    80002568:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    8000256a:	fffff097          	auipc	ra,0xfffff
    8000256e:	5cc080e7          	jalr	1484(ra) # 80001b36 <myproc>
  if(user_dst){
    80002572:	c08d                	beqz	s1,80002594 <either_copyout+0x42>
    return copyout(p->pagetable, dst, src, len);
    80002574:	86d2                	mv	a3,s4
    80002576:	864e                	mv	a2,s3
    80002578:	85ca                	mv	a1,s2
    8000257a:	6d28                	ld	a0,88(a0)
    8000257c:	fffff097          	auipc	ra,0xfffff
    80002580:	2ae080e7          	jalr	686(ra) # 8000182a <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002584:	70a2                	ld	ra,40(sp)
    80002586:	7402                	ld	s0,32(sp)
    80002588:	64e2                	ld	s1,24(sp)
    8000258a:	6942                	ld	s2,16(sp)
    8000258c:	69a2                	ld	s3,8(sp)
    8000258e:	6a02                	ld	s4,0(sp)
    80002590:	6145                	addi	sp,sp,48
    80002592:	8082                	ret
    memmove((char *)dst, src, len);
    80002594:	000a061b          	sext.w	a2,s4
    80002598:	85ce                	mv	a1,s3
    8000259a:	854a                	mv	a0,s2
    8000259c:	fffff097          	auipc	ra,0xfffff
    800025a0:	842080e7          	jalr	-1982(ra) # 80000dde <memmove>
    return 0;
    800025a4:	8526                	mv	a0,s1
    800025a6:	bff9                	j	80002584 <either_copyout+0x32>

00000000800025a8 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800025a8:	7179                	addi	sp,sp,-48
    800025aa:	f406                	sd	ra,40(sp)
    800025ac:	f022                	sd	s0,32(sp)
    800025ae:	ec26                	sd	s1,24(sp)
    800025b0:	e84a                	sd	s2,16(sp)
    800025b2:	e44e                	sd	s3,8(sp)
    800025b4:	e052                	sd	s4,0(sp)
    800025b6:	1800                	addi	s0,sp,48
    800025b8:	892a                	mv	s2,a0
    800025ba:	84ae                	mv	s1,a1
    800025bc:	89b2                	mv	s3,a2
    800025be:	8a36                	mv	s4,a3
  struct proc *p = myproc();
    800025c0:	fffff097          	auipc	ra,0xfffff
    800025c4:	576080e7          	jalr	1398(ra) # 80001b36 <myproc>
  if(user_src){
    800025c8:	c08d                	beqz	s1,800025ea <either_copyin+0x42>
    return copyin(p->pagetable, dst, src, len);
    800025ca:	86d2                	mv	a3,s4
    800025cc:	864e                	mv	a2,s3
    800025ce:	85ca                	mv	a1,s2
    800025d0:	6d28                	ld	a0,88(a0)
    800025d2:	fffff097          	auipc	ra,0xfffff
    800025d6:	2e4080e7          	jalr	740(ra) # 800018b6 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800025da:	70a2                	ld	ra,40(sp)
    800025dc:	7402                	ld	s0,32(sp)
    800025de:	64e2                	ld	s1,24(sp)
    800025e0:	6942                	ld	s2,16(sp)
    800025e2:	69a2                	ld	s3,8(sp)
    800025e4:	6a02                	ld	s4,0(sp)
    800025e6:	6145                	addi	sp,sp,48
    800025e8:	8082                	ret
    memmove(dst, (char*)src, len);
    800025ea:	000a061b          	sext.w	a2,s4
    800025ee:	85ce                	mv	a1,s3
    800025f0:	854a                	mv	a0,s2
    800025f2:	ffffe097          	auipc	ra,0xffffe
    800025f6:	7ec080e7          	jalr	2028(ra) # 80000dde <memmove>
    return 0;
    800025fa:	8526                	mv	a0,s1
    800025fc:	bff9                	j	800025da <either_copyin+0x32>

00000000800025fe <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800025fe:	715d                	addi	sp,sp,-80
    80002600:	e486                	sd	ra,72(sp)
    80002602:	e0a2                	sd	s0,64(sp)
    80002604:	fc26                	sd	s1,56(sp)
    80002606:	f84a                	sd	s2,48(sp)
    80002608:	f44e                	sd	s3,40(sp)
    8000260a:	f052                	sd	s4,32(sp)
    8000260c:	ec56                	sd	s5,24(sp)
    8000260e:	e85a                	sd	s6,16(sp)
    80002610:	e45e                	sd	s7,8(sp)
    80002612:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80002614:	00006517          	auipc	a0,0x6
    80002618:	c7c50513          	addi	a0,a0,-900 # 80008290 <userret+0x200>
    8000261c:	ffffe097          	auipc	ra,0xffffe
    80002620:	f98080e7          	jalr	-104(ra) # 800005b4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002624:	00012497          	auipc	s1,0x12
    80002628:	79c48493          	addi	s1,s1,1948 # 80014dc0 <proc+0x160>
    8000262c:	00013917          	auipc	s2,0x13
    80002630:	5f490913          	addi	s2,s2,1524 # 80015c20 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002634:	4b11                	li	s6,4
      state = states[p->state];
    else
      state = "???";
    80002636:	00006997          	auipc	s3,0x6
    8000263a:	e4298993          	addi	s3,s3,-446 # 80008478 <userret+0x3e8>
    printf("%d %s %s", p->pid, state, p->name);
    8000263e:	00006a97          	auipc	s5,0x6
    80002642:	e42a8a93          	addi	s5,s5,-446 # 80008480 <userret+0x3f0>
    printf("\n");
    80002646:	00006a17          	auipc	s4,0x6
    8000264a:	c4aa0a13          	addi	s4,s4,-950 # 80008290 <userret+0x200>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000264e:	00006b97          	auipc	s7,0x6
    80002652:	6b2b8b93          	addi	s7,s7,1714 # 80008d00 <states.1787>
    80002656:	a00d                	j	80002678 <procdump+0x7a>
    printf("%d %s %s", p->pid, state, p->name);
    80002658:	ee06a583          	lw	a1,-288(a3)
    8000265c:	8556                	mv	a0,s5
    8000265e:	ffffe097          	auipc	ra,0xffffe
    80002662:	f56080e7          	jalr	-170(ra) # 800005b4 <printf>
    printf("\n");
    80002666:	8552                	mv	a0,s4
    80002668:	ffffe097          	auipc	ra,0xffffe
    8000266c:	f4c080e7          	jalr	-180(ra) # 800005b4 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80002670:	17048493          	addi	s1,s1,368
    80002674:	03248163          	beq	s1,s2,80002696 <procdump+0x98>
    if(p->state == UNUSED)
    80002678:	86a6                	mv	a3,s1
    8000267a:	ec04a783          	lw	a5,-320(s1)
    8000267e:	dbed                	beqz	a5,80002670 <procdump+0x72>
      state = "???";
    80002680:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002682:	fcfb6be3          	bltu	s6,a5,80002658 <procdump+0x5a>
    80002686:	1782                	slli	a5,a5,0x20
    80002688:	9381                	srli	a5,a5,0x20
    8000268a:	078e                	slli	a5,a5,0x3
    8000268c:	97de                	add	a5,a5,s7
    8000268e:	6390                	ld	a2,0(a5)
    80002690:	f661                	bnez	a2,80002658 <procdump+0x5a>
      state = "???";
    80002692:	864e                	mv	a2,s3
    80002694:	b7d1                	j	80002658 <procdump+0x5a>
  }
}
    80002696:	60a6                	ld	ra,72(sp)
    80002698:	6406                	ld	s0,64(sp)
    8000269a:	74e2                	ld	s1,56(sp)
    8000269c:	7942                	ld	s2,48(sp)
    8000269e:	79a2                	ld	s3,40(sp)
    800026a0:	7a02                	ld	s4,32(sp)
    800026a2:	6ae2                	ld	s5,24(sp)
    800026a4:	6b42                	ld	s6,16(sp)
    800026a6:	6ba2                	ld	s7,8(sp)
    800026a8:	6161                	addi	sp,sp,80
    800026aa:	8082                	ret

00000000800026ac <swtch>:
    800026ac:	00153023          	sd	ra,0(a0)
    800026b0:	00253423          	sd	sp,8(a0)
    800026b4:	e900                	sd	s0,16(a0)
    800026b6:	ed04                	sd	s1,24(a0)
    800026b8:	03253023          	sd	s2,32(a0)
    800026bc:	03353423          	sd	s3,40(a0)
    800026c0:	03453823          	sd	s4,48(a0)
    800026c4:	03553c23          	sd	s5,56(a0)
    800026c8:	05653023          	sd	s6,64(a0)
    800026cc:	05753423          	sd	s7,72(a0)
    800026d0:	05853823          	sd	s8,80(a0)
    800026d4:	05953c23          	sd	s9,88(a0)
    800026d8:	07a53023          	sd	s10,96(a0)
    800026dc:	07b53423          	sd	s11,104(a0)
    800026e0:	0005b083          	ld	ra,0(a1)
    800026e4:	0085b103          	ld	sp,8(a1)
    800026e8:	6980                	ld	s0,16(a1)
    800026ea:	6d84                	ld	s1,24(a1)
    800026ec:	0205b903          	ld	s2,32(a1)
    800026f0:	0285b983          	ld	s3,40(a1)
    800026f4:	0305ba03          	ld	s4,48(a1)
    800026f8:	0385ba83          	ld	s5,56(a1)
    800026fc:	0405bb03          	ld	s6,64(a1)
    80002700:	0485bb83          	ld	s7,72(a1)
    80002704:	0505bc03          	ld	s8,80(a1)
    80002708:	0585bc83          	ld	s9,88(a1)
    8000270c:	0605bd03          	ld	s10,96(a1)
    80002710:	0685bd83          	ld	s11,104(a1)
    80002714:	8082                	ret

0000000080002716 <scause_desc>:
  } else {
    return 0;
  }
}

static const char *scause_desc(uint64 stval) {
    80002716:	1141                	addi	sp,sp,-16
    80002718:	e422                	sd	s0,8(sp)
    8000271a:	0800                	addi	s0,sp,16
    8000271c:	87aa                	mv	a5,a0
      [13] "load page fault",
      [14] "<reserved for future standard use>",
      [15] "store/AMO page fault",
  };
  uint64 interrupt = stval & 0x8000000000000000L;
  uint64 code = stval & ~0x8000000000000000L;
    8000271e:	00151713          	slli	a4,a0,0x1
    80002722:	8305                	srli	a4,a4,0x1
  if (interrupt) {
    80002724:	04054c63          	bltz	a0,8000277c <scause_desc+0x66>
      return intr_desc[code];
    } else {
      return "<reserved for platform use>";
    }
  } else {
    if (code < NELEM(nointr_desc)) {
    80002728:	5685                	li	a3,-31
    8000272a:	8285                	srli	a3,a3,0x1
    8000272c:	8ee9                	and	a3,a3,a0
    8000272e:	caad                	beqz	a3,800027a0 <scause_desc+0x8a>
      return nointr_desc[code];
    } else if (code <= 23) {
    80002730:	46dd                	li	a3,23
      return "<reserved for future standard use>";
    80002732:	00006517          	auipc	a0,0x6
    80002736:	d8650513          	addi	a0,a0,-634 # 800084b8 <userret+0x428>
    } else if (code <= 23) {
    8000273a:	06e6f063          	bgeu	a3,a4,8000279a <scause_desc+0x84>
    } else if (code <= 31) {
    8000273e:	fc100693          	li	a3,-63
    80002742:	8285                	srli	a3,a3,0x1
    80002744:	8efd                	and	a3,a3,a5
      return "<reserved for custom use>";
    80002746:	00006517          	auipc	a0,0x6
    8000274a:	d9a50513          	addi	a0,a0,-614 # 800084e0 <userret+0x450>
    } else if (code <= 31) {
    8000274e:	c6b1                	beqz	a3,8000279a <scause_desc+0x84>
    } else if (code <= 47) {
    80002750:	02f00693          	li	a3,47
      return "<reserved for future standard use>";
    80002754:	00006517          	auipc	a0,0x6
    80002758:	d6450513          	addi	a0,a0,-668 # 800084b8 <userret+0x428>
    } else if (code <= 47) {
    8000275c:	02e6ff63          	bgeu	a3,a4,8000279a <scause_desc+0x84>
    } else if (code <= 63) {
    80002760:	f8100513          	li	a0,-127
    80002764:	8105                	srli	a0,a0,0x1
    80002766:	8fe9                	and	a5,a5,a0
      return "<reserved for custom use>";
    80002768:	00006517          	auipc	a0,0x6
    8000276c:	d7850513          	addi	a0,a0,-648 # 800084e0 <userret+0x450>
    } else if (code <= 63) {
    80002770:	c78d                	beqz	a5,8000279a <scause_desc+0x84>
    } else {
      return "<reserved for future standard use>";
    80002772:	00006517          	auipc	a0,0x6
    80002776:	d4650513          	addi	a0,a0,-698 # 800084b8 <userret+0x428>
    8000277a:	a005                	j	8000279a <scause_desc+0x84>
    if (code < NELEM(intr_desc)) {
    8000277c:	5505                	li	a0,-31
    8000277e:	8105                	srli	a0,a0,0x1
    80002780:	8fe9                	and	a5,a5,a0
      return "<reserved for platform use>";
    80002782:	00006517          	auipc	a0,0x6
    80002786:	d7e50513          	addi	a0,a0,-642 # 80008500 <userret+0x470>
    if (code < NELEM(intr_desc)) {
    8000278a:	eb81                	bnez	a5,8000279a <scause_desc+0x84>
      return intr_desc[code];
    8000278c:	070e                	slli	a4,a4,0x3
    8000278e:	00006797          	auipc	a5,0x6
    80002792:	59a78793          	addi	a5,a5,1434 # 80008d28 <intr_desc.1611>
    80002796:	973e                	add	a4,a4,a5
    80002798:	6308                	ld	a0,0(a4)
    }
  }
}
    8000279a:	6422                	ld	s0,8(sp)
    8000279c:	0141                	addi	sp,sp,16
    8000279e:	8082                	ret
      return nointr_desc[code];
    800027a0:	070e                	slli	a4,a4,0x3
    800027a2:	00006797          	auipc	a5,0x6
    800027a6:	58678793          	addi	a5,a5,1414 # 80008d28 <intr_desc.1611>
    800027aa:	973e                	add	a4,a4,a5
    800027ac:	6348                	ld	a0,128(a4)
    800027ae:	b7f5                	j	8000279a <scause_desc+0x84>

00000000800027b0 <trapinit>:
void trapinit(void) { initlock(&tickslock, "time"); }
    800027b0:	1141                	addi	sp,sp,-16
    800027b2:	e406                	sd	ra,8(sp)
    800027b4:	e022                	sd	s0,0(sp)
    800027b6:	0800                	addi	s0,sp,16
    800027b8:	00006597          	auipc	a1,0x6
    800027bc:	d6858593          	addi	a1,a1,-664 # 80008520 <userret+0x490>
    800027c0:	00013517          	auipc	a0,0x13
    800027c4:	30050513          	addi	a0,a0,768 # 80015ac0 <tickslock>
    800027c8:	ffffe097          	auipc	ra,0xffffe
    800027cc:	214080e7          	jalr	532(ra) # 800009dc <initlock>
    800027d0:	60a2                	ld	ra,8(sp)
    800027d2:	6402                	ld	s0,0(sp)
    800027d4:	0141                	addi	sp,sp,16
    800027d6:	8082                	ret

00000000800027d8 <trapinithart>:
void trapinithart(void) { w_stvec((uint64)kernelvec); }
    800027d8:	1141                	addi	sp,sp,-16
    800027da:	e422                	sd	s0,8(sp)
    800027dc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800027de:	00003797          	auipc	a5,0x3
    800027e2:	6a278793          	addi	a5,a5,1698 # 80005e80 <kernelvec>
    800027e6:	10579073          	csrw	stvec,a5
    800027ea:	6422                	ld	s0,8(sp)
    800027ec:	0141                	addi	sp,sp,16
    800027ee:	8082                	ret

00000000800027f0 <usertrapret>:
void usertrapret(void) {
    800027f0:	1141                	addi	sp,sp,-16
    800027f2:	e406                	sd	ra,8(sp)
    800027f4:	e022                	sd	s0,0(sp)
    800027f6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800027f8:	fffff097          	auipc	ra,0xfffff
    800027fc:	33e080e7          	jalr	830(ra) # 80001b36 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002800:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80002804:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002806:	10079073          	csrw	sstatus,a5
  w_stvec(TRAMPOLINE + (uservec - trampoline));
    8000280a:	00005617          	auipc	a2,0x5
    8000280e:	7f660613          	addi	a2,a2,2038 # 80008000 <trampoline>
    80002812:	00005697          	auipc	a3,0x5
    80002816:	7ee68693          	addi	a3,a3,2030 # 80008000 <trampoline>
    8000281a:	8e91                	sub	a3,a3,a2
    8000281c:	040007b7          	lui	a5,0x4000
    80002820:	17fd                	addi	a5,a5,-1
    80002822:	07b2                	slli	a5,a5,0xc
    80002824:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002826:	10569073          	csrw	stvec,a3
  p->tf->kernel_satp = r_satp();         // kernel page table
    8000282a:	7138                	ld	a4,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000282c:	180026f3          	csrr	a3,satp
    80002830:	e314                	sd	a3,0(a4)
  p->tf->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002832:	7138                	ld	a4,96(a0)
    80002834:	6534                	ld	a3,72(a0)
    80002836:	6585                	lui	a1,0x1
    80002838:	96ae                	add	a3,a3,a1
    8000283a:	e714                	sd	a3,8(a4)
  p->tf->kernel_trap = (uint64)usertrap;
    8000283c:	7138                	ld	a4,96(a0)
    8000283e:	00000697          	auipc	a3,0x0
    80002842:	12c68693          	addi	a3,a3,300 # 8000296a <usertrap>
    80002846:	eb14                	sd	a3,16(a4)
  p->tf->kernel_hartid = r_tp(); // hartid for cpuid()
    80002848:	7138                	ld	a4,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000284a:	8692                	mv	a3,tp
    8000284c:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000284e:	100026f3          	csrr	a3,sstatus
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002852:	eff6f693          	andi	a3,a3,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002856:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000285a:	10069073          	csrw	sstatus,a3
  w_sepc(p->tf->epc);
    8000285e:	7138                	ld	a4,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002860:	6f18                	ld	a4,24(a4)
    80002862:	14171073          	csrw	sepc,a4
  uint64 satp = MAKE_SATP(p->pagetable);
    80002866:	6d2c                	ld	a1,88(a0)
    80002868:	81b1                	srli	a1,a1,0xc
  uint64 fn = TRAMPOLINE + (userret - trampoline);
    8000286a:	00006717          	auipc	a4,0x6
    8000286e:	82670713          	addi	a4,a4,-2010 # 80008090 <userret>
    80002872:	8f11                	sub	a4,a4,a2
    80002874:	97ba                	add	a5,a5,a4
  ((void (*)(uint64, uint64))fn)(TRAPFRAME, satp);
    80002876:	577d                	li	a4,-1
    80002878:	177e                	slli	a4,a4,0x3f
    8000287a:	8dd9                	or	a1,a1,a4
    8000287c:	02000537          	lui	a0,0x2000
    80002880:	157d                	addi	a0,a0,-1
    80002882:	0536                	slli	a0,a0,0xd
    80002884:	9782                	jalr	a5
}
    80002886:	60a2                	ld	ra,8(sp)
    80002888:	6402                	ld	s0,0(sp)
    8000288a:	0141                	addi	sp,sp,16
    8000288c:	8082                	ret

000000008000288e <clockintr>:
void clockintr() {
    8000288e:	1101                	addi	sp,sp,-32
    80002890:	ec06                	sd	ra,24(sp)
    80002892:	e822                	sd	s0,16(sp)
    80002894:	e426                	sd	s1,8(sp)
    80002896:	1000                	addi	s0,sp,32
  acquire(&tickslock);
    80002898:	00013497          	auipc	s1,0x13
    8000289c:	22848493          	addi	s1,s1,552 # 80015ac0 <tickslock>
    800028a0:	8526                	mv	a0,s1
    800028a2:	ffffe097          	auipc	ra,0xffffe
    800028a6:	20e080e7          	jalr	526(ra) # 80000ab0 <acquire>
  ticks++;
    800028aa:	00025517          	auipc	a0,0x25
    800028ae:	79650513          	addi	a0,a0,1942 # 80028040 <ticks>
    800028b2:	411c                	lw	a5,0(a0)
    800028b4:	2785                	addiw	a5,a5,1
    800028b6:	c11c                	sw	a5,0(a0)
  wakeup(&ticks);
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	bc0080e7          	jalr	-1088(ra) # 80002478 <wakeup>
  release(&tickslock);
    800028c0:	8526                	mv	a0,s1
    800028c2:	ffffe097          	auipc	ra,0xffffe
    800028c6:	2be080e7          	jalr	702(ra) # 80000b80 <release>
}
    800028ca:	60e2                	ld	ra,24(sp)
    800028cc:	6442                	ld	s0,16(sp)
    800028ce:	64a2                	ld	s1,8(sp)
    800028d0:	6105                	addi	sp,sp,32
    800028d2:	8082                	ret

00000000800028d4 <devintr>:
int devintr() {
    800028d4:	1101                	addi	sp,sp,-32
    800028d6:	ec06                	sd	ra,24(sp)
    800028d8:	e822                	sd	s0,16(sp)
    800028da:	e426                	sd	s1,8(sp)
    800028dc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800028de:	14202773          	csrr	a4,scause
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800028e2:	00074d63          	bltz	a4,800028fc <devintr+0x28>
  } else if (scause == 0x8000000000000001L) {
    800028e6:	57fd                	li	a5,-1
    800028e8:	17fe                	slli	a5,a5,0x3f
    800028ea:	0785                	addi	a5,a5,1
    return 0;
    800028ec:	4501                	li	a0,0
  } else if (scause == 0x8000000000000001L) {
    800028ee:	04f70d63          	beq	a4,a5,80002948 <devintr+0x74>
}
    800028f2:	60e2                	ld	ra,24(sp)
    800028f4:	6442                	ld	s0,16(sp)
    800028f6:	64a2                	ld	s1,8(sp)
    800028f8:	6105                	addi	sp,sp,32
    800028fa:	8082                	ret
  if ((scause & 0x8000000000000000L) && (scause & 0xff) == 9) {
    800028fc:	0ff77793          	andi	a5,a4,255
    80002900:	46a5                	li	a3,9
    80002902:	fed792e3          	bne	a5,a3,800028e6 <devintr+0x12>
    int irq = plic_claim();
    80002906:	00003097          	auipc	ra,0x3
    8000290a:	682080e7          	jalr	1666(ra) # 80005f88 <plic_claim>
    8000290e:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002910:	47a9                	li	a5,10
    80002912:	00f50a63          	beq	a0,a5,80002926 <devintr+0x52>
    } else if (irq == VIRTIO0_IRQ || irq == VIRTIO1_IRQ) {
    80002916:	fff5079b          	addiw	a5,a0,-1
    8000291a:	4705                	li	a4,1
    8000291c:	00f77a63          	bgeu	a4,a5,80002930 <devintr+0x5c>
    return 1;
    80002920:	4505                	li	a0,1
    if (irq)
    80002922:	d8e1                	beqz	s1,800028f2 <devintr+0x1e>
    80002924:	a819                	j	8000293a <devintr+0x66>
      uartintr();
    80002926:	ffffe097          	auipc	ra,0xffffe
    8000292a:	f2e080e7          	jalr	-210(ra) # 80000854 <uartintr>
    8000292e:	a031                	j	8000293a <devintr+0x66>
      virtio_disk_intr(irq - VIRTIO0_IRQ);
    80002930:	853e                	mv	a0,a5
    80002932:	00004097          	auipc	ra,0x4
    80002936:	c4a080e7          	jalr	-950(ra) # 8000657c <virtio_disk_intr>
      plic_complete(irq);
    8000293a:	8526                	mv	a0,s1
    8000293c:	00003097          	auipc	ra,0x3
    80002940:	670080e7          	jalr	1648(ra) # 80005fac <plic_complete>
    return 1;
    80002944:	4505                	li	a0,1
    80002946:	b775                	j	800028f2 <devintr+0x1e>
    if (cpuid() == 0) {
    80002948:	fffff097          	auipc	ra,0xfffff
    8000294c:	1c2080e7          	jalr	450(ra) # 80001b0a <cpuid>
    80002950:	c901                	beqz	a0,80002960 <devintr+0x8c>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80002952:	144027f3          	csrr	a5,sip
    w_sip(r_sip() & ~2);
    80002956:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80002958:	14479073          	csrw	sip,a5
    return 2;
    8000295c:	4509                	li	a0,2
    8000295e:	bf51                	j	800028f2 <devintr+0x1e>
      clockintr();
    80002960:	00000097          	auipc	ra,0x0
    80002964:	f2e080e7          	jalr	-210(ra) # 8000288e <clockintr>
    80002968:	b7ed                	j	80002952 <devintr+0x7e>

000000008000296a <usertrap>:
void usertrap(void) {
    8000296a:	7139                	addi	sp,sp,-64
    8000296c:	fc06                	sd	ra,56(sp)
    8000296e:	f822                	sd	s0,48(sp)
    80002970:	f426                	sd	s1,40(sp)
    80002972:	f04a                	sd	s2,32(sp)
    80002974:	ec4e                	sd	s3,24(sp)
    80002976:	e852                	sd	s4,16(sp)
    80002978:	e456                	sd	s5,8(sp)
    8000297a:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000297c:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002980:	1007f793          	andi	a5,a5,256
    80002984:	e7ad                	bnez	a5,800029ee <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80002986:	00003797          	auipc	a5,0x3
    8000298a:	4fa78793          	addi	a5,a5,1274 # 80005e80 <kernelvec>
    8000298e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002992:	fffff097          	auipc	ra,0xfffff
    80002996:	1a4080e7          	jalr	420(ra) # 80001b36 <myproc>
    8000299a:	84aa                	mv	s1,a0
  p->tf->epc = r_sepc();
    8000299c:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000299e:	14102773          	csrr	a4,sepc
    800029a2:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    800029a4:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    800029a8:	47a1                	li	a5,8
    800029aa:	06f71063          	bne	a4,a5,80002a0a <usertrap+0xa0>
    if (p->killed)
    800029ae:	5d1c                	lw	a5,56(a0)
    800029b0:	e7b9                	bnez	a5,800029fe <usertrap+0x94>
    p->tf->epc += 4;
    800029b2:	70b8                	ld	a4,96(s1)
    800029b4:	6f1c                	ld	a5,24(a4)
    800029b6:	0791                	addi	a5,a5,4
    800029b8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800029ba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800029be:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800029c2:	10079073          	csrw	sstatus,a5
    syscall();
    800029c6:	00000097          	auipc	ra,0x0
    800029ca:	39a080e7          	jalr	922(ra) # 80002d60 <syscall>
  if (p->killed)
    800029ce:	5c9c                	lw	a5,56(s1)
    800029d0:	12079363          	bnez	a5,80002af6 <usertrap+0x18c>
  usertrapret();
    800029d4:	00000097          	auipc	ra,0x0
    800029d8:	e1c080e7          	jalr	-484(ra) # 800027f0 <usertrapret>
}
    800029dc:	70e2                	ld	ra,56(sp)
    800029de:	7442                	ld	s0,48(sp)
    800029e0:	74a2                	ld	s1,40(sp)
    800029e2:	7902                	ld	s2,32(sp)
    800029e4:	69e2                	ld	s3,24(sp)
    800029e6:	6a42                	ld	s4,16(sp)
    800029e8:	6aa2                	ld	s5,8(sp)
    800029ea:	6121                	addi	sp,sp,64
    800029ec:	8082                	ret
    panic("usertrap: not from user mode");
    800029ee:	00006517          	auipc	a0,0x6
    800029f2:	b3a50513          	addi	a0,a0,-1222 # 80008528 <userret+0x498>
    800029f6:	ffffe097          	auipc	ra,0xffffe
    800029fa:	b64080e7          	jalr	-1180(ra) # 8000055a <panic>
      exit(-1);
    800029fe:	557d                	li	a0,-1
    80002a00:	fffff097          	auipc	ra,0xfffff
    80002a04:	7a8080e7          	jalr	1960(ra) # 800021a8 <exit>
    80002a08:	b76d                	j	800029b2 <usertrap+0x48>
  } else if ((which_dev = devintr()) != 0) {
    80002a0a:	00000097          	auipc	ra,0x0
    80002a0e:	eca080e7          	jalr	-310(ra) # 800028d4 <devintr>
    80002a12:	892a                	mv	s2,a0
    80002a14:	ed71                	bnez	a0,80002af0 <usertrap+0x186>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002a16:	14202773          	csrr	a4,scause
  } else if (r_scause() == 15 || r_scause() == 13) { // Page fault
    80002a1a:	47bd                	li	a5,15
    80002a1c:	00f70763          	beq	a4,a5,80002a2a <usertrap+0xc0>
    80002a20:	14202773          	csrr	a4,scause
    80002a24:	47b5                	li	a5,13
    80002a26:	08f71363          	bne	a4,a5,80002aac <usertrap+0x142>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002a2a:	143029f3          	csrr	s3,stval
    uint64 va = PGROUNDDOWN(r_stval());
    80002a2e:	777d                	lui	a4,0xfffff
    80002a30:	00e9f9b3          	and	s3,s3,a4
    if (va == PGROUNDDOWN(p->tf->sp - PGSIZE)) {
    80002a34:	70bc                	ld	a5,96(s1)
    80002a36:	7b9c                	ld	a5,48(a5)
    80002a38:	97ba                	add	a5,a5,a4
    80002a3a:	8ff9                	and	a5,a5,a4
    80002a3c:	07378263          	beq	a5,s3,80002aa0 <usertrap+0x136>
    if (va + PGSIZE > p->sz) {
    80002a40:	6785                	lui	a5,0x1
    80002a42:	97ce                	add	a5,a5,s3
    80002a44:	68b8                	ld	a4,80(s1)
    80002a46:	00f77463          	bgeu	a4,a5,80002a4e <usertrap+0xe4>
      p->killed = 1;
    80002a4a:	4785                	li	a5,1
    80002a4c:	dc9c                	sw	a5,56(s1)
    pagetable_t pagetable = p->pagetable;
    80002a4e:	0584ba83          	ld	s5,88(s1)
    char *mem = kalloc();
    80002a52:	ffffe097          	auipc	ra,0xffffe
    80002a56:	f2a080e7          	jalr	-214(ra) # 8000097c <kalloc>
    80002a5a:	8a2a                	mv	s4,a0
    if (mem == 0) {
    80002a5c:	c529                	beqz	a0,80002aa6 <usertrap+0x13c>
    if (p->killed != 1) {
    80002a5e:	5c98                	lw	a4,56(s1)
    80002a60:	4785                	li	a5,1
    80002a62:	08f70b63          	beq	a4,a5,80002af8 <usertrap+0x18e>
      memset(mem, 0, PGSIZE);
    80002a66:	6605                	lui	a2,0x1
    80002a68:	4581                	li	a1,0
    80002a6a:	ffffe097          	auipc	ra,0xffffe
    80002a6e:	314080e7          	jalr	788(ra) # 80000d7e <memset>
      if (mappages(pagetable, va, PGSIZE, (uint64)mem,
    80002a72:	4779                	li	a4,30
    80002a74:	86d2                	mv	a3,s4
    80002a76:	6605                	lui	a2,0x1
    80002a78:	85ce                	mv	a1,s3
    80002a7a:	8556                	mv	a0,s5
    80002a7c:	ffffe097          	auipc	ra,0xffffe
    80002a80:	7a0080e7          	jalr	1952(ra) # 8000121c <mappages>
    80002a84:	d529                	beqz	a0,800029ce <usertrap+0x64>
        kfree(mem);
    80002a86:	8552                	mv	a0,s4
    80002a88:	ffffe097          	auipc	ra,0xffffe
    80002a8c:	df8080e7          	jalr	-520(ra) # 80000880 <kfree>
        panic("usertrap: cannot map va to pa");
    80002a90:	00006517          	auipc	a0,0x6
    80002a94:	ab850513          	addi	a0,a0,-1352 # 80008548 <userret+0x4b8>
    80002a98:	ffffe097          	auipc	ra,0xffffe
    80002a9c:	ac2080e7          	jalr	-1342(ra) # 8000055a <panic>
      p->killed = 1;
    80002aa0:	4785                	li	a5,1
    80002aa2:	dc9c                	sw	a5,56(s1)
    80002aa4:	bf71                	j	80002a40 <usertrap+0xd6>
      p->killed = 1;
    80002aa6:	4785                	li	a5,1
    80002aa8:	dc9c                	sw	a5,56(s1)
    if (p->killed != 1) {
    80002aaa:	a0b9                	j	80002af8 <usertrap+0x18e>
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002aac:	142029f3          	csrr	s3,scause
    80002ab0:	14202573          	csrr	a0,scause
    printf("usertrap(): unexpected scause %p (%s) pid=%d\n", r_scause(),
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	c62080e7          	jalr	-926(ra) # 80002716 <scause_desc>
    80002abc:	862a                	mv	a2,a0
    80002abe:	40b4                	lw	a3,64(s1)
    80002ac0:	85ce                	mv	a1,s3
    80002ac2:	00006517          	auipc	a0,0x6
    80002ac6:	aa650513          	addi	a0,a0,-1370 # 80008568 <userret+0x4d8>
    80002aca:	ffffe097          	auipc	ra,0xffffe
    80002ace:	aea080e7          	jalr	-1302(ra) # 800005b4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002ad2:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ad6:	14302673          	csrr	a2,stval
    printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ada:	00006517          	auipc	a0,0x6
    80002ade:	abe50513          	addi	a0,a0,-1346 # 80008598 <userret+0x508>
    80002ae2:	ffffe097          	auipc	ra,0xffffe
    80002ae6:	ad2080e7          	jalr	-1326(ra) # 800005b4 <printf>
    p->killed = 1;
    80002aea:	4785                	li	a5,1
    80002aec:	dc9c                	sw	a5,56(s1)
    80002aee:	a029                	j	80002af8 <usertrap+0x18e>
  if (p->killed)
    80002af0:	5c9c                	lw	a5,56(s1)
    80002af2:	cb81                	beqz	a5,80002b02 <usertrap+0x198>
    80002af4:	a011                	j	80002af8 <usertrap+0x18e>
    80002af6:	4901                	li	s2,0
    exit(-1);
    80002af8:	557d                	li	a0,-1
    80002afa:	fffff097          	auipc	ra,0xfffff
    80002afe:	6ae080e7          	jalr	1710(ra) # 800021a8 <exit>
  if (which_dev == 2)
    80002b02:	4789                	li	a5,2
    80002b04:	ecf918e3          	bne	s2,a5,800029d4 <usertrap+0x6a>
    yield();
    80002b08:	fffff097          	auipc	ra,0xfffff
    80002b0c:	7ae080e7          	jalr	1966(ra) # 800022b6 <yield>
    80002b10:	b5d1                	j	800029d4 <usertrap+0x6a>

0000000080002b12 <kerneltrap>:
void kerneltrap() {
    80002b12:	7179                	addi	sp,sp,-48
    80002b14:	f406                	sd	ra,40(sp)
    80002b16:	f022                	sd	s0,32(sp)
    80002b18:	ec26                	sd	s1,24(sp)
    80002b1a:	e84a                	sd	s2,16(sp)
    80002b1c:	e44e                	sd	s3,8(sp)
    80002b1e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b20:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b24:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002b28:	142029f3          	csrr	s3,scause
  if ((sstatus & SSTATUS_SPP) == 0)
    80002b2c:	1004f793          	andi	a5,s1,256
    80002b30:	cb85                	beqz	a5,80002b60 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002b32:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002b36:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002b38:	ef85                	bnez	a5,80002b70 <kerneltrap+0x5e>
  if ((which_dev = devintr()) == 0) {
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	d9a080e7          	jalr	-614(ra) # 800028d4 <devintr>
    80002b42:	cd1d                	beqz	a0,80002b80 <kerneltrap+0x6e>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002b44:	4789                	li	a5,2
    80002b46:	08f50063          	beq	a0,a5,80002bc6 <kerneltrap+0xb4>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80002b4a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80002b4e:	10049073          	csrw	sstatus,s1
}
    80002b52:	70a2                	ld	ra,40(sp)
    80002b54:	7402                	ld	s0,32(sp)
    80002b56:	64e2                	ld	s1,24(sp)
    80002b58:	6942                	ld	s2,16(sp)
    80002b5a:	69a2                	ld	s3,8(sp)
    80002b5c:	6145                	addi	sp,sp,48
    80002b5e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002b60:	00006517          	auipc	a0,0x6
    80002b64:	a5850513          	addi	a0,a0,-1448 # 800085b8 <userret+0x528>
    80002b68:	ffffe097          	auipc	ra,0xffffe
    80002b6c:	9f2080e7          	jalr	-1550(ra) # 8000055a <panic>
    panic("kerneltrap: interrupts enabled");
    80002b70:	00006517          	auipc	a0,0x6
    80002b74:	a7050513          	addi	a0,a0,-1424 # 800085e0 <userret+0x550>
    80002b78:	ffffe097          	auipc	ra,0xffffe
    80002b7c:	9e2080e7          	jalr	-1566(ra) # 8000055a <panic>
    printf("scause %p (%s)\n", scause, scause_desc(scause));
    80002b80:	854e                	mv	a0,s3
    80002b82:	00000097          	auipc	ra,0x0
    80002b86:	b94080e7          	jalr	-1132(ra) # 80002716 <scause_desc>
    80002b8a:	862a                	mv	a2,a0
    80002b8c:	85ce                	mv	a1,s3
    80002b8e:	00006517          	auipc	a0,0x6
    80002b92:	a7250513          	addi	a0,a0,-1422 # 80008600 <userret+0x570>
    80002b96:	ffffe097          	auipc	ra,0xffffe
    80002b9a:	a1e080e7          	jalr	-1506(ra) # 800005b4 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002b9e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80002ba2:	14302673          	csrr	a2,stval
    printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80002ba6:	00006517          	auipc	a0,0x6
    80002baa:	a6a50513          	addi	a0,a0,-1430 # 80008610 <userret+0x580>
    80002bae:	ffffe097          	auipc	ra,0xffffe
    80002bb2:	a06080e7          	jalr	-1530(ra) # 800005b4 <printf>
    panic("kerneltrap");
    80002bb6:	00006517          	auipc	a0,0x6
    80002bba:	a7250513          	addi	a0,a0,-1422 # 80008628 <userret+0x598>
    80002bbe:	ffffe097          	auipc	ra,0xffffe
    80002bc2:	99c080e7          	jalr	-1636(ra) # 8000055a <panic>
  if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80002bc6:	fffff097          	auipc	ra,0xfffff
    80002bca:	f70080e7          	jalr	-144(ra) # 80001b36 <myproc>
    80002bce:	dd35                	beqz	a0,80002b4a <kerneltrap+0x38>
    80002bd0:	fffff097          	auipc	ra,0xfffff
    80002bd4:	f66080e7          	jalr	-154(ra) # 80001b36 <myproc>
    80002bd8:	5118                	lw	a4,32(a0)
    80002bda:	478d                	li	a5,3
    80002bdc:	f6f717e3          	bne	a4,a5,80002b4a <kerneltrap+0x38>
    yield();
    80002be0:	fffff097          	auipc	ra,0xfffff
    80002be4:	6d6080e7          	jalr	1750(ra) # 800022b6 <yield>
    80002be8:	b78d                	j	80002b4a <kerneltrap+0x38>

0000000080002bea <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80002bea:	1101                	addi	sp,sp,-32
    80002bec:	ec06                	sd	ra,24(sp)
    80002bee:	e822                	sd	s0,16(sp)
    80002bf0:	e426                	sd	s1,8(sp)
    80002bf2:	1000                	addi	s0,sp,32
    80002bf4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80002bf6:	fffff097          	auipc	ra,0xfffff
    80002bfa:	f40080e7          	jalr	-192(ra) # 80001b36 <myproc>
  switch (n) {
    80002bfe:	4795                	li	a5,5
    80002c00:	0497e163          	bltu	a5,s1,80002c42 <argraw+0x58>
    80002c04:	048a                	slli	s1,s1,0x2
    80002c06:	00006717          	auipc	a4,0x6
    80002c0a:	22270713          	addi	a4,a4,546 # 80008e28 <nointr_desc.1612+0x80>
    80002c0e:	94ba                	add	s1,s1,a4
    80002c10:	409c                	lw	a5,0(s1)
    80002c12:	97ba                	add	a5,a5,a4
    80002c14:	8782                	jr	a5
  case 0:
    return p->tf->a0;
    80002c16:	713c                	ld	a5,96(a0)
    80002c18:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->tf->a5;
  }
  panic("argraw");
  return -1;
}
    80002c1a:	60e2                	ld	ra,24(sp)
    80002c1c:	6442                	ld	s0,16(sp)
    80002c1e:	64a2                	ld	s1,8(sp)
    80002c20:	6105                	addi	sp,sp,32
    80002c22:	8082                	ret
    return p->tf->a1;
    80002c24:	713c                	ld	a5,96(a0)
    80002c26:	7fa8                	ld	a0,120(a5)
    80002c28:	bfcd                	j	80002c1a <argraw+0x30>
    return p->tf->a2;
    80002c2a:	713c                	ld	a5,96(a0)
    80002c2c:	63c8                	ld	a0,128(a5)
    80002c2e:	b7f5                	j	80002c1a <argraw+0x30>
    return p->tf->a3;
    80002c30:	713c                	ld	a5,96(a0)
    80002c32:	67c8                	ld	a0,136(a5)
    80002c34:	b7dd                	j	80002c1a <argraw+0x30>
    return p->tf->a4;
    80002c36:	713c                	ld	a5,96(a0)
    80002c38:	6bc8                	ld	a0,144(a5)
    80002c3a:	b7c5                	j	80002c1a <argraw+0x30>
    return p->tf->a5;
    80002c3c:	713c                	ld	a5,96(a0)
    80002c3e:	6fc8                	ld	a0,152(a5)
    80002c40:	bfe9                	j	80002c1a <argraw+0x30>
  panic("argraw");
    80002c42:	00006517          	auipc	a0,0x6
    80002c46:	bee50513          	addi	a0,a0,-1042 # 80008830 <userret+0x7a0>
    80002c4a:	ffffe097          	auipc	ra,0xffffe
    80002c4e:	910080e7          	jalr	-1776(ra) # 8000055a <panic>

0000000080002c52 <fetchaddr>:
{
    80002c52:	1101                	addi	sp,sp,-32
    80002c54:	ec06                	sd	ra,24(sp)
    80002c56:	e822                	sd	s0,16(sp)
    80002c58:	e426                	sd	s1,8(sp)
    80002c5a:	e04a                	sd	s2,0(sp)
    80002c5c:	1000                	addi	s0,sp,32
    80002c5e:	84aa                	mv	s1,a0
    80002c60:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002c62:	fffff097          	auipc	ra,0xfffff
    80002c66:	ed4080e7          	jalr	-300(ra) # 80001b36 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz)
    80002c6a:	693c                	ld	a5,80(a0)
    80002c6c:	02f4f863          	bgeu	s1,a5,80002c9c <fetchaddr+0x4a>
    80002c70:	00848713          	addi	a4,s1,8
    80002c74:	02e7e663          	bltu	a5,a4,80002ca0 <fetchaddr+0x4e>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002c78:	46a1                	li	a3,8
    80002c7a:	8626                	mv	a2,s1
    80002c7c:	85ca                	mv	a1,s2
    80002c7e:	6d28                	ld	a0,88(a0)
    80002c80:	fffff097          	auipc	ra,0xfffff
    80002c84:	c36080e7          	jalr	-970(ra) # 800018b6 <copyin>
    80002c88:	00a03533          	snez	a0,a0
    80002c8c:	40a00533          	neg	a0,a0
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6902                	ld	s2,0(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret
    return -1;
    80002c9c:	557d                	li	a0,-1
    80002c9e:	bfcd                	j	80002c90 <fetchaddr+0x3e>
    80002ca0:	557d                	li	a0,-1
    80002ca2:	b7fd                	j	80002c90 <fetchaddr+0x3e>

0000000080002ca4 <fetchstr>:
{
    80002ca4:	7179                	addi	sp,sp,-48
    80002ca6:	f406                	sd	ra,40(sp)
    80002ca8:	f022                	sd	s0,32(sp)
    80002caa:	ec26                	sd	s1,24(sp)
    80002cac:	e84a                	sd	s2,16(sp)
    80002cae:	e44e                	sd	s3,8(sp)
    80002cb0:	1800                	addi	s0,sp,48
    80002cb2:	892a                	mv	s2,a0
    80002cb4:	84ae                	mv	s1,a1
    80002cb6:	89b2                	mv	s3,a2
  struct proc *p = myproc();
    80002cb8:	fffff097          	auipc	ra,0xfffff
    80002cbc:	e7e080e7          	jalr	-386(ra) # 80001b36 <myproc>
  int err = copyinstr(p->pagetable, buf, addr, max);
    80002cc0:	86ce                	mv	a3,s3
    80002cc2:	864a                	mv	a2,s2
    80002cc4:	85a6                	mv	a1,s1
    80002cc6:	6d28                	ld	a0,88(a0)
    80002cc8:	fffff097          	auipc	ra,0xfffff
    80002ccc:	c7a080e7          	jalr	-902(ra) # 80001942 <copyinstr>
  if(err < 0)
    80002cd0:	00054763          	bltz	a0,80002cde <fetchstr+0x3a>
  return strlen(buf);
    80002cd4:	8526                	mv	a0,s1
    80002cd6:	ffffe097          	auipc	ra,0xffffe
    80002cda:	230080e7          	jalr	560(ra) # 80000f06 <strlen>
}
    80002cde:	70a2                	ld	ra,40(sp)
    80002ce0:	7402                	ld	s0,32(sp)
    80002ce2:	64e2                	ld	s1,24(sp)
    80002ce4:	6942                	ld	s2,16(sp)
    80002ce6:	69a2                	ld	s3,8(sp)
    80002ce8:	6145                	addi	sp,sp,48
    80002cea:	8082                	ret

0000000080002cec <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
    80002cec:	1101                	addi	sp,sp,-32
    80002cee:	ec06                	sd	ra,24(sp)
    80002cf0:	e822                	sd	s0,16(sp)
    80002cf2:	e426                	sd	s1,8(sp)
    80002cf4:	1000                	addi	s0,sp,32
    80002cf6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002cf8:	00000097          	auipc	ra,0x0
    80002cfc:	ef2080e7          	jalr	-270(ra) # 80002bea <argraw>
    80002d00:	c088                	sw	a0,0(s1)
  return 0;
}
    80002d02:	4501                	li	a0,0
    80002d04:	60e2                	ld	ra,24(sp)
    80002d06:	6442                	ld	s0,16(sp)
    80002d08:	64a2                	ld	s1,8(sp)
    80002d0a:	6105                	addi	sp,sp,32
    80002d0c:	8082                	ret

0000000080002d0e <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
int
argaddr(int n, uint64 *ip)
{
    80002d0e:	1101                	addi	sp,sp,-32
    80002d10:	ec06                	sd	ra,24(sp)
    80002d12:	e822                	sd	s0,16(sp)
    80002d14:	e426                	sd	s1,8(sp)
    80002d16:	1000                	addi	s0,sp,32
    80002d18:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80002d1a:	00000097          	auipc	ra,0x0
    80002d1e:	ed0080e7          	jalr	-304(ra) # 80002bea <argraw>
    80002d22:	e088                	sd	a0,0(s1)
  return 0;
}
    80002d24:	4501                	li	a0,0
    80002d26:	60e2                	ld	ra,24(sp)
    80002d28:	6442                	ld	s0,16(sp)
    80002d2a:	64a2                	ld	s1,8(sp)
    80002d2c:	6105                	addi	sp,sp,32
    80002d2e:	8082                	ret

0000000080002d30 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80002d30:	1101                	addi	sp,sp,-32
    80002d32:	ec06                	sd	ra,24(sp)
    80002d34:	e822                	sd	s0,16(sp)
    80002d36:	e426                	sd	s1,8(sp)
    80002d38:	e04a                	sd	s2,0(sp)
    80002d3a:	1000                	addi	s0,sp,32
    80002d3c:	84ae                	mv	s1,a1
    80002d3e:	8932                	mv	s2,a2
  *ip = argraw(n);
    80002d40:	00000097          	auipc	ra,0x0
    80002d44:	eaa080e7          	jalr	-342(ra) # 80002bea <argraw>
  uint64 addr;
  if(argaddr(n, &addr) < 0)
    return -1;
  return fetchstr(addr, buf, max);
    80002d48:	864a                	mv	a2,s2
    80002d4a:	85a6                	mv	a1,s1
    80002d4c:	00000097          	auipc	ra,0x0
    80002d50:	f58080e7          	jalr	-168(ra) # 80002ca4 <fetchstr>
}
    80002d54:	60e2                	ld	ra,24(sp)
    80002d56:	6442                	ld	s0,16(sp)
    80002d58:	64a2                	ld	s1,8(sp)
    80002d5a:	6902                	ld	s2,0(sp)
    80002d5c:	6105                	addi	sp,sp,32
    80002d5e:	8082                	ret

0000000080002d60 <syscall>:
[SYS_ntas]    sys_ntas,
};

void
syscall(void)
{
    80002d60:	1101                	addi	sp,sp,-32
    80002d62:	ec06                	sd	ra,24(sp)
    80002d64:	e822                	sd	s0,16(sp)
    80002d66:	e426                	sd	s1,8(sp)
    80002d68:	e04a                	sd	s2,0(sp)
    80002d6a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80002d6c:	fffff097          	auipc	ra,0xfffff
    80002d70:	dca080e7          	jalr	-566(ra) # 80001b36 <myproc>
    80002d74:	84aa                	mv	s1,a0

  num = p->tf->a7;
    80002d76:	06053903          	ld	s2,96(a0)
    80002d7a:	0a893783          	ld	a5,168(s2)
    80002d7e:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002d82:	37fd                	addiw	a5,a5,-1
    80002d84:	4755                	li	a4,21
    80002d86:	00f76f63          	bltu	a4,a5,80002da4 <syscall+0x44>
    80002d8a:	00369713          	slli	a4,a3,0x3
    80002d8e:	00006797          	auipc	a5,0x6
    80002d92:	0b278793          	addi	a5,a5,178 # 80008e40 <syscalls>
    80002d96:	97ba                	add	a5,a5,a4
    80002d98:	639c                	ld	a5,0(a5)
    80002d9a:	c789                	beqz	a5,80002da4 <syscall+0x44>
    p->tf->a0 = syscalls[num]();
    80002d9c:	9782                	jalr	a5
    80002d9e:	06a93823          	sd	a0,112(s2)
    80002da2:	a839                	j	80002dc0 <syscall+0x60>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002da4:	16048613          	addi	a2,s1,352
    80002da8:	40ac                	lw	a1,64(s1)
    80002daa:	00006517          	auipc	a0,0x6
    80002dae:	a8e50513          	addi	a0,a0,-1394 # 80008838 <userret+0x7a8>
    80002db2:	ffffe097          	auipc	ra,0xffffe
    80002db6:	802080e7          	jalr	-2046(ra) # 800005b4 <printf>
            p->pid, p->name, num);
    p->tf->a0 = -1;
    80002dba:	70bc                	ld	a5,96(s1)
    80002dbc:	577d                	li	a4,-1
    80002dbe:	fbb8                	sd	a4,112(a5)
  }
}
    80002dc0:	60e2                	ld	ra,24(sp)
    80002dc2:	6442                	ld	s0,16(sp)
    80002dc4:	64a2                	ld	s1,8(sp)
    80002dc6:	6902                	ld	s2,0(sp)
    80002dc8:	6105                	addi	sp,sp,32
    80002dca:	8082                	ret

0000000080002dcc <sys_exit>:
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "proc.h"

uint64 sys_exit(void) {
    80002dcc:	1101                	addi	sp,sp,-32
    80002dce:	ec06                	sd	ra,24(sp)
    80002dd0:	e822                	sd	s0,16(sp)
    80002dd2:	1000                	addi	s0,sp,32
  int n;
  if (argint(0, &n) < 0)
    80002dd4:	fec40593          	addi	a1,s0,-20
    80002dd8:	4501                	li	a0,0
    80002dda:	00000097          	auipc	ra,0x0
    80002dde:	f12080e7          	jalr	-238(ra) # 80002cec <argint>
    return -1;
    80002de2:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002de4:	00054963          	bltz	a0,80002df6 <sys_exit+0x2a>
  exit(n);
    80002de8:	fec42503          	lw	a0,-20(s0)
    80002dec:	fffff097          	auipc	ra,0xfffff
    80002df0:	3bc080e7          	jalr	956(ra) # 800021a8 <exit>
  return 0; // not reached
    80002df4:	4781                	li	a5,0
}
    80002df6:	853e                	mv	a0,a5
    80002df8:	60e2                	ld	ra,24(sp)
    80002dfa:	6442                	ld	s0,16(sp)
    80002dfc:	6105                	addi	sp,sp,32
    80002dfe:	8082                	ret

0000000080002e00 <sys_getpid>:

uint64 sys_getpid(void) { return myproc()->pid; }
    80002e00:	1141                	addi	sp,sp,-16
    80002e02:	e406                	sd	ra,8(sp)
    80002e04:	e022                	sd	s0,0(sp)
    80002e06:	0800                	addi	s0,sp,16
    80002e08:	fffff097          	auipc	ra,0xfffff
    80002e0c:	d2e080e7          	jalr	-722(ra) # 80001b36 <myproc>
    80002e10:	4128                	lw	a0,64(a0)
    80002e12:	60a2                	ld	ra,8(sp)
    80002e14:	6402                	ld	s0,0(sp)
    80002e16:	0141                	addi	sp,sp,16
    80002e18:	8082                	ret

0000000080002e1a <sys_fork>:

uint64 sys_fork(void) { return fork(); }
    80002e1a:	1141                	addi	sp,sp,-16
    80002e1c:	e406                	sd	ra,8(sp)
    80002e1e:	e022                	sd	s0,0(sp)
    80002e20:	0800                	addi	s0,sp,16
    80002e22:	fffff097          	auipc	ra,0xfffff
    80002e26:	07e080e7          	jalr	126(ra) # 80001ea0 <fork>
    80002e2a:	60a2                	ld	ra,8(sp)
    80002e2c:	6402                	ld	s0,0(sp)
    80002e2e:	0141                	addi	sp,sp,16
    80002e30:	8082                	ret

0000000080002e32 <sys_wait>:

uint64 sys_wait(void) {
    80002e32:	1101                	addi	sp,sp,-32
    80002e34:	ec06                	sd	ra,24(sp)
    80002e36:	e822                	sd	s0,16(sp)
    80002e38:	1000                	addi	s0,sp,32
  uint64 p;
  if (argaddr(0, &p) < 0)
    80002e3a:	fe840593          	addi	a1,s0,-24
    80002e3e:	4501                	li	a0,0
    80002e40:	00000097          	auipc	ra,0x0
    80002e44:	ece080e7          	jalr	-306(ra) # 80002d0e <argaddr>
    80002e48:	87aa                	mv	a5,a0
    return -1;
    80002e4a:	557d                	li	a0,-1
  if (argaddr(0, &p) < 0)
    80002e4c:	0007c863          	bltz	a5,80002e5c <sys_wait+0x2a>
  return wait(p);
    80002e50:	fe843503          	ld	a0,-24(s0)
    80002e54:	fffff097          	auipc	ra,0xfffff
    80002e58:	51c080e7          	jalr	1308(ra) # 80002370 <wait>
}
    80002e5c:	60e2                	ld	ra,24(sp)
    80002e5e:	6442                	ld	s0,16(sp)
    80002e60:	6105                	addi	sp,sp,32
    80002e62:	8082                	ret

0000000080002e64 <sys_sbrk>:

uint64 sys_sbrk(void) {
    80002e64:	7179                	addi	sp,sp,-48
    80002e66:	f406                	sd	ra,40(sp)
    80002e68:	f022                	sd	s0,32(sp)
    80002e6a:	ec26                	sd	s1,24(sp)
    80002e6c:	e84a                	sd	s2,16(sp)
    80002e6e:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;
  struct proc *p = myproc();
    80002e70:	fffff097          	auipc	ra,0xfffff
    80002e74:	cc6080e7          	jalr	-826(ra) # 80001b36 <myproc>
    80002e78:	84aa                	mv	s1,a0
  if (argint(0, &n) < 0) {
    80002e7a:	fdc40593          	addi	a1,s0,-36
    80002e7e:	4501                	li	a0,0
    80002e80:	00000097          	auipc	ra,0x0
    80002e84:	e6c080e7          	jalr	-404(ra) # 80002cec <argint>
    80002e88:	04054063          	bltz	a0,80002ec8 <sys_sbrk+0x64>
    return -1;
  }
  addr = p->sz;
    80002e8c:	0504b903          	ld	s2,80(s1)

  if (addr + n >= (MAXVA - 2 * PGSIZE) || addr + n < 0) {
    80002e90:	fdc42703          	lw	a4,-36(s0)
    80002e94:	01270633          	add	a2,a4,s2
    80002e98:	fdfff7b7          	lui	a5,0xfdfff
    80002e9c:	07ba                	slli	a5,a5,0xe
    80002e9e:	83e9                	srli	a5,a5,0x1a
    80002ea0:	02c7e663          	bltu	a5,a2,80002ecc <sys_sbrk+0x68>
    return -1;
  }

  if (n < 0) {
    80002ea4:	00074a63          	bltz	a4,80002eb8 <sys_sbrk+0x54>
    p->sz = uvmdealloc(p->pagetable, addr, addr + n);
  } else {
    p->sz = addr + n;
    80002ea8:	e8b0                	sd	a2,80(s1)
  }

  return addr;
}
    80002eaa:	854a                	mv	a0,s2
    80002eac:	70a2                	ld	ra,40(sp)
    80002eae:	7402                	ld	s0,32(sp)
    80002eb0:	64e2                	ld	s1,24(sp)
    80002eb2:	6942                	ld	s2,16(sp)
    80002eb4:	6145                	addi	sp,sp,48
    80002eb6:	8082                	ret
    p->sz = uvmdealloc(p->pagetable, addr, addr + n);
    80002eb8:	85ca                	mv	a1,s2
    80002eba:	6ca8                	ld	a0,88(s1)
    80002ebc:	ffffe097          	auipc	ra,0xffffe
    80002ec0:	656080e7          	jalr	1622(ra) # 80001512 <uvmdealloc>
    80002ec4:	e8a8                	sd	a0,80(s1)
    80002ec6:	b7d5                	j	80002eaa <sys_sbrk+0x46>
    return -1;
    80002ec8:	597d                	li	s2,-1
    80002eca:	b7c5                	j	80002eaa <sys_sbrk+0x46>
    return -1;
    80002ecc:	597d                	li	s2,-1
    80002ece:	bff1                	j	80002eaa <sys_sbrk+0x46>

0000000080002ed0 <sys_sleep>:

uint64 sys_sleep(void) {
    80002ed0:	7139                	addi	sp,sp,-64
    80002ed2:	fc06                	sd	ra,56(sp)
    80002ed4:	f822                	sd	s0,48(sp)
    80002ed6:	f426                	sd	s1,40(sp)
    80002ed8:	f04a                	sd	s2,32(sp)
    80002eda:	ec4e                	sd	s3,24(sp)
    80002edc:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    80002ede:	fcc40593          	addi	a1,s0,-52
    80002ee2:	4501                	li	a0,0
    80002ee4:	00000097          	auipc	ra,0x0
    80002ee8:	e08080e7          	jalr	-504(ra) # 80002cec <argint>
    return -1;
    80002eec:	57fd                	li	a5,-1
  if (argint(0, &n) < 0)
    80002eee:	06054563          	bltz	a0,80002f58 <sys_sleep+0x88>
  acquire(&tickslock);
    80002ef2:	00013517          	auipc	a0,0x13
    80002ef6:	bce50513          	addi	a0,a0,-1074 # 80015ac0 <tickslock>
    80002efa:	ffffe097          	auipc	ra,0xffffe
    80002efe:	bb6080e7          	jalr	-1098(ra) # 80000ab0 <acquire>
  ticks0 = ticks;
    80002f02:	00025917          	auipc	s2,0x25
    80002f06:	13e92903          	lw	s2,318(s2) # 80028040 <ticks>
  while (ticks - ticks0 < n) {
    80002f0a:	fcc42783          	lw	a5,-52(s0)
    80002f0e:	cf85                	beqz	a5,80002f46 <sys_sleep+0x76>
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002f10:	00013997          	auipc	s3,0x13
    80002f14:	bb098993          	addi	s3,s3,-1104 # 80015ac0 <tickslock>
    80002f18:	00025497          	auipc	s1,0x25
    80002f1c:	12848493          	addi	s1,s1,296 # 80028040 <ticks>
    if (myproc()->killed) {
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	c16080e7          	jalr	-1002(ra) # 80001b36 <myproc>
    80002f28:	5d1c                	lw	a5,56(a0)
    80002f2a:	ef9d                	bnez	a5,80002f68 <sys_sleep+0x98>
    sleep(&ticks, &tickslock);
    80002f2c:	85ce                	mv	a1,s3
    80002f2e:	8526                	mv	a0,s1
    80002f30:	fffff097          	auipc	ra,0xfffff
    80002f34:	3c2080e7          	jalr	962(ra) # 800022f2 <sleep>
  while (ticks - ticks0 < n) {
    80002f38:	409c                	lw	a5,0(s1)
    80002f3a:	412787bb          	subw	a5,a5,s2
    80002f3e:	fcc42703          	lw	a4,-52(s0)
    80002f42:	fce7efe3          	bltu	a5,a4,80002f20 <sys_sleep+0x50>
  }
  release(&tickslock);
    80002f46:	00013517          	auipc	a0,0x13
    80002f4a:	b7a50513          	addi	a0,a0,-1158 # 80015ac0 <tickslock>
    80002f4e:	ffffe097          	auipc	ra,0xffffe
    80002f52:	c32080e7          	jalr	-974(ra) # 80000b80 <release>
  return 0;
    80002f56:	4781                	li	a5,0
}
    80002f58:	853e                	mv	a0,a5
    80002f5a:	70e2                	ld	ra,56(sp)
    80002f5c:	7442                	ld	s0,48(sp)
    80002f5e:	74a2                	ld	s1,40(sp)
    80002f60:	7902                	ld	s2,32(sp)
    80002f62:	69e2                	ld	s3,24(sp)
    80002f64:	6121                	addi	sp,sp,64
    80002f66:	8082                	ret
      release(&tickslock);
    80002f68:	00013517          	auipc	a0,0x13
    80002f6c:	b5850513          	addi	a0,a0,-1192 # 80015ac0 <tickslock>
    80002f70:	ffffe097          	auipc	ra,0xffffe
    80002f74:	c10080e7          	jalr	-1008(ra) # 80000b80 <release>
      return -1;
    80002f78:	57fd                	li	a5,-1
    80002f7a:	bff9                	j	80002f58 <sys_sleep+0x88>

0000000080002f7c <sys_kill>:

uint64 sys_kill(void) {
    80002f7c:	1101                	addi	sp,sp,-32
    80002f7e:	ec06                	sd	ra,24(sp)
    80002f80:	e822                	sd	s0,16(sp)
    80002f82:	1000                	addi	s0,sp,32
  int pid;

  if (argint(0, &pid) < 0)
    80002f84:	fec40593          	addi	a1,s0,-20
    80002f88:	4501                	li	a0,0
    80002f8a:	00000097          	auipc	ra,0x0
    80002f8e:	d62080e7          	jalr	-670(ra) # 80002cec <argint>
    80002f92:	87aa                	mv	a5,a0
    return -1;
    80002f94:	557d                	li	a0,-1
  if (argint(0, &pid) < 0)
    80002f96:	0007c863          	bltz	a5,80002fa6 <sys_kill+0x2a>
  return kill(pid);
    80002f9a:	fec42503          	lw	a0,-20(s0)
    80002f9e:	fffff097          	auipc	ra,0xfffff
    80002fa2:	544080e7          	jalr	1348(ra) # 800024e2 <kill>
}
    80002fa6:	60e2                	ld	ra,24(sp)
    80002fa8:	6442                	ld	s0,16(sp)
    80002faa:	6105                	addi	sp,sp,32
    80002fac:	8082                	ret

0000000080002fae <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64 sys_uptime(void) {
    80002fae:	1101                	addi	sp,sp,-32
    80002fb0:	ec06                	sd	ra,24(sp)
    80002fb2:	e822                	sd	s0,16(sp)
    80002fb4:	e426                	sd	s1,8(sp)
    80002fb6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002fb8:	00013517          	auipc	a0,0x13
    80002fbc:	b0850513          	addi	a0,a0,-1272 # 80015ac0 <tickslock>
    80002fc0:	ffffe097          	auipc	ra,0xffffe
    80002fc4:	af0080e7          	jalr	-1296(ra) # 80000ab0 <acquire>
  xticks = ticks;
    80002fc8:	00025497          	auipc	s1,0x25
    80002fcc:	0784a483          	lw	s1,120(s1) # 80028040 <ticks>
  release(&tickslock);
    80002fd0:	00013517          	auipc	a0,0x13
    80002fd4:	af050513          	addi	a0,a0,-1296 # 80015ac0 <tickslock>
    80002fd8:	ffffe097          	auipc	ra,0xffffe
    80002fdc:	ba8080e7          	jalr	-1112(ra) # 80000b80 <release>
  return xticks;
}
    80002fe0:	02049513          	slli	a0,s1,0x20
    80002fe4:	9101                	srli	a0,a0,0x20
    80002fe6:	60e2                	ld	ra,24(sp)
    80002fe8:	6442                	ld	s0,16(sp)
    80002fea:	64a2                	ld	s1,8(sp)
    80002fec:	6105                	addi	sp,sp,32
    80002fee:	8082                	ret

0000000080002ff0 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002ff0:	7179                	addi	sp,sp,-48
    80002ff2:	f406                	sd	ra,40(sp)
    80002ff4:	f022                	sd	s0,32(sp)
    80002ff6:	ec26                	sd	s1,24(sp)
    80002ff8:	e84a                	sd	s2,16(sp)
    80002ffa:	e44e                	sd	s3,8(sp)
    80002ffc:	e052                	sd	s4,0(sp)
    80002ffe:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80003000:	00005597          	auipc	a1,0x5
    80003004:	2b858593          	addi	a1,a1,696 # 800082b8 <userret+0x228>
    80003008:	00013517          	auipc	a0,0x13
    8000300c:	ad850513          	addi	a0,a0,-1320 # 80015ae0 <bcache>
    80003010:	ffffe097          	auipc	ra,0xffffe
    80003014:	9cc080e7          	jalr	-1588(ra) # 800009dc <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80003018:	0001b797          	auipc	a5,0x1b
    8000301c:	ac878793          	addi	a5,a5,-1336 # 8001dae0 <bcache+0x8000>
    80003020:	0001b717          	auipc	a4,0x1b
    80003024:	e2070713          	addi	a4,a4,-480 # 8001de40 <bcache+0x8360>
    80003028:	3ae7b823          	sd	a4,944(a5)
  bcache.head.next = &bcache.head;
    8000302c:	3ae7bc23          	sd	a4,952(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003030:	00013497          	auipc	s1,0x13
    80003034:	ad048493          	addi	s1,s1,-1328 # 80015b00 <bcache+0x20>
    b->next = bcache.head.next;
    80003038:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000303a:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000303c:	00006a17          	auipc	s4,0x6
    80003040:	81ca0a13          	addi	s4,s4,-2020 # 80008858 <userret+0x7c8>
    b->next = bcache.head.next;
    80003044:	3b893783          	ld	a5,952(s2)
    80003048:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head;
    8000304a:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    8000304e:	85d2                	mv	a1,s4
    80003050:	01048513          	addi	a0,s1,16
    80003054:	00001097          	auipc	ra,0x1
    80003058:	5a0080e7          	jalr	1440(ra) # 800045f4 <initsleeplock>
    bcache.head.next->prev = b;
    8000305c:	3b893783          	ld	a5,952(s2)
    80003060:	eba4                	sd	s1,80(a5)
    bcache.head.next = b;
    80003062:	3a993c23          	sd	s1,952(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80003066:	46048493          	addi	s1,s1,1120
    8000306a:	fd349de3          	bne	s1,s3,80003044 <binit+0x54>
  }
}
    8000306e:	70a2                	ld	ra,40(sp)
    80003070:	7402                	ld	s0,32(sp)
    80003072:	64e2                	ld	s1,24(sp)
    80003074:	6942                	ld	s2,16(sp)
    80003076:	69a2                	ld	s3,8(sp)
    80003078:	6a02                	ld	s4,0(sp)
    8000307a:	6145                	addi	sp,sp,48
    8000307c:	8082                	ret

000000008000307e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000307e:	7179                	addi	sp,sp,-48
    80003080:	f406                	sd	ra,40(sp)
    80003082:	f022                	sd	s0,32(sp)
    80003084:	ec26                	sd	s1,24(sp)
    80003086:	e84a                	sd	s2,16(sp)
    80003088:	e44e                	sd	s3,8(sp)
    8000308a:	1800                	addi	s0,sp,48
    8000308c:	89aa                	mv	s3,a0
    8000308e:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80003090:	00013517          	auipc	a0,0x13
    80003094:	a5050513          	addi	a0,a0,-1456 # 80015ae0 <bcache>
    80003098:	ffffe097          	auipc	ra,0xffffe
    8000309c:	a18080e7          	jalr	-1512(ra) # 80000ab0 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800030a0:	0001b497          	auipc	s1,0x1b
    800030a4:	df84b483          	ld	s1,-520(s1) # 8001de98 <bcache+0x83b8>
    800030a8:	0001b797          	auipc	a5,0x1b
    800030ac:	d9878793          	addi	a5,a5,-616 # 8001de40 <bcache+0x8360>
    800030b0:	02f48f63          	beq	s1,a5,800030ee <bread+0x70>
    800030b4:	873e                	mv	a4,a5
    800030b6:	a021                	j	800030be <bread+0x40>
    800030b8:	6ca4                	ld	s1,88(s1)
    800030ba:	02e48a63          	beq	s1,a4,800030ee <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800030be:	449c                	lw	a5,8(s1)
    800030c0:	ff379ce3          	bne	a5,s3,800030b8 <bread+0x3a>
    800030c4:	44dc                	lw	a5,12(s1)
    800030c6:	ff2799e3          	bne	a5,s2,800030b8 <bread+0x3a>
      b->refcnt++;
    800030ca:	44bc                	lw	a5,72(s1)
    800030cc:	2785                	addiw	a5,a5,1
    800030ce:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    800030d0:	00013517          	auipc	a0,0x13
    800030d4:	a1050513          	addi	a0,a0,-1520 # 80015ae0 <bcache>
    800030d8:	ffffe097          	auipc	ra,0xffffe
    800030dc:	aa8080e7          	jalr	-1368(ra) # 80000b80 <release>
      acquiresleep(&b->lock);
    800030e0:	01048513          	addi	a0,s1,16
    800030e4:	00001097          	auipc	ra,0x1
    800030e8:	54a080e7          	jalr	1354(ra) # 8000462e <acquiresleep>
      return b;
    800030ec:	a8b9                	j	8000314a <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800030ee:	0001b497          	auipc	s1,0x1b
    800030f2:	da24b483          	ld	s1,-606(s1) # 8001de90 <bcache+0x83b0>
    800030f6:	0001b797          	auipc	a5,0x1b
    800030fa:	d4a78793          	addi	a5,a5,-694 # 8001de40 <bcache+0x8360>
    800030fe:	00f48863          	beq	s1,a5,8000310e <bread+0x90>
    80003102:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80003104:	44bc                	lw	a5,72(s1)
    80003106:	cf81                	beqz	a5,8000311e <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80003108:	68a4                	ld	s1,80(s1)
    8000310a:	fee49de3          	bne	s1,a4,80003104 <bread+0x86>
  panic("bget: no buffers");
    8000310e:	00005517          	auipc	a0,0x5
    80003112:	75250513          	addi	a0,a0,1874 # 80008860 <userret+0x7d0>
    80003116:	ffffd097          	auipc	ra,0xffffd
    8000311a:	444080e7          	jalr	1092(ra) # 8000055a <panic>
      b->dev = dev;
    8000311e:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80003122:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80003126:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000312a:	4785                	li	a5,1
    8000312c:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    8000312e:	00013517          	auipc	a0,0x13
    80003132:	9b250513          	addi	a0,a0,-1614 # 80015ae0 <bcache>
    80003136:	ffffe097          	auipc	ra,0xffffe
    8000313a:	a4a080e7          	jalr	-1462(ra) # 80000b80 <release>
      acquiresleep(&b->lock);
    8000313e:	01048513          	addi	a0,s1,16
    80003142:	00001097          	auipc	ra,0x1
    80003146:	4ec080e7          	jalr	1260(ra) # 8000462e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000314a:	409c                	lw	a5,0(s1)
    8000314c:	cb89                	beqz	a5,8000315e <bread+0xe0>
    virtio_disk_rw(b->dev, b, 0);
    b->valid = 1;
  }
  return b;
}
    8000314e:	8526                	mv	a0,s1
    80003150:	70a2                	ld	ra,40(sp)
    80003152:	7402                	ld	s0,32(sp)
    80003154:	64e2                	ld	s1,24(sp)
    80003156:	6942                	ld	s2,16(sp)
    80003158:	69a2                	ld	s3,8(sp)
    8000315a:	6145                	addi	sp,sp,48
    8000315c:	8082                	ret
    virtio_disk_rw(b->dev, b, 0);
    8000315e:	4601                	li	a2,0
    80003160:	85a6                	mv	a1,s1
    80003162:	4488                	lw	a0,8(s1)
    80003164:	00003097          	auipc	ra,0x3
    80003168:	0f6080e7          	jalr	246(ra) # 8000625a <virtio_disk_rw>
    b->valid = 1;
    8000316c:	4785                	li	a5,1
    8000316e:	c09c                	sw	a5,0(s1)
  return b;
    80003170:	bff9                	j	8000314e <bread+0xd0>

0000000080003172 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80003172:	1101                	addi	sp,sp,-32
    80003174:	ec06                	sd	ra,24(sp)
    80003176:	e822                	sd	s0,16(sp)
    80003178:	e426                	sd	s1,8(sp)
    8000317a:	1000                	addi	s0,sp,32
    8000317c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000317e:	0541                	addi	a0,a0,16
    80003180:	00001097          	auipc	ra,0x1
    80003184:	548080e7          	jalr	1352(ra) # 800046c8 <holdingsleep>
    80003188:	cd09                	beqz	a0,800031a2 <bwrite+0x30>
    panic("bwrite");
  virtio_disk_rw(b->dev, b, 1);
    8000318a:	4605                	li	a2,1
    8000318c:	85a6                	mv	a1,s1
    8000318e:	4488                	lw	a0,8(s1)
    80003190:	00003097          	auipc	ra,0x3
    80003194:	0ca080e7          	jalr	202(ra) # 8000625a <virtio_disk_rw>
}
    80003198:	60e2                	ld	ra,24(sp)
    8000319a:	6442                	ld	s0,16(sp)
    8000319c:	64a2                	ld	s1,8(sp)
    8000319e:	6105                	addi	sp,sp,32
    800031a0:	8082                	ret
    panic("bwrite");
    800031a2:	00005517          	auipc	a0,0x5
    800031a6:	6d650513          	addi	a0,a0,1750 # 80008878 <userret+0x7e8>
    800031aa:	ffffd097          	auipc	ra,0xffffd
    800031ae:	3b0080e7          	jalr	944(ra) # 8000055a <panic>

00000000800031b2 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
    800031b2:	1101                	addi	sp,sp,-32
    800031b4:	ec06                	sd	ra,24(sp)
    800031b6:	e822                	sd	s0,16(sp)
    800031b8:	e426                	sd	s1,8(sp)
    800031ba:	e04a                	sd	s2,0(sp)
    800031bc:	1000                	addi	s0,sp,32
    800031be:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800031c0:	01050913          	addi	s2,a0,16
    800031c4:	854a                	mv	a0,s2
    800031c6:	00001097          	auipc	ra,0x1
    800031ca:	502080e7          	jalr	1282(ra) # 800046c8 <holdingsleep>
    800031ce:	c92d                	beqz	a0,80003240 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800031d0:	854a                	mv	a0,s2
    800031d2:	00001097          	auipc	ra,0x1
    800031d6:	4b2080e7          	jalr	1202(ra) # 80004684 <releasesleep>

  acquire(&bcache.lock);
    800031da:	00013517          	auipc	a0,0x13
    800031de:	90650513          	addi	a0,a0,-1786 # 80015ae0 <bcache>
    800031e2:	ffffe097          	auipc	ra,0xffffe
    800031e6:	8ce080e7          	jalr	-1842(ra) # 80000ab0 <acquire>
  b->refcnt--;
    800031ea:	44bc                	lw	a5,72(s1)
    800031ec:	37fd                	addiw	a5,a5,-1
    800031ee:	0007871b          	sext.w	a4,a5
    800031f2:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    800031f4:	eb05                	bnez	a4,80003224 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800031f6:	6cbc                	ld	a5,88(s1)
    800031f8:	68b8                	ld	a4,80(s1)
    800031fa:	ebb8                	sd	a4,80(a5)
    b->prev->next = b->next;
    800031fc:	68bc                	ld	a5,80(s1)
    800031fe:	6cb8                	ld	a4,88(s1)
    80003200:	efb8                	sd	a4,88(a5)
    b->next = bcache.head.next;
    80003202:	0001b797          	auipc	a5,0x1b
    80003206:	8de78793          	addi	a5,a5,-1826 # 8001dae0 <bcache+0x8000>
    8000320a:	3b87b703          	ld	a4,952(a5)
    8000320e:	ecb8                	sd	a4,88(s1)
    b->prev = &bcache.head;
    80003210:	0001b717          	auipc	a4,0x1b
    80003214:	c3070713          	addi	a4,a4,-976 # 8001de40 <bcache+0x8360>
    80003218:	e8b8                	sd	a4,80(s1)
    bcache.head.next->prev = b;
    8000321a:	3b87b703          	ld	a4,952(a5)
    8000321e:	eb24                	sd	s1,80(a4)
    bcache.head.next = b;
    80003220:	3a97bc23          	sd	s1,952(a5)
  }
  
  release(&bcache.lock);
    80003224:	00013517          	auipc	a0,0x13
    80003228:	8bc50513          	addi	a0,a0,-1860 # 80015ae0 <bcache>
    8000322c:	ffffe097          	auipc	ra,0xffffe
    80003230:	954080e7          	jalr	-1708(ra) # 80000b80 <release>
}
    80003234:	60e2                	ld	ra,24(sp)
    80003236:	6442                	ld	s0,16(sp)
    80003238:	64a2                	ld	s1,8(sp)
    8000323a:	6902                	ld	s2,0(sp)
    8000323c:	6105                	addi	sp,sp,32
    8000323e:	8082                	ret
    panic("brelse");
    80003240:	00005517          	auipc	a0,0x5
    80003244:	64050513          	addi	a0,a0,1600 # 80008880 <userret+0x7f0>
    80003248:	ffffd097          	auipc	ra,0xffffd
    8000324c:	312080e7          	jalr	786(ra) # 8000055a <panic>

0000000080003250 <bpin>:

void
bpin(struct buf *b) {
    80003250:	1101                	addi	sp,sp,-32
    80003252:	ec06                	sd	ra,24(sp)
    80003254:	e822                	sd	s0,16(sp)
    80003256:	e426                	sd	s1,8(sp)
    80003258:	1000                	addi	s0,sp,32
    8000325a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000325c:	00013517          	auipc	a0,0x13
    80003260:	88450513          	addi	a0,a0,-1916 # 80015ae0 <bcache>
    80003264:	ffffe097          	auipc	ra,0xffffe
    80003268:	84c080e7          	jalr	-1972(ra) # 80000ab0 <acquire>
  b->refcnt++;
    8000326c:	44bc                	lw	a5,72(s1)
    8000326e:	2785                	addiw	a5,a5,1
    80003270:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    80003272:	00013517          	auipc	a0,0x13
    80003276:	86e50513          	addi	a0,a0,-1938 # 80015ae0 <bcache>
    8000327a:	ffffe097          	auipc	ra,0xffffe
    8000327e:	906080e7          	jalr	-1786(ra) # 80000b80 <release>
}
    80003282:	60e2                	ld	ra,24(sp)
    80003284:	6442                	ld	s0,16(sp)
    80003286:	64a2                	ld	s1,8(sp)
    80003288:	6105                	addi	sp,sp,32
    8000328a:	8082                	ret

000000008000328c <bunpin>:

void
bunpin(struct buf *b) {
    8000328c:	1101                	addi	sp,sp,-32
    8000328e:	ec06                	sd	ra,24(sp)
    80003290:	e822                	sd	s0,16(sp)
    80003292:	e426                	sd	s1,8(sp)
    80003294:	1000                	addi	s0,sp,32
    80003296:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80003298:	00013517          	auipc	a0,0x13
    8000329c:	84850513          	addi	a0,a0,-1976 # 80015ae0 <bcache>
    800032a0:	ffffe097          	auipc	ra,0xffffe
    800032a4:	810080e7          	jalr	-2032(ra) # 80000ab0 <acquire>
  b->refcnt--;
    800032a8:	44bc                	lw	a5,72(s1)
    800032aa:	37fd                	addiw	a5,a5,-1
    800032ac:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    800032ae:	00013517          	auipc	a0,0x13
    800032b2:	83250513          	addi	a0,a0,-1998 # 80015ae0 <bcache>
    800032b6:	ffffe097          	auipc	ra,0xffffe
    800032ba:	8ca080e7          	jalr	-1846(ra) # 80000b80 <release>
}
    800032be:	60e2                	ld	ra,24(sp)
    800032c0:	6442                	ld	s0,16(sp)
    800032c2:	64a2                	ld	s1,8(sp)
    800032c4:	6105                	addi	sp,sp,32
    800032c6:	8082                	ret

00000000800032c8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800032c8:	1101                	addi	sp,sp,-32
    800032ca:	ec06                	sd	ra,24(sp)
    800032cc:	e822                	sd	s0,16(sp)
    800032ce:	e426                	sd	s1,8(sp)
    800032d0:	e04a                	sd	s2,0(sp)
    800032d2:	1000                	addi	s0,sp,32
    800032d4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800032d6:	00d5d59b          	srliw	a1,a1,0xd
    800032da:	0001b797          	auipc	a5,0x1b
    800032de:	fe27a783          	lw	a5,-30(a5) # 8001e2bc <sb+0x1c>
    800032e2:	9dbd                	addw	a1,a1,a5
    800032e4:	00000097          	auipc	ra,0x0
    800032e8:	d9a080e7          	jalr	-614(ra) # 8000307e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800032ec:	0074f713          	andi	a4,s1,7
    800032f0:	4785                	li	a5,1
    800032f2:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    800032f6:	14ce                	slli	s1,s1,0x33
    800032f8:	90d9                	srli	s1,s1,0x36
    800032fa:	00950733          	add	a4,a0,s1
    800032fe:	06074703          	lbu	a4,96(a4)
    80003302:	00e7f6b3          	and	a3,a5,a4
    80003306:	c69d                	beqz	a3,80003334 <bfree+0x6c>
    80003308:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000330a:	94aa                	add	s1,s1,a0
    8000330c:	fff7c793          	not	a5,a5
    80003310:	8ff9                	and	a5,a5,a4
    80003312:	06f48023          	sb	a5,96(s1)
  log_write(bp);
    80003316:	00001097          	auipc	ra,0x1
    8000331a:	19e080e7          	jalr	414(ra) # 800044b4 <log_write>
  brelse(bp);
    8000331e:	854a                	mv	a0,s2
    80003320:	00000097          	auipc	ra,0x0
    80003324:	e92080e7          	jalr	-366(ra) # 800031b2 <brelse>
}
    80003328:	60e2                	ld	ra,24(sp)
    8000332a:	6442                	ld	s0,16(sp)
    8000332c:	64a2                	ld	s1,8(sp)
    8000332e:	6902                	ld	s2,0(sp)
    80003330:	6105                	addi	sp,sp,32
    80003332:	8082                	ret
    panic("freeing free block");
    80003334:	00005517          	auipc	a0,0x5
    80003338:	55450513          	addi	a0,a0,1364 # 80008888 <userret+0x7f8>
    8000333c:	ffffd097          	auipc	ra,0xffffd
    80003340:	21e080e7          	jalr	542(ra) # 8000055a <panic>

0000000080003344 <balloc>:
{
    80003344:	711d                	addi	sp,sp,-96
    80003346:	ec86                	sd	ra,88(sp)
    80003348:	e8a2                	sd	s0,80(sp)
    8000334a:	e4a6                	sd	s1,72(sp)
    8000334c:	e0ca                	sd	s2,64(sp)
    8000334e:	fc4e                	sd	s3,56(sp)
    80003350:	f852                	sd	s4,48(sp)
    80003352:	f456                	sd	s5,40(sp)
    80003354:	f05a                	sd	s6,32(sp)
    80003356:	ec5e                	sd	s7,24(sp)
    80003358:	e862                	sd	s8,16(sp)
    8000335a:	e466                	sd	s9,8(sp)
    8000335c:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    8000335e:	0001b797          	auipc	a5,0x1b
    80003362:	f467a783          	lw	a5,-186(a5) # 8001e2a4 <sb+0x4>
    80003366:	cbd1                	beqz	a5,800033fa <balloc+0xb6>
    80003368:	8baa                	mv	s7,a0
    8000336a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000336c:	0001bb17          	auipc	s6,0x1b
    80003370:	f34b0b13          	addi	s6,s6,-204 # 8001e2a0 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003374:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    80003376:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80003378:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000337a:	6c89                	lui	s9,0x2
    8000337c:	a831                	j	80003398 <balloc+0x54>
    brelse(bp);
    8000337e:	854a                	mv	a0,s2
    80003380:	00000097          	auipc	ra,0x0
    80003384:	e32080e7          	jalr	-462(ra) # 800031b2 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80003388:	015c87bb          	addw	a5,s9,s5
    8000338c:	00078a9b          	sext.w	s5,a5
    80003390:	004b2703          	lw	a4,4(s6)
    80003394:	06eaf363          	bgeu	s5,a4,800033fa <balloc+0xb6>
    bp = bread(dev, BBLOCK(b, sb));
    80003398:	41fad79b          	sraiw	a5,s5,0x1f
    8000339c:	0137d79b          	srliw	a5,a5,0x13
    800033a0:	015787bb          	addw	a5,a5,s5
    800033a4:	40d7d79b          	sraiw	a5,a5,0xd
    800033a8:	01cb2583          	lw	a1,28(s6)
    800033ac:	9dbd                	addw	a1,a1,a5
    800033ae:	855e                	mv	a0,s7
    800033b0:	00000097          	auipc	ra,0x0
    800033b4:	cce080e7          	jalr	-818(ra) # 8000307e <bread>
    800033b8:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033ba:	004b2503          	lw	a0,4(s6)
    800033be:	000a849b          	sext.w	s1,s5
    800033c2:	8662                	mv	a2,s8
    800033c4:	faa4fde3          	bgeu	s1,a0,8000337e <balloc+0x3a>
      m = 1 << (bi % 8);
    800033c8:	41f6579b          	sraiw	a5,a2,0x1f
    800033cc:	01d7d69b          	srliw	a3,a5,0x1d
    800033d0:	00c6873b          	addw	a4,a3,a2
    800033d4:	00777793          	andi	a5,a4,7
    800033d8:	9f95                	subw	a5,a5,a3
    800033da:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800033de:	4037571b          	sraiw	a4,a4,0x3
    800033e2:	00e906b3          	add	a3,s2,a4
    800033e6:	0606c683          	lbu	a3,96(a3)
    800033ea:	00d7f5b3          	and	a1,a5,a3
    800033ee:	cd91                	beqz	a1,8000340a <balloc+0xc6>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800033f0:	2605                	addiw	a2,a2,1
    800033f2:	2485                	addiw	s1,s1,1
    800033f4:	fd4618e3          	bne	a2,s4,800033c4 <balloc+0x80>
    800033f8:	b759                	j	8000337e <balloc+0x3a>
  panic("balloc: out of blocks");
    800033fa:	00005517          	auipc	a0,0x5
    800033fe:	4a650513          	addi	a0,a0,1190 # 800088a0 <userret+0x810>
    80003402:	ffffd097          	auipc	ra,0xffffd
    80003406:	158080e7          	jalr	344(ra) # 8000055a <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000340a:	974a                	add	a4,a4,s2
    8000340c:	8fd5                	or	a5,a5,a3
    8000340e:	06f70023          	sb	a5,96(a4)
        log_write(bp);
    80003412:	854a                	mv	a0,s2
    80003414:	00001097          	auipc	ra,0x1
    80003418:	0a0080e7          	jalr	160(ra) # 800044b4 <log_write>
        brelse(bp);
    8000341c:	854a                	mv	a0,s2
    8000341e:	00000097          	auipc	ra,0x0
    80003422:	d94080e7          	jalr	-620(ra) # 800031b2 <brelse>
  bp = bread(dev, bno);
    80003426:	85a6                	mv	a1,s1
    80003428:	855e                	mv	a0,s7
    8000342a:	00000097          	auipc	ra,0x0
    8000342e:	c54080e7          	jalr	-940(ra) # 8000307e <bread>
    80003432:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80003434:	40000613          	li	a2,1024
    80003438:	4581                	li	a1,0
    8000343a:	06050513          	addi	a0,a0,96
    8000343e:	ffffe097          	auipc	ra,0xffffe
    80003442:	940080e7          	jalr	-1728(ra) # 80000d7e <memset>
  log_write(bp);
    80003446:	854a                	mv	a0,s2
    80003448:	00001097          	auipc	ra,0x1
    8000344c:	06c080e7          	jalr	108(ra) # 800044b4 <log_write>
  brelse(bp);
    80003450:	854a                	mv	a0,s2
    80003452:	00000097          	auipc	ra,0x0
    80003456:	d60080e7          	jalr	-672(ra) # 800031b2 <brelse>
}
    8000345a:	8526                	mv	a0,s1
    8000345c:	60e6                	ld	ra,88(sp)
    8000345e:	6446                	ld	s0,80(sp)
    80003460:	64a6                	ld	s1,72(sp)
    80003462:	6906                	ld	s2,64(sp)
    80003464:	79e2                	ld	s3,56(sp)
    80003466:	7a42                	ld	s4,48(sp)
    80003468:	7aa2                	ld	s5,40(sp)
    8000346a:	7b02                	ld	s6,32(sp)
    8000346c:	6be2                	ld	s7,24(sp)
    8000346e:	6c42                	ld	s8,16(sp)
    80003470:	6ca2                	ld	s9,8(sp)
    80003472:	6125                	addi	sp,sp,96
    80003474:	8082                	ret

0000000080003476 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
    80003476:	7179                	addi	sp,sp,-48
    80003478:	f406                	sd	ra,40(sp)
    8000347a:	f022                	sd	s0,32(sp)
    8000347c:	ec26                	sd	s1,24(sp)
    8000347e:	e84a                	sd	s2,16(sp)
    80003480:	e44e                	sd	s3,8(sp)
    80003482:	e052                	sd	s4,0(sp)
    80003484:	1800                	addi	s0,sp,48
    80003486:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80003488:	47ad                	li	a5,11
    8000348a:	04b7fe63          	bgeu	a5,a1,800034e6 <bmap+0x70>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
    8000348e:	ff45849b          	addiw	s1,a1,-12
    80003492:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80003496:	0ff00793          	li	a5,255
    8000349a:	0ae7e363          	bltu	a5,a4,80003540 <bmap+0xca>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
    8000349e:	08852583          	lw	a1,136(a0)
    800034a2:	c5ad                	beqz	a1,8000350c <bmap+0x96>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    800034a4:	00092503          	lw	a0,0(s2)
    800034a8:	00000097          	auipc	ra,0x0
    800034ac:	bd6080e7          	jalr	-1066(ra) # 8000307e <bread>
    800034b0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800034b2:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800034b6:	02049593          	slli	a1,s1,0x20
    800034ba:	9181                	srli	a1,a1,0x20
    800034bc:	058a                	slli	a1,a1,0x2
    800034be:	00b784b3          	add	s1,a5,a1
    800034c2:	0004a983          	lw	s3,0(s1)
    800034c6:	04098d63          	beqz	s3,80003520 <bmap+0xaa>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
    800034ca:	8552                	mv	a0,s4
    800034cc:	00000097          	auipc	ra,0x0
    800034d0:	ce6080e7          	jalr	-794(ra) # 800031b2 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    800034d4:	854e                	mv	a0,s3
    800034d6:	70a2                	ld	ra,40(sp)
    800034d8:	7402                	ld	s0,32(sp)
    800034da:	64e2                	ld	s1,24(sp)
    800034dc:	6942                	ld	s2,16(sp)
    800034de:	69a2                	ld	s3,8(sp)
    800034e0:	6a02                	ld	s4,0(sp)
    800034e2:	6145                	addi	sp,sp,48
    800034e4:	8082                	ret
    if((addr = ip->addrs[bn]) == 0)
    800034e6:	02059493          	slli	s1,a1,0x20
    800034ea:	9081                	srli	s1,s1,0x20
    800034ec:	048a                	slli	s1,s1,0x2
    800034ee:	94aa                	add	s1,s1,a0
    800034f0:	0584a983          	lw	s3,88(s1)
    800034f4:	fe0990e3          	bnez	s3,800034d4 <bmap+0x5e>
      ip->addrs[bn] = addr = balloc(ip->dev);
    800034f8:	4108                	lw	a0,0(a0)
    800034fa:	00000097          	auipc	ra,0x0
    800034fe:	e4a080e7          	jalr	-438(ra) # 80003344 <balloc>
    80003502:	0005099b          	sext.w	s3,a0
    80003506:	0534ac23          	sw	s3,88(s1)
    8000350a:	b7e9                	j	800034d4 <bmap+0x5e>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    8000350c:	4108                	lw	a0,0(a0)
    8000350e:	00000097          	auipc	ra,0x0
    80003512:	e36080e7          	jalr	-458(ra) # 80003344 <balloc>
    80003516:	0005059b          	sext.w	a1,a0
    8000351a:	08b92423          	sw	a1,136(s2)
    8000351e:	b759                	j	800034a4 <bmap+0x2e>
      a[bn] = addr = balloc(ip->dev);
    80003520:	00092503          	lw	a0,0(s2)
    80003524:	00000097          	auipc	ra,0x0
    80003528:	e20080e7          	jalr	-480(ra) # 80003344 <balloc>
    8000352c:	0005099b          	sext.w	s3,a0
    80003530:	0134a023          	sw	s3,0(s1)
      log_write(bp);
    80003534:	8552                	mv	a0,s4
    80003536:	00001097          	auipc	ra,0x1
    8000353a:	f7e080e7          	jalr	-130(ra) # 800044b4 <log_write>
    8000353e:	b771                	j	800034ca <bmap+0x54>
  panic("bmap: out of range");
    80003540:	00005517          	auipc	a0,0x5
    80003544:	37850513          	addi	a0,a0,888 # 800088b8 <userret+0x828>
    80003548:	ffffd097          	auipc	ra,0xffffd
    8000354c:	012080e7          	jalr	18(ra) # 8000055a <panic>

0000000080003550 <iget>:
{
    80003550:	7179                	addi	sp,sp,-48
    80003552:	f406                	sd	ra,40(sp)
    80003554:	f022                	sd	s0,32(sp)
    80003556:	ec26                	sd	s1,24(sp)
    80003558:	e84a                	sd	s2,16(sp)
    8000355a:	e44e                	sd	s3,8(sp)
    8000355c:	e052                	sd	s4,0(sp)
    8000355e:	1800                	addi	s0,sp,48
    80003560:	89aa                	mv	s3,a0
    80003562:	8a2e                	mv	s4,a1
  acquire(&icache.lock);
    80003564:	0001b517          	auipc	a0,0x1b
    80003568:	d5c50513          	addi	a0,a0,-676 # 8001e2c0 <icache>
    8000356c:	ffffd097          	auipc	ra,0xffffd
    80003570:	544080e7          	jalr	1348(ra) # 80000ab0 <acquire>
  empty = 0;
    80003574:	4901                	li	s2,0
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    80003576:	0001b497          	auipc	s1,0x1b
    8000357a:	d6a48493          	addi	s1,s1,-662 # 8001e2e0 <icache+0x20>
    8000357e:	0001d697          	auipc	a3,0x1d
    80003582:	98268693          	addi	a3,a3,-1662 # 8001ff00 <log>
    80003586:	a039                	j	80003594 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80003588:	02090b63          	beqz	s2,800035be <iget+0x6e>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    8000358c:	09048493          	addi	s1,s1,144
    80003590:	02d48a63          	beq	s1,a3,800035c4 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80003594:	449c                	lw	a5,8(s1)
    80003596:	fef059e3          	blez	a5,80003588 <iget+0x38>
    8000359a:	4098                	lw	a4,0(s1)
    8000359c:	ff3716e3          	bne	a4,s3,80003588 <iget+0x38>
    800035a0:	40d8                	lw	a4,4(s1)
    800035a2:	ff4713e3          	bne	a4,s4,80003588 <iget+0x38>
      ip->ref++;
    800035a6:	2785                	addiw	a5,a5,1
    800035a8:	c49c                	sw	a5,8(s1)
      release(&icache.lock);
    800035aa:	0001b517          	auipc	a0,0x1b
    800035ae:	d1650513          	addi	a0,a0,-746 # 8001e2c0 <icache>
    800035b2:	ffffd097          	auipc	ra,0xffffd
    800035b6:	5ce080e7          	jalr	1486(ra) # 80000b80 <release>
      return ip;
    800035ba:	8926                	mv	s2,s1
    800035bc:	a03d                	j	800035ea <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800035be:	f7f9                	bnez	a5,8000358c <iget+0x3c>
    800035c0:	8926                	mv	s2,s1
    800035c2:	b7e9                	j	8000358c <iget+0x3c>
  if(empty == 0)
    800035c4:	02090c63          	beqz	s2,800035fc <iget+0xac>
  ip->dev = dev;
    800035c8:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    800035cc:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    800035d0:	4785                	li	a5,1
    800035d2:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    800035d6:	04092423          	sw	zero,72(s2)
  release(&icache.lock);
    800035da:	0001b517          	auipc	a0,0x1b
    800035de:	ce650513          	addi	a0,a0,-794 # 8001e2c0 <icache>
    800035e2:	ffffd097          	auipc	ra,0xffffd
    800035e6:	59e080e7          	jalr	1438(ra) # 80000b80 <release>
}
    800035ea:	854a                	mv	a0,s2
    800035ec:	70a2                	ld	ra,40(sp)
    800035ee:	7402                	ld	s0,32(sp)
    800035f0:	64e2                	ld	s1,24(sp)
    800035f2:	6942                	ld	s2,16(sp)
    800035f4:	69a2                	ld	s3,8(sp)
    800035f6:	6a02                	ld	s4,0(sp)
    800035f8:	6145                	addi	sp,sp,48
    800035fa:	8082                	ret
    panic("iget: no inodes");
    800035fc:	00005517          	auipc	a0,0x5
    80003600:	2d450513          	addi	a0,a0,724 # 800088d0 <userret+0x840>
    80003604:	ffffd097          	auipc	ra,0xffffd
    80003608:	f56080e7          	jalr	-170(ra) # 8000055a <panic>

000000008000360c <fsinit>:
fsinit(int dev) {
    8000360c:	7179                	addi	sp,sp,-48
    8000360e:	f406                	sd	ra,40(sp)
    80003610:	f022                	sd	s0,32(sp)
    80003612:	ec26                	sd	s1,24(sp)
    80003614:	e84a                	sd	s2,16(sp)
    80003616:	e44e                	sd	s3,8(sp)
    80003618:	1800                	addi	s0,sp,48
    8000361a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000361c:	4585                	li	a1,1
    8000361e:	00000097          	auipc	ra,0x0
    80003622:	a60080e7          	jalr	-1440(ra) # 8000307e <bread>
    80003626:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003628:	0001b997          	auipc	s3,0x1b
    8000362c:	c7898993          	addi	s3,s3,-904 # 8001e2a0 <sb>
    80003630:	02000613          	li	a2,32
    80003634:	06050593          	addi	a1,a0,96
    80003638:	854e                	mv	a0,s3
    8000363a:	ffffd097          	auipc	ra,0xffffd
    8000363e:	7a4080e7          	jalr	1956(ra) # 80000dde <memmove>
  brelse(bp);
    80003642:	8526                	mv	a0,s1
    80003644:	00000097          	auipc	ra,0x0
    80003648:	b6e080e7          	jalr	-1170(ra) # 800031b2 <brelse>
  if(sb.magic != FSMAGIC)
    8000364c:	0009a703          	lw	a4,0(s3)
    80003650:	102037b7          	lui	a5,0x10203
    80003654:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003658:	02f71263          	bne	a4,a5,8000367c <fsinit+0x70>
  initlog(dev, &sb);
    8000365c:	0001b597          	auipc	a1,0x1b
    80003660:	c4458593          	addi	a1,a1,-956 # 8001e2a0 <sb>
    80003664:	854a                	mv	a0,s2
    80003666:	00001097          	auipc	ra,0x1
    8000366a:	b38080e7          	jalr	-1224(ra) # 8000419e <initlog>
}
    8000366e:	70a2                	ld	ra,40(sp)
    80003670:	7402                	ld	s0,32(sp)
    80003672:	64e2                	ld	s1,24(sp)
    80003674:	6942                	ld	s2,16(sp)
    80003676:	69a2                	ld	s3,8(sp)
    80003678:	6145                	addi	sp,sp,48
    8000367a:	8082                	ret
    panic("invalid file system");
    8000367c:	00005517          	auipc	a0,0x5
    80003680:	26450513          	addi	a0,a0,612 # 800088e0 <userret+0x850>
    80003684:	ffffd097          	auipc	ra,0xffffd
    80003688:	ed6080e7          	jalr	-298(ra) # 8000055a <panic>

000000008000368c <iinit>:
{
    8000368c:	7179                	addi	sp,sp,-48
    8000368e:	f406                	sd	ra,40(sp)
    80003690:	f022                	sd	s0,32(sp)
    80003692:	ec26                	sd	s1,24(sp)
    80003694:	e84a                	sd	s2,16(sp)
    80003696:	e44e                	sd	s3,8(sp)
    80003698:	1800                	addi	s0,sp,48
  initlock(&icache.lock, "icache");
    8000369a:	00005597          	auipc	a1,0x5
    8000369e:	25e58593          	addi	a1,a1,606 # 800088f8 <userret+0x868>
    800036a2:	0001b517          	auipc	a0,0x1b
    800036a6:	c1e50513          	addi	a0,a0,-994 # 8001e2c0 <icache>
    800036aa:	ffffd097          	auipc	ra,0xffffd
    800036ae:	332080e7          	jalr	818(ra) # 800009dc <initlock>
  for(i = 0; i < NINODE; i++) {
    800036b2:	0001b497          	auipc	s1,0x1b
    800036b6:	c3e48493          	addi	s1,s1,-962 # 8001e2f0 <icache+0x30>
    800036ba:	0001d997          	auipc	s3,0x1d
    800036be:	85698993          	addi	s3,s3,-1962 # 8001ff10 <log+0x10>
    initsleeplock(&icache.inode[i].lock, "inode");
    800036c2:	00005917          	auipc	s2,0x5
    800036c6:	23e90913          	addi	s2,s2,574 # 80008900 <userret+0x870>
    800036ca:	85ca                	mv	a1,s2
    800036cc:	8526                	mv	a0,s1
    800036ce:	00001097          	auipc	ra,0x1
    800036d2:	f26080e7          	jalr	-218(ra) # 800045f4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800036d6:	09048493          	addi	s1,s1,144
    800036da:	ff3498e3          	bne	s1,s3,800036ca <iinit+0x3e>
}
    800036de:	70a2                	ld	ra,40(sp)
    800036e0:	7402                	ld	s0,32(sp)
    800036e2:	64e2                	ld	s1,24(sp)
    800036e4:	6942                	ld	s2,16(sp)
    800036e6:	69a2                	ld	s3,8(sp)
    800036e8:	6145                	addi	sp,sp,48
    800036ea:	8082                	ret

00000000800036ec <ialloc>:
{
    800036ec:	715d                	addi	sp,sp,-80
    800036ee:	e486                	sd	ra,72(sp)
    800036f0:	e0a2                	sd	s0,64(sp)
    800036f2:	fc26                	sd	s1,56(sp)
    800036f4:	f84a                	sd	s2,48(sp)
    800036f6:	f44e                	sd	s3,40(sp)
    800036f8:	f052                	sd	s4,32(sp)
    800036fa:	ec56                	sd	s5,24(sp)
    800036fc:	e85a                	sd	s6,16(sp)
    800036fe:	e45e                	sd	s7,8(sp)
    80003700:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80003702:	0001b717          	auipc	a4,0x1b
    80003706:	baa72703          	lw	a4,-1110(a4) # 8001e2ac <sb+0xc>
    8000370a:	4785                	li	a5,1
    8000370c:	04e7fa63          	bgeu	a5,a4,80003760 <ialloc+0x74>
    80003710:	8aaa                	mv	s5,a0
    80003712:	8bae                	mv	s7,a1
    80003714:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80003716:	0001ba17          	auipc	s4,0x1b
    8000371a:	b8aa0a13          	addi	s4,s4,-1142 # 8001e2a0 <sb>
    8000371e:	00048b1b          	sext.w	s6,s1
    80003722:	0044d593          	srli	a1,s1,0x4
    80003726:	018a2783          	lw	a5,24(s4)
    8000372a:	9dbd                	addw	a1,a1,a5
    8000372c:	8556                	mv	a0,s5
    8000372e:	00000097          	auipc	ra,0x0
    80003732:	950080e7          	jalr	-1712(ra) # 8000307e <bread>
    80003736:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80003738:	06050993          	addi	s3,a0,96
    8000373c:	00f4f793          	andi	a5,s1,15
    80003740:	079a                	slli	a5,a5,0x6
    80003742:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80003744:	00099783          	lh	a5,0(s3)
    80003748:	c785                	beqz	a5,80003770 <ialloc+0x84>
    brelse(bp);
    8000374a:	00000097          	auipc	ra,0x0
    8000374e:	a68080e7          	jalr	-1432(ra) # 800031b2 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80003752:	0485                	addi	s1,s1,1
    80003754:	00ca2703          	lw	a4,12(s4)
    80003758:	0004879b          	sext.w	a5,s1
    8000375c:	fce7e1e3          	bltu	a5,a4,8000371e <ialloc+0x32>
  panic("ialloc: no inodes");
    80003760:	00005517          	auipc	a0,0x5
    80003764:	1a850513          	addi	a0,a0,424 # 80008908 <userret+0x878>
    80003768:	ffffd097          	auipc	ra,0xffffd
    8000376c:	df2080e7          	jalr	-526(ra) # 8000055a <panic>
      memset(dip, 0, sizeof(*dip));
    80003770:	04000613          	li	a2,64
    80003774:	4581                	li	a1,0
    80003776:	854e                	mv	a0,s3
    80003778:	ffffd097          	auipc	ra,0xffffd
    8000377c:	606080e7          	jalr	1542(ra) # 80000d7e <memset>
      dip->type = type;
    80003780:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80003784:	854a                	mv	a0,s2
    80003786:	00001097          	auipc	ra,0x1
    8000378a:	d2e080e7          	jalr	-722(ra) # 800044b4 <log_write>
      brelse(bp);
    8000378e:	854a                	mv	a0,s2
    80003790:	00000097          	auipc	ra,0x0
    80003794:	a22080e7          	jalr	-1502(ra) # 800031b2 <brelse>
      return iget(dev, inum);
    80003798:	85da                	mv	a1,s6
    8000379a:	8556                	mv	a0,s5
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	db4080e7          	jalr	-588(ra) # 80003550 <iget>
}
    800037a4:	60a6                	ld	ra,72(sp)
    800037a6:	6406                	ld	s0,64(sp)
    800037a8:	74e2                	ld	s1,56(sp)
    800037aa:	7942                	ld	s2,48(sp)
    800037ac:	79a2                	ld	s3,40(sp)
    800037ae:	7a02                	ld	s4,32(sp)
    800037b0:	6ae2                	ld	s5,24(sp)
    800037b2:	6b42                	ld	s6,16(sp)
    800037b4:	6ba2                	ld	s7,8(sp)
    800037b6:	6161                	addi	sp,sp,80
    800037b8:	8082                	ret

00000000800037ba <iupdate>:
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800037c8:	415c                	lw	a5,4(a0)
    800037ca:	0047d79b          	srliw	a5,a5,0x4
    800037ce:	0001b597          	auipc	a1,0x1b
    800037d2:	aea5a583          	lw	a1,-1302(a1) # 8001e2b8 <sb+0x18>
    800037d6:	9dbd                	addw	a1,a1,a5
    800037d8:	4108                	lw	a0,0(a0)
    800037da:	00000097          	auipc	ra,0x0
    800037de:	8a4080e7          	jalr	-1884(ra) # 8000307e <bread>
    800037e2:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800037e4:	06050793          	addi	a5,a0,96
    800037e8:	40c8                	lw	a0,4(s1)
    800037ea:	893d                	andi	a0,a0,15
    800037ec:	051a                	slli	a0,a0,0x6
    800037ee:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    800037f0:	04c49703          	lh	a4,76(s1)
    800037f4:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    800037f8:	04e49703          	lh	a4,78(s1)
    800037fc:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80003800:	05049703          	lh	a4,80(s1)
    80003804:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80003808:	05249703          	lh	a4,82(s1)
    8000380c:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80003810:	48f8                	lw	a4,84(s1)
    80003812:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80003814:	03400613          	li	a2,52
    80003818:	05848593          	addi	a1,s1,88
    8000381c:	0531                	addi	a0,a0,12
    8000381e:	ffffd097          	auipc	ra,0xffffd
    80003822:	5c0080e7          	jalr	1472(ra) # 80000dde <memmove>
  log_write(bp);
    80003826:	854a                	mv	a0,s2
    80003828:	00001097          	auipc	ra,0x1
    8000382c:	c8c080e7          	jalr	-884(ra) # 800044b4 <log_write>
  brelse(bp);
    80003830:	854a                	mv	a0,s2
    80003832:	00000097          	auipc	ra,0x0
    80003836:	980080e7          	jalr	-1664(ra) # 800031b2 <brelse>
}
    8000383a:	60e2                	ld	ra,24(sp)
    8000383c:	6442                	ld	s0,16(sp)
    8000383e:	64a2                	ld	s1,8(sp)
    80003840:	6902                	ld	s2,0(sp)
    80003842:	6105                	addi	sp,sp,32
    80003844:	8082                	ret

0000000080003846 <idup>:
{
    80003846:	1101                	addi	sp,sp,-32
    80003848:	ec06                	sd	ra,24(sp)
    8000384a:	e822                	sd	s0,16(sp)
    8000384c:	e426                	sd	s1,8(sp)
    8000384e:	1000                	addi	s0,sp,32
    80003850:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    80003852:	0001b517          	auipc	a0,0x1b
    80003856:	a6e50513          	addi	a0,a0,-1426 # 8001e2c0 <icache>
    8000385a:	ffffd097          	auipc	ra,0xffffd
    8000385e:	256080e7          	jalr	598(ra) # 80000ab0 <acquire>
  ip->ref++;
    80003862:	449c                	lw	a5,8(s1)
    80003864:	2785                	addiw	a5,a5,1
    80003866:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    80003868:	0001b517          	auipc	a0,0x1b
    8000386c:	a5850513          	addi	a0,a0,-1448 # 8001e2c0 <icache>
    80003870:	ffffd097          	auipc	ra,0xffffd
    80003874:	310080e7          	jalr	784(ra) # 80000b80 <release>
}
    80003878:	8526                	mv	a0,s1
    8000387a:	60e2                	ld	ra,24(sp)
    8000387c:	6442                	ld	s0,16(sp)
    8000387e:	64a2                	ld	s1,8(sp)
    80003880:	6105                	addi	sp,sp,32
    80003882:	8082                	ret

0000000080003884 <ilock>:
{
    80003884:	1101                	addi	sp,sp,-32
    80003886:	ec06                	sd	ra,24(sp)
    80003888:	e822                	sd	s0,16(sp)
    8000388a:	e426                	sd	s1,8(sp)
    8000388c:	e04a                	sd	s2,0(sp)
    8000388e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80003890:	c115                	beqz	a0,800038b4 <ilock+0x30>
    80003892:	84aa                	mv	s1,a0
    80003894:	451c                	lw	a5,8(a0)
    80003896:	00f05f63          	blez	a5,800038b4 <ilock+0x30>
  acquiresleep(&ip->lock);
    8000389a:	0541                	addi	a0,a0,16
    8000389c:	00001097          	auipc	ra,0x1
    800038a0:	d92080e7          	jalr	-622(ra) # 8000462e <acquiresleep>
  if(ip->valid == 0){
    800038a4:	44bc                	lw	a5,72(s1)
    800038a6:	cf99                	beqz	a5,800038c4 <ilock+0x40>
}
    800038a8:	60e2                	ld	ra,24(sp)
    800038aa:	6442                	ld	s0,16(sp)
    800038ac:	64a2                	ld	s1,8(sp)
    800038ae:	6902                	ld	s2,0(sp)
    800038b0:	6105                	addi	sp,sp,32
    800038b2:	8082                	ret
    panic("ilock");
    800038b4:	00005517          	auipc	a0,0x5
    800038b8:	06c50513          	addi	a0,a0,108 # 80008920 <userret+0x890>
    800038bc:	ffffd097          	auipc	ra,0xffffd
    800038c0:	c9e080e7          	jalr	-866(ra) # 8000055a <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800038c4:	40dc                	lw	a5,4(s1)
    800038c6:	0047d79b          	srliw	a5,a5,0x4
    800038ca:	0001b597          	auipc	a1,0x1b
    800038ce:	9ee5a583          	lw	a1,-1554(a1) # 8001e2b8 <sb+0x18>
    800038d2:	9dbd                	addw	a1,a1,a5
    800038d4:	4088                	lw	a0,0(s1)
    800038d6:	fffff097          	auipc	ra,0xfffff
    800038da:	7a8080e7          	jalr	1960(ra) # 8000307e <bread>
    800038de:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800038e0:	06050593          	addi	a1,a0,96
    800038e4:	40dc                	lw	a5,4(s1)
    800038e6:	8bbd                	andi	a5,a5,15
    800038e8:	079a                	slli	a5,a5,0x6
    800038ea:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800038ec:	00059783          	lh	a5,0(a1)
    800038f0:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    800038f4:	00259783          	lh	a5,2(a1)
    800038f8:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    800038fc:	00459783          	lh	a5,4(a1)
    80003900:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80003904:	00659783          	lh	a5,6(a1)
    80003908:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    8000390c:	459c                	lw	a5,8(a1)
    8000390e:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80003910:	03400613          	li	a2,52
    80003914:	05b1                	addi	a1,a1,12
    80003916:	05848513          	addi	a0,s1,88
    8000391a:	ffffd097          	auipc	ra,0xffffd
    8000391e:	4c4080e7          	jalr	1220(ra) # 80000dde <memmove>
    brelse(bp);
    80003922:	854a                	mv	a0,s2
    80003924:	00000097          	auipc	ra,0x0
    80003928:	88e080e7          	jalr	-1906(ra) # 800031b2 <brelse>
    ip->valid = 1;
    8000392c:	4785                	li	a5,1
    8000392e:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80003930:	04c49783          	lh	a5,76(s1)
    80003934:	fbb5                	bnez	a5,800038a8 <ilock+0x24>
      panic("ilock: no type");
    80003936:	00005517          	auipc	a0,0x5
    8000393a:	ff250513          	addi	a0,a0,-14 # 80008928 <userret+0x898>
    8000393e:	ffffd097          	auipc	ra,0xffffd
    80003942:	c1c080e7          	jalr	-996(ra) # 8000055a <panic>

0000000080003946 <iunlock>:
{
    80003946:	1101                	addi	sp,sp,-32
    80003948:	ec06                	sd	ra,24(sp)
    8000394a:	e822                	sd	s0,16(sp)
    8000394c:	e426                	sd	s1,8(sp)
    8000394e:	e04a                	sd	s2,0(sp)
    80003950:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003952:	c905                	beqz	a0,80003982 <iunlock+0x3c>
    80003954:	84aa                	mv	s1,a0
    80003956:	01050913          	addi	s2,a0,16
    8000395a:	854a                	mv	a0,s2
    8000395c:	00001097          	auipc	ra,0x1
    80003960:	d6c080e7          	jalr	-660(ra) # 800046c8 <holdingsleep>
    80003964:	cd19                	beqz	a0,80003982 <iunlock+0x3c>
    80003966:	449c                	lw	a5,8(s1)
    80003968:	00f05d63          	blez	a5,80003982 <iunlock+0x3c>
  releasesleep(&ip->lock);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00001097          	auipc	ra,0x1
    80003972:	d16080e7          	jalr	-746(ra) # 80004684 <releasesleep>
}
    80003976:	60e2                	ld	ra,24(sp)
    80003978:	6442                	ld	s0,16(sp)
    8000397a:	64a2                	ld	s1,8(sp)
    8000397c:	6902                	ld	s2,0(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret
    panic("iunlock");
    80003982:	00005517          	auipc	a0,0x5
    80003986:	fb650513          	addi	a0,a0,-74 # 80008938 <userret+0x8a8>
    8000398a:	ffffd097          	auipc	ra,0xffffd
    8000398e:	bd0080e7          	jalr	-1072(ra) # 8000055a <panic>

0000000080003992 <iput>:
{
    80003992:	7139                	addi	sp,sp,-64
    80003994:	fc06                	sd	ra,56(sp)
    80003996:	f822                	sd	s0,48(sp)
    80003998:	f426                	sd	s1,40(sp)
    8000399a:	f04a                	sd	s2,32(sp)
    8000399c:	ec4e                	sd	s3,24(sp)
    8000399e:	e852                	sd	s4,16(sp)
    800039a0:	e456                	sd	s5,8(sp)
    800039a2:	0080                	addi	s0,sp,64
    800039a4:	84aa                	mv	s1,a0
  acquire(&icache.lock);
    800039a6:	0001b517          	auipc	a0,0x1b
    800039aa:	91a50513          	addi	a0,a0,-1766 # 8001e2c0 <icache>
    800039ae:	ffffd097          	auipc	ra,0xffffd
    800039b2:	102080e7          	jalr	258(ra) # 80000ab0 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039b6:	4498                	lw	a4,8(s1)
    800039b8:	4785                	li	a5,1
    800039ba:	02f70663          	beq	a4,a5,800039e6 <iput+0x54>
  ip->ref--;
    800039be:	449c                	lw	a5,8(s1)
    800039c0:	37fd                	addiw	a5,a5,-1
    800039c2:	c49c                	sw	a5,8(s1)
  release(&icache.lock);
    800039c4:	0001b517          	auipc	a0,0x1b
    800039c8:	8fc50513          	addi	a0,a0,-1796 # 8001e2c0 <icache>
    800039cc:	ffffd097          	auipc	ra,0xffffd
    800039d0:	1b4080e7          	jalr	436(ra) # 80000b80 <release>
}
    800039d4:	70e2                	ld	ra,56(sp)
    800039d6:	7442                	ld	s0,48(sp)
    800039d8:	74a2                	ld	s1,40(sp)
    800039da:	7902                	ld	s2,32(sp)
    800039dc:	69e2                	ld	s3,24(sp)
    800039de:	6a42                	ld	s4,16(sp)
    800039e0:	6aa2                	ld	s5,8(sp)
    800039e2:	6121                	addi	sp,sp,64
    800039e4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800039e6:	44bc                	lw	a5,72(s1)
    800039e8:	dbf9                	beqz	a5,800039be <iput+0x2c>
    800039ea:	05249783          	lh	a5,82(s1)
    800039ee:	fbe1                	bnez	a5,800039be <iput+0x2c>
    acquiresleep(&ip->lock);
    800039f0:	01048a13          	addi	s4,s1,16
    800039f4:	8552                	mv	a0,s4
    800039f6:	00001097          	auipc	ra,0x1
    800039fa:	c38080e7          	jalr	-968(ra) # 8000462e <acquiresleep>
    release(&icache.lock);
    800039fe:	0001b517          	auipc	a0,0x1b
    80003a02:	8c250513          	addi	a0,a0,-1854 # 8001e2c0 <icache>
    80003a06:	ffffd097          	auipc	ra,0xffffd
    80003a0a:	17a080e7          	jalr	378(ra) # 80000b80 <release>
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80003a0e:	05848913          	addi	s2,s1,88
    80003a12:	08848993          	addi	s3,s1,136
    80003a16:	a819                	j	80003a2c <iput+0x9a>
    if(ip->addrs[i]){
      bfree(ip->dev, ip->addrs[i]);
    80003a18:	4088                	lw	a0,0(s1)
    80003a1a:	00000097          	auipc	ra,0x0
    80003a1e:	8ae080e7          	jalr	-1874(ra) # 800032c8 <bfree>
      ip->addrs[i] = 0;
    80003a22:	00092023          	sw	zero,0(s2)
  for(i = 0; i < NDIRECT; i++){
    80003a26:	0911                	addi	s2,s2,4
    80003a28:	01390663          	beq	s2,s3,80003a34 <iput+0xa2>
    if(ip->addrs[i]){
    80003a2c:	00092583          	lw	a1,0(s2)
    80003a30:	d9fd                	beqz	a1,80003a26 <iput+0x94>
    80003a32:	b7dd                	j	80003a18 <iput+0x86>
    }
  }

  if(ip->addrs[NDIRECT]){
    80003a34:	0884a583          	lw	a1,136(s1)
    80003a38:	ed9d                	bnez	a1,80003a76 <iput+0xe4>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003a3a:	0404aa23          	sw	zero,84(s1)
  iupdate(ip);
    80003a3e:	8526                	mv	a0,s1
    80003a40:	00000097          	auipc	ra,0x0
    80003a44:	d7a080e7          	jalr	-646(ra) # 800037ba <iupdate>
    ip->type = 0;
    80003a48:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80003a4c:	8526                	mv	a0,s1
    80003a4e:	00000097          	auipc	ra,0x0
    80003a52:	d6c080e7          	jalr	-660(ra) # 800037ba <iupdate>
    ip->valid = 0;
    80003a56:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    80003a5a:	8552                	mv	a0,s4
    80003a5c:	00001097          	auipc	ra,0x1
    80003a60:	c28080e7          	jalr	-984(ra) # 80004684 <releasesleep>
    acquire(&icache.lock);
    80003a64:	0001b517          	auipc	a0,0x1b
    80003a68:	85c50513          	addi	a0,a0,-1956 # 8001e2c0 <icache>
    80003a6c:	ffffd097          	auipc	ra,0xffffd
    80003a70:	044080e7          	jalr	68(ra) # 80000ab0 <acquire>
    80003a74:	b7a9                	j	800039be <iput+0x2c>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80003a76:	4088                	lw	a0,0(s1)
    80003a78:	fffff097          	auipc	ra,0xfffff
    80003a7c:	606080e7          	jalr	1542(ra) # 8000307e <bread>
    80003a80:	8aaa                	mv	s5,a0
    for(j = 0; j < NINDIRECT; j++){
    80003a82:	06050913          	addi	s2,a0,96
    80003a86:	46050993          	addi	s3,a0,1120
    80003a8a:	a809                	j	80003a9c <iput+0x10a>
        bfree(ip->dev, a[j]);
    80003a8c:	4088                	lw	a0,0(s1)
    80003a8e:	00000097          	auipc	ra,0x0
    80003a92:	83a080e7          	jalr	-1990(ra) # 800032c8 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80003a96:	0911                	addi	s2,s2,4
    80003a98:	01390663          	beq	s2,s3,80003aa4 <iput+0x112>
      if(a[j])
    80003a9c:	00092583          	lw	a1,0(s2)
    80003aa0:	d9fd                	beqz	a1,80003a96 <iput+0x104>
    80003aa2:	b7ed                	j	80003a8c <iput+0xfa>
    brelse(bp);
    80003aa4:	8556                	mv	a0,s5
    80003aa6:	fffff097          	auipc	ra,0xfffff
    80003aaa:	70c080e7          	jalr	1804(ra) # 800031b2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80003aae:	0884a583          	lw	a1,136(s1)
    80003ab2:	4088                	lw	a0,0(s1)
    80003ab4:	00000097          	auipc	ra,0x0
    80003ab8:	814080e7          	jalr	-2028(ra) # 800032c8 <bfree>
    ip->addrs[NDIRECT] = 0;
    80003abc:	0804a423          	sw	zero,136(s1)
    80003ac0:	bfad                	j	80003a3a <iput+0xa8>

0000000080003ac2 <iunlockput>:
{
    80003ac2:	1101                	addi	sp,sp,-32
    80003ac4:	ec06                	sd	ra,24(sp)
    80003ac6:	e822                	sd	s0,16(sp)
    80003ac8:	e426                	sd	s1,8(sp)
    80003aca:	1000                	addi	s0,sp,32
    80003acc:	84aa                	mv	s1,a0
  iunlock(ip);
    80003ace:	00000097          	auipc	ra,0x0
    80003ad2:	e78080e7          	jalr	-392(ra) # 80003946 <iunlock>
  iput(ip);
    80003ad6:	8526                	mv	a0,s1
    80003ad8:	00000097          	auipc	ra,0x0
    80003adc:	eba080e7          	jalr	-326(ra) # 80003992 <iput>
}
    80003ae0:	60e2                	ld	ra,24(sp)
    80003ae2:	6442                	ld	s0,16(sp)
    80003ae4:	64a2                	ld	s1,8(sp)
    80003ae6:	6105                	addi	sp,sp,32
    80003ae8:	8082                	ret

0000000080003aea <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003aea:	1141                	addi	sp,sp,-16
    80003aec:	e422                	sd	s0,8(sp)
    80003aee:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80003af0:	411c                	lw	a5,0(a0)
    80003af2:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003af4:	415c                	lw	a5,4(a0)
    80003af6:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003af8:	04c51783          	lh	a5,76(a0)
    80003afc:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003b00:	05251783          	lh	a5,82(a0)
    80003b04:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003b08:	05456783          	lwu	a5,84(a0)
    80003b0c:	e99c                	sd	a5,16(a1)
}
    80003b0e:	6422                	ld	s0,8(sp)
    80003b10:	0141                	addi	sp,sp,16
    80003b12:	8082                	ret

0000000080003b14 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003b14:	497c                	lw	a5,84(a0)
    80003b16:	0ed7e563          	bltu	a5,a3,80003c00 <readi+0xec>
{
    80003b1a:	7159                	addi	sp,sp,-112
    80003b1c:	f486                	sd	ra,104(sp)
    80003b1e:	f0a2                	sd	s0,96(sp)
    80003b20:	eca6                	sd	s1,88(sp)
    80003b22:	e8ca                	sd	s2,80(sp)
    80003b24:	e4ce                	sd	s3,72(sp)
    80003b26:	e0d2                	sd	s4,64(sp)
    80003b28:	fc56                	sd	s5,56(sp)
    80003b2a:	f85a                	sd	s6,48(sp)
    80003b2c:	f45e                	sd	s7,40(sp)
    80003b2e:	f062                	sd	s8,32(sp)
    80003b30:	ec66                	sd	s9,24(sp)
    80003b32:	e86a                	sd	s10,16(sp)
    80003b34:	e46e                	sd	s11,8(sp)
    80003b36:	1880                	addi	s0,sp,112
    80003b38:	8baa                	mv	s7,a0
    80003b3a:	8c2e                	mv	s8,a1
    80003b3c:	8ab2                	mv	s5,a2
    80003b3e:	8936                	mv	s2,a3
    80003b40:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003b42:	9f35                	addw	a4,a4,a3
    80003b44:	0cd76063          	bltu	a4,a3,80003c04 <readi+0xf0>
    return -1;
  if(off + n > ip->size)
    80003b48:	00e7f463          	bgeu	a5,a4,80003b50 <readi+0x3c>
    n = ip->size - off;
    80003b4c:	40d78b3b          	subw	s6,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b50:	080b0763          	beqz	s6,80003bde <readi+0xca>
    80003b54:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003b56:	40000d13          	li	s10,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003b5a:	5cfd                	li	s9,-1
    80003b5c:	a82d                	j	80003b96 <readi+0x82>
    80003b5e:	02099d93          	slli	s11,s3,0x20
    80003b62:	020ddd93          	srli	s11,s11,0x20
    80003b66:	06048613          	addi	a2,s1,96
    80003b6a:	86ee                	mv	a3,s11
    80003b6c:	963a                	add	a2,a2,a4
    80003b6e:	85d6                	mv	a1,s5
    80003b70:	8562                	mv	a0,s8
    80003b72:	fffff097          	auipc	ra,0xfffff
    80003b76:	9e0080e7          	jalr	-1568(ra) # 80002552 <either_copyout>
    80003b7a:	05950d63          	beq	a0,s9,80003bd4 <readi+0xc0>
      brelse(bp);
      break;
    }
    brelse(bp);
    80003b7e:	8526                	mv	a0,s1
    80003b80:	fffff097          	auipc	ra,0xfffff
    80003b84:	632080e7          	jalr	1586(ra) # 800031b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003b88:	01498a3b          	addw	s4,s3,s4
    80003b8c:	0129893b          	addw	s2,s3,s2
    80003b90:	9aee                	add	s5,s5,s11
    80003b92:	056a7663          	bgeu	s4,s6,80003bde <readi+0xca>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003b96:	000ba483          	lw	s1,0(s7)
    80003b9a:	00a9559b          	srliw	a1,s2,0xa
    80003b9e:	855e                	mv	a0,s7
    80003ba0:	00000097          	auipc	ra,0x0
    80003ba4:	8d6080e7          	jalr	-1834(ra) # 80003476 <bmap>
    80003ba8:	0005059b          	sext.w	a1,a0
    80003bac:	8526                	mv	a0,s1
    80003bae:	fffff097          	auipc	ra,0xfffff
    80003bb2:	4d0080e7          	jalr	1232(ra) # 8000307e <bread>
    80003bb6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003bb8:	3ff97713          	andi	a4,s2,1023
    80003bbc:	40ed07bb          	subw	a5,s10,a4
    80003bc0:	414b06bb          	subw	a3,s6,s4
    80003bc4:	89be                	mv	s3,a5
    80003bc6:	2781                	sext.w	a5,a5
    80003bc8:	0006861b          	sext.w	a2,a3
    80003bcc:	f8f679e3          	bgeu	a2,a5,80003b5e <readi+0x4a>
    80003bd0:	89b6                	mv	s3,a3
    80003bd2:	b771                	j	80003b5e <readi+0x4a>
      brelse(bp);
    80003bd4:	8526                	mv	a0,s1
    80003bd6:	fffff097          	auipc	ra,0xfffff
    80003bda:	5dc080e7          	jalr	1500(ra) # 800031b2 <brelse>
  }
  return n;
    80003bde:	000b051b          	sext.w	a0,s6
}
    80003be2:	70a6                	ld	ra,104(sp)
    80003be4:	7406                	ld	s0,96(sp)
    80003be6:	64e6                	ld	s1,88(sp)
    80003be8:	6946                	ld	s2,80(sp)
    80003bea:	69a6                	ld	s3,72(sp)
    80003bec:	6a06                	ld	s4,64(sp)
    80003bee:	7ae2                	ld	s5,56(sp)
    80003bf0:	7b42                	ld	s6,48(sp)
    80003bf2:	7ba2                	ld	s7,40(sp)
    80003bf4:	7c02                	ld	s8,32(sp)
    80003bf6:	6ce2                	ld	s9,24(sp)
    80003bf8:	6d42                	ld	s10,16(sp)
    80003bfa:	6da2                	ld	s11,8(sp)
    80003bfc:	6165                	addi	sp,sp,112
    80003bfe:	8082                	ret
    return -1;
    80003c00:	557d                	li	a0,-1
}
    80003c02:	8082                	ret
    return -1;
    80003c04:	557d                	li	a0,-1
    80003c06:	bff1                	j	80003be2 <readi+0xce>

0000000080003c08 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003c08:	497c                	lw	a5,84(a0)
    80003c0a:	10d7e663          	bltu	a5,a3,80003d16 <writei+0x10e>
{
    80003c0e:	7159                	addi	sp,sp,-112
    80003c10:	f486                	sd	ra,104(sp)
    80003c12:	f0a2                	sd	s0,96(sp)
    80003c14:	eca6                	sd	s1,88(sp)
    80003c16:	e8ca                	sd	s2,80(sp)
    80003c18:	e4ce                	sd	s3,72(sp)
    80003c1a:	e0d2                	sd	s4,64(sp)
    80003c1c:	fc56                	sd	s5,56(sp)
    80003c1e:	f85a                	sd	s6,48(sp)
    80003c20:	f45e                	sd	s7,40(sp)
    80003c22:	f062                	sd	s8,32(sp)
    80003c24:	ec66                	sd	s9,24(sp)
    80003c26:	e86a                	sd	s10,16(sp)
    80003c28:	e46e                	sd	s11,8(sp)
    80003c2a:	1880                	addi	s0,sp,112
    80003c2c:	8baa                	mv	s7,a0
    80003c2e:	8c2e                	mv	s8,a1
    80003c30:	8ab2                	mv	s5,a2
    80003c32:	8936                	mv	s2,a3
    80003c34:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003c36:	00e687bb          	addw	a5,a3,a4
    80003c3a:	0ed7e063          	bltu	a5,a3,80003d1a <writei+0x112>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003c3e:	00043737          	lui	a4,0x43
    80003c42:	0cf76e63          	bltu	a4,a5,80003d1e <writei+0x116>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c46:	0a0b0763          	beqz	s6,80003cf4 <writei+0xec>
    80003c4a:	4a01                	li	s4,0
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    80003c4c:	40000d13          	li	s10,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003c50:	5cfd                	li	s9,-1
    80003c52:	a091                	j	80003c96 <writei+0x8e>
    80003c54:	02099d93          	slli	s11,s3,0x20
    80003c58:	020ddd93          	srli	s11,s11,0x20
    80003c5c:	06048513          	addi	a0,s1,96
    80003c60:	86ee                	mv	a3,s11
    80003c62:	8656                	mv	a2,s5
    80003c64:	85e2                	mv	a1,s8
    80003c66:	953a                	add	a0,a0,a4
    80003c68:	fffff097          	auipc	ra,0xfffff
    80003c6c:	940080e7          	jalr	-1728(ra) # 800025a8 <either_copyin>
    80003c70:	07950263          	beq	a0,s9,80003cd4 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003c74:	8526                	mv	a0,s1
    80003c76:	00001097          	auipc	ra,0x1
    80003c7a:	83e080e7          	jalr	-1986(ra) # 800044b4 <log_write>
    brelse(bp);
    80003c7e:	8526                	mv	a0,s1
    80003c80:	fffff097          	auipc	ra,0xfffff
    80003c84:	532080e7          	jalr	1330(ra) # 800031b2 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003c88:	01498a3b          	addw	s4,s3,s4
    80003c8c:	0129893b          	addw	s2,s3,s2
    80003c90:	9aee                	add	s5,s5,s11
    80003c92:	056a7663          	bgeu	s4,s6,80003cde <writei+0xd6>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    80003c96:	000ba483          	lw	s1,0(s7)
    80003c9a:	00a9559b          	srliw	a1,s2,0xa
    80003c9e:	855e                	mv	a0,s7
    80003ca0:	fffff097          	auipc	ra,0xfffff
    80003ca4:	7d6080e7          	jalr	2006(ra) # 80003476 <bmap>
    80003ca8:	0005059b          	sext.w	a1,a0
    80003cac:	8526                	mv	a0,s1
    80003cae:	fffff097          	auipc	ra,0xfffff
    80003cb2:	3d0080e7          	jalr	976(ra) # 8000307e <bread>
    80003cb6:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003cb8:	3ff97713          	andi	a4,s2,1023
    80003cbc:	40ed07bb          	subw	a5,s10,a4
    80003cc0:	414b06bb          	subw	a3,s6,s4
    80003cc4:	89be                	mv	s3,a5
    80003cc6:	2781                	sext.w	a5,a5
    80003cc8:	0006861b          	sext.w	a2,a3
    80003ccc:	f8f674e3          	bgeu	a2,a5,80003c54 <writei+0x4c>
    80003cd0:	89b6                	mv	s3,a3
    80003cd2:	b749                	j	80003c54 <writei+0x4c>
      brelse(bp);
    80003cd4:	8526                	mv	a0,s1
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	4dc080e7          	jalr	1244(ra) # 800031b2 <brelse>
  }

  if(n > 0){
    if(off > ip->size)
    80003cde:	054ba783          	lw	a5,84(s7)
    80003ce2:	0127f463          	bgeu	a5,s2,80003cea <writei+0xe2>
      ip->size = off;
    80003ce6:	052baa23          	sw	s2,84(s7)
    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003cea:	855e                	mv	a0,s7
    80003cec:	00000097          	auipc	ra,0x0
    80003cf0:	ace080e7          	jalr	-1330(ra) # 800037ba <iupdate>
  }

  return n;
    80003cf4:	000b051b          	sext.w	a0,s6
}
    80003cf8:	70a6                	ld	ra,104(sp)
    80003cfa:	7406                	ld	s0,96(sp)
    80003cfc:	64e6                	ld	s1,88(sp)
    80003cfe:	6946                	ld	s2,80(sp)
    80003d00:	69a6                	ld	s3,72(sp)
    80003d02:	6a06                	ld	s4,64(sp)
    80003d04:	7ae2                	ld	s5,56(sp)
    80003d06:	7b42                	ld	s6,48(sp)
    80003d08:	7ba2                	ld	s7,40(sp)
    80003d0a:	7c02                	ld	s8,32(sp)
    80003d0c:	6ce2                	ld	s9,24(sp)
    80003d0e:	6d42                	ld	s10,16(sp)
    80003d10:	6da2                	ld	s11,8(sp)
    80003d12:	6165                	addi	sp,sp,112
    80003d14:	8082                	ret
    return -1;
    80003d16:	557d                	li	a0,-1
}
    80003d18:	8082                	ret
    return -1;
    80003d1a:	557d                	li	a0,-1
    80003d1c:	bff1                	j	80003cf8 <writei+0xf0>
    return -1;
    80003d1e:	557d                	li	a0,-1
    80003d20:	bfe1                	j	80003cf8 <writei+0xf0>

0000000080003d22 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003d22:	1141                	addi	sp,sp,-16
    80003d24:	e406                	sd	ra,8(sp)
    80003d26:	e022                	sd	s0,0(sp)
    80003d28:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003d2a:	4639                	li	a2,14
    80003d2c:	ffffd097          	auipc	ra,0xffffd
    80003d30:	12e080e7          	jalr	302(ra) # 80000e5a <strncmp>
}
    80003d34:	60a2                	ld	ra,8(sp)
    80003d36:	6402                	ld	s0,0(sp)
    80003d38:	0141                	addi	sp,sp,16
    80003d3a:	8082                	ret

0000000080003d3c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003d3c:	7139                	addi	sp,sp,-64
    80003d3e:	fc06                	sd	ra,56(sp)
    80003d40:	f822                	sd	s0,48(sp)
    80003d42:	f426                	sd	s1,40(sp)
    80003d44:	f04a                	sd	s2,32(sp)
    80003d46:	ec4e                	sd	s3,24(sp)
    80003d48:	e852                	sd	s4,16(sp)
    80003d4a:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003d4c:	04c51703          	lh	a4,76(a0)
    80003d50:	4785                	li	a5,1
    80003d52:	00f71a63          	bne	a4,a5,80003d66 <dirlookup+0x2a>
    80003d56:	892a                	mv	s2,a0
    80003d58:	89ae                	mv	s3,a1
    80003d5a:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d5c:	497c                	lw	a5,84(a0)
    80003d5e:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003d60:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d62:	e79d                	bnez	a5,80003d90 <dirlookup+0x54>
    80003d64:	a8a5                	j	80003ddc <dirlookup+0xa0>
    panic("dirlookup not DIR");
    80003d66:	00005517          	auipc	a0,0x5
    80003d6a:	bda50513          	addi	a0,a0,-1062 # 80008940 <userret+0x8b0>
    80003d6e:	ffffc097          	auipc	ra,0xffffc
    80003d72:	7ec080e7          	jalr	2028(ra) # 8000055a <panic>
      panic("dirlookup read");
    80003d76:	00005517          	auipc	a0,0x5
    80003d7a:	be250513          	addi	a0,a0,-1054 # 80008958 <userret+0x8c8>
    80003d7e:	ffffc097          	auipc	ra,0xffffc
    80003d82:	7dc080e7          	jalr	2012(ra) # 8000055a <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003d86:	24c1                	addiw	s1,s1,16
    80003d88:	05492783          	lw	a5,84(s2)
    80003d8c:	04f4f763          	bgeu	s1,a5,80003dda <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003d90:	4741                	li	a4,16
    80003d92:	86a6                	mv	a3,s1
    80003d94:	fc040613          	addi	a2,s0,-64
    80003d98:	4581                	li	a1,0
    80003d9a:	854a                	mv	a0,s2
    80003d9c:	00000097          	auipc	ra,0x0
    80003da0:	d78080e7          	jalr	-648(ra) # 80003b14 <readi>
    80003da4:	47c1                	li	a5,16
    80003da6:	fcf518e3          	bne	a0,a5,80003d76 <dirlookup+0x3a>
    if(de.inum == 0)
    80003daa:	fc045783          	lhu	a5,-64(s0)
    80003dae:	dfe1                	beqz	a5,80003d86 <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003db0:	fc240593          	addi	a1,s0,-62
    80003db4:	854e                	mv	a0,s3
    80003db6:	00000097          	auipc	ra,0x0
    80003dba:	f6c080e7          	jalr	-148(ra) # 80003d22 <namecmp>
    80003dbe:	f561                	bnez	a0,80003d86 <dirlookup+0x4a>
      if(poff)
    80003dc0:	000a0463          	beqz	s4,80003dc8 <dirlookup+0x8c>
        *poff = off;
    80003dc4:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    80003dc8:	fc045583          	lhu	a1,-64(s0)
    80003dcc:	00092503          	lw	a0,0(s2)
    80003dd0:	fffff097          	auipc	ra,0xfffff
    80003dd4:	780080e7          	jalr	1920(ra) # 80003550 <iget>
    80003dd8:	a011                	j	80003ddc <dirlookup+0xa0>
  return 0;
    80003dda:	4501                	li	a0,0
}
    80003ddc:	70e2                	ld	ra,56(sp)
    80003dde:	7442                	ld	s0,48(sp)
    80003de0:	74a2                	ld	s1,40(sp)
    80003de2:	7902                	ld	s2,32(sp)
    80003de4:	69e2                	ld	s3,24(sp)
    80003de6:	6a42                	ld	s4,16(sp)
    80003de8:	6121                	addi	sp,sp,64
    80003dea:	8082                	ret

0000000080003dec <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003dec:	711d                	addi	sp,sp,-96
    80003dee:	ec86                	sd	ra,88(sp)
    80003df0:	e8a2                	sd	s0,80(sp)
    80003df2:	e4a6                	sd	s1,72(sp)
    80003df4:	e0ca                	sd	s2,64(sp)
    80003df6:	fc4e                	sd	s3,56(sp)
    80003df8:	f852                	sd	s4,48(sp)
    80003dfa:	f456                	sd	s5,40(sp)
    80003dfc:	f05a                	sd	s6,32(sp)
    80003dfe:	ec5e                	sd	s7,24(sp)
    80003e00:	e862                	sd	s8,16(sp)
    80003e02:	e466                	sd	s9,8(sp)
    80003e04:	1080                	addi	s0,sp,96
    80003e06:	84aa                	mv	s1,a0
    80003e08:	8b2e                	mv	s6,a1
    80003e0a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80003e0c:	00054703          	lbu	a4,0(a0)
    80003e10:	02f00793          	li	a5,47
    80003e14:	02f70363          	beq	a4,a5,80003e3a <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003e18:	ffffe097          	auipc	ra,0xffffe
    80003e1c:	d1e080e7          	jalr	-738(ra) # 80001b36 <myproc>
    80003e20:	15853503          	ld	a0,344(a0)
    80003e24:	00000097          	auipc	ra,0x0
    80003e28:	a22080e7          	jalr	-1502(ra) # 80003846 <idup>
    80003e2c:	89aa                	mv	s3,a0
  while(*path == '/')
    80003e2e:	02f00913          	li	s2,47
  len = path - s;
    80003e32:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    80003e34:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003e36:	4c05                	li	s8,1
    80003e38:	a865                	j	80003ef0 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    80003e3a:	4585                	li	a1,1
    80003e3c:	4501                	li	a0,0
    80003e3e:	fffff097          	auipc	ra,0xfffff
    80003e42:	712080e7          	jalr	1810(ra) # 80003550 <iget>
    80003e46:	89aa                	mv	s3,a0
    80003e48:	b7dd                	j	80003e2e <namex+0x42>
      iunlockput(ip);
    80003e4a:	854e                	mv	a0,s3
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	c76080e7          	jalr	-906(ra) # 80003ac2 <iunlockput>
      return 0;
    80003e54:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003e56:	854e                	mv	a0,s3
    80003e58:	60e6                	ld	ra,88(sp)
    80003e5a:	6446                	ld	s0,80(sp)
    80003e5c:	64a6                	ld	s1,72(sp)
    80003e5e:	6906                	ld	s2,64(sp)
    80003e60:	79e2                	ld	s3,56(sp)
    80003e62:	7a42                	ld	s4,48(sp)
    80003e64:	7aa2                	ld	s5,40(sp)
    80003e66:	7b02                	ld	s6,32(sp)
    80003e68:	6be2                	ld	s7,24(sp)
    80003e6a:	6c42                	ld	s8,16(sp)
    80003e6c:	6ca2                	ld	s9,8(sp)
    80003e6e:	6125                	addi	sp,sp,96
    80003e70:	8082                	ret
      iunlock(ip);
    80003e72:	854e                	mv	a0,s3
    80003e74:	00000097          	auipc	ra,0x0
    80003e78:	ad2080e7          	jalr	-1326(ra) # 80003946 <iunlock>
      return ip;
    80003e7c:	bfe9                	j	80003e56 <namex+0x6a>
      iunlockput(ip);
    80003e7e:	854e                	mv	a0,s3
    80003e80:	00000097          	auipc	ra,0x0
    80003e84:	c42080e7          	jalr	-958(ra) # 80003ac2 <iunlockput>
      return 0;
    80003e88:	89d2                	mv	s3,s4
    80003e8a:	b7f1                	j	80003e56 <namex+0x6a>
  len = path - s;
    80003e8c:	40b48633          	sub	a2,s1,a1
    80003e90:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003e94:	094cd463          	bge	s9,s4,80003f1c <namex+0x130>
    memmove(name, s, DIRSIZ);
    80003e98:	4639                	li	a2,14
    80003e9a:	8556                	mv	a0,s5
    80003e9c:	ffffd097          	auipc	ra,0xffffd
    80003ea0:	f42080e7          	jalr	-190(ra) # 80000dde <memmove>
  while(*path == '/')
    80003ea4:	0004c783          	lbu	a5,0(s1)
    80003ea8:	01279763          	bne	a5,s2,80003eb6 <namex+0xca>
    path++;
    80003eac:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003eae:	0004c783          	lbu	a5,0(s1)
    80003eb2:	ff278de3          	beq	a5,s2,80003eac <namex+0xc0>
    ilock(ip);
    80003eb6:	854e                	mv	a0,s3
    80003eb8:	00000097          	auipc	ra,0x0
    80003ebc:	9cc080e7          	jalr	-1588(ra) # 80003884 <ilock>
    if(ip->type != T_DIR){
    80003ec0:	04c99783          	lh	a5,76(s3)
    80003ec4:	f98793e3          	bne	a5,s8,80003e4a <namex+0x5e>
    if(nameiparent && *path == '\0'){
    80003ec8:	000b0563          	beqz	s6,80003ed2 <namex+0xe6>
    80003ecc:	0004c783          	lbu	a5,0(s1)
    80003ed0:	d3cd                	beqz	a5,80003e72 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003ed2:	865e                	mv	a2,s7
    80003ed4:	85d6                	mv	a1,s5
    80003ed6:	854e                	mv	a0,s3
    80003ed8:	00000097          	auipc	ra,0x0
    80003edc:	e64080e7          	jalr	-412(ra) # 80003d3c <dirlookup>
    80003ee0:	8a2a                	mv	s4,a0
    80003ee2:	dd51                	beqz	a0,80003e7e <namex+0x92>
    iunlockput(ip);
    80003ee4:	854e                	mv	a0,s3
    80003ee6:	00000097          	auipc	ra,0x0
    80003eea:	bdc080e7          	jalr	-1060(ra) # 80003ac2 <iunlockput>
    ip = next;
    80003eee:	89d2                	mv	s3,s4
  while(*path == '/')
    80003ef0:	0004c783          	lbu	a5,0(s1)
    80003ef4:	05279763          	bne	a5,s2,80003f42 <namex+0x156>
    path++;
    80003ef8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003efa:	0004c783          	lbu	a5,0(s1)
    80003efe:	ff278de3          	beq	a5,s2,80003ef8 <namex+0x10c>
  if(*path == 0)
    80003f02:	c79d                	beqz	a5,80003f30 <namex+0x144>
    path++;
    80003f04:	85a6                	mv	a1,s1
  len = path - s;
    80003f06:	8a5e                	mv	s4,s7
    80003f08:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    80003f0a:	01278963          	beq	a5,s2,80003f1c <namex+0x130>
    80003f0e:	dfbd                	beqz	a5,80003e8c <namex+0xa0>
    path++;
    80003f10:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    80003f12:	0004c783          	lbu	a5,0(s1)
    80003f16:	ff279ce3          	bne	a5,s2,80003f0e <namex+0x122>
    80003f1a:	bf8d                	j	80003e8c <namex+0xa0>
    memmove(name, s, len);
    80003f1c:	2601                	sext.w	a2,a2
    80003f1e:	8556                	mv	a0,s5
    80003f20:	ffffd097          	auipc	ra,0xffffd
    80003f24:	ebe080e7          	jalr	-322(ra) # 80000dde <memmove>
    name[len] = 0;
    80003f28:	9a56                	add	s4,s4,s5
    80003f2a:	000a0023          	sb	zero,0(s4)
    80003f2e:	bf9d                	j	80003ea4 <namex+0xb8>
  if(nameiparent){
    80003f30:	f20b03e3          	beqz	s6,80003e56 <namex+0x6a>
    iput(ip);
    80003f34:	854e                	mv	a0,s3
    80003f36:	00000097          	auipc	ra,0x0
    80003f3a:	a5c080e7          	jalr	-1444(ra) # 80003992 <iput>
    return 0;
    80003f3e:	4981                	li	s3,0
    80003f40:	bf19                	j	80003e56 <namex+0x6a>
  if(*path == 0)
    80003f42:	d7fd                	beqz	a5,80003f30 <namex+0x144>
  while(*path != '/' && *path != 0)
    80003f44:	0004c783          	lbu	a5,0(s1)
    80003f48:	85a6                	mv	a1,s1
    80003f4a:	b7d1                	j	80003f0e <namex+0x122>

0000000080003f4c <dirlink>:
{
    80003f4c:	7139                	addi	sp,sp,-64
    80003f4e:	fc06                	sd	ra,56(sp)
    80003f50:	f822                	sd	s0,48(sp)
    80003f52:	f426                	sd	s1,40(sp)
    80003f54:	f04a                	sd	s2,32(sp)
    80003f56:	ec4e                	sd	s3,24(sp)
    80003f58:	e852                	sd	s4,16(sp)
    80003f5a:	0080                	addi	s0,sp,64
    80003f5c:	892a                	mv	s2,a0
    80003f5e:	8a2e                	mv	s4,a1
    80003f60:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f62:	4601                	li	a2,0
    80003f64:	00000097          	auipc	ra,0x0
    80003f68:	dd8080e7          	jalr	-552(ra) # 80003d3c <dirlookup>
    80003f6c:	e93d                	bnez	a0,80003fe2 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f6e:	05492483          	lw	s1,84(s2)
    80003f72:	c49d                	beqz	s1,80003fa0 <dirlink+0x54>
    80003f74:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003f76:	4741                	li	a4,16
    80003f78:	86a6                	mv	a3,s1
    80003f7a:	fc040613          	addi	a2,s0,-64
    80003f7e:	4581                	li	a1,0
    80003f80:	854a                	mv	a0,s2
    80003f82:	00000097          	auipc	ra,0x0
    80003f86:	b92080e7          	jalr	-1134(ra) # 80003b14 <readi>
    80003f8a:	47c1                	li	a5,16
    80003f8c:	06f51163          	bne	a0,a5,80003fee <dirlink+0xa2>
    if(de.inum == 0)
    80003f90:	fc045783          	lhu	a5,-64(s0)
    80003f94:	c791                	beqz	a5,80003fa0 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003f96:	24c1                	addiw	s1,s1,16
    80003f98:	05492783          	lw	a5,84(s2)
    80003f9c:	fcf4ede3          	bltu	s1,a5,80003f76 <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003fa0:	4639                	li	a2,14
    80003fa2:	85d2                	mv	a1,s4
    80003fa4:	fc240513          	addi	a0,s0,-62
    80003fa8:	ffffd097          	auipc	ra,0xffffd
    80003fac:	eee080e7          	jalr	-274(ra) # 80000e96 <strncpy>
  de.inum = inum;
    80003fb0:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fb4:	4741                	li	a4,16
    80003fb6:	86a6                	mv	a3,s1
    80003fb8:	fc040613          	addi	a2,s0,-64
    80003fbc:	4581                	li	a1,0
    80003fbe:	854a                	mv	a0,s2
    80003fc0:	00000097          	auipc	ra,0x0
    80003fc4:	c48080e7          	jalr	-952(ra) # 80003c08 <writei>
    80003fc8:	872a                	mv	a4,a0
    80003fca:	47c1                	li	a5,16
  return 0;
    80003fcc:	4501                	li	a0,0
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003fce:	02f71863          	bne	a4,a5,80003ffe <dirlink+0xb2>
}
    80003fd2:	70e2                	ld	ra,56(sp)
    80003fd4:	7442                	ld	s0,48(sp)
    80003fd6:	74a2                	ld	s1,40(sp)
    80003fd8:	7902                	ld	s2,32(sp)
    80003fda:	69e2                	ld	s3,24(sp)
    80003fdc:	6a42                	ld	s4,16(sp)
    80003fde:	6121                	addi	sp,sp,64
    80003fe0:	8082                	ret
    iput(ip);
    80003fe2:	00000097          	auipc	ra,0x0
    80003fe6:	9b0080e7          	jalr	-1616(ra) # 80003992 <iput>
    return -1;
    80003fea:	557d                	li	a0,-1
    80003fec:	b7dd                	j	80003fd2 <dirlink+0x86>
      panic("dirlink read");
    80003fee:	00005517          	auipc	a0,0x5
    80003ff2:	97a50513          	addi	a0,a0,-1670 # 80008968 <userret+0x8d8>
    80003ff6:	ffffc097          	auipc	ra,0xffffc
    80003ffa:	564080e7          	jalr	1380(ra) # 8000055a <panic>
    panic("dirlink");
    80003ffe:	00005517          	auipc	a0,0x5
    80004002:	a8a50513          	addi	a0,a0,-1398 # 80008a88 <userret+0x9f8>
    80004006:	ffffc097          	auipc	ra,0xffffc
    8000400a:	554080e7          	jalr	1364(ra) # 8000055a <panic>

000000008000400e <namei>:

struct inode*
namei(char *path)
{
    8000400e:	1101                	addi	sp,sp,-32
    80004010:	ec06                	sd	ra,24(sp)
    80004012:	e822                	sd	s0,16(sp)
    80004014:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80004016:	fe040613          	addi	a2,s0,-32
    8000401a:	4581                	li	a1,0
    8000401c:	00000097          	auipc	ra,0x0
    80004020:	dd0080e7          	jalr	-560(ra) # 80003dec <namex>
}
    80004024:	60e2                	ld	ra,24(sp)
    80004026:	6442                	ld	s0,16(sp)
    80004028:	6105                	addi	sp,sp,32
    8000402a:	8082                	ret

000000008000402c <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000402c:	1141                	addi	sp,sp,-16
    8000402e:	e406                	sd	ra,8(sp)
    80004030:	e022                	sd	s0,0(sp)
    80004032:	0800                	addi	s0,sp,16
    80004034:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80004036:	4585                	li	a1,1
    80004038:	00000097          	auipc	ra,0x0
    8000403c:	db4080e7          	jalr	-588(ra) # 80003dec <namex>
}
    80004040:	60a2                	ld	ra,8(sp)
    80004042:	6402                	ld	s0,0(sp)
    80004044:	0141                	addi	sp,sp,16
    80004046:	8082                	ret

0000000080004048 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(int dev)
{
    80004048:	7179                	addi	sp,sp,-48
    8000404a:	f406                	sd	ra,40(sp)
    8000404c:	f022                	sd	s0,32(sp)
    8000404e:	ec26                	sd	s1,24(sp)
    80004050:	e84a                	sd	s2,16(sp)
    80004052:	e44e                	sd	s3,8(sp)
    80004054:	1800                	addi	s0,sp,48
    80004056:	84aa                	mv	s1,a0
  struct buf *buf = bread(dev, log[dev].start);
    80004058:	0b000993          	li	s3,176
    8000405c:	033507b3          	mul	a5,a0,s3
    80004060:	0001c997          	auipc	s3,0x1c
    80004064:	ea098993          	addi	s3,s3,-352 # 8001ff00 <log>
    80004068:	99be                	add	s3,s3,a5
    8000406a:	0209a583          	lw	a1,32(s3)
    8000406e:	fffff097          	auipc	ra,0xfffff
    80004072:	010080e7          	jalr	16(ra) # 8000307e <bread>
    80004076:	892a                	mv	s2,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log[dev].lh.n;
    80004078:	0349a783          	lw	a5,52(s3)
    8000407c:	d13c                	sw	a5,96(a0)
  for (i = 0; i < log[dev].lh.n; i++) {
    8000407e:	0349a783          	lw	a5,52(s3)
    80004082:	02f05763          	blez	a5,800040b0 <write_head+0x68>
    80004086:	0b000793          	li	a5,176
    8000408a:	02f487b3          	mul	a5,s1,a5
    8000408e:	0001c717          	auipc	a4,0x1c
    80004092:	eaa70713          	addi	a4,a4,-342 # 8001ff38 <log+0x38>
    80004096:	97ba                	add	a5,a5,a4
    80004098:	06450693          	addi	a3,a0,100
    8000409c:	4701                	li	a4,0
    8000409e:	85ce                	mv	a1,s3
    hb->block[i] = log[dev].lh.block[i];
    800040a0:	4390                	lw	a2,0(a5)
    800040a2:	c290                	sw	a2,0(a3)
  for (i = 0; i < log[dev].lh.n; i++) {
    800040a4:	2705                	addiw	a4,a4,1
    800040a6:	0791                	addi	a5,a5,4
    800040a8:	0691                	addi	a3,a3,4
    800040aa:	59d0                	lw	a2,52(a1)
    800040ac:	fec74ae3          	blt	a4,a2,800040a0 <write_head+0x58>
  }
  bwrite(buf);
    800040b0:	854a                	mv	a0,s2
    800040b2:	fffff097          	auipc	ra,0xfffff
    800040b6:	0c0080e7          	jalr	192(ra) # 80003172 <bwrite>
  brelse(buf);
    800040ba:	854a                	mv	a0,s2
    800040bc:	fffff097          	auipc	ra,0xfffff
    800040c0:	0f6080e7          	jalr	246(ra) # 800031b2 <brelse>
}
    800040c4:	70a2                	ld	ra,40(sp)
    800040c6:	7402                	ld	s0,32(sp)
    800040c8:	64e2                	ld	s1,24(sp)
    800040ca:	6942                	ld	s2,16(sp)
    800040cc:	69a2                	ld	s3,8(sp)
    800040ce:	6145                	addi	sp,sp,48
    800040d0:	8082                	ret

00000000800040d2 <install_trans>:
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    800040d2:	0b000793          	li	a5,176
    800040d6:	02f50733          	mul	a4,a0,a5
    800040da:	0001c797          	auipc	a5,0x1c
    800040de:	e2678793          	addi	a5,a5,-474 # 8001ff00 <log>
    800040e2:	97ba                	add	a5,a5,a4
    800040e4:	5bdc                	lw	a5,52(a5)
    800040e6:	0af05b63          	blez	a5,8000419c <install_trans+0xca>
{
    800040ea:	7139                	addi	sp,sp,-64
    800040ec:	fc06                	sd	ra,56(sp)
    800040ee:	f822                	sd	s0,48(sp)
    800040f0:	f426                	sd	s1,40(sp)
    800040f2:	f04a                	sd	s2,32(sp)
    800040f4:	ec4e                	sd	s3,24(sp)
    800040f6:	e852                	sd	s4,16(sp)
    800040f8:	e456                	sd	s5,8(sp)
    800040fa:	e05a                	sd	s6,0(sp)
    800040fc:	0080                	addi	s0,sp,64
    800040fe:	0001c797          	auipc	a5,0x1c
    80004102:	e3a78793          	addi	a5,a5,-454 # 8001ff38 <log+0x38>
    80004106:	00f70a33          	add	s4,a4,a5
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    8000410a:	4981                	li	s3,0
    struct buf *lbuf = bread(dev, log[dev].start+tail+1); // read log block
    8000410c:	00050b1b          	sext.w	s6,a0
    80004110:	0001ca97          	auipc	s5,0x1c
    80004114:	df0a8a93          	addi	s5,s5,-528 # 8001ff00 <log>
    80004118:	9aba                	add	s5,s5,a4
    8000411a:	020aa583          	lw	a1,32(s5)
    8000411e:	013585bb          	addw	a1,a1,s3
    80004122:	2585                	addiw	a1,a1,1
    80004124:	855a                	mv	a0,s6
    80004126:	fffff097          	auipc	ra,0xfffff
    8000412a:	f58080e7          	jalr	-168(ra) # 8000307e <bread>
    8000412e:	892a                	mv	s2,a0
    struct buf *dbuf = bread(dev, log[dev].lh.block[tail]); // read dst
    80004130:	000a2583          	lw	a1,0(s4)
    80004134:	855a                	mv	a0,s6
    80004136:	fffff097          	auipc	ra,0xfffff
    8000413a:	f48080e7          	jalr	-184(ra) # 8000307e <bread>
    8000413e:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80004140:	40000613          	li	a2,1024
    80004144:	06090593          	addi	a1,s2,96
    80004148:	06050513          	addi	a0,a0,96
    8000414c:	ffffd097          	auipc	ra,0xffffd
    80004150:	c92080e7          	jalr	-878(ra) # 80000dde <memmove>
    bwrite(dbuf);  // write dst to disk
    80004154:	8526                	mv	a0,s1
    80004156:	fffff097          	auipc	ra,0xfffff
    8000415a:	01c080e7          	jalr	28(ra) # 80003172 <bwrite>
    bunpin(dbuf);
    8000415e:	8526                	mv	a0,s1
    80004160:	fffff097          	auipc	ra,0xfffff
    80004164:	12c080e7          	jalr	300(ra) # 8000328c <bunpin>
    brelse(lbuf);
    80004168:	854a                	mv	a0,s2
    8000416a:	fffff097          	auipc	ra,0xfffff
    8000416e:	048080e7          	jalr	72(ra) # 800031b2 <brelse>
    brelse(dbuf);
    80004172:	8526                	mv	a0,s1
    80004174:	fffff097          	auipc	ra,0xfffff
    80004178:	03e080e7          	jalr	62(ra) # 800031b2 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    8000417c:	2985                	addiw	s3,s3,1
    8000417e:	0a11                	addi	s4,s4,4
    80004180:	034aa783          	lw	a5,52(s5)
    80004184:	f8f9cbe3          	blt	s3,a5,8000411a <install_trans+0x48>
}
    80004188:	70e2                	ld	ra,56(sp)
    8000418a:	7442                	ld	s0,48(sp)
    8000418c:	74a2                	ld	s1,40(sp)
    8000418e:	7902                	ld	s2,32(sp)
    80004190:	69e2                	ld	s3,24(sp)
    80004192:	6a42                	ld	s4,16(sp)
    80004194:	6aa2                	ld	s5,8(sp)
    80004196:	6b02                	ld	s6,0(sp)
    80004198:	6121                	addi	sp,sp,64
    8000419a:	8082                	ret
    8000419c:	8082                	ret

000000008000419e <initlog>:
{
    8000419e:	7179                	addi	sp,sp,-48
    800041a0:	f406                	sd	ra,40(sp)
    800041a2:	f022                	sd	s0,32(sp)
    800041a4:	ec26                	sd	s1,24(sp)
    800041a6:	e84a                	sd	s2,16(sp)
    800041a8:	e44e                	sd	s3,8(sp)
    800041aa:	e052                	sd	s4,0(sp)
    800041ac:	1800                	addi	s0,sp,48
    800041ae:	84aa                	mv	s1,a0
    800041b0:	8a2e                	mv	s4,a1
  initlock(&log[dev].lock, "log");
    800041b2:	0b000713          	li	a4,176
    800041b6:	02e509b3          	mul	s3,a0,a4
    800041ba:	0001c917          	auipc	s2,0x1c
    800041be:	d4690913          	addi	s2,s2,-698 # 8001ff00 <log>
    800041c2:	994e                	add	s2,s2,s3
    800041c4:	00004597          	auipc	a1,0x4
    800041c8:	7b458593          	addi	a1,a1,1972 # 80008978 <userret+0x8e8>
    800041cc:	854a                	mv	a0,s2
    800041ce:	ffffd097          	auipc	ra,0xffffd
    800041d2:	80e080e7          	jalr	-2034(ra) # 800009dc <initlock>
  log[dev].start = sb->logstart;
    800041d6:	014a2583          	lw	a1,20(s4)
    800041da:	02b92023          	sw	a1,32(s2)
  log[dev].size = sb->nlog;
    800041de:	010a2783          	lw	a5,16(s4)
    800041e2:	02f92223          	sw	a5,36(s2)
  log[dev].dev = dev;
    800041e6:	02992823          	sw	s1,48(s2)
  struct buf *buf = bread(dev, log[dev].start);
    800041ea:	8526                	mv	a0,s1
    800041ec:	fffff097          	auipc	ra,0xfffff
    800041f0:	e92080e7          	jalr	-366(ra) # 8000307e <bread>
  log[dev].lh.n = lh->n;
    800041f4:	513c                	lw	a5,96(a0)
    800041f6:	02f92a23          	sw	a5,52(s2)
  for (i = 0; i < log[dev].lh.n; i++) {
    800041fa:	02f05663          	blez	a5,80004226 <initlog+0x88>
    800041fe:	06450693          	addi	a3,a0,100
    80004202:	0001c717          	auipc	a4,0x1c
    80004206:	d3670713          	addi	a4,a4,-714 # 8001ff38 <log+0x38>
    8000420a:	974e                	add	a4,a4,s3
    8000420c:	37fd                	addiw	a5,a5,-1
    8000420e:	1782                	slli	a5,a5,0x20
    80004210:	9381                	srli	a5,a5,0x20
    80004212:	078a                	slli	a5,a5,0x2
    80004214:	06850613          	addi	a2,a0,104
    80004218:	97b2                	add	a5,a5,a2
    log[dev].lh.block[i] = lh->block[i];
    8000421a:	4290                	lw	a2,0(a3)
    8000421c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log[dev].lh.n; i++) {
    8000421e:	0691                	addi	a3,a3,4
    80004220:	0711                	addi	a4,a4,4
    80004222:	fef69ce3          	bne	a3,a5,8000421a <initlog+0x7c>
  brelse(buf);
    80004226:	fffff097          	auipc	ra,0xfffff
    8000422a:	f8c080e7          	jalr	-116(ra) # 800031b2 <brelse>

static void
recover_from_log(int dev)
{
  read_head(dev);
  install_trans(dev); // if committed, copy from log to disk
    8000422e:	8526                	mv	a0,s1
    80004230:	00000097          	auipc	ra,0x0
    80004234:	ea2080e7          	jalr	-350(ra) # 800040d2 <install_trans>
  log[dev].lh.n = 0;
    80004238:	0b000793          	li	a5,176
    8000423c:	02f48733          	mul	a4,s1,a5
    80004240:	0001c797          	auipc	a5,0x1c
    80004244:	cc078793          	addi	a5,a5,-832 # 8001ff00 <log>
    80004248:	97ba                	add	a5,a5,a4
    8000424a:	0207aa23          	sw	zero,52(a5)
  write_head(dev); // clear the log
    8000424e:	8526                	mv	a0,s1
    80004250:	00000097          	auipc	ra,0x0
    80004254:	df8080e7          	jalr	-520(ra) # 80004048 <write_head>
}
    80004258:	70a2                	ld	ra,40(sp)
    8000425a:	7402                	ld	s0,32(sp)
    8000425c:	64e2                	ld	s1,24(sp)
    8000425e:	6942                	ld	s2,16(sp)
    80004260:	69a2                	ld	s3,8(sp)
    80004262:	6a02                	ld	s4,0(sp)
    80004264:	6145                	addi	sp,sp,48
    80004266:	8082                	ret

0000000080004268 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(int dev)
{
    80004268:	7139                	addi	sp,sp,-64
    8000426a:	fc06                	sd	ra,56(sp)
    8000426c:	f822                	sd	s0,48(sp)
    8000426e:	f426                	sd	s1,40(sp)
    80004270:	f04a                	sd	s2,32(sp)
    80004272:	ec4e                	sd	s3,24(sp)
    80004274:	e852                	sd	s4,16(sp)
    80004276:	e456                	sd	s5,8(sp)
    80004278:	0080                	addi	s0,sp,64
    8000427a:	8aaa                	mv	s5,a0
  acquire(&log[dev].lock);
    8000427c:	0b000913          	li	s2,176
    80004280:	032507b3          	mul	a5,a0,s2
    80004284:	0001c917          	auipc	s2,0x1c
    80004288:	c7c90913          	addi	s2,s2,-900 # 8001ff00 <log>
    8000428c:	993e                	add	s2,s2,a5
    8000428e:	854a                	mv	a0,s2
    80004290:	ffffd097          	auipc	ra,0xffffd
    80004294:	820080e7          	jalr	-2016(ra) # 80000ab0 <acquire>
  while(1){
    if(log[dev].committing){
    80004298:	0001c997          	auipc	s3,0x1c
    8000429c:	c6898993          	addi	s3,s3,-920 # 8001ff00 <log>
    800042a0:	84ca                	mv	s1,s2
      sleep(&log, &log[dev].lock);
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042a2:	4a79                	li	s4,30
    800042a4:	a039                	j	800042b2 <begin_op+0x4a>
      sleep(&log, &log[dev].lock);
    800042a6:	85ca                	mv	a1,s2
    800042a8:	854e                	mv	a0,s3
    800042aa:	ffffe097          	auipc	ra,0xffffe
    800042ae:	048080e7          	jalr	72(ra) # 800022f2 <sleep>
    if(log[dev].committing){
    800042b2:	54dc                	lw	a5,44(s1)
    800042b4:	fbed                	bnez	a5,800042a6 <begin_op+0x3e>
    } else if(log[dev].lh.n + (log[dev].outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800042b6:	549c                	lw	a5,40(s1)
    800042b8:	0017871b          	addiw	a4,a5,1
    800042bc:	0007069b          	sext.w	a3,a4
    800042c0:	0027179b          	slliw	a5,a4,0x2
    800042c4:	9fb9                	addw	a5,a5,a4
    800042c6:	0017979b          	slliw	a5,a5,0x1
    800042ca:	58d8                	lw	a4,52(s1)
    800042cc:	9fb9                	addw	a5,a5,a4
    800042ce:	00fa5963          	bge	s4,a5,800042e0 <begin_op+0x78>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log[dev].lock);
    800042d2:	85ca                	mv	a1,s2
    800042d4:	854e                	mv	a0,s3
    800042d6:	ffffe097          	auipc	ra,0xffffe
    800042da:	01c080e7          	jalr	28(ra) # 800022f2 <sleep>
    800042de:	bfd1                	j	800042b2 <begin_op+0x4a>
    } else {
      log[dev].outstanding += 1;
    800042e0:	0b000513          	li	a0,176
    800042e4:	02aa8ab3          	mul	s5,s5,a0
    800042e8:	0001c797          	auipc	a5,0x1c
    800042ec:	c1878793          	addi	a5,a5,-1000 # 8001ff00 <log>
    800042f0:	9abe                	add	s5,s5,a5
    800042f2:	02daa423          	sw	a3,40(s5)
      release(&log[dev].lock);
    800042f6:	854a                	mv	a0,s2
    800042f8:	ffffd097          	auipc	ra,0xffffd
    800042fc:	888080e7          	jalr	-1912(ra) # 80000b80 <release>
      break;
    }
  }
}
    80004300:	70e2                	ld	ra,56(sp)
    80004302:	7442                	ld	s0,48(sp)
    80004304:	74a2                	ld	s1,40(sp)
    80004306:	7902                	ld	s2,32(sp)
    80004308:	69e2                	ld	s3,24(sp)
    8000430a:	6a42                	ld	s4,16(sp)
    8000430c:	6aa2                	ld	s5,8(sp)
    8000430e:	6121                	addi	sp,sp,64
    80004310:	8082                	ret

0000000080004312 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(int dev)
{
    80004312:	715d                	addi	sp,sp,-80
    80004314:	e486                	sd	ra,72(sp)
    80004316:	e0a2                	sd	s0,64(sp)
    80004318:	fc26                	sd	s1,56(sp)
    8000431a:	f84a                	sd	s2,48(sp)
    8000431c:	f44e                	sd	s3,40(sp)
    8000431e:	f052                	sd	s4,32(sp)
    80004320:	ec56                	sd	s5,24(sp)
    80004322:	e85a                	sd	s6,16(sp)
    80004324:	e45e                	sd	s7,8(sp)
    80004326:	e062                	sd	s8,0(sp)
    80004328:	0880                	addi	s0,sp,80
    8000432a:	8aaa                	mv	s5,a0
  int do_commit = 0;

  acquire(&log[dev].lock);
    8000432c:	0b000913          	li	s2,176
    80004330:	03250933          	mul	s2,a0,s2
    80004334:	0001c497          	auipc	s1,0x1c
    80004338:	bcc48493          	addi	s1,s1,-1076 # 8001ff00 <log>
    8000433c:	94ca                	add	s1,s1,s2
    8000433e:	8526                	mv	a0,s1
    80004340:	ffffc097          	auipc	ra,0xffffc
    80004344:	770080e7          	jalr	1904(ra) # 80000ab0 <acquire>
  log[dev].outstanding -= 1;
    80004348:	5498                	lw	a4,40(s1)
    8000434a:	377d                	addiw	a4,a4,-1
    8000434c:	d498                	sw	a4,40(s1)
  if(log[dev].committing)
    8000434e:	54dc                	lw	a5,44(s1)
    80004350:	efbd                	bnez	a5,800043ce <end_op+0xbc>
    80004352:	00070b1b          	sext.w	s6,a4
    panic("log[dev].committing");
  if(log[dev].outstanding == 0){
    80004356:	080b1463          	bnez	s6,800043de <end_op+0xcc>
    do_commit = 1;
    log[dev].committing = 1;
    8000435a:	0b000993          	li	s3,176
    8000435e:	033a87b3          	mul	a5,s5,s3
    80004362:	0001c997          	auipc	s3,0x1c
    80004366:	b9e98993          	addi	s3,s3,-1122 # 8001ff00 <log>
    8000436a:	99be                	add	s3,s3,a5
    8000436c:	4785                	li	a5,1
    8000436e:	02f9a623          	sw	a5,44(s3)
    // begin_op() may be waiting for log space,
    // and decrementing log[dev].outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log[dev].lock);
    80004372:	8526                	mv	a0,s1
    80004374:	ffffd097          	auipc	ra,0xffffd
    80004378:	80c080e7          	jalr	-2036(ra) # 80000b80 <release>
}

static void
commit(int dev)
{
  if (log[dev].lh.n > 0) {
    8000437c:	0349a783          	lw	a5,52(s3)
    80004380:	06f04d63          	bgtz	a5,800043fa <end_op+0xe8>
    acquire(&log[dev].lock);
    80004384:	8526                	mv	a0,s1
    80004386:	ffffc097          	auipc	ra,0xffffc
    8000438a:	72a080e7          	jalr	1834(ra) # 80000ab0 <acquire>
    log[dev].committing = 0;
    8000438e:	0001c517          	auipc	a0,0x1c
    80004392:	b7250513          	addi	a0,a0,-1166 # 8001ff00 <log>
    80004396:	0b000793          	li	a5,176
    8000439a:	02fa87b3          	mul	a5,s5,a5
    8000439e:	97aa                	add	a5,a5,a0
    800043a0:	0207a623          	sw	zero,44(a5)
    wakeup(&log);
    800043a4:	ffffe097          	auipc	ra,0xffffe
    800043a8:	0d4080e7          	jalr	212(ra) # 80002478 <wakeup>
    release(&log[dev].lock);
    800043ac:	8526                	mv	a0,s1
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	7d2080e7          	jalr	2002(ra) # 80000b80 <release>
}
    800043b6:	60a6                	ld	ra,72(sp)
    800043b8:	6406                	ld	s0,64(sp)
    800043ba:	74e2                	ld	s1,56(sp)
    800043bc:	7942                	ld	s2,48(sp)
    800043be:	79a2                	ld	s3,40(sp)
    800043c0:	7a02                	ld	s4,32(sp)
    800043c2:	6ae2                	ld	s5,24(sp)
    800043c4:	6b42                	ld	s6,16(sp)
    800043c6:	6ba2                	ld	s7,8(sp)
    800043c8:	6c02                	ld	s8,0(sp)
    800043ca:	6161                	addi	sp,sp,80
    800043cc:	8082                	ret
    panic("log[dev].committing");
    800043ce:	00004517          	auipc	a0,0x4
    800043d2:	5b250513          	addi	a0,a0,1458 # 80008980 <userret+0x8f0>
    800043d6:	ffffc097          	auipc	ra,0xffffc
    800043da:	184080e7          	jalr	388(ra) # 8000055a <panic>
    wakeup(&log);
    800043de:	0001c517          	auipc	a0,0x1c
    800043e2:	b2250513          	addi	a0,a0,-1246 # 8001ff00 <log>
    800043e6:	ffffe097          	auipc	ra,0xffffe
    800043ea:	092080e7          	jalr	146(ra) # 80002478 <wakeup>
  release(&log[dev].lock);
    800043ee:	8526                	mv	a0,s1
    800043f0:	ffffc097          	auipc	ra,0xffffc
    800043f4:	790080e7          	jalr	1936(ra) # 80000b80 <release>
  if(do_commit){
    800043f8:	bf7d                	j	800043b6 <end_op+0xa4>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    800043fa:	0001c797          	auipc	a5,0x1c
    800043fe:	b3e78793          	addi	a5,a5,-1218 # 8001ff38 <log+0x38>
    80004402:	993e                	add	s2,s2,a5
    struct buf *to = bread(dev, log[dev].start+tail+1); // log block
    80004404:	000a8c1b          	sext.w	s8,s5
    80004408:	0b000b93          	li	s7,176
    8000440c:	037a87b3          	mul	a5,s5,s7
    80004410:	0001cb97          	auipc	s7,0x1c
    80004414:	af0b8b93          	addi	s7,s7,-1296 # 8001ff00 <log>
    80004418:	9bbe                	add	s7,s7,a5
    8000441a:	020ba583          	lw	a1,32(s7)
    8000441e:	016585bb          	addw	a1,a1,s6
    80004422:	2585                	addiw	a1,a1,1
    80004424:	8562                	mv	a0,s8
    80004426:	fffff097          	auipc	ra,0xfffff
    8000442a:	c58080e7          	jalr	-936(ra) # 8000307e <bread>
    8000442e:	89aa                	mv	s3,a0
    struct buf *from = bread(dev, log[dev].lh.block[tail]); // cache block
    80004430:	00092583          	lw	a1,0(s2)
    80004434:	8562                	mv	a0,s8
    80004436:	fffff097          	auipc	ra,0xfffff
    8000443a:	c48080e7          	jalr	-952(ra) # 8000307e <bread>
    8000443e:	8a2a                	mv	s4,a0
    memmove(to->data, from->data, BSIZE);
    80004440:	40000613          	li	a2,1024
    80004444:	06050593          	addi	a1,a0,96
    80004448:	06098513          	addi	a0,s3,96
    8000444c:	ffffd097          	auipc	ra,0xffffd
    80004450:	992080e7          	jalr	-1646(ra) # 80000dde <memmove>
    bwrite(to);  // write the log
    80004454:	854e                	mv	a0,s3
    80004456:	fffff097          	auipc	ra,0xfffff
    8000445a:	d1c080e7          	jalr	-740(ra) # 80003172 <bwrite>
    brelse(from);
    8000445e:	8552                	mv	a0,s4
    80004460:	fffff097          	auipc	ra,0xfffff
    80004464:	d52080e7          	jalr	-686(ra) # 800031b2 <brelse>
    brelse(to);
    80004468:	854e                	mv	a0,s3
    8000446a:	fffff097          	auipc	ra,0xfffff
    8000446e:	d48080e7          	jalr	-696(ra) # 800031b2 <brelse>
  for (tail = 0; tail < log[dev].lh.n; tail++) {
    80004472:	2b05                	addiw	s6,s6,1
    80004474:	0911                	addi	s2,s2,4
    80004476:	034ba783          	lw	a5,52(s7)
    8000447a:	fafb40e3          	blt	s6,a5,8000441a <end_op+0x108>
    write_log(dev);     // Write modified blocks from cache to log
    write_head(dev);    // Write header to disk -- the real commit
    8000447e:	8556                	mv	a0,s5
    80004480:	00000097          	auipc	ra,0x0
    80004484:	bc8080e7          	jalr	-1080(ra) # 80004048 <write_head>
    install_trans(dev); // Now install writes to home locations
    80004488:	8556                	mv	a0,s5
    8000448a:	00000097          	auipc	ra,0x0
    8000448e:	c48080e7          	jalr	-952(ra) # 800040d2 <install_trans>
    log[dev].lh.n = 0;
    80004492:	0b000793          	li	a5,176
    80004496:	02fa8733          	mul	a4,s5,a5
    8000449a:	0001c797          	auipc	a5,0x1c
    8000449e:	a6678793          	addi	a5,a5,-1434 # 8001ff00 <log>
    800044a2:	97ba                	add	a5,a5,a4
    800044a4:	0207aa23          	sw	zero,52(a5)
    write_head(dev);    // Erase the transaction from the log
    800044a8:	8556                	mv	a0,s5
    800044aa:	00000097          	auipc	ra,0x0
    800044ae:	b9e080e7          	jalr	-1122(ra) # 80004048 <write_head>
    800044b2:	bdc9                	j	80004384 <end_op+0x72>

00000000800044b4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800044b4:	7179                	addi	sp,sp,-48
    800044b6:	f406                	sd	ra,40(sp)
    800044b8:	f022                	sd	s0,32(sp)
    800044ba:	ec26                	sd	s1,24(sp)
    800044bc:	e84a                	sd	s2,16(sp)
    800044be:	e44e                	sd	s3,8(sp)
    800044c0:	e052                	sd	s4,0(sp)
    800044c2:	1800                	addi	s0,sp,48
  int i;

  int dev = b->dev;
    800044c4:	00852903          	lw	s2,8(a0)
  if (log[dev].lh.n >= LOGSIZE || log[dev].lh.n >= log[dev].size - 1)
    800044c8:	0b000793          	li	a5,176
    800044cc:	02f90733          	mul	a4,s2,a5
    800044d0:	0001c797          	auipc	a5,0x1c
    800044d4:	a3078793          	addi	a5,a5,-1488 # 8001ff00 <log>
    800044d8:	97ba                	add	a5,a5,a4
    800044da:	5bd4                	lw	a3,52(a5)
    800044dc:	47f5                	li	a5,29
    800044de:	0ad7cc63          	blt	a5,a3,80004596 <log_write+0xe2>
    800044e2:	89aa                	mv	s3,a0
    800044e4:	0001c797          	auipc	a5,0x1c
    800044e8:	a1c78793          	addi	a5,a5,-1508 # 8001ff00 <log>
    800044ec:	97ba                	add	a5,a5,a4
    800044ee:	53dc                	lw	a5,36(a5)
    800044f0:	37fd                	addiw	a5,a5,-1
    800044f2:	0af6d263          	bge	a3,a5,80004596 <log_write+0xe2>
    panic("too big a transaction");
  if (log[dev].outstanding < 1)
    800044f6:	0b000793          	li	a5,176
    800044fa:	02f90733          	mul	a4,s2,a5
    800044fe:	0001c797          	auipc	a5,0x1c
    80004502:	a0278793          	addi	a5,a5,-1534 # 8001ff00 <log>
    80004506:	97ba                	add	a5,a5,a4
    80004508:	579c                	lw	a5,40(a5)
    8000450a:	08f05e63          	blez	a5,800045a6 <log_write+0xf2>
    panic("log_write outside of trans");

  acquire(&log[dev].lock);
    8000450e:	0b000793          	li	a5,176
    80004512:	02f904b3          	mul	s1,s2,a5
    80004516:	0001ca17          	auipc	s4,0x1c
    8000451a:	9eaa0a13          	addi	s4,s4,-1558 # 8001ff00 <log>
    8000451e:	9a26                	add	s4,s4,s1
    80004520:	8552                	mv	a0,s4
    80004522:	ffffc097          	auipc	ra,0xffffc
    80004526:	58e080e7          	jalr	1422(ra) # 80000ab0 <acquire>
  for (i = 0; i < log[dev].lh.n; i++) {
    8000452a:	034a2603          	lw	a2,52(s4)
    8000452e:	08c05463          	blez	a2,800045b6 <log_write+0x102>
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    80004532:	00c9a583          	lw	a1,12(s3)
    80004536:	0001c797          	auipc	a5,0x1c
    8000453a:	a0278793          	addi	a5,a5,-1534 # 8001ff38 <log+0x38>
    8000453e:	97a6                	add	a5,a5,s1
  for (i = 0; i < log[dev].lh.n; i++) {
    80004540:	4701                	li	a4,0
    if (log[dev].lh.block[i] == b->blockno)   // log absorbtion
    80004542:	4394                	lw	a3,0(a5)
    80004544:	06b68a63          	beq	a3,a1,800045b8 <log_write+0x104>
  for (i = 0; i < log[dev].lh.n; i++) {
    80004548:	2705                	addiw	a4,a4,1
    8000454a:	0791                	addi	a5,a5,4
    8000454c:	fec71be3          	bne	a4,a2,80004542 <log_write+0x8e>
      break;
  }
  log[dev].lh.block[i] = b->blockno;
    80004550:	02c00793          	li	a5,44
    80004554:	02f907b3          	mul	a5,s2,a5
    80004558:	97b2                	add	a5,a5,a2
    8000455a:	07b1                	addi	a5,a5,12
    8000455c:	078a                	slli	a5,a5,0x2
    8000455e:	0001c717          	auipc	a4,0x1c
    80004562:	9a270713          	addi	a4,a4,-1630 # 8001ff00 <log>
    80004566:	97ba                	add	a5,a5,a4
    80004568:	00c9a703          	lw	a4,12(s3)
    8000456c:	c798                	sw	a4,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    bpin(b);
    8000456e:	854e                	mv	a0,s3
    80004570:	fffff097          	auipc	ra,0xfffff
    80004574:	ce0080e7          	jalr	-800(ra) # 80003250 <bpin>
    log[dev].lh.n++;
    80004578:	0b000793          	li	a5,176
    8000457c:	02f90933          	mul	s2,s2,a5
    80004580:	0001c797          	auipc	a5,0x1c
    80004584:	98078793          	addi	a5,a5,-1664 # 8001ff00 <log>
    80004588:	993e                	add	s2,s2,a5
    8000458a:	03492783          	lw	a5,52(s2)
    8000458e:	2785                	addiw	a5,a5,1
    80004590:	02f92a23          	sw	a5,52(s2)
    80004594:	a099                	j	800045da <log_write+0x126>
    panic("too big a transaction");
    80004596:	00004517          	auipc	a0,0x4
    8000459a:	40250513          	addi	a0,a0,1026 # 80008998 <userret+0x908>
    8000459e:	ffffc097          	auipc	ra,0xffffc
    800045a2:	fbc080e7          	jalr	-68(ra) # 8000055a <panic>
    panic("log_write outside of trans");
    800045a6:	00004517          	auipc	a0,0x4
    800045aa:	40a50513          	addi	a0,a0,1034 # 800089b0 <userret+0x920>
    800045ae:	ffffc097          	auipc	ra,0xffffc
    800045b2:	fac080e7          	jalr	-84(ra) # 8000055a <panic>
  for (i = 0; i < log[dev].lh.n; i++) {
    800045b6:	4701                	li	a4,0
  log[dev].lh.block[i] = b->blockno;
    800045b8:	02c00793          	li	a5,44
    800045bc:	02f907b3          	mul	a5,s2,a5
    800045c0:	97ba                	add	a5,a5,a4
    800045c2:	07b1                	addi	a5,a5,12
    800045c4:	078a                	slli	a5,a5,0x2
    800045c6:	0001c697          	auipc	a3,0x1c
    800045ca:	93a68693          	addi	a3,a3,-1734 # 8001ff00 <log>
    800045ce:	97b6                	add	a5,a5,a3
    800045d0:	00c9a683          	lw	a3,12(s3)
    800045d4:	c794                	sw	a3,8(a5)
  if (i == log[dev].lh.n) {  // Add new block to log?
    800045d6:	f8e60ce3          	beq	a2,a4,8000456e <log_write+0xba>
  }
  release(&log[dev].lock);
    800045da:	8552                	mv	a0,s4
    800045dc:	ffffc097          	auipc	ra,0xffffc
    800045e0:	5a4080e7          	jalr	1444(ra) # 80000b80 <release>
}
    800045e4:	70a2                	ld	ra,40(sp)
    800045e6:	7402                	ld	s0,32(sp)
    800045e8:	64e2                	ld	s1,24(sp)
    800045ea:	6942                	ld	s2,16(sp)
    800045ec:	69a2                	ld	s3,8(sp)
    800045ee:	6a02                	ld	s4,0(sp)
    800045f0:	6145                	addi	sp,sp,48
    800045f2:	8082                	ret

00000000800045f4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800045f4:	1101                	addi	sp,sp,-32
    800045f6:	ec06                	sd	ra,24(sp)
    800045f8:	e822                	sd	s0,16(sp)
    800045fa:	e426                	sd	s1,8(sp)
    800045fc:	e04a                	sd	s2,0(sp)
    800045fe:	1000                	addi	s0,sp,32
    80004600:	84aa                	mv	s1,a0
    80004602:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80004604:	00004597          	auipc	a1,0x4
    80004608:	3cc58593          	addi	a1,a1,972 # 800089d0 <userret+0x940>
    8000460c:	0521                	addi	a0,a0,8
    8000460e:	ffffc097          	auipc	ra,0xffffc
    80004612:	3ce080e7          	jalr	974(ra) # 800009dc <initlock>
  lk->name = name;
    80004616:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    8000461a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000461e:	0204a823          	sw	zero,48(s1)
}
    80004622:	60e2                	ld	ra,24(sp)
    80004624:	6442                	ld	s0,16(sp)
    80004626:	64a2                	ld	s1,8(sp)
    80004628:	6902                	ld	s2,0(sp)
    8000462a:	6105                	addi	sp,sp,32
    8000462c:	8082                	ret

000000008000462e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000462e:	1101                	addi	sp,sp,-32
    80004630:	ec06                	sd	ra,24(sp)
    80004632:	e822                	sd	s0,16(sp)
    80004634:	e426                	sd	s1,8(sp)
    80004636:	e04a                	sd	s2,0(sp)
    80004638:	1000                	addi	s0,sp,32
    8000463a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000463c:	00850913          	addi	s2,a0,8
    80004640:	854a                	mv	a0,s2
    80004642:	ffffc097          	auipc	ra,0xffffc
    80004646:	46e080e7          	jalr	1134(ra) # 80000ab0 <acquire>
  while (lk->locked) {
    8000464a:	409c                	lw	a5,0(s1)
    8000464c:	cb89                	beqz	a5,8000465e <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000464e:	85ca                	mv	a1,s2
    80004650:	8526                	mv	a0,s1
    80004652:	ffffe097          	auipc	ra,0xffffe
    80004656:	ca0080e7          	jalr	-864(ra) # 800022f2 <sleep>
  while (lk->locked) {
    8000465a:	409c                	lw	a5,0(s1)
    8000465c:	fbed                	bnez	a5,8000464e <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000465e:	4785                	li	a5,1
    80004660:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80004662:	ffffd097          	auipc	ra,0xffffd
    80004666:	4d4080e7          	jalr	1236(ra) # 80001b36 <myproc>
    8000466a:	413c                	lw	a5,64(a0)
    8000466c:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    8000466e:	854a                	mv	a0,s2
    80004670:	ffffc097          	auipc	ra,0xffffc
    80004674:	510080e7          	jalr	1296(ra) # 80000b80 <release>
}
    80004678:	60e2                	ld	ra,24(sp)
    8000467a:	6442                	ld	s0,16(sp)
    8000467c:	64a2                	ld	s1,8(sp)
    8000467e:	6902                	ld	s2,0(sp)
    80004680:	6105                	addi	sp,sp,32
    80004682:	8082                	ret

0000000080004684 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80004684:	1101                	addi	sp,sp,-32
    80004686:	ec06                	sd	ra,24(sp)
    80004688:	e822                	sd	s0,16(sp)
    8000468a:	e426                	sd	s1,8(sp)
    8000468c:	e04a                	sd	s2,0(sp)
    8000468e:	1000                	addi	s0,sp,32
    80004690:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80004692:	00850913          	addi	s2,a0,8
    80004696:	854a                	mv	a0,s2
    80004698:	ffffc097          	auipc	ra,0xffffc
    8000469c:	418080e7          	jalr	1048(ra) # 80000ab0 <acquire>
  lk->locked = 0;
    800046a0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800046a4:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    800046a8:	8526                	mv	a0,s1
    800046aa:	ffffe097          	auipc	ra,0xffffe
    800046ae:	dce080e7          	jalr	-562(ra) # 80002478 <wakeup>
  release(&lk->lk);
    800046b2:	854a                	mv	a0,s2
    800046b4:	ffffc097          	auipc	ra,0xffffc
    800046b8:	4cc080e7          	jalr	1228(ra) # 80000b80 <release>
}
    800046bc:	60e2                	ld	ra,24(sp)
    800046be:	6442                	ld	s0,16(sp)
    800046c0:	64a2                	ld	s1,8(sp)
    800046c2:	6902                	ld	s2,0(sp)
    800046c4:	6105                	addi	sp,sp,32
    800046c6:	8082                	ret

00000000800046c8 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800046c8:	7179                	addi	sp,sp,-48
    800046ca:	f406                	sd	ra,40(sp)
    800046cc:	f022                	sd	s0,32(sp)
    800046ce:	ec26                	sd	s1,24(sp)
    800046d0:	e84a                	sd	s2,16(sp)
    800046d2:	e44e                	sd	s3,8(sp)
    800046d4:	1800                	addi	s0,sp,48
    800046d6:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800046d8:	00850913          	addi	s2,a0,8
    800046dc:	854a                	mv	a0,s2
    800046de:	ffffc097          	auipc	ra,0xffffc
    800046e2:	3d2080e7          	jalr	978(ra) # 80000ab0 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800046e6:	409c                	lw	a5,0(s1)
    800046e8:	ef99                	bnez	a5,80004706 <holdingsleep+0x3e>
    800046ea:	4481                	li	s1,0
  release(&lk->lk);
    800046ec:	854a                	mv	a0,s2
    800046ee:	ffffc097          	auipc	ra,0xffffc
    800046f2:	492080e7          	jalr	1170(ra) # 80000b80 <release>
  return r;
}
    800046f6:	8526                	mv	a0,s1
    800046f8:	70a2                	ld	ra,40(sp)
    800046fa:	7402                	ld	s0,32(sp)
    800046fc:	64e2                	ld	s1,24(sp)
    800046fe:	6942                	ld	s2,16(sp)
    80004700:	69a2                	ld	s3,8(sp)
    80004702:	6145                	addi	sp,sp,48
    80004704:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80004706:	0304a983          	lw	s3,48(s1)
    8000470a:	ffffd097          	auipc	ra,0xffffd
    8000470e:	42c080e7          	jalr	1068(ra) # 80001b36 <myproc>
    80004712:	4124                	lw	s1,64(a0)
    80004714:	413484b3          	sub	s1,s1,s3
    80004718:	0014b493          	seqz	s1,s1
    8000471c:	bfc1                	j	800046ec <holdingsleep+0x24>

000000008000471e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000471e:	1141                	addi	sp,sp,-16
    80004720:	e406                	sd	ra,8(sp)
    80004722:	e022                	sd	s0,0(sp)
    80004724:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004726:	00004597          	auipc	a1,0x4
    8000472a:	2ba58593          	addi	a1,a1,698 # 800089e0 <userret+0x950>
    8000472e:	0001c517          	auipc	a0,0x1c
    80004732:	9d250513          	addi	a0,a0,-1582 # 80020100 <ftable>
    80004736:	ffffc097          	auipc	ra,0xffffc
    8000473a:	2a6080e7          	jalr	678(ra) # 800009dc <initlock>
}
    8000473e:	60a2                	ld	ra,8(sp)
    80004740:	6402                	ld	s0,0(sp)
    80004742:	0141                	addi	sp,sp,16
    80004744:	8082                	ret

0000000080004746 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80004746:	1101                	addi	sp,sp,-32
    80004748:	ec06                	sd	ra,24(sp)
    8000474a:	e822                	sd	s0,16(sp)
    8000474c:	e426                	sd	s1,8(sp)
    8000474e:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004750:	0001c517          	auipc	a0,0x1c
    80004754:	9b050513          	addi	a0,a0,-1616 # 80020100 <ftable>
    80004758:	ffffc097          	auipc	ra,0xffffc
    8000475c:	358080e7          	jalr	856(ra) # 80000ab0 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004760:	0001c497          	auipc	s1,0x1c
    80004764:	9c048493          	addi	s1,s1,-1600 # 80020120 <ftable+0x20>
    80004768:	0001d717          	auipc	a4,0x1d
    8000476c:	95870713          	addi	a4,a4,-1704 # 800210c0 <ftable+0xfc0>
    if(f->ref == 0){
    80004770:	40dc                	lw	a5,4(s1)
    80004772:	cf99                	beqz	a5,80004790 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80004774:	02848493          	addi	s1,s1,40
    80004778:	fee49ce3          	bne	s1,a4,80004770 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000477c:	0001c517          	auipc	a0,0x1c
    80004780:	98450513          	addi	a0,a0,-1660 # 80020100 <ftable>
    80004784:	ffffc097          	auipc	ra,0xffffc
    80004788:	3fc080e7          	jalr	1020(ra) # 80000b80 <release>
  return 0;
    8000478c:	4481                	li	s1,0
    8000478e:	a819                	j	800047a4 <filealloc+0x5e>
      f->ref = 1;
    80004790:	4785                	li	a5,1
    80004792:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004794:	0001c517          	auipc	a0,0x1c
    80004798:	96c50513          	addi	a0,a0,-1684 # 80020100 <ftable>
    8000479c:	ffffc097          	auipc	ra,0xffffc
    800047a0:	3e4080e7          	jalr	996(ra) # 80000b80 <release>
}
    800047a4:	8526                	mv	a0,s1
    800047a6:	60e2                	ld	ra,24(sp)
    800047a8:	6442                	ld	s0,16(sp)
    800047aa:	64a2                	ld	s1,8(sp)
    800047ac:	6105                	addi	sp,sp,32
    800047ae:	8082                	ret

00000000800047b0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800047b0:	1101                	addi	sp,sp,-32
    800047b2:	ec06                	sd	ra,24(sp)
    800047b4:	e822                	sd	s0,16(sp)
    800047b6:	e426                	sd	s1,8(sp)
    800047b8:	1000                	addi	s0,sp,32
    800047ba:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800047bc:	0001c517          	auipc	a0,0x1c
    800047c0:	94450513          	addi	a0,a0,-1724 # 80020100 <ftable>
    800047c4:	ffffc097          	auipc	ra,0xffffc
    800047c8:	2ec080e7          	jalr	748(ra) # 80000ab0 <acquire>
  if(f->ref < 1)
    800047cc:	40dc                	lw	a5,4(s1)
    800047ce:	02f05263          	blez	a5,800047f2 <filedup+0x42>
    panic("filedup");
  f->ref++;
    800047d2:	2785                	addiw	a5,a5,1
    800047d4:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800047d6:	0001c517          	auipc	a0,0x1c
    800047da:	92a50513          	addi	a0,a0,-1750 # 80020100 <ftable>
    800047de:	ffffc097          	auipc	ra,0xffffc
    800047e2:	3a2080e7          	jalr	930(ra) # 80000b80 <release>
  return f;
}
    800047e6:	8526                	mv	a0,s1
    800047e8:	60e2                	ld	ra,24(sp)
    800047ea:	6442                	ld	s0,16(sp)
    800047ec:	64a2                	ld	s1,8(sp)
    800047ee:	6105                	addi	sp,sp,32
    800047f0:	8082                	ret
    panic("filedup");
    800047f2:	00004517          	auipc	a0,0x4
    800047f6:	1f650513          	addi	a0,a0,502 # 800089e8 <userret+0x958>
    800047fa:	ffffc097          	auipc	ra,0xffffc
    800047fe:	d60080e7          	jalr	-672(ra) # 8000055a <panic>

0000000080004802 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80004802:	7139                	addi	sp,sp,-64
    80004804:	fc06                	sd	ra,56(sp)
    80004806:	f822                	sd	s0,48(sp)
    80004808:	f426                	sd	s1,40(sp)
    8000480a:	f04a                	sd	s2,32(sp)
    8000480c:	ec4e                	sd	s3,24(sp)
    8000480e:	e852                	sd	s4,16(sp)
    80004810:	e456                	sd	s5,8(sp)
    80004812:	0080                	addi	s0,sp,64
    80004814:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80004816:	0001c517          	auipc	a0,0x1c
    8000481a:	8ea50513          	addi	a0,a0,-1814 # 80020100 <ftable>
    8000481e:	ffffc097          	auipc	ra,0xffffc
    80004822:	292080e7          	jalr	658(ra) # 80000ab0 <acquire>
  if(f->ref < 1)
    80004826:	40dc                	lw	a5,4(s1)
    80004828:	06f05563          	blez	a5,80004892 <fileclose+0x90>
    panic("fileclose");
  if(--f->ref > 0){
    8000482c:	37fd                	addiw	a5,a5,-1
    8000482e:	0007871b          	sext.w	a4,a5
    80004832:	c0dc                	sw	a5,4(s1)
    80004834:	06e04763          	bgtz	a4,800048a2 <fileclose+0xa0>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80004838:	0004a903          	lw	s2,0(s1)
    8000483c:	0094ca83          	lbu	s5,9(s1)
    80004840:	0104ba03          	ld	s4,16(s1)
    80004844:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80004848:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000484c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004850:	0001c517          	auipc	a0,0x1c
    80004854:	8b050513          	addi	a0,a0,-1872 # 80020100 <ftable>
    80004858:	ffffc097          	auipc	ra,0xffffc
    8000485c:	328080e7          	jalr	808(ra) # 80000b80 <release>

  if(ff.type == FD_PIPE){
    80004860:	4785                	li	a5,1
    80004862:	06f90163          	beq	s2,a5,800048c4 <fileclose+0xc2>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80004866:	3979                	addiw	s2,s2,-2
    80004868:	4785                	li	a5,1
    8000486a:	0527e463          	bltu	a5,s2,800048b2 <fileclose+0xb0>
    begin_op(ff.ip->dev);
    8000486e:	0009a503          	lw	a0,0(s3)
    80004872:	00000097          	auipc	ra,0x0
    80004876:	9f6080e7          	jalr	-1546(ra) # 80004268 <begin_op>
    iput(ff.ip);
    8000487a:	854e                	mv	a0,s3
    8000487c:	fffff097          	auipc	ra,0xfffff
    80004880:	116080e7          	jalr	278(ra) # 80003992 <iput>
    end_op(ff.ip->dev);
    80004884:	0009a503          	lw	a0,0(s3)
    80004888:	00000097          	auipc	ra,0x0
    8000488c:	a8a080e7          	jalr	-1398(ra) # 80004312 <end_op>
    80004890:	a00d                	j	800048b2 <fileclose+0xb0>
    panic("fileclose");
    80004892:	00004517          	auipc	a0,0x4
    80004896:	15e50513          	addi	a0,a0,350 # 800089f0 <userret+0x960>
    8000489a:	ffffc097          	auipc	ra,0xffffc
    8000489e:	cc0080e7          	jalr	-832(ra) # 8000055a <panic>
    release(&ftable.lock);
    800048a2:	0001c517          	auipc	a0,0x1c
    800048a6:	85e50513          	addi	a0,a0,-1954 # 80020100 <ftable>
    800048aa:	ffffc097          	auipc	ra,0xffffc
    800048ae:	2d6080e7          	jalr	726(ra) # 80000b80 <release>
  }
}
    800048b2:	70e2                	ld	ra,56(sp)
    800048b4:	7442                	ld	s0,48(sp)
    800048b6:	74a2                	ld	s1,40(sp)
    800048b8:	7902                	ld	s2,32(sp)
    800048ba:	69e2                	ld	s3,24(sp)
    800048bc:	6a42                	ld	s4,16(sp)
    800048be:	6aa2                	ld	s5,8(sp)
    800048c0:	6121                	addi	sp,sp,64
    800048c2:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800048c4:	85d6                	mv	a1,s5
    800048c6:	8552                	mv	a0,s4
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	376080e7          	jalr	886(ra) # 80004c3e <pipeclose>
    800048d0:	b7cd                	j	800048b2 <fileclose+0xb0>

00000000800048d2 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800048d2:	715d                	addi	sp,sp,-80
    800048d4:	e486                	sd	ra,72(sp)
    800048d6:	e0a2                	sd	s0,64(sp)
    800048d8:	fc26                	sd	s1,56(sp)
    800048da:	f84a                	sd	s2,48(sp)
    800048dc:	f44e                	sd	s3,40(sp)
    800048de:	0880                	addi	s0,sp,80
    800048e0:	84aa                	mv	s1,a0
    800048e2:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    800048e4:	ffffd097          	auipc	ra,0xffffd
    800048e8:	252080e7          	jalr	594(ra) # 80001b36 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800048ec:	409c                	lw	a5,0(s1)
    800048ee:	37f9                	addiw	a5,a5,-2
    800048f0:	4705                	li	a4,1
    800048f2:	04f76763          	bltu	a4,a5,80004940 <filestat+0x6e>
    800048f6:	892a                	mv	s2,a0
    ilock(f->ip);
    800048f8:	6c88                	ld	a0,24(s1)
    800048fa:	fffff097          	auipc	ra,0xfffff
    800048fe:	f8a080e7          	jalr	-118(ra) # 80003884 <ilock>
    stati(f->ip, &st);
    80004902:	fb840593          	addi	a1,s0,-72
    80004906:	6c88                	ld	a0,24(s1)
    80004908:	fffff097          	auipc	ra,0xfffff
    8000490c:	1e2080e7          	jalr	482(ra) # 80003aea <stati>
    iunlock(f->ip);
    80004910:	6c88                	ld	a0,24(s1)
    80004912:	fffff097          	auipc	ra,0xfffff
    80004916:	034080e7          	jalr	52(ra) # 80003946 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000491a:	46e1                	li	a3,24
    8000491c:	fb840613          	addi	a2,s0,-72
    80004920:	85ce                	mv	a1,s3
    80004922:	05893503          	ld	a0,88(s2)
    80004926:	ffffd097          	auipc	ra,0xffffd
    8000492a:	f04080e7          	jalr	-252(ra) # 8000182a <copyout>
    8000492e:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80004932:	60a6                	ld	ra,72(sp)
    80004934:	6406                	ld	s0,64(sp)
    80004936:	74e2                	ld	s1,56(sp)
    80004938:	7942                	ld	s2,48(sp)
    8000493a:	79a2                	ld	s3,40(sp)
    8000493c:	6161                	addi	sp,sp,80
    8000493e:	8082                	ret
  return -1;
    80004940:	557d                	li	a0,-1
    80004942:	bfc5                	j	80004932 <filestat+0x60>

0000000080004944 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004944:	7179                	addi	sp,sp,-48
    80004946:	f406                	sd	ra,40(sp)
    80004948:	f022                	sd	s0,32(sp)
    8000494a:	ec26                	sd	s1,24(sp)
    8000494c:	e84a                	sd	s2,16(sp)
    8000494e:	e44e                	sd	s3,8(sp)
    80004950:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80004952:	00854783          	lbu	a5,8(a0)
    80004956:	c7c5                	beqz	a5,800049fe <fileread+0xba>
    80004958:	84aa                	mv	s1,a0
    8000495a:	89ae                	mv	s3,a1
    8000495c:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    8000495e:	411c                	lw	a5,0(a0)
    80004960:	4705                	li	a4,1
    80004962:	04e78963          	beq	a5,a4,800049b4 <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004966:	470d                	li	a4,3
    80004968:	04e78d63          	beq	a5,a4,800049c2 <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    8000496c:	4709                	li	a4,2
    8000496e:	08e79063          	bne	a5,a4,800049ee <fileread+0xaa>
    ilock(f->ip);
    80004972:	6d08                	ld	a0,24(a0)
    80004974:	fffff097          	auipc	ra,0xfffff
    80004978:	f10080e7          	jalr	-240(ra) # 80003884 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000497c:	874a                	mv	a4,s2
    8000497e:	5094                	lw	a3,32(s1)
    80004980:	864e                	mv	a2,s3
    80004982:	4585                	li	a1,1
    80004984:	6c88                	ld	a0,24(s1)
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	18e080e7          	jalr	398(ra) # 80003b14 <readi>
    8000498e:	892a                	mv	s2,a0
    80004990:	00a05563          	blez	a0,8000499a <fileread+0x56>
      f->off += r;
    80004994:	509c                	lw	a5,32(s1)
    80004996:	9fa9                	addw	a5,a5,a0
    80004998:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000499a:	6c88                	ld	a0,24(s1)
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	faa080e7          	jalr	-86(ra) # 80003946 <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    800049a4:	854a                	mv	a0,s2
    800049a6:	70a2                	ld	ra,40(sp)
    800049a8:	7402                	ld	s0,32(sp)
    800049aa:	64e2                	ld	s1,24(sp)
    800049ac:	6942                	ld	s2,16(sp)
    800049ae:	69a2                	ld	s3,8(sp)
    800049b0:	6145                	addi	sp,sp,48
    800049b2:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800049b4:	6908                	ld	a0,16(a0)
    800049b6:	00000097          	auipc	ra,0x0
    800049ba:	40c080e7          	jalr	1036(ra) # 80004dc2 <piperead>
    800049be:	892a                	mv	s2,a0
    800049c0:	b7d5                	j	800049a4 <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800049c2:	02451783          	lh	a5,36(a0)
    800049c6:	03079693          	slli	a3,a5,0x30
    800049ca:	92c1                	srli	a3,a3,0x30
    800049cc:	4725                	li	a4,9
    800049ce:	02d76a63          	bltu	a4,a3,80004a02 <fileread+0xbe>
    800049d2:	0792                	slli	a5,a5,0x4
    800049d4:	0001b717          	auipc	a4,0x1b
    800049d8:	68c70713          	addi	a4,a4,1676 # 80020060 <devsw>
    800049dc:	97ba                	add	a5,a5,a4
    800049de:	639c                	ld	a5,0(a5)
    800049e0:	c39d                	beqz	a5,80004a06 <fileread+0xc2>
    r = devsw[f->major].read(f, 1, addr, n);
    800049e2:	86b2                	mv	a3,a2
    800049e4:	862e                	mv	a2,a1
    800049e6:	4585                	li	a1,1
    800049e8:	9782                	jalr	a5
    800049ea:	892a                	mv	s2,a0
    800049ec:	bf65                	j	800049a4 <fileread+0x60>
    panic("fileread");
    800049ee:	00004517          	auipc	a0,0x4
    800049f2:	01250513          	addi	a0,a0,18 # 80008a00 <userret+0x970>
    800049f6:	ffffc097          	auipc	ra,0xffffc
    800049fa:	b64080e7          	jalr	-1180(ra) # 8000055a <panic>
    return -1;
    800049fe:	597d                	li	s2,-1
    80004a00:	b755                	j	800049a4 <fileread+0x60>
      return -1;
    80004a02:	597d                	li	s2,-1
    80004a04:	b745                	j	800049a4 <fileread+0x60>
    80004a06:	597d                	li	s2,-1
    80004a08:	bf71                	j	800049a4 <fileread+0x60>

0000000080004a0a <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80004a0a:	00954783          	lbu	a5,9(a0)
    80004a0e:	14078663          	beqz	a5,80004b5a <filewrite+0x150>
{
    80004a12:	715d                	addi	sp,sp,-80
    80004a14:	e486                	sd	ra,72(sp)
    80004a16:	e0a2                	sd	s0,64(sp)
    80004a18:	fc26                	sd	s1,56(sp)
    80004a1a:	f84a                	sd	s2,48(sp)
    80004a1c:	f44e                	sd	s3,40(sp)
    80004a1e:	f052                	sd	s4,32(sp)
    80004a20:	ec56                	sd	s5,24(sp)
    80004a22:	e85a                	sd	s6,16(sp)
    80004a24:	e45e                	sd	s7,8(sp)
    80004a26:	e062                	sd	s8,0(sp)
    80004a28:	0880                	addi	s0,sp,80
    80004a2a:	84aa                	mv	s1,a0
    80004a2c:	8aae                	mv	s5,a1
    80004a2e:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80004a30:	411c                	lw	a5,0(a0)
    80004a32:	4705                	li	a4,1
    80004a34:	02e78263          	beq	a5,a4,80004a58 <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80004a38:	470d                	li	a4,3
    80004a3a:	02e78563          	beq	a5,a4,80004a64 <filewrite+0x5a>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(f, 1, addr, n);
  } else if(f->type == FD_INODE){
    80004a3e:	4709                	li	a4,2
    80004a40:	10e79563          	bne	a5,a4,80004b4a <filewrite+0x140>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80004a44:	0ec05f63          	blez	a2,80004b42 <filewrite+0x138>
    int i = 0;
    80004a48:	4981                	li	s3,0
    80004a4a:	6b05                	lui	s6,0x1
    80004a4c:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80004a50:	6b85                	lui	s7,0x1
    80004a52:	c00b8b9b          	addiw	s7,s7,-1024
    80004a56:	a851                	j	80004aea <filewrite+0xe0>
    ret = pipewrite(f->pipe, addr, n);
    80004a58:	6908                	ld	a0,16(a0)
    80004a5a:	00000097          	auipc	ra,0x0
    80004a5e:	254080e7          	jalr	596(ra) # 80004cae <pipewrite>
    80004a62:	a865                	j	80004b1a <filewrite+0x110>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004a64:	02451783          	lh	a5,36(a0)
    80004a68:	03079693          	slli	a3,a5,0x30
    80004a6c:	92c1                	srli	a3,a3,0x30
    80004a6e:	4725                	li	a4,9
    80004a70:	0ed76763          	bltu	a4,a3,80004b5e <filewrite+0x154>
    80004a74:	0792                	slli	a5,a5,0x4
    80004a76:	0001b717          	auipc	a4,0x1b
    80004a7a:	5ea70713          	addi	a4,a4,1514 # 80020060 <devsw>
    80004a7e:	97ba                	add	a5,a5,a4
    80004a80:	679c                	ld	a5,8(a5)
    80004a82:	c3e5                	beqz	a5,80004b62 <filewrite+0x158>
    ret = devsw[f->major].write(f, 1, addr, n);
    80004a84:	86b2                	mv	a3,a2
    80004a86:	862e                	mv	a2,a1
    80004a88:	4585                	li	a1,1
    80004a8a:	9782                	jalr	a5
    80004a8c:	a079                	j	80004b1a <filewrite+0x110>
    80004a8e:	00090c1b          	sext.w	s8,s2
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op(f->ip->dev);
    80004a92:	6c9c                	ld	a5,24(s1)
    80004a94:	4388                	lw	a0,0(a5)
    80004a96:	fffff097          	auipc	ra,0xfffff
    80004a9a:	7d2080e7          	jalr	2002(ra) # 80004268 <begin_op>
      ilock(f->ip);
    80004a9e:	6c88                	ld	a0,24(s1)
    80004aa0:	fffff097          	auipc	ra,0xfffff
    80004aa4:	de4080e7          	jalr	-540(ra) # 80003884 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004aa8:	8762                	mv	a4,s8
    80004aaa:	5094                	lw	a3,32(s1)
    80004aac:	01598633          	add	a2,s3,s5
    80004ab0:	4585                	li	a1,1
    80004ab2:	6c88                	ld	a0,24(s1)
    80004ab4:	fffff097          	auipc	ra,0xfffff
    80004ab8:	154080e7          	jalr	340(ra) # 80003c08 <writei>
    80004abc:	892a                	mv	s2,a0
    80004abe:	02a05e63          	blez	a0,80004afa <filewrite+0xf0>
        f->off += r;
    80004ac2:	509c                	lw	a5,32(s1)
    80004ac4:	9fa9                	addw	a5,a5,a0
    80004ac6:	d09c                	sw	a5,32(s1)
      iunlock(f->ip);
    80004ac8:	6c88                	ld	a0,24(s1)
    80004aca:	fffff097          	auipc	ra,0xfffff
    80004ace:	e7c080e7          	jalr	-388(ra) # 80003946 <iunlock>
      end_op(f->ip->dev);
    80004ad2:	6c9c                	ld	a5,24(s1)
    80004ad4:	4388                	lw	a0,0(a5)
    80004ad6:	00000097          	auipc	ra,0x0
    80004ada:	83c080e7          	jalr	-1988(ra) # 80004312 <end_op>

      if(r < 0)
        break;
      if(r != n1)
    80004ade:	052c1a63          	bne	s8,s2,80004b32 <filewrite+0x128>
        panic("short filewrite");
      i += r;
    80004ae2:	013909bb          	addw	s3,s2,s3
    while(i < n){
    80004ae6:	0349d763          	bge	s3,s4,80004b14 <filewrite+0x10a>
      int n1 = n - i;
    80004aea:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80004aee:	893e                	mv	s2,a5
    80004af0:	2781                	sext.w	a5,a5
    80004af2:	f8fb5ee3          	bge	s6,a5,80004a8e <filewrite+0x84>
    80004af6:	895e                	mv	s2,s7
    80004af8:	bf59                	j	80004a8e <filewrite+0x84>
      iunlock(f->ip);
    80004afa:	6c88                	ld	a0,24(s1)
    80004afc:	fffff097          	auipc	ra,0xfffff
    80004b00:	e4a080e7          	jalr	-438(ra) # 80003946 <iunlock>
      end_op(f->ip->dev);
    80004b04:	6c9c                	ld	a5,24(s1)
    80004b06:	4388                	lw	a0,0(a5)
    80004b08:	00000097          	auipc	ra,0x0
    80004b0c:	80a080e7          	jalr	-2038(ra) # 80004312 <end_op>
      if(r < 0)
    80004b10:	fc0957e3          	bgez	s2,80004ade <filewrite+0xd4>
    }
    ret = (i == n ? n : -1);
    80004b14:	8552                	mv	a0,s4
    80004b16:	033a1863          	bne	s4,s3,80004b46 <filewrite+0x13c>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80004b1a:	60a6                	ld	ra,72(sp)
    80004b1c:	6406                	ld	s0,64(sp)
    80004b1e:	74e2                	ld	s1,56(sp)
    80004b20:	7942                	ld	s2,48(sp)
    80004b22:	79a2                	ld	s3,40(sp)
    80004b24:	7a02                	ld	s4,32(sp)
    80004b26:	6ae2                	ld	s5,24(sp)
    80004b28:	6b42                	ld	s6,16(sp)
    80004b2a:	6ba2                	ld	s7,8(sp)
    80004b2c:	6c02                	ld	s8,0(sp)
    80004b2e:	6161                	addi	sp,sp,80
    80004b30:	8082                	ret
        panic("short filewrite");
    80004b32:	00004517          	auipc	a0,0x4
    80004b36:	ede50513          	addi	a0,a0,-290 # 80008a10 <userret+0x980>
    80004b3a:	ffffc097          	auipc	ra,0xffffc
    80004b3e:	a20080e7          	jalr	-1504(ra) # 8000055a <panic>
    int i = 0;
    80004b42:	4981                	li	s3,0
    80004b44:	bfc1                	j	80004b14 <filewrite+0x10a>
    ret = (i == n ? n : -1);
    80004b46:	557d                	li	a0,-1
    80004b48:	bfc9                	j	80004b1a <filewrite+0x110>
    panic("filewrite");
    80004b4a:	00004517          	auipc	a0,0x4
    80004b4e:	ed650513          	addi	a0,a0,-298 # 80008a20 <userret+0x990>
    80004b52:	ffffc097          	auipc	ra,0xffffc
    80004b56:	a08080e7          	jalr	-1528(ra) # 8000055a <panic>
    return -1;
    80004b5a:	557d                	li	a0,-1
}
    80004b5c:	8082                	ret
      return -1;
    80004b5e:	557d                	li	a0,-1
    80004b60:	bf6d                	j	80004b1a <filewrite+0x110>
    80004b62:	557d                	li	a0,-1
    80004b64:	bf5d                	j	80004b1a <filewrite+0x110>

0000000080004b66 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80004b66:	7179                	addi	sp,sp,-48
    80004b68:	f406                	sd	ra,40(sp)
    80004b6a:	f022                	sd	s0,32(sp)
    80004b6c:	ec26                	sd	s1,24(sp)
    80004b6e:	e84a                	sd	s2,16(sp)
    80004b70:	e44e                	sd	s3,8(sp)
    80004b72:	e052                	sd	s4,0(sp)
    80004b74:	1800                	addi	s0,sp,48
    80004b76:	84aa                	mv	s1,a0
    80004b78:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80004b7a:	0005b023          	sd	zero,0(a1)
    80004b7e:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004b82:	00000097          	auipc	ra,0x0
    80004b86:	bc4080e7          	jalr	-1084(ra) # 80004746 <filealloc>
    80004b8a:	e088                	sd	a0,0(s1)
    80004b8c:	c549                	beqz	a0,80004c16 <pipealloc+0xb0>
    80004b8e:	00000097          	auipc	ra,0x0
    80004b92:	bb8080e7          	jalr	-1096(ra) # 80004746 <filealloc>
    80004b96:	00aa3023          	sd	a0,0(s4)
    80004b9a:	c925                	beqz	a0,80004c0a <pipealloc+0xa4>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80004b9c:	ffffc097          	auipc	ra,0xffffc
    80004ba0:	de0080e7          	jalr	-544(ra) # 8000097c <kalloc>
    80004ba4:	892a                	mv	s2,a0
    80004ba6:	cd39                	beqz	a0,80004c04 <pipealloc+0x9e>
    goto bad;
  pi->readopen = 1;
    80004ba8:	4985                	li	s3,1
    80004baa:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    80004bae:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80004bb2:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80004bb6:	22052023          	sw	zero,544(a0)
  memset(&pi->lock, 0, sizeof(pi->lock));
    80004bba:	02000613          	li	a2,32
    80004bbe:	4581                	li	a1,0
    80004bc0:	ffffc097          	auipc	ra,0xffffc
    80004bc4:	1be080e7          	jalr	446(ra) # 80000d7e <memset>
  (*f0)->type = FD_PIPE;
    80004bc8:	609c                	ld	a5,0(s1)
    80004bca:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004bce:	609c                	ld	a5,0(s1)
    80004bd0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004bd4:	609c                	ld	a5,0(s1)
    80004bd6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004bda:	609c                	ld	a5,0(s1)
    80004bdc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004be0:	000a3783          	ld	a5,0(s4)
    80004be4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004be8:	000a3783          	ld	a5,0(s4)
    80004bec:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80004bf0:	000a3783          	ld	a5,0(s4)
    80004bf4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004bf8:	000a3783          	ld	a5,0(s4)
    80004bfc:	0127b823          	sd	s2,16(a5)
  return 0;
    80004c00:	4501                	li	a0,0
    80004c02:	a025                	j	80004c2a <pipealloc+0xc4>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80004c04:	6088                	ld	a0,0(s1)
    80004c06:	e501                	bnez	a0,80004c0e <pipealloc+0xa8>
    80004c08:	a039                	j	80004c16 <pipealloc+0xb0>
    80004c0a:	6088                	ld	a0,0(s1)
    80004c0c:	c51d                	beqz	a0,80004c3a <pipealloc+0xd4>
    fileclose(*f0);
    80004c0e:	00000097          	auipc	ra,0x0
    80004c12:	bf4080e7          	jalr	-1036(ra) # 80004802 <fileclose>
  if(*f1)
    80004c16:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80004c1a:	557d                	li	a0,-1
  if(*f1)
    80004c1c:	c799                	beqz	a5,80004c2a <pipealloc+0xc4>
    fileclose(*f1);
    80004c1e:	853e                	mv	a0,a5
    80004c20:	00000097          	auipc	ra,0x0
    80004c24:	be2080e7          	jalr	-1054(ra) # 80004802 <fileclose>
  return -1;
    80004c28:	557d                	li	a0,-1
}
    80004c2a:	70a2                	ld	ra,40(sp)
    80004c2c:	7402                	ld	s0,32(sp)
    80004c2e:	64e2                	ld	s1,24(sp)
    80004c30:	6942                	ld	s2,16(sp)
    80004c32:	69a2                	ld	s3,8(sp)
    80004c34:	6a02                	ld	s4,0(sp)
    80004c36:	6145                	addi	sp,sp,48
    80004c38:	8082                	ret
  return -1;
    80004c3a:	557d                	li	a0,-1
    80004c3c:	b7fd                	j	80004c2a <pipealloc+0xc4>

0000000080004c3e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004c3e:	1101                	addi	sp,sp,-32
    80004c40:	ec06                	sd	ra,24(sp)
    80004c42:	e822                	sd	s0,16(sp)
    80004c44:	e426                	sd	s1,8(sp)
    80004c46:	e04a                	sd	s2,0(sp)
    80004c48:	1000                	addi	s0,sp,32
    80004c4a:	84aa                	mv	s1,a0
    80004c4c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80004c4e:	ffffc097          	auipc	ra,0xffffc
    80004c52:	e62080e7          	jalr	-414(ra) # 80000ab0 <acquire>
  if(writable){
    80004c56:	02090d63          	beqz	s2,80004c90 <pipeclose+0x52>
    pi->writeopen = 0;
    80004c5a:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    80004c5e:	22048513          	addi	a0,s1,544
    80004c62:	ffffe097          	auipc	ra,0xffffe
    80004c66:	816080e7          	jalr	-2026(ra) # 80002478 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80004c6a:	2284b783          	ld	a5,552(s1)
    80004c6e:	eb95                	bnez	a5,80004ca2 <pipeclose+0x64>
    release(&pi->lock);
    80004c70:	8526                	mv	a0,s1
    80004c72:	ffffc097          	auipc	ra,0xffffc
    80004c76:	f0e080e7          	jalr	-242(ra) # 80000b80 <release>
    kfree((char*)pi);
    80004c7a:	8526                	mv	a0,s1
    80004c7c:	ffffc097          	auipc	ra,0xffffc
    80004c80:	c04080e7          	jalr	-1020(ra) # 80000880 <kfree>
  } else
    release(&pi->lock);
}
    80004c84:	60e2                	ld	ra,24(sp)
    80004c86:	6442                	ld	s0,16(sp)
    80004c88:	64a2                	ld	s1,8(sp)
    80004c8a:	6902                	ld	s2,0(sp)
    80004c8c:	6105                	addi	sp,sp,32
    80004c8e:	8082                	ret
    pi->readopen = 0;
    80004c90:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    80004c94:	22448513          	addi	a0,s1,548
    80004c98:	ffffd097          	auipc	ra,0xffffd
    80004c9c:	7e0080e7          	jalr	2016(ra) # 80002478 <wakeup>
    80004ca0:	b7e9                	j	80004c6a <pipeclose+0x2c>
    release(&pi->lock);
    80004ca2:	8526                	mv	a0,s1
    80004ca4:	ffffc097          	auipc	ra,0xffffc
    80004ca8:	edc080e7          	jalr	-292(ra) # 80000b80 <release>
}
    80004cac:	bfe1                	j	80004c84 <pipeclose+0x46>

0000000080004cae <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80004cae:	7159                	addi	sp,sp,-112
    80004cb0:	f486                	sd	ra,104(sp)
    80004cb2:	f0a2                	sd	s0,96(sp)
    80004cb4:	eca6                	sd	s1,88(sp)
    80004cb6:	e8ca                	sd	s2,80(sp)
    80004cb8:	e4ce                	sd	s3,72(sp)
    80004cba:	e0d2                	sd	s4,64(sp)
    80004cbc:	fc56                	sd	s5,56(sp)
    80004cbe:	f85a                	sd	s6,48(sp)
    80004cc0:	f45e                	sd	s7,40(sp)
    80004cc2:	f062                	sd	s8,32(sp)
    80004cc4:	ec66                	sd	s9,24(sp)
    80004cc6:	1880                	addi	s0,sp,112
    80004cc8:	84aa                	mv	s1,a0
    80004cca:	8b2e                	mv	s6,a1
    80004ccc:	8ab2                	mv	s5,a2
  int i;
  char ch;
  struct proc *pr = myproc();
    80004cce:	ffffd097          	auipc	ra,0xffffd
    80004cd2:	e68080e7          	jalr	-408(ra) # 80001b36 <myproc>
    80004cd6:	8c2a                	mv	s8,a0

  acquire(&pi->lock);
    80004cd8:	8526                	mv	a0,s1
    80004cda:	ffffc097          	auipc	ra,0xffffc
    80004cde:	dd6080e7          	jalr	-554(ra) # 80000ab0 <acquire>
  for(i = 0; i < n; i++){
    80004ce2:	0b505063          	blez	s5,80004d82 <pipewrite+0xd4>
    80004ce6:	8926                	mv	s2,s1
    80004ce8:	fffa8b9b          	addiw	s7,s5,-1
    80004cec:	1b82                	slli	s7,s7,0x20
    80004cee:	020bdb93          	srli	s7,s7,0x20
    80004cf2:	001b0793          	addi	a5,s6,1
    80004cf6:	9bbe                	add	s7,s7,a5
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
      if(pi->readopen == 0 || myproc()->killed){
        release(&pi->lock);
        return -1;
      }
      wakeup(&pi->nread);
    80004cf8:	22048a13          	addi	s4,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80004cfc:	22448993          	addi	s3,s1,548
    }
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d00:	5cfd                	li	s9,-1
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d02:	2204a783          	lw	a5,544(s1)
    80004d06:	2244a703          	lw	a4,548(s1)
    80004d0a:	2007879b          	addiw	a5,a5,512
    80004d0e:	02f71e63          	bne	a4,a5,80004d4a <pipewrite+0x9c>
      if(pi->readopen == 0 || myproc()->killed){
    80004d12:	2284a783          	lw	a5,552(s1)
    80004d16:	c3d9                	beqz	a5,80004d9c <pipewrite+0xee>
    80004d18:	ffffd097          	auipc	ra,0xffffd
    80004d1c:	e1e080e7          	jalr	-482(ra) # 80001b36 <myproc>
    80004d20:	5d1c                	lw	a5,56(a0)
    80004d22:	efad                	bnez	a5,80004d9c <pipewrite+0xee>
      wakeup(&pi->nread);
    80004d24:	8552                	mv	a0,s4
    80004d26:	ffffd097          	auipc	ra,0xffffd
    80004d2a:	752080e7          	jalr	1874(ra) # 80002478 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004d2e:	85ca                	mv	a1,s2
    80004d30:	854e                	mv	a0,s3
    80004d32:	ffffd097          	auipc	ra,0xffffd
    80004d36:	5c0080e7          	jalr	1472(ra) # 800022f2 <sleep>
    while(pi->nwrite == pi->nread + PIPESIZE){  //DOC: pipewrite-full
    80004d3a:	2204a783          	lw	a5,544(s1)
    80004d3e:	2244a703          	lw	a4,548(s1)
    80004d42:	2007879b          	addiw	a5,a5,512
    80004d46:	fcf706e3          	beq	a4,a5,80004d12 <pipewrite+0x64>
    if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004d4a:	4685                	li	a3,1
    80004d4c:	865a                	mv	a2,s6
    80004d4e:	f9f40593          	addi	a1,s0,-97
    80004d52:	058c3503          	ld	a0,88(s8)
    80004d56:	ffffd097          	auipc	ra,0xffffd
    80004d5a:	b60080e7          	jalr	-1184(ra) # 800018b6 <copyin>
    80004d5e:	03950263          	beq	a0,s9,80004d82 <pipewrite+0xd4>
      break;
    pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004d62:	2244a783          	lw	a5,548(s1)
    80004d66:	0017871b          	addiw	a4,a5,1
    80004d6a:	22e4a223          	sw	a4,548(s1)
    80004d6e:	1ff7f793          	andi	a5,a5,511
    80004d72:	97a6                	add	a5,a5,s1
    80004d74:	f9f44703          	lbu	a4,-97(s0)
    80004d78:	02e78023          	sb	a4,32(a5)
  for(i = 0; i < n; i++){
    80004d7c:	0b05                	addi	s6,s6,1
    80004d7e:	f97b12e3          	bne	s6,s7,80004d02 <pipewrite+0x54>
  }
  wakeup(&pi->nread);
    80004d82:	22048513          	addi	a0,s1,544
    80004d86:	ffffd097          	auipc	ra,0xffffd
    80004d8a:	6f2080e7          	jalr	1778(ra) # 80002478 <wakeup>
  release(&pi->lock);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	ffffc097          	auipc	ra,0xffffc
    80004d94:	df0080e7          	jalr	-528(ra) # 80000b80 <release>
  return n;
    80004d98:	8556                	mv	a0,s5
    80004d9a:	a039                	j	80004da8 <pipewrite+0xfa>
        release(&pi->lock);
    80004d9c:	8526                	mv	a0,s1
    80004d9e:	ffffc097          	auipc	ra,0xffffc
    80004da2:	de2080e7          	jalr	-542(ra) # 80000b80 <release>
        return -1;
    80004da6:	557d                	li	a0,-1
}
    80004da8:	70a6                	ld	ra,104(sp)
    80004daa:	7406                	ld	s0,96(sp)
    80004dac:	64e6                	ld	s1,88(sp)
    80004dae:	6946                	ld	s2,80(sp)
    80004db0:	69a6                	ld	s3,72(sp)
    80004db2:	6a06                	ld	s4,64(sp)
    80004db4:	7ae2                	ld	s5,56(sp)
    80004db6:	7b42                	ld	s6,48(sp)
    80004db8:	7ba2                	ld	s7,40(sp)
    80004dba:	7c02                	ld	s8,32(sp)
    80004dbc:	6ce2                	ld	s9,24(sp)
    80004dbe:	6165                	addi	sp,sp,112
    80004dc0:	8082                	ret

0000000080004dc2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004dc2:	715d                	addi	sp,sp,-80
    80004dc4:	e486                	sd	ra,72(sp)
    80004dc6:	e0a2                	sd	s0,64(sp)
    80004dc8:	fc26                	sd	s1,56(sp)
    80004dca:	f84a                	sd	s2,48(sp)
    80004dcc:	f44e                	sd	s3,40(sp)
    80004dce:	f052                	sd	s4,32(sp)
    80004dd0:	ec56                	sd	s5,24(sp)
    80004dd2:	e85a                	sd	s6,16(sp)
    80004dd4:	0880                	addi	s0,sp,80
    80004dd6:	84aa                	mv	s1,a0
    80004dd8:	892e                	mv	s2,a1
    80004dda:	8a32                	mv	s4,a2
  int i;
  struct proc *pr = myproc();
    80004ddc:	ffffd097          	auipc	ra,0xffffd
    80004de0:	d5a080e7          	jalr	-678(ra) # 80001b36 <myproc>
    80004de4:	8aaa                	mv	s5,a0
  char ch;

  acquire(&pi->lock);
    80004de6:	8b26                	mv	s6,s1
    80004de8:	8526                	mv	a0,s1
    80004dea:	ffffc097          	auipc	ra,0xffffc
    80004dee:	cc6080e7          	jalr	-826(ra) # 80000ab0 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004df2:	2204a703          	lw	a4,544(s1)
    80004df6:	2244a783          	lw	a5,548(s1)
    if(myproc()->killed){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004dfa:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004dfe:	02f71763          	bne	a4,a5,80004e2c <piperead+0x6a>
    80004e02:	22c4a783          	lw	a5,556(s1)
    80004e06:	c39d                	beqz	a5,80004e2c <piperead+0x6a>
    if(myproc()->killed){
    80004e08:	ffffd097          	auipc	ra,0xffffd
    80004e0c:	d2e080e7          	jalr	-722(ra) # 80001b36 <myproc>
    80004e10:	5d1c                	lw	a5,56(a0)
    80004e12:	ebc1                	bnez	a5,80004ea2 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004e14:	85da                	mv	a1,s6
    80004e16:	854e                	mv	a0,s3
    80004e18:	ffffd097          	auipc	ra,0xffffd
    80004e1c:	4da080e7          	jalr	1242(ra) # 800022f2 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004e20:	2204a703          	lw	a4,544(s1)
    80004e24:	2244a783          	lw	a5,548(s1)
    80004e28:	fcf70de3          	beq	a4,a5,80004e02 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e2c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e2e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e30:	05405363          	blez	s4,80004e76 <piperead+0xb4>
    if(pi->nread == pi->nwrite)
    80004e34:	2204a783          	lw	a5,544(s1)
    80004e38:	2244a703          	lw	a4,548(s1)
    80004e3c:	02f70d63          	beq	a4,a5,80004e76 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004e40:	0017871b          	addiw	a4,a5,1
    80004e44:	22e4a023          	sw	a4,544(s1)
    80004e48:	1ff7f793          	andi	a5,a5,511
    80004e4c:	97a6                	add	a5,a5,s1
    80004e4e:	0207c783          	lbu	a5,32(a5)
    80004e52:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004e56:	4685                	li	a3,1
    80004e58:	fbf40613          	addi	a2,s0,-65
    80004e5c:	85ca                	mv	a1,s2
    80004e5e:	058ab503          	ld	a0,88(s5)
    80004e62:	ffffd097          	auipc	ra,0xffffd
    80004e66:	9c8080e7          	jalr	-1592(ra) # 8000182a <copyout>
    80004e6a:	01650663          	beq	a0,s6,80004e76 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004e6e:	2985                	addiw	s3,s3,1
    80004e70:	0905                	addi	s2,s2,1
    80004e72:	fd3a11e3          	bne	s4,s3,80004e34 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004e76:	22448513          	addi	a0,s1,548
    80004e7a:	ffffd097          	auipc	ra,0xffffd
    80004e7e:	5fe080e7          	jalr	1534(ra) # 80002478 <wakeup>
  release(&pi->lock);
    80004e82:	8526                	mv	a0,s1
    80004e84:	ffffc097          	auipc	ra,0xffffc
    80004e88:	cfc080e7          	jalr	-772(ra) # 80000b80 <release>
  return i;
}
    80004e8c:	854e                	mv	a0,s3
    80004e8e:	60a6                	ld	ra,72(sp)
    80004e90:	6406                	ld	s0,64(sp)
    80004e92:	74e2                	ld	s1,56(sp)
    80004e94:	7942                	ld	s2,48(sp)
    80004e96:	79a2                	ld	s3,40(sp)
    80004e98:	7a02                	ld	s4,32(sp)
    80004e9a:	6ae2                	ld	s5,24(sp)
    80004e9c:	6b42                	ld	s6,16(sp)
    80004e9e:	6161                	addi	sp,sp,80
    80004ea0:	8082                	ret
      release(&pi->lock);
    80004ea2:	8526                	mv	a0,s1
    80004ea4:	ffffc097          	auipc	ra,0xffffc
    80004ea8:	cdc080e7          	jalr	-804(ra) # 80000b80 <release>
      return -1;
    80004eac:	59fd                	li	s3,-1
    80004eae:	bff9                	j	80004e8c <piperead+0xca>

0000000080004eb0 <exec>:
#include "elf.h"

static int loadseg(pde_t *pgdir, uint64 addr, struct inode *ip, uint offset,
                   uint sz);

int exec(char *path, char **argv) {
    80004eb0:	df010113          	addi	sp,sp,-528
    80004eb4:	20113423          	sd	ra,520(sp)
    80004eb8:	20813023          	sd	s0,512(sp)
    80004ebc:	ffa6                	sd	s1,504(sp)
    80004ebe:	fbca                	sd	s2,496(sp)
    80004ec0:	f7ce                	sd	s3,488(sp)
    80004ec2:	f3d2                	sd	s4,480(sp)
    80004ec4:	efd6                	sd	s5,472(sp)
    80004ec6:	ebda                	sd	s6,464(sp)
    80004ec8:	e7de                	sd	s7,456(sp)
    80004eca:	e3e2                	sd	s8,448(sp)
    80004ecc:	ff66                	sd	s9,440(sp)
    80004ece:	fb6a                	sd	s10,432(sp)
    80004ed0:	f76e                	sd	s11,424(sp)
    80004ed2:	0c00                	addi	s0,sp,528
    80004ed4:	84aa                	mv	s1,a0
    80004ed6:	dea43c23          	sd	a0,-520(s0)
    80004eda:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz, sp, ustack[MAXARG + 1], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004ede:	ffffd097          	auipc	ra,0xffffd
    80004ee2:	c58080e7          	jalr	-936(ra) # 80001b36 <myproc>
    80004ee6:	892a                	mv	s2,a0

  begin_op(ROOTDEV);
    80004ee8:	4501                	li	a0,0
    80004eea:	fffff097          	auipc	ra,0xfffff
    80004eee:	37e080e7          	jalr	894(ra) # 80004268 <begin_op>

  if ((ip = namei(path)) == 0) {
    80004ef2:	8526                	mv	a0,s1
    80004ef4:	fffff097          	auipc	ra,0xfffff
    80004ef8:	11a080e7          	jalr	282(ra) # 8000400e <namei>
    80004efc:	c935                	beqz	a0,80004f70 <exec+0xc0>
    80004efe:	84aa                	mv	s1,a0
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80004f00:	fffff097          	auipc	ra,0xfffff
    80004f04:	984080e7          	jalr	-1660(ra) # 80003884 <ilock>

  // Check ELF header
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004f08:	04000713          	li	a4,64
    80004f0c:	4681                	li	a3,0
    80004f0e:	e4840613          	addi	a2,s0,-440
    80004f12:	4581                	li	a1,0
    80004f14:	8526                	mv	a0,s1
    80004f16:	fffff097          	auipc	ra,0xfffff
    80004f1a:	bfe080e7          	jalr	-1026(ra) # 80003b14 <readi>
    80004f1e:	04000793          	li	a5,64
    80004f22:	00f51a63          	bne	a0,a5,80004f36 <exec+0x86>
    goto bad;
  if (elf.magic != ELF_MAGIC)
    80004f26:	e4842703          	lw	a4,-440(s0)
    80004f2a:	464c47b7          	lui	a5,0x464c4
    80004f2e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004f32:	04f70663          	beq	a4,a5,80004f7e <exec+0xce>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004f36:	8526                	mv	a0,s1
    80004f38:	fffff097          	auipc	ra,0xfffff
    80004f3c:	b8a080e7          	jalr	-1142(ra) # 80003ac2 <iunlockput>
    end_op(ROOTDEV);
    80004f40:	4501                	li	a0,0
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	3d0080e7          	jalr	976(ra) # 80004312 <end_op>
  }
  return -1;
    80004f4a:	557d                	li	a0,-1
}
    80004f4c:	20813083          	ld	ra,520(sp)
    80004f50:	20013403          	ld	s0,512(sp)
    80004f54:	74fe                	ld	s1,504(sp)
    80004f56:	795e                	ld	s2,496(sp)
    80004f58:	79be                	ld	s3,488(sp)
    80004f5a:	7a1e                	ld	s4,480(sp)
    80004f5c:	6afe                	ld	s5,472(sp)
    80004f5e:	6b5e                	ld	s6,464(sp)
    80004f60:	6bbe                	ld	s7,456(sp)
    80004f62:	6c1e                	ld	s8,448(sp)
    80004f64:	7cfa                	ld	s9,440(sp)
    80004f66:	7d5a                	ld	s10,432(sp)
    80004f68:	7dba                	ld	s11,424(sp)
    80004f6a:	21010113          	addi	sp,sp,528
    80004f6e:	8082                	ret
    end_op(ROOTDEV);
    80004f70:	4501                	li	a0,0
    80004f72:	fffff097          	auipc	ra,0xfffff
    80004f76:	3a0080e7          	jalr	928(ra) # 80004312 <end_op>
    return -1;
    80004f7a:	557d                	li	a0,-1
    80004f7c:	bfc1                	j	80004f4c <exec+0x9c>
  if ((pagetable = proc_pagetable(p)) == 0)
    80004f7e:	854a                	mv	a0,s2
    80004f80:	ffffd097          	auipc	ra,0xffffd
    80004f84:	c7a080e7          	jalr	-902(ra) # 80001bfa <proc_pagetable>
    80004f88:	8c2a                	mv	s8,a0
    80004f8a:	d555                	beqz	a0,80004f36 <exec+0x86>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004f8c:	e6842983          	lw	s3,-408(s0)
    80004f90:	e8045783          	lhu	a5,-384(s0)
    80004f94:	c7fd                	beqz	a5,80005082 <exec+0x1d2>
  sz = 0;
    80004f96:	e0043423          	sd	zero,-504(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004f9a:	4b81                	li	s7,0
    if (ph.vaddr % PGSIZE != 0)
    80004f9c:	6b05                	lui	s6,0x1
    80004f9e:	fffb0793          	addi	a5,s6,-1 # fff <_entry-0x7ffff001>
    80004fa2:	def43823          	sd	a5,-528(s0)
    80004fa6:	a0a5                	j	8000500e <exec+0x15e>
    panic("loadseg: va must be page aligned");

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    80004fa8:	00004517          	auipc	a0,0x4
    80004fac:	a8850513          	addi	a0,a0,-1400 # 80008a30 <userret+0x9a0>
    80004fb0:	ffffb097          	auipc	ra,0xffffb
    80004fb4:	5aa080e7          	jalr	1450(ra) # 8000055a <panic>
    if (sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004fb8:	8756                	mv	a4,s5
    80004fba:	012d86bb          	addw	a3,s11,s2
    80004fbe:	4581                	li	a1,0
    80004fc0:	8526                	mv	a0,s1
    80004fc2:	fffff097          	auipc	ra,0xfffff
    80004fc6:	b52080e7          	jalr	-1198(ra) # 80003b14 <readi>
    80004fca:	2501                	sext.w	a0,a0
    80004fcc:	10aa9263          	bne	s5,a0,800050d0 <exec+0x220>
  for (i = 0; i < sz; i += PGSIZE) {
    80004fd0:	6785                	lui	a5,0x1
    80004fd2:	0127893b          	addw	s2,a5,s2
    80004fd6:	77fd                	lui	a5,0xfffff
    80004fd8:	01478a3b          	addw	s4,a5,s4
    80004fdc:	03997263          	bgeu	s2,s9,80005000 <exec+0x150>
    pa = walkaddr(pagetable, va + i);
    80004fe0:	02091593          	slli	a1,s2,0x20
    80004fe4:	9181                	srli	a1,a1,0x20
    80004fe6:	95ea                	add	a1,a1,s10
    80004fe8:	8562                	mv	a0,s8
    80004fea:	ffffc097          	auipc	ra,0xffffc
    80004fee:	192080e7          	jalr	402(ra) # 8000117c <walkaddr>
    80004ff2:	862a                	mv	a2,a0
    if (pa == 0)
    80004ff4:	d955                	beqz	a0,80004fa8 <exec+0xf8>
      n = PGSIZE;
    80004ff6:	8ada                	mv	s5,s6
    if (sz - i < PGSIZE)
    80004ff8:	fd6a70e3          	bgeu	s4,s6,80004fb8 <exec+0x108>
      n = sz - i;
    80004ffc:	8ad2                	mv	s5,s4
    80004ffe:	bf6d                	j	80004fb8 <exec+0x108>
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80005000:	2b85                	addiw	s7,s7,1
    80005002:	0389899b          	addiw	s3,s3,56
    80005006:	e8045783          	lhu	a5,-384(s0)
    8000500a:	06fbde63          	bge	s7,a5,80005086 <exec+0x1d6>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000500e:	2981                	sext.w	s3,s3
    80005010:	03800713          	li	a4,56
    80005014:	86ce                	mv	a3,s3
    80005016:	e1040613          	addi	a2,s0,-496
    8000501a:	4581                	li	a1,0
    8000501c:	8526                	mv	a0,s1
    8000501e:	fffff097          	auipc	ra,0xfffff
    80005022:	af6080e7          	jalr	-1290(ra) # 80003b14 <readi>
    80005026:	03800793          	li	a5,56
    8000502a:	0af51363          	bne	a0,a5,800050d0 <exec+0x220>
    if (ph.type != ELF_PROG_LOAD)
    8000502e:	e1042783          	lw	a5,-496(s0)
    80005032:	4705                	li	a4,1
    80005034:	fce796e3          	bne	a5,a4,80005000 <exec+0x150>
    if (ph.memsz < ph.filesz)
    80005038:	e3843603          	ld	a2,-456(s0)
    8000503c:	e3043783          	ld	a5,-464(s0)
    80005040:	08f66863          	bltu	a2,a5,800050d0 <exec+0x220>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80005044:	e2043783          	ld	a5,-480(s0)
    80005048:	963e                	add	a2,a2,a5
    8000504a:	08f66363          	bltu	a2,a5,800050d0 <exec+0x220>
    if ((sz = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz)) == 0)
    8000504e:	e0843583          	ld	a1,-504(s0)
    80005052:	8562                	mv	a0,s8
    80005054:	ffffc097          	auipc	ra,0xffffc
    80005058:	502080e7          	jalr	1282(ra) # 80001556 <uvmalloc>
    8000505c:	e0a43423          	sd	a0,-504(s0)
    80005060:	c925                	beqz	a0,800050d0 <exec+0x220>
    if (ph.vaddr % PGSIZE != 0)
    80005062:	e2043d03          	ld	s10,-480(s0)
    80005066:	df043783          	ld	a5,-528(s0)
    8000506a:	00fd77b3          	and	a5,s10,a5
    8000506e:	e3ad                	bnez	a5,800050d0 <exec+0x220>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80005070:	e1842d83          	lw	s11,-488(s0)
    80005074:	e3042c83          	lw	s9,-464(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80005078:	f80c84e3          	beqz	s9,80005000 <exec+0x150>
    8000507c:	8a66                	mv	s4,s9
    8000507e:	4901                	li	s2,0
    80005080:	b785                	j	80004fe0 <exec+0x130>
  sz = 0;
    80005082:	e0043423          	sd	zero,-504(s0)
  iunlockput(ip);
    80005086:	8526                	mv	a0,s1
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	a3a080e7          	jalr	-1478(ra) # 80003ac2 <iunlockput>
  end_op(ROOTDEV);
    80005090:	4501                	li	a0,0
    80005092:	fffff097          	auipc	ra,0xfffff
    80005096:	280080e7          	jalr	640(ra) # 80004312 <end_op>
  p = myproc();
    8000509a:	ffffd097          	auipc	ra,0xffffd
    8000509e:	a9c080e7          	jalr	-1380(ra) # 80001b36 <myproc>
    800050a2:	8baa                	mv	s7,a0
  uint64 oldsz = p->sz;
    800050a4:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    800050a8:	6585                	lui	a1,0x1
    800050aa:	15fd                	addi	a1,a1,-1
    800050ac:	e0843783          	ld	a5,-504(s0)
    800050b0:	00b78b33          	add	s6,a5,a1
    800050b4:	75fd                	lui	a1,0xfffff
    800050b6:	00bb75b3          	and	a1,s6,a1
  if ((sz = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    800050ba:	6609                	lui	a2,0x2
    800050bc:	962e                	add	a2,a2,a1
    800050be:	8562                	mv	a0,s8
    800050c0:	ffffc097          	auipc	ra,0xffffc
    800050c4:	496080e7          	jalr	1174(ra) # 80001556 <uvmalloc>
    800050c8:	e0a43423          	sd	a0,-504(s0)
  ip = 0;
    800050cc:	4481                	li	s1,0
  if ((sz = uvmalloc(pagetable, sz, sz + 2 * PGSIZE)) == 0)
    800050ce:	ed01                	bnez	a0,800050e6 <exec+0x236>
    proc_freepagetable(pagetable, sz);
    800050d0:	e0843583          	ld	a1,-504(s0)
    800050d4:	8562                	mv	a0,s8
    800050d6:	ffffd097          	auipc	ra,0xffffd
    800050da:	c24080e7          	jalr	-988(ra) # 80001cfa <proc_freepagetable>
  if (ip) {
    800050de:	e4049ce3          	bnez	s1,80004f36 <exec+0x86>
  return -1;
    800050e2:	557d                	li	a0,-1
    800050e4:	b5a5                	j	80004f4c <exec+0x9c>
  uvmclear(pagetable, sz - 2 * PGSIZE);
    800050e6:	75f9                	lui	a1,0xffffe
    800050e8:	84aa                	mv	s1,a0
    800050ea:	95aa                	add	a1,a1,a0
    800050ec:	8562                	mv	a0,s8
    800050ee:	ffffc097          	auipc	ra,0xffffc
    800050f2:	70a080e7          	jalr	1802(ra) # 800017f8 <uvmclear>
  stackbase = sp - PGSIZE;
    800050f6:	7afd                	lui	s5,0xfffff
    800050f8:	9aa6                	add	s5,s5,s1
  for (argc = 0; argv[argc]; argc++) {
    800050fa:	e0043783          	ld	a5,-512(s0)
    800050fe:	6388                	ld	a0,0(a5)
    80005100:	c135                	beqz	a0,80005164 <exec+0x2b4>
    80005102:	e8840993          	addi	s3,s0,-376
    80005106:	f8840c93          	addi	s9,s0,-120
    8000510a:	4901                	li	s2,0
    sp -= strlen(argv[argc]) + 1;
    8000510c:	ffffc097          	auipc	ra,0xffffc
    80005110:	dfa080e7          	jalr	-518(ra) # 80000f06 <strlen>
    80005114:	2505                	addiw	a0,a0,1
    80005116:	8c89                	sub	s1,s1,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80005118:	98c1                	andi	s1,s1,-16
    if (sp < stackbase)
    8000511a:	0f54ea63          	bltu	s1,s5,8000520e <exec+0x35e>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000511e:	e0043b03          	ld	s6,-512(s0)
    80005122:	000b3a03          	ld	s4,0(s6)
    80005126:	8552                	mv	a0,s4
    80005128:	ffffc097          	auipc	ra,0xffffc
    8000512c:	dde080e7          	jalr	-546(ra) # 80000f06 <strlen>
    80005130:	0015069b          	addiw	a3,a0,1
    80005134:	8652                	mv	a2,s4
    80005136:	85a6                	mv	a1,s1
    80005138:	8562                	mv	a0,s8
    8000513a:	ffffc097          	auipc	ra,0xffffc
    8000513e:	6f0080e7          	jalr	1776(ra) # 8000182a <copyout>
    80005142:	0c054863          	bltz	a0,80005212 <exec+0x362>
    ustack[argc] = sp;
    80005146:	0099b023          	sd	s1,0(s3)
  for (argc = 0; argv[argc]; argc++) {
    8000514a:	0905                	addi	s2,s2,1
    8000514c:	008b0793          	addi	a5,s6,8
    80005150:	e0f43023          	sd	a5,-512(s0)
    80005154:	008b3503          	ld	a0,8(s6)
    80005158:	c909                	beqz	a0,8000516a <exec+0x2ba>
    if (argc >= MAXARG)
    8000515a:	09a1                	addi	s3,s3,8
    8000515c:	fb3c98e3          	bne	s9,s3,8000510c <exec+0x25c>
  ip = 0;
    80005160:	4481                	li	s1,0
    80005162:	b7bd                	j	800050d0 <exec+0x220>
  sp = sz;
    80005164:	e0843483          	ld	s1,-504(s0)
  for (argc = 0; argv[argc]; argc++) {
    80005168:	4901                	li	s2,0
  ustack[argc] = 0;
    8000516a:	00391793          	slli	a5,s2,0x3
    8000516e:	f9040713          	addi	a4,s0,-112
    80005172:	97ba                	add	a5,a5,a4
    80005174:	ee07bc23          	sd	zero,-264(a5) # ffffffffffffeef8 <end+0xffffffff7ffd6e9c>
  sp -= (argc + 1) * sizeof(uint64);
    80005178:	00190693          	addi	a3,s2,1
    8000517c:	068e                	slli	a3,a3,0x3
    8000517e:	8c95                	sub	s1,s1,a3
  sp -= sp % 16;
    80005180:	ff04f993          	andi	s3,s1,-16
  ip = 0;
    80005184:	4481                	li	s1,0
  if (sp < stackbase)
    80005186:	f559e5e3          	bltu	s3,s5,800050d0 <exec+0x220>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000518a:	e8840613          	addi	a2,s0,-376
    8000518e:	85ce                	mv	a1,s3
    80005190:	8562                	mv	a0,s8
    80005192:	ffffc097          	auipc	ra,0xffffc
    80005196:	698080e7          	jalr	1688(ra) # 8000182a <copyout>
    8000519a:	06054e63          	bltz	a0,80005216 <exec+0x366>
  p->tf->a1 = sp;
    8000519e:	060bb783          	ld	a5,96(s7) # 1060 <_entry-0x7fffefa0>
    800051a2:	0737bc23          	sd	s3,120(a5)
  for (last = s = path; *s; s++)
    800051a6:	df843783          	ld	a5,-520(s0)
    800051aa:	0007c703          	lbu	a4,0(a5)
    800051ae:	cf11                	beqz	a4,800051ca <exec+0x31a>
    800051b0:	0785                	addi	a5,a5,1
    if (*s == '/')
    800051b2:	02f00693          	li	a3,47
    800051b6:	a029                	j	800051c0 <exec+0x310>
  for (last = s = path; *s; s++)
    800051b8:	0785                	addi	a5,a5,1
    800051ba:	fff7c703          	lbu	a4,-1(a5)
    800051be:	c711                	beqz	a4,800051ca <exec+0x31a>
    if (*s == '/')
    800051c0:	fed71ce3          	bne	a4,a3,800051b8 <exec+0x308>
      last = s + 1;
    800051c4:	def43c23          	sd	a5,-520(s0)
    800051c8:	bfc5                	j	800051b8 <exec+0x308>
  safestrcpy(p->name, last, sizeof(p->name));
    800051ca:	4641                	li	a2,16
    800051cc:	df843583          	ld	a1,-520(s0)
    800051d0:	160b8513          	addi	a0,s7,352
    800051d4:	ffffc097          	auipc	ra,0xffffc
    800051d8:	d00080e7          	jalr	-768(ra) # 80000ed4 <safestrcpy>
  oldpagetable = p->pagetable;
    800051dc:	058bb503          	ld	a0,88(s7)
  p->pagetable = pagetable;
    800051e0:	058bbc23          	sd	s8,88(s7)
  p->sz = sz;
    800051e4:	e0843783          	ld	a5,-504(s0)
    800051e8:	04fbb823          	sd	a5,80(s7)
  p->tf->epc = elf.entry; // initial program counter = main
    800051ec:	060bb783          	ld	a5,96(s7)
    800051f0:	e6043703          	ld	a4,-416(s0)
    800051f4:	ef98                	sd	a4,24(a5)
  p->tf->sp = sp;         // initial stack pointer
    800051f6:	060bb783          	ld	a5,96(s7)
    800051fa:	0337b823          	sd	s3,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800051fe:	85ea                	mv	a1,s10
    80005200:	ffffd097          	auipc	ra,0xffffd
    80005204:	afa080e7          	jalr	-1286(ra) # 80001cfa <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80005208:	0009051b          	sext.w	a0,s2
    8000520c:	b381                	j	80004f4c <exec+0x9c>
  ip = 0;
    8000520e:	4481                	li	s1,0
    80005210:	b5c1                	j	800050d0 <exec+0x220>
    80005212:	4481                	li	s1,0
    80005214:	bd75                	j	800050d0 <exec+0x220>
    80005216:	4481                	li	s1,0
    80005218:	bd65                	j	800050d0 <exec+0x220>

000000008000521a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000521a:	7179                	addi	sp,sp,-48
    8000521c:	f406                	sd	ra,40(sp)
    8000521e:	f022                	sd	s0,32(sp)
    80005220:	ec26                	sd	s1,24(sp)
    80005222:	e84a                	sd	s2,16(sp)
    80005224:	1800                	addi	s0,sp,48
    80005226:	892e                	mv	s2,a1
    80005228:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    8000522a:	fdc40593          	addi	a1,s0,-36
    8000522e:	ffffe097          	auipc	ra,0xffffe
    80005232:	abe080e7          	jalr	-1346(ra) # 80002cec <argint>
    80005236:	04054063          	bltz	a0,80005276 <argfd+0x5c>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000523a:	fdc42703          	lw	a4,-36(s0)
    8000523e:	47bd                	li	a5,15
    80005240:	02e7ed63          	bltu	a5,a4,8000527a <argfd+0x60>
    80005244:	ffffd097          	auipc	ra,0xffffd
    80005248:	8f2080e7          	jalr	-1806(ra) # 80001b36 <myproc>
    8000524c:	fdc42703          	lw	a4,-36(s0)
    80005250:	01a70793          	addi	a5,a4,26
    80005254:	078e                	slli	a5,a5,0x3
    80005256:	953e                	add	a0,a0,a5
    80005258:	651c                	ld	a5,8(a0)
    8000525a:	c395                	beqz	a5,8000527e <argfd+0x64>
    return -1;
  if(pfd)
    8000525c:	00090463          	beqz	s2,80005264 <argfd+0x4a>
    *pfd = fd;
    80005260:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80005264:	4501                	li	a0,0
  if(pf)
    80005266:	c091                	beqz	s1,8000526a <argfd+0x50>
    *pf = f;
    80005268:	e09c                	sd	a5,0(s1)
}
    8000526a:	70a2                	ld	ra,40(sp)
    8000526c:	7402                	ld	s0,32(sp)
    8000526e:	64e2                	ld	s1,24(sp)
    80005270:	6942                	ld	s2,16(sp)
    80005272:	6145                	addi	sp,sp,48
    80005274:	8082                	ret
    return -1;
    80005276:	557d                	li	a0,-1
    80005278:	bfcd                	j	8000526a <argfd+0x50>
    return -1;
    8000527a:	557d                	li	a0,-1
    8000527c:	b7fd                	j	8000526a <argfd+0x50>
    8000527e:	557d                	li	a0,-1
    80005280:	b7ed                	j	8000526a <argfd+0x50>

0000000080005282 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80005282:	1101                	addi	sp,sp,-32
    80005284:	ec06                	sd	ra,24(sp)
    80005286:	e822                	sd	s0,16(sp)
    80005288:	e426                	sd	s1,8(sp)
    8000528a:	1000                	addi	s0,sp,32
    8000528c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000528e:	ffffd097          	auipc	ra,0xffffd
    80005292:	8a8080e7          	jalr	-1880(ra) # 80001b36 <myproc>
    80005296:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80005298:	0d850793          	addi	a5,a0,216
    8000529c:	4501                	li	a0,0
    8000529e:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800052a0:	6398                	ld	a4,0(a5)
    800052a2:	cb19                	beqz	a4,800052b8 <fdalloc+0x36>
  for(fd = 0; fd < NOFILE; fd++){
    800052a4:	2505                	addiw	a0,a0,1
    800052a6:	07a1                	addi	a5,a5,8
    800052a8:	fed51ce3          	bne	a0,a3,800052a0 <fdalloc+0x1e>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800052ac:	557d                	li	a0,-1
}
    800052ae:	60e2                	ld	ra,24(sp)
    800052b0:	6442                	ld	s0,16(sp)
    800052b2:	64a2                	ld	s1,8(sp)
    800052b4:	6105                	addi	sp,sp,32
    800052b6:	8082                	ret
      p->ofile[fd] = f;
    800052b8:	01a50793          	addi	a5,a0,26
    800052bc:	078e                	slli	a5,a5,0x3
    800052be:	963e                	add	a2,a2,a5
    800052c0:	e604                	sd	s1,8(a2)
      return fd;
    800052c2:	b7f5                	j	800052ae <fdalloc+0x2c>

00000000800052c4 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800052c4:	715d                	addi	sp,sp,-80
    800052c6:	e486                	sd	ra,72(sp)
    800052c8:	e0a2                	sd	s0,64(sp)
    800052ca:	fc26                	sd	s1,56(sp)
    800052cc:	f84a                	sd	s2,48(sp)
    800052ce:	f44e                	sd	s3,40(sp)
    800052d0:	f052                	sd	s4,32(sp)
    800052d2:	ec56                	sd	s5,24(sp)
    800052d4:	0880                	addi	s0,sp,80
    800052d6:	89ae                	mv	s3,a1
    800052d8:	8ab2                	mv	s5,a2
    800052da:	8a36                	mv	s4,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800052dc:	fb040593          	addi	a1,s0,-80
    800052e0:	fffff097          	auipc	ra,0xfffff
    800052e4:	d4c080e7          	jalr	-692(ra) # 8000402c <nameiparent>
    800052e8:	892a                	mv	s2,a0
    800052ea:	12050e63          	beqz	a0,80005426 <create+0x162>
    return 0;

  ilock(dp);
    800052ee:	ffffe097          	auipc	ra,0xffffe
    800052f2:	596080e7          	jalr	1430(ra) # 80003884 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800052f6:	4601                	li	a2,0
    800052f8:	fb040593          	addi	a1,s0,-80
    800052fc:	854a                	mv	a0,s2
    800052fe:	fffff097          	auipc	ra,0xfffff
    80005302:	a3e080e7          	jalr	-1474(ra) # 80003d3c <dirlookup>
    80005306:	84aa                	mv	s1,a0
    80005308:	c921                	beqz	a0,80005358 <create+0x94>
    iunlockput(dp);
    8000530a:	854a                	mv	a0,s2
    8000530c:	ffffe097          	auipc	ra,0xffffe
    80005310:	7b6080e7          	jalr	1974(ra) # 80003ac2 <iunlockput>
    ilock(ip);
    80005314:	8526                	mv	a0,s1
    80005316:	ffffe097          	auipc	ra,0xffffe
    8000531a:	56e080e7          	jalr	1390(ra) # 80003884 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000531e:	2981                	sext.w	s3,s3
    80005320:	4789                	li	a5,2
    80005322:	02f99463          	bne	s3,a5,8000534a <create+0x86>
    80005326:	04c4d783          	lhu	a5,76(s1)
    8000532a:	37f9                	addiw	a5,a5,-2
    8000532c:	17c2                	slli	a5,a5,0x30
    8000532e:	93c1                	srli	a5,a5,0x30
    80005330:	4705                	li	a4,1
    80005332:	00f76c63          	bltu	a4,a5,8000534a <create+0x86>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
    80005336:	8526                	mv	a0,s1
    80005338:	60a6                	ld	ra,72(sp)
    8000533a:	6406                	ld	s0,64(sp)
    8000533c:	74e2                	ld	s1,56(sp)
    8000533e:	7942                	ld	s2,48(sp)
    80005340:	79a2                	ld	s3,40(sp)
    80005342:	7a02                	ld	s4,32(sp)
    80005344:	6ae2                	ld	s5,24(sp)
    80005346:	6161                	addi	sp,sp,80
    80005348:	8082                	ret
    iunlockput(ip);
    8000534a:	8526                	mv	a0,s1
    8000534c:	ffffe097          	auipc	ra,0xffffe
    80005350:	776080e7          	jalr	1910(ra) # 80003ac2 <iunlockput>
    return 0;
    80005354:	4481                	li	s1,0
    80005356:	b7c5                	j	80005336 <create+0x72>
  if((ip = ialloc(dp->dev, type)) == 0)
    80005358:	85ce                	mv	a1,s3
    8000535a:	00092503          	lw	a0,0(s2)
    8000535e:	ffffe097          	auipc	ra,0xffffe
    80005362:	38e080e7          	jalr	910(ra) # 800036ec <ialloc>
    80005366:	84aa                	mv	s1,a0
    80005368:	c521                	beqz	a0,800053b0 <create+0xec>
  ilock(ip);
    8000536a:	ffffe097          	auipc	ra,0xffffe
    8000536e:	51a080e7          	jalr	1306(ra) # 80003884 <ilock>
  ip->major = major;
    80005372:	05549723          	sh	s5,78(s1)
  ip->minor = minor;
    80005376:	05449823          	sh	s4,80(s1)
  ip->nlink = 1;
    8000537a:	4a05                	li	s4,1
    8000537c:	05449923          	sh	s4,82(s1)
  iupdate(ip);
    80005380:	8526                	mv	a0,s1
    80005382:	ffffe097          	auipc	ra,0xffffe
    80005386:	438080e7          	jalr	1080(ra) # 800037ba <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000538a:	2981                	sext.w	s3,s3
    8000538c:	03498a63          	beq	s3,s4,800053c0 <create+0xfc>
  if(dirlink(dp, name, ip->inum) < 0)
    80005390:	40d0                	lw	a2,4(s1)
    80005392:	fb040593          	addi	a1,s0,-80
    80005396:	854a                	mv	a0,s2
    80005398:	fffff097          	auipc	ra,0xfffff
    8000539c:	bb4080e7          	jalr	-1100(ra) # 80003f4c <dirlink>
    800053a0:	06054b63          	bltz	a0,80005416 <create+0x152>
  iunlockput(dp);
    800053a4:	854a                	mv	a0,s2
    800053a6:	ffffe097          	auipc	ra,0xffffe
    800053aa:	71c080e7          	jalr	1820(ra) # 80003ac2 <iunlockput>
  return ip;
    800053ae:	b761                	j	80005336 <create+0x72>
    panic("create: ialloc");
    800053b0:	00003517          	auipc	a0,0x3
    800053b4:	6a050513          	addi	a0,a0,1696 # 80008a50 <userret+0x9c0>
    800053b8:	ffffb097          	auipc	ra,0xffffb
    800053bc:	1a2080e7          	jalr	418(ra) # 8000055a <panic>
    dp->nlink++;  // for ".."
    800053c0:	05295783          	lhu	a5,82(s2)
    800053c4:	2785                	addiw	a5,a5,1
    800053c6:	04f91923          	sh	a5,82(s2)
    iupdate(dp);
    800053ca:	854a                	mv	a0,s2
    800053cc:	ffffe097          	auipc	ra,0xffffe
    800053d0:	3ee080e7          	jalr	1006(ra) # 800037ba <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800053d4:	40d0                	lw	a2,4(s1)
    800053d6:	00003597          	auipc	a1,0x3
    800053da:	68a58593          	addi	a1,a1,1674 # 80008a60 <userret+0x9d0>
    800053de:	8526                	mv	a0,s1
    800053e0:	fffff097          	auipc	ra,0xfffff
    800053e4:	b6c080e7          	jalr	-1172(ra) # 80003f4c <dirlink>
    800053e8:	00054f63          	bltz	a0,80005406 <create+0x142>
    800053ec:	00492603          	lw	a2,4(s2)
    800053f0:	00003597          	auipc	a1,0x3
    800053f4:	67858593          	addi	a1,a1,1656 # 80008a68 <userret+0x9d8>
    800053f8:	8526                	mv	a0,s1
    800053fa:	fffff097          	auipc	ra,0xfffff
    800053fe:	b52080e7          	jalr	-1198(ra) # 80003f4c <dirlink>
    80005402:	f80557e3          	bgez	a0,80005390 <create+0xcc>
      panic("create dots");
    80005406:	00003517          	auipc	a0,0x3
    8000540a:	66a50513          	addi	a0,a0,1642 # 80008a70 <userret+0x9e0>
    8000540e:	ffffb097          	auipc	ra,0xffffb
    80005412:	14c080e7          	jalr	332(ra) # 8000055a <panic>
    panic("create: dirlink");
    80005416:	00003517          	auipc	a0,0x3
    8000541a:	66a50513          	addi	a0,a0,1642 # 80008a80 <userret+0x9f0>
    8000541e:	ffffb097          	auipc	ra,0xffffb
    80005422:	13c080e7          	jalr	316(ra) # 8000055a <panic>
    return 0;
    80005426:	84aa                	mv	s1,a0
    80005428:	b739                	j	80005336 <create+0x72>

000000008000542a <sys_dup>:
{
    8000542a:	7179                	addi	sp,sp,-48
    8000542c:	f406                	sd	ra,40(sp)
    8000542e:	f022                	sd	s0,32(sp)
    80005430:	ec26                	sd	s1,24(sp)
    80005432:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80005434:	fd840613          	addi	a2,s0,-40
    80005438:	4581                	li	a1,0
    8000543a:	4501                	li	a0,0
    8000543c:	00000097          	auipc	ra,0x0
    80005440:	dde080e7          	jalr	-546(ra) # 8000521a <argfd>
    return -1;
    80005444:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80005446:	02054363          	bltz	a0,8000546c <sys_dup+0x42>
  if((fd=fdalloc(f)) < 0)
    8000544a:	fd843503          	ld	a0,-40(s0)
    8000544e:	00000097          	auipc	ra,0x0
    80005452:	e34080e7          	jalr	-460(ra) # 80005282 <fdalloc>
    80005456:	84aa                	mv	s1,a0
    return -1;
    80005458:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000545a:	00054963          	bltz	a0,8000546c <sys_dup+0x42>
  filedup(f);
    8000545e:	fd843503          	ld	a0,-40(s0)
    80005462:	fffff097          	auipc	ra,0xfffff
    80005466:	34e080e7          	jalr	846(ra) # 800047b0 <filedup>
  return fd;
    8000546a:	87a6                	mv	a5,s1
}
    8000546c:	853e                	mv	a0,a5
    8000546e:	70a2                	ld	ra,40(sp)
    80005470:	7402                	ld	s0,32(sp)
    80005472:	64e2                	ld	s1,24(sp)
    80005474:	6145                	addi	sp,sp,48
    80005476:	8082                	ret

0000000080005478 <sys_read>:
{
    80005478:	7179                	addi	sp,sp,-48
    8000547a:	f406                	sd	ra,40(sp)
    8000547c:	f022                	sd	s0,32(sp)
    8000547e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005480:	fe840613          	addi	a2,s0,-24
    80005484:	4581                	li	a1,0
    80005486:	4501                	li	a0,0
    80005488:	00000097          	auipc	ra,0x0
    8000548c:	d92080e7          	jalr	-622(ra) # 8000521a <argfd>
    return -1;
    80005490:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005492:	04054163          	bltz	a0,800054d4 <sys_read+0x5c>
    80005496:	fe440593          	addi	a1,s0,-28
    8000549a:	4509                	li	a0,2
    8000549c:	ffffe097          	auipc	ra,0xffffe
    800054a0:	850080e7          	jalr	-1968(ra) # 80002cec <argint>
    return -1;
    800054a4:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054a6:	02054763          	bltz	a0,800054d4 <sys_read+0x5c>
    800054aa:	fd840593          	addi	a1,s0,-40
    800054ae:	4505                	li	a0,1
    800054b0:	ffffe097          	auipc	ra,0xffffe
    800054b4:	85e080e7          	jalr	-1954(ra) # 80002d0e <argaddr>
    return -1;
    800054b8:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054ba:	00054d63          	bltz	a0,800054d4 <sys_read+0x5c>
  return fileread(f, p, n);
    800054be:	fe442603          	lw	a2,-28(s0)
    800054c2:	fd843583          	ld	a1,-40(s0)
    800054c6:	fe843503          	ld	a0,-24(s0)
    800054ca:	fffff097          	auipc	ra,0xfffff
    800054ce:	47a080e7          	jalr	1146(ra) # 80004944 <fileread>
    800054d2:	87aa                	mv	a5,a0
}
    800054d4:	853e                	mv	a0,a5
    800054d6:	70a2                	ld	ra,40(sp)
    800054d8:	7402                	ld	s0,32(sp)
    800054da:	6145                	addi	sp,sp,48
    800054dc:	8082                	ret

00000000800054de <sys_write>:
{
    800054de:	7179                	addi	sp,sp,-48
    800054e0:	f406                	sd	ra,40(sp)
    800054e2:	f022                	sd	s0,32(sp)
    800054e4:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054e6:	fe840613          	addi	a2,s0,-24
    800054ea:	4581                	li	a1,0
    800054ec:	4501                	li	a0,0
    800054ee:	00000097          	auipc	ra,0x0
    800054f2:	d2c080e7          	jalr	-724(ra) # 8000521a <argfd>
    return -1;
    800054f6:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    800054f8:	04054163          	bltz	a0,8000553a <sys_write+0x5c>
    800054fc:	fe440593          	addi	a1,s0,-28
    80005500:	4509                	li	a0,2
    80005502:	ffffd097          	auipc	ra,0xffffd
    80005506:	7ea080e7          	jalr	2026(ra) # 80002cec <argint>
    return -1;
    8000550a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    8000550c:	02054763          	bltz	a0,8000553a <sys_write+0x5c>
    80005510:	fd840593          	addi	a1,s0,-40
    80005514:	4505                	li	a0,1
    80005516:	ffffd097          	auipc	ra,0xffffd
    8000551a:	7f8080e7          	jalr	2040(ra) # 80002d0e <argaddr>
    return -1;
    8000551e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argaddr(1, &p) < 0)
    80005520:	00054d63          	bltz	a0,8000553a <sys_write+0x5c>
  return filewrite(f, p, n);
    80005524:	fe442603          	lw	a2,-28(s0)
    80005528:	fd843583          	ld	a1,-40(s0)
    8000552c:	fe843503          	ld	a0,-24(s0)
    80005530:	fffff097          	auipc	ra,0xfffff
    80005534:	4da080e7          	jalr	1242(ra) # 80004a0a <filewrite>
    80005538:	87aa                	mv	a5,a0
}
    8000553a:	853e                	mv	a0,a5
    8000553c:	70a2                	ld	ra,40(sp)
    8000553e:	7402                	ld	s0,32(sp)
    80005540:	6145                	addi	sp,sp,48
    80005542:	8082                	ret

0000000080005544 <sys_close>:
{
    80005544:	1101                	addi	sp,sp,-32
    80005546:	ec06                	sd	ra,24(sp)
    80005548:	e822                	sd	s0,16(sp)
    8000554a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000554c:	fe040613          	addi	a2,s0,-32
    80005550:	fec40593          	addi	a1,s0,-20
    80005554:	4501                	li	a0,0
    80005556:	00000097          	auipc	ra,0x0
    8000555a:	cc4080e7          	jalr	-828(ra) # 8000521a <argfd>
    return -1;
    8000555e:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80005560:	02054463          	bltz	a0,80005588 <sys_close+0x44>
  myproc()->ofile[fd] = 0;
    80005564:	ffffc097          	auipc	ra,0xffffc
    80005568:	5d2080e7          	jalr	1490(ra) # 80001b36 <myproc>
    8000556c:	fec42783          	lw	a5,-20(s0)
    80005570:	07e9                	addi	a5,a5,26
    80005572:	078e                	slli	a5,a5,0x3
    80005574:	97aa                	add	a5,a5,a0
    80005576:	0007b423          	sd	zero,8(a5)
  fileclose(f);
    8000557a:	fe043503          	ld	a0,-32(s0)
    8000557e:	fffff097          	auipc	ra,0xfffff
    80005582:	284080e7          	jalr	644(ra) # 80004802 <fileclose>
  return 0;
    80005586:	4781                	li	a5,0
}
    80005588:	853e                	mv	a0,a5
    8000558a:	60e2                	ld	ra,24(sp)
    8000558c:	6442                	ld	s0,16(sp)
    8000558e:	6105                	addi	sp,sp,32
    80005590:	8082                	ret

0000000080005592 <sys_fstat>:
{
    80005592:	1101                	addi	sp,sp,-32
    80005594:	ec06                	sd	ra,24(sp)
    80005596:	e822                	sd	s0,16(sp)
    80005598:	1000                	addi	s0,sp,32
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    8000559a:	fe840613          	addi	a2,s0,-24
    8000559e:	4581                	li	a1,0
    800055a0:	4501                	li	a0,0
    800055a2:	00000097          	auipc	ra,0x0
    800055a6:	c78080e7          	jalr	-904(ra) # 8000521a <argfd>
    return -1;
    800055aa:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055ac:	02054563          	bltz	a0,800055d6 <sys_fstat+0x44>
    800055b0:	fe040593          	addi	a1,s0,-32
    800055b4:	4505                	li	a0,1
    800055b6:	ffffd097          	auipc	ra,0xffffd
    800055ba:	758080e7          	jalr	1880(ra) # 80002d0e <argaddr>
    return -1;
    800055be:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0 || argaddr(1, &st) < 0)
    800055c0:	00054b63          	bltz	a0,800055d6 <sys_fstat+0x44>
  return filestat(f, st);
    800055c4:	fe043583          	ld	a1,-32(s0)
    800055c8:	fe843503          	ld	a0,-24(s0)
    800055cc:	fffff097          	auipc	ra,0xfffff
    800055d0:	306080e7          	jalr	774(ra) # 800048d2 <filestat>
    800055d4:	87aa                	mv	a5,a0
}
    800055d6:	853e                	mv	a0,a5
    800055d8:	60e2                	ld	ra,24(sp)
    800055da:	6442                	ld	s0,16(sp)
    800055dc:	6105                	addi	sp,sp,32
    800055de:	8082                	ret

00000000800055e0 <sys_link>:
{
    800055e0:	7169                	addi	sp,sp,-304
    800055e2:	f606                	sd	ra,296(sp)
    800055e4:	f222                	sd	s0,288(sp)
    800055e6:	ee26                	sd	s1,280(sp)
    800055e8:	ea4a                	sd	s2,272(sp)
    800055ea:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800055ec:	08000613          	li	a2,128
    800055f0:	ed040593          	addi	a1,s0,-304
    800055f4:	4501                	li	a0,0
    800055f6:	ffffd097          	auipc	ra,0xffffd
    800055fa:	73a080e7          	jalr	1850(ra) # 80002d30 <argstr>
    return -1;
    800055fe:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005600:	12054363          	bltz	a0,80005726 <sys_link+0x146>
    80005604:	08000613          	li	a2,128
    80005608:	f5040593          	addi	a1,s0,-176
    8000560c:	4505                	li	a0,1
    8000560e:	ffffd097          	auipc	ra,0xffffd
    80005612:	722080e7          	jalr	1826(ra) # 80002d30 <argstr>
    return -1;
    80005616:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80005618:	10054763          	bltz	a0,80005726 <sys_link+0x146>
  begin_op(ROOTDEV);
    8000561c:	4501                	li	a0,0
    8000561e:	fffff097          	auipc	ra,0xfffff
    80005622:	c4a080e7          	jalr	-950(ra) # 80004268 <begin_op>
  if((ip = namei(old)) == 0){
    80005626:	ed040513          	addi	a0,s0,-304
    8000562a:	fffff097          	auipc	ra,0xfffff
    8000562e:	9e4080e7          	jalr	-1564(ra) # 8000400e <namei>
    80005632:	84aa                	mv	s1,a0
    80005634:	c559                	beqz	a0,800056c2 <sys_link+0xe2>
  ilock(ip);
    80005636:	ffffe097          	auipc	ra,0xffffe
    8000563a:	24e080e7          	jalr	590(ra) # 80003884 <ilock>
  if(ip->type == T_DIR){
    8000563e:	04c49703          	lh	a4,76(s1)
    80005642:	4785                	li	a5,1
    80005644:	08f70663          	beq	a4,a5,800056d0 <sys_link+0xf0>
  ip->nlink++;
    80005648:	0524d783          	lhu	a5,82(s1)
    8000564c:	2785                	addiw	a5,a5,1
    8000564e:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80005652:	8526                	mv	a0,s1
    80005654:	ffffe097          	auipc	ra,0xffffe
    80005658:	166080e7          	jalr	358(ra) # 800037ba <iupdate>
  iunlock(ip);
    8000565c:	8526                	mv	a0,s1
    8000565e:	ffffe097          	auipc	ra,0xffffe
    80005662:	2e8080e7          	jalr	744(ra) # 80003946 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80005666:	fd040593          	addi	a1,s0,-48
    8000566a:	f5040513          	addi	a0,s0,-176
    8000566e:	fffff097          	auipc	ra,0xfffff
    80005672:	9be080e7          	jalr	-1602(ra) # 8000402c <nameiparent>
    80005676:	892a                	mv	s2,a0
    80005678:	cd2d                	beqz	a0,800056f2 <sys_link+0x112>
  ilock(dp);
    8000567a:	ffffe097          	auipc	ra,0xffffe
    8000567e:	20a080e7          	jalr	522(ra) # 80003884 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80005682:	00092703          	lw	a4,0(s2)
    80005686:	409c                	lw	a5,0(s1)
    80005688:	06f71063          	bne	a4,a5,800056e8 <sys_link+0x108>
    8000568c:	40d0                	lw	a2,4(s1)
    8000568e:	fd040593          	addi	a1,s0,-48
    80005692:	854a                	mv	a0,s2
    80005694:	fffff097          	auipc	ra,0xfffff
    80005698:	8b8080e7          	jalr	-1864(ra) # 80003f4c <dirlink>
    8000569c:	04054663          	bltz	a0,800056e8 <sys_link+0x108>
  iunlockput(dp);
    800056a0:	854a                	mv	a0,s2
    800056a2:	ffffe097          	auipc	ra,0xffffe
    800056a6:	420080e7          	jalr	1056(ra) # 80003ac2 <iunlockput>
  iput(ip);
    800056aa:	8526                	mv	a0,s1
    800056ac:	ffffe097          	auipc	ra,0xffffe
    800056b0:	2e6080e7          	jalr	742(ra) # 80003992 <iput>
  end_op(ROOTDEV);
    800056b4:	4501                	li	a0,0
    800056b6:	fffff097          	auipc	ra,0xfffff
    800056ba:	c5c080e7          	jalr	-932(ra) # 80004312 <end_op>
  return 0;
    800056be:	4781                	li	a5,0
    800056c0:	a09d                	j	80005726 <sys_link+0x146>
    end_op(ROOTDEV);
    800056c2:	4501                	li	a0,0
    800056c4:	fffff097          	auipc	ra,0xfffff
    800056c8:	c4e080e7          	jalr	-946(ra) # 80004312 <end_op>
    return -1;
    800056cc:	57fd                	li	a5,-1
    800056ce:	a8a1                	j	80005726 <sys_link+0x146>
    iunlockput(ip);
    800056d0:	8526                	mv	a0,s1
    800056d2:	ffffe097          	auipc	ra,0xffffe
    800056d6:	3f0080e7          	jalr	1008(ra) # 80003ac2 <iunlockput>
    end_op(ROOTDEV);
    800056da:	4501                	li	a0,0
    800056dc:	fffff097          	auipc	ra,0xfffff
    800056e0:	c36080e7          	jalr	-970(ra) # 80004312 <end_op>
    return -1;
    800056e4:	57fd                	li	a5,-1
    800056e6:	a081                	j	80005726 <sys_link+0x146>
    iunlockput(dp);
    800056e8:	854a                	mv	a0,s2
    800056ea:	ffffe097          	auipc	ra,0xffffe
    800056ee:	3d8080e7          	jalr	984(ra) # 80003ac2 <iunlockput>
  ilock(ip);
    800056f2:	8526                	mv	a0,s1
    800056f4:	ffffe097          	auipc	ra,0xffffe
    800056f8:	190080e7          	jalr	400(ra) # 80003884 <ilock>
  ip->nlink--;
    800056fc:	0524d783          	lhu	a5,82(s1)
    80005700:	37fd                	addiw	a5,a5,-1
    80005702:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80005706:	8526                	mv	a0,s1
    80005708:	ffffe097          	auipc	ra,0xffffe
    8000570c:	0b2080e7          	jalr	178(ra) # 800037ba <iupdate>
  iunlockput(ip);
    80005710:	8526                	mv	a0,s1
    80005712:	ffffe097          	auipc	ra,0xffffe
    80005716:	3b0080e7          	jalr	944(ra) # 80003ac2 <iunlockput>
  end_op(ROOTDEV);
    8000571a:	4501                	li	a0,0
    8000571c:	fffff097          	auipc	ra,0xfffff
    80005720:	bf6080e7          	jalr	-1034(ra) # 80004312 <end_op>
  return -1;
    80005724:	57fd                	li	a5,-1
}
    80005726:	853e                	mv	a0,a5
    80005728:	70b2                	ld	ra,296(sp)
    8000572a:	7412                	ld	s0,288(sp)
    8000572c:	64f2                	ld	s1,280(sp)
    8000572e:	6952                	ld	s2,272(sp)
    80005730:	6155                	addi	sp,sp,304
    80005732:	8082                	ret

0000000080005734 <sys_unlink>:
{
    80005734:	7151                	addi	sp,sp,-240
    80005736:	f586                	sd	ra,232(sp)
    80005738:	f1a2                	sd	s0,224(sp)
    8000573a:	eda6                	sd	s1,216(sp)
    8000573c:	e9ca                	sd	s2,208(sp)
    8000573e:	e5ce                	sd	s3,200(sp)
    80005740:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80005742:	08000613          	li	a2,128
    80005746:	f3040593          	addi	a1,s0,-208
    8000574a:	4501                	li	a0,0
    8000574c:	ffffd097          	auipc	ra,0xffffd
    80005750:	5e4080e7          	jalr	1508(ra) # 80002d30 <argstr>
    80005754:	18054463          	bltz	a0,800058dc <sys_unlink+0x1a8>
  begin_op(ROOTDEV);
    80005758:	4501                	li	a0,0
    8000575a:	fffff097          	auipc	ra,0xfffff
    8000575e:	b0e080e7          	jalr	-1266(ra) # 80004268 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80005762:	fb040593          	addi	a1,s0,-80
    80005766:	f3040513          	addi	a0,s0,-208
    8000576a:	fffff097          	auipc	ra,0xfffff
    8000576e:	8c2080e7          	jalr	-1854(ra) # 8000402c <nameiparent>
    80005772:	84aa                	mv	s1,a0
    80005774:	cd61                	beqz	a0,8000584c <sys_unlink+0x118>
  ilock(dp);
    80005776:	ffffe097          	auipc	ra,0xffffe
    8000577a:	10e080e7          	jalr	270(ra) # 80003884 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    8000577e:	00003597          	auipc	a1,0x3
    80005782:	2e258593          	addi	a1,a1,738 # 80008a60 <userret+0x9d0>
    80005786:	fb040513          	addi	a0,s0,-80
    8000578a:	ffffe097          	auipc	ra,0xffffe
    8000578e:	598080e7          	jalr	1432(ra) # 80003d22 <namecmp>
    80005792:	14050c63          	beqz	a0,800058ea <sys_unlink+0x1b6>
    80005796:	00003597          	auipc	a1,0x3
    8000579a:	2d258593          	addi	a1,a1,722 # 80008a68 <userret+0x9d8>
    8000579e:	fb040513          	addi	a0,s0,-80
    800057a2:	ffffe097          	auipc	ra,0xffffe
    800057a6:	580080e7          	jalr	1408(ra) # 80003d22 <namecmp>
    800057aa:	14050063          	beqz	a0,800058ea <sys_unlink+0x1b6>
  if((ip = dirlookup(dp, name, &off)) == 0)
    800057ae:	f2c40613          	addi	a2,s0,-212
    800057b2:	fb040593          	addi	a1,s0,-80
    800057b6:	8526                	mv	a0,s1
    800057b8:	ffffe097          	auipc	ra,0xffffe
    800057bc:	584080e7          	jalr	1412(ra) # 80003d3c <dirlookup>
    800057c0:	892a                	mv	s2,a0
    800057c2:	12050463          	beqz	a0,800058ea <sys_unlink+0x1b6>
  ilock(ip);
    800057c6:	ffffe097          	auipc	ra,0xffffe
    800057ca:	0be080e7          	jalr	190(ra) # 80003884 <ilock>
  if(ip->nlink < 1)
    800057ce:	05291783          	lh	a5,82(s2)
    800057d2:	08f05463          	blez	a5,8000585a <sys_unlink+0x126>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800057d6:	04c91703          	lh	a4,76(s2)
    800057da:	4785                	li	a5,1
    800057dc:	08f70763          	beq	a4,a5,8000586a <sys_unlink+0x136>
  memset(&de, 0, sizeof(de));
    800057e0:	4641                	li	a2,16
    800057e2:	4581                	li	a1,0
    800057e4:	fc040513          	addi	a0,s0,-64
    800057e8:	ffffb097          	auipc	ra,0xffffb
    800057ec:	596080e7          	jalr	1430(ra) # 80000d7e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800057f0:	4741                	li	a4,16
    800057f2:	f2c42683          	lw	a3,-212(s0)
    800057f6:	fc040613          	addi	a2,s0,-64
    800057fa:	4581                	li	a1,0
    800057fc:	8526                	mv	a0,s1
    800057fe:	ffffe097          	auipc	ra,0xffffe
    80005802:	40a080e7          	jalr	1034(ra) # 80003c08 <writei>
    80005806:	47c1                	li	a5,16
    80005808:	0af51763          	bne	a0,a5,800058b6 <sys_unlink+0x182>
  if(ip->type == T_DIR){
    8000580c:	04c91703          	lh	a4,76(s2)
    80005810:	4785                	li	a5,1
    80005812:	0af70a63          	beq	a4,a5,800058c6 <sys_unlink+0x192>
  iunlockput(dp);
    80005816:	8526                	mv	a0,s1
    80005818:	ffffe097          	auipc	ra,0xffffe
    8000581c:	2aa080e7          	jalr	682(ra) # 80003ac2 <iunlockput>
  ip->nlink--;
    80005820:	05295783          	lhu	a5,82(s2)
    80005824:	37fd                	addiw	a5,a5,-1
    80005826:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    8000582a:	854a                	mv	a0,s2
    8000582c:	ffffe097          	auipc	ra,0xffffe
    80005830:	f8e080e7          	jalr	-114(ra) # 800037ba <iupdate>
  iunlockput(ip);
    80005834:	854a                	mv	a0,s2
    80005836:	ffffe097          	auipc	ra,0xffffe
    8000583a:	28c080e7          	jalr	652(ra) # 80003ac2 <iunlockput>
  end_op(ROOTDEV);
    8000583e:	4501                	li	a0,0
    80005840:	fffff097          	auipc	ra,0xfffff
    80005844:	ad2080e7          	jalr	-1326(ra) # 80004312 <end_op>
  return 0;
    80005848:	4501                	li	a0,0
    8000584a:	a85d                	j	80005900 <sys_unlink+0x1cc>
    end_op(ROOTDEV);
    8000584c:	4501                	li	a0,0
    8000584e:	fffff097          	auipc	ra,0xfffff
    80005852:	ac4080e7          	jalr	-1340(ra) # 80004312 <end_op>
    return -1;
    80005856:	557d                	li	a0,-1
    80005858:	a065                	j	80005900 <sys_unlink+0x1cc>
    panic("unlink: nlink < 1");
    8000585a:	00003517          	auipc	a0,0x3
    8000585e:	23650513          	addi	a0,a0,566 # 80008a90 <userret+0xa00>
    80005862:	ffffb097          	auipc	ra,0xffffb
    80005866:	cf8080e7          	jalr	-776(ra) # 8000055a <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000586a:	05492703          	lw	a4,84(s2)
    8000586e:	02000793          	li	a5,32
    80005872:	f6e7f7e3          	bgeu	a5,a4,800057e0 <sys_unlink+0xac>
    80005876:	02000993          	li	s3,32
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000587a:	4741                	li	a4,16
    8000587c:	86ce                	mv	a3,s3
    8000587e:	f1840613          	addi	a2,s0,-232
    80005882:	4581                	li	a1,0
    80005884:	854a                	mv	a0,s2
    80005886:	ffffe097          	auipc	ra,0xffffe
    8000588a:	28e080e7          	jalr	654(ra) # 80003b14 <readi>
    8000588e:	47c1                	li	a5,16
    80005890:	00f51b63          	bne	a0,a5,800058a6 <sys_unlink+0x172>
    if(de.inum != 0)
    80005894:	f1845783          	lhu	a5,-232(s0)
    80005898:	e7a1                	bnez	a5,800058e0 <sys_unlink+0x1ac>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000589a:	29c1                	addiw	s3,s3,16
    8000589c:	05492783          	lw	a5,84(s2)
    800058a0:	fcf9ede3          	bltu	s3,a5,8000587a <sys_unlink+0x146>
    800058a4:	bf35                	j	800057e0 <sys_unlink+0xac>
      panic("isdirempty: readi");
    800058a6:	00003517          	auipc	a0,0x3
    800058aa:	20250513          	addi	a0,a0,514 # 80008aa8 <userret+0xa18>
    800058ae:	ffffb097          	auipc	ra,0xffffb
    800058b2:	cac080e7          	jalr	-852(ra) # 8000055a <panic>
    panic("unlink: writei");
    800058b6:	00003517          	auipc	a0,0x3
    800058ba:	20a50513          	addi	a0,a0,522 # 80008ac0 <userret+0xa30>
    800058be:	ffffb097          	auipc	ra,0xffffb
    800058c2:	c9c080e7          	jalr	-868(ra) # 8000055a <panic>
    dp->nlink--;
    800058c6:	0524d783          	lhu	a5,82(s1)
    800058ca:	37fd                	addiw	a5,a5,-1
    800058cc:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    800058d0:	8526                	mv	a0,s1
    800058d2:	ffffe097          	auipc	ra,0xffffe
    800058d6:	ee8080e7          	jalr	-280(ra) # 800037ba <iupdate>
    800058da:	bf35                	j	80005816 <sys_unlink+0xe2>
    return -1;
    800058dc:	557d                	li	a0,-1
    800058de:	a00d                	j	80005900 <sys_unlink+0x1cc>
    iunlockput(ip);
    800058e0:	854a                	mv	a0,s2
    800058e2:	ffffe097          	auipc	ra,0xffffe
    800058e6:	1e0080e7          	jalr	480(ra) # 80003ac2 <iunlockput>
  iunlockput(dp);
    800058ea:	8526                	mv	a0,s1
    800058ec:	ffffe097          	auipc	ra,0xffffe
    800058f0:	1d6080e7          	jalr	470(ra) # 80003ac2 <iunlockput>
  end_op(ROOTDEV);
    800058f4:	4501                	li	a0,0
    800058f6:	fffff097          	auipc	ra,0xfffff
    800058fa:	a1c080e7          	jalr	-1508(ra) # 80004312 <end_op>
  return -1;
    800058fe:	557d                	li	a0,-1
}
    80005900:	70ae                	ld	ra,232(sp)
    80005902:	740e                	ld	s0,224(sp)
    80005904:	64ee                	ld	s1,216(sp)
    80005906:	694e                	ld	s2,208(sp)
    80005908:	69ae                	ld	s3,200(sp)
    8000590a:	616d                	addi	sp,sp,240
    8000590c:	8082                	ret

000000008000590e <sys_open>:

uint64
sys_open(void)
{
    8000590e:	7131                	addi	sp,sp,-192
    80005910:	fd06                	sd	ra,184(sp)
    80005912:	f922                	sd	s0,176(sp)
    80005914:	f526                	sd	s1,168(sp)
    80005916:	f14a                	sd	s2,160(sp)
    80005918:	ed4e                	sd	s3,152(sp)
    8000591a:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    8000591c:	08000613          	li	a2,128
    80005920:	f5040593          	addi	a1,s0,-176
    80005924:	4501                	li	a0,0
    80005926:	ffffd097          	auipc	ra,0xffffd
    8000592a:	40a080e7          	jalr	1034(ra) # 80002d30 <argstr>
    return -1;
    8000592e:	54fd                	li	s1,-1
  if((n = argstr(0, path, MAXPATH)) < 0 || argint(1, &omode) < 0)
    80005930:	0a054963          	bltz	a0,800059e2 <sys_open+0xd4>
    80005934:	f4c40593          	addi	a1,s0,-180
    80005938:	4505                	li	a0,1
    8000593a:	ffffd097          	auipc	ra,0xffffd
    8000593e:	3b2080e7          	jalr	946(ra) # 80002cec <argint>
    80005942:	0a054063          	bltz	a0,800059e2 <sys_open+0xd4>

  begin_op(ROOTDEV);
    80005946:	4501                	li	a0,0
    80005948:	fffff097          	auipc	ra,0xfffff
    8000594c:	920080e7          	jalr	-1760(ra) # 80004268 <begin_op>

  if(omode & O_CREATE){
    80005950:	f4c42783          	lw	a5,-180(s0)
    80005954:	2007f793          	andi	a5,a5,512
    80005958:	c3dd                	beqz	a5,800059fe <sys_open+0xf0>
    ip = create(path, T_FILE, 0, 0);
    8000595a:	4681                	li	a3,0
    8000595c:	4601                	li	a2,0
    8000595e:	4589                	li	a1,2
    80005960:	f5040513          	addi	a0,s0,-176
    80005964:	00000097          	auipc	ra,0x0
    80005968:	960080e7          	jalr	-1696(ra) # 800052c4 <create>
    8000596c:	892a                	mv	s2,a0
    if(ip == 0){
    8000596e:	c151                	beqz	a0,800059f2 <sys_open+0xe4>
      end_op(ROOTDEV);
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80005970:	04c91703          	lh	a4,76(s2)
    80005974:	478d                	li	a5,3
    80005976:	00f71763          	bne	a4,a5,80005984 <sys_open+0x76>
    8000597a:	04e95703          	lhu	a4,78(s2)
    8000597e:	47a5                	li	a5,9
    80005980:	0ce7e663          	bltu	a5,a4,80005a4c <sys_open+0x13e>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80005984:	fffff097          	auipc	ra,0xfffff
    80005988:	dc2080e7          	jalr	-574(ra) # 80004746 <filealloc>
    8000598c:	89aa                	mv	s3,a0
    8000598e:	c97d                	beqz	a0,80005a84 <sys_open+0x176>
    80005990:	00000097          	auipc	ra,0x0
    80005994:	8f2080e7          	jalr	-1806(ra) # 80005282 <fdalloc>
    80005998:	84aa                	mv	s1,a0
    8000599a:	0e054063          	bltz	a0,80005a7a <sys_open+0x16c>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000599e:	04c91703          	lh	a4,76(s2)
    800059a2:	478d                	li	a5,3
    800059a4:	0cf70063          	beq	a4,a5,80005a64 <sys_open+0x156>
    f->type = FD_DEVICE;
    f->major = ip->major;
    f->minor = ip->minor;
  } else {
    f->type = FD_INODE;
    800059a8:	4789                	li	a5,2
    800059aa:	00f9a023          	sw	a5,0(s3)
  }
  f->ip = ip;
    800059ae:	0129bc23          	sd	s2,24(s3)
  f->off = 0;
    800059b2:	0209a023          	sw	zero,32(s3)
  f->readable = !(omode & O_WRONLY);
    800059b6:	f4c42783          	lw	a5,-180(s0)
    800059ba:	0017c713          	xori	a4,a5,1
    800059be:	8b05                	andi	a4,a4,1
    800059c0:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800059c4:	8b8d                	andi	a5,a5,3
    800059c6:	00f037b3          	snez	a5,a5
    800059ca:	00f984a3          	sb	a5,9(s3)

  iunlock(ip);
    800059ce:	854a                	mv	a0,s2
    800059d0:	ffffe097          	auipc	ra,0xffffe
    800059d4:	f76080e7          	jalr	-138(ra) # 80003946 <iunlock>
  end_op(ROOTDEV);
    800059d8:	4501                	li	a0,0
    800059da:	fffff097          	auipc	ra,0xfffff
    800059de:	938080e7          	jalr	-1736(ra) # 80004312 <end_op>

  return fd;
}
    800059e2:	8526                	mv	a0,s1
    800059e4:	70ea                	ld	ra,184(sp)
    800059e6:	744a                	ld	s0,176(sp)
    800059e8:	74aa                	ld	s1,168(sp)
    800059ea:	790a                	ld	s2,160(sp)
    800059ec:	69ea                	ld	s3,152(sp)
    800059ee:	6129                	addi	sp,sp,192
    800059f0:	8082                	ret
      end_op(ROOTDEV);
    800059f2:	4501                	li	a0,0
    800059f4:	fffff097          	auipc	ra,0xfffff
    800059f8:	91e080e7          	jalr	-1762(ra) # 80004312 <end_op>
      return -1;
    800059fc:	b7dd                	j	800059e2 <sys_open+0xd4>
    if((ip = namei(path)) == 0){
    800059fe:	f5040513          	addi	a0,s0,-176
    80005a02:	ffffe097          	auipc	ra,0xffffe
    80005a06:	60c080e7          	jalr	1548(ra) # 8000400e <namei>
    80005a0a:	892a                	mv	s2,a0
    80005a0c:	c90d                	beqz	a0,80005a3e <sys_open+0x130>
    ilock(ip);
    80005a0e:	ffffe097          	auipc	ra,0xffffe
    80005a12:	e76080e7          	jalr	-394(ra) # 80003884 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80005a16:	04c91703          	lh	a4,76(s2)
    80005a1a:	4785                	li	a5,1
    80005a1c:	f4f71ae3          	bne	a4,a5,80005970 <sys_open+0x62>
    80005a20:	f4c42783          	lw	a5,-180(s0)
    80005a24:	d3a5                	beqz	a5,80005984 <sys_open+0x76>
      iunlockput(ip);
    80005a26:	854a                	mv	a0,s2
    80005a28:	ffffe097          	auipc	ra,0xffffe
    80005a2c:	09a080e7          	jalr	154(ra) # 80003ac2 <iunlockput>
      end_op(ROOTDEV);
    80005a30:	4501                	li	a0,0
    80005a32:	fffff097          	auipc	ra,0xfffff
    80005a36:	8e0080e7          	jalr	-1824(ra) # 80004312 <end_op>
      return -1;
    80005a3a:	54fd                	li	s1,-1
    80005a3c:	b75d                	j	800059e2 <sys_open+0xd4>
      end_op(ROOTDEV);
    80005a3e:	4501                	li	a0,0
    80005a40:	fffff097          	auipc	ra,0xfffff
    80005a44:	8d2080e7          	jalr	-1838(ra) # 80004312 <end_op>
      return -1;
    80005a48:	54fd                	li	s1,-1
    80005a4a:	bf61                	j	800059e2 <sys_open+0xd4>
    iunlockput(ip);
    80005a4c:	854a                	mv	a0,s2
    80005a4e:	ffffe097          	auipc	ra,0xffffe
    80005a52:	074080e7          	jalr	116(ra) # 80003ac2 <iunlockput>
    end_op(ROOTDEV);
    80005a56:	4501                	li	a0,0
    80005a58:	fffff097          	auipc	ra,0xfffff
    80005a5c:	8ba080e7          	jalr	-1862(ra) # 80004312 <end_op>
    return -1;
    80005a60:	54fd                	li	s1,-1
    80005a62:	b741                	j	800059e2 <sys_open+0xd4>
    f->type = FD_DEVICE;
    80005a64:	00f9a023          	sw	a5,0(s3)
    f->major = ip->major;
    80005a68:	04e91783          	lh	a5,78(s2)
    80005a6c:	02f99223          	sh	a5,36(s3)
    f->minor = ip->minor;
    80005a70:	05091783          	lh	a5,80(s2)
    80005a74:	02f99323          	sh	a5,38(s3)
    80005a78:	bf1d                	j	800059ae <sys_open+0xa0>
      fileclose(f);
    80005a7a:	854e                	mv	a0,s3
    80005a7c:	fffff097          	auipc	ra,0xfffff
    80005a80:	d86080e7          	jalr	-634(ra) # 80004802 <fileclose>
    iunlockput(ip);
    80005a84:	854a                	mv	a0,s2
    80005a86:	ffffe097          	auipc	ra,0xffffe
    80005a8a:	03c080e7          	jalr	60(ra) # 80003ac2 <iunlockput>
    end_op(ROOTDEV);
    80005a8e:	4501                	li	a0,0
    80005a90:	fffff097          	auipc	ra,0xfffff
    80005a94:	882080e7          	jalr	-1918(ra) # 80004312 <end_op>
    return -1;
    80005a98:	54fd                	li	s1,-1
    80005a9a:	b7a1                	j	800059e2 <sys_open+0xd4>

0000000080005a9c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005a9c:	7175                	addi	sp,sp,-144
    80005a9e:	e506                	sd	ra,136(sp)
    80005aa0:	e122                	sd	s0,128(sp)
    80005aa2:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op(ROOTDEV);
    80005aa4:	4501                	li	a0,0
    80005aa6:	ffffe097          	auipc	ra,0xffffe
    80005aaa:	7c2080e7          	jalr	1986(ra) # 80004268 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80005aae:	08000613          	li	a2,128
    80005ab2:	f7040593          	addi	a1,s0,-144
    80005ab6:	4501                	li	a0,0
    80005ab8:	ffffd097          	auipc	ra,0xffffd
    80005abc:	278080e7          	jalr	632(ra) # 80002d30 <argstr>
    80005ac0:	02054a63          	bltz	a0,80005af4 <sys_mkdir+0x58>
    80005ac4:	4681                	li	a3,0
    80005ac6:	4601                	li	a2,0
    80005ac8:	4585                	li	a1,1
    80005aca:	f7040513          	addi	a0,s0,-144
    80005ace:	fffff097          	auipc	ra,0xfffff
    80005ad2:	7f6080e7          	jalr	2038(ra) # 800052c4 <create>
    80005ad6:	cd19                	beqz	a0,80005af4 <sys_mkdir+0x58>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    80005ad8:	ffffe097          	auipc	ra,0xffffe
    80005adc:	fea080e7          	jalr	-22(ra) # 80003ac2 <iunlockput>
  end_op(ROOTDEV);
    80005ae0:	4501                	li	a0,0
    80005ae2:	fffff097          	auipc	ra,0xfffff
    80005ae6:	830080e7          	jalr	-2000(ra) # 80004312 <end_op>
  return 0;
    80005aea:	4501                	li	a0,0
}
    80005aec:	60aa                	ld	ra,136(sp)
    80005aee:	640a                	ld	s0,128(sp)
    80005af0:	6149                	addi	sp,sp,144
    80005af2:	8082                	ret
    end_op(ROOTDEV);
    80005af4:	4501                	li	a0,0
    80005af6:	fffff097          	auipc	ra,0xfffff
    80005afa:	81c080e7          	jalr	-2020(ra) # 80004312 <end_op>
    return -1;
    80005afe:	557d                	li	a0,-1
    80005b00:	b7f5                	j	80005aec <sys_mkdir+0x50>

0000000080005b02 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005b02:	7135                	addi	sp,sp,-160
    80005b04:	ed06                	sd	ra,152(sp)
    80005b06:	e922                	sd	s0,144(sp)
    80005b08:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op(ROOTDEV);
    80005b0a:	4501                	li	a0,0
    80005b0c:	ffffe097          	auipc	ra,0xffffe
    80005b10:	75c080e7          	jalr	1884(ra) # 80004268 <begin_op>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b14:	08000613          	li	a2,128
    80005b18:	f7040593          	addi	a1,s0,-144
    80005b1c:	4501                	li	a0,0
    80005b1e:	ffffd097          	auipc	ra,0xffffd
    80005b22:	212080e7          	jalr	530(ra) # 80002d30 <argstr>
    80005b26:	04054b63          	bltz	a0,80005b7c <sys_mknod+0x7a>
     argint(1, &major) < 0 ||
    80005b2a:	f6c40593          	addi	a1,s0,-148
    80005b2e:	4505                	li	a0,1
    80005b30:	ffffd097          	auipc	ra,0xffffd
    80005b34:	1bc080e7          	jalr	444(ra) # 80002cec <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80005b38:	04054263          	bltz	a0,80005b7c <sys_mknod+0x7a>
     argint(2, &minor) < 0 ||
    80005b3c:	f6840593          	addi	a1,s0,-152
    80005b40:	4509                	li	a0,2
    80005b42:	ffffd097          	auipc	ra,0xffffd
    80005b46:	1aa080e7          	jalr	426(ra) # 80002cec <argint>
     argint(1, &major) < 0 ||
    80005b4a:	02054963          	bltz	a0,80005b7c <sys_mknod+0x7a>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80005b4e:	f6841683          	lh	a3,-152(s0)
    80005b52:	f6c41603          	lh	a2,-148(s0)
    80005b56:	458d                	li	a1,3
    80005b58:	f7040513          	addi	a0,s0,-144
    80005b5c:	fffff097          	auipc	ra,0xfffff
    80005b60:	768080e7          	jalr	1896(ra) # 800052c4 <create>
     argint(2, &minor) < 0 ||
    80005b64:	cd01                	beqz	a0,80005b7c <sys_mknod+0x7a>
    end_op(ROOTDEV);
    return -1;
  }
  iunlockput(ip);
    80005b66:	ffffe097          	auipc	ra,0xffffe
    80005b6a:	f5c080e7          	jalr	-164(ra) # 80003ac2 <iunlockput>
  end_op(ROOTDEV);
    80005b6e:	4501                	li	a0,0
    80005b70:	ffffe097          	auipc	ra,0xffffe
    80005b74:	7a2080e7          	jalr	1954(ra) # 80004312 <end_op>
  return 0;
    80005b78:	4501                	li	a0,0
    80005b7a:	a039                	j	80005b88 <sys_mknod+0x86>
    end_op(ROOTDEV);
    80005b7c:	4501                	li	a0,0
    80005b7e:	ffffe097          	auipc	ra,0xffffe
    80005b82:	794080e7          	jalr	1940(ra) # 80004312 <end_op>
    return -1;
    80005b86:	557d                	li	a0,-1
}
    80005b88:	60ea                	ld	ra,152(sp)
    80005b8a:	644a                	ld	s0,144(sp)
    80005b8c:	610d                	addi	sp,sp,160
    80005b8e:	8082                	ret

0000000080005b90 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005b90:	7135                	addi	sp,sp,-160
    80005b92:	ed06                	sd	ra,152(sp)
    80005b94:	e922                	sd	s0,144(sp)
    80005b96:	e526                	sd	s1,136(sp)
    80005b98:	e14a                	sd	s2,128(sp)
    80005b9a:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80005b9c:	ffffc097          	auipc	ra,0xffffc
    80005ba0:	f9a080e7          	jalr	-102(ra) # 80001b36 <myproc>
    80005ba4:	892a                	mv	s2,a0
  
  begin_op(ROOTDEV);
    80005ba6:	4501                	li	a0,0
    80005ba8:	ffffe097          	auipc	ra,0xffffe
    80005bac:	6c0080e7          	jalr	1728(ra) # 80004268 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80005bb0:	08000613          	li	a2,128
    80005bb4:	f6040593          	addi	a1,s0,-160
    80005bb8:	4501                	li	a0,0
    80005bba:	ffffd097          	auipc	ra,0xffffd
    80005bbe:	176080e7          	jalr	374(ra) # 80002d30 <argstr>
    80005bc2:	04054c63          	bltz	a0,80005c1a <sys_chdir+0x8a>
    80005bc6:	f6040513          	addi	a0,s0,-160
    80005bca:	ffffe097          	auipc	ra,0xffffe
    80005bce:	444080e7          	jalr	1092(ra) # 8000400e <namei>
    80005bd2:	84aa                	mv	s1,a0
    80005bd4:	c139                	beqz	a0,80005c1a <sys_chdir+0x8a>
    end_op(ROOTDEV);
    return -1;
  }
  ilock(ip);
    80005bd6:	ffffe097          	auipc	ra,0xffffe
    80005bda:	cae080e7          	jalr	-850(ra) # 80003884 <ilock>
  if(ip->type != T_DIR){
    80005bde:	04c49703          	lh	a4,76(s1)
    80005be2:	4785                	li	a5,1
    80005be4:	04f71263          	bne	a4,a5,80005c28 <sys_chdir+0x98>
    iunlockput(ip);
    end_op(ROOTDEV);
    return -1;
  }
  iunlock(ip);
    80005be8:	8526                	mv	a0,s1
    80005bea:	ffffe097          	auipc	ra,0xffffe
    80005bee:	d5c080e7          	jalr	-676(ra) # 80003946 <iunlock>
  iput(p->cwd);
    80005bf2:	15893503          	ld	a0,344(s2)
    80005bf6:	ffffe097          	auipc	ra,0xffffe
    80005bfa:	d9c080e7          	jalr	-612(ra) # 80003992 <iput>
  end_op(ROOTDEV);
    80005bfe:	4501                	li	a0,0
    80005c00:	ffffe097          	auipc	ra,0xffffe
    80005c04:	712080e7          	jalr	1810(ra) # 80004312 <end_op>
  p->cwd = ip;
    80005c08:	14993c23          	sd	s1,344(s2)
  return 0;
    80005c0c:	4501                	li	a0,0
}
    80005c0e:	60ea                	ld	ra,152(sp)
    80005c10:	644a                	ld	s0,144(sp)
    80005c12:	64aa                	ld	s1,136(sp)
    80005c14:	690a                	ld	s2,128(sp)
    80005c16:	610d                	addi	sp,sp,160
    80005c18:	8082                	ret
    end_op(ROOTDEV);
    80005c1a:	4501                	li	a0,0
    80005c1c:	ffffe097          	auipc	ra,0xffffe
    80005c20:	6f6080e7          	jalr	1782(ra) # 80004312 <end_op>
    return -1;
    80005c24:	557d                	li	a0,-1
    80005c26:	b7e5                	j	80005c0e <sys_chdir+0x7e>
    iunlockput(ip);
    80005c28:	8526                	mv	a0,s1
    80005c2a:	ffffe097          	auipc	ra,0xffffe
    80005c2e:	e98080e7          	jalr	-360(ra) # 80003ac2 <iunlockput>
    end_op(ROOTDEV);
    80005c32:	4501                	li	a0,0
    80005c34:	ffffe097          	auipc	ra,0xffffe
    80005c38:	6de080e7          	jalr	1758(ra) # 80004312 <end_op>
    return -1;
    80005c3c:	557d                	li	a0,-1
    80005c3e:	bfc1                	j	80005c0e <sys_chdir+0x7e>

0000000080005c40 <sys_exec>:

uint64
sys_exec(void)
{
    80005c40:	7145                	addi	sp,sp,-464
    80005c42:	e786                	sd	ra,456(sp)
    80005c44:	e3a2                	sd	s0,448(sp)
    80005c46:	ff26                	sd	s1,440(sp)
    80005c48:	fb4a                	sd	s2,432(sp)
    80005c4a:	f74e                	sd	s3,424(sp)
    80005c4c:	f352                	sd	s4,416(sp)
    80005c4e:	ef56                	sd	s5,408(sp)
    80005c50:	0b80                	addi	s0,sp,464
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  if(argstr(0, path, MAXPATH) < 0 || argaddr(1, &uargv) < 0){
    80005c52:	08000613          	li	a2,128
    80005c56:	f4040593          	addi	a1,s0,-192
    80005c5a:	4501                	li	a0,0
    80005c5c:	ffffd097          	auipc	ra,0xffffd
    80005c60:	0d4080e7          	jalr	212(ra) # 80002d30 <argstr>
    80005c64:	0e054663          	bltz	a0,80005d50 <sys_exec+0x110>
    80005c68:	e3840593          	addi	a1,s0,-456
    80005c6c:	4505                	li	a0,1
    80005c6e:	ffffd097          	auipc	ra,0xffffd
    80005c72:	0a0080e7          	jalr	160(ra) # 80002d0e <argaddr>
    80005c76:	0e054763          	bltz	a0,80005d64 <sys_exec+0x124>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005c7a:	10000613          	li	a2,256
    80005c7e:	4581                	li	a1,0
    80005c80:	e4040513          	addi	a0,s0,-448
    80005c84:	ffffb097          	auipc	ra,0xffffb
    80005c88:	0fa080e7          	jalr	250(ra) # 80000d7e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80005c8c:	e4040913          	addi	s2,s0,-448
  memset(argv, 0, sizeof(argv));
    80005c90:	89ca                	mv	s3,s2
    80005c92:	4481                	li	s1,0
    if(i >= NELEM(argv)){
    80005c94:	02000a13          	li	s4,32
    80005c98:	00048a9b          	sext.w	s5,s1
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80005c9c:	00349513          	slli	a0,s1,0x3
    80005ca0:	e3040593          	addi	a1,s0,-464
    80005ca4:	e3843783          	ld	a5,-456(s0)
    80005ca8:	953e                	add	a0,a0,a5
    80005caa:	ffffd097          	auipc	ra,0xffffd
    80005cae:	fa8080e7          	jalr	-88(ra) # 80002c52 <fetchaddr>
    80005cb2:	02054a63          	bltz	a0,80005ce6 <sys_exec+0xa6>
      goto bad;
    }
    if(uarg == 0){
    80005cb6:	e3043783          	ld	a5,-464(s0)
    80005cba:	c7a1                	beqz	a5,80005d02 <sys_exec+0xc2>
      argv[i] = 0;
      break;
    }
    argv[i] = kalloc();
    80005cbc:	ffffb097          	auipc	ra,0xffffb
    80005cc0:	cc0080e7          	jalr	-832(ra) # 8000097c <kalloc>
    80005cc4:	85aa                	mv	a1,a0
    80005cc6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80005cca:	c92d                	beqz	a0,80005d3c <sys_exec+0xfc>
      panic("sys_exec kalloc");
    if(fetchstr(uarg, argv[i], PGSIZE) < 0){
    80005ccc:	6605                	lui	a2,0x1
    80005cce:	e3043503          	ld	a0,-464(s0)
    80005cd2:	ffffd097          	auipc	ra,0xffffd
    80005cd6:	fd2080e7          	jalr	-46(ra) # 80002ca4 <fetchstr>
    80005cda:	00054663          	bltz	a0,80005ce6 <sys_exec+0xa6>
    if(i >= NELEM(argv)){
    80005cde:	0485                	addi	s1,s1,1
    80005ce0:	09a1                	addi	s3,s3,8
    80005ce2:	fb449be3          	bne	s1,s4,80005c98 <sys_exec+0x58>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005ce6:	10090493          	addi	s1,s2,256
    80005cea:	00093503          	ld	a0,0(s2)
    80005cee:	cd39                	beqz	a0,80005d4c <sys_exec+0x10c>
    kfree(argv[i]);
    80005cf0:	ffffb097          	auipc	ra,0xffffb
    80005cf4:	b90080e7          	jalr	-1136(ra) # 80000880 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005cf8:	0921                	addi	s2,s2,8
    80005cfa:	fe9918e3          	bne	s2,s1,80005cea <sys_exec+0xaa>
  return -1;
    80005cfe:	557d                	li	a0,-1
    80005d00:	a889                	j	80005d52 <sys_exec+0x112>
      argv[i] = 0;
    80005d02:	0a8e                	slli	s5,s5,0x3
    80005d04:	fc040793          	addi	a5,s0,-64
    80005d08:	9abe                	add	s5,s5,a5
    80005d0a:	e80ab023          	sd	zero,-384(s5) # ffffffffffffee80 <end+0xffffffff7ffd6e24>
  int ret = exec(path, argv);
    80005d0e:	e4040593          	addi	a1,s0,-448
    80005d12:	f4040513          	addi	a0,s0,-192
    80005d16:	fffff097          	auipc	ra,0xfffff
    80005d1a:	19a080e7          	jalr	410(ra) # 80004eb0 <exec>
    80005d1e:	84aa                	mv	s1,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d20:	10090993          	addi	s3,s2,256
    80005d24:	00093503          	ld	a0,0(s2)
    80005d28:	c901                	beqz	a0,80005d38 <sys_exec+0xf8>
    kfree(argv[i]);
    80005d2a:	ffffb097          	auipc	ra,0xffffb
    80005d2e:	b56080e7          	jalr	-1194(ra) # 80000880 <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005d32:	0921                	addi	s2,s2,8
    80005d34:	ff3918e3          	bne	s2,s3,80005d24 <sys_exec+0xe4>
  return ret;
    80005d38:	8526                	mv	a0,s1
    80005d3a:	a821                	j	80005d52 <sys_exec+0x112>
      panic("sys_exec kalloc");
    80005d3c:	00003517          	auipc	a0,0x3
    80005d40:	d9450513          	addi	a0,a0,-620 # 80008ad0 <userret+0xa40>
    80005d44:	ffffb097          	auipc	ra,0xffffb
    80005d48:	816080e7          	jalr	-2026(ra) # 8000055a <panic>
  return -1;
    80005d4c:	557d                	li	a0,-1
    80005d4e:	a011                	j	80005d52 <sys_exec+0x112>
    return -1;
    80005d50:	557d                	li	a0,-1
}
    80005d52:	60be                	ld	ra,456(sp)
    80005d54:	641e                	ld	s0,448(sp)
    80005d56:	74fa                	ld	s1,440(sp)
    80005d58:	795a                	ld	s2,432(sp)
    80005d5a:	79ba                	ld	s3,424(sp)
    80005d5c:	7a1a                	ld	s4,416(sp)
    80005d5e:	6afa                	ld	s5,408(sp)
    80005d60:	6179                	addi	sp,sp,464
    80005d62:	8082                	ret
    return -1;
    80005d64:	557d                	li	a0,-1
    80005d66:	b7f5                	j	80005d52 <sys_exec+0x112>

0000000080005d68 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005d68:	7139                	addi	sp,sp,-64
    80005d6a:	fc06                	sd	ra,56(sp)
    80005d6c:	f822                	sd	s0,48(sp)
    80005d6e:	f426                	sd	s1,40(sp)
    80005d70:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80005d72:	ffffc097          	auipc	ra,0xffffc
    80005d76:	dc4080e7          	jalr	-572(ra) # 80001b36 <myproc>
    80005d7a:	84aa                	mv	s1,a0

  if(argaddr(0, &fdarray) < 0)
    80005d7c:	fd840593          	addi	a1,s0,-40
    80005d80:	4501                	li	a0,0
    80005d82:	ffffd097          	auipc	ra,0xffffd
    80005d86:	f8c080e7          	jalr	-116(ra) # 80002d0e <argaddr>
    return -1;
    80005d8a:	57fd                	li	a5,-1
  if(argaddr(0, &fdarray) < 0)
    80005d8c:	0e054063          	bltz	a0,80005e6c <sys_pipe+0x104>
  if(pipealloc(&rf, &wf) < 0)
    80005d90:	fc840593          	addi	a1,s0,-56
    80005d94:	fd040513          	addi	a0,s0,-48
    80005d98:	fffff097          	auipc	ra,0xfffff
    80005d9c:	dce080e7          	jalr	-562(ra) # 80004b66 <pipealloc>
    return -1;
    80005da0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80005da2:	0c054563          	bltz	a0,80005e6c <sys_pipe+0x104>
  fd0 = -1;
    80005da6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80005daa:	fd043503          	ld	a0,-48(s0)
    80005dae:	fffff097          	auipc	ra,0xfffff
    80005db2:	4d4080e7          	jalr	1236(ra) # 80005282 <fdalloc>
    80005db6:	fca42223          	sw	a0,-60(s0)
    80005dba:	08054c63          	bltz	a0,80005e52 <sys_pipe+0xea>
    80005dbe:	fc843503          	ld	a0,-56(s0)
    80005dc2:	fffff097          	auipc	ra,0xfffff
    80005dc6:	4c0080e7          	jalr	1216(ra) # 80005282 <fdalloc>
    80005dca:	fca42023          	sw	a0,-64(s0)
    80005dce:	06054863          	bltz	a0,80005e3e <sys_pipe+0xd6>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005dd2:	4691                	li	a3,4
    80005dd4:	fc440613          	addi	a2,s0,-60
    80005dd8:	fd843583          	ld	a1,-40(s0)
    80005ddc:	6ca8                	ld	a0,88(s1)
    80005dde:	ffffc097          	auipc	ra,0xffffc
    80005de2:	a4c080e7          	jalr	-1460(ra) # 8000182a <copyout>
    80005de6:	02054063          	bltz	a0,80005e06 <sys_pipe+0x9e>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80005dea:	4691                	li	a3,4
    80005dec:	fc040613          	addi	a2,s0,-64
    80005df0:	fd843583          	ld	a1,-40(s0)
    80005df4:	0591                	addi	a1,a1,4
    80005df6:	6ca8                	ld	a0,88(s1)
    80005df8:	ffffc097          	auipc	ra,0xffffc
    80005dfc:	a32080e7          	jalr	-1486(ra) # 8000182a <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80005e00:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80005e02:	06055563          	bgez	a0,80005e6c <sys_pipe+0x104>
    p->ofile[fd0] = 0;
    80005e06:	fc442783          	lw	a5,-60(s0)
    80005e0a:	07e9                	addi	a5,a5,26
    80005e0c:	078e                	slli	a5,a5,0x3
    80005e0e:	97a6                	add	a5,a5,s1
    80005e10:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80005e14:	fc042503          	lw	a0,-64(s0)
    80005e18:	0569                	addi	a0,a0,26
    80005e1a:	050e                	slli	a0,a0,0x3
    80005e1c:	9526                	add	a0,a0,s1
    80005e1e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005e22:	fd043503          	ld	a0,-48(s0)
    80005e26:	fffff097          	auipc	ra,0xfffff
    80005e2a:	9dc080e7          	jalr	-1572(ra) # 80004802 <fileclose>
    fileclose(wf);
    80005e2e:	fc843503          	ld	a0,-56(s0)
    80005e32:	fffff097          	auipc	ra,0xfffff
    80005e36:	9d0080e7          	jalr	-1584(ra) # 80004802 <fileclose>
    return -1;
    80005e3a:	57fd                	li	a5,-1
    80005e3c:	a805                	j	80005e6c <sys_pipe+0x104>
    if(fd0 >= 0)
    80005e3e:	fc442783          	lw	a5,-60(s0)
    80005e42:	0007c863          	bltz	a5,80005e52 <sys_pipe+0xea>
      p->ofile[fd0] = 0;
    80005e46:	01a78513          	addi	a0,a5,26
    80005e4a:	050e                	slli	a0,a0,0x3
    80005e4c:	9526                	add	a0,a0,s1
    80005e4e:	00053423          	sd	zero,8(a0)
    fileclose(rf);
    80005e52:	fd043503          	ld	a0,-48(s0)
    80005e56:	fffff097          	auipc	ra,0xfffff
    80005e5a:	9ac080e7          	jalr	-1620(ra) # 80004802 <fileclose>
    fileclose(wf);
    80005e5e:	fc843503          	ld	a0,-56(s0)
    80005e62:	fffff097          	auipc	ra,0xfffff
    80005e66:	9a0080e7          	jalr	-1632(ra) # 80004802 <fileclose>
    return -1;
    80005e6a:	57fd                	li	a5,-1
}
    80005e6c:	853e                	mv	a0,a5
    80005e6e:	70e2                	ld	ra,56(sp)
    80005e70:	7442                	ld	s0,48(sp)
    80005e72:	74a2                	ld	s1,40(sp)
    80005e74:	6121                	addi	sp,sp,64
    80005e76:	8082                	ret
	...

0000000080005e80 <kernelvec>:
    80005e80:	7111                	addi	sp,sp,-256
    80005e82:	e006                	sd	ra,0(sp)
    80005e84:	e40a                	sd	sp,8(sp)
    80005e86:	e80e                	sd	gp,16(sp)
    80005e88:	ec12                	sd	tp,24(sp)
    80005e8a:	f016                	sd	t0,32(sp)
    80005e8c:	f41a                	sd	t1,40(sp)
    80005e8e:	f81e                	sd	t2,48(sp)
    80005e90:	fc22                	sd	s0,56(sp)
    80005e92:	e0a6                	sd	s1,64(sp)
    80005e94:	e4aa                	sd	a0,72(sp)
    80005e96:	e8ae                	sd	a1,80(sp)
    80005e98:	ecb2                	sd	a2,88(sp)
    80005e9a:	f0b6                	sd	a3,96(sp)
    80005e9c:	f4ba                	sd	a4,104(sp)
    80005e9e:	f8be                	sd	a5,112(sp)
    80005ea0:	fcc2                	sd	a6,120(sp)
    80005ea2:	e146                	sd	a7,128(sp)
    80005ea4:	e54a                	sd	s2,136(sp)
    80005ea6:	e94e                	sd	s3,144(sp)
    80005ea8:	ed52                	sd	s4,152(sp)
    80005eaa:	f156                	sd	s5,160(sp)
    80005eac:	f55a                	sd	s6,168(sp)
    80005eae:	f95e                	sd	s7,176(sp)
    80005eb0:	fd62                	sd	s8,184(sp)
    80005eb2:	e1e6                	sd	s9,192(sp)
    80005eb4:	e5ea                	sd	s10,200(sp)
    80005eb6:	e9ee                	sd	s11,208(sp)
    80005eb8:	edf2                	sd	t3,216(sp)
    80005eba:	f1f6                	sd	t4,224(sp)
    80005ebc:	f5fa                	sd	t5,232(sp)
    80005ebe:	f9fe                	sd	t6,240(sp)
    80005ec0:	c53fc0ef          	jal	ra,80002b12 <kerneltrap>
    80005ec4:	6082                	ld	ra,0(sp)
    80005ec6:	6122                	ld	sp,8(sp)
    80005ec8:	61c2                	ld	gp,16(sp)
    80005eca:	7282                	ld	t0,32(sp)
    80005ecc:	7322                	ld	t1,40(sp)
    80005ece:	73c2                	ld	t2,48(sp)
    80005ed0:	7462                	ld	s0,56(sp)
    80005ed2:	6486                	ld	s1,64(sp)
    80005ed4:	6526                	ld	a0,72(sp)
    80005ed6:	65c6                	ld	a1,80(sp)
    80005ed8:	6666                	ld	a2,88(sp)
    80005eda:	7686                	ld	a3,96(sp)
    80005edc:	7726                	ld	a4,104(sp)
    80005ede:	77c6                	ld	a5,112(sp)
    80005ee0:	7866                	ld	a6,120(sp)
    80005ee2:	688a                	ld	a7,128(sp)
    80005ee4:	692a                	ld	s2,136(sp)
    80005ee6:	69ca                	ld	s3,144(sp)
    80005ee8:	6a6a                	ld	s4,152(sp)
    80005eea:	7a8a                	ld	s5,160(sp)
    80005eec:	7b2a                	ld	s6,168(sp)
    80005eee:	7bca                	ld	s7,176(sp)
    80005ef0:	7c6a                	ld	s8,184(sp)
    80005ef2:	6c8e                	ld	s9,192(sp)
    80005ef4:	6d2e                	ld	s10,200(sp)
    80005ef6:	6dce                	ld	s11,208(sp)
    80005ef8:	6e6e                	ld	t3,216(sp)
    80005efa:	7e8e                	ld	t4,224(sp)
    80005efc:	7f2e                	ld	t5,232(sp)
    80005efe:	7fce                	ld	t6,240(sp)
    80005f00:	6111                	addi	sp,sp,256
    80005f02:	10200073          	sret
    80005f06:	00000013          	nop
    80005f0a:	00000013          	nop
    80005f0e:	0001                	nop

0000000080005f10 <timervec>:
    80005f10:	34051573          	csrrw	a0,mscratch,a0
    80005f14:	e10c                	sd	a1,0(a0)
    80005f16:	e510                	sd	a2,8(a0)
    80005f18:	e914                	sd	a3,16(a0)
    80005f1a:	710c                	ld	a1,32(a0)
    80005f1c:	7510                	ld	a2,40(a0)
    80005f1e:	6194                	ld	a3,0(a1)
    80005f20:	96b2                	add	a3,a3,a2
    80005f22:	e194                	sd	a3,0(a1)
    80005f24:	4589                	li	a1,2
    80005f26:	14459073          	csrw	sip,a1
    80005f2a:	6914                	ld	a3,16(a0)
    80005f2c:	6510                	ld	a2,8(a0)
    80005f2e:	610c                	ld	a1,0(a0)
    80005f30:	34051573          	csrrw	a0,mscratch,a0
    80005f34:	30200073          	mret
	...

0000000080005f3a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80005f3a:	1141                	addi	sp,sp,-16
    80005f3c:	e422                	sd	s0,8(sp)
    80005f3e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005f40:	0c0007b7          	lui	a5,0xc000
    80005f44:	4705                	li	a4,1
    80005f46:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005f48:	c3d8                	sw	a4,4(a5)
}
    80005f4a:	6422                	ld	s0,8(sp)
    80005f4c:	0141                	addi	sp,sp,16
    80005f4e:	8082                	ret

0000000080005f50 <plicinithart>:

void
plicinithart(void)
{
    80005f50:	1141                	addi	sp,sp,-16
    80005f52:	e406                	sd	ra,8(sp)
    80005f54:	e022                	sd	s0,0(sp)
    80005f56:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f58:	ffffc097          	auipc	ra,0xffffc
    80005f5c:	bb2080e7          	jalr	-1102(ra) # 80001b0a <cpuid>
  
  // set uart's enable bit for this hart's S-mode. 
  *(uint32*)PLIC_SENABLE(hart)= (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005f60:	0085171b          	slliw	a4,a0,0x8
    80005f64:	0c0027b7          	lui	a5,0xc002
    80005f68:	97ba                	add	a5,a5,a4
    80005f6a:	40200713          	li	a4,1026
    80005f6e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005f72:	00d5151b          	slliw	a0,a0,0xd
    80005f76:	0c2017b7          	lui	a5,0xc201
    80005f7a:	953e                	add	a0,a0,a5
    80005f7c:	00052023          	sw	zero,0(a0)
}
    80005f80:	60a2                	ld	ra,8(sp)
    80005f82:	6402                	ld	s0,0(sp)
    80005f84:	0141                	addi	sp,sp,16
    80005f86:	8082                	ret

0000000080005f88 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005f88:	1141                	addi	sp,sp,-16
    80005f8a:	e406                	sd	ra,8(sp)
    80005f8c:	e022                	sd	s0,0(sp)
    80005f8e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005f90:	ffffc097          	auipc	ra,0xffffc
    80005f94:	b7a080e7          	jalr	-1158(ra) # 80001b0a <cpuid>
  //int irq = *(uint32*)(PLIC + 0x201004);
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005f98:	00d5179b          	slliw	a5,a0,0xd
    80005f9c:	0c201537          	lui	a0,0xc201
    80005fa0:	953e                	add	a0,a0,a5
  return irq;
}
    80005fa2:	4148                	lw	a0,4(a0)
    80005fa4:	60a2                	ld	ra,8(sp)
    80005fa6:	6402                	ld	s0,0(sp)
    80005fa8:	0141                	addi	sp,sp,16
    80005faa:	8082                	ret

0000000080005fac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80005fac:	1101                	addi	sp,sp,-32
    80005fae:	ec06                	sd	ra,24(sp)
    80005fb0:	e822                	sd	s0,16(sp)
    80005fb2:	e426                	sd	s1,8(sp)
    80005fb4:	1000                	addi	s0,sp,32
    80005fb6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005fb8:	ffffc097          	auipc	ra,0xffffc
    80005fbc:	b52080e7          	jalr	-1198(ra) # 80001b0a <cpuid>
  //*(uint32*)(PLIC + 0x201004) = irq;
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005fc0:	00d5151b          	slliw	a0,a0,0xd
    80005fc4:	0c2017b7          	lui	a5,0xc201
    80005fc8:	97aa                	add	a5,a5,a0
    80005fca:	c3c4                	sw	s1,4(a5)
}
    80005fcc:	60e2                	ld	ra,24(sp)
    80005fce:	6442                	ld	s0,16(sp)
    80005fd0:	64a2                	ld	s1,8(sp)
    80005fd2:	6105                	addi	sp,sp,32
    80005fd4:	8082                	ret

0000000080005fd6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int n, int i)
{
    80005fd6:	1141                	addi	sp,sp,-16
    80005fd8:	e406                	sd	ra,8(sp)
    80005fda:	e022                	sd	s0,0(sp)
    80005fdc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80005fde:	479d                	li	a5,7
    80005fe0:	06b7c963          	blt	a5,a1,80006052 <free_desc+0x7c>
    panic("virtio_disk_intr 1");
  if(disk[n].free[i])
    80005fe4:	00151793          	slli	a5,a0,0x1
    80005fe8:	97aa                	add	a5,a5,a0
    80005fea:	00c79713          	slli	a4,a5,0xc
    80005fee:	0001c797          	auipc	a5,0x1c
    80005ff2:	01278793          	addi	a5,a5,18 # 80022000 <disk>
    80005ff6:	97ba                	add	a5,a5,a4
    80005ff8:	97ae                	add	a5,a5,a1
    80005ffa:	6709                	lui	a4,0x2
    80005ffc:	97ba                	add	a5,a5,a4
    80005ffe:	0187c783          	lbu	a5,24(a5)
    80006002:	e3a5                	bnez	a5,80006062 <free_desc+0x8c>
    panic("virtio_disk_intr 2");
  disk[n].desc[i].addr = 0;
    80006004:	0001c817          	auipc	a6,0x1c
    80006008:	ffc80813          	addi	a6,a6,-4 # 80022000 <disk>
    8000600c:	00151693          	slli	a3,a0,0x1
    80006010:	00a68733          	add	a4,a3,a0
    80006014:	0732                	slli	a4,a4,0xc
    80006016:	00e807b3          	add	a5,a6,a4
    8000601a:	6709                	lui	a4,0x2
    8000601c:	00f70633          	add	a2,a4,a5
    80006020:	6210                	ld	a2,0(a2)
    80006022:	00459893          	slli	a7,a1,0x4
    80006026:	9646                	add	a2,a2,a7
    80006028:	00063023          	sd	zero,0(a2) # 1000 <_entry-0x7ffff000>
  disk[n].free[i] = 1;
    8000602c:	97ae                	add	a5,a5,a1
    8000602e:	97ba                	add	a5,a5,a4
    80006030:	4605                	li	a2,1
    80006032:	00c78c23          	sb	a2,24(a5)
  wakeup(&disk[n].free[0]);
    80006036:	96aa                	add	a3,a3,a0
    80006038:	06b2                	slli	a3,a3,0xc
    8000603a:	0761                	addi	a4,a4,24
    8000603c:	96ba                	add	a3,a3,a4
    8000603e:	00d80533          	add	a0,a6,a3
    80006042:	ffffc097          	auipc	ra,0xffffc
    80006046:	436080e7          	jalr	1078(ra) # 80002478 <wakeup>
}
    8000604a:	60a2                	ld	ra,8(sp)
    8000604c:	6402                	ld	s0,0(sp)
    8000604e:	0141                	addi	sp,sp,16
    80006050:	8082                	ret
    panic("virtio_disk_intr 1");
    80006052:	00003517          	auipc	a0,0x3
    80006056:	a8e50513          	addi	a0,a0,-1394 # 80008ae0 <userret+0xa50>
    8000605a:	ffffa097          	auipc	ra,0xffffa
    8000605e:	500080e7          	jalr	1280(ra) # 8000055a <panic>
    panic("virtio_disk_intr 2");
    80006062:	00003517          	auipc	a0,0x3
    80006066:	a9650513          	addi	a0,a0,-1386 # 80008af8 <userret+0xa68>
    8000606a:	ffffa097          	auipc	ra,0xffffa
    8000606e:	4f0080e7          	jalr	1264(ra) # 8000055a <panic>

0000000080006072 <virtio_disk_init>:
  __sync_synchronize();
    80006072:	0ff0000f          	fence
  if(disk[n].init)
    80006076:	00151793          	slli	a5,a0,0x1
    8000607a:	97aa                	add	a5,a5,a0
    8000607c:	07b2                	slli	a5,a5,0xc
    8000607e:	0001c717          	auipc	a4,0x1c
    80006082:	f8270713          	addi	a4,a4,-126 # 80022000 <disk>
    80006086:	973e                	add	a4,a4,a5
    80006088:	6789                	lui	a5,0x2
    8000608a:	97ba                	add	a5,a5,a4
    8000608c:	0a87a783          	lw	a5,168(a5) # 20a8 <_entry-0x7fffdf58>
    80006090:	c391                	beqz	a5,80006094 <virtio_disk_init+0x22>
    80006092:	8082                	ret
{
    80006094:	7139                	addi	sp,sp,-64
    80006096:	fc06                	sd	ra,56(sp)
    80006098:	f822                	sd	s0,48(sp)
    8000609a:	f426                	sd	s1,40(sp)
    8000609c:	f04a                	sd	s2,32(sp)
    8000609e:	ec4e                	sd	s3,24(sp)
    800060a0:	e852                	sd	s4,16(sp)
    800060a2:	e456                	sd	s5,8(sp)
    800060a4:	0080                	addi	s0,sp,64
    800060a6:	84aa                	mv	s1,a0
  printf("virtio disk init %d\n", n);
    800060a8:	85aa                	mv	a1,a0
    800060aa:	00003517          	auipc	a0,0x3
    800060ae:	a6650513          	addi	a0,a0,-1434 # 80008b10 <userret+0xa80>
    800060b2:	ffffa097          	auipc	ra,0xffffa
    800060b6:	502080e7          	jalr	1282(ra) # 800005b4 <printf>
  initlock(&disk[n].vdisk_lock, "virtio_disk");
    800060ba:	00149993          	slli	s3,s1,0x1
    800060be:	99a6                	add	s3,s3,s1
    800060c0:	09b2                	slli	s3,s3,0xc
    800060c2:	6789                	lui	a5,0x2
    800060c4:	0b078793          	addi	a5,a5,176 # 20b0 <_entry-0x7fffdf50>
    800060c8:	97ce                	add	a5,a5,s3
    800060ca:	00003597          	auipc	a1,0x3
    800060ce:	a5e58593          	addi	a1,a1,-1442 # 80008b28 <userret+0xa98>
    800060d2:	0001c517          	auipc	a0,0x1c
    800060d6:	f2e50513          	addi	a0,a0,-210 # 80022000 <disk>
    800060da:	953e                	add	a0,a0,a5
    800060dc:	ffffb097          	auipc	ra,0xffffb
    800060e0:	900080e7          	jalr	-1792(ra) # 800009dc <initlock>
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800060e4:	0014891b          	addiw	s2,s1,1
    800060e8:	00c9191b          	slliw	s2,s2,0xc
    800060ec:	100007b7          	lui	a5,0x10000
    800060f0:	97ca                	add	a5,a5,s2
    800060f2:	4398                	lw	a4,0(a5)
    800060f4:	2701                	sext.w	a4,a4
    800060f6:	747277b7          	lui	a5,0x74727
    800060fa:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800060fe:	12f71663          	bne	a4,a5,8000622a <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80006102:	100007b7          	lui	a5,0x10000
    80006106:	0791                	addi	a5,a5,4
    80006108:	97ca                	add	a5,a5,s2
    8000610a:	439c                	lw	a5,0(a5)
    8000610c:	2781                	sext.w	a5,a5
  if(*R(n, VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000610e:	4705                	li	a4,1
    80006110:	10e79d63          	bne	a5,a4,8000622a <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006114:	100007b7          	lui	a5,0x10000
    80006118:	07a1                	addi	a5,a5,8
    8000611a:	97ca                	add	a5,a5,s2
    8000611c:	439c                	lw	a5,0(a5)
    8000611e:	2781                	sext.w	a5,a5
     *R(n, VIRTIO_MMIO_VERSION) != 1 ||
    80006120:	4709                	li	a4,2
    80006122:	10e79463          	bne	a5,a4,8000622a <virtio_disk_init+0x1b8>
     *R(n, VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80006126:	100007b7          	lui	a5,0x10000
    8000612a:	07b1                	addi	a5,a5,12
    8000612c:	97ca                	add	a5,a5,s2
    8000612e:	4398                	lw	a4,0(a5)
    80006130:	2701                	sext.w	a4,a4
     *R(n, VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80006132:	554d47b7          	lui	a5,0x554d4
    80006136:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000613a:	0ef71863          	bne	a4,a5,8000622a <virtio_disk_init+0x1b8>
  *R(n, VIRTIO_MMIO_STATUS) = status;
    8000613e:	100007b7          	lui	a5,0x10000
    80006142:	07078693          	addi	a3,a5,112 # 10000070 <_entry-0x6fffff90>
    80006146:	96ca                	add	a3,a3,s2
    80006148:	4705                	li	a4,1
    8000614a:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    8000614c:	470d                	li	a4,3
    8000614e:	c298                	sw	a4,0(a3)
  uint64 features = *R(n, VIRTIO_MMIO_DEVICE_FEATURES);
    80006150:	01078713          	addi	a4,a5,16
    80006154:	974a                	add	a4,a4,s2
    80006156:	430c                	lw	a1,0(a4)
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006158:	02078613          	addi	a2,a5,32
    8000615c:	964a                	add	a2,a2,s2
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    8000615e:	c7ffe737          	lui	a4,0xc7ffe
    80006162:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fd6703>
    80006166:	8f6d                	and	a4,a4,a1
  *R(n, VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80006168:	2701                	sext.w	a4,a4
    8000616a:	c218                	sw	a4,0(a2)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    8000616c:	472d                	li	a4,11
    8000616e:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_STATUS) = status;
    80006170:	473d                	li	a4,15
    80006172:	c298                	sw	a4,0(a3)
  *R(n, VIRTIO_MMIO_GUEST_PAGE_SIZE) = PGSIZE;
    80006174:	02878713          	addi	a4,a5,40
    80006178:	974a                	add	a4,a4,s2
    8000617a:	6685                	lui	a3,0x1
    8000617c:	c314                	sw	a3,0(a4)
  *R(n, VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000617e:	03078713          	addi	a4,a5,48
    80006182:	974a                	add	a4,a4,s2
    80006184:	00072023          	sw	zero,0(a4)
  uint32 max = *R(n, VIRTIO_MMIO_QUEUE_NUM_MAX);
    80006188:	03478793          	addi	a5,a5,52
    8000618c:	97ca                	add	a5,a5,s2
    8000618e:	439c                	lw	a5,0(a5)
    80006190:	2781                	sext.w	a5,a5
  if(max == 0)
    80006192:	c7c5                	beqz	a5,8000623a <virtio_disk_init+0x1c8>
  if(max < NUM)
    80006194:	471d                	li	a4,7
    80006196:	0af77a63          	bgeu	a4,a5,8000624a <virtio_disk_init+0x1d8>
  *R(n, VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000619a:	10000ab7          	lui	s5,0x10000
    8000619e:	038a8793          	addi	a5,s5,56 # 10000038 <_entry-0x6fffffc8>
    800061a2:	97ca                	add	a5,a5,s2
    800061a4:	4721                	li	a4,8
    800061a6:	c398                	sw	a4,0(a5)
  memset(disk[n].pages, 0, sizeof(disk[n].pages));
    800061a8:	0001ca17          	auipc	s4,0x1c
    800061ac:	e58a0a13          	addi	s4,s4,-424 # 80022000 <disk>
    800061b0:	99d2                	add	s3,s3,s4
    800061b2:	6609                	lui	a2,0x2
    800061b4:	4581                	li	a1,0
    800061b6:	854e                	mv	a0,s3
    800061b8:	ffffb097          	auipc	ra,0xffffb
    800061bc:	bc6080e7          	jalr	-1082(ra) # 80000d7e <memset>
  *R(n, VIRTIO_MMIO_QUEUE_PFN) = ((uint64)disk[n].pages) >> PGSHIFT;
    800061c0:	040a8a93          	addi	s5,s5,64
    800061c4:	9956                	add	s2,s2,s5
    800061c6:	00c9d793          	srli	a5,s3,0xc
    800061ca:	2781                	sext.w	a5,a5
    800061cc:	00f92023          	sw	a5,0(s2)
  disk[n].desc = (struct VRingDesc *) disk[n].pages;
    800061d0:	00149513          	slli	a0,s1,0x1
    800061d4:	009507b3          	add	a5,a0,s1
    800061d8:	07b2                	slli	a5,a5,0xc
    800061da:	97d2                	add	a5,a5,s4
    800061dc:	6689                	lui	a3,0x2
    800061de:	97b6                	add	a5,a5,a3
    800061e0:	0137b023          	sd	s3,0(a5)
  disk[n].avail = (uint16*)(((char*)disk[n].desc) + NUM*sizeof(struct VRingDesc));
    800061e4:	08098713          	addi	a4,s3,128
    800061e8:	e798                	sd	a4,8(a5)
  disk[n].used = (struct UsedArea *) (disk[n].pages + PGSIZE);
    800061ea:	6705                	lui	a4,0x1
    800061ec:	99ba                	add	s3,s3,a4
    800061ee:	0137b823          	sd	s3,16(a5)
    disk[n].free[i] = 1;
    800061f2:	4705                	li	a4,1
    800061f4:	00e78c23          	sb	a4,24(a5)
    800061f8:	00e78ca3          	sb	a4,25(a5)
    800061fc:	00e78d23          	sb	a4,26(a5)
    80006200:	00e78da3          	sb	a4,27(a5)
    80006204:	00e78e23          	sb	a4,28(a5)
    80006208:	00e78ea3          	sb	a4,29(a5)
    8000620c:	00e78f23          	sb	a4,30(a5)
    80006210:	00e78fa3          	sb	a4,31(a5)
  disk[n].init = 1;
    80006214:	0ae7a423          	sw	a4,168(a5)
}
    80006218:	70e2                	ld	ra,56(sp)
    8000621a:	7442                	ld	s0,48(sp)
    8000621c:	74a2                	ld	s1,40(sp)
    8000621e:	7902                	ld	s2,32(sp)
    80006220:	69e2                	ld	s3,24(sp)
    80006222:	6a42                	ld	s4,16(sp)
    80006224:	6aa2                	ld	s5,8(sp)
    80006226:	6121                	addi	sp,sp,64
    80006228:	8082                	ret
    panic("could not find virtio disk");
    8000622a:	00003517          	auipc	a0,0x3
    8000622e:	90e50513          	addi	a0,a0,-1778 # 80008b38 <userret+0xaa8>
    80006232:	ffffa097          	auipc	ra,0xffffa
    80006236:	328080e7          	jalr	808(ra) # 8000055a <panic>
    panic("virtio disk has no queue 0");
    8000623a:	00003517          	auipc	a0,0x3
    8000623e:	91e50513          	addi	a0,a0,-1762 # 80008b58 <userret+0xac8>
    80006242:	ffffa097          	auipc	ra,0xffffa
    80006246:	318080e7          	jalr	792(ra) # 8000055a <panic>
    panic("virtio disk max queue too short");
    8000624a:	00003517          	auipc	a0,0x3
    8000624e:	92e50513          	addi	a0,a0,-1746 # 80008b78 <userret+0xae8>
    80006252:	ffffa097          	auipc	ra,0xffffa
    80006256:	308080e7          	jalr	776(ra) # 8000055a <panic>

000000008000625a <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(int n, struct buf *b, int write)
{
    8000625a:	7135                	addi	sp,sp,-160
    8000625c:	ed06                	sd	ra,152(sp)
    8000625e:	e922                	sd	s0,144(sp)
    80006260:	e526                	sd	s1,136(sp)
    80006262:	e14a                	sd	s2,128(sp)
    80006264:	fcce                	sd	s3,120(sp)
    80006266:	f8d2                	sd	s4,112(sp)
    80006268:	f4d6                	sd	s5,104(sp)
    8000626a:	f0da                	sd	s6,96(sp)
    8000626c:	ecde                	sd	s7,88(sp)
    8000626e:	e8e2                	sd	s8,80(sp)
    80006270:	e4e6                	sd	s9,72(sp)
    80006272:	e0ea                	sd	s10,64(sp)
    80006274:	fc6e                	sd	s11,56(sp)
    80006276:	1100                	addi	s0,sp,160
    80006278:	892a                	mv	s2,a0
    8000627a:	89ae                	mv	s3,a1
    8000627c:	8db2                	mv	s11,a2
  uint64 sector = b->blockno * (BSIZE / 512);
    8000627e:	45dc                	lw	a5,12(a1)
    80006280:	0017979b          	slliw	a5,a5,0x1
    80006284:	1782                	slli	a5,a5,0x20
    80006286:	9381                	srli	a5,a5,0x20
    80006288:	f6f43423          	sd	a5,-152(s0)

  acquire(&disk[n].vdisk_lock);
    8000628c:	00151493          	slli	s1,a0,0x1
    80006290:	94aa                	add	s1,s1,a0
    80006292:	04b2                	slli	s1,s1,0xc
    80006294:	6a89                	lui	s5,0x2
    80006296:	0b0a8a13          	addi	s4,s5,176 # 20b0 <_entry-0x7fffdf50>
    8000629a:	9a26                	add	s4,s4,s1
    8000629c:	0001cb97          	auipc	s7,0x1c
    800062a0:	d64b8b93          	addi	s7,s7,-668 # 80022000 <disk>
    800062a4:	9a5e                	add	s4,s4,s7
    800062a6:	8552                	mv	a0,s4
    800062a8:	ffffb097          	auipc	ra,0xffffb
    800062ac:	808080e7          	jalr	-2040(ra) # 80000ab0 <acquire>
  int idx[3];
  while(1){
    if(alloc3_desc(n, idx) == 0) {
      break;
    }
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    800062b0:	0ae1                	addi	s5,s5,24
    800062b2:	94d6                	add	s1,s1,s5
    800062b4:	01748ab3          	add	s5,s1,s7
    800062b8:	8d56                	mv	s10,s5
  for(int i = 0; i < 3; i++){
    800062ba:	4b81                	li	s7,0
  for(int i = 0; i < NUM; i++){
    800062bc:	4ca1                	li	s9,8
      disk[n].free[i] = 0;
    800062be:	00191b13          	slli	s6,s2,0x1
    800062c2:	9b4a                	add	s6,s6,s2
    800062c4:	00cb1793          	slli	a5,s6,0xc
    800062c8:	0001cb17          	auipc	s6,0x1c
    800062cc:	d38b0b13          	addi	s6,s6,-712 # 80022000 <disk>
    800062d0:	9b3e                	add	s6,s6,a5
  for(int i = 0; i < NUM; i++){
    800062d2:	8c5e                	mv	s8,s7
    800062d4:	a8ad                	j	8000634e <virtio_disk_rw+0xf4>
      disk[n].free[i] = 0;
    800062d6:	00fb06b3          	add	a3,s6,a5
    800062da:	96aa                	add	a3,a3,a0
    800062dc:	00068c23          	sb	zero,24(a3) # 2018 <_entry-0x7fffdfe8>
    idx[i] = alloc_desc(n);
    800062e0:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800062e2:	0207c363          	bltz	a5,80006308 <virtio_disk_rw+0xae>
  for(int i = 0; i < 3; i++){
    800062e6:	2485                	addiw	s1,s1,1
    800062e8:	0711                	addi	a4,a4,4
    800062ea:	1eb48363          	beq	s1,a1,800064d0 <virtio_disk_rw+0x276>
    idx[i] = alloc_desc(n);
    800062ee:	863a                	mv	a2,a4
    800062f0:	86ea                	mv	a3,s10
  for(int i = 0; i < NUM; i++){
    800062f2:	87e2                	mv	a5,s8
    if(disk[n].free[i]){
    800062f4:	0006c803          	lbu	a6,0(a3)
    800062f8:	fc081fe3          	bnez	a6,800062d6 <virtio_disk_rw+0x7c>
  for(int i = 0; i < NUM; i++){
    800062fc:	2785                	addiw	a5,a5,1
    800062fe:	0685                	addi	a3,a3,1
    80006300:	ff979ae3          	bne	a5,s9,800062f4 <virtio_disk_rw+0x9a>
    idx[i] = alloc_desc(n);
    80006304:	57fd                	li	a5,-1
    80006306:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80006308:	02905d63          	blez	s1,80006342 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    8000630c:	f8042583          	lw	a1,-128(s0)
    80006310:	854a                	mv	a0,s2
    80006312:	00000097          	auipc	ra,0x0
    80006316:	cc4080e7          	jalr	-828(ra) # 80005fd6 <free_desc>
      for(int j = 0; j < i; j++)
    8000631a:	4785                	li	a5,1
    8000631c:	0297d363          	bge	a5,s1,80006342 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    80006320:	f8442583          	lw	a1,-124(s0)
    80006324:	854a                	mv	a0,s2
    80006326:	00000097          	auipc	ra,0x0
    8000632a:	cb0080e7          	jalr	-848(ra) # 80005fd6 <free_desc>
      for(int j = 0; j < i; j++)
    8000632e:	4789                	li	a5,2
    80006330:	0097d963          	bge	a5,s1,80006342 <virtio_disk_rw+0xe8>
        free_desc(n, idx[j]);
    80006334:	f8842583          	lw	a1,-120(s0)
    80006338:	854a                	mv	a0,s2
    8000633a:	00000097          	auipc	ra,0x0
    8000633e:	c9c080e7          	jalr	-868(ra) # 80005fd6 <free_desc>
    sleep(&disk[n].free[0], &disk[n].vdisk_lock);
    80006342:	85d2                	mv	a1,s4
    80006344:	8556                	mv	a0,s5
    80006346:	ffffc097          	auipc	ra,0xffffc
    8000634a:	fac080e7          	jalr	-84(ra) # 800022f2 <sleep>
  for(int i = 0; i < 3; i++){
    8000634e:	f8040713          	addi	a4,s0,-128
    80006352:	84de                	mv	s1,s7
      disk[n].free[i] = 0;
    80006354:	6509                	lui	a0,0x2
  for(int i = 0; i < 3; i++){
    80006356:	458d                	li	a1,3
    80006358:	bf59                	j	800062ee <virtio_disk_rw+0x94>
  disk[n].desc[idx[0]].next = idx[1];

  disk[n].desc[idx[1]].addr = (uint64) b->data;
  disk[n].desc[idx[1]].len = BSIZE;
  if(write)
    disk[n].desc[idx[1]].flags = 0; // device reads b->data
    8000635a:	00191793          	slli	a5,s2,0x1
    8000635e:	97ca                	add	a5,a5,s2
    80006360:	07b2                	slli	a5,a5,0xc
    80006362:	0001c717          	auipc	a4,0x1c
    80006366:	c9e70713          	addi	a4,a4,-866 # 80022000 <disk>
    8000636a:	973e                	add	a4,a4,a5
    8000636c:	6789                	lui	a5,0x2
    8000636e:	97ba                	add	a5,a5,a4
    80006370:	639c                	ld	a5,0(a5)
    80006372:	97b6                	add	a5,a5,a3
    80006374:	00079623          	sh	zero,12(a5) # 200c <_entry-0x7fffdff4>
  else
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk[n].desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80006378:	0001c517          	auipc	a0,0x1c
    8000637c:	c8850513          	addi	a0,a0,-888 # 80022000 <disk>
    80006380:	00191793          	slli	a5,s2,0x1
    80006384:	01278733          	add	a4,a5,s2
    80006388:	0732                	slli	a4,a4,0xc
    8000638a:	972a                	add	a4,a4,a0
    8000638c:	6609                	lui	a2,0x2
    8000638e:	9732                	add	a4,a4,a2
    80006390:	630c                	ld	a1,0(a4)
    80006392:	95b6                	add	a1,a1,a3
    80006394:	00c5d603          	lhu	a2,12(a1)
    80006398:	00166613          	ori	a2,a2,1
    8000639c:	00c59623          	sh	a2,12(a1)
  disk[n].desc[idx[1]].next = idx[2];
    800063a0:	f8842603          	lw	a2,-120(s0)
    800063a4:	630c                	ld	a1,0(a4)
    800063a6:	96ae                	add	a3,a3,a1
    800063a8:	00c69723          	sh	a2,14(a3)

  disk[n].info[idx[0]].status = 0;
    800063ac:	97ca                	add	a5,a5,s2
    800063ae:	07a2                	slli	a5,a5,0x8
    800063b0:	97a6                	add	a5,a5,s1
    800063b2:	20078793          	addi	a5,a5,512
    800063b6:	0792                	slli	a5,a5,0x4
    800063b8:	97aa                	add	a5,a5,a0
    800063ba:	02078823          	sb	zero,48(a5)
  disk[n].desc[idx[2]].addr = (uint64) &disk[n].info[idx[0]].status;
    800063be:	00461693          	slli	a3,a2,0x4
    800063c2:	00073803          	ld	a6,0(a4)
    800063c6:	9836                	add	a6,a6,a3
    800063c8:	20348613          	addi	a2,s1,515
    800063cc:	00191593          	slli	a1,s2,0x1
    800063d0:	95ca                	add	a1,a1,s2
    800063d2:	05a2                	slli	a1,a1,0x8
    800063d4:	962e                	add	a2,a2,a1
    800063d6:	0612                	slli	a2,a2,0x4
    800063d8:	962a                	add	a2,a2,a0
    800063da:	00c83023          	sd	a2,0(a6)
  disk[n].desc[idx[2]].len = 1;
    800063de:	630c                	ld	a1,0(a4)
    800063e0:	95b6                	add	a1,a1,a3
    800063e2:	4605                	li	a2,1
    800063e4:	c590                	sw	a2,8(a1)
  disk[n].desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800063e6:	630c                	ld	a1,0(a4)
    800063e8:	95b6                	add	a1,a1,a3
    800063ea:	4509                	li	a0,2
    800063ec:	00a59623          	sh	a0,12(a1)
  disk[n].desc[idx[2]].next = 0;
    800063f0:	630c                	ld	a1,0(a4)
    800063f2:	96ae                	add	a3,a3,a1
    800063f4:	00069723          	sh	zero,14(a3)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800063f8:	00c9a223          	sw	a2,4(s3)
  disk[n].info[idx[0]].b = b;
    800063fc:	0337b423          	sd	s3,40(a5)

  // avail[0] is flags
  // avail[1] tells the device how far to look in avail[2...].
  // avail[2...] are desc[] indices the device should process.
  // we only tell device the first index in our chain of descriptors.
  disk[n].avail[2 + (disk[n].avail[1] % NUM)] = idx[0];
    80006400:	6714                	ld	a3,8(a4)
    80006402:	0026d783          	lhu	a5,2(a3)
    80006406:	8b9d                	andi	a5,a5,7
    80006408:	2789                	addiw	a5,a5,2
    8000640a:	0786                	slli	a5,a5,0x1
    8000640c:	97b6                	add	a5,a5,a3
    8000640e:	00979023          	sh	s1,0(a5)
  __sync_synchronize();
    80006412:	0ff0000f          	fence
  disk[n].avail[1] = disk[n].avail[1] + 1;
    80006416:	6718                	ld	a4,8(a4)
    80006418:	00275783          	lhu	a5,2(a4)
    8000641c:	2785                	addiw	a5,a5,1
    8000641e:	00f71123          	sh	a5,2(a4)

  *R(n, VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80006422:	0019079b          	addiw	a5,s2,1
    80006426:	00c7979b          	slliw	a5,a5,0xc
    8000642a:	10000737          	lui	a4,0x10000
    8000642e:	05070713          	addi	a4,a4,80 # 10000050 <_entry-0x6fffffb0>
    80006432:	97ba                	add	a5,a5,a4
    80006434:	0007a023          	sw	zero,0(a5)

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80006438:	0049a783          	lw	a5,4(s3)
    8000643c:	00c79d63          	bne	a5,a2,80006456 <virtio_disk_rw+0x1fc>
    80006440:	4485                	li	s1,1
    sleep(b, &disk[n].vdisk_lock);
    80006442:	85d2                	mv	a1,s4
    80006444:	854e                	mv	a0,s3
    80006446:	ffffc097          	auipc	ra,0xffffc
    8000644a:	eac080e7          	jalr	-340(ra) # 800022f2 <sleep>
  while(b->disk == 1) {
    8000644e:	0049a783          	lw	a5,4(s3)
    80006452:	fe9788e3          	beq	a5,s1,80006442 <virtio_disk_rw+0x1e8>
  }

  disk[n].info[idx[0]].b = 0;
    80006456:	f8042483          	lw	s1,-128(s0)
    8000645a:	00191793          	slli	a5,s2,0x1
    8000645e:	97ca                	add	a5,a5,s2
    80006460:	07a2                	slli	a5,a5,0x8
    80006462:	97a6                	add	a5,a5,s1
    80006464:	20078793          	addi	a5,a5,512
    80006468:	0792                	slli	a5,a5,0x4
    8000646a:	0001c717          	auipc	a4,0x1c
    8000646e:	b9670713          	addi	a4,a4,-1130 # 80022000 <disk>
    80006472:	97ba                	add	a5,a5,a4
    80006474:	0207b423          	sd	zero,40(a5)
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006478:	00191793          	slli	a5,s2,0x1
    8000647c:	97ca                	add	a5,a5,s2
    8000647e:	07b2                	slli	a5,a5,0xc
    80006480:	97ba                	add	a5,a5,a4
    80006482:	6989                	lui	s3,0x2
    80006484:	99be                	add	s3,s3,a5
    free_desc(n, i);
    80006486:	85a6                	mv	a1,s1
    80006488:	854a                	mv	a0,s2
    8000648a:	00000097          	auipc	ra,0x0
    8000648e:	b4c080e7          	jalr	-1204(ra) # 80005fd6 <free_desc>
    if(disk[n].desc[i].flags & VRING_DESC_F_NEXT)
    80006492:	0492                	slli	s1,s1,0x4
    80006494:	0009b783          	ld	a5,0(s3) # 2000 <_entry-0x7fffe000>
    80006498:	94be                	add	s1,s1,a5
    8000649a:	00c4d783          	lhu	a5,12(s1)
    8000649e:	8b85                	andi	a5,a5,1
    800064a0:	c781                	beqz	a5,800064a8 <virtio_disk_rw+0x24e>
      i = disk[n].desc[i].next;
    800064a2:	00e4d483          	lhu	s1,14(s1)
    free_desc(n, i);
    800064a6:	b7c5                	j	80006486 <virtio_disk_rw+0x22c>
  free_chain(n, idx[0]);

  release(&disk[n].vdisk_lock);
    800064a8:	8552                	mv	a0,s4
    800064aa:	ffffa097          	auipc	ra,0xffffa
    800064ae:	6d6080e7          	jalr	1750(ra) # 80000b80 <release>
}
    800064b2:	60ea                	ld	ra,152(sp)
    800064b4:	644a                	ld	s0,144(sp)
    800064b6:	64aa                	ld	s1,136(sp)
    800064b8:	690a                	ld	s2,128(sp)
    800064ba:	79e6                	ld	s3,120(sp)
    800064bc:	7a46                	ld	s4,112(sp)
    800064be:	7aa6                	ld	s5,104(sp)
    800064c0:	7b06                	ld	s6,96(sp)
    800064c2:	6be6                	ld	s7,88(sp)
    800064c4:	6c46                	ld	s8,80(sp)
    800064c6:	6ca6                	ld	s9,72(sp)
    800064c8:	6d06                	ld	s10,64(sp)
    800064ca:	7de2                	ld	s11,56(sp)
    800064cc:	610d                	addi	sp,sp,160
    800064ce:	8082                	ret
  if(write)
    800064d0:	01b037b3          	snez	a5,s11
    800064d4:	f6f42823          	sw	a5,-144(s0)
  buf0.reserved = 0;
    800064d8:	f6042a23          	sw	zero,-140(s0)
  buf0.sector = sector;
    800064dc:	f6843783          	ld	a5,-152(s0)
    800064e0:	f6f43c23          	sd	a5,-136(s0)
  disk[n].desc[idx[0]].addr = (uint64) kvmpa((uint64) &buf0);
    800064e4:	f8042483          	lw	s1,-128(s0)
    800064e8:	00449b13          	slli	s6,s1,0x4
    800064ec:	00191793          	slli	a5,s2,0x1
    800064f0:	97ca                	add	a5,a5,s2
    800064f2:	07b2                	slli	a5,a5,0xc
    800064f4:	0001ca97          	auipc	s5,0x1c
    800064f8:	b0ca8a93          	addi	s5,s5,-1268 # 80022000 <disk>
    800064fc:	97d6                	add	a5,a5,s5
    800064fe:	6a89                	lui	s5,0x2
    80006500:	9abe                	add	s5,s5,a5
    80006502:	000abb83          	ld	s7,0(s5) # 2000 <_entry-0x7fffe000>
    80006506:	9bda                	add	s7,s7,s6
    80006508:	f7040513          	addi	a0,s0,-144
    8000650c:	ffffb097          	auipc	ra,0xffffb
    80006510:	cb2080e7          	jalr	-846(ra) # 800011be <kvmpa>
    80006514:	00abb023          	sd	a0,0(s7)
  disk[n].desc[idx[0]].len = sizeof(buf0);
    80006518:	000ab783          	ld	a5,0(s5)
    8000651c:	97da                	add	a5,a5,s6
    8000651e:	4741                	li	a4,16
    80006520:	c798                	sw	a4,8(a5)
  disk[n].desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80006522:	000ab783          	ld	a5,0(s5)
    80006526:	97da                	add	a5,a5,s6
    80006528:	4705                	li	a4,1
    8000652a:	00e79623          	sh	a4,12(a5)
  disk[n].desc[idx[0]].next = idx[1];
    8000652e:	f8442683          	lw	a3,-124(s0)
    80006532:	000ab783          	ld	a5,0(s5)
    80006536:	9b3e                	add	s6,s6,a5
    80006538:	00db1723          	sh	a3,14(s6)
  disk[n].desc[idx[1]].addr = (uint64) b->data;
    8000653c:	0692                	slli	a3,a3,0x4
    8000653e:	000ab783          	ld	a5,0(s5)
    80006542:	97b6                	add	a5,a5,a3
    80006544:	06098713          	addi	a4,s3,96
    80006548:	e398                	sd	a4,0(a5)
  disk[n].desc[idx[1]].len = BSIZE;
    8000654a:	000ab783          	ld	a5,0(s5)
    8000654e:	97b6                	add	a5,a5,a3
    80006550:	40000713          	li	a4,1024
    80006554:	c798                	sw	a4,8(a5)
  if(write)
    80006556:	e00d92e3          	bnez	s11,8000635a <virtio_disk_rw+0x100>
    disk[n].desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000655a:	00191793          	slli	a5,s2,0x1
    8000655e:	97ca                	add	a5,a5,s2
    80006560:	07b2                	slli	a5,a5,0xc
    80006562:	0001c717          	auipc	a4,0x1c
    80006566:	a9e70713          	addi	a4,a4,-1378 # 80022000 <disk>
    8000656a:	973e                	add	a4,a4,a5
    8000656c:	6789                	lui	a5,0x2
    8000656e:	97ba                	add	a5,a5,a4
    80006570:	639c                	ld	a5,0(a5)
    80006572:	97b6                	add	a5,a5,a3
    80006574:	4709                	li	a4,2
    80006576:	00e79623          	sh	a4,12(a5) # 200c <_entry-0x7fffdff4>
    8000657a:	bbfd                	j	80006378 <virtio_disk_rw+0x11e>

000000008000657c <virtio_disk_intr>:

void
virtio_disk_intr(int n)
{
    8000657c:	7139                	addi	sp,sp,-64
    8000657e:	fc06                	sd	ra,56(sp)
    80006580:	f822                	sd	s0,48(sp)
    80006582:	f426                	sd	s1,40(sp)
    80006584:	f04a                	sd	s2,32(sp)
    80006586:	ec4e                	sd	s3,24(sp)
    80006588:	e852                	sd	s4,16(sp)
    8000658a:	e456                	sd	s5,8(sp)
    8000658c:	0080                	addi	s0,sp,64
    8000658e:	84aa                	mv	s1,a0
  acquire(&disk[n].vdisk_lock);
    80006590:	00151913          	slli	s2,a0,0x1
    80006594:	00a90a33          	add	s4,s2,a0
    80006598:	0a32                	slli	s4,s4,0xc
    8000659a:	6989                	lui	s3,0x2
    8000659c:	0b098793          	addi	a5,s3,176 # 20b0 <_entry-0x7fffdf50>
    800065a0:	9a3e                	add	s4,s4,a5
    800065a2:	0001ca97          	auipc	s5,0x1c
    800065a6:	a5ea8a93          	addi	s5,s5,-1442 # 80022000 <disk>
    800065aa:	9a56                	add	s4,s4,s5
    800065ac:	8552                	mv	a0,s4
    800065ae:	ffffa097          	auipc	ra,0xffffa
    800065b2:	502080e7          	jalr	1282(ra) # 80000ab0 <acquire>

  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    800065b6:	9926                	add	s2,s2,s1
    800065b8:	0932                	slli	s2,s2,0xc
    800065ba:	9956                	add	s2,s2,s5
    800065bc:	99ca                	add	s3,s3,s2
    800065be:	0209d783          	lhu	a5,32(s3)
    800065c2:	0109b703          	ld	a4,16(s3)
    800065c6:	00275683          	lhu	a3,2(a4)
    800065ca:	8ebd                	xor	a3,a3,a5
    800065cc:	8a9d                	andi	a3,a3,7
    800065ce:	c2a5                	beqz	a3,8000662e <virtio_disk_intr+0xb2>
    int id = disk[n].used->elems[disk[n].used_idx].id;

    if(disk[n].info[id].status != 0)
    800065d0:	8956                	mv	s2,s5
    800065d2:	00149693          	slli	a3,s1,0x1
    800065d6:	96a6                	add	a3,a3,s1
    800065d8:	00869993          	slli	s3,a3,0x8
      panic("virtio_disk_intr status");
    
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    wakeup(disk[n].info[id].b);

    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    800065dc:	06b2                	slli	a3,a3,0xc
    800065de:	96d6                	add	a3,a3,s5
    800065e0:	6489                	lui	s1,0x2
    800065e2:	94b6                	add	s1,s1,a3
    int id = disk[n].used->elems[disk[n].used_idx].id;
    800065e4:	078e                	slli	a5,a5,0x3
    800065e6:	97ba                	add	a5,a5,a4
    800065e8:	43dc                	lw	a5,4(a5)
    if(disk[n].info[id].status != 0)
    800065ea:	00f98733          	add	a4,s3,a5
    800065ee:	20070713          	addi	a4,a4,512
    800065f2:	0712                	slli	a4,a4,0x4
    800065f4:	974a                	add	a4,a4,s2
    800065f6:	03074703          	lbu	a4,48(a4)
    800065fa:	eb21                	bnez	a4,8000664a <virtio_disk_intr+0xce>
    disk[n].info[id].b->disk = 0;   // disk is done with buf
    800065fc:	97ce                	add	a5,a5,s3
    800065fe:	20078793          	addi	a5,a5,512
    80006602:	0792                	slli	a5,a5,0x4
    80006604:	97ca                	add	a5,a5,s2
    80006606:	7798                	ld	a4,40(a5)
    80006608:	00072223          	sw	zero,4(a4)
    wakeup(disk[n].info[id].b);
    8000660c:	7788                	ld	a0,40(a5)
    8000660e:	ffffc097          	auipc	ra,0xffffc
    80006612:	e6a080e7          	jalr	-406(ra) # 80002478 <wakeup>
    disk[n].used_idx = (disk[n].used_idx + 1) % NUM;
    80006616:	0204d783          	lhu	a5,32(s1) # 2020 <_entry-0x7fffdfe0>
    8000661a:	2785                	addiw	a5,a5,1
    8000661c:	8b9d                	andi	a5,a5,7
    8000661e:	02f49023          	sh	a5,32(s1)
  while((disk[n].used_idx % NUM) != (disk[n].used->id % NUM)){
    80006622:	6898                	ld	a4,16(s1)
    80006624:	00275683          	lhu	a3,2(a4)
    80006628:	8a9d                	andi	a3,a3,7
    8000662a:	faf69de3          	bne	a3,a5,800065e4 <virtio_disk_intr+0x68>
  }

  release(&disk[n].vdisk_lock);
    8000662e:	8552                	mv	a0,s4
    80006630:	ffffa097          	auipc	ra,0xffffa
    80006634:	550080e7          	jalr	1360(ra) # 80000b80 <release>
}
    80006638:	70e2                	ld	ra,56(sp)
    8000663a:	7442                	ld	s0,48(sp)
    8000663c:	74a2                	ld	s1,40(sp)
    8000663e:	7902                	ld	s2,32(sp)
    80006640:	69e2                	ld	s3,24(sp)
    80006642:	6a42                	ld	s4,16(sp)
    80006644:	6aa2                	ld	s5,8(sp)
    80006646:	6121                	addi	sp,sp,64
    80006648:	8082                	ret
      panic("virtio_disk_intr status");
    8000664a:	00002517          	auipc	a0,0x2
    8000664e:	54e50513          	addi	a0,a0,1358 # 80008b98 <userret+0xb08>
    80006652:	ffffa097          	auipc	ra,0xffffa
    80006656:	f08080e7          	jalr	-248(ra) # 8000055a <panic>

000000008000665a <bit_isset>:
static Sz_info *bd_sizes; 
static void *bd_base;   // start address of memory managed by the buddy allocator
static struct spinlock lock;

// Return 1 if bit at position index in array is set to 1
int bit_isset(char *array, int index) {
    8000665a:	1141                	addi	sp,sp,-16
    8000665c:	e422                	sd	s0,8(sp)
    8000665e:	0800                	addi	s0,sp,16
  char b = array[index/8];
  char m = (1 << (index % 8));
    80006660:	41f5d79b          	sraiw	a5,a1,0x1f
    80006664:	01d7d79b          	srliw	a5,a5,0x1d
    80006668:	9dbd                	addw	a1,a1,a5
    8000666a:	0075f713          	andi	a4,a1,7
    8000666e:	9f1d                	subw	a4,a4,a5
    80006670:	4785                	li	a5,1
    80006672:	00e797bb          	sllw	a5,a5,a4
    80006676:	0ff7f793          	andi	a5,a5,255
  char b = array[index/8];
    8000667a:	4035d59b          	sraiw	a1,a1,0x3
    8000667e:	95aa                	add	a1,a1,a0
  return (b & m) == m;
    80006680:	0005c503          	lbu	a0,0(a1)
    80006684:	8d7d                	and	a0,a0,a5
    80006686:	8d1d                	sub	a0,a0,a5
}
    80006688:	00153513          	seqz	a0,a0
    8000668c:	6422                	ld	s0,8(sp)
    8000668e:	0141                	addi	sp,sp,16
    80006690:	8082                	ret

0000000080006692 <bit_set>:

// Set bit at position index in array to 1
void bit_set(char *array, int index) {
    80006692:	1141                	addi	sp,sp,-16
    80006694:	e422                	sd	s0,8(sp)
    80006696:	0800                	addi	s0,sp,16
  char b = array[index/8];
    80006698:	41f5d79b          	sraiw	a5,a1,0x1f
    8000669c:	01d7d79b          	srliw	a5,a5,0x1d
    800066a0:	9dbd                	addw	a1,a1,a5
    800066a2:	4035d71b          	sraiw	a4,a1,0x3
    800066a6:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    800066a8:	899d                	andi	a1,a1,7
    800066aa:	9d9d                	subw	a1,a1,a5
  array[index/8] = (b | m);
    800066ac:	4785                	li	a5,1
    800066ae:	00b795bb          	sllw	a1,a5,a1
    800066b2:	00054783          	lbu	a5,0(a0)
    800066b6:	8ddd                	or	a1,a1,a5
    800066b8:	00b50023          	sb	a1,0(a0)
}
    800066bc:	6422                	ld	s0,8(sp)
    800066be:	0141                	addi	sp,sp,16
    800066c0:	8082                	ret

00000000800066c2 <bit_clear>:

// Clear bit at position index in array
void bit_clear(char *array, int index) {
    800066c2:	1141                	addi	sp,sp,-16
    800066c4:	e422                	sd	s0,8(sp)
    800066c6:	0800                	addi	s0,sp,16
  char b = array[index/8];
    800066c8:	41f5d79b          	sraiw	a5,a1,0x1f
    800066cc:	01d7d79b          	srliw	a5,a5,0x1d
    800066d0:	9dbd                	addw	a1,a1,a5
    800066d2:	4035d71b          	sraiw	a4,a1,0x3
    800066d6:	953a                	add	a0,a0,a4
  char m = (1 << (index % 8));
    800066d8:	899d                	andi	a1,a1,7
    800066da:	9d9d                	subw	a1,a1,a5
  array[index/8] = (b & ~m);
    800066dc:	4785                	li	a5,1
    800066de:	00b795bb          	sllw	a1,a5,a1
    800066e2:	fff5c593          	not	a1,a1
    800066e6:	00054783          	lbu	a5,0(a0)
    800066ea:	8dfd                	and	a1,a1,a5
    800066ec:	00b50023          	sb	a1,0(a0)
}
    800066f0:	6422                	ld	s0,8(sp)
    800066f2:	0141                	addi	sp,sp,16
    800066f4:	8082                	ret

00000000800066f6 <bd_print_vector>:

// Print a bit vector as a list of ranges of 1 bits
void
bd_print_vector(char *vector, int len) {
    800066f6:	715d                	addi	sp,sp,-80
    800066f8:	e486                	sd	ra,72(sp)
    800066fa:	e0a2                	sd	s0,64(sp)
    800066fc:	fc26                	sd	s1,56(sp)
    800066fe:	f84a                	sd	s2,48(sp)
    80006700:	f44e                	sd	s3,40(sp)
    80006702:	f052                	sd	s4,32(sp)
    80006704:	ec56                	sd	s5,24(sp)
    80006706:	e85a                	sd	s6,16(sp)
    80006708:	e45e                	sd	s7,8(sp)
    8000670a:	0880                	addi	s0,sp,80
    8000670c:	8a2e                	mv	s4,a1
  int last, lb;
  
  last = 1;
  lb = 0;
  for (int b = 0; b < len; b++) {
    8000670e:	08b05b63          	blez	a1,800067a4 <bd_print_vector+0xae>
    80006712:	89aa                	mv	s3,a0
    80006714:	4481                	li	s1,0
  lb = 0;
    80006716:	4a81                	li	s5,0
  last = 1;
    80006718:	4905                	li	s2,1
    if (last == bit_isset(vector, b))
      continue;
    if(last == 1)
    8000671a:	4b05                	li	s6,1
      printf(" [%d, %d)", lb, b);
    8000671c:	00002b97          	auipc	s7,0x2
    80006720:	494b8b93          	addi	s7,s7,1172 # 80008bb0 <userret+0xb20>
    80006724:	a01d                	j	8000674a <bd_print_vector+0x54>
    80006726:	8626                	mv	a2,s1
    80006728:	85d6                	mv	a1,s5
    8000672a:	855e                	mv	a0,s7
    8000672c:	ffffa097          	auipc	ra,0xffffa
    80006730:	e88080e7          	jalr	-376(ra) # 800005b4 <printf>
    lb = b;
    last = bit_isset(vector, b);
    80006734:	85a6                	mv	a1,s1
    80006736:	854e                	mv	a0,s3
    80006738:	00000097          	auipc	ra,0x0
    8000673c:	f22080e7          	jalr	-222(ra) # 8000665a <bit_isset>
    80006740:	892a                	mv	s2,a0
    80006742:	8aa6                	mv	s5,s1
  for (int b = 0; b < len; b++) {
    80006744:	2485                	addiw	s1,s1,1
    80006746:	009a0d63          	beq	s4,s1,80006760 <bd_print_vector+0x6a>
    if (last == bit_isset(vector, b))
    8000674a:	85a6                	mv	a1,s1
    8000674c:	854e                	mv	a0,s3
    8000674e:	00000097          	auipc	ra,0x0
    80006752:	f0c080e7          	jalr	-244(ra) # 8000665a <bit_isset>
    80006756:	ff2507e3          	beq	a0,s2,80006744 <bd_print_vector+0x4e>
    if(last == 1)
    8000675a:	fd691de3          	bne	s2,s6,80006734 <bd_print_vector+0x3e>
    8000675e:	b7e1                	j	80006726 <bd_print_vector+0x30>
  }
  if(lb == 0 || last == 1) {
    80006760:	000a8563          	beqz	s5,8000676a <bd_print_vector+0x74>
    80006764:	4785                	li	a5,1
    80006766:	00f91c63          	bne	s2,a5,8000677e <bd_print_vector+0x88>
    printf(" [%d, %d)", lb, len);
    8000676a:	8652                	mv	a2,s4
    8000676c:	85d6                	mv	a1,s5
    8000676e:	00002517          	auipc	a0,0x2
    80006772:	44250513          	addi	a0,a0,1090 # 80008bb0 <userret+0xb20>
    80006776:	ffffa097          	auipc	ra,0xffffa
    8000677a:	e3e080e7          	jalr	-450(ra) # 800005b4 <printf>
  }
  printf("\n");
    8000677e:	00002517          	auipc	a0,0x2
    80006782:	b1250513          	addi	a0,a0,-1262 # 80008290 <userret+0x200>
    80006786:	ffffa097          	auipc	ra,0xffffa
    8000678a:	e2e080e7          	jalr	-466(ra) # 800005b4 <printf>
}
    8000678e:	60a6                	ld	ra,72(sp)
    80006790:	6406                	ld	s0,64(sp)
    80006792:	74e2                	ld	s1,56(sp)
    80006794:	7942                	ld	s2,48(sp)
    80006796:	79a2                	ld	s3,40(sp)
    80006798:	7a02                	ld	s4,32(sp)
    8000679a:	6ae2                	ld	s5,24(sp)
    8000679c:	6b42                	ld	s6,16(sp)
    8000679e:	6ba2                	ld	s7,8(sp)
    800067a0:	6161                	addi	sp,sp,80
    800067a2:	8082                	ret
  lb = 0;
    800067a4:	4a81                	li	s5,0
    800067a6:	b7d1                	j	8000676a <bd_print_vector+0x74>

00000000800067a8 <bd_print>:

// Print buddy's data structures
void
bd_print() {
  for (int k = 0; k < nsizes; k++) {
    800067a8:	00022697          	auipc	a3,0x22
    800067ac:	8b06a683          	lw	a3,-1872(a3) # 80028058 <nsizes>
    800067b0:	10d05063          	blez	a3,800068b0 <bd_print+0x108>
bd_print() {
    800067b4:	711d                	addi	sp,sp,-96
    800067b6:	ec86                	sd	ra,88(sp)
    800067b8:	e8a2                	sd	s0,80(sp)
    800067ba:	e4a6                	sd	s1,72(sp)
    800067bc:	e0ca                	sd	s2,64(sp)
    800067be:	fc4e                	sd	s3,56(sp)
    800067c0:	f852                	sd	s4,48(sp)
    800067c2:	f456                	sd	s5,40(sp)
    800067c4:	f05a                	sd	s6,32(sp)
    800067c6:	ec5e                	sd	s7,24(sp)
    800067c8:	e862                	sd	s8,16(sp)
    800067ca:	e466                	sd	s9,8(sp)
    800067cc:	e06a                	sd	s10,0(sp)
    800067ce:	1080                	addi	s0,sp,96
  for (int k = 0; k < nsizes; k++) {
    800067d0:	4481                	li	s1,0
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    800067d2:	4a85                	li	s5,1
    800067d4:	4c41                	li	s8,16
    800067d6:	00002b97          	auipc	s7,0x2
    800067da:	3eab8b93          	addi	s7,s7,1002 # 80008bc0 <userret+0xb30>
    lst_print(&bd_sizes[k].free);
    800067de:	00022a17          	auipc	s4,0x22
    800067e2:	872a0a13          	addi	s4,s4,-1934 # 80028050 <bd_sizes>
    printf("  alloc:");
    800067e6:	00002b17          	auipc	s6,0x2
    800067ea:	402b0b13          	addi	s6,s6,1026 # 80008be8 <userret+0xb58>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    800067ee:	00022997          	auipc	s3,0x22
    800067f2:	86a98993          	addi	s3,s3,-1942 # 80028058 <nsizes>
    if(k > 0) {
      printf("  split:");
    800067f6:	00002c97          	auipc	s9,0x2
    800067fa:	402c8c93          	addi	s9,s9,1026 # 80008bf8 <userret+0xb68>
    800067fe:	a801                	j	8000680e <bd_print+0x66>
  for (int k = 0; k < nsizes; k++) {
    80006800:	0009a683          	lw	a3,0(s3)
    80006804:	0485                	addi	s1,s1,1
    80006806:	0004879b          	sext.w	a5,s1
    8000680a:	08d7d563          	bge	a5,a3,80006894 <bd_print+0xec>
    8000680e:	0004891b          	sext.w	s2,s1
    printf("size %d (blksz %d nblk %d): free list: ", k, BLK_SIZE(k), NBLK(k));
    80006812:	36fd                	addiw	a3,a3,-1
    80006814:	9e85                	subw	a3,a3,s1
    80006816:	00da96bb          	sllw	a3,s5,a3
    8000681a:	009c1633          	sll	a2,s8,s1
    8000681e:	85ca                	mv	a1,s2
    80006820:	855e                	mv	a0,s7
    80006822:	ffffa097          	auipc	ra,0xffffa
    80006826:	d92080e7          	jalr	-622(ra) # 800005b4 <printf>
    lst_print(&bd_sizes[k].free);
    8000682a:	00549d13          	slli	s10,s1,0x5
    8000682e:	000a3503          	ld	a0,0(s4)
    80006832:	956a                	add	a0,a0,s10
    80006834:	00001097          	auipc	ra,0x1
    80006838:	a4e080e7          	jalr	-1458(ra) # 80007282 <lst_print>
    printf("  alloc:");
    8000683c:	855a                	mv	a0,s6
    8000683e:	ffffa097          	auipc	ra,0xffffa
    80006842:	d76080e7          	jalr	-650(ra) # 800005b4 <printf>
    bd_print_vector(bd_sizes[k].alloc, NBLK(k));
    80006846:	0009a583          	lw	a1,0(s3)
    8000684a:	35fd                	addiw	a1,a1,-1
    8000684c:	412585bb          	subw	a1,a1,s2
    80006850:	000a3783          	ld	a5,0(s4)
    80006854:	97ea                	add	a5,a5,s10
    80006856:	00ba95bb          	sllw	a1,s5,a1
    8000685a:	6b88                	ld	a0,16(a5)
    8000685c:	00000097          	auipc	ra,0x0
    80006860:	e9a080e7          	jalr	-358(ra) # 800066f6 <bd_print_vector>
    if(k > 0) {
    80006864:	f9205ee3          	blez	s2,80006800 <bd_print+0x58>
      printf("  split:");
    80006868:	8566                	mv	a0,s9
    8000686a:	ffffa097          	auipc	ra,0xffffa
    8000686e:	d4a080e7          	jalr	-694(ra) # 800005b4 <printf>
      bd_print_vector(bd_sizes[k].split, NBLK(k));
    80006872:	0009a583          	lw	a1,0(s3)
    80006876:	35fd                	addiw	a1,a1,-1
    80006878:	412585bb          	subw	a1,a1,s2
    8000687c:	000a3783          	ld	a5,0(s4)
    80006880:	9d3e                	add	s10,s10,a5
    80006882:	00ba95bb          	sllw	a1,s5,a1
    80006886:	018d3503          	ld	a0,24(s10)
    8000688a:	00000097          	auipc	ra,0x0
    8000688e:	e6c080e7          	jalr	-404(ra) # 800066f6 <bd_print_vector>
    80006892:	b7bd                	j	80006800 <bd_print+0x58>
    }
  }
}
    80006894:	60e6                	ld	ra,88(sp)
    80006896:	6446                	ld	s0,80(sp)
    80006898:	64a6                	ld	s1,72(sp)
    8000689a:	6906                	ld	s2,64(sp)
    8000689c:	79e2                	ld	s3,56(sp)
    8000689e:	7a42                	ld	s4,48(sp)
    800068a0:	7aa2                	ld	s5,40(sp)
    800068a2:	7b02                	ld	s6,32(sp)
    800068a4:	6be2                	ld	s7,24(sp)
    800068a6:	6c42                	ld	s8,16(sp)
    800068a8:	6ca2                	ld	s9,8(sp)
    800068aa:	6d02                	ld	s10,0(sp)
    800068ac:	6125                	addi	sp,sp,96
    800068ae:	8082                	ret
    800068b0:	8082                	ret

00000000800068b2 <firstk>:

// What is the first k such that 2^k >= n?
int
firstk(uint64 n) {
    800068b2:	1141                	addi	sp,sp,-16
    800068b4:	e422                	sd	s0,8(sp)
    800068b6:	0800                	addi	s0,sp,16
  int k = 0;
  uint64 size = LEAF_SIZE;

  while (size < n) {
    800068b8:	47c1                	li	a5,16
    800068ba:	00a7fb63          	bgeu	a5,a0,800068d0 <firstk+0x1e>
    800068be:	872a                	mv	a4,a0
  int k = 0;
    800068c0:	4501                	li	a0,0
    k++;
    800068c2:	2505                	addiw	a0,a0,1
    size *= 2;
    800068c4:	0786                	slli	a5,a5,0x1
  while (size < n) {
    800068c6:	fee7eee3          	bltu	a5,a4,800068c2 <firstk+0x10>
  }
  return k;
}
    800068ca:	6422                	ld	s0,8(sp)
    800068cc:	0141                	addi	sp,sp,16
    800068ce:	8082                	ret
  int k = 0;
    800068d0:	4501                	li	a0,0
    800068d2:	bfe5                	j	800068ca <firstk+0x18>

00000000800068d4 <blk_index>:

// Compute the block index for address p at size k
int
blk_index(int k, char *p) {
    800068d4:	1141                	addi	sp,sp,-16
    800068d6:	e422                	sd	s0,8(sp)
    800068d8:	0800                	addi	s0,sp,16
  int n = p - (char *) bd_base;
  return n / BLK_SIZE(k);
    800068da:	00021797          	auipc	a5,0x21
    800068de:	76e7b783          	ld	a5,1902(a5) # 80028048 <bd_base>
    800068e2:	9d9d                	subw	a1,a1,a5
    800068e4:	47c1                	li	a5,16
    800068e6:	00a79533          	sll	a0,a5,a0
    800068ea:	02a5c533          	div	a0,a1,a0
}
    800068ee:	2501                	sext.w	a0,a0
    800068f0:	6422                	ld	s0,8(sp)
    800068f2:	0141                	addi	sp,sp,16
    800068f4:	8082                	ret

00000000800068f6 <addr>:

// Convert a block index at size k back into an address
void *addr(int k, int bi) {
    800068f6:	1141                	addi	sp,sp,-16
    800068f8:	e422                	sd	s0,8(sp)
    800068fa:	0800                	addi	s0,sp,16
  int n = bi * BLK_SIZE(k);
    800068fc:	47c1                	li	a5,16
    800068fe:	00a797b3          	sll	a5,a5,a0
  return (char *) bd_base + n;
    80006902:	02b787bb          	mulw	a5,a5,a1
}
    80006906:	00021517          	auipc	a0,0x21
    8000690a:	74253503          	ld	a0,1858(a0) # 80028048 <bd_base>
    8000690e:	953e                	add	a0,a0,a5
    80006910:	6422                	ld	s0,8(sp)
    80006912:	0141                	addi	sp,sp,16
    80006914:	8082                	ret

0000000080006916 <bd_malloc>:

// allocate nbytes, but malloc won't return anything smaller than LEAF_SIZE
void *
bd_malloc(uint64 nbytes)
{
    80006916:	7159                	addi	sp,sp,-112
    80006918:	f486                	sd	ra,104(sp)
    8000691a:	f0a2                	sd	s0,96(sp)
    8000691c:	eca6                	sd	s1,88(sp)
    8000691e:	e8ca                	sd	s2,80(sp)
    80006920:	e4ce                	sd	s3,72(sp)
    80006922:	e0d2                	sd	s4,64(sp)
    80006924:	fc56                	sd	s5,56(sp)
    80006926:	f85a                	sd	s6,48(sp)
    80006928:	f45e                	sd	s7,40(sp)
    8000692a:	f062                	sd	s8,32(sp)
    8000692c:	ec66                	sd	s9,24(sp)
    8000692e:	e86a                	sd	s10,16(sp)
    80006930:	e46e                	sd	s11,8(sp)
    80006932:	1880                	addi	s0,sp,112
    80006934:	84aa                	mv	s1,a0
  int fk, k;

  acquire(&lock);
    80006936:	00021517          	auipc	a0,0x21
    8000693a:	6ca50513          	addi	a0,a0,1738 # 80028000 <lock>
    8000693e:	ffffa097          	auipc	ra,0xffffa
    80006942:	172080e7          	jalr	370(ra) # 80000ab0 <acquire>

  // Find a free block >= nbytes, starting with smallest k possible
  fk = firstk(nbytes);
    80006946:	8526                	mv	a0,s1
    80006948:	00000097          	auipc	ra,0x0
    8000694c:	f6a080e7          	jalr	-150(ra) # 800068b2 <firstk>
  for (k = fk; k < nsizes; k++) {
    80006950:	00021797          	auipc	a5,0x21
    80006954:	7087a783          	lw	a5,1800(a5) # 80028058 <nsizes>
    80006958:	02f55d63          	bge	a0,a5,80006992 <bd_malloc+0x7c>
    8000695c:	8c2a                	mv	s8,a0
    8000695e:	00551913          	slli	s2,a0,0x5
    80006962:	84aa                	mv	s1,a0
    if(!lst_empty(&bd_sizes[k].free))
    80006964:	00021997          	auipc	s3,0x21
    80006968:	6ec98993          	addi	s3,s3,1772 # 80028050 <bd_sizes>
  for (k = fk; k < nsizes; k++) {
    8000696c:	00021a17          	auipc	s4,0x21
    80006970:	6eca0a13          	addi	s4,s4,1772 # 80028058 <nsizes>
    if(!lst_empty(&bd_sizes[k].free))
    80006974:	0009b503          	ld	a0,0(s3)
    80006978:	954a                	add	a0,a0,s2
    8000697a:	00001097          	auipc	ra,0x1
    8000697e:	88e080e7          	jalr	-1906(ra) # 80007208 <lst_empty>
    80006982:	c115                	beqz	a0,800069a6 <bd_malloc+0x90>
  for (k = fk; k < nsizes; k++) {
    80006984:	2485                	addiw	s1,s1,1
    80006986:	02090913          	addi	s2,s2,32
    8000698a:	000a2783          	lw	a5,0(s4)
    8000698e:	fef4c3e3          	blt	s1,a5,80006974 <bd_malloc+0x5e>
      break;
  }
  if(k >= nsizes) { // No free blocks?
    release(&lock);
    80006992:	00021517          	auipc	a0,0x21
    80006996:	66e50513          	addi	a0,a0,1646 # 80028000 <lock>
    8000699a:	ffffa097          	auipc	ra,0xffffa
    8000699e:	1e6080e7          	jalr	486(ra) # 80000b80 <release>
    return 0;
    800069a2:	4b01                	li	s6,0
    800069a4:	a0e1                	j	80006a6c <bd_malloc+0x156>
  if(k >= nsizes) { // No free blocks?
    800069a6:	00021797          	auipc	a5,0x21
    800069aa:	6b27a783          	lw	a5,1714(a5) # 80028058 <nsizes>
    800069ae:	fef4d2e3          	bge	s1,a5,80006992 <bd_malloc+0x7c>
  }

  // Found a block; pop it and potentially split it.
  char *p = lst_pop(&bd_sizes[k].free);
    800069b2:	00549993          	slli	s3,s1,0x5
    800069b6:	00021917          	auipc	s2,0x21
    800069ba:	69a90913          	addi	s2,s2,1690 # 80028050 <bd_sizes>
    800069be:	00093503          	ld	a0,0(s2)
    800069c2:	954e                	add	a0,a0,s3
    800069c4:	00001097          	auipc	ra,0x1
    800069c8:	870080e7          	jalr	-1936(ra) # 80007234 <lst_pop>
    800069cc:	8b2a                	mv	s6,a0
  return n / BLK_SIZE(k);
    800069ce:	00021597          	auipc	a1,0x21
    800069d2:	67a5b583          	ld	a1,1658(a1) # 80028048 <bd_base>
    800069d6:	40b505bb          	subw	a1,a0,a1
    800069da:	47c1                	li	a5,16
    800069dc:	009797b3          	sll	a5,a5,s1
    800069e0:	02f5c5b3          	div	a1,a1,a5
  bit_set(bd_sizes[k].alloc, blk_index(k, p));
    800069e4:	00093783          	ld	a5,0(s2)
    800069e8:	97ce                	add	a5,a5,s3
    800069ea:	2581                	sext.w	a1,a1
    800069ec:	6b88                	ld	a0,16(a5)
    800069ee:	00000097          	auipc	ra,0x0
    800069f2:	ca4080e7          	jalr	-860(ra) # 80006692 <bit_set>
  for(; k > fk; k--) {
    800069f6:	069c5363          	bge	s8,s1,80006a5c <bd_malloc+0x146>
    // split a block at size k and mark one half allocated at size k-1
    // and put the buddy on the free list at size k-1
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    800069fa:	4bc1                	li	s7,16
    bit_set(bd_sizes[k].split, blk_index(k, p));
    800069fc:	8dca                	mv	s11,s2
  int n = p - (char *) bd_base;
    800069fe:	00021d17          	auipc	s10,0x21
    80006a02:	64ad0d13          	addi	s10,s10,1610 # 80028048 <bd_base>
    char *q = p + BLK_SIZE(k-1);   // p's buddy
    80006a06:	85a6                	mv	a1,s1
    80006a08:	34fd                	addiw	s1,s1,-1
    80006a0a:	009b9ab3          	sll	s5,s7,s1
    80006a0e:	015b0cb3          	add	s9,s6,s5
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80006a12:	000dba03          	ld	s4,0(s11)
  int n = p - (char *) bd_base;
    80006a16:	000d3903          	ld	s2,0(s10)
  return n / BLK_SIZE(k);
    80006a1a:	412b093b          	subw	s2,s6,s2
    80006a1e:	00bb95b3          	sll	a1,s7,a1
    80006a22:	02b945b3          	div	a1,s2,a1
    bit_set(bd_sizes[k].split, blk_index(k, p));
    80006a26:	013a07b3          	add	a5,s4,s3
    80006a2a:	2581                	sext.w	a1,a1
    80006a2c:	6f88                	ld	a0,24(a5)
    80006a2e:	00000097          	auipc	ra,0x0
    80006a32:	c64080e7          	jalr	-924(ra) # 80006692 <bit_set>
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    80006a36:	1981                	addi	s3,s3,-32
    80006a38:	9a4e                	add	s4,s4,s3
  return n / BLK_SIZE(k);
    80006a3a:	035945b3          	div	a1,s2,s5
    bit_set(bd_sizes[k-1].alloc, blk_index(k-1, p));
    80006a3e:	2581                	sext.w	a1,a1
    80006a40:	010a3503          	ld	a0,16(s4)
    80006a44:	00000097          	auipc	ra,0x0
    80006a48:	c4e080e7          	jalr	-946(ra) # 80006692 <bit_set>
    lst_push(&bd_sizes[k-1].free, q);
    80006a4c:	85e6                	mv	a1,s9
    80006a4e:	8552                	mv	a0,s4
    80006a50:	00001097          	auipc	ra,0x1
    80006a54:	81a080e7          	jalr	-2022(ra) # 8000726a <lst_push>
  for(; k > fk; k--) {
    80006a58:	fb8497e3          	bne	s1,s8,80006a06 <bd_malloc+0xf0>
  }
  release(&lock);
    80006a5c:	00021517          	auipc	a0,0x21
    80006a60:	5a450513          	addi	a0,a0,1444 # 80028000 <lock>
    80006a64:	ffffa097          	auipc	ra,0xffffa
    80006a68:	11c080e7          	jalr	284(ra) # 80000b80 <release>

  return p;
}
    80006a6c:	855a                	mv	a0,s6
    80006a6e:	70a6                	ld	ra,104(sp)
    80006a70:	7406                	ld	s0,96(sp)
    80006a72:	64e6                	ld	s1,88(sp)
    80006a74:	6946                	ld	s2,80(sp)
    80006a76:	69a6                	ld	s3,72(sp)
    80006a78:	6a06                	ld	s4,64(sp)
    80006a7a:	7ae2                	ld	s5,56(sp)
    80006a7c:	7b42                	ld	s6,48(sp)
    80006a7e:	7ba2                	ld	s7,40(sp)
    80006a80:	7c02                	ld	s8,32(sp)
    80006a82:	6ce2                	ld	s9,24(sp)
    80006a84:	6d42                	ld	s10,16(sp)
    80006a86:	6da2                	ld	s11,8(sp)
    80006a88:	6165                	addi	sp,sp,112
    80006a8a:	8082                	ret

0000000080006a8c <size>:

// Find the size of the block that p points to.
int
size(char *p) {
    80006a8c:	7139                	addi	sp,sp,-64
    80006a8e:	fc06                	sd	ra,56(sp)
    80006a90:	f822                	sd	s0,48(sp)
    80006a92:	f426                	sd	s1,40(sp)
    80006a94:	f04a                	sd	s2,32(sp)
    80006a96:	ec4e                	sd	s3,24(sp)
    80006a98:	e852                	sd	s4,16(sp)
    80006a9a:	e456                	sd	s5,8(sp)
    80006a9c:	e05a                	sd	s6,0(sp)
    80006a9e:	0080                	addi	s0,sp,64
  for (int k = 0; k < nsizes; k++) {
    80006aa0:	00021a97          	auipc	s5,0x21
    80006aa4:	5b8aaa83          	lw	s5,1464(s5) # 80028058 <nsizes>
  return n / BLK_SIZE(k);
    80006aa8:	00021a17          	auipc	s4,0x21
    80006aac:	5a0a3a03          	ld	s4,1440(s4) # 80028048 <bd_base>
    80006ab0:	41450a3b          	subw	s4,a0,s4
    80006ab4:	00021497          	auipc	s1,0x21
    80006ab8:	59c4b483          	ld	s1,1436(s1) # 80028050 <bd_sizes>
    80006abc:	03848493          	addi	s1,s1,56
  for (int k = 0; k < nsizes; k++) {
    80006ac0:	4901                	li	s2,0
  return n / BLK_SIZE(k);
    80006ac2:	4b41                	li	s6,16
  for (int k = 0; k < nsizes; k++) {
    80006ac4:	03595363          	bge	s2,s5,80006aea <size+0x5e>
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006ac8:	0019099b          	addiw	s3,s2,1
  return n / BLK_SIZE(k);
    80006acc:	013b15b3          	sll	a1,s6,s3
    80006ad0:	02ba45b3          	div	a1,s4,a1
    if(bit_isset(bd_sizes[k+1].split, blk_index(k+1, p))) {
    80006ad4:	2581                	sext.w	a1,a1
    80006ad6:	6088                	ld	a0,0(s1)
    80006ad8:	00000097          	auipc	ra,0x0
    80006adc:	b82080e7          	jalr	-1150(ra) # 8000665a <bit_isset>
    80006ae0:	02048493          	addi	s1,s1,32
    80006ae4:	e501                	bnez	a0,80006aec <size+0x60>
  for (int k = 0; k < nsizes; k++) {
    80006ae6:	894e                	mv	s2,s3
    80006ae8:	bff1                	j	80006ac4 <size+0x38>
      return k;
    }
  }
  return 0;
    80006aea:	4901                	li	s2,0
}
    80006aec:	854a                	mv	a0,s2
    80006aee:	70e2                	ld	ra,56(sp)
    80006af0:	7442                	ld	s0,48(sp)
    80006af2:	74a2                	ld	s1,40(sp)
    80006af4:	7902                	ld	s2,32(sp)
    80006af6:	69e2                	ld	s3,24(sp)
    80006af8:	6a42                	ld	s4,16(sp)
    80006afa:	6aa2                	ld	s5,8(sp)
    80006afc:	6b02                	ld	s6,0(sp)
    80006afe:	6121                	addi	sp,sp,64
    80006b00:	8082                	ret

0000000080006b02 <bd_free>:

// Free memory pointed to by p, which was earlier allocated using
// bd_malloc.
void
bd_free(void *p) {
    80006b02:	7159                	addi	sp,sp,-112
    80006b04:	f486                	sd	ra,104(sp)
    80006b06:	f0a2                	sd	s0,96(sp)
    80006b08:	eca6                	sd	s1,88(sp)
    80006b0a:	e8ca                	sd	s2,80(sp)
    80006b0c:	e4ce                	sd	s3,72(sp)
    80006b0e:	e0d2                	sd	s4,64(sp)
    80006b10:	fc56                	sd	s5,56(sp)
    80006b12:	f85a                	sd	s6,48(sp)
    80006b14:	f45e                	sd	s7,40(sp)
    80006b16:	f062                	sd	s8,32(sp)
    80006b18:	ec66                	sd	s9,24(sp)
    80006b1a:	e86a                	sd	s10,16(sp)
    80006b1c:	e46e                	sd	s11,8(sp)
    80006b1e:	1880                	addi	s0,sp,112
    80006b20:	8aaa                	mv	s5,a0
  void *q;
  int k;

  acquire(&lock);
    80006b22:	00021517          	auipc	a0,0x21
    80006b26:	4de50513          	addi	a0,a0,1246 # 80028000 <lock>
    80006b2a:	ffffa097          	auipc	ra,0xffffa
    80006b2e:	f86080e7          	jalr	-122(ra) # 80000ab0 <acquire>
  for (k = size(p); k < MAXSIZE; k++) {
    80006b32:	8556                	mv	a0,s5
    80006b34:	00000097          	auipc	ra,0x0
    80006b38:	f58080e7          	jalr	-168(ra) # 80006a8c <size>
    80006b3c:	84aa                	mv	s1,a0
    80006b3e:	00021797          	auipc	a5,0x21
    80006b42:	51a7a783          	lw	a5,1306(a5) # 80028058 <nsizes>
    80006b46:	37fd                	addiw	a5,a5,-1
    80006b48:	0af55d63          	bge	a0,a5,80006c02 <bd_free+0x100>
    80006b4c:	00551a13          	slli	s4,a0,0x5
  int n = p - (char *) bd_base;
    80006b50:	00021c17          	auipc	s8,0x21
    80006b54:	4f8c0c13          	addi	s8,s8,1272 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    80006b58:	4bc1                	li	s7,16
    int bi = blk_index(k, p);
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    80006b5a:	00021b17          	auipc	s6,0x21
    80006b5e:	4f6b0b13          	addi	s6,s6,1270 # 80028050 <bd_sizes>
  for (k = size(p); k < MAXSIZE; k++) {
    80006b62:	00021c97          	auipc	s9,0x21
    80006b66:	4f6c8c93          	addi	s9,s9,1270 # 80028058 <nsizes>
    80006b6a:	a82d                	j	80006ba4 <bd_free+0xa2>
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006b6c:	fff58d9b          	addiw	s11,a1,-1
    80006b70:	a881                	j	80006bc0 <bd_free+0xbe>
    if(buddy % 2 == 0) {
      p = q;
    }
    // at size k+1, mark that the merged buddy pair isn't split
    // anymore
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    80006b72:	020a0a13          	addi	s4,s4,32
    80006b76:	2485                	addiw	s1,s1,1
  int n = p - (char *) bd_base;
    80006b78:	000c3583          	ld	a1,0(s8)
  return n / BLK_SIZE(k);
    80006b7c:	40ba85bb          	subw	a1,s5,a1
    80006b80:	009b97b3          	sll	a5,s7,s1
    80006b84:	02f5c5b3          	div	a1,a1,a5
    bit_clear(bd_sizes[k+1].split, blk_index(k+1, p));
    80006b88:	000b3783          	ld	a5,0(s6)
    80006b8c:	97d2                	add	a5,a5,s4
    80006b8e:	2581                	sext.w	a1,a1
    80006b90:	6f88                	ld	a0,24(a5)
    80006b92:	00000097          	auipc	ra,0x0
    80006b96:	b30080e7          	jalr	-1232(ra) # 800066c2 <bit_clear>
  for (k = size(p); k < MAXSIZE; k++) {
    80006b9a:	000ca783          	lw	a5,0(s9)
    80006b9e:	37fd                	addiw	a5,a5,-1
    80006ba0:	06f4d163          	bge	s1,a5,80006c02 <bd_free+0x100>
  int n = p - (char *) bd_base;
    80006ba4:	000c3903          	ld	s2,0(s8)
  return n / BLK_SIZE(k);
    80006ba8:	009b99b3          	sll	s3,s7,s1
    80006bac:	412a87bb          	subw	a5,s5,s2
    80006bb0:	0337c7b3          	div	a5,a5,s3
    80006bb4:	0007859b          	sext.w	a1,a5
    int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006bb8:	8b85                	andi	a5,a5,1
    80006bba:	fbcd                	bnez	a5,80006b6c <bd_free+0x6a>
    80006bbc:	00158d9b          	addiw	s11,a1,1
    bit_clear(bd_sizes[k].alloc, bi);  // free p at size k
    80006bc0:	000b3d03          	ld	s10,0(s6)
    80006bc4:	9d52                	add	s10,s10,s4
    80006bc6:	010d3503          	ld	a0,16(s10)
    80006bca:	00000097          	auipc	ra,0x0
    80006bce:	af8080e7          	jalr	-1288(ra) # 800066c2 <bit_clear>
    if (bit_isset(bd_sizes[k].alloc, buddy)) {  // is buddy allocated?
    80006bd2:	85ee                	mv	a1,s11
    80006bd4:	010d3503          	ld	a0,16(s10)
    80006bd8:	00000097          	auipc	ra,0x0
    80006bdc:	a82080e7          	jalr	-1406(ra) # 8000665a <bit_isset>
    80006be0:	e10d                	bnez	a0,80006c02 <bd_free+0x100>
  int n = bi * BLK_SIZE(k);
    80006be2:	000d8d1b          	sext.w	s10,s11
  return (char *) bd_base + n;
    80006be6:	03b989bb          	mulw	s3,s3,s11
    80006bea:	994e                	add	s2,s2,s3
    lst_remove(q);    // remove buddy from free list
    80006bec:	854a                	mv	a0,s2
    80006bee:	00000097          	auipc	ra,0x0
    80006bf2:	630080e7          	jalr	1584(ra) # 8000721e <lst_remove>
    if(buddy % 2 == 0) {
    80006bf6:	001d7d13          	andi	s10,s10,1
    80006bfa:	f60d1ce3          	bnez	s10,80006b72 <bd_free+0x70>
      p = q;
    80006bfe:	8aca                	mv	s5,s2
    80006c00:	bf8d                	j	80006b72 <bd_free+0x70>
  }
  lst_push(&bd_sizes[k].free, p);
    80006c02:	0496                	slli	s1,s1,0x5
    80006c04:	85d6                	mv	a1,s5
    80006c06:	00021517          	auipc	a0,0x21
    80006c0a:	44a53503          	ld	a0,1098(a0) # 80028050 <bd_sizes>
    80006c0e:	9526                	add	a0,a0,s1
    80006c10:	00000097          	auipc	ra,0x0
    80006c14:	65a080e7          	jalr	1626(ra) # 8000726a <lst_push>
  release(&lock);
    80006c18:	00021517          	auipc	a0,0x21
    80006c1c:	3e850513          	addi	a0,a0,1000 # 80028000 <lock>
    80006c20:	ffffa097          	auipc	ra,0xffffa
    80006c24:	f60080e7          	jalr	-160(ra) # 80000b80 <release>
}
    80006c28:	70a6                	ld	ra,104(sp)
    80006c2a:	7406                	ld	s0,96(sp)
    80006c2c:	64e6                	ld	s1,88(sp)
    80006c2e:	6946                	ld	s2,80(sp)
    80006c30:	69a6                	ld	s3,72(sp)
    80006c32:	6a06                	ld	s4,64(sp)
    80006c34:	7ae2                	ld	s5,56(sp)
    80006c36:	7b42                	ld	s6,48(sp)
    80006c38:	7ba2                	ld	s7,40(sp)
    80006c3a:	7c02                	ld	s8,32(sp)
    80006c3c:	6ce2                	ld	s9,24(sp)
    80006c3e:	6d42                	ld	s10,16(sp)
    80006c40:	6da2                	ld	s11,8(sp)
    80006c42:	6165                	addi	sp,sp,112
    80006c44:	8082                	ret

0000000080006c46 <blk_index_next>:

// Compute the first block at size k that doesn't contain p
int
blk_index_next(int k, char *p) {
    80006c46:	1141                	addi	sp,sp,-16
    80006c48:	e422                	sd	s0,8(sp)
    80006c4a:	0800                	addi	s0,sp,16
  int n = (p - (char *) bd_base) / BLK_SIZE(k);
    80006c4c:	00021797          	auipc	a5,0x21
    80006c50:	3fc7b783          	ld	a5,1020(a5) # 80028048 <bd_base>
    80006c54:	8d9d                	sub	a1,a1,a5
    80006c56:	47c1                	li	a5,16
    80006c58:	00a797b3          	sll	a5,a5,a0
    80006c5c:	02f5c533          	div	a0,a1,a5
    80006c60:	2501                	sext.w	a0,a0
  if((p - (char*) bd_base) % BLK_SIZE(k) != 0)
    80006c62:	02f5e5b3          	rem	a1,a1,a5
    80006c66:	c191                	beqz	a1,80006c6a <blk_index_next+0x24>
      n++;
    80006c68:	2505                	addiw	a0,a0,1
  return n ;
}
    80006c6a:	6422                	ld	s0,8(sp)
    80006c6c:	0141                	addi	sp,sp,16
    80006c6e:	8082                	ret

0000000080006c70 <log2>:

int
log2(uint64 n) {
    80006c70:	1141                	addi	sp,sp,-16
    80006c72:	e422                	sd	s0,8(sp)
    80006c74:	0800                	addi	s0,sp,16
  int k = 0;
  while (n > 1) {
    80006c76:	4705                	li	a4,1
    80006c78:	00a77b63          	bgeu	a4,a0,80006c8e <log2+0x1e>
    80006c7c:	87aa                	mv	a5,a0
  int k = 0;
    80006c7e:	4501                	li	a0,0
    k++;
    80006c80:	2505                	addiw	a0,a0,1
    n = n >> 1;
    80006c82:	8385                	srli	a5,a5,0x1
  while (n > 1) {
    80006c84:	fef76ee3          	bltu	a4,a5,80006c80 <log2+0x10>
  }
  return k;
}
    80006c88:	6422                	ld	s0,8(sp)
    80006c8a:	0141                	addi	sp,sp,16
    80006c8c:	8082                	ret
  int k = 0;
    80006c8e:	4501                	li	a0,0
    80006c90:	bfe5                	j	80006c88 <log2+0x18>

0000000080006c92 <bd_mark>:

// Mark memory from [start, stop), starting at size 0, as allocated. 
void
bd_mark(void *start, void *stop)
{
    80006c92:	711d                	addi	sp,sp,-96
    80006c94:	ec86                	sd	ra,88(sp)
    80006c96:	e8a2                	sd	s0,80(sp)
    80006c98:	e4a6                	sd	s1,72(sp)
    80006c9a:	e0ca                	sd	s2,64(sp)
    80006c9c:	fc4e                	sd	s3,56(sp)
    80006c9e:	f852                	sd	s4,48(sp)
    80006ca0:	f456                	sd	s5,40(sp)
    80006ca2:	f05a                	sd	s6,32(sp)
    80006ca4:	ec5e                	sd	s7,24(sp)
    80006ca6:	e862                	sd	s8,16(sp)
    80006ca8:	e466                	sd	s9,8(sp)
    80006caa:	e06a                	sd	s10,0(sp)
    80006cac:	1080                	addi	s0,sp,96
  int bi, bj;

  if (((uint64) start % LEAF_SIZE != 0) || ((uint64) stop % LEAF_SIZE != 0))
    80006cae:	00b56933          	or	s2,a0,a1
    80006cb2:	00f97913          	andi	s2,s2,15
    80006cb6:	04091263          	bnez	s2,80006cfa <bd_mark+0x68>
    80006cba:	8b2a                	mv	s6,a0
    80006cbc:	8bae                	mv	s7,a1
    panic("bd_mark");

  for (int k = 0; k < nsizes; k++) {
    80006cbe:	00021c17          	auipc	s8,0x21
    80006cc2:	39ac2c03          	lw	s8,922(s8) # 80028058 <nsizes>
    80006cc6:	4981                	li	s3,0
  int n = p - (char *) bd_base;
    80006cc8:	00021d17          	auipc	s10,0x21
    80006ccc:	380d0d13          	addi	s10,s10,896 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    80006cd0:	4cc1                	li	s9,16
    bi = blk_index(k, start);
    bj = blk_index_next(k, stop);
    for(; bi < bj; bi++) {
      if(k > 0) {
        // if a block is allocated at size k, mark it as split too.
        bit_set(bd_sizes[k].split, bi);
    80006cd2:	00021a97          	auipc	s5,0x21
    80006cd6:	37ea8a93          	addi	s5,s5,894 # 80028050 <bd_sizes>
  for (int k = 0; k < nsizes; k++) {
    80006cda:	07804563          	bgtz	s8,80006d44 <bd_mark+0xb2>
      }
      bit_set(bd_sizes[k].alloc, bi);
    }
  }
}
    80006cde:	60e6                	ld	ra,88(sp)
    80006ce0:	6446                	ld	s0,80(sp)
    80006ce2:	64a6                	ld	s1,72(sp)
    80006ce4:	6906                	ld	s2,64(sp)
    80006ce6:	79e2                	ld	s3,56(sp)
    80006ce8:	7a42                	ld	s4,48(sp)
    80006cea:	7aa2                	ld	s5,40(sp)
    80006cec:	7b02                	ld	s6,32(sp)
    80006cee:	6be2                	ld	s7,24(sp)
    80006cf0:	6c42                	ld	s8,16(sp)
    80006cf2:	6ca2                	ld	s9,8(sp)
    80006cf4:	6d02                	ld	s10,0(sp)
    80006cf6:	6125                	addi	sp,sp,96
    80006cf8:	8082                	ret
    panic("bd_mark");
    80006cfa:	00002517          	auipc	a0,0x2
    80006cfe:	f0e50513          	addi	a0,a0,-242 # 80008c08 <userret+0xb78>
    80006d02:	ffffa097          	auipc	ra,0xffffa
    80006d06:	858080e7          	jalr	-1960(ra) # 8000055a <panic>
      bit_set(bd_sizes[k].alloc, bi);
    80006d0a:	000ab783          	ld	a5,0(s5)
    80006d0e:	97ca                	add	a5,a5,s2
    80006d10:	85a6                	mv	a1,s1
    80006d12:	6b88                	ld	a0,16(a5)
    80006d14:	00000097          	auipc	ra,0x0
    80006d18:	97e080e7          	jalr	-1666(ra) # 80006692 <bit_set>
    for(; bi < bj; bi++) {
    80006d1c:	2485                	addiw	s1,s1,1
    80006d1e:	009a0e63          	beq	s4,s1,80006d3a <bd_mark+0xa8>
      if(k > 0) {
    80006d22:	ff3054e3          	blez	s3,80006d0a <bd_mark+0x78>
        bit_set(bd_sizes[k].split, bi);
    80006d26:	000ab783          	ld	a5,0(s5)
    80006d2a:	97ca                	add	a5,a5,s2
    80006d2c:	85a6                	mv	a1,s1
    80006d2e:	6f88                	ld	a0,24(a5)
    80006d30:	00000097          	auipc	ra,0x0
    80006d34:	962080e7          	jalr	-1694(ra) # 80006692 <bit_set>
    80006d38:	bfc9                	j	80006d0a <bd_mark+0x78>
  for (int k = 0; k < nsizes; k++) {
    80006d3a:	2985                	addiw	s3,s3,1
    80006d3c:	02090913          	addi	s2,s2,32
    80006d40:	f9898fe3          	beq	s3,s8,80006cde <bd_mark+0x4c>
  int n = p - (char *) bd_base;
    80006d44:	000d3483          	ld	s1,0(s10)
  return n / BLK_SIZE(k);
    80006d48:	409b04bb          	subw	s1,s6,s1
    80006d4c:	013c97b3          	sll	a5,s9,s3
    80006d50:	02f4c4b3          	div	s1,s1,a5
    80006d54:	2481                	sext.w	s1,s1
    bj = blk_index_next(k, stop);
    80006d56:	85de                	mv	a1,s7
    80006d58:	854e                	mv	a0,s3
    80006d5a:	00000097          	auipc	ra,0x0
    80006d5e:	eec080e7          	jalr	-276(ra) # 80006c46 <blk_index_next>
    80006d62:	8a2a                	mv	s4,a0
    for(; bi < bj; bi++) {
    80006d64:	faa4cfe3          	blt	s1,a0,80006d22 <bd_mark+0x90>
    80006d68:	bfc9                	j	80006d3a <bd_mark+0xa8>

0000000080006d6a <bd_initfree_pair>:

// If a block is marked as allocated and the buddy is free, put the
// buddy on the free list at size k.
int
bd_initfree_pair(int k, int bi) {
    80006d6a:	7139                	addi	sp,sp,-64
    80006d6c:	fc06                	sd	ra,56(sp)
    80006d6e:	f822                	sd	s0,48(sp)
    80006d70:	f426                	sd	s1,40(sp)
    80006d72:	f04a                	sd	s2,32(sp)
    80006d74:	ec4e                	sd	s3,24(sp)
    80006d76:	e852                	sd	s4,16(sp)
    80006d78:	e456                	sd	s5,8(sp)
    80006d7a:	e05a                	sd	s6,0(sp)
    80006d7c:	0080                	addi	s0,sp,64
    80006d7e:	89aa                	mv	s3,a0
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006d80:	00058a9b          	sext.w	s5,a1
    80006d84:	0015f793          	andi	a5,a1,1
    80006d88:	ebad                	bnez	a5,80006dfa <bd_initfree_pair+0x90>
    80006d8a:	00158a1b          	addiw	s4,a1,1
  int free = 0;
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006d8e:	00599493          	slli	s1,s3,0x5
    80006d92:	00021797          	auipc	a5,0x21
    80006d96:	2be7b783          	ld	a5,702(a5) # 80028050 <bd_sizes>
    80006d9a:	94be                	add	s1,s1,a5
    80006d9c:	0104bb03          	ld	s6,16(s1)
    80006da0:	855a                	mv	a0,s6
    80006da2:	00000097          	auipc	ra,0x0
    80006da6:	8b8080e7          	jalr	-1864(ra) # 8000665a <bit_isset>
    80006daa:	892a                	mv	s2,a0
    80006dac:	85d2                	mv	a1,s4
    80006dae:	855a                	mv	a0,s6
    80006db0:	00000097          	auipc	ra,0x0
    80006db4:	8aa080e7          	jalr	-1878(ra) # 8000665a <bit_isset>
  int free = 0;
    80006db8:	4b01                	li	s6,0
  if(bit_isset(bd_sizes[k].alloc, bi) !=  bit_isset(bd_sizes[k].alloc, buddy)) {
    80006dba:	02a90563          	beq	s2,a0,80006de4 <bd_initfree_pair+0x7a>
    // one of the pair is free
    free = BLK_SIZE(k);
    80006dbe:	45c1                	li	a1,16
    80006dc0:	013599b3          	sll	s3,a1,s3
    80006dc4:	00098b1b          	sext.w	s6,s3
    if(bit_isset(bd_sizes[k].alloc, bi))
    80006dc8:	02090c63          	beqz	s2,80006e00 <bd_initfree_pair+0x96>
  return (char *) bd_base + n;
    80006dcc:	034989bb          	mulw	s3,s3,s4
      lst_push(&bd_sizes[k].free, addr(k, buddy));   // put buddy on free list
    80006dd0:	00021597          	auipc	a1,0x21
    80006dd4:	2785b583          	ld	a1,632(a1) # 80028048 <bd_base>
    80006dd8:	95ce                	add	a1,a1,s3
    80006dda:	8526                	mv	a0,s1
    80006ddc:	00000097          	auipc	ra,0x0
    80006de0:	48e080e7          	jalr	1166(ra) # 8000726a <lst_push>
    else
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
  }
  return free;
}
    80006de4:	855a                	mv	a0,s6
    80006de6:	70e2                	ld	ra,56(sp)
    80006de8:	7442                	ld	s0,48(sp)
    80006dea:	74a2                	ld	s1,40(sp)
    80006dec:	7902                	ld	s2,32(sp)
    80006dee:	69e2                	ld	s3,24(sp)
    80006df0:	6a42                	ld	s4,16(sp)
    80006df2:	6aa2                	ld	s5,8(sp)
    80006df4:	6b02                	ld	s6,0(sp)
    80006df6:	6121                	addi	sp,sp,64
    80006df8:	8082                	ret
  int buddy = (bi % 2 == 0) ? bi+1 : bi-1;
    80006dfa:	fff58a1b          	addiw	s4,a1,-1
    80006dfe:	bf41                	j	80006d8e <bd_initfree_pair+0x24>
  return (char *) bd_base + n;
    80006e00:	035989bb          	mulw	s3,s3,s5
      lst_push(&bd_sizes[k].free, addr(k, bi));      // put bi on free list
    80006e04:	00021597          	auipc	a1,0x21
    80006e08:	2445b583          	ld	a1,580(a1) # 80028048 <bd_base>
    80006e0c:	95ce                	add	a1,a1,s3
    80006e0e:	8526                	mv	a0,s1
    80006e10:	00000097          	auipc	ra,0x0
    80006e14:	45a080e7          	jalr	1114(ra) # 8000726a <lst_push>
    80006e18:	b7f1                	j	80006de4 <bd_initfree_pair+0x7a>

0000000080006e1a <bd_initfree>:
  
// Initialize the free lists for each size k.  For each size k, there
// are only two pairs that may have a buddy that should be on free list:
// bd_left and bd_right.
int
bd_initfree(void *bd_left, void *bd_right) {
    80006e1a:	711d                	addi	sp,sp,-96
    80006e1c:	ec86                	sd	ra,88(sp)
    80006e1e:	e8a2                	sd	s0,80(sp)
    80006e20:	e4a6                	sd	s1,72(sp)
    80006e22:	e0ca                	sd	s2,64(sp)
    80006e24:	fc4e                	sd	s3,56(sp)
    80006e26:	f852                	sd	s4,48(sp)
    80006e28:	f456                	sd	s5,40(sp)
    80006e2a:	f05a                	sd	s6,32(sp)
    80006e2c:	ec5e                	sd	s7,24(sp)
    80006e2e:	e862                	sd	s8,16(sp)
    80006e30:	e466                	sd	s9,8(sp)
    80006e32:	e06a                	sd	s10,0(sp)
    80006e34:	1080                	addi	s0,sp,96
  int free = 0;

  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006e36:	00021717          	auipc	a4,0x21
    80006e3a:	22272703          	lw	a4,546(a4) # 80028058 <nsizes>
    80006e3e:	4785                	li	a5,1
    80006e40:	06e7db63          	bge	a5,a4,80006eb6 <bd_initfree+0x9c>
    80006e44:	8aaa                	mv	s5,a0
    80006e46:	8b2e                	mv	s6,a1
    80006e48:	4901                	li	s2,0
  int free = 0;
    80006e4a:	4a01                	li	s4,0
  int n = p - (char *) bd_base;
    80006e4c:	00021c97          	auipc	s9,0x21
    80006e50:	1fcc8c93          	addi	s9,s9,508 # 80028048 <bd_base>
  return n / BLK_SIZE(k);
    80006e54:	4c41                	li	s8,16
  for (int k = 0; k < MAXSIZE; k++) {   // skip max size
    80006e56:	00021b97          	auipc	s7,0x21
    80006e5a:	202b8b93          	addi	s7,s7,514 # 80028058 <nsizes>
    80006e5e:	a039                	j	80006e6c <bd_initfree+0x52>
    80006e60:	2905                	addiw	s2,s2,1
    80006e62:	000ba783          	lw	a5,0(s7)
    80006e66:	37fd                	addiw	a5,a5,-1
    80006e68:	04f95863          	bge	s2,a5,80006eb8 <bd_initfree+0x9e>
    int left = blk_index_next(k, bd_left);
    80006e6c:	85d6                	mv	a1,s5
    80006e6e:	854a                	mv	a0,s2
    80006e70:	00000097          	auipc	ra,0x0
    80006e74:	dd6080e7          	jalr	-554(ra) # 80006c46 <blk_index_next>
    80006e78:	89aa                	mv	s3,a0
  int n = p - (char *) bd_base;
    80006e7a:	000cb483          	ld	s1,0(s9)
  return n / BLK_SIZE(k);
    80006e7e:	409b04bb          	subw	s1,s6,s1
    80006e82:	012c17b3          	sll	a5,s8,s2
    80006e86:	02f4c4b3          	div	s1,s1,a5
    80006e8a:	2481                	sext.w	s1,s1
    int right = blk_index(k, bd_right);
    free += bd_initfree_pair(k, left);
    80006e8c:	85aa                	mv	a1,a0
    80006e8e:	854a                	mv	a0,s2
    80006e90:	00000097          	auipc	ra,0x0
    80006e94:	eda080e7          	jalr	-294(ra) # 80006d6a <bd_initfree_pair>
    80006e98:	01450d3b          	addw	s10,a0,s4
    80006e9c:	000d0a1b          	sext.w	s4,s10
    if(right <= left)
    80006ea0:	fc99d0e3          	bge	s3,s1,80006e60 <bd_initfree+0x46>
      continue;
    free += bd_initfree_pair(k, right);
    80006ea4:	85a6                	mv	a1,s1
    80006ea6:	854a                	mv	a0,s2
    80006ea8:	00000097          	auipc	ra,0x0
    80006eac:	ec2080e7          	jalr	-318(ra) # 80006d6a <bd_initfree_pair>
    80006eb0:	00ad0a3b          	addw	s4,s10,a0
    80006eb4:	b775                	j	80006e60 <bd_initfree+0x46>
  int free = 0;
    80006eb6:	4a01                	li	s4,0
  }
  return free;
}
    80006eb8:	8552                	mv	a0,s4
    80006eba:	60e6                	ld	ra,88(sp)
    80006ebc:	6446                	ld	s0,80(sp)
    80006ebe:	64a6                	ld	s1,72(sp)
    80006ec0:	6906                	ld	s2,64(sp)
    80006ec2:	79e2                	ld	s3,56(sp)
    80006ec4:	7a42                	ld	s4,48(sp)
    80006ec6:	7aa2                	ld	s5,40(sp)
    80006ec8:	7b02                	ld	s6,32(sp)
    80006eca:	6be2                	ld	s7,24(sp)
    80006ecc:	6c42                	ld	s8,16(sp)
    80006ece:	6ca2                	ld	s9,8(sp)
    80006ed0:	6d02                	ld	s10,0(sp)
    80006ed2:	6125                	addi	sp,sp,96
    80006ed4:	8082                	ret

0000000080006ed6 <bd_mark_data_structures>:

// Mark the range [bd_base,p) as allocated
int
bd_mark_data_structures(char *p) {
    80006ed6:	7179                	addi	sp,sp,-48
    80006ed8:	f406                	sd	ra,40(sp)
    80006eda:	f022                	sd	s0,32(sp)
    80006edc:	ec26                	sd	s1,24(sp)
    80006ede:	e84a                	sd	s2,16(sp)
    80006ee0:	e44e                	sd	s3,8(sp)
    80006ee2:	1800                	addi	s0,sp,48
    80006ee4:	892a                	mv	s2,a0
  int meta = p - (char*)bd_base;
    80006ee6:	00021997          	auipc	s3,0x21
    80006eea:	16298993          	addi	s3,s3,354 # 80028048 <bd_base>
    80006eee:	0009b483          	ld	s1,0(s3)
    80006ef2:	409504bb          	subw	s1,a0,s1
  printf("bd: %d meta bytes for managing %d bytes of memory\n", meta, BLK_SIZE(MAXSIZE));
    80006ef6:	00021797          	auipc	a5,0x21
    80006efa:	1627a783          	lw	a5,354(a5) # 80028058 <nsizes>
    80006efe:	37fd                	addiw	a5,a5,-1
    80006f00:	4641                	li	a2,16
    80006f02:	00f61633          	sll	a2,a2,a5
    80006f06:	85a6                	mv	a1,s1
    80006f08:	00002517          	auipc	a0,0x2
    80006f0c:	d0850513          	addi	a0,a0,-760 # 80008c10 <userret+0xb80>
    80006f10:	ffff9097          	auipc	ra,0xffff9
    80006f14:	6a4080e7          	jalr	1700(ra) # 800005b4 <printf>
  bd_mark(bd_base, p);
    80006f18:	85ca                	mv	a1,s2
    80006f1a:	0009b503          	ld	a0,0(s3)
    80006f1e:	00000097          	auipc	ra,0x0
    80006f22:	d74080e7          	jalr	-652(ra) # 80006c92 <bd_mark>
  return meta;
}
    80006f26:	8526                	mv	a0,s1
    80006f28:	70a2                	ld	ra,40(sp)
    80006f2a:	7402                	ld	s0,32(sp)
    80006f2c:	64e2                	ld	s1,24(sp)
    80006f2e:	6942                	ld	s2,16(sp)
    80006f30:	69a2                	ld	s3,8(sp)
    80006f32:	6145                	addi	sp,sp,48
    80006f34:	8082                	ret

0000000080006f36 <bd_mark_unavailable>:

// Mark the range [end, HEAPSIZE) as allocated
int
bd_mark_unavailable(void *end, void *left) {
    80006f36:	1101                	addi	sp,sp,-32
    80006f38:	ec06                	sd	ra,24(sp)
    80006f3a:	e822                	sd	s0,16(sp)
    80006f3c:	e426                	sd	s1,8(sp)
    80006f3e:	1000                	addi	s0,sp,32
  int unavailable = BLK_SIZE(MAXSIZE)-(end-bd_base);
    80006f40:	00021497          	auipc	s1,0x21
    80006f44:	1184a483          	lw	s1,280(s1) # 80028058 <nsizes>
    80006f48:	fff4879b          	addiw	a5,s1,-1
    80006f4c:	44c1                	li	s1,16
    80006f4e:	00f494b3          	sll	s1,s1,a5
    80006f52:	00021797          	auipc	a5,0x21
    80006f56:	0f67b783          	ld	a5,246(a5) # 80028048 <bd_base>
    80006f5a:	8d1d                	sub	a0,a0,a5
    80006f5c:	40a4853b          	subw	a0,s1,a0
    80006f60:	0005049b          	sext.w	s1,a0
  if(unavailable > 0)
    80006f64:	00905a63          	blez	s1,80006f78 <bd_mark_unavailable+0x42>
    unavailable = ROUNDUP(unavailable, LEAF_SIZE);
    80006f68:	357d                	addiw	a0,a0,-1
    80006f6a:	41f5549b          	sraiw	s1,a0,0x1f
    80006f6e:	01c4d49b          	srliw	s1,s1,0x1c
    80006f72:	9ca9                	addw	s1,s1,a0
    80006f74:	98c1                	andi	s1,s1,-16
    80006f76:	24c1                	addiw	s1,s1,16
  printf("bd: 0x%x bytes unavailable\n", unavailable);
    80006f78:	85a6                	mv	a1,s1
    80006f7a:	00002517          	auipc	a0,0x2
    80006f7e:	cce50513          	addi	a0,a0,-818 # 80008c48 <userret+0xbb8>
    80006f82:	ffff9097          	auipc	ra,0xffff9
    80006f86:	632080e7          	jalr	1586(ra) # 800005b4 <printf>

  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80006f8a:	00021717          	auipc	a4,0x21
    80006f8e:	0be73703          	ld	a4,190(a4) # 80028048 <bd_base>
    80006f92:	00021597          	auipc	a1,0x21
    80006f96:	0c65a583          	lw	a1,198(a1) # 80028058 <nsizes>
    80006f9a:	fff5879b          	addiw	a5,a1,-1
    80006f9e:	45c1                	li	a1,16
    80006fa0:	00f595b3          	sll	a1,a1,a5
    80006fa4:	40958533          	sub	a0,a1,s1
  bd_mark(bd_end, bd_base+BLK_SIZE(MAXSIZE));
    80006fa8:	95ba                	add	a1,a1,a4
    80006faa:	953a                	add	a0,a0,a4
    80006fac:	00000097          	auipc	ra,0x0
    80006fb0:	ce6080e7          	jalr	-794(ra) # 80006c92 <bd_mark>
  return unavailable;
}
    80006fb4:	8526                	mv	a0,s1
    80006fb6:	60e2                	ld	ra,24(sp)
    80006fb8:	6442                	ld	s0,16(sp)
    80006fba:	64a2                	ld	s1,8(sp)
    80006fbc:	6105                	addi	sp,sp,32
    80006fbe:	8082                	ret

0000000080006fc0 <bd_init>:

// Initialize the buddy allocator: it manages memory from [base, end).
void
bd_init(void *base, void *end) {
    80006fc0:	715d                	addi	sp,sp,-80
    80006fc2:	e486                	sd	ra,72(sp)
    80006fc4:	e0a2                	sd	s0,64(sp)
    80006fc6:	fc26                	sd	s1,56(sp)
    80006fc8:	f84a                	sd	s2,48(sp)
    80006fca:	f44e                	sd	s3,40(sp)
    80006fcc:	f052                	sd	s4,32(sp)
    80006fce:	ec56                	sd	s5,24(sp)
    80006fd0:	e85a                	sd	s6,16(sp)
    80006fd2:	e45e                	sd	s7,8(sp)
    80006fd4:	e062                	sd	s8,0(sp)
    80006fd6:	0880                	addi	s0,sp,80
    80006fd8:	8c2e                	mv	s8,a1
  char *p = (char *) ROUNDUP((uint64)base, LEAF_SIZE);
    80006fda:	fff50493          	addi	s1,a0,-1
    80006fde:	98c1                	andi	s1,s1,-16
    80006fe0:	04c1                	addi	s1,s1,16
  int sz;

  initlock(&lock, "buddy");
    80006fe2:	00002597          	auipc	a1,0x2
    80006fe6:	c8658593          	addi	a1,a1,-890 # 80008c68 <userret+0xbd8>
    80006fea:	00021517          	auipc	a0,0x21
    80006fee:	01650513          	addi	a0,a0,22 # 80028000 <lock>
    80006ff2:	ffffa097          	auipc	ra,0xffffa
    80006ff6:	9ea080e7          	jalr	-1558(ra) # 800009dc <initlock>
  bd_base = (void *) p;
    80006ffa:	00021797          	auipc	a5,0x21
    80006ffe:	0497b723          	sd	s1,78(a5) # 80028048 <bd_base>

  // compute the number of sizes we need to manage [base, end)
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80007002:	409c0933          	sub	s2,s8,s1
    80007006:	43f95513          	srai	a0,s2,0x3f
    8000700a:	893d                	andi	a0,a0,15
    8000700c:	954a                	add	a0,a0,s2
    8000700e:	8511                	srai	a0,a0,0x4
    80007010:	00000097          	auipc	ra,0x0
    80007014:	c60080e7          	jalr	-928(ra) # 80006c70 <log2>
  if((char*)end-p > BLK_SIZE(MAXSIZE)) {
    80007018:	47c1                	li	a5,16
    8000701a:	00a797b3          	sll	a5,a5,a0
    8000701e:	1b27c663          	blt	a5,s2,800071ca <bd_init+0x20a>
  nsizes = log2(((char *)end-p)/LEAF_SIZE) + 1;
    80007022:	2505                	addiw	a0,a0,1
    80007024:	00021797          	auipc	a5,0x21
    80007028:	02a7aa23          	sw	a0,52(a5) # 80028058 <nsizes>
    nsizes++;  // round up to the next power of 2
  }

  printf("bd: memory sz is %d bytes; allocate an size array of length %d\n",
    8000702c:	00021997          	auipc	s3,0x21
    80007030:	02c98993          	addi	s3,s3,44 # 80028058 <nsizes>
    80007034:	0009a603          	lw	a2,0(s3)
    80007038:	85ca                	mv	a1,s2
    8000703a:	00002517          	auipc	a0,0x2
    8000703e:	c3650513          	addi	a0,a0,-970 # 80008c70 <userret+0xbe0>
    80007042:	ffff9097          	auipc	ra,0xffff9
    80007046:	572080e7          	jalr	1394(ra) # 800005b4 <printf>
         (char*) end - p, nsizes);

  // allocate bd_sizes array
  bd_sizes = (Sz_info *) p;
    8000704a:	00021797          	auipc	a5,0x21
    8000704e:	0097b323          	sd	s1,6(a5) # 80028050 <bd_sizes>
  p += sizeof(Sz_info) * nsizes;
    80007052:	0009a603          	lw	a2,0(s3)
    80007056:	00561913          	slli	s2,a2,0x5
    8000705a:	9926                	add	s2,s2,s1
  memset(bd_sizes, 0, sizeof(Sz_info) * nsizes);
    8000705c:	0056161b          	slliw	a2,a2,0x5
    80007060:	4581                	li	a1,0
    80007062:	8526                	mv	a0,s1
    80007064:	ffffa097          	auipc	ra,0xffffa
    80007068:	d1a080e7          	jalr	-742(ra) # 80000d7e <memset>

  // initialize free list and allocate the alloc array for each size k
  for (int k = 0; k < nsizes; k++) {
    8000706c:	0009a783          	lw	a5,0(s3)
    80007070:	06f05a63          	blez	a5,800070e4 <bd_init+0x124>
    80007074:	4981                	li	s3,0
    lst_init(&bd_sizes[k].free);
    80007076:	00021a97          	auipc	s5,0x21
    8000707a:	fdaa8a93          	addi	s5,s5,-38 # 80028050 <bd_sizes>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    8000707e:	00021a17          	auipc	s4,0x21
    80007082:	fdaa0a13          	addi	s4,s4,-38 # 80028058 <nsizes>
    80007086:	4b05                	li	s6,1
    lst_init(&bd_sizes[k].free);
    80007088:	00599b93          	slli	s7,s3,0x5
    8000708c:	000ab503          	ld	a0,0(s5)
    80007090:	955e                	add	a0,a0,s7
    80007092:	00000097          	auipc	ra,0x0
    80007096:	166080e7          	jalr	358(ra) # 800071f8 <lst_init>
    sz = sizeof(char)* ROUNDUP(NBLK(k), 8)/8;
    8000709a:	000a2483          	lw	s1,0(s4)
    8000709e:	34fd                	addiw	s1,s1,-1
    800070a0:	413484bb          	subw	s1,s1,s3
    800070a4:	009b14bb          	sllw	s1,s6,s1
    800070a8:	fff4879b          	addiw	a5,s1,-1
    800070ac:	41f7d49b          	sraiw	s1,a5,0x1f
    800070b0:	01d4d49b          	srliw	s1,s1,0x1d
    800070b4:	9cbd                	addw	s1,s1,a5
    800070b6:	98e1                	andi	s1,s1,-8
    800070b8:	24a1                	addiw	s1,s1,8
    bd_sizes[k].alloc = p;
    800070ba:	000ab783          	ld	a5,0(s5)
    800070be:	9bbe                	add	s7,s7,a5
    800070c0:	012bb823          	sd	s2,16(s7)
    memset(bd_sizes[k].alloc, 0, sz);
    800070c4:	848d                	srai	s1,s1,0x3
    800070c6:	8626                	mv	a2,s1
    800070c8:	4581                	li	a1,0
    800070ca:	854a                	mv	a0,s2
    800070cc:	ffffa097          	auipc	ra,0xffffa
    800070d0:	cb2080e7          	jalr	-846(ra) # 80000d7e <memset>
    p += sz;
    800070d4:	9926                	add	s2,s2,s1
  for (int k = 0; k < nsizes; k++) {
    800070d6:	0985                	addi	s3,s3,1
    800070d8:	000a2703          	lw	a4,0(s4)
    800070dc:	0009879b          	sext.w	a5,s3
    800070e0:	fae7c4e3          	blt	a5,a4,80007088 <bd_init+0xc8>
  }

  // allocate the split array for each size k, except for k = 0, since
  // we will not split blocks of size k = 0, the smallest size.
  for (int k = 1; k < nsizes; k++) {
    800070e4:	00021797          	auipc	a5,0x21
    800070e8:	f747a783          	lw	a5,-140(a5) # 80028058 <nsizes>
    800070ec:	4705                	li	a4,1
    800070ee:	06f75163          	bge	a4,a5,80007150 <bd_init+0x190>
    800070f2:	02000a13          	li	s4,32
    800070f6:	4985                	li	s3,1
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    800070f8:	4b85                	li	s7,1
    bd_sizes[k].split = p;
    800070fa:	00021b17          	auipc	s6,0x21
    800070fe:	f56b0b13          	addi	s6,s6,-170 # 80028050 <bd_sizes>
  for (int k = 1; k < nsizes; k++) {
    80007102:	00021a97          	auipc	s5,0x21
    80007106:	f56a8a93          	addi	s5,s5,-170 # 80028058 <nsizes>
    sz = sizeof(char)* (ROUNDUP(NBLK(k), 8))/8;
    8000710a:	37fd                	addiw	a5,a5,-1
    8000710c:	413787bb          	subw	a5,a5,s3
    80007110:	00fb94bb          	sllw	s1,s7,a5
    80007114:	fff4879b          	addiw	a5,s1,-1
    80007118:	41f7d49b          	sraiw	s1,a5,0x1f
    8000711c:	01d4d49b          	srliw	s1,s1,0x1d
    80007120:	9cbd                	addw	s1,s1,a5
    80007122:	98e1                	andi	s1,s1,-8
    80007124:	24a1                	addiw	s1,s1,8
    bd_sizes[k].split = p;
    80007126:	000b3783          	ld	a5,0(s6)
    8000712a:	97d2                	add	a5,a5,s4
    8000712c:	0127bc23          	sd	s2,24(a5)
    memset(bd_sizes[k].split, 0, sz);
    80007130:	848d                	srai	s1,s1,0x3
    80007132:	8626                	mv	a2,s1
    80007134:	4581                	li	a1,0
    80007136:	854a                	mv	a0,s2
    80007138:	ffffa097          	auipc	ra,0xffffa
    8000713c:	c46080e7          	jalr	-954(ra) # 80000d7e <memset>
    p += sz;
    80007140:	9926                	add	s2,s2,s1
  for (int k = 1; k < nsizes; k++) {
    80007142:	2985                	addiw	s3,s3,1
    80007144:	000aa783          	lw	a5,0(s5)
    80007148:	020a0a13          	addi	s4,s4,32
    8000714c:	faf9cfe3          	blt	s3,a5,8000710a <bd_init+0x14a>
  }
  p = (char *) ROUNDUP((uint64) p, LEAF_SIZE);
    80007150:	197d                	addi	s2,s2,-1
    80007152:	ff097913          	andi	s2,s2,-16
    80007156:	0941                	addi	s2,s2,16

  // done allocating; mark the memory range [base, p) as allocated, so
  // that buddy will not hand out that memory.
  int meta = bd_mark_data_structures(p);
    80007158:	854a                	mv	a0,s2
    8000715a:	00000097          	auipc	ra,0x0
    8000715e:	d7c080e7          	jalr	-644(ra) # 80006ed6 <bd_mark_data_structures>
    80007162:	8a2a                	mv	s4,a0
  
  // mark the unavailable memory range [end, HEAP_SIZE) as allocated,
  // so that buddy will not hand out that memory.
  int unavailable = bd_mark_unavailable(end, p);
    80007164:	85ca                	mv	a1,s2
    80007166:	8562                	mv	a0,s8
    80007168:	00000097          	auipc	ra,0x0
    8000716c:	dce080e7          	jalr	-562(ra) # 80006f36 <bd_mark_unavailable>
    80007170:	89aa                	mv	s3,a0
  void *bd_end = bd_base+BLK_SIZE(MAXSIZE)-unavailable;
    80007172:	00021a97          	auipc	s5,0x21
    80007176:	ee6a8a93          	addi	s5,s5,-282 # 80028058 <nsizes>
    8000717a:	000aa783          	lw	a5,0(s5)
    8000717e:	37fd                	addiw	a5,a5,-1
    80007180:	44c1                	li	s1,16
    80007182:	00f497b3          	sll	a5,s1,a5
    80007186:	8f89                	sub	a5,a5,a0
  
  // initialize free lists for each size k
  int free = bd_initfree(p, bd_end);
    80007188:	00021597          	auipc	a1,0x21
    8000718c:	ec05b583          	ld	a1,-320(a1) # 80028048 <bd_base>
    80007190:	95be                	add	a1,a1,a5
    80007192:	854a                	mv	a0,s2
    80007194:	00000097          	auipc	ra,0x0
    80007198:	c86080e7          	jalr	-890(ra) # 80006e1a <bd_initfree>

  // check if the amount that is free is what we expect
  if(free != BLK_SIZE(MAXSIZE)-meta-unavailable) {
    8000719c:	000aa603          	lw	a2,0(s5)
    800071a0:	367d                	addiw	a2,a2,-1
    800071a2:	00c49633          	sll	a2,s1,a2
    800071a6:	41460633          	sub	a2,a2,s4
    800071aa:	41360633          	sub	a2,a2,s3
    800071ae:	02c51463          	bne	a0,a2,800071d6 <bd_init+0x216>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    panic("bd_init: free mem");
  }
}
    800071b2:	60a6                	ld	ra,72(sp)
    800071b4:	6406                	ld	s0,64(sp)
    800071b6:	74e2                	ld	s1,56(sp)
    800071b8:	7942                	ld	s2,48(sp)
    800071ba:	79a2                	ld	s3,40(sp)
    800071bc:	7a02                	ld	s4,32(sp)
    800071be:	6ae2                	ld	s5,24(sp)
    800071c0:	6b42                	ld	s6,16(sp)
    800071c2:	6ba2                	ld	s7,8(sp)
    800071c4:	6c02                	ld	s8,0(sp)
    800071c6:	6161                	addi	sp,sp,80
    800071c8:	8082                	ret
    nsizes++;  // round up to the next power of 2
    800071ca:	2509                	addiw	a0,a0,2
    800071cc:	00021797          	auipc	a5,0x21
    800071d0:	e8a7a623          	sw	a0,-372(a5) # 80028058 <nsizes>
    800071d4:	bda1                	j	8000702c <bd_init+0x6c>
    printf("free %d %d\n", free, BLK_SIZE(MAXSIZE)-meta-unavailable);
    800071d6:	85aa                	mv	a1,a0
    800071d8:	00002517          	auipc	a0,0x2
    800071dc:	ad850513          	addi	a0,a0,-1320 # 80008cb0 <userret+0xc20>
    800071e0:	ffff9097          	auipc	ra,0xffff9
    800071e4:	3d4080e7          	jalr	980(ra) # 800005b4 <printf>
    panic("bd_init: free mem");
    800071e8:	00002517          	auipc	a0,0x2
    800071ec:	ad850513          	addi	a0,a0,-1320 # 80008cc0 <userret+0xc30>
    800071f0:	ffff9097          	auipc	ra,0xffff9
    800071f4:	36a080e7          	jalr	874(ra) # 8000055a <panic>

00000000800071f8 <lst_init>:
// fast. circular simplifies code, because don't have to check for
// empty list in insert and remove.

void
lst_init(struct list *lst)
{
    800071f8:	1141                	addi	sp,sp,-16
    800071fa:	e422                	sd	s0,8(sp)
    800071fc:	0800                	addi	s0,sp,16
  lst->next = lst;
    800071fe:	e108                	sd	a0,0(a0)
  lst->prev = lst;
    80007200:	e508                	sd	a0,8(a0)
}
    80007202:	6422                	ld	s0,8(sp)
    80007204:	0141                	addi	sp,sp,16
    80007206:	8082                	ret

0000000080007208 <lst_empty>:

int
lst_empty(struct list *lst) {
    80007208:	1141                	addi	sp,sp,-16
    8000720a:	e422                	sd	s0,8(sp)
    8000720c:	0800                	addi	s0,sp,16
  return lst->next == lst;
    8000720e:	611c                	ld	a5,0(a0)
    80007210:	40a78533          	sub	a0,a5,a0
}
    80007214:	00153513          	seqz	a0,a0
    80007218:	6422                	ld	s0,8(sp)
    8000721a:	0141                	addi	sp,sp,16
    8000721c:	8082                	ret

000000008000721e <lst_remove>:

void
lst_remove(struct list *e) {
    8000721e:	1141                	addi	sp,sp,-16
    80007220:	e422                	sd	s0,8(sp)
    80007222:	0800                	addi	s0,sp,16
  e->prev->next = e->next;
    80007224:	6518                	ld	a4,8(a0)
    80007226:	611c                	ld	a5,0(a0)
    80007228:	e31c                	sd	a5,0(a4)
  e->next->prev = e->prev;
    8000722a:	6518                	ld	a4,8(a0)
    8000722c:	e798                	sd	a4,8(a5)
}
    8000722e:	6422                	ld	s0,8(sp)
    80007230:	0141                	addi	sp,sp,16
    80007232:	8082                	ret

0000000080007234 <lst_pop>:

void*
lst_pop(struct list *lst) {
    80007234:	1101                	addi	sp,sp,-32
    80007236:	ec06                	sd	ra,24(sp)
    80007238:	e822                	sd	s0,16(sp)
    8000723a:	e426                	sd	s1,8(sp)
    8000723c:	1000                	addi	s0,sp,32
  if(lst->next == lst)
    8000723e:	6104                	ld	s1,0(a0)
    80007240:	00a48d63          	beq	s1,a0,8000725a <lst_pop+0x26>
    panic("lst_pop");
  struct list *p = lst->next;
  lst_remove(p);
    80007244:	8526                	mv	a0,s1
    80007246:	00000097          	auipc	ra,0x0
    8000724a:	fd8080e7          	jalr	-40(ra) # 8000721e <lst_remove>
  return (void *)p;
}
    8000724e:	8526                	mv	a0,s1
    80007250:	60e2                	ld	ra,24(sp)
    80007252:	6442                	ld	s0,16(sp)
    80007254:	64a2                	ld	s1,8(sp)
    80007256:	6105                	addi	sp,sp,32
    80007258:	8082                	ret
    panic("lst_pop");
    8000725a:	00002517          	auipc	a0,0x2
    8000725e:	a7e50513          	addi	a0,a0,-1410 # 80008cd8 <userret+0xc48>
    80007262:	ffff9097          	auipc	ra,0xffff9
    80007266:	2f8080e7          	jalr	760(ra) # 8000055a <panic>

000000008000726a <lst_push>:

void
lst_push(struct list *lst, void *p)
{
    8000726a:	1141                	addi	sp,sp,-16
    8000726c:	e422                	sd	s0,8(sp)
    8000726e:	0800                	addi	s0,sp,16
  struct list *e = (struct list *) p;
  e->next = lst->next;
    80007270:	611c                	ld	a5,0(a0)
    80007272:	e19c                	sd	a5,0(a1)
  e->prev = lst;
    80007274:	e588                	sd	a0,8(a1)
  lst->next->prev = p;
    80007276:	611c                	ld	a5,0(a0)
    80007278:	e78c                	sd	a1,8(a5)
  lst->next = e;
    8000727a:	e10c                	sd	a1,0(a0)
}
    8000727c:	6422                	ld	s0,8(sp)
    8000727e:	0141                	addi	sp,sp,16
    80007280:	8082                	ret

0000000080007282 <lst_print>:

void
lst_print(struct list *lst)
{
    80007282:	7179                	addi	sp,sp,-48
    80007284:	f406                	sd	ra,40(sp)
    80007286:	f022                	sd	s0,32(sp)
    80007288:	ec26                	sd	s1,24(sp)
    8000728a:	e84a                	sd	s2,16(sp)
    8000728c:	e44e                	sd	s3,8(sp)
    8000728e:	1800                	addi	s0,sp,48
  for (struct list *p = lst->next; p != lst; p = p->next) {
    80007290:	6104                	ld	s1,0(a0)
    80007292:	02950063          	beq	a0,s1,800072b2 <lst_print+0x30>
    80007296:	892a                	mv	s2,a0
    printf(" %p", p);
    80007298:	00002997          	auipc	s3,0x2
    8000729c:	a4898993          	addi	s3,s3,-1464 # 80008ce0 <userret+0xc50>
    800072a0:	85a6                	mv	a1,s1
    800072a2:	854e                	mv	a0,s3
    800072a4:	ffff9097          	auipc	ra,0xffff9
    800072a8:	310080e7          	jalr	784(ra) # 800005b4 <printf>
  for (struct list *p = lst->next; p != lst; p = p->next) {
    800072ac:	6084                	ld	s1,0(s1)
    800072ae:	fe9919e3          	bne	s2,s1,800072a0 <lst_print+0x1e>
  }
  printf("\n");
    800072b2:	00001517          	auipc	a0,0x1
    800072b6:	fde50513          	addi	a0,a0,-34 # 80008290 <userret+0x200>
    800072ba:	ffff9097          	auipc	ra,0xffff9
    800072be:	2fa080e7          	jalr	762(ra) # 800005b4 <printf>
}
    800072c2:	70a2                	ld	ra,40(sp)
    800072c4:	7402                	ld	s0,32(sp)
    800072c6:	64e2                	ld	s1,24(sp)
    800072c8:	6942                	ld	s2,16(sp)
    800072ca:	69a2                	ld	s3,8(sp)
    800072cc:	6145                	addi	sp,sp,48
    800072ce:	8082                	ret
	...

0000000080008000 <trampoline>:
    80008000:	14051573          	csrrw	a0,sscratch,a0
    80008004:	02153423          	sd	ra,40(a0)
    80008008:	02253823          	sd	sp,48(a0)
    8000800c:	02353c23          	sd	gp,56(a0)
    80008010:	04453023          	sd	tp,64(a0)
    80008014:	04553423          	sd	t0,72(a0)
    80008018:	04653823          	sd	t1,80(a0)
    8000801c:	04753c23          	sd	t2,88(a0)
    80008020:	f120                	sd	s0,96(a0)
    80008022:	f524                	sd	s1,104(a0)
    80008024:	fd2c                	sd	a1,120(a0)
    80008026:	e150                	sd	a2,128(a0)
    80008028:	e554                	sd	a3,136(a0)
    8000802a:	e958                	sd	a4,144(a0)
    8000802c:	ed5c                	sd	a5,152(a0)
    8000802e:	0b053023          	sd	a6,160(a0)
    80008032:	0b153423          	sd	a7,168(a0)
    80008036:	0b253823          	sd	s2,176(a0)
    8000803a:	0b353c23          	sd	s3,184(a0)
    8000803e:	0d453023          	sd	s4,192(a0)
    80008042:	0d553423          	sd	s5,200(a0)
    80008046:	0d653823          	sd	s6,208(a0)
    8000804a:	0d753c23          	sd	s7,216(a0)
    8000804e:	0f853023          	sd	s8,224(a0)
    80008052:	0f953423          	sd	s9,232(a0)
    80008056:	0fa53823          	sd	s10,240(a0)
    8000805a:	0fb53c23          	sd	s11,248(a0)
    8000805e:	11c53023          	sd	t3,256(a0)
    80008062:	11d53423          	sd	t4,264(a0)
    80008066:	11e53823          	sd	t5,272(a0)
    8000806a:	11f53c23          	sd	t6,280(a0)
    8000806e:	140022f3          	csrr	t0,sscratch
    80008072:	06553823          	sd	t0,112(a0)
    80008076:	00853103          	ld	sp,8(a0)
    8000807a:	02053203          	ld	tp,32(a0)
    8000807e:	01053283          	ld	t0,16(a0)
    80008082:	00053303          	ld	t1,0(a0)
    80008086:	18031073          	csrw	satp,t1
    8000808a:	12000073          	sfence.vma
    8000808e:	8282                	jr	t0

0000000080008090 <userret>:
    80008090:	18059073          	csrw	satp,a1
    80008094:	12000073          	sfence.vma
    80008098:	07053283          	ld	t0,112(a0)
    8000809c:	14029073          	csrw	sscratch,t0
    800080a0:	02853083          	ld	ra,40(a0)
    800080a4:	03053103          	ld	sp,48(a0)
    800080a8:	03853183          	ld	gp,56(a0)
    800080ac:	04053203          	ld	tp,64(a0)
    800080b0:	04853283          	ld	t0,72(a0)
    800080b4:	05053303          	ld	t1,80(a0)
    800080b8:	05853383          	ld	t2,88(a0)
    800080bc:	7120                	ld	s0,96(a0)
    800080be:	7524                	ld	s1,104(a0)
    800080c0:	7d2c                	ld	a1,120(a0)
    800080c2:	6150                	ld	a2,128(a0)
    800080c4:	6554                	ld	a3,136(a0)
    800080c6:	6958                	ld	a4,144(a0)
    800080c8:	6d5c                	ld	a5,152(a0)
    800080ca:	0a053803          	ld	a6,160(a0)
    800080ce:	0a853883          	ld	a7,168(a0)
    800080d2:	0b053903          	ld	s2,176(a0)
    800080d6:	0b853983          	ld	s3,184(a0)
    800080da:	0c053a03          	ld	s4,192(a0)
    800080de:	0c853a83          	ld	s5,200(a0)
    800080e2:	0d053b03          	ld	s6,208(a0)
    800080e6:	0d853b83          	ld	s7,216(a0)
    800080ea:	0e053c03          	ld	s8,224(a0)
    800080ee:	0e853c83          	ld	s9,232(a0)
    800080f2:	0f053d03          	ld	s10,240(a0)
    800080f6:	0f853d83          	ld	s11,248(a0)
    800080fa:	10053e03          	ld	t3,256(a0)
    800080fe:	10853e83          	ld	t4,264(a0)
    80008102:	11053f03          	ld	t5,272(a0)
    80008106:	11853f83          	ld	t6,280(a0)
    8000810a:	14051573          	csrrw	a0,sscratch,a0
    8000810e:	10200073          	sret
