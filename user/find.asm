
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find_file>:
		find_file(argv[1],argv[2]);
	}
	exit(status);
}

int find_file(char *dir, char *fname){
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	26913423          	sd	s1,616(sp)
  10:	27213023          	sd	s2,608(sp)
  14:	25313c23          	sd	s3,600(sp)
  18:	25413823          	sd	s4,592(sp)
  1c:	25513423          	sd	s5,584(sp)
  20:	25613023          	sd	s6,576(sp)
  24:	23713c23          	sd	s7,568(sp)
  28:	0500                	addi	s0,sp,640
  2a:	892a                	mv	s2,a0
  2c:	8a2e                	mv	s4,a1
	char buf[512],*p;
	int fd;
	struct dirent de;
	struct stat fst;

	fd=open(dir,0);
  2e:	4581                	li	a1,0
  30:	00000097          	auipc	ra,0x0
  34:	45a080e7          	jalr	1114(ra) # 48a <open>
	//error checking for reading 
	if(fd < 0){
  38:	0e054063          	bltz	a0,118 <find_file+0x118>
  3c:	84aa                	mv	s1,a0
		fprintf(2, "Error opening path\n");
		return 1;
	}
		
	strcpy(buf,dir);
  3e:	85ca                	mv	a1,s2
  40:	db040513          	addi	a0,s0,-592
  44:	00000097          	auipc	ra,0x0
  48:	190080e7          	jalr	400(ra) # 1d4 <strcpy>
	p = buf+strlen(buf);
  4c:	db040513          	addi	a0,s0,-592
  50:	00000097          	auipc	ra,0x0
  54:	1cc080e7          	jalr	460(ra) # 21c <strlen>
  58:	1502                	slli	a0,a0,0x20
  5a:	9101                	srli	a0,a0,0x20
  5c:	db040793          	addi	a5,s0,-592
  60:	953e                	add	a0,a0,a5
    *p++ = '/';
  62:	00150b13          	addi	s6,a0,1
  66:	02f00793          	li	a5,47
  6a:	00f50023          	sb	a5,0(a0)
	while(read(fd,&de,sizeof(de))==sizeof(de)){
			
		if(de.inum==0){
			continue;
		}
		if(!strcmp(de.name,".") || !strcmp(de.name,"..")){
  6e:	da240b93          	addi	s7,s0,-606
  72:	895e                	mv	s2,s7
  74:	00001997          	auipc	s3,0x1
  78:	91498993          	addi	s3,s3,-1772 # 988 <malloc+0x100>
  7c:	00001a97          	auipc	s5,0x1
  80:	914a8a93          	addi	s5,s5,-1772 # 990 <malloc+0x108>
	while(read(fd,&de,sizeof(de))==sizeof(de)){
  84:	4641                	li	a2,16
  86:	da040593          	addi	a1,s0,-608
  8a:	8526                	mv	a0,s1
  8c:	00000097          	auipc	ra,0x0
  90:	3d6080e7          	jalr	982(ra) # 462 <read>
  94:	47c1                	li	a5,16
  96:	0cf51463          	bne	a0,a5,15e <find_file+0x15e>
		if(de.inum==0){
  9a:	da045783          	lhu	a5,-608(s0)
  9e:	d3fd                	beqz	a5,84 <find_file+0x84>
		if(!strcmp(de.name,".") || !strcmp(de.name,"..")){
  a0:	85ce                	mv	a1,s3
  a2:	854a                	mv	a0,s2
  a4:	00000097          	auipc	ra,0x0
  a8:	14c080e7          	jalr	332(ra) # 1f0 <strcmp>
  ac:	dd61                	beqz	a0,84 <find_file+0x84>
  ae:	85d6                	mv	a1,s5
  b0:	854a                	mv	a0,s2
  b2:	00000097          	auipc	ra,0x0
  b6:	13e080e7          	jalr	318(ra) # 1f0 <strcmp>
  ba:	d569                	beqz	a0,84 <find_file+0x84>
			continue;
		}
		memmove(p,de.name,sizeof(de.name));
  bc:	4639                	li	a2,14
  be:	85de                	mv	a1,s7
  c0:	855a                	mv	a0,s6
  c2:	00000097          	auipc	ra,0x0
  c6:	2d2080e7          	jalr	722(ra) # 394 <memmove>
		
		//error checking on checking stats
		if(stat(buf,&fst)<0){
  ca:	d8840593          	addi	a1,s0,-632
  ce:	db040513          	addi	a0,s0,-592
  d2:	00000097          	auipc	ra,0x0
  d6:	232080e7          	jalr	562(ra) # 304 <stat>
  da:	04054a63          	bltz	a0,12e <find_file+0x12e>
			fprintf(2, "Error retrieving file status");
			close(fd);
			return 1;
		}
		switch (fst.type)
  de:	d9041783          	lh	a5,-624(s0)
  e2:	0007869b          	sext.w	a3,a5
  e6:	4705                	li	a4,1
  e8:	06e68363          	beq	a3,a4,14e <find_file+0x14e>
  ec:	4709                	li	a4,2
  ee:	f8e69be3          	bne	a3,a4,84 <find_file+0x84>
		{
		case T_FILE:
			if(strcmp(de.name,fname)==0){
  f2:	85d2                	mv	a1,s4
  f4:	da240513          	addi	a0,s0,-606
  f8:	00000097          	auipc	ra,0x0
  fc:	0f8080e7          	jalr	248(ra) # 1f0 <strcmp>
 100:	f935                	bnez	a0,74 <find_file+0x74>
				printf("%s \n",buf);
 102:	db040593          	addi	a1,s0,-592
 106:	00001517          	auipc	a0,0x1
 10a:	8b250513          	addi	a0,a0,-1870 # 9b8 <malloc+0x130>
 10e:	00000097          	auipc	ra,0x0
 112:	6bc080e7          	jalr	1724(ra) # 7ca <printf>
 116:	bfb9                	j	74 <find_file+0x74>
		fprintf(2, "Error opening path\n");
 118:	00001597          	auipc	a1,0x1
 11c:	85858593          	addi	a1,a1,-1960 # 970 <malloc+0xe8>
 120:	4509                	li	a0,2
 122:	00000097          	auipc	ra,0x0
 126:	67a080e7          	jalr	1658(ra) # 79c <fprintf>
		return 1;
 12a:	4505                	li	a0,1
 12c:	a83d                	j	16a <find_file+0x16a>
			fprintf(2, "Error retrieving file status");
 12e:	00001597          	auipc	a1,0x1
 132:	86a58593          	addi	a1,a1,-1942 # 998 <malloc+0x110>
 136:	4509                	li	a0,2
 138:	00000097          	auipc	ra,0x0
 13c:	664080e7          	jalr	1636(ra) # 79c <fprintf>
			close(fd);
 140:	8526                	mv	a0,s1
 142:	00000097          	auipc	ra,0x0
 146:	330080e7          	jalr	816(ra) # 472 <close>
			return 1;
 14a:	4505                	li	a0,1
 14c:	a839                	j	16a <find_file+0x16a>
			}
			break;
		
		case T_DIR:
			find_file(buf,fname);
 14e:	85d2                	mv	a1,s4
 150:	db040513          	addi	a0,s0,-592
 154:	00000097          	auipc	ra,0x0
 158:	eac080e7          	jalr	-340(ra) # 0 <find_file>
			break;
 15c:	bf21                	j	74 <find_file+0x74>
		}
		
		
	}
	close(fd);
 15e:	8526                	mv	a0,s1
 160:	00000097          	auipc	ra,0x0
 164:	312080e7          	jalr	786(ra) # 472 <close>

	return 0;
 168:	4501                	li	a0,0
}
 16a:	27813083          	ld	ra,632(sp)
 16e:	27013403          	ld	s0,624(sp)
 172:	26813483          	ld	s1,616(sp)
 176:	26013903          	ld	s2,608(sp)
 17a:	25813983          	ld	s3,600(sp)
 17e:	25013a03          	ld	s4,592(sp)
 182:	24813a83          	ld	s5,584(sp)
 186:	24013b03          	ld	s6,576(sp)
 18a:	23813b83          	ld	s7,568(sp)
 18e:	28010113          	addi	sp,sp,640
 192:	8082                	ret

0000000000000194 <main>:
int main(int argc, char *argv[]){
 194:	1141                	addi	sp,sp,-16
 196:	e406                	sd	ra,8(sp)
 198:	e022                	sd	s0,0(sp)
 19a:	0800                	addi	s0,sp,16
	if(argc!=3){
 19c:	470d                	li	a4,3
 19e:	00e50f63          	beq	a0,a4,1bc <main+0x28>
		printf("usage: <directory> <filename>\n");
 1a2:	00001517          	auipc	a0,0x1
 1a6:	81e50513          	addi	a0,a0,-2018 # 9c0 <malloc+0x138>
 1aa:	00000097          	auipc	ra,0x0
 1ae:	620080e7          	jalr	1568(ra) # 7ca <printf>
		exit(status);
 1b2:	557d                	li	a0,-1
 1b4:	00000097          	auipc	ra,0x0
 1b8:	296080e7          	jalr	662(ra) # 44a <exit>
 1bc:	87ae                	mv	a5,a1
		find_file(argv[1],argv[2]);
 1be:	698c                	ld	a1,16(a1)
 1c0:	6788                	ld	a0,8(a5)
 1c2:	00000097          	auipc	ra,0x0
 1c6:	e3e080e7          	jalr	-450(ra) # 0 <find_file>
	exit(status);
 1ca:	557d                	li	a0,-1
 1cc:	00000097          	auipc	ra,0x0
 1d0:	27e080e7          	jalr	638(ra) # 44a <exit>

00000000000001d4 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
 1d4:	1141                	addi	sp,sp,-16
 1d6:	e422                	sd	s0,8(sp)
 1d8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1da:	87aa                	mv	a5,a0
 1dc:	0585                	addi	a1,a1,1
 1de:	0785                	addi	a5,a5,1
 1e0:	fff5c703          	lbu	a4,-1(a1)
 1e4:	fee78fa3          	sb	a4,-1(a5)
 1e8:	fb75                	bnez	a4,1dc <strcpy+0x8>
    ;
  return os;
}
 1ea:	6422                	ld	s0,8(sp)
 1ec:	0141                	addi	sp,sp,16
 1ee:	8082                	ret

00000000000001f0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1f0:	1141                	addi	sp,sp,-16
 1f2:	e422                	sd	s0,8(sp)
 1f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cb91                	beqz	a5,20e <strcmp+0x1e>
 1fc:	0005c703          	lbu	a4,0(a1)
 200:	00f71763          	bne	a4,a5,20e <strcmp+0x1e>
    p++, q++;
 204:	0505                	addi	a0,a0,1
 206:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbe5                	bnez	a5,1fc <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
 20e:	0005c503          	lbu	a0,0(a1)
}
 212:	40a7853b          	subw	a0,a5,a0
 216:	6422                	ld	s0,8(sp)
 218:	0141                	addi	sp,sp,16
 21a:	8082                	ret

000000000000021c <strlen>:

uint
strlen(const char *s)
{
 21c:	1141                	addi	sp,sp,-16
 21e:	e422                	sd	s0,8(sp)
 220:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 222:	00054783          	lbu	a5,0(a0)
 226:	cf91                	beqz	a5,242 <strlen+0x26>
 228:	0505                	addi	a0,a0,1
 22a:	87aa                	mv	a5,a0
 22c:	4685                	li	a3,1
 22e:	9e89                	subw	a3,a3,a0
 230:	00f6853b          	addw	a0,a3,a5
 234:	0785                	addi	a5,a5,1
 236:	fff7c703          	lbu	a4,-1(a5)
 23a:	fb7d                	bnez	a4,230 <strlen+0x14>
    ;
  return n;
}
 23c:	6422                	ld	s0,8(sp)
 23e:	0141                	addi	sp,sp,16
 240:	8082                	ret
  for(n = 0; s[n]; n++)
 242:	4501                	li	a0,0
 244:	bfe5                	j	23c <strlen+0x20>

0000000000000246 <memset>:

void*
memset(void *dst, int c, uint n)
{
 246:	1141                	addi	sp,sp,-16
 248:	e422                	sd	s0,8(sp)
 24a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 24c:	ce09                	beqz	a2,266 <memset+0x20>
 24e:	87aa                	mv	a5,a0
 250:	fff6071b          	addiw	a4,a2,-1
 254:	1702                	slli	a4,a4,0x20
 256:	9301                	srli	a4,a4,0x20
 258:	0705                	addi	a4,a4,1
 25a:	972a                	add	a4,a4,a0
    cdst[i] = c;
 25c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 260:	0785                	addi	a5,a5,1
 262:	fee79de3          	bne	a5,a4,25c <memset+0x16>
  }
  return dst;
}
 266:	6422                	ld	s0,8(sp)
 268:	0141                	addi	sp,sp,16
 26a:	8082                	ret

000000000000026c <strchr>:

char*
strchr(const char *s, char c)
{
 26c:	1141                	addi	sp,sp,-16
 26e:	e422                	sd	s0,8(sp)
 270:	0800                	addi	s0,sp,16
  for(; *s; s++)
 272:	00054783          	lbu	a5,0(a0)
 276:	cb99                	beqz	a5,28c <strchr+0x20>
    if(*s == c)
 278:	00f58763          	beq	a1,a5,286 <strchr+0x1a>
  for(; *s; s++)
 27c:	0505                	addi	a0,a0,1
 27e:	00054783          	lbu	a5,0(a0)
 282:	fbfd                	bnez	a5,278 <strchr+0xc>
      return (char*)s;
  return 0;
 284:	4501                	li	a0,0
}
 286:	6422                	ld	s0,8(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
  return 0;
 28c:	4501                	li	a0,0
 28e:	bfe5                	j	286 <strchr+0x1a>

0000000000000290 <gets>:

char*
gets(char *buf, int max)
{
 290:	711d                	addi	sp,sp,-96
 292:	ec86                	sd	ra,88(sp)
 294:	e8a2                	sd	s0,80(sp)
 296:	e4a6                	sd	s1,72(sp)
 298:	e0ca                	sd	s2,64(sp)
 29a:	fc4e                	sd	s3,56(sp)
 29c:	f852                	sd	s4,48(sp)
 29e:	f456                	sd	s5,40(sp)
 2a0:	f05a                	sd	s6,32(sp)
 2a2:	ec5e                	sd	s7,24(sp)
 2a4:	1080                	addi	s0,sp,96
 2a6:	8baa                	mv	s7,a0
 2a8:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2aa:	892a                	mv	s2,a0
 2ac:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
 2ae:	4aa9                	li	s5,10
 2b0:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
 2b2:	89a6                	mv	s3,s1
 2b4:	2485                	addiw	s1,s1,1
 2b6:	0344d863          	bge	s1,s4,2e6 <gets+0x56>
    cc = read(0, &c, 1);
 2ba:	4605                	li	a2,1
 2bc:	faf40593          	addi	a1,s0,-81
 2c0:	4501                	li	a0,0
 2c2:	00000097          	auipc	ra,0x0
 2c6:	1a0080e7          	jalr	416(ra) # 462 <read>
    if(cc < 1)
 2ca:	00a05e63          	blez	a0,2e6 <gets+0x56>
    buf[i++] = c;
 2ce:	faf44783          	lbu	a5,-81(s0)
 2d2:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2d6:	01578763          	beq	a5,s5,2e4 <gets+0x54>
 2da:	0905                	addi	s2,s2,1
 2dc:	fd679be3          	bne	a5,s6,2b2 <gets+0x22>
  for(i=0; i+1 < max; ){
 2e0:	89a6                	mv	s3,s1
 2e2:	a011                	j	2e6 <gets+0x56>
 2e4:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
 2e6:	99de                	add	s3,s3,s7
 2e8:	00098023          	sb	zero,0(s3)
  return buf;
}
 2ec:	855e                	mv	a0,s7
 2ee:	60e6                	ld	ra,88(sp)
 2f0:	6446                	ld	s0,80(sp)
 2f2:	64a6                	ld	s1,72(sp)
 2f4:	6906                	ld	s2,64(sp)
 2f6:	79e2                	ld	s3,56(sp)
 2f8:	7a42                	ld	s4,48(sp)
 2fa:	7aa2                	ld	s5,40(sp)
 2fc:	7b02                	ld	s6,32(sp)
 2fe:	6be2                	ld	s7,24(sp)
 300:	6125                	addi	sp,sp,96
 302:	8082                	ret

0000000000000304 <stat>:

int
stat(const char *n, struct stat *st)
{
 304:	1101                	addi	sp,sp,-32
 306:	ec06                	sd	ra,24(sp)
 308:	e822                	sd	s0,16(sp)
 30a:	e426                	sd	s1,8(sp)
 30c:	e04a                	sd	s2,0(sp)
 30e:	1000                	addi	s0,sp,32
 310:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 312:	4581                	li	a1,0
 314:	00000097          	auipc	ra,0x0
 318:	176080e7          	jalr	374(ra) # 48a <open>
  if(fd < 0)
 31c:	02054563          	bltz	a0,346 <stat+0x42>
 320:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 322:	85ca                	mv	a1,s2
 324:	00000097          	auipc	ra,0x0
 328:	17e080e7          	jalr	382(ra) # 4a2 <fstat>
 32c:	892a                	mv	s2,a0
  close(fd);
 32e:	8526                	mv	a0,s1
 330:	00000097          	auipc	ra,0x0
 334:	142080e7          	jalr	322(ra) # 472 <close>
  return r;
}
 338:	854a                	mv	a0,s2
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	64a2                	ld	s1,8(sp)
 340:	6902                	ld	s2,0(sp)
 342:	6105                	addi	sp,sp,32
 344:	8082                	ret
    return -1;
 346:	597d                	li	s2,-1
 348:	bfc5                	j	338 <stat+0x34>

000000000000034a <atoi>:

int
atoi(const char *s)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e422                	sd	s0,8(sp)
 34e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 350:	00054603          	lbu	a2,0(a0)
 354:	fd06079b          	addiw	a5,a2,-48
 358:	0ff7f793          	andi	a5,a5,255
 35c:	4725                	li	a4,9
 35e:	02f76963          	bltu	a4,a5,390 <atoi+0x46>
 362:	86aa                	mv	a3,a0
  n = 0;
 364:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
 366:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
 368:	0685                	addi	a3,a3,1
 36a:	0025179b          	slliw	a5,a0,0x2
 36e:	9fa9                	addw	a5,a5,a0
 370:	0017979b          	slliw	a5,a5,0x1
 374:	9fb1                	addw	a5,a5,a2
 376:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37a:	0006c603          	lbu	a2,0(a3)
 37e:	fd06071b          	addiw	a4,a2,-48
 382:	0ff77713          	andi	a4,a4,255
 386:	fee5f1e3          	bgeu	a1,a4,368 <atoi+0x1e>
  return n;
}
 38a:	6422                	ld	s0,8(sp)
 38c:	0141                	addi	sp,sp,16
 38e:	8082                	ret
  n = 0;
 390:	4501                	li	a0,0
 392:	bfe5                	j	38a <atoi+0x40>

0000000000000394 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 394:	1141                	addi	sp,sp,-16
 396:	e422                	sd	s0,8(sp)
 398:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39a:	02b57663          	bgeu	a0,a1,3c6 <memmove+0x32>
    while(n-- > 0)
 39e:	02c05163          	blez	a2,3c0 <memmove+0x2c>
 3a2:	fff6079b          	addiw	a5,a2,-1
 3a6:	1782                	slli	a5,a5,0x20
 3a8:	9381                	srli	a5,a5,0x20
 3aa:	0785                	addi	a5,a5,1
 3ac:	97aa                	add	a5,a5,a0
  dst = vdst;
 3ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b0:	0585                	addi	a1,a1,1
 3b2:	0705                	addi	a4,a4,1
 3b4:	fff5c683          	lbu	a3,-1(a1)
 3b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3bc:	fee79ae3          	bne	a5,a4,3b0 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c0:	6422                	ld	s0,8(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
    dst += n;
 3c6:	00c50733          	add	a4,a0,a2
    src += n;
 3ca:	95b2                	add	a1,a1,a2
    while(n-- > 0)
 3cc:	fec05ae3          	blez	a2,3c0 <memmove+0x2c>
 3d0:	fff6079b          	addiw	a5,a2,-1
 3d4:	1782                	slli	a5,a5,0x20
 3d6:	9381                	srli	a5,a5,0x20
 3d8:	fff7c793          	not	a5,a5
 3dc:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3de:	15fd                	addi	a1,a1,-1
 3e0:	177d                	addi	a4,a4,-1
 3e2:	0005c683          	lbu	a3,0(a1)
 3e6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ea:	fee79ae3          	bne	a5,a4,3de <memmove+0x4a>
 3ee:	bfc9                	j	3c0 <memmove+0x2c>

00000000000003f0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f0:	1141                	addi	sp,sp,-16
 3f2:	e422                	sd	s0,8(sp)
 3f4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3f6:	ca05                	beqz	a2,426 <memcmp+0x36>
 3f8:	fff6069b          	addiw	a3,a2,-1
 3fc:	1682                	slli	a3,a3,0x20
 3fe:	9281                	srli	a3,a3,0x20
 400:	0685                	addi	a3,a3,1
 402:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
 404:	00054783          	lbu	a5,0(a0)
 408:	0005c703          	lbu	a4,0(a1)
 40c:	00e79863          	bne	a5,a4,41c <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
 410:	0505                	addi	a0,a0,1
    p2++;
 412:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 414:	fed518e3          	bne	a0,a3,404 <memcmp+0x14>
  }
  return 0;
 418:	4501                	li	a0,0
 41a:	a019                	j	420 <memcmp+0x30>
      return *p1 - *p2;
 41c:	40e7853b          	subw	a0,a5,a4
}
 420:	6422                	ld	s0,8(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
  return 0;
 426:	4501                	li	a0,0
 428:	bfe5                	j	420 <memcmp+0x30>

000000000000042a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42a:	1141                	addi	sp,sp,-16
 42c:	e406                	sd	ra,8(sp)
 42e:	e022                	sd	s0,0(sp)
 430:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 432:	00000097          	auipc	ra,0x0
 436:	f62080e7          	jalr	-158(ra) # 394 <memmove>
}
 43a:	60a2                	ld	ra,8(sp)
 43c:	6402                	ld	s0,0(sp)
 43e:	0141                	addi	sp,sp,16
 440:	8082                	ret

0000000000000442 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 442:	4885                	li	a7,1
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exit>:
.global exit
exit:
 li a7, SYS_exit
 44a:	4889                	li	a7,2
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <wait>:
.global wait
wait:
 li a7, SYS_wait
 452:	488d                	li	a7,3
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 45a:	4891                	li	a7,4
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <read>:
.global read
read:
 li a7, SYS_read
 462:	4895                	li	a7,5
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <write>:
.global write
write:
 li a7, SYS_write
 46a:	48c1                	li	a7,16
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <close>:
.global close
close:
 li a7, SYS_close
 472:	48d5                	li	a7,21
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <kill>:
.global kill
kill:
 li a7, SYS_kill
 47a:	4899                	li	a7,6
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <exec>:
.global exec
exec:
 li a7, SYS_exec
 482:	489d                	li	a7,7
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <open>:
.global open
open:
 li a7, SYS_open
 48a:	48bd                	li	a7,15
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 492:	48c5                	li	a7,17
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 49a:	48c9                	li	a7,18
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4a2:	48a1                	li	a7,8
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <link>:
.global link
link:
 li a7, SYS_link
 4aa:	48cd                	li	a7,19
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4b2:	48d1                	li	a7,20
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4ba:	48a5                	li	a7,9
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 4c2:	48a9                	li	a7,10
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4ca:	48ad                	li	a7,11
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
 4d2:	48b1                	li	a7,12
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
 4da:	48b5                	li	a7,13
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4e2:	48b9                	li	a7,14
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
 4ea:	48d9                	li	a7,22
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4f2:	1101                	addi	sp,sp,-32
 4f4:	ec06                	sd	ra,24(sp)
 4f6:	e822                	sd	s0,16(sp)
 4f8:	1000                	addi	s0,sp,32
 4fa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4fe:	4605                	li	a2,1
 500:	fef40593          	addi	a1,s0,-17
 504:	00000097          	auipc	ra,0x0
 508:	f66080e7          	jalr	-154(ra) # 46a <write>
}
 50c:	60e2                	ld	ra,24(sp)
 50e:	6442                	ld	s0,16(sp)
 510:	6105                	addi	sp,sp,32
 512:	8082                	ret

0000000000000514 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 514:	7139                	addi	sp,sp,-64
 516:	fc06                	sd	ra,56(sp)
 518:	f822                	sd	s0,48(sp)
 51a:	f426                	sd	s1,40(sp)
 51c:	f04a                	sd	s2,32(sp)
 51e:	ec4e                	sd	s3,24(sp)
 520:	0080                	addi	s0,sp,64
 522:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 524:	c299                	beqz	a3,52a <printint+0x16>
 526:	0805c863          	bltz	a1,5b6 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 52a:	2581                	sext.w	a1,a1
  neg = 0;
 52c:	4881                	li	a7,0
 52e:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
 532:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 534:	2601                	sext.w	a2,a2
 536:	00000517          	auipc	a0,0x0
 53a:	4b250513          	addi	a0,a0,1202 # 9e8 <digits>
 53e:	883a                	mv	a6,a4
 540:	2705                	addiw	a4,a4,1
 542:	02c5f7bb          	remuw	a5,a1,a2
 546:	1782                	slli	a5,a5,0x20
 548:	9381                	srli	a5,a5,0x20
 54a:	97aa                	add	a5,a5,a0
 54c:	0007c783          	lbu	a5,0(a5)
 550:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 554:	0005879b          	sext.w	a5,a1
 558:	02c5d5bb          	divuw	a1,a1,a2
 55c:	0685                	addi	a3,a3,1
 55e:	fec7f0e3          	bgeu	a5,a2,53e <printint+0x2a>
  if(neg)
 562:	00088b63          	beqz	a7,578 <printint+0x64>
    buf[i++] = '-';
 566:	fd040793          	addi	a5,s0,-48
 56a:	973e                	add	a4,a4,a5
 56c:	02d00793          	li	a5,45
 570:	fef70823          	sb	a5,-16(a4)
 574:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
 578:	02e05863          	blez	a4,5a8 <printint+0x94>
 57c:	fc040793          	addi	a5,s0,-64
 580:	00e78933          	add	s2,a5,a4
 584:	fff78993          	addi	s3,a5,-1
 588:	99ba                	add	s3,s3,a4
 58a:	377d                	addiw	a4,a4,-1
 58c:	1702                	slli	a4,a4,0x20
 58e:	9301                	srli	a4,a4,0x20
 590:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 594:	fff94583          	lbu	a1,-1(s2)
 598:	8526                	mv	a0,s1
 59a:	00000097          	auipc	ra,0x0
 59e:	f58080e7          	jalr	-168(ra) # 4f2 <putc>
  while(--i >= 0)
 5a2:	197d                	addi	s2,s2,-1
 5a4:	ff3918e3          	bne	s2,s3,594 <printint+0x80>
}
 5a8:	70e2                	ld	ra,56(sp)
 5aa:	7442                	ld	s0,48(sp)
 5ac:	74a2                	ld	s1,40(sp)
 5ae:	7902                	ld	s2,32(sp)
 5b0:	69e2                	ld	s3,24(sp)
 5b2:	6121                	addi	sp,sp,64
 5b4:	8082                	ret
    x = -xx;
 5b6:	40b005bb          	negw	a1,a1
    neg = 1;
 5ba:	4885                	li	a7,1
    x = -xx;
 5bc:	bf8d                	j	52e <printint+0x1a>

00000000000005be <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5be:	7119                	addi	sp,sp,-128
 5c0:	fc86                	sd	ra,120(sp)
 5c2:	f8a2                	sd	s0,112(sp)
 5c4:	f4a6                	sd	s1,104(sp)
 5c6:	f0ca                	sd	s2,96(sp)
 5c8:	ecce                	sd	s3,88(sp)
 5ca:	e8d2                	sd	s4,80(sp)
 5cc:	e4d6                	sd	s5,72(sp)
 5ce:	e0da                	sd	s6,64(sp)
 5d0:	fc5e                	sd	s7,56(sp)
 5d2:	f862                	sd	s8,48(sp)
 5d4:	f466                	sd	s9,40(sp)
 5d6:	f06a                	sd	s10,32(sp)
 5d8:	ec6e                	sd	s11,24(sp)
 5da:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5dc:	0005c903          	lbu	s2,0(a1)
 5e0:	18090f63          	beqz	s2,77e <vprintf+0x1c0>
 5e4:	8aaa                	mv	s5,a0
 5e6:	8b32                	mv	s6,a2
 5e8:	00158493          	addi	s1,a1,1
  state = 0;
 5ec:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 5ee:	02500a13          	li	s4,37
      if(c == 'd'){
 5f2:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
 5f6:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
 5fa:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
 5fe:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 602:	00000b97          	auipc	s7,0x0
 606:	3e6b8b93          	addi	s7,s7,998 # 9e8 <digits>
 60a:	a839                	j	628 <vprintf+0x6a>
        putc(fd, c);
 60c:	85ca                	mv	a1,s2
 60e:	8556                	mv	a0,s5
 610:	00000097          	auipc	ra,0x0
 614:	ee2080e7          	jalr	-286(ra) # 4f2 <putc>
 618:	a019                	j	61e <vprintf+0x60>
    } else if(state == '%'){
 61a:	01498f63          	beq	s3,s4,638 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
 61e:	0485                	addi	s1,s1,1
 620:	fff4c903          	lbu	s2,-1(s1)
 624:	14090d63          	beqz	s2,77e <vprintf+0x1c0>
    c = fmt[i] & 0xff;
 628:	0009079b          	sext.w	a5,s2
    if(state == 0){
 62c:	fe0997e3          	bnez	s3,61a <vprintf+0x5c>
      if(c == '%'){
 630:	fd479ee3          	bne	a5,s4,60c <vprintf+0x4e>
        state = '%';
 634:	89be                	mv	s3,a5
 636:	b7e5                	j	61e <vprintf+0x60>
      if(c == 'd'){
 638:	05878063          	beq	a5,s8,678 <vprintf+0xba>
      } else if(c == 'l') {
 63c:	05978c63          	beq	a5,s9,694 <vprintf+0xd6>
      } else if(c == 'x') {
 640:	07a78863          	beq	a5,s10,6b0 <vprintf+0xf2>
      } else if(c == 'p') {
 644:	09b78463          	beq	a5,s11,6cc <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
 648:	07300713          	li	a4,115
 64c:	0ce78663          	beq	a5,a4,718 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 650:	06300713          	li	a4,99
 654:	0ee78e63          	beq	a5,a4,750 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
 658:	11478863          	beq	a5,s4,768 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 65c:	85d2                	mv	a1,s4
 65e:	8556                	mv	a0,s5
 660:	00000097          	auipc	ra,0x0
 664:	e92080e7          	jalr	-366(ra) # 4f2 <putc>
        putc(fd, c);
 668:	85ca                	mv	a1,s2
 66a:	8556                	mv	a0,s5
 66c:	00000097          	auipc	ra,0x0
 670:	e86080e7          	jalr	-378(ra) # 4f2 <putc>
      }
      state = 0;
 674:	4981                	li	s3,0
 676:	b765                	j	61e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
 678:	008b0913          	addi	s2,s6,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000b2583          	lw	a1,0(s6)
 684:	8556                	mv	a0,s5
 686:	00000097          	auipc	ra,0x0
 68a:	e8e080e7          	jalr	-370(ra) # 514 <printint>
 68e:	8b4a                	mv	s6,s2
      state = 0;
 690:	4981                	li	s3,0
 692:	b771                	j	61e <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
 694:	008b0913          	addi	s2,s6,8
 698:	4681                	li	a3,0
 69a:	4629                	li	a2,10
 69c:	000b2583          	lw	a1,0(s6)
 6a0:	8556                	mv	a0,s5
 6a2:	00000097          	auipc	ra,0x0
 6a6:	e72080e7          	jalr	-398(ra) # 514 <printint>
 6aa:	8b4a                	mv	s6,s2
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bf85                	j	61e <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
 6b0:	008b0913          	addi	s2,s6,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000b2583          	lw	a1,0(s6)
 6bc:	8556                	mv	a0,s5
 6be:	00000097          	auipc	ra,0x0
 6c2:	e56080e7          	jalr	-426(ra) # 514 <printint>
 6c6:	8b4a                	mv	s6,s2
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	bf91                	j	61e <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
 6cc:	008b0793          	addi	a5,s6,8
 6d0:	f8f43423          	sd	a5,-120(s0)
 6d4:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
 6d8:	03000593          	li	a1,48
 6dc:	8556                	mv	a0,s5
 6de:	00000097          	auipc	ra,0x0
 6e2:	e14080e7          	jalr	-492(ra) # 4f2 <putc>
  putc(fd, 'x');
 6e6:	85ea                	mv	a1,s10
 6e8:	8556                	mv	a0,s5
 6ea:	00000097          	auipc	ra,0x0
 6ee:	e08080e7          	jalr	-504(ra) # 4f2 <putc>
 6f2:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6f4:	03c9d793          	srli	a5,s3,0x3c
 6f8:	97de                	add	a5,a5,s7
 6fa:	0007c583          	lbu	a1,0(a5)
 6fe:	8556                	mv	a0,s5
 700:	00000097          	auipc	ra,0x0
 704:	df2080e7          	jalr	-526(ra) # 4f2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 708:	0992                	slli	s3,s3,0x4
 70a:	397d                	addiw	s2,s2,-1
 70c:	fe0914e3          	bnez	s2,6f4 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
 710:	f8843b03          	ld	s6,-120(s0)
      state = 0;
 714:	4981                	li	s3,0
 716:	b721                	j	61e <vprintf+0x60>
        s = va_arg(ap, char*);
 718:	008b0993          	addi	s3,s6,8
 71c:	000b3903          	ld	s2,0(s6)
        if(s == 0)
 720:	02090163          	beqz	s2,742 <vprintf+0x184>
        while(*s != 0){
 724:	00094583          	lbu	a1,0(s2)
 728:	c9a1                	beqz	a1,778 <vprintf+0x1ba>
          putc(fd, *s);
 72a:	8556                	mv	a0,s5
 72c:	00000097          	auipc	ra,0x0
 730:	dc6080e7          	jalr	-570(ra) # 4f2 <putc>
          s++;
 734:	0905                	addi	s2,s2,1
        while(*s != 0){
 736:	00094583          	lbu	a1,0(s2)
 73a:	f9e5                	bnez	a1,72a <vprintf+0x16c>
        s = va_arg(ap, char*);
 73c:	8b4e                	mv	s6,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	bdf9                	j	61e <vprintf+0x60>
          s = "(null)";
 742:	00000917          	auipc	s2,0x0
 746:	29e90913          	addi	s2,s2,670 # 9e0 <malloc+0x158>
        while(*s != 0){
 74a:	02800593          	li	a1,40
 74e:	bff1                	j	72a <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
 750:	008b0913          	addi	s2,s6,8
 754:	000b4583          	lbu	a1,0(s6)
 758:	8556                	mv	a0,s5
 75a:	00000097          	auipc	ra,0x0
 75e:	d98080e7          	jalr	-616(ra) # 4f2 <putc>
 762:	8b4a                	mv	s6,s2
      state = 0;
 764:	4981                	li	s3,0
 766:	bd65                	j	61e <vprintf+0x60>
        putc(fd, c);
 768:	85d2                	mv	a1,s4
 76a:	8556                	mv	a0,s5
 76c:	00000097          	auipc	ra,0x0
 770:	d86080e7          	jalr	-634(ra) # 4f2 <putc>
      state = 0;
 774:	4981                	li	s3,0
 776:	b565                	j	61e <vprintf+0x60>
        s = va_arg(ap, char*);
 778:	8b4e                	mv	s6,s3
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b54d                	j	61e <vprintf+0x60>
    }
  }
}
 77e:	70e6                	ld	ra,120(sp)
 780:	7446                	ld	s0,112(sp)
 782:	74a6                	ld	s1,104(sp)
 784:	7906                	ld	s2,96(sp)
 786:	69e6                	ld	s3,88(sp)
 788:	6a46                	ld	s4,80(sp)
 78a:	6aa6                	ld	s5,72(sp)
 78c:	6b06                	ld	s6,64(sp)
 78e:	7be2                	ld	s7,56(sp)
 790:	7c42                	ld	s8,48(sp)
 792:	7ca2                	ld	s9,40(sp)
 794:	7d02                	ld	s10,32(sp)
 796:	6de2                	ld	s11,24(sp)
 798:	6109                	addi	sp,sp,128
 79a:	8082                	ret

000000000000079c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 79c:	715d                	addi	sp,sp,-80
 79e:	ec06                	sd	ra,24(sp)
 7a0:	e822                	sd	s0,16(sp)
 7a2:	1000                	addi	s0,sp,32
 7a4:	e010                	sd	a2,0(s0)
 7a6:	e414                	sd	a3,8(s0)
 7a8:	e818                	sd	a4,16(s0)
 7aa:	ec1c                	sd	a5,24(s0)
 7ac:	03043023          	sd	a6,32(s0)
 7b0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7b4:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7b8:	8622                	mv	a2,s0
 7ba:	00000097          	auipc	ra,0x0
 7be:	e04080e7          	jalr	-508(ra) # 5be <vprintf>
}
 7c2:	60e2                	ld	ra,24(sp)
 7c4:	6442                	ld	s0,16(sp)
 7c6:	6161                	addi	sp,sp,80
 7c8:	8082                	ret

00000000000007ca <printf>:

void
printf(const char *fmt, ...)
{
 7ca:	711d                	addi	sp,sp,-96
 7cc:	ec06                	sd	ra,24(sp)
 7ce:	e822                	sd	s0,16(sp)
 7d0:	1000                	addi	s0,sp,32
 7d2:	e40c                	sd	a1,8(s0)
 7d4:	e810                	sd	a2,16(s0)
 7d6:	ec14                	sd	a3,24(s0)
 7d8:	f018                	sd	a4,32(s0)
 7da:	f41c                	sd	a5,40(s0)
 7dc:	03043823          	sd	a6,48(s0)
 7e0:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7e4:	00840613          	addi	a2,s0,8
 7e8:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ec:	85aa                	mv	a1,a0
 7ee:	4505                	li	a0,1
 7f0:	00000097          	auipc	ra,0x0
 7f4:	dce080e7          	jalr	-562(ra) # 5be <vprintf>
}
 7f8:	60e2                	ld	ra,24(sp)
 7fa:	6442                	ld	s0,16(sp)
 7fc:	6125                	addi	sp,sp,96
 7fe:	8082                	ret

0000000000000800 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 800:	1141                	addi	sp,sp,-16
 802:	e422                	sd	s0,8(sp)
 804:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 806:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 80a:	00000797          	auipc	a5,0x0
 80e:	1f67b783          	ld	a5,502(a5) # a00 <freep>
 812:	a805                	j	842 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 814:	4618                	lw	a4,8(a2)
 816:	9db9                	addw	a1,a1,a4
 818:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 81c:	6398                	ld	a4,0(a5)
 81e:	6318                	ld	a4,0(a4)
 820:	fee53823          	sd	a4,-16(a0)
 824:	a091                	j	868 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 826:	ff852703          	lw	a4,-8(a0)
 82a:	9e39                	addw	a2,a2,a4
 82c:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
 82e:	ff053703          	ld	a4,-16(a0)
 832:	e398                	sd	a4,0(a5)
 834:	a099                	j	87a <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 836:	6398                	ld	a4,0(a5)
 838:	00e7e463          	bltu	a5,a4,840 <free+0x40>
 83c:	00e6ea63          	bltu	a3,a4,850 <free+0x50>
{
 840:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 842:	fed7fae3          	bgeu	a5,a3,836 <free+0x36>
 846:	6398                	ld	a4,0(a5)
 848:	00e6e463          	bltu	a3,a4,850 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84c:	fee7eae3          	bltu	a5,a4,840 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
 850:	ff852583          	lw	a1,-8(a0)
 854:	6390                	ld	a2,0(a5)
 856:	02059713          	slli	a4,a1,0x20
 85a:	9301                	srli	a4,a4,0x20
 85c:	0712                	slli	a4,a4,0x4
 85e:	9736                	add	a4,a4,a3
 860:	fae60ae3          	beq	a2,a4,814 <free+0x14>
    bp->s.ptr = p->s.ptr;
 864:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
 868:	4790                	lw	a2,8(a5)
 86a:	02061713          	slli	a4,a2,0x20
 86e:	9301                	srli	a4,a4,0x20
 870:	0712                	slli	a4,a4,0x4
 872:	973e                	add	a4,a4,a5
 874:	fae689e3          	beq	a3,a4,826 <free+0x26>
  } else
    p->s.ptr = bp;
 878:	e394                	sd	a3,0(a5)
  freep = p;
 87a:	00000717          	auipc	a4,0x0
 87e:	18f73323          	sd	a5,390(a4) # a00 <freep>
}
 882:	6422                	ld	s0,8(sp)
 884:	0141                	addi	sp,sp,16
 886:	8082                	ret

0000000000000888 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 888:	7139                	addi	sp,sp,-64
 88a:	fc06                	sd	ra,56(sp)
 88c:	f822                	sd	s0,48(sp)
 88e:	f426                	sd	s1,40(sp)
 890:	f04a                	sd	s2,32(sp)
 892:	ec4e                	sd	s3,24(sp)
 894:	e852                	sd	s4,16(sp)
 896:	e456                	sd	s5,8(sp)
 898:	e05a                	sd	s6,0(sp)
 89a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 89c:	02051493          	slli	s1,a0,0x20
 8a0:	9081                	srli	s1,s1,0x20
 8a2:	04bd                	addi	s1,s1,15
 8a4:	8091                	srli	s1,s1,0x4
 8a6:	0014899b          	addiw	s3,s1,1
 8aa:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
 8ac:	00000517          	auipc	a0,0x0
 8b0:	15453503          	ld	a0,340(a0) # a00 <freep>
 8b4:	c515                	beqz	a0,8e0 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b8:	4798                	lw	a4,8(a5)
 8ba:	02977f63          	bgeu	a4,s1,8f8 <malloc+0x70>
 8be:	8a4e                	mv	s4,s3
 8c0:	0009871b          	sext.w	a4,s3
 8c4:	6685                	lui	a3,0x1
 8c6:	00d77363          	bgeu	a4,a3,8cc <malloc+0x44>
 8ca:	6a05                	lui	s4,0x1
 8cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d4:	00000917          	auipc	s2,0x0
 8d8:	12c90913          	addi	s2,s2,300 # a00 <freep>
  if(p == (char*)-1)
 8dc:	5afd                	li	s5,-1
 8de:	a88d                	j	950 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
 8e0:	00000797          	auipc	a5,0x0
 8e4:	12878793          	addi	a5,a5,296 # a08 <base>
 8e8:	00000717          	auipc	a4,0x0
 8ec:	10f73c23          	sd	a5,280(a4) # a00 <freep>
 8f0:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8f2:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8f6:	b7e1                	j	8be <malloc+0x36>
      if(p->s.size == nunits)
 8f8:	02e48b63          	beq	s1,a4,92e <malloc+0xa6>
        p->s.size -= nunits;
 8fc:	4137073b          	subw	a4,a4,s3
 900:	c798                	sw	a4,8(a5)
        p += p->s.size;
 902:	1702                	slli	a4,a4,0x20
 904:	9301                	srli	a4,a4,0x20
 906:	0712                	slli	a4,a4,0x4
 908:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 90a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 90e:	00000717          	auipc	a4,0x0
 912:	0ea73923          	sd	a0,242(a4) # a00 <freep>
      return (void*)(p + 1);
 916:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 91a:	70e2                	ld	ra,56(sp)
 91c:	7442                	ld	s0,48(sp)
 91e:	74a2                	ld	s1,40(sp)
 920:	7902                	ld	s2,32(sp)
 922:	69e2                	ld	s3,24(sp)
 924:	6a42                	ld	s4,16(sp)
 926:	6aa2                	ld	s5,8(sp)
 928:	6b02                	ld	s6,0(sp)
 92a:	6121                	addi	sp,sp,64
 92c:	8082                	ret
        prevp->s.ptr = p->s.ptr;
 92e:	6398                	ld	a4,0(a5)
 930:	e118                	sd	a4,0(a0)
 932:	bff1                	j	90e <malloc+0x86>
  hp->s.size = nu;
 934:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 938:	0541                	addi	a0,a0,16
 93a:	00000097          	auipc	ra,0x0
 93e:	ec6080e7          	jalr	-314(ra) # 800 <free>
  return freep;
 942:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
 946:	d971                	beqz	a0,91a <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	fa9776e3          	bgeu	a4,s1,8f8 <malloc+0x70>
    if(p == freep)
 950:	00093703          	ld	a4,0(s2)
 954:	853e                	mv	a0,a5
 956:	fef719e3          	bne	a4,a5,948 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
 95a:	8552                	mv	a0,s4
 95c:	00000097          	auipc	ra,0x0
 960:	b76080e7          	jalr	-1162(ra) # 4d2 <sbrk>
  if(p == (char*)-1)
 964:	fd5518e3          	bne	a0,s5,934 <malloc+0xac>
        return 0;
 968:	4501                	li	a0,0
 96a:	bf45                	j	91a <malloc+0x92>
