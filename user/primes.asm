
user/_primes:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <source>:
            sieve();
        }
    }
}

void source() {
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	1800                	addi	s0,sp,48
    int n;
    for (n = 2; n < 100; n++) {
   a:	4789                	li	a5,2
   c:	fcf42e23          	sw	a5,-36(s0)
  10:	06300493          	li	s1,99
        write(1, &n, sizeof(n));
  14:	4611                	li	a2,4
  16:	fdc40593          	addi	a1,s0,-36
  1a:	4505                	li	a0,1
  1c:	00000097          	auipc	ra,0x0
  20:	414080e7          	jalr	1044(ra) # 430 <write>
    for (n = 2; n < 100; n++) {
  24:	fdc42783          	lw	a5,-36(s0)
  28:	2785                	addiw	a5,a5,1
  2a:	0007871b          	sext.w	a4,a5
  2e:	fcf42e23          	sw	a5,-36(s0)
  32:	fee4d1e3          	bge	s1,a4,14 <source+0x14>
    }
}
  36:	70a2                	ld	ra,40(sp)
  38:	7402                	ld	s0,32(sp)
  3a:	64e2                	ld	s1,24(sp)
  3c:	6145                	addi	sp,sp,48
  3e:	8082                	ret

0000000000000040 <redirect>:

void redirect(int new_fd, int pipe[2]) {
  40:	1101                	addi	sp,sp,-32
  42:	ec06                	sd	ra,24(sp)
  44:	e822                	sd	s0,16(sp)
  46:	e426                	sd	s1,8(sp)
  48:	e04a                	sd	s2,0(sp)
  4a:	1000                	addi	s0,sp,32
  4c:	84aa                	mv	s1,a0
  4e:	892e                	mv	s2,a1
    close(new_fd);
  50:	00000097          	auipc	ra,0x0
  54:	3e8080e7          	jalr	1000(ra) # 438 <close>
    dup(pipe[new_fd]);
  58:	048a                	slli	s1,s1,0x2
  5a:	94ca                	add	s1,s1,s2
  5c:	4088                	lw	a0,0(s1)
  5e:	00000097          	auipc	ra,0x0
  62:	42a080e7          	jalr	1066(ra) # 488 <dup>
    close(pipe[0]);
  66:	00092503          	lw	a0,0(s2)
  6a:	00000097          	auipc	ra,0x0
  6e:	3ce080e7          	jalr	974(ra) # 438 <close>
    close(pipe[1]);
  72:	00492503          	lw	a0,4(s2)
  76:	00000097          	auipc	ra,0x0
  7a:	3c2080e7          	jalr	962(ra) # 438 <close>
  7e:	60e2                	ld	ra,24(sp)
  80:	6442                	ld	s0,16(sp)
  82:	64a2                	ld	s1,8(sp)
  84:	6902                	ld	s2,0(sp)
  86:	6105                	addi	sp,sp,32
  88:	8082                	ret

000000000000008a <sieve>:
void sieve() {
  8a:	7179                	addi	sp,sp,-48
  8c:	f406                	sd	ra,40(sp)
  8e:	f022                	sd	s0,32(sp)
  90:	1800                	addi	s0,sp,48
    read(0, &n, sizeof(n));
  92:	4611                	li	a2,4
  94:	fec40593          	addi	a1,s0,-20
  98:	4501                	li	a0,0
  9a:	00000097          	auipc	ra,0x0
  9e:	38e080e7          	jalr	910(ra) # 428 <read>
    if (n != 0) {
  a2:	fec42783          	lw	a5,-20(s0)
  a6:	e789                	bnez	a5,b0 <sieve+0x26>
}
  a8:	70a2                	ld	ra,40(sp)
  aa:	7402                	ld	s0,32(sp)
  ac:	6145                	addi	sp,sp,48
  ae:	8082                	ret
        printf("%d: Prime %d \n", getpid(), n);
  b0:	00000097          	auipc	ra,0x0
  b4:	3e0080e7          	jalr	992(ra) # 490 <getpid>
  b8:	85aa                	mv	a1,a0
  ba:	fec42603          	lw	a2,-20(s0)
  be:	00001517          	auipc	a0,0x1
  c2:	87a50513          	addi	a0,a0,-1926 # 938 <malloc+0xea>
  c6:	00000097          	auipc	ra,0x0
  ca:	6ca080e7          	jalr	1738(ra) # 790 <printf>
        int z = pipe(fd);
  ce:	fe040513          	addi	a0,s0,-32
  d2:	00000097          	auipc	ra,0x0
  d6:	34e080e7          	jalr	846(ra) # 420 <pipe>
        if (z < 0) {
  da:	fc0547e3          	bltz	a0,a8 <sieve+0x1e>
        if (fork()) {
  de:	00000097          	auipc	ra,0x0
  e2:	32a080e7          	jalr	810(ra) # 408 <fork>
  e6:	ed09                	bnez	a0,100 <sieve+0x76>
            redirect(0, fd);
  e8:	fe040593          	addi	a1,s0,-32
  ec:	4501                	li	a0,0
  ee:	00000097          	auipc	ra,0x0
  f2:	f52080e7          	jalr	-174(ra) # 40 <redirect>
            sieve();
  f6:	00000097          	auipc	ra,0x0
  fa:	f94080e7          	jalr	-108(ra) # 8a <sieve>
  fe:	b76d                	j	a8 <sieve+0x1e>
            redirect(1, fd);
 100:	fe040593          	addi	a1,s0,-32
 104:	4505                	li	a0,1
 106:	00000097          	auipc	ra,0x0
 10a:	f3a080e7          	jalr	-198(ra) # 40 <redirect>
 10e:	a809                	j	120 <sieve+0x96>
                    write(1, &p, sizeof(p));
 110:	4611                	li	a2,4
 112:	fdc40593          	addi	a1,s0,-36
 116:	4505                	li	a0,1
 118:	00000097          	auipc	ra,0x0
 11c:	318080e7          	jalr	792(ra) # 430 <write>
                int x = read(0, &p, sizeof(p));
 120:	4611                	li	a2,4
 122:	fdc40593          	addi	a1,s0,-36
 126:	4501                	li	a0,0
 128:	00000097          	auipc	ra,0x0
 12c:	300080e7          	jalr	768(ra) # 428 <read>
                if (x <= 0) {
 130:	f6a05ce3          	blez	a0,a8 <sieve+0x1e>
                if (p % n != 0) {
 134:	fdc42783          	lw	a5,-36(s0)
 138:	fec42703          	lw	a4,-20(s0)
 13c:	02e7e7bb          	remw	a5,a5,a4
 140:	d3e5                	beqz	a5,120 <sieve+0x96>
 142:	b7f9                	j	110 <sieve+0x86>

0000000000000144 <main>:
int main(int argc, char* argv[]) {
 144:	1101                	addi	sp,sp,-32
 146:	ec06                	sd	ra,24(sp)
 148:	e822                	sd	s0,16(sp)
 14a:	1000                	addi	s0,sp,32
    pipe(fd);
 14c:	fe840513          	addi	a0,s0,-24
 150:	00000097          	auipc	ra,0x0
 154:	2d0080e7          	jalr	720(ra) # 420 <pipe>
    if (fork()) {
 158:	00000097          	auipc	ra,0x0
 15c:	2b0080e7          	jalr	688(ra) # 408 <fork>
 160:	c10d                	beqz	a0,182 <main+0x3e>
        redirect(1, fd);
 162:	fe840593          	addi	a1,s0,-24
 166:	4505                	li	a0,1
 168:	00000097          	auipc	ra,0x0
 16c:	ed8080e7          	jalr	-296(ra) # 40 <redirect>
        source();
 170:	00000097          	auipc	ra,0x0
 174:	e90080e7          	jalr	-368(ra) # 0 <source>
    exit(0);
 178:	4501                	li	a0,0
 17a:	00000097          	auipc	ra,0x0
 17e:	296080e7          	jalr	662(ra) # 410 <exit>
        redirect(0, fd);
 182:	fe840593          	addi	a1,s0,-24
 186:	4501                	li	a0,0
 188:	00000097          	auipc	ra,0x0
 18c:	eb8080e7          	jalr	-328(ra) # 40 <redirect>
        sieve();
 190:	00000097          	auipc	ra,0x0
 194:	efa080e7          	jalr	-262(ra) # 8a <sieve>
 198:	b7c5                	j	178 <main+0x34>

000000000000019a <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e422                	sd	s0,8(sp)
 19e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1a0:	87aa                	mv	a5,a0
 1a2:	0585                	addi	a1,a1,1
 1a4:	0785                	addi	a5,a5,1
 1a6:	fff5c703          	lbu	a4,-1(a1)
 1aa:	fee78fa3          	sb	a4,-1(a5)
 1ae:	fb75                	bnez	a4,1a2 <strcpy+0x8>
    ;
  return os;
}
 1b0:	6422                	ld	s0,8(sp)
 1b2:	0141                	addi	sp,sp,16
 1b4:	8082                	ret

00000000000001b6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e422                	sd	s0,8(sp)
 1ba:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cb91                	beqz	a5,1d4 <strcmp+0x1e>
 1c2:	0005c703          	lbu	a4,0(a1)
 1c6:	00f71763          	bne	a4,a5,1d4 <strcmp+0x1e>
    p++, q++;
 1ca:	0505                	addi	a0,a0,1
 1cc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1ce:	00054783          	lbu	a5,0(a0)
 1d2:	fbe5                	bnez	a5,1c2 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 1d4:	0005c503          	lbu	a0,0(a1)
}
 1d8:	40a7853b          	subw	a0,a5,a0
 1dc:	6422                	ld	s0,8(sp)
 1de:	0141                	addi	sp,sp,16
 1e0:	8082                	ret

00000000000001e2 <strlen>:

uint
strlen(const char *s)
{
 1e2:	1141                	addi	sp,sp,-16
 1e4:	e422                	sd	s0,8(sp)
 1e6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1e8:	00054783          	lbu	a5,0(a0)
 1ec:	cf91                	beqz	a5,208 <strlen+0x26>
 1ee:	0505                	addi	a0,a0,1
 1f0:	87aa                	mv	a5,a0
 1f2:	4685                	li	a3,1
 1f4:	9e89                	subw	a3,a3,a0
 1f6:	00f6853b          	addw	a0,a3,a5
 1fa:	0785                	addi	a5,a5,1
 1fc:	fff7c703          	lbu	a4,-1(a5)
 200:	fb7d                	bnez	a4,1f6 <strlen+0x14>
    ;
  return n;
}
 202:	6422                	ld	s0,8(sp)
 204:	0141                	addi	sp,sp,16
 206:	8082                	ret
  for(n = 0; s[n]; n++)
 208:	4501                	li	a0,0
 20a:	bfe5                	j	202 <strlen+0x20>

000000000000020c <memset>:

void*
memset(void *dst, int c, uint n)
{
 20c:	1141                	addi	sp,sp,-16
 20e:	e422                	sd	s0,8(sp)
 210:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 212:	ce09                	beqz	a2,22c <memset+0x20>
 214:	87aa                	mv	a5,a0
 216:	fff6071b          	addiw	a4,a2,-1
 21a:	1702                	slli	a4,a4,0x20
 21c:	9301                	srli	a4,a4,0x20
 21e:	0705                	addi	a4,a4,1
 220:	972a                	add	a4,a4,a0
    cdst[i] = c;
 222:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 226:	0785                	addi	a5,a5,1
 228:	fee79de3          	bne	a5,a4,222 <memset+0x16>
  }
  return dst;
}
 22c:	6422                	ld	s0,8(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret

0000000000000232 <strchr>:

char*
strchr(const char *s, char c)
{
 232:	1141                	addi	sp,sp,-16
 234:	e422                	sd	s0,8(sp)
 236:	0800                	addi	s0,sp,16
  for(; *s; s++)
 238:	00054783          	lbu	a5,0(a0)
 23c:	cb99                	beqz	a5,252 <strchr+0x20>
    if(*s == c)
 23e:	00f58763          	beq	a1,a5,24c <strchr+0x1a>
  for(; *s; s++)
 242:	0505                	addi	a0,a0,1
 244:	00054783          	lbu	a5,0(a0)
 248:	fbfd                	bnez	a5,23e <strchr+0xc>
      return (char*)s;
  return 0;
 24a:	4501                	li	a0,0
}
 24c:	6422                	ld	s0,8(sp)
 24e:	0141                	addi	sp,sp,16
 250:	8082                	ret
  return 0;
 252:	4501                	li	a0,0
 254:	bfe5                	j	24c <strchr+0x1a>

0000000000000256 <gets>:

char*
gets(char *buf, int max)
{
 256:	711d                	addi	sp,sp,-96
 258:	ec86                	sd	ra,88(sp)
 25a:	e8a2                	sd	s0,80(sp)
 25c:	e4a6                	sd	s1,72(sp)
 25e:	e0ca                	sd	s2,64(sp)
 260:	fc4e                	sd	s3,56(sp)
 262:	f852                	sd	s4,48(sp)
 264:	f456                	sd	s5,40(sp)
 266:	f05a                	sd	s6,32(sp)
 268:	ec5e                	sd	s7,24(sp)
 26a:	1080                	addi	s0,sp,96
 26c:	8baa                	mv	s7,a0
 26e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 270:	892a                	mv	s2,a0
 272:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 274:	4aa9                	li	s5,10
 276:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 278:	89a6                	mv	s3,s1
 27a:	2485                	addiw	s1,s1,1
 27c:	0344d863          	bge	s1,s4,2ac <gets+0x56>
    cc = read(0, &c, 1);
 280:	4605                	li	a2,1
 282:	faf40593          	addi	a1,s0,-81
 286:	4501                	li	a0,0
 288:	00000097          	auipc	ra,0x0
 28c:	1a0080e7          	jalr	416(ra) # 428 <read>
    if(cc < 1)
 290:	00a05e63          	blez	a0,2ac <gets+0x56>
    buf[i++] = c;
 294:	faf44783          	lbu	a5,-81(s0)
 298:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 29c:	01578763          	beq	a5,s5,2aa <gets+0x54>
 2a0:	0905                	addi	s2,s2,1
 2a2:	fd679be3          	bne	a5,s6,278 <gets+0x22>
  for(i=0; i+1 < max; ){
 2a6:	89a6                	mv	s3,s1
 2a8:	a011                	j	2ac <gets+0x56>
 2aa:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2ac:	99de                	add	s3,s3,s7
 2ae:	00098023          	sb	zero,0(s3)
  return buf;
}
 2b2:	855e                	mv	a0,s7
 2b4:	60e6                	ld	ra,88(sp)
 2b6:	6446                	ld	s0,80(sp)
 2b8:	64a6                	ld	s1,72(sp)
 2ba:	6906                	ld	s2,64(sp)
 2bc:	79e2                	ld	s3,56(sp)
 2be:	7a42                	ld	s4,48(sp)
 2c0:	7aa2                	ld	s5,40(sp)
 2c2:	7b02                	ld	s6,32(sp)
 2c4:	6be2                	ld	s7,24(sp)
 2c6:	6125                	addi	sp,sp,96
 2c8:	8082                	ret

00000000000002ca <stat>:

int
stat(const char *n, struct stat *st)
{
 2ca:	1101                	addi	sp,sp,-32
 2cc:	ec06                	sd	ra,24(sp)
 2ce:	e822                	sd	s0,16(sp)
 2d0:	e426                	sd	s1,8(sp)
 2d2:	e04a                	sd	s2,0(sp)
 2d4:	1000                	addi	s0,sp,32
 2d6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2d8:	4581                	li	a1,0
 2da:	00000097          	auipc	ra,0x0
 2de:	176080e7          	jalr	374(ra) # 450 <open>
  if(fd < 0)
 2e2:	02054563          	bltz	a0,30c <stat+0x42>
 2e6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2e8:	85ca                	mv	a1,s2
 2ea:	00000097          	auipc	ra,0x0
 2ee:	17e080e7          	jalr	382(ra) # 468 <fstat>
 2f2:	892a                	mv	s2,a0
  close(fd);
 2f4:	8526                	mv	a0,s1
 2f6:	00000097          	auipc	ra,0x0
 2fa:	142080e7          	jalr	322(ra) # 438 <close>
  return r;
}
 2fe:	854a                	mv	a0,s2
 300:	60e2                	ld	ra,24(sp)
 302:	6442                	ld	s0,16(sp)
 304:	64a2                	ld	s1,8(sp)
 306:	6902                	ld	s2,0(sp)
 308:	6105                	addi	sp,sp,32
 30a:	8082                	ret
    return -1;
 30c:	597d                	li	s2,-1
 30e:	bfc5                	j	2fe <stat+0x34>

0000000000000310 <atoi>:

int
atoi(const char *s)
{
 310:	1141                	addi	sp,sp,-16
 312:	e422                	sd	s0,8(sp)
 314:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 316:	00054603          	lbu	a2,0(a0)
 31a:	fd06079b          	addiw	a5,a2,-48
 31e:	0ff7f793          	andi	a5,a5,255
 322:	4725                	li	a4,9
 324:	02f76963          	bltu	a4,a5,356 <atoi+0x46>
 328:	86aa                	mv	a3,a0
  n = 0;
 32a:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 32c:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 32e:	0685                	addi	a3,a3,1
 330:	0025179b          	slliw	a5,a0,0x2
 334:	9fa9                	addw	a5,a5,a0
 336:	0017979b          	slliw	a5,a5,0x1
 33a:	9fb1                	addw	a5,a5,a2
 33c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 340:	0006c603          	lbu	a2,0(a3)
 344:	fd06071b          	addiw	a4,a2,-48
 348:	0ff77713          	andi	a4,a4,255
 34c:	fee5f1e3          	bgeu	a1,a4,32e <atoi+0x1e>
  return n;
}
 350:	6422                	ld	s0,8(sp)
 352:	0141                	addi	sp,sp,16
 354:	8082                	ret
  n = 0;
 356:	4501                	li	a0,0
 358:	bfe5                	j	350 <atoi+0x40>

000000000000035a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e422                	sd	s0,8(sp)
 35e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 360:	02b57663          	bgeu	a0,a1,38c <memmove+0x32>
    while(n-- > 0)
 364:	02c05163          	blez	a2,386 <memmove+0x2c>
 368:	fff6079b          	addiw	a5,a2,-1
 36c:	1782                	slli	a5,a5,0x20
 36e:	9381                	srli	a5,a5,0x20
 370:	0785                	addi	a5,a5,1
 372:	97aa                	add	a5,a5,a0
  dst = vdst;
 374:	872a                	mv	a4,a0
      *dst++ = *src++;
 376:	0585                	addi	a1,a1,1
 378:	0705                	addi	a4,a4,1
 37a:	fff5c683          	lbu	a3,-1(a1)
 37e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 382:	fee79ae3          	bne	a5,a4,376 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 386:	6422                	ld	s0,8(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
    dst += n;
 38c:	00c50733          	add	a4,a0,a2
    src += n;
 390:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 392:	fec05ae3          	blez	a2,386 <memmove+0x2c>
 396:	fff6079b          	addiw	a5,a2,-1
 39a:	1782                	slli	a5,a5,0x20
 39c:	9381                	srli	a5,a5,0x20
 39e:	fff7c793          	not	a5,a5
 3a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3a4:	15fd                	addi	a1,a1,-1
 3a6:	177d                	addi	a4,a4,-1
 3a8:	0005c683          	lbu	a3,0(a1)
 3ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3b0:	fee79ae3          	bne	a5,a4,3a4 <memmove+0x4a>
 3b4:	bfc9                	j	386 <memmove+0x2c>

00000000000003b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3b6:	1141                	addi	sp,sp,-16
 3b8:	e422                	sd	s0,8(sp)
 3ba:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3bc:	ca05                	beqz	a2,3ec <memcmp+0x36>
 3be:	fff6069b          	addiw	a3,a2,-1
 3c2:	1682                	slli	a3,a3,0x20
 3c4:	9281                	srli	a3,a3,0x20
 3c6:	0685                	addi	a3,a3,1
 3c8:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 3ca:	00054783          	lbu	a5,0(a0)
 3ce:	0005c703          	lbu	a4,0(a1)
 3d2:	00e79863          	bne	a5,a4,3e2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 3d6:	0505                	addi	a0,a0,1
    p2++;
 3d8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3da:	fed518e3          	bne	a0,a3,3ca <memcmp+0x14>
  }
  return 0;
 3de:	4501                	li	a0,0
 3e0:	a019                	j	3e6 <memcmp+0x30>
      return *p1 - *p2;
 3e2:	40e7853b          	subw	a0,a5,a4
}
 3e6:	6422                	ld	s0,8(sp)
 3e8:	0141                	addi	sp,sp,16
 3ea:	8082                	ret
  return 0;
 3ec:	4501                	li	a0,0
 3ee:	bfe5                	j	3e6 <memcmp+0x30>

00000000000003f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e406                	sd	ra,8(sp)
 3f4:	e022                	sd	s0,0(sp)
 3f6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3f8:	00000097          	auipc	ra,0x0
 3fc:	f62080e7          	jalr	-158(ra) # 35a <memmove>
}
 400:	60a2                	ld	ra,8(sp)
 402:	6402                	ld	s0,0(sp)
 404:	0141                	addi	sp,sp,16
 406:	8082                	ret

0000000000000408 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 408:	4885                	li	a7,1
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <exit>:
.global exit
exit:
 li a7, SYS_exit
 410:	4889                	li	a7,2
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <wait>:
.global wait
wait:
 li a7, SYS_wait
 418:	488d                	li	a7,3
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 420:	4891                	li	a7,4
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <read>:
.global read
read:
 li a7, SYS_read
 428:	4895                	li	a7,5
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <write>:
.global write
write:
 li a7, SYS_write
 430:	48c1                	li	a7,16
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <close>:
.global close
close:
 li a7, SYS_close
 438:	48d5                	li	a7,21
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <kill>:
.global kill
kill:
 li a7, SYS_kill
 440:	4899                	li	a7,6
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <exec>:
.global exec
exec:
 li a7, SYS_exec
 448:	489d                	li	a7,7
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <open>:
.global open
open:
 li a7, SYS_open
 450:	48bd                	li	a7,15
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 458:	48c5                	li	a7,17
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 460:	48c9                	li	a7,18
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 468:	48a1                	li	a7,8
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <link>:
.global link
link:
 li a7, SYS_link
 470:	48cd                	li	a7,19
 ecall
 472:	00000073          	ecall
 ret
 476:	8082                	ret

0000000000000478 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 478:	48d1                	li	a7,20
 ecall
 47a:	00000073          	ecall
 ret
 47e:	8082                	ret

0000000000000480 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 480:	48a5                	li	a7,9
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <dup>:
.global dup
dup:
 li a7, SYS_dup
 488:	48a9                	li	a7,10
 ecall
 48a:	00000073          	ecall
 ret
 48e:	8082                	ret

0000000000000490 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 490:	48ad                	li	a7,11
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 498:	48b1                	li	a7,12
 ecall
 49a:	00000073          	ecall
 ret
 49e:	8082                	ret

00000000000004a0 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4a0:	48b5                	li	a7,13
 ecall
 4a2:	00000073          	ecall
 ret
 4a6:	8082                	ret

00000000000004a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4a8:	48b9                	li	a7,14
 ecall
 4aa:	00000073          	ecall
 ret
 4ae:	8082                	ret

00000000000004b0 <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 4b0:	48d9                	li	a7,22
 ecall
 4b2:	00000073          	ecall
 ret
 4b6:	8082                	ret

00000000000004b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4b8:	1101                	addi	sp,sp,-32
 4ba:	ec06                	sd	ra,24(sp)
 4bc:	e822                	sd	s0,16(sp)
 4be:	1000                	addi	s0,sp,32
 4c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4c4:	4605                	li	a2,1
 4c6:	fef40593          	addi	a1,s0,-17
 4ca:	00000097          	auipc	ra,0x0
 4ce:	f66080e7          	jalr	-154(ra) # 430 <write>
}
 4d2:	60e2                	ld	ra,24(sp)
 4d4:	6442                	ld	s0,16(sp)
 4d6:	6105                	addi	sp,sp,32
 4d8:	8082                	ret

00000000000004da <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4da:	7139                	addi	sp,sp,-64
 4dc:	fc06                	sd	ra,56(sp)
 4de:	f822                	sd	s0,48(sp)
 4e0:	f426                	sd	s1,40(sp)
 4e2:	f04a                	sd	s2,32(sp)
 4e4:	ec4e                	sd	s3,24(sp)
 4e6:	0080                	addi	s0,sp,64
 4e8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4ea:	c299                	beqz	a3,4f0 <printint+0x16>
 4ec:	0805c863          	bltz	a1,57c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 4f0:	2581                	sext.w	a1,a1
  neg = 0;
 4f2:	4881                	li	a7,0
 4f4:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 4f8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4fa:	2601                	sext.w	a2,a2
 4fc:	00000517          	auipc	a0,0x0
 500:	45450513          	addi	a0,a0,1108 # 950 <digits>
 504:	883a                	mv	a6,a4
 506:	2705                	addiw	a4,a4,1
 508:	02c5f7bb          	remuw	a5,a1,a2
 50c:	1782                	slli	a5,a5,0x20
 50e:	9381                	srli	a5,a5,0x20
 510:	97aa                	add	a5,a5,a0
 512:	0007c783          	lbu	a5,0(a5)
 516:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 51a:	0005879b          	sext.w	a5,a1
 51e:	02c5d5bb          	divuw	a1,a1,a2
 522:	0685                	addi	a3,a3,1
 524:	fec7f0e3          	bgeu	a5,a2,504 <printint+0x2a>
  if(neg)
 528:	00088b63          	beqz	a7,53e <printint+0x64>
    buf[i++] = '-';
 52c:	fd040793          	addi	a5,s0,-48
 530:	973e                	add	a4,a4,a5
 532:	02d00793          	li	a5,45
 536:	fef70823          	sb	a5,-16(a4)
 53a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 53e:	02e05863          	blez	a4,56e <printint+0x94>
 542:	fc040793          	addi	a5,s0,-64
 546:	00e78933          	add	s2,a5,a4
 54a:	fff78993          	addi	s3,a5,-1
 54e:	99ba                	add	s3,s3,a4
 550:	377d                	addiw	a4,a4,-1
 552:	1702                	slli	a4,a4,0x20
 554:	9301                	srli	a4,a4,0x20
 556:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 55a:	fff94583          	lbu	a1,-1(s2)
 55e:	8526                	mv	a0,s1
 560:	00000097          	auipc	ra,0x0
 564:	f58080e7          	jalr	-168(ra) # 4b8 <putc>
  while(--i >= 0)
 568:	197d                	addi	s2,s2,-1
 56a:	ff3918e3          	bne	s2,s3,55a <printint+0x80>
}
 56e:	70e2                	ld	ra,56(sp)
 570:	7442                	ld	s0,48(sp)
 572:	74a2                	ld	s1,40(sp)
 574:	7902                	ld	s2,32(sp)
 576:	69e2                	ld	s3,24(sp)
 578:	6121                	addi	sp,sp,64
 57a:	8082                	ret
    x = -xx;
 57c:	40b005bb          	negw	a1,a1
    neg = 1;
 580:	4885                	li	a7,1
    x = -xx;
 582:	bf8d                	j	4f4 <printint+0x1a>

0000000000000584 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 584:	7119                	addi	sp,sp,-128
 586:	fc86                	sd	ra,120(sp)
 588:	f8a2                	sd	s0,112(sp)
 58a:	f4a6                	sd	s1,104(sp)
 58c:	f0ca                	sd	s2,96(sp)
 58e:	ecce                	sd	s3,88(sp)
 590:	e8d2                	sd	s4,80(sp)
 592:	e4d6                	sd	s5,72(sp)
 594:	e0da                	sd	s6,64(sp)
 596:	fc5e                	sd	s7,56(sp)
 598:	f862                	sd	s8,48(sp)
 59a:	f466                	sd	s9,40(sp)
 59c:	f06a                	sd	s10,32(sp)
 59e:	ec6e                	sd	s11,24(sp)
 5a0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5a2:	0005c903          	lbu	s2,0(a1)
 5a6:	18090f63          	beqz	s2,744 <vprintf+0x1c0>
 5aa:	8aaa                	mv	s5,a0
 5ac:	8b32                	mv	s6,a2
 5ae:	00158493          	addi	s1,a1,1
  state = 0;
 5b2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5b4:	02500a13          	li	s4,37
      if(c == 'd'){
 5b8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5bc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5c0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5c4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5c8:	00000b97          	auipc	s7,0x0
 5cc:	388b8b93          	addi	s7,s7,904 # 950 <digits>
 5d0:	a839                	j	5ee <vprintf+0x6a>
        putc(fd, c);
 5d2:	85ca                	mv	a1,s2
 5d4:	8556                	mv	a0,s5
 5d6:	00000097          	auipc	ra,0x0
 5da:	ee2080e7          	jalr	-286(ra) # 4b8 <putc>
 5de:	a019                	j	5e4 <vprintf+0x60>
    } else if(state == '%'){
 5e0:	01498f63          	beq	s3,s4,5fe <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 5e4:	0485                	addi	s1,s1,1
 5e6:	fff4c903          	lbu	s2,-1(s1)
 5ea:	14090d63          	beqz	s2,744 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 5ee:	0009079b          	sext.w	a5,s2
    if(state == 0){
 5f2:	fe0997e3          	bnez	s3,5e0 <vprintf+0x5c>
      if(c == '%'){
 5f6:	fd479ee3          	bne	a5,s4,5d2 <vprintf+0x4e>
        state = '%';
 5fa:	89be                	mv	s3,a5
 5fc:	b7e5                	j	5e4 <vprintf+0x60>
      if(c == 'd'){
 5fe:	05878063          	beq	a5,s8,63e <vprintf+0xba>
      } else if(c == 'l') {
 602:	05978c63          	beq	a5,s9,65a <vprintf+0xd6>
      } else if(c == 'x') {
 606:	07a78863          	beq	a5,s10,676 <vprintf+0xf2>
      } else if(c == 'p') {
 60a:	09b78463          	beq	a5,s11,692 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 60e:	07300713          	li	a4,115
 612:	0ce78663          	beq	a5,a4,6de <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 616:	06300713          	li	a4,99
 61a:	0ee78e63          	beq	a5,a4,716 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 61e:	11478863          	beq	a5,s4,72e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 622:	85d2                	mv	a1,s4
 624:	8556                	mv	a0,s5
 626:	00000097          	auipc	ra,0x0
 62a:	e92080e7          	jalr	-366(ra) # 4b8 <putc>
        putc(fd, c);
 62e:	85ca                	mv	a1,s2
 630:	8556                	mv	a0,s5
 632:	00000097          	auipc	ra,0x0
 636:	e86080e7          	jalr	-378(ra) # 4b8 <putc>
      }
      state = 0;
 63a:	4981                	li	s3,0
 63c:	b765                	j	5e4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 63e:	008b0913          	addi	s2,s6,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000b2583          	lw	a1,0(s6)
 64a:	8556                	mv	a0,s5
 64c:	00000097          	auipc	ra,0x0
 650:	e8e080e7          	jalr	-370(ra) # 4da <printint>
 654:	8b4a                	mv	s6,s2
      state = 0;
 656:	4981                	li	s3,0
 658:	b771                	j	5e4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	008b0913          	addi	s2,s6,8
 65e:	4681                	li	a3,0
 660:	4629                	li	a2,10
 662:	000b2583          	lw	a1,0(s6)
 666:	8556                	mv	a0,s5
 668:	00000097          	auipc	ra,0x0
 66c:	e72080e7          	jalr	-398(ra) # 4da <printint>
 670:	8b4a                	mv	s6,s2
      state = 0;
 672:	4981                	li	s3,0
 674:	bf85                	j	5e4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 676:	008b0913          	addi	s2,s6,8
 67a:	4681                	li	a3,0
 67c:	4641                	li	a2,16
 67e:	000b2583          	lw	a1,0(s6)
 682:	8556                	mv	a0,s5
 684:	00000097          	auipc	ra,0x0
 688:	e56080e7          	jalr	-426(ra) # 4da <printint>
 68c:	8b4a                	mv	s6,s2
      state = 0;
 68e:	4981                	li	s3,0
 690:	bf91                	j	5e4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 692:	008b0793          	addi	a5,s6,8
 696:	f8f43423          	sd	a5,-120(s0)
 69a:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 69e:	03000593          	li	a1,48
 6a2:	8556                	mv	a0,s5
 6a4:	00000097          	auipc	ra,0x0
 6a8:	e14080e7          	jalr	-492(ra) # 4b8 <putc>
  putc(fd, 'x');
 6ac:	85ea                	mv	a1,s10
 6ae:	8556                	mv	a0,s5
 6b0:	00000097          	auipc	ra,0x0
 6b4:	e08080e7          	jalr	-504(ra) # 4b8 <putc>
 6b8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ba:	03c9d793          	srli	a5,s3,0x3c
 6be:	97de                	add	a5,a5,s7
 6c0:	0007c583          	lbu	a1,0(a5)
 6c4:	8556                	mv	a0,s5
 6c6:	00000097          	auipc	ra,0x0
 6ca:	df2080e7          	jalr	-526(ra) # 4b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ce:	0992                	slli	s3,s3,0x4
 6d0:	397d                	addiw	s2,s2,-1
 6d2:	fe0914e3          	bnez	s2,6ba <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 6d6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b721                	j	5e4 <vprintf+0x60>
        s = va_arg(ap, char*);
 6de:	008b0993          	addi	s3,s6,8
 6e2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 6e6:	02090163          	beqz	s2,708 <vprintf+0x184>
        while(*s != 0){
 6ea:	00094583          	lbu	a1,0(s2)
 6ee:	c9a1                	beqz	a1,73e <vprintf+0x1ba>
          putc(fd, *s);
 6f0:	8556                	mv	a0,s5
 6f2:	00000097          	auipc	ra,0x0
 6f6:	dc6080e7          	jalr	-570(ra) # 4b8 <putc>
          s++;
 6fa:	0905                	addi	s2,s2,1
        while(*s != 0){
 6fc:	00094583          	lbu	a1,0(s2)
 700:	f9e5                	bnez	a1,6f0 <vprintf+0x16c>
        s = va_arg(ap, char*);
 702:	8b4e                	mv	s6,s3
      state = 0;
 704:	4981                	li	s3,0
 706:	bdf9                	j	5e4 <vprintf+0x60>
          s = "(null)";
 708:	00000917          	auipc	s2,0x0
 70c:	24090913          	addi	s2,s2,576 # 948 <malloc+0xfa>
        while(*s != 0){
 710:	02800593          	li	a1,40
 714:	bff1                	j	6f0 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 716:	008b0913          	addi	s2,s6,8
 71a:	000b4583          	lbu	a1,0(s6)
 71e:	8556                	mv	a0,s5
 720:	00000097          	auipc	ra,0x0
 724:	d98080e7          	jalr	-616(ra) # 4b8 <putc>
 728:	8b4a                	mv	s6,s2
      state = 0;
 72a:	4981                	li	s3,0
 72c:	bd65                	j	5e4 <vprintf+0x60>
        putc(fd, c);
 72e:	85d2                	mv	a1,s4
 730:	8556                	mv	a0,s5
 732:	00000097          	auipc	ra,0x0
 736:	d86080e7          	jalr	-634(ra) # 4b8 <putc>
      state = 0;
 73a:	4981                	li	s3,0
 73c:	b565                	j	5e4 <vprintf+0x60>
        s = va_arg(ap, char*);
 73e:	8b4e                	mv	s6,s3
      state = 0;
 740:	4981                	li	s3,0
 742:	b54d                	j	5e4 <vprintf+0x60>
    }
  }
}
 744:	70e6                	ld	ra,120(sp)
 746:	7446                	ld	s0,112(sp)
 748:	74a6                	ld	s1,104(sp)
 74a:	7906                	ld	s2,96(sp)
 74c:	69e6                	ld	s3,88(sp)
 74e:	6a46                	ld	s4,80(sp)
 750:	6aa6                	ld	s5,72(sp)
 752:	6b06                	ld	s6,64(sp)
 754:	7be2                	ld	s7,56(sp)
 756:	7c42                	ld	s8,48(sp)
 758:	7ca2                	ld	s9,40(sp)
 75a:	7d02                	ld	s10,32(sp)
 75c:	6de2                	ld	s11,24(sp)
 75e:	6109                	addi	sp,sp,128
 760:	8082                	ret

0000000000000762 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 762:	715d                	addi	sp,sp,-80
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e010                	sd	a2,0(s0)
 76c:	e414                	sd	a3,8(s0)
 76e:	e818                	sd	a4,16(s0)
 770:	ec1c                	sd	a5,24(s0)
 772:	03043023          	sd	a6,32(s0)
 776:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77e:	8622                	mv	a2,s0
 780:	00000097          	auipc	ra,0x0
 784:	e04080e7          	jalr	-508(ra) # 584 <vprintf>
}
 788:	60e2                	ld	ra,24(sp)
 78a:	6442                	ld	s0,16(sp)
 78c:	6161                	addi	sp,sp,80
 78e:	8082                	ret

0000000000000790 <printf>:

void
printf(const char *fmt, ...)
{
 790:	711d                	addi	sp,sp,-96
 792:	ec06                	sd	ra,24(sp)
 794:	e822                	sd	s0,16(sp)
 796:	1000                	addi	s0,sp,32
 798:	e40c                	sd	a1,8(s0)
 79a:	e810                	sd	a2,16(s0)
 79c:	ec14                	sd	a3,24(s0)
 79e:	f018                	sd	a4,32(s0)
 7a0:	f41c                	sd	a5,40(s0)
 7a2:	03043823          	sd	a6,48(s0)
 7a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7aa:	00840613          	addi	a2,s0,8
 7ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7b2:	85aa                	mv	a1,a0
 7b4:	4505                	li	a0,1
 7b6:	00000097          	auipc	ra,0x0
 7ba:	dce080e7          	jalr	-562(ra) # 584 <vprintf>
}
 7be:	60e2                	ld	ra,24(sp)
 7c0:	6442                	ld	s0,16(sp)
 7c2:	6125                	addi	sp,sp,96
 7c4:	8082                	ret

00000000000007c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7c6:	1141                	addi	sp,sp,-16
 7c8:	e422                	sd	s0,8(sp)
 7ca:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7cc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d0:	00000797          	auipc	a5,0x0
 7d4:	1987b783          	ld	a5,408(a5) # 968 <freep>
 7d8:	a805                	j	808 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 7da:	4618                	lw	a4,8(a2)
 7dc:	9db9                	addw	a1,a1,a4
 7de:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e2:	6398                	ld	a4,0(a5)
 7e4:	6318                	ld	a4,0(a4)
 7e6:	fee53823          	sd	a4,-16(a0)
 7ea:	a091                	j	82e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 7ec:	ff852703          	lw	a4,-8(a0)
 7f0:	9e39                	addw	a2,a2,a4
 7f2:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 7f4:	ff053703          	ld	a4,-16(a0)
 7f8:	e398                	sd	a4,0(a5)
 7fa:	a099                	j	840 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fc:	6398                	ld	a4,0(a5)
 7fe:	00e7e463          	bltu	a5,a4,806 <free+0x40>
 802:	00e6ea63          	bltu	a3,a4,816 <free+0x50>
{
 806:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 808:	fed7fae3          	bgeu	a5,a3,7fc <free+0x36>
 80c:	6398                	ld	a4,0(a5)
 80e:	00e6e463          	bltu	a3,a4,816 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 812:	fee7eae3          	bltu	a5,a4,806 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 816:	ff852583          	lw	a1,-8(a0)
 81a:	6390                	ld	a2,0(a5)
 81c:	02059713          	slli	a4,a1,0x20
 820:	9301                	srli	a4,a4,0x20
 822:	0712                	slli	a4,a4,0x4
 824:	9736                	add	a4,a4,a3
 826:	fae60ae3          	beq	a2,a4,7da <free+0x14>
    bp->s.ptr = p->s.ptr;
 82a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 82e:	4790                	lw	a2,8(a5)
 830:	02061713          	slli	a4,a2,0x20
 834:	9301                	srli	a4,a4,0x20
 836:	0712                	slli	a4,a4,0x4
 838:	973e                	add	a4,a4,a5
 83a:	fae689e3          	beq	a3,a4,7ec <free+0x26>
  } else
    p->s.ptr = bp;
 83e:	e394                	sd	a3,0(a5)
  freep = p;
 840:	00000717          	auipc	a4,0x0
 844:	12f73423          	sd	a5,296(a4) # 968 <freep>
}
 848:	6422                	ld	s0,8(sp)
 84a:	0141                	addi	sp,sp,16
 84c:	8082                	ret

000000000000084e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 84e:	7139                	addi	sp,sp,-64
 850:	fc06                	sd	ra,56(sp)
 852:	f822                	sd	s0,48(sp)
 854:	f426                	sd	s1,40(sp)
 856:	f04a                	sd	s2,32(sp)
 858:	ec4e                	sd	s3,24(sp)
 85a:	e852                	sd	s4,16(sp)
 85c:	e456                	sd	s5,8(sp)
 85e:	e05a                	sd	s6,0(sp)
 860:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 862:	02051493          	slli	s1,a0,0x20
 866:	9081                	srli	s1,s1,0x20
 868:	04bd                	addi	s1,s1,15
 86a:	8091                	srli	s1,s1,0x4
 86c:	0014899b          	addiw	s3,s1,1
 870:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 872:	00000517          	auipc	a0,0x0
 876:	0f653503          	ld	a0,246(a0) # 968 <freep>
 87a:	c515                	beqz	a0,8a6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 87e:	4798                	lw	a4,8(a5)
 880:	02977f63          	bgeu	a4,s1,8be <malloc+0x70>
 884:	8a4e                	mv	s4,s3
 886:	0009871b          	sext.w	a4,s3
 88a:	6685                	lui	a3,0x1
 88c:	00d77363          	bgeu	a4,a3,892 <malloc+0x44>
 890:	6a05                	lui	s4,0x1
 892:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 896:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 89a:	00000917          	auipc	s2,0x0
 89e:	0ce90913          	addi	s2,s2,206 # 968 <freep>
  if(p == (char*)-1)
 8a2:	5afd                	li	s5,-1
 8a4:	a88d                	j	916 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8a6:	00000797          	auipc	a5,0x0
 8aa:	0ca78793          	addi	a5,a5,202 # 970 <base>
 8ae:	00000717          	auipc	a4,0x0
 8b2:	0af73d23          	sd	a5,186(a4) # 968 <freep>
 8b6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8bc:	b7e1                	j	884 <malloc+0x36>
      if(p->s.size == nunits)
 8be:	02e48b63          	beq	s1,a4,8f4 <malloc+0xa6>
        p->s.size -= nunits;
 8c2:	4137073b          	subw	a4,a4,s3
 8c6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c8:	1702                	slli	a4,a4,0x20
 8ca:	9301                	srli	a4,a4,0x20
 8cc:	0712                	slli	a4,a4,0x4
 8ce:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d4:	00000717          	auipc	a4,0x0
 8d8:	08a73a23          	sd	a0,148(a4) # 968 <freep>
      return (void*)(p + 1);
 8dc:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 8e0:	70e2                	ld	ra,56(sp)
 8e2:	7442                	ld	s0,48(sp)
 8e4:	74a2                	ld	s1,40(sp)
 8e6:	7902                	ld	s2,32(sp)
 8e8:	69e2                	ld	s3,24(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
 8f0:	6121                	addi	sp,sp,64
 8f2:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 8f4:	6398                	ld	a4,0(a5)
 8f6:	e118                	sd	a4,0(a0)
 8f8:	bff1                	j	8d4 <malloc+0x86>
  hp->s.size = nu;
 8fa:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8fe:	0541                	addi	a0,a0,16
 900:	00000097          	auipc	ra,0x0
 904:	ec6080e7          	jalr	-314(ra) # 7c6 <free>
  return freep;
 908:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 90c:	d971                	beqz	a0,8e0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	fa9776e3          	bgeu	a4,s1,8be <malloc+0x70>
    if(p == freep)
 916:	00093703          	ld	a4,0(s2)
 91a:	853e                	mv	a0,a5
 91c:	fef719e3          	bne	a4,a5,90e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 920:	8552                	mv	a0,s4
 922:	00000097          	auipc	ra,0x0
 926:	b76080e7          	jalr	-1162(ra) # 498 <sbrk>
  if(p == (char*)-1)
 92a:	fd5518e3          	bne	a0,s5,8fa <malloc+0xac>
        return 0;
 92e:	4501                	li	a0,0
 930:	bf45                	j	8e0 <malloc+0x92>
