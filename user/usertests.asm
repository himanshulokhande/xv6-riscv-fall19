
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
       0:	00007797          	auipc	a5,0x7
       4:	b4078793          	addi	a5,a5,-1216 # 6b40 <uninit>
       8:	00009697          	auipc	a3,0x9
       c:	24868693          	addi	a3,a3,584 # 9250 <buf>
    if(uninit[i] != '\0'){
      10:	0007c703          	lbu	a4,0(a5)
      14:	e709                	bnez	a4,1e <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      16:	0785                	addi	a5,a5,1
      18:	fed79ce3          	bne	a5,a3,10 <bsstest+0x10>
      1c:	8082                	ret
{
      1e:	1141                	addi	sp,sp,-16
      20:	e406                	sd	ra,8(sp)
      22:	e022                	sd	s0,0(sp)
      24:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      26:	85aa                	mv	a1,a0
      28:	00005517          	auipc	a0,0x5
      2c:	bc050513          	addi	a0,a0,-1088 # 4be8 <malloc+0x36e>
      30:	00004097          	auipc	ra,0x4
      34:	78c080e7          	jalr	1932(ra) # 47bc <printf>
      exit(1);
      38:	4505                	li	a0,1
      3a:	00004097          	auipc	ra,0x4
      3e:	402080e7          	jalr	1026(ra) # 443c <exit>

0000000000000042 <iputtest>:
{
      42:	1101                	addi	sp,sp,-32
      44:	ec06                	sd	ra,24(sp)
      46:	e822                	sd	s0,16(sp)
      48:	e426                	sd	s1,8(sp)
      4a:	1000                	addi	s0,sp,32
      4c:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
      4e:	00005517          	auipc	a0,0x5
      52:	bb250513          	addi	a0,a0,-1102 # 4c00 <malloc+0x386>
      56:	00004097          	auipc	ra,0x4
      5a:	44e080e7          	jalr	1102(ra) # 44a4 <mkdir>
      5e:	04054563          	bltz	a0,a8 <iputtest+0x66>
  if(chdir("iputdir") < 0){
      62:	00005517          	auipc	a0,0x5
      66:	b9e50513          	addi	a0,a0,-1122 # 4c00 <malloc+0x386>
      6a:	00004097          	auipc	ra,0x4
      6e:	442080e7          	jalr	1090(ra) # 44ac <chdir>
      72:	04054963          	bltz	a0,c4 <iputtest+0x82>
  if(unlink("../iputdir") < 0){
      76:	00005517          	auipc	a0,0x5
      7a:	bca50513          	addi	a0,a0,-1078 # 4c40 <malloc+0x3c6>
      7e:	00004097          	auipc	ra,0x4
      82:	40e080e7          	jalr	1038(ra) # 448c <unlink>
      86:	04054d63          	bltz	a0,e0 <iputtest+0x9e>
  if(chdir("/") < 0){
      8a:	00005517          	auipc	a0,0x5
      8e:	be650513          	addi	a0,a0,-1050 # 4c70 <malloc+0x3f6>
      92:	00004097          	auipc	ra,0x4
      96:	41a080e7          	jalr	1050(ra) # 44ac <chdir>
      9a:	06054163          	bltz	a0,fc <iputtest+0xba>
}
      9e:	60e2                	ld	ra,24(sp)
      a0:	6442                	ld	s0,16(sp)
      a2:	64a2                	ld	s1,8(sp)
      a4:	6105                	addi	sp,sp,32
      a6:	8082                	ret
    printf("%s: mkdir failed\n", s);
      a8:	85a6                	mv	a1,s1
      aa:	00005517          	auipc	a0,0x5
      ae:	b5e50513          	addi	a0,a0,-1186 # 4c08 <malloc+0x38e>
      b2:	00004097          	auipc	ra,0x4
      b6:	70a080e7          	jalr	1802(ra) # 47bc <printf>
    exit(1);
      ba:	4505                	li	a0,1
      bc:	00004097          	auipc	ra,0x4
      c0:	380080e7          	jalr	896(ra) # 443c <exit>
    printf("%s: chdir iputdir failed\n", s);
      c4:	85a6                	mv	a1,s1
      c6:	00005517          	auipc	a0,0x5
      ca:	b5a50513          	addi	a0,a0,-1190 # 4c20 <malloc+0x3a6>
      ce:	00004097          	auipc	ra,0x4
      d2:	6ee080e7          	jalr	1774(ra) # 47bc <printf>
    exit(1);
      d6:	4505                	li	a0,1
      d8:	00004097          	auipc	ra,0x4
      dc:	364080e7          	jalr	868(ra) # 443c <exit>
    printf("%s: unlink ../iputdir failed\n", s);
      e0:	85a6                	mv	a1,s1
      e2:	00005517          	auipc	a0,0x5
      e6:	b6e50513          	addi	a0,a0,-1170 # 4c50 <malloc+0x3d6>
      ea:	00004097          	auipc	ra,0x4
      ee:	6d2080e7          	jalr	1746(ra) # 47bc <printf>
    exit(1);
      f2:	4505                	li	a0,1
      f4:	00004097          	auipc	ra,0x4
      f8:	348080e7          	jalr	840(ra) # 443c <exit>
    printf("%s: chdir / failed\n", s);
      fc:	85a6                	mv	a1,s1
      fe:	00005517          	auipc	a0,0x5
     102:	b7a50513          	addi	a0,a0,-1158 # 4c78 <malloc+0x3fe>
     106:	00004097          	auipc	ra,0x4
     10a:	6b6080e7          	jalr	1718(ra) # 47bc <printf>
    exit(1);
     10e:	4505                	li	a0,1
     110:	00004097          	auipc	ra,0x4
     114:	32c080e7          	jalr	812(ra) # 443c <exit>

0000000000000118 <rmdot>:
{
     118:	1101                	addi	sp,sp,-32
     11a:	ec06                	sd	ra,24(sp)
     11c:	e822                	sd	s0,16(sp)
     11e:	e426                	sd	s1,8(sp)
     120:	1000                	addi	s0,sp,32
     122:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
     124:	00005517          	auipc	a0,0x5
     128:	b6c50513          	addi	a0,a0,-1172 # 4c90 <malloc+0x416>
     12c:	00004097          	auipc	ra,0x4
     130:	378080e7          	jalr	888(ra) # 44a4 <mkdir>
     134:	e549                	bnez	a0,1be <rmdot+0xa6>
  if(chdir("dots") != 0){
     136:	00005517          	auipc	a0,0x5
     13a:	b5a50513          	addi	a0,a0,-1190 # 4c90 <malloc+0x416>
     13e:	00004097          	auipc	ra,0x4
     142:	36e080e7          	jalr	878(ra) # 44ac <chdir>
     146:	e951                	bnez	a0,1da <rmdot+0xc2>
  if(unlink(".") == 0){
     148:	00005517          	auipc	a0,0x5
     14c:	b8050513          	addi	a0,a0,-1152 # 4cc8 <malloc+0x44e>
     150:	00004097          	auipc	ra,0x4
     154:	33c080e7          	jalr	828(ra) # 448c <unlink>
     158:	cd59                	beqz	a0,1f6 <rmdot+0xde>
  if(unlink("..") == 0){
     15a:	00005517          	auipc	a0,0x5
     15e:	b8e50513          	addi	a0,a0,-1138 # 4ce8 <malloc+0x46e>
     162:	00004097          	auipc	ra,0x4
     166:	32a080e7          	jalr	810(ra) # 448c <unlink>
     16a:	c545                	beqz	a0,212 <rmdot+0xfa>
  if(chdir("/") != 0){
     16c:	00005517          	auipc	a0,0x5
     170:	b0450513          	addi	a0,a0,-1276 # 4c70 <malloc+0x3f6>
     174:	00004097          	auipc	ra,0x4
     178:	338080e7          	jalr	824(ra) # 44ac <chdir>
     17c:	e94d                	bnez	a0,22e <rmdot+0x116>
  if(unlink("dots/.") == 0){
     17e:	00005517          	auipc	a0,0x5
     182:	b8a50513          	addi	a0,a0,-1142 # 4d08 <malloc+0x48e>
     186:	00004097          	auipc	ra,0x4
     18a:	306080e7          	jalr	774(ra) # 448c <unlink>
     18e:	cd55                	beqz	a0,24a <rmdot+0x132>
  if(unlink("dots/..") == 0){
     190:	00005517          	auipc	a0,0x5
     194:	ba050513          	addi	a0,a0,-1120 # 4d30 <malloc+0x4b6>
     198:	00004097          	auipc	ra,0x4
     19c:	2f4080e7          	jalr	756(ra) # 448c <unlink>
     1a0:	c179                	beqz	a0,266 <rmdot+0x14e>
  if(unlink("dots") != 0){
     1a2:	00005517          	auipc	a0,0x5
     1a6:	aee50513          	addi	a0,a0,-1298 # 4c90 <malloc+0x416>
     1aa:	00004097          	auipc	ra,0x4
     1ae:	2e2080e7          	jalr	738(ra) # 448c <unlink>
     1b2:	e961                	bnez	a0,282 <rmdot+0x16a>
}
     1b4:	60e2                	ld	ra,24(sp)
     1b6:	6442                	ld	s0,16(sp)
     1b8:	64a2                	ld	s1,8(sp)
     1ba:	6105                	addi	sp,sp,32
     1bc:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
     1be:	85a6                	mv	a1,s1
     1c0:	00005517          	auipc	a0,0x5
     1c4:	ad850513          	addi	a0,a0,-1320 # 4c98 <malloc+0x41e>
     1c8:	00004097          	auipc	ra,0x4
     1cc:	5f4080e7          	jalr	1524(ra) # 47bc <printf>
    exit(1);
     1d0:	4505                	li	a0,1
     1d2:	00004097          	auipc	ra,0x4
     1d6:	26a080e7          	jalr	618(ra) # 443c <exit>
    printf("%s: chdir dots failed\n", s);
     1da:	85a6                	mv	a1,s1
     1dc:	00005517          	auipc	a0,0x5
     1e0:	ad450513          	addi	a0,a0,-1324 # 4cb0 <malloc+0x436>
     1e4:	00004097          	auipc	ra,0x4
     1e8:	5d8080e7          	jalr	1496(ra) # 47bc <printf>
    exit(1);
     1ec:	4505                	li	a0,1
     1ee:	00004097          	auipc	ra,0x4
     1f2:	24e080e7          	jalr	590(ra) # 443c <exit>
    printf("%s: rm . worked!\n", s);
     1f6:	85a6                	mv	a1,s1
     1f8:	00005517          	auipc	a0,0x5
     1fc:	ad850513          	addi	a0,a0,-1320 # 4cd0 <malloc+0x456>
     200:	00004097          	auipc	ra,0x4
     204:	5bc080e7          	jalr	1468(ra) # 47bc <printf>
    exit(1);
     208:	4505                	li	a0,1
     20a:	00004097          	auipc	ra,0x4
     20e:	232080e7          	jalr	562(ra) # 443c <exit>
    printf("%s: rm .. worked!\n", s);
     212:	85a6                	mv	a1,s1
     214:	00005517          	auipc	a0,0x5
     218:	adc50513          	addi	a0,a0,-1316 # 4cf0 <malloc+0x476>
     21c:	00004097          	auipc	ra,0x4
     220:	5a0080e7          	jalr	1440(ra) # 47bc <printf>
    exit(1);
     224:	4505                	li	a0,1
     226:	00004097          	auipc	ra,0x4
     22a:	216080e7          	jalr	534(ra) # 443c <exit>
    printf("%s: chdir / failed\n", s);
     22e:	85a6                	mv	a1,s1
     230:	00005517          	auipc	a0,0x5
     234:	a4850513          	addi	a0,a0,-1464 # 4c78 <malloc+0x3fe>
     238:	00004097          	auipc	ra,0x4
     23c:	584080e7          	jalr	1412(ra) # 47bc <printf>
    exit(1);
     240:	4505                	li	a0,1
     242:	00004097          	auipc	ra,0x4
     246:	1fa080e7          	jalr	506(ra) # 443c <exit>
    printf("%s: unlink dots/. worked!\n", s);
     24a:	85a6                	mv	a1,s1
     24c:	00005517          	auipc	a0,0x5
     250:	ac450513          	addi	a0,a0,-1340 # 4d10 <malloc+0x496>
     254:	00004097          	auipc	ra,0x4
     258:	568080e7          	jalr	1384(ra) # 47bc <printf>
    exit(1);
     25c:	4505                	li	a0,1
     25e:	00004097          	auipc	ra,0x4
     262:	1de080e7          	jalr	478(ra) # 443c <exit>
    printf("%s: unlink dots/.. worked!\n", s);
     266:	85a6                	mv	a1,s1
     268:	00005517          	auipc	a0,0x5
     26c:	ad050513          	addi	a0,a0,-1328 # 4d38 <malloc+0x4be>
     270:	00004097          	auipc	ra,0x4
     274:	54c080e7          	jalr	1356(ra) # 47bc <printf>
    exit(1);
     278:	4505                	li	a0,1
     27a:	00004097          	auipc	ra,0x4
     27e:	1c2080e7          	jalr	450(ra) # 443c <exit>
    printf("%s: unlink dots failed!\n", s);
     282:	85a6                	mv	a1,s1
     284:	00005517          	auipc	a0,0x5
     288:	ad450513          	addi	a0,a0,-1324 # 4d58 <malloc+0x4de>
     28c:	00004097          	auipc	ra,0x4
     290:	530080e7          	jalr	1328(ra) # 47bc <printf>
    exit(1);
     294:	4505                	li	a0,1
     296:	00004097          	auipc	ra,0x4
     29a:	1a6080e7          	jalr	422(ra) # 443c <exit>

000000000000029e <exitiputtest>:
{
     29e:	7179                	addi	sp,sp,-48
     2a0:	f406                	sd	ra,40(sp)
     2a2:	f022                	sd	s0,32(sp)
     2a4:	ec26                	sd	s1,24(sp)
     2a6:	1800                	addi	s0,sp,48
     2a8:	84aa                	mv	s1,a0
  pid = fork();
     2aa:	00004097          	auipc	ra,0x4
     2ae:	18a080e7          	jalr	394(ra) # 4434 <fork>
  if(pid < 0){
     2b2:	04054663          	bltz	a0,2fe <exitiputtest+0x60>
  if(pid == 0){
     2b6:	ed45                	bnez	a0,36e <exitiputtest+0xd0>
    if(mkdir("iputdir") < 0){
     2b8:	00005517          	auipc	a0,0x5
     2bc:	94850513          	addi	a0,a0,-1720 # 4c00 <malloc+0x386>
     2c0:	00004097          	auipc	ra,0x4
     2c4:	1e4080e7          	jalr	484(ra) # 44a4 <mkdir>
     2c8:	04054963          	bltz	a0,31a <exitiputtest+0x7c>
    if(chdir("iputdir") < 0){
     2cc:	00005517          	auipc	a0,0x5
     2d0:	93450513          	addi	a0,a0,-1740 # 4c00 <malloc+0x386>
     2d4:	00004097          	auipc	ra,0x4
     2d8:	1d8080e7          	jalr	472(ra) # 44ac <chdir>
     2dc:	04054d63          	bltz	a0,336 <exitiputtest+0x98>
    if(unlink("../iputdir") < 0){
     2e0:	00005517          	auipc	a0,0x5
     2e4:	96050513          	addi	a0,a0,-1696 # 4c40 <malloc+0x3c6>
     2e8:	00004097          	auipc	ra,0x4
     2ec:	1a4080e7          	jalr	420(ra) # 448c <unlink>
     2f0:	06054163          	bltz	a0,352 <exitiputtest+0xb4>
    exit(0);
     2f4:	4501                	li	a0,0
     2f6:	00004097          	auipc	ra,0x4
     2fa:	146080e7          	jalr	326(ra) # 443c <exit>
    printf("%s: fork failed\n", s);
     2fe:	85a6                	mv	a1,s1
     300:	00005517          	auipc	a0,0x5
     304:	a7850513          	addi	a0,a0,-1416 # 4d78 <malloc+0x4fe>
     308:	00004097          	auipc	ra,0x4
     30c:	4b4080e7          	jalr	1204(ra) # 47bc <printf>
    exit(1);
     310:	4505                	li	a0,1
     312:	00004097          	auipc	ra,0x4
     316:	12a080e7          	jalr	298(ra) # 443c <exit>
      printf("%s: mkdir failed\n", s);
     31a:	85a6                	mv	a1,s1
     31c:	00005517          	auipc	a0,0x5
     320:	8ec50513          	addi	a0,a0,-1812 # 4c08 <malloc+0x38e>
     324:	00004097          	auipc	ra,0x4
     328:	498080e7          	jalr	1176(ra) # 47bc <printf>
      exit(1);
     32c:	4505                	li	a0,1
     32e:	00004097          	auipc	ra,0x4
     332:	10e080e7          	jalr	270(ra) # 443c <exit>
      printf("%s: child chdir failed\n", s);
     336:	85a6                	mv	a1,s1
     338:	00005517          	auipc	a0,0x5
     33c:	a5850513          	addi	a0,a0,-1448 # 4d90 <malloc+0x516>
     340:	00004097          	auipc	ra,0x4
     344:	47c080e7          	jalr	1148(ra) # 47bc <printf>
      exit(1);
     348:	4505                	li	a0,1
     34a:	00004097          	auipc	ra,0x4
     34e:	0f2080e7          	jalr	242(ra) # 443c <exit>
      printf("%s: unlink ../iputdir failed\n", s);
     352:	85a6                	mv	a1,s1
     354:	00005517          	auipc	a0,0x5
     358:	8fc50513          	addi	a0,a0,-1796 # 4c50 <malloc+0x3d6>
     35c:	00004097          	auipc	ra,0x4
     360:	460080e7          	jalr	1120(ra) # 47bc <printf>
      exit(1);
     364:	4505                	li	a0,1
     366:	00004097          	auipc	ra,0x4
     36a:	0d6080e7          	jalr	214(ra) # 443c <exit>
  wait(&xstatus);
     36e:	fdc40513          	addi	a0,s0,-36
     372:	00004097          	auipc	ra,0x4
     376:	0d2080e7          	jalr	210(ra) # 4444 <wait>
  exit(xstatus);
     37a:	fdc42503          	lw	a0,-36(s0)
     37e:	00004097          	auipc	ra,0x4
     382:	0be080e7          	jalr	190(ra) # 443c <exit>

0000000000000386 <exitwait>:
{
     386:	7139                	addi	sp,sp,-64
     388:	fc06                	sd	ra,56(sp)
     38a:	f822                	sd	s0,48(sp)
     38c:	f426                	sd	s1,40(sp)
     38e:	f04a                	sd	s2,32(sp)
     390:	ec4e                	sd	s3,24(sp)
     392:	e852                	sd	s4,16(sp)
     394:	0080                	addi	s0,sp,64
     396:	8a2a                	mv	s4,a0
  for(i = 0; i < 100; i++){
     398:	4901                	li	s2,0
     39a:	06400993          	li	s3,100
    pid = fork();
     39e:	00004097          	auipc	ra,0x4
     3a2:	096080e7          	jalr	150(ra) # 4434 <fork>
     3a6:	84aa                	mv	s1,a0
    if(pid < 0){
     3a8:	02054a63          	bltz	a0,3dc <exitwait+0x56>
    if(pid){
     3ac:	c151                	beqz	a0,430 <exitwait+0xaa>
      if(wait(&xstate) != pid){
     3ae:	fcc40513          	addi	a0,s0,-52
     3b2:	00004097          	auipc	ra,0x4
     3b6:	092080e7          	jalr	146(ra) # 4444 <wait>
     3ba:	02951f63          	bne	a0,s1,3f8 <exitwait+0x72>
      if(i != xstate) {
     3be:	fcc42783          	lw	a5,-52(s0)
     3c2:	05279963          	bne	a5,s2,414 <exitwait+0x8e>
  for(i = 0; i < 100; i++){
     3c6:	2905                	addiw	s2,s2,1
     3c8:	fd391be3          	bne	s2,s3,39e <exitwait+0x18>
}
     3cc:	70e2                	ld	ra,56(sp)
     3ce:	7442                	ld	s0,48(sp)
     3d0:	74a2                	ld	s1,40(sp)
     3d2:	7902                	ld	s2,32(sp)
     3d4:	69e2                	ld	s3,24(sp)
     3d6:	6a42                	ld	s4,16(sp)
     3d8:	6121                	addi	sp,sp,64
     3da:	8082                	ret
      printf("%s: fork failed\n", s);
     3dc:	85d2                	mv	a1,s4
     3de:	00005517          	auipc	a0,0x5
     3e2:	99a50513          	addi	a0,a0,-1638 # 4d78 <malloc+0x4fe>
     3e6:	00004097          	auipc	ra,0x4
     3ea:	3d6080e7          	jalr	982(ra) # 47bc <printf>
      exit(1);
     3ee:	4505                	li	a0,1
     3f0:	00004097          	auipc	ra,0x4
     3f4:	04c080e7          	jalr	76(ra) # 443c <exit>
        printf("%s: wait wrong pid\n", s);
     3f8:	85d2                	mv	a1,s4
     3fa:	00005517          	auipc	a0,0x5
     3fe:	9ae50513          	addi	a0,a0,-1618 # 4da8 <malloc+0x52e>
     402:	00004097          	auipc	ra,0x4
     406:	3ba080e7          	jalr	954(ra) # 47bc <printf>
        exit(1);
     40a:	4505                	li	a0,1
     40c:	00004097          	auipc	ra,0x4
     410:	030080e7          	jalr	48(ra) # 443c <exit>
        printf("%s: wait wrong exit status\n", s);
     414:	85d2                	mv	a1,s4
     416:	00005517          	auipc	a0,0x5
     41a:	9aa50513          	addi	a0,a0,-1622 # 4dc0 <malloc+0x546>
     41e:	00004097          	auipc	ra,0x4
     422:	39e080e7          	jalr	926(ra) # 47bc <printf>
        exit(1);
     426:	4505                	li	a0,1
     428:	00004097          	auipc	ra,0x4
     42c:	014080e7          	jalr	20(ra) # 443c <exit>
      exit(i);
     430:	854a                	mv	a0,s2
     432:	00004097          	auipc	ra,0x4
     436:	00a080e7          	jalr	10(ra) # 443c <exit>

000000000000043a <twochildren>:
{
     43a:	1101                	addi	sp,sp,-32
     43c:	ec06                	sd	ra,24(sp)
     43e:	e822                	sd	s0,16(sp)
     440:	e426                	sd	s1,8(sp)
     442:	e04a                	sd	s2,0(sp)
     444:	1000                	addi	s0,sp,32
     446:	892a                	mv	s2,a0
     448:	3e800493          	li	s1,1000
    int pid1 = fork();
     44c:	00004097          	auipc	ra,0x4
     450:	fe8080e7          	jalr	-24(ra) # 4434 <fork>
    if(pid1 < 0){
     454:	02054c63          	bltz	a0,48c <twochildren+0x52>
    if(pid1 == 0){
     458:	c921                	beqz	a0,4a8 <twochildren+0x6e>
      int pid2 = fork();
     45a:	00004097          	auipc	ra,0x4
     45e:	fda080e7          	jalr	-38(ra) # 4434 <fork>
      if(pid2 < 0){
     462:	04054763          	bltz	a0,4b0 <twochildren+0x76>
      if(pid2 == 0){
     466:	c13d                	beqz	a0,4cc <twochildren+0x92>
        wait(0);
     468:	4501                	li	a0,0
     46a:	00004097          	auipc	ra,0x4
     46e:	fda080e7          	jalr	-38(ra) # 4444 <wait>
        wait(0);
     472:	4501                	li	a0,0
     474:	00004097          	auipc	ra,0x4
     478:	fd0080e7          	jalr	-48(ra) # 4444 <wait>
  for(int i = 0; i < 1000; i++){
     47c:	34fd                	addiw	s1,s1,-1
     47e:	f4f9                	bnez	s1,44c <twochildren+0x12>
}
     480:	60e2                	ld	ra,24(sp)
     482:	6442                	ld	s0,16(sp)
     484:	64a2                	ld	s1,8(sp)
     486:	6902                	ld	s2,0(sp)
     488:	6105                	addi	sp,sp,32
     48a:	8082                	ret
      printf("%s: fork failed\n", s);
     48c:	85ca                	mv	a1,s2
     48e:	00005517          	auipc	a0,0x5
     492:	8ea50513          	addi	a0,a0,-1814 # 4d78 <malloc+0x4fe>
     496:	00004097          	auipc	ra,0x4
     49a:	326080e7          	jalr	806(ra) # 47bc <printf>
      exit(1);
     49e:	4505                	li	a0,1
     4a0:	00004097          	auipc	ra,0x4
     4a4:	f9c080e7          	jalr	-100(ra) # 443c <exit>
      exit(0);
     4a8:	00004097          	auipc	ra,0x4
     4ac:	f94080e7          	jalr	-108(ra) # 443c <exit>
        printf("%s: fork failed\n", s);
     4b0:	85ca                	mv	a1,s2
     4b2:	00005517          	auipc	a0,0x5
     4b6:	8c650513          	addi	a0,a0,-1850 # 4d78 <malloc+0x4fe>
     4ba:	00004097          	auipc	ra,0x4
     4be:	302080e7          	jalr	770(ra) # 47bc <printf>
        exit(1);
     4c2:	4505                	li	a0,1
     4c4:	00004097          	auipc	ra,0x4
     4c8:	f78080e7          	jalr	-136(ra) # 443c <exit>
        exit(0);
     4cc:	00004097          	auipc	ra,0x4
     4d0:	f70080e7          	jalr	-144(ra) # 443c <exit>

00000000000004d4 <forkfork>:
{
     4d4:	7179                	addi	sp,sp,-48
     4d6:	f406                	sd	ra,40(sp)
     4d8:	f022                	sd	s0,32(sp)
     4da:	ec26                	sd	s1,24(sp)
     4dc:	1800                	addi	s0,sp,48
     4de:	84aa                	mv	s1,a0
    int pid = fork();
     4e0:	00004097          	auipc	ra,0x4
     4e4:	f54080e7          	jalr	-172(ra) # 4434 <fork>
    if(pid < 0){
     4e8:	04054163          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4ec:	cd29                	beqz	a0,546 <forkfork+0x72>
    int pid = fork();
     4ee:	00004097          	auipc	ra,0x4
     4f2:	f46080e7          	jalr	-186(ra) # 4434 <fork>
    if(pid < 0){
     4f6:	02054a63          	bltz	a0,52a <forkfork+0x56>
    if(pid == 0){
     4fa:	c531                	beqz	a0,546 <forkfork+0x72>
    wait(&xstatus);
     4fc:	fdc40513          	addi	a0,s0,-36
     500:	00004097          	auipc	ra,0x4
     504:	f44080e7          	jalr	-188(ra) # 4444 <wait>
    if(xstatus != 0) {
     508:	fdc42783          	lw	a5,-36(s0)
     50c:	ebbd                	bnez	a5,582 <forkfork+0xae>
    wait(&xstatus);
     50e:	fdc40513          	addi	a0,s0,-36
     512:	00004097          	auipc	ra,0x4
     516:	f32080e7          	jalr	-206(ra) # 4444 <wait>
    if(xstatus != 0) {
     51a:	fdc42783          	lw	a5,-36(s0)
     51e:	e3b5                	bnez	a5,582 <forkfork+0xae>
}
     520:	70a2                	ld	ra,40(sp)
     522:	7402                	ld	s0,32(sp)
     524:	64e2                	ld	s1,24(sp)
     526:	6145                	addi	sp,sp,48
     528:	8082                	ret
      printf("%s: fork failed", s);
     52a:	85a6                	mv	a1,s1
     52c:	00005517          	auipc	a0,0x5
     530:	8b450513          	addi	a0,a0,-1868 # 4de0 <malloc+0x566>
     534:	00004097          	auipc	ra,0x4
     538:	288080e7          	jalr	648(ra) # 47bc <printf>
      exit(1);
     53c:	4505                	li	a0,1
     53e:	00004097          	auipc	ra,0x4
     542:	efe080e7          	jalr	-258(ra) # 443c <exit>
{
     546:	0c800493          	li	s1,200
        int pid1 = fork();
     54a:	00004097          	auipc	ra,0x4
     54e:	eea080e7          	jalr	-278(ra) # 4434 <fork>
        if(pid1 < 0){
     552:	00054f63          	bltz	a0,570 <forkfork+0x9c>
        if(pid1 == 0){
     556:	c115                	beqz	a0,57a <forkfork+0xa6>
        wait(0);
     558:	4501                	li	a0,0
     55a:	00004097          	auipc	ra,0x4
     55e:	eea080e7          	jalr	-278(ra) # 4444 <wait>
      for(int j = 0; j < 200; j++){
     562:	34fd                	addiw	s1,s1,-1
     564:	f0fd                	bnez	s1,54a <forkfork+0x76>
      exit(0);
     566:	4501                	li	a0,0
     568:	00004097          	auipc	ra,0x4
     56c:	ed4080e7          	jalr	-300(ra) # 443c <exit>
          exit(1);
     570:	4505                	li	a0,1
     572:	00004097          	auipc	ra,0x4
     576:	eca080e7          	jalr	-310(ra) # 443c <exit>
          exit(0);
     57a:	00004097          	auipc	ra,0x4
     57e:	ec2080e7          	jalr	-318(ra) # 443c <exit>
      printf("%s: fork in child failed", s);
     582:	85a6                	mv	a1,s1
     584:	00005517          	auipc	a0,0x5
     588:	86c50513          	addi	a0,a0,-1940 # 4df0 <malloc+0x576>
     58c:	00004097          	auipc	ra,0x4
     590:	230080e7          	jalr	560(ra) # 47bc <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	00004097          	auipc	ra,0x4
     59a:	ea6080e7          	jalr	-346(ra) # 443c <exit>

000000000000059e <reparent2>:
{
     59e:	1101                	addi	sp,sp,-32
     5a0:	ec06                	sd	ra,24(sp)
     5a2:	e822                	sd	s0,16(sp)
     5a4:	e426                	sd	s1,8(sp)
     5a6:	1000                	addi	s0,sp,32
     5a8:	32000493          	li	s1,800
    int pid1 = fork();
     5ac:	00004097          	auipc	ra,0x4
     5b0:	e88080e7          	jalr	-376(ra) # 4434 <fork>
    if(pid1 < 0){
     5b4:	00054f63          	bltz	a0,5d2 <reparent2+0x34>
    if(pid1 == 0){
     5b8:	c915                	beqz	a0,5ec <reparent2+0x4e>
    wait(0);
     5ba:	4501                	li	a0,0
     5bc:	00004097          	auipc	ra,0x4
     5c0:	e88080e7          	jalr	-376(ra) # 4444 <wait>
  for(int i = 0; i < 800; i++){
     5c4:	34fd                	addiw	s1,s1,-1
     5c6:	f0fd                	bnez	s1,5ac <reparent2+0xe>
  exit(0);
     5c8:	4501                	li	a0,0
     5ca:	00004097          	auipc	ra,0x4
     5ce:	e72080e7          	jalr	-398(ra) # 443c <exit>
      printf("fork failed\n");
     5d2:	00005517          	auipc	a0,0x5
     5d6:	0a650513          	addi	a0,a0,166 # 5678 <malloc+0xdfe>
     5da:	00004097          	auipc	ra,0x4
     5de:	1e2080e7          	jalr	482(ra) # 47bc <printf>
      exit(1);
     5e2:	4505                	li	a0,1
     5e4:	00004097          	auipc	ra,0x4
     5e8:	e58080e7          	jalr	-424(ra) # 443c <exit>
      fork();
     5ec:	00004097          	auipc	ra,0x4
     5f0:	e48080e7          	jalr	-440(ra) # 4434 <fork>
      fork();
     5f4:	00004097          	auipc	ra,0x4
     5f8:	e40080e7          	jalr	-448(ra) # 4434 <fork>
      exit(0);
     5fc:	4501                	li	a0,0
     5fe:	00004097          	auipc	ra,0x4
     602:	e3e080e7          	jalr	-450(ra) # 443c <exit>

0000000000000606 <forktest>:
{
     606:	7179                	addi	sp,sp,-48
     608:	f406                	sd	ra,40(sp)
     60a:	f022                	sd	s0,32(sp)
     60c:	ec26                	sd	s1,24(sp)
     60e:	e84a                	sd	s2,16(sp)
     610:	e44e                	sd	s3,8(sp)
     612:	1800                	addi	s0,sp,48
     614:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
     616:	4481                	li	s1,0
     618:	3e800913          	li	s2,1000
    pid = fork();
     61c:	00004097          	auipc	ra,0x4
     620:	e18080e7          	jalr	-488(ra) # 4434 <fork>
    if(pid < 0)
     624:	02054863          	bltz	a0,654 <forktest+0x4e>
    if(pid == 0)
     628:	c115                	beqz	a0,64c <forktest+0x46>
  for(n=0; n<N; n++){
     62a:	2485                	addiw	s1,s1,1
     62c:	ff2498e3          	bne	s1,s2,61c <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
     630:	85ce                	mv	a1,s3
     632:	00004517          	auipc	a0,0x4
     636:	7f650513          	addi	a0,a0,2038 # 4e28 <malloc+0x5ae>
     63a:	00004097          	auipc	ra,0x4
     63e:	182080e7          	jalr	386(ra) # 47bc <printf>
    exit(1);
     642:	4505                	li	a0,1
     644:	00004097          	auipc	ra,0x4
     648:	df8080e7          	jalr	-520(ra) # 443c <exit>
      exit(0);
     64c:	00004097          	auipc	ra,0x4
     650:	df0080e7          	jalr	-528(ra) # 443c <exit>
  if (n == 0) {
     654:	cc9d                	beqz	s1,692 <forktest+0x8c>
  if(n == N){
     656:	3e800793          	li	a5,1000
     65a:	fcf48be3          	beq	s1,a5,630 <forktest+0x2a>
  for(; n > 0; n--){
     65e:	00905b63          	blez	s1,674 <forktest+0x6e>
    if(wait(0) < 0){
     662:	4501                	li	a0,0
     664:	00004097          	auipc	ra,0x4
     668:	de0080e7          	jalr	-544(ra) # 4444 <wait>
     66c:	04054163          	bltz	a0,6ae <forktest+0xa8>
  for(; n > 0; n--){
     670:	34fd                	addiw	s1,s1,-1
     672:	f8e5                	bnez	s1,662 <forktest+0x5c>
  if(wait(0) != -1){
     674:	4501                	li	a0,0
     676:	00004097          	auipc	ra,0x4
     67a:	dce080e7          	jalr	-562(ra) # 4444 <wait>
     67e:	57fd                	li	a5,-1
     680:	04f51563          	bne	a0,a5,6ca <forktest+0xc4>
}
     684:	70a2                	ld	ra,40(sp)
     686:	7402                	ld	s0,32(sp)
     688:	64e2                	ld	s1,24(sp)
     68a:	6942                	ld	s2,16(sp)
     68c:	69a2                	ld	s3,8(sp)
     68e:	6145                	addi	sp,sp,48
     690:	8082                	ret
    printf("%s: no fork at all!\n", s);
     692:	85ce                	mv	a1,s3
     694:	00004517          	auipc	a0,0x4
     698:	77c50513          	addi	a0,a0,1916 # 4e10 <malloc+0x596>
     69c:	00004097          	auipc	ra,0x4
     6a0:	120080e7          	jalr	288(ra) # 47bc <printf>
    exit(1);
     6a4:	4505                	li	a0,1
     6a6:	00004097          	auipc	ra,0x4
     6aa:	d96080e7          	jalr	-618(ra) # 443c <exit>
      printf("%s: wait stopped early\n", s);
     6ae:	85ce                	mv	a1,s3
     6b0:	00004517          	auipc	a0,0x4
     6b4:	7a050513          	addi	a0,a0,1952 # 4e50 <malloc+0x5d6>
     6b8:	00004097          	auipc	ra,0x4
     6bc:	104080e7          	jalr	260(ra) # 47bc <printf>
      exit(1);
     6c0:	4505                	li	a0,1
     6c2:	00004097          	auipc	ra,0x4
     6c6:	d7a080e7          	jalr	-646(ra) # 443c <exit>
    printf("%s: wait got too many\n", s);
     6ca:	85ce                	mv	a1,s3
     6cc:	00004517          	auipc	a0,0x4
     6d0:	79c50513          	addi	a0,a0,1948 # 4e68 <malloc+0x5ee>
     6d4:	00004097          	auipc	ra,0x4
     6d8:	0e8080e7          	jalr	232(ra) # 47bc <printf>
    exit(1);
     6dc:	4505                	li	a0,1
     6de:	00004097          	auipc	ra,0x4
     6e2:	d5e080e7          	jalr	-674(ra) # 443c <exit>

00000000000006e6 <kernmem>:
{
     6e6:	715d                	addi	sp,sp,-80
     6e8:	e486                	sd	ra,72(sp)
     6ea:	e0a2                	sd	s0,64(sp)
     6ec:	fc26                	sd	s1,56(sp)
     6ee:	f84a                	sd	s2,48(sp)
     6f0:	f44e                	sd	s3,40(sp)
     6f2:	f052                	sd	s4,32(sp)
     6f4:	ec56                	sd	s5,24(sp)
     6f6:	0880                	addi	s0,sp,80
     6f8:	8a2a                	mv	s4,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     6fa:	4485                	li	s1,1
     6fc:	04fe                	slli	s1,s1,0x1f
    if(xstatus != -1)  // did kernel kill child?
     6fe:	5afd                	li	s5,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     700:	69b1                	lui	s3,0xc
     702:	35098993          	addi	s3,s3,848 # c350 <__BSS_END__+0xf0>
     706:	1003d937          	lui	s2,0x1003d
     70a:	090e                	slli	s2,s2,0x3
     70c:	48090913          	addi	s2,s2,1152 # 1003d480 <__BSS_END__+0x10031220>
    pid = fork();
     710:	00004097          	auipc	ra,0x4
     714:	d24080e7          	jalr	-732(ra) # 4434 <fork>
    if(pid < 0){
     718:	02054963          	bltz	a0,74a <kernmem+0x64>
    if(pid == 0){
     71c:	c529                	beqz	a0,766 <kernmem+0x80>
    wait(&xstatus);
     71e:	fbc40513          	addi	a0,s0,-68
     722:	00004097          	auipc	ra,0x4
     726:	d22080e7          	jalr	-734(ra) # 4444 <wait>
    if(xstatus != -1)  // did kernel kill child?
     72a:	fbc42783          	lw	a5,-68(s0)
     72e:	05579c63          	bne	a5,s5,786 <kernmem+0xa0>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
     732:	94ce                	add	s1,s1,s3
     734:	fd249ee3          	bne	s1,s2,710 <kernmem+0x2a>
}
     738:	60a6                	ld	ra,72(sp)
     73a:	6406                	ld	s0,64(sp)
     73c:	74e2                	ld	s1,56(sp)
     73e:	7942                	ld	s2,48(sp)
     740:	79a2                	ld	s3,40(sp)
     742:	7a02                	ld	s4,32(sp)
     744:	6ae2                	ld	s5,24(sp)
     746:	6161                	addi	sp,sp,80
     748:	8082                	ret
      printf("%s: fork failed\n", s);
     74a:	85d2                	mv	a1,s4
     74c:	00004517          	auipc	a0,0x4
     750:	62c50513          	addi	a0,a0,1580 # 4d78 <malloc+0x4fe>
     754:	00004097          	auipc	ra,0x4
     758:	068080e7          	jalr	104(ra) # 47bc <printf>
      exit(1);
     75c:	4505                	li	a0,1
     75e:	00004097          	auipc	ra,0x4
     762:	cde080e7          	jalr	-802(ra) # 443c <exit>
      printf("%s: oops could read %x = %x\n", a, *a);
     766:	0004c603          	lbu	a2,0(s1)
     76a:	85a6                	mv	a1,s1
     76c:	00004517          	auipc	a0,0x4
     770:	71450513          	addi	a0,a0,1812 # 4e80 <malloc+0x606>
     774:	00004097          	auipc	ra,0x4
     778:	048080e7          	jalr	72(ra) # 47bc <printf>
      exit(1);
     77c:	4505                	li	a0,1
     77e:	00004097          	auipc	ra,0x4
     782:	cbe080e7          	jalr	-834(ra) # 443c <exit>
      exit(1);
     786:	4505                	li	a0,1
     788:	00004097          	auipc	ra,0x4
     78c:	cb4080e7          	jalr	-844(ra) # 443c <exit>

0000000000000790 <stacktest>:

// check that there's an invalid page beneath
// the user stack, to catch stack overflow.
void
stacktest(char *s)
{
     790:	7179                	addi	sp,sp,-48
     792:	f406                	sd	ra,40(sp)
     794:	f022                	sd	s0,32(sp)
     796:	ec26                	sd	s1,24(sp)
     798:	1800                	addi	s0,sp,48
     79a:	84aa                	mv	s1,a0
  int pid;
  int xstatus;
  
  pid = fork();
     79c:	00004097          	auipc	ra,0x4
     7a0:	c98080e7          	jalr	-872(ra) # 4434 <fork>
  if(pid == 0) {
     7a4:	c115                	beqz	a0,7c8 <stacktest+0x38>
    char *sp = (char *) r_sp();
    sp -= PGSIZE;
    // the *sp should cause a trap.
    printf("%s: stacktest: read below stack %p\n", *sp);
    exit(1);
  } else if(pid < 0){
     7a6:	04054363          	bltz	a0,7ec <stacktest+0x5c>
    printf("%s: fork failed\n", s);
    exit(1);
  }
  wait(&xstatus);
     7aa:	fdc40513          	addi	a0,s0,-36
     7ae:	00004097          	auipc	ra,0x4
     7b2:	c96080e7          	jalr	-874(ra) # 4444 <wait>
  if(xstatus == -1)  // kernel killed child?
     7b6:	fdc42503          	lw	a0,-36(s0)
     7ba:	57fd                	li	a5,-1
     7bc:	04f50663          	beq	a0,a5,808 <stacktest+0x78>
    exit(0);
  else
    exit(xstatus);
     7c0:	00004097          	auipc	ra,0x4
     7c4:	c7c080e7          	jalr	-900(ra) # 443c <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
     7c8:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %p\n", *sp);
     7ca:	77fd                	lui	a5,0xfffff
     7cc:	97ba                	add	a5,a5,a4
     7ce:	0007c583          	lbu	a1,0(a5) # fffffffffffff000 <__BSS_END__+0xffffffffffff2da0>
     7d2:	00004517          	auipc	a0,0x4
     7d6:	6ce50513          	addi	a0,a0,1742 # 4ea0 <malloc+0x626>
     7da:	00004097          	auipc	ra,0x4
     7de:	fe2080e7          	jalr	-30(ra) # 47bc <printf>
    exit(1);
     7e2:	4505                	li	a0,1
     7e4:	00004097          	auipc	ra,0x4
     7e8:	c58080e7          	jalr	-936(ra) # 443c <exit>
    printf("%s: fork failed\n", s);
     7ec:	85a6                	mv	a1,s1
     7ee:	00004517          	auipc	a0,0x4
     7f2:	58a50513          	addi	a0,a0,1418 # 4d78 <malloc+0x4fe>
     7f6:	00004097          	auipc	ra,0x4
     7fa:	fc6080e7          	jalr	-58(ra) # 47bc <printf>
    exit(1);
     7fe:	4505                	li	a0,1
     800:	00004097          	auipc	ra,0x4
     804:	c3c080e7          	jalr	-964(ra) # 443c <exit>
    exit(0);
     808:	4501                	li	a0,0
     80a:	00004097          	auipc	ra,0x4
     80e:	c32080e7          	jalr	-974(ra) # 443c <exit>

0000000000000812 <openiputtest>:
{
     812:	7179                	addi	sp,sp,-48
     814:	f406                	sd	ra,40(sp)
     816:	f022                	sd	s0,32(sp)
     818:	ec26                	sd	s1,24(sp)
     81a:	1800                	addi	s0,sp,48
     81c:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
     81e:	00004517          	auipc	a0,0x4
     822:	6aa50513          	addi	a0,a0,1706 # 4ec8 <malloc+0x64e>
     826:	00004097          	auipc	ra,0x4
     82a:	c7e080e7          	jalr	-898(ra) # 44a4 <mkdir>
     82e:	04054263          	bltz	a0,872 <openiputtest+0x60>
  pid = fork();
     832:	00004097          	auipc	ra,0x4
     836:	c02080e7          	jalr	-1022(ra) # 4434 <fork>
  if(pid < 0){
     83a:	04054a63          	bltz	a0,88e <openiputtest+0x7c>
  if(pid == 0){
     83e:	e93d                	bnez	a0,8b4 <openiputtest+0xa2>
    int fd = open("oidir", O_RDWR);
     840:	4589                	li	a1,2
     842:	00004517          	auipc	a0,0x4
     846:	68650513          	addi	a0,a0,1670 # 4ec8 <malloc+0x64e>
     84a:	00004097          	auipc	ra,0x4
     84e:	c32080e7          	jalr	-974(ra) # 447c <open>
    if(fd >= 0){
     852:	04054c63          	bltz	a0,8aa <openiputtest+0x98>
      printf("%s: open directory for write succeeded\n", s);
     856:	85a6                	mv	a1,s1
     858:	00004517          	auipc	a0,0x4
     85c:	69050513          	addi	a0,a0,1680 # 4ee8 <malloc+0x66e>
     860:	00004097          	auipc	ra,0x4
     864:	f5c080e7          	jalr	-164(ra) # 47bc <printf>
      exit(1);
     868:	4505                	li	a0,1
     86a:	00004097          	auipc	ra,0x4
     86e:	bd2080e7          	jalr	-1070(ra) # 443c <exit>
    printf("%s: mkdir oidir failed\n", s);
     872:	85a6                	mv	a1,s1
     874:	00004517          	auipc	a0,0x4
     878:	65c50513          	addi	a0,a0,1628 # 4ed0 <malloc+0x656>
     87c:	00004097          	auipc	ra,0x4
     880:	f40080e7          	jalr	-192(ra) # 47bc <printf>
    exit(1);
     884:	4505                	li	a0,1
     886:	00004097          	auipc	ra,0x4
     88a:	bb6080e7          	jalr	-1098(ra) # 443c <exit>
    printf("%s: fork failed\n", s);
     88e:	85a6                	mv	a1,s1
     890:	00004517          	auipc	a0,0x4
     894:	4e850513          	addi	a0,a0,1256 # 4d78 <malloc+0x4fe>
     898:	00004097          	auipc	ra,0x4
     89c:	f24080e7          	jalr	-220(ra) # 47bc <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	00004097          	auipc	ra,0x4
     8a6:	b9a080e7          	jalr	-1126(ra) # 443c <exit>
    exit(0);
     8aa:	4501                	li	a0,0
     8ac:	00004097          	auipc	ra,0x4
     8b0:	b90080e7          	jalr	-1136(ra) # 443c <exit>
  sleep(1);
     8b4:	4505                	li	a0,1
     8b6:	00004097          	auipc	ra,0x4
     8ba:	c16080e7          	jalr	-1002(ra) # 44cc <sleep>
  if(unlink("oidir") != 0){
     8be:	00004517          	auipc	a0,0x4
     8c2:	60a50513          	addi	a0,a0,1546 # 4ec8 <malloc+0x64e>
     8c6:	00004097          	auipc	ra,0x4
     8ca:	bc6080e7          	jalr	-1082(ra) # 448c <unlink>
     8ce:	cd19                	beqz	a0,8ec <openiputtest+0xda>
    printf("%s: unlink failed\n", s);
     8d0:	85a6                	mv	a1,s1
     8d2:	00004517          	auipc	a0,0x4
     8d6:	63e50513          	addi	a0,a0,1598 # 4f10 <malloc+0x696>
     8da:	00004097          	auipc	ra,0x4
     8de:	ee2080e7          	jalr	-286(ra) # 47bc <printf>
    exit(1);
     8e2:	4505                	li	a0,1
     8e4:	00004097          	auipc	ra,0x4
     8e8:	b58080e7          	jalr	-1192(ra) # 443c <exit>
  wait(&xstatus);
     8ec:	fdc40513          	addi	a0,s0,-36
     8f0:	00004097          	auipc	ra,0x4
     8f4:	b54080e7          	jalr	-1196(ra) # 4444 <wait>
  exit(xstatus);
     8f8:	fdc42503          	lw	a0,-36(s0)
     8fc:	00004097          	auipc	ra,0x4
     900:	b40080e7          	jalr	-1216(ra) # 443c <exit>

0000000000000904 <opentest>:
{
     904:	1101                	addi	sp,sp,-32
     906:	ec06                	sd	ra,24(sp)
     908:	e822                	sd	s0,16(sp)
     90a:	e426                	sd	s1,8(sp)
     90c:	1000                	addi	s0,sp,32
     90e:	84aa                	mv	s1,a0
  fd = open("echo", 0);
     910:	4581                	li	a1,0
     912:	00004517          	auipc	a0,0x4
     916:	61650513          	addi	a0,a0,1558 # 4f28 <malloc+0x6ae>
     91a:	00004097          	auipc	ra,0x4
     91e:	b62080e7          	jalr	-1182(ra) # 447c <open>
  if(fd < 0){
     922:	02054663          	bltz	a0,94e <opentest+0x4a>
  close(fd);
     926:	00004097          	auipc	ra,0x4
     92a:	b3e080e7          	jalr	-1218(ra) # 4464 <close>
  fd = open("doesnotexist", 0);
     92e:	4581                	li	a1,0
     930:	00004517          	auipc	a0,0x4
     934:	61850513          	addi	a0,a0,1560 # 4f48 <malloc+0x6ce>
     938:	00004097          	auipc	ra,0x4
     93c:	b44080e7          	jalr	-1212(ra) # 447c <open>
  if(fd >= 0){
     940:	02055563          	bgez	a0,96a <opentest+0x66>
}
     944:	60e2                	ld	ra,24(sp)
     946:	6442                	ld	s0,16(sp)
     948:	64a2                	ld	s1,8(sp)
     94a:	6105                	addi	sp,sp,32
     94c:	8082                	ret
    printf("%s: open echo failed!\n", s);
     94e:	85a6                	mv	a1,s1
     950:	00004517          	auipc	a0,0x4
     954:	5e050513          	addi	a0,a0,1504 # 4f30 <malloc+0x6b6>
     958:	00004097          	auipc	ra,0x4
     95c:	e64080e7          	jalr	-412(ra) # 47bc <printf>
    exit(1);
     960:	4505                	li	a0,1
     962:	00004097          	auipc	ra,0x4
     966:	ada080e7          	jalr	-1318(ra) # 443c <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     96a:	85a6                	mv	a1,s1
     96c:	00004517          	auipc	a0,0x4
     970:	5ec50513          	addi	a0,a0,1516 # 4f58 <malloc+0x6de>
     974:	00004097          	auipc	ra,0x4
     978:	e48080e7          	jalr	-440(ra) # 47bc <printf>
    exit(1);
     97c:	4505                	li	a0,1
     97e:	00004097          	auipc	ra,0x4
     982:	abe080e7          	jalr	-1346(ra) # 443c <exit>

0000000000000986 <createtest>:
{
     986:	7179                	addi	sp,sp,-48
     988:	f406                	sd	ra,40(sp)
     98a:	f022                	sd	s0,32(sp)
     98c:	ec26                	sd	s1,24(sp)
     98e:	e84a                	sd	s2,16(sp)
     990:	e44e                	sd	s3,8(sp)
     992:	1800                	addi	s0,sp,48
  name[0] = 'a';
     994:	00006797          	auipc	a5,0x6
     998:	09c78793          	addi	a5,a5,156 # 6a30 <_edata>
     99c:	06100713          	li	a4,97
     9a0:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9a4:	00078123          	sb	zero,2(a5)
     9a8:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ac:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9ae:	06400993          	li	s3,100
    name[1] = '0' + i;
     9b2:	009900a3          	sb	s1,1(s2)
    fd = open(name, O_CREATE|O_RDWR);
     9b6:	20200593          	li	a1,514
     9ba:	854a                	mv	a0,s2
     9bc:	00004097          	auipc	ra,0x4
     9c0:	ac0080e7          	jalr	-1344(ra) # 447c <open>
    close(fd);
     9c4:	00004097          	auipc	ra,0x4
     9c8:	aa0080e7          	jalr	-1376(ra) # 4464 <close>
  for(i = 0; i < N; i++){
     9cc:	2485                	addiw	s1,s1,1
     9ce:	0ff4f493          	andi	s1,s1,255
     9d2:	ff3490e3          	bne	s1,s3,9b2 <createtest+0x2c>
  name[0] = 'a';
     9d6:	00006797          	auipc	a5,0x6
     9da:	05a78793          	addi	a5,a5,90 # 6a30 <_edata>
     9de:	06100713          	li	a4,97
     9e2:	00e78023          	sb	a4,0(a5)
  name[2] = '\0';
     9e6:	00078123          	sb	zero,2(a5)
     9ea:	03000493          	li	s1,48
    name[1] = '0' + i;
     9ee:	893e                	mv	s2,a5
  for(i = 0; i < N; i++){
     9f0:	06400993          	li	s3,100
    name[1] = '0' + i;
     9f4:	009900a3          	sb	s1,1(s2)
    unlink(name);
     9f8:	854a                	mv	a0,s2
     9fa:	00004097          	auipc	ra,0x4
     9fe:	a92080e7          	jalr	-1390(ra) # 448c <unlink>
  for(i = 0; i < N; i++){
     a02:	2485                	addiw	s1,s1,1
     a04:	0ff4f493          	andi	s1,s1,255
     a08:	ff3496e3          	bne	s1,s3,9f4 <createtest+0x6e>
}
     a0c:	70a2                	ld	ra,40(sp)
     a0e:	7402                	ld	s0,32(sp)
     a10:	64e2                	ld	s1,24(sp)
     a12:	6942                	ld	s2,16(sp)
     a14:	69a2                	ld	s3,8(sp)
     a16:	6145                	addi	sp,sp,48
     a18:	8082                	ret

0000000000000a1a <forkforkfork>:
{
     a1a:	1101                	addi	sp,sp,-32
     a1c:	ec06                	sd	ra,24(sp)
     a1e:	e822                	sd	s0,16(sp)
     a20:	e426                	sd	s1,8(sp)
     a22:	1000                	addi	s0,sp,32
     a24:	84aa                	mv	s1,a0
  unlink("stopforking");
     a26:	00004517          	auipc	a0,0x4
     a2a:	55a50513          	addi	a0,a0,1370 # 4f80 <malloc+0x706>
     a2e:	00004097          	auipc	ra,0x4
     a32:	a5e080e7          	jalr	-1442(ra) # 448c <unlink>
  int pid = fork();
     a36:	00004097          	auipc	ra,0x4
     a3a:	9fe080e7          	jalr	-1538(ra) # 4434 <fork>
  if(pid < 0){
     a3e:	04054563          	bltz	a0,a88 <forkforkfork+0x6e>
  if(pid == 0){
     a42:	c12d                	beqz	a0,aa4 <forkforkfork+0x8a>
  sleep(20); // two seconds
     a44:	4551                	li	a0,20
     a46:	00004097          	auipc	ra,0x4
     a4a:	a86080e7          	jalr	-1402(ra) # 44cc <sleep>
  close(open("stopforking", O_CREATE|O_RDWR));
     a4e:	20200593          	li	a1,514
     a52:	00004517          	auipc	a0,0x4
     a56:	52e50513          	addi	a0,a0,1326 # 4f80 <malloc+0x706>
     a5a:	00004097          	auipc	ra,0x4
     a5e:	a22080e7          	jalr	-1502(ra) # 447c <open>
     a62:	00004097          	auipc	ra,0x4
     a66:	a02080e7          	jalr	-1534(ra) # 4464 <close>
  wait(0);
     a6a:	4501                	li	a0,0
     a6c:	00004097          	auipc	ra,0x4
     a70:	9d8080e7          	jalr	-1576(ra) # 4444 <wait>
  sleep(10); // one second
     a74:	4529                	li	a0,10
     a76:	00004097          	auipc	ra,0x4
     a7a:	a56080e7          	jalr	-1450(ra) # 44cc <sleep>
}
     a7e:	60e2                	ld	ra,24(sp)
     a80:	6442                	ld	s0,16(sp)
     a82:	64a2                	ld	s1,8(sp)
     a84:	6105                	addi	sp,sp,32
     a86:	8082                	ret
    printf("%s: fork failed", s);
     a88:	85a6                	mv	a1,s1
     a8a:	00004517          	auipc	a0,0x4
     a8e:	35650513          	addi	a0,a0,854 # 4de0 <malloc+0x566>
     a92:	00004097          	auipc	ra,0x4
     a96:	d2a080e7          	jalr	-726(ra) # 47bc <printf>
    exit(1);
     a9a:	4505                	li	a0,1
     a9c:	00004097          	auipc	ra,0x4
     aa0:	9a0080e7          	jalr	-1632(ra) # 443c <exit>
      int fd = open("stopforking", 0);
     aa4:	00004497          	auipc	s1,0x4
     aa8:	4dc48493          	addi	s1,s1,1244 # 4f80 <malloc+0x706>
     aac:	4581                	li	a1,0
     aae:	8526                	mv	a0,s1
     ab0:	00004097          	auipc	ra,0x4
     ab4:	9cc080e7          	jalr	-1588(ra) # 447c <open>
      if(fd >= 0){
     ab8:	02055463          	bgez	a0,ae0 <forkforkfork+0xc6>
      if(fork() < 0){
     abc:	00004097          	auipc	ra,0x4
     ac0:	978080e7          	jalr	-1672(ra) # 4434 <fork>
     ac4:	fe0554e3          	bgez	a0,aac <forkforkfork+0x92>
        close(open("stopforking", O_CREATE|O_RDWR));
     ac8:	20200593          	li	a1,514
     acc:	8526                	mv	a0,s1
     ace:	00004097          	auipc	ra,0x4
     ad2:	9ae080e7          	jalr	-1618(ra) # 447c <open>
     ad6:	00004097          	auipc	ra,0x4
     ada:	98e080e7          	jalr	-1650(ra) # 4464 <close>
     ade:	b7f9                	j	aac <forkforkfork+0x92>
        exit(0);
     ae0:	4501                	li	a0,0
     ae2:	00004097          	auipc	ra,0x4
     ae6:	95a080e7          	jalr	-1702(ra) # 443c <exit>

0000000000000aea <createdelete>:
{
     aea:	7175                	addi	sp,sp,-144
     aec:	e506                	sd	ra,136(sp)
     aee:	e122                	sd	s0,128(sp)
     af0:	fca6                	sd	s1,120(sp)
     af2:	f8ca                	sd	s2,112(sp)
     af4:	f4ce                	sd	s3,104(sp)
     af6:	f0d2                	sd	s4,96(sp)
     af8:	ecd6                	sd	s5,88(sp)
     afa:	e8da                	sd	s6,80(sp)
     afc:	e4de                	sd	s7,72(sp)
     afe:	e0e2                	sd	s8,64(sp)
     b00:	fc66                	sd	s9,56(sp)
     b02:	0900                	addi	s0,sp,144
     b04:	8caa                	mv	s9,a0
  for(pi = 0; pi < NCHILD; pi++){
     b06:	4901                	li	s2,0
     b08:	4991                	li	s3,4
    pid = fork();
     b0a:	00004097          	auipc	ra,0x4
     b0e:	92a080e7          	jalr	-1750(ra) # 4434 <fork>
     b12:	84aa                	mv	s1,a0
    if(pid < 0){
     b14:	02054f63          	bltz	a0,b52 <createdelete+0x68>
    if(pid == 0){
     b18:	c939                	beqz	a0,b6e <createdelete+0x84>
  for(pi = 0; pi < NCHILD; pi++){
     b1a:	2905                	addiw	s2,s2,1
     b1c:	ff3917e3          	bne	s2,s3,b0a <createdelete+0x20>
     b20:	4491                	li	s1,4
    wait(&xstatus);
     b22:	f7c40513          	addi	a0,s0,-132
     b26:	00004097          	auipc	ra,0x4
     b2a:	91e080e7          	jalr	-1762(ra) # 4444 <wait>
    if(xstatus != 0)
     b2e:	f7c42903          	lw	s2,-132(s0)
     b32:	0e091263          	bnez	s2,c16 <createdelete+0x12c>
  for(pi = 0; pi < NCHILD; pi++){
     b36:	34fd                	addiw	s1,s1,-1
     b38:	f4ed                	bnez	s1,b22 <createdelete+0x38>
  name[0] = name[1] = name[2] = 0;
     b3a:	f8040123          	sb	zero,-126(s0)
     b3e:	03000993          	li	s3,48
     b42:	5a7d                	li	s4,-1
     b44:	07000c13          	li	s8,112
      } else if((i >= 1 && i < N/2) && fd >= 0){
     b48:	4b21                	li	s6,8
      if((i == 0 || i >= N/2) && fd < 0){
     b4a:	4ba5                	li	s7,9
    for(pi = 0; pi < NCHILD; pi++){
     b4c:	07400a93          	li	s5,116
     b50:	a29d                	j	cb6 <createdelete+0x1cc>
      printf("fork failed\n", s);
     b52:	85e6                	mv	a1,s9
     b54:	00005517          	auipc	a0,0x5
     b58:	b2450513          	addi	a0,a0,-1244 # 5678 <malloc+0xdfe>
     b5c:	00004097          	auipc	ra,0x4
     b60:	c60080e7          	jalr	-928(ra) # 47bc <printf>
      exit(1);
     b64:	4505                	li	a0,1
     b66:	00004097          	auipc	ra,0x4
     b6a:	8d6080e7          	jalr	-1834(ra) # 443c <exit>
      name[0] = 'p' + pi;
     b6e:	0709091b          	addiw	s2,s2,112
     b72:	f9240023          	sb	s2,-128(s0)
      name[2] = '\0';
     b76:	f8040123          	sb	zero,-126(s0)
      for(i = 0; i < N; i++){
     b7a:	4951                	li	s2,20
     b7c:	a015                	j	ba0 <createdelete+0xb6>
          printf("%s: create failed\n", s);
     b7e:	85e6                	mv	a1,s9
     b80:	00004517          	auipc	a0,0x4
     b84:	41050513          	addi	a0,a0,1040 # 4f90 <malloc+0x716>
     b88:	00004097          	auipc	ra,0x4
     b8c:	c34080e7          	jalr	-972(ra) # 47bc <printf>
          exit(1);
     b90:	4505                	li	a0,1
     b92:	00004097          	auipc	ra,0x4
     b96:	8aa080e7          	jalr	-1878(ra) # 443c <exit>
      for(i = 0; i < N; i++){
     b9a:	2485                	addiw	s1,s1,1
     b9c:	07248863          	beq	s1,s2,c0c <createdelete+0x122>
        name[1] = '0' + i;
     ba0:	0304879b          	addiw	a5,s1,48
     ba4:	f8f400a3          	sb	a5,-127(s0)
        fd = open(name, O_CREATE | O_RDWR);
     ba8:	20200593          	li	a1,514
     bac:	f8040513          	addi	a0,s0,-128
     bb0:	00004097          	auipc	ra,0x4
     bb4:	8cc080e7          	jalr	-1844(ra) # 447c <open>
        if(fd < 0){
     bb8:	fc0543e3          	bltz	a0,b7e <createdelete+0x94>
        close(fd);
     bbc:	00004097          	auipc	ra,0x4
     bc0:	8a8080e7          	jalr	-1880(ra) # 4464 <close>
        if(i > 0 && (i % 2 ) == 0){
     bc4:	fc905be3          	blez	s1,b9a <createdelete+0xb0>
     bc8:	0014f793          	andi	a5,s1,1
     bcc:	f7f9                	bnez	a5,b9a <createdelete+0xb0>
          name[1] = '0' + (i / 2);
     bce:	01f4d79b          	srliw	a5,s1,0x1f
     bd2:	9fa5                	addw	a5,a5,s1
     bd4:	4017d79b          	sraiw	a5,a5,0x1
     bd8:	0307879b          	addiw	a5,a5,48
     bdc:	f8f400a3          	sb	a5,-127(s0)
          if(unlink(name) < 0){
     be0:	f8040513          	addi	a0,s0,-128
     be4:	00004097          	auipc	ra,0x4
     be8:	8a8080e7          	jalr	-1880(ra) # 448c <unlink>
     bec:	fa0557e3          	bgez	a0,b9a <createdelete+0xb0>
            printf("%s: unlink failed\n", s);
     bf0:	85e6                	mv	a1,s9
     bf2:	00004517          	auipc	a0,0x4
     bf6:	31e50513          	addi	a0,a0,798 # 4f10 <malloc+0x696>
     bfa:	00004097          	auipc	ra,0x4
     bfe:	bc2080e7          	jalr	-1086(ra) # 47bc <printf>
            exit(1);
     c02:	4505                	li	a0,1
     c04:	00004097          	auipc	ra,0x4
     c08:	838080e7          	jalr	-1992(ra) # 443c <exit>
      exit(0);
     c0c:	4501                	li	a0,0
     c0e:	00004097          	auipc	ra,0x4
     c12:	82e080e7          	jalr	-2002(ra) # 443c <exit>
      exit(1);
     c16:	4505                	li	a0,1
     c18:	00004097          	auipc	ra,0x4
     c1c:	824080e7          	jalr	-2012(ra) # 443c <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
     c20:	f8040613          	addi	a2,s0,-128
     c24:	85e6                	mv	a1,s9
     c26:	00004517          	auipc	a0,0x4
     c2a:	38250513          	addi	a0,a0,898 # 4fa8 <malloc+0x72e>
     c2e:	00004097          	auipc	ra,0x4
     c32:	b8e080e7          	jalr	-1138(ra) # 47bc <printf>
        exit(1);
     c36:	4505                	li	a0,1
     c38:	00004097          	auipc	ra,0x4
     c3c:	804080e7          	jalr	-2044(ra) # 443c <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c40:	054b7163          	bgeu	s6,s4,c82 <createdelete+0x198>
      if(fd >= 0)
     c44:	02055a63          	bgez	a0,c78 <createdelete+0x18e>
    for(pi = 0; pi < NCHILD; pi++){
     c48:	2485                	addiw	s1,s1,1
     c4a:	0ff4f493          	andi	s1,s1,255
     c4e:	05548c63          	beq	s1,s5,ca6 <createdelete+0x1bc>
      name[0] = 'p' + pi;
     c52:	f8940023          	sb	s1,-128(s0)
      name[1] = '0' + i;
     c56:	f93400a3          	sb	s3,-127(s0)
      fd = open(name, 0);
     c5a:	4581                	li	a1,0
     c5c:	f8040513          	addi	a0,s0,-128
     c60:	00004097          	auipc	ra,0x4
     c64:	81c080e7          	jalr	-2020(ra) # 447c <open>
      if((i == 0 || i >= N/2) && fd < 0){
     c68:	00090463          	beqz	s2,c70 <createdelete+0x186>
     c6c:	fd2bdae3          	bge	s7,s2,c40 <createdelete+0x156>
     c70:	fa0548e3          	bltz	a0,c20 <createdelete+0x136>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c74:	014b7963          	bgeu	s6,s4,c86 <createdelete+0x19c>
        close(fd);
     c78:	00003097          	auipc	ra,0x3
     c7c:	7ec080e7          	jalr	2028(ra) # 4464 <close>
     c80:	b7e1                	j	c48 <createdelete+0x15e>
      } else if((i >= 1 && i < N/2) && fd >= 0){
     c82:	fc0543e3          	bltz	a0,c48 <createdelete+0x15e>
        printf("%s: oops createdelete %s did exist\n", s, name);
     c86:	f8040613          	addi	a2,s0,-128
     c8a:	85e6                	mv	a1,s9
     c8c:	00004517          	auipc	a0,0x4
     c90:	34450513          	addi	a0,a0,836 # 4fd0 <malloc+0x756>
     c94:	00004097          	auipc	ra,0x4
     c98:	b28080e7          	jalr	-1240(ra) # 47bc <printf>
        exit(1);
     c9c:	4505                	li	a0,1
     c9e:	00003097          	auipc	ra,0x3
     ca2:	79e080e7          	jalr	1950(ra) # 443c <exit>
  for(i = 0; i < N; i++){
     ca6:	2905                	addiw	s2,s2,1
     ca8:	2a05                	addiw	s4,s4,1
     caa:	2985                	addiw	s3,s3,1
     cac:	0ff9f993          	andi	s3,s3,255
     cb0:	47d1                	li	a5,20
     cb2:	02f90a63          	beq	s2,a5,ce6 <createdelete+0x1fc>
    for(pi = 0; pi < NCHILD; pi++){
     cb6:	84e2                	mv	s1,s8
     cb8:	bf69                	j	c52 <createdelete+0x168>
  for(i = 0; i < N; i++){
     cba:	2905                	addiw	s2,s2,1
     cbc:	0ff97913          	andi	s2,s2,255
     cc0:	2985                	addiw	s3,s3,1
     cc2:	0ff9f993          	andi	s3,s3,255
     cc6:	03490863          	beq	s2,s4,cf6 <createdelete+0x20c>
  name[0] = name[1] = name[2] = 0;
     cca:	84d6                	mv	s1,s5
      name[0] = 'p' + i;
     ccc:	f9240023          	sb	s2,-128(s0)
      name[1] = '0' + i;
     cd0:	f93400a3          	sb	s3,-127(s0)
      unlink(name);
     cd4:	f8040513          	addi	a0,s0,-128
     cd8:	00003097          	auipc	ra,0x3
     cdc:	7b4080e7          	jalr	1972(ra) # 448c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
     ce0:	34fd                	addiw	s1,s1,-1
     ce2:	f4ed                	bnez	s1,ccc <createdelete+0x1e2>
     ce4:	bfd9                	j	cba <createdelete+0x1d0>
     ce6:	03000993          	li	s3,48
     cea:	07000913          	li	s2,112
  name[0] = name[1] = name[2] = 0;
     cee:	4a91                	li	s5,4
  for(i = 0; i < N; i++){
     cf0:	08400a13          	li	s4,132
     cf4:	bfd9                	j	cca <createdelete+0x1e0>
}
     cf6:	60aa                	ld	ra,136(sp)
     cf8:	640a                	ld	s0,128(sp)
     cfa:	74e6                	ld	s1,120(sp)
     cfc:	7946                	ld	s2,112(sp)
     cfe:	79a6                	ld	s3,104(sp)
     d00:	7a06                	ld	s4,96(sp)
     d02:	6ae6                	ld	s5,88(sp)
     d04:	6b46                	ld	s6,80(sp)
     d06:	6ba6                	ld	s7,72(sp)
     d08:	6c06                	ld	s8,64(sp)
     d0a:	7ce2                	ld	s9,56(sp)
     d0c:	6149                	addi	sp,sp,144
     d0e:	8082                	ret

0000000000000d10 <fourteen>:
{
     d10:	1101                	addi	sp,sp,-32
     d12:	ec06                	sd	ra,24(sp)
     d14:	e822                	sd	s0,16(sp)
     d16:	e426                	sd	s1,8(sp)
     d18:	1000                	addi	s0,sp,32
     d1a:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
     d1c:	00004517          	auipc	a0,0x4
     d20:	4ac50513          	addi	a0,a0,1196 # 51c8 <malloc+0x94e>
     d24:	00003097          	auipc	ra,0x3
     d28:	780080e7          	jalr	1920(ra) # 44a4 <mkdir>
     d2c:	e141                	bnez	a0,dac <fourteen+0x9c>
  if(mkdir("12345678901234/123456789012345") != 0){
     d2e:	00004517          	auipc	a0,0x4
     d32:	2f250513          	addi	a0,a0,754 # 5020 <malloc+0x7a6>
     d36:	00003097          	auipc	ra,0x3
     d3a:	76e080e7          	jalr	1902(ra) # 44a4 <mkdir>
     d3e:	e549                	bnez	a0,dc8 <fourteen+0xb8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
     d40:	20000593          	li	a1,512
     d44:	00004517          	auipc	a0,0x4
     d48:	33450513          	addi	a0,a0,820 # 5078 <malloc+0x7fe>
     d4c:	00003097          	auipc	ra,0x3
     d50:	730080e7          	jalr	1840(ra) # 447c <open>
  if(fd < 0){
     d54:	08054863          	bltz	a0,de4 <fourteen+0xd4>
  close(fd);
     d58:	00003097          	auipc	ra,0x3
     d5c:	70c080e7          	jalr	1804(ra) # 4464 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
     d60:	4581                	li	a1,0
     d62:	00004517          	auipc	a0,0x4
     d66:	38e50513          	addi	a0,a0,910 # 50f0 <malloc+0x876>
     d6a:	00003097          	auipc	ra,0x3
     d6e:	712080e7          	jalr	1810(ra) # 447c <open>
  if(fd < 0){
     d72:	08054763          	bltz	a0,e00 <fourteen+0xf0>
  close(fd);
     d76:	00003097          	auipc	ra,0x3
     d7a:	6ee080e7          	jalr	1774(ra) # 4464 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
     d7e:	00004517          	auipc	a0,0x4
     d82:	3e250513          	addi	a0,a0,994 # 5160 <malloc+0x8e6>
     d86:	00003097          	auipc	ra,0x3
     d8a:	71e080e7          	jalr	1822(ra) # 44a4 <mkdir>
     d8e:	c559                	beqz	a0,e1c <fourteen+0x10c>
  if(mkdir("123456789012345/12345678901234") == 0){
     d90:	00004517          	auipc	a0,0x4
     d94:	42850513          	addi	a0,a0,1064 # 51b8 <malloc+0x93e>
     d98:	00003097          	auipc	ra,0x3
     d9c:	70c080e7          	jalr	1804(ra) # 44a4 <mkdir>
     da0:	cd41                	beqz	a0,e38 <fourteen+0x128>
}
     da2:	60e2                	ld	ra,24(sp)
     da4:	6442                	ld	s0,16(sp)
     da6:	64a2                	ld	s1,8(sp)
     da8:	6105                	addi	sp,sp,32
     daa:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
     dac:	85a6                	mv	a1,s1
     dae:	00004517          	auipc	a0,0x4
     db2:	24a50513          	addi	a0,a0,586 # 4ff8 <malloc+0x77e>
     db6:	00004097          	auipc	ra,0x4
     dba:	a06080e7          	jalr	-1530(ra) # 47bc <printf>
    exit(1);
     dbe:	4505                	li	a0,1
     dc0:	00003097          	auipc	ra,0x3
     dc4:	67c080e7          	jalr	1660(ra) # 443c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
     dc8:	85a6                	mv	a1,s1
     dca:	00004517          	auipc	a0,0x4
     dce:	27650513          	addi	a0,a0,630 # 5040 <malloc+0x7c6>
     dd2:	00004097          	auipc	ra,0x4
     dd6:	9ea080e7          	jalr	-1558(ra) # 47bc <printf>
    exit(1);
     dda:	4505                	li	a0,1
     ddc:	00003097          	auipc	ra,0x3
     de0:	660080e7          	jalr	1632(ra) # 443c <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
     de4:	85a6                	mv	a1,s1
     de6:	00004517          	auipc	a0,0x4
     dea:	2c250513          	addi	a0,a0,706 # 50a8 <malloc+0x82e>
     dee:	00004097          	auipc	ra,0x4
     df2:	9ce080e7          	jalr	-1586(ra) # 47bc <printf>
    exit(1);
     df6:	4505                	li	a0,1
     df8:	00003097          	auipc	ra,0x3
     dfc:	644080e7          	jalr	1604(ra) # 443c <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
     e00:	85a6                	mv	a1,s1
     e02:	00004517          	auipc	a0,0x4
     e06:	31e50513          	addi	a0,a0,798 # 5120 <malloc+0x8a6>
     e0a:	00004097          	auipc	ra,0x4
     e0e:	9b2080e7          	jalr	-1614(ra) # 47bc <printf>
    exit(1);
     e12:	4505                	li	a0,1
     e14:	00003097          	auipc	ra,0x3
     e18:	628080e7          	jalr	1576(ra) # 443c <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
     e1c:	85a6                	mv	a1,s1
     e1e:	00004517          	auipc	a0,0x4
     e22:	36250513          	addi	a0,a0,866 # 5180 <malloc+0x906>
     e26:	00004097          	auipc	ra,0x4
     e2a:	996080e7          	jalr	-1642(ra) # 47bc <printf>
    exit(1);
     e2e:	4505                	li	a0,1
     e30:	00003097          	auipc	ra,0x3
     e34:	60c080e7          	jalr	1548(ra) # 443c <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
     e38:	85a6                	mv	a1,s1
     e3a:	00004517          	auipc	a0,0x4
     e3e:	39e50513          	addi	a0,a0,926 # 51d8 <malloc+0x95e>
     e42:	00004097          	auipc	ra,0x4
     e46:	97a080e7          	jalr	-1670(ra) # 47bc <printf>
    exit(1);
     e4a:	4505                	li	a0,1
     e4c:	00003097          	auipc	ra,0x3
     e50:	5f0080e7          	jalr	1520(ra) # 443c <exit>

0000000000000e54 <bigwrite>:
{
     e54:	715d                	addi	sp,sp,-80
     e56:	e486                	sd	ra,72(sp)
     e58:	e0a2                	sd	s0,64(sp)
     e5a:	fc26                	sd	s1,56(sp)
     e5c:	f84a                	sd	s2,48(sp)
     e5e:	f44e                	sd	s3,40(sp)
     e60:	f052                	sd	s4,32(sp)
     e62:	ec56                	sd	s5,24(sp)
     e64:	e85a                	sd	s6,16(sp)
     e66:	e45e                	sd	s7,8(sp)
     e68:	0880                	addi	s0,sp,80
     e6a:	8baa                	mv	s7,a0
  unlink("bigwrite");
     e6c:	00004517          	auipc	a0,0x4
     e70:	c2c50513          	addi	a0,a0,-980 # 4a98 <malloc+0x21e>
     e74:	00003097          	auipc	ra,0x3
     e78:	618080e7          	jalr	1560(ra) # 448c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e7c:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e80:	00004a97          	auipc	s5,0x4
     e84:	c18a8a93          	addi	s5,s5,-1000 # 4a98 <malloc+0x21e>
      int cc = write(fd, buf, sz);
     e88:	00008a17          	auipc	s4,0x8
     e8c:	3c8a0a13          	addi	s4,s4,968 # 9250 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     e90:	6b0d                	lui	s6,0x3
     e92:	1c9b0b13          	addi	s6,s6,457 # 31c9 <dirfile+0x2b>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     e96:	20200593          	li	a1,514
     e9a:	8556                	mv	a0,s5
     e9c:	00003097          	auipc	ra,0x3
     ea0:	5e0080e7          	jalr	1504(ra) # 447c <open>
     ea4:	892a                	mv	s2,a0
    if(fd < 0){
     ea6:	04054d63          	bltz	a0,f00 <bigwrite+0xac>
      int cc = write(fd, buf, sz);
     eaa:	8626                	mv	a2,s1
     eac:	85d2                	mv	a1,s4
     eae:	00003097          	auipc	ra,0x3
     eb2:	5ae080e7          	jalr	1454(ra) # 445c <write>
     eb6:	89aa                	mv	s3,a0
      if(cc != sz){
     eb8:	06a49463          	bne	s1,a0,f20 <bigwrite+0xcc>
      int cc = write(fd, buf, sz);
     ebc:	8626                	mv	a2,s1
     ebe:	85d2                	mv	a1,s4
     ec0:	854a                	mv	a0,s2
     ec2:	00003097          	auipc	ra,0x3
     ec6:	59a080e7          	jalr	1434(ra) # 445c <write>
      if(cc != sz){
     eca:	04951963          	bne	a0,s1,f1c <bigwrite+0xc8>
    close(fd);
     ece:	854a                	mv	a0,s2
     ed0:	00003097          	auipc	ra,0x3
     ed4:	594080e7          	jalr	1428(ra) # 4464 <close>
    unlink("bigwrite");
     ed8:	8556                	mv	a0,s5
     eda:	00003097          	auipc	ra,0x3
     ede:	5b2080e7          	jalr	1458(ra) # 448c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     ee2:	1d74849b          	addiw	s1,s1,471
     ee6:	fb6498e3          	bne	s1,s6,e96 <bigwrite+0x42>
}
     eea:	60a6                	ld	ra,72(sp)
     eec:	6406                	ld	s0,64(sp)
     eee:	74e2                	ld	s1,56(sp)
     ef0:	7942                	ld	s2,48(sp)
     ef2:	79a2                	ld	s3,40(sp)
     ef4:	7a02                	ld	s4,32(sp)
     ef6:	6ae2                	ld	s5,24(sp)
     ef8:	6b42                	ld	s6,16(sp)
     efa:	6ba2                	ld	s7,8(sp)
     efc:	6161                	addi	sp,sp,80
     efe:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     f00:	85de                	mv	a1,s7
     f02:	00004517          	auipc	a0,0x4
     f06:	30e50513          	addi	a0,a0,782 # 5210 <malloc+0x996>
     f0a:	00004097          	auipc	ra,0x4
     f0e:	8b2080e7          	jalr	-1870(ra) # 47bc <printf>
      exit(1);
     f12:	4505                	li	a0,1
     f14:	00003097          	auipc	ra,0x3
     f18:	528080e7          	jalr	1320(ra) # 443c <exit>
     f1c:	84ce                	mv	s1,s3
      int cc = write(fd, buf, sz);
     f1e:	89aa                	mv	s3,a0
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     f20:	86ce                	mv	a3,s3
     f22:	8626                	mv	a2,s1
     f24:	85de                	mv	a1,s7
     f26:	00004517          	auipc	a0,0x4
     f2a:	30a50513          	addi	a0,a0,778 # 5230 <malloc+0x9b6>
     f2e:	00004097          	auipc	ra,0x4
     f32:	88e080e7          	jalr	-1906(ra) # 47bc <printf>
        exit(1);
     f36:	4505                	li	a0,1
     f38:	00003097          	auipc	ra,0x3
     f3c:	504080e7          	jalr	1284(ra) # 443c <exit>

0000000000000f40 <writetest>:
{
     f40:	7139                	addi	sp,sp,-64
     f42:	fc06                	sd	ra,56(sp)
     f44:	f822                	sd	s0,48(sp)
     f46:	f426                	sd	s1,40(sp)
     f48:	f04a                	sd	s2,32(sp)
     f4a:	ec4e                	sd	s3,24(sp)
     f4c:	e852                	sd	s4,16(sp)
     f4e:	e456                	sd	s5,8(sp)
     f50:	e05a                	sd	s6,0(sp)
     f52:	0080                	addi	s0,sp,64
     f54:	8b2a                	mv	s6,a0
  fd = open("small", O_CREATE|O_RDWR);
     f56:	20200593          	li	a1,514
     f5a:	00004517          	auipc	a0,0x4
     f5e:	2ee50513          	addi	a0,a0,750 # 5248 <malloc+0x9ce>
     f62:	00003097          	auipc	ra,0x3
     f66:	51a080e7          	jalr	1306(ra) # 447c <open>
  if(fd < 0){
     f6a:	0a054d63          	bltz	a0,1024 <writetest+0xe4>
     f6e:	892a                	mv	s2,a0
     f70:	4481                	li	s1,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f72:	00004997          	auipc	s3,0x4
     f76:	2fe98993          	addi	s3,s3,766 # 5270 <malloc+0x9f6>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f7a:	00004a97          	auipc	s5,0x4
     f7e:	32ea8a93          	addi	s5,s5,814 # 52a8 <malloc+0xa2e>
  for(i = 0; i < N; i++){
     f82:	06400a13          	li	s4,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     f86:	4629                	li	a2,10
     f88:	85ce                	mv	a1,s3
     f8a:	854a                	mv	a0,s2
     f8c:	00003097          	auipc	ra,0x3
     f90:	4d0080e7          	jalr	1232(ra) # 445c <write>
     f94:	47a9                	li	a5,10
     f96:	0af51563          	bne	a0,a5,1040 <writetest+0x100>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     f9a:	4629                	li	a2,10
     f9c:	85d6                	mv	a1,s5
     f9e:	854a                	mv	a0,s2
     fa0:	00003097          	auipc	ra,0x3
     fa4:	4bc080e7          	jalr	1212(ra) # 445c <write>
     fa8:	47a9                	li	a5,10
     faa:	0af51963          	bne	a0,a5,105c <writetest+0x11c>
  for(i = 0; i < N; i++){
     fae:	2485                	addiw	s1,s1,1
     fb0:	fd449be3          	bne	s1,s4,f86 <writetest+0x46>
  close(fd);
     fb4:	854a                	mv	a0,s2
     fb6:	00003097          	auipc	ra,0x3
     fba:	4ae080e7          	jalr	1198(ra) # 4464 <close>
  fd = open("small", O_RDONLY);
     fbe:	4581                	li	a1,0
     fc0:	00004517          	auipc	a0,0x4
     fc4:	28850513          	addi	a0,a0,648 # 5248 <malloc+0x9ce>
     fc8:	00003097          	auipc	ra,0x3
     fcc:	4b4080e7          	jalr	1204(ra) # 447c <open>
     fd0:	84aa                	mv	s1,a0
  if(fd < 0){
     fd2:	0a054363          	bltz	a0,1078 <writetest+0x138>
  i = read(fd, buf, N*SZ*2);
     fd6:	7d000613          	li	a2,2000
     fda:	00008597          	auipc	a1,0x8
     fde:	27658593          	addi	a1,a1,630 # 9250 <buf>
     fe2:	00003097          	auipc	ra,0x3
     fe6:	472080e7          	jalr	1138(ra) # 4454 <read>
  if(i != N*SZ*2){
     fea:	7d000793          	li	a5,2000
     fee:	0af51363          	bne	a0,a5,1094 <writetest+0x154>
  close(fd);
     ff2:	8526                	mv	a0,s1
     ff4:	00003097          	auipc	ra,0x3
     ff8:	470080e7          	jalr	1136(ra) # 4464 <close>
  if(unlink("small") < 0){
     ffc:	00004517          	auipc	a0,0x4
    1000:	24c50513          	addi	a0,a0,588 # 5248 <malloc+0x9ce>
    1004:	00003097          	auipc	ra,0x3
    1008:	488080e7          	jalr	1160(ra) # 448c <unlink>
    100c:	0a054263          	bltz	a0,10b0 <writetest+0x170>
}
    1010:	70e2                	ld	ra,56(sp)
    1012:	7442                	ld	s0,48(sp)
    1014:	74a2                	ld	s1,40(sp)
    1016:	7902                	ld	s2,32(sp)
    1018:	69e2                	ld	s3,24(sp)
    101a:	6a42                	ld	s4,16(sp)
    101c:	6aa2                	ld	s5,8(sp)
    101e:	6b02                	ld	s6,0(sp)
    1020:	6121                	addi	sp,sp,64
    1022:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
    1024:	85da                	mv	a1,s6
    1026:	00004517          	auipc	a0,0x4
    102a:	22a50513          	addi	a0,a0,554 # 5250 <malloc+0x9d6>
    102e:	00003097          	auipc	ra,0x3
    1032:	78e080e7          	jalr	1934(ra) # 47bc <printf>
    exit(1);
    1036:	4505                	li	a0,1
    1038:	00003097          	auipc	ra,0x3
    103c:	404080e7          	jalr	1028(ra) # 443c <exit>
      printf("%s: error: write aa %d new file failed\n", i);
    1040:	85a6                	mv	a1,s1
    1042:	00004517          	auipc	a0,0x4
    1046:	23e50513          	addi	a0,a0,574 # 5280 <malloc+0xa06>
    104a:	00003097          	auipc	ra,0x3
    104e:	772080e7          	jalr	1906(ra) # 47bc <printf>
      exit(1);
    1052:	4505                	li	a0,1
    1054:	00003097          	auipc	ra,0x3
    1058:	3e8080e7          	jalr	1000(ra) # 443c <exit>
      printf("%s: error: write bb %d new file failed\n", i);
    105c:	85a6                	mv	a1,s1
    105e:	00004517          	auipc	a0,0x4
    1062:	25a50513          	addi	a0,a0,602 # 52b8 <malloc+0xa3e>
    1066:	00003097          	auipc	ra,0x3
    106a:	756080e7          	jalr	1878(ra) # 47bc <printf>
      exit(1);
    106e:	4505                	li	a0,1
    1070:	00003097          	auipc	ra,0x3
    1074:	3cc080e7          	jalr	972(ra) # 443c <exit>
    printf("%s: error: open small failed!\n", s);
    1078:	85da                	mv	a1,s6
    107a:	00004517          	auipc	a0,0x4
    107e:	26650513          	addi	a0,a0,614 # 52e0 <malloc+0xa66>
    1082:	00003097          	auipc	ra,0x3
    1086:	73a080e7          	jalr	1850(ra) # 47bc <printf>
    exit(1);
    108a:	4505                	li	a0,1
    108c:	00003097          	auipc	ra,0x3
    1090:	3b0080e7          	jalr	944(ra) # 443c <exit>
    printf("%s: read failed\n", s);
    1094:	85da                	mv	a1,s6
    1096:	00004517          	auipc	a0,0x4
    109a:	26a50513          	addi	a0,a0,618 # 5300 <malloc+0xa86>
    109e:	00003097          	auipc	ra,0x3
    10a2:	71e080e7          	jalr	1822(ra) # 47bc <printf>
    exit(1);
    10a6:	4505                	li	a0,1
    10a8:	00003097          	auipc	ra,0x3
    10ac:	394080e7          	jalr	916(ra) # 443c <exit>
    printf("%s: unlink small failed\n", s);
    10b0:	85da                	mv	a1,s6
    10b2:	00004517          	auipc	a0,0x4
    10b6:	26650513          	addi	a0,a0,614 # 5318 <malloc+0xa9e>
    10ba:	00003097          	auipc	ra,0x3
    10be:	702080e7          	jalr	1794(ra) # 47bc <printf>
    exit(1);
    10c2:	4505                	li	a0,1
    10c4:	00003097          	auipc	ra,0x3
    10c8:	378080e7          	jalr	888(ra) # 443c <exit>

00000000000010cc <writebig>:
{
    10cc:	7139                	addi	sp,sp,-64
    10ce:	fc06                	sd	ra,56(sp)
    10d0:	f822                	sd	s0,48(sp)
    10d2:	f426                	sd	s1,40(sp)
    10d4:	f04a                	sd	s2,32(sp)
    10d6:	ec4e                	sd	s3,24(sp)
    10d8:	e852                	sd	s4,16(sp)
    10da:	e456                	sd	s5,8(sp)
    10dc:	0080                	addi	s0,sp,64
    10de:	8aaa                	mv	s5,a0
  fd = open("big", O_CREATE|O_RDWR);
    10e0:	20200593          	li	a1,514
    10e4:	00004517          	auipc	a0,0x4
    10e8:	25450513          	addi	a0,a0,596 # 5338 <malloc+0xabe>
    10ec:	00003097          	auipc	ra,0x3
    10f0:	390080e7          	jalr	912(ra) # 447c <open>
    10f4:	89aa                	mv	s3,a0
  for(i = 0; i < MAXFILE; i++){
    10f6:	4481                	li	s1,0
    ((int*)buf)[0] = i;
    10f8:	00008917          	auipc	s2,0x8
    10fc:	15890913          	addi	s2,s2,344 # 9250 <buf>
  for(i = 0; i < MAXFILE; i++){
    1100:	10c00a13          	li	s4,268
  if(fd < 0){
    1104:	06054c63          	bltz	a0,117c <writebig+0xb0>
    ((int*)buf)[0] = i;
    1108:	00992023          	sw	s1,0(s2)
    if(write(fd, buf, BSIZE) != BSIZE){
    110c:	40000613          	li	a2,1024
    1110:	85ca                	mv	a1,s2
    1112:	854e                	mv	a0,s3
    1114:	00003097          	auipc	ra,0x3
    1118:	348080e7          	jalr	840(ra) # 445c <write>
    111c:	40000793          	li	a5,1024
    1120:	06f51c63          	bne	a0,a5,1198 <writebig+0xcc>
  for(i = 0; i < MAXFILE; i++){
    1124:	2485                	addiw	s1,s1,1
    1126:	ff4491e3          	bne	s1,s4,1108 <writebig+0x3c>
  close(fd);
    112a:	854e                	mv	a0,s3
    112c:	00003097          	auipc	ra,0x3
    1130:	338080e7          	jalr	824(ra) # 4464 <close>
  fd = open("big", O_RDONLY);
    1134:	4581                	li	a1,0
    1136:	00004517          	auipc	a0,0x4
    113a:	20250513          	addi	a0,a0,514 # 5338 <malloc+0xabe>
    113e:	00003097          	auipc	ra,0x3
    1142:	33e080e7          	jalr	830(ra) # 447c <open>
    1146:	89aa                	mv	s3,a0
  n = 0;
    1148:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
    114a:	00008917          	auipc	s2,0x8
    114e:	10690913          	addi	s2,s2,262 # 9250 <buf>
  if(fd < 0){
    1152:	06054163          	bltz	a0,11b4 <writebig+0xe8>
    i = read(fd, buf, BSIZE);
    1156:	40000613          	li	a2,1024
    115a:	85ca                	mv	a1,s2
    115c:	854e                	mv	a0,s3
    115e:	00003097          	auipc	ra,0x3
    1162:	2f6080e7          	jalr	758(ra) # 4454 <read>
    if(i == 0){
    1166:	c52d                	beqz	a0,11d0 <writebig+0x104>
    } else if(i != BSIZE){
    1168:	40000793          	li	a5,1024
    116c:	0af51d63          	bne	a0,a5,1226 <writebig+0x15a>
    if(((int*)buf)[0] != n){
    1170:	00092603          	lw	a2,0(s2)
    1174:	0c961763          	bne	a2,s1,1242 <writebig+0x176>
    n++;
    1178:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
    117a:	bff1                	j	1156 <writebig+0x8a>
    printf("%s: error: creat big failed!\n", s);
    117c:	85d6                	mv	a1,s5
    117e:	00004517          	auipc	a0,0x4
    1182:	1c250513          	addi	a0,a0,450 # 5340 <malloc+0xac6>
    1186:	00003097          	auipc	ra,0x3
    118a:	636080e7          	jalr	1590(ra) # 47bc <printf>
    exit(1);
    118e:	4505                	li	a0,1
    1190:	00003097          	auipc	ra,0x3
    1194:	2ac080e7          	jalr	684(ra) # 443c <exit>
      printf("%s: error: write big file failed\n", i);
    1198:	85a6                	mv	a1,s1
    119a:	00004517          	auipc	a0,0x4
    119e:	1c650513          	addi	a0,a0,454 # 5360 <malloc+0xae6>
    11a2:	00003097          	auipc	ra,0x3
    11a6:	61a080e7          	jalr	1562(ra) # 47bc <printf>
      exit(1);
    11aa:	4505                	li	a0,1
    11ac:	00003097          	auipc	ra,0x3
    11b0:	290080e7          	jalr	656(ra) # 443c <exit>
    printf("%s: error: open big failed!\n", s);
    11b4:	85d6                	mv	a1,s5
    11b6:	00004517          	auipc	a0,0x4
    11ba:	1d250513          	addi	a0,a0,466 # 5388 <malloc+0xb0e>
    11be:	00003097          	auipc	ra,0x3
    11c2:	5fe080e7          	jalr	1534(ra) # 47bc <printf>
    exit(1);
    11c6:	4505                	li	a0,1
    11c8:	00003097          	auipc	ra,0x3
    11cc:	274080e7          	jalr	628(ra) # 443c <exit>
      if(n == MAXFILE - 1){
    11d0:	10b00793          	li	a5,267
    11d4:	02f48a63          	beq	s1,a5,1208 <writebig+0x13c>
  close(fd);
    11d8:	854e                	mv	a0,s3
    11da:	00003097          	auipc	ra,0x3
    11de:	28a080e7          	jalr	650(ra) # 4464 <close>
  if(unlink("big") < 0){
    11e2:	00004517          	auipc	a0,0x4
    11e6:	15650513          	addi	a0,a0,342 # 5338 <malloc+0xabe>
    11ea:	00003097          	auipc	ra,0x3
    11ee:	2a2080e7          	jalr	674(ra) # 448c <unlink>
    11f2:	06054663          	bltz	a0,125e <writebig+0x192>
}
    11f6:	70e2                	ld	ra,56(sp)
    11f8:	7442                	ld	s0,48(sp)
    11fa:	74a2                	ld	s1,40(sp)
    11fc:	7902                	ld	s2,32(sp)
    11fe:	69e2                	ld	s3,24(sp)
    1200:	6a42                	ld	s4,16(sp)
    1202:	6aa2                	ld	s5,8(sp)
    1204:	6121                	addi	sp,sp,64
    1206:	8082                	ret
        printf("%s: read only %d blocks from big", n);
    1208:	10b00593          	li	a1,267
    120c:	00004517          	auipc	a0,0x4
    1210:	19c50513          	addi	a0,a0,412 # 53a8 <malloc+0xb2e>
    1214:	00003097          	auipc	ra,0x3
    1218:	5a8080e7          	jalr	1448(ra) # 47bc <printf>
        exit(1);
    121c:	4505                	li	a0,1
    121e:	00003097          	auipc	ra,0x3
    1222:	21e080e7          	jalr	542(ra) # 443c <exit>
      printf("%s: read failed %d\n", i);
    1226:	85aa                	mv	a1,a0
    1228:	00004517          	auipc	a0,0x4
    122c:	1a850513          	addi	a0,a0,424 # 53d0 <malloc+0xb56>
    1230:	00003097          	auipc	ra,0x3
    1234:	58c080e7          	jalr	1420(ra) # 47bc <printf>
      exit(1);
    1238:	4505                	li	a0,1
    123a:	00003097          	auipc	ra,0x3
    123e:	202080e7          	jalr	514(ra) # 443c <exit>
      printf("%s: read content of block %d is %d\n",
    1242:	85a6                	mv	a1,s1
    1244:	00004517          	auipc	a0,0x4
    1248:	1a450513          	addi	a0,a0,420 # 53e8 <malloc+0xb6e>
    124c:	00003097          	auipc	ra,0x3
    1250:	570080e7          	jalr	1392(ra) # 47bc <printf>
      exit(1);
    1254:	4505                	li	a0,1
    1256:	00003097          	auipc	ra,0x3
    125a:	1e6080e7          	jalr	486(ra) # 443c <exit>
    printf("%s: unlink big failed\n", s);
    125e:	85d6                	mv	a1,s5
    1260:	00004517          	auipc	a0,0x4
    1264:	1b050513          	addi	a0,a0,432 # 5410 <malloc+0xb96>
    1268:	00003097          	auipc	ra,0x3
    126c:	554080e7          	jalr	1364(ra) # 47bc <printf>
    exit(1);
    1270:	4505                	li	a0,1
    1272:	00003097          	auipc	ra,0x3
    1276:	1ca080e7          	jalr	458(ra) # 443c <exit>

000000000000127a <unlinkread>:
{
    127a:	7179                	addi	sp,sp,-48
    127c:	f406                	sd	ra,40(sp)
    127e:	f022                	sd	s0,32(sp)
    1280:	ec26                	sd	s1,24(sp)
    1282:	e84a                	sd	s2,16(sp)
    1284:	e44e                	sd	s3,8(sp)
    1286:	1800                	addi	s0,sp,48
    1288:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
    128a:	20200593          	li	a1,514
    128e:	00003517          	auipc	a0,0x3
    1292:	7a250513          	addi	a0,a0,1954 # 4a30 <malloc+0x1b6>
    1296:	00003097          	auipc	ra,0x3
    129a:	1e6080e7          	jalr	486(ra) # 447c <open>
  if(fd < 0){
    129e:	0e054563          	bltz	a0,1388 <unlinkread+0x10e>
    12a2:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
    12a4:	4615                	li	a2,5
    12a6:	00004597          	auipc	a1,0x4
    12aa:	1a258593          	addi	a1,a1,418 # 5448 <malloc+0xbce>
    12ae:	00003097          	auipc	ra,0x3
    12b2:	1ae080e7          	jalr	430(ra) # 445c <write>
  close(fd);
    12b6:	8526                	mv	a0,s1
    12b8:	00003097          	auipc	ra,0x3
    12bc:	1ac080e7          	jalr	428(ra) # 4464 <close>
  fd = open("unlinkread", O_RDWR);
    12c0:	4589                	li	a1,2
    12c2:	00003517          	auipc	a0,0x3
    12c6:	76e50513          	addi	a0,a0,1902 # 4a30 <malloc+0x1b6>
    12ca:	00003097          	auipc	ra,0x3
    12ce:	1b2080e7          	jalr	434(ra) # 447c <open>
    12d2:	84aa                	mv	s1,a0
  if(fd < 0){
    12d4:	0c054863          	bltz	a0,13a4 <unlinkread+0x12a>
  if(unlink("unlinkread") != 0){
    12d8:	00003517          	auipc	a0,0x3
    12dc:	75850513          	addi	a0,a0,1880 # 4a30 <malloc+0x1b6>
    12e0:	00003097          	auipc	ra,0x3
    12e4:	1ac080e7          	jalr	428(ra) # 448c <unlink>
    12e8:	ed61                	bnez	a0,13c0 <unlinkread+0x146>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    12ea:	20200593          	li	a1,514
    12ee:	00003517          	auipc	a0,0x3
    12f2:	74250513          	addi	a0,a0,1858 # 4a30 <malloc+0x1b6>
    12f6:	00003097          	auipc	ra,0x3
    12fa:	186080e7          	jalr	390(ra) # 447c <open>
    12fe:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
    1300:	460d                	li	a2,3
    1302:	00004597          	auipc	a1,0x4
    1306:	18e58593          	addi	a1,a1,398 # 5490 <malloc+0xc16>
    130a:	00003097          	auipc	ra,0x3
    130e:	152080e7          	jalr	338(ra) # 445c <write>
  close(fd1);
    1312:	854a                	mv	a0,s2
    1314:	00003097          	auipc	ra,0x3
    1318:	150080e7          	jalr	336(ra) # 4464 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
    131c:	660d                	lui	a2,0x3
    131e:	00008597          	auipc	a1,0x8
    1322:	f3258593          	addi	a1,a1,-206 # 9250 <buf>
    1326:	8526                	mv	a0,s1
    1328:	00003097          	auipc	ra,0x3
    132c:	12c080e7          	jalr	300(ra) # 4454 <read>
    1330:	4795                	li	a5,5
    1332:	0af51563          	bne	a0,a5,13dc <unlinkread+0x162>
  if(buf[0] != 'h'){
    1336:	00008717          	auipc	a4,0x8
    133a:	f1a74703          	lbu	a4,-230(a4) # 9250 <buf>
    133e:	06800793          	li	a5,104
    1342:	0af71b63          	bne	a4,a5,13f8 <unlinkread+0x17e>
  if(write(fd, buf, 10) != 10){
    1346:	4629                	li	a2,10
    1348:	00008597          	auipc	a1,0x8
    134c:	f0858593          	addi	a1,a1,-248 # 9250 <buf>
    1350:	8526                	mv	a0,s1
    1352:	00003097          	auipc	ra,0x3
    1356:	10a080e7          	jalr	266(ra) # 445c <write>
    135a:	47a9                	li	a5,10
    135c:	0af51c63          	bne	a0,a5,1414 <unlinkread+0x19a>
  close(fd);
    1360:	8526                	mv	a0,s1
    1362:	00003097          	auipc	ra,0x3
    1366:	102080e7          	jalr	258(ra) # 4464 <close>
  unlink("unlinkread");
    136a:	00003517          	auipc	a0,0x3
    136e:	6c650513          	addi	a0,a0,1734 # 4a30 <malloc+0x1b6>
    1372:	00003097          	auipc	ra,0x3
    1376:	11a080e7          	jalr	282(ra) # 448c <unlink>
}
    137a:	70a2                	ld	ra,40(sp)
    137c:	7402                	ld	s0,32(sp)
    137e:	64e2                	ld	s1,24(sp)
    1380:	6942                	ld	s2,16(sp)
    1382:	69a2                	ld	s3,8(sp)
    1384:	6145                	addi	sp,sp,48
    1386:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
    1388:	85ce                	mv	a1,s3
    138a:	00004517          	auipc	a0,0x4
    138e:	09e50513          	addi	a0,a0,158 # 5428 <malloc+0xbae>
    1392:	00003097          	auipc	ra,0x3
    1396:	42a080e7          	jalr	1066(ra) # 47bc <printf>
    exit(1);
    139a:	4505                	li	a0,1
    139c:	00003097          	auipc	ra,0x3
    13a0:	0a0080e7          	jalr	160(ra) # 443c <exit>
    printf("%s: open unlinkread failed\n", s);
    13a4:	85ce                	mv	a1,s3
    13a6:	00004517          	auipc	a0,0x4
    13aa:	0aa50513          	addi	a0,a0,170 # 5450 <malloc+0xbd6>
    13ae:	00003097          	auipc	ra,0x3
    13b2:	40e080e7          	jalr	1038(ra) # 47bc <printf>
    exit(1);
    13b6:	4505                	li	a0,1
    13b8:	00003097          	auipc	ra,0x3
    13bc:	084080e7          	jalr	132(ra) # 443c <exit>
    printf("%s: unlink unlinkread failed\n", s);
    13c0:	85ce                	mv	a1,s3
    13c2:	00004517          	auipc	a0,0x4
    13c6:	0ae50513          	addi	a0,a0,174 # 5470 <malloc+0xbf6>
    13ca:	00003097          	auipc	ra,0x3
    13ce:	3f2080e7          	jalr	1010(ra) # 47bc <printf>
    exit(1);
    13d2:	4505                	li	a0,1
    13d4:	00003097          	auipc	ra,0x3
    13d8:	068080e7          	jalr	104(ra) # 443c <exit>
    printf("%s: unlinkread read failed", s);
    13dc:	85ce                	mv	a1,s3
    13de:	00004517          	auipc	a0,0x4
    13e2:	0ba50513          	addi	a0,a0,186 # 5498 <malloc+0xc1e>
    13e6:	00003097          	auipc	ra,0x3
    13ea:	3d6080e7          	jalr	982(ra) # 47bc <printf>
    exit(1);
    13ee:	4505                	li	a0,1
    13f0:	00003097          	auipc	ra,0x3
    13f4:	04c080e7          	jalr	76(ra) # 443c <exit>
    printf("%s: unlinkread wrong data\n", s);
    13f8:	85ce                	mv	a1,s3
    13fa:	00004517          	auipc	a0,0x4
    13fe:	0be50513          	addi	a0,a0,190 # 54b8 <malloc+0xc3e>
    1402:	00003097          	auipc	ra,0x3
    1406:	3ba080e7          	jalr	954(ra) # 47bc <printf>
    exit(1);
    140a:	4505                	li	a0,1
    140c:	00003097          	auipc	ra,0x3
    1410:	030080e7          	jalr	48(ra) # 443c <exit>
    printf("%s: unlinkread write failed\n", s);
    1414:	85ce                	mv	a1,s3
    1416:	00004517          	auipc	a0,0x4
    141a:	0c250513          	addi	a0,a0,194 # 54d8 <malloc+0xc5e>
    141e:	00003097          	auipc	ra,0x3
    1422:	39e080e7          	jalr	926(ra) # 47bc <printf>
    exit(1);
    1426:	4505                	li	a0,1
    1428:	00003097          	auipc	ra,0x3
    142c:	014080e7          	jalr	20(ra) # 443c <exit>

0000000000001430 <exectest>:
{
    1430:	715d                	addi	sp,sp,-80
    1432:	e486                	sd	ra,72(sp)
    1434:	e0a2                	sd	s0,64(sp)
    1436:	fc26                	sd	s1,56(sp)
    1438:	f84a                	sd	s2,48(sp)
    143a:	0880                	addi	s0,sp,80
    143c:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    143e:	00004797          	auipc	a5,0x4
    1442:	aea78793          	addi	a5,a5,-1302 # 4f28 <malloc+0x6ae>
    1446:	fcf43023          	sd	a5,-64(s0)
    144a:	00004797          	auipc	a5,0x4
    144e:	0ae78793          	addi	a5,a5,174 # 54f8 <malloc+0xc7e>
    1452:	fcf43423          	sd	a5,-56(s0)
    1456:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    145a:	00004517          	auipc	a0,0x4
    145e:	0a650513          	addi	a0,a0,166 # 5500 <malloc+0xc86>
    1462:	00003097          	auipc	ra,0x3
    1466:	02a080e7          	jalr	42(ra) # 448c <unlink>
  pid = fork();
    146a:	00003097          	auipc	ra,0x3
    146e:	fca080e7          	jalr	-54(ra) # 4434 <fork>
  if(pid < 0) {
    1472:	04054663          	bltz	a0,14be <exectest+0x8e>
    1476:	84aa                	mv	s1,a0
  if(pid == 0) {
    1478:	e959                	bnez	a0,150e <exectest+0xde>
    close(1);
    147a:	4505                	li	a0,1
    147c:	00003097          	auipc	ra,0x3
    1480:	fe8080e7          	jalr	-24(ra) # 4464 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1484:	20100593          	li	a1,513
    1488:	00004517          	auipc	a0,0x4
    148c:	07850513          	addi	a0,a0,120 # 5500 <malloc+0xc86>
    1490:	00003097          	auipc	ra,0x3
    1494:	fec080e7          	jalr	-20(ra) # 447c <open>
    if(fd < 0) {
    1498:	04054163          	bltz	a0,14da <exectest+0xaa>
    if(fd != 1) {
    149c:	4785                	li	a5,1
    149e:	04f50c63          	beq	a0,a5,14f6 <exectest+0xc6>
      printf("%s: wrong fd\n", s);
    14a2:	85ca                	mv	a1,s2
    14a4:	00004517          	auipc	a0,0x4
    14a8:	06450513          	addi	a0,a0,100 # 5508 <malloc+0xc8e>
    14ac:	00003097          	auipc	ra,0x3
    14b0:	310080e7          	jalr	784(ra) # 47bc <printf>
      exit(1);
    14b4:	4505                	li	a0,1
    14b6:	00003097          	auipc	ra,0x3
    14ba:	f86080e7          	jalr	-122(ra) # 443c <exit>
     printf("%s: fork failed\n", s);
    14be:	85ca                	mv	a1,s2
    14c0:	00004517          	auipc	a0,0x4
    14c4:	8b850513          	addi	a0,a0,-1864 # 4d78 <malloc+0x4fe>
    14c8:	00003097          	auipc	ra,0x3
    14cc:	2f4080e7          	jalr	756(ra) # 47bc <printf>
     exit(1);
    14d0:	4505                	li	a0,1
    14d2:	00003097          	auipc	ra,0x3
    14d6:	f6a080e7          	jalr	-150(ra) # 443c <exit>
      printf("%s: create failed\n", s);
    14da:	85ca                	mv	a1,s2
    14dc:	00004517          	auipc	a0,0x4
    14e0:	ab450513          	addi	a0,a0,-1356 # 4f90 <malloc+0x716>
    14e4:	00003097          	auipc	ra,0x3
    14e8:	2d8080e7          	jalr	728(ra) # 47bc <printf>
      exit(1);
    14ec:	4505                	li	a0,1
    14ee:	00003097          	auipc	ra,0x3
    14f2:	f4e080e7          	jalr	-178(ra) # 443c <exit>
    if(exec("echo", echoargv) < 0){
    14f6:	fc040593          	addi	a1,s0,-64
    14fa:	00004517          	auipc	a0,0x4
    14fe:	a2e50513          	addi	a0,a0,-1490 # 4f28 <malloc+0x6ae>
    1502:	00003097          	auipc	ra,0x3
    1506:	f72080e7          	jalr	-142(ra) # 4474 <exec>
    150a:	02054163          	bltz	a0,152c <exectest+0xfc>
  if (wait(&xstatus) != pid) {
    150e:	fdc40513          	addi	a0,s0,-36
    1512:	00003097          	auipc	ra,0x3
    1516:	f32080e7          	jalr	-206(ra) # 4444 <wait>
    151a:	02951763          	bne	a0,s1,1548 <exectest+0x118>
  if(xstatus != 0)
    151e:	fdc42503          	lw	a0,-36(s0)
    1522:	cd0d                	beqz	a0,155c <exectest+0x12c>
    exit(xstatus);
    1524:	00003097          	auipc	ra,0x3
    1528:	f18080e7          	jalr	-232(ra) # 443c <exit>
      printf("%s: exec echo failed\n", s);
    152c:	85ca                	mv	a1,s2
    152e:	00004517          	auipc	a0,0x4
    1532:	fea50513          	addi	a0,a0,-22 # 5518 <malloc+0xc9e>
    1536:	00003097          	auipc	ra,0x3
    153a:	286080e7          	jalr	646(ra) # 47bc <printf>
      exit(1);
    153e:	4505                	li	a0,1
    1540:	00003097          	auipc	ra,0x3
    1544:	efc080e7          	jalr	-260(ra) # 443c <exit>
    printf("%s: wait failed!\n", s);
    1548:	85ca                	mv	a1,s2
    154a:	00004517          	auipc	a0,0x4
    154e:	fe650513          	addi	a0,a0,-26 # 5530 <malloc+0xcb6>
    1552:	00003097          	auipc	ra,0x3
    1556:	26a080e7          	jalr	618(ra) # 47bc <printf>
    155a:	b7d1                	j	151e <exectest+0xee>
  fd = open("echo-ok", O_RDONLY);
    155c:	4581                	li	a1,0
    155e:	00004517          	auipc	a0,0x4
    1562:	fa250513          	addi	a0,a0,-94 # 5500 <malloc+0xc86>
    1566:	00003097          	auipc	ra,0x3
    156a:	f16080e7          	jalr	-234(ra) # 447c <open>
  if(fd < 0) {
    156e:	02054a63          	bltz	a0,15a2 <exectest+0x172>
  if (read(fd, buf, 2) != 2) {
    1572:	4609                	li	a2,2
    1574:	fb840593          	addi	a1,s0,-72
    1578:	00003097          	auipc	ra,0x3
    157c:	edc080e7          	jalr	-292(ra) # 4454 <read>
    1580:	4789                	li	a5,2
    1582:	02f50e63          	beq	a0,a5,15be <exectest+0x18e>
    printf("%s: read failed\n", s);
    1586:	85ca                	mv	a1,s2
    1588:	00004517          	auipc	a0,0x4
    158c:	d7850513          	addi	a0,a0,-648 # 5300 <malloc+0xa86>
    1590:	00003097          	auipc	ra,0x3
    1594:	22c080e7          	jalr	556(ra) # 47bc <printf>
    exit(1);
    1598:	4505                	li	a0,1
    159a:	00003097          	auipc	ra,0x3
    159e:	ea2080e7          	jalr	-350(ra) # 443c <exit>
    printf("%s: open failed\n", s);
    15a2:	85ca                	mv	a1,s2
    15a4:	00004517          	auipc	a0,0x4
    15a8:	fa450513          	addi	a0,a0,-92 # 5548 <malloc+0xcce>
    15ac:	00003097          	auipc	ra,0x3
    15b0:	210080e7          	jalr	528(ra) # 47bc <printf>
    exit(1);
    15b4:	4505                	li	a0,1
    15b6:	00003097          	auipc	ra,0x3
    15ba:	e86080e7          	jalr	-378(ra) # 443c <exit>
  unlink("echo-ok");
    15be:	00004517          	auipc	a0,0x4
    15c2:	f4250513          	addi	a0,a0,-190 # 5500 <malloc+0xc86>
    15c6:	00003097          	auipc	ra,0x3
    15ca:	ec6080e7          	jalr	-314(ra) # 448c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    15ce:	fb844703          	lbu	a4,-72(s0)
    15d2:	04f00793          	li	a5,79
    15d6:	00f71863          	bne	a4,a5,15e6 <exectest+0x1b6>
    15da:	fb944703          	lbu	a4,-71(s0)
    15de:	04b00793          	li	a5,75
    15e2:	02f70063          	beq	a4,a5,1602 <exectest+0x1d2>
    printf("%s: wrong output\n", s);
    15e6:	85ca                	mv	a1,s2
    15e8:	00004517          	auipc	a0,0x4
    15ec:	f7850513          	addi	a0,a0,-136 # 5560 <malloc+0xce6>
    15f0:	00003097          	auipc	ra,0x3
    15f4:	1cc080e7          	jalr	460(ra) # 47bc <printf>
    exit(1);
    15f8:	4505                	li	a0,1
    15fa:	00003097          	auipc	ra,0x3
    15fe:	e42080e7          	jalr	-446(ra) # 443c <exit>
    exit(0);
    1602:	4501                	li	a0,0
    1604:	00003097          	auipc	ra,0x3
    1608:	e38080e7          	jalr	-456(ra) # 443c <exit>

000000000000160c <bigargtest>:
{
    160c:	7179                	addi	sp,sp,-48
    160e:	f406                	sd	ra,40(sp)
    1610:	f022                	sd	s0,32(sp)
    1612:	ec26                	sd	s1,24(sp)
    1614:	1800                	addi	s0,sp,48
    1616:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    1618:	00004517          	auipc	a0,0x4
    161c:	f6050513          	addi	a0,a0,-160 # 5578 <malloc+0xcfe>
    1620:	00003097          	auipc	ra,0x3
    1624:	e6c080e7          	jalr	-404(ra) # 448c <unlink>
  pid = fork();
    1628:	00003097          	auipc	ra,0x3
    162c:	e0c080e7          	jalr	-500(ra) # 4434 <fork>
  if(pid == 0){
    1630:	c121                	beqz	a0,1670 <bigargtest+0x64>
  } else if(pid < 0){
    1632:	0a054063          	bltz	a0,16d2 <bigargtest+0xc6>
  wait(&xstatus);
    1636:	fdc40513          	addi	a0,s0,-36
    163a:	00003097          	auipc	ra,0x3
    163e:	e0a080e7          	jalr	-502(ra) # 4444 <wait>
  if(xstatus != 0)
    1642:	fdc42503          	lw	a0,-36(s0)
    1646:	e545                	bnez	a0,16ee <bigargtest+0xe2>
  fd = open("bigarg-ok", 0);
    1648:	4581                	li	a1,0
    164a:	00004517          	auipc	a0,0x4
    164e:	f2e50513          	addi	a0,a0,-210 # 5578 <malloc+0xcfe>
    1652:	00003097          	auipc	ra,0x3
    1656:	e2a080e7          	jalr	-470(ra) # 447c <open>
  if(fd < 0){
    165a:	08054e63          	bltz	a0,16f6 <bigargtest+0xea>
  close(fd);
    165e:	00003097          	auipc	ra,0x3
    1662:	e06080e7          	jalr	-506(ra) # 4464 <close>
}
    1666:	70a2                	ld	ra,40(sp)
    1668:	7402                	ld	s0,32(sp)
    166a:	64e2                	ld	s1,24(sp)
    166c:	6145                	addi	sp,sp,48
    166e:	8082                	ret
    1670:	00005797          	auipc	a5,0x5
    1674:	3d078793          	addi	a5,a5,976 # 6a40 <args.1707>
    1678:	00005697          	auipc	a3,0x5
    167c:	4c068693          	addi	a3,a3,1216 # 6b38 <args.1707+0xf8>
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    1680:	00004717          	auipc	a4,0x4
    1684:	f0870713          	addi	a4,a4,-248 # 5588 <malloc+0xd0e>
    1688:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    168a:	07a1                	addi	a5,a5,8
    168c:	fed79ee3          	bne	a5,a3,1688 <bigargtest+0x7c>
    args[MAXARG-1] = 0;
    1690:	00005597          	auipc	a1,0x5
    1694:	3b058593          	addi	a1,a1,944 # 6a40 <args.1707>
    1698:	0e05bc23          	sd	zero,248(a1)
    exec("echo", args);
    169c:	00004517          	auipc	a0,0x4
    16a0:	88c50513          	addi	a0,a0,-1908 # 4f28 <malloc+0x6ae>
    16a4:	00003097          	auipc	ra,0x3
    16a8:	dd0080e7          	jalr	-560(ra) # 4474 <exec>
    fd = open("bigarg-ok", O_CREATE);
    16ac:	20000593          	li	a1,512
    16b0:	00004517          	auipc	a0,0x4
    16b4:	ec850513          	addi	a0,a0,-312 # 5578 <malloc+0xcfe>
    16b8:	00003097          	auipc	ra,0x3
    16bc:	dc4080e7          	jalr	-572(ra) # 447c <open>
    close(fd);
    16c0:	00003097          	auipc	ra,0x3
    16c4:	da4080e7          	jalr	-604(ra) # 4464 <close>
    exit(0);
    16c8:	4501                	li	a0,0
    16ca:	00003097          	auipc	ra,0x3
    16ce:	d72080e7          	jalr	-654(ra) # 443c <exit>
    printf("%s: bigargtest: fork failed\n", s);
    16d2:	85a6                	mv	a1,s1
    16d4:	00004517          	auipc	a0,0x4
    16d8:	f9450513          	addi	a0,a0,-108 # 5668 <malloc+0xdee>
    16dc:	00003097          	auipc	ra,0x3
    16e0:	0e0080e7          	jalr	224(ra) # 47bc <printf>
    exit(1);
    16e4:	4505                	li	a0,1
    16e6:	00003097          	auipc	ra,0x3
    16ea:	d56080e7          	jalr	-682(ra) # 443c <exit>
    exit(xstatus);
    16ee:	00003097          	auipc	ra,0x3
    16f2:	d4e080e7          	jalr	-690(ra) # 443c <exit>
    printf("%s: bigarg test failed!\n", s);
    16f6:	85a6                	mv	a1,s1
    16f8:	00004517          	auipc	a0,0x4
    16fc:	f9050513          	addi	a0,a0,-112 # 5688 <malloc+0xe0e>
    1700:	00003097          	auipc	ra,0x3
    1704:	0bc080e7          	jalr	188(ra) # 47bc <printf>
    exit(1);
    1708:	4505                	li	a0,1
    170a:	00003097          	auipc	ra,0x3
    170e:	d32080e7          	jalr	-718(ra) # 443c <exit>

0000000000001712 <badarg>:

// regression test. test whether exec() leaks memory if one of the
// arguments is invalid. the test passes if the kernel doesn't panic.
void
badarg(char *s)
{
    1712:	7139                	addi	sp,sp,-64
    1714:	fc06                	sd	ra,56(sp)
    1716:	f822                	sd	s0,48(sp)
    1718:	f426                	sd	s1,40(sp)
    171a:	f04a                	sd	s2,32(sp)
    171c:	ec4e                	sd	s3,24(sp)
    171e:	0080                	addi	s0,sp,64
    1720:	64b1                	lui	s1,0xc
    1722:	35048493          	addi	s1,s1,848 # c350 <__BSS_END__+0xf0>
  for(int i = 0; i < 50000; i++){
    char *argv[2];
    argv[0] = (char*)0xffffffff;
    1726:	597d                	li	s2,-1
    1728:	02095913          	srli	s2,s2,0x20
    argv[1] = 0;
    exec("echo", argv);
    172c:	00003997          	auipc	s3,0x3
    1730:	7fc98993          	addi	s3,s3,2044 # 4f28 <malloc+0x6ae>
    argv[0] = (char*)0xffffffff;
    1734:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    1738:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    173c:	fc040593          	addi	a1,s0,-64
    1740:	854e                	mv	a0,s3
    1742:	00003097          	auipc	ra,0x3
    1746:	d32080e7          	jalr	-718(ra) # 4474 <exec>
  for(int i = 0; i < 50000; i++){
    174a:	34fd                	addiw	s1,s1,-1
    174c:	f4e5                	bnez	s1,1734 <badarg+0x22>
  }
  
  exit(0);
    174e:	4501                	li	a0,0
    1750:	00003097          	auipc	ra,0x3
    1754:	cec080e7          	jalr	-788(ra) # 443c <exit>

0000000000001758 <pipe1>:
{
    1758:	711d                	addi	sp,sp,-96
    175a:	ec86                	sd	ra,88(sp)
    175c:	e8a2                	sd	s0,80(sp)
    175e:	e4a6                	sd	s1,72(sp)
    1760:	e0ca                	sd	s2,64(sp)
    1762:	fc4e                	sd	s3,56(sp)
    1764:	f852                	sd	s4,48(sp)
    1766:	f456                	sd	s5,40(sp)
    1768:	f05a                	sd	s6,32(sp)
    176a:	ec5e                	sd	s7,24(sp)
    176c:	1080                	addi	s0,sp,96
    176e:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    1770:	fa840513          	addi	a0,s0,-88
    1774:	00003097          	auipc	ra,0x3
    1778:	cd8080e7          	jalr	-808(ra) # 444c <pipe>
    177c:	ed25                	bnez	a0,17f4 <pipe1+0x9c>
    177e:	84aa                	mv	s1,a0
  pid = fork();
    1780:	00003097          	auipc	ra,0x3
    1784:	cb4080e7          	jalr	-844(ra) # 4434 <fork>
    1788:	8a2a                	mv	s4,a0
  if(pid == 0){
    178a:	c159                	beqz	a0,1810 <pipe1+0xb8>
  } else if(pid > 0){
    178c:	16a05e63          	blez	a0,1908 <pipe1+0x1b0>
    close(fds[1]);
    1790:	fac42503          	lw	a0,-84(s0)
    1794:	00003097          	auipc	ra,0x3
    1798:	cd0080e7          	jalr	-816(ra) # 4464 <close>
    total = 0;
    179c:	8a26                	mv	s4,s1
    cc = 1;
    179e:	4985                	li	s3,1
    while((n = read(fds[0], buf, cc)) > 0){
    17a0:	00008a97          	auipc	s5,0x8
    17a4:	ab0a8a93          	addi	s5,s5,-1360 # 9250 <buf>
      if(cc > sizeof(buf))
    17a8:	6b0d                	lui	s6,0x3
    while((n = read(fds[0], buf, cc)) > 0){
    17aa:	864e                	mv	a2,s3
    17ac:	85d6                	mv	a1,s5
    17ae:	fa842503          	lw	a0,-88(s0)
    17b2:	00003097          	auipc	ra,0x3
    17b6:	ca2080e7          	jalr	-862(ra) # 4454 <read>
    17ba:	10a05263          	blez	a0,18be <pipe1+0x166>
      for(i = 0; i < n; i++){
    17be:	00008717          	auipc	a4,0x8
    17c2:	a9270713          	addi	a4,a4,-1390 # 9250 <buf>
    17c6:	00a4863b          	addw	a2,s1,a0
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17ca:	00074683          	lbu	a3,0(a4)
    17ce:	0ff4f793          	andi	a5,s1,255
    17d2:	2485                	addiw	s1,s1,1
    17d4:	0cf69163          	bne	a3,a5,1896 <pipe1+0x13e>
      for(i = 0; i < n; i++){
    17d8:	0705                	addi	a4,a4,1
    17da:	fec498e3          	bne	s1,a2,17ca <pipe1+0x72>
      total += n;
    17de:	00aa0a3b          	addw	s4,s4,a0
      cc = cc * 2;
    17e2:	0019979b          	slliw	a5,s3,0x1
    17e6:	0007899b          	sext.w	s3,a5
      if(cc > sizeof(buf))
    17ea:	013b7363          	bgeu	s6,s3,17f0 <pipe1+0x98>
        cc = sizeof(buf);
    17ee:	89da                	mv	s3,s6
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    17f0:	84b2                	mv	s1,a2
    17f2:	bf65                	j	17aa <pipe1+0x52>
    printf("%s: pipe() failed\n", s);
    17f4:	85ca                	mv	a1,s2
    17f6:	00004517          	auipc	a0,0x4
    17fa:	eb250513          	addi	a0,a0,-334 # 56a8 <malloc+0xe2e>
    17fe:	00003097          	auipc	ra,0x3
    1802:	fbe080e7          	jalr	-66(ra) # 47bc <printf>
    exit(1);
    1806:	4505                	li	a0,1
    1808:	00003097          	auipc	ra,0x3
    180c:	c34080e7          	jalr	-972(ra) # 443c <exit>
    close(fds[0]);
    1810:	fa842503          	lw	a0,-88(s0)
    1814:	00003097          	auipc	ra,0x3
    1818:	c50080e7          	jalr	-944(ra) # 4464 <close>
    for(n = 0; n < N; n++){
    181c:	00008b17          	auipc	s6,0x8
    1820:	a34b0b13          	addi	s6,s6,-1484 # 9250 <buf>
    1824:	416004bb          	negw	s1,s6
    1828:	0ff4f493          	andi	s1,s1,255
    182c:	409b0993          	addi	s3,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    1830:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1832:	6a85                	lui	s5,0x1
    1834:	42da8a93          	addi	s5,s5,1069 # 142d <unlinkread+0x1b3>
{
    1838:	87da                	mv	a5,s6
        buf[i] = seq++;
    183a:	0097873b          	addw	a4,a5,s1
    183e:	00e78023          	sb	a4,0(a5)
      for(i = 0; i < SZ; i++)
    1842:	0785                	addi	a5,a5,1
    1844:	fef99be3          	bne	s3,a5,183a <pipe1+0xe2>
    1848:	409a0a1b          	addiw	s4,s4,1033
      if(write(fds[1], buf, SZ) != SZ){
    184c:	40900613          	li	a2,1033
    1850:	85de                	mv	a1,s7
    1852:	fac42503          	lw	a0,-84(s0)
    1856:	00003097          	auipc	ra,0x3
    185a:	c06080e7          	jalr	-1018(ra) # 445c <write>
    185e:	40900793          	li	a5,1033
    1862:	00f51c63          	bne	a0,a5,187a <pipe1+0x122>
    for(n = 0; n < N; n++){
    1866:	24a5                	addiw	s1,s1,9
    1868:	0ff4f493          	andi	s1,s1,255
    186c:	fd5a16e3          	bne	s4,s5,1838 <pipe1+0xe0>
    exit(0);
    1870:	4501                	li	a0,0
    1872:	00003097          	auipc	ra,0x3
    1876:	bca080e7          	jalr	-1078(ra) # 443c <exit>
        printf("%s: pipe1 oops 1\n", s);
    187a:	85ca                	mv	a1,s2
    187c:	00004517          	auipc	a0,0x4
    1880:	e4450513          	addi	a0,a0,-444 # 56c0 <malloc+0xe46>
    1884:	00003097          	auipc	ra,0x3
    1888:	f38080e7          	jalr	-200(ra) # 47bc <printf>
        exit(1);
    188c:	4505                	li	a0,1
    188e:	00003097          	auipc	ra,0x3
    1892:	bae080e7          	jalr	-1106(ra) # 443c <exit>
          printf("%s: pipe1 oops 2\n", s);
    1896:	85ca                	mv	a1,s2
    1898:	00004517          	auipc	a0,0x4
    189c:	e4050513          	addi	a0,a0,-448 # 56d8 <malloc+0xe5e>
    18a0:	00003097          	auipc	ra,0x3
    18a4:	f1c080e7          	jalr	-228(ra) # 47bc <printf>
}
    18a8:	60e6                	ld	ra,88(sp)
    18aa:	6446                	ld	s0,80(sp)
    18ac:	64a6                	ld	s1,72(sp)
    18ae:	6906                	ld	s2,64(sp)
    18b0:	79e2                	ld	s3,56(sp)
    18b2:	7a42                	ld	s4,48(sp)
    18b4:	7aa2                	ld	s5,40(sp)
    18b6:	7b02                	ld	s6,32(sp)
    18b8:	6be2                	ld	s7,24(sp)
    18ba:	6125                	addi	sp,sp,96
    18bc:	8082                	ret
    if(total != N * SZ){
    18be:	6785                	lui	a5,0x1
    18c0:	42d78793          	addi	a5,a5,1069 # 142d <unlinkread+0x1b3>
    18c4:	02fa0063          	beq	s4,a5,18e4 <pipe1+0x18c>
      printf("%s: pipe1 oops 3 total %d\n", total);
    18c8:	85d2                	mv	a1,s4
    18ca:	00004517          	auipc	a0,0x4
    18ce:	e2650513          	addi	a0,a0,-474 # 56f0 <malloc+0xe76>
    18d2:	00003097          	auipc	ra,0x3
    18d6:	eea080e7          	jalr	-278(ra) # 47bc <printf>
      exit(1);
    18da:	4505                	li	a0,1
    18dc:	00003097          	auipc	ra,0x3
    18e0:	b60080e7          	jalr	-1184(ra) # 443c <exit>
    close(fds[0]);
    18e4:	fa842503          	lw	a0,-88(s0)
    18e8:	00003097          	auipc	ra,0x3
    18ec:	b7c080e7          	jalr	-1156(ra) # 4464 <close>
    wait(&xstatus);
    18f0:	fa440513          	addi	a0,s0,-92
    18f4:	00003097          	auipc	ra,0x3
    18f8:	b50080e7          	jalr	-1200(ra) # 4444 <wait>
    exit(xstatus);
    18fc:	fa442503          	lw	a0,-92(s0)
    1900:	00003097          	auipc	ra,0x3
    1904:	b3c080e7          	jalr	-1220(ra) # 443c <exit>
    printf("%s: fork() failed\n", s);
    1908:	85ca                	mv	a1,s2
    190a:	00004517          	auipc	a0,0x4
    190e:	e0650513          	addi	a0,a0,-506 # 5710 <malloc+0xe96>
    1912:	00003097          	auipc	ra,0x3
    1916:	eaa080e7          	jalr	-342(ra) # 47bc <printf>
    exit(1);
    191a:	4505                	li	a0,1
    191c:	00003097          	auipc	ra,0x3
    1920:	b20080e7          	jalr	-1248(ra) # 443c <exit>

0000000000001924 <pgbug>:
{
    1924:	7179                	addi	sp,sp,-48
    1926:	f406                	sd	ra,40(sp)
    1928:	f022                	sd	s0,32(sp)
    192a:	ec26                	sd	s1,24(sp)
    192c:	1800                	addi	s0,sp,48
  argv[0] = 0;
    192e:	fc043c23          	sd	zero,-40(s0)
  exec((char*)0xeaeb0b5b00002f5e, argv);
    1932:	00005497          	auipc	s1,0x5
    1936:	0ee4b483          	ld	s1,238(s1) # 6a20 <__SDATA_BEGIN__>
    193a:	fd840593          	addi	a1,s0,-40
    193e:	8526                	mv	a0,s1
    1940:	00003097          	auipc	ra,0x3
    1944:	b34080e7          	jalr	-1228(ra) # 4474 <exec>
  pipe((int*)0xeaeb0b5b00002f5e);
    1948:	8526                	mv	a0,s1
    194a:	00003097          	auipc	ra,0x3
    194e:	b02080e7          	jalr	-1278(ra) # 444c <pipe>
  exit(0);
    1952:	4501                	li	a0,0
    1954:	00003097          	auipc	ra,0x3
    1958:	ae8080e7          	jalr	-1304(ra) # 443c <exit>

000000000000195c <preempt>:
{
    195c:	7139                	addi	sp,sp,-64
    195e:	fc06                	sd	ra,56(sp)
    1960:	f822                	sd	s0,48(sp)
    1962:	f426                	sd	s1,40(sp)
    1964:	f04a                	sd	s2,32(sp)
    1966:	ec4e                	sd	s3,24(sp)
    1968:	e852                	sd	s4,16(sp)
    196a:	0080                	addi	s0,sp,64
    196c:	8a2a                	mv	s4,a0
  pid1 = fork();
    196e:	00003097          	auipc	ra,0x3
    1972:	ac6080e7          	jalr	-1338(ra) # 4434 <fork>
  if(pid1 < 0) {
    1976:	00054563          	bltz	a0,1980 <preempt+0x24>
    197a:	89aa                	mv	s3,a0
  if(pid1 == 0)
    197c:	ed19                	bnez	a0,199a <preempt+0x3e>
    for(;;)
    197e:	a001                	j	197e <preempt+0x22>
    printf("%s: fork failed");
    1980:	00003517          	auipc	a0,0x3
    1984:	46050513          	addi	a0,a0,1120 # 4de0 <malloc+0x566>
    1988:	00003097          	auipc	ra,0x3
    198c:	e34080e7          	jalr	-460(ra) # 47bc <printf>
    exit(1);
    1990:	4505                	li	a0,1
    1992:	00003097          	auipc	ra,0x3
    1996:	aaa080e7          	jalr	-1366(ra) # 443c <exit>
  pid2 = fork();
    199a:	00003097          	auipc	ra,0x3
    199e:	a9a080e7          	jalr	-1382(ra) # 4434 <fork>
    19a2:	892a                	mv	s2,a0
  if(pid2 < 0) {
    19a4:	00054463          	bltz	a0,19ac <preempt+0x50>
  if(pid2 == 0)
    19a8:	e105                	bnez	a0,19c8 <preempt+0x6c>
    for(;;)
    19aa:	a001                	j	19aa <preempt+0x4e>
    printf("%s: fork failed\n", s);
    19ac:	85d2                	mv	a1,s4
    19ae:	00003517          	auipc	a0,0x3
    19b2:	3ca50513          	addi	a0,a0,970 # 4d78 <malloc+0x4fe>
    19b6:	00003097          	auipc	ra,0x3
    19ba:	e06080e7          	jalr	-506(ra) # 47bc <printf>
    exit(1);
    19be:	4505                	li	a0,1
    19c0:	00003097          	auipc	ra,0x3
    19c4:	a7c080e7          	jalr	-1412(ra) # 443c <exit>
  pipe(pfds);
    19c8:	fc840513          	addi	a0,s0,-56
    19cc:	00003097          	auipc	ra,0x3
    19d0:	a80080e7          	jalr	-1408(ra) # 444c <pipe>
  pid3 = fork();
    19d4:	00003097          	auipc	ra,0x3
    19d8:	a60080e7          	jalr	-1440(ra) # 4434 <fork>
    19dc:	84aa                	mv	s1,a0
  if(pid3 < 0) {
    19de:	02054e63          	bltz	a0,1a1a <preempt+0xbe>
  if(pid3 == 0){
    19e2:	e13d                	bnez	a0,1a48 <preempt+0xec>
    close(pfds[0]);
    19e4:	fc842503          	lw	a0,-56(s0)
    19e8:	00003097          	auipc	ra,0x3
    19ec:	a7c080e7          	jalr	-1412(ra) # 4464 <close>
    if(write(pfds[1], "x", 1) != 1)
    19f0:	4605                	li	a2,1
    19f2:	00004597          	auipc	a1,0x4
    19f6:	d3658593          	addi	a1,a1,-714 # 5728 <malloc+0xeae>
    19fa:	fcc42503          	lw	a0,-52(s0)
    19fe:	00003097          	auipc	ra,0x3
    1a02:	a5e080e7          	jalr	-1442(ra) # 445c <write>
    1a06:	4785                	li	a5,1
    1a08:	02f51763          	bne	a0,a5,1a36 <preempt+0xda>
    close(pfds[1]);
    1a0c:	fcc42503          	lw	a0,-52(s0)
    1a10:	00003097          	auipc	ra,0x3
    1a14:	a54080e7          	jalr	-1452(ra) # 4464 <close>
    for(;;)
    1a18:	a001                	j	1a18 <preempt+0xbc>
     printf("%s: fork failed\n", s);
    1a1a:	85d2                	mv	a1,s4
    1a1c:	00003517          	auipc	a0,0x3
    1a20:	35c50513          	addi	a0,a0,860 # 4d78 <malloc+0x4fe>
    1a24:	00003097          	auipc	ra,0x3
    1a28:	d98080e7          	jalr	-616(ra) # 47bc <printf>
     exit(1);
    1a2c:	4505                	li	a0,1
    1a2e:	00003097          	auipc	ra,0x3
    1a32:	a0e080e7          	jalr	-1522(ra) # 443c <exit>
      printf("%s: preempt write error");
    1a36:	00004517          	auipc	a0,0x4
    1a3a:	cfa50513          	addi	a0,a0,-774 # 5730 <malloc+0xeb6>
    1a3e:	00003097          	auipc	ra,0x3
    1a42:	d7e080e7          	jalr	-642(ra) # 47bc <printf>
    1a46:	b7d9                	j	1a0c <preempt+0xb0>
  close(pfds[1]);
    1a48:	fcc42503          	lw	a0,-52(s0)
    1a4c:	00003097          	auipc	ra,0x3
    1a50:	a18080e7          	jalr	-1512(ra) # 4464 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    1a54:	660d                	lui	a2,0x3
    1a56:	00007597          	auipc	a1,0x7
    1a5a:	7fa58593          	addi	a1,a1,2042 # 9250 <buf>
    1a5e:	fc842503          	lw	a0,-56(s0)
    1a62:	00003097          	auipc	ra,0x3
    1a66:	9f2080e7          	jalr	-1550(ra) # 4454 <read>
    1a6a:	4785                	li	a5,1
    1a6c:	02f50263          	beq	a0,a5,1a90 <preempt+0x134>
    printf("%s: preempt read error");
    1a70:	00004517          	auipc	a0,0x4
    1a74:	cd850513          	addi	a0,a0,-808 # 5748 <malloc+0xece>
    1a78:	00003097          	auipc	ra,0x3
    1a7c:	d44080e7          	jalr	-700(ra) # 47bc <printf>
}
    1a80:	70e2                	ld	ra,56(sp)
    1a82:	7442                	ld	s0,48(sp)
    1a84:	74a2                	ld	s1,40(sp)
    1a86:	7902                	ld	s2,32(sp)
    1a88:	69e2                	ld	s3,24(sp)
    1a8a:	6a42                	ld	s4,16(sp)
    1a8c:	6121                	addi	sp,sp,64
    1a8e:	8082                	ret
  close(pfds[0]);
    1a90:	fc842503          	lw	a0,-56(s0)
    1a94:	00003097          	auipc	ra,0x3
    1a98:	9d0080e7          	jalr	-1584(ra) # 4464 <close>
  printf("kill... ");
    1a9c:	00004517          	auipc	a0,0x4
    1aa0:	cc450513          	addi	a0,a0,-828 # 5760 <malloc+0xee6>
    1aa4:	00003097          	auipc	ra,0x3
    1aa8:	d18080e7          	jalr	-744(ra) # 47bc <printf>
  kill(pid1);
    1aac:	854e                	mv	a0,s3
    1aae:	00003097          	auipc	ra,0x3
    1ab2:	9be080e7          	jalr	-1602(ra) # 446c <kill>
  kill(pid2);
    1ab6:	854a                	mv	a0,s2
    1ab8:	00003097          	auipc	ra,0x3
    1abc:	9b4080e7          	jalr	-1612(ra) # 446c <kill>
  kill(pid3);
    1ac0:	8526                	mv	a0,s1
    1ac2:	00003097          	auipc	ra,0x3
    1ac6:	9aa080e7          	jalr	-1622(ra) # 446c <kill>
  printf("wait... ");
    1aca:	00004517          	auipc	a0,0x4
    1ace:	ca650513          	addi	a0,a0,-858 # 5770 <malloc+0xef6>
    1ad2:	00003097          	auipc	ra,0x3
    1ad6:	cea080e7          	jalr	-790(ra) # 47bc <printf>
  wait(0);
    1ada:	4501                	li	a0,0
    1adc:	00003097          	auipc	ra,0x3
    1ae0:	968080e7          	jalr	-1688(ra) # 4444 <wait>
  wait(0);
    1ae4:	4501                	li	a0,0
    1ae6:	00003097          	auipc	ra,0x3
    1aea:	95e080e7          	jalr	-1698(ra) # 4444 <wait>
  wait(0);
    1aee:	4501                	li	a0,0
    1af0:	00003097          	auipc	ra,0x3
    1af4:	954080e7          	jalr	-1708(ra) # 4444 <wait>
    1af8:	b761                	j	1a80 <preempt+0x124>

0000000000001afa <reparent>:
{
    1afa:	7179                	addi	sp,sp,-48
    1afc:	f406                	sd	ra,40(sp)
    1afe:	f022                	sd	s0,32(sp)
    1b00:	ec26                	sd	s1,24(sp)
    1b02:	e84a                	sd	s2,16(sp)
    1b04:	e44e                	sd	s3,8(sp)
    1b06:	e052                	sd	s4,0(sp)
    1b08:	1800                	addi	s0,sp,48
    1b0a:	89aa                	mv	s3,a0
  int master_pid = getpid();
    1b0c:	00003097          	auipc	ra,0x3
    1b10:	9b0080e7          	jalr	-1616(ra) # 44bc <getpid>
    1b14:	8a2a                	mv	s4,a0
    1b16:	0c800913          	li	s2,200
    int pid = fork();
    1b1a:	00003097          	auipc	ra,0x3
    1b1e:	91a080e7          	jalr	-1766(ra) # 4434 <fork>
    1b22:	84aa                	mv	s1,a0
    if(pid < 0){
    1b24:	02054263          	bltz	a0,1b48 <reparent+0x4e>
    if(pid){
    1b28:	cd21                	beqz	a0,1b80 <reparent+0x86>
      if(wait(0) != pid){
    1b2a:	4501                	li	a0,0
    1b2c:	00003097          	auipc	ra,0x3
    1b30:	918080e7          	jalr	-1768(ra) # 4444 <wait>
    1b34:	02951863          	bne	a0,s1,1b64 <reparent+0x6a>
  for(int i = 0; i < 200; i++){
    1b38:	397d                	addiw	s2,s2,-1
    1b3a:	fe0910e3          	bnez	s2,1b1a <reparent+0x20>
  exit(0);
    1b3e:	4501                	li	a0,0
    1b40:	00003097          	auipc	ra,0x3
    1b44:	8fc080e7          	jalr	-1796(ra) # 443c <exit>
      printf("%s: fork failed\n", s);
    1b48:	85ce                	mv	a1,s3
    1b4a:	00003517          	auipc	a0,0x3
    1b4e:	22e50513          	addi	a0,a0,558 # 4d78 <malloc+0x4fe>
    1b52:	00003097          	auipc	ra,0x3
    1b56:	c6a080e7          	jalr	-918(ra) # 47bc <printf>
      exit(1);
    1b5a:	4505                	li	a0,1
    1b5c:	00003097          	auipc	ra,0x3
    1b60:	8e0080e7          	jalr	-1824(ra) # 443c <exit>
        printf("%s: wait wrong pid\n", s);
    1b64:	85ce                	mv	a1,s3
    1b66:	00003517          	auipc	a0,0x3
    1b6a:	24250513          	addi	a0,a0,578 # 4da8 <malloc+0x52e>
    1b6e:	00003097          	auipc	ra,0x3
    1b72:	c4e080e7          	jalr	-946(ra) # 47bc <printf>
        exit(1);
    1b76:	4505                	li	a0,1
    1b78:	00003097          	auipc	ra,0x3
    1b7c:	8c4080e7          	jalr	-1852(ra) # 443c <exit>
      int pid2 = fork();
    1b80:	00003097          	auipc	ra,0x3
    1b84:	8b4080e7          	jalr	-1868(ra) # 4434 <fork>
      if(pid2 < 0){
    1b88:	00054763          	bltz	a0,1b96 <reparent+0x9c>
      exit(0);
    1b8c:	4501                	li	a0,0
    1b8e:	00003097          	auipc	ra,0x3
    1b92:	8ae080e7          	jalr	-1874(ra) # 443c <exit>
        kill(master_pid);
    1b96:	8552                	mv	a0,s4
    1b98:	00003097          	auipc	ra,0x3
    1b9c:	8d4080e7          	jalr	-1836(ra) # 446c <kill>
        exit(1);
    1ba0:	4505                	li	a0,1
    1ba2:	00003097          	auipc	ra,0x3
    1ba6:	89a080e7          	jalr	-1894(ra) # 443c <exit>

0000000000001baa <mem>:
{
    1baa:	7139                	addi	sp,sp,-64
    1bac:	fc06                	sd	ra,56(sp)
    1bae:	f822                	sd	s0,48(sp)
    1bb0:	f426                	sd	s1,40(sp)
    1bb2:	f04a                	sd	s2,32(sp)
    1bb4:	ec4e                	sd	s3,24(sp)
    1bb6:	0080                	addi	s0,sp,64
    1bb8:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    1bba:	00003097          	auipc	ra,0x3
    1bbe:	87a080e7          	jalr	-1926(ra) # 4434 <fork>
    m1 = 0;
    1bc2:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    1bc4:	6909                	lui	s2,0x2
    1bc6:	71190913          	addi	s2,s2,1809 # 2711 <concreate+0x2b1>
  if((pid = fork()) == 0){
    1bca:	ed39                	bnez	a0,1c28 <mem+0x7e>
    while((m2 = malloc(10001)) != 0){
    1bcc:	854a                	mv	a0,s2
    1bce:	00003097          	auipc	ra,0x3
    1bd2:	cac080e7          	jalr	-852(ra) # 487a <malloc>
    1bd6:	c501                	beqz	a0,1bde <mem+0x34>
      *(char**)m2 = m1;
    1bd8:	e104                	sd	s1,0(a0)
      m1 = m2;
    1bda:	84aa                	mv	s1,a0
    1bdc:	bfc5                	j	1bcc <mem+0x22>
    while(m1){
    1bde:	c881                	beqz	s1,1bee <mem+0x44>
      m2 = *(char**)m1;
    1be0:	8526                	mv	a0,s1
    1be2:	6084                	ld	s1,0(s1)
      free(m1);
    1be4:	00003097          	auipc	ra,0x3
    1be8:	c0e080e7          	jalr	-1010(ra) # 47f2 <free>
    while(m1){
    1bec:	f8f5                	bnez	s1,1be0 <mem+0x36>
    m1 = malloc(1024*20);
    1bee:	6515                	lui	a0,0x5
    1bf0:	00003097          	auipc	ra,0x3
    1bf4:	c8a080e7          	jalr	-886(ra) # 487a <malloc>
    if(m1 == 0){
    1bf8:	c911                	beqz	a0,1c0c <mem+0x62>
    free(m1);
    1bfa:	00003097          	auipc	ra,0x3
    1bfe:	bf8080e7          	jalr	-1032(ra) # 47f2 <free>
    exit(0);
    1c02:	4501                	li	a0,0
    1c04:	00003097          	auipc	ra,0x3
    1c08:	838080e7          	jalr	-1992(ra) # 443c <exit>
      printf("couldn't allocate mem?!!\n", s);
    1c0c:	85ce                	mv	a1,s3
    1c0e:	00004517          	auipc	a0,0x4
    1c12:	b7250513          	addi	a0,a0,-1166 # 5780 <malloc+0xf06>
    1c16:	00003097          	auipc	ra,0x3
    1c1a:	ba6080e7          	jalr	-1114(ra) # 47bc <printf>
      exit(1);
    1c1e:	4505                	li	a0,1
    1c20:	00003097          	auipc	ra,0x3
    1c24:	81c080e7          	jalr	-2020(ra) # 443c <exit>
    wait(&xstatus);
    1c28:	fcc40513          	addi	a0,s0,-52
    1c2c:	00003097          	auipc	ra,0x3
    1c30:	818080e7          	jalr	-2024(ra) # 4444 <wait>
    exit(xstatus);
    1c34:	fcc42503          	lw	a0,-52(s0)
    1c38:	00003097          	auipc	ra,0x3
    1c3c:	804080e7          	jalr	-2044(ra) # 443c <exit>

0000000000001c40 <sharedfd>:
{
    1c40:	7159                	addi	sp,sp,-112
    1c42:	f486                	sd	ra,104(sp)
    1c44:	f0a2                	sd	s0,96(sp)
    1c46:	eca6                	sd	s1,88(sp)
    1c48:	e8ca                	sd	s2,80(sp)
    1c4a:	e4ce                	sd	s3,72(sp)
    1c4c:	e0d2                	sd	s4,64(sp)
    1c4e:	fc56                	sd	s5,56(sp)
    1c50:	f85a                	sd	s6,48(sp)
    1c52:	f45e                	sd	s7,40(sp)
    1c54:	1880                	addi	s0,sp,112
    1c56:	8a2a                	mv	s4,a0
  unlink("sharedfd");
    1c58:	00003517          	auipc	a0,0x3
    1c5c:	e1050513          	addi	a0,a0,-496 # 4a68 <malloc+0x1ee>
    1c60:	00003097          	auipc	ra,0x3
    1c64:	82c080e7          	jalr	-2004(ra) # 448c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    1c68:	20200593          	li	a1,514
    1c6c:	00003517          	auipc	a0,0x3
    1c70:	dfc50513          	addi	a0,a0,-516 # 4a68 <malloc+0x1ee>
    1c74:	00003097          	auipc	ra,0x3
    1c78:	808080e7          	jalr	-2040(ra) # 447c <open>
  if(fd < 0){
    1c7c:	04054a63          	bltz	a0,1cd0 <sharedfd+0x90>
    1c80:	892a                	mv	s2,a0
  pid = fork();
    1c82:	00002097          	auipc	ra,0x2
    1c86:	7b2080e7          	jalr	1970(ra) # 4434 <fork>
    1c8a:	89aa                	mv	s3,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    1c8c:	06300593          	li	a1,99
    1c90:	c119                	beqz	a0,1c96 <sharedfd+0x56>
    1c92:	07000593          	li	a1,112
    1c96:	4629                	li	a2,10
    1c98:	fa040513          	addi	a0,s0,-96
    1c9c:	00002097          	auipc	ra,0x2
    1ca0:	59c080e7          	jalr	1436(ra) # 4238 <memset>
    1ca4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    1ca8:	4629                	li	a2,10
    1caa:	fa040593          	addi	a1,s0,-96
    1cae:	854a                	mv	a0,s2
    1cb0:	00002097          	auipc	ra,0x2
    1cb4:	7ac080e7          	jalr	1964(ra) # 445c <write>
    1cb8:	47a9                	li	a5,10
    1cba:	02f51963          	bne	a0,a5,1cec <sharedfd+0xac>
  for(i = 0; i < N; i++){
    1cbe:	34fd                	addiw	s1,s1,-1
    1cc0:	f4e5                	bnez	s1,1ca8 <sharedfd+0x68>
  if(pid == 0) {
    1cc2:	04099363          	bnez	s3,1d08 <sharedfd+0xc8>
    exit(0);
    1cc6:	4501                	li	a0,0
    1cc8:	00002097          	auipc	ra,0x2
    1ccc:	774080e7          	jalr	1908(ra) # 443c <exit>
    printf("%s: cannot open sharedfd for writing", s);
    1cd0:	85d2                	mv	a1,s4
    1cd2:	00004517          	auipc	a0,0x4
    1cd6:	ace50513          	addi	a0,a0,-1330 # 57a0 <malloc+0xf26>
    1cda:	00003097          	auipc	ra,0x3
    1cde:	ae2080e7          	jalr	-1310(ra) # 47bc <printf>
    exit(1);
    1ce2:	4505                	li	a0,1
    1ce4:	00002097          	auipc	ra,0x2
    1ce8:	758080e7          	jalr	1880(ra) # 443c <exit>
      printf("%s: write sharedfd failed\n", s);
    1cec:	85d2                	mv	a1,s4
    1cee:	00004517          	auipc	a0,0x4
    1cf2:	ada50513          	addi	a0,a0,-1318 # 57c8 <malloc+0xf4e>
    1cf6:	00003097          	auipc	ra,0x3
    1cfa:	ac6080e7          	jalr	-1338(ra) # 47bc <printf>
      exit(1);
    1cfe:	4505                	li	a0,1
    1d00:	00002097          	auipc	ra,0x2
    1d04:	73c080e7          	jalr	1852(ra) # 443c <exit>
    wait(&xstatus);
    1d08:	f9c40513          	addi	a0,s0,-100
    1d0c:	00002097          	auipc	ra,0x2
    1d10:	738080e7          	jalr	1848(ra) # 4444 <wait>
    if(xstatus != 0)
    1d14:	f9c42983          	lw	s3,-100(s0)
    1d18:	00098763          	beqz	s3,1d26 <sharedfd+0xe6>
      exit(xstatus);
    1d1c:	854e                	mv	a0,s3
    1d1e:	00002097          	auipc	ra,0x2
    1d22:	71e080e7          	jalr	1822(ra) # 443c <exit>
  close(fd);
    1d26:	854a                	mv	a0,s2
    1d28:	00002097          	auipc	ra,0x2
    1d2c:	73c080e7          	jalr	1852(ra) # 4464 <close>
  fd = open("sharedfd", 0);
    1d30:	4581                	li	a1,0
    1d32:	00003517          	auipc	a0,0x3
    1d36:	d3650513          	addi	a0,a0,-714 # 4a68 <malloc+0x1ee>
    1d3a:	00002097          	auipc	ra,0x2
    1d3e:	742080e7          	jalr	1858(ra) # 447c <open>
    1d42:	8baa                	mv	s7,a0
  nc = np = 0;
    1d44:	8ace                	mv	s5,s3
  if(fd < 0){
    1d46:	02054563          	bltz	a0,1d70 <sharedfd+0x130>
    1d4a:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    1d4e:	06300493          	li	s1,99
      if(buf[i] == 'p')
    1d52:	07000b13          	li	s6,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    1d56:	4629                	li	a2,10
    1d58:	fa040593          	addi	a1,s0,-96
    1d5c:	855e                	mv	a0,s7
    1d5e:	00002097          	auipc	ra,0x2
    1d62:	6f6080e7          	jalr	1782(ra) # 4454 <read>
    1d66:	02a05f63          	blez	a0,1da4 <sharedfd+0x164>
    1d6a:	fa040793          	addi	a5,s0,-96
    1d6e:	a01d                	j	1d94 <sharedfd+0x154>
    printf("%s: cannot open sharedfd for reading\n", s);
    1d70:	85d2                	mv	a1,s4
    1d72:	00004517          	auipc	a0,0x4
    1d76:	a7650513          	addi	a0,a0,-1418 # 57e8 <malloc+0xf6e>
    1d7a:	00003097          	auipc	ra,0x3
    1d7e:	a42080e7          	jalr	-1470(ra) # 47bc <printf>
    exit(1);
    1d82:	4505                	li	a0,1
    1d84:	00002097          	auipc	ra,0x2
    1d88:	6b8080e7          	jalr	1720(ra) # 443c <exit>
        nc++;
    1d8c:	2985                	addiw	s3,s3,1
    for(i = 0; i < sizeof(buf); i++){
    1d8e:	0785                	addi	a5,a5,1
    1d90:	fd2783e3          	beq	a5,s2,1d56 <sharedfd+0x116>
      if(buf[i] == 'c')
    1d94:	0007c703          	lbu	a4,0(a5)
    1d98:	fe970ae3          	beq	a4,s1,1d8c <sharedfd+0x14c>
      if(buf[i] == 'p')
    1d9c:	ff6719e3          	bne	a4,s6,1d8e <sharedfd+0x14e>
        np++;
    1da0:	2a85                	addiw	s5,s5,1
    1da2:	b7f5                	j	1d8e <sharedfd+0x14e>
  close(fd);
    1da4:	855e                	mv	a0,s7
    1da6:	00002097          	auipc	ra,0x2
    1daa:	6be080e7          	jalr	1726(ra) # 4464 <close>
  unlink("sharedfd");
    1dae:	00003517          	auipc	a0,0x3
    1db2:	cba50513          	addi	a0,a0,-838 # 4a68 <malloc+0x1ee>
    1db6:	00002097          	auipc	ra,0x2
    1dba:	6d6080e7          	jalr	1750(ra) # 448c <unlink>
  if(nc == N*SZ && np == N*SZ){
    1dbe:	6789                	lui	a5,0x2
    1dc0:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2b0>
    1dc4:	00f99763          	bne	s3,a5,1dd2 <sharedfd+0x192>
    1dc8:	6789                	lui	a5,0x2
    1dca:	71078793          	addi	a5,a5,1808 # 2710 <concreate+0x2b0>
    1dce:	02fa8063          	beq	s5,a5,1dee <sharedfd+0x1ae>
    printf("%s: nc/np test fails\n", s);
    1dd2:	85d2                	mv	a1,s4
    1dd4:	00004517          	auipc	a0,0x4
    1dd8:	a3c50513          	addi	a0,a0,-1476 # 5810 <malloc+0xf96>
    1ddc:	00003097          	auipc	ra,0x3
    1de0:	9e0080e7          	jalr	-1568(ra) # 47bc <printf>
    exit(1);
    1de4:	4505                	li	a0,1
    1de6:	00002097          	auipc	ra,0x2
    1dea:	656080e7          	jalr	1622(ra) # 443c <exit>
    exit(0);
    1dee:	4501                	li	a0,0
    1df0:	00002097          	auipc	ra,0x2
    1df4:	64c080e7          	jalr	1612(ra) # 443c <exit>

0000000000001df8 <fourfiles>:
{
    1df8:	7171                	addi	sp,sp,-176
    1dfa:	f506                	sd	ra,168(sp)
    1dfc:	f122                	sd	s0,160(sp)
    1dfe:	ed26                	sd	s1,152(sp)
    1e00:	e94a                	sd	s2,144(sp)
    1e02:	e54e                	sd	s3,136(sp)
    1e04:	e152                	sd	s4,128(sp)
    1e06:	fcd6                	sd	s5,120(sp)
    1e08:	f8da                	sd	s6,112(sp)
    1e0a:	f4de                	sd	s7,104(sp)
    1e0c:	f0e2                	sd	s8,96(sp)
    1e0e:	ece6                	sd	s9,88(sp)
    1e10:	e8ea                	sd	s10,80(sp)
    1e12:	e4ee                	sd	s11,72(sp)
    1e14:	1900                	addi	s0,sp,176
    1e16:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e18:	00003797          	auipc	a5,0x3
    1e1c:	b4878793          	addi	a5,a5,-1208 # 4960 <malloc+0xe6>
    1e20:	f6f43823          	sd	a5,-144(s0)
    1e24:	00003797          	auipc	a5,0x3
    1e28:	b4478793          	addi	a5,a5,-1212 # 4968 <malloc+0xee>
    1e2c:	f6f43c23          	sd	a5,-136(s0)
    1e30:	00003797          	auipc	a5,0x3
    1e34:	b4078793          	addi	a5,a5,-1216 # 4970 <malloc+0xf6>
    1e38:	f8f43023          	sd	a5,-128(s0)
    1e3c:	00003797          	auipc	a5,0x3
    1e40:	b3c78793          	addi	a5,a5,-1220 # 4978 <malloc+0xfe>
    1e44:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    1e48:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    1e4c:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    1e4e:	4481                	li	s1,0
    1e50:	4a11                	li	s4,4
    fname = names[pi];
    1e52:	00093983          	ld	s3,0(s2)
    unlink(fname);
    1e56:	854e                	mv	a0,s3
    1e58:	00002097          	auipc	ra,0x2
    1e5c:	634080e7          	jalr	1588(ra) # 448c <unlink>
    pid = fork();
    1e60:	00002097          	auipc	ra,0x2
    1e64:	5d4080e7          	jalr	1492(ra) # 4434 <fork>
    if(pid < 0){
    1e68:	04054563          	bltz	a0,1eb2 <fourfiles+0xba>
    if(pid == 0){
    1e6c:	c12d                	beqz	a0,1ece <fourfiles+0xd6>
  for(pi = 0; pi < NCHILD; pi++){
    1e6e:	2485                	addiw	s1,s1,1
    1e70:	0921                	addi	s2,s2,8
    1e72:	ff4490e3          	bne	s1,s4,1e52 <fourfiles+0x5a>
    1e76:	4491                	li	s1,4
    wait(&xstatus);
    1e78:	f6c40513          	addi	a0,s0,-148
    1e7c:	00002097          	auipc	ra,0x2
    1e80:	5c8080e7          	jalr	1480(ra) # 4444 <wait>
    if(xstatus != 0)
    1e84:	f6c42503          	lw	a0,-148(s0)
    1e88:	ed69                	bnez	a0,1f62 <fourfiles+0x16a>
  for(pi = 0; pi < NCHILD; pi++){
    1e8a:	34fd                	addiw	s1,s1,-1
    1e8c:	f4f5                	bnez	s1,1e78 <fourfiles+0x80>
    1e8e:	03000b13          	li	s6,48
    total = 0;
    1e92:	f4a43c23          	sd	a0,-168(s0)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1e96:	00007a17          	auipc	s4,0x7
    1e9a:	3baa0a13          	addi	s4,s4,954 # 9250 <buf>
    1e9e:	00007a97          	auipc	s5,0x7
    1ea2:	3b3a8a93          	addi	s5,s5,947 # 9251 <buf+0x1>
    if(total != N*SZ){
    1ea6:	6d05                	lui	s10,0x1
    1ea8:	770d0d13          	addi	s10,s10,1904 # 1770 <pipe1+0x18>
  for(i = 0; i < NCHILD; i++){
    1eac:	03400d93          	li	s11,52
    1eb0:	a23d                	j	1fde <fourfiles+0x1e6>
      printf("fork failed\n", s);
    1eb2:	85e6                	mv	a1,s9
    1eb4:	00003517          	auipc	a0,0x3
    1eb8:	7c450513          	addi	a0,a0,1988 # 5678 <malloc+0xdfe>
    1ebc:	00003097          	auipc	ra,0x3
    1ec0:	900080e7          	jalr	-1792(ra) # 47bc <printf>
      exit(1);
    1ec4:	4505                	li	a0,1
    1ec6:	00002097          	auipc	ra,0x2
    1eca:	576080e7          	jalr	1398(ra) # 443c <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    1ece:	20200593          	li	a1,514
    1ed2:	854e                	mv	a0,s3
    1ed4:	00002097          	auipc	ra,0x2
    1ed8:	5a8080e7          	jalr	1448(ra) # 447c <open>
    1edc:	892a                	mv	s2,a0
      if(fd < 0){
    1ede:	04054763          	bltz	a0,1f2c <fourfiles+0x134>
      memset(buf, '0'+pi, SZ);
    1ee2:	1f400613          	li	a2,500
    1ee6:	0304859b          	addiw	a1,s1,48
    1eea:	00007517          	auipc	a0,0x7
    1eee:	36650513          	addi	a0,a0,870 # 9250 <buf>
    1ef2:	00002097          	auipc	ra,0x2
    1ef6:	346080e7          	jalr	838(ra) # 4238 <memset>
    1efa:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    1efc:	00007997          	auipc	s3,0x7
    1f00:	35498993          	addi	s3,s3,852 # 9250 <buf>
    1f04:	1f400613          	li	a2,500
    1f08:	85ce                	mv	a1,s3
    1f0a:	854a                	mv	a0,s2
    1f0c:	00002097          	auipc	ra,0x2
    1f10:	550080e7          	jalr	1360(ra) # 445c <write>
    1f14:	85aa                	mv	a1,a0
    1f16:	1f400793          	li	a5,500
    1f1a:	02f51763          	bne	a0,a5,1f48 <fourfiles+0x150>
      for(i = 0; i < N; i++){
    1f1e:	34fd                	addiw	s1,s1,-1
    1f20:	f0f5                	bnez	s1,1f04 <fourfiles+0x10c>
      exit(0);
    1f22:	4501                	li	a0,0
    1f24:	00002097          	auipc	ra,0x2
    1f28:	518080e7          	jalr	1304(ra) # 443c <exit>
        printf("create failed\n", s);
    1f2c:	85e6                	mv	a1,s9
    1f2e:	00004517          	auipc	a0,0x4
    1f32:	8fa50513          	addi	a0,a0,-1798 # 5828 <malloc+0xfae>
    1f36:	00003097          	auipc	ra,0x3
    1f3a:	886080e7          	jalr	-1914(ra) # 47bc <printf>
        exit(1);
    1f3e:	4505                	li	a0,1
    1f40:	00002097          	auipc	ra,0x2
    1f44:	4fc080e7          	jalr	1276(ra) # 443c <exit>
          printf("write failed %d\n", n);
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	8f050513          	addi	a0,a0,-1808 # 5838 <malloc+0xfbe>
    1f50:	00003097          	auipc	ra,0x3
    1f54:	86c080e7          	jalr	-1940(ra) # 47bc <printf>
          exit(1);
    1f58:	4505                	li	a0,1
    1f5a:	00002097          	auipc	ra,0x2
    1f5e:	4e2080e7          	jalr	1250(ra) # 443c <exit>
      exit(xstatus);
    1f62:	00002097          	auipc	ra,0x2
    1f66:	4da080e7          	jalr	1242(ra) # 443c <exit>
          printf("wrong char\n", s);
    1f6a:	85e6                	mv	a1,s9
    1f6c:	00004517          	auipc	a0,0x4
    1f70:	8e450513          	addi	a0,a0,-1820 # 5850 <malloc+0xfd6>
    1f74:	00003097          	auipc	ra,0x3
    1f78:	848080e7          	jalr	-1976(ra) # 47bc <printf>
          exit(1);
    1f7c:	4505                	li	a0,1
    1f7e:	00002097          	auipc	ra,0x2
    1f82:	4be080e7          	jalr	1214(ra) # 443c <exit>
      total += n;
    1f86:	00a9093b          	addw	s2,s2,a0
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1f8a:	660d                	lui	a2,0x3
    1f8c:	85d2                	mv	a1,s4
    1f8e:	854e                	mv	a0,s3
    1f90:	00002097          	auipc	ra,0x2
    1f94:	4c4080e7          	jalr	1220(ra) # 4454 <read>
    1f98:	02a05363          	blez	a0,1fbe <fourfiles+0x1c6>
    1f9c:	00007797          	auipc	a5,0x7
    1fa0:	2b478793          	addi	a5,a5,692 # 9250 <buf>
    1fa4:	fff5069b          	addiw	a3,a0,-1
    1fa8:	1682                	slli	a3,a3,0x20
    1faa:	9281                	srli	a3,a3,0x20
    1fac:	96d6                	add	a3,a3,s5
        if(buf[j] != '0'+i){
    1fae:	0007c703          	lbu	a4,0(a5)
    1fb2:	fa971ce3          	bne	a4,s1,1f6a <fourfiles+0x172>
      for(j = 0; j < n; j++){
    1fb6:	0785                	addi	a5,a5,1
    1fb8:	fed79be3          	bne	a5,a3,1fae <fourfiles+0x1b6>
    1fbc:	b7e9                	j	1f86 <fourfiles+0x18e>
    close(fd);
    1fbe:	854e                	mv	a0,s3
    1fc0:	00002097          	auipc	ra,0x2
    1fc4:	4a4080e7          	jalr	1188(ra) # 4464 <close>
    if(total != N*SZ){
    1fc8:	03a91963          	bne	s2,s10,1ffa <fourfiles+0x202>
    unlink(fname);
    1fcc:	8562                	mv	a0,s8
    1fce:	00002097          	auipc	ra,0x2
    1fd2:	4be080e7          	jalr	1214(ra) # 448c <unlink>
  for(i = 0; i < NCHILD; i++){
    1fd6:	0ba1                	addi	s7,s7,8
    1fd8:	2b05                	addiw	s6,s6,1
    1fda:	03bb0e63          	beq	s6,s11,2016 <fourfiles+0x21e>
    fname = names[i];
    1fde:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    1fe2:	4581                	li	a1,0
    1fe4:	8562                	mv	a0,s8
    1fe6:	00002097          	auipc	ra,0x2
    1fea:	496080e7          	jalr	1174(ra) # 447c <open>
    1fee:	89aa                	mv	s3,a0
    total = 0;
    1ff0:	f5843903          	ld	s2,-168(s0)
        if(buf[j] != '0'+i){
    1ff4:	000b049b          	sext.w	s1,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1ff8:	bf49                	j	1f8a <fourfiles+0x192>
      printf("wrong length %d\n", total);
    1ffa:	85ca                	mv	a1,s2
    1ffc:	00004517          	auipc	a0,0x4
    2000:	86450513          	addi	a0,a0,-1948 # 5860 <malloc+0xfe6>
    2004:	00002097          	auipc	ra,0x2
    2008:	7b8080e7          	jalr	1976(ra) # 47bc <printf>
      exit(1);
    200c:	4505                	li	a0,1
    200e:	00002097          	auipc	ra,0x2
    2012:	42e080e7          	jalr	1070(ra) # 443c <exit>
}
    2016:	70aa                	ld	ra,168(sp)
    2018:	740a                	ld	s0,160(sp)
    201a:	64ea                	ld	s1,152(sp)
    201c:	694a                	ld	s2,144(sp)
    201e:	69aa                	ld	s3,136(sp)
    2020:	6a0a                	ld	s4,128(sp)
    2022:	7ae6                	ld	s5,120(sp)
    2024:	7b46                	ld	s6,112(sp)
    2026:	7ba6                	ld	s7,104(sp)
    2028:	7c06                	ld	s8,96(sp)
    202a:	6ce6                	ld	s9,88(sp)
    202c:	6d46                	ld	s10,80(sp)
    202e:	6da6                	ld	s11,72(sp)
    2030:	614d                	addi	sp,sp,176
    2032:	8082                	ret

0000000000002034 <bigfile>:
{
    2034:	7139                	addi	sp,sp,-64
    2036:	fc06                	sd	ra,56(sp)
    2038:	f822                	sd	s0,48(sp)
    203a:	f426                	sd	s1,40(sp)
    203c:	f04a                	sd	s2,32(sp)
    203e:	ec4e                	sd	s3,24(sp)
    2040:	e852                	sd	s4,16(sp)
    2042:	e456                	sd	s5,8(sp)
    2044:	0080                	addi	s0,sp,64
    2046:	8aaa                	mv	s5,a0
  unlink("bigfile.test");
    2048:	00004517          	auipc	a0,0x4
    204c:	83050513          	addi	a0,a0,-2000 # 5878 <malloc+0xffe>
    2050:	00002097          	auipc	ra,0x2
    2054:	43c080e7          	jalr	1084(ra) # 448c <unlink>
  fd = open("bigfile.test", O_CREATE | O_RDWR);
    2058:	20200593          	li	a1,514
    205c:	00004517          	auipc	a0,0x4
    2060:	81c50513          	addi	a0,a0,-2020 # 5878 <malloc+0xffe>
    2064:	00002097          	auipc	ra,0x2
    2068:	418080e7          	jalr	1048(ra) # 447c <open>
    206c:	89aa                	mv	s3,a0
  for(i = 0; i < N; i++){
    206e:	4481                	li	s1,0
    memset(buf, i, SZ);
    2070:	00007917          	auipc	s2,0x7
    2074:	1e090913          	addi	s2,s2,480 # 9250 <buf>
  for(i = 0; i < N; i++){
    2078:	4a51                	li	s4,20
  if(fd < 0){
    207a:	0a054063          	bltz	a0,211a <bigfile+0xe6>
    memset(buf, i, SZ);
    207e:	25800613          	li	a2,600
    2082:	85a6                	mv	a1,s1
    2084:	854a                	mv	a0,s2
    2086:	00002097          	auipc	ra,0x2
    208a:	1b2080e7          	jalr	434(ra) # 4238 <memset>
    if(write(fd, buf, SZ) != SZ){
    208e:	25800613          	li	a2,600
    2092:	85ca                	mv	a1,s2
    2094:	854e                	mv	a0,s3
    2096:	00002097          	auipc	ra,0x2
    209a:	3c6080e7          	jalr	966(ra) # 445c <write>
    209e:	25800793          	li	a5,600
    20a2:	08f51a63          	bne	a0,a5,2136 <bigfile+0x102>
  for(i = 0; i < N; i++){
    20a6:	2485                	addiw	s1,s1,1
    20a8:	fd449be3          	bne	s1,s4,207e <bigfile+0x4a>
  close(fd);
    20ac:	854e                	mv	a0,s3
    20ae:	00002097          	auipc	ra,0x2
    20b2:	3b6080e7          	jalr	950(ra) # 4464 <close>
  fd = open("bigfile.test", 0);
    20b6:	4581                	li	a1,0
    20b8:	00003517          	auipc	a0,0x3
    20bc:	7c050513          	addi	a0,a0,1984 # 5878 <malloc+0xffe>
    20c0:	00002097          	auipc	ra,0x2
    20c4:	3bc080e7          	jalr	956(ra) # 447c <open>
    20c8:	8a2a                	mv	s4,a0
  total = 0;
    20ca:	4981                	li	s3,0
  for(i = 0; ; i++){
    20cc:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    20ce:	00007917          	auipc	s2,0x7
    20d2:	18290913          	addi	s2,s2,386 # 9250 <buf>
  if(fd < 0){
    20d6:	06054e63          	bltz	a0,2152 <bigfile+0x11e>
    cc = read(fd, buf, SZ/2);
    20da:	12c00613          	li	a2,300
    20de:	85ca                	mv	a1,s2
    20e0:	8552                	mv	a0,s4
    20e2:	00002097          	auipc	ra,0x2
    20e6:	372080e7          	jalr	882(ra) # 4454 <read>
    if(cc < 0){
    20ea:	08054263          	bltz	a0,216e <bigfile+0x13a>
    if(cc == 0)
    20ee:	c971                	beqz	a0,21c2 <bigfile+0x18e>
    if(cc != SZ/2){
    20f0:	12c00793          	li	a5,300
    20f4:	08f51b63          	bne	a0,a5,218a <bigfile+0x156>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    20f8:	01f4d79b          	srliw	a5,s1,0x1f
    20fc:	9fa5                	addw	a5,a5,s1
    20fe:	4017d79b          	sraiw	a5,a5,0x1
    2102:	00094703          	lbu	a4,0(s2)
    2106:	0af71063          	bne	a4,a5,21a6 <bigfile+0x172>
    210a:	12b94703          	lbu	a4,299(s2)
    210e:	08f71c63          	bne	a4,a5,21a6 <bigfile+0x172>
    total += cc;
    2112:	12c9899b          	addiw	s3,s3,300
  for(i = 0; ; i++){
    2116:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    2118:	b7c9                	j	20da <bigfile+0xa6>
    printf("%s: cannot create bigfile", s);
    211a:	85d6                	mv	a1,s5
    211c:	00003517          	auipc	a0,0x3
    2120:	76c50513          	addi	a0,a0,1900 # 5888 <malloc+0x100e>
    2124:	00002097          	auipc	ra,0x2
    2128:	698080e7          	jalr	1688(ra) # 47bc <printf>
    exit(1);
    212c:	4505                	li	a0,1
    212e:	00002097          	auipc	ra,0x2
    2132:	30e080e7          	jalr	782(ra) # 443c <exit>
      printf("%s: write bigfile failed\n", s);
    2136:	85d6                	mv	a1,s5
    2138:	00003517          	auipc	a0,0x3
    213c:	77050513          	addi	a0,a0,1904 # 58a8 <malloc+0x102e>
    2140:	00002097          	auipc	ra,0x2
    2144:	67c080e7          	jalr	1660(ra) # 47bc <printf>
      exit(1);
    2148:	4505                	li	a0,1
    214a:	00002097          	auipc	ra,0x2
    214e:	2f2080e7          	jalr	754(ra) # 443c <exit>
    printf("%s: cannot open bigfile\n", s);
    2152:	85d6                	mv	a1,s5
    2154:	00003517          	auipc	a0,0x3
    2158:	77450513          	addi	a0,a0,1908 # 58c8 <malloc+0x104e>
    215c:	00002097          	auipc	ra,0x2
    2160:	660080e7          	jalr	1632(ra) # 47bc <printf>
    exit(1);
    2164:	4505                	li	a0,1
    2166:	00002097          	auipc	ra,0x2
    216a:	2d6080e7          	jalr	726(ra) # 443c <exit>
      printf("%s: read bigfile failed\n", s);
    216e:	85d6                	mv	a1,s5
    2170:	00003517          	auipc	a0,0x3
    2174:	77850513          	addi	a0,a0,1912 # 58e8 <malloc+0x106e>
    2178:	00002097          	auipc	ra,0x2
    217c:	644080e7          	jalr	1604(ra) # 47bc <printf>
      exit(1);
    2180:	4505                	li	a0,1
    2182:	00002097          	auipc	ra,0x2
    2186:	2ba080e7          	jalr	698(ra) # 443c <exit>
      printf("%s: short read bigfile\n", s);
    218a:	85d6                	mv	a1,s5
    218c:	00003517          	auipc	a0,0x3
    2190:	77c50513          	addi	a0,a0,1916 # 5908 <malloc+0x108e>
    2194:	00002097          	auipc	ra,0x2
    2198:	628080e7          	jalr	1576(ra) # 47bc <printf>
      exit(1);
    219c:	4505                	li	a0,1
    219e:	00002097          	auipc	ra,0x2
    21a2:	29e080e7          	jalr	670(ra) # 443c <exit>
      printf("%s: read bigfile wrong data\n", s);
    21a6:	85d6                	mv	a1,s5
    21a8:	00003517          	auipc	a0,0x3
    21ac:	77850513          	addi	a0,a0,1912 # 5920 <malloc+0x10a6>
    21b0:	00002097          	auipc	ra,0x2
    21b4:	60c080e7          	jalr	1548(ra) # 47bc <printf>
      exit(1);
    21b8:	4505                	li	a0,1
    21ba:	00002097          	auipc	ra,0x2
    21be:	282080e7          	jalr	642(ra) # 443c <exit>
  close(fd);
    21c2:	8552                	mv	a0,s4
    21c4:	00002097          	auipc	ra,0x2
    21c8:	2a0080e7          	jalr	672(ra) # 4464 <close>
  if(total != N*SZ){
    21cc:	678d                	lui	a5,0x3
    21ce:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x508>
    21d2:	02f99363          	bne	s3,a5,21f8 <bigfile+0x1c4>
  unlink("bigfile.test");
    21d6:	00003517          	auipc	a0,0x3
    21da:	6a250513          	addi	a0,a0,1698 # 5878 <malloc+0xffe>
    21de:	00002097          	auipc	ra,0x2
    21e2:	2ae080e7          	jalr	686(ra) # 448c <unlink>
}
    21e6:	70e2                	ld	ra,56(sp)
    21e8:	7442                	ld	s0,48(sp)
    21ea:	74a2                	ld	s1,40(sp)
    21ec:	7902                	ld	s2,32(sp)
    21ee:	69e2                	ld	s3,24(sp)
    21f0:	6a42                	ld	s4,16(sp)
    21f2:	6aa2                	ld	s5,8(sp)
    21f4:	6121                	addi	sp,sp,64
    21f6:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    21f8:	85d6                	mv	a1,s5
    21fa:	00003517          	auipc	a0,0x3
    21fe:	74650513          	addi	a0,a0,1862 # 5940 <malloc+0x10c6>
    2202:	00002097          	auipc	ra,0x2
    2206:	5ba080e7          	jalr	1466(ra) # 47bc <printf>
    exit(1);
    220a:	4505                	li	a0,1
    220c:	00002097          	auipc	ra,0x2
    2210:	230080e7          	jalr	560(ra) # 443c <exit>

0000000000002214 <linktest>:
{
    2214:	1101                	addi	sp,sp,-32
    2216:	ec06                	sd	ra,24(sp)
    2218:	e822                	sd	s0,16(sp)
    221a:	e426                	sd	s1,8(sp)
    221c:	e04a                	sd	s2,0(sp)
    221e:	1000                	addi	s0,sp,32
    2220:	892a                	mv	s2,a0
  unlink("lf1");
    2222:	00003517          	auipc	a0,0x3
    2226:	73e50513          	addi	a0,a0,1854 # 5960 <malloc+0x10e6>
    222a:	00002097          	auipc	ra,0x2
    222e:	262080e7          	jalr	610(ra) # 448c <unlink>
  unlink("lf2");
    2232:	00003517          	auipc	a0,0x3
    2236:	73650513          	addi	a0,a0,1846 # 5968 <malloc+0x10ee>
    223a:	00002097          	auipc	ra,0x2
    223e:	252080e7          	jalr	594(ra) # 448c <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
    2242:	20200593          	li	a1,514
    2246:	00003517          	auipc	a0,0x3
    224a:	71a50513          	addi	a0,a0,1818 # 5960 <malloc+0x10e6>
    224e:	00002097          	auipc	ra,0x2
    2252:	22e080e7          	jalr	558(ra) # 447c <open>
  if(fd < 0){
    2256:	10054763          	bltz	a0,2364 <linktest+0x150>
    225a:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
    225c:	4615                	li	a2,5
    225e:	00003597          	auipc	a1,0x3
    2262:	1ea58593          	addi	a1,a1,490 # 5448 <malloc+0xbce>
    2266:	00002097          	auipc	ra,0x2
    226a:	1f6080e7          	jalr	502(ra) # 445c <write>
    226e:	4795                	li	a5,5
    2270:	10f51863          	bne	a0,a5,2380 <linktest+0x16c>
  close(fd);
    2274:	8526                	mv	a0,s1
    2276:	00002097          	auipc	ra,0x2
    227a:	1ee080e7          	jalr	494(ra) # 4464 <close>
  if(link("lf1", "lf2") < 0){
    227e:	00003597          	auipc	a1,0x3
    2282:	6ea58593          	addi	a1,a1,1770 # 5968 <malloc+0x10ee>
    2286:	00003517          	auipc	a0,0x3
    228a:	6da50513          	addi	a0,a0,1754 # 5960 <malloc+0x10e6>
    228e:	00002097          	auipc	ra,0x2
    2292:	20e080e7          	jalr	526(ra) # 449c <link>
    2296:	10054363          	bltz	a0,239c <linktest+0x188>
  unlink("lf1");
    229a:	00003517          	auipc	a0,0x3
    229e:	6c650513          	addi	a0,a0,1734 # 5960 <malloc+0x10e6>
    22a2:	00002097          	auipc	ra,0x2
    22a6:	1ea080e7          	jalr	490(ra) # 448c <unlink>
  if(open("lf1", 0) >= 0){
    22aa:	4581                	li	a1,0
    22ac:	00003517          	auipc	a0,0x3
    22b0:	6b450513          	addi	a0,a0,1716 # 5960 <malloc+0x10e6>
    22b4:	00002097          	auipc	ra,0x2
    22b8:	1c8080e7          	jalr	456(ra) # 447c <open>
    22bc:	0e055e63          	bgez	a0,23b8 <linktest+0x1a4>
  fd = open("lf2", 0);
    22c0:	4581                	li	a1,0
    22c2:	00003517          	auipc	a0,0x3
    22c6:	6a650513          	addi	a0,a0,1702 # 5968 <malloc+0x10ee>
    22ca:	00002097          	auipc	ra,0x2
    22ce:	1b2080e7          	jalr	434(ra) # 447c <open>
    22d2:	84aa                	mv	s1,a0
  if(fd < 0){
    22d4:	10054063          	bltz	a0,23d4 <linktest+0x1c0>
  if(read(fd, buf, sizeof(buf)) != SZ){
    22d8:	660d                	lui	a2,0x3
    22da:	00007597          	auipc	a1,0x7
    22de:	f7658593          	addi	a1,a1,-138 # 9250 <buf>
    22e2:	00002097          	auipc	ra,0x2
    22e6:	172080e7          	jalr	370(ra) # 4454 <read>
    22ea:	4795                	li	a5,5
    22ec:	10f51263          	bne	a0,a5,23f0 <linktest+0x1dc>
  close(fd);
    22f0:	8526                	mv	a0,s1
    22f2:	00002097          	auipc	ra,0x2
    22f6:	172080e7          	jalr	370(ra) # 4464 <close>
  if(link("lf2", "lf2") >= 0){
    22fa:	00003597          	auipc	a1,0x3
    22fe:	66e58593          	addi	a1,a1,1646 # 5968 <malloc+0x10ee>
    2302:	852e                	mv	a0,a1
    2304:	00002097          	auipc	ra,0x2
    2308:	198080e7          	jalr	408(ra) # 449c <link>
    230c:	10055063          	bgez	a0,240c <linktest+0x1f8>
  unlink("lf2");
    2310:	00003517          	auipc	a0,0x3
    2314:	65850513          	addi	a0,a0,1624 # 5968 <malloc+0x10ee>
    2318:	00002097          	auipc	ra,0x2
    231c:	174080e7          	jalr	372(ra) # 448c <unlink>
  if(link("lf2", "lf1") >= 0){
    2320:	00003597          	auipc	a1,0x3
    2324:	64058593          	addi	a1,a1,1600 # 5960 <malloc+0x10e6>
    2328:	00003517          	auipc	a0,0x3
    232c:	64050513          	addi	a0,a0,1600 # 5968 <malloc+0x10ee>
    2330:	00002097          	auipc	ra,0x2
    2334:	16c080e7          	jalr	364(ra) # 449c <link>
    2338:	0e055863          	bgez	a0,2428 <linktest+0x214>
  if(link(".", "lf1") >= 0){
    233c:	00003597          	auipc	a1,0x3
    2340:	62458593          	addi	a1,a1,1572 # 5960 <malloc+0x10e6>
    2344:	00003517          	auipc	a0,0x3
    2348:	98450513          	addi	a0,a0,-1660 # 4cc8 <malloc+0x44e>
    234c:	00002097          	auipc	ra,0x2
    2350:	150080e7          	jalr	336(ra) # 449c <link>
    2354:	0e055863          	bgez	a0,2444 <linktest+0x230>
}
    2358:	60e2                	ld	ra,24(sp)
    235a:	6442                	ld	s0,16(sp)
    235c:	64a2                	ld	s1,8(sp)
    235e:	6902                	ld	s2,0(sp)
    2360:	6105                	addi	sp,sp,32
    2362:	8082                	ret
    printf("%s: create lf1 failed\n", s);
    2364:	85ca                	mv	a1,s2
    2366:	00003517          	auipc	a0,0x3
    236a:	60a50513          	addi	a0,a0,1546 # 5970 <malloc+0x10f6>
    236e:	00002097          	auipc	ra,0x2
    2372:	44e080e7          	jalr	1102(ra) # 47bc <printf>
    exit(1);
    2376:	4505                	li	a0,1
    2378:	00002097          	auipc	ra,0x2
    237c:	0c4080e7          	jalr	196(ra) # 443c <exit>
    printf("%s: write lf1 failed\n", s);
    2380:	85ca                	mv	a1,s2
    2382:	00003517          	auipc	a0,0x3
    2386:	60650513          	addi	a0,a0,1542 # 5988 <malloc+0x110e>
    238a:	00002097          	auipc	ra,0x2
    238e:	432080e7          	jalr	1074(ra) # 47bc <printf>
    exit(1);
    2392:	4505                	li	a0,1
    2394:	00002097          	auipc	ra,0x2
    2398:	0a8080e7          	jalr	168(ra) # 443c <exit>
    printf("%s: link lf1 lf2 failed\n", s);
    239c:	85ca                	mv	a1,s2
    239e:	00003517          	auipc	a0,0x3
    23a2:	60250513          	addi	a0,a0,1538 # 59a0 <malloc+0x1126>
    23a6:	00002097          	auipc	ra,0x2
    23aa:	416080e7          	jalr	1046(ra) # 47bc <printf>
    exit(1);
    23ae:	4505                	li	a0,1
    23b0:	00002097          	auipc	ra,0x2
    23b4:	08c080e7          	jalr	140(ra) # 443c <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
    23b8:	85ca                	mv	a1,s2
    23ba:	00003517          	auipc	a0,0x3
    23be:	60650513          	addi	a0,a0,1542 # 59c0 <malloc+0x1146>
    23c2:	00002097          	auipc	ra,0x2
    23c6:	3fa080e7          	jalr	1018(ra) # 47bc <printf>
    exit(1);
    23ca:	4505                	li	a0,1
    23cc:	00002097          	auipc	ra,0x2
    23d0:	070080e7          	jalr	112(ra) # 443c <exit>
    printf("%s: open lf2 failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00003517          	auipc	a0,0x3
    23da:	61a50513          	addi	a0,a0,1562 # 59f0 <malloc+0x1176>
    23de:	00002097          	auipc	ra,0x2
    23e2:	3de080e7          	jalr	990(ra) # 47bc <printf>
    exit(1);
    23e6:	4505                	li	a0,1
    23e8:	00002097          	auipc	ra,0x2
    23ec:	054080e7          	jalr	84(ra) # 443c <exit>
    printf("%s: read lf2 failed\n", s);
    23f0:	85ca                	mv	a1,s2
    23f2:	00003517          	auipc	a0,0x3
    23f6:	61650513          	addi	a0,a0,1558 # 5a08 <malloc+0x118e>
    23fa:	00002097          	auipc	ra,0x2
    23fe:	3c2080e7          	jalr	962(ra) # 47bc <printf>
    exit(1);
    2402:	4505                	li	a0,1
    2404:	00002097          	auipc	ra,0x2
    2408:	038080e7          	jalr	56(ra) # 443c <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
    240c:	85ca                	mv	a1,s2
    240e:	00003517          	auipc	a0,0x3
    2412:	61250513          	addi	a0,a0,1554 # 5a20 <malloc+0x11a6>
    2416:	00002097          	auipc	ra,0x2
    241a:	3a6080e7          	jalr	934(ra) # 47bc <printf>
    exit(1);
    241e:	4505                	li	a0,1
    2420:	00002097          	auipc	ra,0x2
    2424:	01c080e7          	jalr	28(ra) # 443c <exit>
    printf("%s: link non-existant succeeded! oops\n", s);
    2428:	85ca                	mv	a1,s2
    242a:	00003517          	auipc	a0,0x3
    242e:	61e50513          	addi	a0,a0,1566 # 5a48 <malloc+0x11ce>
    2432:	00002097          	auipc	ra,0x2
    2436:	38a080e7          	jalr	906(ra) # 47bc <printf>
    exit(1);
    243a:	4505                	li	a0,1
    243c:	00002097          	auipc	ra,0x2
    2440:	000080e7          	jalr	ra # 443c <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
    2444:	85ca                	mv	a1,s2
    2446:	00003517          	auipc	a0,0x3
    244a:	62a50513          	addi	a0,a0,1578 # 5a70 <malloc+0x11f6>
    244e:	00002097          	auipc	ra,0x2
    2452:	36e080e7          	jalr	878(ra) # 47bc <printf>
    exit(1);
    2456:	4505                	li	a0,1
    2458:	00002097          	auipc	ra,0x2
    245c:	fe4080e7          	jalr	-28(ra) # 443c <exit>

0000000000002460 <concreate>:
{
    2460:	7135                	addi	sp,sp,-160
    2462:	ed06                	sd	ra,152(sp)
    2464:	e922                	sd	s0,144(sp)
    2466:	e526                	sd	s1,136(sp)
    2468:	e14a                	sd	s2,128(sp)
    246a:	fcce                	sd	s3,120(sp)
    246c:	f8d2                	sd	s4,112(sp)
    246e:	f4d6                	sd	s5,104(sp)
    2470:	f0da                	sd	s6,96(sp)
    2472:	ecde                	sd	s7,88(sp)
    2474:	1100                	addi	s0,sp,160
    2476:	89aa                	mv	s3,a0
  file[0] = 'C';
    2478:	04300793          	li	a5,67
    247c:	faf40423          	sb	a5,-88(s0)
  file[2] = '\0';
    2480:	fa040523          	sb	zero,-86(s0)
  for(i = 0; i < N; i++){
    2484:	4901                	li	s2,0
    if(pid && (i % 3) == 1){
    2486:	4b0d                	li	s6,3
    2488:	4a85                	li	s5,1
      link("C0", file);
    248a:	00003b97          	auipc	s7,0x3
    248e:	606b8b93          	addi	s7,s7,1542 # 5a90 <malloc+0x1216>
  for(i = 0; i < N; i++){
    2492:	02800a13          	li	s4,40
    2496:	a471                	j	2722 <concreate+0x2c2>
      link("C0", file);
    2498:	fa840593          	addi	a1,s0,-88
    249c:	855e                	mv	a0,s7
    249e:	00002097          	auipc	ra,0x2
    24a2:	ffe080e7          	jalr	-2(ra) # 449c <link>
    if(pid == 0) {
    24a6:	a48d                	j	2708 <concreate+0x2a8>
    } else if(pid == 0 && (i % 5) == 1){
    24a8:	4795                	li	a5,5
    24aa:	02f9693b          	remw	s2,s2,a5
    24ae:	4785                	li	a5,1
    24b0:	02f90b63          	beq	s2,a5,24e6 <concreate+0x86>
      fd = open(file, O_CREATE | O_RDWR);
    24b4:	20200593          	li	a1,514
    24b8:	fa840513          	addi	a0,s0,-88
    24bc:	00002097          	auipc	ra,0x2
    24c0:	fc0080e7          	jalr	-64(ra) # 447c <open>
      if(fd < 0){
    24c4:	22055963          	bgez	a0,26f6 <concreate+0x296>
        printf("concreate create %s failed\n", file);
    24c8:	fa840593          	addi	a1,s0,-88
    24cc:	00003517          	auipc	a0,0x3
    24d0:	5cc50513          	addi	a0,a0,1484 # 5a98 <malloc+0x121e>
    24d4:	00002097          	auipc	ra,0x2
    24d8:	2e8080e7          	jalr	744(ra) # 47bc <printf>
        exit(1);
    24dc:	4505                	li	a0,1
    24de:	00002097          	auipc	ra,0x2
    24e2:	f5e080e7          	jalr	-162(ra) # 443c <exit>
      link("C0", file);
    24e6:	fa840593          	addi	a1,s0,-88
    24ea:	00003517          	auipc	a0,0x3
    24ee:	5a650513          	addi	a0,a0,1446 # 5a90 <malloc+0x1216>
    24f2:	00002097          	auipc	ra,0x2
    24f6:	faa080e7          	jalr	-86(ra) # 449c <link>
      exit(0);
    24fa:	4501                	li	a0,0
    24fc:	00002097          	auipc	ra,0x2
    2500:	f40080e7          	jalr	-192(ra) # 443c <exit>
        exit(1);
    2504:	4505                	li	a0,1
    2506:	00002097          	auipc	ra,0x2
    250a:	f36080e7          	jalr	-202(ra) # 443c <exit>
  memset(fa, 0, sizeof(fa));
    250e:	02800613          	li	a2,40
    2512:	4581                	li	a1,0
    2514:	f8040513          	addi	a0,s0,-128
    2518:	00002097          	auipc	ra,0x2
    251c:	d20080e7          	jalr	-736(ra) # 4238 <memset>
  fd = open(".", 0);
    2520:	4581                	li	a1,0
    2522:	00002517          	auipc	a0,0x2
    2526:	7a650513          	addi	a0,a0,1958 # 4cc8 <malloc+0x44e>
    252a:	00002097          	auipc	ra,0x2
    252e:	f52080e7          	jalr	-174(ra) # 447c <open>
    2532:	892a                	mv	s2,a0
  n = 0;
    2534:	8aa6                	mv	s5,s1
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2536:	04300a13          	li	s4,67
      if(i < 0 || i >= sizeof(fa)){
    253a:	02700b13          	li	s6,39
      fa[i] = 1;
    253e:	4b85                	li	s7,1
  while(read(fd, &de, sizeof(de)) > 0){
    2540:	a03d                	j	256e <concreate+0x10e>
        printf("%s: concreate weird file %s\n", s, de.name);
    2542:	f7240613          	addi	a2,s0,-142
    2546:	85ce                	mv	a1,s3
    2548:	00003517          	auipc	a0,0x3
    254c:	57050513          	addi	a0,a0,1392 # 5ab8 <malloc+0x123e>
    2550:	00002097          	auipc	ra,0x2
    2554:	26c080e7          	jalr	620(ra) # 47bc <printf>
        exit(1);
    2558:	4505                	li	a0,1
    255a:	00002097          	auipc	ra,0x2
    255e:	ee2080e7          	jalr	-286(ra) # 443c <exit>
      fa[i] = 1;
    2562:	fb040793          	addi	a5,s0,-80
    2566:	973e                	add	a4,a4,a5
    2568:	fd770823          	sb	s7,-48(a4)
      n++;
    256c:	2a85                	addiw	s5,s5,1
  while(read(fd, &de, sizeof(de)) > 0){
    256e:	4641                	li	a2,16
    2570:	f7040593          	addi	a1,s0,-144
    2574:	854a                	mv	a0,s2
    2576:	00002097          	auipc	ra,0x2
    257a:	ede080e7          	jalr	-290(ra) # 4454 <read>
    257e:	04a05a63          	blez	a0,25d2 <concreate+0x172>
    if(de.inum == 0)
    2582:	f7045783          	lhu	a5,-144(s0)
    2586:	d7e5                	beqz	a5,256e <concreate+0x10e>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    2588:	f7244783          	lbu	a5,-142(s0)
    258c:	ff4791e3          	bne	a5,s4,256e <concreate+0x10e>
    2590:	f7444783          	lbu	a5,-140(s0)
    2594:	ffe9                	bnez	a5,256e <concreate+0x10e>
      i = de.name[1] - '0';
    2596:	f7344783          	lbu	a5,-141(s0)
    259a:	fd07879b          	addiw	a5,a5,-48
    259e:	0007871b          	sext.w	a4,a5
      if(i < 0 || i >= sizeof(fa)){
    25a2:	faeb60e3          	bltu	s6,a4,2542 <concreate+0xe2>
      if(fa[i]){
    25a6:	fb040793          	addi	a5,s0,-80
    25aa:	97ba                	add	a5,a5,a4
    25ac:	fd07c783          	lbu	a5,-48(a5)
    25b0:	dbcd                	beqz	a5,2562 <concreate+0x102>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    25b2:	f7240613          	addi	a2,s0,-142
    25b6:	85ce                	mv	a1,s3
    25b8:	00003517          	auipc	a0,0x3
    25bc:	52050513          	addi	a0,a0,1312 # 5ad8 <malloc+0x125e>
    25c0:	00002097          	auipc	ra,0x2
    25c4:	1fc080e7          	jalr	508(ra) # 47bc <printf>
        exit(1);
    25c8:	4505                	li	a0,1
    25ca:	00002097          	auipc	ra,0x2
    25ce:	e72080e7          	jalr	-398(ra) # 443c <exit>
  close(fd);
    25d2:	854a                	mv	a0,s2
    25d4:	00002097          	auipc	ra,0x2
    25d8:	e90080e7          	jalr	-368(ra) # 4464 <close>
  if(n != N){
    25dc:	02800793          	li	a5,40
    25e0:	00fa9763          	bne	s5,a5,25ee <concreate+0x18e>
    if(((i % 3) == 0 && pid == 0) ||
    25e4:	4a8d                	li	s5,3
    25e6:	4b05                	li	s6,1
  for(i = 0; i < N; i++){
    25e8:	02800a13          	li	s4,40
    25ec:	a05d                	j	2692 <concreate+0x232>
    printf("%s: concreate not enough files in directory listing\n", s);
    25ee:	85ce                	mv	a1,s3
    25f0:	00003517          	auipc	a0,0x3
    25f4:	51050513          	addi	a0,a0,1296 # 5b00 <malloc+0x1286>
    25f8:	00002097          	auipc	ra,0x2
    25fc:	1c4080e7          	jalr	452(ra) # 47bc <printf>
    exit(1);
    2600:	4505                	li	a0,1
    2602:	00002097          	auipc	ra,0x2
    2606:	e3a080e7          	jalr	-454(ra) # 443c <exit>
      printf("%s: fork failed\n", s);
    260a:	85ce                	mv	a1,s3
    260c:	00002517          	auipc	a0,0x2
    2610:	76c50513          	addi	a0,a0,1900 # 4d78 <malloc+0x4fe>
    2614:	00002097          	auipc	ra,0x2
    2618:	1a8080e7          	jalr	424(ra) # 47bc <printf>
      exit(1);
    261c:	4505                	li	a0,1
    261e:	00002097          	auipc	ra,0x2
    2622:	e1e080e7          	jalr	-482(ra) # 443c <exit>
      close(open(file, 0));
    2626:	4581                	li	a1,0
    2628:	fa840513          	addi	a0,s0,-88
    262c:	00002097          	auipc	ra,0x2
    2630:	e50080e7          	jalr	-432(ra) # 447c <open>
    2634:	00002097          	auipc	ra,0x2
    2638:	e30080e7          	jalr	-464(ra) # 4464 <close>
      close(open(file, 0));
    263c:	4581                	li	a1,0
    263e:	fa840513          	addi	a0,s0,-88
    2642:	00002097          	auipc	ra,0x2
    2646:	e3a080e7          	jalr	-454(ra) # 447c <open>
    264a:	00002097          	auipc	ra,0x2
    264e:	e1a080e7          	jalr	-486(ra) # 4464 <close>
      close(open(file, 0));
    2652:	4581                	li	a1,0
    2654:	fa840513          	addi	a0,s0,-88
    2658:	00002097          	auipc	ra,0x2
    265c:	e24080e7          	jalr	-476(ra) # 447c <open>
    2660:	00002097          	auipc	ra,0x2
    2664:	e04080e7          	jalr	-508(ra) # 4464 <close>
      close(open(file, 0));
    2668:	4581                	li	a1,0
    266a:	fa840513          	addi	a0,s0,-88
    266e:	00002097          	auipc	ra,0x2
    2672:	e0e080e7          	jalr	-498(ra) # 447c <open>
    2676:	00002097          	auipc	ra,0x2
    267a:	dee080e7          	jalr	-530(ra) # 4464 <close>
    if(pid == 0)
    267e:	06090763          	beqz	s2,26ec <concreate+0x28c>
      wait(0);
    2682:	4501                	li	a0,0
    2684:	00002097          	auipc	ra,0x2
    2688:	dc0080e7          	jalr	-576(ra) # 4444 <wait>
  for(i = 0; i < N; i++){
    268c:	2485                	addiw	s1,s1,1
    268e:	0d448963          	beq	s1,s4,2760 <concreate+0x300>
    file[1] = '0' + i;
    2692:	0304879b          	addiw	a5,s1,48
    2696:	faf404a3          	sb	a5,-87(s0)
    pid = fork();
    269a:	00002097          	auipc	ra,0x2
    269e:	d9a080e7          	jalr	-614(ra) # 4434 <fork>
    26a2:	892a                	mv	s2,a0
    if(pid < 0){
    26a4:	f60543e3          	bltz	a0,260a <concreate+0x1aa>
    if(((i % 3) == 0 && pid == 0) ||
    26a8:	0354e73b          	remw	a4,s1,s5
    26ac:	00a767b3          	or	a5,a4,a0
    26b0:	2781                	sext.w	a5,a5
    26b2:	dbb5                	beqz	a5,2626 <concreate+0x1c6>
    26b4:	01671363          	bne	a4,s6,26ba <concreate+0x25a>
       ((i % 3) == 1 && pid != 0)){
    26b8:	f53d                	bnez	a0,2626 <concreate+0x1c6>
      unlink(file);
    26ba:	fa840513          	addi	a0,s0,-88
    26be:	00002097          	auipc	ra,0x2
    26c2:	dce080e7          	jalr	-562(ra) # 448c <unlink>
      unlink(file);
    26c6:	fa840513          	addi	a0,s0,-88
    26ca:	00002097          	auipc	ra,0x2
    26ce:	dc2080e7          	jalr	-574(ra) # 448c <unlink>
      unlink(file);
    26d2:	fa840513          	addi	a0,s0,-88
    26d6:	00002097          	auipc	ra,0x2
    26da:	db6080e7          	jalr	-586(ra) # 448c <unlink>
      unlink(file);
    26de:	fa840513          	addi	a0,s0,-88
    26e2:	00002097          	auipc	ra,0x2
    26e6:	daa080e7          	jalr	-598(ra) # 448c <unlink>
    26ea:	bf51                	j	267e <concreate+0x21e>
      exit(0);
    26ec:	4501                	li	a0,0
    26ee:	00002097          	auipc	ra,0x2
    26f2:	d4e080e7          	jalr	-690(ra) # 443c <exit>
      close(fd);
    26f6:	00002097          	auipc	ra,0x2
    26fa:	d6e080e7          	jalr	-658(ra) # 4464 <close>
    if(pid == 0) {
    26fe:	bbf5                	j	24fa <concreate+0x9a>
      close(fd);
    2700:	00002097          	auipc	ra,0x2
    2704:	d64080e7          	jalr	-668(ra) # 4464 <close>
      wait(&xstatus);
    2708:	f6c40513          	addi	a0,s0,-148
    270c:	00002097          	auipc	ra,0x2
    2710:	d38080e7          	jalr	-712(ra) # 4444 <wait>
      if(xstatus != 0)
    2714:	f6c42483          	lw	s1,-148(s0)
    2718:	de0496e3          	bnez	s1,2504 <concreate+0xa4>
  for(i = 0; i < N; i++){
    271c:	2905                	addiw	s2,s2,1
    271e:	df4908e3          	beq	s2,s4,250e <concreate+0xae>
    file[1] = '0' + i;
    2722:	0309079b          	addiw	a5,s2,48
    2726:	faf404a3          	sb	a5,-87(s0)
    unlink(file);
    272a:	fa840513          	addi	a0,s0,-88
    272e:	00002097          	auipc	ra,0x2
    2732:	d5e080e7          	jalr	-674(ra) # 448c <unlink>
    pid = fork();
    2736:	00002097          	auipc	ra,0x2
    273a:	cfe080e7          	jalr	-770(ra) # 4434 <fork>
    if(pid && (i % 3) == 1){
    273e:	d60505e3          	beqz	a0,24a8 <concreate+0x48>
    2742:	036967bb          	remw	a5,s2,s6
    2746:	d55789e3          	beq	a5,s5,2498 <concreate+0x38>
      fd = open(file, O_CREATE | O_RDWR);
    274a:	20200593          	li	a1,514
    274e:	fa840513          	addi	a0,s0,-88
    2752:	00002097          	auipc	ra,0x2
    2756:	d2a080e7          	jalr	-726(ra) # 447c <open>
      if(fd < 0){
    275a:	fa0553e3          	bgez	a0,2700 <concreate+0x2a0>
    275e:	b3ad                	j	24c8 <concreate+0x68>
}
    2760:	60ea                	ld	ra,152(sp)
    2762:	644a                	ld	s0,144(sp)
    2764:	64aa                	ld	s1,136(sp)
    2766:	690a                	ld	s2,128(sp)
    2768:	79e6                	ld	s3,120(sp)
    276a:	7a46                	ld	s4,112(sp)
    276c:	7aa6                	ld	s5,104(sp)
    276e:	7b06                	ld	s6,96(sp)
    2770:	6be6                	ld	s7,88(sp)
    2772:	610d                	addi	sp,sp,160
    2774:	8082                	ret

0000000000002776 <linkunlink>:
{
    2776:	711d                	addi	sp,sp,-96
    2778:	ec86                	sd	ra,88(sp)
    277a:	e8a2                	sd	s0,80(sp)
    277c:	e4a6                	sd	s1,72(sp)
    277e:	e0ca                	sd	s2,64(sp)
    2780:	fc4e                	sd	s3,56(sp)
    2782:	f852                	sd	s4,48(sp)
    2784:	f456                	sd	s5,40(sp)
    2786:	f05a                	sd	s6,32(sp)
    2788:	ec5e                	sd	s7,24(sp)
    278a:	e862                	sd	s8,16(sp)
    278c:	e466                	sd	s9,8(sp)
    278e:	1080                	addi	s0,sp,96
    2790:	84aa                	mv	s1,a0
  unlink("x");
    2792:	00003517          	auipc	a0,0x3
    2796:	f9650513          	addi	a0,a0,-106 # 5728 <malloc+0xeae>
    279a:	00002097          	auipc	ra,0x2
    279e:	cf2080e7          	jalr	-782(ra) # 448c <unlink>
  pid = fork();
    27a2:	00002097          	auipc	ra,0x2
    27a6:	c92080e7          	jalr	-878(ra) # 4434 <fork>
  if(pid < 0){
    27aa:	02054b63          	bltz	a0,27e0 <linkunlink+0x6a>
    27ae:	8c2a                	mv	s8,a0
  unsigned int x = (pid ? 1 : 97);
    27b0:	4c85                	li	s9,1
    27b2:	e119                	bnez	a0,27b8 <linkunlink+0x42>
    27b4:	06100c93          	li	s9,97
    27b8:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    27bc:	41c659b7          	lui	s3,0x41c65
    27c0:	e6d9899b          	addiw	s3,s3,-403
    27c4:	690d                	lui	s2,0x3
    27c6:	0399091b          	addiw	s2,s2,57
    if((x % 3) == 0){
    27ca:	4a0d                	li	s4,3
    } else if((x % 3) == 1){
    27cc:	4b05                	li	s6,1
      unlink("x");
    27ce:	00003a97          	auipc	s5,0x3
    27d2:	f5aa8a93          	addi	s5,s5,-166 # 5728 <malloc+0xeae>
      link("cat", "x");
    27d6:	00003b97          	auipc	s7,0x3
    27da:	362b8b93          	addi	s7,s7,866 # 5b38 <malloc+0x12be>
    27de:	a091                	j	2822 <linkunlink+0xac>
    printf("%s: fork failed\n", s);
    27e0:	85a6                	mv	a1,s1
    27e2:	00002517          	auipc	a0,0x2
    27e6:	59650513          	addi	a0,a0,1430 # 4d78 <malloc+0x4fe>
    27ea:	00002097          	auipc	ra,0x2
    27ee:	fd2080e7          	jalr	-46(ra) # 47bc <printf>
    exit(1);
    27f2:	4505                	li	a0,1
    27f4:	00002097          	auipc	ra,0x2
    27f8:	c48080e7          	jalr	-952(ra) # 443c <exit>
      close(open("x", O_RDWR | O_CREATE));
    27fc:	20200593          	li	a1,514
    2800:	8556                	mv	a0,s5
    2802:	00002097          	auipc	ra,0x2
    2806:	c7a080e7          	jalr	-902(ra) # 447c <open>
    280a:	00002097          	auipc	ra,0x2
    280e:	c5a080e7          	jalr	-934(ra) # 4464 <close>
    2812:	a031                	j	281e <linkunlink+0xa8>
      unlink("x");
    2814:	8556                	mv	a0,s5
    2816:	00002097          	auipc	ra,0x2
    281a:	c76080e7          	jalr	-906(ra) # 448c <unlink>
  for(i = 0; i < 100; i++){
    281e:	34fd                	addiw	s1,s1,-1
    2820:	c09d                	beqz	s1,2846 <linkunlink+0xd0>
    x = x * 1103515245 + 12345;
    2822:	033c87bb          	mulw	a5,s9,s3
    2826:	012787bb          	addw	a5,a5,s2
    282a:	00078c9b          	sext.w	s9,a5
    if((x % 3) == 0){
    282e:	0347f7bb          	remuw	a5,a5,s4
    2832:	d7e9                	beqz	a5,27fc <linkunlink+0x86>
    } else if((x % 3) == 1){
    2834:	ff6790e3          	bne	a5,s6,2814 <linkunlink+0x9e>
      link("cat", "x");
    2838:	85d6                	mv	a1,s5
    283a:	855e                	mv	a0,s7
    283c:	00002097          	auipc	ra,0x2
    2840:	c60080e7          	jalr	-928(ra) # 449c <link>
    2844:	bfe9                	j	281e <linkunlink+0xa8>
  if(pid)
    2846:	020c0463          	beqz	s8,286e <linkunlink+0xf8>
    wait(0);
    284a:	4501                	li	a0,0
    284c:	00002097          	auipc	ra,0x2
    2850:	bf8080e7          	jalr	-1032(ra) # 4444 <wait>
}
    2854:	60e6                	ld	ra,88(sp)
    2856:	6446                	ld	s0,80(sp)
    2858:	64a6                	ld	s1,72(sp)
    285a:	6906                	ld	s2,64(sp)
    285c:	79e2                	ld	s3,56(sp)
    285e:	7a42                	ld	s4,48(sp)
    2860:	7aa2                	ld	s5,40(sp)
    2862:	7b02                	ld	s6,32(sp)
    2864:	6be2                	ld	s7,24(sp)
    2866:	6c42                	ld	s8,16(sp)
    2868:	6ca2                	ld	s9,8(sp)
    286a:	6125                	addi	sp,sp,96
    286c:	8082                	ret
    exit(0);
    286e:	4501                	li	a0,0
    2870:	00002097          	auipc	ra,0x2
    2874:	bcc080e7          	jalr	-1076(ra) # 443c <exit>

0000000000002878 <bigdir>:
{
    2878:	715d                	addi	sp,sp,-80
    287a:	e486                	sd	ra,72(sp)
    287c:	e0a2                	sd	s0,64(sp)
    287e:	fc26                	sd	s1,56(sp)
    2880:	f84a                	sd	s2,48(sp)
    2882:	f44e                	sd	s3,40(sp)
    2884:	f052                	sd	s4,32(sp)
    2886:	ec56                	sd	s5,24(sp)
    2888:	e85a                	sd	s6,16(sp)
    288a:	0880                	addi	s0,sp,80
    288c:	89aa                	mv	s3,a0
  unlink("bd");
    288e:	00003517          	auipc	a0,0x3
    2892:	2b250513          	addi	a0,a0,690 # 5b40 <malloc+0x12c6>
    2896:	00002097          	auipc	ra,0x2
    289a:	bf6080e7          	jalr	-1034(ra) # 448c <unlink>
  fd = open("bd", O_CREATE);
    289e:	20000593          	li	a1,512
    28a2:	00003517          	auipc	a0,0x3
    28a6:	29e50513          	addi	a0,a0,670 # 5b40 <malloc+0x12c6>
    28aa:	00002097          	auipc	ra,0x2
    28ae:	bd2080e7          	jalr	-1070(ra) # 447c <open>
  if(fd < 0){
    28b2:	0c054963          	bltz	a0,2984 <bigdir+0x10c>
  close(fd);
    28b6:	00002097          	auipc	ra,0x2
    28ba:	bae080e7          	jalr	-1106(ra) # 4464 <close>
  for(i = 0; i < N; i++){
    28be:	4901                	li	s2,0
    name[0] = 'x';
    28c0:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
    28c4:	00003a17          	auipc	s4,0x3
    28c8:	27ca0a13          	addi	s4,s4,636 # 5b40 <malloc+0x12c6>
  for(i = 0; i < N; i++){
    28cc:	1f400b13          	li	s6,500
    name[0] = 'x';
    28d0:	fb540823          	sb	s5,-80(s0)
    name[1] = '0' + (i / 64);
    28d4:	41f9579b          	sraiw	a5,s2,0x1f
    28d8:	01a7d71b          	srliw	a4,a5,0x1a
    28dc:	012707bb          	addw	a5,a4,s2
    28e0:	4067d69b          	sraiw	a3,a5,0x6
    28e4:	0306869b          	addiw	a3,a3,48
    28e8:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    28ec:	03f7f793          	andi	a5,a5,63
    28f0:	9f99                	subw	a5,a5,a4
    28f2:	0307879b          	addiw	a5,a5,48
    28f6:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    28fa:	fa0409a3          	sb	zero,-77(s0)
    if(link("bd", name) != 0){
    28fe:	fb040593          	addi	a1,s0,-80
    2902:	8552                	mv	a0,s4
    2904:	00002097          	auipc	ra,0x2
    2908:	b98080e7          	jalr	-1128(ra) # 449c <link>
    290c:	84aa                	mv	s1,a0
    290e:	e949                	bnez	a0,29a0 <bigdir+0x128>
  for(i = 0; i < N; i++){
    2910:	2905                	addiw	s2,s2,1
    2912:	fb691fe3          	bne	s2,s6,28d0 <bigdir+0x58>
  unlink("bd");
    2916:	00003517          	auipc	a0,0x3
    291a:	22a50513          	addi	a0,a0,554 # 5b40 <malloc+0x12c6>
    291e:	00002097          	auipc	ra,0x2
    2922:	b6e080e7          	jalr	-1170(ra) # 448c <unlink>
    name[0] = 'x';
    2926:	07800913          	li	s2,120
  for(i = 0; i < N; i++){
    292a:	1f400a13          	li	s4,500
    name[0] = 'x';
    292e:	fb240823          	sb	s2,-80(s0)
    name[1] = '0' + (i / 64);
    2932:	41f4d79b          	sraiw	a5,s1,0x1f
    2936:	01a7d71b          	srliw	a4,a5,0x1a
    293a:	009707bb          	addw	a5,a4,s1
    293e:	4067d69b          	sraiw	a3,a5,0x6
    2942:	0306869b          	addiw	a3,a3,48
    2946:	fad408a3          	sb	a3,-79(s0)
    name[2] = '0' + (i % 64);
    294a:	03f7f793          	andi	a5,a5,63
    294e:	9f99                	subw	a5,a5,a4
    2950:	0307879b          	addiw	a5,a5,48
    2954:	faf40923          	sb	a5,-78(s0)
    name[3] = '\0';
    2958:	fa0409a3          	sb	zero,-77(s0)
    if(unlink(name) != 0){
    295c:	fb040513          	addi	a0,s0,-80
    2960:	00002097          	auipc	ra,0x2
    2964:	b2c080e7          	jalr	-1236(ra) # 448c <unlink>
    2968:	e931                	bnez	a0,29bc <bigdir+0x144>
  for(i = 0; i < N; i++){
    296a:	2485                	addiw	s1,s1,1
    296c:	fd4491e3          	bne	s1,s4,292e <bigdir+0xb6>
}
    2970:	60a6                	ld	ra,72(sp)
    2972:	6406                	ld	s0,64(sp)
    2974:	74e2                	ld	s1,56(sp)
    2976:	7942                	ld	s2,48(sp)
    2978:	79a2                	ld	s3,40(sp)
    297a:	7a02                	ld	s4,32(sp)
    297c:	6ae2                	ld	s5,24(sp)
    297e:	6b42                	ld	s6,16(sp)
    2980:	6161                	addi	sp,sp,80
    2982:	8082                	ret
    printf("%s: bigdir create failed\n", s);
    2984:	85ce                	mv	a1,s3
    2986:	00003517          	auipc	a0,0x3
    298a:	1c250513          	addi	a0,a0,450 # 5b48 <malloc+0x12ce>
    298e:	00002097          	auipc	ra,0x2
    2992:	e2e080e7          	jalr	-466(ra) # 47bc <printf>
    exit(1);
    2996:	4505                	li	a0,1
    2998:	00002097          	auipc	ra,0x2
    299c:	aa4080e7          	jalr	-1372(ra) # 443c <exit>
      printf("%s: bigdir link failed\n", s);
    29a0:	85ce                	mv	a1,s3
    29a2:	00003517          	auipc	a0,0x3
    29a6:	1c650513          	addi	a0,a0,454 # 5b68 <malloc+0x12ee>
    29aa:	00002097          	auipc	ra,0x2
    29ae:	e12080e7          	jalr	-494(ra) # 47bc <printf>
      exit(1);
    29b2:	4505                	li	a0,1
    29b4:	00002097          	auipc	ra,0x2
    29b8:	a88080e7          	jalr	-1400(ra) # 443c <exit>
      printf("%s: bigdir unlink failed", s);
    29bc:	85ce                	mv	a1,s3
    29be:	00003517          	auipc	a0,0x3
    29c2:	1c250513          	addi	a0,a0,450 # 5b80 <malloc+0x1306>
    29c6:	00002097          	auipc	ra,0x2
    29ca:	df6080e7          	jalr	-522(ra) # 47bc <printf>
      exit(1);
    29ce:	4505                	li	a0,1
    29d0:	00002097          	auipc	ra,0x2
    29d4:	a6c080e7          	jalr	-1428(ra) # 443c <exit>

00000000000029d8 <subdir>:
{
    29d8:	1101                	addi	sp,sp,-32
    29da:	ec06                	sd	ra,24(sp)
    29dc:	e822                	sd	s0,16(sp)
    29de:	e426                	sd	s1,8(sp)
    29e0:	e04a                	sd	s2,0(sp)
    29e2:	1000                	addi	s0,sp,32
    29e4:	892a                	mv	s2,a0
  unlink("ff");
    29e6:	00003517          	auipc	a0,0x3
    29ea:	2ea50513          	addi	a0,a0,746 # 5cd0 <malloc+0x1456>
    29ee:	00002097          	auipc	ra,0x2
    29f2:	a9e080e7          	jalr	-1378(ra) # 448c <unlink>
  if(mkdir("dd") != 0){
    29f6:	00003517          	auipc	a0,0x3
    29fa:	1aa50513          	addi	a0,a0,426 # 5ba0 <malloc+0x1326>
    29fe:	00002097          	auipc	ra,0x2
    2a02:	aa6080e7          	jalr	-1370(ra) # 44a4 <mkdir>
    2a06:	38051663          	bnez	a0,2d92 <subdir+0x3ba>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2a0a:	20200593          	li	a1,514
    2a0e:	00003517          	auipc	a0,0x3
    2a12:	1b250513          	addi	a0,a0,434 # 5bc0 <malloc+0x1346>
    2a16:	00002097          	auipc	ra,0x2
    2a1a:	a66080e7          	jalr	-1434(ra) # 447c <open>
    2a1e:	84aa                	mv	s1,a0
  if(fd < 0){
    2a20:	38054763          	bltz	a0,2dae <subdir+0x3d6>
  write(fd, "ff", 2);
    2a24:	4609                	li	a2,2
    2a26:	00003597          	auipc	a1,0x3
    2a2a:	2aa58593          	addi	a1,a1,682 # 5cd0 <malloc+0x1456>
    2a2e:	00002097          	auipc	ra,0x2
    2a32:	a2e080e7          	jalr	-1490(ra) # 445c <write>
  close(fd);
    2a36:	8526                	mv	a0,s1
    2a38:	00002097          	auipc	ra,0x2
    2a3c:	a2c080e7          	jalr	-1492(ra) # 4464 <close>
  if(unlink("dd") >= 0){
    2a40:	00003517          	auipc	a0,0x3
    2a44:	16050513          	addi	a0,a0,352 # 5ba0 <malloc+0x1326>
    2a48:	00002097          	auipc	ra,0x2
    2a4c:	a44080e7          	jalr	-1468(ra) # 448c <unlink>
    2a50:	36055d63          	bgez	a0,2dca <subdir+0x3f2>
  if(mkdir("/dd/dd") != 0){
    2a54:	00003517          	auipc	a0,0x3
    2a58:	1c450513          	addi	a0,a0,452 # 5c18 <malloc+0x139e>
    2a5c:	00002097          	auipc	ra,0x2
    2a60:	a48080e7          	jalr	-1464(ra) # 44a4 <mkdir>
    2a64:	38051163          	bnez	a0,2de6 <subdir+0x40e>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2a68:	20200593          	li	a1,514
    2a6c:	00003517          	auipc	a0,0x3
    2a70:	1d450513          	addi	a0,a0,468 # 5c40 <malloc+0x13c6>
    2a74:	00002097          	auipc	ra,0x2
    2a78:	a08080e7          	jalr	-1528(ra) # 447c <open>
    2a7c:	84aa                	mv	s1,a0
  if(fd < 0){
    2a7e:	38054263          	bltz	a0,2e02 <subdir+0x42a>
  write(fd, "FF", 2);
    2a82:	4609                	li	a2,2
    2a84:	00003597          	auipc	a1,0x3
    2a88:	1ec58593          	addi	a1,a1,492 # 5c70 <malloc+0x13f6>
    2a8c:	00002097          	auipc	ra,0x2
    2a90:	9d0080e7          	jalr	-1584(ra) # 445c <write>
  close(fd);
    2a94:	8526                	mv	a0,s1
    2a96:	00002097          	auipc	ra,0x2
    2a9a:	9ce080e7          	jalr	-1586(ra) # 4464 <close>
  fd = open("dd/dd/../ff", 0);
    2a9e:	4581                	li	a1,0
    2aa0:	00003517          	auipc	a0,0x3
    2aa4:	1d850513          	addi	a0,a0,472 # 5c78 <malloc+0x13fe>
    2aa8:	00002097          	auipc	ra,0x2
    2aac:	9d4080e7          	jalr	-1580(ra) # 447c <open>
    2ab0:	84aa                	mv	s1,a0
  if(fd < 0){
    2ab2:	36054663          	bltz	a0,2e1e <subdir+0x446>
  cc = read(fd, buf, sizeof(buf));
    2ab6:	660d                	lui	a2,0x3
    2ab8:	00006597          	auipc	a1,0x6
    2abc:	79858593          	addi	a1,a1,1944 # 9250 <buf>
    2ac0:	00002097          	auipc	ra,0x2
    2ac4:	994080e7          	jalr	-1644(ra) # 4454 <read>
  if(cc != 2 || buf[0] != 'f'){
    2ac8:	4789                	li	a5,2
    2aca:	36f51863          	bne	a0,a5,2e3a <subdir+0x462>
    2ace:	00006717          	auipc	a4,0x6
    2ad2:	78274703          	lbu	a4,1922(a4) # 9250 <buf>
    2ad6:	06600793          	li	a5,102
    2ada:	36f71063          	bne	a4,a5,2e3a <subdir+0x462>
  close(fd);
    2ade:	8526                	mv	a0,s1
    2ae0:	00002097          	auipc	ra,0x2
    2ae4:	984080e7          	jalr	-1660(ra) # 4464 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2ae8:	00003597          	auipc	a1,0x3
    2aec:	1e058593          	addi	a1,a1,480 # 5cc8 <malloc+0x144e>
    2af0:	00003517          	auipc	a0,0x3
    2af4:	15050513          	addi	a0,a0,336 # 5c40 <malloc+0x13c6>
    2af8:	00002097          	auipc	ra,0x2
    2afc:	9a4080e7          	jalr	-1628(ra) # 449c <link>
    2b00:	34051b63          	bnez	a0,2e56 <subdir+0x47e>
  if(unlink("dd/dd/ff") != 0){
    2b04:	00003517          	auipc	a0,0x3
    2b08:	13c50513          	addi	a0,a0,316 # 5c40 <malloc+0x13c6>
    2b0c:	00002097          	auipc	ra,0x2
    2b10:	980080e7          	jalr	-1664(ra) # 448c <unlink>
    2b14:	34051f63          	bnez	a0,2e72 <subdir+0x49a>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2b18:	4581                	li	a1,0
    2b1a:	00003517          	auipc	a0,0x3
    2b1e:	12650513          	addi	a0,a0,294 # 5c40 <malloc+0x13c6>
    2b22:	00002097          	auipc	ra,0x2
    2b26:	95a080e7          	jalr	-1702(ra) # 447c <open>
    2b2a:	36055263          	bgez	a0,2e8e <subdir+0x4b6>
  if(chdir("dd") != 0){
    2b2e:	00003517          	auipc	a0,0x3
    2b32:	07250513          	addi	a0,a0,114 # 5ba0 <malloc+0x1326>
    2b36:	00002097          	auipc	ra,0x2
    2b3a:	976080e7          	jalr	-1674(ra) # 44ac <chdir>
    2b3e:	36051663          	bnez	a0,2eaa <subdir+0x4d2>
  if(chdir("dd/../../dd") != 0){
    2b42:	00003517          	auipc	a0,0x3
    2b46:	21e50513          	addi	a0,a0,542 # 5d60 <malloc+0x14e6>
    2b4a:	00002097          	auipc	ra,0x2
    2b4e:	962080e7          	jalr	-1694(ra) # 44ac <chdir>
    2b52:	36051a63          	bnez	a0,2ec6 <subdir+0x4ee>
  if(chdir("dd/../../../dd") != 0){
    2b56:	00003517          	auipc	a0,0x3
    2b5a:	23a50513          	addi	a0,a0,570 # 5d90 <malloc+0x1516>
    2b5e:	00002097          	auipc	ra,0x2
    2b62:	94e080e7          	jalr	-1714(ra) # 44ac <chdir>
    2b66:	36051e63          	bnez	a0,2ee2 <subdir+0x50a>
  if(chdir("./..") != 0){
    2b6a:	00003517          	auipc	a0,0x3
    2b6e:	25650513          	addi	a0,a0,598 # 5dc0 <malloc+0x1546>
    2b72:	00002097          	auipc	ra,0x2
    2b76:	93a080e7          	jalr	-1734(ra) # 44ac <chdir>
    2b7a:	38051263          	bnez	a0,2efe <subdir+0x526>
  fd = open("dd/dd/ffff", 0);
    2b7e:	4581                	li	a1,0
    2b80:	00003517          	auipc	a0,0x3
    2b84:	14850513          	addi	a0,a0,328 # 5cc8 <malloc+0x144e>
    2b88:	00002097          	auipc	ra,0x2
    2b8c:	8f4080e7          	jalr	-1804(ra) # 447c <open>
    2b90:	84aa                	mv	s1,a0
  if(fd < 0){
    2b92:	38054463          	bltz	a0,2f1a <subdir+0x542>
  if(read(fd, buf, sizeof(buf)) != 2){
    2b96:	660d                	lui	a2,0x3
    2b98:	00006597          	auipc	a1,0x6
    2b9c:	6b858593          	addi	a1,a1,1720 # 9250 <buf>
    2ba0:	00002097          	auipc	ra,0x2
    2ba4:	8b4080e7          	jalr	-1868(ra) # 4454 <read>
    2ba8:	4789                	li	a5,2
    2baa:	38f51663          	bne	a0,a5,2f36 <subdir+0x55e>
  close(fd);
    2bae:	8526                	mv	a0,s1
    2bb0:	00002097          	auipc	ra,0x2
    2bb4:	8b4080e7          	jalr	-1868(ra) # 4464 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2bb8:	4581                	li	a1,0
    2bba:	00003517          	auipc	a0,0x3
    2bbe:	08650513          	addi	a0,a0,134 # 5c40 <malloc+0x13c6>
    2bc2:	00002097          	auipc	ra,0x2
    2bc6:	8ba080e7          	jalr	-1862(ra) # 447c <open>
    2bca:	38055463          	bgez	a0,2f52 <subdir+0x57a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2bce:	20200593          	li	a1,514
    2bd2:	00003517          	auipc	a0,0x3
    2bd6:	27e50513          	addi	a0,a0,638 # 5e50 <malloc+0x15d6>
    2bda:	00002097          	auipc	ra,0x2
    2bde:	8a2080e7          	jalr	-1886(ra) # 447c <open>
    2be2:	38055663          	bgez	a0,2f6e <subdir+0x596>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2be6:	20200593          	li	a1,514
    2bea:	00003517          	auipc	a0,0x3
    2bee:	29650513          	addi	a0,a0,662 # 5e80 <malloc+0x1606>
    2bf2:	00002097          	auipc	ra,0x2
    2bf6:	88a080e7          	jalr	-1910(ra) # 447c <open>
    2bfa:	38055863          	bgez	a0,2f8a <subdir+0x5b2>
  if(open("dd", O_CREATE) >= 0){
    2bfe:	20000593          	li	a1,512
    2c02:	00003517          	auipc	a0,0x3
    2c06:	f9e50513          	addi	a0,a0,-98 # 5ba0 <malloc+0x1326>
    2c0a:	00002097          	auipc	ra,0x2
    2c0e:	872080e7          	jalr	-1934(ra) # 447c <open>
    2c12:	38055a63          	bgez	a0,2fa6 <subdir+0x5ce>
  if(open("dd", O_RDWR) >= 0){
    2c16:	4589                	li	a1,2
    2c18:	00003517          	auipc	a0,0x3
    2c1c:	f8850513          	addi	a0,a0,-120 # 5ba0 <malloc+0x1326>
    2c20:	00002097          	auipc	ra,0x2
    2c24:	85c080e7          	jalr	-1956(ra) # 447c <open>
    2c28:	38055d63          	bgez	a0,2fc2 <subdir+0x5ea>
  if(open("dd", O_WRONLY) >= 0){
    2c2c:	4585                	li	a1,1
    2c2e:	00003517          	auipc	a0,0x3
    2c32:	f7250513          	addi	a0,a0,-142 # 5ba0 <malloc+0x1326>
    2c36:	00002097          	auipc	ra,0x2
    2c3a:	846080e7          	jalr	-1978(ra) # 447c <open>
    2c3e:	3a055063          	bgez	a0,2fde <subdir+0x606>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2c42:	00003597          	auipc	a1,0x3
    2c46:	2ce58593          	addi	a1,a1,718 # 5f10 <malloc+0x1696>
    2c4a:	00003517          	auipc	a0,0x3
    2c4e:	20650513          	addi	a0,a0,518 # 5e50 <malloc+0x15d6>
    2c52:	00002097          	auipc	ra,0x2
    2c56:	84a080e7          	jalr	-1974(ra) # 449c <link>
    2c5a:	3a050063          	beqz	a0,2ffa <subdir+0x622>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2c5e:	00003597          	auipc	a1,0x3
    2c62:	2b258593          	addi	a1,a1,690 # 5f10 <malloc+0x1696>
    2c66:	00003517          	auipc	a0,0x3
    2c6a:	21a50513          	addi	a0,a0,538 # 5e80 <malloc+0x1606>
    2c6e:	00002097          	auipc	ra,0x2
    2c72:	82e080e7          	jalr	-2002(ra) # 449c <link>
    2c76:	3a050063          	beqz	a0,3016 <subdir+0x63e>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2c7a:	00003597          	auipc	a1,0x3
    2c7e:	04e58593          	addi	a1,a1,78 # 5cc8 <malloc+0x144e>
    2c82:	00003517          	auipc	a0,0x3
    2c86:	f3e50513          	addi	a0,a0,-194 # 5bc0 <malloc+0x1346>
    2c8a:	00002097          	auipc	ra,0x2
    2c8e:	812080e7          	jalr	-2030(ra) # 449c <link>
    2c92:	3a050063          	beqz	a0,3032 <subdir+0x65a>
  if(mkdir("dd/ff/ff") == 0){
    2c96:	00003517          	auipc	a0,0x3
    2c9a:	1ba50513          	addi	a0,a0,442 # 5e50 <malloc+0x15d6>
    2c9e:	00002097          	auipc	ra,0x2
    2ca2:	806080e7          	jalr	-2042(ra) # 44a4 <mkdir>
    2ca6:	3a050463          	beqz	a0,304e <subdir+0x676>
  if(mkdir("dd/xx/ff") == 0){
    2caa:	00003517          	auipc	a0,0x3
    2cae:	1d650513          	addi	a0,a0,470 # 5e80 <malloc+0x1606>
    2cb2:	00001097          	auipc	ra,0x1
    2cb6:	7f2080e7          	jalr	2034(ra) # 44a4 <mkdir>
    2cba:	3a050863          	beqz	a0,306a <subdir+0x692>
  if(mkdir("dd/dd/ffff") == 0){
    2cbe:	00003517          	auipc	a0,0x3
    2cc2:	00a50513          	addi	a0,a0,10 # 5cc8 <malloc+0x144e>
    2cc6:	00001097          	auipc	ra,0x1
    2cca:	7de080e7          	jalr	2014(ra) # 44a4 <mkdir>
    2cce:	3a050c63          	beqz	a0,3086 <subdir+0x6ae>
  if(unlink("dd/xx/ff") == 0){
    2cd2:	00003517          	auipc	a0,0x3
    2cd6:	1ae50513          	addi	a0,a0,430 # 5e80 <malloc+0x1606>
    2cda:	00001097          	auipc	ra,0x1
    2cde:	7b2080e7          	jalr	1970(ra) # 448c <unlink>
    2ce2:	3c050063          	beqz	a0,30a2 <subdir+0x6ca>
  if(unlink("dd/ff/ff") == 0){
    2ce6:	00003517          	auipc	a0,0x3
    2cea:	16a50513          	addi	a0,a0,362 # 5e50 <malloc+0x15d6>
    2cee:	00001097          	auipc	ra,0x1
    2cf2:	79e080e7          	jalr	1950(ra) # 448c <unlink>
    2cf6:	3c050463          	beqz	a0,30be <subdir+0x6e6>
  if(chdir("dd/ff") == 0){
    2cfa:	00003517          	auipc	a0,0x3
    2cfe:	ec650513          	addi	a0,a0,-314 # 5bc0 <malloc+0x1346>
    2d02:	00001097          	auipc	ra,0x1
    2d06:	7aa080e7          	jalr	1962(ra) # 44ac <chdir>
    2d0a:	3c050863          	beqz	a0,30da <subdir+0x702>
  if(chdir("dd/xx") == 0){
    2d0e:	00003517          	auipc	a0,0x3
    2d12:	35250513          	addi	a0,a0,850 # 6060 <malloc+0x17e6>
    2d16:	00001097          	auipc	ra,0x1
    2d1a:	796080e7          	jalr	1942(ra) # 44ac <chdir>
    2d1e:	3c050c63          	beqz	a0,30f6 <subdir+0x71e>
  if(unlink("dd/dd/ffff") != 0){
    2d22:	00003517          	auipc	a0,0x3
    2d26:	fa650513          	addi	a0,a0,-90 # 5cc8 <malloc+0x144e>
    2d2a:	00001097          	auipc	ra,0x1
    2d2e:	762080e7          	jalr	1890(ra) # 448c <unlink>
    2d32:	3e051063          	bnez	a0,3112 <subdir+0x73a>
  if(unlink("dd/ff") != 0){
    2d36:	00003517          	auipc	a0,0x3
    2d3a:	e8a50513          	addi	a0,a0,-374 # 5bc0 <malloc+0x1346>
    2d3e:	00001097          	auipc	ra,0x1
    2d42:	74e080e7          	jalr	1870(ra) # 448c <unlink>
    2d46:	3e051463          	bnez	a0,312e <subdir+0x756>
  if(unlink("dd") == 0){
    2d4a:	00003517          	auipc	a0,0x3
    2d4e:	e5650513          	addi	a0,a0,-426 # 5ba0 <malloc+0x1326>
    2d52:	00001097          	auipc	ra,0x1
    2d56:	73a080e7          	jalr	1850(ra) # 448c <unlink>
    2d5a:	3e050863          	beqz	a0,314a <subdir+0x772>
  if(unlink("dd/dd") < 0){
    2d5e:	00003517          	auipc	a0,0x3
    2d62:	37250513          	addi	a0,a0,882 # 60d0 <malloc+0x1856>
    2d66:	00001097          	auipc	ra,0x1
    2d6a:	726080e7          	jalr	1830(ra) # 448c <unlink>
    2d6e:	3e054c63          	bltz	a0,3166 <subdir+0x78e>
  if(unlink("dd") < 0){
    2d72:	00003517          	auipc	a0,0x3
    2d76:	e2e50513          	addi	a0,a0,-466 # 5ba0 <malloc+0x1326>
    2d7a:	00001097          	auipc	ra,0x1
    2d7e:	712080e7          	jalr	1810(ra) # 448c <unlink>
    2d82:	40054063          	bltz	a0,3182 <subdir+0x7aa>
}
    2d86:	60e2                	ld	ra,24(sp)
    2d88:	6442                	ld	s0,16(sp)
    2d8a:	64a2                	ld	s1,8(sp)
    2d8c:	6902                	ld	s2,0(sp)
    2d8e:	6105                	addi	sp,sp,32
    2d90:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2d92:	85ca                	mv	a1,s2
    2d94:	00003517          	auipc	a0,0x3
    2d98:	e1450513          	addi	a0,a0,-492 # 5ba8 <malloc+0x132e>
    2d9c:	00002097          	auipc	ra,0x2
    2da0:	a20080e7          	jalr	-1504(ra) # 47bc <printf>
    exit(1);
    2da4:	4505                	li	a0,1
    2da6:	00001097          	auipc	ra,0x1
    2daa:	696080e7          	jalr	1686(ra) # 443c <exit>
    printf("%s: create dd/ff failed\n", s);
    2dae:	85ca                	mv	a1,s2
    2db0:	00003517          	auipc	a0,0x3
    2db4:	e1850513          	addi	a0,a0,-488 # 5bc8 <malloc+0x134e>
    2db8:	00002097          	auipc	ra,0x2
    2dbc:	a04080e7          	jalr	-1532(ra) # 47bc <printf>
    exit(1);
    2dc0:	4505                	li	a0,1
    2dc2:	00001097          	auipc	ra,0x1
    2dc6:	67a080e7          	jalr	1658(ra) # 443c <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2dca:	85ca                	mv	a1,s2
    2dcc:	00003517          	auipc	a0,0x3
    2dd0:	e1c50513          	addi	a0,a0,-484 # 5be8 <malloc+0x136e>
    2dd4:	00002097          	auipc	ra,0x2
    2dd8:	9e8080e7          	jalr	-1560(ra) # 47bc <printf>
    exit(1);
    2ddc:	4505                	li	a0,1
    2dde:	00001097          	auipc	ra,0x1
    2de2:	65e080e7          	jalr	1630(ra) # 443c <exit>
    printf("subdir mkdir dd/dd failed\n", s);
    2de6:	85ca                	mv	a1,s2
    2de8:	00003517          	auipc	a0,0x3
    2dec:	e3850513          	addi	a0,a0,-456 # 5c20 <malloc+0x13a6>
    2df0:	00002097          	auipc	ra,0x2
    2df4:	9cc080e7          	jalr	-1588(ra) # 47bc <printf>
    exit(1);
    2df8:	4505                	li	a0,1
    2dfa:	00001097          	auipc	ra,0x1
    2dfe:	642080e7          	jalr	1602(ra) # 443c <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2e02:	85ca                	mv	a1,s2
    2e04:	00003517          	auipc	a0,0x3
    2e08:	e4c50513          	addi	a0,a0,-436 # 5c50 <malloc+0x13d6>
    2e0c:	00002097          	auipc	ra,0x2
    2e10:	9b0080e7          	jalr	-1616(ra) # 47bc <printf>
    exit(1);
    2e14:	4505                	li	a0,1
    2e16:	00001097          	auipc	ra,0x1
    2e1a:	626080e7          	jalr	1574(ra) # 443c <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2e1e:	85ca                	mv	a1,s2
    2e20:	00003517          	auipc	a0,0x3
    2e24:	e6850513          	addi	a0,a0,-408 # 5c88 <malloc+0x140e>
    2e28:	00002097          	auipc	ra,0x2
    2e2c:	994080e7          	jalr	-1644(ra) # 47bc <printf>
    exit(1);
    2e30:	4505                	li	a0,1
    2e32:	00001097          	auipc	ra,0x1
    2e36:	60a080e7          	jalr	1546(ra) # 443c <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2e3a:	85ca                	mv	a1,s2
    2e3c:	00003517          	auipc	a0,0x3
    2e40:	e6c50513          	addi	a0,a0,-404 # 5ca8 <malloc+0x142e>
    2e44:	00002097          	auipc	ra,0x2
    2e48:	978080e7          	jalr	-1672(ra) # 47bc <printf>
    exit(1);
    2e4c:	4505                	li	a0,1
    2e4e:	00001097          	auipc	ra,0x1
    2e52:	5ee080e7          	jalr	1518(ra) # 443c <exit>
    printf("link dd/dd/ff dd/dd/ffff failed\n", s);
    2e56:	85ca                	mv	a1,s2
    2e58:	00003517          	auipc	a0,0x3
    2e5c:	e8050513          	addi	a0,a0,-384 # 5cd8 <malloc+0x145e>
    2e60:	00002097          	auipc	ra,0x2
    2e64:	95c080e7          	jalr	-1700(ra) # 47bc <printf>
    exit(1);
    2e68:	4505                	li	a0,1
    2e6a:	00001097          	auipc	ra,0x1
    2e6e:	5d2080e7          	jalr	1490(ra) # 443c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2e72:	85ca                	mv	a1,s2
    2e74:	00003517          	auipc	a0,0x3
    2e78:	e8c50513          	addi	a0,a0,-372 # 5d00 <malloc+0x1486>
    2e7c:	00002097          	auipc	ra,0x2
    2e80:	940080e7          	jalr	-1728(ra) # 47bc <printf>
    exit(1);
    2e84:	4505                	li	a0,1
    2e86:	00001097          	auipc	ra,0x1
    2e8a:	5b6080e7          	jalr	1462(ra) # 443c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2e8e:	85ca                	mv	a1,s2
    2e90:	00003517          	auipc	a0,0x3
    2e94:	e9050513          	addi	a0,a0,-368 # 5d20 <malloc+0x14a6>
    2e98:	00002097          	auipc	ra,0x2
    2e9c:	924080e7          	jalr	-1756(ra) # 47bc <printf>
    exit(1);
    2ea0:	4505                	li	a0,1
    2ea2:	00001097          	auipc	ra,0x1
    2ea6:	59a080e7          	jalr	1434(ra) # 443c <exit>
    printf("%s: chdir dd failed\n", s);
    2eaa:	85ca                	mv	a1,s2
    2eac:	00003517          	auipc	a0,0x3
    2eb0:	e9c50513          	addi	a0,a0,-356 # 5d48 <malloc+0x14ce>
    2eb4:	00002097          	auipc	ra,0x2
    2eb8:	908080e7          	jalr	-1784(ra) # 47bc <printf>
    exit(1);
    2ebc:	4505                	li	a0,1
    2ebe:	00001097          	auipc	ra,0x1
    2ec2:	57e080e7          	jalr	1406(ra) # 443c <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2ec6:	85ca                	mv	a1,s2
    2ec8:	00003517          	auipc	a0,0x3
    2ecc:	ea850513          	addi	a0,a0,-344 # 5d70 <malloc+0x14f6>
    2ed0:	00002097          	auipc	ra,0x2
    2ed4:	8ec080e7          	jalr	-1812(ra) # 47bc <printf>
    exit(1);
    2ed8:	4505                	li	a0,1
    2eda:	00001097          	auipc	ra,0x1
    2ede:	562080e7          	jalr	1378(ra) # 443c <exit>
    printf("chdir dd/../../dd failed\n", s);
    2ee2:	85ca                	mv	a1,s2
    2ee4:	00003517          	auipc	a0,0x3
    2ee8:	ebc50513          	addi	a0,a0,-324 # 5da0 <malloc+0x1526>
    2eec:	00002097          	auipc	ra,0x2
    2ef0:	8d0080e7          	jalr	-1840(ra) # 47bc <printf>
    exit(1);
    2ef4:	4505                	li	a0,1
    2ef6:	00001097          	auipc	ra,0x1
    2efa:	546080e7          	jalr	1350(ra) # 443c <exit>
    printf("%s: chdir ./.. failed\n", s);
    2efe:	85ca                	mv	a1,s2
    2f00:	00003517          	auipc	a0,0x3
    2f04:	ec850513          	addi	a0,a0,-312 # 5dc8 <malloc+0x154e>
    2f08:	00002097          	auipc	ra,0x2
    2f0c:	8b4080e7          	jalr	-1868(ra) # 47bc <printf>
    exit(1);
    2f10:	4505                	li	a0,1
    2f12:	00001097          	auipc	ra,0x1
    2f16:	52a080e7          	jalr	1322(ra) # 443c <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2f1a:	85ca                	mv	a1,s2
    2f1c:	00003517          	auipc	a0,0x3
    2f20:	ec450513          	addi	a0,a0,-316 # 5de0 <malloc+0x1566>
    2f24:	00002097          	auipc	ra,0x2
    2f28:	898080e7          	jalr	-1896(ra) # 47bc <printf>
    exit(1);
    2f2c:	4505                	li	a0,1
    2f2e:	00001097          	auipc	ra,0x1
    2f32:	50e080e7          	jalr	1294(ra) # 443c <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2f36:	85ca                	mv	a1,s2
    2f38:	00003517          	auipc	a0,0x3
    2f3c:	ec850513          	addi	a0,a0,-312 # 5e00 <malloc+0x1586>
    2f40:	00002097          	auipc	ra,0x2
    2f44:	87c080e7          	jalr	-1924(ra) # 47bc <printf>
    exit(1);
    2f48:	4505                	li	a0,1
    2f4a:	00001097          	auipc	ra,0x1
    2f4e:	4f2080e7          	jalr	1266(ra) # 443c <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2f52:	85ca                	mv	a1,s2
    2f54:	00003517          	auipc	a0,0x3
    2f58:	ecc50513          	addi	a0,a0,-308 # 5e20 <malloc+0x15a6>
    2f5c:	00002097          	auipc	ra,0x2
    2f60:	860080e7          	jalr	-1952(ra) # 47bc <printf>
    exit(1);
    2f64:	4505                	li	a0,1
    2f66:	00001097          	auipc	ra,0x1
    2f6a:	4d6080e7          	jalr	1238(ra) # 443c <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2f6e:	85ca                	mv	a1,s2
    2f70:	00003517          	auipc	a0,0x3
    2f74:	ef050513          	addi	a0,a0,-272 # 5e60 <malloc+0x15e6>
    2f78:	00002097          	auipc	ra,0x2
    2f7c:	844080e7          	jalr	-1980(ra) # 47bc <printf>
    exit(1);
    2f80:	4505                	li	a0,1
    2f82:	00001097          	auipc	ra,0x1
    2f86:	4ba080e7          	jalr	1210(ra) # 443c <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2f8a:	85ca                	mv	a1,s2
    2f8c:	00003517          	auipc	a0,0x3
    2f90:	f0450513          	addi	a0,a0,-252 # 5e90 <malloc+0x1616>
    2f94:	00002097          	auipc	ra,0x2
    2f98:	828080e7          	jalr	-2008(ra) # 47bc <printf>
    exit(1);
    2f9c:	4505                	li	a0,1
    2f9e:	00001097          	auipc	ra,0x1
    2fa2:	49e080e7          	jalr	1182(ra) # 443c <exit>
    printf("%s: create dd succeeded!\n", s);
    2fa6:	85ca                	mv	a1,s2
    2fa8:	00003517          	auipc	a0,0x3
    2fac:	f0850513          	addi	a0,a0,-248 # 5eb0 <malloc+0x1636>
    2fb0:	00002097          	auipc	ra,0x2
    2fb4:	80c080e7          	jalr	-2036(ra) # 47bc <printf>
    exit(1);
    2fb8:	4505                	li	a0,1
    2fba:	00001097          	auipc	ra,0x1
    2fbe:	482080e7          	jalr	1154(ra) # 443c <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    2fc2:	85ca                	mv	a1,s2
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	f0c50513          	addi	a0,a0,-244 # 5ed0 <malloc+0x1656>
    2fcc:	00001097          	auipc	ra,0x1
    2fd0:	7f0080e7          	jalr	2032(ra) # 47bc <printf>
    exit(1);
    2fd4:	4505                	li	a0,1
    2fd6:	00001097          	auipc	ra,0x1
    2fda:	466080e7          	jalr	1126(ra) # 443c <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    2fde:	85ca                	mv	a1,s2
    2fe0:	00003517          	auipc	a0,0x3
    2fe4:	f1050513          	addi	a0,a0,-240 # 5ef0 <malloc+0x1676>
    2fe8:	00001097          	auipc	ra,0x1
    2fec:	7d4080e7          	jalr	2004(ra) # 47bc <printf>
    exit(1);
    2ff0:	4505                	li	a0,1
    2ff2:	00001097          	auipc	ra,0x1
    2ff6:	44a080e7          	jalr	1098(ra) # 443c <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    2ffa:	85ca                	mv	a1,s2
    2ffc:	00003517          	auipc	a0,0x3
    3000:	f2450513          	addi	a0,a0,-220 # 5f20 <malloc+0x16a6>
    3004:	00001097          	auipc	ra,0x1
    3008:	7b8080e7          	jalr	1976(ra) # 47bc <printf>
    exit(1);
    300c:	4505                	li	a0,1
    300e:	00001097          	auipc	ra,0x1
    3012:	42e080e7          	jalr	1070(ra) # 443c <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    3016:	85ca                	mv	a1,s2
    3018:	00003517          	auipc	a0,0x3
    301c:	f3050513          	addi	a0,a0,-208 # 5f48 <malloc+0x16ce>
    3020:	00001097          	auipc	ra,0x1
    3024:	79c080e7          	jalr	1948(ra) # 47bc <printf>
    exit(1);
    3028:	4505                	li	a0,1
    302a:	00001097          	auipc	ra,0x1
    302e:	412080e7          	jalr	1042(ra) # 443c <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3032:	85ca                	mv	a1,s2
    3034:	00003517          	auipc	a0,0x3
    3038:	f3c50513          	addi	a0,a0,-196 # 5f70 <malloc+0x16f6>
    303c:	00001097          	auipc	ra,0x1
    3040:	780080e7          	jalr	1920(ra) # 47bc <printf>
    exit(1);
    3044:	4505                	li	a0,1
    3046:	00001097          	auipc	ra,0x1
    304a:	3f6080e7          	jalr	1014(ra) # 443c <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    304e:	85ca                	mv	a1,s2
    3050:	00003517          	auipc	a0,0x3
    3054:	f4850513          	addi	a0,a0,-184 # 5f98 <malloc+0x171e>
    3058:	00001097          	auipc	ra,0x1
    305c:	764080e7          	jalr	1892(ra) # 47bc <printf>
    exit(1);
    3060:	4505                	li	a0,1
    3062:	00001097          	auipc	ra,0x1
    3066:	3da080e7          	jalr	986(ra) # 443c <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    306a:	85ca                	mv	a1,s2
    306c:	00003517          	auipc	a0,0x3
    3070:	f4c50513          	addi	a0,a0,-180 # 5fb8 <malloc+0x173e>
    3074:	00001097          	auipc	ra,0x1
    3078:	748080e7          	jalr	1864(ra) # 47bc <printf>
    exit(1);
    307c:	4505                	li	a0,1
    307e:	00001097          	auipc	ra,0x1
    3082:	3be080e7          	jalr	958(ra) # 443c <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    3086:	85ca                	mv	a1,s2
    3088:	00003517          	auipc	a0,0x3
    308c:	f5050513          	addi	a0,a0,-176 # 5fd8 <malloc+0x175e>
    3090:	00001097          	auipc	ra,0x1
    3094:	72c080e7          	jalr	1836(ra) # 47bc <printf>
    exit(1);
    3098:	4505                	li	a0,1
    309a:	00001097          	auipc	ra,0x1
    309e:	3a2080e7          	jalr	930(ra) # 443c <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30a2:	85ca                	mv	a1,s2
    30a4:	00003517          	auipc	a0,0x3
    30a8:	f5c50513          	addi	a0,a0,-164 # 6000 <malloc+0x1786>
    30ac:	00001097          	auipc	ra,0x1
    30b0:	710080e7          	jalr	1808(ra) # 47bc <printf>
    exit(1);
    30b4:	4505                	li	a0,1
    30b6:	00001097          	auipc	ra,0x1
    30ba:	386080e7          	jalr	902(ra) # 443c <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30be:	85ca                	mv	a1,s2
    30c0:	00003517          	auipc	a0,0x3
    30c4:	f6050513          	addi	a0,a0,-160 # 6020 <malloc+0x17a6>
    30c8:	00001097          	auipc	ra,0x1
    30cc:	6f4080e7          	jalr	1780(ra) # 47bc <printf>
    exit(1);
    30d0:	4505                	li	a0,1
    30d2:	00001097          	auipc	ra,0x1
    30d6:	36a080e7          	jalr	874(ra) # 443c <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30da:	85ca                	mv	a1,s2
    30dc:	00003517          	auipc	a0,0x3
    30e0:	f6450513          	addi	a0,a0,-156 # 6040 <malloc+0x17c6>
    30e4:	00001097          	auipc	ra,0x1
    30e8:	6d8080e7          	jalr	1752(ra) # 47bc <printf>
    exit(1);
    30ec:	4505                	li	a0,1
    30ee:	00001097          	auipc	ra,0x1
    30f2:	34e080e7          	jalr	846(ra) # 443c <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30f6:	85ca                	mv	a1,s2
    30f8:	00003517          	auipc	a0,0x3
    30fc:	f7050513          	addi	a0,a0,-144 # 6068 <malloc+0x17ee>
    3100:	00001097          	auipc	ra,0x1
    3104:	6bc080e7          	jalr	1724(ra) # 47bc <printf>
    exit(1);
    3108:	4505                	li	a0,1
    310a:	00001097          	auipc	ra,0x1
    310e:	332080e7          	jalr	818(ra) # 443c <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3112:	85ca                	mv	a1,s2
    3114:	00003517          	auipc	a0,0x3
    3118:	bec50513          	addi	a0,a0,-1044 # 5d00 <malloc+0x1486>
    311c:	00001097          	auipc	ra,0x1
    3120:	6a0080e7          	jalr	1696(ra) # 47bc <printf>
    exit(1);
    3124:	4505                	li	a0,1
    3126:	00001097          	auipc	ra,0x1
    312a:	316080e7          	jalr	790(ra) # 443c <exit>
    printf("%s: unlink dd/ff failed\n", s);
    312e:	85ca                	mv	a1,s2
    3130:	00003517          	auipc	a0,0x3
    3134:	f5850513          	addi	a0,a0,-168 # 6088 <malloc+0x180e>
    3138:	00001097          	auipc	ra,0x1
    313c:	684080e7          	jalr	1668(ra) # 47bc <printf>
    exit(1);
    3140:	4505                	li	a0,1
    3142:	00001097          	auipc	ra,0x1
    3146:	2fa080e7          	jalr	762(ra) # 443c <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    314a:	85ca                	mv	a1,s2
    314c:	00003517          	auipc	a0,0x3
    3150:	f5c50513          	addi	a0,a0,-164 # 60a8 <malloc+0x182e>
    3154:	00001097          	auipc	ra,0x1
    3158:	668080e7          	jalr	1640(ra) # 47bc <printf>
    exit(1);
    315c:	4505                	li	a0,1
    315e:	00001097          	auipc	ra,0x1
    3162:	2de080e7          	jalr	734(ra) # 443c <exit>
    printf("%s: unlink dd/dd failed\n", s);
    3166:	85ca                	mv	a1,s2
    3168:	00003517          	auipc	a0,0x3
    316c:	f7050513          	addi	a0,a0,-144 # 60d8 <malloc+0x185e>
    3170:	00001097          	auipc	ra,0x1
    3174:	64c080e7          	jalr	1612(ra) # 47bc <printf>
    exit(1);
    3178:	4505                	li	a0,1
    317a:	00001097          	auipc	ra,0x1
    317e:	2c2080e7          	jalr	706(ra) # 443c <exit>
    printf("%s: unlink dd failed\n", s);
    3182:	85ca                	mv	a1,s2
    3184:	00003517          	auipc	a0,0x3
    3188:	f7450513          	addi	a0,a0,-140 # 60f8 <malloc+0x187e>
    318c:	00001097          	auipc	ra,0x1
    3190:	630080e7          	jalr	1584(ra) # 47bc <printf>
    exit(1);
    3194:	4505                	li	a0,1
    3196:	00001097          	auipc	ra,0x1
    319a:	2a6080e7          	jalr	678(ra) # 443c <exit>

000000000000319e <dirfile>:
{
    319e:	1101                	addi	sp,sp,-32
    31a0:	ec06                	sd	ra,24(sp)
    31a2:	e822                	sd	s0,16(sp)
    31a4:	e426                	sd	s1,8(sp)
    31a6:	e04a                	sd	s2,0(sp)
    31a8:	1000                	addi	s0,sp,32
    31aa:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    31ac:	20000593          	li	a1,512
    31b0:	00002517          	auipc	a0,0x2
    31b4:	a1050513          	addi	a0,a0,-1520 # 4bc0 <malloc+0x346>
    31b8:	00001097          	auipc	ra,0x1
    31bc:	2c4080e7          	jalr	708(ra) # 447c <open>
  if(fd < 0){
    31c0:	0e054d63          	bltz	a0,32ba <dirfile+0x11c>
  close(fd);
    31c4:	00001097          	auipc	ra,0x1
    31c8:	2a0080e7          	jalr	672(ra) # 4464 <close>
  if(chdir("dirfile") == 0){
    31cc:	00002517          	auipc	a0,0x2
    31d0:	9f450513          	addi	a0,a0,-1548 # 4bc0 <malloc+0x346>
    31d4:	00001097          	auipc	ra,0x1
    31d8:	2d8080e7          	jalr	728(ra) # 44ac <chdir>
    31dc:	cd6d                	beqz	a0,32d6 <dirfile+0x138>
  fd = open("dirfile/xx", 0);
    31de:	4581                	li	a1,0
    31e0:	00003517          	auipc	a0,0x3
    31e4:	f7050513          	addi	a0,a0,-144 # 6150 <malloc+0x18d6>
    31e8:	00001097          	auipc	ra,0x1
    31ec:	294080e7          	jalr	660(ra) # 447c <open>
  if(fd >= 0){
    31f0:	10055163          	bgez	a0,32f2 <dirfile+0x154>
  fd = open("dirfile/xx", O_CREATE);
    31f4:	20000593          	li	a1,512
    31f8:	00003517          	auipc	a0,0x3
    31fc:	f5850513          	addi	a0,a0,-168 # 6150 <malloc+0x18d6>
    3200:	00001097          	auipc	ra,0x1
    3204:	27c080e7          	jalr	636(ra) # 447c <open>
  if(fd >= 0){
    3208:	10055363          	bgez	a0,330e <dirfile+0x170>
  if(mkdir("dirfile/xx") == 0){
    320c:	00003517          	auipc	a0,0x3
    3210:	f4450513          	addi	a0,a0,-188 # 6150 <malloc+0x18d6>
    3214:	00001097          	auipc	ra,0x1
    3218:	290080e7          	jalr	656(ra) # 44a4 <mkdir>
    321c:	10050763          	beqz	a0,332a <dirfile+0x18c>
  if(unlink("dirfile/xx") == 0){
    3220:	00003517          	auipc	a0,0x3
    3224:	f3050513          	addi	a0,a0,-208 # 6150 <malloc+0x18d6>
    3228:	00001097          	auipc	ra,0x1
    322c:	264080e7          	jalr	612(ra) # 448c <unlink>
    3230:	10050b63          	beqz	a0,3346 <dirfile+0x1a8>
  if(link("README", "dirfile/xx") == 0){
    3234:	00003597          	auipc	a1,0x3
    3238:	f1c58593          	addi	a1,a1,-228 # 6150 <malloc+0x18d6>
    323c:	00003517          	auipc	a0,0x3
    3240:	f9c50513          	addi	a0,a0,-100 # 61d8 <malloc+0x195e>
    3244:	00001097          	auipc	ra,0x1
    3248:	258080e7          	jalr	600(ra) # 449c <link>
    324c:	10050b63          	beqz	a0,3362 <dirfile+0x1c4>
  if(unlink("dirfile") != 0){
    3250:	00002517          	auipc	a0,0x2
    3254:	97050513          	addi	a0,a0,-1680 # 4bc0 <malloc+0x346>
    3258:	00001097          	auipc	ra,0x1
    325c:	234080e7          	jalr	564(ra) # 448c <unlink>
    3260:	10051f63          	bnez	a0,337e <dirfile+0x1e0>
  fd = open(".", O_RDWR);
    3264:	4589                	li	a1,2
    3266:	00002517          	auipc	a0,0x2
    326a:	a6250513          	addi	a0,a0,-1438 # 4cc8 <malloc+0x44e>
    326e:	00001097          	auipc	ra,0x1
    3272:	20e080e7          	jalr	526(ra) # 447c <open>
  if(fd >= 0){
    3276:	12055263          	bgez	a0,339a <dirfile+0x1fc>
  fd = open(".", 0);
    327a:	4581                	li	a1,0
    327c:	00002517          	auipc	a0,0x2
    3280:	a4c50513          	addi	a0,a0,-1460 # 4cc8 <malloc+0x44e>
    3284:	00001097          	auipc	ra,0x1
    3288:	1f8080e7          	jalr	504(ra) # 447c <open>
    328c:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    328e:	4605                	li	a2,1
    3290:	00002597          	auipc	a1,0x2
    3294:	49858593          	addi	a1,a1,1176 # 5728 <malloc+0xeae>
    3298:	00001097          	auipc	ra,0x1
    329c:	1c4080e7          	jalr	452(ra) # 445c <write>
    32a0:	10a04b63          	bgtz	a0,33b6 <dirfile+0x218>
  close(fd);
    32a4:	8526                	mv	a0,s1
    32a6:	00001097          	auipc	ra,0x1
    32aa:	1be080e7          	jalr	446(ra) # 4464 <close>
}
    32ae:	60e2                	ld	ra,24(sp)
    32b0:	6442                	ld	s0,16(sp)
    32b2:	64a2                	ld	s1,8(sp)
    32b4:	6902                	ld	s2,0(sp)
    32b6:	6105                	addi	sp,sp,32
    32b8:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    32ba:	85ca                	mv	a1,s2
    32bc:	00003517          	auipc	a0,0x3
    32c0:	e5450513          	addi	a0,a0,-428 # 6110 <malloc+0x1896>
    32c4:	00001097          	auipc	ra,0x1
    32c8:	4f8080e7          	jalr	1272(ra) # 47bc <printf>
    exit(1);
    32cc:	4505                	li	a0,1
    32ce:	00001097          	auipc	ra,0x1
    32d2:	16e080e7          	jalr	366(ra) # 443c <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    32d6:	85ca                	mv	a1,s2
    32d8:	00003517          	auipc	a0,0x3
    32dc:	e5850513          	addi	a0,a0,-424 # 6130 <malloc+0x18b6>
    32e0:	00001097          	auipc	ra,0x1
    32e4:	4dc080e7          	jalr	1244(ra) # 47bc <printf>
    exit(1);
    32e8:	4505                	li	a0,1
    32ea:	00001097          	auipc	ra,0x1
    32ee:	152080e7          	jalr	338(ra) # 443c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    32f2:	85ca                	mv	a1,s2
    32f4:	00003517          	auipc	a0,0x3
    32f8:	e6c50513          	addi	a0,a0,-404 # 6160 <malloc+0x18e6>
    32fc:	00001097          	auipc	ra,0x1
    3300:	4c0080e7          	jalr	1216(ra) # 47bc <printf>
    exit(1);
    3304:	4505                	li	a0,1
    3306:	00001097          	auipc	ra,0x1
    330a:	136080e7          	jalr	310(ra) # 443c <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    330e:	85ca                	mv	a1,s2
    3310:	00003517          	auipc	a0,0x3
    3314:	e5050513          	addi	a0,a0,-432 # 6160 <malloc+0x18e6>
    3318:	00001097          	auipc	ra,0x1
    331c:	4a4080e7          	jalr	1188(ra) # 47bc <printf>
    exit(1);
    3320:	4505                	li	a0,1
    3322:	00001097          	auipc	ra,0x1
    3326:	11a080e7          	jalr	282(ra) # 443c <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    332a:	85ca                	mv	a1,s2
    332c:	00003517          	auipc	a0,0x3
    3330:	e5c50513          	addi	a0,a0,-420 # 6188 <malloc+0x190e>
    3334:	00001097          	auipc	ra,0x1
    3338:	488080e7          	jalr	1160(ra) # 47bc <printf>
    exit(1);
    333c:	4505                	li	a0,1
    333e:	00001097          	auipc	ra,0x1
    3342:	0fe080e7          	jalr	254(ra) # 443c <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3346:	85ca                	mv	a1,s2
    3348:	00003517          	auipc	a0,0x3
    334c:	e6850513          	addi	a0,a0,-408 # 61b0 <malloc+0x1936>
    3350:	00001097          	auipc	ra,0x1
    3354:	46c080e7          	jalr	1132(ra) # 47bc <printf>
    exit(1);
    3358:	4505                	li	a0,1
    335a:	00001097          	auipc	ra,0x1
    335e:	0e2080e7          	jalr	226(ra) # 443c <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    3362:	85ca                	mv	a1,s2
    3364:	00003517          	auipc	a0,0x3
    3368:	e7c50513          	addi	a0,a0,-388 # 61e0 <malloc+0x1966>
    336c:	00001097          	auipc	ra,0x1
    3370:	450080e7          	jalr	1104(ra) # 47bc <printf>
    exit(1);
    3374:	4505                	li	a0,1
    3376:	00001097          	auipc	ra,0x1
    337a:	0c6080e7          	jalr	198(ra) # 443c <exit>
    printf("%s: unlink dirfile failed!\n", s);
    337e:	85ca                	mv	a1,s2
    3380:	00003517          	auipc	a0,0x3
    3384:	e8850513          	addi	a0,a0,-376 # 6208 <malloc+0x198e>
    3388:	00001097          	auipc	ra,0x1
    338c:	434080e7          	jalr	1076(ra) # 47bc <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	00001097          	auipc	ra,0x1
    3396:	0aa080e7          	jalr	170(ra) # 443c <exit>
    printf("%s: open . for writing succeeded!\n", s);
    339a:	85ca                	mv	a1,s2
    339c:	00003517          	auipc	a0,0x3
    33a0:	e8c50513          	addi	a0,a0,-372 # 6228 <malloc+0x19ae>
    33a4:	00001097          	auipc	ra,0x1
    33a8:	418080e7          	jalr	1048(ra) # 47bc <printf>
    exit(1);
    33ac:	4505                	li	a0,1
    33ae:	00001097          	auipc	ra,0x1
    33b2:	08e080e7          	jalr	142(ra) # 443c <exit>
    printf("%s: write . succeeded!\n", s);
    33b6:	85ca                	mv	a1,s2
    33b8:	00003517          	auipc	a0,0x3
    33bc:	e9850513          	addi	a0,a0,-360 # 6250 <malloc+0x19d6>
    33c0:	00001097          	auipc	ra,0x1
    33c4:	3fc080e7          	jalr	1020(ra) # 47bc <printf>
    exit(1);
    33c8:	4505                	li	a0,1
    33ca:	00001097          	auipc	ra,0x1
    33ce:	072080e7          	jalr	114(ra) # 443c <exit>

00000000000033d2 <iref>:
{
    33d2:	7139                	addi	sp,sp,-64
    33d4:	fc06                	sd	ra,56(sp)
    33d6:	f822                	sd	s0,48(sp)
    33d8:	f426                	sd	s1,40(sp)
    33da:	f04a                	sd	s2,32(sp)
    33dc:	ec4e                	sd	s3,24(sp)
    33de:	e852                	sd	s4,16(sp)
    33e0:	e456                	sd	s5,8(sp)
    33e2:	e05a                	sd	s6,0(sp)
    33e4:	0080                	addi	s0,sp,64
    33e6:	8b2a                	mv	s6,a0
    33e8:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    33ec:	00003a17          	auipc	s4,0x3
    33f0:	e7ca0a13          	addi	s4,s4,-388 # 6268 <malloc+0x19ee>
    mkdir("");
    33f4:	00003497          	auipc	s1,0x3
    33f8:	a5448493          	addi	s1,s1,-1452 # 5e48 <malloc+0x15ce>
    link("README", "");
    33fc:	00003a97          	auipc	s5,0x3
    3400:	ddca8a93          	addi	s5,s5,-548 # 61d8 <malloc+0x195e>
    fd = open("xx", O_CREATE);
    3404:	00003997          	auipc	s3,0x3
    3408:	d5498993          	addi	s3,s3,-684 # 6158 <malloc+0x18de>
    340c:	a891                	j	3460 <iref+0x8e>
      printf("%s: mkdir irefd failed\n", s);
    340e:	85da                	mv	a1,s6
    3410:	00003517          	auipc	a0,0x3
    3414:	e6050513          	addi	a0,a0,-416 # 6270 <malloc+0x19f6>
    3418:	00001097          	auipc	ra,0x1
    341c:	3a4080e7          	jalr	932(ra) # 47bc <printf>
      exit(1);
    3420:	4505                	li	a0,1
    3422:	00001097          	auipc	ra,0x1
    3426:	01a080e7          	jalr	26(ra) # 443c <exit>
      printf("%s: chdir irefd failed\n", s);
    342a:	85da                	mv	a1,s6
    342c:	00003517          	auipc	a0,0x3
    3430:	e5c50513          	addi	a0,a0,-420 # 6288 <malloc+0x1a0e>
    3434:	00001097          	auipc	ra,0x1
    3438:	388080e7          	jalr	904(ra) # 47bc <printf>
      exit(1);
    343c:	4505                	li	a0,1
    343e:	00001097          	auipc	ra,0x1
    3442:	ffe080e7          	jalr	-2(ra) # 443c <exit>
      close(fd);
    3446:	00001097          	auipc	ra,0x1
    344a:	01e080e7          	jalr	30(ra) # 4464 <close>
    344e:	a889                	j	34a0 <iref+0xce>
    unlink("xx");
    3450:	854e                	mv	a0,s3
    3452:	00001097          	auipc	ra,0x1
    3456:	03a080e7          	jalr	58(ra) # 448c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    345a:	397d                	addiw	s2,s2,-1
    345c:	06090063          	beqz	s2,34bc <iref+0xea>
    if(mkdir("irefd") != 0){
    3460:	8552                	mv	a0,s4
    3462:	00001097          	auipc	ra,0x1
    3466:	042080e7          	jalr	66(ra) # 44a4 <mkdir>
    346a:	f155                	bnez	a0,340e <iref+0x3c>
    if(chdir("irefd") != 0){
    346c:	8552                	mv	a0,s4
    346e:	00001097          	auipc	ra,0x1
    3472:	03e080e7          	jalr	62(ra) # 44ac <chdir>
    3476:	f955                	bnez	a0,342a <iref+0x58>
    mkdir("");
    3478:	8526                	mv	a0,s1
    347a:	00001097          	auipc	ra,0x1
    347e:	02a080e7          	jalr	42(ra) # 44a4 <mkdir>
    link("README", "");
    3482:	85a6                	mv	a1,s1
    3484:	8556                	mv	a0,s5
    3486:	00001097          	auipc	ra,0x1
    348a:	016080e7          	jalr	22(ra) # 449c <link>
    fd = open("", O_CREATE);
    348e:	20000593          	li	a1,512
    3492:	8526                	mv	a0,s1
    3494:	00001097          	auipc	ra,0x1
    3498:	fe8080e7          	jalr	-24(ra) # 447c <open>
    if(fd >= 0)
    349c:	fa0555e3          	bgez	a0,3446 <iref+0x74>
    fd = open("xx", O_CREATE);
    34a0:	20000593          	li	a1,512
    34a4:	854e                	mv	a0,s3
    34a6:	00001097          	auipc	ra,0x1
    34aa:	fd6080e7          	jalr	-42(ra) # 447c <open>
    if(fd >= 0)
    34ae:	fa0541e3          	bltz	a0,3450 <iref+0x7e>
      close(fd);
    34b2:	00001097          	auipc	ra,0x1
    34b6:	fb2080e7          	jalr	-78(ra) # 4464 <close>
    34ba:	bf59                	j	3450 <iref+0x7e>
  chdir("/");
    34bc:	00001517          	auipc	a0,0x1
    34c0:	7b450513          	addi	a0,a0,1972 # 4c70 <malloc+0x3f6>
    34c4:	00001097          	auipc	ra,0x1
    34c8:	fe8080e7          	jalr	-24(ra) # 44ac <chdir>
}
    34cc:	70e2                	ld	ra,56(sp)
    34ce:	7442                	ld	s0,48(sp)
    34d0:	74a2                	ld	s1,40(sp)
    34d2:	7902                	ld	s2,32(sp)
    34d4:	69e2                	ld	s3,24(sp)
    34d6:	6a42                	ld	s4,16(sp)
    34d8:	6aa2                	ld	s5,8(sp)
    34da:	6b02                	ld	s6,0(sp)
    34dc:	6121                	addi	sp,sp,64
    34de:	8082                	ret

00000000000034e0 <validatetest>:
{
    34e0:	7139                	addi	sp,sp,-64
    34e2:	fc06                	sd	ra,56(sp)
    34e4:	f822                	sd	s0,48(sp)
    34e6:	f426                	sd	s1,40(sp)
    34e8:	f04a                	sd	s2,32(sp)
    34ea:	ec4e                	sd	s3,24(sp)
    34ec:	e852                	sd	s4,16(sp)
    34ee:	e456                	sd	s5,8(sp)
    34f0:	e05a                	sd	s6,0(sp)
    34f2:	0080                	addi	s0,sp,64
    34f4:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    34f6:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
    34f8:	00003997          	auipc	s3,0x3
    34fc:	da898993          	addi	s3,s3,-600 # 62a0 <malloc+0x1a26>
    3500:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3502:	6a85                	lui	s5,0x1
    3504:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
    3508:	85a6                	mv	a1,s1
    350a:	854e                	mv	a0,s3
    350c:	00001097          	auipc	ra,0x1
    3510:	f90080e7          	jalr	-112(ra) # 449c <link>
    3514:	01251f63          	bne	a0,s2,3532 <validatetest+0x52>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
    3518:	94d6                	add	s1,s1,s5
    351a:	ff4497e3          	bne	s1,s4,3508 <validatetest+0x28>
}
    351e:	70e2                	ld	ra,56(sp)
    3520:	7442                	ld	s0,48(sp)
    3522:	74a2                	ld	s1,40(sp)
    3524:	7902                	ld	s2,32(sp)
    3526:	69e2                	ld	s3,24(sp)
    3528:	6a42                	ld	s4,16(sp)
    352a:	6aa2                	ld	s5,8(sp)
    352c:	6b02                	ld	s6,0(sp)
    352e:	6121                	addi	sp,sp,64
    3530:	8082                	ret
      printf("%s: link should not succeed\n", s);
    3532:	85da                	mv	a1,s6
    3534:	00003517          	auipc	a0,0x3
    3538:	d7c50513          	addi	a0,a0,-644 # 62b0 <malloc+0x1a36>
    353c:	00001097          	auipc	ra,0x1
    3540:	280080e7          	jalr	640(ra) # 47bc <printf>
      exit(1);
    3544:	4505                	li	a0,1
    3546:	00001097          	auipc	ra,0x1
    354a:	ef6080e7          	jalr	-266(ra) # 443c <exit>

000000000000354e <sbrkbasic>:
{
    354e:	7139                	addi	sp,sp,-64
    3550:	fc06                	sd	ra,56(sp)
    3552:	f822                	sd	s0,48(sp)
    3554:	f426                	sd	s1,40(sp)
    3556:	f04a                	sd	s2,32(sp)
    3558:	ec4e                	sd	s3,24(sp)
    355a:	e852                	sd	s4,16(sp)
    355c:	0080                	addi	s0,sp,64
    355e:	8a2a                	mv	s4,a0
  a = sbrk(TOOMUCH);
    3560:	40000537          	lui	a0,0x40000
    3564:	00001097          	auipc	ra,0x1
    3568:	f60080e7          	jalr	-160(ra) # 44c4 <sbrk>
  if(a != (char*)0xffffffffffffffffL){
    356c:	57fd                	li	a5,-1
    356e:	02f50063          	beq	a0,a5,358e <sbrkbasic+0x40>
    3572:	85aa                	mv	a1,a0
    printf("%s: sbrk(<toomuch>) returned %p\n", a);
    3574:	00003517          	auipc	a0,0x3
    3578:	d5c50513          	addi	a0,a0,-676 # 62d0 <malloc+0x1a56>
    357c:	00001097          	auipc	ra,0x1
    3580:	240080e7          	jalr	576(ra) # 47bc <printf>
    exit(1);
    3584:	4505                	li	a0,1
    3586:	00001097          	auipc	ra,0x1
    358a:	eb6080e7          	jalr	-330(ra) # 443c <exit>
  a = sbrk(0);
    358e:	4501                	li	a0,0
    3590:	00001097          	auipc	ra,0x1
    3594:	f34080e7          	jalr	-204(ra) # 44c4 <sbrk>
    3598:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    359a:	4901                	li	s2,0
    359c:	6985                	lui	s3,0x1
    359e:	38898993          	addi	s3,s3,904 # 1388 <unlinkread+0x10e>
    35a2:	a011                	j	35a6 <sbrkbasic+0x58>
    a = b + 1;
    35a4:	84be                	mv	s1,a5
    b = sbrk(1);
    35a6:	4505                	li	a0,1
    35a8:	00001097          	auipc	ra,0x1
    35ac:	f1c080e7          	jalr	-228(ra) # 44c4 <sbrk>
    if(b != a){
    35b0:	04951c63          	bne	a0,s1,3608 <sbrkbasic+0xba>
    *b = 1;
    35b4:	4785                	li	a5,1
    35b6:	00f48023          	sb	a5,0(s1)
    a = b + 1;
    35ba:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    35be:	2905                	addiw	s2,s2,1
    35c0:	ff3912e3          	bne	s2,s3,35a4 <sbrkbasic+0x56>
  pid = fork();
    35c4:	00001097          	auipc	ra,0x1
    35c8:	e70080e7          	jalr	-400(ra) # 4434 <fork>
    35cc:	892a                	mv	s2,a0
  if(pid < 0){
    35ce:	04054d63          	bltz	a0,3628 <sbrkbasic+0xda>
  c = sbrk(1);
    35d2:	4505                	li	a0,1
    35d4:	00001097          	auipc	ra,0x1
    35d8:	ef0080e7          	jalr	-272(ra) # 44c4 <sbrk>
  c = sbrk(1);
    35dc:	4505                	li	a0,1
    35de:	00001097          	auipc	ra,0x1
    35e2:	ee6080e7          	jalr	-282(ra) # 44c4 <sbrk>
  if(c != a + 1){
    35e6:	0489                	addi	s1,s1,2
    35e8:	04a48e63          	beq	s1,a0,3644 <sbrkbasic+0xf6>
    printf("%s: sbrk test failed post-fork\n", s);
    35ec:	85d2                	mv	a1,s4
    35ee:	00003517          	auipc	a0,0x3
    35f2:	d4a50513          	addi	a0,a0,-694 # 6338 <malloc+0x1abe>
    35f6:	00001097          	auipc	ra,0x1
    35fa:	1c6080e7          	jalr	454(ra) # 47bc <printf>
    exit(1);
    35fe:	4505                	li	a0,1
    3600:	00001097          	auipc	ra,0x1
    3604:	e3c080e7          	jalr	-452(ra) # 443c <exit>
      printf("%s: sbrk test failed %d %x %x\n", i, a, b);
    3608:	86aa                	mv	a3,a0
    360a:	8626                	mv	a2,s1
    360c:	85ca                	mv	a1,s2
    360e:	00003517          	auipc	a0,0x3
    3612:	cea50513          	addi	a0,a0,-790 # 62f8 <malloc+0x1a7e>
    3616:	00001097          	auipc	ra,0x1
    361a:	1a6080e7          	jalr	422(ra) # 47bc <printf>
      exit(1);
    361e:	4505                	li	a0,1
    3620:	00001097          	auipc	ra,0x1
    3624:	e1c080e7          	jalr	-484(ra) # 443c <exit>
    printf("%s: sbrk test fork failed\n", s);
    3628:	85d2                	mv	a1,s4
    362a:	00003517          	auipc	a0,0x3
    362e:	cee50513          	addi	a0,a0,-786 # 6318 <malloc+0x1a9e>
    3632:	00001097          	auipc	ra,0x1
    3636:	18a080e7          	jalr	394(ra) # 47bc <printf>
    exit(1);
    363a:	4505                	li	a0,1
    363c:	00001097          	auipc	ra,0x1
    3640:	e00080e7          	jalr	-512(ra) # 443c <exit>
  if(pid == 0)
    3644:	00091763          	bnez	s2,3652 <sbrkbasic+0x104>
    exit(0);
    3648:	4501                	li	a0,0
    364a:	00001097          	auipc	ra,0x1
    364e:	df2080e7          	jalr	-526(ra) # 443c <exit>
  wait(&xstatus);
    3652:	fcc40513          	addi	a0,s0,-52
    3656:	00001097          	auipc	ra,0x1
    365a:	dee080e7          	jalr	-530(ra) # 4444 <wait>
  exit(xstatus);
    365e:	fcc42503          	lw	a0,-52(s0)
    3662:	00001097          	auipc	ra,0x1
    3666:	dda080e7          	jalr	-550(ra) # 443c <exit>

000000000000366a <sbrkmuch>:
{
    366a:	7179                	addi	sp,sp,-48
    366c:	f406                	sd	ra,40(sp)
    366e:	f022                	sd	s0,32(sp)
    3670:	ec26                	sd	s1,24(sp)
    3672:	e84a                	sd	s2,16(sp)
    3674:	e44e                	sd	s3,8(sp)
    3676:	e052                	sd	s4,0(sp)
    3678:	1800                	addi	s0,sp,48
    367a:	8a2a                	mv	s4,a0
  oldbrk = sbrk(0);
    367c:	4501                	li	a0,0
    367e:	00001097          	auipc	ra,0x1
    3682:	e46080e7          	jalr	-442(ra) # 44c4 <sbrk>
    3686:	892a                	mv	s2,a0
  a = sbrk(0);
    3688:	4501                	li	a0,0
    368a:	00001097          	auipc	ra,0x1
    368e:	e3a080e7          	jalr	-454(ra) # 44c4 <sbrk>
    3692:	84aa                	mv	s1,a0
  p = sbrk(amt);
    3694:	06400537          	lui	a0,0x6400
    3698:	9d05                	subw	a0,a0,s1
    369a:	00001097          	auipc	ra,0x1
    369e:	e2a080e7          	jalr	-470(ra) # 44c4 <sbrk>
  if (p != a) {
    36a2:	0ca49363          	bne	s1,a0,3768 <sbrkmuch+0xfe>
  *lastaddr = 99;
    36a6:	064007b7          	lui	a5,0x6400
    36aa:	06300713          	li	a4,99
    36ae:	fee78fa3          	sb	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3d9f>
  a = sbrk(0);
    36b2:	4501                	li	a0,0
    36b4:	00001097          	auipc	ra,0x1
    36b8:	e10080e7          	jalr	-496(ra) # 44c4 <sbrk>
    36bc:	89aa                	mv	s3,a0
  c = sbrk(-PGSIZE);
    36be:	757d                	lui	a0,0xfffff
    36c0:	00001097          	auipc	ra,0x1
    36c4:	e04080e7          	jalr	-508(ra) # 44c4 <sbrk>
    36c8:	84aa                	mv	s1,a0
  printf("%d \n",c);
    36ca:	85aa                	mv	a1,a0
    36cc:	00003517          	auipc	a0,0x3
    36d0:	cd450513          	addi	a0,a0,-812 # 63a0 <malloc+0x1b26>
    36d4:	00001097          	auipc	ra,0x1
    36d8:	0e8080e7          	jalr	232(ra) # 47bc <printf>
  if(c == (char*)0xffffffffffffffffL){
    36dc:	57fd                	li	a5,-1
    36de:	0af48363          	beq	s1,a5,3784 <sbrkmuch+0x11a>
  c = sbrk(0);
    36e2:	4501                	li	a0,0
    36e4:	00001097          	auipc	ra,0x1
    36e8:	de0080e7          	jalr	-544(ra) # 44c4 <sbrk>
  if(c != a - PGSIZE){
    36ec:	77fd                	lui	a5,0xfffff
    36ee:	97ce                	add	a5,a5,s3
    36f0:	0af51863          	bne	a0,a5,37a0 <sbrkmuch+0x136>
  a = sbrk(0);
    36f4:	4501                	li	a0,0
    36f6:	00001097          	auipc	ra,0x1
    36fa:	dce080e7          	jalr	-562(ra) # 44c4 <sbrk>
    36fe:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    3700:	6505                	lui	a0,0x1
    3702:	00001097          	auipc	ra,0x1
    3706:	dc2080e7          	jalr	-574(ra) # 44c4 <sbrk>
    370a:	89aa                	mv	s3,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    370c:	0aa49963          	bne	s1,a0,37be <sbrkmuch+0x154>
    3710:	4501                	li	a0,0
    3712:	00001097          	auipc	ra,0x1
    3716:	db2080e7          	jalr	-590(ra) # 44c4 <sbrk>
    371a:	6785                	lui	a5,0x1
    371c:	97a6                	add	a5,a5,s1
    371e:	0af51063          	bne	a0,a5,37be <sbrkmuch+0x154>
  if(*lastaddr == 99){
    3722:	064007b7          	lui	a5,0x6400
    3726:	fff7c703          	lbu	a4,-1(a5) # 63fffff <__BSS_END__+0x63f3d9f>
    372a:	06300793          	li	a5,99
    372e:	0af70763          	beq	a4,a5,37dc <sbrkmuch+0x172>
  a = sbrk(0);
    3732:	4501                	li	a0,0
    3734:	00001097          	auipc	ra,0x1
    3738:	d90080e7          	jalr	-624(ra) # 44c4 <sbrk>
    373c:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    373e:	4501                	li	a0,0
    3740:	00001097          	auipc	ra,0x1
    3744:	d84080e7          	jalr	-636(ra) # 44c4 <sbrk>
    3748:	40a9053b          	subw	a0,s2,a0
    374c:	00001097          	auipc	ra,0x1
    3750:	d78080e7          	jalr	-648(ra) # 44c4 <sbrk>
  if(c != a){
    3754:	0aa49263          	bne	s1,a0,37f8 <sbrkmuch+0x18e>
}
    3758:	70a2                	ld	ra,40(sp)
    375a:	7402                	ld	s0,32(sp)
    375c:	64e2                	ld	s1,24(sp)
    375e:	6942                	ld	s2,16(sp)
    3760:	69a2                	ld	s3,8(sp)
    3762:	6a02                	ld	s4,0(sp)
    3764:	6145                	addi	sp,sp,48
    3766:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    3768:	85d2                	mv	a1,s4
    376a:	00003517          	auipc	a0,0x3
    376e:	bee50513          	addi	a0,a0,-1042 # 6358 <malloc+0x1ade>
    3772:	00001097          	auipc	ra,0x1
    3776:	04a080e7          	jalr	74(ra) # 47bc <printf>
    exit(1);
    377a:	4505                	li	a0,1
    377c:	00001097          	auipc	ra,0x1
    3780:	cc0080e7          	jalr	-832(ra) # 443c <exit>
    printf("%s: sbrk could not deallocate\n", s);
    3784:	85d2                	mv	a1,s4
    3786:	00003517          	auipc	a0,0x3
    378a:	c2250513          	addi	a0,a0,-990 # 63a8 <malloc+0x1b2e>
    378e:	00001097          	auipc	ra,0x1
    3792:	02e080e7          	jalr	46(ra) # 47bc <printf>
    exit(1);
    3796:	4505                	li	a0,1
    3798:	00001097          	auipc	ra,0x1
    379c:	ca4080e7          	jalr	-860(ra) # 443c <exit>
    printf("%s: sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    37a0:	862a                	mv	a2,a0
    37a2:	85ce                	mv	a1,s3
    37a4:	00003517          	auipc	a0,0x3
    37a8:	c2450513          	addi	a0,a0,-988 # 63c8 <malloc+0x1b4e>
    37ac:	00001097          	auipc	ra,0x1
    37b0:	010080e7          	jalr	16(ra) # 47bc <printf>
    exit(1);
    37b4:	4505                	li	a0,1
    37b6:	00001097          	auipc	ra,0x1
    37ba:	c86080e7          	jalr	-890(ra) # 443c <exit>
    printf("%s: sbrk re-allocation failed, a %x c %x\n", a, c);
    37be:	864e                	mv	a2,s3
    37c0:	85a6                	mv	a1,s1
    37c2:	00003517          	auipc	a0,0x3
    37c6:	c4650513          	addi	a0,a0,-954 # 6408 <malloc+0x1b8e>
    37ca:	00001097          	auipc	ra,0x1
    37ce:	ff2080e7          	jalr	-14(ra) # 47bc <printf>
    exit(1);
    37d2:	4505                	li	a0,1
    37d4:	00001097          	auipc	ra,0x1
    37d8:	c68080e7          	jalr	-920(ra) # 443c <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    37dc:	85d2                	mv	a1,s4
    37de:	00003517          	auipc	a0,0x3
    37e2:	c5a50513          	addi	a0,a0,-934 # 6438 <malloc+0x1bbe>
    37e6:	00001097          	auipc	ra,0x1
    37ea:	fd6080e7          	jalr	-42(ra) # 47bc <printf>
    exit(1);
    37ee:	4505                	li	a0,1
    37f0:	00001097          	auipc	ra,0x1
    37f4:	c4c080e7          	jalr	-948(ra) # 443c <exit>
    printf("%s: sbrk downsize failed, a %x c %x\n", a, c);
    37f8:	862a                	mv	a2,a0
    37fa:	85a6                	mv	a1,s1
    37fc:	00003517          	auipc	a0,0x3
    3800:	c7450513          	addi	a0,a0,-908 # 6470 <malloc+0x1bf6>
    3804:	00001097          	auipc	ra,0x1
    3808:	fb8080e7          	jalr	-72(ra) # 47bc <printf>
    exit(1);
    380c:	4505                	li	a0,1
    380e:	00001097          	auipc	ra,0x1
    3812:	c2e080e7          	jalr	-978(ra) # 443c <exit>

0000000000003816 <sbrkfail>:
{
    3816:	7119                	addi	sp,sp,-128
    3818:	fc86                	sd	ra,120(sp)
    381a:	f8a2                	sd	s0,112(sp)
    381c:	f4a6                	sd	s1,104(sp)
    381e:	f0ca                	sd	s2,96(sp)
    3820:	ecce                	sd	s3,88(sp)
    3822:	e8d2                	sd	s4,80(sp)
    3824:	e4d6                	sd	s5,72(sp)
    3826:	0100                	addi	s0,sp,128
    3828:	892a                	mv	s2,a0
  if(pipe(fds) != 0){
    382a:	fb040513          	addi	a0,s0,-80
    382e:	00001097          	auipc	ra,0x1
    3832:	c1e080e7          	jalr	-994(ra) # 444c <pipe>
    3836:	e901                	bnez	a0,3846 <sbrkfail+0x30>
    3838:	f8040493          	addi	s1,s0,-128
    383c:	fa840a13          	addi	s4,s0,-88
    3840:	89a6                	mv	s3,s1
    if(pids[i] != -1)
    3842:	5afd                	li	s5,-1
    3844:	a08d                	j	38a6 <sbrkfail+0x90>
    printf("%s: pipe() failed\n", s);
    3846:	85ca                	mv	a1,s2
    3848:	00002517          	auipc	a0,0x2
    384c:	e6050513          	addi	a0,a0,-416 # 56a8 <malloc+0xe2e>
    3850:	00001097          	auipc	ra,0x1
    3854:	f6c080e7          	jalr	-148(ra) # 47bc <printf>
    exit(1);
    3858:	4505                	li	a0,1
    385a:	00001097          	auipc	ra,0x1
    385e:	be2080e7          	jalr	-1054(ra) # 443c <exit>
      sbrk(BIG - (uint64)sbrk(0));
    3862:	4501                	li	a0,0
    3864:	00001097          	auipc	ra,0x1
    3868:	c60080e7          	jalr	-928(ra) # 44c4 <sbrk>
    386c:	064007b7          	lui	a5,0x6400
    3870:	40a7853b          	subw	a0,a5,a0
    3874:	00001097          	auipc	ra,0x1
    3878:	c50080e7          	jalr	-944(ra) # 44c4 <sbrk>
      write(fds[1], "x", 1);
    387c:	4605                	li	a2,1
    387e:	00002597          	auipc	a1,0x2
    3882:	eaa58593          	addi	a1,a1,-342 # 5728 <malloc+0xeae>
    3886:	fb442503          	lw	a0,-76(s0)
    388a:	00001097          	auipc	ra,0x1
    388e:	bd2080e7          	jalr	-1070(ra) # 445c <write>
      for(;;) sleep(1000);
    3892:	3e800513          	li	a0,1000
    3896:	00001097          	auipc	ra,0x1
    389a:	c36080e7          	jalr	-970(ra) # 44cc <sleep>
    389e:	bfd5                	j	3892 <sbrkfail+0x7c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    38a0:	0991                	addi	s3,s3,4
    38a2:	03498563          	beq	s3,s4,38cc <sbrkfail+0xb6>
    if((pids[i] = fork()) == 0){
    38a6:	00001097          	auipc	ra,0x1
    38aa:	b8e080e7          	jalr	-1138(ra) # 4434 <fork>
    38ae:	00a9a023          	sw	a0,0(s3)
    38b2:	d945                	beqz	a0,3862 <sbrkfail+0x4c>
    if(pids[i] != -1)
    38b4:	ff5506e3          	beq	a0,s5,38a0 <sbrkfail+0x8a>
      read(fds[0], &scratch, 1);
    38b8:	4605                	li	a2,1
    38ba:	faf40593          	addi	a1,s0,-81
    38be:	fb042503          	lw	a0,-80(s0)
    38c2:	00001097          	auipc	ra,0x1
    38c6:	b92080e7          	jalr	-1134(ra) # 4454 <read>
    38ca:	bfd9                	j	38a0 <sbrkfail+0x8a>
  c = sbrk(PGSIZE);
    38cc:	6505                	lui	a0,0x1
    38ce:	00001097          	auipc	ra,0x1
    38d2:	bf6080e7          	jalr	-1034(ra) # 44c4 <sbrk>
    38d6:	89aa                	mv	s3,a0
    if(pids[i] == -1)
    38d8:	5afd                	li	s5,-1
    38da:	a021                	j	38e2 <sbrkfail+0xcc>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    38dc:	0491                	addi	s1,s1,4
    38de:	01448f63          	beq	s1,s4,38fc <sbrkfail+0xe6>
    if(pids[i] == -1)
    38e2:	4088                	lw	a0,0(s1)
    38e4:	ff550ce3          	beq	a0,s5,38dc <sbrkfail+0xc6>
    kill(pids[i]);
    38e8:	00001097          	auipc	ra,0x1
    38ec:	b84080e7          	jalr	-1148(ra) # 446c <kill>
    wait(0);
    38f0:	4501                	li	a0,0
    38f2:	00001097          	auipc	ra,0x1
    38f6:	b52080e7          	jalr	-1198(ra) # 4444 <wait>
    38fa:	b7cd                	j	38dc <sbrkfail+0xc6>
  if(c == (char*)0xffffffffffffffffL){
    38fc:	57fd                	li	a5,-1
    38fe:	02f98e63          	beq	s3,a5,393a <sbrkfail+0x124>
  pid = fork();
    3902:	00001097          	auipc	ra,0x1
    3906:	b32080e7          	jalr	-1230(ra) # 4434 <fork>
    390a:	84aa                	mv	s1,a0
  if(pid < 0){
    390c:	04054563          	bltz	a0,3956 <sbrkfail+0x140>
  if(pid == 0){
    3910:	c12d                	beqz	a0,3972 <sbrkfail+0x15c>
  wait(&xstatus);
    3912:	fbc40513          	addi	a0,s0,-68
    3916:	00001097          	auipc	ra,0x1
    391a:	b2e080e7          	jalr	-1234(ra) # 4444 <wait>
  if(xstatus != -1)
    391e:	fbc42703          	lw	a4,-68(s0)
    3922:	57fd                	li	a5,-1
    3924:	08f71c63          	bne	a4,a5,39bc <sbrkfail+0x1a6>
}
    3928:	70e6                	ld	ra,120(sp)
    392a:	7446                	ld	s0,112(sp)
    392c:	74a6                	ld	s1,104(sp)
    392e:	7906                	ld	s2,96(sp)
    3930:	69e6                	ld	s3,88(sp)
    3932:	6a46                	ld	s4,80(sp)
    3934:	6aa6                	ld	s5,72(sp)
    3936:	6109                	addi	sp,sp,128
    3938:	8082                	ret
    printf("%s: failed sbrk leaked memory\n", s);
    393a:	85ca                	mv	a1,s2
    393c:	00003517          	auipc	a0,0x3
    3940:	b5c50513          	addi	a0,a0,-1188 # 6498 <malloc+0x1c1e>
    3944:	00001097          	auipc	ra,0x1
    3948:	e78080e7          	jalr	-392(ra) # 47bc <printf>
    exit(1);
    394c:	4505                	li	a0,1
    394e:	00001097          	auipc	ra,0x1
    3952:	aee080e7          	jalr	-1298(ra) # 443c <exit>
    printf("%s: fork failed\n", s);
    3956:	85ca                	mv	a1,s2
    3958:	00001517          	auipc	a0,0x1
    395c:	42050513          	addi	a0,a0,1056 # 4d78 <malloc+0x4fe>
    3960:	00001097          	auipc	ra,0x1
    3964:	e5c080e7          	jalr	-420(ra) # 47bc <printf>
    exit(1);
    3968:	4505                	li	a0,1
    396a:	00001097          	auipc	ra,0x1
    396e:	ad2080e7          	jalr	-1326(ra) # 443c <exit>
    a = sbrk(0);
    3972:	4501                	li	a0,0
    3974:	00001097          	auipc	ra,0x1
    3978:	b50080e7          	jalr	-1200(ra) # 44c4 <sbrk>
    397c:	892a                	mv	s2,a0
    sbrk(10*BIG);
    397e:	3e800537          	lui	a0,0x3e800
    3982:	00001097          	auipc	ra,0x1
    3986:	b42080e7          	jalr	-1214(ra) # 44c4 <sbrk>
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    398a:	874a                	mv	a4,s2
    398c:	3e8007b7          	lui	a5,0x3e800
    3990:	97ca                	add	a5,a5,s2
    3992:	6685                	lui	a3,0x1
      n += *(a+i);
    3994:	00074603          	lbu	a2,0(a4)
    3998:	9cb1                	addw	s1,s1,a2
    for (i = 0; i < 10*BIG; i += PGSIZE) {
    399a:	9736                	add	a4,a4,a3
    399c:	fef71ce3          	bne	a4,a5,3994 <sbrkfail+0x17e>
    printf("%s: allocate a lot of memory succeeded %d\n", n);
    39a0:	85a6                	mv	a1,s1
    39a2:	00003517          	auipc	a0,0x3
    39a6:	b1650513          	addi	a0,a0,-1258 # 64b8 <malloc+0x1c3e>
    39aa:	00001097          	auipc	ra,0x1
    39ae:	e12080e7          	jalr	-494(ra) # 47bc <printf>
    exit(1);
    39b2:	4505                	li	a0,1
    39b4:	00001097          	auipc	ra,0x1
    39b8:	a88080e7          	jalr	-1400(ra) # 443c <exit>
    exit(1);
    39bc:	4505                	li	a0,1
    39be:	00001097          	auipc	ra,0x1
    39c2:	a7e080e7          	jalr	-1410(ra) # 443c <exit>

00000000000039c6 <sbrkarg>:
{
    39c6:	7179                	addi	sp,sp,-48
    39c8:	f406                	sd	ra,40(sp)
    39ca:	f022                	sd	s0,32(sp)
    39cc:	ec26                	sd	s1,24(sp)
    39ce:	e84a                	sd	s2,16(sp)
    39d0:	e44e                	sd	s3,8(sp)
    39d2:	1800                	addi	s0,sp,48
    39d4:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    39d6:	6505                	lui	a0,0x1
    39d8:	00001097          	auipc	ra,0x1
    39dc:	aec080e7          	jalr	-1300(ra) # 44c4 <sbrk>
    39e0:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    39e2:	20100593          	li	a1,513
    39e6:	00003517          	auipc	a0,0x3
    39ea:	b0250513          	addi	a0,a0,-1278 # 64e8 <malloc+0x1c6e>
    39ee:	00001097          	auipc	ra,0x1
    39f2:	a8e080e7          	jalr	-1394(ra) # 447c <open>
    39f6:	84aa                	mv	s1,a0
  unlink("sbrk");
    39f8:	00003517          	auipc	a0,0x3
    39fc:	af050513          	addi	a0,a0,-1296 # 64e8 <malloc+0x1c6e>
    3a00:	00001097          	auipc	ra,0x1
    3a04:	a8c080e7          	jalr	-1396(ra) # 448c <unlink>
  if(fd < 0)  {
    3a08:	0404c163          	bltz	s1,3a4a <sbrkarg+0x84>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    3a0c:	6605                	lui	a2,0x1
    3a0e:	85ca                	mv	a1,s2
    3a10:	8526                	mv	a0,s1
    3a12:	00001097          	auipc	ra,0x1
    3a16:	a4a080e7          	jalr	-1462(ra) # 445c <write>
    3a1a:	04054663          	bltz	a0,3a66 <sbrkarg+0xa0>
  close(fd);
    3a1e:	8526                	mv	a0,s1
    3a20:	00001097          	auipc	ra,0x1
    3a24:	a44080e7          	jalr	-1468(ra) # 4464 <close>
  a = sbrk(PGSIZE);
    3a28:	6505                	lui	a0,0x1
    3a2a:	00001097          	auipc	ra,0x1
    3a2e:	a9a080e7          	jalr	-1382(ra) # 44c4 <sbrk>
  if(pipe((int *) a) != 0){
    3a32:	00001097          	auipc	ra,0x1
    3a36:	a1a080e7          	jalr	-1510(ra) # 444c <pipe>
    3a3a:	e521                	bnez	a0,3a82 <sbrkarg+0xbc>
}
    3a3c:	70a2                	ld	ra,40(sp)
    3a3e:	7402                	ld	s0,32(sp)
    3a40:	64e2                	ld	s1,24(sp)
    3a42:	6942                	ld	s2,16(sp)
    3a44:	69a2                	ld	s3,8(sp)
    3a46:	6145                	addi	sp,sp,48
    3a48:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    3a4a:	85ce                	mv	a1,s3
    3a4c:	00003517          	auipc	a0,0x3
    3a50:	aa450513          	addi	a0,a0,-1372 # 64f0 <malloc+0x1c76>
    3a54:	00001097          	auipc	ra,0x1
    3a58:	d68080e7          	jalr	-664(ra) # 47bc <printf>
    exit(1);
    3a5c:	4505                	li	a0,1
    3a5e:	00001097          	auipc	ra,0x1
    3a62:	9de080e7          	jalr	-1570(ra) # 443c <exit>
    printf("%s: write sbrk failed\n", s);
    3a66:	85ce                	mv	a1,s3
    3a68:	00003517          	auipc	a0,0x3
    3a6c:	aa050513          	addi	a0,a0,-1376 # 6508 <malloc+0x1c8e>
    3a70:	00001097          	auipc	ra,0x1
    3a74:	d4c080e7          	jalr	-692(ra) # 47bc <printf>
    exit(1);
    3a78:	4505                	li	a0,1
    3a7a:	00001097          	auipc	ra,0x1
    3a7e:	9c2080e7          	jalr	-1598(ra) # 443c <exit>
    printf("%s: pipe() failed\n", s);
    3a82:	85ce                	mv	a1,s3
    3a84:	00002517          	auipc	a0,0x2
    3a88:	c2450513          	addi	a0,a0,-988 # 56a8 <malloc+0xe2e>
    3a8c:	00001097          	auipc	ra,0x1
    3a90:	d30080e7          	jalr	-720(ra) # 47bc <printf>
    exit(1);
    3a94:	4505                	li	a0,1
    3a96:	00001097          	auipc	ra,0x1
    3a9a:	9a6080e7          	jalr	-1626(ra) # 443c <exit>

0000000000003a9e <argptest>:
{
    3a9e:	1101                	addi	sp,sp,-32
    3aa0:	ec06                	sd	ra,24(sp)
    3aa2:	e822                	sd	s0,16(sp)
    3aa4:	e426                	sd	s1,8(sp)
    3aa6:	e04a                	sd	s2,0(sp)
    3aa8:	1000                	addi	s0,sp,32
    3aaa:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    3aac:	4581                	li	a1,0
    3aae:	00003517          	auipc	a0,0x3
    3ab2:	a7250513          	addi	a0,a0,-1422 # 6520 <malloc+0x1ca6>
    3ab6:	00001097          	auipc	ra,0x1
    3aba:	9c6080e7          	jalr	-1594(ra) # 447c <open>
  if (fd < 0) {
    3abe:	02054b63          	bltz	a0,3af4 <argptest+0x56>
    3ac2:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    3ac4:	4501                	li	a0,0
    3ac6:	00001097          	auipc	ra,0x1
    3aca:	9fe080e7          	jalr	-1538(ra) # 44c4 <sbrk>
    3ace:	567d                	li	a2,-1
    3ad0:	fff50593          	addi	a1,a0,-1
    3ad4:	8526                	mv	a0,s1
    3ad6:	00001097          	auipc	ra,0x1
    3ada:	97e080e7          	jalr	-1666(ra) # 4454 <read>
  close(fd);
    3ade:	8526                	mv	a0,s1
    3ae0:	00001097          	auipc	ra,0x1
    3ae4:	984080e7          	jalr	-1660(ra) # 4464 <close>
}
    3ae8:	60e2                	ld	ra,24(sp)
    3aea:	6442                	ld	s0,16(sp)
    3aec:	64a2                	ld	s1,8(sp)
    3aee:	6902                	ld	s2,0(sp)
    3af0:	6105                	addi	sp,sp,32
    3af2:	8082                	ret
    printf("%s: open failed\n", s);
    3af4:	85ca                	mv	a1,s2
    3af6:	00002517          	auipc	a0,0x2
    3afa:	a5250513          	addi	a0,a0,-1454 # 5548 <malloc+0xcce>
    3afe:	00001097          	auipc	ra,0x1
    3b02:	cbe080e7          	jalr	-834(ra) # 47bc <printf>
    exit(1);
    3b06:	4505                	li	a0,1
    3b08:	00001097          	auipc	ra,0x1
    3b0c:	934080e7          	jalr	-1740(ra) # 443c <exit>

0000000000003b10 <sbrkbugs>:
{
    3b10:	1141                	addi	sp,sp,-16
    3b12:	e406                	sd	ra,8(sp)
    3b14:	e022                	sd	s0,0(sp)
    3b16:	0800                	addi	s0,sp,16
  int pid = fork();
    3b18:	00001097          	auipc	ra,0x1
    3b1c:	91c080e7          	jalr	-1764(ra) # 4434 <fork>
  if(pid < 0){
    3b20:	02054263          	bltz	a0,3b44 <sbrkbugs+0x34>
  if(pid == 0){
    3b24:	ed0d                	bnez	a0,3b5e <sbrkbugs+0x4e>
    int sz = (uint64) sbrk(0);
    3b26:	00001097          	auipc	ra,0x1
    3b2a:	99e080e7          	jalr	-1634(ra) # 44c4 <sbrk>
    sbrk(-sz);
    3b2e:	40a0053b          	negw	a0,a0
    3b32:	00001097          	auipc	ra,0x1
    3b36:	992080e7          	jalr	-1646(ra) # 44c4 <sbrk>
    exit(0);
    3b3a:	4501                	li	a0,0
    3b3c:	00001097          	auipc	ra,0x1
    3b40:	900080e7          	jalr	-1792(ra) # 443c <exit>
    printf("fork failed\n");
    3b44:	00002517          	auipc	a0,0x2
    3b48:	b3450513          	addi	a0,a0,-1228 # 5678 <malloc+0xdfe>
    3b4c:	00001097          	auipc	ra,0x1
    3b50:	c70080e7          	jalr	-912(ra) # 47bc <printf>
    exit(1);
    3b54:	4505                	li	a0,1
    3b56:	00001097          	auipc	ra,0x1
    3b5a:	8e6080e7          	jalr	-1818(ra) # 443c <exit>
  wait(0);
    3b5e:	4501                	li	a0,0
    3b60:	00001097          	auipc	ra,0x1
    3b64:	8e4080e7          	jalr	-1820(ra) # 4444 <wait>
  pid = fork();
    3b68:	00001097          	auipc	ra,0x1
    3b6c:	8cc080e7          	jalr	-1844(ra) # 4434 <fork>
  if(pid < 0){
    3b70:	02054563          	bltz	a0,3b9a <sbrkbugs+0x8a>
  if(pid == 0){
    3b74:	e121                	bnez	a0,3bb4 <sbrkbugs+0xa4>
    int sz = (uint64) sbrk(0);
    3b76:	00001097          	auipc	ra,0x1
    3b7a:	94e080e7          	jalr	-1714(ra) # 44c4 <sbrk>
    sbrk(-(sz - 3500));
    3b7e:	6785                	lui	a5,0x1
    3b80:	dac7879b          	addiw	a5,a5,-596
    3b84:	40a7853b          	subw	a0,a5,a0
    3b88:	00001097          	auipc	ra,0x1
    3b8c:	93c080e7          	jalr	-1732(ra) # 44c4 <sbrk>
    exit(0);
    3b90:	4501                	li	a0,0
    3b92:	00001097          	auipc	ra,0x1
    3b96:	8aa080e7          	jalr	-1878(ra) # 443c <exit>
    printf("fork failed\n");
    3b9a:	00002517          	auipc	a0,0x2
    3b9e:	ade50513          	addi	a0,a0,-1314 # 5678 <malloc+0xdfe>
    3ba2:	00001097          	auipc	ra,0x1
    3ba6:	c1a080e7          	jalr	-998(ra) # 47bc <printf>
    exit(1);
    3baa:	4505                	li	a0,1
    3bac:	00001097          	auipc	ra,0x1
    3bb0:	890080e7          	jalr	-1904(ra) # 443c <exit>
  wait(0);
    3bb4:	4501                	li	a0,0
    3bb6:	00001097          	auipc	ra,0x1
    3bba:	88e080e7          	jalr	-1906(ra) # 4444 <wait>
  pid = fork();
    3bbe:	00001097          	auipc	ra,0x1
    3bc2:	876080e7          	jalr	-1930(ra) # 4434 <fork>
  if(pid < 0){
    3bc6:	02054a63          	bltz	a0,3bfa <sbrkbugs+0xea>
  if(pid == 0){
    3bca:	e529                	bnez	a0,3c14 <sbrkbugs+0x104>
    sbrk((10*4096 + 2048) - (uint64)sbrk(0));
    3bcc:	00001097          	auipc	ra,0x1
    3bd0:	8f8080e7          	jalr	-1800(ra) # 44c4 <sbrk>
    3bd4:	67ad                	lui	a5,0xb
    3bd6:	8007879b          	addiw	a5,a5,-2048
    3bda:	40a7853b          	subw	a0,a5,a0
    3bde:	00001097          	auipc	ra,0x1
    3be2:	8e6080e7          	jalr	-1818(ra) # 44c4 <sbrk>
    sbrk(-10);
    3be6:	5559                	li	a0,-10
    3be8:	00001097          	auipc	ra,0x1
    3bec:	8dc080e7          	jalr	-1828(ra) # 44c4 <sbrk>
    exit(0);
    3bf0:	4501                	li	a0,0
    3bf2:	00001097          	auipc	ra,0x1
    3bf6:	84a080e7          	jalr	-1974(ra) # 443c <exit>
    printf("fork failed\n");
    3bfa:	00002517          	auipc	a0,0x2
    3bfe:	a7e50513          	addi	a0,a0,-1410 # 5678 <malloc+0xdfe>
    3c02:	00001097          	auipc	ra,0x1
    3c06:	bba080e7          	jalr	-1094(ra) # 47bc <printf>
    exit(1);
    3c0a:	4505                	li	a0,1
    3c0c:	00001097          	auipc	ra,0x1
    3c10:	830080e7          	jalr	-2000(ra) # 443c <exit>
  wait(0);
    3c14:	4501                	li	a0,0
    3c16:	00001097          	auipc	ra,0x1
    3c1a:	82e080e7          	jalr	-2002(ra) # 4444 <wait>
  exit(0);
    3c1e:	4501                	li	a0,0
    3c20:	00001097          	auipc	ra,0x1
    3c24:	81c080e7          	jalr	-2020(ra) # 443c <exit>

0000000000003c28 <dirtest>:
{
    3c28:	1101                	addi	sp,sp,-32
    3c2a:	ec06                	sd	ra,24(sp)
    3c2c:	e822                	sd	s0,16(sp)
    3c2e:	e426                	sd	s1,8(sp)
    3c30:	1000                	addi	s0,sp,32
    3c32:	84aa                	mv	s1,a0
  printf("mkdir test\n");
    3c34:	00003517          	auipc	a0,0x3
    3c38:	8f450513          	addi	a0,a0,-1804 # 6528 <malloc+0x1cae>
    3c3c:	00001097          	auipc	ra,0x1
    3c40:	b80080e7          	jalr	-1152(ra) # 47bc <printf>
  if(mkdir("dir0") < 0){
    3c44:	00003517          	auipc	a0,0x3
    3c48:	8f450513          	addi	a0,a0,-1804 # 6538 <malloc+0x1cbe>
    3c4c:	00001097          	auipc	ra,0x1
    3c50:	858080e7          	jalr	-1960(ra) # 44a4 <mkdir>
    3c54:	04054d63          	bltz	a0,3cae <dirtest+0x86>
  if(chdir("dir0") < 0){
    3c58:	00003517          	auipc	a0,0x3
    3c5c:	8e050513          	addi	a0,a0,-1824 # 6538 <malloc+0x1cbe>
    3c60:	00001097          	auipc	ra,0x1
    3c64:	84c080e7          	jalr	-1972(ra) # 44ac <chdir>
    3c68:	06054163          	bltz	a0,3cca <dirtest+0xa2>
  if(chdir("..") < 0){
    3c6c:	00001517          	auipc	a0,0x1
    3c70:	07c50513          	addi	a0,a0,124 # 4ce8 <malloc+0x46e>
    3c74:	00001097          	auipc	ra,0x1
    3c78:	838080e7          	jalr	-1992(ra) # 44ac <chdir>
    3c7c:	06054563          	bltz	a0,3ce6 <dirtest+0xbe>
  if(unlink("dir0") < 0){
    3c80:	00003517          	auipc	a0,0x3
    3c84:	8b850513          	addi	a0,a0,-1864 # 6538 <malloc+0x1cbe>
    3c88:	00001097          	auipc	ra,0x1
    3c8c:	804080e7          	jalr	-2044(ra) # 448c <unlink>
    3c90:	06054963          	bltz	a0,3d02 <dirtest+0xda>
  printf("%s: mkdir test ok\n");
    3c94:	00003517          	auipc	a0,0x3
    3c98:	8f450513          	addi	a0,a0,-1804 # 6588 <malloc+0x1d0e>
    3c9c:	00001097          	auipc	ra,0x1
    3ca0:	b20080e7          	jalr	-1248(ra) # 47bc <printf>
}
    3ca4:	60e2                	ld	ra,24(sp)
    3ca6:	6442                	ld	s0,16(sp)
    3ca8:	64a2                	ld	s1,8(sp)
    3caa:	6105                	addi	sp,sp,32
    3cac:	8082                	ret
    printf("%s: mkdir failed\n", s);
    3cae:	85a6                	mv	a1,s1
    3cb0:	00001517          	auipc	a0,0x1
    3cb4:	f5850513          	addi	a0,a0,-168 # 4c08 <malloc+0x38e>
    3cb8:	00001097          	auipc	ra,0x1
    3cbc:	b04080e7          	jalr	-1276(ra) # 47bc <printf>
    exit(1);
    3cc0:	4505                	li	a0,1
    3cc2:	00000097          	auipc	ra,0x0
    3cc6:	77a080e7          	jalr	1914(ra) # 443c <exit>
    printf("%s: chdir dir0 failed\n", s);
    3cca:	85a6                	mv	a1,s1
    3ccc:	00003517          	auipc	a0,0x3
    3cd0:	87450513          	addi	a0,a0,-1932 # 6540 <malloc+0x1cc6>
    3cd4:	00001097          	auipc	ra,0x1
    3cd8:	ae8080e7          	jalr	-1304(ra) # 47bc <printf>
    exit(1);
    3cdc:	4505                	li	a0,1
    3cde:	00000097          	auipc	ra,0x0
    3ce2:	75e080e7          	jalr	1886(ra) # 443c <exit>
    printf("%s: chdir .. failed\n", s);
    3ce6:	85a6                	mv	a1,s1
    3ce8:	00003517          	auipc	a0,0x3
    3cec:	87050513          	addi	a0,a0,-1936 # 6558 <malloc+0x1cde>
    3cf0:	00001097          	auipc	ra,0x1
    3cf4:	acc080e7          	jalr	-1332(ra) # 47bc <printf>
    exit(1);
    3cf8:	4505                	li	a0,1
    3cfa:	00000097          	auipc	ra,0x0
    3cfe:	742080e7          	jalr	1858(ra) # 443c <exit>
    printf("%s: unlink dir0 failed\n", s);
    3d02:	85a6                	mv	a1,s1
    3d04:	00003517          	auipc	a0,0x3
    3d08:	86c50513          	addi	a0,a0,-1940 # 6570 <malloc+0x1cf6>
    3d0c:	00001097          	auipc	ra,0x1
    3d10:	ab0080e7          	jalr	-1360(ra) # 47bc <printf>
    exit(1);
    3d14:	4505                	li	a0,1
    3d16:	00000097          	auipc	ra,0x0
    3d1a:	726080e7          	jalr	1830(ra) # 443c <exit>

0000000000003d1e <fsfull>:
{
    3d1e:	7171                	addi	sp,sp,-176
    3d20:	f506                	sd	ra,168(sp)
    3d22:	f122                	sd	s0,160(sp)
    3d24:	ed26                	sd	s1,152(sp)
    3d26:	e94a                	sd	s2,144(sp)
    3d28:	e54e                	sd	s3,136(sp)
    3d2a:	e152                	sd	s4,128(sp)
    3d2c:	fcd6                	sd	s5,120(sp)
    3d2e:	f8da                	sd	s6,112(sp)
    3d30:	f4de                	sd	s7,104(sp)
    3d32:	f0e2                	sd	s8,96(sp)
    3d34:	ece6                	sd	s9,88(sp)
    3d36:	e8ea                	sd	s10,80(sp)
    3d38:	e4ee                	sd	s11,72(sp)
    3d3a:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    3d3c:	00003517          	auipc	a0,0x3
    3d40:	86450513          	addi	a0,a0,-1948 # 65a0 <malloc+0x1d26>
    3d44:	00001097          	auipc	ra,0x1
    3d48:	a78080e7          	jalr	-1416(ra) # 47bc <printf>
  for(nfiles = 0; ; nfiles++){
    3d4c:	4481                	li	s1,0
    name[0] = 'f';
    3d4e:	06600d13          	li	s10,102
    name[1] = '0' + nfiles / 1000;
    3d52:	3e800c13          	li	s8,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3d56:	06400b93          	li	s7,100
    name[3] = '0' + (nfiles % 100) / 10;
    3d5a:	4b29                	li	s6,10
    printf("%s: writing %s\n", name);
    3d5c:	00003c97          	auipc	s9,0x3
    3d60:	854c8c93          	addi	s9,s9,-1964 # 65b0 <malloc+0x1d36>
    int total = 0;
    3d64:	4d81                	li	s11,0
      int cc = write(fd, buf, BSIZE);
    3d66:	00005a17          	auipc	s4,0x5
    3d6a:	4eaa0a13          	addi	s4,s4,1258 # 9250 <buf>
    name[0] = 'f';
    3d6e:	f5a40823          	sb	s10,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3d72:	0384c7bb          	divw	a5,s1,s8
    3d76:	0307879b          	addiw	a5,a5,48
    3d7a:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3d7e:	0384e7bb          	remw	a5,s1,s8
    3d82:	0377c7bb          	divw	a5,a5,s7
    3d86:	0307879b          	addiw	a5,a5,48
    3d8a:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3d8e:	0374e7bb          	remw	a5,s1,s7
    3d92:	0367c7bb          	divw	a5,a5,s6
    3d96:	0307879b          	addiw	a5,a5,48
    3d9a:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3d9e:	0364e7bb          	remw	a5,s1,s6
    3da2:	0307879b          	addiw	a5,a5,48
    3da6:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3daa:	f4040aa3          	sb	zero,-171(s0)
    printf("%s: writing %s\n", name);
    3dae:	f5040593          	addi	a1,s0,-176
    3db2:	8566                	mv	a0,s9
    3db4:	00001097          	auipc	ra,0x1
    3db8:	a08080e7          	jalr	-1528(ra) # 47bc <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    3dbc:	20200593          	li	a1,514
    3dc0:	f5040513          	addi	a0,s0,-176
    3dc4:	00000097          	auipc	ra,0x0
    3dc8:	6b8080e7          	jalr	1720(ra) # 447c <open>
    3dcc:	892a                	mv	s2,a0
    if(fd < 0){
    3dce:	0a055663          	bgez	a0,3e7a <fsfull+0x15c>
      printf("%s: open %s failed\n", name);
    3dd2:	f5040593          	addi	a1,s0,-176
    3dd6:	00002517          	auipc	a0,0x2
    3dda:	7ea50513          	addi	a0,a0,2026 # 65c0 <malloc+0x1d46>
    3dde:	00001097          	auipc	ra,0x1
    3de2:	9de080e7          	jalr	-1570(ra) # 47bc <printf>
  while(nfiles >= 0){
    3de6:	0604c363          	bltz	s1,3e4c <fsfull+0x12e>
    name[0] = 'f';
    3dea:	06600b13          	li	s6,102
    name[1] = '0' + nfiles / 1000;
    3dee:	3e800a13          	li	s4,1000
    name[2] = '0' + (nfiles % 1000) / 100;
    3df2:	06400993          	li	s3,100
    name[3] = '0' + (nfiles % 100) / 10;
    3df6:	4929                	li	s2,10
  while(nfiles >= 0){
    3df8:	5afd                	li	s5,-1
    name[0] = 'f';
    3dfa:	f5640823          	sb	s6,-176(s0)
    name[1] = '0' + nfiles / 1000;
    3dfe:	0344c7bb          	divw	a5,s1,s4
    3e02:	0307879b          	addiw	a5,a5,48
    3e06:	f4f408a3          	sb	a5,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    3e0a:	0344e7bb          	remw	a5,s1,s4
    3e0e:	0337c7bb          	divw	a5,a5,s3
    3e12:	0307879b          	addiw	a5,a5,48
    3e16:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    3e1a:	0334e7bb          	remw	a5,s1,s3
    3e1e:	0327c7bb          	divw	a5,a5,s2
    3e22:	0307879b          	addiw	a5,a5,48
    3e26:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    3e2a:	0324e7bb          	remw	a5,s1,s2
    3e2e:	0307879b          	addiw	a5,a5,48
    3e32:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    3e36:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    3e3a:	f5040513          	addi	a0,s0,-176
    3e3e:	00000097          	auipc	ra,0x0
    3e42:	64e080e7          	jalr	1614(ra) # 448c <unlink>
    nfiles--;
    3e46:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    3e48:	fb5499e3          	bne	s1,s5,3dfa <fsfull+0xdc>
  printf("fsfull test finished\n");
    3e4c:	00002517          	auipc	a0,0x2
    3e50:	7a450513          	addi	a0,a0,1956 # 65f0 <malloc+0x1d76>
    3e54:	00001097          	auipc	ra,0x1
    3e58:	968080e7          	jalr	-1688(ra) # 47bc <printf>
}
    3e5c:	70aa                	ld	ra,168(sp)
    3e5e:	740a                	ld	s0,160(sp)
    3e60:	64ea                	ld	s1,152(sp)
    3e62:	694a                	ld	s2,144(sp)
    3e64:	69aa                	ld	s3,136(sp)
    3e66:	6a0a                	ld	s4,128(sp)
    3e68:	7ae6                	ld	s5,120(sp)
    3e6a:	7b46                	ld	s6,112(sp)
    3e6c:	7ba6                	ld	s7,104(sp)
    3e6e:	7c06                	ld	s8,96(sp)
    3e70:	6ce6                	ld	s9,88(sp)
    3e72:	6d46                	ld	s10,80(sp)
    3e74:	6da6                	ld	s11,72(sp)
    3e76:	614d                	addi	sp,sp,176
    3e78:	8082                	ret
    int total = 0;
    3e7a:	89ee                	mv	s3,s11
      if(cc < BSIZE)
    3e7c:	3ff00a93          	li	s5,1023
      int cc = write(fd, buf, BSIZE);
    3e80:	40000613          	li	a2,1024
    3e84:	85d2                	mv	a1,s4
    3e86:	854a                	mv	a0,s2
    3e88:	00000097          	auipc	ra,0x0
    3e8c:	5d4080e7          	jalr	1492(ra) # 445c <write>
      if(cc < BSIZE)
    3e90:	00aad563          	bge	s5,a0,3e9a <fsfull+0x17c>
      total += cc;
    3e94:	00a989bb          	addw	s3,s3,a0
    while(1){
    3e98:	b7e5                	j	3e80 <fsfull+0x162>
    printf("%s: wrote %d bytes\n", total);
    3e9a:	85ce                	mv	a1,s3
    3e9c:	00002517          	auipc	a0,0x2
    3ea0:	73c50513          	addi	a0,a0,1852 # 65d8 <malloc+0x1d5e>
    3ea4:	00001097          	auipc	ra,0x1
    3ea8:	918080e7          	jalr	-1768(ra) # 47bc <printf>
    close(fd);
    3eac:	854a                	mv	a0,s2
    3eae:	00000097          	auipc	ra,0x0
    3eb2:	5b6080e7          	jalr	1462(ra) # 4464 <close>
    if(total == 0)
    3eb6:	f20988e3          	beqz	s3,3de6 <fsfull+0xc8>
  for(nfiles = 0; ; nfiles++){
    3eba:	2485                	addiw	s1,s1,1
    3ebc:	bd4d                	j	3d6e <fsfull+0x50>

0000000000003ebe <rand>:
{
    3ebe:	1141                	addi	sp,sp,-16
    3ec0:	e422                	sd	s0,8(sp)
    3ec2:	0800                	addi	s0,sp,16
  randstate = randstate * 1664525 + 1013904223;
    3ec4:	00003717          	auipc	a4,0x3
    3ec8:	b6470713          	addi	a4,a4,-1180 # 6a28 <randstate>
    3ecc:	6308                	ld	a0,0(a4)
    3ece:	001967b7          	lui	a5,0x196
    3ed2:	60d78793          	addi	a5,a5,1549 # 19660d <__BSS_END__+0x18a3ad>
    3ed6:	02f50533          	mul	a0,a0,a5
    3eda:	3c6ef7b7          	lui	a5,0x3c6ef
    3ede:	35f78793          	addi	a5,a5,863 # 3c6ef35f <__BSS_END__+0x3c6e30ff>
    3ee2:	953e                	add	a0,a0,a5
    3ee4:	e308                	sd	a0,0(a4)
}
    3ee6:	2501                	sext.w	a0,a0
    3ee8:	6422                	ld	s0,8(sp)
    3eea:	0141                	addi	sp,sp,16
    3eec:	8082                	ret

0000000000003eee <badwrite>:
{
    3eee:	7179                	addi	sp,sp,-48
    3ef0:	f406                	sd	ra,40(sp)
    3ef2:	f022                	sd	s0,32(sp)
    3ef4:	ec26                	sd	s1,24(sp)
    3ef6:	e84a                	sd	s2,16(sp)
    3ef8:	e44e                	sd	s3,8(sp)
    3efa:	e052                	sd	s4,0(sp)
    3efc:	1800                	addi	s0,sp,48
  unlink("junk");
    3efe:	00002517          	auipc	a0,0x2
    3f02:	70a50513          	addi	a0,a0,1802 # 6608 <malloc+0x1d8e>
    3f06:	00000097          	auipc	ra,0x0
    3f0a:	586080e7          	jalr	1414(ra) # 448c <unlink>
    3f0e:	25800913          	li	s2,600
    int fd = open("junk", O_CREATE|O_WRONLY);
    3f12:	00002997          	auipc	s3,0x2
    3f16:	6f698993          	addi	s3,s3,1782 # 6608 <malloc+0x1d8e>
    write(fd, (char*)0xffffffffffL, 1);
    3f1a:	5a7d                	li	s4,-1
    3f1c:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
    3f20:	20100593          	li	a1,513
    3f24:	854e                	mv	a0,s3
    3f26:	00000097          	auipc	ra,0x0
    3f2a:	556080e7          	jalr	1366(ra) # 447c <open>
    3f2e:	84aa                	mv	s1,a0
    if(fd < 0){
    3f30:	06054b63          	bltz	a0,3fa6 <badwrite+0xb8>
    write(fd, (char*)0xffffffffffL, 1);
    3f34:	4605                	li	a2,1
    3f36:	85d2                	mv	a1,s4
    3f38:	00000097          	auipc	ra,0x0
    3f3c:	524080e7          	jalr	1316(ra) # 445c <write>
    close(fd);
    3f40:	8526                	mv	a0,s1
    3f42:	00000097          	auipc	ra,0x0
    3f46:	522080e7          	jalr	1314(ra) # 4464 <close>
    unlink("junk");
    3f4a:	854e                	mv	a0,s3
    3f4c:	00000097          	auipc	ra,0x0
    3f50:	540080e7          	jalr	1344(ra) # 448c <unlink>
  for(int i = 0; i < assumed_free; i++){
    3f54:	397d                	addiw	s2,s2,-1
    3f56:	fc0915e3          	bnez	s2,3f20 <badwrite+0x32>
  int fd = open("junk", O_CREATE|O_WRONLY);
    3f5a:	20100593          	li	a1,513
    3f5e:	00002517          	auipc	a0,0x2
    3f62:	6aa50513          	addi	a0,a0,1706 # 6608 <malloc+0x1d8e>
    3f66:	00000097          	auipc	ra,0x0
    3f6a:	516080e7          	jalr	1302(ra) # 447c <open>
    3f6e:	84aa                	mv	s1,a0
  if(fd < 0){
    3f70:	04054863          	bltz	a0,3fc0 <badwrite+0xd2>
  if(write(fd, "x", 1) != 1){
    3f74:	4605                	li	a2,1
    3f76:	00001597          	auipc	a1,0x1
    3f7a:	7b258593          	addi	a1,a1,1970 # 5728 <malloc+0xeae>
    3f7e:	00000097          	auipc	ra,0x0
    3f82:	4de080e7          	jalr	1246(ra) # 445c <write>
    3f86:	4785                	li	a5,1
    3f88:	04f50963          	beq	a0,a5,3fda <badwrite+0xec>
    printf("write failed\n");
    3f8c:	00002517          	auipc	a0,0x2
    3f90:	69c50513          	addi	a0,a0,1692 # 6628 <malloc+0x1dae>
    3f94:	00001097          	auipc	ra,0x1
    3f98:	828080e7          	jalr	-2008(ra) # 47bc <printf>
    exit(1);
    3f9c:	4505                	li	a0,1
    3f9e:	00000097          	auipc	ra,0x0
    3fa2:	49e080e7          	jalr	1182(ra) # 443c <exit>
      printf("open junk failed\n");
    3fa6:	00002517          	auipc	a0,0x2
    3faa:	66a50513          	addi	a0,a0,1642 # 6610 <malloc+0x1d96>
    3fae:	00001097          	auipc	ra,0x1
    3fb2:	80e080e7          	jalr	-2034(ra) # 47bc <printf>
      exit(1);
    3fb6:	4505                	li	a0,1
    3fb8:	00000097          	auipc	ra,0x0
    3fbc:	484080e7          	jalr	1156(ra) # 443c <exit>
    printf("open junk failed\n");
    3fc0:	00002517          	auipc	a0,0x2
    3fc4:	65050513          	addi	a0,a0,1616 # 6610 <malloc+0x1d96>
    3fc8:	00000097          	auipc	ra,0x0
    3fcc:	7f4080e7          	jalr	2036(ra) # 47bc <printf>
    exit(1);
    3fd0:	4505                	li	a0,1
    3fd2:	00000097          	auipc	ra,0x0
    3fd6:	46a080e7          	jalr	1130(ra) # 443c <exit>
  close(fd);
    3fda:	8526                	mv	a0,s1
    3fdc:	00000097          	auipc	ra,0x0
    3fe0:	488080e7          	jalr	1160(ra) # 4464 <close>
  unlink("junk");
    3fe4:	00002517          	auipc	a0,0x2
    3fe8:	62450513          	addi	a0,a0,1572 # 6608 <malloc+0x1d8e>
    3fec:	00000097          	auipc	ra,0x0
    3ff0:	4a0080e7          	jalr	1184(ra) # 448c <unlink>
  exit(0);
    3ff4:	4501                	li	a0,0
    3ff6:	00000097          	auipc	ra,0x0
    3ffa:	446080e7          	jalr	1094(ra) # 443c <exit>

0000000000003ffe <run>:
}

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    3ffe:	7179                	addi	sp,sp,-48
    4000:	f406                	sd	ra,40(sp)
    4002:	f022                	sd	s0,32(sp)
    4004:	ec26                	sd	s1,24(sp)
    4006:	e84a                	sd	s2,16(sp)
    4008:	1800                	addi	s0,sp,48
    400a:	892a                	mv	s2,a0
    400c:	84ae                	mv	s1,a1
  int pid;
  int xstatus;
  
  printf("test %s: ", s);
    400e:	00002517          	auipc	a0,0x2
    4012:	62a50513          	addi	a0,a0,1578 # 6638 <malloc+0x1dbe>
    4016:	00000097          	auipc	ra,0x0
    401a:	7a6080e7          	jalr	1958(ra) # 47bc <printf>
  if((pid = fork()) < 0) {
    401e:	00000097          	auipc	ra,0x0
    4022:	416080e7          	jalr	1046(ra) # 4434 <fork>
    4026:	02054f63          	bltz	a0,4064 <run+0x66>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    402a:	c931                	beqz	a0,407e <run+0x80>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    402c:	fdc40513          	addi	a0,s0,-36
    4030:	00000097          	auipc	ra,0x0
    4034:	414080e7          	jalr	1044(ra) # 4444 <wait>
    if(xstatus != 0) 
    4038:	fdc42783          	lw	a5,-36(s0)
    403c:	cba1                	beqz	a5,408c <run+0x8e>
      printf("FAILED\n", s);
    403e:	85a6                	mv	a1,s1
    4040:	00002517          	auipc	a0,0x2
    4044:	62050513          	addi	a0,a0,1568 # 6660 <malloc+0x1de6>
    4048:	00000097          	auipc	ra,0x0
    404c:	774080e7          	jalr	1908(ra) # 47bc <printf>
    else
      printf("OK\n", s);
    return xstatus == 0;
    4050:	fdc42503          	lw	a0,-36(s0)
  }
}
    4054:	00153513          	seqz	a0,a0
    4058:	70a2                	ld	ra,40(sp)
    405a:	7402                	ld	s0,32(sp)
    405c:	64e2                	ld	s1,24(sp)
    405e:	6942                	ld	s2,16(sp)
    4060:	6145                	addi	sp,sp,48
    4062:	8082                	ret
    printf("runtest: fork error\n");
    4064:	00002517          	auipc	a0,0x2
    4068:	5e450513          	addi	a0,a0,1508 # 6648 <malloc+0x1dce>
    406c:	00000097          	auipc	ra,0x0
    4070:	750080e7          	jalr	1872(ra) # 47bc <printf>
    exit(1);
    4074:	4505                	li	a0,1
    4076:	00000097          	auipc	ra,0x0
    407a:	3c6080e7          	jalr	966(ra) # 443c <exit>
    f(s);
    407e:	8526                	mv	a0,s1
    4080:	9902                	jalr	s2
    exit(0);
    4082:	4501                	li	a0,0
    4084:	00000097          	auipc	ra,0x0
    4088:	3b8080e7          	jalr	952(ra) # 443c <exit>
      printf("OK\n", s);
    408c:	85a6                	mv	a1,s1
    408e:	00002517          	auipc	a0,0x2
    4092:	5da50513          	addi	a0,a0,1498 # 6668 <malloc+0x1dee>
    4096:	00000097          	auipc	ra,0x0
    409a:	726080e7          	jalr	1830(ra) # 47bc <printf>
    409e:	bf4d                	j	4050 <run+0x52>

00000000000040a0 <main>:

int
main(int argc, char *argv[])
{
    40a0:	ce010113          	addi	sp,sp,-800
    40a4:	30113c23          	sd	ra,792(sp)
    40a8:	30813823          	sd	s0,784(sp)
    40ac:	30913423          	sd	s1,776(sp)
    40b0:	31213023          	sd	s2,768(sp)
    40b4:	2f313c23          	sd	s3,760(sp)
    40b8:	2f413823          	sd	s4,752(sp)
    40bc:	1600                	addi	s0,sp,800
  char *n = 0;
  if(argc > 1) {
    40be:	4785                	li	a5,1
  char *n = 0;
    40c0:	4901                	li	s2,0
  if(argc > 1) {
    40c2:	00a7d463          	bge	a5,a0,40ca <main+0x2a>
    n = argv[1];
    40c6:	0085b903          	ld	s2,8(a1)
  }
  
  struct test {
    void (*f)(char *);
    char *s;
  } tests[] = {
    40ca:	00002797          	auipc	a5,0x2
    40ce:	64678793          	addi	a5,a5,1606 # 6710 <malloc+0x1e96>
    40d2:	ce040713          	addi	a4,s0,-800
    40d6:	00003817          	auipc	a6,0x3
    40da:	91a80813          	addi	a6,a6,-1766 # 69f0 <malloc+0x2176>
    40de:	6388                	ld	a0,0(a5)
    40e0:	678c                	ld	a1,8(a5)
    40e2:	6b90                	ld	a2,16(a5)
    40e4:	6f94                	ld	a3,24(a5)
    40e6:	e308                	sd	a0,0(a4)
    40e8:	e70c                	sd	a1,8(a4)
    40ea:	eb10                	sd	a2,16(a4)
    40ec:	ef14                	sd	a3,24(a4)
    40ee:	02078793          	addi	a5,a5,32
    40f2:	02070713          	addi	a4,a4,32
    40f6:	ff0794e3          	bne	a5,a6,40de <main+0x3e>
    40fa:	6394                	ld	a3,0(a5)
    40fc:	679c                	ld	a5,8(a5)
    40fe:	e314                	sd	a3,0(a4)
    4100:	e71c                	sd	a5,8(a4)
    {forktest, "forktest"},
    {bigdir, "bigdir"}, // slow
    { 0, 0},
  };
    
  printf("usertests starting\n");
    4102:	00002517          	auipc	a0,0x2
    4106:	56e50513          	addi	a0,a0,1390 # 6670 <malloc+0x1df6>
    410a:	00000097          	auipc	ra,0x0
    410e:	6b2080e7          	jalr	1714(ra) # 47bc <printf>

  if(open("usertests.ran", 0) >= 0){
    4112:	4581                	li	a1,0
    4114:	00002517          	auipc	a0,0x2
    4118:	57450513          	addi	a0,a0,1396 # 6688 <malloc+0x1e0e>
    411c:	00000097          	auipc	ra,0x0
    4120:	360080e7          	jalr	864(ra) # 447c <open>
    4124:	00054f63          	bltz	a0,4142 <main+0xa2>
    printf("already ran user tests -- rebuild fs.img (rm fs.img; make fs.img)\n");
    4128:	00002517          	auipc	a0,0x2
    412c:	57050513          	addi	a0,a0,1392 # 6698 <malloc+0x1e1e>
    4130:	00000097          	auipc	ra,0x0
    4134:	68c080e7          	jalr	1676(ra) # 47bc <printf>
    exit(1);
    4138:	4505                	li	a0,1
    413a:	00000097          	auipc	ra,0x0
    413e:	302080e7          	jalr	770(ra) # 443c <exit>
  }
  close(open("usertests.ran", O_CREATE));
    4142:	20000593          	li	a1,512
    4146:	00002517          	auipc	a0,0x2
    414a:	54250513          	addi	a0,a0,1346 # 6688 <malloc+0x1e0e>
    414e:	00000097          	auipc	ra,0x0
    4152:	32e080e7          	jalr	814(ra) # 447c <open>
    4156:	00000097          	auipc	ra,0x0
    415a:	30e080e7          	jalr	782(ra) # 4464 <close>

  int fail = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    415e:	ce843503          	ld	a0,-792(s0)
    4162:	c529                	beqz	a0,41ac <main+0x10c>
    4164:	ce040493          	addi	s1,s0,-800
  int fail = 0;
    4168:	4981                	li	s3,0
    if((n == 0) || strcmp(t->s, n) == 0) {
      if(!run(t->f, t->s))
        fail = 1;
    416a:	4a05                	li	s4,1
    416c:	a021                	j	4174 <main+0xd4>
  for (struct test *t = tests; t->s != 0; t++) {
    416e:	04c1                	addi	s1,s1,16
    4170:	6488                	ld	a0,8(s1)
    4172:	c115                	beqz	a0,4196 <main+0xf6>
    if((n == 0) || strcmp(t->s, n) == 0) {
    4174:	00090863          	beqz	s2,4184 <main+0xe4>
    4178:	85ca                	mv	a1,s2
    417a:	00000097          	auipc	ra,0x0
    417e:	068080e7          	jalr	104(ra) # 41e2 <strcmp>
    4182:	f575                	bnez	a0,416e <main+0xce>
      if(!run(t->f, t->s))
    4184:	648c                	ld	a1,8(s1)
    4186:	6088                	ld	a0,0(s1)
    4188:	00000097          	auipc	ra,0x0
    418c:	e76080e7          	jalr	-394(ra) # 3ffe <run>
    4190:	fd79                	bnez	a0,416e <main+0xce>
        fail = 1;
    4192:	89d2                	mv	s3,s4
    4194:	bfe9                	j	416e <main+0xce>
    }
  }
  if(!fail)
    4196:	00098b63          	beqz	s3,41ac <main+0x10c>
    printf("ALL TESTS PASSED\n");
  else
    printf("SOME TESTS FAILED\n");
    419a:	00002517          	auipc	a0,0x2
    419e:	55e50513          	addi	a0,a0,1374 # 66f8 <malloc+0x1e7e>
    41a2:	00000097          	auipc	ra,0x0
    41a6:	61a080e7          	jalr	1562(ra) # 47bc <printf>
    41aa:	a809                	j	41bc <main+0x11c>
    printf("ALL TESTS PASSED\n");
    41ac:	00002517          	auipc	a0,0x2
    41b0:	53450513          	addi	a0,a0,1332 # 66e0 <malloc+0x1e66>
    41b4:	00000097          	auipc	ra,0x0
    41b8:	608080e7          	jalr	1544(ra) # 47bc <printf>
  exit(1);   // not reached.
    41bc:	4505                	li	a0,1
    41be:	00000097          	auipc	ra,0x0
    41c2:	27e080e7          	jalr	638(ra) # 443c <exit>

00000000000041c6 <strcpy>:
#include "kernel/fcntl.h"
#include "user/user.h"

char*
strcpy(char *s, const char *t)
{
    41c6:	1141                	addi	sp,sp,-16
    41c8:	e422                	sd	s0,8(sp)
    41ca:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    41cc:	87aa                	mv	a5,a0
    41ce:	0585                	addi	a1,a1,1
    41d0:	0785                	addi	a5,a5,1
    41d2:	fff5c703          	lbu	a4,-1(a1)
    41d6:	fee78fa3          	sb	a4,-1(a5)
    41da:	fb75                	bnez	a4,41ce <strcpy+0x8>
    ;
  return os;
}
    41dc:	6422                	ld	s0,8(sp)
    41de:	0141                	addi	sp,sp,16
    41e0:	8082                	ret

00000000000041e2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    41e2:	1141                	addi	sp,sp,-16
    41e4:	e422                	sd	s0,8(sp)
    41e6:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    41e8:	00054783          	lbu	a5,0(a0)
    41ec:	cb91                	beqz	a5,4200 <strcmp+0x1e>
    41ee:	0005c703          	lbu	a4,0(a1)
    41f2:	00f71763          	bne	a4,a5,4200 <strcmp+0x1e>
    p++, q++;
    41f6:	0505                	addi	a0,a0,1
    41f8:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    41fa:	00054783          	lbu	a5,0(a0)
    41fe:	fbe5                	bnez	a5,41ee <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
    4200:	0005c503          	lbu	a0,0(a1)
}
    4204:	40a7853b          	subw	a0,a5,a0
    4208:	6422                	ld	s0,8(sp)
    420a:	0141                	addi	sp,sp,16
    420c:	8082                	ret

000000000000420e <strlen>:

uint
strlen(const char *s)
{
    420e:	1141                	addi	sp,sp,-16
    4210:	e422                	sd	s0,8(sp)
    4212:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4214:	00054783          	lbu	a5,0(a0)
    4218:	cf91                	beqz	a5,4234 <strlen+0x26>
    421a:	0505                	addi	a0,a0,1
    421c:	87aa                	mv	a5,a0
    421e:	4685                	li	a3,1
    4220:	9e89                	subw	a3,a3,a0
    4222:	00f6853b          	addw	a0,a3,a5
    4226:	0785                	addi	a5,a5,1
    4228:	fff7c703          	lbu	a4,-1(a5)
    422c:	fb7d                	bnez	a4,4222 <strlen+0x14>
    ;
  return n;
}
    422e:	6422                	ld	s0,8(sp)
    4230:	0141                	addi	sp,sp,16
    4232:	8082                	ret
  for(n = 0; s[n]; n++)
    4234:	4501                	li	a0,0
    4236:	bfe5                	j	422e <strlen+0x20>

0000000000004238 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4238:	1141                	addi	sp,sp,-16
    423a:	e422                	sd	s0,8(sp)
    423c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    423e:	ce09                	beqz	a2,4258 <memset+0x20>
    4240:	87aa                	mv	a5,a0
    4242:	fff6071b          	addiw	a4,a2,-1
    4246:	1702                	slli	a4,a4,0x20
    4248:	9301                	srli	a4,a4,0x20
    424a:	0705                	addi	a4,a4,1
    424c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    424e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4252:	0785                	addi	a5,a5,1
    4254:	fee79de3          	bne	a5,a4,424e <memset+0x16>
  }
  return dst;
}
    4258:	6422                	ld	s0,8(sp)
    425a:	0141                	addi	sp,sp,16
    425c:	8082                	ret

000000000000425e <strchr>:

char*
strchr(const char *s, char c)
{
    425e:	1141                	addi	sp,sp,-16
    4260:	e422                	sd	s0,8(sp)
    4262:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4264:	00054783          	lbu	a5,0(a0)
    4268:	cb99                	beqz	a5,427e <strchr+0x20>
    if(*s == c)
    426a:	00f58763          	beq	a1,a5,4278 <strchr+0x1a>
  for(; *s; s++)
    426e:	0505                	addi	a0,a0,1
    4270:	00054783          	lbu	a5,0(a0)
    4274:	fbfd                	bnez	a5,426a <strchr+0xc>
      return (char*)s;
  return 0;
    4276:	4501                	li	a0,0
}
    4278:	6422                	ld	s0,8(sp)
    427a:	0141                	addi	sp,sp,16
    427c:	8082                	ret
  return 0;
    427e:	4501                	li	a0,0
    4280:	bfe5                	j	4278 <strchr+0x1a>

0000000000004282 <gets>:

char*
gets(char *buf, int max)
{
    4282:	711d                	addi	sp,sp,-96
    4284:	ec86                	sd	ra,88(sp)
    4286:	e8a2                	sd	s0,80(sp)
    4288:	e4a6                	sd	s1,72(sp)
    428a:	e0ca                	sd	s2,64(sp)
    428c:	fc4e                	sd	s3,56(sp)
    428e:	f852                	sd	s4,48(sp)
    4290:	f456                	sd	s5,40(sp)
    4292:	f05a                	sd	s6,32(sp)
    4294:	ec5e                	sd	s7,24(sp)
    4296:	1080                	addi	s0,sp,96
    4298:	8baa                	mv	s7,a0
    429a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    429c:	892a                	mv	s2,a0
    429e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
    42a0:	4aa9                	li	s5,10
    42a2:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
    42a4:	89a6                	mv	s3,s1
    42a6:	2485                	addiw	s1,s1,1
    42a8:	0344d863          	bge	s1,s4,42d8 <gets+0x56>
    cc = read(0, &c, 1);
    42ac:	4605                	li	a2,1
    42ae:	faf40593          	addi	a1,s0,-81
    42b2:	4501                	li	a0,0
    42b4:	00000097          	auipc	ra,0x0
    42b8:	1a0080e7          	jalr	416(ra) # 4454 <read>
    if(cc < 1)
    42bc:	00a05e63          	blez	a0,42d8 <gets+0x56>
    buf[i++] = c;
    42c0:	faf44783          	lbu	a5,-81(s0)
    42c4:	00f90023          	sb	a5,0(s2) # 3000 <subdir+0x628>
    if(c == '\n' || c == '\r')
    42c8:	01578763          	beq	a5,s5,42d6 <gets+0x54>
    42cc:	0905                	addi	s2,s2,1
    42ce:	fd679be3          	bne	a5,s6,42a4 <gets+0x22>
  for(i=0; i+1 < max; ){
    42d2:	89a6                	mv	s3,s1
    42d4:	a011                	j	42d8 <gets+0x56>
    42d6:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
    42d8:	99de                	add	s3,s3,s7
    42da:	00098023          	sb	zero,0(s3)
  return buf;
}
    42de:	855e                	mv	a0,s7
    42e0:	60e6                	ld	ra,88(sp)
    42e2:	6446                	ld	s0,80(sp)
    42e4:	64a6                	ld	s1,72(sp)
    42e6:	6906                	ld	s2,64(sp)
    42e8:	79e2                	ld	s3,56(sp)
    42ea:	7a42                	ld	s4,48(sp)
    42ec:	7aa2                	ld	s5,40(sp)
    42ee:	7b02                	ld	s6,32(sp)
    42f0:	6be2                	ld	s7,24(sp)
    42f2:	6125                	addi	sp,sp,96
    42f4:	8082                	ret

00000000000042f6 <stat>:

int
stat(const char *n, struct stat *st)
{
    42f6:	1101                	addi	sp,sp,-32
    42f8:	ec06                	sd	ra,24(sp)
    42fa:	e822                	sd	s0,16(sp)
    42fc:	e426                	sd	s1,8(sp)
    42fe:	e04a                	sd	s2,0(sp)
    4300:	1000                	addi	s0,sp,32
    4302:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4304:	4581                	li	a1,0
    4306:	00000097          	auipc	ra,0x0
    430a:	176080e7          	jalr	374(ra) # 447c <open>
  if(fd < 0)
    430e:	02054563          	bltz	a0,4338 <stat+0x42>
    4312:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4314:	85ca                	mv	a1,s2
    4316:	00000097          	auipc	ra,0x0
    431a:	17e080e7          	jalr	382(ra) # 4494 <fstat>
    431e:	892a                	mv	s2,a0
  close(fd);
    4320:	8526                	mv	a0,s1
    4322:	00000097          	auipc	ra,0x0
    4326:	142080e7          	jalr	322(ra) # 4464 <close>
  return r;
}
    432a:	854a                	mv	a0,s2
    432c:	60e2                	ld	ra,24(sp)
    432e:	6442                	ld	s0,16(sp)
    4330:	64a2                	ld	s1,8(sp)
    4332:	6902                	ld	s2,0(sp)
    4334:	6105                	addi	sp,sp,32
    4336:	8082                	ret
    return -1;
    4338:	597d                	li	s2,-1
    433a:	bfc5                	j	432a <stat+0x34>

000000000000433c <atoi>:

int
atoi(const char *s)
{
    433c:	1141                	addi	sp,sp,-16
    433e:	e422                	sd	s0,8(sp)
    4340:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4342:	00054603          	lbu	a2,0(a0)
    4346:	fd06079b          	addiw	a5,a2,-48
    434a:	0ff7f793          	andi	a5,a5,255
    434e:	4725                	li	a4,9
    4350:	02f76963          	bltu	a4,a5,4382 <atoi+0x46>
    4354:	86aa                	mv	a3,a0
  n = 0;
    4356:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
    4358:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
    435a:	0685                	addi	a3,a3,1
    435c:	0025179b          	slliw	a5,a0,0x2
    4360:	9fa9                	addw	a5,a5,a0
    4362:	0017979b          	slliw	a5,a5,0x1
    4366:	9fb1                	addw	a5,a5,a2
    4368:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    436c:	0006c603          	lbu	a2,0(a3) # 1000 <writetest+0xc0>
    4370:	fd06071b          	addiw	a4,a2,-48
    4374:	0ff77713          	andi	a4,a4,255
    4378:	fee5f1e3          	bgeu	a1,a4,435a <atoi+0x1e>
  return n;
}
    437c:	6422                	ld	s0,8(sp)
    437e:	0141                	addi	sp,sp,16
    4380:	8082                	ret
  n = 0;
    4382:	4501                	li	a0,0
    4384:	bfe5                	j	437c <atoi+0x40>

0000000000004386 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4386:	1141                	addi	sp,sp,-16
    4388:	e422                	sd	s0,8(sp)
    438a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    438c:	02b57663          	bgeu	a0,a1,43b8 <memmove+0x32>
    while(n-- > 0)
    4390:	02c05163          	blez	a2,43b2 <memmove+0x2c>
    4394:	fff6079b          	addiw	a5,a2,-1
    4398:	1782                	slli	a5,a5,0x20
    439a:	9381                	srli	a5,a5,0x20
    439c:	0785                	addi	a5,a5,1
    439e:	97aa                	add	a5,a5,a0
  dst = vdst;
    43a0:	872a                	mv	a4,a0
      *dst++ = *src++;
    43a2:	0585                	addi	a1,a1,1
    43a4:	0705                	addi	a4,a4,1
    43a6:	fff5c683          	lbu	a3,-1(a1)
    43aa:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    43ae:	fee79ae3          	bne	a5,a4,43a2 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    43b2:	6422                	ld	s0,8(sp)
    43b4:	0141                	addi	sp,sp,16
    43b6:	8082                	ret
    dst += n;
    43b8:	00c50733          	add	a4,a0,a2
    src += n;
    43bc:	95b2                	add	a1,a1,a2
    while(n-- > 0)
    43be:	fec05ae3          	blez	a2,43b2 <memmove+0x2c>
    43c2:	fff6079b          	addiw	a5,a2,-1
    43c6:	1782                	slli	a5,a5,0x20
    43c8:	9381                	srli	a5,a5,0x20
    43ca:	fff7c793          	not	a5,a5
    43ce:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    43d0:	15fd                	addi	a1,a1,-1
    43d2:	177d                	addi	a4,a4,-1
    43d4:	0005c683          	lbu	a3,0(a1)
    43d8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    43dc:	fee79ae3          	bne	a5,a4,43d0 <memmove+0x4a>
    43e0:	bfc9                	j	43b2 <memmove+0x2c>

00000000000043e2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    43e2:	1141                	addi	sp,sp,-16
    43e4:	e422                	sd	s0,8(sp)
    43e6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    43e8:	ca05                	beqz	a2,4418 <memcmp+0x36>
    43ea:	fff6069b          	addiw	a3,a2,-1
    43ee:	1682                	slli	a3,a3,0x20
    43f0:	9281                	srli	a3,a3,0x20
    43f2:	0685                	addi	a3,a3,1
    43f4:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
    43f6:	00054783          	lbu	a5,0(a0)
    43fa:	0005c703          	lbu	a4,0(a1)
    43fe:	00e79863          	bne	a5,a4,440e <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
    4402:	0505                	addi	a0,a0,1
    p2++;
    4404:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4406:	fed518e3          	bne	a0,a3,43f6 <memcmp+0x14>
  }
  return 0;
    440a:	4501                	li	a0,0
    440c:	a019                	j	4412 <memcmp+0x30>
      return *p1 - *p2;
    440e:	40e7853b          	subw	a0,a5,a4
}
    4412:	6422                	ld	s0,8(sp)
    4414:	0141                	addi	sp,sp,16
    4416:	8082                	ret
  return 0;
    4418:	4501                	li	a0,0
    441a:	bfe5                	j	4412 <memcmp+0x30>

000000000000441c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    441c:	1141                	addi	sp,sp,-16
    441e:	e406                	sd	ra,8(sp)
    4420:	e022                	sd	s0,0(sp)
    4422:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4424:	00000097          	auipc	ra,0x0
    4428:	f62080e7          	jalr	-158(ra) # 4386 <memmove>
}
    442c:	60a2                	ld	ra,8(sp)
    442e:	6402                	ld	s0,0(sp)
    4430:	0141                	addi	sp,sp,16
    4432:	8082                	ret

0000000000004434 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4434:	4885                	li	a7,1
 ecall
    4436:	00000073          	ecall
 ret
    443a:	8082                	ret

000000000000443c <exit>:
.global exit
exit:
 li a7, SYS_exit
    443c:	4889                	li	a7,2
 ecall
    443e:	00000073          	ecall
 ret
    4442:	8082                	ret

0000000000004444 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4444:	488d                	li	a7,3
 ecall
    4446:	00000073          	ecall
 ret
    444a:	8082                	ret

000000000000444c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    444c:	4891                	li	a7,4
 ecall
    444e:	00000073          	ecall
 ret
    4452:	8082                	ret

0000000000004454 <read>:
.global read
read:
 li a7, SYS_read
    4454:	4895                	li	a7,5
 ecall
    4456:	00000073          	ecall
 ret
    445a:	8082                	ret

000000000000445c <write>:
.global write
write:
 li a7, SYS_write
    445c:	48c1                	li	a7,16
 ecall
    445e:	00000073          	ecall
 ret
    4462:	8082                	ret

0000000000004464 <close>:
.global close
close:
 li a7, SYS_close
    4464:	48d5                	li	a7,21
 ecall
    4466:	00000073          	ecall
 ret
    446a:	8082                	ret

000000000000446c <kill>:
.global kill
kill:
 li a7, SYS_kill
    446c:	4899                	li	a7,6
 ecall
    446e:	00000073          	ecall
 ret
    4472:	8082                	ret

0000000000004474 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4474:	489d                	li	a7,7
 ecall
    4476:	00000073          	ecall
 ret
    447a:	8082                	ret

000000000000447c <open>:
.global open
open:
 li a7, SYS_open
    447c:	48bd                	li	a7,15
 ecall
    447e:	00000073          	ecall
 ret
    4482:	8082                	ret

0000000000004484 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4484:	48c5                	li	a7,17
 ecall
    4486:	00000073          	ecall
 ret
    448a:	8082                	ret

000000000000448c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    448c:	48c9                	li	a7,18
 ecall
    448e:	00000073          	ecall
 ret
    4492:	8082                	ret

0000000000004494 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4494:	48a1                	li	a7,8
 ecall
    4496:	00000073          	ecall
 ret
    449a:	8082                	ret

000000000000449c <link>:
.global link
link:
 li a7, SYS_link
    449c:	48cd                	li	a7,19
 ecall
    449e:	00000073          	ecall
 ret
    44a2:	8082                	ret

00000000000044a4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    44a4:	48d1                	li	a7,20
 ecall
    44a6:	00000073          	ecall
 ret
    44aa:	8082                	ret

00000000000044ac <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    44ac:	48a5                	li	a7,9
 ecall
    44ae:	00000073          	ecall
 ret
    44b2:	8082                	ret

00000000000044b4 <dup>:
.global dup
dup:
 li a7, SYS_dup
    44b4:	48a9                	li	a7,10
 ecall
    44b6:	00000073          	ecall
 ret
    44ba:	8082                	ret

00000000000044bc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    44bc:	48ad                	li	a7,11
 ecall
    44be:	00000073          	ecall
 ret
    44c2:	8082                	ret

00000000000044c4 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
    44c4:	48b1                	li	a7,12
 ecall
    44c6:	00000073          	ecall
 ret
    44ca:	8082                	ret

00000000000044cc <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
    44cc:	48b5                	li	a7,13
 ecall
    44ce:	00000073          	ecall
 ret
    44d2:	8082                	ret

00000000000044d4 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    44d4:	48b9                	li	a7,14
 ecall
    44d6:	00000073          	ecall
 ret
    44da:	8082                	ret

00000000000044dc <ntas>:
.global ntas
ntas:
 li a7, SYS_ntas
    44dc:	48d9                	li	a7,22
 ecall
    44de:	00000073          	ecall
 ret
    44e2:	8082                	ret

00000000000044e4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    44e4:	1101                	addi	sp,sp,-32
    44e6:	ec06                	sd	ra,24(sp)
    44e8:	e822                	sd	s0,16(sp)
    44ea:	1000                	addi	s0,sp,32
    44ec:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    44f0:	4605                	li	a2,1
    44f2:	fef40593          	addi	a1,s0,-17
    44f6:	00000097          	auipc	ra,0x0
    44fa:	f66080e7          	jalr	-154(ra) # 445c <write>
}
    44fe:	60e2                	ld	ra,24(sp)
    4500:	6442                	ld	s0,16(sp)
    4502:	6105                	addi	sp,sp,32
    4504:	8082                	ret

0000000000004506 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    4506:	7139                	addi	sp,sp,-64
    4508:	fc06                	sd	ra,56(sp)
    450a:	f822                	sd	s0,48(sp)
    450c:	f426                	sd	s1,40(sp)
    450e:	f04a                	sd	s2,32(sp)
    4510:	ec4e                	sd	s3,24(sp)
    4512:	0080                	addi	s0,sp,64
    4514:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    4516:	c299                	beqz	a3,451c <printint+0x16>
    4518:	0805c863          	bltz	a1,45a8 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
    451c:	2581                	sext.w	a1,a1
  neg = 0;
    451e:	4881                	li	a7,0
    4520:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
    4524:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4526:	2601                	sext.w	a2,a2
    4528:	00002517          	auipc	a0,0x2
    452c:	4e050513          	addi	a0,a0,1248 # 6a08 <digits>
    4530:	883a                	mv	a6,a4
    4532:	2705                	addiw	a4,a4,1
    4534:	02c5f7bb          	remuw	a5,a1,a2
    4538:	1782                	slli	a5,a5,0x20
    453a:	9381                	srli	a5,a5,0x20
    453c:	97aa                	add	a5,a5,a0
    453e:	0007c783          	lbu	a5,0(a5)
    4542:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    4546:	0005879b          	sext.w	a5,a1
    454a:	02c5d5bb          	divuw	a1,a1,a2
    454e:	0685                	addi	a3,a3,1
    4550:	fec7f0e3          	bgeu	a5,a2,4530 <printint+0x2a>
  if(neg)
    4554:	00088b63          	beqz	a7,456a <printint+0x64>
    buf[i++] = '-';
    4558:	fd040793          	addi	a5,s0,-48
    455c:	973e                	add	a4,a4,a5
    455e:	02d00793          	li	a5,45
    4562:	fef70823          	sb	a5,-16(a4)
    4566:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    456a:	02e05863          	blez	a4,459a <printint+0x94>
    456e:	fc040793          	addi	a5,s0,-64
    4572:	00e78933          	add	s2,a5,a4
    4576:	fff78993          	addi	s3,a5,-1
    457a:	99ba                	add	s3,s3,a4
    457c:	377d                	addiw	a4,a4,-1
    457e:	1702                	slli	a4,a4,0x20
    4580:	9301                	srli	a4,a4,0x20
    4582:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    4586:	fff94583          	lbu	a1,-1(s2)
    458a:	8526                	mv	a0,s1
    458c:	00000097          	auipc	ra,0x0
    4590:	f58080e7          	jalr	-168(ra) # 44e4 <putc>
  while(--i >= 0)
    4594:	197d                	addi	s2,s2,-1
    4596:	ff3918e3          	bne	s2,s3,4586 <printint+0x80>
}
    459a:	70e2                	ld	ra,56(sp)
    459c:	7442                	ld	s0,48(sp)
    459e:	74a2                	ld	s1,40(sp)
    45a0:	7902                	ld	s2,32(sp)
    45a2:	69e2                	ld	s3,24(sp)
    45a4:	6121                	addi	sp,sp,64
    45a6:	8082                	ret
    x = -xx;
    45a8:	40b005bb          	negw	a1,a1
    neg = 1;
    45ac:	4885                	li	a7,1
    x = -xx;
    45ae:	bf8d                	j	4520 <printint+0x1a>

00000000000045b0 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    45b0:	7119                	addi	sp,sp,-128
    45b2:	fc86                	sd	ra,120(sp)
    45b4:	f8a2                	sd	s0,112(sp)
    45b6:	f4a6                	sd	s1,104(sp)
    45b8:	f0ca                	sd	s2,96(sp)
    45ba:	ecce                	sd	s3,88(sp)
    45bc:	e8d2                	sd	s4,80(sp)
    45be:	e4d6                	sd	s5,72(sp)
    45c0:	e0da                	sd	s6,64(sp)
    45c2:	fc5e                	sd	s7,56(sp)
    45c4:	f862                	sd	s8,48(sp)
    45c6:	f466                	sd	s9,40(sp)
    45c8:	f06a                	sd	s10,32(sp)
    45ca:	ec6e                	sd	s11,24(sp)
    45cc:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    45ce:	0005c903          	lbu	s2,0(a1)
    45d2:	18090f63          	beqz	s2,4770 <vprintf+0x1c0>
    45d6:	8aaa                	mv	s5,a0
    45d8:	8b32                	mv	s6,a2
    45da:	00158493          	addi	s1,a1,1
  state = 0;
    45de:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
    45e0:	02500a13          	li	s4,37
      if(c == 'd'){
    45e4:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
    45e8:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
    45ec:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
    45f0:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    45f4:	00002b97          	auipc	s7,0x2
    45f8:	414b8b93          	addi	s7,s7,1044 # 6a08 <digits>
    45fc:	a839                	j	461a <vprintf+0x6a>
        putc(fd, c);
    45fe:	85ca                	mv	a1,s2
    4600:	8556                	mv	a0,s5
    4602:	00000097          	auipc	ra,0x0
    4606:	ee2080e7          	jalr	-286(ra) # 44e4 <putc>
    460a:	a019                	j	4610 <vprintf+0x60>
    } else if(state == '%'){
    460c:	01498f63          	beq	s3,s4,462a <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
    4610:	0485                	addi	s1,s1,1
    4612:	fff4c903          	lbu	s2,-1(s1)
    4616:	14090d63          	beqz	s2,4770 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
    461a:	0009079b          	sext.w	a5,s2
    if(state == 0){
    461e:	fe0997e3          	bnez	s3,460c <vprintf+0x5c>
      if(c == '%'){
    4622:	fd479ee3          	bne	a5,s4,45fe <vprintf+0x4e>
        state = '%';
    4626:	89be                	mv	s3,a5
    4628:	b7e5                	j	4610 <vprintf+0x60>
      if(c == 'd'){
    462a:	05878063          	beq	a5,s8,466a <vprintf+0xba>
      } else if(c == 'l') {
    462e:	05978c63          	beq	a5,s9,4686 <vprintf+0xd6>
      } else if(c == 'x') {
    4632:	07a78863          	beq	a5,s10,46a2 <vprintf+0xf2>
      } else if(c == 'p') {
    4636:	09b78463          	beq	a5,s11,46be <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
    463a:	07300713          	li	a4,115
    463e:	0ce78663          	beq	a5,a4,470a <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    4642:	06300713          	li	a4,99
    4646:	0ee78e63          	beq	a5,a4,4742 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
    464a:	11478863          	beq	a5,s4,475a <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    464e:	85d2                	mv	a1,s4
    4650:	8556                	mv	a0,s5
    4652:	00000097          	auipc	ra,0x0
    4656:	e92080e7          	jalr	-366(ra) # 44e4 <putc>
        putc(fd, c);
    465a:	85ca                	mv	a1,s2
    465c:	8556                	mv	a0,s5
    465e:	00000097          	auipc	ra,0x0
    4662:	e86080e7          	jalr	-378(ra) # 44e4 <putc>
      }
      state = 0;
    4666:	4981                	li	s3,0
    4668:	b765                	j	4610 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
    466a:	008b0913          	addi	s2,s6,8
    466e:	4685                	li	a3,1
    4670:	4629                	li	a2,10
    4672:	000b2583          	lw	a1,0(s6)
    4676:	8556                	mv	a0,s5
    4678:	00000097          	auipc	ra,0x0
    467c:	e8e080e7          	jalr	-370(ra) # 4506 <printint>
    4680:	8b4a                	mv	s6,s2
      state = 0;
    4682:	4981                	li	s3,0
    4684:	b771                	j	4610 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
    4686:	008b0913          	addi	s2,s6,8
    468a:	4681                	li	a3,0
    468c:	4629                	li	a2,10
    468e:	000b2583          	lw	a1,0(s6)
    4692:	8556                	mv	a0,s5
    4694:	00000097          	auipc	ra,0x0
    4698:	e72080e7          	jalr	-398(ra) # 4506 <printint>
    469c:	8b4a                	mv	s6,s2
      state = 0;
    469e:	4981                	li	s3,0
    46a0:	bf85                	j	4610 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
    46a2:	008b0913          	addi	s2,s6,8
    46a6:	4681                	li	a3,0
    46a8:	4641                	li	a2,16
    46aa:	000b2583          	lw	a1,0(s6)
    46ae:	8556                	mv	a0,s5
    46b0:	00000097          	auipc	ra,0x0
    46b4:	e56080e7          	jalr	-426(ra) # 4506 <printint>
    46b8:	8b4a                	mv	s6,s2
      state = 0;
    46ba:	4981                	li	s3,0
    46bc:	bf91                	j	4610 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
    46be:	008b0793          	addi	a5,s6,8
    46c2:	f8f43423          	sd	a5,-120(s0)
    46c6:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
    46ca:	03000593          	li	a1,48
    46ce:	8556                	mv	a0,s5
    46d0:	00000097          	auipc	ra,0x0
    46d4:	e14080e7          	jalr	-492(ra) # 44e4 <putc>
  putc(fd, 'x');
    46d8:	85ea                	mv	a1,s10
    46da:	8556                	mv	a0,s5
    46dc:	00000097          	auipc	ra,0x0
    46e0:	e08080e7          	jalr	-504(ra) # 44e4 <putc>
    46e4:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    46e6:	03c9d793          	srli	a5,s3,0x3c
    46ea:	97de                	add	a5,a5,s7
    46ec:	0007c583          	lbu	a1,0(a5)
    46f0:	8556                	mv	a0,s5
    46f2:	00000097          	auipc	ra,0x0
    46f6:	df2080e7          	jalr	-526(ra) # 44e4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    46fa:	0992                	slli	s3,s3,0x4
    46fc:	397d                	addiw	s2,s2,-1
    46fe:	fe0914e3          	bnez	s2,46e6 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
    4702:	f8843b03          	ld	s6,-120(s0)
      state = 0;
    4706:	4981                	li	s3,0
    4708:	b721                	j	4610 <vprintf+0x60>
        s = va_arg(ap, char*);
    470a:	008b0993          	addi	s3,s6,8
    470e:	000b3903          	ld	s2,0(s6)
        if(s == 0)
    4712:	02090163          	beqz	s2,4734 <vprintf+0x184>
        while(*s != 0){
    4716:	00094583          	lbu	a1,0(s2)
    471a:	c9a1                	beqz	a1,476a <vprintf+0x1ba>
          putc(fd, *s);
    471c:	8556                	mv	a0,s5
    471e:	00000097          	auipc	ra,0x0
    4722:	dc6080e7          	jalr	-570(ra) # 44e4 <putc>
          s++;
    4726:	0905                	addi	s2,s2,1
        while(*s != 0){
    4728:	00094583          	lbu	a1,0(s2)
    472c:	f9e5                	bnez	a1,471c <vprintf+0x16c>
        s = va_arg(ap, char*);
    472e:	8b4e                	mv	s6,s3
      state = 0;
    4730:	4981                	li	s3,0
    4732:	bdf9                	j	4610 <vprintf+0x60>
          s = "(null)";
    4734:	00002917          	auipc	s2,0x2
    4738:	2cc90913          	addi	s2,s2,716 # 6a00 <malloc+0x2186>
        while(*s != 0){
    473c:	02800593          	li	a1,40
    4740:	bff1                	j	471c <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
    4742:	008b0913          	addi	s2,s6,8
    4746:	000b4583          	lbu	a1,0(s6)
    474a:	8556                	mv	a0,s5
    474c:	00000097          	auipc	ra,0x0
    4750:	d98080e7          	jalr	-616(ra) # 44e4 <putc>
    4754:	8b4a                	mv	s6,s2
      state = 0;
    4756:	4981                	li	s3,0
    4758:	bd65                	j	4610 <vprintf+0x60>
        putc(fd, c);
    475a:	85d2                	mv	a1,s4
    475c:	8556                	mv	a0,s5
    475e:	00000097          	auipc	ra,0x0
    4762:	d86080e7          	jalr	-634(ra) # 44e4 <putc>
      state = 0;
    4766:	4981                	li	s3,0
    4768:	b565                	j	4610 <vprintf+0x60>
        s = va_arg(ap, char*);
    476a:	8b4e                	mv	s6,s3
      state = 0;
    476c:	4981                	li	s3,0
    476e:	b54d                	j	4610 <vprintf+0x60>
    }
  }
}
    4770:	70e6                	ld	ra,120(sp)
    4772:	7446                	ld	s0,112(sp)
    4774:	74a6                	ld	s1,104(sp)
    4776:	7906                	ld	s2,96(sp)
    4778:	69e6                	ld	s3,88(sp)
    477a:	6a46                	ld	s4,80(sp)
    477c:	6aa6                	ld	s5,72(sp)
    477e:	6b06                	ld	s6,64(sp)
    4780:	7be2                	ld	s7,56(sp)
    4782:	7c42                	ld	s8,48(sp)
    4784:	7ca2                	ld	s9,40(sp)
    4786:	7d02                	ld	s10,32(sp)
    4788:	6de2                	ld	s11,24(sp)
    478a:	6109                	addi	sp,sp,128
    478c:	8082                	ret

000000000000478e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    478e:	715d                	addi	sp,sp,-80
    4790:	ec06                	sd	ra,24(sp)
    4792:	e822                	sd	s0,16(sp)
    4794:	1000                	addi	s0,sp,32
    4796:	e010                	sd	a2,0(s0)
    4798:	e414                	sd	a3,8(s0)
    479a:	e818                	sd	a4,16(s0)
    479c:	ec1c                	sd	a5,24(s0)
    479e:	03043023          	sd	a6,32(s0)
    47a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    47a6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    47aa:	8622                	mv	a2,s0
    47ac:	00000097          	auipc	ra,0x0
    47b0:	e04080e7          	jalr	-508(ra) # 45b0 <vprintf>
}
    47b4:	60e2                	ld	ra,24(sp)
    47b6:	6442                	ld	s0,16(sp)
    47b8:	6161                	addi	sp,sp,80
    47ba:	8082                	ret

00000000000047bc <printf>:

void
printf(const char *fmt, ...)
{
    47bc:	711d                	addi	sp,sp,-96
    47be:	ec06                	sd	ra,24(sp)
    47c0:	e822                	sd	s0,16(sp)
    47c2:	1000                	addi	s0,sp,32
    47c4:	e40c                	sd	a1,8(s0)
    47c6:	e810                	sd	a2,16(s0)
    47c8:	ec14                	sd	a3,24(s0)
    47ca:	f018                	sd	a4,32(s0)
    47cc:	f41c                	sd	a5,40(s0)
    47ce:	03043823          	sd	a6,48(s0)
    47d2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    47d6:	00840613          	addi	a2,s0,8
    47da:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    47de:	85aa                	mv	a1,a0
    47e0:	4505                	li	a0,1
    47e2:	00000097          	auipc	ra,0x0
    47e6:	dce080e7          	jalr	-562(ra) # 45b0 <vprintf>
}
    47ea:	60e2                	ld	ra,24(sp)
    47ec:	6442                	ld	s0,16(sp)
    47ee:	6125                	addi	sp,sp,96
    47f0:	8082                	ret

00000000000047f2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    47f2:	1141                	addi	sp,sp,-16
    47f4:	e422                	sd	s0,8(sp)
    47f6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    47f8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    47fc:	00002797          	auipc	a5,0x2
    4800:	23c7b783          	ld	a5,572(a5) # 6a38 <freep>
    4804:	a805                	j	4834 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
    4806:	4618                	lw	a4,8(a2)
    4808:	9db9                	addw	a1,a1,a4
    480a:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    480e:	6398                	ld	a4,0(a5)
    4810:	6318                	ld	a4,0(a4)
    4812:	fee53823          	sd	a4,-16(a0)
    4816:	a091                	j	485a <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
    4818:	ff852703          	lw	a4,-8(a0)
    481c:	9e39                	addw	a2,a2,a4
    481e:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    4820:	ff053703          	ld	a4,-16(a0)
    4824:	e398                	sd	a4,0(a5)
    4826:	a099                	j	486c <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    4828:	6398                	ld	a4,0(a5)
    482a:	00e7e463          	bltu	a5,a4,4832 <free+0x40>
    482e:	00e6ea63          	bltu	a3,a4,4842 <free+0x50>
{
    4832:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    4834:	fed7fae3          	bgeu	a5,a3,4828 <free+0x36>
    4838:	6398                	ld	a4,0(a5)
    483a:	00e6e463          	bltu	a3,a4,4842 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    483e:	fee7eae3          	bltu	a5,a4,4832 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    4842:	ff852583          	lw	a1,-8(a0)
    4846:	6390                	ld	a2,0(a5)
    4848:	02059713          	slli	a4,a1,0x20
    484c:	9301                	srli	a4,a4,0x20
    484e:	0712                	slli	a4,a4,0x4
    4850:	9736                	add	a4,a4,a3
    4852:	fae60ae3          	beq	a2,a4,4806 <free+0x14>
    bp->s.ptr = p->s.ptr;
    4856:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    485a:	4790                	lw	a2,8(a5)
    485c:	02061713          	slli	a4,a2,0x20
    4860:	9301                	srli	a4,a4,0x20
    4862:	0712                	slli	a4,a4,0x4
    4864:	973e                	add	a4,a4,a5
    4866:	fae689e3          	beq	a3,a4,4818 <free+0x26>
  } else
    p->s.ptr = bp;
    486a:	e394                	sd	a3,0(a5)
  freep = p;
    486c:	00002717          	auipc	a4,0x2
    4870:	1cf73623          	sd	a5,460(a4) # 6a38 <freep>
}
    4874:	6422                	ld	s0,8(sp)
    4876:	0141                	addi	sp,sp,16
    4878:	8082                	ret

000000000000487a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    487a:	7139                	addi	sp,sp,-64
    487c:	fc06                	sd	ra,56(sp)
    487e:	f822                	sd	s0,48(sp)
    4880:	f426                	sd	s1,40(sp)
    4882:	f04a                	sd	s2,32(sp)
    4884:	ec4e                	sd	s3,24(sp)
    4886:	e852                	sd	s4,16(sp)
    4888:	e456                	sd	s5,8(sp)
    488a:	e05a                	sd	s6,0(sp)
    488c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    488e:	02051493          	slli	s1,a0,0x20
    4892:	9081                	srli	s1,s1,0x20
    4894:	04bd                	addi	s1,s1,15
    4896:	8091                	srli	s1,s1,0x4
    4898:	0014899b          	addiw	s3,s1,1
    489c:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    489e:	00002517          	auipc	a0,0x2
    48a2:	19a53503          	ld	a0,410(a0) # 6a38 <freep>
    48a6:	c515                	beqz	a0,48d2 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    48a8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    48aa:	4798                	lw	a4,8(a5)
    48ac:	02977f63          	bgeu	a4,s1,48ea <malloc+0x70>
    48b0:	8a4e                	mv	s4,s3
    48b2:	0009871b          	sext.w	a4,s3
    48b6:	6685                	lui	a3,0x1
    48b8:	00d77363          	bgeu	a4,a3,48be <malloc+0x44>
    48bc:	6a05                	lui	s4,0x1
    48be:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    48c2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    48c6:	00002917          	auipc	s2,0x2
    48ca:	17290913          	addi	s2,s2,370 # 6a38 <freep>
  if(p == (char*)-1)
    48ce:	5afd                	li	s5,-1
    48d0:	a88d                	j	4942 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    48d2:	00008797          	auipc	a5,0x8
    48d6:	97e78793          	addi	a5,a5,-1666 # c250 <base>
    48da:	00002717          	auipc	a4,0x2
    48de:	14f73f23          	sd	a5,350(a4) # 6a38 <freep>
    48e2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    48e4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    48e8:	b7e1                	j	48b0 <malloc+0x36>
      if(p->s.size == nunits)
    48ea:	02e48b63          	beq	s1,a4,4920 <malloc+0xa6>
        p->s.size -= nunits;
    48ee:	4137073b          	subw	a4,a4,s3
    48f2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    48f4:	1702                	slli	a4,a4,0x20
    48f6:	9301                	srli	a4,a4,0x20
    48f8:	0712                	slli	a4,a4,0x4
    48fa:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    48fc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    4900:	00002717          	auipc	a4,0x2
    4904:	12a73c23          	sd	a0,312(a4) # 6a38 <freep>
      return (void*)(p + 1);
    4908:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    490c:	70e2                	ld	ra,56(sp)
    490e:	7442                	ld	s0,48(sp)
    4910:	74a2                	ld	s1,40(sp)
    4912:	7902                	ld	s2,32(sp)
    4914:	69e2                	ld	s3,24(sp)
    4916:	6a42                	ld	s4,16(sp)
    4918:	6aa2                	ld	s5,8(sp)
    491a:	6b02                	ld	s6,0(sp)
    491c:	6121                	addi	sp,sp,64
    491e:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    4920:	6398                	ld	a4,0(a5)
    4922:	e118                	sd	a4,0(a0)
    4924:	bff1                	j	4900 <malloc+0x86>
  hp->s.size = nu;
    4926:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    492a:	0541                	addi	a0,a0,16
    492c:	00000097          	auipc	ra,0x0
    4930:	ec6080e7          	jalr	-314(ra) # 47f2 <free>
  return freep;
    4934:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    4938:	d971                	beqz	a0,490c <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    493a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    493c:	4798                	lw	a4,8(a5)
    493e:	fa9776e3          	bgeu	a4,s1,48ea <malloc+0x70>
    if(p == freep)
    4942:	00093703          	ld	a4,0(s2)
    4946:	853e                	mv	a0,a5
    4948:	fef719e3          	bne	a4,a5,493a <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    494c:	8552                	mv	a0,s4
    494e:	00000097          	auipc	ra,0x0
    4952:	b76080e7          	jalr	-1162(ra) # 44c4 <sbrk>
  if(p == (char*)-1)
    4956:	fd5518e3          	bne	a0,s5,4926 <malloc+0xac>
        return 0;
    495a:	4501                	li	a0,0
    495c:	bf45                	j	490c <malloc+0x92>
