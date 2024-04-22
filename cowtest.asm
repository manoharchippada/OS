
_cowtest:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    printf(1, "[prnt] v4 = %d\n", v4);
    printf(1, "=====> v1 = v4 ? %s\n", v1 == v4 ? "YES" : "NO");
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);
}

int main(){
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	push   -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 0c             	sub    $0xc,%esp
    printf(1, ">>>>>>>>>>>>>>>>> WITHOUT COW <<<<<<<<<<<<<<<<<<<<<<\n");
  11:	68 14 0e 00 00       	push   $0xe14
  16:	6a 01                	push   $0x1
  18:	e8 13 08 00 00       	call   830 <printf>
    enable_cow(0);
  1d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  24:	e8 4a 07 00 00       	call   773 <enable_cow>
    testcase1();
  29:	e8 62 03 00 00       	call   390 <testcase1>
    testcase2();
  2e:	e8 fd 01 00 00       	call   230 <testcase2>
    testcase3();
  33:	e8 38 00 00 00       	call   70 <testcase3>

    printf(1, "\n\n>>>>>>>>>>>>>>>>> WITH COW <<<<<<<<<<<<<<<<<<<<<<\n");    enable_cow(1);
  38:	58                   	pop    %eax
  39:	5a                   	pop    %edx
  3a:	68 4c 0e 00 00       	push   $0xe4c
  3f:	6a 01                	push   $0x1
  41:	e8 ea 07 00 00       	call   830 <printf>
  46:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  4d:	e8 21 07 00 00       	call   773 <enable_cow>
    testcase1();
  52:	e8 39 03 00 00       	call   390 <testcase1>
    testcase2();
  57:	e8 d4 01 00 00       	call   230 <testcase2>
    testcase3();
  5c:	e8 0f 00 00 00       	call   70 <testcase3>
    exit();
  61:	e8 5d 06 00 00       	call   6c3 <exit>
  66:	66 90                	xchg   %ax,%ax
  68:	66 90                	xchg   %ax,%ax
  6a:	66 90                	xchg   %ax,%ax
  6c:	66 90                	xchg   %ax,%ax
  6e:	66 90                	xchg   %ax,%ax

00000070 <testcase3>:
void testcase3(){
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	57                   	push   %edi
  74:	56                   	push   %esi
  75:	53                   	push   %ebx
  76:	83 ec 24             	sub    $0x24,%esp
    printf(1,"\n----- Test case 3 -----\n");
  79:	68 5f 0b 00 00       	push   $0xb5f
  7e:	6a 01                	push   $0x1
  80:	e8 ab 07 00 00       	call   830 <printf>
    v1 = get_free_frame_cnt();
  85:	e8 e1 06 00 00       	call   76b <get_free_frame_cnt>
    printf(1,"[prnt] v1 = %d\n", v1);
  8a:	83 c4 0c             	add    $0xc,%esp
  8d:	50                   	push   %eax
    v1 = get_free_frame_cnt();
  8e:	89 c3                	mov    %eax,%ebx
    printf(1,"[prnt] v1 = %d\n", v1);
  90:	68 79 0b 00 00       	push   $0xb79
  95:	6a 01                	push   $0x1
  97:	e8 94 07 00 00       	call   830 <printf>
    if((pid = fork()) == 0)
  9c:	e8 1a 06 00 00       	call   6bb <fork>
  a1:	83 c4 10             	add    $0x10,%esp
  a4:	85 c0                	test   %eax,%eax
  a6:	0f 84 c8 00 00 00    	je     174 <testcase3+0x104>
  ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        v2 = get_free_frame_cnt();
  af:	e8 b7 06 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[prnt] v2 = %d\n", v2);
  b4:	83 ec 04             	sub    $0x4,%esp
  b7:	50                   	push   %eax
        v2 = get_free_frame_cnt();
  b8:	89 c6                	mov    %eax,%esi
        printf(1,"[prnt] v2 = %d\n", v2);
  ba:	68 ce 0b 00 00       	push   $0xbce
  bf:	6a 01                	push   $0x1
  c1:	e8 6a 07 00 00       	call   830 <printf>
        printf(1,"[prnt] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
  c6:	83 c4 0c             	add    $0xc,%esp
        global_array[0] = 111;     
  c9:	c7 05 40 12 00 00 6f 	movl   $0x6f,0x1240
  d0:	00 00 00 
        printf(1,"[prnt] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
  d3:	6a 6f                	push   $0x6f
  d5:	68 7c 0d 00 00       	push   $0xd7c
  da:	6a 01                	push   $0x1
  dc:	e8 4f 07 00 00       	call   830 <printf>
        v3 = get_free_frame_cnt();
  e1:	e8 85 06 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[prnt] v3 = %d\n", v3);
  e6:	83 c4 0c             	add    $0xc,%esp
  e9:	50                   	push   %eax
        v3 = get_free_frame_cnt();
  ea:	89 c7                	mov    %eax,%edi
        printf(1,"[prnt] v3 = %d\n", v3);
  ec:	68 de 0b 00 00       	push   $0xbde
  f1:	6a 01                	push   $0x1
  f3:	e8 38 07 00 00       	call   830 <printf>
    if (wait() != pid)
  f8:	e8 ce 05 00 00       	call   6cb <wait>
  fd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
 100:	83 c4 10             	add    $0x10,%esp
 103:	39 d0                	cmp    %edx,%eax
 105:	0f 85 09 01 00 00    	jne    214 <testcase3+0x1a4>
    v7 = get_free_frame_cnt();
 10b:	e8 5b 06 00 00       	call   76b <get_free_frame_cnt>
    printf(1, "[prnt] v7 = %d\n", v7);
 110:	83 ec 04             	sub    $0x4,%esp
 113:	50                   	push   %eax
 114:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 117:	68 fc 0b 00 00       	push   $0xbfc
 11c:	6a 01                	push   $0x1
 11e:	e8 0d 07 00 00       	call   830 <printf>
    printf(1, "=====> v1 = v7 ? %s\n", v1 == v7 ? "YES" : "NO");
 123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 126:	83 c4 0c             	add    $0xc,%esp
 129:	ba 5c 0b 00 00       	mov    $0xb5c,%edx
 12e:	39 c3                	cmp    %eax,%ebx
 130:	b8 58 0b 00 00       	mov    $0xb58,%eax
 135:	0f 45 c2             	cmovne %edx,%eax
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 138:	29 f3                	sub    %esi,%ebx
    printf(1, "=====> v2 - v3 = %d\n", v2 - v3);    
 13a:	29 fe                	sub    %edi,%esi
    printf(1, "=====> v1 = v7 ? %s\n", v1 == v7 ? "YES" : "NO");
 13c:	50                   	push   %eax
 13d:	68 0c 0c 00 00       	push   $0xc0c
 142:	6a 01                	push   $0x1
 144:	e8 e7 06 00 00       	call   830 <printf>
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 149:	83 c4 0c             	add    $0xc,%esp
 14c:	53                   	push   %ebx
 14d:	68 21 0c 00 00       	push   $0xc21
 152:	6a 01                	push   $0x1
 154:	e8 d7 06 00 00       	call   830 <printf>
    printf(1, "=====> v2 - v3 = %d\n", v2 - v3);    
 159:	83 c4 0c             	add    $0xc,%esp
 15c:	56                   	push   %esi
 15d:	68 36 0c 00 00       	push   $0xc36
 162:	6a 01                	push   $0x1
 164:	e8 c7 06 00 00       	call   830 <printf>
}
 169:	83 c4 10             	add    $0x10,%esp
 16c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16f:	5b                   	pop    %ebx
 170:	5e                   	pop    %esi
 171:	5f                   	pop    %edi
 172:	5d                   	pop    %ebp
 173:	c3                   	ret
        sleep(100);
 174:	83 ec 0c             	sub    $0xc,%esp
 177:	6a 64                	push   $0x64
 179:	e8 d5 05 00 00       	call   753 <sleep>
        v4 = get_free_frame_cnt();
 17e:	e8 e8 05 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[chld] v4 = %d\n", v4);
 183:	83 c4 0c             	add    $0xc,%esp
 186:	50                   	push   %eax
 187:	68 89 0b 00 00       	push   $0xb89
 18c:	6a 01                	push   $0x1
 18e:	e8 9d 06 00 00       	call   830 <printf>
        printf(1,"[chld] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 193:	83 c4 0c             	add    $0xc,%esp
        global_array[0] = 222;
 196:	c7 05 40 12 00 00 de 	movl   $0xde,0x1240
 19d:	00 00 00 
        printf(1,"[chld] modified one element in the 1st page, global_array[0]=%d\n", global_array[0]);
 1a0:	68 de 00 00 00       	push   $0xde
 1a5:	68 f0 0c 00 00       	push   $0xcf0
 1aa:	6a 01                	push   $0x1
 1ac:	e8 7f 06 00 00       	call   830 <printf>
        v5 = get_free_frame_cnt();
 1b1:	e8 b5 05 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[chld] v5 = %d\n", v5);
 1b6:	83 c4 0c             	add    $0xc,%esp
 1b9:	50                   	push   %eax
        v5 = get_free_frame_cnt();
 1ba:	89 c3                	mov    %eax,%ebx
        printf(1,"[chld] v5 = %d\n", v5);
 1bc:	68 99 0b 00 00       	push   $0xb99
 1c1:	6a 01                	push   $0x1
 1c3:	e8 68 06 00 00       	call   830 <printf>
        printf(1,"[chld] modified two elements in the 2nd page, global_array[2047]=%d\n", global_array[2047]);
 1c8:	83 c4 0c             	add    $0xc,%esp
        global_array[2047] = 333;           
 1cb:	c7 05 3c 32 00 00 4d 	movl   $0x14d,0x323c
 1d2:	01 00 00 
        printf(1,"[chld] modified two elements in the 2nd page, global_array[2047]=%d\n", global_array[2047]);
 1d5:	68 4d 01 00 00       	push   $0x14d
 1da:	68 34 0d 00 00       	push   $0xd34
 1df:	6a 01                	push   $0x1
 1e1:	e8 4a 06 00 00       	call   830 <printf>
        v6 = get_free_frame_cnt();
 1e6:	e8 80 05 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[chld] v6 = %d\n", v6);
 1eb:	83 c4 0c             	add    $0xc,%esp
 1ee:	50                   	push   %eax
        v6 = get_free_frame_cnt();
 1ef:	89 c6                	mov    %eax,%esi
        printf(1,"[chld] v6 = %d\n", v6);
 1f1:	68 a9 0b 00 00       	push   $0xba9
        printf(1, "=====> v5 - v6 = %d\n", v5 - v6);    
 1f6:	29 f3                	sub    %esi,%ebx
        printf(1,"[chld] v6 = %d\n", v6);
 1f8:	6a 01                	push   $0x1
 1fa:	e8 31 06 00 00       	call   830 <printf>
        printf(1, "=====> v5 - v6 = %d\n", v5 - v6);    
 1ff:	83 c4 0c             	add    $0xc,%esp
 202:	53                   	push   %ebx
 203:	68 b9 0b 00 00       	push   $0xbb9
 208:	6a 01                	push   $0x1
 20a:	e8 21 06 00 00       	call   830 <printf>
        exit();
 20f:	e8 af 04 00 00       	call   6c3 <exit>
        printf(1,"wait() error!");
 214:	50                   	push   %eax
 215:	50                   	push   %eax
 216:	68 ee 0b 00 00       	push   $0xbee
 21b:	6a 01                	push   $0x1
 21d:	e8 0e 06 00 00       	call   830 <printf>
        exit();
 222:	e8 9c 04 00 00       	call   6c3 <exit>
 227:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 22e:	66 90                	xchg   %ax,%ax

00000230 <testcase2>:
void testcase2(){
 230:	55                   	push   %ebp
 231:	89 e5                	mov    %esp,%ebp
 233:	57                   	push   %edi
 234:	56                   	push   %esi
 235:	53                   	push   %ebx
 236:	83 ec 14             	sub    $0x14,%esp
    printf(1,"\n----- Test case 2 -----\n");
 239:	68 4b 0c 00 00       	push   $0xc4b
 23e:	6a 01                	push   $0x1
 240:	e8 eb 05 00 00       	call   830 <printf>
    v1 = get_free_frame_cnt();
 245:	e8 21 05 00 00       	call   76b <get_free_frame_cnt>
    printf(1,"[prnt] v1 = %d\n", v1);
 24a:	83 c4 0c             	add    $0xc,%esp
 24d:	50                   	push   %eax
    v1 = get_free_frame_cnt();
 24e:	89 c3                	mov    %eax,%ebx
    printf(1,"[prnt] v1 = %d\n", v1);
 250:	68 79 0b 00 00       	push   $0xb79
 255:	6a 01                	push   $0x1
 257:	e8 d4 05 00 00       	call   830 <printf>
    if((pid = fork()) == 0)
 25c:	e8 5a 04 00 00       	call   6bb <fork>
 261:	83 c4 10             	add    $0x10,%esp
 264:	85 c0                	test   %eax,%eax
 266:	0f 84 a6 00 00 00    	je     312 <testcase2+0xe2>
 26c:	89 c7                	mov    %eax,%edi
        v2 = get_free_frame_cnt();
 26e:	e8 f8 04 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[prnt] v2 = %d\n", v2);
 273:	83 ec 04             	sub    $0x4,%esp
 276:	50                   	push   %eax
        v2 = get_free_frame_cnt();
 277:	89 c6                	mov    %eax,%esi
        printf(1,"[prnt] v2 = %d\n", v2);
 279:	68 ce 0b 00 00       	push   $0xbce
 27e:	6a 01                	push   $0x1
 280:	e8 ab 05 00 00       	call   830 <printf>
        printf(1,"[prnt] read global_var, global_var=%d\n", global_var);
 285:	83 c4 0c             	add    $0xc,%esp
 288:	ff 35 20 12 00 00    	push   0x1220
 28e:	68 ec 0d 00 00       	push   $0xdec
 293:	6a 01                	push   $0x1
 295:	e8 96 05 00 00       	call   830 <printf>
        v3 = get_free_frame_cnt();
 29a:	e8 cc 04 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[prnt] v3 = %d\n", v3);
 29f:	83 c4 0c             	add    $0xc,%esp
 2a2:	50                   	push   %eax
 2a3:	68 de 0b 00 00       	push   $0xbde
 2a8:	6a 01                	push   $0x1
 2aa:	e8 81 05 00 00       	call   830 <printf>
    if (wait() != pid)
 2af:	e8 17 04 00 00       	call   6cb <wait>
 2b4:	83 c4 10             	add    $0x10,%esp
 2b7:	39 f8                	cmp    %edi,%eax
 2b9:	0f 85 bd 00 00 00    	jne    37c <testcase2+0x14c>
    v6 = get_free_frame_cnt();
 2bf:	e8 a7 04 00 00       	call   76b <get_free_frame_cnt>
    printf(1, "[prnt] v6 = %d\n", v6);
 2c4:	83 ec 04             	sub    $0x4,%esp
 2c7:	50                   	push   %eax
    v6 = get_free_frame_cnt();
 2c8:	89 c7                	mov    %eax,%edi
    printf(1, "[prnt] v6 = %d\n", v6);
 2ca:	68 7a 0c 00 00       	push   $0xc7a
 2cf:	6a 01                	push   $0x1
 2d1:	e8 5a 05 00 00       	call   830 <printf>
    printf(1, "=====> v1 = v6 ? %s\n", v1 == v6 ? "YES" : "NO");
 2d6:	83 c4 0c             	add    $0xc,%esp
 2d9:	ba 5c 0b 00 00       	mov    $0xb5c,%edx
 2de:	39 fb                	cmp    %edi,%ebx
 2e0:	b8 58 0b 00 00       	mov    $0xb58,%eax
 2e5:	0f 45 c2             	cmovne %edx,%eax
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 2e8:	29 f3                	sub    %esi,%ebx
    printf(1, "=====> v1 = v6 ? %s\n", v1 == v6 ? "YES" : "NO");
 2ea:	50                   	push   %eax
 2eb:	68 8a 0c 00 00       	push   $0xc8a
 2f0:	6a 01                	push   $0x1
 2f2:	e8 39 05 00 00       	call   830 <printf>
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);    
 2f7:	83 c4 0c             	add    $0xc,%esp
 2fa:	53                   	push   %ebx
 2fb:	68 21 0c 00 00       	push   $0xc21
 300:	6a 01                	push   $0x1
 302:	e8 29 05 00 00       	call   830 <printf>
}
 307:	83 c4 10             	add    $0x10,%esp
 30a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 30d:	5b                   	pop    %ebx
 30e:	5e                   	pop    %esi
 30f:	5f                   	pop    %edi
 310:	5d                   	pop    %ebp
 311:	c3                   	ret
        sleep(100);
 312:	83 ec 0c             	sub    $0xc,%esp
 315:	6a 64                	push   $0x64
 317:	e8 37 04 00 00       	call   753 <sleep>
        v4 = get_free_frame_cnt();
 31c:	e8 4a 04 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[chld] v4 = %d\n", v4);
 321:	83 c4 0c             	add    $0xc,%esp
 324:	50                   	push   %eax
        v4 = get_free_frame_cnt();
 325:	89 c3                	mov    %eax,%ebx
        printf(1,"[chld] v4 = %d\n", v4);
 327:	68 89 0b 00 00       	push   $0xb89
 32c:	6a 01                	push   $0x1
 32e:	e8 fd 04 00 00       	call   830 <printf>
        printf(1,"[chld] modified global_var, global_var=%d\n", global_var);
 333:	83 c4 0c             	add    $0xc,%esp
        global_var = 100;
 336:	c7 05 20 12 00 00 64 	movl   $0x64,0x1220
 33d:	00 00 00 
        printf(1,"[chld] modified global_var, global_var=%d\n", global_var);
 340:	6a 64                	push   $0x64
 342:	68 c0 0d 00 00       	push   $0xdc0
 347:	6a 01                	push   $0x1
 349:	e8 e2 04 00 00       	call   830 <printf>
        v5 = get_free_frame_cnt();
 34e:	e8 18 04 00 00       	call   76b <get_free_frame_cnt>
        printf(1,"[chld] v5 = %d\n", v5);        
 353:	83 c4 0c             	add    $0xc,%esp
 356:	50                   	push   %eax
        v5 = get_free_frame_cnt();
 357:	89 c6                	mov    %eax,%esi
        printf(1,"[chld] v5 = %d\n", v5);        
 359:	68 99 0b 00 00       	push   $0xb99
        printf(1,"=====> v4 - v5 = %d\n", v4 - v5);
 35e:	29 f3                	sub    %esi,%ebx
        printf(1,"[chld] v5 = %d\n", v5);        
 360:	6a 01                	push   $0x1
 362:	e8 c9 04 00 00       	call   830 <printf>
        printf(1,"=====> v4 - v5 = %d\n", v4 - v5);
 367:	83 c4 0c             	add    $0xc,%esp
 36a:	53                   	push   %ebx
 36b:	68 65 0c 00 00       	push   $0xc65
 370:	6a 01                	push   $0x1
 372:	e8 b9 04 00 00       	call   830 <printf>
        exit();
 377:	e8 47 03 00 00       	call   6c3 <exit>
        printf(1,"wait() error!");
 37c:	50                   	push   %eax
 37d:	50                   	push   %eax
 37e:	68 ee 0b 00 00       	push   $0xbee
 383:	6a 01                	push   $0x1
 385:	e8 a6 04 00 00       	call   830 <printf>
        exit();
 38a:	e8 34 03 00 00       	call   6c3 <exit>
 38f:	90                   	nop

00000390 <testcase1>:
void testcase1(){
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	57                   	push   %edi
 394:	56                   	push   %esi
 395:	53                   	push   %ebx
 396:	83 ec 14             	sub    $0x14,%esp
    printf(1,"\n----- Test case 1 -----\n");
 399:	68 9f 0c 00 00       	push   $0xc9f
 39e:	6a 01                	push   $0x1
 3a0:	e8 8b 04 00 00       	call   830 <printf>
    v1 = get_free_frame_cnt();
 3a5:	e8 c1 03 00 00       	call   76b <get_free_frame_cnt>
    printf(1,"[prnt] v1 = %d\n", v1);
 3aa:	83 c4 0c             	add    $0xc,%esp
 3ad:	50                   	push   %eax
    v1 = get_free_frame_cnt();
 3ae:	89 c3                	mov    %eax,%ebx
    printf(1,"[prnt] v1 = %d\n", v1);
 3b0:	68 79 0b 00 00       	push   $0xb79
 3b5:	6a 01                	push   $0x1
 3b7:	e8 74 04 00 00       	call   830 <printf>
    if((pid = fork()) == 0)
 3bc:	e8 fa 02 00 00       	call   6bb <fork>
 3c1:	83 c4 10             	add    $0x10,%esp
 3c4:	85 c0                	test   %eax,%eax
 3c6:	74 78                	je     440 <testcase1+0xb0>
 3c8:	89 c7                	mov    %eax,%edi
        v2 = get_free_frame_cnt();
 3ca:	e8 9c 03 00 00       	call   76b <get_free_frame_cnt>
        printf(1, "[prnt] v2 = %d\n", v2);
 3cf:	83 ec 04             	sub    $0x4,%esp
 3d2:	50                   	push   %eax
        v2 = get_free_frame_cnt();
 3d3:	89 c6                	mov    %eax,%esi
        printf(1, "[prnt] v2 = %d\n", v2);
 3d5:	68 ce 0b 00 00       	push   $0xbce
 3da:	6a 01                	push   $0x1
 3dc:	e8 4f 04 00 00       	call   830 <printf>
    if (wait() != pid)
 3e1:	e8 e5 02 00 00       	call   6cb <wait>
 3e6:	83 c4 10             	add    $0x10,%esp
 3e9:	39 f8                	cmp    %edi,%eax
 3eb:	75 77                	jne    464 <testcase1+0xd4>
    v4 = get_free_frame_cnt();    
 3ed:	e8 79 03 00 00       	call   76b <get_free_frame_cnt>
    printf(1, "[prnt] v4 = %d\n", v4);
 3f2:	83 ec 04             	sub    $0x4,%esp
 3f5:	50                   	push   %eax
    v4 = get_free_frame_cnt();    
 3f6:	89 c7                	mov    %eax,%edi
    printf(1, "[prnt] v4 = %d\n", v4);
 3f8:	68 c9 0c 00 00       	push   $0xcc9
 3fd:	6a 01                	push   $0x1
 3ff:	e8 2c 04 00 00       	call   830 <printf>
    printf(1, "=====> v1 = v4 ? %s\n", v1 == v4 ? "YES" : "NO");
 404:	83 c4 0c             	add    $0xc,%esp
 407:	ba 5c 0b 00 00       	mov    $0xb5c,%edx
 40c:	39 fb                	cmp    %edi,%ebx
 40e:	b8 58 0b 00 00       	mov    $0xb58,%eax
 413:	0f 45 c2             	cmovne %edx,%eax
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);
 416:	29 f3                	sub    %esi,%ebx
    printf(1, "=====> v1 = v4 ? %s\n", v1 == v4 ? "YES" : "NO");
 418:	50                   	push   %eax
 419:	68 d9 0c 00 00       	push   $0xcd9
 41e:	6a 01                	push   $0x1
 420:	e8 0b 04 00 00       	call   830 <printf>
    printf(1, "=====> v1 - v2 = %d\n", v1 - v2);
 425:	83 c4 0c             	add    $0xc,%esp
 428:	53                   	push   %ebx
 429:	68 21 0c 00 00       	push   $0xc21
 42e:	6a 01                	push   $0x1
 430:	e8 fb 03 00 00       	call   830 <printf>
}
 435:	83 c4 10             	add    $0x10,%esp
 438:	8d 65 f4             	lea    -0xc(%ebp),%esp
 43b:	5b                   	pop    %ebx
 43c:	5e                   	pop    %esi
 43d:	5f                   	pop    %edi
 43e:	5d                   	pop    %ebp
 43f:	c3                   	ret
        sleep(100);        
 440:	83 ec 0c             	sub    $0xc,%esp
 443:	6a 64                	push   $0x64
 445:	e8 09 03 00 00       	call   753 <sleep>
        v3 = get_free_frame_cnt();
 44a:	e8 1c 03 00 00       	call   76b <get_free_frame_cnt>
        printf(1, "[chld] v3 = %d\n", v3);
 44f:	83 c4 0c             	add    $0xc,%esp
 452:	50                   	push   %eax
 453:	68 b9 0c 00 00       	push   $0xcb9
 458:	6a 01                	push   $0x1
 45a:	e8 d1 03 00 00       	call   830 <printf>
        exit();
 45f:	e8 5f 02 00 00       	call   6c3 <exit>
        printf(1, "wait() error!");
 464:	50                   	push   %eax
 465:	50                   	push   %eax
 466:	68 ee 0b 00 00       	push   $0xbee
 46b:	6a 01                	push   $0x1
 46d:	e8 be 03 00 00       	call   830 <printf>
        exit();
 472:	e8 4c 02 00 00       	call   6c3 <exit>
 477:	66 90                	xchg   %ax,%ax
 479:	66 90                	xchg   %ax,%ax
 47b:	66 90                	xchg   %ax,%ax
 47d:	66 90                	xchg   %ax,%ax
 47f:	90                   	nop

00000480 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, char *t)
{
 480:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 481:	31 c0                	xor    %eax,%eax
{
 483:	89 e5                	mov    %esp,%ebp
 485:	53                   	push   %ebx
 486:	8b 4d 08             	mov    0x8(%ebp),%ecx
 489:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 48c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
 490:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
 494:	88 14 01             	mov    %dl,(%ecx,%eax,1)
 497:	83 c0 01             	add    $0x1,%eax
 49a:	84 d2                	test   %dl,%dl
 49c:	75 f2                	jne    490 <strcpy+0x10>
    ;
  return os;
}
 49e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4a1:	89 c8                	mov    %ecx,%eax
 4a3:	c9                   	leave
 4a4:	c3                   	ret
 4a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000004b0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	53                   	push   %ebx
 4b4:	8b 55 08             	mov    0x8(%ebp),%edx
 4b7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 4ba:	0f b6 02             	movzbl (%edx),%eax
 4bd:	84 c0                	test   %al,%al
 4bf:	75 17                	jne    4d8 <strcmp+0x28>
 4c1:	eb 3a                	jmp    4fd <strcmp+0x4d>
 4c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 4c7:	90                   	nop
 4c8:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
 4cc:	83 c2 01             	add    $0x1,%edx
 4cf:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
 4d2:	84 c0                	test   %al,%al
 4d4:	74 1a                	je     4f0 <strcmp+0x40>
    p++, q++;
 4d6:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
 4d8:	0f b6 19             	movzbl (%ecx),%ebx
 4db:	38 c3                	cmp    %al,%bl
 4dd:	74 e9                	je     4c8 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
 4df:	29 d8                	sub    %ebx,%eax
}
 4e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4e4:	c9                   	leave
 4e5:	c3                   	ret
 4e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 4ed:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
 4f0:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
 4f4:	31 c0                	xor    %eax,%eax
 4f6:	29 d8                	sub    %ebx,%eax
}
 4f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 4fb:	c9                   	leave
 4fc:	c3                   	ret
  return (uchar)*p - (uchar)*q;
 4fd:	0f b6 19             	movzbl (%ecx),%ebx
 500:	31 c0                	xor    %eax,%eax
 502:	eb db                	jmp    4df <strcmp+0x2f>
 504:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 50b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 50f:	90                   	nop

00000510 <strlen>:

uint
strlen(char *s)
{
 510:	55                   	push   %ebp
 511:	89 e5                	mov    %esp,%ebp
 513:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 516:	80 3a 00             	cmpb   $0x0,(%edx)
 519:	74 15                	je     530 <strlen+0x20>
 51b:	31 c0                	xor    %eax,%eax
 51d:	8d 76 00             	lea    0x0(%esi),%esi
 520:	83 c0 01             	add    $0x1,%eax
 523:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 527:	89 c1                	mov    %eax,%ecx
 529:	75 f5                	jne    520 <strlen+0x10>
    ;
  return n;
}
 52b:	89 c8                	mov    %ecx,%eax
 52d:	5d                   	pop    %ebp
 52e:	c3                   	ret
 52f:	90                   	nop
  for(n = 0; s[n]; n++)
 530:	31 c9                	xor    %ecx,%ecx
}
 532:	5d                   	pop    %ebp
 533:	89 c8                	mov    %ecx,%eax
 535:	c3                   	ret
 536:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 53d:	8d 76 00             	lea    0x0(%esi),%esi

00000540 <memset>:

void*
memset(void *dst, int c, uint n)
{
 540:	55                   	push   %ebp
 541:	89 e5                	mov    %esp,%ebp
 543:	57                   	push   %edi
 544:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 547:	8b 4d 10             	mov    0x10(%ebp),%ecx
 54a:	8b 45 0c             	mov    0xc(%ebp),%eax
 54d:	89 d7                	mov    %edx,%edi
 54f:	fc                   	cld
 550:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 552:	8b 7d fc             	mov    -0x4(%ebp),%edi
 555:	89 d0                	mov    %edx,%eax
 557:	c9                   	leave
 558:	c3                   	ret
 559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000560 <strchr>:

char*
strchr(const char *s, char c)
{
 560:	55                   	push   %ebp
 561:	89 e5                	mov    %esp,%ebp
 563:	8b 45 08             	mov    0x8(%ebp),%eax
 566:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 56a:	0f b6 10             	movzbl (%eax),%edx
 56d:	84 d2                	test   %dl,%dl
 56f:	75 12                	jne    583 <strchr+0x23>
 571:	eb 1d                	jmp    590 <strchr+0x30>
 573:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 577:	90                   	nop
 578:	0f b6 50 01          	movzbl 0x1(%eax),%edx
 57c:	83 c0 01             	add    $0x1,%eax
 57f:	84 d2                	test   %dl,%dl
 581:	74 0d                	je     590 <strchr+0x30>
    if(*s == c)
 583:	38 d1                	cmp    %dl,%cl
 585:	75 f1                	jne    578 <strchr+0x18>
      return (char*)s;
  return 0;
}
 587:	5d                   	pop    %ebp
 588:	c3                   	ret
 589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
 590:	31 c0                	xor    %eax,%eax
}
 592:	5d                   	pop    %ebp
 593:	c3                   	ret
 594:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 59b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 59f:	90                   	nop

000005a0 <gets>:

char*
gets(char *buf, int max)
{
 5a0:	55                   	push   %ebp
 5a1:	89 e5                	mov    %esp,%ebp
 5a3:	57                   	push   %edi
 5a4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 5a5:	8d 75 e7             	lea    -0x19(%ebp),%esi
{
 5a8:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
 5a9:	31 db                	xor    %ebx,%ebx
{
 5ab:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
 5ae:	eb 27                	jmp    5d7 <gets+0x37>
    cc = read(0, &c, 1);
 5b0:	83 ec 04             	sub    $0x4,%esp
 5b3:	6a 01                	push   $0x1
 5b5:	56                   	push   %esi
 5b6:	6a 00                	push   $0x0
 5b8:	e8 1e 01 00 00       	call   6db <read>
    if(cc < 1)
 5bd:	83 c4 10             	add    $0x10,%esp
 5c0:	85 c0                	test   %eax,%eax
 5c2:	7e 1d                	jle    5e1 <gets+0x41>
      break;
    buf[i++] = c;
 5c4:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 5c8:	8b 55 08             	mov    0x8(%ebp),%edx
 5cb:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 5cf:	3c 0a                	cmp    $0xa,%al
 5d1:	74 10                	je     5e3 <gets+0x43>
 5d3:	3c 0d                	cmp    $0xd,%al
 5d5:	74 0c                	je     5e3 <gets+0x43>
  for(i=0; i+1 < max; ){
 5d7:	89 df                	mov    %ebx,%edi
 5d9:	83 c3 01             	add    $0x1,%ebx
 5dc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 5df:	7c cf                	jl     5b0 <gets+0x10>
 5e1:	89 fb                	mov    %edi,%ebx
      break;
  }
  buf[i] = '\0';
 5e3:	8b 45 08             	mov    0x8(%ebp),%eax
 5e6:	c6 04 18 00          	movb   $0x0,(%eax,%ebx,1)
  return buf;
}
 5ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5ed:	5b                   	pop    %ebx
 5ee:	5e                   	pop    %esi
 5ef:	5f                   	pop    %edi
 5f0:	5d                   	pop    %ebp
 5f1:	c3                   	ret
 5f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 5f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000600 <stat>:

int
stat(char *n, struct stat *st)
{
 600:	55                   	push   %ebp
 601:	89 e5                	mov    %esp,%ebp
 603:	56                   	push   %esi
 604:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 605:	83 ec 08             	sub    $0x8,%esp
 608:	6a 00                	push   $0x0
 60a:	ff 75 08             	push   0x8(%ebp)
 60d:	e8 f1 00 00 00       	call   703 <open>
  if(fd < 0)
 612:	83 c4 10             	add    $0x10,%esp
 615:	85 c0                	test   %eax,%eax
 617:	78 27                	js     640 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 619:	83 ec 08             	sub    $0x8,%esp
 61c:	ff 75 0c             	push   0xc(%ebp)
 61f:	89 c3                	mov    %eax,%ebx
 621:	50                   	push   %eax
 622:	e8 f4 00 00 00       	call   71b <fstat>
  close(fd);
 627:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 62a:	89 c6                	mov    %eax,%esi
  close(fd);
 62c:	e8 ba 00 00 00       	call   6eb <close>
  return r;
 631:	83 c4 10             	add    $0x10,%esp
}
 634:	8d 65 f8             	lea    -0x8(%ebp),%esp
 637:	89 f0                	mov    %esi,%eax
 639:	5b                   	pop    %ebx
 63a:	5e                   	pop    %esi
 63b:	5d                   	pop    %ebp
 63c:	c3                   	ret
 63d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 640:	be ff ff ff ff       	mov    $0xffffffff,%esi
 645:	eb ed                	jmp    634 <stat+0x34>
 647:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 64e:	66 90                	xchg   %ax,%ax

00000650 <atoi>:

int
atoi(const char *s)
{
 650:	55                   	push   %ebp
 651:	89 e5                	mov    %esp,%ebp
 653:	53                   	push   %ebx
 654:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 657:	0f be 02             	movsbl (%edx),%eax
 65a:	8d 48 d0             	lea    -0x30(%eax),%ecx
 65d:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
 660:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
 665:	77 1e                	ja     685 <atoi+0x35>
 667:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 66e:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 670:	83 c2 01             	add    $0x1,%edx
 673:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
 676:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
 67a:	0f be 02             	movsbl (%edx),%eax
 67d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 680:	80 fb 09             	cmp    $0x9,%bl
 683:	76 eb                	jbe    670 <atoi+0x20>
  return n;
}
 685:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 688:	89 c8                	mov    %ecx,%eax
 68a:	c9                   	leave
 68b:	c3                   	ret
 68c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000690 <memmove>:

void*
memmove(void *vdst, void *vsrc, int n)
{
 690:	55                   	push   %ebp
 691:	89 e5                	mov    %esp,%ebp
 693:	57                   	push   %edi
 694:	56                   	push   %esi
 695:	8b 45 10             	mov    0x10(%ebp),%eax
 698:	8b 55 08             	mov    0x8(%ebp),%edx
 69b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst, *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 69e:	85 c0                	test   %eax,%eax
 6a0:	7e 13                	jle    6b5 <memmove+0x25>
 6a2:	01 d0                	add    %edx,%eax
  dst = vdst;
 6a4:	89 d7                	mov    %edx,%edi
 6a6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 6ad:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
 6b0:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
 6b1:	39 f8                	cmp    %edi,%eax
 6b3:	75 fb                	jne    6b0 <memmove+0x20>
  return vdst;
}
 6b5:	5e                   	pop    %esi
 6b6:	89 d0                	mov    %edx,%eax
 6b8:	5f                   	pop    %edi
 6b9:	5d                   	pop    %ebp
 6ba:	c3                   	ret

000006bb <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 6bb:	b8 01 00 00 00       	mov    $0x1,%eax
 6c0:	cd 40                	int    $0x40
 6c2:	c3                   	ret

000006c3 <exit>:
SYSCALL(exit)
 6c3:	b8 02 00 00 00       	mov    $0x2,%eax
 6c8:	cd 40                	int    $0x40
 6ca:	c3                   	ret

000006cb <wait>:
SYSCALL(wait)
 6cb:	b8 03 00 00 00       	mov    $0x3,%eax
 6d0:	cd 40                	int    $0x40
 6d2:	c3                   	ret

000006d3 <pipe>:
SYSCALL(pipe)
 6d3:	b8 04 00 00 00       	mov    $0x4,%eax
 6d8:	cd 40                	int    $0x40
 6da:	c3                   	ret

000006db <read>:
SYSCALL(read)
 6db:	b8 05 00 00 00       	mov    $0x5,%eax
 6e0:	cd 40                	int    $0x40
 6e2:	c3                   	ret

000006e3 <write>:
SYSCALL(write)
 6e3:	b8 10 00 00 00       	mov    $0x10,%eax
 6e8:	cd 40                	int    $0x40
 6ea:	c3                   	ret

000006eb <close>:
SYSCALL(close)
 6eb:	b8 15 00 00 00       	mov    $0x15,%eax
 6f0:	cd 40                	int    $0x40
 6f2:	c3                   	ret

000006f3 <kill>:
SYSCALL(kill)
 6f3:	b8 06 00 00 00       	mov    $0x6,%eax
 6f8:	cd 40                	int    $0x40
 6fa:	c3                   	ret

000006fb <exec>:
SYSCALL(exec)
 6fb:	b8 07 00 00 00       	mov    $0x7,%eax
 700:	cd 40                	int    $0x40
 702:	c3                   	ret

00000703 <open>:
SYSCALL(open)
 703:	b8 0f 00 00 00       	mov    $0xf,%eax
 708:	cd 40                	int    $0x40
 70a:	c3                   	ret

0000070b <mknod>:
SYSCALL(mknod)
 70b:	b8 11 00 00 00       	mov    $0x11,%eax
 710:	cd 40                	int    $0x40
 712:	c3                   	ret

00000713 <unlink>:
SYSCALL(unlink)
 713:	b8 12 00 00 00       	mov    $0x12,%eax
 718:	cd 40                	int    $0x40
 71a:	c3                   	ret

0000071b <fstat>:
SYSCALL(fstat)
 71b:	b8 08 00 00 00       	mov    $0x8,%eax
 720:	cd 40                	int    $0x40
 722:	c3                   	ret

00000723 <link>:
SYSCALL(link)
 723:	b8 13 00 00 00       	mov    $0x13,%eax
 728:	cd 40                	int    $0x40
 72a:	c3                   	ret

0000072b <mkdir>:
SYSCALL(mkdir)
 72b:	b8 14 00 00 00       	mov    $0x14,%eax
 730:	cd 40                	int    $0x40
 732:	c3                   	ret

00000733 <chdir>:
SYSCALL(chdir)
 733:	b8 09 00 00 00       	mov    $0x9,%eax
 738:	cd 40                	int    $0x40
 73a:	c3                   	ret

0000073b <dup>:
SYSCALL(dup)
 73b:	b8 0a 00 00 00       	mov    $0xa,%eax
 740:	cd 40                	int    $0x40
 742:	c3                   	ret

00000743 <getpid>:
SYSCALL(getpid)
 743:	b8 0b 00 00 00       	mov    $0xb,%eax
 748:	cd 40                	int    $0x40
 74a:	c3                   	ret

0000074b <sbrk>:
SYSCALL(sbrk)
 74b:	b8 0c 00 00 00       	mov    $0xc,%eax
 750:	cd 40                	int    $0x40
 752:	c3                   	ret

00000753 <sleep>:
SYSCALL(sleep)
 753:	b8 0d 00 00 00       	mov    $0xd,%eax
 758:	cd 40                	int    $0x40
 75a:	c3                   	ret

0000075b <uptime>:
SYSCALL(uptime)
 75b:	b8 0e 00 00 00       	mov    $0xe,%eax
 760:	cd 40                	int    $0x40
 762:	c3                   	ret

00000763 <shutdown>:
SYSCALL(shutdown)
 763:	b8 16 00 00 00       	mov    $0x16,%eax
 768:	cd 40                	int    $0x40
 76a:	c3                   	ret

0000076b <get_free_frame_cnt>:
SYSCALL(get_free_frame_cnt)
 76b:	b8 17 00 00 00       	mov    $0x17,%eax
 770:	cd 40                	int    $0x40
 772:	c3                   	ret

00000773 <enable_cow>:
SYSCALL(enable_cow)
 773:	b8 18 00 00 00       	mov    $0x18,%eax
 778:	cd 40                	int    $0x40
 77a:	c3                   	ret

0000077b <get_cow_status>:
SYSCALL(get_cow_status)
 77b:	b8 19 00 00 00       	mov    $0x19,%eax
 780:	cd 40                	int    $0x40
 782:	c3                   	ret
 783:	66 90                	xchg   %ax,%ax
 785:	66 90                	xchg   %ax,%ax
 787:	66 90                	xchg   %ax,%ax
 789:	66 90                	xchg   %ax,%ax
 78b:	66 90                	xchg   %ax,%ax
 78d:	66 90                	xchg   %ax,%ax
 78f:	90                   	nop

00000790 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 790:	55                   	push   %ebp
 791:	89 e5                	mov    %esp,%ebp
 793:	57                   	push   %edi
 794:	56                   	push   %esi
 795:	53                   	push   %ebx
 796:	89 cb                	mov    %ecx,%ebx
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 798:	89 d1                	mov    %edx,%ecx
{
 79a:	83 ec 3c             	sub    $0x3c,%esp
 79d:	89 45 c0             	mov    %eax,-0x40(%ebp)
  if(sgn && xx < 0){
 7a0:	85 d2                	test   %edx,%edx
 7a2:	0f 89 80 00 00 00    	jns    828 <printint+0x98>
 7a8:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 7ac:	74 7a                	je     828 <printint+0x98>
    x = -xx;
 7ae:	f7 d9                	neg    %ecx
    neg = 1;
 7b0:	b8 01 00 00 00       	mov    $0x1,%eax
  } else {
    x = xx;
  }

  i = 0;
 7b5:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 7b8:	31 f6                	xor    %esi,%esi
 7ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
 7c0:	89 c8                	mov    %ecx,%eax
 7c2:	31 d2                	xor    %edx,%edx
 7c4:	89 f7                	mov    %esi,%edi
 7c6:	f7 f3                	div    %ebx
 7c8:	8d 76 01             	lea    0x1(%esi),%esi
 7cb:	0f b6 92 e0 0e 00 00 	movzbl 0xee0(%edx),%edx
 7d2:	88 54 35 d7          	mov    %dl,-0x29(%ebp,%esi,1)
  }while((x /= base) != 0);
 7d6:	89 ca                	mov    %ecx,%edx
 7d8:	89 c1                	mov    %eax,%ecx
 7da:	39 da                	cmp    %ebx,%edx
 7dc:	73 e2                	jae    7c0 <printint+0x30>
  if(neg)
 7de:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 7e1:	85 c0                	test   %eax,%eax
 7e3:	74 07                	je     7ec <printint+0x5c>
    buf[i++] = '-';
 7e5:	c6 44 35 d8 2d       	movb   $0x2d,-0x28(%ebp,%esi,1)
    buf[i++] = digits[x % base];
 7ea:	89 f7                	mov    %esi,%edi
 7ec:	8d 5d d8             	lea    -0x28(%ebp),%ebx
 7ef:	8b 75 c0             	mov    -0x40(%ebp),%esi
 7f2:	01 df                	add    %ebx,%edi
 7f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  while(--i >= 0)
    putc(fd, buf[i]);
 7f8:	0f b6 07             	movzbl (%edi),%eax
  write(fd, &c, 1);
 7fb:	83 ec 04             	sub    $0x4,%esp
 7fe:	88 45 d7             	mov    %al,-0x29(%ebp)
 801:	8d 45 d7             	lea    -0x29(%ebp),%eax
 804:	6a 01                	push   $0x1
 806:	50                   	push   %eax
 807:	56                   	push   %esi
 808:	e8 d6 fe ff ff       	call   6e3 <write>
  while(--i >= 0)
 80d:	89 f8                	mov    %edi,%eax
 80f:	83 c4 10             	add    $0x10,%esp
 812:	83 ef 01             	sub    $0x1,%edi
 815:	39 d8                	cmp    %ebx,%eax
 817:	75 df                	jne    7f8 <printint+0x68>
}
 819:	8d 65 f4             	lea    -0xc(%ebp),%esp
 81c:	5b                   	pop    %ebx
 81d:	5e                   	pop    %esi
 81e:	5f                   	pop    %edi
 81f:	5d                   	pop    %ebp
 820:	c3                   	ret
 821:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 828:	31 c0                	xor    %eax,%eax
 82a:	eb 89                	jmp    7b5 <printint+0x25>
 82c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000830 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, char *fmt, ...)
{
 830:	55                   	push   %ebp
 831:	89 e5                	mov    %esp,%ebp
 833:	57                   	push   %edi
 834:	56                   	push   %esi
 835:	53                   	push   %ebx
 836:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 839:	8b 75 0c             	mov    0xc(%ebp),%esi
{
 83c:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i = 0; fmt[i]; i++){
 83f:	0f b6 1e             	movzbl (%esi),%ebx
 842:	83 c6 01             	add    $0x1,%esi
 845:	84 db                	test   %bl,%bl
 847:	74 67                	je     8b0 <printf+0x80>
 849:	8d 4d 10             	lea    0x10(%ebp),%ecx
 84c:	31 d2                	xor    %edx,%edx
 84e:	89 4d d0             	mov    %ecx,-0x30(%ebp)
 851:	eb 34                	jmp    887 <printf+0x57>
 853:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 857:	90                   	nop
 858:	89 55 d4             	mov    %edx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 85b:	ba 25 00 00 00       	mov    $0x25,%edx
      if(c == '%'){
 860:	83 f8 25             	cmp    $0x25,%eax
 863:	74 18                	je     87d <printf+0x4d>
  write(fd, &c, 1);
 865:	83 ec 04             	sub    $0x4,%esp
 868:	8d 45 e7             	lea    -0x19(%ebp),%eax
 86b:	88 5d e7             	mov    %bl,-0x19(%ebp)
 86e:	6a 01                	push   $0x1
 870:	50                   	push   %eax
 871:	57                   	push   %edi
 872:	e8 6c fe ff ff       	call   6e3 <write>
 877:	8b 55 d4             	mov    -0x2c(%ebp),%edx
      } else {
        putc(fd, c);
 87a:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 87d:	0f b6 1e             	movzbl (%esi),%ebx
 880:	83 c6 01             	add    $0x1,%esi
 883:	84 db                	test   %bl,%bl
 885:	74 29                	je     8b0 <printf+0x80>
    c = fmt[i] & 0xff;
 887:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 88a:	85 d2                	test   %edx,%edx
 88c:	74 ca                	je     858 <printf+0x28>
      }
    } else if(state == '%'){
 88e:	83 fa 25             	cmp    $0x25,%edx
 891:	75 ea                	jne    87d <printf+0x4d>
      if(c == 'd'){
 893:	83 f8 25             	cmp    $0x25,%eax
 896:	0f 84 24 01 00 00    	je     9c0 <printf+0x190>
 89c:	83 e8 63             	sub    $0x63,%eax
 89f:	83 f8 15             	cmp    $0x15,%eax
 8a2:	77 1c                	ja     8c0 <printf+0x90>
 8a4:	ff 24 85 88 0e 00 00 	jmp    *0xe88(,%eax,4)
 8ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 8af:	90                   	nop
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 8b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 8b3:	5b                   	pop    %ebx
 8b4:	5e                   	pop    %esi
 8b5:	5f                   	pop    %edi
 8b6:	5d                   	pop    %ebp
 8b7:	c3                   	ret
 8b8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 8bf:	90                   	nop
  write(fd, &c, 1);
 8c0:	83 ec 04             	sub    $0x4,%esp
 8c3:	8d 55 e7             	lea    -0x19(%ebp),%edx
 8c6:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 8ca:	6a 01                	push   $0x1
 8cc:	52                   	push   %edx
 8cd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 8d0:	57                   	push   %edi
 8d1:	e8 0d fe ff ff       	call   6e3 <write>
 8d6:	83 c4 0c             	add    $0xc,%esp
 8d9:	88 5d e7             	mov    %bl,-0x19(%ebp)
 8dc:	6a 01                	push   $0x1
 8de:	8b 55 d4             	mov    -0x2c(%ebp),%edx
 8e1:	52                   	push   %edx
 8e2:	57                   	push   %edi
 8e3:	e8 fb fd ff ff       	call   6e3 <write>
        putc(fd, c);
 8e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 8eb:	31 d2                	xor    %edx,%edx
 8ed:	eb 8e                	jmp    87d <printf+0x4d>
 8ef:	90                   	nop
        printint(fd, *ap, 16, 0);
 8f0:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 8f3:	83 ec 0c             	sub    $0xc,%esp
 8f6:	b9 10 00 00 00       	mov    $0x10,%ecx
 8fb:	8b 13                	mov    (%ebx),%edx
 8fd:	6a 00                	push   $0x0
 8ff:	89 f8                	mov    %edi,%eax
        ap++;
 901:	83 c3 04             	add    $0x4,%ebx
        printint(fd, *ap, 16, 0);
 904:	e8 87 fe ff ff       	call   790 <printint>
        ap++;
 909:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 90c:	83 c4 10             	add    $0x10,%esp
      state = 0;
 90f:	31 d2                	xor    %edx,%edx
 911:	e9 67 ff ff ff       	jmp    87d <printf+0x4d>
 916:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 91d:	8d 76 00             	lea    0x0(%esi),%esi
        s = (char*)*ap;
 920:	8b 45 d0             	mov    -0x30(%ebp),%eax
 923:	8b 18                	mov    (%eax),%ebx
        ap++;
 925:	83 c0 04             	add    $0x4,%eax
 928:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
 92b:	85 db                	test   %ebx,%ebx
 92d:	0f 84 9d 00 00 00    	je     9d0 <printf+0x1a0>
        while(*s != 0){
 933:	0f b6 03             	movzbl (%ebx),%eax
      state = 0;
 936:	31 d2                	xor    %edx,%edx
        while(*s != 0){
 938:	84 c0                	test   %al,%al
 93a:	0f 84 3d ff ff ff    	je     87d <printf+0x4d>
 940:	8d 55 e7             	lea    -0x19(%ebp),%edx
 943:	89 75 d4             	mov    %esi,-0x2c(%ebp)
 946:	89 de                	mov    %ebx,%esi
 948:	89 d3                	mov    %edx,%ebx
 94a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 950:	83 ec 04             	sub    $0x4,%esp
 953:	88 45 e7             	mov    %al,-0x19(%ebp)
          s++;
 956:	83 c6 01             	add    $0x1,%esi
  write(fd, &c, 1);
 959:	6a 01                	push   $0x1
 95b:	53                   	push   %ebx
 95c:	57                   	push   %edi
 95d:	e8 81 fd ff ff       	call   6e3 <write>
        while(*s != 0){
 962:	0f b6 06             	movzbl (%esi),%eax
 965:	83 c4 10             	add    $0x10,%esp
 968:	84 c0                	test   %al,%al
 96a:	75 e4                	jne    950 <printf+0x120>
      state = 0;
 96c:	8b 75 d4             	mov    -0x2c(%ebp),%esi
 96f:	31 d2                	xor    %edx,%edx
 971:	e9 07 ff ff ff       	jmp    87d <printf+0x4d>
 976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 97d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
 980:	8b 5d d0             	mov    -0x30(%ebp),%ebx
 983:	83 ec 0c             	sub    $0xc,%esp
 986:	b9 0a 00 00 00       	mov    $0xa,%ecx
 98b:	8b 13                	mov    (%ebx),%edx
 98d:	6a 01                	push   $0x1
 98f:	e9 6b ff ff ff       	jmp    8ff <printf+0xcf>
 994:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, *ap);
 998:	8b 5d d0             	mov    -0x30(%ebp),%ebx
  write(fd, &c, 1);
 99b:	83 ec 04             	sub    $0x4,%esp
 99e:	8d 55 e7             	lea    -0x19(%ebp),%edx
        putc(fd, *ap);
 9a1:	8b 03                	mov    (%ebx),%eax
        ap++;
 9a3:	83 c3 04             	add    $0x4,%ebx
        putc(fd, *ap);
 9a6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
 9a9:	6a 01                	push   $0x1
 9ab:	52                   	push   %edx
 9ac:	57                   	push   %edi
 9ad:	e8 31 fd ff ff       	call   6e3 <write>
        ap++;
 9b2:	89 5d d0             	mov    %ebx,-0x30(%ebp)
 9b5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 9b8:	31 d2                	xor    %edx,%edx
 9ba:	e9 be fe ff ff       	jmp    87d <printf+0x4d>
 9bf:	90                   	nop
  write(fd, &c, 1);
 9c0:	83 ec 04             	sub    $0x4,%esp
 9c3:	88 5d e7             	mov    %bl,-0x19(%ebp)
 9c6:	8d 55 e7             	lea    -0x19(%ebp),%edx
 9c9:	6a 01                	push   $0x1
 9cb:	e9 11 ff ff ff       	jmp    8e1 <printf+0xb1>
 9d0:	b8 28 00 00 00       	mov    $0x28,%eax
          s = "(null)";
 9d5:	bb 81 0e 00 00       	mov    $0xe81,%ebx
 9da:	e9 61 ff ff ff       	jmp    940 <printf+0x110>
 9df:	90                   	nop

000009e0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9e0:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e1:	a1 40 32 00 00       	mov    0x3240,%eax
{
 9e6:	89 e5                	mov    %esp,%ebp
 9e8:	57                   	push   %edi
 9e9:	56                   	push   %esi
 9ea:	53                   	push   %ebx
 9eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 9ee:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 9f8:	89 c2                	mov    %eax,%edx
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9fa:	8b 00                	mov    (%eax),%eax
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9fc:	39 ca                	cmp    %ecx,%edx
 9fe:	73 30                	jae    a30 <free+0x50>
 a00:	39 c1                	cmp    %eax,%ecx
 a02:	72 04                	jb     a08 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a04:	39 c2                	cmp    %eax,%edx
 a06:	72 f0                	jb     9f8 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a08:	8b 73 fc             	mov    -0x4(%ebx),%esi
 a0b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 a0e:	39 f8                	cmp    %edi,%eax
 a10:	74 2e                	je     a40 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a12:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a15:	8b 42 04             	mov    0x4(%edx),%eax
 a18:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 a1b:	39 f1                	cmp    %esi,%ecx
 a1d:	74 38                	je     a57 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a1f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
 a21:	5b                   	pop    %ebx
  freep = p;
 a22:	89 15 40 32 00 00    	mov    %edx,0x3240
}
 a28:	5e                   	pop    %esi
 a29:	5f                   	pop    %edi
 a2a:	5d                   	pop    %ebp
 a2b:	c3                   	ret
 a2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a30:	39 c1                	cmp    %eax,%ecx
 a32:	72 d0                	jb     a04 <free+0x24>
 a34:	eb c2                	jmp    9f8 <free+0x18>
 a36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 a3d:	8d 76 00             	lea    0x0(%esi),%esi
    bp->s.size += p->s.ptr->s.size;
 a40:	03 70 04             	add    0x4(%eax),%esi
 a43:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 a46:	8b 02                	mov    (%edx),%eax
 a48:	8b 00                	mov    (%eax),%eax
 a4a:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
 a4d:	8b 42 04             	mov    0x4(%edx),%eax
 a50:	8d 34 c2             	lea    (%edx,%eax,8),%esi
 a53:	39 f1                	cmp    %esi,%ecx
 a55:	75 c8                	jne    a1f <free+0x3f>
    p->s.size += bp->s.size;
 a57:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
 a5a:	89 15 40 32 00 00    	mov    %edx,0x3240
    p->s.size += bp->s.size;
 a60:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
 a63:	8b 4b f8             	mov    -0x8(%ebx),%ecx
 a66:	89 0a                	mov    %ecx,(%edx)
}
 a68:	5b                   	pop    %ebx
 a69:	5e                   	pop    %esi
 a6a:	5f                   	pop    %edi
 a6b:	5d                   	pop    %ebp
 a6c:	c3                   	ret
 a6d:	8d 76 00             	lea    0x0(%esi),%esi

00000a70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a70:	55                   	push   %ebp
 a71:	89 e5                	mov    %esp,%ebp
 a73:	57                   	push   %edi
 a74:	56                   	push   %esi
 a75:	53                   	push   %ebx
 a76:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a79:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 a7c:	8b 15 40 32 00 00    	mov    0x3240,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a82:	8d 78 07             	lea    0x7(%eax),%edi
 a85:	c1 ef 03             	shr    $0x3,%edi
 a88:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 a8b:	85 d2                	test   %edx,%edx
 a8d:	0f 84 8d 00 00 00    	je     b20 <malloc+0xb0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a93:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a95:	8b 48 04             	mov    0x4(%eax),%ecx
 a98:	39 f9                	cmp    %edi,%ecx
 a9a:	73 64                	jae    b00 <malloc+0x90>
  if(nu < 4096)
 a9c:	bb 00 10 00 00       	mov    $0x1000,%ebx
 aa1:	39 df                	cmp    %ebx,%edi
 aa3:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 aa6:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 aad:	eb 0a                	jmp    ab9 <malloc+0x49>
 aaf:	90                   	nop
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ab0:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 ab2:	8b 48 04             	mov    0x4(%eax),%ecx
 ab5:	39 f9                	cmp    %edi,%ecx
 ab7:	73 47                	jae    b00 <malloc+0x90>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 ab9:	89 c2                	mov    %eax,%edx
 abb:	39 05 40 32 00 00    	cmp    %eax,0x3240
 ac1:	75 ed                	jne    ab0 <malloc+0x40>
  p = sbrk(nu * sizeof(Header));
 ac3:	83 ec 0c             	sub    $0xc,%esp
 ac6:	56                   	push   %esi
 ac7:	e8 7f fc ff ff       	call   74b <sbrk>
  if(p == (char*)-1)
 acc:	83 c4 10             	add    $0x10,%esp
 acf:	83 f8 ff             	cmp    $0xffffffff,%eax
 ad2:	74 1c                	je     af0 <malloc+0x80>
  hp->s.size = nu;
 ad4:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 ad7:	83 ec 0c             	sub    $0xc,%esp
 ada:	83 c0 08             	add    $0x8,%eax
 add:	50                   	push   %eax
 ade:	e8 fd fe ff ff       	call   9e0 <free>
  return freep;
 ae3:	8b 15 40 32 00 00    	mov    0x3240,%edx
      if((p = morecore(nunits)) == 0)
 ae9:	83 c4 10             	add    $0x10,%esp
 aec:	85 d2                	test   %edx,%edx
 aee:	75 c0                	jne    ab0 <malloc+0x40>
        return 0;
  }
}
 af0:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 af3:	31 c0                	xor    %eax,%eax
}
 af5:	5b                   	pop    %ebx
 af6:	5e                   	pop    %esi
 af7:	5f                   	pop    %edi
 af8:	5d                   	pop    %ebp
 af9:	c3                   	ret
 afa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 b00:	39 cf                	cmp    %ecx,%edi
 b02:	74 4c                	je     b50 <malloc+0xe0>
        p->s.size -= nunits;
 b04:	29 f9                	sub    %edi,%ecx
 b06:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 b09:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 b0c:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 b0f:	89 15 40 32 00 00    	mov    %edx,0x3240
}
 b15:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 b18:	83 c0 08             	add    $0x8,%eax
}
 b1b:	5b                   	pop    %ebx
 b1c:	5e                   	pop    %esi
 b1d:	5f                   	pop    %edi
 b1e:	5d                   	pop    %ebp
 b1f:	c3                   	ret
    base.s.ptr = freep = prevp = &base;
 b20:	c7 05 40 32 00 00 44 	movl   $0x3244,0x3240
 b27:	32 00 00 
    base.s.size = 0;
 b2a:	b8 44 32 00 00       	mov    $0x3244,%eax
    base.s.ptr = freep = prevp = &base;
 b2f:	c7 05 44 32 00 00 44 	movl   $0x3244,0x3244
 b36:	32 00 00 
    base.s.size = 0;
 b39:	c7 05 48 32 00 00 00 	movl   $0x0,0x3248
 b40:	00 00 00 
    if(p->s.size >= nunits){
 b43:	e9 54 ff ff ff       	jmp    a9c <malloc+0x2c>
 b48:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 b4f:	90                   	nop
        prevp->s.ptr = p->s.ptr;
 b50:	8b 08                	mov    (%eax),%ecx
 b52:	89 0a                	mov    %ecx,(%edx)
 b54:	eb b9                	jmp    b0f <malloc+0x9f>
